Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22F231759
	for <linux-scsi@vger.kernel.org>; Fri,  8 Mar 2024 08:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709887922; cv=fail; b=Nji1R0gaCLFHKT6ZZoZhUFjCFi8qMwA2icynZkZRln1HJNbQgPx90wClzwD+4lgjFxHqgGEmzQavCICoVEFpkPNhzN0jtNZ0ShVVQaRPby9s8qgpNL1zWzNtUOlc10jaPxmJ4bglwOF2Ux8m8WGfxoNTtvqOElnxsOu6Pe7tJME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709887922; c=relaxed/simple;
	bh=1D1/beFVGL1yPgK5ikDDygYLZ7ZinlO+NtkpMGbUSgY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cnrFnIQkLQDaaAsYyAB0ReSqR2RXH4WeS2B1ceeAWuFl+XkHDBd06tfZMmKkNcLVZA5Ycp3zS8M8QcQSgwrJM3aN3luIFO86MrUhyPwy5A0R6WihEgRjlKQNuHnocFB60A8zsnC351SnUHwczWIyb0d1w5jur/5IngvgAThVTEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=OqwrDaRo; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=eglo3oUc; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="OqwrDaRo";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="eglo3oUc"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1709887920; x=1741423920;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1D1/beFVGL1yPgK5ikDDygYLZ7ZinlO+NtkpMGbUSgY=;
  b=OqwrDaRotglyppka7pIAsY7EvNTHgpFXXnNsMYeaPAjQd0GGiNTCBjzr
   Nrnx7SLb2honfBEVL1BW0W4isVHZQwttL/7+GoEcuKFglnhiiiw8TvSlI
   v94sb5s0/t0W0vEbmGEq7JyTz+BNu/u2w4jKMirKbDb8OGMbqu6EWSF9Z
   YZRJ4SwZ+hZBAdN9dAVNfhfwZirHJ5hI14RP/vmxJGjrI738p6Fo7bl1J
   cMqHL4a+8NJWj5bhvboEHw2NWCThWsI5CCsa8ThC4Lfu2giZj772NU51M
   pZbrs3FArR0YpSltMZsEqxepBGE7vnUJqbg4ppJG0yqcLDnC9a2K/+UpE
   Q==;
X-CSE-ConnectionGUID: OHgk9TlJQRWy79JG0DELRA==
X-CSE-MsgGUID: eYndXahzTZWHns699GVb5w==
X-IronPort-AV: E=Sophos;i="6.07,109,1708358400"; 
   d="scan'208";a="10649917"
Received: from mail-dm6nam11lp2169.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.169])
  by ob1.hgst.iphmx.com with ESMTP; 08 Mar 2024 16:51:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kpAPo4O4pDeKXhAJIB1eujqmiBpBKgTzwmgT3h+iy/6aeLYeUV3WbAzXBqMwmjVdgjtlmB5lj1aDNNHrHONyVMrUpXg3QvKo0Y9xqXH9Np6ts7Edauq+Fltq9IBGULr8MHDrRImfTKXffBlhKVaGc3hcsGM7YJylcjGxFzg18TuNe5OgQJgGL3doverz+arFtIf+GImCJ8H/jKR/xQN5dJFw7TTrtAUZEbFKo7ODpdOtd1MKRdtOL9IrQZUeTZZpu1t3iQTHBSVdkGyiZBBGUf+65AwYCBitLxSe4g0DX6EDwuP9PuT5GsUlnG6WhMvBdmjq/alV413EZPZZXZtGaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0X29rUQuQviRXtHvRwfSxLHK4yumZSOW48Y56fYzvQo=;
 b=P3bi9qzURe1v9WPBY4tJwwRT1SBBCLZlhRF7MkChhDJe4Erl2va3QvhaFRRNfoKsMpd9wg5JYFGKiV/P4z1tmS/o/Tcny/4VzpZ7pZ9NXcP3RYLcQ+XWxNRdGfHcRL7/v87b5wvzH39USQ92k/PdeDL6PdXyfJYqR6Tl3szjpT7D0B6b6JyzL0mLipBe5mO4cNujZsF7vR4YiOnaPYB1ZaeEKrF1tuuIcf20MIJbI4U3p1AAnFLKA69mlMUejmqZjSk3Pef8XxaaANR414HomrNSyA6Xgf4iWEliTb68YY0EFSiXKz1UcBBMFnhaC+8ge3YjX7dvk3gyrr/z6ncrZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0X29rUQuQviRXtHvRwfSxLHK4yumZSOW48Y56fYzvQo=;
 b=eglo3oUcm5qOi872N5HvXHkvPDf93Kcnwadc2kmKtiiEN0hakQ5C9nrH/eg2KPquw6/n55gOOMpHJkvYskxEEGm1NwOzW5g2ezQAD53iTmbxz7NKFPcrMUcRbat7ZwqJ5TpTgja00a5dx9dhuc8b6r1S4iro7S+QuFS6ycE9/QQ=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SN7PR04MB8461.namprd04.prod.outlook.com (2603:10b6:806:323::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.29; Fri, 8 Mar
 2024 08:51:56 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5395:f1:f080:8605]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5395:f1:f080:8605%3]) with mapi id 15.20.7362.024; Fri, 8 Mar 2024
 08:51:56 +0000
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
Subject: RE: [PATCH v1 3/7] ufs: host: mediatek: Add UFS_MTK_CAP_DISABLE_MCQ
Thread-Topic: [PATCH v1 3/7] ufs: host: mediatek: Add UFS_MTK_CAP_DISABLE_MCQ
Thread-Index: AQHacSap9aUxQ0m1Q0ecRIfdVjoHMbEtiT7Q
Date: Fri, 8 Mar 2024 08:51:56 +0000
Message-ID:
 <DM6PR04MB65755019F0E7254865FD551BFC272@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240308070241.9163-1-peter.wang@mediatek.com>
 <20240308070241.9163-4-peter.wang@mediatek.com>
