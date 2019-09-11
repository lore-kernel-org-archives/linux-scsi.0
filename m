Return-Path: <SRS0=uqxd=XG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99FECC49ED6
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 10:56:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6209E21479
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 10:56:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ISJZK7p7";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="v6F6r6XM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfIKK4x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Sep 2019 06:56:53 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:17552 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726724AbfIKK4w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Sep 2019 06:56:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1568199412; x=1599735412;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sUFy62V12BwpeA+iJe293nD+g2KS8NuuSG9P6NFcZO0=;
  b=ISJZK7p7vNzIQTEj9hRL5LbCMtvoWn3rFobb1LEPBap83dpu77ccwuTf
   vp7De3lB45pYHF6rmWt4RPmY2En16N84BpgjVoDdmPOWaptnZNF6oDx1P
   VV/5ZFjs5SUfY1SWsKDk9BeSH4+HuqsakQzBrZlJSwQnfx9UZLUltRMtr
   oIUMtuZdrJ/lGOXDEvf/z8W42/CxjiWFygRePBBj12Yxu6NdUHeJvVPWj
   O1TEKZiykdIuS5sNZxdJe3NN0stXDigCl3sVFq76fDObul/02fy3Nw9pr
   CaAu+ktpGQUIqMPEx81ElBBWJ6HyWnmQUann+G69Gi889dEyR3qiu08Zv
   g==;
IronPort-SDR: M7rB/e8fbVJlyXkSLoKIMZE6yVrKAvvSZ1w+XI5bUE20j2M0l6QhHdqBJ7YYyjg2Br5W/kpO+z
 NwrnADxNRJxFKxLQ0gjL8SEFLxmMTxhy44oqS7pc40tYCaqgXtF4BXTdiUp+drq/+5OjDWadK6
 zMg75+UyX2Nz8XBPHWJOJkfYCmI10tdSRH96GGrM5zRREtxJY+oVen6T4ANQUHY2IR1v+zugMX
 ezbZaG7sX+FqC+weH0NEuvuJ/7Ffqud3Bl+YJmHyBzGwJn6rt0YrMp3e7nIkxIYAVz83kUimXS
 xaU=
X-IronPort-AV: E=Sophos;i="5.64,493,1559491200"; 
   d="scan'208";a="118859565"
Received: from mail-dm3nam03lp2051.outbound.protection.outlook.com (HELO NAM03-DM3-obe.outbound.protection.outlook.com) ([104.47.41.51])
  by ob1.hgst.iphmx.com with ESMTP; 11 Sep 2019 18:56:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cZ9XdsRo2Zh3t4ZxM1VZJboCZfTKi2qMltLs+IDbuq0A/y1PBg9/aoQbsV6PNhXBKS0P2Xb2F9Gr0sHY4nH4p7qQmvP9EPE6ycWRPfLfzMst+Nz4qjS28K1xfBmB/Vb5z7JKlJbQ16RHeqW2YWt9Xx14+GFW4ZtEExd5Mq3tBKZnm4Zbya4rlAM3fgkUSVUzpuIZcoKAOpqZmL9wA79Vr5ZAHH6/ri3oAhwwE1KQDVV9kuCQo8fCr5DvVFfTXsmVite/9q2bd/WWX+7fypHcIyxicnUQZus9fJytkP4ngBES5h+Tcsza4gFjXJDtQLxEk6Chf3MtWTeDJB23uSIjuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rbxjv8MXFBnD9UmmcyNeYuu7BaY377X3li+Ke/Q3Nms=;
 b=JJTi9hyco/6tYNol88U+nE4egiKeGBpSUegDbnpal7ysv7Wmn3zlx108n4j2D6w/5kWq9DELR5RkaRf8a5/HyQi59muVFzxSdMqZ+nyo/YdlhImYpnQM5hm25KuTSE/C776B5OvNb11CyCsi7AzOg+ZpoC/Gg4oC6czlNenBmme5ykgQRhpPWVH37KgfG+Ro1lb5G48/bbqm4IwCAs7JHQ/JhVglFvMrj7h+zDDVHm5ogR9c//R9FmHFylmrlzgNw0dR/txkwZaut35B7ZRo/jPcdh/GS9aWsOg29KFm2MxvRDZBlZtQTD3p+FH2ZwRRgZLSd0rOD12wxaKdsWi5ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rbxjv8MXFBnD9UmmcyNeYuu7BaY377X3li+Ke/Q3Nms=;
 b=v6F6r6XMVDZBA11S9zYLLulc/PeBbvyleEsxw/kDIDp0EoXbdutYpzTVfa18BTWpTxZSsyS72l5WVly+ZQSQi2bKcxN2Z/iWGFx1dM29nXSYnLJIyuftEBDEPlO8F/Xx3LcTYS+Y1sqlvCymZ0BMdyM9ttui7rEwhQu9ThW9+uM=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6942.namprd04.prod.outlook.com (10.186.145.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Wed, 11 Sep 2019 10:56:48 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9c2b:ac1b:67b8:f371]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9c2b:ac1b:67b8:f371%2]) with mapi id 15.20.2241.018; Wed, 11 Sep 2019
 10:56:48 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
        "sthumma@codeaurora.org" <sthumma@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>
CC:     "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "evgreen@chromium.org" <evgreen@chromium.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "marc.w.gonzalez@free.fr" <marc.w.gonzalez@free.fr>,
        "subhashj@codeaurora.org" <subhashj@codeaurora.org>,
        "vivek.gautam@codeaurora.org" <vivek.gautam@codeaurora.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Subject: RE: [PATCH v1 2/3] scsi: ufs: override auto suspend tunables for ufs
