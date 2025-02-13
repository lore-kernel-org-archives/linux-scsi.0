Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB372135C0
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2025 10:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739444280; cv=fail; b=Q0sJa9f1mLM2OUDjJcZjrfZgGVtcCELOHOMnj/eEbcyTtussB8vQ4gfjrXteYwCr8DiwZJal/ntN/21GIkIeJ3GCfmJy8hcdoUi0bExX3iGMy2EVJ+teWUTBS/K3VkHqxRn4Lo7dpZMeRfKLLJubjhDhrnzvYgeNC/ERM29NyE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739444280; c=relaxed/simple;
	bh=UCS6DZtcxkNNRERLF9XUAeODBsSXr8IinOXOMxhCSrs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ukr3JxY3Fu3OddC1esD4o2TZHF+yv0OkYA2dQNvMaJZt0C6eQdu5J7wuabaH39eBOHMDdwX/O9ultjMhrrWDiAihV7wl2qaNcnCbTxhHYg/2ZDl1Nut99/X+qLulBgSh5l7OrM1473rDFrl6eDV+vUNLuJoMimCNevvOZT0knCE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=kZyvmNJy; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=JaeKxI/+; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="kZyvmNJy";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="JaeKxI/+"
X-UUID: 5f9173b2e9f911efbd192953cf12861f-20250213
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=UCS6DZtcxkNNRERLF9XUAeODBsSXr8IinOXOMxhCSrs=;
	b=kZyvmNJyWkIGfZvpasGMLHDob7oXd09AI/zPkzG7KgFyBLPIv/PjGnB9U8XriypRbFoqcErlQf4ux+x9tioPAT+uNZMLmcaIXkdoY/D7r5f6oL3IfHdcrI59+iEKSdXSa2xs8Y2FAvZfZBmQYxFfwMtv/+1phpdvCHk3mlBAzrI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.46,REQID:20c22dff-22d4-4df9-8ed1-249bb4e98928,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:60aa074,CLOUDID:f964518f-637d-4112-88e4-c7792fee6ae2,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|50,
	EDM:-3,IP:nil,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 5f9173b2e9f911efbd192953cf12861f-20250213
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1402990426; Thu, 13 Feb 2025 18:57:53 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N2.mediatek.inc (172.21.101.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Thu, 13 Feb 2025 18:57:51 +0800
Received: from HK3PR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.28 via Frontend Transport; Thu, 13 Feb 2025 18:57:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JYzDwGkG9KPW/NLTdtoi7KJNednjd+ahje/CrA2D6CN0dNZ/QAjlI7DhVSjlfHko3LH/D7emmQAT61o23Fe0Hrlw7TCnCBSaK5AVLS7aSeVriILuF6w/LkBiHS0z6C3UEG+vTCBLa2yCYKOBWWKKUSVcEA0EGlhZQdcRDprVuDMWmRKh7koT816t1PUQQeqsJ51shLC5n2nQgJwOo6NYXPxgEGnEx5pFWHrUG7NNzev3n4f04m5njXUHWl9GbHwhcz9+jFDVSpS6QndvWGhqP50+4Ep4/sAB7LnZPT07L/wZqk+cXgx95LFcN86YkDMu4S3sssX1A/FZgWO0IxX8Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UCS6DZtcxkNNRERLF9XUAeODBsSXr8IinOXOMxhCSrs=;
 b=GMXj/d8bTNe5rVLJEGau+5/wkBfk1vmXwpe1t2NwkNbbLQe0IxTxQCYFcXD4pFjUh+quugyEpsdBATx/B6v727aPoD7bqpXUmiwldWbNCrmj4KtDygd2Y1n1hTZjim0sKKnxuZJgKBo++oR/D2ZySv5bbf2KU9JHIxdR3uQ4N3U5WGIAWDAIxBQvImUOvJIlYXRIO6iBSpWdhq1Aybb5qKRO1WNH4EcWbUn9J0B5FwxxM99eYviErn7mFOpb6nCC3uDolE0nnh7nGQL3IYu8pJziYgUJS0IQsuLLdDblqlRft8uPDuaeLm9sPdnnBwg1K+EVlL4uY11c3P2UWyJB8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UCS6DZtcxkNNRERLF9XUAeODBsSXr8IinOXOMxhCSrs=;
 b=JaeKxI/+bak6VWow/uwSvdm2YiHGOYmOfrkTQzMfd9cWGUbk5xEneZmxnlg41+86Oc+A/NPhxFBNLid+p97q1sSXmzAUagjisPXibwkQzMtWAxa0U6HWswbTIEjyKc6MOZPSEwgVabd/xP7SnuglwMn32n2np1S17UGPFSqpNg4=
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com (2603:1096:4:129::11)
 by SI6PR03MB8707.apcprd03.prod.outlook.com (2603:1096:4:253::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.12; Thu, 13 Feb
 2025 10:57:49 +0000
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::c4cf:543e:48b5:9432]) by SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::c4cf:543e:48b5:9432%4]) with mapi id 15.20.8445.015; Thu, 13 Feb 2025
 10:57:49 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"ebiggers@google.com" <ebiggers@google.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "quic_ziqichen@quicinc.com"
	<quic_ziqichen@quicinc.com>, "pstanner@redhat.com" <pstanner@redhat.com>,
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "AngeloGioacchino
 Del Regno" <angelogioacchino.delregno@collabora.com>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "u.kleine-koenig@baylibre.com"
	<u.kleine-koenig@baylibre.com>, "krzk@kernel.org" <krzk@kernel.org>,
	"orsonzhai@gmail.com" <orsonzhai@gmail.com>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>