In-Reply-To: <20240308070241.9163-4-peter.wang@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SN7PR04MB8461:EE_
x-ms-office365-filtering-correlation-id: a505c25d-3bd1-43e2-3338-08dc3f4d023e
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 X9/coHFa8S34ZPUzD8W8jnBjIG7+Bk7UHYD+gWZzKKCe5n0oQ79/BzjKOJsM0mRQntTgbEzLss+OlcUeYS/MlSZoXNceRmZWTNcISXSJ3hEQotdWG7lmDqz5OqB+yqxTDVjYQxz6uO+Cpx8i9K/eR6NExV9nOmjn1zJ+1nXqItD4yXYvgVAG6RJ3TAE8NLxE/bnx4Tvy1fk/qTu24hJJ210xQ/sLpL6uaIs5s3dmDPrE2EvTBd2UEvk/MpaTOBU2M56R6dvov66tpJftQcploHY0uamf68YzsjjFdSyCjUK6w6tiOuKJRsJzEeCV+kwCJKxWkCISQprbu1b9Et2RvCGoxXE89WfTpB7ZbKwvxFtLUEAQMRjSqda4XcZy6Ox8MLb3h8JfHA6kyHviJzCBtLJxn12UJzz+VgsYln+KidIuaCYuPGmtAVpSv8yY+elmkD+u5/tcofRPL/09MGUsQUFKyqcqBF/Zn2+cKB+hVAxSU/CHJYZ6mOXFMj1PL/eVJYOearlEYWNx6+EqQlmW8MrEgjGVZoOHPQXmgc7T5wlwbLWJdi0jFyJPaQnIUzRHoY8t4vR9bn/bFvDqnjH9VklAidH3A4QD4il0wOuxN+3aHw+nSTLQX9gfoV0a1Pfoy+VSBbeouWiPLNawILKabxuHWGhQJthRs7vQ/Z2FXeO6x8/HbFy/YBt3kONp0Y1qdXmswUDZyT6WftxR4zq7qdFK0OLWB2NDWAB9f/y8N4o=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?vS3mrdA3ibb3aM1cRz0kySVC5uSpfMocpSotBuscrxjrOkkMAxdstjIuzMjR?=
 =?us-ascii?Q?BEAGUfoOQN+tMl+7Rcvn8lw7WSpp+Ij1+uCMDYGKhmedgh2uRNfJsfD2Ewx3?=
 =?us-ascii?Q?/h4MbKz6mRc6j5AhbMyrIDDlA2U/rHeYBXH/Df0E1cKsLY/5e51RJo+SiVV5?=
 =?us-ascii?Q?TgzvdGJ4oU+ydOMPXwc83amg2sTWwtNLe4N5TA4IA4sSnk0Y8c1sjp96635d?=
 =?us-ascii?Q?UiuwXWzR8mpjwalWMvsmuw3m7QDNQZzaL+l9MOhy0bc/XmqvspvowejHLv5a?=
 =?us-ascii?Q?P3+UVaPdjZ9MYouRIcPdzp9uyzMl/hokHK/ZRq69Lz8PT32G3RzunWishq71?=
 =?us-ascii?Q?hiAKKiDre9U5SYIM9kP1Th1KrTx4bLmtCUj91Usn0hUuokiZ31V0Mrs/sAmu?=
 =?us-ascii?Q?cj2bzzIAmLCzevO3qTNt1oiE4hshFYGWg7S6CPEMo4w/T9divAm27dgXRZZp?=
 =?us-ascii?Q?3fVwVMjdwO1Eg93e78Wv96H71yRohpmMSGDyqjceLZjYe2KnBRsiFWBT1YHJ?=
 =?us-ascii?Q?yS1RXY0axvKz0+RzY8HyvXgIFsrDP0HIqwL5tJNM8vBPEKGynAPU92UhbZrF?=
 =?us-ascii?Q?SECa1V2q+ajBSW+XPu5M+G4YLciiLKEsxa6LEs0xB9igEcOblJNR3YTh+Qqg?=
 =?us-ascii?Q?mHxbx04WFzRPHRYEGzdqRXufkveRsap0P6UiF5YQA1O6S6+qFeJQCEtEYLkU?=
 =?us-ascii?Q?f7BUaW5YRyyQm+UXrtxsBx0HfK4JoMuN8Bd1xak8IBuUn5AFJDF0UFk16DNN?=
 =?us-ascii?Q?r1PkexTE4C0ZQSki6ixxdUhIqiC7q0VWojo6Xpba6ELy4g3avxnEk2xdyuy7?=
 =?us-ascii?Q?BECccBzxWzpOMSl2a6nZnYCep67E0DFPLk/7bSlVtZbPNGawv8d9Ht6Rs8L/?=
 =?us-ascii?Q?1DRWohth+tMPNTdKVxdOQ8lgD49lGLHTIbXivk95+EFva0FWEoQ3QwZZ47R8?=
 =?us-ascii?Q?CBPlS3GPFda7D2+S6B1bo4p1qYx5QjoNoqqBhPQG7zHAaLDEFYDPREeaFaCX?=
 =?us-ascii?Q?gOq4WN8QfxZcVFcMSQVo2p6tk3TRpq2v0PHa0DL0TQM7ga3oG+KcMaevualG?=
 =?us-ascii?Q?Dn/3kwfwyQQU32PDveg6ycNtROH7rUhgqXOMjuK5IO/Yom2H5DAO4MCaGEWL?=
 =?us-ascii?Q?SE1c9KY6kpvCg45CpNmmy5RsfulwNCaO47s19Tjs4c31RdDXdgS+1FSYc4+n?=
 =?us-ascii?Q?ODNyor5jOVThOvxmZf9Xp7Nk6m/w/4tSl/V0WLBzyiSa1ReLyP4jiOVQCI/q?=
 =?us-ascii?Q?2F3WbRHlG2h7ge/poaCQsWVjraXXcsVv6LRE1mYUsPOEgibt0WT7HzQhPMBG?=
 =?us-ascii?Q?5ShZ+SM0dsDeCzkW4V85rdoTSYvo0MnPJ/oTVmYTGmz1bd/S2Wlq4R3ddHaX?=
 =?us-ascii?Q?Z5GSBBjq7H/klFtF5fYt1lR7iXS2Dd10jmoa9kxbKGMqPQgq0+pfGRZ8pO1V?=
 =?us-ascii?Q?KR2Gk1EzPXKAhnlmTrDzaKxM+1cvAM80kXGbKsyPemdUS4hFzdIF0pGHCgrD?=
 =?us-ascii?Q?4c0Z4BDMBaH65PDNd6j+GSGq/DXD6Fx1yPphus+8lYg7d/74OptVYrkJ8oTa?=
 =?us-ascii?Q?9Bep3RpCDjm+qh10mNUx7ONNsCcxh8pjcOvFlOMQ?=
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
	Sz9Yi3d8tiY2/ySacoWQSh+5D9kEUC59IJl1PzO4LvHC1SQYWAWI4EJkUip/rQJ5dC/MX+T+O8mlHjSkw9CpAvkeNtj6RjIgZPtVgA981DvwnLf4ybMO/R8e3Iuw8M3JyS7gnmcqKe5L6FmGVgweHCn0Uw0WQNlcnOtgkp9IdYK2wQJUJji8dYAEeQ479wLvUUhu6+fA/D7CoTdtz7EVbLwzt6IUzC2wosYLqEG8011gZoaZfQyXqlSogeKB4FFsiE0pDfCeWBTUpbeljcwkC+pkCFcjhsmpxpgG43Rw/UA+5rhcdLrPzYiMRNjmMoCbZuy+fgvfjjjQg2S9Cp30WKDCDsaz8fNHZKwaM/gySBdZtNVzJKa8/d4FxNb5/8Jxza0bpqvUxW1fhGQCtZqsVr3QYGitWSE2fF+lA8jlZYrhcgge7M67kdohwgnXbm0IvC6KX972G1mH8PRriicrF/DOJ1juyqJdlV/RUEzaGVnu+EAuAvHLPtIPkS3eaT1IQNPsPnsUj5BjqxiPBK5oPdKxIM1xJ7sVDWJmhjtuspLhELLDj1nId0lQg6rlajH/5/WzTFA/mZWf61i52L08PAX6/gVRMLeTtheCi6mFto93Pmcr/Mw8JipU+2QIYBbk
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a505c25d-3bd1-43e2-3338-08dc3f4d023e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2024 08:51:56.2301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a2ZEXbQVDz18THD/KnzqHslR7LJvtjj99FKhiU6VzffWNpNaV4PkFlxgZAWKpXdzk4nxXCUp36AK2LV9Z4gCPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR04MB8461

