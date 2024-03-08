Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5D1208B8
	for <linux-scsi@vger.kernel.org>; Fri,  8 Mar 2024 08:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709887294; cv=fail; b=AVwl15T8vc6fBJegtSsL0VBe4/mo8A3F0T8ztzJOuxItHpu0fBhV0/+rXFQcVOTwb5qaXejCvRupzxAN/CBTwPdaL/m2Z0ZMG1IoeZ9khv0LeV0sCSDZV7k7K7S13SGrSJm1ZFKtxD5gjmLkT36BzttO2o97I3FPAM34kXWonUs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709887294; c=relaxed/simple;
	bh=i8v6S6oGZ7WliTMyCZ2B2Edwil4TkrpL8LnXU5YkHNs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=V8VQFXsNNxDaqyl7NoAG30gEiZPzWkJC7l1uNaLYK4j5iyv+AMYdHZu5od4YTlzlnox1T1GaObAj9hIH4Q9kZ7bEFE9ZR0kldEsfki9bK9HyXuD9cDU7Hb3uMHcMCVbZjAsS9orO+eCPU3vUB9UO9gdnxtSgCmxJhrpcGs7km54=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=fgj1wl8y; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Ud4O07jU; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fgj1wl8y";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Ud4O07jU"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1709887292; x=1741423292;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=i8v6S6oGZ7WliTMyCZ2B2Edwil4TkrpL8LnXU5YkHNs=;
  b=fgj1wl8ydSftX9xSXhXUF8dsgzotwmJH0jo8fjFyKWpf4wlHwdTp3k3I
   Hx1FOmQa0lyNOIqFREdhh4O95RYMTzfTLdpVDsa0mJyDbQGz/X5SOEhT8
   ptprr/Sv+280OrD4tapAIEfbZxDJdfbX4qUa1RLRXHc6y2UrTQYh8TNt3
   tnI9NOMJkeQsRF3qQ9Y9+IzOCN5M6EZpExZYY05S4HzXUBMFiCUVCRnTC
   IF0JQG3k8QQjG/QYc3ZmtvUuzbtaVNC3P2ePM/Z4mAG6jAh9+9qCzjTLf
   Fkt/itiqZoGbO0YI3lsttNonNb3Uvlr1IYNs8+HBkSO3TVl+R5ltLRryA
   g==;
X-CSE-ConnectionGUID: YvNFypSdQZ2PAmF5M6fNcw==
X-CSE-MsgGUID: EPqiZYFvTeuCz8sWGsFCNA==
X-IronPort-AV: E=Sophos;i="6.07,109,1708358400"; 
   d="scan'208";a="11358316"
