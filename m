Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A48C433E4
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:18:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FC5D206F0
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:18:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="FzjvKhrH";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="nEHgqjvF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbgGMISe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 04:18:34 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:52404 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbgGMISe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 04:18:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594628313; x=1626164313;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jc1bhuERftjmbLVt/DqjIVPGK/ExcQghh3ES/FTyAcg=;
  b=FzjvKhrHs3uLhlaoQnh3+72J0akWXgepsbtbOKWyC42fdKzKX1I6W1L0
   PSNj8mHHZy4egFbDnOEyIEE8+v22fhP4uCfxcRdKd+rEi4lJTSko44m/a
   31OVua6ZBcxJlqALjI/Wk4AXP66xNY3euw2pA5cB8IuCv4qeDU4dmufA6
   FDg+6jBmGLNorzYDmZb9D6fqyXBvv+jxjId6gvc9yG6uZUP4cz0G24m9F
   S893uoxbQc4+lKBPbE1Azoa9pJjSJ08DfXGJrUsPj3RZwJdmy0iHw0DF2
   xWAzeXl8wt0gIvP9wC+nx5gzgMX7uRfn12VydXfUDiQLgZsZSWE1VOuxd
   w==;
IronPort-SDR: 1sBQ4d3+A09npia2M/KSnsEz1tufTRsYU8pLMSzQFLh1Woi0M2glEPs70z8Bgr4s4+VoCdex21
 4683VuBTb96xq1zTABUfLM7SJ5RnT8TkdhhD1ulhyOYy1YIj49IC4KUXgV1QHZkZ5OEh2UjjgS
 ngvM3DeWdrT6INKZvsE3c+pvOYymLoOG9f7l5QGDDei/3XRagSF2ozW06C+TmUiFfZBUeuEjKK
 JsqiWHiTeXfr5b3B6R1XGDM2LPypr50tLP7Dc73EfhmchCXAX2zT9LeqJrL6e8qdhCkj4ZO0Ta
 Lj8=
X-IronPort-AV: E=Sophos;i="5.75,346,1589212800"; 
   d="scan'208";a="251556706"
