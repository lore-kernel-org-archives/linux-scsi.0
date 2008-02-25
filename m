From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] ps3rom: fix wrong resid calculation bug
Date: Mon, 25 Feb 2008 14:22:56 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802251420270.31208@vixen.sonytel.be>
References: <1203895523-4009-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-463852703-1203945776=:31208"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:39057 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753283AbYBYNXF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Feb 2008 08:23:05 -0500
In-Reply-To: <1203895523-4009-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, tomof@acm.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-463852703-1203945776=:31208
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sun, 24 Feb 2008, FUJITA Tomonori wrote:
> sg driver rounds up the length in struct scatterlist to be a multiple
> of 512 in some conditions. So LLDs can't use the data length in a sg
> list to calculate residual. Instead, the length in struct scsi_cmnd
> should be used.

Thanks!

> --- a/drivers/scsi/ps3rom.c
> +++ b/drivers/scsi/ps3rom.c
> @@ -124,7 +124,7 @@ static int fill_from_dev_buffer(struct scsi_cmnd *cmd, const void *buf)
>  		}
>  		req_len += sgpnt->length;
>  	}
> -	scsi_set_resid(cmd, req_len - act_len);
> +	scsi_set_resid(cmd, scsi_bufflen(cmd) - act_len);
>  	return 0;
>  }

My 2 comments:
  - The variable buflen already contains scsi_bufflen(cmd),
  - We no longer need to calculate the data length of the whole scatterlist.

I'll follow up to this email with a replacement patch and an addendum patch.

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
---584349381-463852703-1203945776=:31208--
