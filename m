Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B6B9C2D0A3
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 07:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E981222B9
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 07:13:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bH+COX2t";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="NifbPlaH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727760AbgKCHNC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 02:13:02 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:41635 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgKCHNC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2020 02:13:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604387581; x=1635923581;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AoXsH90liERt0+vmxAUp9Jo2ppWmmwFmXs9E/egTdok=;
  b=bH+COX2tqlQXafIFlmcuE6CJhr0eaYTJLa3Y6niuo0khPsSMiehiaAm9
   RLv6v09kKHb4MRGEIkIZ3x/rAMie8DEkr9/vQtElRs91CL5qOmuNixMet
   yXVkkKbGTQmovRhBvlIrJbcqAjwWR6egWb3bFhTiE7yr9KVg8T0KgQmUZ
   BJGAsxxTWY2OTuSyqhnrXKd2KiS6nKI1Vy6M3VmU53XDfXn2gjQxFl/1K
   7w4UNq1pkBFwp2Sfwm5y+osq+kkll6o+Jqhu1hfh3eHZSZtSiWezWzL5a
   wCEOadjOk5pgfRhO6iTjXf45obX8ettp/bgb0nTBm9OTYOGu8mMmsTJhf
   g==;
IronPort-SDR: rbnsL/aeCd/v1LGq5cTRJYDan/+DIZyXqFK1jcetAvxN4v/EdSUVprxtgkDS0LMqhB+vpzvNez
 qbyN6eo6T/ioOx21SX7qIIBt04BE7angiy3LXKlOGkxvtwWllJzuppoCgNbTHx9CxABC8lzQNZ
 d/mQMKt3uUK/98sqZqKpLMMz4ZLcpGZWv+/tbMw4ww/GM+3KdLsfp0ZakNe0fozvLAbEhbPMjQ
 EDE4SSsLyz1ypEvHpRnm0CKSa1N7zBYVYvAWUAQydF1ck9fZRstzo8ujSc05ugGO5L4BH0tz0y
 qcc=
X-IronPort-AV: E=Sophos;i="5.77,447,1596470400"; 
   d="scan'208";a="261576754"
Received: from mail-sn1nam04lp2055.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.55])
  by ob1.hgst.iphmx.com with ESMTP; 03 Nov 2020 15:13:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C6ffGJsbbNlTML+HldM6qjvmdLaVF+MEdTDih+X2tdiK/j7Bzy7SimcPn5my/vDF9Lc6Z/bayx0tLsUaFEsQkq3NARz5vztAwhwAsEwG5Y0w3cqKU4ID14pSV/3PYeyUO0FfWscRtHQuH1bY2QsleYkM3TpoKNk+0/hwIdEIc2srXZPW/JB3bt+LdBiU1sRDOVceimqDet7/O4rrtAvrUFi7NKEagkYb8VkjhuTbvSpvrJb9aGj6TJsDg5GMxfinjTwcu7gFy29JS2cTGJUJrRmgYHYTzVJIAx6zO0tinBfl59Bv/0sNOZViseE6o0eSdDRw7JGr0pnQybXsxMHPeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=au/7O8shYa0yBHOSK+9LEdsqN7lhS9yU68VFNqR3KIY=;
 b=K0bFzE7QqCicE2fvNBBg4CqemtmKSZDlHamctdo9UPMWvcuKtZKm7YB0hIiAxNSW7/HUCjUWIMqPO0/qWcEivuWipvDwPNRhdplvfH3+s/zMXUIDJs4saJ3hCESuJyrKWNlhUXmaHxY1LctTcpJ+HYVUYS0VkM1Vce7P7lNqnXo+uzhA/kpuNnKgZCgU2f+AX6tobBTDXJJxFxlmCUFxiSpk6iJAk0iRI6qG465EjTJ4NH0tLpCsfTLSZU3Mg4k4ac4KnX6mPHCiiEmoCM17BEFUkoXMmJVarDCi+/8lzal/A2cJJ5iulXozC4ttJRSPe42L171GNvNMONrkwx20MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=au/7O8shYa0yBHOSK+9LEdsqN7lhS9yU68VFNqR3KIY=;
 b=NifbPlaHNXT11iV4gjks134C4cS4Rapod2FbEsfYbhJAdmjLu3OXPGaQGNboknCwX+IGg+ipXjOJ4pK1n6gm9wLr4NezRGyY59NNeNTu++jlxpe3CrEsxLu0dtzdKsXpW8KFx8YegP8BefrUq5EIcjE9tLy2bu2bbSMC4YKpE9A=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4172.namprd04.prod.outlook.com (2603:10b6:5:99::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3499.29; Tue, 3 Nov 2020 07:12:56 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5c59:8281:ef4a:3e2a]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5c59:8281:ef4a:3e2a%9]) with mapi id 15.20.3499.032; Tue, 3 Nov 2020
 07:12:56 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
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
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>,
        "jiajie.hao@mediatek.com" <jiajie.hao@mediatek.com>,
        "alice.chao@mediatek.com" <alice.chao@mediatek.com>
