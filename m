From: Anton Blanchard <anton@samba.org>
Subject: Re: 2.5.51 + fastT FC disk
Date: Tue, 6 Sep 2005 18:08:14 +1000
Message-ID: <20050906080814.GT6945@krispykreme>
References: <20021212132439.GE6278@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:23189 "EHLO ozlabs.org")
	by vger.kernel.org with ESMTP id S932444AbVIFILX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2005 04:11:23 -0400
Content-Disposition: inline
In-Reply-To: <20021212132439.GE6278@krispykreme>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


On Fri, Dec 13, 2002 at 12:24:39AM +1100, Anton Blanchard wrote:

> We tested 2.5.51 on a ppc64 box, qlogic 2312 and a fastt700 array. I
> had CONFIG_SCSI_REPORT_LUNS and unfortunately it thought the management
> LUN was a disk:
> 
>   Vendor: IBM       Model: Universal Xport   Rev: 0520
>   Type:   Direct-Access                      ANSI SCSI revision: 03
> 
> ...
> 
> SCSI device sdaj: drive cache: write through
> SCSI device sdaj: 40960 512-byte hdwr sectors (21 MB)
>  sdaj: unknown partition table
> Attached scsi disk sdaj at scsi2, channel 0, id 0, lun 31
> 
> ...
> 
> end_request: I/O error, dev sdaj, sector 0

Three years later...

It looks like SGI use the same FC vendor and they already have a
workaround for this issue. The following patch adds the IBM version of
it.

Signed-off-by: Anton Blanchard <anton@samba.org>

Index: linux-2.6.git-work/drivers/scsi/scsi_devinfo.c
===================================================================
--- linux-2.6.git-work.orig/drivers/scsi/scsi_devinfo.c	2005-05-23 17:42:37.000000000 +1000
+++ linux-2.6.git-work/drivers/scsi/scsi_devinfo.c	2005-05-23 18:21:00.000000000 +1000
@@ -191,6 +191,7 @@
 	{"SGI", "RAID5", "*", BLIST_SPARSELUN},
 	{"SGI", "TP9100", "*", BLIST_REPORTLUN2},
 	{"SGI", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
+	{"IBM", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"SMSC", "USB 2 HS-CF", NULL, BLIST_SPARSELUN | BLIST_INQUIRY_36},
 	{"SONY", "CD-ROM CDU-8001", NULL, BLIST_BORKEN},
 	{"SONY", "TSL", NULL, BLIST_FORCELUN},		/* DDS3 & DDS4 autoloaders */
