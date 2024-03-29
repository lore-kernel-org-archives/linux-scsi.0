Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F32817999
	for <linux-scsi@vger.kernel.org>; Fri, 29 Mar 2024 01:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711676905; cv=fail; b=CPqVqqKuKLVnxyNVh1r9/nOMy44QCX14NGKNscqZrg/yxJ0usz79bubtQK8diN3eeNOokzZbnnO2VC01D8QYHR3mXd+IvjIfyQV0Ua8Ub0iVKswfb/A4VPDvGRf1Hkt9dvIArQAH1AMB21a1Qbf/kn/N1uUP2axfw+w0v104CMA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711676905; c=relaxed/simple;
	bh=xVgN3vjHAZQM7ESRVPWyDh2IAT/3OcQ4uHzy+RsaJvg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aaueylIZT4K6DXY3MkA8HcDtBwafkt5INwz3/4ztwttwMby0Ef9V7C3QvWMYmXc4q6/cBAzCWh3uVLI+AUhkOOJapeNhv4w5uRcOo7mzDTpVEi9AC8DnQZkDSwBQGxMD8u1HlKHR5oH5zehC98s2zhifR4tNHIV9FQZOiiSFUtY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Xg3dc/P1; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=GXYghKB7; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Xg3dc/P1";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="GXYghKB7"
X-UUID: 6abe70d8ed6e11eeb8927bc1f75efef4-20240329
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=xVgN3vjHAZQM7ESRVPWyDh2IAT/3OcQ4uHzy+RsaJvg=;
	b=Xg3dc/P1TqkpyYIUR9iMjDTa2UnvBlvy3EfXYB1kd+6UtTHr2EBnb6JWm1YLljtkunxl6jqjYTBG7pUxmwZa9oUTQWTNlhK8H7+MUBBsPKOB+JikVObbaUKMQpQl74sIXK0DdT9ftRCaKIuiW3Nn0jXZiU45JL8yKHDmkFKauaE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:e84a3259-aa32-4167-88b4-5aef63848e95,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6f543d0,CLOUDID:9ee17400-c26b-4159-a099-3b9d0558e447,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 6abe70d8ed6e11eeb8927bc1f75efef4-20240329
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1034727466; Fri, 29 Mar 2024 09:48:18 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 29 Mar 2024 09:48:17 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 29 Mar 2024 09:48:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dbZGgqEFwxns59z0m51EXfVp6TaNLZELsv9eSbLMYDuoQqsFdiZCiE7DNNl2tY5VJUv2IfHsCJQnxubPCJjcKa5niycg53IPrnMIbHzUqh2QoEM0wj1l4Rjvg54+deijnCXlDZwSpXq8U1uoS/0Ig+S6d2kFWGCl3S5FYnAZv07h97GqYWZmeO5tfw3Sb3Qg1YaZGw7Q5t7FE1WkIvEB8qGnRxNbFLs4gcrX9CEuHAqmhMxMNQy2fYP+8v9TdBj7fRkjDvUOrqh+pOiOA75AHmrx8e+Xe72pf6o15vjFMfyy10sybxbq6bv4iWyLDWl7LVrWSzTtVKG80VVQQ+lfxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xVgN3vjHAZQM7ESRVPWyDh2IAT/3OcQ4uHzy+RsaJvg=;
 b=ixKOYIYfAiqu/E/0QMpGkH2m4E/tKntH9gGAk0lYOjfS14tHC+Lw2gzonD60tbO7mSJEG/Z8Wz4dxeDSdJ664ST6WVcYR5WKSf78ovPApC3dXYXuSKDPF5QkixurLEzhWzGi0nxEWhY8QBPJvjhhXPdvoqROI8IiEjQA5bEPK2Il5/ZOCnpofwjVLvWaVAAv+Uc1U0bktwwF5mOKYneiEgypYEdgl71lXpE89WGlMd/gPfV1UVTaAaW+WzTbvAWy1vJQyHYtBYFpzyN4CRyMSVqZTe+pNoIiM+ImvmtSRli/r801+TDYoSMQ/Isr4GA8wL6q/u7pRlfovl9Ul2Eb5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xVgN3vjHAZQM7ESRVPWyDh2IAT/3OcQ4uHzy+RsaJvg=;
 b=GXYghKB74czXG5tzrW9eB4NEEeSyzHWcRjyS6MknGkqPJIVGxVwcwVorPUDHtlsPIkIs+yieQ+AefK2dZeWB+VuJbicyibOK13pZmYNMcdDNQOLnE7UQOoRBos+mp7M+THivK683GoXY9FJZNzKPz6zKS/I0BRUUtWeTFzZggdc=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB8258.apcprd03.prod.outlook.com (2603:1096:820:115::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.39; Fri, 29 Mar
 2024 01:48:15 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::b834:398:6805:4ca2]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::b834:398:6805:4ca2%6]) with mapi id 15.20.7409.031; Fri, 29 Mar 2024
 01:48:15 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	wsd_upstream <wsd_upstream@mediatek.com>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
	"chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: wlun suspend dev/link state error recovery
