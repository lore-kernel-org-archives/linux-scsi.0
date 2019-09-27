Return-Path: <SRS0=gVs6=XW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39F6BC4360C
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 16:34:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EB9920872
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 16:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfI0Qe1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Sep 2019 12:34:27 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56148 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727447AbfI0Qe1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Sep 2019 12:34:27 -0400
Received: (qmail 4664 invoked by uid 2102); 27 Sep 2019 12:34:26 -0400
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 27 Sep 2019 12:34:26 -0400
Date:   Fri, 27 Sep 2019 12:34:26 -0400 (EDT)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "usb-storage@lists.one-eyed-alien.net" 
        <usb-storage@lists.one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH 0/2] Fix SCSI & USB Storage CHECK CONDITION handling
In-Reply-To: <BYAPR04MB5816017131A10A32CC54D756E7810@BYAPR04MB5816.namprd04.prod.outlook.com>
Message-ID: <Pine.LNX.4.44L0.1909271218200.2054-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 27 Sep 2019, Damien Le Moal wrote:

> On 2019/09/26 16:57, Alan Stern wrote:
> > On Fri, 27 Sep 2019, Damien Le Moal wrote:
> > 
> >> If a non-passthrough command is terminated with a CHECK CONDITION, the
> >> scsi error recovery code reuses the failed command scsi_cmnd structure
> >> to process error recovery request sense. To preserve information
> >> regarding the failed command, the functions scsi_eh_prep_cmnd() and
> >> scsi_eh_restore_cmnd() respectively save and restore the original
> >> command information. However, the resid field of the failed command
> >> request structure is not preserved and reused for the request sense
> >> handling, leading to the original command having an incorrect resid
> >> when:
> >> A) The command is not retried and terminated with an error
> >> B) The command completes after retry and the underlying LLD does not set
> >>    resid for a fully completed command (resid=0)
> >>
> >> The first patch of this series addresses case (A) above by adding resid
> >> as part of the command information saved using struct scsi_eh_save.
> > 
> > Good catch.
> > 
> >> Case B can be observed with a WD My Book USB disks when a read or write
> >> command is sent to the disk while the disk is in deep sleep mode
> >> (spun down) due to a long period of inactivity (~30min).
> >> In such case, the following command sequence happen:
> >> 1) The read or write command is terminated after a few seconds with
> >>    CHECK CONDITION and an asc/ascq of 04/01 (LOGICAL UNIT IS IN PROCESS
> >>    OF BECOMING READY)
> >> 2) In response to this failure, the USB mass storage driver triggers
> >>    autosense processing, reusing the command descriptor to issue a
> >>    request sense command with a 96B sense buffer size. The reply
> >>    to this command gives a NOT READY / LOGICAL UNIT IS IN PROCESS
> >>    OF BECOMING READY sense of 18B, resulting in a resid of 78B.
> >> 3) The original command is retried and failed again, with step 2
> >>    repeated, until the drive spins up and becomes ready.
> >> 4) When the original command completes after the drive has become ready,
> >>    the request sense command resid of 78B is seen by the scsi disk
> >>    driver sd_done() function and wrongly generates a warning about the
> >>    unaligned value reported.
> > 
> > But with the 1/1 patch in place, 4 won't happen any more, right?  
> > sd_done() will see the resid from the successful read or write.
> 
> No it will not because the USB driver does not set the residue when the value
> returned for the command is 0, that is, when the command succeeds after the disk
> spins up. E.g., in my test, I used a 4096B read at LBA 0. With patch 1 only, I
> see a residue of 4096 since the command is entirely failed with CHECK CONDITION
> until the drive spins up and becomes ready, at which point the resid becomes 0
> but is not set with scsi_set_resid(). Without patch 1 nor 2, I see a residue of
> 78B which is the residue from the request sense executed between retries of the
> read command.

I don't doubt your results.  But you need to do a better job of 
explaining how the existing code leads to those results.

For example, you said the driver does not set the command's residue 
when the command succeeds.  But in fact, one of the first things 
usb_stor_invoke_transport() does -- before it begins transmitting the 
command -- is

	scsi_set_resid(srb, 0);

So if the command is successful, even if the transport layer routine 
doesn't set the residue explicitly, the value should still be 0.

So if you see the residue not getting set properly, you should explain 
exactly how that happens.

> Patch 2 is needed to make sure that the residue is set to 0 when the command
> fully completes. If there is no failure/request sense/retry dance, resid is
> already 0 (initialized value) so there is no problem. The problem shows up only
> for CHECK CONDITION + retry patterns. Tests confirm this. Only patch 1 does not
> solve the problem.

But the residue gets reset to 0 every time before the command is
retried, doesn't it?

Unless for your device, the driver doesn't run 
usb_stor_invoke_transport().  The only way that can happen is if you 
use one of the modular subdrivers -- in which case the bug lies in that 
subdriver and should be fixed there, not in transport.c.

> >> This problem is fixed in patch 2 by always setting a command resid to 0
> >> when there is no residual in usb_stor_Bulk_transport(). Note that
> >> usb_stor_CB_transport() does not need changes since usb_stor_bulk_srb()
> >> always sets the resid for a completed command, regardless of the
> >> residual value.
> > 
> > Exactly the same reasoning shows that usb_stor_Bulk_transport() also
> > does not need changes, doesn't it?  Which means that patch 2/2 is 
> > unnecessary.
> 
> In usb_stor_Bulk_transport(), since scsi_set_resid() is only called under the
> 
> if (residue && !(us->fflags & US_FL_IGNORE_RESIDUE))
> 
> condition, resid is not set if it is 0.

But usb_stor_Bulk_transport() calls usb_stor_bulk_srb(), which does set
the residue, as you realize:

> Whereas in usb_stor_CB_transport(), through the call to usb_stor_bulk_srb(),
> resid is always set, unconditionally, with:
> 
> scsi_set_resid(srb, scsi_bufflen(srb) - partial);
> 
> where partial is the command length for a fully completed command (the variable
> name is misleading), leading to resid being set to 0 as needed for successful
> commands.
> 
> Please let me know if I missed something. I can reproduce the problem 100% of
> the time, even though it is painful due to the 30min wait between tests to wait
> for the drive going to sleep (if I force a sleep power state, the problem does
> not happen due to power control the drive USB bridge FW, I am guessing, which
> will wake up the disk before the command is sent).

Please investigate a little more closely into what's going wrong and
present more details so that others can understand it too.

Alan Stern

