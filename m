From: Christian =?iso-8859-1?q?Sch=F6niger?=
	<christian.schoeniger@fes-aes.de>
Subject: PROBLEM: aic79xx probe order for multi-channel controllers
Date: Wed, 29 Mar 2006 17:33:25 +0200
Message-ID: <200603291733.25955.christian.schoeniger@fes-aes.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.fes-aes.de ([62.153.241.252]:15543 "EHLO mx2.fes-aes.de")
	by vger.kernel.org with ESMTP id S1751177AbWC2Pd7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 10:33:59 -0500
Received: from localhost (localhost [127.0.0.1])
	by mx2.fes-aes.de (Postfix) with ESMTP id DE37016AFE
	for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2006 17:33:48 +0200 (CEST)
Received: from mx2.fes-aes.de ([127.0.0.1])
 by localhost (mx2.fes-aes.de [127.0.0.1]) (amavisd-new, port 10024) with LMTP
 id 01901-02 for <linux-scsi@vger.kernel.org>;
 Wed, 29 Mar 2006 17:33:33 +0200 (CEST)
Received: from fes-aes.de (mailserver [194.49.70.8])
	by mx2.fes-aes.de (Postfix) with ESMTP id 66D5416ADA
	for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2006 17:33:31 +0200 (CEST)
Received: from linux43.fes-aes.de ([194.49.70.43] verified)
  by fes-aes.de (CommuniGate Pro SMTP 5.0.6)
  with ESMTP id 4230736 for linux-scsi@vger.kernel.org; Wed, 29 Mar 2006 17:33:26 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Many onboard scsi controllers are multi-channel and use channel "B" as 
internal bus. Anything on the external channel ("A") is attached before 
the internal devices.
This applies e.g. to Intel SR1300 Servers with AIC-7902 U320 chipset.

The "reverse_scan" option doesn't seem to effect the multi-channel
probe order.

In the Adaptec BIOS you can specify the boot channel. This channel 
should be scanned first. This works fine with AIC-78xx controllers.
The aic79xx driver ignores this setting. Looking at the code, I found it 
disabled.

/usr/src/kernel-source-2.6.8/drivers/scsi/aic7xxx/aic79xx_osm.c:
*snip*
int
ahd_softc_comp(struct ahd_softc *lahd, struct ahd_softc *rahd)
{
        int     value;

        /*
         * Under Linux, cards are ordered as follows:
         *      1) PCI devices that are marked as the boot controller.
         *      2) PCI devices with BIOS enabled sorted by 
bus/slot/func.
         *      3) All remaining PCI devices sorted by bus/slot/func.
         */
#if 0
        value = (lahd->flags & AHD_BOOT_CHANNEL)
              - (rahd->flags & AHD_BOOT_CHANNEL);
        if (value != 0)
                /* Controllers set for boot have a *higher* priority */
                return (value);
#endif
*snip*

Affected aic79xx driver versions are at 1.3.11 up to the latest Adaptec 
version 2.0.12.

Removing the "# if 0 ... endif" statements causes the boot channel 
probed first.


Christian

-- 
---=================================================================---
Christian Schoeniger, SYSADMIN, FES GmbH - Fahrzeug-Entwicklung Sachsen
phone: +49 375 56 60 254 fax: +49 375 56 60 92254 http://www.fes-aes.de
---===> I haven't lost my mind; I know exactly where I left it. <===---
