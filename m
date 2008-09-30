From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [regression] CD-DA delay needed after insertion
 (http://bugzilla.kernel.org/show_bug.cgi?id=10974)
Date: Tue, 30 Sep 2008 16:51:39 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0809301648490.5818@vixen.sonytel.be>
References: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
 <Pine.LNX.4.64.0806171530340.22840@vixen.sonytel.be>
 <1214605634.3394.91.camel@localhost.localdomain>
 <Pine.LNX.4.64.0806301120570.10868@vixen.sonytel.be>
 <1214841102.3381.5.camel@localhost.localdomain> <1214925487.3316.12.camel@localhost.localdomain>
 <Pine.LNX.4.64.0809171701330.21347@vixen.sonytel.be>
 <806dafc20809300117u2806e37bx986b54543862f358@mail.gmail.com>
 <Pine.LNX.4.64.0809301430370.5818@vixen.sonytel.be>
 <806dafc20809300548y4af5f10bs8a80caa24f176c79@mail.gmail.com>
 <806dafc20809300551i7678660aq5e4fd6e8080382a0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-511647526-1222786299=:5818"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:57981 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752552AbYI3Ovk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2008 10:51:40 -0400
In-Reply-To: <806dafc20809300551i7678660aq5e4fd6e8080382a0@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Monty Montgomery <monty@xiph.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-511647526-1222786299=:5818
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 30 Sep 2008, Monty Montgomery wrote:
> Fixed in SVN; pull a copy and try again.
> 
> [Mein Gott, that bug was just embarrassing]

With latest cdparanoia git-^H^H^H^Hsvn, the problem still happens.
After applying the patch below, there's no more crash thanks to your last
commit, and It Just Works(tm):

    eject; sg_start -i -l /dev/scd0; cdparanoia -d /dev/scd0 -Z -q 1-1[:1] /dev/null || echo failed

diff --git a/interface/scan_devices.c b/interface/scan_devices.c
index bfe5403..df08906 100644
--- a/interface/scan_devices.c
+++ b/interface/scan_devices.c
@@ -614,7 +614,7 @@ cdrom_drive *cdda_identify_scsi(const char *generic_device,
 
   if(specialized_device) {
     if(use_sgio)
-      i_fd=open(specialized_device,O_RDWR|O_NONBLOCK);
+      i_fd=open(specialized_device,O_RDONLY);
     else
       i_fd=open(specialized_device,O_RDONLY|O_NONBLOCK);
   }

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-511647526-1222786299=:5818--
