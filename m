Return-Path: <SRS0=+Wsi=7M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF15C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 20:38:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 642992074A
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 20:38:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NILCm+8u";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="BnEyiUqW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729006AbgE3UiE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 May 2020 16:38:04 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:28395 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgE3UiD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 May 2020 16:38:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1590871104; x=1622407104;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8BiLFCBkL+XnOf1HHoA9Rc/8Hd0LDHzcqPI16UkgvG4=;
  b=NILCm+8u4jM5bnozUrDWZaANQX/aCH+7riBRp19OyVenwV0Zl7bKikt3
   5rxAHYs7Uvwo1KbjcIkdFUX6jF2Y8B/FQ17ktweliJq9scytpILEz7i+m
   KgylNykV+7gL0q9I1Mayg8d3kj8vw4EMTj5D7+cIgaKCJwPKCd1uU2eL5
   +fEM+0JWFiGfmYx052h+GnJq10pfuVnJtrQrW0ru8F6cN/kE7i0BPYlnJ
   iLRLlM+nL3fA8idOAw/pp67gF9mIAERgSBhlIblY4NaAdgp6mwtTeecSJ
   LJkxliy054v2gyJMI8EYQ0bGmIx03D0z1iKa0Up5tSp6SydUvTwfs8V6L
   A==;
IronPort-SDR: +6ysK6XMZGmn5u0X0ySNtEFyM7psZ0dkANh066O3sE32GNpCGDCT0NuhDg55ivHebT/euf/Kh5
 Woy8YGPP8w6PNIeXkugAMEG8ikK1m0+kHzUFqieq32FxtRmYkh/6uIplX6+TxrMV1Ovtun0Mgn
 FzGzQkCIAAqaumEaZs1NP1CXMruNtPiAO6BoXdz7nshnx7AbZdA2yK144hFtja+fTN8f5kJJ7Q
 ODYHlfy0S1NNOEzkAKwJtEIszTtId0UC6tP8M0Ixh2iuDrcY1PP/Cf2DBacYexaDLn7v8ZKfZX
 uV4=
X-IronPort-AV: E=Sophos;i="5.73,454,1583164800"; 
   d="scan'208";a="241707897"
