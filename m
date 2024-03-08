Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29781535D7
	for <linux-scsi@vger.kernel.org>; Fri,  8 Mar 2024 08:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709888218; cv=fail; b=DI4EB961g/pudjB9tbH+eDgHk6cJETuU6D7lr1biETir0kYq6JQK/FYKq7EJVhfd3RK4qrQQQ2X00O5VIYLaDyKXGMwbE07/O8pzBERX7nW/no2rq5Hi5deSi/qiMQG8GZQCRAeDdBQ0QW2A3RaRusO9Zc3lgooTHcdP+hWHuh0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709888218; c=relaxed/simple;
	bh=AvIa4tMt0qTSceSOC4RWjzKDQ7zCfowM0tg96H4H9cU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PPKr90Wdwxq/LHcoC5HC06n6vZz/NFWn94F7St2H/3Dca2qRiFaUsH2PrrDW+AR0PuSTJ10ouvHRpR1X47M3F93xFt76a1cNDi0r5eXCxChmnBqEmhdmiLuZG9hdc23JE+HohWAITrP74csFR2EJ1EJ+4cGoASehVPWJGSJyV8o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ETXPtvDS; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=YYG8E+Ms; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ETXPtvDS";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="YYG8E+Ms"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1709888215; x=1741424215;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AvIa4tMt0qTSceSOC4RWjzKDQ7zCfowM0tg96H4H9cU=;
  b=ETXPtvDSdzN0koZ1hvz1oJZj4GeqzbSqnSPa0LjG9yGBgsbeVHjm2LAC
   /HLlaMtzNR9fC3dFL8/oUyTPZomXt/FOxGGMRn9EDlsb7TStZ25QfwsO6
   Jcjhi/u9AnOZK/yjKgY1eXb58c+o/pOqxU90IBekJPTadFnkaM0p9CzL+
   lvUxp4RdbMv1G5EHvUzw5SAtoeE4pfyP2bJ+5l4FtU5hvz1Vq2jyQP4on
   J+JsnfpwHWGb7mMSQSD26fWn0ggnCgNqGmi1vQh2NVV+MLsJvRXA2OIAI
   er3+mJTaIhnYBIPcOyr51YJEourVtr4+ncNZfIa7jp/zCTH8VNbkU8UHc
   w==;
X-CSE-ConnectionGUID: wxnuwZHBR+mYjlLbj36obQ==
X-CSE-MsgGUID: LbfEB8FfTA+SZ1seul0/4g==
X-IronPort-AV: E=Sophos;i="6.07,109,1708358400"; 
   d="scan'208";a="11724838"
