From: =?utf-8?q?Milan_Svoboda?= <milan.svoboda@centrum.cz>
Subject: =?utf-8?q?Re=3A_=5Busb=2Dstorage=5D_Re=3A_usb_disk_recognized_but_fails?=
Date: Sun, 26 Jan 2014 21:17:26 +0100
Message-ID: <20140126211726.17BCBFF3@centrum.cz>
References: <Pine.LNX.4.44L0.1401241056050.1129-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gmmr6.centrum.cz ([46.255.227.244]:50568 "EHLO gmmr6.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147AbaAZUR2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Jan 2014 15:17:28 -0500
In-Reply-To: <Pine.LNX.4.44L0.1401241056050.1129-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?utf-8?q?Alan_Stern?= <stern@rowland.harvard.edu>, =?utf-8?q?Matthieu_Castet?= <castet.matthieu@free.fr>
Cc: =?utf-8?q?Sarah_Sharp?= <sarah.a.sharp@linux.intel.com>, =?utf-8?q?USB_list?= <linux-usb@vger.kernel.org>, =?utf-8?q?USB_Storage_List?= <usb-storage@lists.one-eyed-alien.net>, =?utf-8?q?SCSI_development_list?= <linux-scsi@vger.kernel.org>

>
>You were right; that driver caused the problem.
>
>Matthieu Castet wrote the Cypress-ATACB driver, so maybe he can help.
>
>As shown above, this device matches the last entry in the
>unusual_cypress.h file (the one named "Super Top").  Not shown here is
>the bcdDevice value, which is 0x0150.  Should the bcdDevice range for
>that unusual_devs entry be restricted to just 0x0219?
>
>Milan, the patch below should prevent the Cypress-ATACB driver from 
>binding to your device.  With this change, the original kernel config 
>should work.
>
>Alan Stern
>
>
>
>Index: usb-3.13/drivers/usb/storage/unusual_cypress.h
>===================================================================
>--- usb-3.13.orig/drivers/usb/storage/unusual_cypress.h
>+++ usb-3.13/drivers/usb/storage/unusual_cypress.h
>@@ -31,7 +31,7 @@ UNUSUAL_DEV(  0x04b4, 0x6831, 0x0000, 0x
> 		"Cypress ISD-300LP",
> 		USB_SC_CYP_ATACB, USB_PR_DEVICE, NULL, 0),
> 
>-UNUSUAL_DEV( 0x14cd, 0x6116, 0x0000, 0x0219,
>+UNUSUAL_DEV( 0x14cd, 0x6116, 0x0219, 0x0219,
> 		"Super Top",
> 		"USB 2.0  SATA BRIDGE",
> 		USB_SC_CYP_ATACB, USB_PR_DEVICE, NULL, 0),
>
>

This patch works. Looking forward to have it included in the master.

Thanks for your help,
Milan Svoboda
