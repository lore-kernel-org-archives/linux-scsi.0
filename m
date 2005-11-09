From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/3]  qla2xxx: deprecate usage of firmware-loader modules.
Date: 9 Nov 2005 15:48:50 -0800
Message-ID: <20051109234846.4868.25487.sendpatchset@andrew-vasquezs-powerbook-g4-15.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:43586 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751629AbVKIXsz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2005 18:48:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

James,

This set of patches transitions the qla2xxx driver to begin using the
request_firmware() interfaces to retrieve firmware-blobs from
user-space.  This will be the default behaviour going forward as the
embedded firmware-binary images are scheduled for removal from the
upstream kernel sources.

NOTE: A set of  (deprecated) Kconfig options are present to allow the
user to continue to use the firmware-loader modules.

Layout of Kconfig updates:

 - default qla2xxx build mechanism (firmware via request_firmware())

	<M> QLogic QLA2XXX Fibre Channel Support
	[ ]     Use firmware-loader modules (DEPRECATED)

 - using firmware loader modules (embedded firmware used)

	<M> QLogic QLA2XXX Fibre Channel Support
	[*]     Use firmware-loader modules (DEPRECATED)
	< >       Build QLogic ISP2100 firmware-module (NEW)
	< >       Build QLogic ISP2200 firmware-module (NEW)
	< >       Build QLogic ISP2300 firmware-module (NEW)
	<M>       Build QLogic ISP2322 firmware-module (NEW)
	< >       Build QLogic ISP63xx firmware-module (NEW)
	<M>       Build QLogic ISP24xx firmware-module (NEW)


Summary of updates:

  Add full firmware(-request) hotplug support for all ISPs.
  Add support for embedded ISP24xx firmware.
  Resync with latest released ISP24xx firmware -- 4.00.16.

All patches can be found at the following URL:

        ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.01.03k/
		5001-Add-full-firmware-request-hotplug-support-for-all-ISPs.txt
		5002-Add-support-for-embedded-ISP24xx-firmware.txt
		5003-Resync-with-latest-released-ISP24xx-firmware-4.00.16.txt.bz2

Regards,
Andrew Vasquez
QLogic Corporation

-- 
Andrew Vasquez