Received: from mail-dm6nam11lp2169.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.169])
  by ob1.hgst.iphmx.com with ESMTP; 08 Mar 2024 16:41:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YcuWi+gA2eaW7XT6M1e4npZmGE31x+d2rMPrBdwKrxU/XFVaRBBWHd8mS3DkF3rBlqJ02Jvel3SQTpQgUnVRM/G5HzMT50Ke6ySbjAEEwbi0jUs+geg8t+BWA8p6MXM7Hia5+CGRDSHU3jHckucWVA4ZMUQY77hu/61ZuX8pA+zHqgMh2wwQBvzwgUDRKgOXRvDEUQRQfhNGkqYfYRnzAplHW30z91lpB08h9kXye/OhoVcoL5XUj0HYWDhwRAmijhzc4UyUnncH2IIpBkkWMiUM1JCyJ/PQ5clFY8lkGD8L4TsefoMyXeGzEOob7/TNstLN1OoILUESx8Rur1w4mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W/tU78b3cQ2nHoXzrFz0p4lDm12FbH+qSwTO55F2efI=;
 b=k5/LCY452/6C3NC0Re06hJhhTLCzRHs8pU2riB442o3V1JS/vqZPkfLK5GMaBfO/VQeuBwa6EjhtbWHpfa3SzhTk8PjkIIFiXXlJtNFjVQ0hsIZREqRryaZ5kF+UR3rIMQSAB9tL5iXdVCtMoMJ/bIX783QrpqK3fuS5bWkz8VeUf5DJ9HgOCaRXM4DkSQZW7YAMlKGVzGIz61A9nu6fqY0SIdG4liEewkfCpQ9uRWLkZoJAYHb/n4GYdyRE1N1H3CmraRZ9bkWTsiijFMO4TaWN2ZG0Mj029ogOLFy+qA0i5IaauZ+wBYc3YUujcXsuVxIwAs6dpcevA+c0nOvmAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W/tU78b3cQ2nHoXzrFz0p4lDm12FbH+qSwTO55F2efI=;
 b=Ud4O07jU5J0N0fy0VFL69TefnceDGXTgDSAAwPbV4lIqrOVPIe3XFqqr7/hgjeqxTGT25oGaEkWX/YoFgTVow9WMH4icUH9wgqarEXdmg+dxCjW81vJIpWI2ToX6YtNsWtJRWeiBO8fkYtOKx/cJIZla5pQC3Tpx8BCOJGsIcfo=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 MW6PR04MB8819.namprd04.prod.outlook.com (2603:10b6:303:23b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.26; Fri, 8 Mar
 2024 08:41:25 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5395:f1:f080:8605]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5395:f1:f080:8605%3]) with mapi id 15.20.7362.024; Fri, 8 Mar 2024
 08:41:25 +0000
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
Thread-Index: AQHacSaqoUvce3CwLU249nWufxiG37EthdrQ
Date: Fri, 8 Mar 2024 08:41:25 +0000
Message-ID:
 <DM6PR04MB6575155021E474B0A5CF4642FC272@DM6PR04MB6575.namprd04.prod.outlook.com>
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
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|MW6PR04MB8819:EE_
x-ms-office365-filtering-correlation-id: 607a7236-0374-4d83-daa8-08dc3f4b8a1c
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 qd9Z2/GHvTX/5HD4VDDNr0gOOe5fAXqo+gmn00t8kiwPuVg8e5pR1s9UY4QiH4nsByhQI3Re7mqhlECUazcYnqQR+YojFSzkkUr04WHQeSZg8IykhUp8w7k7F6fTOcCk5858Lem0P+JGiaCY3m+Vxe5JO9lbJFJZ2Rqn9klpurzE5W9br/kpT7I//3+oeuDJ9dOcUYlqs0GAN2ivjXCpMrMOsj7EWX4A4SiM0QQro/hxJzmn0yIX0TASnRSqRJsxmu2iCTvHy05DuH3oNnPaLAzVJ32JVI2L1527TsFwJ5PSuctl2GrjLQpDrrx3XqHmO4tLy7naHB0yj4zRlj/RClpNPXu6orP/e3DsuLkckCC7VHurnQUzF6MXZByRfLpMH8jbLzUR04jiGOfIP8DDaiq5+5UMSPIZqWZDSLXL6+RtyxeBNj3exG2RJBNkZPPmETWcsxI8MK+L8YF/haRc7LE63MtziCwlPVA/EKGsq06lbfUeApvEpcEeelHVQERB2yn4+1Sjmj93n7GhgIzAMWgOd1X88G1ZEIN89IcOtBEgw+DC8SQTxo5zacdLcueYOFH1DiHLYHlXGU4mdejfE2rilZjct2xM1IZqZlXTwP9vTsDJkaMVuDyT0VlUOV31q8gdqghtt/WZPz9pXOluDyMDvkkgZWZiMTdlwejEJSCJVs7bfP6Zn9ex2fJNMuzA8LwhhdET7gwt6uhSEjwBp6kliWFD8RqrT5tCKmgA8dg=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?jt7w+cHcWC61yq05R7cBjU+35sfDxlIo649eOApLux9QXpK0wcXOgSoNxHIC?=
 =?us-ascii?Q?xL0x4k6Epj2xzgzvqCsliNZ28jik7lJ2xH1eJHkGfRMXy/H6xTQKC4zng0ni?=
 =?us-ascii?Q?RswIahDrBH9WZ0sYzywLwqZZt4XXlWCMV2D54ZZjMPOu7w0Y3kPXMv+IEs3F?=
 =?us-ascii?Q?5dGOJ1fgS5JL/0eyxiQOqI2tvdDvSKNxwBRvD9r4TMzd3qS9Vud6vPXzfqWQ?=
 =?us-ascii?Q?GDHyhKspS8epE8EdSbrn1St2pW385SlVwBngcssRKwzNOtBzTv4E48OugLXR?=
 =?us-ascii?Q?EGADAtufnqCKfv9zu7Aeb5QkmMgemEiAqSYsxZ+FOeerbQjyYPPo1/9uoBEU?=
 =?us-ascii?Q?DJLUYM9VvwMjgCpoF5b/vSTIdAb+OcXZaixJIz/Jj07h8KaEJuudQx8S4Lal?=
 =?us-ascii?Q?m9rK44757i+tdX/u10Pg1OLSQQ/SHIUvVTNwsKGvoALdXwRGx0YrHY9JLDsk?=
 =?us-ascii?Q?PPbrbyLw4t9kLEYm6MSyYfgQVBCzwt+fLOKfNF9DDUgDMLYkiQTvyUROOih7?=
 =?us-ascii?Q?tSZDZKoxvaoysZ2EgiJOTIhM5PDHFuxqOOQOT7OZUZiARqG6voHdREWRTebC?=
 =?us-ascii?Q?WgeVHUQeF1sduTVDsLIWg/HJhEATrzXZHAKXtLwhei7duCUdoqoGhSIB1kSL?=
 =?us-ascii?Q?7hnlp7WHtBrMWG6w7s5pJqRZoX9+RBEv04zSiJTz7Gezxnv0iozQ3OOAcGIS?=
 =?us-ascii?Q?FdNNQnAaRZheCqBmI4NQrEWUp9EcEjZxCxWlJo2dZ7QY5SLmb/oTxBp32Jwt?=
 =?us-ascii?Q?MaE/uqFiVhLMcqvjnCticdqtMhaHP/J/Jf462zY50GzZDgkNM+Q02yZdEnfj?=
 =?us-ascii?Q?6Pxd/jfFh7FB2cRgxM24mEHkHNkWdISJgGpuj0bC9O8a3UiErybJAEkx2pBh?=
 =?us-ascii?Q?yX/65olLwnoYxvmMhQIABgE0L/xUR289uKQi4LKdwQkHTvrL8XnTP9KMO/m0?=
 =?us-ascii?Q?U+HAdrkLFg1XYkJr2RMGFUCbrP3h/iOCta43fp8W0MMudt/CC3R6HSolvEnh?=
 =?us-ascii?Q?6kyDTFcvl9VeOZMIdXD8kfRtjaPyCIDgEJjlvW7PHgZlqT1RT0xGmFi3M8dL?=
 =?us-ascii?Q?bLMYc8nDXY/fM2WRQK99M7qJU6WBQC+hXuUi4TFwUfZQ78XmWLxesohU5zXU?=
 =?us-ascii?Q?gelN+ARr8TU3BliSM8gyzTdRdmixo/S4MIMtzk7Bs8WpHSdCZC4hqB82dwtR?=
 =?us-ascii?Q?zLW80QIpoiTJ2bORwCghd7nwH9QiebpcNnSceJnn/4CjCkAzjqUvsnv+BxQO?=
 =?us-ascii?Q?fv1NSJ30Ln32wfJnvDL66JbdrWdkKDJxJ1dyMOivGw/IKhERIKYjSUiKdRPR?=
 =?us-ascii?Q?VYq01x2j2Bnq/y+PwbsldaUuiCfurzTCOA02Gz/5H32omL/RwZG3E+JF/cwi?=
 =?us-ascii?Q?lyS4Zjxd/9qKk4J+ryYS1bDKUuEm5ObB9sfGqDXZg7sRpefGcVDN82hlCitG?=
 =?us-ascii?Q?JfPAh4Aj7860E0x2oVkfhsNBp5UU4fdV536gYkb0sGyoRpkKswjj41as/TuH?=
 =?us-ascii?Q?VdLXr7vje572Gssh/5Hb7He1D80eEkRRf80mPAfu3E6w74YW3pg3uB9xvPR+?=
 =?us-ascii?Q?YveWxqAW3pcsVOndKLQiv8CUMP6epTYqxf5JXFP8?=
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
	VjDfJyMe/uqV2nyAeknZ+MhewTcWKDVItoInXY1lazQBigzG6AaAo9WcDqwsNDEGjaUra+1L4iicVgKocM+kLfVkiPnw9qUa3GPJRHr1WRmhMRqqwNf2Erf3H5o9PAD80tjx4fN/HH4ty/r5+wkfsIvdfvDF1VzLHec60ADU5odmK+dqRdCK+HepdJdTxVp0fInItrcsExtwq8WziXOCA261iovmrRYVEydJUdNRWPN4NoG5oSbBNKW4d9mQxgSoMFuxjYVCW4VZj/VNJdoyN4zsB6x+OiarSG+X1CrAUHsbUV2bRMJ+jVgk8vz3bDHJruI6yyuw4dJtI8R7oWQqd7ROirXJImW/IS20KLI94suWpTj007XEaqGHUdIs2Z0tpGb23V3sb+O6Q98z5MAmPrM+e5sRjuuWdO+61N+UBIllUn6fVqlMOd9eqdcv+mDGDaCnFT8aPt/ddPtJvcb5sl6YFVBJot0VZaQVUSVWcGqwG+6SH+dzLL8AgdidHMaVHm44vpCs5kcvZPkhQDnZ1fPAare4CZEtUDQAn1yXqdh+HGTfsb3ivNIirs7/MuVpIvKi2LuR0tOkDb1NZVWg9pXjbrTvCseBgiK+qHxHJAW3jVdRf2lfkWjhw4DUyhKp
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 607a7236-0374-4d83-daa8-08dc3f4b8a1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2024 08:41:25.1611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: afiBsDt9geNLUDvylKmljLYnbZpJiDVgLEEgOxzJUM1e02Y2kn0cxMD9WZx8sXB3wC2MlN8LjbXSbj5CvLy5aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR04MB8819

=20
> From: Peter Wang <peter.wang@mediatek.com>
>=20
> Mediatek tx skew issue fix by check dts setting and vendor/model.
> Then set PA_TACTIVATE set 8
>=20
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
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
Is this a quirk for micron? Why not implemented as a quirk?
And go for all this trouble setting it in the dt etc.

Thanks,
Avri

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

