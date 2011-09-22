From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] pm8001: raise host can queue
Date: Wed, 21 Sep 2011 21:25:50 -0700
Message-ID: <CAA9_cme5EOrkC_LKfVdEoqch9C_KYireVX79OUgPcsEoQ2MeqA@mail.gmail.com>
References: <CE155251DF87469DA8F1A8290EDCF361@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45184 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab1IVEZv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2011 00:25:51 -0400
Received: by qyk7 with SMTP id 7so2420607qyk.19
        for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2011 21:25:51 -0700 (PDT)
In-Reply-To: <CE155251DF87469DA8F1A8290EDCF361@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, lindar_liu <lindar_liu@usish.com>, crystal_yu@usish.com, john_gong@usish.com, mark_salyzyn@us.xyratex.com, Christoph Hellwig <hch@infradead.org>

On Wed, Sep 21, 2011 at 7:05 PM, Jack Wang <jack_wang@usish.com> wrote:
> Hi James,
>
> Because Dan change device queue depth to 256, and as point by Mark th=
is may
> result in starvation, so I bump the host can queue value to 510.

Hi,

Is this a theoretical or actual concern?  Because the mid-layer should
be handling starvation if I understand the mechanics of the
shost->starved_list.

--
Dan

> Best regards!
>
> Jack
>
> From 3647cde88d66760ca336ad127a5b1fdf5c1d28f7 Mon Sep 17 00:00:00 200=
1
> From: Jack Wang <jack_wang@usish.com>
> Date: Thu, 22 Sep 2011 09:50:54 +0800
> Subject: [PATCH] bump host can queue to follow libsas queue depth cha=
nge
>
> Signed-off-by: Jack Wang <jack_wang@usish.com>
> ---
> =A0pm8001_defs.h | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/pm8001_defs.h b/pm8001_defs.h
> index 944afad..704b492 100644
> --- a/pm8001_defs.h
> +++ b/pm8001_defs.h
> @@ -68,7 +68,7 @@ enum port_type {
> =A0#define =A0 =A0 =A0 =A0PM8001_MAX_CCB =A0 =A0 =A0 =A0 =A0 512 =A0 =
=A0/* max ccbs supported */
> =A0#define =A0 =A0 =A0 =A0PM8001_MAX_INB_NUM =A0 =A0 =A0 1
> =A0#define =A0 =A0 =A0 =A0PM8001_MAX_OUTB_NUM =A0 =A0 =A01
> -#define =A0 =A0 =A0 =A0PM8001_CAN_QUEUE =A0 =A0 =A0 =A0 128 =A0 =A0/=
* SCSI Queue depth */
> +#define =A0 =A0 =A0 =A0PM8001_CAN_QUEUE =A0 =A0 =A0 =A0 510 =A0 =A0/=
* SCSI Queue depth */


>
> =A0/* unchangeable hardware details */
> =A0#define =A0 =A0 =A0 =A0PM8001_MAX_PHYS =A0 =A0 =A0 =A0 =A08 =A0 =A0=
 =A0/* max. possible phys */
> --
> 1.7.4.msysgit.0
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
