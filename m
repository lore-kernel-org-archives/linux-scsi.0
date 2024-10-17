Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895C516F8F5
	for <linux-scsi@vger.kernel.org>; Thu, 17 Oct 2024 06:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729148126; cv=fail; b=Jb5UcJu3Wt5hZCc/8X1UmopcqkbCcZyp9AYdSofHsEYXu1tqHU/B9nrl7fh7cnQMUAqhoEF63kNiG2gQn3T+EOQ8KkPb2XfIZ4RYhR8OLIy8BU5/G9wT+jUdwW5K1+xGA+gcpk+gwD1Xoq6HKPWeSaxtndc2S+CqmLKhc3rH0HE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729148126; c=relaxed/simple;
	bh=denJKH3J66ar8qBspWYNdNIp28UWysFLuYL2s9uhAKU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RJaf3cqLlMsdU3A+Fg67reMKbUX7TxDPKCBk2+nzFOXKQJbsiRWdEincFOq1isc9OmsxgCaVuOEcewCLJKEidT8hbHTDu/JsXUm/XdPcsevB0PrBrd7qM7XXrNhL6TXhSAj1HhfJwwkUghx+hJ+5M39XnpX+e85+F+y4e6t0fJY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=b1Msb9MI; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=0M3ZUDfx; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="b1Msb9MI";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="0M3ZUDfx"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729148124; x=1760684124;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=denJKH3J66ar8qBspWYNdNIp28UWysFLuYL2s9uhAKU=;
  b=b1Msb9MI9nEwT2JJrlwIf0UHR8DSGP++mbzccnqsc2kY12OYtq0cIhhQ
   V2R4cgufnVEoF7ljm1lwMqZfyKWf0Quh+kN9sgf0vq81OMu9OlLwinmGU
   o6dUGB/tubuPB3JGDGX93kUyIDQzW/iDOLGz8o/o/A0KQJGGoghPXSPaI
   phhTzovZdyCqGmP+mvzWzxKwct+oPX64s+LxhM4510j5tt0pgMttm6y2W
   IisRRVLzVBplj2BATfJ5cktUSVCuPA0cJu+QQWe2Js3ZeSQaAeyXETibe
   05YjKvPMg8h5fJDPHpxYGWKHQC+z+WCd8fd881SdhrJbw7pKRvPjqTlpb
   Q==;
X-CSE-ConnectionGUID: 6lrqt47oS4yDGPAIw4MfHA==
X-CSE-MsgGUID: 4g2HEuFzRCqmgjw+PUHA1g==
X-IronPort-AV: E=Sophos;i="6.11,210,1725292800"; 
   d="scan'208";a="30104702"
Received: from mail-bn8nam12lp2168.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.168])
  by ob1.hgst.iphmx.com with ESMTP; 17 Oct 2024 14:55:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LSrAAc+qeDkngjkdT5x5RzpmdVoUe3UqD0mbWwfUK0QIsluPqWv0RcPSBAojAAbZqOeUcRYb0R6zZqczEgN+4Insig8yKo3xW8O3lN5VkgG3FHws8C7/eyQSnftmS8QEcVEkc6LZuMqU5+Rh1p5NZS9kfP1hMflpIufrnncffSPC6S/OQSju58pck3mjnC2UV7iEjKfXq2e1vvm/VGMnKBIbnsLla83wesoDuhHaFEomPeHLAxgOEbucDk3ikVFxU40TCphNso2SdF0K7++7pnVCtqH+FZepzK8eihkqYV/53Rp3N+Jd3Y9GdAaByiBzweHk+C59X5byW9NJCEIw2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vyc0CjYy4Uu4nC4/zLm+nsUqnTAHWjTXO/Yd+ihdCHQ=;
 b=dn1v1Ne5/Z2BopiBtcmVK0+FBSYkQ7dWLvgjoxSErqG6BAEqLXfuyU2uZuHC1TTeCdFsV7wX0d6hFd11WIO3nCr/VQO0AFa8sejBIeeFg02Yemzk8bLOS73KHg7qdFX2Dis+/2jl4xtP7IiBjPyRT1HL9PpQ96xD/6/j/DATOe4QWiftthWIR6NhUCHXf/t4M/a095t5CURUEjuGBhfT1nw+fGbOe3b6565BvHckhDMOWyg/hTUO0szXwpJBISNN+STY22mSb/Wjf42fiZfNFZzMAH9F1Zjz3PcOIK4J3vfHQY2+SNg2Op1hJ8d5IhrA9HOtbokspa42JX20h42+4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vyc0CjYy4Uu4nC4/zLm+nsUqnTAHWjTXO/Yd+ihdCHQ=;
 b=0M3ZUDfxihF9LtcdoskPOIAKLrpSQAwCsNRdahZLbnRkUNwAIj2nmHU2jXegk3krjRcoQ9KUFmcBMp2jV3k5d6Nbc+m0wdveGVrIFnvBui47FlhHFzO58FCc84cS4YlyJ0pCieBp9DZla/ppEeBttdBDdDPNja1bDHxaimUVtww=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 PH0PR04MB7301.namprd04.prod.outlook.com (2603:10b6:510:c::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.18; Thu, 17 Oct 2024 06:55:13 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%7]) with mapi id 15.20.8069.019; Thu, 17 Oct 2024
 06:55:13 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Bao D. Nguyen"
	<quic_nguyenb@quicinc.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, Peter Wang
	<peter.wang@mediatek.com>, Minwoo Im <minwoo.im@samsung.com>, Manivannan
 Sadhasivam <manivannan.sadhasivam@linaro.org>, Chanwoo Lee
	<cw9316.lee@samsung.com>, Rohit Ner <rohitner@google.com>, Stanley Jhu
	<chu.stanley@gmail.com>, Can Guo <quic_cang@quicinc.com>
