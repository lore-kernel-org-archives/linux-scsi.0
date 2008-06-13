From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [regression] CD-DA delay needed after insertion
Date: Fri, 13 Jun 2008 13:57:21 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1822578177-1213358241=:2141"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:48502 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753457AbYFML5X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jun 2008 07:57:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1822578177-1213358241=:2141
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

We've found another regression in 2.6.25 w.r.t. CD media change on PS3.

It can easily be reproduced by:

  1. Inserting an audio CD
  2. Running the following command as soon as the blue CD/DVD/BD drive LED
     stops blinking and is lit continuously:
      
	 cdparanoia -Z -q 1-1[:1] /dev/null || echo failed

On 2.6.25 (and current mainline), you have to wait ca. 10 seconds after
insertion, or it will fail.
On 2.6.24 and older, it just works immediately.

It does not matter whether
http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fjejb%2Fscsi-rc-fixes-2.6.git;a=commitdiff_plain;h=d1daeabf0da5bfa1943272ce508e2ba785730bf0
is applied or not.

We haven't bisected it yet.

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
---584349381-1822578177-1213358241=:2141--
