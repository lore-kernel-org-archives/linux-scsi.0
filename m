From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] mptctl for mptsas
Date: Thu, 04 Jan 2007 23:48:54 -0500
Message-ID: <459DD8B6.2060302@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070005000606040702000704"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:59057 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030312AbXAEEtB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jan 2007 23:49:01 -0500
Received: from ip-178.83.126.206.dsl-cust.ca.inter.net ([206.126.83.178] helo=[192.168.48.87])
	by pentafluge.infradead.org with esmtpsa (Exim 4.63 #1 (Red Hat Linux))
	id 1H2h0i-00011v-Va
	for linux-scsi@vger.kernel.org; Fri, 05 Jan 2007 04:48:57 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------070005000606040702000704
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch makes the mptctl pass through available if
the mptsas driver is selected. Without this patch
if mptsas is the only fusion driver chosen, then
the mptctl is not presented as an option.

smp_utils uses the mptctl driver to pass SAS SMP
functions through a MPT SAS HBA.

I have discussed this patch with Eric and it may
be in one of his coming patchsets (but I didn't see
it in today's patches). So this one is for the
record. The patch is against lk 2.6.20-rc3 .

Signed-off-by: Douglas Gilbert <dougg@torque.net>

Doug Gilbert

--------------070005000606040702000704
Content-Type: text/x-patch;
 name="mptctl_sas.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mptctl_sas.diff"

--- linux/drivers/message/fusion/Kconfig	2006-09-20 11:12:11.000000000 -0400
+++ linux/drivers/message/fusion/Kconfig2620rc3sas	2007-01-04 23:29:13.000000000 -0500
@@ -66,7 +66,7 @@
 
 config FUSION_CTL
 	tristate "Fusion MPT misc device (ioctl) driver"
-	depends on FUSION_SPI || FUSION_FC
+	depends on FUSION_SPI || FUSION_FC || FUSION_SAS
 	---help---
 	  The Fusion MPT misc device driver provides specialized control
 	  of MPT adapters via system ioctl calls.  Use of ioctl calls to

--------------070005000606040702000704--
