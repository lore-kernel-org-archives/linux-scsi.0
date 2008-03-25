From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH v2 5/5] ps3rom: use scsi_build_sense_buffer
Date: Tue, 25 Mar 2008 13:17:41 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803251316320.1672@vixen.sonytel.be>
References: 1206378609.3494.50.camel@localhost.localdomain
 <1206404816-21710-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206404816-21710-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206404816-21710-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206404816-21710-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206404816-21710-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1650271770-1206447461=:1672"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:59221 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754047AbYCYMRp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Mar 2008 08:17:45 -0400
In-Reply-To: <1206404816-21710-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, tomof@acm.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1650271770-1206447461=:1672
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 25 Mar 2008, FUJITA Tomonori wrote:
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Acked-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  drivers/scsi/ps3rom.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
> index d1e7845..ce48e2d 100644
> --- a/drivers/scsi/ps3rom.c
> +++ b/drivers/scsi/ps3rom.c
> @@ -26,6 +26,7 @@
>  #include <scsi/scsi_dbg.h>
>  #include <scsi/scsi_device.h>
>  #include <scsi/scsi_host.h>
> +#include <scsi/scsi_eh.h>
>  
>  #include <asm/lv1call.h>
>  #include <asm/ps3stor.h>
> @@ -330,11 +331,7 @@ static irqreturn_t ps3rom_interrupt(int irq, void *data)
>  		goto done;
>  	}
>  
> -	cmd->sense_buffer[0]  = 0x70;
> -	cmd->sense_buffer[2]  = sense_key;
> -	cmd->sense_buffer[7]  = 16 - 6;
> -	cmd->sense_buffer[12] = asc;
> -	cmd->sense_buffer[13] = ascq;
> +	scsi_build_sense_buffer(0, cmd->sense_buffer, sense_key, asc, ascq);
>  	cmd->result = SAM_STAT_CHECK_CONDITION;
>  
>  done:
> -- 
> 1.5.3.7

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
---584349381-1650271770-1206447461=:1672--
