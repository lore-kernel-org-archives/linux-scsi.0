Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F3BC4332F
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Nov 2021 06:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABD9161425
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Nov 2021 06:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234846AbhKGHCc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Nov 2021 02:02:32 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:48694 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229878AbhKGHCb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Nov 2021 02:02:31 -0500
X-UUID: 41249c9b85594ad6b30a38a94909b227-20211107
X-UUID: 41249c9b85594ad6b30a38a94909b227-20211107
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1645556500; Sun, 07 Nov 2021 14:59:46 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Sun, 7 Nov 2021 14:59:45 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkmbs10n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.3 via Frontend
 Transport; Sun, 7 Nov 2021 14:59:45 +0800
Message-ID: <7d4f5762d3df2742ebb32d2feb586be2ccb46b20.camel@mediatek.com>
Subject: Re: [PATCH] scsi: ufs: Improve SCSI abort handling
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James Bottomley" <James.Bottomley@HansenPartnership.com>,
        Vinayak Holikatti <vinholikatti@gmail.com>,
        Vishak G <vishak.g@samsung.com>,
        Girish K S <girish.shivananjappa@linaro.org>,
        Santosh Yaraganavi <santoshsy@gmail.com>
Date:   Sun, 7 Nov 2021 14:59:45 +0800
In-Reply-To: <20211104181059.4129537-1-bvanassche@acm.org>
References: <20211104181059.4129537-1-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On Thu, 2021-11-04 at 11:10 -0700, Bart Van Assche wrote:
> The following has been observed on a test setup:
> 
> WARNING: CPU: 4 PID: 250 at drivers/scsi/ufs/ufshcd.c:2737
> ufshcd_queuecommand+0x468/0x65c
> Call trace:
>  ufshcd_queuecommand+0x468/0x65c
>  scsi_send_eh_cmnd+0x224/0x6a0
>  scsi_eh_test_devices+0x248/0x418
>  scsi_eh_ready_devs+0xc34/0xe58
>  scsi_error_handler+0x204/0x80c
>  kthread+0x150/0x1b4
>  ret_from_fork+0x10/0x30
> 
> That warning is triggered by the following statement:
> 
> 	WARN_ON(lrbp->cmd);
> 
> Fix this warning by clearing lrbp->cmd from the abort handler.
> 
> Fixes: 7a3e97b0dc4b ("[SCSI] ufshcd: UFS Host controller driver")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 3b4a714e2f68..d8a59258b1dc 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7069,6 +7069,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  		goto release;
>  	}
>  
> +	lrbp->cmd = NULL;
>  	err = SUCCESS;
>  
>  release:

Thanks for this patch! We are looking at the same issue as well
recently.

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>



