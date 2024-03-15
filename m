Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894E9749A
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 02:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710470282; cv=fail; b=NQ6HCpBfLsjX4YzQburRtIgB5DavzqzdD6KOPAwFSunOo2EYjK3AxeTRcd+7xwlZhxz7F4eBNB4CoQcZl0KIYGy9i2IC8tUOLfo0+AvjzA6cloW4YbSCHDkYTcFMLsQdyUhbh9Rj9Pte7Zeq/6zhF2On8ag2eYitJV39/2g2ZrA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710470282; c=relaxed/simple;
	bh=8bqSTdT1GME7vHi82rzwKRp+1J1Acggn5YTGA5KhdAA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MyCKzbdJqszjEn+GG3Sx+Uegxl5iDzoA1wLrPEqV3l1k53WN4n0JNLMY+c2daT1NhAPMJKXbDl+Ksq0Zsn9I2YqiTZWoK5YJt+vtJocliO8xEPHv9MaDEolKNMdUSWw44O+sYTLbfajdbpV98XAH3JK8k34Fm3Ud8Kq20/Rr/sg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=C074V+b5; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=gHp0pO4L; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="C074V+b5";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="gHp0pO4L"
X-UUID: 07f166a8e27511ee935d6952f98a51a9-20240315
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=8bqSTdT1GME7vHi82rzwKRp+1J1Acggn5YTGA5KhdAA=;
	b=C074V+b5jleYOxr++jcsAL50l3N5QqrOA3WV5doqdb1NoHihtQ+yNFHNQKzxADwHxXSsYobJyq7KmLDWqq/C3aTNbAsdA3nLeIhpuUso7Kz+kfuA/5SiT2Gjw1Xyy/ARKpn0BM2bcFNR0Z2gClig355h5ywQs7/NLcUWpiHF6FU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:1ccb26ed-047a-4f6e-a324-d34838896e52,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6f543d0,CLOUDID:bed28581-4f93-4875-95e7-8c66ea833d57,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 07f166a8e27511ee935d6952f98a51a9-20240315
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <chun-hung.wu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 313482961; Fri, 15 Mar 2024 10:37:56 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 15 Mar 2024 10:37:55 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 15 Mar 2024 10:37:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C3EcHhxy82DSk6BfI5fk7ONknIr7wEDm6+lpmC/df149Vmko2wUefc7oem8+fcjjMN6KQX5lfzZml/kZ7v+GJ1Bg24JmCJQgluhEhWQjKB0YX+ndqjzjbfJo+n+jD8JHRCO0X+zOsVxCA1f842LjKFDnfYrS4WFdG0DMShp0L/HnRGQcMrOS/hdMHBhdt39rPkPjmwBf0FljNbpznCEbB5ADznfpPqBwNxtrWbNmvXxqjcHf3d8Z1ftILDeucbYQ6OvEwhKKTWCdRWUC2d5UZd/BoBS4G+sR1gCHT6PWOJqSRfpeOPHIiiHAjazkEDt8fokEYOjxrfUij+sdn/1YfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8bqSTdT1GME7vHi82rzwKRp+1J1Acggn5YTGA5KhdAA=;
 b=iTUR1We7H2D4Jszv/J6/9+rLLV1n9NV/RVzJy0l1YHbijP4KpNh1YHrlMLMQbI2zY/Hnwdp/XNVnIVMZmLjdM4fAXt32kdSoxrRbHbNc4bTaGGrAdYGqAfVHSx69/dRoCggUNCnIRJyPgveFOLW/6+SGLklk7AxbXgkzV1nxJK4AMMOCKvw2+7SkTP9682P6253tNHphunrG9UIYnDW9EegcGUoDTwsBMevwiyJKTZxEh9r1HyksNdv9eUvH6dSQHJ0YqloPL1HDy3AYE+4jiIPcspVNhg7muaG8pQXgxFP+ityd+paBGsEwizlUFJJCO5stzaUaXUU8JtgQhD2oZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8bqSTdT1GME7vHi82rzwKRp+1J1Acggn5YTGA5KhdAA=;
 b=gHp0pO4LcDq9PAIkSI3A6JUbamHc+RDZ8TlDAC4N8eptn2ks1JpDMcNAhnzsw6uUHyV334EK4YAw34OG2LWXKQS3lky+sdrYy11PWcy7bAszH2QNlehF7nqE3cXJ0k8IfU350U1oc9oisWXVT4OX/w6lApD001KtYdhCnU+qIwk=