Subject: RE: [PATCH 6/7] scsi: ufs: core: Fix ufshcd_mcq_sq_cleanup()
Thread-Topic: [PATCH 6/7] scsi: ufs: core: Fix ufshcd_mcq_sq_cleanup()
Thread-Index: AQHbIBBBWZ/scSktVkqDqxLsXwv7OrKKgX/w
Date: Thu, 17 Oct 2024 06:55:13 +0000
Message-ID:
 <DM6PR04MB65756D0B96314EF126162948FC472@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20241016211154.2425403-1-bvanassche@acm.org>
 <20241016211154.2425403-7-bvanassche@acm.org>
In-Reply-To: <20241016211154.2425403-7-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|PH0PR04MB7301:EE_
x-ms-office365-filtering-correlation-id: 32627cc4-fea6-48db-0dc9-08dcee78a655
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|10070799003|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?9zmDPmAUYyAMaC5UiXOQlzlnkMv+lP/lM5J8oC98sAfuu3ikiX+xdo7A4cpY?=
 =?us-ascii?Q?I/gckXTZJj6vovC6xnb2jS/qqHa1HnCxixim3pUQJt3V0fR7lFdYj98Fg4sT?=
 =?us-ascii?Q?8LwKaTUoDsTNibNtbd9sJSukkiRBr49g6f4GgZAZ0ectsB1CA8vAswWhEYLK?=
 =?us-ascii?Q?5/EI8o0t+x2eu46L+cbafY01NKLtBNLfSDtMMHf8QByZxkRbhDyi+2JKrqj0?=
 =?us-ascii?Q?yiZbJ+pXJGaJ5yhSwUAH5P4NMtta5wvzGFAd+TpWNbzTW8gxkqt0AatD6z3h?=
 =?us-ascii?Q?gAc6lFnMp5hL8nxroRi4+FH2z5ly+275HYPBcJ+I5F3YBsLxggrprQjLatfL?=
 =?us-ascii?Q?sjf1AeHr391KVJaGEMsE8MO6KvPhDRZqSdHdoWoDQZ+NDymdBW5rxZAImcA8?=
 =?us-ascii?Q?UUinl7U6fTkgxFKSoWPKwGSe/6EyApvX9PSXk9UkCKtvhOToZhpSOpvx1xow?=
 =?us-ascii?Q?Hbbh2MgcRpvnCmxXqs0m56n5P2gEsEWOyRya3EErHudTHDNdFeRlonpcHxZa?=
 =?us-ascii?Q?mXRsOonZypfQBR2IEL2zLQ6xY2Ap9HDkbavbk6G7WkCYyhn2UYWkBnF0c+hJ?=
 =?us-ascii?Q?kkyJ4Ds5Os6TXwc2BcwTLHR8OHX1c4pSDmUoUM8WP4A+WgXe1Wsy0TXJAK9q?=
 =?us-ascii?Q?mWgjbBCHSlDXBqgH2Ti0u0GTX2687Jqu4gb5lWWaZsJ2Srvj5uNLf2XFfbbR?=
 =?us-ascii?Q?ZSkJ6EiWmseV1airCyWwsI8SDY59HNBMSJLM79zJMXmdODj/8AijTAFmcZwh?=
 =?us-ascii?Q?r/kb1AIvov8HxPM6Rg3sepknrGE7YePemb/5H/IoebNKkAqO4jMwUTaRrTfn?=
 =?us-ascii?Q?PVIqud1l4v/CkzDtjBsQ4IVPJYVRurdq6Zn4POyIXoKiz4XRrdBtrZQRg7Q7?=
 =?us-ascii?Q?qDW+yaA+tQJBfdatj7m4DmP5wsdPh7f1fUeU9X0G/ELcr+kM+MK73KriFprd?=
 =?us-ascii?Q?6ol7mTmCmuR1xW8ExFfWFjfaXdtFbfFZLKyy6TMbGXCcuEO12p+28SfT9pbK?=
 =?us-ascii?Q?V9ewaRHGaLHyXOO2BB59U2cwP5Nw2RkEyZtFjBeHkAzP5PkCEi0pFARWrsWn?=
 =?us-ascii?Q?pfSSeLCQqIkoES7x8QC4iDQNahqheVNnc1pWDCVaLolKSHCnysbDz7kmWBZD?=
 =?us-ascii?Q?FFXXXXt2Khy6rO6zel5sll6rqRntcpR2Xx6VzcRtmo1XU/L0RnCFS1h8aw24?=
 =?us-ascii?Q?jz+iFWDvMVw84jKBNlgdCHY/Xi4eTG+CNcO3/hcCv5kGjEOGd9NMnWx2fpIB?=
 =?us-ascii?Q?MpyWN4OavuZvCAd9LItyz6KXKCp+s6AeHxa7yt86JsvvNS1LQ+t9xXAFH1x/?=
 =?us-ascii?Q?9J/QYSleVFEihHksxfwk+ihEQpW3uCvTA4LxvEt1CSMYvmprz4QYPPPF/03X?=
 =?us-ascii?Q?PC/tqlw=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(10070799003)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?iKyhZB4986P8LpxbPCjuybaiOVljP0+1l0WUVl121XYrOzWR7SYeQw+1/KmJ?=
 =?us-ascii?Q?uaIqP/uUqhOpgDySqLogyV8kNsy0xpOdw1KMmlO/KfIPHF/JvHASnRdBxxFj?=
 =?us-ascii?Q?ghQFpDaJu2rQD00MeeNOQezr63z32SDYg3ntuUqI+/OKhA69NuA9twMWIz1N?=
 =?us-ascii?Q?TD7v5goUr+OnvhG0OHKwt5jk20itHPBQR9bdq2wuFxGNzaql/vnWYljADirr?=
 =?us-ascii?Q?/5SGahzk9qkMaVs4HsiJVG2XT/4jfHUzgaWaCVRAAafVSaNIHkEXT44IpbhU?=
 =?us-ascii?Q?4cm4u/Ruc2srLFcFLWQDoyPYdtPONi3xnmbNzjLnml8LY+tRlSp5lH3jlb6h?=
 =?us-ascii?Q?nejHdj+NQmwaHVyH6llZQJ799A1IwonIAQwK6qBhjNQFUUIEUhjQP48y3EF8?=
 =?us-ascii?Q?Q6tCDAjoShfmEASc59mz34RyMAGUpOfjr53IZKcos5G26eHbKim3+SBDEbPw?=
 =?us-ascii?Q?aRz8arLCqMeljM0R8fOpsd6sn1cBNvt2gp6/moN/bAccE5d/wP3TQBZdhUHu?=
 =?us-ascii?Q?azMx/GZTfTYR4qwgJ0KZfredCVJO7vISHounnLpXv/YS0gYrQGDiK5KwgDFB?=
 =?us-ascii?Q?kYIWfGD0hZ0fcRs8lOekyp0NgvrB52wP/wDDNgQPEl3/dyyO1cuW9GIoVtqb?=
 =?us-ascii?Q?usWmflXgIRGKOVJ08Lmyf+1OfASztD9YkwSeEUE9cbFJ2Afvcey0eNWhXXDe?=
 =?us-ascii?Q?yGW8ZpO0lK6rzVRz3kdsDNAH5UTjOKIsQ3UIXVRxsUodBazntsbjaj2Nsjy0?=
 =?us-ascii?Q?/prz+lqRaXqpsm5fMc1iFWx7MZsr/nkhRx+kx54jwWhoOifWyrL4fAj9Zh3j?=
 =?us-ascii?Q?bwnuNrs/bu627kH21zwVUVgKF+WyiBAqyYvOohjhOn1ExbeGhb6gmcK5cCs9?=
 =?us-ascii?Q?wQQjNN0+N2mfaiI2KUaC5z1PbMllJd8Z8YyrfelXAu0pDs1xIn5QARfVaWDJ?=
 =?us-ascii?Q?FKuK2x0Lr6JayQ0p2iXHOLs7r7dp5/09OhmDe/5jBoWCUiUQQBm0kd+XKL14?=
 =?us-ascii?Q?oRVFa2h0KhKEQFGnlseALe9JPc6rMVrI0VxVYAh1QkZzSGQHNDLJtzktzH/9?=
 =?us-ascii?Q?zBz3OuyjxRGBzfGbjtH6n2VPbelKclTLvFZoNPX5xxm74F6JxNR1Tay64nFq?=
 =?us-ascii?Q?vxGh0nFYw7pmwvBDOe8nrdMEyhbkqmaZ2779ks0UAMXVsfSDKfOS02qbYjuE?=
 =?us-ascii?Q?lV3MLgTvAvdeZuOjBYif+euEB12ExPeb417LYhyDtbT1V0x677Lr727QXZo5?=
 =?us-ascii?Q?qlHpYn93LerntEjlarWdMpPZfqmGT9sJE2ZTxAZJN0OxrQkyeA3tq0C+RKu/?=
 =?us-ascii?Q?5JWasPPG8NEfZuP1q2waAzzhXAUGkRcwkSbwFsqbxB27cQoCT5E923WfpHo3?=
 =?us-ascii?Q?r/OIyF61n3WZUS/Q5N5k0eyG79b4OYHwPLVF1jO5p8ohUvtlkHj8us0Tt2qn?=
 =?us-ascii?Q?Ue07mxeD6460uItvKzm5mw3Gf8hcuFnhTgigjxv4m4X1ecumQhysb2GSKjXp?=
 =?us-ascii?Q?qa84jWAjjYCRunoJrRaW2KjMCpNAVl/0tijOUwzTW/uJZO2x5lqx0IxHPTz9?=
 =?us-ascii?Q?bdrKVTcqoX36TGwcsFUdhzebSaFJXopkLjTr4YlakL2FI/aC//l3JbhYofDi?=
 =?us-ascii?Q?hTUxI3XNVS6xHg/VQl2MK0yzQPVzJOj4Z00l/UOxWnMS?=
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
	ianumS2xN9BLZLVWz0cKgrMxEIuzqA+haXzLlIKOEiTnm2bz8H/UBKBx7gf7mogr9UX738zzDiImRw2bc9mriYj7W9ssgTobLTPcUlngeS+UjVsEVuJMbg2TEzdxtvkX+cG9ZKbUS/M+Wrr1W+kS10PtEi9cGIecIBCdiyMC5GbRyIJoVLPcL0rG01vV0Ssexp+J1a6BaeG7dRwVUNit3Oey92i0e/LYs7Kfgy6Y1N4+CMv3cy37eMmmDnEp4zBqt4okJm6YYkMSoQZHEQjDg75NIhrHze8ZsIXtTT1Iwawn1u8gVvGxuQaj+Hegqe/wlrn/8IZEUgOoMQWupWU3IAesrrOOTTXACqkFLOzChdpyMTkB3yTnHvkjSqqIq7MKqshzUlBW1duI9Ay/jsGYualcGck7e2kkAol3XSXK00GS6gquE/qmSSLRXqcLuSrhzHKvRQTNrRabnwfTYH4OoGajHQy5n7glWvZV96W2or0KO2Pwa+awJsQT0H19Ms5mvc3y3kpNX6nMKTiUFG+Zd+pnzsF/D2Xfc8duFg9faxAd2C5v4Dreep2AB5Kr34EJ6ZedxvoTZMoGzM6F9XlQ/Lnw9A61/fULOZnIYhupkllbhTtVBoIoCRuuCxaby0Rd
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32627cc4-fea6-48db-0dc9-08dcee78a655
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2024 06:55:13.3236
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gSK3rLcE2+9x7B3Uf77e5x4VaDhYjq16ib97oLVatQITk86V1RXV+qNyXZn0ECEJ5lmIvW4u7ka6NhP1w6O9lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7301

