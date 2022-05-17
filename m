Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EF38C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 06:50:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236440AbiEQGuU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 May 2022 02:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240651AbiEQGuC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2022 02:50:02 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A0A45523
        for <linux-scsi@vger.kernel.org>; Mon, 16 May 2022 23:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1652770167; x=1684306167;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VtGY5Y7DS5XbpoMVRtTiF5gV+fZtt6IWRm0s9/Gy310=;
  b=pGq0Baut9DZgwnlqv85Tvia+enieFXte9O5lf3XuJpSrrN7NTPjrsQTf
   Q9wblIkw93Q2HkfSTHFD5dkZHYf+QDe1zoB/uCh5I/Pe74dFiejNZtHNF
   la5E6fop8KBz2TeqDQ9SGr9Ov/UfxxciCPrnGB4fwPUb2c/mp2onw1JFA
   Snw3S2tEVgEhZyjC+Hh2clg8t7qaLQFlhmRFO9SnZBs+mvQdTI5IhoegV
   d6lam0zQ0Dg+Qn/wN0McMe4E/cj0+mgbKBilC2DuwPOwqMlbNXuyKuai6
   ZWQdUAS8l8x34DE3O+HR77D44mMgJJGsqwkG057/qQu1ojKGYWA/Q/Jcf
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,232,1647273600"; 
   d="scan'208";a="312507325"
Received: from mail-sn1anam02lp2049.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.49])
  by ob1.hgst.iphmx.com with ESMTP; 17 May 2022 14:49:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I6Q1UC+2t+6rkJFxfbCQ0aVRobBWvUmAezZmKJzIuWcHZMtY/REmCGaCujl2pc5pWleev+BGf0psJIHcuGRENA7b4Gj8pLMvZNvg87CAsiEdi1B3biUjiGDaq2P0IId+9IMTzemdJbD8nrxsB3b1LiuysDTEjuVTTdSFHNxZvtBhucDIiWjmDFozPjmX3e8rD7lTlJMxXz+QGV+8RfqrZ0Gd6zm9z+V3Q9K0xBMwgBjcXc0LI3e7MVMkSJD1lrSzkiQ6vqnmc5FpmLlVuYD7HukEcBWMT7TuKgceABXEkzuf4JhDsusrAxDLFhLClnoad5wwnssBZ5eGY8LbahfG9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SO2BxI2aKzGBoJ4lGqGTy0t1dBANYXqMwC2smbHOTMg=;
 b=CrPU5N4AGhY1jjXuVFSnPjZ3TpHUp13G/9T9aNsakgPex/82xmj5mdFeOoD5liO+JGOhE6SHuT6b2c18UvXocbucJtRlSEgM44u9ryWkseMJwh7twLihFwfwySUCqc2HDOJr8qG+kEkU1nY70AYvV2B9dYgtbAj/9A0PPpFXKtlJuQeH/vVdeCEUzpjSgq6TwJMSEB7N16K1yLGiTOCyy4QHE6k0RMWzUbMIowOnQH2xsAVdYQvbz/vCdpnqW/u1CtP1Sw5uiQF6+s5yzIA7KbLhVeg3LPn9Vo/bsjGoDESzKDbFRys6+gOQ0IM+Nb//gqGMytGgZyQG3hDNk617LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SO2BxI2aKzGBoJ4lGqGTy0t1dBANYXqMwC2smbHOTMg=;
 b=ffeABh5eOFRNFRS7oXFwSb9WHhGUoYyYx9MIbbpKmYVXOiK7Qi6hrfzc1nwB2OpTHuF05XHJpMM82/XK3pUIvdLgBXUMtNkQkEe2WlyWtRB1C35olmqKVemH8C2EuS10sfov0ZK8UeAZbmhmVMAFg5pDZYZJC1dPw6sTlmyv6Yk=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SJ0PR04MB7166.namprd04.prod.outlook.com (2603:10b6:a03:29f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 06:49:23 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::cc4e:5a1e:e4a:e3fb]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::cc4e:5a1e:e4a:e3fb%3]) with mapi id 15.20.5273.013; Tue, 17 May 2022
 06:49:23 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "wsd_upstream@mediatek.com" <wsd_upstream@mediatek.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "alice.chao@mediatek.com" <alice.chao@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "jiajie.hao@mediatek.com" <jiajie.hao@mediatek.com>,
        "powen.kao@mediatek.com" <powen.kao@mediatek.com>,
        "qilin.tan@mediatek.com" <qilin.tan@mediatek.com>,
        "lin.gui@mediatek.com" <lin.gui@mediatek.com>,
        "eddie.huang@mediatek.com" <eddie.huang@mediatek.com>,
        "tun-yu.yu@mediatek.com" <tun-yu.yu@mediatek.com>