Subject: Re: [PATCH] scsi: ufs: Constify the third pwr_change_notify()
 argument
Thread-Topic: [PATCH] scsi: ufs: Constify the third pwr_change_notify()
 argument
Thread-Index: AQHbfZdBmM1oALy+20GLrzUyCwP7eLNFEQ0A
Date: Thu, 13 Feb 2025 10:57:49 +0000
Message-ID: <5ed2ecd7acdbd5d70c36cff6e823124550e53e28.camel@mediatek.com>
References: <20250212213838.1044917-1-bvanassche@acm.org>
In-Reply-To: <20250212213838.1044917-1-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5609:EE_|SI6PR03MB8707:EE_
x-ms-office365-filtering-correlation-id: 150a15e6-5079-422b-07bd-08dd4c1d419f
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?OThaeVhjQXQwV1FkVkRFREFBL1JIa3k1QkdKeXA2b2paclZEOUkvZTE0SGdQ?=
 =?utf-8?B?RUIxZ2RNdFBUVS83U0VqejZualhhQXpzdWVUZG15eVVxRXo0eWpVQk1jd0dp?=
 =?utf-8?B?d0ExYlhqTUY0R2t3VXV3azhmeFVyMi84VDVIbUpKazhlbW9HcnF0anRwaVYw?=
 =?utf-8?B?a2RWVkJiY0RnOXMyWk1vcmxuMkRnS2RJQ3NVbllNczhudGFXbkhsck0xYVBW?=
 =?utf-8?B?MTBML0ZnS1ZCd1orTWEzR0VOT1pXb01RZ1YvdUZscjFlODJhVmhqcmtpUjUr?=
 =?utf-8?B?am4xc1cxb0RLZXNoVDVJWHo4OHlDYXZDck4zVjZoc2JXVjg2dXdvM3gyQzBH?=
 =?utf-8?B?TDRyVmF2Y3FoV0RJSkRnTmxLVHh2eXIwR2ZULzhOL3Axa0JjOVpyZXpQdzNY?=
 =?utf-8?B?S0xyZXZsa3lMUFRjMFFzZTNjeXNKTDVDcGw5MWtIenhIK21nMTlad2ZodjZn?=
 =?utf-8?B?QlgxVkdpbHg1WmkrU012Z0t3UEN3cXMxUHBYOVZXK0NsdW5jeFU4aDY0ZXZR?=
 =?utf-8?B?N3ZSU0NSWGR0YlhhbVdZNG1RVTg1V0pzU0g4aVcvV2taaEFnYklJUWZKNjZ4?=
 =?utf-8?B?R2t6RndDeHFmOEpCbzNRSzNtUlFLdUF1Rk45MmFwU1RqazFVSk5SaXBuV3BC?=
 =?utf-8?B?V2hxakN4UTd2elNVanVKYWpIZk5vZzc4UHgvVys1Q2lNMTY4WlpFUjM4TWk5?=
 =?utf-8?B?WDZYTDNYbmNsdVVaeTRwdGtmVEpONlZmS1RUNWNCNmlNQ2ZqUVdGdUlMVUJv?=
 =?utf-8?B?Tlh3MG9RSW1TK1MwVUhLRDNoUGFKQmMyek85aEZsMXZiVVMzR25ERzBYTmg2?=
 =?utf-8?B?bSs3RnpiTkd5UE9mZ1FHc2dISk9tNHY4K3JLcm5UZ2ZuRXlCd2NVbXEyb1Ri?=
 =?utf-8?B?QUtRTUp6clNpZ0VWMjAzYlhFQmx5R25tS2svMmVjbjUwcEVXVVJzU1JhSDVr?=
 =?utf-8?B?WExZUVE4dm1JcTVOSWl4Z1pmZFYrNjhFWnpWS0pmbG5RWDZIQm1NcXE2REdW?=
 =?utf-8?B?anpMTm5JRE1YVStEV2FCWENGamwxbUM2dmdXT2JqUGJZVmhxOEd6ekNhNWZq?=
 =?utf-8?B?bnRuUUFFTHNqN2VPdG00Q3NLNTV4SHc4UDVqdGFYYXZOZjc1UEZYYmdKdnYx?=
 =?utf-8?B?dzFrWXR2YW5JeGlVSmVrMkIybEptWFdESFNHcnB2blRBMGRZZ2FYNXZjYWc1?=
 =?utf-8?B?bk9tK0NkU0d3TTZVK0lVbC9sM0J5Y2ZCSnJqODlzTHRWSGZPb2tHV1lQb2tM?=
 =?utf-8?B?VmgxTlF3cnVmYjZBNmlLNE83K1hoeWFTRHJwZU9na2E5ZjFqODFBVEkrRDF5?=
 =?utf-8?B?RzZSdjVrVjcvSmZQNUV4NGNOMWcwaDhNNFVZdkRvU1pNL25iNWJJVHN2NlZI?=
 =?utf-8?B?N1R6d1BzVFVCMDgzMk52RFRXZ2ZTNEExWXpZclhwVXRXQnd3M1hlNVgzc2sv?=
 =?utf-8?B?VkZTRVBvV2lqeUtUdys1VzB0OUNCczlaTlNYcWw4QlpLdUJVSWxKZjgrMVhM?=
 =?utf-8?B?emMva1YzcXYrSFlnd1FNSXpKdklqZEFvcFpxcWFpUnE0TFd2VFZJK3R0T3hI?=
 =?utf-8?B?SGFLM2ViNFFreUhJaDlFQ2ZaaEl2Z25GQ0kwMm9zYnBRTEZQbFJUbzUyUVE2?=
 =?utf-8?B?YzJzOUxUTEY2VElaS1lCbFgzVHhrc2F1bkx6Z081T3hna1JYS1hFU3UxeFVJ?=
 =?utf-8?B?Y0RSM2RDUW1tMUxCeWhHS0hEUHNPSlhTU3lqYUYzek5xdm8yUHVxZ0Vub3M0?=
 =?utf-8?B?dFoxT2R6TVdiQnZsSmF3L0ttaEFlZ0owSnU3OGNLYlNKWWR2aXNCODFYK0lY?=
 =?utf-8?B?SE9wc0pIRkZyU0dITFZUWHpDSms0UkF4Y1FUKzhNLzB4UXo1NUk2R1lodDBN?=
 =?utf-8?B?K3pFRlFoNldVSU1GRWdYK1JPMVdPNjh5UHlpU1BtQ3pYMzV1OVFjQXFxbm1U?=
 =?utf-8?Q?jPYypzfBFmwMxVQRRVlDSG6S455/i7Y0?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5609.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?emN0YXdMNkRia2ZIQ1RTNHBGaFFyUTNNblJQUytMMElGUW44T2g5cUpNNTY0?=
 =?utf-8?B?ZlpWeWFBMkNxU0Roa2N5a1ArSlNLbXdTV3VpOXVFTExzRHZaVm5yd1p6N0Nk?=
 =?utf-8?B?OWE3VnBIKyttS2R0MzR6cHpVemo0WUVUMkY1U1lKYlRGbGsvejRrSkl2WWFq?=
 =?utf-8?B?NlV3Y0lnbE9wR3pQRlVKTUxnRmthVUdSN3QxOXZTOEp1RmowLzU1ODJzalh1?=
 =?utf-8?B?TEtSVXZWVGd0cTJzdk81MlVxU0NtNDZOaGFJZXg1SHVtWFQwK3pYVnM1WWhF?=
 =?utf-8?B?S3dSTCtkUDllajVMK01tSGZBMlM0dlQxMSsxUXJZY05XazJjMm5sK1IyRnI2?=
 =?utf-8?B?Z0F1THFreWd1d3YxZ214Z0JCT1kxMmM5c25hcHFLdEYvTzhTUzBXNTlldkdN?=
 =?utf-8?B?aDVqbndPTzV1NndTbUNIVVMzOE5IRlFneTI4Qy9DaGZuZmlnVWRST3hVM0Jn?=
 =?utf-8?B?ZFNvRHAzVVpxdGhlWVR1aExaRTl1M2hsYW1RbGEyYzJKTWVTN0tqZVI3T1hk?=
 =?utf-8?B?QkZnWXMyV09XMXViVGh1cWJ5bVdocmlsOEMrbkVOc21QYnNrMC9ZdE92SWdC?=
 =?utf-8?B?V2ROeHRJZ1V5M0NMb0RKc0xOdkM4Z0VZajVDb0FtQ1FBY0dPMnpIdVYzMVVm?=
 =?utf-8?B?Sks3enRrTzU1YU5hcFYrUkJrV21uN05TRzRrNVJNVjVnMllNQ1k1SGg3TEw1?=
 =?utf-8?B?SDRhUUFHV01yTEk3N0p3TzJiczd1dStidjIrNHk3SVM1QXI3TmdLM1o0WHhR?=
 =?utf-8?B?UjhMNkZMUSt6UVBNYmNpeCt3Qm96djJmOVY5VGNra0JsWmQrRWNvS2Q4VGZT?=
 =?utf-8?B?ZEhkTVMzQmdjVDVFS1NrNW9iWkZRb0pISVVGYjBEY2h4bkZVL1p4TVhzeW4r?=
 =?utf-8?B?TGpCZXdnaDN0cDVHWTJISXQ4NlRCSTQ0NUtXalBvazNmYVFBYTJzejdzQzhP?=
 =?utf-8?B?MXM4NWMxTGNMeHdRZlIxUVFLTzFmVmpyMUtjV3d0V2xmMlJscHJrSjBodFFy?=
 =?utf-8?B?MVBOV3ZydWtTRFVJNVhEdGMzUSt0aVNlVnd2SEcySkxVdnN4Y2FHTHlnZlAz?=
 =?utf-8?B?OTFHaDhrcTd0czVuSU5xWWNiamZMMXYvVzN6enNZQkZGOFpJMnBLM2NxVEp1?=
 =?utf-8?B?UWh3OVdhTHdLZHppNnRUb1RMd0R6MEF2dnZjVElmTWVER2U3b1g0eDZBL1I4?=
 =?utf-8?B?bUZ4MGRQQ1hLYlRmd1ZiMkZXSXl1aDBzd1pOMCt4Y25QcFVOeWJIV0RmUG9R?=
 =?utf-8?B?bjZ5V2prNWxVRE9FTW0zZzd0MVcrUGlpajQ0eVVMd3V1dS95REw1bUZZMy9n?=
 =?utf-8?B?bXVFWlI2WC9zazFIYURYSW93a1hlL0k0bUoraUg1L1hVTVpMcHdJNE0vKzdW?=
 =?utf-8?B?WjJFYzE2ejcyNHdMY3lQU05pL2RMWXhPVG40cVNwNkJPSVM0d0lWelJldXJ6?=
 =?utf-8?B?b2VlRWpFQUtiL3JadUZkejU1TnpNdEk3L1NhZzc1NlVQZHF3WmNINFdCNlBx?=
 =?utf-8?B?QzJHRU9GcDkwZEh2cHhmY2s2OFFCZ3RKOGRQaG9GWVorZGtkMEI5ZmxrZDZF?=
 =?utf-8?B?c0JKbklFYzlza09HMklydGxhNTB0aGpWbW9IK0FGbGZOVXpiM3JudjJLc1Jw?=
 =?utf-8?B?L2diTCtScE5DM0VuV3NRMVAxeUcvc2tmbVh1VmdMOXhERmVrQUUvVFFYemdG?=
 =?utf-8?B?QnU1UEpjTlAvSzIxYzBLZktMYTlvcFQ0YVRZNlpOZG91endmaVpZMjJ3NFlx?=
 =?utf-8?B?citSbHptV2NPTHVnQ2JFVFFselR0MmdqYy9VaUUxcUpHbVBKQTFzS2llRUx4?=
 =?utf-8?B?RHpDSnQ3ZzVSZzhRbW1TK3BTTThnYXdKYXczTXVOd3lkcTd4dnBoNmpFbEdD?=
 =?utf-8?B?dlpjTVNlSEtKU1pOSFJjekFQMHpGQWhya3ZKd2QxRXd0bUdrQlZlS0xEVlhB?=
 =?utf-8?B?US9hWU1Xby9tZHNxRi9JZ2FPR0pPYzRpUzgwQzRVOE8yc3Yra3RZY3lwZi9J?=
 =?utf-8?B?VTNGbHltOXVjUUFBbjJ5M3Q1Y1RVR0FXRzJYc2lNSkpPYXIrRHlTOXRzekpG?=
 =?utf-8?B?VTBUM21ZQmhhditjc1I3N2FKOUpTTlRlNHBhWjUyOUtXcWJzSWE0dHJjMUJm?=
 =?utf-8?B?YStFdDFUNmxSZ2lVMWp5TDVxclJPN0xnb3ZEM3djeGZOeWh0UXRKeEZZRFJB?=
 =?utf-8?B?T3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A343FD30A4B14F4E83AF1FF47DEADDD6@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5609.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 150a15e6-5079-422b-07bd-08dd4c1d419f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2025 10:57:49.4651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dpo2Wxj++6WAEug6/dv+khv7AYj0ygSb4YPU3b89QCMKR6hlag8F4kthQP2Co0lq7+/XKGDCqxWbrsnF3dU/wQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI6PR03MB8707