Received: from mail-mw2nam10lp2103.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.103])
  by ob1.hgst.iphmx.com with ESMTP; 31 May 2020 04:38:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X82G0BBG6Q5bPVWSBnU0z6TxOgx6Z54dNlIqvLLvcszm6WfQPAcqGF3mhaOdkHZS7lUXeeC0EJHIDhm4DE9zxukGRu/fs8NLVdqefvp8dtLIaaC3hId75M3syVymC1BrKAy9zHRRyz0gGt9kWHF+sXGCYIGnvTIBzq2INH2zTHzVIGUUJb8AftCXKumzVy5ddGzHS88C0LeORky2UysOi6yhtOKN/F3RijUHNbowgrLwXEGNGXantatD/kUHsl1QI8HkfYvYWeVV/xxef5XqR5GKs0/EspuVHKD+fbZzZhXtKyY0VFjdy5aESgWir5T4F+ccr5PgOoKxfi8bul5vVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wpfgxi24WL33phAyME1DCOrxSIyIK4rqeaSdrztVxaU=;
 b=Qh8Ok93NLYpU2CmbeiQdwXAOLylBBCID6fEuHljR1JjCJPlQc80bZc1qFMnXeqj7i3aTsbZeHdfiZ7LfJSbSzApxn2/eMLYwNyJWxeqkTQAQ7RqPc54hEEtFzGexKcdhByHsj/tpybAjriYoBO9ts91AyZi3WxGq3WKZTw4hYr3oxo5N7MdG6NhyM1HgXdbWXrVlb6WXB19EXMcf+GgBme2itKgde0KWvEUOwRPAQWK2BytlhS5HayZOBPZnJ2dZHbXBnn7MJQKyBmgKrZN3K0e5Cl4lU0AjQ9LUnTsL2mGU4aFhbFbZkhdCj5EQRwlrHirdCsGsSPMCX31QlzB5oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wpfgxi24WL33phAyME1DCOrxSIyIK4rqeaSdrztVxaU=;
 b=BnEyiUqWdDQjJ9pZey90rVVRCjV9AbKcSpgKfwX3jMWCD99fjK9dxLlrPfDe8cQRWz1s8P1zT/bCjJKoJzx66uRky5jD9dM81cwZUgwK0VK3p+hNlwiYTyiHPcJcTZ+wEKoJYAvAgv5mUrPPlbjUEudg0MmBaAMunXXnBDalBwQ=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5070.namprd04.prod.outlook.com (2603:10b6:805:9e::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Sat, 30 May
 2020 20:37:57 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3045.022; Sat, 30 May 2020
 20:37:57 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>
Subject: RE: [PATCH v1 1/2] scsi: ufs: Support WriteBooster on Samsung UFS
 devices
Thread-Topic: [PATCH v1 1/2] scsi: ufs: Support WriteBooster on Samsung UFS
 devices
Thread-Index: AQHWNpT3Vi/TzAb5lEy8ZsLwGGZsRajBERRQ
Date:   Sat, 30 May 2020 20:37:57 +0000
Message-ID: <SN6PR04MB46400873245235EA56838A19FC8C0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200530151337.6182-1-stanley.chu@mediatek.com>
 <20200530151337.6182-2-stanley.chu@mediatek.com>
In-Reply-To: <20200530151337.6182-2-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4c2e3a2c-f906-40c1-a775-08d804d9563f
x-ms-traffictypediagnostic: SN6PR04MB5070:
x-microsoft-antispam-prvs: <SN6PR04MB5070F195D45B3FCCEF891F28FC8C0@SN6PR04MB5070.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:849;
x-forefront-prvs: 041963B986
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W7GcxjGCtRJBa1XIp/vDvJTIP+J3RfdskcI60PJkzFDakJ2Uej0X8fplgIWvxmJCx23DGYBe+GQ4t2XG67Co3w11jo14j97XwFvIV8R3DwHBKe4kKs9fBD6PKovA0gSC3jOQvGAVadfRi8nz1MWkDVKMS74WC8m9a+ARPOHk5LC9sFMJaP5U4CCTFMFliWgwdFxjkdvM8mBrTTFDjk5kqxpmCmhRZkW0LFOGc3fLtgRvLTyX4Bnk2rzEzZ4lOJtwysNubcbETyLFig0U+X8cNRyjLQvJJOLaHG8vTs0MiXs4HXXEVsFU1CkfIETAkkxyytboXinxjFLhAzy007umDQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(6506007)(64756008)(4326008)(2906002)(110136005)(8936002)(86362001)(316002)(52536014)(66556008)(7696005)(71200400001)(54906003)(66446008)(8676002)(83380400001)(9686003)(478600001)(55016002)(33656002)(5660300002)(66946007)(76116006)(66476007)(7416002)(26005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: +ddPBFk3kPg+OjxiZnZ+01tLHj5p9X4r+b0rUV+Pir0STD1M482lN/5uOvVjC7m0mzmnvi4qt8ULYxDgYp4IWsMIu1Sp9Vo889QNYVJTA6mINCGHFPOWwjrvKuM3a2rT0CNqzxHpYltnHlpz2BtdlcclcLCc5vGO6syc551h33Vo9CqofRZi23nA4Va+bxPD8dpPdm7QB2FuCJtgRq34Oels9LUzFiucaXk87cKmUDDSM0PzyHy03Zn2JbQie2uxW9tudQr5JD+Wh1zSpLxOxhG/rb4sOKXiK5QWSaOYDeC1ZM64UeHGjmVEjWrZjGw7SX8+yxJsgejYiqwcLgs8dCwE/Hjzg6Dtg0mdbMR+ZPuneqdHXskdP0I/kgxwg0cIf3sI6l7pPk08lACkRNlx7EdoU+HmNx5fBeXusLWOFM0G+zlMYG6s0D0CrjXnYEM3ap5HnIwu/f26/gmp08RovWNxDRwZzfrmzHaydxXJkxQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c2e3a2c-f906-40c1-a775-08d804d9563f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2020 20:37:57.3202
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tz0fHFYpBGNYRh5tnggMOuaEq3CWXtGqLBtAjqBw6PC2Zu6d0sSyGMpYS9Nzh1umB9L8A0ZtMdp8dpDjZhPLGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5070
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> @@ -2801,11 +2801,17 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum
> query_opcode opcode,
>  {
>         struct ufs_query_req *request =3D NULL;
>         struct ufs_query_res *response =3D NULL;
> -       int err, selector =3D 0;
> +       int err;
>         int timeout =3D QUERY_REQ_TIMEOUT;
> +       u8 selector =3D 0;
>=20
>         BUG_ON(!hba);
>=20
> +       if (hba->dev_quirks & UFS_DEVICE_QUIRK_WB_SPECIAL_SELECTOR) {
> +               if (ufshcd_is_wb_flags(idn))
> +                       selector =3D 1;
> +       }
> +
Why not make the caller set the applicable selector,
Instead of checking this for every flag?

>         ufshcd_hold(hba, false);
>         mutex_lock(&hba->dev_cmd.lock);
>         ufshcd_init_query(hba, &request, &response, opcode, idn, index,
> @@ -2882,6 +2888,11 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum
> query_opcode opcode,
>                 goto out;
>         }
>=20
> +       if (hba->dev_quirks & UFS_DEVICE_QUIRK_WB_SPECIAL_SELECTOR) {
> +               if (ufshcd_is_wb_attrs(idn))
> +                       selector =3D 1;
> +       }
> +
Same here

>         mutex_lock(&hba->dev_cmd.lock);
>         ufshcd_init_query(hba, &request, &response, opcode, idn, index,
>                         selector);
> @@ -3042,6 +3053,11 @@ int ufshcd_query_descriptor_retry(struct ufs_hba
> *hba,
>         int err;
>         int retries;
>=20
> +       if (hba->dev_quirks & UFS_DEVICE_QUIRK_WB_SPECIAL_SELECTOR) {
> +               if (ufshcd_is_wb_desc(idn, index))
> +                       selector =3D 1;
> +       }
> +
And here.
But this can't be true -=20
Are you setting the selector =3D 1 for reading any field for those descript=
ors?
Shouldn't it be for the wb specific fields?
=20

>         for (retries =3D QUERY_REQ_RETRIES; retries > 0; retries--) {
>                 err =3D __ufshcd_query_descriptor(hba, opcode, idn, index=
,
>                                                 selector, desc_buf, buf_l=
en);
> @@ -6907,8 +6923,10 @@ static int ufs_get_device_desc(struct ufs_hba *hba=
)
>         size_t buff_len;
>         u8 model_index;
>         u8 *desc_buf;
> +       u8 retry_cnt =3D 0;
>         struct ufs_dev_info *dev_info =3D &hba->dev_info;
>=20
> +retry:
>         buff_len =3D max_t(size_t, hba->desc_size.dev_desc,
>                          QUERY_DESC_MAX_SIZE + 1);
>         desc_buf =3D kmalloc(buff_len, GFP_KERNEL);
> @@ -6948,6 +6966,29 @@ static int ufs_get_device_desc(struct ufs_hba *hba=
)
>=20
>         ufs_fixup_device_setup(hba);
>=20
> +       if (!retry_cnt && (hba->dev_quirks &
> +               UFS_DEVICE_QUIRK_WB_SPECIAL_SELECTOR)) {
If you only want to enter this clause once - you should use something other=
 than retry_cnt,
Which the reader expects to performs retries....

Also, this is becoming too wired -=20
From your commit log I get that for specific Samsung devices,
You need to query wb descriptor fields/attributes/flags using selectore =3D=
 1.
But what it has to do with descriptor sizes?

> +               /*
> +                * Update WriteBooster related descriptor length with spe=
cific
> +                * seletor used.
> +                */
> +               ufshcd_read_desc_length(hba, QUERY_DESC_IDN_DEVICE, 0,
> +                                       &hba->desc_size.dev_desc);
> +               ufshcd_read_desc_length(hba, QUERY_DESC_IDN_CONFIGURATION=
,
> 0,
> +                                       &hba->desc_size.conf_desc);
> +               ufshcd_read_desc_length(hba, QUERY_DESC_IDN_UNIT, 0,
> +                                       &hba->desc_size.unit_desc);
> +               ufshcd_read_desc_length(hba, QUERY_DESC_IDN_GEOMETRY, 0,
> +                                       &hba->desc_size.geom_desc);
> +               /*
> +                * Read device descriptor again with specific selector us=
ed to
> +                * get WriteBooster related fileds.
> +                */
> +               kfree(desc_buf);
> +               retry_cnt++;
> +               goto retry;
> +       }
> +
>         /*
>          * Probe WB only for UFS-3.1 devices or UFS devices with quirk
>          * UFS_DEVICE_QUIRK_SUPPORT_EXTENDED_FEATURES enabled
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index bf97d616e597..d850c47e8ae0 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -876,6 +876,26 @@ static inline u8 ufshcd_wb_get_query_index(struct
> ufs_hba *hba)
>         return 0;
>  }
>=20
> +static inline bool ufshcd_is_wb_attrs(enum attr_idn idn)
> +{
> +       return ((idn >=3D QUERY_ATTR_IDN_WB_FLUSH_STATUS) &&
> +               (idn <=3D QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE));
> +}
> +
> +static inline bool ufshcd_is_wb_desc(enum desc_idn idn, u8 index)
> +{
> +       return (idn <=3D QUERY_DESC_IDN_CONFIGURATION) ||
> +               ((idn =3D=3D QUERY_DESC_IDN_UNIT) &&
> +               (index !=3D UFS_UPIU_RPMB_QUERY_INDEX)) ||
> +               (idn =3D=3D QUERY_DESC_IDN_GEOMETRY);
> +}
> +
> +static inline bool ufshcd_is_wb_flags(enum flag_idn idn)
> +{
> +       return ((idn >=3D QUERY_FLAG_IDN_WB_EN) &&
> +               (idn <=3D QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8));
> +}
> +
>  extern int ufshcd_runtime_suspend(struct ufs_hba *hba);
>  extern int ufshcd_runtime_resume(struct ufs_hba *hba);
>  extern int ufshcd_runtime_idle(struct ufs_hba *hba);
> --
> 2.18.0