> From: Peter Wang <peter.wang@mediatek.com>
>=20
> From: Po-Wen Kao <powen.kao@mediatek.com>
>=20
> Add new mediatek host cap UFS_MTK_CAP_DISABLE_MCQ to allow disable
> MCQ feature by assigning dts boolean property "mediatek,ufs-disable-mcq""
>=20
> Reviewed-by: Peter Wang <peter.wang@mediatek.com>
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
> Signed-off-by: Po-Wen Kao <powen.kao@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>


> ---
>  drivers/ufs/host/ufs-mediatek.c | 12 ++++++++++++  drivers/ufs/host/ufs-
> mediatek.h |  1 +
>  2 files changed, 13 insertions(+)
>=20
> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 0262e8994236..cdf29cfa490b 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -640,6 +640,9 @@ static void ufs_mtk_init_host_caps(struct ufs_hba *hb=
a)
>         if (of_property_read_bool(np, "mediatek,ufs-tx-skew-fix"))
>                 host->caps |=3D UFS_MTK_CAP_TX_SKEW_FIX;
>=20
> +       if (of_property_read_bool(np, "mediatek,ufs-disable-mcq"))
> +               host->caps |=3D UFS_MTK_CAP_DISABLE_MCQ;
> +
>         dev_info(hba->dev, "caps: 0x%x", host->caps);  }
>=20
> @@ -874,6 +877,9 @@ static void ufs_mtk_init_mcq_irq(struct ufs_hba *hba)
>         host->mcq_nr_intr =3D UFSHCD_MAX_Q_NR;
>         pdev =3D container_of(hba->dev, struct platform_device, dev);
>=20
> +       if (host->caps & UFS_MTK_CAP_DISABLE_MCQ)
> +               goto failed;
> +
>         for (i =3D 0; i < host->mcq_nr_intr; i++) {
>                 /* irq index 0 is legacy irq, sq/cq irq start from index =
1 */
>                 irq =3D platform_get_irq(pdev, i + 1); @@ -1585,6 +1591,1=
2 @@ static
> int ufs_mtk_clk_scale_notify(struct ufs_hba *hba, bool scale_up,
>=20
>  static int ufs_mtk_get_hba_mac(struct ufs_hba *hba)  {
> +       struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
> +
> +       /* MCQ operation not permitted */
> +       if (host->caps & UFS_MTK_CAP_DISABLE_MCQ)
> +               return -EPERM;
> +
>         return MAX_SUPP_MAC;
>  }
>=20
> diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-media=
tek.h
> index 146c25080599..79c64de25254 100644
> --- a/drivers/ufs/host/ufs-mediatek.h
> +++ b/drivers/ufs/host/ufs-mediatek.h
> @@ -143,6 +143,7 @@ enum ufs_mtk_host_caps {
>         UFS_MTK_CAP_ALLOW_VCCQX_LPM            =3D 1 << 5,
>         UFS_MTK_CAP_PMC_VIA_FASTAUTO           =3D 1 << 6,
>         UFS_MTK_CAP_TX_SKEW_FIX                =3D 1 << 7,
> +       UFS_MTK_CAP_DISABLE_MCQ                =3D 1 << 8,
>  };
>=20
>  struct ufs_mtk_crypt_cfg {
> --
> 2.18.0

