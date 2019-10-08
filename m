Return-Path: <SRS0=0ZI3=YB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C2CC4360C
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Oct 2019 15:58:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DB1B206C0
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Oct 2019 15:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbfJHP6z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Oct 2019 11:58:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50450 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbfJHP6z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Oct 2019 11:58:55 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D9A7130860B9;
        Tue,  8 Oct 2019 15:58:54 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18C011001DE1;
        Tue,  8 Oct 2019 15:58:54 +0000 (UTC)
Message-ID: <279be0eb137c93f3d4010935cfa2922cabab8548.camel@redhat.com>
Subject: Re: [PATCH] scsi_dh_alua: handle RTPG sense code correctly during
 state transitions
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Martin Wilck <martin.wilck@suse.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Date:   Tue, 08 Oct 2019 11:58:53 -0400
In-Reply-To: <220f6ffe-1657-f95f-c948-219b45f9496f@suse.de>
References: <20191007135701.32389-1-hare@suse.de>
         <4ff5beeae5092d313d0e90a83f04a222400180f1.camel@redhat.com>
         <220f6ffe-1657-f95f-c948-219b45f9496f@suse.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Tue, 08 Oct 2019 15:58:54 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2019-10-08 at 08:21 +0200, Hannes Reinecke wrote:
> On 10/7/19 10:45 PM, Ewan D. Milne wrote:
> > 
> > The patch itself looks OK, but I was wondering about a couple of things:
> > 
> >   - There are other places in scsi_dh_alua where the ASC/ASCQ 04 0A is checked
> >     and we retry, I understand that this is a particular case you are solving
> >     but is the changing of the state to -> transitioning (because that's what
> >     the device said the state was) applicable in those other cases?
> 
> No. The original code was built around the assumption that RTPG would
> return the status of the device; consequently we would have to retry
> RTPG until we get a final status. But as mentioned, there are arrays
> which cannot return RTPG data during transitioning, so the code would
> never be able to detect a transitioning state.
> With this patch we set the state directly once the said sense code is
> received.
> But this applies _only_ to the RTPG command, as this is required to move
> the state machine along.
> None of the other commands are affected.
> 
> >   - The code originally seems to have been under the assumption that the
> >     transitioning state was a transient event, so the retry would pick up
> >     the eventual state.  Now, some storage arrays spend a long time in the
> >     transitioning state, but if we don't send another command are we going to
> >     get the sense (or the UA) that triggers entry to the eventual ALUA state?
> > 
> 
> Note, there are two types of retries.
> The one is the 'normal' command retry, where we resend a command a given
> number of times to retrieve the final status.
> This is precisely the error which caused this patch.
> 
> And then there is a scheduled retry; here we essentially poll the array
> with sending RTPG in regular intervals until the 'transitioning' state
> is gone. (Check for 'alua_rtpg()' and the handling of the SCSI_DH_RETRY
> return value). With the patch we continue to trigger that second type of
> retries, which will eventually clear the transitioning state.
> 
> Cheers,
> 
> Hannes

Thanks for the explanation.  The patch looks good.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

