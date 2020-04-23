Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93AF1C55191
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 08:02:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7401020736
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 08:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgDWIC0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Apr 2020 04:02:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:44386 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbgDWIC0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Apr 2020 04:02:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5EA53AF93;
        Thu, 23 Apr 2020 08:02:23 +0000 (UTC)
Date:   Thu, 23 Apr 2020 10:02:23 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        maier@linux.ibm.com, bvanassche@acm.org, herbszt@gmx.de,
        natechancellor@gmail.com, rdunlap@infradead.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v3 12/31] elx: libefc: Remote node state machine
 interfaces
Message-ID: <20200423080223.6muuun5ce2pumooe@beryllium.lan>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-13-jsmart2021@gmail.com>
 <1f711306-0c3d-ab28-6984-73299efe6e5f@suse.de>
 <3f7d5a66-f366-70d4-3730-a75fe2e1a3b8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f7d5a66-f366-70d4-3730-a75fe2e1a3b8@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,

On Wed, Apr 22, 2020 at 06:35:24PM -0700, James Smart wrote:
> On 4/15/2020 8:51 AM, Hannes Reinecke wrote:
> > Relating to my previous comments: Can you elaborate about the lifetime
> > rules to the node? It looks as if any access to the node is being
> > guarded by the main efc->lock.
> > Which, taken to extremes, would meant that one has to hold that lock for
> > _any_ access to the node; that would include I/O processing etc, too.
> > I can't really see how that would scale to the IOPS you are pursuing, so
> > clearly that will not happen.
> > So how _do_ you ensure the validity of a node if the lock is not held?
> > 
> > Cheers,
> > 
> > Hannes
> 
> This lock is defined for single EQ/RQ. For multi EQ/RQ which we will add in
> future, will have more granular locks and performance improvements.
> All the State Machine Events are triggered from the EQ processing thread
> except vport creation and deletion.
> 
> Locking:
>   Global lock per efc port "efc->lock"
> 
> Domain:
>     efc_domain_cb --> (All the events are executed under efc lock)
> 
>     Async link up notification(EFC_HW_DOMAIN_FOUND)
>          Alloc Domain, Start discovery
>          Alloc Sport
>     Async link down notification (EFC_HW_DOMAIN_LOST)
>           Hold frames. (New frames will be moved to pending)
>           Post Sport Shutdown.
>           Post All Nodes Shutdown.
> 
> Sport:
>     efc_lport_cb --> (All the events are executed under efc lock)
> 
>       HW sport registration (Mbox command responses) to complete sport
> allocation.
> 
> Vport :
>     efc_sport_vport_new() --> New Vport
> 
>      efc_vport_sport_alloc() (Protected by efc lock)
>      Alloc Sport, and start Sport SM
> 
>    efc_sport_vport_del()  --> Delete Vport
> 
>      Post shutdown event to the Sport. (Protected by efc lock)
> 
> Node:
>    efc_remote_node_cb() --> (All the events are executed under efc lock)
> 
>        HW node registration (Mbox command responses) to complete node
> allocation.
> 
> Node lifeCycle:
>    efc_domain_dispatch_frame:-
> 
>     EFC lock held
>     efc_node_find() IF not found, Create one.
>     when PLOGI is received, Register with hardware
>     Upon PRLI completion, setup a new session with LIO.
> 
>    IO path:
> 
>      Find sport and node under EFC lock.
>      If node can process commands, start IO processing.
>      Each IO is added to the node->active_ios.
> 
>   Node deletion: (RSCN notification or LOGO received ..)
> 
>      EFC lock held
>      Disable receiving fcp commands. (node->fcp_enabled)
>      Disable IO allocation for this node.
>      Remove LIO session.
>      Deregister node with HW
>      Waits for all active_ios to be completed/freed.
>      Purge pending IOs.
>      Free the Node.


Thanks a lot for this. IMO, this should be added as documentation.

> In IO path, EFC lock is acquired to find the sport and node, release the EFC
> lock and continue with IO allocation and processing. Note: There is still an
> unsafe area where we check for 'node->hold_frames" without the lock.

Is this is the fast path? Would RCU help to avoid taking the lock at all?
The usage pattern sounds like it would be a candidate for RCU.

> Node is
> assumed to be kept alive until all the IOs under the node are freed.  Adding
> the refcounting will remove this assumption.

Thanks,
Daniel
