From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [Cbe-oss-dev] [PATCH] ps3rom: sector size should be 512 bytes
Date: Thu, 31 Jan 2008 14:28:20 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801311414380.15534@vixen.sonytel.be>
References: <dc3abf350801290318u66474599n2f293832373f3706@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1658879875-1201785373=:15534"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58623 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758631AbYAaN2X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 08:28:23 -0500
In-Reply-To: <dc3abf350801290318u66474599n2f293832373f3706@mail.gmail.com>
Content-ID: <Pine.LNX.4.64.0801311416150.15534@vixen.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aegis Lin <aegislin@gmail.com>
Cc: Masakazu Mokuno <Masakazu_Mokuno@hq.scei.sony.co.jp>, Cell Broadband Engine OSS Development <cbe-oss-dev@ozlabs.org>, linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1658879875-1201785373=:15534
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0801311416151.15534@vixen.sonytel.be>

On Tue, 29 Jan 2008, Aegis Lin wrote:
> Quite minor patch, but from the context it should be desired
> that 64KB is available for ATAPI transferrring.
> (Historically) in SCSI/block layer sector size is defined as
> 512 during sector-byte calculation. Originally in ps3rom.c
> CD_FRAMESIZE was used, which makes
> /sys/block/sr0/queue/max_sectors_kb
> to be limited to 16KB.

Can I please have a Signed-off-by?

> diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
> index 17b4a7c..cc7062b 100644
> --- a/drivers/scsi/ps3rom.c
> +++ b/drivers/scsi/ps3rom.c
> @@ -35,7 +35,7 @@
>  
>  #define BOUNCE_SIZE			(64*1024)
>  
> -#define PS3ROM_MAX_SECTORS		(BOUNCE_SIZE / CD_FRAMESIZE)
> +#define PS3ROM_MAX_SECTORS		(BOUNCE_SIZE / 512)
>  
>  
>  struct ps3rom_private {

Indeed, scsi_host_template.max_sectors seems to be just passed to the block
layer, so it concerns 512-byte sectors.

Furthermore, drivers/cdrom/cdrom.c:cdrom_read_cdda_bpc() seems to handle the
conversion from raw CD frame sizes to 512-byte sectors, and limit the requested
number of sectors if needed.

However, I didn't find where it handles conversion from CD data frame sizes to
512-byte sectors.

Am I missing something?

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

Sony Network and Software Technology Center Europe
A division of Sony Service Centre (Europe) N.V.
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
VAT BE 0413.825.160 · RPR Brussels
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584349381-1658879875-1201785373=:15534--