Thread-Topic: [PATCH v1] ufs: core: wlun suspend dev/link state error recovery
Thread-Index: AQHagP1SDrv8STXnO06VzGjRm2sAg7FNaaQAgACKtAA=
Date: Fri, 29 Mar 2024 01:48:15 +0000
Message-ID: <110ed3d2e4096ba64cfeeefff5397595f6a507a3.camel@mediatek.com>
References: <20240328104707.1452-1-peter.wang@mediatek.com>
	 <bd8ca5a8-2875-452b-ae99-26eeca15ce13@acm.org>
In-Reply-To: <bd8ca5a8-2875-452b-ae99-26eeca15ce13@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB8258:EE_
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YzwgcQIG2Vg88r1qxTKajS0plXzyBQ1hEUPpfuUMdA+7ql1cNxto0fpqdCyBL5SvSi7cC5DaDDFUHay4DGzT51Wn8vEdbLFWw1JT0kQ4YE6qlLerEvHG7FYiHgszZi1y5i6RBJfAYJuxAAMGJuCsqptFOeW7alWWX77LUWW7KyZlb2sOhtuLFhvvxPWW4fNvHnpQyLoZEVw5o6Gu85jX7Strt/RRTP3KATeLtPd50VblW21Nn15E3JNExczbSXyPYm7v83MEAcJ2pRvjf0sX19jZjsnRKs0AP/CK0DYHhPfSR0GkzC7C3zifCP7JINtoXLahgYgxBTH/DoNxEb4TdtlaVgSZHQQR9gwDkxUWh5rz8qiGaXRYydoge2Lpc2aIGOqNHN56XHgswtlwfqmfMn0ymA3+Bg807hkbops53VpAMGMCT+0m0rNTXi2XGJhA+uMbQm5HkQOPqLP9+PUJAMR/Z0hL06bofNQz3hyXViOCa7M8n1/52v6jWHZZmckk6xuW1In3YgLF/jBJgP1IUPhde8t6fkL+CnE6LxM+fkkaRCnrHL+4Fs4AvSaxV1qLKRDUdsNEMwVR3OtlSF/OKWa8PLwMceVvylwTujEWMz98RGpZA3d6Y//xgKJtqSyax6mhSwvprzU6LqlpTPhJFdi2BgarhCUnExGQtOJMCPA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WEtPWWlCQmYvTHlqaTgzdkQvc0JWZVdkK0VMMTNSSm5kRUgzUHRDMWxrVWhR?=
 =?utf-8?B?dGVpamNHcFFYdVRydW9IM3ROaGZkaHNzUUV3RXRGOW9PN1JRcXBCOUZBS0Fh?=
 =?utf-8?B?L2NiM0VDOW1zY1NhSDRkb3oraGhhWmdJcHFQdWd1bGRucnd5ZkxsaHBYZ20y?=
 =?utf-8?B?SGh3TGdMUkw5Y2R1Z250S0NoUFFJYzAzdUFDVWdzNkY4ZzIwZ2NObEJrcmU4?=
 =?utf-8?B?MERnUUFZNEdXN2JhQzFSTEtKZjhuWFBzUXBsendKMlFSVEpMSjA3Qm8rUmp1?=
 =?utf-8?B?Ky9EeVJ5R0VDSU9lS0EvQ0ZpeUNRZUtSVlRMdno0UVRKbFJzWFpJTDZ1L2JY?=
 =?utf-8?B?bjZTMXlQRkhCUkxJME5wQk5JcVJWYndudnRVdUNHVm1UVUt1M1lmMCtMYWMy?=
 =?utf-8?B?UDFkc0tQQTJFQ2dveUZxenFRcnNSU2luNjdLU1FHT0s2N1RlQ2hVaUlkRFNJ?=
 =?utf-8?B?SHRUODNwRGFjV2MvaHIySExwY25LQ2JxNEFXMTZDVjU4VUJrdU53ZVpiblZj?=
 =?utf-8?B?QUtndzFCRTQ1Ny9mZnpibndBeFFKazdHS0ROQjZoSWpFR0Z1bGROMGFWQlRr?=
 =?utf-8?B?WnViWEh0aThZbytqRm9KSnZQV3dBQjFVT3ozcGU5TFV1OVlTYmY5cGEvTmxu?=
 =?utf-8?B?RHpwUVBBTDBsZjd5ZndmVEk4Q0Uxb2pZaE1MY0txdFVmcVozZlY5YzlrZXU0?=
 =?utf-8?B?ZDlRaFdBeFNSaDJyMldxZXBaYzhZR2tiVDdEbU5Oa2k3cW5lSFo0UTRhUE5H?=
 =?utf-8?B?L1RHMGZSSGkrT1FQVXdrWmhYUDNNb0I2aWNqdTdtalAyUnlPd3g1Z25DK1Ay?=
 =?utf-8?B?cWZUMHo2OGpsS0hNTVJmWXBpTHp1ek5xSHZQUTZDeXhKK2RYanJXZ2cwUVV5?=
 =?utf-8?B?d21pUWtRbklKL0RGMmJkNnY4Tnc1dHZuWnFuMXE3RUFHOThLMU0xSkwveEtV?=
 =?utf-8?B?elYyYmxyZmp4SGtmZnEzWW5mWHVXZVFtc25xVUlQcXJqNUp0aXlVYnBmOTBG?=
 =?utf-8?B?d09QYUFQYTBaL050VExhd0RpR3I3dHd4bldqZ3hrZXNoZC9kUzdsUTVlVW1t?=
 =?utf-8?B?QW1oalRoU3JrRVJCaXBpcFBkREJDSHFWb1R5NGt6dVZxQmRrMjcybjM4Q0dz?=
 =?utf-8?B?djFZS1FnM0pVNUY1TDdpYkpnVDNleXJnU1NJb3FyaDBhU2JRU1BSWUFHVi9v?=
 =?utf-8?B?dWQ0UmZWZDU1Nk5iU2pSdStSbCsyNkZBV09LMzJLbjlhM1ZlY2w1aDJvQ2w3?=
 =?utf-8?B?SERiTi9IOGI5eXRGVFVzM1pDYXJWN0VMSkR4c2pyQjl5TVl5Um1oUDVmb1R3?=
 =?utf-8?B?d05lb1k4ejRCeWo4dWx1VFY0bnZTd1V4Z1l5ellvSk5Hb2lOU0gwWEErZUVv?=
 =?utf-8?B?NDVMUGMvUlRYMi9YaDZoWUJaQXpTL2x3WllXekt1VjVSS09zZHZlQUhEQjlU?=
 =?utf-8?B?WnpqWHlMcDdPdUF1VWxkMmc3UlhnRXpMVEtOZC9NZzJUQUtmK1FpOWtyeDRl?=
 =?utf-8?B?T20xUU83UXhYVExVbWppL2RrREtBdEFZZ0xuVWM3OVVFcC9vaVZDd2FTcU5G?=
 =?utf-8?B?aG11T2E1TWJiL3hvRzBHbjhWa2FOU3hSZ1FKVnZIRkhHbmJGTThSMGQ0NTJt?=
 =?utf-8?B?TnltZzZ5VENwL0twc3Jua08zeVYvR1J1UU1UZE1vaWVFQ1RUZUwxT2VQVGdr?=
 =?utf-8?B?bld2d1o1dEZiN3pxS0RWVWNJcVdpTGd6RE5ibUFQWW91SlFSdVBMTFVOR3BG?=
 =?utf-8?B?NTVObHVoNXNwblg4TVJHcTJHcUlyYkIyV2l4MThJeVAvTE1MRmlFaURPQVRk?=
 =?utf-8?B?dXRsTTZtZGptRHZUaitiaHNYRzRaZWQ5YUswajM1OWI0b08vVFdFUk1ieHFK?=
 =?utf-8?B?RnpxYVl6Q2U5d2Z0ZCtUQjZuT0VXS0ZORTVZRnFlSnBobUN0SzdmS29vUFdl?=
 =?utf-8?B?YktmcU5OTmp1dTBmR0FTcEliTkxWMk1vN1ptbDJ1U21lWE9mTEp2emRKUW1H?=
 =?utf-8?B?NWRoMUsrdEZKekNwNnVZM2NRV0s4Z3pQdnVtekVtRE4xR01VdVV5dG54SFdY?=
 =?utf-8?B?cFJoRzZMVnhrRkNVZkRob3JOdHdIWm9zTWd0NVd5Y1k1YS9vK21kVU9ZenFQ?=
 =?utf-8?B?cFRlMllETmNqRjFNZ0sxL0JCT2VMQ0U3T2hkSXJYS1NmNng1RkRxeGVQODlp?=
 =?utf-8?B?eHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <64C642828B461644843A05B7D3354BC1@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92ac2b69-05a5-48d1-70ac-08dc4f924cc5
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2024 01:48:15.1142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GV9shieSKKFPqcaENQjYsj0csLYJYzS7XDmtosoueN0+bORV0ekeA48+LmjltYDhvAvunoSqoh8sWVVq9tC9Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB8258
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--23.185000-8.000000
X-TMASE-MatchedRID: TMsvcu6/L5fUL3YCMmnG4reiCVGXv/W5bkEYJ8otHacNcckEPxfz2DEU
	xl1gE1bkfdd9BtGlLLzx1uczIHKx54/qvvWxLCnegOqr/r0d+CzOo//J/EA1QauZoybwHAwkzvR
	QSqpv1wVOFu8ssjxG8/qCi9Rv8CVxbn83JMqUbr2xNxaTG4Ot0oEcpMn6x9cZVzOmd/bB9b7xt/
	fflIv7Xc2x8bKmyFE6X07Sn912HMwvebl6MJ1oUWivjLE8DPtZNjuRIfuOU0cRhxa4AcJ0q6PFj
	JEFr+olFUew0Fl/1pE9wJeM2pSaRcK21zBg2KlfAqYBE3k9Mpw=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--23.185000-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	E7A8B707EAB8575AB6A0D8A0227C3888FA268F0E9E0DB267A50014543A00F61F2000:8
