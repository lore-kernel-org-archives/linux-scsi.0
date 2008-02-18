From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] ps3rom: disable clustering
Date: Mon, 18 Feb 2008 15:18:15 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802181516170.13406@vixen.sonytel.be>
References: <1203259560-15434-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-286681433-1203344295=:13406"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:60128 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753232AbYBROSR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Feb 2008 09:18:17 -0500
In-Reply-To: <1203259560-15434-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-286681433-1203344295=:13406
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sun, 17 Feb 2008, FUJITA Tomonori wrote:
> ps3rom does:
> 
> scsi_for_each_sg(cmd, sgpnt, scsi_sg_count(cmd), k) {
> 	kaddr = kmap_atomic(sg_page(sgpnt), KM_IRQ0);
> 
> We cannot do something like that with the clustering enabled (or we
> can use scsi_kmap_atomic_sg).
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>

Seems to (still) work fine..

James: as you're scripts seem to be waiting for an ack from me, and it's not
really obvious to me whether this patch is needed or not, I'll leave it up to
you.

> ---
>  drivers/scsi/ps3rom.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
> index 0cd614a..90985cd 100644
> --- a/drivers/scsi/ps3rom.c
> +++ b/drivers/scsi/ps3rom.c
> @@ -427,7 +427,7 @@ static struct scsi_host_template ps3rom_host_template = {
>  	.cmd_per_lun =		1,
>  	.emulated =             1,		/* only sg driver uses this */
>  	.max_sectors =		PS3ROM_MAX_SECTORS,
> -	.use_clustering =	ENABLE_CLUSTERING,
> +	.use_clustering =	DISABLE_CLUSTERING,
>  	.module =		THIS_MODULE,
>  };

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
---584349381-286681433-1203344295=:13406--
