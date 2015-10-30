From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [RESEND PATCH] [SCSI] mvumi: 64bit value for seconds_since1970
Date: Fri, 30 Oct 2015 10:35:57 +0100
Message-ID: <1446197757.16404.56.camel@suse.de>
References: <20151030091110.GA3880@tina-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47288 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758993AbbJ3Jf7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 05:35:59 -0400
In-Reply-To: <20151030091110.GA3880@tina-laptop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tina Ruchandani <ruchandani.tina@gmail.com>, linux-scsi@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, y2038@lists.linaro.org

On Fri, 2015-10-30 at 02:11 -0700, Tina Ruchandani wrote:
> struct mvumi_hs_page2 stores a "seconds_since1970" field which is of
> type u64. It is however, written to, using 'struct timeval' which has
> a 32-bit seconds field and whose value will overflow in year 2038.
> This patch uses ktime_get_real_seconds() instead since it provides a
> 64-bit seconds value, which is 2038 safe.
>=20
> Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

> ---
> =C2=A0drivers/scsi/mvumi.c | 10 +++++-----
> =C2=A01 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 3e6b866..02360de 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
> @@ -31,6 +31,7 @@
> =C2=A0#include <linux/spinlock.h>
> =C2=A0#include <linux/interrupt.h>
> =C2=A0#include <linux/delay.h>
> +#include <linux/ktime.h>
> =C2=A0#include <linux/blkdev.h>
> =C2=A0#include <linux/io.h>
> =C2=A0#include <scsi/scsi.h>
> @@ -858,8 +859,8 @@ static void mvumi_hs_build_page(struct mvumi_hba
> *mhba,
> =C2=A0	struct mvumi_hs_page2 *hs_page2;
> =C2=A0	struct mvumi_hs_page4 *hs_page4;
> =C2=A0	struct mvumi_hs_page3 *hs_page3;
> -	struct timeval time;
> -	unsigned int local_time;
> +	u64 time;
> +	u64 local_time;
> =C2=A0
> =C2=A0	switch (hs_header->page_code) {
> =C2=A0	case HS_PAGE_HOST_INFO:
> @@ -877,9 +878,8 @@ static void mvumi_hs_build_page(struct mvumi_hba
> *mhba,
> =C2=A0		hs_page2->slot_number =3D 0;
> =C2=A0		hs_page2->intr_level =3D 0;
> =C2=A0		hs_page2->intr_vector =3D 0;
> -		do_gettimeofday(&time);
> -		local_time =3D (unsigned int) (time.tv_sec -
> -						(sys_tz.tz_minuteswe
> st * 60));
> +		time =3D ktime_get_real_seconds();
> +		local_time =3D (time - (sys_tz.tz_minuteswest * 60));
> =C2=A0		hs_page2->seconds_since1970 =3D local_time;
> =C2=A0		hs_header->checksum =3D
> mvumi_calculate_checksum(hs_header,
> =C2=A0						hs_header-
> >frame_length);

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
