Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3811E53A
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jun 2024 06:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718691810; cv=fail; b=Rh37UrB+SX2kuCvvSEyfU0b1MQUAShePtNmztu5HG8VG5CqHqSSRJZQliXa5x4MSZ4ZBt3AhHHH64o/55BejfiR33ma7Hm8dK2ALiakMGPYUuaMIYdXNUnH1/D64xGPCZPLz3ThCGK90qotHNjzoh2GLcZXqxipAmaW84qv+U6Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718691810; c=relaxed/simple;
	bh=Nc/Ni43uoWxcGfUsB/kIs4z8Mp/Ybc8yrpdvfbvh51c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gH5IDr7AvhF8UvMfbL8GSCwd44Jd9Tc0YSZ2/XS1X3pK+VyUM4mjn8Y7NPehez7M8hrbpZulrAmZsPKgE8EEfvhR8w0Pfc2V2fuJ3Rlqpv3GBxy7ITcGuYfI7f3oba7aW2lMoUh525wT+JLAPWbLMnyp1YnoQAfuoS1dVjIL47M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=IWwB8Zhs; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=uUaG/ngb; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="IWwB8Zhs";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="uUaG/ngb"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1718691808; x=1750227808;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Nc/Ni43uoWxcGfUsB/kIs4z8Mp/Ybc8yrpdvfbvh51c=;
  b=IWwB8ZhsBODopulbncZ9neHGXmWixIcG1PaUffNurMo43TD1qm+W9vOg
   GfKCwuNrXjZ3JuW5JONnyxjQrVcruRfo5Mx/JyfRZt2cmBFhjh02Ue4bt
   PlxnYvZglkTPRsYjUjc3E5lycS9kIzSsIKhznGJpSfmdNJOSG8DY18BrH
   BU5oU1Y98JE3b3mCgUApD3F/7lOE4hoO5cBqmQSHNA/Ef4s2oaA7qZTys
   74B8C6/OUu/+rmJeXawZiiOcZkA5G0FY6Rh753C+QsdF1kEdXWoLiEB/E
   jw7oo86jsqYnDdkWSXNLNepFF/NFZmByOxUBksQIQ9EIpv1m5VdH4QZy5
   A==;
X-CSE-ConnectionGUID: 2jjO9+kqS7i3nzTxtwR6Ww==
X-CSE-MsgGUID: VpumYhDERfGTH4Z70LonHA==
X-IronPort-AV: E=Sophos;i="6.08,247,1712592000"; 
   d="scan'208";a="19685942"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jun 2024 14:23:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fFMg7mVi9pixg1sQqO1zTgSXCeqLtIubMoUr+yxJc1LmBswhuJ2NqZVKUnIDTjAKU3NBXKpt1oalssyFmYYmkzuxgrGKk0nJN3zDqdtCKt/3Ixz1QE76FmNYFfMFRJLXb0isqbcO6xjKorBtCYwysZSCChOA1b5SIq55nygX7hCd+3OfZo4dbSgvcOwgiIygOTkkcB0RTfnFn/quvMOGHhd+E/aLoweSuyz6BOC5XSnQIhA9lJ6w3oVgriKpWk6ZiE+JRO6eOg7lPgC9kGDfD2AptNtFcDLV/lmXHDi87+dMqKtQzUo5mH9lBpjfyBOlaJplwOWHP6ilahtvLxMhfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EcwcBWxDC/0BkewBg40YwpFRm/aF4/Df8Tna08IKsSs=;
 b=ncTsCDq6ENVTO+ncROw9Grofqo1Vvmuv5XhD598pCTjIvFWXzhKezrUcVb09M9Xi2S8AtlGvrN6JwzUTns5CNnWI993/3scA5k7SChYiy+ctbNNMKzHn1L7LmJF8WlEVpTWPp7gdI/e9KkFOeKlMXHVjkAzzsQr4oqDU4KUp3SNAZXHmALGyPTARw9SUrC/g0bO1ifVpiXj3osib+31pZGFZJXkJa2aBtUVP9s57q8tEsKjijoDtJzO6Iq+isvjD8NgNPycqDOKESdQxxyv9l6fDzkkw84Ys6JCYYzfNfExTfv/uyeqHyLdx8HhaQH+5gIeEDUQWeUjqbUMMWkKuPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EcwcBWxDC/0BkewBg40YwpFRm/aF4/Df8Tna08IKsSs=;
 b=uUaG/ngbNAYJzeqRzHuQ/24vCxcR7zplkpoqtPqwdfU3TAxlyAqOalzCd5huC5xsEIotKOGKGXQ+FoV56neOYNWMgy5VFIc1S7TPeD9P7TOvaqXj6R38aIHmRZixP5bTRz0K90uuniOZvHQmmYTd4UiW2zT3C5ACwsn5o4A7DMw=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6745.namprd04.prod.outlook.com (2603:10b6:5:22a::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.31; Tue, 18 Jun 2024 06:23:25 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%6]) with mapi id 15.20.7677.030; Tue, 18 Jun 2024
 06:23:25 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Minwoo Im
	<minwoo.im@samsung.com>, Peter Wang <peter.wang@mediatek.com>, ChanWoo Lee
	<cw9316.lee@samsung.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, Po-Wen
 Kao <powen.kao@mediatek.com>, Yang Li <yang.lee@linux.alibaba.com>, Keoseong
 Park <keosung.park@samsung.com>
