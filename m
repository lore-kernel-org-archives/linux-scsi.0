Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE13C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 11:08:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80E96613D3
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 11:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhJTLHF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 07:07:05 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:48380 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230029AbhJTLHE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 07:07:04 -0400
X-UUID: ce69122baba64e8dbf72e8e6e9dd1c21-20211020
X-UUID: ce69122baba64e8dbf72e8e6e9dd1c21-20211020
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 719726207; Wed, 20 Oct 2021 19:04:47 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Wed, 20 Oct 2021 19:04:46 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 20 Oct 2021 19:04:44 +0800
Message-ID: <b20bd855eb2ec7aab66dd0026fbda8e6625b30ef.camel@mediatek.com>
Subject: Re: [PATCH] scsi: ufs: mediatek: avoid sched_clock() misuse
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Arnd Bergmann <arnd@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Arnd Bergmann <arnd@arndb.de>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "Avri Altman" <avri.altman@wdc.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Bean Huo" <beanhuo@micron.com>,
        Peter Wang <peter.wang@mediatek.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Date:   Wed, 20 Oct 2021 19:04:44 +0800
In-Reply-To: <20211018132022.2281589-1-arnd@kernel.org>
References: <20211018132022.2281589-1-arnd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Arnd,

On Mon, 2021-10-18 at 15:20 +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> sched_clock() is not meant to be used in portable driver code,
> and assuming a particular clock frequency is not how this is
> meant to be used. It also causes a build failure because of
> a missing header inclusion:
> 
> drivers/scsi/ufs/ufs-mediatek.c:321:12: error: implicit declaration
> of function 'sched_clock' [-Werror,-Wimplicit-function-declaration]
>         timeout = sched_clock() + retry_ms * 1000000UL;
> 
> A better interface to use here ktime_get_mono_fast_ns(), which
> works mostly like ktime_get() but is safe to use inside of a
> suspend callback.
> 
> Fixes: 9561f58442e4 ("scsi: ufs: mediatek: Support vops pre suspend
> to disable auto-hibern8")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/scsi/ufs/ufs-mediatek.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-
> mediatek.c
> index d1696db70ce8..a47241ed0a57 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -318,15 +318,15 @@ static void ufs_mtk_wait_idle_state(struct
> ufs_hba *hba,
>  	u32 val, sm;
>  	bool wait_idle;
>  
> -	timeout = sched_clock() + retry_ms * 1000000UL;
> -
> +	/* cannot use plain ktime_get() in suspend */
> +	timeout = ktime_get_mono_fast_ns() + retry_ms * 1000000UL;

Thanks for this fix.

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>

>  
>  	/* wait a specific time after check base */
>  	udelay(10);
>  	wait_idle = false;
>  
>  	do {
> -		time_checked = sched_clock();
> +		time_checked = ktime_get_mono_fast_ns();
>  		ufs_mtk_dbg_sel(hba);
>  		val = ufshcd_readl(hba, REG_UFS_PROBE);
>  

