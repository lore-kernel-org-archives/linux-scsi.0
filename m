From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [regression] CD-DA delay needed after insertion
Date: Mon, 16 Jun 2008 17:05:50 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806161659440.30122@vixen.sonytel.be>
References: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
 <1213540781.3517.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-882354669-1213628750=:30122"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:40560 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751831AbYFPPFx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jun 2008 11:05:53 -0400
In-Reply-To: <1213540781.3517.18.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-882354669-1213628750=:30122
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

	Hi James,

On Sun, 15 Jun 2008, James Bottomley wrote:
> On Fri, 2008-06-13 at 13:57 +0200, Geert Uytterhoeven wrote:
> > We've found another regression in 2.6.25 w.r.t. CD media change on PS3.
> > 
> > It can easily be reproduced by:
> > 
> >   1. Inserting an audio CD
> >   2. Running the following command as soon as the blue CD/DVD/BD drive LED
> >      stops blinking and is lit continuously:
> >       
> > 	 cdparanoia -Z -q 1-1[:1] /dev/null || echo failed
> > 
> > On 2.6.25 (and current mainline), you have to wait ca. 10 seconds after
> > insertion, or it will fail.
> > On 2.6.24 and older, it just works immediately.
> > 
> > It does not matter whether
> > http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fjejb%2Fscsi-rc-fixes-2.6.git;a=commitdiff_plain;h=d1daeabf0da5bfa1943272ce508e2ba785730bf0
> > is applied or not.
> > 
> > We haven't bisected it yet.
> 
> There aren't that many commits affecting sr between 2.6.24 and 2.6.25,
> so I'd bet on the previous culprits.
> 
> This time, the taxonomy looks like NOT_READY isn't being waited for
> properly.  I'd still tend to blame
> 210ba1d1724f5c4ed87a2ab1a21ca861a915f734 it's just that this time I

Reverting that commit doesn't fix the problem.

> suspect this to be the problem line:
> 
> 	if (sshdr.sense_key == NOT_READY && sshdr.asc == 0x04)
> 		return CDS_DISC_OK;
> 
> Previously the code would have returned CDS_NO_DISC for the not ready
> case.  The CD would have tried to close the door but (and this is the
> key) it would have waited for the door to close before trying again.

I tried the patch below.

Now the kernel spits out messages every 2 seconds:

| G: CDS_NO_DISC
| G: CDS_NO_DISC

Insert CD-DA media

Reading from CD using cdparanioa fails

| F: CDS_DISC_OK
| F: CDS_DISC_OK
| F: CDS_DISC_OK
| F: CDS_DISC_OK
| F: CDS_DISC_OK

Reading from CD starts to work here

| B: CDS_DISC_OK
| B: CDS_DISC_OK

I tried changing the return value in the `F' case to CDS_NO_DISC, but that
doesn't make a difference.

--- a/drivers/scsi/sr_ioctl.c	2008-06-16 16:34:01.000000000 +0200
+++ b/drivers/scsi/sr_ioctl.c	2008-06-16 16:59:28.000000000 +0200
@@ -304,25 +304,34 @@ int sr_drive_status(struct cdrom_device_
 
 	if (CDSL_CURRENT != slot) {
 		/* we have no changer support */
+printk("A: -EINVAL\n");
 		return -EINVAL;
 	}
-	if (0 == sr_test_unit_ready(cd->device, &sshdr))
+	if (0 == sr_test_unit_ready(cd->device, &sshdr)) {
+printk("B: CDS_DISC_OK\n");
 		return CDS_DISC_OK;
+	}
 
 	if (!cdrom_get_media_event(cdi, &med)) {
-		if (med.media_present)
+		if (med.media_present) {
+printk("C: CDS_DISC_OK\n");
 			return CDS_DISC_OK;
-		else if (med.door_open)
+		} else if (med.door_open) {
+printk("D: CDS_TRAY_OPEN\n");
 			return CDS_TRAY_OPEN;
-		else
+		} else {
+printk("E: CDS_NO_DISC\n");
 			return CDS_NO_DISC;
+		}
 	}
 
 	/*
 	 * 0x04 is format in progress .. but there must be a disc present!
 	 */
-	if (sshdr.sense_key == NOT_READY && sshdr.asc == 0x04)
+	if (sshdr.sense_key == NOT_READY && sshdr.asc == 0x04) {
+printk("F: CDS_DISC_OK\n");
 		return CDS_DISC_OK;
+	}
 
 	/*
 	 * If not using Mt Fuji extended media tray reports,
@@ -331,11 +340,15 @@ int sr_drive_status(struct cdrom_device_
 	 */
 	if (scsi_sense_valid(&sshdr) &&
 	    /* 0x3a is medium not present */
-	    sshdr.asc == 0x3a)
+	    sshdr.asc == 0x3a) {
+printk("G: CDS_NO_DISC\n");
 		return CDS_NO_DISC;
-	else
+	} else {
+printk("H: CDS_TRAY_OPEN\n");
 		return CDS_TRAY_OPEN;
+	}
 
+printk("I: CDS_DRIVE_NOT_READY\n");
 	return CDS_DRIVE_NOT_READY;
 }
 

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

Sony Technology and Software Centre Europe
A division of Sony Service Centre (Europe) N.V.
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
VAT BE 0413.825.160 · RPR Brussels
Fortis 293-0376800-10 GEBA-BE-BB
---584349381-882354669-1213628750=:30122--
