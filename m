From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 2/3] SCSI: Support Type C RAID controller
Date: Sun, 20 Jun 2010 09:18:18 -0500
Message-ID: <1277043498.5242.12.camel@mulgrave.site>
References: <2A012083FB99432B9F10199BDD454867@areca4e4f859d4>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:36861 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609Ab0FTOS3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jun 2010 10:18:29 -0400
In-Reply-To: <2A012083FB99432B9F10199BDD454867@areca4e4f859d4>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nick.cheng@areca.com.tw
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 2010-06-18 at 15:39 +0800, Nick Cheng wrote:
> 1. To support Type C RAID controller, ACB_ADAPTER_TYPE_C, i.e. PCI device
> ID: 0x1880.

OK, got patch 1/3 successfully, but after I apply it, this one doesn't
apply:

jejb@mulgrave:~/git/scsi-misc-2.6> patch -p2 < ~/tmp.diff
patching file drivers/scsi/arcmsr/arcmsr.h
Hunk #9 succeeded at 599 with fuzz 2.
Hunk #10 FAILED at 619.

This rejection, for instance is because there's an indent before the
#else and #endif in the patch which isn't in the file ... that lack of
indent dates back to the time the driver was first imported, so you
can't be patching from the current kernel to this.

1 out of 10 hunks FAILED -- saving rejects to file
drivers/scsi/arcmsr/arcmsr.h.rej
patching file drivers/scsi/arcmsr/arcmsr_hba.c
Hunk #3 FAILED at 121.
Hunk #13 FAILED at 448.
Hunk #14 FAILED at 475.
Hunk #15 FAILED at 502.
Hunk #16 succeeded at 644 (offset 1 line).
Hunk #17 succeeded at 780 (offset 1 line).
Hunk #18 FAILED at 794.
Hunk #19 succeeded at 811 (offset 1 line).
Hunk #20 succeeded at 844 (offset 1 line).
Hunk #21 succeeded at 856 with fuzz 1 (offset 1 line).
Hunk #22 succeeded at 880 (offset 1 line).
Hunk #23 succeeded at 923 (offset 1 line).
Hunk #24 succeeded at 940 (offset 1 line).
Hunk #25 succeeded at 972 (offset 1 line).
Hunk #26 succeeded at 986 (offset 1 line).
Hunk #27 succeeded at 1009 (offset 1 line).
Hunk #28 succeeded at 1036 (offset 1 line).
Hunk #29 succeeded at 1047 (offset 1 line).
Hunk #30 succeeded at 1088 (offset 1 line).
Hunk #31 succeeded at 1119 (offset 1 line).
Hunk #32 succeeded at 1180 (offset 1 line).
Hunk #33 FAILED at 1197.
Hunk #34 FAILED at 1236.
Hunk #35 succeeded at 1263 (offset 1 line).
Hunk #36 succeeded at 1278 (offset 1 line).
Hunk #37 succeeded at 1289 (offset 1 line).
Hunk #38 succeeded at 1310 (offset 1 line).
Hunk #39 succeeded at 1323 (offset 1 line).
Hunk #40 succeeded at 1355 (offset 1 line).
Hunk #41 succeeded at 1380 (offset 1 line).
Hunk #42 succeeded at 1409 (offset 1 line).
Hunk #43 succeeded at 1438 (offset 1 line).
Hunk #44 succeeded at 1463 (offset 1 line).
Hunk #45 succeeded at 1552 (offset 1 line).
Hunk #46 succeeded at 1596 (offset 1 line).
Hunk #47 succeeded at 1665 (offset 2 lines).
Hunk #48 succeeded at 1734 with fuzz 1 (offset 2 lines).
Hunk #49 succeeded at 1778 (offset 3 lines).
Hunk #50 succeeded at 2194 (offset 3 lines).
Hunk #51 succeeded at 2220 (offset 3 lines).
Hunk #52 FAILED at 2294.
Hunk #53 succeeded at 2344 (offset 3 lines).
Hunk #54 succeeded at 2421 (offset 3 lines).
Hunk #55 succeeded at 2432 (offset 3 lines).
Hunk #56 FAILED at 2459.
Hunk #57 FAILED at 2474.
Hunk #58 FAILED at 2522.
Hunk #59 succeeded at 2546 (offset 3 lines).
Hunk #60 succeeded at 2567 (offset 3 lines).
Hunk #61 succeeded at 2585 (offset 3 lines).
Hunk #62 succeeded at 2606 (offset 3 lines).
Hunk #63 succeeded at 2625 (offset 3 lines).
Hunk #64 succeeded at 2634 (offset 3 lines).
Hunk #65 succeeded at 2681 (offset 3 lines).
Hunk #66 succeeded at 2729 (offset 3 lines).
Hunk #67 succeeded at 2762 (offset 3 lines).
Hunk #68 succeeded at 2773 (offset 3 lines).
Hunk #69 succeeded at 2784 (offset 3 lines).
Hunk #70 succeeded at 2811 (offset 3 lines).
Hunk #71 succeeded at 2838 (offset 3 lines).
Hunk #72 succeeded at 2858 (offset 3 lines).
Hunk #73 FAILED at 2870.
Hunk #74 FAILED at 2892.
Hunk #75 FAILED at 2967.
Hunk #76 FAILED at 2992.
Hunk #77 succeeded at 3028 (offset 4 lines).
Hunk #78 succeeded at 3052 with fuzz 1 (offset 4 lines).
Hunk #79 FAILED at 3070.
Hunk #80 succeeded at 3083 (offset 4 lines).
Hunk #81 succeeded at 3151 (offset 4 lines).
16 out of 81 hunks FAILED -- saving rejects to file
drivers/scsi/arcmsr/arcmsr_hba.c.rej

Can you redo 2/3 and 3/3 so they apply in sequence on 2.6.35-rc3 with
1/3 already applied?

Thanks,

James