Subject: RE: [PATCH 3/8] scsi: ufs: Inline ufshcd_mcq_vops_get_hba_mac()
Thread-Topic: [PATCH 3/8] scsi: ufs: Inline ufshcd_mcq_vops_get_hba_mac()
Thread-Index: AQHawPqpKtw7w6+dy0m5D1g7hSR4srHNDX1g
Date: Tue, 18 Jun 2024 06:23:25 +0000
Message-ID:
 <DM6PR04MB6575721D80D8B63E840E9941FCCE2@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240617210844.337476-1-bvanassche@acm.org>
 <20240617210844.337476-4-bvanassche@acm.org>
In-Reply-To: <20240617210844.337476-4-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|DM6PR04MB6745:EE_
x-ms-office365-filtering-correlation-id: afc0868e-59a4-439f-5dfc-08dc8f5f28f7
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230037|376011|7416011|1800799021|366013|38070700015;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?U1PmbnAiCMWAFOXOAWeXKVVDgNwc8jgnfeEZ3VB1Ox9qBXI2xWsjACZAQqei?=
 =?us-ascii?Q?6LLJSpqbcTANl8QDfEww+HGuQf5AGTcdklGDKR8yibMCT610avKSJ5W+eQ2O?=
 =?us-ascii?Q?AJT5IdToRX0LJRqrr/deHEWSrS1vmiilldOTx5QcTUr4VVqLYCT/Bgwbvjp5?=
 =?us-ascii?Q?CHOoQoc5f3tBk/eUfN3dmneAOBdA0devfUZJHYJzkvanpP8PwFwjd6eoFfUK?=
 =?us-ascii?Q?VxZA4V/9TSSIU1piLHugp6KBSaHlvcJWPCIsS0Hw1osL3I6A8piKUmNdqP+/?=
 =?us-ascii?Q?Zly+EhpsDNhvUQvQqQbMao6Nt20lffuDfcNpbDXffXAT6yFgLTksmmpefUvH?=
 =?us-ascii?Q?ZSzYyWsbpIUSR/sPn00/f5lkC7buSDe9xsjmNUnrXn5cLdn2+iqwWXB0dI56?=
 =?us-ascii?Q?qOvxLypDiO+s6+e9fHu4d/5AsoP6btJs+Y1PnFXas1d+/MsuPf9+32wIpmGl?=
 =?us-ascii?Q?6Brl7ebRRqKbZ50KWjG3DsdvZ73Ue2zTfFK1inVJ5ZwUQmni9T/QWrYp8sj1?=
 =?us-ascii?Q?QcNKJPF5lDdj4S6ZmeWX8+NX0pKC1bsCqI0pZOPQWg103ECCF4nQAVbotLPD?=
 =?us-ascii?Q?WoOtvrUNGOoI/TDfJRpudYWIvsUQWHGelGY9iR5nMrT53oTc+vJEsoUmpvBY?=
 =?us-ascii?Q?BaJkcrZ981Hbs3zMKO9sLEYxQThJ+qbx2lVttpqzXIbJgm04FhrKBB0KY2Ns?=
 =?us-ascii?Q?UbJuw+Jq5jhDbN11MiX4VgWhbQyguUc3r96bpdU78VlvelW+xgXIcxDQSBAb?=
 =?us-ascii?Q?EdyLNK+qO+ly69FsgrYADMncSFrFwQjEEqzlvXAFoEwnMjhJjCqPLieAXbO0?=
 =?us-ascii?Q?Gb+P83Svt97cbBfjnj4510lV/sbPfb/Lb+rbaGx4lw+1LsbGfz5mxK6I1A0E?=
 =?us-ascii?Q?R4yfryvb1OJ6x4PhGY4Kpud4LfcL+foFZ0enP+lU05M6Zt4VULpyo0PU3QK8?=
 =?us-ascii?Q?+DxAV0isRZrcj0kSVbYbKxnvaGB6+AOYwru4ZR9SckZWJwBTyAna0PWAEsES?=
 =?us-ascii?Q?ONqV6CbO5ZCPCyTZDNawLvEL4eV7xET49sI6zEO9GyR7ZD7pCjveNrN2Pivk?=
 =?us-ascii?Q?0i5YmsO3LkVq01toCWUCmDQk6DzPEtWc4Udj+AuE3zQ5EOr5wyVCENfT+okF?=
 =?us-ascii?Q?8pcr0cPIC00/53TNeGzyAm6M5cTrVoZi1/kyTOeqZOjOv+UFIBBHPmD0DWa2?=
 =?us-ascii?Q?D7lnvvYeC815SmTJzMfNoxrABFWgKjW9jfRy1pLILn/fxBWU20+EDKE9kxZS?=
 =?us-ascii?Q?2eSrqc/JnzQ1fgdgYwj3gZVbtZSqknbyApt1bEu6AUxlnMVic19v6AQzXwGy?=
 =?us-ascii?Q?KCilPQ+6Ts9nmOEXT/A4/gQ0KwwCOzUGpsByn2XWCzaVkUtZTfveL/sna0xr?=
 =?us-ascii?Q?WtGvO0Y=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(7416011)(1800799021)(366013)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?ze7awJohKqLECPVCp2kc18MLoJhABldCsbJ0BHQ+4/rDDoawvSa8F1CqkRRE?=
 =?us-ascii?Q?oRPgqELaKDyQHLFAJZfsY7ddYsUeARm7JY1zDypXo2ChOOoEvcWfRdgAzkb4?=
 =?us-ascii?Q?yjH0fH6lYwIPoid8JIDGv7P9gnf6NfIKgQ7Op3CKUBC19GOQaJqN5EnLykOH?=
 =?us-ascii?Q?QgUVoO+xDs8CKwHzbzByq13hiy0JywFAAUwBOqYnznM24swT9iO6Ej6NhpuF?=
 =?us-ascii?Q?P4xHjv5l9vCQGekdVWJT5pX4YcCLu63BEdbgfpoE4Xs08EC8JllPrIAzEFZY?=
 =?us-ascii?Q?zAVtUpJFy0JxLjK4Qd62DA8SqGS6WUS/6k00npMf+efftfiGWrsIWtMAM70X?=
 =?us-ascii?Q?Vhq5LwXeldP5buh7ympHmkiNaua81LSV5DUx0Ez8hQaZZ41R/fBOQrWsIyFn?=
 =?us-ascii?Q?kGdliwI/1MitDN6ffFHItUAXxi1kYZ4K/prJa1OPie8+kxgMQOUSpMAo4ke5?=
 =?us-ascii?Q?4NsR3oGmEKyCFF69AWh0KlRgKCh6GP2fK2BLmIwC2HpX8Ot0YvJ0VwI4jGg0?=
 =?us-ascii?Q?KIPwTcrkfdu6OBlB6vDMffVhleeRM3VW9jKSGb91CEE1BAmZ3ldG99mcect4?=
 =?us-ascii?Q?P/ZKewAVV+YCkLJC7L7ausiwQO85gRHP7cvXQPprm2p8vNIcYPYW7ujXdcbY?=
 =?us-ascii?Q?S6XTT4Z74jqtYZGUcCtAE2d9DEEHegW2IEMOmfJ5hMmjmvWRO6EsT4rmsb2I?=
 =?us-ascii?Q?gHwEQwas+4eR9I+ImRqmQdfRWo4VBnJWNfBJ8FGtHqdpkeQnRA1FVWargFCA?=
 =?us-ascii?Q?grzLd/aG5ww1Tli2i9zVhqmSdBGa8fpHCZelsgvTcd8U2H4JB5KlDiaTIW2Z?=
 =?us-ascii?Q?4ZNhj3ZSQkm9s2nckR7eX7WMxZiJPg81eg24hf9GjjCBDYUtgS8DcL2wusqK?=
 =?us-ascii?Q?pmlNmE5p8+ol7SLARSpNNdYzxnlpERnQUEbulz6jHR9PUTH6O1xeSIiXDNPt?=
 =?us-ascii?Q?34fIB647aRnWNV6GirtcmCO8zPMUkDMGz3n+Ziby2EJye+pANnP926+4t2hj?=
 =?us-ascii?Q?GJejeiADv9y1jodm7xiVPh/gNTkQa0L0vfDF5yBy2WY97D6RygqNjrdrc18O?=
 =?us-ascii?Q?Ag/ImYGBlh4/kWacS872mIHY3GlPXrJtGK7v00xmQItQR/T7f1lVoT7b3QF9?=
 =?us-ascii?Q?HS0E9rOISNfyFmmNlDS8kyXlmA3n87fd+9f9/jAQFynHnsN+fi4a+UQ5xgwW?=
 =?us-ascii?Q?vNaSazDG0/evr3u6ujUeX9WmS+9CPP4L+u6dnHNk24aAim7mLGB1hOO6yqYi?=
 =?us-ascii?Q?AAw6IR5H/nMnJ9zzmtY5I/klFbpofsU5LKyYLTI4SBPHlX3/tC3OxudFEnau?=
 =?us-ascii?Q?KKtOd8/OLfZ2eI/rYPci8w2w2GgPGT8+butzY298nBMPQ0jSf1PldoDt+Kau?=
 =?us-ascii?Q?30hnS1No+8YM4ZpXmxcXecvF7FVnpATdDAXxdtKrHGUiysUJjD5MJziL6gLT?=
 =?us-ascii?Q?cbmDPfgUUMDqVCbvn6npUSNcm2bVNChNb/iN+ZC/jceYJAQW9eBnfDxOZWo7?=
 =?us-ascii?Q?mQPfkWSCD2Uvq6XMaXun8ZQ4lyvHrmb9wIGhw1Te7c/8kKMRQBah08UyDLy7?=
 =?us-ascii?Q?U0qZzvLLWyCd5Pl/YXDWEXz9pTvWuUFhEQpFgcWu?=
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
	oR95oPrfbXadDVpl8V3X416KLd4mV1/HsNNmLS6UaCm2ig9KHgwR960ZSNR7cConlY7o8U6UZLB+SUFkRf63ajXmQjbjvEU15leixnuKJw4GqvX+TPjmhElGSJEfTWtDFBCz5JmG/UoBtD3IPtfTg/UAQ53xoVU+k/OSynHYBt4MmkH2aBWDbG/0k1Zcqqc90xqLZPJVm7XH9AdoP3AWknzuPxH7c+La6TsD8tIRkmgwDt/ksbRUStf0uPfmA064gc0Bole0koHghz3jn1zQ00YsyRwDbO6pZvxvIWeSaMo0wOjwEzxeaX/wj8OVCfpDQR4Nms9UWprvmsGEV0v8DahwXhsQ+Q4a35hmw9upDYyfSiCpYNIliqnecsvFgdFbh+Lk1MHuL631IAe5s9lAKNZIwH4ACga3hYjI3Zb4SLwNrmiRtAGFdtcSv/zMzzFWwO6vta1XoubAfu9jb4NWAoadwQqL1WARtL96VKQkDw9pdU8q+J0QFjNOa30OGXpvdKI8uaUMy5vnFpRrKJdYEN6N8eGnp8GdillYahe4BhyjwdESCcXSf/sHSf1+fQV8Wkmbq6GMDjF4USv12CRiO1VKbfnpQ5x/SyX1FPnttpqfSQ/MgDgVgZth80LFJcZU
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afc0868e-59a4-439f-5dfc-08dc8f5f28f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2024 06:23:25.1531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NRhNU9fY1Edk9n7F5HzCvHljK2BXMCrmU0EDQIPnlXbaNDu+06UDJXtEzUaQYDQyYEIp3yJ8/KGrQUOELtKmNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6745