Subject: RE: [PATCH v1 1/6] scsi: ufs-mediatek: Assign arguments with correct
 type
Thread-Topic: [PATCH v1 1/6] scsi: ufs-mediatek: Assign arguments with correct
 type
Thread-Index: AQHWrerABC0BriD7CEyLHrMbpYegqqm2BS3A
Date:   Tue, 3 Nov 2020 07:12:56 +0000
Message-ID: <DM6PR04MB6575F51915ED4E904ED82EC1FC110@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201029115750.24391-1-stanley.chu@mediatek.com>
 <20201029115750.24391-2-stanley.chu@mediatek.com>
In-Reply-To: <20201029115750.24391-2-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7f229233-8129-41a4-d76c-08d87fc7e39c
x-ms-traffictypediagnostic: DM6PR04MB4172:
x-microsoft-antispam-prvs: <DM6PR04MB4172FFA02E2FAECA00953402FC110@DM6PR04MB4172.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mNvvN4Vps1c4+90GVc5DF9qRu+UNTaNguIs4Ow4k5GSxbb9EF7rpOcihWSC7w1FqSMpi5Yhe/pf9Jjjb+UjiG8Ucrzx2OvCZ6nUmQFXE0XBibfzbWz6t/uDCC4reqeyuIeJ7U3TrP36E4FFW++C/m2ynCpl0HeMdiw+nhOTSj/xgx9b02NhxQ77PpFvJRClf9uyl1F1Y9BjWVWeoPqtQGzLWJ/7dEc0CqYk/b8JfpJdoV4U0p8Wi+w/Z4TrqukcNRS3UNUzZTXP3jhUOFDbL5HUK+f2uM1J2XQ6ieI6RDiHomzVxpziP2HS3mMcsoJiHWnnMHSQAE9F+B1/OZt8fwQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(376002)(346002)(136003)(9686003)(4326008)(83380400001)(316002)(186003)(71200400001)(86362001)(8676002)(66446008)(55016002)(110136005)(2906002)(26005)(66556008)(5660300002)(478600001)(6506007)(8936002)(64756008)(54906003)(33656002)(7416002)(52536014)(66476007)(76116006)(66946007)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: S7QUR83MbUDaRyCtMXZuJWh30mB9Jehtz5vCdqEVsL+rxbdZCXpC2E2aVt3EKugK2DDhdOZQI0WBD5FM74pBYnp6wjOgCA95Qk1ONSNiKt6+qpW6lRvS2nYxW1fOioCrslMJMAvVtnqa1DeW+w+6HA5H6CNDrl372D1e5jwOs9iOf1+LBNFq9mz/Bzwef+JPsF1GoczqACTTZ86i8n1tsLSpNbCELd5V3Eidkk45Qwm5hG11Jxk3YSOosSbiO6499z3amtnVlcyY+/ExxWNwpaugBaTaYQA3DRT4ctIpV+4KNjKT574Pj5Lv7ldmvRB/1sau0mfJhCV4soISaaTa7cjdraqtlHCwQcg8UiTLcaDxOe6k+uTcpkPUIUyhD9gXZLRBweOa+PNWX/YODTUmCbf8XV2ZvIJ6jJHwBxJxDb8zsrwTe2Lo43oKPIRvZ4vh3nxeFJfdtFBB1J+Dfu1SbDSunLfQ27ybL0WG23gLxHOdAp9XuaF3krN3ojHOiGlp114tFb/PtQyR+kX4bJbcUFaxbQXw4wVj6iULlfGyA7tiCrkr0Qd+qiAklwy6/zf48ZbTPEmuS38cpMeS+LkELsPAqSfcJNFtP+jvYA42uP5jQmZzchcAz45H7NLtICVouWcWr1heSatlVkK6hkYe3A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f229233-8129-41a4-d76c-08d87fc7e39c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 07:12:56.6015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: feBPJtUkT82WMy6YdoJHdSCTvPr+5vseJnM8Rv5tJBXyARo28uIINUXzuG+N3W85dODVZV6RWikEwHCexOiRcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4172
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> In ufs_mtk_unipro_set_lpm(), use specific unsigned values
> as the argument to invoke ufshcd_dme_set().
>=20
> In the same time, change the name of ufs_mtk_unipro_set_pm()
> to ufs_mtk_unipro_set_lpm() to align the naming convention
> in MediaTek UFS driver.
>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Looks like this patch is gilding the lily?

