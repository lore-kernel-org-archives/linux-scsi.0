Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F58C4708F
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 05:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03E6A611CA
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 05:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhEaFgd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 01:36:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31882 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbhEaFgc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 May 2021 01:36:32 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210531053451epoutp0298933ff01bc2813e367986855f07c608~ED-Ce-ki21309913099epoutp02z
        for <linux-scsi@vger.kernel.org>; Mon, 31 May 2021 05:34:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210531053451epoutp0298933ff01bc2813e367986855f07c608~ED-Ce-ki21309913099epoutp02z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1622439291;
        bh=7iMVZYTP459+AdihVez2bqJivAE8ytmHKaxhplD35Lg=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=Irj7Sfl2VDD7q/PUcRFylZb9BzfDiaqbsElkshQQyqK+DtXeclPoNh15QBWqPmijS
         TFEmScaIXBUaA5WY1Kdscifp6+R89Iecb0I1LcX8Vm+DJESPh7wpIz1tWCdO1VdiMj
         UwvLKUOpyZgiqLIPyXLQGdps6nDf3zEMz7Gv1OP0=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20210531053451epcas5p29d6ffa434bb9c8761c4060043ca936b8~ED-CGCrlg2144021440epcas5p2M;
        Mon, 31 May 2021 05:34:51 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EF.DE.09835.B7574B06; Mon, 31 May 2021 14:34:51 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20210531053159epcas5p209ae07d05a016789b341237d5e7984e5~ED8hfhJ3F0315703157epcas5p2I;
        Mon, 31 May 2021 05:31:59 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210531053159epsmtrp1683055e2e96a697e98433a24908fc287~ED8heenXs1369413694epsmtrp15;
        Mon, 31 May 2021 05:31:59 +0000 (GMT)