Received: from mail-cys01nam02lp2058.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.58])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jul 2020 16:18:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PL1Q+g7IYlwMCKT+Gn5EsUPNL7rCa2aSfv+C+aJwoC8gusqMCCiz3KIejHRpJSB5ClbjGFNwLoh3LG6+r7PHSsUwXfiAgUWzTbaciYCzMnuAFMv/m/iwn8aqw3t63xHWDveLplSz2R6mu41XtXIsECXzeGDMXLqRIXVT3W1tQc7n5Me/ZLyHzMuMc3/KEEa7hgbCpjlI7GekJ4U2EM8vZ18ppq1z2p8pXVdRL9j220gDuaXhyodLUq5rqzsdcYucU7qJ7csRDpMkmt5D/kqj/bHoF4/dIl8OM17kirUEvh+gERHFRl6HXlHSglptz6PoL/5xz3rGt8HBZmMsIXtv/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S6v0HdCPIplJvV/vtvvj+X2Kqgnf5h5feS+F4rQb2KA=;
 b=lRJWT1RbaYX19+96EtEKCJUaY9BHlqoQL2M2Wv8QqBHtpJ4GDn1hPE9cuRx4gecx8mzjSaUH2dtQmkN1Ic7rtRb+VsYgOmiIEFIS/gT+fHkn4RWpzdlvZzUOTBotEeA8dsKkFrO3f0Q3fH8X+eaB/vIQLlScho1GXPbSaMLt6E3ADvPGxoXRUY/zvXBzwkLI9M6RX/+BiEOQcn1A+jI12q65hdsbQVo9qC74osfz5B+Y6hqzzGATlqVw4F/F5ylH7uc4hgrkjSLWEWgy9P4oHssp7KklWvr7TGXlgv+djphjzw1L2Cxp7iuH9jecZTDGupvkzukhJis/JrbSMaEoJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S6v0HdCPIplJvV/vtvvj+X2Kqgnf5h5feS+F4rQb2KA=;
 b=nEHgqjvFFj0vB5MZYBwbmCI9QVCOyATfNVkDkENlRGZCehSNxkkAVZq0UZsq0iustjH+yZut/rE8l8l9oGLNH6iRYyy7GhsNtsb/iMA38tLpSo1eU+m65khAdi3gjrqWVZagbC6yKMIA8PvRjOvnEP02xdb3ZEE2F5rpHXmel5Y=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5359.namprd04.prod.outlook.com (2603:10b6:805:104::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Mon, 13 Jul
 2020 08:18:29 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3174.025; Mon, 13 Jul 2020
 08:18:29 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "satyat@google.com" <satyat@google.com>
CC:     "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>
Subject: RE: [PATCH v3] scsi: ufs-mediatek: Add inline encryption support
Thread-Topic: [PATCH v3] scsi: ufs-mediatek: Add inline encryption support
Thread-Index: AQHWV+P/GyVh+1wGz06EBRk2amZ8p6kFLF0Q
Date:   Mon, 13 Jul 2020 08:18:29 +0000
Message-ID: <SN6PR04MB4640380F541EBDD2F5BC434EFC600@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200712003226.7593-1-stanley.chu@mediatek.com>
In-Reply-To: <20200712003226.7593-1-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d81fbc99-5c8d-44b6-a604-08d827055352
x-ms-traffictypediagnostic: SN6PR04MB5359:
x-microsoft-antispam-prvs: <SN6PR04MB5359E4BB4FA7DA1E8BD93FDCFC600@SN6PR04MB5359.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EGdfIPMl3g37UFEOw/8AzEAVx148yMF7z+cS0sV4iLP4DE8h+gRMvMv8yXCmlwlLwbHO7qEdt6K8hByuWUkYfWA9dhHRlBs4P0wZ/8kNZlhgZalMTRK3B5jXk2Vqdm6iGkOWhlbgNqt1KyDnnQrLQ8SNM1j/FgEsXp2+zn08TzZXbMGfr6LDclo9bihTHHkJwm7imAcyvTh2tyuxVjEhQd8O1iFFnn6+2tN/lbvo+U9K8C8GUZIaWhBAVtgErFLhXAJ8Kg19iJh/k67HBImQwsafMb0+XR2hsd3bJYDJgPmlYs5moMSofpdXdqCfVMzDu/m3hYPA3M1zbbp+Pw1piQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(366004)(136003)(396003)(39860400002)(5660300002)(33656002)(54906003)(110136005)(86362001)(8676002)(52536014)(71200400001)(66946007)(7696005)(26005)(64756008)(66556008)(76116006)(478600001)(66446008)(66476007)(186003)(4326008)(7416002)(316002)(2906002)(9686003)(83380400001)(6506007)(55016002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: PvB0Kx+k+6BGjnjZW4wVtYiNEb/0pWOiZbMoMLNYsLhijJZDW2YgjAmTR2GCXAwEzyolOy9gaNWRjSZdpg7VBqGasnEHVDFtkG89wCJH1Daxyjki/7VXAVr/aNrWJqDj2M2lVk+l215eK1r8DBYTc3jUJC+bKIHuCBFIdicVoPB5/NPK/6kRWvOI1FZkjYNbCXPNMZTQPndjtWXqZSqbktujnXsaFScxvX4Mdf/JVmSToZ25iTSp/WMfBs71Q+UBvqyWvMYcG+VQ6bPGKApuLgBDBlsXjKNCwfKOeETtZM7hplzA73mu14uiPqWcvpw5NpBd7nCPYepUrKZc1vQJ7dHGeVvCRImn6jFA5xqrtfbYyRk/Ws8flELQDCYYolRSrhvmxlZu/+8zk3WDS+nNCFJg50n8bcX4gY8dwddWCBKSzsbq/b/QHDlitV1DqY6rkdmC+bB5dM9sVgUWCs9tCi8/r4iFKAdiMTsi0uOMv8A=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d81fbc99-5c8d-44b6-a604-08d827055352
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2020 08:18:29.8310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AlM5b0ao84+NEuAgUIeKdQxx3NzbDY9iCzlRUf0UM4SWmlpZ9sj+jt7Z5A5KlhnRzA07Edhymvm28Q5m3OsiXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5359
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> Add inline encryption support to ufs-mediatek.
>=20
> The standards-compliant parts, such as querying the crypto capabilities
> and enabling crypto for individual UFS requests, are already handled by
> ufshcd-crypto.c, which itself is wired into the blk-crypto framework.
>=20
> However MediaTek UFS host requires a vendor-specific hce_enable operation
> to allow crypto-related registers being accessed normally in kernel.
> After this step, MediaTek UFS host can work as standard-compliant host
> for inline-encryption related functions.
>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

> ---
>  drivers/scsi/ufs/ufs-mediatek.c | 22 ++++++++++++++++++++++
>  drivers/scsi/ufs/ufs-mediatek.h |  1 +
>  2 files changed, 23 insertions(+)
>=20
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-media=
tek.c
> index ad929235c193..31af8b3d2b53 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -16,6 +16,7 @@
>  #include <linux/soc/mediatek/mtk_sip_svc.h>
>=20
>  #include "ufshcd.h"
> +#include "ufshcd-crypto.h"
>  #include "ufshcd-pltfrm.h"
>  #include "ufs_quirks.h"
>  #include "unipro.h"
> @@ -25,6 +26,9 @@
>         arm_smccc_smc(MTK_SIP_UFS_CONTROL, \
>                       cmd, val, 0, 0, 0, 0, 0, &(res))
>=20
> +#define ufs_mtk_crypto_ctrl(res, enable) \
> +       ufs_mtk_smc(UFS_MTK_SIP_CRYPTO_CTRL, enable, res)
> +
>  #define ufs_mtk_ref_clk_notify(on, res) \
>         ufs_mtk_smc(UFS_MTK_SIP_REF_CLK_NOTIFICATION, on, res)
>=20
> @@ -73,6 +77,18 @@ static void ufs_mtk_cfg_unipro_cg(struct ufs_hba *hba,
> bool enable)
>         }
>  }
>=20
> +static void ufs_mtk_crypto_enable(struct ufs_hba *hba)
> +{
> +       struct arm_smccc_res res;
> +
> +       ufs_mtk_crypto_ctrl(res, 1);
> +       if (res.a0) {
> +               dev_info(hba->dev, "%s: crypto enable failed, err: %lu\n"=
,
> +                        __func__, res.a0);
> +               hba->caps &=3D ~UFSHCD_CAP_CRYPTO;
> +       }
> +}
> +
>  static int ufs_mtk_hce_enable_notify(struct ufs_hba *hba,
>                                      enum ufs_notify_change_status status=
)
>  {
> @@ -83,6 +99,9 @@ static int ufs_mtk_hce_enable_notify(struct ufs_hba
> *hba,
>                         hba->vps->hba_enable_delay_us =3D 0;
>                 else
>                         hba->vps->hba_enable_delay_us =3D 600;
> +
> +               if (hba->caps & UFSHCD_CAP_CRYPTO)
> +                       ufs_mtk_crypto_enable(hba);
>         }
>=20
>         return 0;
> @@ -317,6 +336,9 @@ static int ufs_mtk_init(struct ufs_hba *hba)
>         /* Enable clock-gating */
>         hba->caps |=3D UFSHCD_CAP_CLK_GATING;
>=20
> +       /* Enable inline encryption */
> +       hba->caps |=3D UFSHCD_CAP_CRYPTO;
> +
>         /* Enable WriteBooster */
>         hba->caps |=3D UFSHCD_CAP_WB_EN;
>         hba->vps->wb_flush_threshold =3D UFS_WB_BUF_REMAIN_PERCENT(80);
> diff --git a/drivers/scsi/ufs/ufs-mediatek.h b/drivers/scsi/ufs/ufs-media=
tek.h
> index 6052ec105aba..8ed24d5fcff9 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.h
> +++ b/drivers/scsi/ufs/ufs-mediatek.h
> @@ -70,6 +70,7 @@ enum {
>   */
>  #define MTK_SIP_UFS_CONTROL               MTK_SIP_SMC_CMD(0x276)
>  #define UFS_MTK_SIP_DEVICE_RESET          BIT(1)
> +#define UFS_MTK_SIP_CRYPTO_CTRL           BIT(2)
>  #define UFS_MTK_SIP_REF_CLK_NOTIFICATION  BIT(3)
>=20
>  /*
> --
> 2.18.0
