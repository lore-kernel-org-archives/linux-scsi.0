From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: PATCH 2/4 ] SCSI: Support 1024 scatter-gather list entries and
 improve AP while FW trapped and behaviors of EHs
Date: Tue, 25 May 2010 10:35:29 -0500
Message-ID: <1274801729.5300.44.camel@mulgrave.site>
References: <5763B1DC6C74425FAFED2732C136C5DB@areca4e4f859d4>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:34987 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756283Ab0EYPfi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 May 2010 11:35:38 -0400
In-Reply-To: <5763B1DC6C74425FAFED2732C136C5DB@areca4e4f859d4>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nick.cheng@areca.com.tw
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 11:24 +0800, Nick Cheng wrote:
> 1. To support 4M/1024 scatter-gather list entry, reorganize struct
> ARCMSR_CDB and struct CommandControlBlock
> 2. To modify arcmsr_probe
> 3. In order to help fix F/W issue, add the driver mode for type B card
> 4. To improve AP's behavior while F/W resets
> 5. To unify struct MessageUnit_B's members' naming in all OS drivers'
> 6. To improve error handlers, arcmsr_bus_reset(), arcmsr_abort()
> 7. To fix the arcmsr_queue_command() in bus reset stage, just let the
> commands pass down to FW, don't block
> Signed-off-by: Nick Cheng< nick.cheng@areca.com.tw >

OK, got patch 1.  This one now doesn't apply:

jejb@mulgrave:~/git/scsi-misc-2.6/drivers/scsi/arcmsr> patch -p4  <
~/tmp.diff
patching file arcmsr.h
Hunk #12 FAILED at 441.
1 out of 13 hunks FAILED -- saving rejects to file arcmsr.h.rej
patching file arcmsr_hba.c
Hunk #1 succeeded at 71 (offset 1 line).
Hunk #2 succeeded at 101 (offset 1 line).
Hunk #3 FAILED at 127.
Hunk #4 succeeded at 155 (offset 1 line).
Hunk #5 succeeded at 167 (offset 1 line).
Hunk #6 succeeded at 269 (offset 1 line).
Hunk #7 succeeded at 280 (offset 1 line).
Hunk #8 succeeded at 532 (offset 1 line).
Hunk #9 succeeded at 568 (offset 1 line).
Hunk #10 succeeded at 576 (offset 1 line).
Hunk #11 succeeded at 590 (offset 1 line).
Hunk #12 succeeded at 697 (offset 1 line).
Hunk #13 succeeded at 723 (offset 1 line).
Hunk #14 succeeded at 791 (offset 1 line).
Hunk #15 succeeded at 810 (offset 1 line).
Hunk #16 succeeded at 825 (offset 1 line).
Hunk #17 succeeded at 847 (offset 1 line).
Hunk #18 succeeded at 857 (offset 1 line).
Hunk #19 succeeded at 934 (offset 1 line).
Hunk #20 succeeded at 960 (offset 1 line).
Hunk #21 succeeded at 964 (offset 1 line).
Hunk #22 succeeded at 1022 (offset 1 line).
Hunk #23 succeeded at 1035 (offset 1 line).
Hunk #24 succeeded at 1047 (offset 1 line).
Hunk #25 succeeded at 1079 (offset 1 line).
Hunk #26 succeeded at 1091 (offset 1 line).
Hunk #27 succeeded at 1101 (offset 1 line).
Hunk #28 succeeded at 1116 (offset 1 line).
Hunk #29 succeeded at 1148 (offset 1 line).
Hunk #30 succeeded at 1176 (offset 1 line).
Hunk #31 succeeded at 1197 (offset 1 line).
Hunk #32 succeeded at 1222 (offset 1 line).
Hunk #33 succeeded at 1242 (offset 1 line).
Hunk #34 succeeded at 1263 (offset 1 line).
Hunk #35 succeeded at 1398 (offset 1 line).
Hunk #36 FAILED at 1429.
Hunk #37 succeeded at 1559 (offset 2 lines).
Hunk #38 succeeded at 1590 (offset 2 lines).
Hunk #39 succeeded at 1609 (offset 2 lines).
Hunk #40 succeeded at 1668 (offset 2 lines).
Hunk #41 succeeded at 1676 (offset 2 lines).
Hunk #42 succeeded at 1706 (offset 2 lines).
Hunk #43 succeeded at 1728 (offset 2 lines).
Hunk #44 succeeded at 1791 (offset 2 lines).
Hunk #45 FAILED at 1873.
Hunk #46 succeeded at 1951 (offset 2 lines).
Hunk #47 FAILED at 1964.
Hunk #48 FAILED at 1991.
Hunk #49 FAILED at 2034.
Hunk #50 FAILED at 2052.
Hunk #51 succeeded at 2101 (offset 2 lines).
Hunk #52 succeeded at 2124 (offset 2 lines).
Hunk #53 succeeded at 2134 (offset 2 lines).
Hunk #54 succeeded at 2175 (offset 2 lines).
Hunk #55 succeeded at 2197 (offset 2 lines).
Hunk #56 succeeded at 2234 (offset 2 lines).
Hunk #57 succeeded at 2243 (offset 2 lines).
Hunk #58 succeeded at 2272 (offset 2 lines).
Hunk #59 succeeded at 2291 (offset 2 lines).
Hunk #60 succeeded at 2322 (offset 2 lines).
Hunk #61 succeeded at 2333 (offset 2 lines).
Hunk #62 succeeded at 2353 (offset 2 lines).
Hunk #63 succeeded at 2400 (offset 2 lines).
Hunk #64 succeeded at 2436 (offset 2 lines).
Hunk #65 succeeded at 2452 (offset 2 lines).
Hunk #66 succeeded at 2467 (offset 2 lines).
Hunk #67 succeeded at 2492 (offset 2 lines).
Hunk #68 succeeded at 2519 (offset 2 lines).
Hunk #69 succeeded at 2541 (offset 2 lines).
Hunk #70 succeeded at 2561 (offset 2 lines).
Hunk #71 FAILED at 2610.
Hunk #72 succeeded at 2651 (offset 2 lines).
Hunk #73 succeeded at 2665 (offset 2 lines).
8 out of 73 hunks FAILED -- saving rejects to file arcmsr_hba.c.rej


Incidentally, I have to move into the directory and do a -p4 because
your path prefix isn't what's in the kernel:

> diff -Naurp --ignore-blank-lines --ignore-all-space --ignore-space-change linux-2.6/drivers/scsi/arcmsr.1.20.00.15-81103/arcmsr.h linux-2.6/drivers/scsi/arcmsr.1.20.00.15-91209/arcmsr.h
> --- linux-2.6/drivers/scsi/arcmsr.1.20.00.15-81103/arcmsr.h     2010-05-03 11:35:24.000000000 +0800
> +++ linux-2.6/drivers/scsi/arcmsr.1.20.00.15-91209/arcmsr.h     2010-05-03 14:32:42.000000000 +0800

The arcmsr.h problem looks to be tab related:  There's an extra tab
between char and firm_version[20] in the version of arcmsr.h you took as
a base.

Even with a white space fuzzing apply, I still get two rejections.

James


