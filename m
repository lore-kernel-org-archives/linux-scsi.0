Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC16BC43334
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jun 2022 02:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353846AbiFNCq3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jun 2022 22:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354037AbiFNCqG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2022 22:46:06 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5457156761
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 19:23:37 -0700 (PDT)
X-UUID: 64a5186461b0479599a7bb40375b90cf-20220614
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.6,REQID:1c58d216-c4a4-4d49-a1b3-7dfa5150de74,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACTI
        ON:release,TS:0
X-CID-META: VersionHash:b14ad71,CLOUDID:278452c5-c67b-4a73-9b18-726dd8f2eb58,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:0,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: 64a5186461b0479599a7bb40375b90cf-20220614
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 853539083; Tue, 14 Jun 2022 10:23:06 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Tue, 14 Jun 2022 10:23:06 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.3 via Frontend
 Transport; Tue, 14 Jun 2022 10:23:06 +0800
Message-ID: <c16ed22c8d23b9da65e3695dab70a03812851678.camel@mediatek.com>
Subject: Re: [PATCH v2 0/3] ufs: Fix a race between the interrupt handler
 and the reset handler
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        <linux-scsi@vger.kernel.org>
Date:   Tue, 14 Jun 2022 10:23:06 +0800
In-Reply-To: <20220613214442.212466-1-bvanassche@acm.org>
References: <20220613214442.212466-1-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

I am not sure if this series could solve the racing you met.
However this series looks good to me.

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>

On Mon, 2022-06-13 at 14:44 -0700, Bart Van Assche wrote:
> Hi Martin,
> 
> This patch series is version two of a fix between the UFS interrupt
> handler and
> reset handlers. Please consider this patch series for kernel v5.20.
> 
> Changes compared to v1:
> - Converted a single patch into three patches.
> - Modified patch 3/3 such that only cleared requests are completed.
> 
> Bart Van Assche (3):
>   scsi: ufs: Simplify ufshcd_clear_cmd()
>   scsi: ufs: Support clearing multiple commands at once
>   scsi: ufs: Fix a race between the interrupt handler and the reset
>     handler
> 
>  drivers/ufs/core/ufshcd.c | 76 ++++++++++++++++++++++++-------------
> --
>  1 file changed, 48 insertions(+), 28 deletions(-)
> 