Thread-Topic: [PATCH v1 2/3] scsi: ufs: override auto suspend tunables for ufs
Thread-Index: AQHVaIUfYjJD70fr/kKF3DSWp7K95acmTYpw
Date:   Wed, 11 Sep 2019 10:56:47 +0000
Message-ID: <MN2PR04MB6991D63EEF50367BE2CB062CFCB10@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1568194890-24439-1-git-send-email-stanley.chu@mediatek.com>
 <1568194890-24439-3-git-send-email-stanley.chu@mediatek.com>
In-Reply-To: <1568194890-24439-3-git-send-email-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7d85e6f-1c41-459d-0255-08d736a6be42
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB6942;
x-ms-traffictypediagnostic: MN2PR04MB6942:
x-microsoft-antispam-prvs: <MN2PR04MB69422C6623A01F93692E7EF7FCB10@MN2PR04MB6942.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(366004)(346002)(396003)(39860400002)(376002)(199004)(189003)(446003)(476003)(81166006)(81156014)(6116002)(3846002)(186003)(66556008)(66476007)(64756008)(66446008)(229853002)(76116006)(4326008)(86362001)(14444005)(8936002)(66066001)(7416002)(66946007)(8676002)(256004)(26005)(76176011)(55016002)(7736002)(11346002)(305945005)(316002)(53936002)(9686003)(7696005)(74316002)(71190400001)(52536014)(478600001)(486006)(71200400001)(5660300002)(110136005)(54906003)(99286004)(2201001)(6436002)(15650500001)(2906002)(33656002)(102836004)(6246003)(25786009)(2501003)(14454004)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6942;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: P/gEi7NLvroocXTSWjO3cu+yqj/OA/PON3sE+hqKO1qBm1Qiwqgn6m0qWuDrUV7unEuWjJGhjGY3GCsdDjI52QBdLcQyP06bWjA4suLd8N6fQmHvY6q4sGjEQZfNGe/fxTBBxcyTKQCtLCy+Tf42BJUPjgmoruAZLIFJPgMHeDFik6AF21HFUB6l17QIsaJf5jtVf0cYHcDeWiBkBKov2OuXTthqba55s3uCwdVJfabwPvhQKQUzlztJBxopuK49HhBmjhhxuz7W/PThuDM+QbeW0S7/3+wQ4lBobSCTKXgi1wN9DrJECHFvx1ZO7xk+DJegDKgbhC7fmiO3WBgFjrgE9uZuaLcpH6uNNmb8+Jkpb5LKKdm9I41FznqlXqdbMrUhd+6suSOErkihrAnfh6kPvTA6rJm0Bs7LOjOHjH0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7d85e6f-1c41-459d-0255-08d736a6be42
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 10:56:47.8721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FefgIR256x1G0769bJoc8dcHKSommTbfKQ4pYFC1pcKPb8awOwITJZz2UjuZMZAMEERGvMLs9eUY+uVQL5GVLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6942
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Rework from previous work by:
> Sujit Reddy Thumma <sthumma@codeaurora.org>
>=20
> Override auto suspend tunables for UFS device LUNs during initialization =
so
> as to efficiently manage background operations and the power consumption.
>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

> ---
>  drivers/scsi/ufs/ufshcd.c |  8 ++++++++  drivers/scsi/ufs/ufshcd.h | 10
> ++++++++++
>  2 files changed, 18 insertions(+)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 30b752c61b97..d253a018a73b 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -88,6 +88,9 @@
>  /* Interrupt aggregation default timeout, unit: 40us */
>  #define INT_AGGR_DEF_TO        0x02
>=20
> +/* default delay of autosuspend: 2000 ms */ #define
Typo?

> +RPM_AUTOSUSPEND_DELAY_MS 2000
> +
>  #define ufshcd_toggle_vreg(_dev, _vreg, _on)                           \
>         ({                                                              \
>                 int _ret;                                               \
> @@ -4612,9 +4615,14 @@ static int ufshcd_change_queue_depth(struct
> scsi_device *sdev, int depth)
>   */
>  static int ufshcd_slave_configure(struct scsi_device *sdev)  {
> +       struct ufs_hba *hba =3D shost_priv(sdev->host);
>         struct request_queue *q =3D sdev->request_queue;
>=20
>         blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
> +
> +       if (ufshcd_is_rpm_autosuspend_allowed(hba))
> +               sdev->rpm_autosuspend_delay =3D
> RPM_AUTOSUSPEND_DELAY_MS;
> +
>         return 0;
>  }
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index
> a43c7135f33d..99ea416519af 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -714,6 +714,12 @@ struct ufs_hba {
>          * the performance of ongoing read/write operations.
>          */
>  #define UFSHCD_CAP_KEEP_AUTO_BKOPS_ENABLED_EXCEPT_SUSPEND (1
> << 5)
> +       /*
> +        * This capability allows host controller driver to automatically
> +        * enable runtime power management by itself instead of waiting
> +        * for userspace to control the power management.
> +        */
> +#define UFSHCD_CAP_RPM_AUTOSUSPEND (1 << 6)
>=20
>         struct devfreq *devfreq;
>         struct ufs_clk_scaling clk_scaling; @@ -747,6 +753,10 @@ static i=
nline
> bool ufshcd_can_autobkops_during_suspend(struct ufs_hba *hba)  {
>         return hba->caps & UFSHCD_CAP_AUTO_BKOPS_SUSPEND;  }
> +static inline bool ufshcd_is_rpm_autosuspend_allowed(struct ufs_hba
> +*hba) {
> +       return hba->caps & UFSHCD_CAP_RPM_AUTOSUSPEND; }
>=20
>  static inline bool ufshcd_is_intr_aggr_allowed(struct ufs_hba *hba)  {
> --
> 2.18.0

