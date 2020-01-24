Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62070C2D0DB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 10:44:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A3742070A
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 10:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731492AbgAXKoL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 05:44:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:38892 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbgAXKoL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Jan 2020 05:44:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CC4ABB0DA;
        Fri, 24 Jan 2020 10:44:09 +0000 (UTC)
Date:   Fri, 24 Jan 2020 11:44:08 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org,
        Himanshu Madhani <hmadhani@marvell.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Quinn Tran <qutran@marvell.com>, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 2/6] qla2xxx: Simplify the code for aborting SCSI
 commands
Message-ID: <20200124104408.lrapyyu2vkmlx676@beryllium.lan>
References: <20200123042345.23886-1-bvanassche@acm.org>
 <20200123042345.23886-3-bvanassche@acm.org>
 <20200123101730.tqvkhgq42dvmq2tr@beryllium.lan>
 <b110ffaa-aeaa-7454-d64a-cf35124aca7b@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b110ffaa-aeaa-7454-d64a-cf35124aca7b@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On Thu, Jan 23, 2020 at 07:12:04PM -0800, Bart Van Assche wrote:
> >> +/*
> >> + * The caller must ensure that no completion interrupts will happen
> >> + * while this function is in progress.
> >> + */
> > 
> > So could we add something like WARN_ON(irqs_disabled())?
> 
> qla2x00_abort_all_cmds() is typically called after the kernel driver
> discovered that the firmware stopped processing commands. If the
> firmware has stopped processing commands it is safe to call this
> function without disabling interrupts. Even if the caller would disable
> interrupts, that would only disable interrupts on the local CPU but not
> on other CPUs. Additionally, disabling interrupts is not a proper
> solution because if a completion interrupt arrives after a command has
> been aborted that will cause trouble if the command handle has already
> been associated with another command.

Thanks for the explenation. I understood the comment as 'interrupts'
have to be disabled when calling this function.

Thanks,
Daniel