Received: from mail-dm6nam11lp2169.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.169])
  by ob1.hgst.iphmx.com with ESMTP; 08 Mar 2024 16:56:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kHtnYnOxIyuPmaNAULsxxCmIiZigCX9z+RFPUN4ZSGol6iGSwr5HfMqVCVsXf2a4ffpVXXMHFQN9ZelmosNOKz+sJEXW+ze6EGBrwXC1d1bscsRYjUxjZPGFrkF9qkzdeXNKBAOFbgSmtg0J34Lp3175E8LUvvaYJILcEIAtoUIqEsXlAjf7CLKnhd62IRcFkH1LjTW1h50GINDZEZwJXkgA2eaUMFoTuYBkeAPJHTB4ZGrdnTuz7UeBoheVLV2roloyeFkjTAKxeIgAX300Oxb/Ns5r7/o6LkY2orV95aAMqYXCNbZzb+4e91jv0iIjdF0vHzdt07Av1+EqbIE8Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P1O821A6XtJ0n78XRA7sh8X34whbVtNf4zYr+/yo72c=;
 b=EvwX4Z2CMX8ffvfy7VszjMNowGX0/MJQXrM1jRvS5BbnwbQgFYkNP6rLKjZJ8TtM96GOPhw8YeinSKFbnWyzH8wrLs2Tk4Bw8/ZGtVDmAEiJeBVApr1CxckCVJP7fhgIBjcOusyn8msm7SW6Q4n3XUcIOcEQreW2uQGkwCxDVA/Og3eyNjJZ/Vx8J1O5otBxRBZ8EUMUx0s7h0OiA+8xH+JkLjFpfA42XngiDZrUZi+nQbC0HvdGMlNpP4s6UkXtFf5YCy6RvPMUi4Q4PCwoKBrzA62kYMPwA81ZFuS/DMLhXF2NC3NU8vDwZxy/ENtYsdKEYyolHcqv7z0GmUgNPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1O821A6XtJ0n78XRA7sh8X34whbVtNf4zYr+/yo72c=;
 b=YYG8E+MsaIb+sxMDDgaTZcmfb/vE9FhZX79kJ0+g8znOsx9ScEoTkxadLPd5e2TrLWdkp0oPAdvd6xD960muRdJbfqIkdAODUq5fRYQX83M10HyIvVya0OMFnJYWlf3oeDSf4trsK1QZoLQ/hxVikXvtqpF6+ndX9MVSuNF+shQ=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SN7PR04MB8461.namprd04.prod.outlook.com (2603:10b6:806:323::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.29; Fri, 8 Mar
 2024 08:56:51 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5395:f1:f080:8605]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5395:f1:f080:8605%3]) with mapi id 15.20.7362.024; Fri, 8 Mar 2024
 08:56:51 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "jejb@linux.ibm.com"
	<jejb@linux.ibm.com>
CC: "wsd_upstream@mediatek.com" <wsd_upstream@mediatek.com>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
	"alice.chao@mediatek.com" <alice.chao@mediatek.com>, "cc.chou@mediatek.com"
	<cc.chou@mediatek.com>, "chaotian.jing@mediatek.com"
	<chaotian.jing@mediatek.com>, "jiajie.hao@mediatek.com"
	<jiajie.hao@mediatek.com>, "powen.kao@mediatek.com" <powen.kao@mediatek.com>,
	"qilin.tan@mediatek.com" <qilin.tan@mediatek.com>, "lin.gui@mediatek.com"
	<lin.gui@mediatek.com>, "tun-yu.yu@mediatek.com" <tun-yu.yu@mediatek.com>,
	"eddie.huang@mediatek.com" <eddie.huang@mediatek.com>,
	"naomi.chu@mediatek.com" <naomi.chu@mediatek.com>, "chu.stanley@gmail.com"
	<chu.stanley@gmail.com>
Subject: RE: [PATCH v1 2/7] ufs: host: mediatek: tx skew fix
Thread-Topic: [PATCH v1 2/7] ufs: host: mediatek: tx skew fix
Thread-Index: AQHacSaqoUvce3CwLU249nWufxiG37EtinqQ
Date: Fri, 8 Mar 2024 08:56:50 +0000
Message-ID:
 <DM6PR04MB6575B7F68177E0856D3E7952FC272@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240308070241.9163-1-peter.wang@mediatek.com>
 <20240308070241.9163-3-peter.wang@mediatek.com>
