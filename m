From: Guido Guenther <agx@sigxcpu.org>
Subject: EMC Symmetrix vs. no storage on LUN 0
Date: Thu, 27 Apr 2006 11:13:22 +0200
Message-ID: <20060427091322.GA19126@bogon.ms20.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from honk1.physik.uni-konstanz.de ([134.34.140.224]:60129 "EHLO
	honk1.physik.uni-konstanz.de") by vger.kernel.org with ESMTP
	id S964985AbWD0JVL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Apr 2006 05:21:11 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: frankpiotrowski@web.de

Hi,
we have a rather old EMC Symmetrix which always has a peripheral
qualifier of 001b on LUN0. This has the problem that the
scsi_probe_and_add_lun code bails out to out_free_result: before we
apply the device flags (that we got from scsi_probe_lun just before this
check) to bflagsp. The result is that (without these flags) we stop
scanning and don't see any devices on the EMC. This patch against 2.6.16
ignores this peripheral qualifier for LUN 0 and the devices get detected
properly:

--- linux-2.6.16.7/drivers/scsi/scsi_scan.c.orig	2006-04-17 23:53:25.000000000 +0200
+++ linux-2.6.16.7/drivers/scsi/scsi_scan.c	2006-04-26 20:12:21.000000000 +0200
@@ -853,7 +862,7 @@
 	/*
 	 * result contains valid SCSI INQUIRY data.
 	 */
-	if ((result[0] >> 5) == 3) {
+	if ((result[0] >> 5) == 3 && lun != 0) {
 		/*
 		 * For a Peripheral qualifier 3 (011b), the SCSI
 		 * spec says: The device server is not capable of

Signed-Off-By: Guido Guenther <agx@sigxcpu.org>

Historical note: we always had issues with this machine, we had a
different patch for 2.6.11, discussion about it is here:
http://marc.theaimsgroup.com/?l=linux-scsi&m=110297733824960&w=2
Due to code changes in recent kernels we just need the above now, can
this be applied?
Cheers,
 -- Guido
