From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Fw: Re: 2.6.19-rc4-mm2 -- Build problems
Date: Thu, 02 Nov 2006 13:24:47 -0800
Message-ID: <454A621F.40906@us.ibm.com>
References: <20061102124857.355208ec.akpm@osdl.org>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:51078 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S1752466AbWKBVYu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Nov 2006 16:24:50 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kA2LOnii024956
	for <linux-scsi@vger.kernel.org>; Thu, 2 Nov 2006 16:24:49 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kA2LOnFr353600
	for <linux-scsi@vger.kernel.org>; Thu, 2 Nov 2006 14:24:49 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kA2LOmHG015157
	for <linux-scsi@vger.kernel.org>; Thu, 2 Nov 2006 14:24:48 -0700
In-Reply-To: <20061102124857.355208ec.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Andrew Morton wrote:

> WARNING: "ata_sas_slave_configure" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_port_disable" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_sas_port_init" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_sas_port_stop" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_sas_port_start" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_sas_port_alloc" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_noop_qc_prep" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_tf_to_fis" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_noop_dev_select" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_tf_from_fis" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_host_init" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_sas_queuecmd" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_sas_port_destroy" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_scsi_ioctl" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_qc_complete" [drivers/scsi/libsas/libsas.ko] undefined!

The SATA-fortified libsas depends on libata for SATA support.
Kconfig needs to know about that.  Patch is for aic94xx-sas-2.6
and apparently -mm as well.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

--

diff --git a/drivers/scsi/libsas/Kconfig b/drivers/scsi/libsas/Kconfig
index aafdc92..b64e391 100644
--- a/drivers/scsi/libsas/Kconfig
+++ b/drivers/scsi/libsas/Kconfig
@@ -24,7 +24,7 @@ #
 
 config SCSI_SAS_LIBSAS
 	tristate "SAS Domain Transport Attributes"
-	depends on SCSI
+	depends on SCSI && ATA
 	select SCSI_SAS_ATTRS
 	help
 	  This provides transport specific helpers for SAS drivers which