> ---
>  drivers/scsi/ufs/ufs-mediatek.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-media=
tek.c
> index 8df73bc2f8cb..0196a89055b5 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -639,14 +639,14 @@ static int ufs_mtk_pwr_change_notify(struct
> ufs_hba *hba,
>         return ret;
>  }
>=20
> -static int ufs_mtk_unipro_set_pm(struct ufs_hba *hba, bool lpm)
> +static int ufs_mtk_unipro_set_lpm(struct ufs_hba *hba, bool lpm)
>  {
>         int ret;
>         struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
>=20
>         ret =3D ufshcd_dme_set(hba,
>                              UIC_ARG_MIB_SEL(VS_UNIPROPOWERDOWNCONTROL, 0=
),
> -                            lpm);
> +                            lpm ? 1 : 0);
bool is implicitly converted to int anyway?

>         if (!ret || !lpm) {
>                 /*
>                  * Forcibly set as non-LPM mode if UIC commands is failed
> @@ -664,7 +664,7 @@ static int ufs_mtk_pre_link(struct ufs_hba *hba)
>         int ret;
>         u32 tmp;
>=20
> -       ret =3D ufs_mtk_unipro_set_pm(hba, false);
> +       ret =3D ufs_mtk_unipro_set_lpm(hba, false);
>         if (ret)
>                 return ret;
>=20
> @@ -774,7 +774,7 @@ static int ufs_mtk_link_set_hpm(struct ufs_hba
> *hba)
>         if (err)
>                 return err;
>=20
> -       err =3D ufs_mtk_unipro_set_pm(hba, false);
> +       err =3D ufs_mtk_unipro_set_lpm(hba, false);
>         if (err)
>                 return err;
>=20
> @@ -795,10 +795,10 @@ static int ufs_mtk_link_set_lpm(struct ufs_hba
> *hba)
>  {
>         int err;
>=20
> -       err =3D ufs_mtk_unipro_set_pm(hba, true);
> +       err =3D ufs_mtk_unipro_set_lpm(hba, true);
>         if (err) {
>                 /* Resume UniPro state for following error recovery */
> -               ufs_mtk_unipro_set_pm(hba, false);
> +               ufs_mtk_unipro_set_lpm(hba, false);
>                 return err;
>         }
>=20
> --
> 2.18.0