In-Reply-To: <20240308070241.9163-3-peter.wang@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SN7PR04MB8461:EE_
x-ms-office365-filtering-correlation-id: 71c600cf-938c-47af-8ca5-08dc3f4db1d1
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 0EOS91cp0aqeaTjHwGYhCaQHjjcBVbwpP04EWlHFi+9YrcWeDB5H7zwQPRFhn1oO7P0ZwsNBboLaxFWnm6JESRCOwLu6sbRRXq4vpDdyzJc3ZiJD1qmiR257fPiW/VOwMZAdhPHxSfvbIWDr1VJnUvGaK6v1U8zVS89gYgxANahHYmL4nYucV87mj1Pfv/b3B0cgKtM9w6JzhAWUWbJlRm2nYU1uAKzkXDjPDMbEHdeju7rbiQpM1QIGgQNdNoKUrnNkY+6egMmv2GqA4mCvB/FVbNq1kNdvJWlMFhFmsMMpglYB6fEpD4woXkLtpPs11n86qEKKBozQ6ihge3YgotTREkFR3tQhyY0t+Sav0HoTOMPUHoN3h3M+FjUUoaPTC3a98wuz9A14HhLsdaEttTANGU9J73fgCZIMT+99SqqYSMde/zrQN8fSUz+fbUilAahDQ3cC4Qj42QiNRn14vbl3FtC4SXKjotjR0NfiQZLbrrcqAJedv+452glPPtnveQSYFMlc3iwAIQbW0llZGsysJOaT5UBh9PBGcSPvOI/mRkHdyNjVCs2FVy8gzE7MEsvyCVerLgKkFBfVyhy4Q+oR0MeOKjuO/AqOw9p9q3dJyGx/D83VjRUbwltFXZmRASb4bawPnEnoMpHjuFuP1PTZOZ1QvP9KGep1BLubNXfTTkXP6b2X/rWdZoJqJ0Yk/msjHG3M5x3dRibxyenYp+xB72C37lSo5p5yPmFvxtc=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?3bSBTTOPXJPrFel6x7D7EU7FcKlWAS3SGRzZnct9LTDmSmAReGXGYCNHD0d4?=
 =?us-ascii?Q?L2DGLMPsEzLm0aLoZ6TwRbkr66V/bzMvwDytNn+jWSU3zMBNxxLFsAN7WGYH?=
 =?us-ascii?Q?l2IVTwgFi8UqFkJ4+VZTs5C0/Tr8eq3TCsYLxZTApU5p/8OlTwka4BZ1pGP0?=
 =?us-ascii?Q?3SLMjt9bspBL5xy+3L7zjxyki/GRRZbNWjdddOArAQe6fKdXXM2xksIIqF7y?=
 =?us-ascii?Q?CsVbSVtNoWPfvoOlDNOsPzcjt6gb0Pf6WW21475YEGhWS8q7LnGdSP87n2Dr?=
 =?us-ascii?Q?RNJ2Bub8z6OgtNfVD7kWi20o6EFa1Rk6Y9LWhw087vWyEuNW7ltaq3b08wJk?=
 =?us-ascii?Q?HQAAyih2xwKk1qeMpKoZ9vitjsysTljcgn0wRFoYV2BeiJc4Vr0TYitcYJsQ?=
 =?us-ascii?Q?5PvbEioobg898Vc6sX4AM8ATfO533cJUaeHM+J68chDjEyH9xkA2SK3lcMOx?=
 =?us-ascii?Q?NGuYJeBQsX4BTj/mvxT/P7wtvim33kICyUN7oNq1OwdyekcN0sfVMcy61u+o?=
 =?us-ascii?Q?XUhwGpNuknInTGC+bwzHiyPXV7WXc2EdmKTnQXtEdw/+9m9jCxpGAId+34IR?=
 =?us-ascii?Q?SonUS0q+F8YTTcSo8qCDM+qjigEy9GH1J9P/HPoBM+V2vHvepCfCKcYeTOxy?=
 =?us-ascii?Q?LzpAB/o8TLu2W1wsp4gY7K/3ykcqBJRi0OJECOkQGkbUb1Cil4bCMf6k28pr?=
 =?us-ascii?Q?i7B3cGepFLUU2Zd/qaci0Chyo4wkaUF/f2Cff5hZR7lXS7Kb4j1U/Y9smfRk?=
 =?us-ascii?Q?qr5fZhvDt5NgEyb8fuXoiUHixK/zpEof70FjKBMOOU7tnpK/vS6eB8S/vJXm?=
 =?us-ascii?Q?X9vBNVgRqL4FpirFFxxy4FOfq90qyVf+uczoirAqchNzxCDqLGWy8chL8sAc?=
 =?us-ascii?Q?ytpKI6zHqkPoVGr2gltsOSfgCqDLLqG8L8gOsNWDxhiSvVvue1TGu9Z8Fx5u?=
 =?us-ascii?Q?Y+O5eLZTdNCFCbfvuigy+grp4Ow8tdwHEuniz5d+eCZJU3ptd9tWGMRD1af4?=
 =?us-ascii?Q?KMsZ/Yqc8hqdgcAk0s2/LdPl14kdmrYrnmO4JgGbw0kwWwNg6rr3RmxUpR2G?=
 =?us-ascii?Q?m2c70FO9E6uFSavU4MeKCJ7nrjmcta76Em7HXirWPENSeROAWsmvQfWct0K+?=
 =?us-ascii?Q?uUbDgR02lRsy9lNGd2hTHUlDYL1V2Z3yoqMsnjaKMYHaesHhWWKBSHXiro/D?=
 =?us-ascii?Q?7rPWvRmUdYwX9ibkkrT4x0nUPUmZg9yKTkRxcP2C1l+pG1wYux1hdRPZn7Kc?=
 =?us-ascii?Q?a2teCvKMRly3dFnGAUjjpfGg0PLMPRN5l4Ncz/BxfJrugElen2KQ9WllkWTg?=
 =?us-ascii?Q?NpoOEUXnYZ6Szj6KyXK94HNDixrC0nKb4mqVk+D8UT/qW+QSKs6oVLFm8rpi?=
 =?us-ascii?Q?bo2nA++jQzxPGMQ8X4+y61qJ5Z3XJy8v6SOYF9kYBmmW7EvifKgrz/PO+kJ/?=
 =?us-ascii?Q?jZ4plktzvBhtQhPpO/wR0EnLFPBKWZBOs1wKMK09JDsg1gwbqtb3/q8hhRvI?=
 =?us-ascii?Q?X1m+oBFOdtthSsOFhv95YwfpF6xJrNguIH4P0EL/mAjIOzQEYsYVul9U9zUs?=
 =?us-ascii?Q?EdLadSo6oWB//1zA7Y7ZJkSYC1O/r/fP1xN9Ums6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kDKki94EU9KtDsxXegluY6MF1U64PPCyxitsvosTLTxPDYtlXHkS6jLcCVFZLBm7RAvOH3GNyaRMNYdDbEteoYczn9mlPOdpMsIuFm4hDlA4HP1nTk7WgVKRZ1CuhNfHUZ5d/JgfwUAx5peSGD0efz6KsOqKthsjhSi6mTA3pc6LxDDJ0bXswmXQwdLTGBt9jx+EGgPmc2lTOOvKp6Bh4UnhHIQCnLXdUhZyiLBWmVP4JsHM05tvKtNnqA8Ys51e4Nu6IeswKhp8fJme5tXultpI6+8q0nAurFNKiu+KTHcCDSNbcELzvFaxy+MaS2QV9HJL5bGPZ7bmKgmXhjTEemGszv0YxC8PAc0C7Ue/pzQk/SkLdGtbCaJvCawyFUjvlq2Xj5zrhEroTLVB0pOGwRGJs82gkmQuq5zdXnU33mzniI/H4xchmIyi8KYN95J669tVuDc7HEOMlwbJ2ZMklXnUIX5/P0FV6qn1LCi+gS0d9gj/oEmOvDn/Q80a6/As7gBYHf121lqcDKYD+95sH3D1OXzbn5Wa4rh0AmKTefI2FaOUqaZxIo2N6LAHVnQ/xptggiyMMxukG5moy7zttXdZtXhMdOvm3JgOYLZgeGN5UPRRXhMUBl+e4c73hg4J
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71c600cf-938c-47af-8ca5-08dc3f4db1d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2024 08:56:50.7962
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TyuJY1ChtpbD9TRAxhnpYH68aBr72UvpIvqAF+i2DCWPi17cs3U1xMpLK5ZHBVdxSZ0WIcz8uAeBp68aq4OA3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR04MB8461

