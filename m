From: Randy Dunlap <rdunlap@xenotime.net>
Subject: megaraid sparse warnings
Date: Sat, 13 Feb 2010 21:23:04 -0800
Message-ID: <4B7788B8.8090005@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.64.118]:59952 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750900Ab0BNFXG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Feb 2010 00:23:06 -0500
Received: from chimera.site ([71.245.98.113]) by xenotime.net for <linux-scsi@vger.kernel.org>; Sat, 13 Feb 2010 21:23:05 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>, Neela Syam Kolli <megaraidlinux@lsi.com>

Hi,

sparse produces these warnings:

drivers/scsi/megaraid.c:307:65: warning: right shift by bigger than source value
drivers/scsi/megaraid.c:309:65: warning: right shift by bigger than source value
drivers/scsi/megaraid.c:313:67: warning: right shift by bigger than source value
drivers/scsi/megaraid.c:315:67: warning: right shift by bigger than source value

on this source code:

	/* use HP firmware and bios version encoding */
	if (adapter->product_info.subsysvid == HP_SUBSYS_VID) {
		sprintf (adapter->fw_version, "%c%d%d.%d%d",
			 adapter->product_info.fw_version[2],
			 adapter->product_info.fw_version[1] >> 8,
			 adapter->product_info.fw_version[1] & 0x0f,
			 adapter->product_info.fw_version[0] >> 8,
			 adapter->product_info.fw_version[0] & 0x0f);
		sprintf (adapter->bios_version, "%c%d%d.%d%d",
			 adapter->product_info.bios_version[2],
			 adapter->product_info.bios_version[1] >> 8,
			 adapter->product_info.bios_version[1] & 0x0f,
			 adapter->product_info.bios_version[0] >> 8,
			 adapter->product_info.bios_version[0] & 0x0f);
	} else {


Are the fw_version and bios_version fields more than 8 bits each for HP subsys VID
products?  Do HP VID products need a different struct so that they print this info
correctly?

thanks,
-- 
~Randy
