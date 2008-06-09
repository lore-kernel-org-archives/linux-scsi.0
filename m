From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [Cbe-oss-dev] [regression/bisected] corrupt CD data after media
 change and delay
Date: Mon, 9 Jun 2008 17:27:26 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806091721040.22138@vixen.sonytel.be>
References: <Pine.LNX.4.64.0806061458300.6228@vixen.sonytel.be>
 <1212765202.16182.5.camel@localhost.localdomain>
 <Pine.LNX.4.64.0806091443000.17741@vixen.sonytel.be>
 <Pine.LNX.4.64.0806091546260.22138@vixen.sonytel.be>
 <1213023916.3508.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-529845150-1213025158=:22138"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760231AbYFIP1k@vger.kernel.org>
In-Reply-To: <1213023916.3508.23.camel@localhost.localdomain>
Content-ID: <Pine.LNX.4.64.0806091726130.22138@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Martin <tasio@tasio.net>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, Maarten Bressers <mbres@gentoo.org>, Daniel Drake <dsd@gentoo.org>, Cell Broadband Engine OSS Development <cbe-oss-dev@ozlabs.org>
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-529845150-1213025158=:22138
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0806091726131.22138@vixen.sonytel.be>

	Hi James,

On Mon, 9 Jun 2008, James Bottomley wrote:
> On Mon, 2008-06-09 at 15:54 +0200, Geert Uytterhoeven wrote:
> > I managed to reproduce it on my laptop (Core 2 Duo, SATA DVD-RAM, running
> > Ubuntu 8.04 for amd64), by booting Debian's 2.6.25 kernel into recovery mode.
> > So the problem is not PS3-specific.
> > 
> > Worse, I never got an updated /sys/block/sr0/size for the second CD, not even
> > when mounting it ASAP (which is ca. 15-20 seconds after inserting it).  It
> > always stayed at the value for the first CD.
> 
> Well, we have the taxonomy.  It's something to do with the media change
> trigger.  Could you try getting the output of this patch and correlate
> the prints with your success and failure cases?

Sure!

Inserting first CD, mounting:

| +0+ the_result = 0x8000002 Sense Key : 0x0 [current] [descriptor]
| +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
| +1+ CDS_DISC_OK
| +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
| +1+ CDS_DISC_OK
| +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
| +1+ CDS_DISC_OK
| +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
| +1+ CDS_DISC_OK
| +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
| +11+ Return forcing update is 1
                                ^
				OK

| ISO 9660 Extensions: RRIP_1991A

Unmounting first CD:

| +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
| +1+ CDS_DISC_OK
| +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
| +1+ CDS_DISC_OK
| +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
| +11+ Return forcing update is 0

Ejecting first CD:

| +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
| +11+ Return forcing update is 0

Inserting second CD, mounting after 30 seconds:

| +0+ the_result = 0x8000002 Sense Key : 0x0 [current] [descriptor]
| +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
| +1+ CDS_DISC_OK
| +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
| +1+ CDS_DISC_OK
| +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
| +1+ CDS_DISC_OK
| +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
| +1+ CDS_DISC_OK
| +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
| +11+ Return forcing update is 0
                                ^
				Not updated!
| ISO 9660 Extensions: Microsoft Joliet Level 3
| ISO 9660 Extensions: RRIP_1991A

=> failed!

Unmounting second CD:

| +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
| +1+ CDS_DISC_OK
| +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
| +1+ CDS_DISC_OK
| +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
| +11+ Return forcing update is 0

Ejecting second CD:

| +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
| +11+ Return forcing update is 0

Inserting second CD, mounting immediately:

| +0+ the_result = 0x8000002 Sense Key : 0x0 [current] [descriptor]
| +0+ the_result = 0x8000002 Sense Key : 0x0 [current] [descriptor]
| +0+ the_result = 0x8000002 Sense Key : 0x0 [current] [descriptor]
| Sense Key : 0x2 [current] 
| +5+ CDS_DISC_OK
| +0+ the_result = 0x8000002 Sense Key : 0x0 [current] [descriptor]
| +0+ the_result = 0x8000002 Sense Key : 0x0 [current] [descriptor]
| +0+ the_result = 0x8000002 Sense Key : 0x0 [current] [descriptor]
| Sense Key : 0x2 [current] 
| +5+ CDS_DISC_OK
| +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
| +1+ CDS_DISC_OK
| +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
| +1+ CDS_DISC_OK
| +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
| +11+ Return forcing update is 1
                                ^
				OK

| ISO 9660 Extensions: Microsoft Joliet Level 3
| ISO 9660 Extensions: RRIP_1991A

=> success!

Unmounting second CD:

| +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
| +1+ CDS_DISC_OK
| +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
| +1+ CDS_DISC_OK
| +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
| +11+ Return forcing update is 0

Ejecting second CD:

| +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
| +11+ Return forcing update is 0

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
---584349381-529845150-1213025158=:22138--