Subject: RE: [PATCH v1] scsi: ufs-mediatek: introduce new UFS4.0 HS-G5 mode
Thread-Topic: [PATCH v1] scsi: ufs-mediatek: introduce new UFS4.0 HS-G5 mode
Thread-Index: AQHYZggwx0NPiDCjwk+CeS3yoMMIL60ikeXg
Date:   Tue, 17 May 2022 06:49:23 +0000
Message-ID: <DM6PR04MB6575493B52D07E45947BF3C1FCCE9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220512135654.3656-1-peter.wang@mediatek.com>
In-Reply-To: <20220512135654.3656-1-peter.wang@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9931110-42f0-4b22-c6e9-08da37d1607e
x-ms-traffictypediagnostic: SJ0PR04MB7166:EE_
x-microsoft-antispam-prvs: <SJ0PR04MB7166286AC2BD87924C35A40EFCCE9@SJ0PR04MB7166.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vOdz74tj9OulKbnxrt61UDU4uPf63vL4oD4DHeIaLhz0l/v4BYfg+rOynU85TFuHdaWNlSQfPjcT/sBTvvpogA++4kQxu/MBh1Rud28kL7523sdVG96LIaRpaHLNZ+dYFtCP+hbraRr7wCBkBO+XgSgfymTdkpKWpc5o3JTdqLteX3kooM0FztKdp00HrXb3+Umkc3+JX6r+bHbyBNAE+jeSHjsWbWQp6DZ7O1ZlTfzlJstklgtxTwSYCFGaFBn4hyfSMnvneNsdmqoKhMuAvfUQH6zS7CWVtcMbtHSK85Lg/zF1J9UVXR5ULGLrKZvVk41IlTv1dl6UMIxMGrtLMvPrNL4RapOU01YkxiUCMHrHiILSM8mjBkTjKUxZlsn9/ommgLyzduqNIXWDKtSMMxeFlsGvtIbQIzGxDuJMjBwaGt6gFz/0fIaYG/O28N92y7lBuqla/04o5WWmqv2oTIkF38Nc81LOUWxObdMdUb/5J2Z7PX9SHmjfN8DjK+485gbi5jFm5jiVufdyCHuKdSQIFR9k4NVm6+vS2u/lpI9Wh2SkM5xYXV186413A9kkzzSs9k0lEamhrxbJD6yycbNU8gSwQyp/Ex51LJvDN7lUsVcgDRqOoLC5NZH0FLu0FCsYPRKyLORgiAqSuw0Z/nscif4mDRgj6bD5dVAvcMfj1SqcpfM/gZKWf6DLKVd0eqE0hk6zbZCK58oy/2T2TQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(33656002)(82960400001)(4326008)(508600001)(110136005)(55016003)(71200400001)(64756008)(66556008)(66446008)(76116006)(66946007)(54906003)(66476007)(7696005)(9686003)(6506007)(8676002)(122000001)(2906002)(86362001)(186003)(26005)(8936002)(316002)(83380400001)(7416002)(5660300002)(38070700005)(38100700002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?p/Hvx8mF5tonOXVnGDfelFRgrMGu5Vca++FavmD/HITwmztgnZN7wzJX5Mf+?=
 =?us-ascii?Q?L4Fwf0qK7nFymBCbxE/KEU7vh7qNt1ZWNYFseFyLVlZQ08EIUCAYieX6JMbD?=
 =?us-ascii?Q?qARmgx0qP+ju6wHHD4U8pBJlDu2+dbFTovvviXFjTnub+6LCIf3AmXPnl6O5?=
 =?us-ascii?Q?Kp0GSf0bevrDP9l33OzuzZHwLGZ7AEUs2EC1JpSHNvgJ2qT5OASDcAgTDJXg?=
 =?us-ascii?Q?5+0p02vbUStFX4HTxmk2E7IAUQ1YhtBwX93DWqEzT7l5RNVxllvbPhBecti6?=
 =?us-ascii?Q?EuIwopgkEyKA9tx31iTmMN/xbo12qMt3MeJbjHPDtjrhUa4vC53+eGO/PHgk?=
 =?us-ascii?Q?WI4YpaunyoE+1ONgWgFeSBBnUx8easgKwh/UM99jsRgzJ1wdVeVRz8Sjd8ue?=
 =?us-ascii?Q?f7K63edG9KVnhb0okNnKJY0HB/2Fq1XLHUlG58lllYkGBF9vEq9tZDChqhcZ?=
 =?us-ascii?Q?a+Lq962Tn0J0UZ2OdvXXxjLVOO+cpUO96G5oz6s+oI+1Hg74qXovCm69kewE?=
 =?us-ascii?Q?fvhdo21ADaFiune4I88N/RmUMc7+M8YXs/9PE4cbGq6oyEN7t5YxyPvap2Fa?=
 =?us-ascii?Q?d6f7BYfgHw7peHywd9PUhce7kXZGgdQIsRMTbj/lCVyYc1ErlB5PRpM0klzH?=
 =?us-ascii?Q?gmPgFKalMbrKdtbZlNIHTUBhanJvc/OI+Pej5lzRcdejaKHleI6xJgURMxvG?=
 =?us-ascii?Q?0+HTCnDoSUdjEDpv7MjkbU3f0RWc+xMI17c/yzooFfR2oA2W1MASnOX8u73a?=
 =?us-ascii?Q?Dwq6vrGbJcoOGJQ1bjPMaD98C15I22Eo3Kd4l6ZcdBofrfRhmKmZLp0GBkGS?=
 =?us-ascii?Q?o2hU6BoF26p5FqJkR5NwfVqkQr/4FO/Bgml2tk8Y6VigRzwAS7dAnuQdDotp?=
 =?us-ascii?Q?+trKMd5Gex3VYHIWorie2vmAUA000OOcmjzGGVrA2sZYEFKXWzXf3HIUJQHL?=
 =?us-ascii?Q?td8hB3Qym97ghxEf1nQGKDCXpmep8vrZyA7D/zIZwq48TWMjvLvCQarPWu7w?=
 =?us-ascii?Q?6BfXfIpe0RD2rUzBsrvKdDDgKgRI47F9UpQumtHCInnLuE8+IA6txNyZWo2C?=
 =?us-ascii?Q?3biUr/Awq2HKQgdIt81XTDYVSf0iXT5o5t+NdRgua5IsmkjdjWhSYYv9V/b7?=
 =?us-ascii?Q?F722DQoTJrHvTJHyxm+YhSt4DPJyBPLofepUGSdpqNQ37rxBvv2w5dWbvzT8?=
 =?us-ascii?Q?GRvE++GksKHQ26wczdh7BzKDV1vwJA3rdaobMBIUQhmIKF4NFNfMdKkHKnT5?=
 =?us-ascii?Q?+onlOgYNtQ5IHDgjRV1O3WM9PSz42GovT438nmGNCMLOd/i7HFmjY29a47+v?=
 =?us-ascii?Q?MUALw5F8F4y8dJeBzE+7k3HhM9fIdlHke/W2ZnWFFS8O2+lIYidPfPQC+d5/?=
 =?us-ascii?Q?+TMh/pO1qM7vfg2hY7Pwz7evWaGtuCCAoH5d5JTvmR3l55kdp0vQ/2z2+KRO?=
 =?us-ascii?Q?GyEoyaFMqAJAo+dSGN9sIZvMrEnbsamDPZcXVtxDtiuyLqbEU63TrgHqidUt?=
 =?us-ascii?Q?5F5GF1RR4tLNjY5BZZWmcP4ZwB7wgEEGJsbPE2O+xJ2oo7GTS/Go9xXTgrOZ?=
 =?us-ascii?Q?DVIZU4TfpEpGXxM43UdofYk++q2EMFSdLkd7WthjdGmZCaUshLKQPEN6zenp?=
 =?us-ascii?Q?NN+tOcivo4lUUHdAczoVE7UlpnbcYs9U6NcJ739nVM7sLfoxOaHu6Kq2I1nP?=
 =?us-ascii?Q?9TTB8UuopcHpR0dmDHjTTHOw9bkHvYKj8o/LmaLKsAUlUnqBhe2Hb6WSoYC8?=
 =?us-ascii?Q?weJXQ5w3Nw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9931110-42f0-4b22-c6e9-08da37d1607e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2022 06:49:23.2804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4ZjT4PM7nUm9z2iY8i4S91eMP5TWJh2/IQrDRQic2SBbaN0GXsXBd3oXMgV0vw6KFnkTn+HHR9B01zGZOD2vxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7166
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,
=20
> From: Peter Wang <peter.wang@mediatek.com>
>=20
> Per UFS4.0 spec, HS-G5 is a new speed mode.
> This patch introduce HS-G5 speed mode to mediatek.
> Also add a host cap for power mode change via fastauto.
Maybe better to wait a week or 2 to let Martin pick Bart's Split of the ufs=
 directory ?

>=20
> Co-Developed-by: CC Chou <cc.chou@mediatek.com>
> Signed-off-by: CC Chou <cc.chou@mediatek.com>
> Co-Developed-by: Eddie Huang <eddie.huang@mediatek.com>
> Signed-off-by: Eddie Huang <eddie.huang@mediatek.com>
> Co-Developed-by: Dennis Yu <tun-yu.yu@mediatek.com>
> Signed-off-by: Dennis Yu <tun-yu.yu@mediatek.com>
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
I think the signed-of-by suffices, not need the co-developed duplication?

> ---
>  drivers/scsi/ufs/ufs-mediatek.c | 60 +++++++++++++++++++++++++++++++--
> drivers/scsi/ufs/ufs-mediatek.h |  1 +
>  drivers/scsi/ufs/ufshcd.c       |  3 +-
>  drivers/scsi/ufs/ufshcd.h       |  1 +
>  drivers/scsi/ufs/unipro.h       |  4 ++-
>  5 files changed, 65 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-media=
tek.c
> index 86a938075f30..8f2a3b03d244 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -78,6 +78,13 @@ static bool ufs_mtk_is_broken_vcc(struct ufs_hba *hba)
>         return !!(host->caps & UFS_MTK_CAP_BROKEN_VCC);  }
>=20
> +static bool ufs_mtk_is_pmc_via_fastauto(struct ufs_hba *hba) {
> +       struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
> +
> +       return !!(host->caps & UFS_MTK_CAP_PMC_VIA_FASTAUTO); }
Not sure that !! are needed

