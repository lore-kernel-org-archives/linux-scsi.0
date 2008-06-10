From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [Cbe-oss-dev] [regression/bisected] corrupt CD data after media
	change and delay
Date: Tue, 10 Jun 2008 17:11:34 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806101705150.1797@vixen.sonytel.be>
References: <Pine.LNX.4.64.0806061458300.6228@vixen.sonytel.be>
	<1212765202.16182.5.camel@localhost.localdomain>
	<Pine.LNX.4.64.0806091443000.17741@vixen.sonytel.be>
	<Pine.LNX.4.64.0806091546260.22138@vixen.sonytel.be>
	<1213023916.3508.23.camel@localhost.localdomain>
	<Pine.LNX.4.64.0806091721040.22138@vixen.sonytel.be>
	<1213028647.3508.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-584349381-1699011968-1213110694=:1797"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:34331 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752871AbYFJPn6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jun 2008 11:43:58 -0400
Received: from vixen.sonytel.be (piraat.sonytel.be [43.221.60.197])
	by vervifontaine.sonycom.com (Postfix) with ESMTP id BAE1B58C3D
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2008 17:43:47 +0200 (MEST)
In-Reply-To: <1213028647.3508.33.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1699011968-1213110694=:1797
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

	Hi James,

On Mon, 9 Jun 2008, James Bottomley wrote:
> My best guess is that it's something to do with eaten UNIT_ATTENTION
> keys.  I theorise that in the successful case, they get processed in
> scsi_io_completion which sets the changed bit.  In the delay case, the
> unit attention is eaten by sr_test_unit_ready so the changed bit is
> always kept at zero.  If this is the case, then the patch below should
> fix it.  If not, we're back to more debugging ...

Yep, that fixed it. Thanks!

Inserting first CD, mounting:

| +0+ the_result = 0x8000002 (sdev->changed = 1)
| Sense Key : 0x0 [current] [descriptor]
| +0+ the_result = 0x8000002 (sdev->changed = 1)
| Sense Key : 0x0 [current] [descriptor]
| +0+ the_result = 0x8000002 (sdev->changed = 1)
| Sense Key : 0x0 [current] [descriptor]
| Sense Key : 0x2 [current] 
| +5+ CDS_DISC_OK
| +0+ the_result = 0x8000002 (sdev->changed = 1)
| Sense Key : 0x0 [current] [descriptor]
| +0+ the_result = 0x8000002 (sdev->changed = 1)
| Sense Key : 0x0 [current] [descriptor]
| +0+ the_result = 0x8000002 (sdev->changed = 1)
| Sense Key : 0x0 [current] [descriptor]
| Sense Key : 0x2 [current] 
| +5+ CDS_DISC_OK
| +0+ the_result = 0x0 (sdev->changed = 1)
| Sense Key : 0x0 [current] [descriptor]
| +1+ CDS_DISC_OK
| +0+ the_result = 0x0 (sdev->changed = 1)
| Sense Key : 0x0 [current] [descriptor]
| +1+ CDS_DISC_OK
| +0+ the_result = 0x0 (sdev->changed = 1)
| Sense Key : 0x0 [current] [descriptor]
| +11+ Return forcing update is 1
                                ^
				OK

| ISO 9660 Extensions: RRIP_1991A

Unmounting first CD:

| +0+ the_result = 0x0 (sdev->changed = 0)
| Sense Key : 0x0 [current] [descriptor]
| +1+ CDS_DISC_OK
| +0+ the_result = 0x0 (sdev->changed = 0)
| Sense Key : 0x0 [current] [descriptor]
| +1+ CDS_DISC_OK
| +0+ the_result = 0x0 (sdev->changed = 0)
| Sense Key : 0x0 [current] [descriptor]
| +11+ Return forcing update is 0

Inserting second CD, mounting after 30 seconds:

| +0+ the_result = 0x8000002 (sdev->changed = 1)
| Sense Key : 0x0 [current] [descriptor]
| +0+ the_result = 0x0 (sdev->changed = 1)
| Sense Key : 0x0 [current] [descriptor]
| +1+ CDS_DISC_OK
| +0+ the_result = 0x0 (sdev->changed = 1)
| Sense Key : 0x0 [current] [descriptor]
| +1+ CDS_DISC_OK
| +0+ the_result = 0x0 (sdev->changed = 1)
| Sense Key : 0x0 [current] [descriptor]
| +1+ CDS_DISC_OK
| +0+ the_result = 0x0 (sdev->changed = 1)
| Sense Key : 0x0 [current] [descriptor]
| +1+ CDS_DISC_OK
| +0+ the_result = 0x0 (sdev->changed = 1)
| Sense Key : 0x0 [current] [descriptor]
| +11+ Return forcing update is 1
                                ^
				OK!

| ISO 9660 Extensions: Microsoft Joliet Level 3
| ISO 9660 Extensions: RRIP_1991A

=> success!

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
---584349381-1699011968-1213110694=:1797--