> From: Peter Wang <peter.wang@mediatek.com>
>=20
> Mediatek tx skew issue fix by check dts setting and vendor/model.
> Then set PA_TACTIVATE set 8
>=20
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>


> ---
>  drivers/ufs/host/ufs-mediatek.c | 21 +++++++++++++++++++++
> drivers/ufs/host/ufs-mediatek.h |  1 +
>  2 files changed, 22 insertions(+)
>=20
> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 6fc6fa2ea5bd..0262e8994236 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -119,6 +119,13 @@ static bool ufs_mtk_is_pmc_via_fastauto(struct
> ufs_hba *hba)
>         return !!(host->caps & UFS_MTK_CAP_PMC_VIA_FASTAUTO);  }
>=20
> +static bool ufs_mtk_is_tx_skew_fix(struct ufs_hba *hba) {
> +       struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
> +
> +       return !!(host->caps & UFS_MTK_CAP_TX_SKEW_FIX); }
> +
>  static bool ufs_mtk_is_allow_vccqx_lpm(struct ufs_hba *hba)  {
>         struct ufs_mtk_host *host =3D ufshcd_get_variant(hba); @@ -630,6 =
+637,9
> @@ static void ufs_mtk_init_host_caps(struct ufs_hba *hba)
>         if (of_property_read_bool(np, "mediatek,ufs-pmc-via-fastauto"))
>                 host->caps |=3D UFS_MTK_CAP_PMC_VIA_FASTAUTO;
>=20
> +       if (of_property_read_bool(np, "mediatek,ufs-tx-skew-fix"))
> +               host->caps |=3D UFS_MTK_CAP_TX_SKEW_FIX;
> +
>         dev_info(hba->dev, "caps: 0x%x", host->caps);  }
>=20
> @@ -1423,6 +1433,17 @@ static int ufs_mtk_apply_dev_quirks(struct ufs_hba
> *hba)
>         if (mid =3D=3D UFS_VENDOR_SAMSUNG) {
>                 ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TACTIVATE), 6);
>                 ufshcd_dme_set(hba, UIC_ARG_MIB(PA_HIBERN8TIME), 10);
> +       } else if (mid =3D=3D UFS_VENDOR_MICRON) {
> +               /* Only for the host which have TX skew issue */
> +               if (ufs_mtk_is_tx_skew_fix(hba) &&
> +                       (STR_PRFX_EQUAL("MT128GBCAV2U31", dev_info->model=
) ||
> +                       STR_PRFX_EQUAL("MT256GBCAV4U31", dev_info->model)=
 ||
> +                       STR_PRFX_EQUAL("MT512GBCAV8U31", dev_info->model)=
 ||
> +                       STR_PRFX_EQUAL("MT256GBEAX4U40", dev_info->model)=
 ||
> +                       STR_PRFX_EQUAL("MT512GAYAX4U40", dev_info->model)=
 ||
> +                       STR_PRFX_EQUAL("MT001TAYAX8U40", dev_info->model)=
)) {
> +                       ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TACTIVATE), 8)=
;
> +               }
>         }
>=20
>         /*
> diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-media=
tek.h
> index 0720da2f1402..146c25080599 100644
> --- a/drivers/ufs/host/ufs-mediatek.h
> +++ b/drivers/ufs/host/ufs-mediatek.h
> @@ -142,6 +142,7 @@ enum ufs_mtk_host_caps {
>          */
>         UFS_MTK_CAP_ALLOW_VCCQX_LPM            =3D 1 << 5,
>         UFS_MTK_CAP_PMC_VIA_FASTAUTO           =3D 1 << 6,
> +       UFS_MTK_CAP_TX_SKEW_FIX                =3D 1 << 7,
>  };
>=20
>  struct ufs_mtk_crypt_cfg {
> --
> 2.18.0