> +
>  static void ufs_mtk_cfg_unipro_cg(struct ufs_hba *hba, bool enable)  {
>         u32 tmp;
> @@ -580,6 +587,9 @@ static void ufs_mtk_init_host_caps(struct ufs_hba *hb=
a)
>         if (of_property_read_bool(np, "mediatek,ufs-broken-vcc"))
>                 host->caps |=3D UFS_MTK_CAP_BROKEN_VCC;
>=20
> +       if (of_property_read_bool(np, "mediatek,ufs-pmc-via-fastauto"))
> +               host->caps |=3D UFS_MTK_CAP_PMC_VIA_FASTAUTO;
> +
>         dev_info(hba->dev, "caps: 0x%x", host->caps);  }
>=20
> @@ -755,6 +765,26 @@ static int ufs_mtk_init(struct ufs_hba *hba)
>         return err;
>  }
>=20
> +static bool ufs_mtk_pmc_via_fastauto(struct ufs_hba *hba,
> +       struct ufs_pa_layer_attr *dev_req_params) {
> +       if (!ufs_mtk_is_pmc_via_fastauto(hba))
> +               return false;
> +
> +       if (dev_req_params->hs_rate =3D=3D hba->pwr_info.hs_rate)
> +               return false;
> +
> +       if ((dev_req_params->pwr_tx !=3D FAST_MODE) &&
> +               (dev_req_params->gear_tx < UFS_HS_G4))
> +               return false;
> +
> +       if ((dev_req_params->pwr_rx !=3D FAST_MODE) &&
> +               (dev_req_params->gear_rx < UFS_HS_G4))
> +               return false;
> +
> +       return true;
> +}
> +
>  static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
>                                   struct ufs_pa_layer_attr *dev_max_param=
s,
>                                   struct ufs_pa_layer_attr *dev_req_param=
s) @@ -764,8
> +794,8 @@ static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
>         int ret;
>=20
>         ufshcd_init_pwr_dev_param(&host_cap);
> -       host_cap.hs_rx_gear =3D UFS_HS_G4;
> -       host_cap.hs_tx_gear =3D UFS_HS_G4;
> +       host_cap.hs_rx_gear =3D UFS_HS_G5;
> +       host_cap.hs_tx_gear =3D UFS_HS_G5;
>=20
>         ret =3D ufshcd_get_pwr_dev_param(&host_cap,
>                                        dev_max_params, @@ -775,6 +805,32 =
@@ static int
> ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
>                         __func__);
>         }
>=20
> +       if (ufs_mtk_pmc_via_fastauto(hba, dev_req_params)) {
> +               ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXTERMINATION), TRUE);
> +               ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXGEAR), UFS_HS_G1);
> +
> +               ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXTERMINATION), TRUE);
> +               ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXGEAR), UFS_HS_G1);
Other than setting G1 - all other are done anyway as part ufshcd_change_pow=
er_mode?
Maybe add instead an appropriate quirk and use it in ufshcd_change_power_mo=
de?
=20
> +
> +               ufshcd_dme_set(hba, UIC_ARG_MIB(PA_ACTIVETXDATALANES),
> +                                               dev_req_params->lane_tx);
> +               ufshcd_dme_set(hba, UIC_ARG_MIB(PA_ACTIVERXDATALANES),
> +                                               dev_req_params->lane_rx);
> +               ufshcd_dme_set(hba, UIC_ARG_MIB(PA_HSSERIES),
> +
> + dev_req_params->hs_rate);
> +
> +               ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXHSADAPTTYPE),
> +                    PA_NO_ADAPT);
> +
> +               ret =3D ufshcd_uic_change_pwr_mode(hba,
> +                       FASTAUTO_MODE << 4 | FASTAUTO_MODE);
> +
> +               if (ret) {
> +                       dev_err(hba->dev, "%s: HSG1B FASTAUTO failed ret=
=3D%d\n",
> +                               __func__, ret);
> +               }
> +       }
> +
>         if (host->hw_ver.major >=3D 3) {
>                 ret =3D ufshcd_dme_configure_adapt(hba,
>                                            dev_req_params->gear_tx, diff =
--git
> a/drivers/scsi/ufs/ufs-mediatek.h b/drivers/scsi/ufs/ufs-mediatek.h index
> 414dca86c09f..3a31f03f3cb1 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.h
> +++ b/drivers/scsi/ufs/ufs-mediatek.h
> @@ -108,6 +108,7 @@ enum ufs_mtk_host_caps {
>         UFS_MTK_CAP_VA09_PWR_CTRL              =3D 1 << 1,
>         UFS_MTK_CAP_DISABLE_AH8                =3D 1 << 2,
>         UFS_MTK_CAP_BROKEN_VCC                 =3D 1 << 3,
> +       UFS_MTK_CAP_PMC_VIA_FASTAUTO           =3D 1 << 4,
>  };
>=20
>  struct ufs_mtk_crypt_cfg {
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 3f9caafa91bf..e750011d0de7 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4076,7 +4076,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba,
> struct uic_command *cmd)
>   *
>   * Returns 0 on success, non-zero value on failure
>   */
> -static int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
> +int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
>  {
>         struct uic_command uic_cmd =3D {0};
>         int ret;
> @@ -4101,6 +4101,7 @@ static int ufshcd_uic_change_pwr_mode(struct
> ufs_hba *hba, u8 mode)
>  out:
>         return ret;
>  }
> +EXPORT_SYMBOL(ufshcd_uic_change_pwr_mode);
>=20
>  int ufshcd_link_recovery(struct ufs_hba *hba)  { diff --git
> a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index
> 94f545be183a..1cda0f211d72 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -1101,6 +1101,7 @@ extern int ufshcd_dme_set_attr(struct ufs_hba *hba,
> u32 attr_sel,
>                                u8 attr_set, u32 mib_val, u8 peer);  exter=
n int
> ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
>                                u32 *mib_val, u8 peer);
> +extern int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode);
>  extern int ufshcd_config_pwr_mode(struct ufs_hba *hba,
>                         struct ufs_pa_layer_attr *desired_pwr_mode);
>=20
> diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h index
> 8e9e486a4f7b..94d97f123e3a 100644
> --- a/drivers/scsi/ufs/unipro.h
> +++ b/drivers/scsi/ufs/unipro.h
> @@ -231,6 +231,7 @@ enum ufs_hs_gear_tag {
>         UFS_HS_G2,              /* HS Gear 2 */
>         UFS_HS_G3,              /* HS Gear 3 */
>         UFS_HS_G4,              /* HS Gear 4 */
> +       UFS_HS_G5,              /* HS Gear 5 */
>  };
>=20
>  enum ufs_unipro_ver {
> @@ -240,7 +241,8 @@ enum ufs_unipro_ver {
>         UFS_UNIPRO_VER_1_6  =3D 3, /* UniPro version 1.6 */
>         UFS_UNIPRO_VER_1_61 =3D 4, /* UniPro version 1.61 */
>         UFS_UNIPRO_VER_1_8  =3D 5, /* UniPro version 1.8 */
> -       UFS_UNIPRO_VER_MAX  =3D 6, /* UniPro unsupported version */
> +       UFS_UNIPRO_VER_2_0  =3D 6, /* UniPro version 2.0 */
Maybe use it now in ufs_mtk_get_controller_version to set host->hw_ver.majo=
r =3D 4?

Thanks,
Avri

> +       UFS_UNIPRO_VER_MAX  =3D 7, /* UniPro unsupported version */
>         /* UniPro version field mask in PA_LOCALVERINFO */
>         UFS_UNIPRO_VER_MASK =3D 0xF,
>  };
> --
> 2.18.0