T24gV2VkLCAyMDI1LTAyLTEyIGF0IDEzOjM4IC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRo
ZSBjb250ZW50Lg0KPiANCj4gDQo+IFRoZSB0aGlyZCBwd3JfY2hhbmdlX25vdGlmeSgpIGFyZ3Vt
ZW50IGlzIGFuIGlucHV0IHBhcmFtZXRlci4gTWFrZQ0KPiB0aGlzDQo+IGV4cGxpY2l0IGJ5IGRl
Y2xhcmluZyBpdCAnY29uc3QnLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQmFydCBWYW4gQXNzY2hl
IDxidmFuYXNzY2hlQGFjbS5vcmc+DQo+IC0tLQ0KPiDCoGRyaXZlcnMvdWZzL2NvcmUvdWZzaGNk
LXByaXYuaMKgIHzCoCA2ICsrKy0tLQ0KPiDCoGRyaXZlcnMvdWZzL2hvc3QvdWZzLWV4eW5vcy5j
wqDCoCB8IDEwICsrKysrLS0tLS0NCj4gwqBkcml2ZXJzL3Vmcy9ob3N0L3Vmcy1leHlub3MuaMKg
wqAgfMKgIDIgKy0NCj4gwqBkcml2ZXJzL3Vmcy9ob3N0L3Vmcy1oaXNpLmPCoMKgwqDCoCB8wqAg
NiArKystLS0NCj4gwqBkcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jIHwgMTAgKysrKyst
LS0tLQ0KPiDCoGRyaXZlcnMvdWZzL2hvc3QvdWZzLXFjb20uY8KgwqDCoMKgIHzCoCAyICstDQo+
IMKgZHJpdmVycy91ZnMvaG9zdC91ZnMtc3ByZC5jwqDCoMKgwqAgfMKgIDYgKysrLS0tDQo+IMKg
ZHJpdmVycy91ZnMvaG9zdC91ZnNoY2QtcGNpLmPCoMKgIHzCoCAyICstDQo+IMKgaW5jbHVkZS91
ZnMvdWZzaGNkLmjCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCA4ICsrKystLS0tDQo+IMKgOSBm
aWxlcyBjaGFuZ2VkLCAyNiBpbnNlcnRpb25zKCspLCAyNiBkZWxldGlvbnMoLSkNCj4gDQo+IA0K
DQpSZXZpZXdlZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQoNCg0K