> Make ufshcd_mcq_decide_queue_depth() easier to read by inlining
> ufshcd_mcq_vops_get_hba_mac().
This changes its functionality by making it non-mandatory.
Maybe relate to that in the commit log.
Also, it would make sense to squash it to the next patch, so your line of r=
easoning is clear.

Thanks,
Avri

>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufs-mcq.c     | 18 +++++++++++-------
>  drivers/ufs/core/ufshcd-priv.h |  8 --------
>  2 files changed, 11 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c inde=
x
> 4bcae410c268..0482c7a1e419 100644
> --- a/drivers/ufs/core/ufs-mcq.c
> +++ b/drivers/ufs/core/ufs-mcq.c
> @@ -144,14 +144,14 @@ EXPORT_SYMBOL_GPL(ufshcd_mcq_queue_cfg_addr);
>   */
>  int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba)  {
> -       int mac;
> +       int mac =3D -EOPNOTSUPP;
>=20
> -       /* Mandatory to implement get_hba_mac() */
> -       mac =3D ufshcd_mcq_vops_get_hba_mac(hba);
> -       if (mac < 0) {
> -               dev_err(hba->dev, "Failed to get mac, err=3D%d\n", mac);
> -               return mac;
> -       }
> +       if (!hba->vops || !hba->vops->get_hba_mac)
> +               goto err;
> +
> +       mac =3D hba->vops->get_hba_mac(hba);
> +       if (mac < 0)
> +               goto err;
>=20
>         WARN_ON_ONCE(!hba->dev_info.bqueuedepth);
>         /*
> @@ -160,6 +160,10 @@ int ufshcd_mcq_decide_queue_depth(struct ufs_hba
> *hba)
>          * shared queuing architecture is enabled.
>          */
>         return min_t(int, mac, hba->dev_info.bqueuedepth);
> +
> +err:
> +       dev_err(hba->dev, "Failed to get mac, err=3D%d\n", mac);
> +       return mac;
>  }
>=20
>  static int ufshcd_mcq_config_nr_queues(struct ufs_hba *hba) diff --git
> a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h index
> f42d99ce5bf1..a1add22205db 100644
> --- a/drivers/ufs/core/ufshcd-priv.h
> +++ b/drivers/ufs/core/ufshcd-priv.h
> @@ -255,14 +255,6 @@ static inline int
> ufshcd_vops_mcq_config_resource(struct ufs_hba *hba)
>         return -EOPNOTSUPP;
>  }
>=20
> -static inline int ufshcd_mcq_vops_get_hba_mac(struct ufs_hba *hba) -{
> -       if (hba->vops && hba->vops->get_hba_mac)
> -               return hba->vops->get_hba_mac(hba);
> -
> -       return -EOPNOTSUPP;
> -}
> -
>  static inline int ufshcd_mcq_vops_op_runtime_config(struct ufs_hba *hba)=
  {
>         if (hba->vops && hba->vops->op_runtime_config)

