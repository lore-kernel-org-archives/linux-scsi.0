From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 1/1] SCSI: lpfc, restore MSI-X/MSI support
Date: Thu, 14 Jan 2010 14:02:25 -0800
Message-ID: <86802c441001141402k10e67212l540695489d300849@mail.gmail.com>
References: <87r5pta66n.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:55528 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab0ANWCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2010 17:02:25 -0500
Received: by pwj9 with SMTP id 9so391513pwj.21
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jan 2010 14:02:25 -0800 (PST)
In-Reply-To: <87r5pta66n.fsf@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: George Kadianakis <desnacked@gmail.com>
Cc: linux-scsi@vger.kernel.org, james.smart@emulex.com

On Wed, Jan 13, 2010 at 4:20 PM, George Kadianakis <desnacked@gmail.com=
> wrote:
> From: George Kadianakis <desnacked {bomb} gmail {point} com>
>
> A Gentoo bug report [1] showed that as of 2.6.31 lpfc only uses INTx =
interrupts.
> This patch restores lpfc's ability to support MSI-X/MSI interrupts th=
at the
> "Addition of SLI4 Interface - Base Support" patch [2] broke.
> It reestablishes MSI-X as the default interrupt method and in case MS=
I-X is not
> supported lpfc_sli{4,}_enable_intr fallbacks to MSI and then to INTx.
>
> [1]: http://bugs.gentoo.org/show_bug.cgi?id=3D296319
> [2]: commit da0436e915a5c17ee79e72c1bf978a4ebb1cbf4d
>
> Signed-off-by: =A0George Kadianakis <desnacked {cat} gmail {dog} com>
> ---
> =A0drivers/scsi/lpfc/lpfc_attr.c | =A0 =A06 +++---
> =A01 file changed, 3 insertions(+), 3 deletions(-)
>
>
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_a=
ttr.c
> index e1a30a1..936ecaf 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -2890,12 +2890,12 @@ LPFC_ATTR_RW(poll_tmo, 10, 1, 255,
> =A0/*
> =A0# lpfc_use_msi: Use MSI (Message Signaled Interrupts) in systems t=
hat
> =A0# =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 supp=
ort this feature
> -# =A0 =A0 =A0 0 =A0=3D MSI disabled (default)
> +# =A0 =A0 =A0 0 =A0=3D MSI disabled
> =A0# =A0 =A0 =A0 1 =A0=3D MSI enabled
> -# =A0 =A0 =A0 2 =A0=3D MSI-X enabled
> +# =A0 =A0 =A0 2 =A0=3D MSI-X enabled (default)
> =A0# Value range is [0,2]. Default value is 0.
0 ?
> =A0*/
> -LPFC_ATTR_R(use_msi, 0, 0, 2, "Use Message Signaled Interrupts (1) o=
r "
> +LPFC_ATTR_R(use_msi, 2, 0, 2, "Use Message Signaled Interrupts (1) o=
r "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0"MSI-X (2), if possible");
>
> =A0/*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
