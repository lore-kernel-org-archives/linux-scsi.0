Return-Path: <SRS0=ejtk=BS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23874C433DF
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Aug 2020 15:05:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CFAC20748
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Aug 2020 15:05:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgHHPFo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Aug 2020 11:05:44 -0400
Received: from netrider.rowland.org ([192.131.102.5]:45107 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726238AbgHHPFo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Aug 2020 11:05:44 -0400
Received: (qmail 257140 invoked by uid 1000); 8 Aug 2020 11:05:42 -0400
Date:   Sat, 8 Aug 2020 11:05:42 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
Message-ID: <20200808150542.GB256751@rowland.harvard.edu>
References: <1596037482.4356.37.camel@HansenPartnership.com>
 <A1653792-B7E5-46A9-835B-7FA85FCD0378@puri.sm>
 <20200729182515.GB1580638@rowland.harvard.edu>
 <1596047349.4356.84.camel@HansenPartnership.com>
 <d3fe36a9-b785-a5c4-c90d-b8fa10f4272f@puri.sm>
 <20200730151030.GB6332@rowland.harvard.edu>
 <9b80ca7c-39f8-e52d-2535-8b0baf93c7d1@puri.sm>
 <425990b3-4b0b-4dcf-24dc-4e7e60d5869d@puri.sm>
 <20200807143002.GE226516@rowland.harvard.edu>
 <b0abab28-880e-4b88-eb3c-9ffd927d1ed9@puri.sm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0abab28-880e-4b88-eb3c-9ffd927d1ed9@puri.sm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Aug 08, 2020 at 08:59:09AM +0200, Martin Kepplinger wrote:
> On 07.08.20 16:30, Alan Stern wrote:
> > On Fri, Aug 07, 2020 at 11:51:21AM +0200, Martin Kepplinger wrote:
> >> it's really strange: below is the change I'm trying. Of course that's
> >> only for testing the functionality, nothing how a patch could look like.
> >>
> >> While I remember it had worked, now (weirdly since I tried that mounting
> >> via fstab) it doesn't anymore!
> >>
> >> What I understand (not much): I handle the error with "retry" via the
> >> new flag, but scsi_decide_disposition() returns SUCCESS because of "no
> >> more retries"; but it's the first and only time it's called.
> > 
> > Are you saying that scmd->allowed is set to 0?  Or is scsi_notry_cmd() 
> > returning a nonzero value?  Whichever is true, why does it happen that 
> > way?
> 
> scsi_notry_cmd() is returning 1. (it's retry 1 of 5 allowed).
> 
> why is it returning 1? REQ_FAILFAST_DEV is set. It's DID_OK, then "if
> (status_byte(scmd->result) != CHECK_CONDITION)" appearently is not true,
> then at the end it returns 1 because of REQ_FAILFAST_DEV.
> 
> that seems to come from the block layer. why and when? could I change
> that so that the scsi error handling stays in control?

The only place I see where that flag might get set is in 
blk_mq_bio_to_request() in block/blk-mq.c, which does:

	if (bio->bi_opf & REQ_RAHEAD)
		rq->cmd_flags |= REQ_FAILFAST_MASK;

So apparently read-ahead reads are supposed to fail fast (i.e., without 
retries), presumably because they are optional after all.

> > What is the failing command?  Is it a READ(10)?
> 
> Not sure how I'd answer that, but here's the test to trigger the error:
> 
> mount /dev/sda1 /mnt
> cd /mnt
> ls
> cp file ~/ (if ls "works" and doesn't yet trigger the error)
> 
> and that's the (familiar looking) logs when doing so. again: despite the
> mentioned workaround in scsi_error and the new expected_media_change
> flag *is* set and gets cleared, as it should be. REQ_FAILFAST_DEV seems
> to override what I want to do is scsi_error:
> 
> [   55.557629] sd 0:0:0:0: [sda] tag#0 UNKNOWN(0x2003) Result:
> hostbyte=0x00 driverbyte=0x08 cmd_age=0s
> [   55.557639] sd 0:0:0:0: [sda] tag#0 Sense Key : 0x6 [current]
> [   55.557646] sd 0:0:0:0: [sda] tag#0 ASC=0x28 ASCQ=0x0
> [   55.557657] sd 0:0:0:0: [sda] tag#0 CDB: opcode=0x28 28 00 00 08 fc
> e0 00 00 01 00

Yes, 0x28 is READ(10).  Likely this is a read-ahead request, although I 
don't know how we can tell for sure.

> [   55.557666] blk_update_request: I/O error, dev sda, sector 589024 op
> 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
> [   55.568899] sd 0:0:0:0: [sda] tag#0 device offline or changed
> [   55.574691] blk_update_request: I/O error, dev sda, sector 589025 op
> 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
> [   55.585756] sd 0:0:0:0: [sda] tag#0 device offline or changed
> [   55.591562] blk_update_request: I/O error, dev sda, sector 589026 op
> 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
> [   55.602274] sd 0:0:0:0: [sda] tag#0 device offline or changed
> (... goes on with the same)

Is such a drastic response really appropriate for the failure of a 
read-ahead request?  It seems like a more logical response would be to 
let the request fail but keep the device online.

Of course, that would only solve part of your problem -- your log would 
still get filled with those "I/O error" messages even though they 
wouldn't be fatal.  Probably a better approach would be to make the new 
expecting_media_change flag override scsi_no_retry_cmd().

But this is not my area of expertise.  Maybe someone else will have more 
to say.

Alan Stern