Received: from TYSPR03MB7350.apcprd03.prod.outlook.com (2603:1096:400:413::14)
 by SEZPR03MB8322.apcprd03.prod.outlook.com (2603:1096:101:192::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.19; Fri, 15 Mar
 2024 02:37:53 +0000
Received: from TYSPR03MB7350.apcprd03.prod.outlook.com
 ([fe80::913f:a95a:231e:cd2c]) by TYSPR03MB7350.apcprd03.prod.outlook.com
 ([fe80::913f:a95a:231e:cd2c%3]) with mapi id 15.20.7386.020; Fri, 15 Mar 2024
 02:37:53 +0000
From: =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?=
	<peter.wang@mediatek.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	wsd_upstream <wsd_upstream@mediatek.com>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
	"chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v1 5/7] ufs: host: mediatek: rename host power control API
Thread-Topic: [PATCH v1 5/7] ufs: host: mediatek: rename host power control
 API
Thread-Index: AQHacSa4artAu4jAXUCaGx1WhfGKJrE4IUGA
Date: Fri, 15 Mar 2024 02:37:53 +0000
Message-ID: <cb2c56dca715641266cf08d88a4b20f43184739c.camel@mediatek.com>
References: <20240308070241.9163-1-peter.wang@mediatek.com>
	 <20240308070241.9163-6-peter.wang@mediatek.com>
In-Reply-To: <20240308070241.9163-6-peter.wang@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYSPR03MB7350:EE_|SEZPR03MB8322:EE_
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xjjHoISFRSpw02e/fIzhsRW9fxHvBPiykZvOrPjDyDpsOe85YxFWFdXQ5hX/TqP9dEXzrZPPHiQ/bAC/NAzyzIQHxZlH/OekLDFJhjJwjZMd5kJjvgP+bQvARs8A5KsdLiKjJgxolu5Nh8r3C+0mgS0L6IlvuLg8rtdBhh5AQUEH82Cl9v8YSM/zVi+3VJ0lAGIVH7s1PHdxKFqIsRo/DtVywd/teYrIRBmYhOa8lHf/eFKK3jz6oZBQwf3SSqgo+ihh0dGV/98COPfH2Iv8jFmbJg8/I1RgDAq0GVoCdLLR1PHQqel63+a506m+TiM6i3cHy7z/oFkJljq3Z2/xPu8ntnXXHuGEMY1iAVHpI5ZkDcDhP+2EjwZ4ArZbn1KbajySTGkVSDAQQORcazgHfqxAE2LP5R+mpx/EeoNNt36Fj5KHVP2tkWFRzGNEqg1/jMT3cFtO41+UPnItGXdTsB8+h/2QU84aeCWG6FlWlMjbIQFV/xbJ4KSihDyciHtS/UOLX9MGmTKsUfKZQcGp2/AypikpPPvTiDIrXO/5JQCjgc/l41n7Cn9fZWf5Sk79VUMbycnF646O9rmdIegZa+ORP6ThLi2Acu9SoxfDg9RxPJcQFCfwIubsHNEPr3Q/M2CsaWSNZy9O9bxrxLiXWf5qJ/kedISs7T8HwWpDKtg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR03MB7350.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZUpUOTMvUlFPWi9UcWpTalppN3oxR2ZUUnZVN0djTVlnT1JuTVFlS0I5bElV?=
 =?utf-8?B?ZEh4UWwrS1Q5ZHMxV1pGbWxoaFJ2K04yaEJhdUNJK0h4V3dhVlBRSjEvTHZI?=
 =?utf-8?B?Q0NZWDB3bDJGZ0dLYkx0OSs3WXBFZFBDSy9YVVQ5S1d2M1pCY0F0bTdicnZZ?=
 =?utf-8?B?R09MNm9EZTVaQURIYXB0ZXo1a1RjSGdMNzZFUkVFWkZiR2JTOHZpS2xtQVhY?=
 =?utf-8?B?S3VZMEZ1ZWRScHljcjQ4R1Q1MzNtMjJnWG1MQ21sUmVCTVZXdFVKQmtJcW1h?=
 =?utf-8?B?TGNCRzFCclp2ZGNLQjhMTFcxVUIrQy9iNVM5akJ1cVdIbnFPQUxCVTh0UUpJ?=
 =?utf-8?B?eXdBbUd1dG1OcHltS1R1SkxmemJEZ2tPR0NvR1E5ZFMrejFxdFpxbEs4T3Y2?=
 =?utf-8?B?ZFNweUtWdncwTzk3QmY2SlhDclhLVHlsVFpNWVk0UjhrRy96dDVOV3kxYjF6?=
 =?utf-8?B?d1dvSkk3WGptTVM5K2xhSXJoMkVhN3ozVUZZS1dyQmRzZ0VGZTJFekIrNmxs?=
 =?utf-8?B?QWNnMk5ZMnlmYXAyVVdsYUFtanlxdXRXM2F4MkpSTGZjYkV3b3NVa0pJMFlR?=
 =?utf-8?B?MGFtV2V5WGQ3NEJlOWpqOVR5aDVsQ0xSUk9OWklxTXlEMkRQeGVReTV1V01U?=
 =?utf-8?B?bjFGL250TVpsNmt4VTY5dVVhbERaR1ZONUFKMkdHNzVNQ0pUcHVXU0MwSVQ3?=
 =?utf-8?B?RCtNUDVFcllnQkRjNFBmdFVEdVRCNVFpV05pYW1NS0VobVpxL3NXWElFaHNO?=
 =?utf-8?B?bjk3TE5uWGN5TzR6dWY3cjhnVTk5eWhHcHhHTXB5RzRUc29HbkZpZEQ3cUpM?=
 =?utf-8?B?T25xMEltVlgvSGMrRWNQSHNORmpUb3hTblVIdVQ1Z1grb3gxRVhQZ1d6bGtZ?=
 =?utf-8?B?OXE5aXZ4dXdpRDhYUk95aW84Tit2eTVqaGdnL2hwUlRPcXh0U3lHdmNVT2Ru?=
 =?utf-8?B?S2VySW1QNGJRaU5nenNSaVAxNWt3RXkzM09xVFQvSkVscnA3V3pabnlHNHEr?=
 =?utf-8?B?TzNuRVd3ZVBnRW9qZ0pYL1YyR2hYd0ZJSHpYMDgvRjZiaEZEVlRNMEEzN0FN?=
 =?utf-8?B?K09tYTg4SEczNWNZc0RvVFVLZjFZK1ZNcDhvakw1U2ZNbnljMzNWV01Pb2tE?=
 =?utf-8?B?cXl4andnT2xPdUhyM0h5YmF4akg1cDlteGxRdzY4amtCN0g3b2lQUFhaMlRO?=
 =?utf-8?B?bWVQMGlZZ2VQV0FqSXhETTFmaGFCZWRmNDExWDV6VTZLWmV5Uysvc2xtN1JR?=
 =?utf-8?B?T2QyRE1Xczk5anNSMVRteGdTRmh5eWRNT1BZNjBJMDFNMGowdHlIZGt6ZWtk?=
 =?utf-8?B?eXhZRkMwTHhBMFY4WkZuYWp1Sld2b3A4RSsyTkRERUxYRnV5QkkrWU9vUFFM?=
 =?utf-8?B?RVZoWWNNT0NqcFV0KzZ2QXVuNUF4Z2dBN2JadXI2bEhmQU0wdWJEVlFvQlNL?=
 =?utf-8?B?UWt3T0FUQ2lFRklBN1dhVFNHZW1ITXprWlN4dVBZVXk5NjdzT1E5amRwM3Nq?=
 =?utf-8?B?SHpHU2VXTk1Tb3VDRlJkdTNXL0lHZDE5WFZYbkhuVTZ5c2V4RmtFcFJmZ1lz?=
 =?utf-8?B?QTNPSkx6elBKK3RYRDhOcDRVSHJ1SEF0OUxPZnJJSWNoUkxLNjdTclozbnE5?=
 =?utf-8?B?ZDV1N0tmWjAvM2FxWEo3MFAvTEhnWEJSdis0MG9jWmMzdm5kbmVMVW1SUzhi?=
 =?utf-8?B?Q2w1TnpJNUhuYTArc0RzcDVWN016dHpuR0NKT3FuTHlaNzFEd01zT2NkV0s2?=
 =?utf-8?B?WmRIMWt2REY5Z2ZPMVdLMUxKNzlXWjBnVURLRi84M0F2Rm9teEgyMjdzelhO?=
 =?utf-8?B?dEdVWFFnWFRwbm1jNlJaTXFhSjkyQmZ5MExCYmNQV3QwNkZROU1OQmtrNlFj?=
 =?utf-8?B?NVpCdlpjYnRaa1RsdEJyR3lGOEljZkEzbmgzUC9hbUhmMlhXUHR1OTRlMnpK?=
 =?utf-8?B?YnRtbmJzSThLVTlSN3RnSG5lNnk0S1BpZXJlcDVaUGN3MysySHc1YSszNnhn?=
 =?utf-8?B?blRQY1V3azB1M2dnbmFyL09ITkkxUnFWdUJNd3pUSjNZVVUrQyt6NHpzTlpj?=
 =?utf-8?B?VVR5am1CSDFvRFdLTFlVSC9GVEJlZjV6ejlrWElTRFdQOFR4T1VmOVhxZUtN?=
 =?utf-8?B?ZTlkVmpraW9Tb09CL3pyZzFXVjJuUUhrbk15LzJZQWdUTWswMWZEdSsvMmky?=
 =?utf-8?B?L2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DAB88583FD28524B9C01E6997E026FDE@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYSPR03MB7350.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eafc5955-c9e3-48e4-3418-08dc4498ea4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2024 02:37:53.6125
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V6JfTNZjpMsUdHAyWBQU4xHKXD17Jl1wycugUJ3g5zqaTt+Q0SDFBFDajnOTq9N+NVCdx3B2Q3pRBC/sKTxRIlpAKz9DEJLK7HkWTDUcHnU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8322

T24gRnJpLCAyMDI0LTAzLTA4IGF0IDE1OjAyICswODAwLCBwZXRlci53YW5nQG1lZGlhdGVrLmNv
bSB3cm90ZToNCj4gRnJvbTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+
IA0KPiBGcm9tOiBQby1XZW4gS2FvIDxwb3dlbi5rYW9AbWVkaWF0ZWsuY29tPg0KPiANCj4gSG9z
dCBwb3dlciBjb250cm9sIGlzIGNvbnRyb2wgY3J5cHRvIHNyYW0gcG93ZXIuDQo+IFJlbmFtZSBp
dCBmb3IgZWFzeSBtYWludGFpbi4NCj4gDQo+IFJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRl
ci53YW5nQG1lZGlhdGVrLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIu
d2FuZ0BtZWRpYXRlay5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFBvLVdlbiBLYW8gPHBvd2VuLmth
b0BtZWRpYXRlay5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWst
c2lwLmggfCAxMyArKystLS0tLS0tLS0tDQo+ICBkcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRl
ay5jICAgICB8ICA0ICsrLS0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCAx
MiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1t
ZWRpYXRlay1zaXAuaA0KPiBiL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLXNpcC5oDQo+
IGluZGV4IDMwMTQ2YmIxY2NiZS4uZmQ2NDA4NDY5MTBhIDEwMDc1NQ0KPiAtLS0gYS9kcml2ZXJz
L3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay1zaXAuaA0KPiArKysgYi9kcml2ZXJzL3Vmcy9ob3N0L3Vm
cy1tZWRpYXRlay1zaXAuaA0KPiBAQCAtMTYsNyArMTYsNyBAQA0KPiAgI2RlZmluZSBVRlNfTVRL
X1NJUF9ERVZJQ0VfUkVTRVQgICAgICAgICAgQklUKDEpDQo+ICAjZGVmaW5lIFVGU19NVEtfU0lQ
X0NSWVBUT19DVFJMICAgICAgICAgICBCSVQoMikNCj4gICNkZWZpbmUgVUZTX01US19TSVBfUkVG
X0NMS19OT1RJRklDQVRJT04gIEJJVCgzKQ0KPiAtI2RlZmluZSBVRlNfTVRLX1NJUF9IT1NUX1BX
Ul9DVFJMICAgICAgICAgQklUKDUpDQo+ICsjZGVmaW5lIFVGU19NVEtfU0lQX1NSQU1fUFdSX0NU
UkwgICAgICAgICBCSVQoNSkNCj4gICNkZWZpbmUgVUZTX01US19TSVBfR0VUX1ZDQ19OVU0gICAg
ICAgICAgIEJJVCg2KQ0KPiAgI2RlZmluZSBVRlNfTVRLX1NJUF9ERVZJQ0VfUFdSX0NUUkwgICAg
ICAgQklUKDcpDQo+ICANCj4gQEAgLTMxLDEzICszMSw2IEBAIGVudW0gdWZzX210a192Y2NfbnVt
IHsNCj4gIAlVRlNfVkNDX01BWA0KPiAgfTsNCj4gIA0KPiAtLyoNCj4gLSAqIEhvc3QgUG93ZXIg
Q29udHJvbCBvcHRpb25zDQo+IC0gKi8NCj4gLWVudW0gew0KPiAtCUhPU1RfUFdSX0hDSSA9IDAs
DQo+IC0JSE9TVF9QV1JfTVBIWQ0KPiAtfTsNCj4gIA0KPiAgLyoNCj4gICAqIFNNQyBjYWxsIHdy
YXBwZXIgZnVuY3Rpb24NCj4gQEAgLTc4LDggKzcxLDggQEAgc3RhdGljIGlubGluZSB2b2lkIF91
ZnNfbXRrX3NtYyhzdHJ1Y3QNCj4gdWZzX210a19zbWNfYXJnIHMpDQo+ICAjZGVmaW5lIHVmc19t
dGtfZGV2aWNlX3Jlc2V0X2N0cmwoaGlnaCwgcmVzKSBcDQo+ICAJdWZzX210a19zbWMoVUZTX01U
S19TSVBfREVWSUNFX1JFU0VULCAmKHJlcyksIGhpZ2gpDQo+ICANCj4gLSNkZWZpbmUgdWZzX210
a19ob3N0X3B3cl9jdHJsKG9wdCwgb24sIHJlcykgXA0KPiAtCXVmc19tdGtfc21jKFVGU19NVEtf
U0lQX0hPU1RfUFdSX0NUUkwsICYocmVzKSwgb3B0LCBvbikNCj4gKyNkZWZpbmUgdWZzX210a19z
cmFtX3B3cl9jdHJsKG9uLCByZXMpIFwNCj4gKwl1ZnNfbXRrX3NtYyhVRlNfTVRLX1NJUF9TUkFN
X1BXUl9DVFJMLCAmKHJlcyksIG9uKQ0KPiAgDQo+ICAjZGVmaW5lIHVmc19tdGtfZ2V0X3ZjY19u
dW0ocmVzKSBcDQo+ICAJdWZzX210a19zbWMoVUZTX01US19TSVBfR0VUX1ZDQ19OVU0sICYocmVz
KSkNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMgYi9kcml2
ZXJzL3Vmcy9ob3N0L3Vmcy0NCj4gbWVkaWF0ZWsuYw0KPiBpbmRleCBhZTE4NGU0ZjkwZTYuLjJj
YWYwYzFkNGUxNyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsu
Yw0KPiArKysgYi9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jDQo+IEBAIC0xMzc2LDcg
KzEzNzYsNyBAQCBzdGF0aWMgaW50IHVmc19tdGtfc3VzcGVuZChzdHJ1Y3QgdWZzX2hiYSAqaGJh
LA0KPiBlbnVtIHVmc19wbV9vcCBwbV9vcCwNCj4gIAlpZiAodWZzaGNkX2lzX2xpbmtfb2ZmKGhi
YSkpDQo+ICAJCXVmc19tdGtfZGV2aWNlX3Jlc2V0X2N0cmwoMCwgcmVzKTsNCj4gIA0KPiAtCXVm
c19tdGtfaG9zdF9wd3JfY3RybChIT1NUX1BXUl9IQ0ksIGZhbHNlLCByZXMpOw0KPiArCXVmc19t
dGtfc3JhbV9wd3JfY3RybChmYWxzZSwgcmVzKTsNCj4gIA0KPiAgCXJldHVybiAwOw0KPiAgZmFp
bDoNCj4gQEAgLTEzOTcsNyArMTM5Nyw3IEBAIHN0YXRpYyBpbnQgdWZzX210a19yZXN1bWUoc3Ry
dWN0IHVmc19oYmEgKmhiYSwNCj4gZW51bSB1ZnNfcG1fb3AgcG1fb3ApDQo+ICAJaWYgKGhiYS0+
dWZzaGNkX3N0YXRlICE9IFVGU0hDRF9TVEFURV9PUEVSQVRJT05BTCkNCj4gIAkJdWZzX210a19k
ZXZfdnJlZ19zZXRfbHBtKGhiYSwgZmFsc2UpOw0KPiAgDQo+IC0JdWZzX210a19ob3N0X3B3cl9j
dHJsKEhPU1RfUFdSX0hDSSwgdHJ1ZSwgcmVzKTsNCj4gKwl1ZnNfbXRrX3NyYW1fcHdyX2N0cmwo
dHJ1ZSwgcmVzKTsNCj4gIA0KPiAgCWVyciA9IHVmc19tdGtfbXBoeV9wb3dlcl9vbihoYmEsIHRy
dWUpOw0KPiAgCWlmIChlcnIpDQpBY2tlZC1ieTogQ2h1bi1IdW5nIFd1IDxDaHVuLUh1bmcuV3VA
bWVkaWF0ZWsuY29tPg0K
