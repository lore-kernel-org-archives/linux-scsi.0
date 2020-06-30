Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F82C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 13:38:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 597F4206EB
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 13:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733066AbgF3NiU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 09:38:20 -0400
Received: from netrider.rowland.org ([192.131.102.5]:39199 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726033AbgF3NiR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 09:38:17 -0400
Received: (qmail 448451 invoked by uid 1000); 30 Jun 2020 09:38:16 -0400
Date:   Tue, 30 Jun 2020 09:38:16 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     Bart Van Assche <bvanassche@acm.org>, jejb@linux.ibm.com,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
Message-ID: <20200630133816.GA447566@rowland.harvard.edu>
References: <20200623111018.31954-1-martin.kepplinger@puri.sm>
 <ed9ae198-4c68-f82b-04fc-2299ab16df96@acm.org>
 <eccacce9-393c-ca5d-e3b3-09961340e0db@puri.sm>
 <1379e21d-c51a-3710-e185-c2d7a9681fb7@acm.org>
 <20200626154441.GA296771@rowland.harvard.edu>
 <c19f1938-ae47-2357-669d-5b4021aec154@puri.sm>
 <20200629161536.GA405175@rowland.harvard.edu>
 <823057f0-95cf-bfcf-c39f-ca5d7abe2372@puri.sm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <823057f0-95cf-bfcf-c39f-ca5d7abe2372@puri.sm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 30, 2020 at 05:33:25AM +0200, Martin Kepplinger wrote:
> > Martin, does this fix the problem?
> > 
> 
> not quite: mounting works and resuming itself indeed happens now when
> copying a file, but the I/O itself doesn't, but says "device offline or
> changed":
> 
> [  167.167615] sd 0:0:0:0: [sda] tag#0 UNKNOWN(0x2003) Result:
> hostbyte=0x00 driverbyte=0x08 cmd_age=0s
> [  167.167630] sd 0:0:0:0: [sda] tag#0 Sense Key : 0x6 [current]
> [  167.167638] sd 0:0:0:0: [sda] tag#0 ASC=0x28 ASCQ=0x0

That code stands for "Not-ready to ready transition".  It isn't really an 
error, just a notification.  The command should have been retried.

> [  167.167648] sd 0:0:0:0: [sda] tag#0 CDB: opcode=0x28 28 00 00 00 24
> c2 00 00 01 00
> [  167.167658] blk_update_request: I/O error, dev sda, sector 9410 op
> 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
> [  167.178327] FAT-fs (sda1): FAT read failed (blocknr 1218)

And it should not have failed.  Martin or James, any ideas about this?

> [  167.183895] sd 0:0:0:0: [sda] tag#0 device offline or changed
> [  167.189695] blk_update_request: I/O error, dev sda, sector 5101888 op
> 0x0:(READ) flags 0x80700 phys_seg 8 prio class 0
> [  167.200510] sd 0:0:0:0: [sda] tag#0 device offline or changed
> 
> 
> and a later try to copy a file only yields (mostly my own debug prints):
> 
> 
> [  371.110798] blk_queue_enter: wait_event: pm=0
> [  371.300666] scsi_runtime_resume
> [  371.303834] scsi_runtime_resume
> [  371.307007] scsi_runtime_resume
> [  371.310213] sd 0:0:0:0: [sda] tag#0 device offline or changed
> [  371.316011] blk_update_request: I/O error, dev sda, sector 5101888 op
> 0x0:(READ) flags 0x0 phys_seg 1 prio class 0

No way to tell from the log what caused this error.

> [  372.560690] scsi_runtime_suspend
> [  372.563968] scsi_runtime_suspend
> [  372.567237] scsi_runtime_suspend
> 
> thanks Alan for taking the time and trying to fix this! you're close.
> what is missing?

At this point I don't know.

Alan Stern