X-MTK: N

T24gVGh1LCAyMDI0LTAzLTI4IGF0IDEwOjMxIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gMy8yOC8yNCAwMzo0NywgcGV0ZXIud2FuZ0BtZWRpYXRlay5j
b20gd3JvdGU6DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgYi9k
cml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ID4gaW5kZXggZTMwZmQxMjU5ODhkLi4wYTMyZjQy
M2Y2YTAgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiA+ICsr
KyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gPiBAQCAtOTc5MSw3ICs5NzkxLDEwIEBA
IHN0YXRpYyBpbnQgX191ZnNoY2Rfd2xfc3VzcGVuZChzdHJ1Y3QNCj4gdWZzX2hiYSAqaGJhLCBl
bnVtIHVmc19wbV9vcCBwbV9vcCkNCj4gPiAgIA0KPiA+ICAgLyogVUZTIGRldmljZSAmIGxpbmsg
bXVzdCBiZSBhY3RpdmUgYmVmb3JlIHdlIGVudGVyIGluIHRoaXMNCj4gZnVuY3Rpb24gKi8NCj4g
PiAgIGlmICghdWZzaGNkX2lzX3Vmc19kZXZfYWN0aXZlKGhiYSkgfHwNCj4gIXVmc2hjZF9pc19s
aW5rX2FjdGl2ZShoYmEpKSB7DQo+ID4gLXJldCA9IC1FSU5WQUw7DQo+ID4gKy8qICBXYWl0IGVy
ciBoYW5kbGVyIGZpbmlzaCBvciB0aXJnZ2VyIGVyciByZWNvdmVyeSBpbiB0aGlzIGNhc2UNCj4g
Ki8NCj4gPiAraWYgKCF1ZnNoY2RfZWhfaW5fcHJvZ3Jlc3MoaGJhKSkNCj4gPiArdWZzaGNkX2Zv
cmNlX2Vycm9yX3JlY292ZXJ5KGhiYSk7DQo+ID4gK3JldCA9IC1FQlVTWTsNCj4gPiAgIGdvdG8g
ZW5hYmxlX3NjYWxpbmc7DQo+ID4gICB9DQo+IA0KPiBQbGVhc2UgZml4IHRoZSBzcGVsbGluZyBp
biB0aGUgYWJvdmUgc291cmNlIGNvZGUgY29tbWVudCAoInRpcmdnZXIiKS4NCj4gDQo+IFRoYW5r
cywNCj4gDQo+IEJhcnQuDQo+IA0KPiANCg0KSGkgQmFydCwNCg0KV2lsbCBmaXggdHlwbyBuZXh0
IHZlcnNpb24uDQoNClRoYW5rcw0KUGV0ZXINCg0KDQo=
