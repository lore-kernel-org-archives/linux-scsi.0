Return-Path: <SRS0=YGqw=XV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24EE3C4360C
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 23:57:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEC53206BF
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 23:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbfIZX5S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Sep 2019 19:57:18 -0400
Received: from netrider.rowland.org ([192.131.102.5]:51097 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1729009AbfIZX5R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Sep 2019 19:57:17 -0400
Received: (qmail 26841 invoked by uid 500); 26 Sep 2019 19:57:16 -0400
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 26 Sep 2019 19:57:16 -0400
Date:   Thu, 26 Sep 2019 19:57:16 -0400 (EDT)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To:     Damien Le Moal <damien.lemoal@wdc.com>
cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-usb@vger.kernel.org>,
        <usb-storage@lists.one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH 0/2] Fix SCSI & USB Storage CHECK CONDITION handling
In-Reply-To: <20190926220844.26631-1-damien.lemoal@wdc.com>
Message-ID: <Pine.LNX.4.44L0.1909261943230.24988-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 27 Sep 2019, Damien Le Moal wrote:

> If a non-passthrough command is terminated with a CHECK CONDITION, the
> scsi error recovery code reuses the failed command scsi_cmnd structure
> to process error recovery request sense. To preserve information
> regarding the failed command, the functions scsi_eh_prep_cmnd() and
> scsi_eh_restore_cmnd() respectively save and restore the original
> command information. However, the resid field of the failed command
> request structure is not preserved and reused for the request sense
> handling, leading to the original command having an incorrect resid
> when:
> A) The command is not retried and terminated with an error
> B) The command completes after retry and the underlying LLD does not set
>    resid for a fully completed command (resid=0)
> 
> The first patch of this series addresses case (A) above by adding resid
> as part of the command information saved using struct scsi_eh_save.

Good catch.

> Case B can be observed with a WD My Book USB disks when a read or write
> command is sent to the disk while the disk is in deep sleep mode
> (spun down) due to a long period of inactivity (~30min).
> In such case, the following command sequence happen:
> 1) The read or write command is terminated after a few seconds with
>    CHECK CONDITION and an asc/ascq of 04/01 (LOGICAL UNIT IS IN PROCESS
>    OF BECOMING READY)
> 2) In response to this failure, the USB mass storage driver triggers
>    autosense processing, reusing the command descriptor to issue a
>    request sense command with a 96B sense buffer size. The reply
>    to this command gives a NOT READY / LOGICAL UNIT IS IN PROCESS
>    OF BECOMING READY sense of 18B, resulting in a resid of 78B.
> 3) The original command is retried and failed again, with step 2
>    repeated, until the drive spins up and becomes ready.
> 4) When the original command completes after the drive has become ready,
>    the request sense command resid of 78B is seen by the scsi disk
>    driver sd_done() function and wrongly generates a warning about the
>    unaligned value reported.

But with the 1/1 patch in place, 4 won't happen any more, right?  
sd_done() will see the resid from the successful read or write.

> This problem is fixed in patch 2 by always setting a command resid to 0
> when there is no residual in usb_stor_Bulk_transport(). Note that
> usb_stor_CB_transport() does not need changes since usb_stor_bulk_srb()
> always sets the resid for a completed command, regardless of the
> residual value.

Exactly the same reasoning shows that usb_stor_Bulk_transport() also
does not need changes, doesn't it?  Which means that patch 2/2 is 
unnecessary.

Alan Stern

PS: The correct term is "residue", not "residual".  I know that the 
code sometimes uses the wrong word.

