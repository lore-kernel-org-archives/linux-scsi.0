Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D53E4C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 01:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiGLBaf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 21:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiGLBac (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 21:30:32 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C82A8CCAD;
        Mon, 11 Jul 2022 18:30:31 -0700 (PDT)
X-UUID: 7c1e2cadbdf94a81bfb82760b5fcfd7e-20220712
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:8a358d3e-d566-40a1-9a4b-5bd7f0385827,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACTI
        ON:release,TS:0
X-CID-META: VersionHash:0f94e32,CLOUDID:61670264-0b3f-4b2c-b3a6-ed5c044366a0,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:0,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: 7c1e2cadbdf94a81bfb82760b5fcfd7e-20220712
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1987120554; Tue, 12 Jul 2022 09:30:25 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Tue, 12 Jul 2022 09:30:23 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 12 Jul 2022 09:30:23 +0800
Message-ID: <8c00f8c89b08ce108730d59afa00d3cc54cdcaa2.camel@mediatek.com>
Subject: Re: [PATCH 1/1] scsi: ufs: fix missing clk change notification on
 host reset
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Po-Wen Kao <powen.kao@mediatek.com>, <asutoshd@codeaurora.org>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     <wsd_upstream@mediatek.com>, <peter.wang@mediatek.com>,
        <alice.chao@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <mason.zhang@mediatek.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Date:   Tue, 12 Jul 2022 09:30:23 +0800
In-Reply-To: <20220711144224.17916-2-powen.kao@mediatek.com>
References: <20220711144224.17916-1-powen.kao@mediatek.com>
         <20220711144224.17916-2-powen.kao@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2022-07-11 at 22:42 +0800, Po-Wen Kao wrote:
> In ufshcd_host_reset_and_restore(), ufshcd_set_clk_freq() is called
> to scale clk rate. However, this did not call vops-
> >clk_scale_notify()
> to inform platform driver of clk change.
> 
> We propose to call on ufshcd_scale_clks() instead so that clk change
> can be properly handled.
> 
> Signed-off-by: Po-Wen Kao <powen.kao@mediatek.com>
> ---

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>