=20
> -       /* Poll SQRTSy.CUS =3D 1. Return result from SQRTSy.RTC */
> -       reg =3D opr_sqd_base + REG_SQRTS;
> -       err =3D read_poll_timeout(readl, val, val & SQ_CUS, 20,
> -                               MCQ_POLL_US, false, reg);
> +       /* Wait until SQRTSy.CUS =3D 1. */
> +       err =3D read_poll_timeout(readl, val, val & SQ_CUS, 20, MCQ_POLL_=
US,
> +                               false, opr_sqd_base + REG_SQRTS);
>         if (err)
Can remove the if (err)

> -               dev_err(hba->dev, "%s: failed. hwq=3D%d, tag=3D%d err=3D%=
ld\n",
> -                       __func__, id, task_tag,
> -                       FIELD_GET(SQ_ICU_ERR_CODE_MASK, readl(reg)));
> +               dev_err(hba->dev, "%s: failed. hwq=3D%d, tag=3D%d err=3D%=
d\n",
> +                       __func__, id, task_tag, err);
And report RTC on success or err otherwise:
+                       __func__, id, task_tag, err ? : FIELD_GET(SQ_ICU_ER=
R_CODE_MASK, readl(opr_sqd_base + REG_SQRTS));

Thanks,
Avri

>=20
>         if (ufshcd_mcq_sq_start(hba, hwq))
>                 err =3D -ETIMEDOUT;