X-AuditID: b6c32a4b-7dfff7000000266b-36-60b4757b507a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        08.FF.08163.EC474B06; Mon, 31 May 2021 14:31:58 +0900 (KST)
Received: from alimakhtar02 (unknown [107.122.12.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210531053156epsmtip1bd0183378e5d8a18292b980318a447fd~ED8e4sAkk2734727347epsmtip1j;
        Mon, 31 May 2021 05:31:56 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Stanley Chu'" <stanley.chu@mediatek.com>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>
Cc:     <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <jonathan.hsu@mediatek.com>,
        <powen.kao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>
In-Reply-To: <20210531051757.11538-1-stanley.chu@mediatek.com>
Subject: RE: [PATCH v1] scsi: ufs-mediatek: Fix HCI version in some
 platforms
Date:   Mon, 31 May 2021 11:01:54 +0530
Message-ID: <03b601d755de$46968810$d3c39830$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQI9wCeNkvCo/PMq9FZTcGhmFBsQUAHY0XRXqiFz85A=
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsWy7bCmum516ZYEg0vnxS1apsxlt3j58yqb
        xf/zv9ktrt2az2ax6s0ONotFN7YxWdzo3M9qMX/ZfGaL7utAseXH/zFZbP30m9Xi7d3/LBZL
        t95kdOD1mLDoAKNHy8n9LB4fn95i8fi8Sc6j/UA3UwBrFJdNSmpOZllqkb5dAlfGiXPf2ApO
        C1W8vXCPqYFxAX8XIyeHhICJRNfZOYxdjFwcQgK7GSXO/V3GAuF8YpRYdmoTG4TzmVFi48Ym
        RpiW3ZM+Q7XsYpT4cLGNGSQhJPCSUeJRJ5jNJqArsWNxG1i3iMBsRomVd64wgTjMAo8ZJS7f
        vgxWxSlgJ/H/1AN2EFtYwF9i9q7fTCA2i4CqxJenLawgNq+ApUTX8TVsELagxMmZT1hAbGYB
        eYntb+cwQ5ykIPHz6TKwehEBK4mJSy8yQtSISxz92cMMslhC4ASHxKFtl6AaXCSeTL7CAmEL
        S7w6voUdwpaSeNnfBmRzANnZEj27jCHCNRJL5x2DKreXOHBlDgtICbOApsT6XfoQYVmJqafW
        MUGs5ZPo/f2ECSLOK7FjHoytKtH87irUGGmJid3drBMYlWYh+WwWks9mIflgFsK2BYwsqxgl
        UwuKc9NTi00LjPNSy/WKE3OLS/PS9ZLzczcxgtOYlvcOxkcPPugdYmTiYDzEKMHBrCTCe6Zi
        Y4IQb0piZVVqUX58UWlOavEhRmkOFiVx3hUPJycICaQnlqRmp6YWpBbBZJk4OKUamK4nLfvx
        44WFp/Pdg+nse5Uau91MQ3878hw+N+1zyrmrmdWSt3ine01+vlSy+69l+N1CSR+R6fPNb3Nx
        xxYUBf9c/HDF09MHZgnse71g+eOTRSr+R6LsDn79fu3y5UNHIvccZjBOvhpgfOzG1JA1m+4x
        cDw4aPv8mudPfSWr7XOfrdy5LH2BqcYbBk+pxd596+y+/FxxfsH23mNdaXrGMTVyH2rnnb2Q
        eP6VjMuuz4zxHgelWP7Hei9bG/opf3Fc9IF3N2YayN4sX/a+YoHoiYl8e5ZaXr8ebJ414fIK
        XYsZn3pXCi+5EWv7f3bawx6Xzreyv+wTgwVUAs/0/l0xPcDQKYPtKJtB45GK6Gs5DqvWKbEU
        ZyQaajEXFScCAHagyy7SAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsWy7bCSnO65ki0JBkueG1u0TJnLbvHy51U2
        i//nf7NbXLs1n81i1ZsdbBaLbmxjsrjRuZ/VYv6y+cwW3deBYsuP/2Oy2PrpN6vF27v/WSyW
        br3J6MDrMWHRAUaPlpP7WTw+Pr3F4vF5k5xH+4FupgDWKC6blNSczLLUIn27BK6ME+e+sRWc
        Fqp4e+EeUwPjAv4uRk4OCQETid2TPjN2MXJxCAnsYJTYu+o0I0RCWuL6xgnsELawxMp/z9kh
        ip4zSuy6e5sVJMEmoCuxY3EbG0hCRGA+o8T++7PAqpgFXjNKfN2yBaqln1Hi+InvbCAtnAJ2
        Ev9PPQCbKyzgK/H211UWEJtFQFXiy9MWsLG8ApYSXcfXsEHYghInZz4BquEAmqon0bYR7Dxm
        AXmJ7W/nMEOcpyDx8+kysFYRASuJiUsvQtWISxz92cM8gVF4FpJJsxAmzUIyaRaSjgWMLKsY
        JVMLinPTc4sNC4zyUsv1ihNzi0vz0vWS83M3MYKjUUtrB+OeVR/0DjEycTAeYpTgYFYS4T1T
        sTFBiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBqaWaOf5
        T8otm5/+n/p9SlBExqSOupQV2Y2JwlpXnorOWXFUIval9t0p+/eEbdQy/l8r6xFcp/Jia+gn
        +XnXqhw4Juf9clG+8nfWEcbT2u4OwmHCp1jfOvs897+Yyf7k0fTi22ylCw3K1lhX1MTv+yu2
        5/AUd9edC1hf803WsDx53/KhasrbpnvbDAVk85/u/x2SpeTNXyjExOTqyh+lvKqpJ4H/Ddvz
        PcIh3MuThH7/nhr/VadF7lnwxvPnn/0Nu/OK40Bu6OXkUgMLhS1eile2vNm0qoP/7Xqnkk3b
        H7zdmzLz4z7Vf/+ubatnMQutzEjV6VVVn5vgv3t3q9ghT6GvcS8/HjsT6Cy38Om+c7uUWIoz
        Eg21mIuKEwFsqPHFNQMAAA==
X-CMS-MailID: 20210531053159epcas5p209ae07d05a016789b341237d5e7984e5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20210531051803epcas5p4c0a997f3346da0a0a1190630ac64ba94
References: <CGME20210531051803epcas5p4c0a997f3346da0a0a1190630ac64ba94@epcas5p4.samsung.com>
        <20210531051757.11538-1-stanley.chu@mediatek.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Stanley,

> -----Original Message-----
> From: Stanley Chu <stanley.chu@mediatek.com>
> Sent: 31 May 2021 10:48
> To: linux-scsi@vger.kernel.org; martin.petersen@oracle.com;
> avri.altman@wdc.com; alim.akhtar@samsung.com; jejb@linux.ibm.com
> Cc: peter.wang@mediatek.com; chun-hung.wu@mediatek.com;
> alice.chao@mediatek.com; jonathan.hsu@mediatek.com;
> powen.kao@mediatek.com; cc.chou@mediatek.com;
> chaotian.jing@mediatek.com; jiajie.hao@mediatek.com; Stanley Chu
> <stanley.chu@mediatek.com>
> Subject: [PATCH v1] scsi: ufs-mediatek: Fix HCI version in some platforms
> 
> Some MediaTek platforms have incorrect UFSHCI versions showed in register
> map. Fix the version by referring to UniPro version which is always
correct.
> 
A bit of extra details will help here, like say HCI version below 3.0 is
broken on some MediaTek SoC etc.
That will also help to understand if this was a deviation from HCI spec. 

> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---

With the updated commit message, feel free to add
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

>  drivers/scsi/ufs/ufs-mediatek.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c
b/drivers/scsi/ufs/ufs-mediatek.c
> index 9912e208c2a1..3d3605fd05b2 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -606,6 +606,16 @@ static void ufs_mtk_get_controller_version(struct
> ufs_hba *hba)
>  		if (ver >= UFS_UNIPRO_VER_1_8)
>  			host->hw_ver.major = 3;
>  	}
> +
> +	/* Fix HCI version for some platforms with incorrect version */
> +	if (hba->ufs_version < ufshci_version(3, 0) &&
> +	    host->hw_ver.major == 3)
> +		hba->ufs_version = ufshci_version(3, 0); }
> +
> +static u32 ufs_mtk_get_ufs_hci_version(struct ufs_hba *hba) {
> +	return hba->ufs_version;
>  }
> 
>  /**
> @@ -1042,6 +1052,7 @@ static void ufs_mtk_event_notify(struct ufs_hba
> *hba,  static const struct ufs_hba_variant_ops ufs_hba_mtk_vops = {
>  	.name                = "mediatek.ufshci",
>  	.init                = ufs_mtk_init,
> +	.get_ufs_hci_version = ufs_mtk_get_ufs_hci_version,
>  	.setup_clocks        = ufs_mtk_setup_clocks,
>  	.hce_enable_notify   = ufs_mtk_hce_enable_notify,
>  	.link_startup_notify = ufs_mtk_link_startup_notify,
> --
> 2.18.0


