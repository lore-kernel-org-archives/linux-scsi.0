From: Catalin Muresan <catalin.muresan@astral.ro>
Subject: Re: Apple Xserve RAID and qlogic ISP2312 (qla2300)
Date: Fri, 29 Oct 2004 12:01:09 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041029090109.GG6671@astral.ro>
References: <20041027233321.GA842@astral.ro> <20041028143734.GA16358@beaverton.ibm.com> <20041028153522.GC1915@astral.ro> <20041028164210.GA16905@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dummy.cluj.astral.ro ([193.230.240.25]:33692 "EHLO
	cnn.astral.ro") by vger.kernel.org with ESMTP id S263171AbUJ2JHR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Oct 2004 05:07:17 -0400
Content-Disposition: inline
In-Reply-To: <20041028164210.GA16905@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi@vger.kernel.org, bogdan.luca@astral.ro

On Thu, Oct 28, 2004 at 09:42:10AM -0700, Patrick Mansfield wrote:
 > What tricks and ugly patch? I haven't tried boot via qlogic on an HS20.

	trick: echo "scsi add-single-device 0 0 0 5" > /proc/scsi/scsi
	ugly patch, only to help me get past this issue:

--- linux-2.6.9-orig/drivers/scsi/scsi_scan.c	2004-10-19 00:54:55.000000000 +0300
+++ linux-2.6.9/drivers/scsi/scsi_scan.c	2004-10-28 14:53:28.355982680 +0300
@@ -1199,7 +1199,7 @@
 			 */
 			scsi_sequential_lun_scan(shost, channel, id, bflags,
 				       	res, sdev->scsi_level, rescan);
-	} else if (res == SCSI_SCAN_TARGET_PRESENT) {
+	} else if (res == SCSI_SCAN_TARGET_PRESENT || res == SCSI_SCAN_NO_RESPONSE) {
 		/*
 		 * There's a target here, but lun 0 is offline so we
 		 * can't use the report_lun scan.  Fall back to a



 > 
 > -- Patrick Mansfield

-- 
 Catalin Muresan
 ASTRAL Internet & Data
 Technology Manager
