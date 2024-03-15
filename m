Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F61D266
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 02:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710470230; cv=fail; b=sNqxlp5U9TZ3FJRsa11oBItqI4grUO5EuijBbjUGIbNpWAEkhxIXw3wwCP1RPT1lKlZNKcaKWP40Ag6U56MJWgGwliWOVyKSDMI3D4/WAmQrsBvnB4Hnf4ow5D36/X2i4cBnXN/JuNUlMEpYsDDuxwEp9zYkcm86R9MdlWrblIM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710470230; c=relaxed/simple;
	bh=LQKyzjW7iGqx/8TSSZ8A/ZF90UkO163xVDREt3CsP0w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=D0Q4kKIkAv1s9lAw8QpT6qwduM3roBmZQ1EEDReADhWzMBGqsmZYg1W4J6IJmt9Fl2M90vNPSSM5V4w4UnB+XRaVOdwcmmkEyJdTJ8tbrIDfB9PXk/GSj7gF9FLKaIVYq70ur45x0dRsD9wLrBH/RI0qoF2DTe10/bWPvdfmUK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=bdwU0ZNE; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=FGjCaV63; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="bdwU0ZNE";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="FGjCaV63"
X-UUID: e749fa50e27411ee935d6952f98a51a9-20240315
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=LQKyzjW7iGqx/8TSSZ8A/ZF90UkO163xVDREt3CsP0w=;
	b=bdwU0ZNE6N9IFdfpYe3geoQAKHAdql4YMKr5E7X0VlCy62ClEOEp2LUD3JyDgS0xije8VEAlvVBOS6jYyD1wtix1nFycQWRW8NU5NCI+C99CTEOVaQkLZOSZbPPvPQghEa8ZdXyxvt9+mox/z1m2EKm0mxr4sn4kwbqJPGtMT3w=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:f6247f65-6b26-4644-8ce4-ebd8ce3cb656,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6f543d0,CLOUDID:78270685-8d4f-477b-89d2-1e3bdbef96d1,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: e749fa50e27411ee935d6952f98a51a9-20240315
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <chun-hung.wu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 818491442; Fri, 15 Mar 2024 10:37:01 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 15 Mar 2024 10:37:00 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 15 Mar 2024 10:37:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IS+3qsnk5I0to6/6UVJXonh+fZMFXpGUTx8mv3ef1jcxgptvyX6MLipwf2N7APyHFus8oUOotoyLcaobIRwU2bHRW6Ln6pcgmRyeajYbCtnmTxc2mOzBvEwOf5LpAB7+lKwKbm5mxM0omd/WOCA7I1DkXDX8uM4LUap5V6kaN4QGsfUeCBGlgATcLRKIXoX0ft9ngVmxdkFTs4gEHQ14AZuzqcr94+x+PoVX4vs+wsUTAvrfrhhpeWEpLqirT20m49UiO95S3Wbn8EhtcvbpcmZjcCd5lOlbYQ77kt4OzW4ngs2iQyLKXwlgEKpFN4IU46PP4zl+2B/dHm9dsSmElw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LQKyzjW7iGqx/8TSSZ8A/ZF90UkO163xVDREt3CsP0w=;
 b=nL/e9Ixl0+a5+xvCIE2dbiCnOtnC1KiBAnGHErkmIIHS9R7vVQDYKT+L/e3uYtAAaveKAMB8mlqVXIXG9andepb4ooxaqiKrWF5srrFX9gxngmsmbjmVA1xBEGpHKVvlPZNBnawf9OXlas9vgyT5wYoreqpILbCl9LKRZI9E76+WJwl44qZ2t6YzZQIt4lWyE6+k6uwc/SaqSBYAnxiKX7Yk/fJwtK+IiAysbShlnXQwAgyMZB1VY+P1JvbmFR32j60256q5phSJb23y8hKqTGNpyTqnazzUtMjZ8D7uKvr71FNaOUWBQMuszyifw+4cZQH66pQShAfx0b3QGCwsVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQKyzjW7iGqx/8TSSZ8A/ZF90UkO163xVDREt3CsP0w=;
 b=FGjCaV63SD+AYSiP3FAwusoROs8pLnXG5QojMMCOpVoGjtQk/pN9qLIb9tLusYmmoUT6a3uZv1zfAv/rAQikv/2JhNPaidri2isCoqD91CaDxtb/xzPo20nXMatH8VxJ1uTTOy7c+vKomdESAmcdVvQxahGqeHXcJTUGMhT7S6Y=
Received: from TYSPR03MB7350.apcprd03.prod.outlook.com (2603:1096:400:413::14)
 by SEZPR03MB8322.apcprd03.prod.outlook.com (2603:1096:101:192::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.19; Fri, 15 Mar
 2024 02:36:56 +0000
Received: from TYSPR03MB7350.apcprd03.prod.outlook.com
 ([fe80::913f:a95a:231e:cd2c]) by TYSPR03MB7350.apcprd03.prod.outlook.com
 ([fe80::913f:a95a:231e:cd2c%3]) with mapi id 15.20.7386.020; Fri, 15 Mar 2024
 02:36:56 +0000
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
Subject: Re: [PATCH v1 4/7] ufs: host: mediatek: ufs mtk sip command
 reconstruct
Thread-Topic: [PATCH v1 4/7] ufs: host: mediatek: ufs mtk sip command
 reconstruct
Thread-Index: AQHacSa4YX3skvJb50qEWL7ckUZRErE4IP0A
Date: Fri, 15 Mar 2024 02:36:56 +0000
Message-ID: <ae0fa9de72dd24f011e8abb17ad640aab6bfa1f0.camel@mediatek.com>
References: <20240308070241.9163-1-peter.wang@mediatek.com>
	 <20240308070241.9163-5-peter.wang@mediatek.com>
In-Reply-To: <20240308070241.9163-5-peter.wang@mediatek.com>
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
x-microsoft-antispam-message-info: gsdkqdu6MAM2qFE1HCFKwdNRTud/nemQRrM+Wasen0oEEAlk5zDOlL9p5YNp7/ZreYFjBPt0dHOf8jq2qBdTP1s8s5ldxgoVPyPsi8ixr/V1cBJOHDY1V9C6cD69gHS2AlbXVpW0aGx2QjcUZQ2+ywzjddm9jWimkRmUTEyMuXZ74kzBc3UBL66zW+fOzo4qTKao9dIgPvbDw3yYacf8ueOyX2tdf0aIelW/ZDgsmWIshfbUnqhax1MXm37Rpk5IVxOfQNdYzfom0xH1J77kJvBk0eBeMPttltC6XHG/zMqEHHsUrEjKqIM0bc10ScniD8npbLKzOi6p3Pfrt/uRL0Y/UHIlxSIMmWXtGLOuO8QdaOwxwVoRennJ9CY/2AxVvdQ5ragcSudS5pZ5jAx0fnHqx4QLjSMP4cI6VD0onFTf+2JjbAyIUTVL/cUG66NQMBQt9T6kfyH9yIppEN2aiaf6GlF0T45m1r3/t46IR1OsW7Diu6YMX+13kr4u0xtx0OX1ZctSUUQt+X8AiQrz2A8mj6+mCXGZaFX0muxTw9vw28rZbp+2IsDnSHl7NfpaBXIpIrz3xkLGUQ3DdZObmDOFmlPzGLnxE2XnH+xehRxwplUiqO0HjeTuedx/93osgp64QKOxVzTzfcjStnd7znVtcirMXr0TibvQnRwnfLw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR03MB7350.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K0pGNkRGdEs0cVdaN0Q4ZWtSRVZtcUgyd3lwYnRUNGYwUGNZTFY1TG8yT1VU?=
 =?utf-8?B?QnltSXJscHdlZm9zZUdDZEJkaUVhM3B5QmtZMkN1MmYxUFlmbU9pWjVla2Iw?=
 =?utf-8?B?UkU3S2dSaXg0emUwenBNcCtOY25XVWdBUnhNTXZTU0FGdU15blVGMElMbnhO?=
 =?utf-8?B?N3NFb093d2ZyUmlKSWlnVTQzKzhqRHlFa3NrczdmcGkrUnNUTXZzL1hETVJD?=
 =?utf-8?B?emRRTU1qQnBQM2JNeFlXWHUvbVFGQm5UMTYyM1hqMkVkQXdYUmZhbFhxS3Ja?=
 =?utf-8?B?VWIwQUszV0NlYnU0bG9vQUFzTjZlbE5iWWlYbUIzV01pSEgzeitIRjF1SlNE?=
 =?utf-8?B?bi90VmN4dzRLNGVOcitzbGkvcTJzakZPS3NOSjlNenliL3MybXpNbVV4dnYz?=
 =?utf-8?B?N2lieVNVUlVnUFVzUHNlcHRlQ2VoZ1ZldTBrZTU3Q2l1aFVxOW1UOUFBemNi?=
 =?utf-8?B?TzMyRFhJU3hBY1RnNDhNSUN3UmhBQnZwaEFDbG9LOXF1NS9pRXdWYjlLc3p6?=
 =?utf-8?B?RWlKcUZndFg5ck5naFNXeEJtVDNpeElZYnp2YU1KdW5SM0pFUWxMUGcxdkc1?=
 =?utf-8?B?NEVYS0VsZy85ZEp2emdtSGkxMUlHWldMWnVMdTU5djN4Ym5PMXcvYkpYYXBw?=
 =?utf-8?B?bG15LytkSmV6Smt1Mkl4aStnRTRaMTBBNmQ2cmpxRFRoVnQ5WUlSbllPK0l3?=
 =?utf-8?B?TkNQSDlLKzVibzJoc1FMSGc5cXR6b2ZVVjgwV1IyN1B3MkZEOXpJWDh6VHBO?=
 =?utf-8?B?RFdKakNaZzMxa2M3cVdNUW9pYTBEUU13S0J6WlMvZDVkT3hZVVNhSFFjUzJU?=
 =?utf-8?B?ZXlWY2hLOFp1V2c0ZFh1cFZYVXNUcVZEOHBEUm4rRHFoTEJNWnV2RHJQQ3RM?=
 =?utf-8?B?bytaUVhyTmxMWEZycEZuQ2hhb08rUHAxbGh4M1p3aXVvL2F0MmMvdXB3UmJW?=
 =?utf-8?B?cnVVcXZBaWttMmU1QURLMXY1UTNMQnZtTmVSM1RQMzBNMlpXYjRXMGs2eHBm?=
 =?utf-8?B?WXg5THFTZFhwTUlRaVdPZ3YxMXRMRjNqMEZvZ0M5eFNWZ1R2QnZ6L1luSldm?=
 =?utf-8?B?UU5ralhqU01wbFpid0FIMDhibjZ3L2oyc1VQNk9MYStFQ01Ya2pVTzVYUWVO?=
 =?utf-8?B?aU8raGRvYjJkTzdxb3BlaW4xQjlqV0h2Z0dhV2dqSlNVcHhYODRnd3hvOUFR?=
 =?utf-8?B?czR0Q2tjNkdhcjBFcmNxWVF3WVZLYWR0b1FmRUV2K2F3eFEwM1FEVk1VR2xC?=
 =?utf-8?B?bHdTamRYWFNBR2Qxb2dsVnVtVW5keU1XTHBiT24vem8wNzVMNitKMEx3QStW?=
 =?utf-8?B?YU1FaXg4bnR4ZE9NTUhCdzVybnlaZmloN0ZJUjVLcS93eFF4dUtwOVRDT21R?=
 =?utf-8?B?V0k3cjRqSlIrcHJhQy9DOXo2K2RZQ3M4cHhJN05qblFjTHZ1NG5VU0V1c0VO?=
 =?utf-8?B?ZG5QcXBYZXl4WWVnMjgyQTVyRGd1REJ0NWVycW1LMGI0YWkwb0hQSGFtMkFk?=
 =?utf-8?B?Zkl6VktGdkxVRFpqTGltSVdOZDhVaHF0cUR6bGp0NTN6eVpzbjN1Y2p3d2Y3?=
 =?utf-8?B?YkEwL2tsU1ZWN01jTTVPSHZwcEZjaVVVaXc2ejB5Z2ZpRWZPU2RveHNTemtR?=
 =?utf-8?B?d2FTRlBHeEs1STdLREtwOURBSHI2eFRsYUJxTU5tRnl3bi90R3JyaU5MSlRn?=
 =?utf-8?B?eUwvMjV1bFZNZG5IbjNnV2xTaUhSaTFSSlBwNDBKZEVQR0xWRWpMR2tRZ2Zx?=
 =?utf-8?B?ZVdSMXlZMkFlVDJRbml3ZFdST3duL0hNWmN1aXdUMDA1SzExcTFUSUhTVkM4?=
 =?utf-8?B?TlQwUll1Y2hUM1FIZzF6YU1XNk5lWWtxeXVWcmxCbmVLRmNrQlVOTXFmUHlG?=
 =?utf-8?B?SXF6eE1wR05CZ212akhZQ013Sm9vV3JvWXE1U2Z5aGdUb0JiZmlYMHhHQUNs?=
 =?utf-8?B?UEpVaVlrL2Y0TzYxdExrZWE4L1dkaHdWaWYvc1RjMWtGOStDeTVTSVM1b08z?=
 =?utf-8?B?ODliNkxHMFVZOFVtM2VMRXZyNElvcEtNMFczbnVSbUxnQUcybGV3QjFDdUht?=
 =?utf-8?B?czJWclpJZithKzBZRWhIRWJGTlFkUTVtM0dzSFZ5OE90UnlGOGVmMUt0V0J2?=
 =?utf-8?B?SVd5TmVrSG5Wek1vMzB6bjZtR1RvVmNneTNQSVlpYXhYaVVTRU80Mk11aHhj?=
 =?utf-8?B?R3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D1D8FAADCC42E47937C0F80442C025E@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYSPR03MB7350.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae408305-c68f-4456-96fe-08dc4498c85e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2024 02:36:56.6855
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wYWLOUMtCqjB4M/PJ9Vzp0MldXNoKC1mzOn0hTmi8j5O/52Y2CC9d36R6bpzUEjxFgzV0U0clULa/m2SHqmoxAO64b3nIXNl8tmn8qgGPtE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8322

T24gRnJpLCAyMDI0LTAzLTA4IGF0IDE1OjAyICswODAwLCBwZXRlci53YW5nQG1lZGlhdGVrLmNv
bSB3cm90ZToNCj4gRnJvbTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+
IA0KPiBGcm9tOiBQby1XZW4gS2FvIDxwb3dlbi5rYW9AbWVkaWF0ZWsuY29tPg0KPiANCj4gTW92
ZSBzaXAgY29tbWFuZCBhbmQgZGVmaW5lIHRvIGEgbmV3IHNpcCBoZWFkZXIgZmlsZS4NCj4gDQo+
IFJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCj4gU2ln
bmVkLW9mZi1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+IFNpZ25l
ZC1vZmYtYnk6IFBvLVdlbiBLYW8gPHBvd2VuLmthb0BtZWRpYXRlay5jb20+DQo+IC0tLQ0KPiAg
ZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWstc2lwLmggfCA5MA0KPiArKysrKysrKysrKysr
KysrKysrKysrKysrKysrKw0KPiAgZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYyAgICAg
fCAgMyArLQ0KPiAgZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuaCAgICAgfCA3OSAtLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ICAzIGZpbGVzIGNoYW5nZWQsIDkyIGluc2VydGlvbnMo
KyksIDgwIGRlbGV0aW9ucygtKQ0KPiAgY3JlYXRlIG1vZGUgMTAwNzU1IGRyaXZlcnMvdWZzL2hv
c3QvdWZzLW1lZGlhdGVrLXNpcC5oDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvaG9z
dC91ZnMtbWVkaWF0ZWstc2lwLmgNCj4gYi9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay1z
aXAuaA0KPiBuZXcgZmlsZSBtb2RlIDEwMDc1NQ0KPiBpbmRleCAwMDAwMDAwMDAwMDAuLjMwMTQ2
YmIxY2NiZQ0KPiAtLS0gL2Rldi9udWxsDQo+ICsrKyBiL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1l
ZGlhdGVrLXNpcC5oDQo+IEBAIC0wLDAgKzEsOTAgQEANCj4gKy8qIFNQRFgtTGljZW5zZS1JZGVu
dGlmaWVyOiBHUEwtMi4wICovDQo+ICsvKg0KPiArICogQ29weXJpZ2h0IChDKSAyMDIyIE1lZGlh
VGVrIEluYy4NCj4gKyAqLw0KPiArDQo+ICsjaWZuZGVmIF9VRlNfTUVESUFURUtfU0lQX0gNCj4g
KyNkZWZpbmUgX1VGU19NRURJQVRFS19TSVBfSA0KPiArDQo+ICsjaW5jbHVkZSA8bGludXgvc29j
L21lZGlhdGVrL210a19zaXBfc3ZjLmg+DQo+ICsNCj4gKy8qDQo+ICsgKiBTaVAgY29tbWFuZHMN
Cj4gKyAqLw0KPiArI2RlZmluZSBNVEtfU0lQX1VGU19DT05UUk9MICAgICAgICAgICAgICAgTVRL
X1NJUF9TTUNfQ01EKDB4Mjc2KQ0KPiArI2RlZmluZSBVRlNfTVRLX1NJUF9WQTA5X1BXUl9DVFJM
ICAgICAgICAgQklUKDApDQo+ICsjZGVmaW5lIFVGU19NVEtfU0lQX0RFVklDRV9SRVNFVCAgICAg
ICAgICBCSVQoMSkNCj4gKyNkZWZpbmUgVUZTX01US19TSVBfQ1JZUFRPX0NUUkwgICAgICAgICAg
IEJJVCgyKQ0KPiArI2RlZmluZSBVRlNfTVRLX1NJUF9SRUZfQ0xLX05PVElGSUNBVElPTiAgQklU
KDMpDQo+ICsjZGVmaW5lIFVGU19NVEtfU0lQX0hPU1RfUFdSX0NUUkwgICAgICAgICBCSVQoNSkN
Cj4gKyNkZWZpbmUgVUZTX01US19TSVBfR0VUX1ZDQ19OVU0gICAgICAgICAgIEJJVCg2KQ0KPiAr
I2RlZmluZSBVRlNfTVRLX1NJUF9ERVZJQ0VfUFdSX0NUUkwgICAgICAgQklUKDcpDQo+ICsNCj4g
Kw0KPiArLyoNCj4gKyAqIE11bHRpLVZDQyBieSBOdW1iZXJpbmcNCj4gKyAqLw0KPiArZW51bSB1
ZnNfbXRrX3ZjY19udW0gew0KPiArCVVGU19WQ0NfTk9ORSA9IDAsDQo+ICsJVUZTX1ZDQ18xLA0K
PiArCVVGU19WQ0NfMiwNCj4gKwlVRlNfVkNDX01BWA0KPiArfTsNCj4gKw0KPiArLyoNCj4gKyAq
IEhvc3QgUG93ZXIgQ29udHJvbCBvcHRpb25zDQo+ICsgKi8NCj4gK2VudW0gew0KPiArCUhPU1Rf
UFdSX0hDSSA9IDAsDQo+ICsJSE9TVF9QV1JfTVBIWQ0KPiArfTsNCj4gKw0KPiArLyoNCj4gKyAq
IFNNQyBjYWxsIHdyYXBwZXIgZnVuY3Rpb24NCj4gKyAqLw0KPiArc3RydWN0IHVmc19tdGtfc21j
X2FyZyB7DQo+ICsJdW5zaWduZWQgbG9uZyBjbWQ7DQo+ICsJc3RydWN0IGFybV9zbWNjY19yZXMg
KnJlczsNCj4gKwl1bnNpZ25lZCBsb25nIHYxOw0KPiArCXVuc2lnbmVkIGxvbmcgdjI7DQo+ICsJ
dW5zaWduZWQgbG9uZyB2MzsNCj4gKwl1bnNpZ25lZCBsb25nIHY0Ow0KPiArCXVuc2lnbmVkIGxv
bmcgdjU7DQo+ICsJdW5zaWduZWQgbG9uZyB2NjsNCj4gKwl1bnNpZ25lZCBsb25nIHY3Ow0KPiAr
fTsNCj4gKw0KPiArDQo+ICtzdGF0aWMgaW5saW5lIHZvaWQgX3Vmc19tdGtfc21jKHN0cnVjdCB1
ZnNfbXRrX3NtY19hcmcgcykNCj4gK3sNCj4gKwlhcm1fc21jY2Nfc21jKE1US19TSVBfVUZTX0NP
TlRST0wsDQo+ICsJCXMuY21kLA0KPiArCQlzLnYxLCBzLnYyLCBzLnYzLCBzLnY0LCBzLnY1LCBz
LnY2LCBzLnJlcyk7DQo+ICt9DQo+ICsNCj4gKyNkZWZpbmUgdWZzX210a19zbWMoLi4uKSBcDQo+
ICsJX3Vmc19tdGtfc21jKChzdHJ1Y3QgdWZzX210a19zbWNfYXJnKSB7X19WQV9BUkdTX199KQ0K
PiArDQo+ICsvKiBTaXAga2VybmVsIGludGVyZmFjZSAqLw0KPiArI2RlZmluZSB1ZnNfbXRrX3Zh
MDlfcHdyX2N0cmwocmVzLCBvbikgXA0KPiArCXVmc19tdGtfc21jKFVGU19NVEtfU0lQX1ZBMDlf
UFdSX0NUUkwsICYocmVzKSwgb24pDQo+ICsNCj4gKyNkZWZpbmUgdWZzX210a19jcnlwdG9fY3Ry
bChyZXMsIGVuYWJsZSkgXA0KPiArCXVmc19tdGtfc21jKFVGU19NVEtfU0lQX0NSWVBUT19DVFJM
LCAmKHJlcyksIGVuYWJsZSkNCj4gKw0KPiArI2RlZmluZSB1ZnNfbXRrX3JlZl9jbGtfbm90aWZ5
KG9uLCBzdGFnZSwgcmVzKSBcDQo+ICsJdWZzX210a19zbWMoVUZTX01US19TSVBfUkVGX0NMS19O
T1RJRklDQVRJT04sICYocmVzKSwgb24sDQo+IHN0YWdlKQ0KPiArDQo+ICsjZGVmaW5lIHVmc19t
dGtfZGV2aWNlX3Jlc2V0X2N0cmwoaGlnaCwgcmVzKSBcDQo+ICsJdWZzX210a19zbWMoVUZTX01U
S19TSVBfREVWSUNFX1JFU0VULCAmKHJlcyksIGhpZ2gpDQo+ICsNCj4gKyNkZWZpbmUgdWZzX210
a19ob3N0X3B3cl9jdHJsKG9wdCwgb24sIHJlcykgXA0KPiArCXVmc19tdGtfc21jKFVGU19NVEtf
U0lQX0hPU1RfUFdSX0NUUkwsICYocmVzKSwgb3B0LCBvbikNCj4gKw0KPiArI2RlZmluZSB1ZnNf
bXRrX2dldF92Y2NfbnVtKHJlcykgXA0KPiArCXVmc19tdGtfc21jKFVGU19NVEtfU0lQX0dFVF9W
Q0NfTlVNLCAmKHJlcykpDQo+ICsNCj4gKyNkZWZpbmUgdWZzX210a19kZXZpY2VfcHdyX2N0cmwo
b24sIHVmc192ZXJzaW9uLCByZXMpIFwNCj4gKwl1ZnNfbXRrX3NtYyhVRlNfTVRLX1NJUF9ERVZJ
Q0VfUFdSX0NUUkwsICYocmVzKSwgb24sDQo+IHVmc192ZXJzaW9uKQ0KPiArDQo+ICsjZW5kaWYg
LyogIV9VRlNfTUVESUFURUtfU0lQX0ggKi8NCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2hv
c3QvdWZzLW1lZGlhdGVrLmMgYi9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy0NCj4gbWVkaWF0ZWsuYw0K
PiBpbmRleCBjZGYyOWNmYTQ5MGIuLmFlMTg0ZTRmOTBlNiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVy
cy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYw0KPiArKysgYi9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1t
ZWRpYXRlay5jDQo+IEBAIC0yMCwxMyArMjAsMTQgQEANCj4gICNpbmNsdWRlIDxsaW51eC9wbV9x
b3MuaD4NCj4gICNpbmNsdWRlIDxsaW51eC9yZWd1bGF0b3IvY29uc3VtZXIuaD4NCj4gICNpbmNs
dWRlIDxsaW51eC9yZXNldC5oPg0KPiAtI2luY2x1ZGUgPGxpbnV4L3NvYy9tZWRpYXRlay9tdGtf
c2lwX3N2Yy5oPg0KPiAgDQo+ICAjaW5jbHVkZSA8dWZzL3Vmc2hjZC5oPg0KPiAgI2luY2x1ZGUg
InVmc2hjZC1wbHRmcm0uaCINCj4gICNpbmNsdWRlIDx1ZnMvdWZzX3F1aXJrcy5oPg0KPiAgI2lu
Y2x1ZGUgPHVmcy91bmlwcm8uaD4NCj4gKw0KPiAgI2luY2x1ZGUgInVmcy1tZWRpYXRlay5oIg0K
PiArI2luY2x1ZGUgInVmcy1tZWRpYXRlay1zaXAuaCINCj4gIA0KPiAgc3RhdGljIGludCAgdWZz
X210a19jb25maWdfbWNxKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wgaXJxKTsNCj4gIA0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuaCBiL2RyaXZlcnMvdWZz
L2hvc3QvdWZzLQ0KPiBtZWRpYXRlay5oDQo+IGluZGV4IDc5YzY0ZGUyNTI1NC4uMTdiZTNmNzQ4
ZmEwIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5oDQo+ICsr
KyBiL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmgNCj4gQEAgLTgsNyArOCw2IEBADQo+
ICANCj4gICNpbmNsdWRlIDxsaW51eC9iaXRvcHMuaD4NCj4gICNpbmNsdWRlIDxsaW51eC9wbV9x
b3MuaD4NCj4gLSNpbmNsdWRlIDxsaW51eC9zb2MvbWVkaWF0ZWsvbXRrX3NpcF9zdmMuaD4NCj4g
IA0KPiAgLyoNCj4gICAqIE1DUSBkZWZpbmUgYW5kIHN0cnVjdA0KPiBAQCAtMTAwLDE4ICs5OSw2
IEBAIGVudW0gew0KPiAgCVZTX0hJQl9FWElUICAgICAgICAgICAgICAgICA9IDEzLA0KPiAgfTsN
Cj4gIA0KPiAtLyoNCj4gLSAqIFNpUCBjb21tYW5kcw0KPiAtICovDQo+IC0jZGVmaW5lIE1US19T
SVBfVUZTX0NPTlRST0wgICAgICAgICAgICAgICBNVEtfU0lQX1NNQ19DTUQoMHgyNzYpDQo+IC0j
ZGVmaW5lIFVGU19NVEtfU0lQX1ZBMDlfUFdSX0NUUkwgICAgICAgICBCSVQoMCkNCj4gLSNkZWZp
bmUgVUZTX01US19TSVBfREVWSUNFX1JFU0VUICAgICAgICAgIEJJVCgxKQ0KPiAtI2RlZmluZSBV
RlNfTVRLX1NJUF9DUllQVE9fQ1RSTCAgICAgICAgICAgQklUKDIpDQo+IC0jZGVmaW5lIFVGU19N
VEtfU0lQX1JFRl9DTEtfTk9USUZJQ0FUSU9OICBCSVQoMykNCj4gLSNkZWZpbmUgVUZTX01US19T
SVBfSE9TVF9QV1JfQ1RSTCAgICAgICAgIEJJVCg1KQ0KPiAtI2RlZmluZSBVRlNfTVRLX1NJUF9H
RVRfVkNDX05VTSAgICAgICAgICAgQklUKDYpDQo+IC0jZGVmaW5lIFVGU19NVEtfU0lQX0RFVklD
RV9QV1JfQ1RSTCAgICAgICBCSVQoNykNCj4gLQ0KPiAgLyoNCj4gICAqIFZTX0RFQlVHQ0xPQ0tF
TkFCTEUNCj4gICAqLw0KPiBAQCAtMTk3LDcwICsxODQsNCBAQCBzdHJ1Y3QgdWZzX210a19ob3N0
IHsNCj4gIAlzdHJ1Y3QgdWZzX210a19tY3FfaW50cl9pbmZvIG1jcV9pbnRyX2luZm9bVUZTSENE
X01BWF9RX05SXTsNCj4gIH07DQo+ICANCj4gLS8qDQo+IC0gKiBNdWx0aS1WQ0MgYnkgTnVtYmVy
aW5nDQo+IC0gKi8NCj4gLWVudW0gdWZzX210a192Y2NfbnVtIHsNCj4gLQlVRlNfVkNDX05PTkUg
PSAwLA0KPiAtCVVGU19WQ0NfMSwNCj4gLQlVRlNfVkNDXzIsDQo+IC0JVUZTX1ZDQ19NQVgNCj4g
LX07DQo+IC0NCj4gLS8qDQo+IC0gKiBIb3N0IFBvd2VyIENvbnRyb2wgb3B0aW9ucw0KPiAtICov
DQo+IC1lbnVtIHsNCj4gLQlIT1NUX1BXUl9IQ0kgPSAwLA0KPiAtCUhPU1RfUFdSX01QSFkNCj4g
LX07DQo+IC0NCj4gLS8qDQo+IC0gKiBTTUMgY2FsbCB3cmFwcGVyIGZ1bmN0aW9uDQo+IC0gKi8N
Cj4gLXN0cnVjdCB1ZnNfbXRrX3NtY19hcmcgew0KPiAtCXVuc2lnbmVkIGxvbmcgY21kOw0KPiAt
CXN0cnVjdCBhcm1fc21jY2NfcmVzICpyZXM7DQo+IC0JdW5zaWduZWQgbG9uZyB2MTsNCj4gLQl1
bnNpZ25lZCBsb25nIHYyOw0KPiAtCXVuc2lnbmVkIGxvbmcgdjM7DQo+IC0JdW5zaWduZWQgbG9u
ZyB2NDsNCj4gLQl1bnNpZ25lZCBsb25nIHY1Ow0KPiAtCXVuc2lnbmVkIGxvbmcgdjY7DQo+IC0J
dW5zaWduZWQgbG9uZyB2NzsNCj4gLX07DQo+IC0NCj4gLXN0YXRpYyB2b2lkIF91ZnNfbXRrX3Nt
YyhzdHJ1Y3QgdWZzX210a19zbWNfYXJnIHMpDQo+IC17DQo+IC0JYXJtX3NtY2NjX3NtYyhNVEtf
U0lQX1VGU19DT05UUk9MLA0KPiAtCQkgICAgICBzLmNtZCwgcy52MSwgcy52Miwgcy52Mywgcy52
NCwgcy52NSwgcy52NiwNCj4gcy5yZXMpOw0KPiAtfQ0KPiAtDQo+IC0jZGVmaW5lIHVmc19tdGtf
c21jKC4uLikgXA0KPiAtCV91ZnNfbXRrX3NtYygoc3RydWN0IHVmc19tdGtfc21jX2FyZykge19f
VkFfQVJHU19ffSkNCj4gLQ0KPiAtLyoNCj4gLSAqIFNNQyBjYWxsIGludGVyZmFjZQ0KPiAtICov
DQo+IC0jZGVmaW5lIHVmc19tdGtfdmEwOV9wd3JfY3RybChyZXMsIG9uKSBcDQo+IC0JdWZzX210
a19zbWMoVUZTX01US19TSVBfVkEwOV9QV1JfQ1RSTCwgJihyZXMpLCBvbikNCj4gLQ0KPiAtI2Rl
ZmluZSB1ZnNfbXRrX2NyeXB0b19jdHJsKHJlcywgZW5hYmxlKSBcDQo+IC0JdWZzX210a19zbWMo
VUZTX01US19TSVBfQ1JZUFRPX0NUUkwsICYocmVzKSwgZW5hYmxlKQ0KPiAtDQo+IC0jZGVmaW5l
IHVmc19tdGtfcmVmX2Nsa19ub3RpZnkob24sIHN0YWdlLCByZXMpIFwNCj4gLQl1ZnNfbXRrX3Nt
YyhVRlNfTVRLX1NJUF9SRUZfQ0xLX05PVElGSUNBVElPTiwgJihyZXMpLCBvbiwNCj4gc3RhZ2Up
DQo+IC0NCj4gLSNkZWZpbmUgdWZzX210a19kZXZpY2VfcmVzZXRfY3RybChoaWdoLCByZXMpIFwN
Cj4gLQl1ZnNfbXRrX3NtYyhVRlNfTVRLX1NJUF9ERVZJQ0VfUkVTRVQsICYocmVzKSwgaGlnaCkN
Cj4gLQ0KPiAtI2RlZmluZSB1ZnNfbXRrX2hvc3RfcHdyX2N0cmwob3B0LCBvbiwgcmVzKSBcDQo+
IC0JdWZzX210a19zbWMoVUZTX01US19TSVBfSE9TVF9QV1JfQ1RSTCwgJihyZXMpLCBvcHQsIG9u
KQ0KPiAtDQo+IC0jZGVmaW5lIHVmc19tdGtfZ2V0X3ZjY19udW0ocmVzKSBcDQo+IC0JdWZzX210
a19zbWMoVUZTX01US19TSVBfR0VUX1ZDQ19OVU0sICYocmVzKSkNCj4gLQ0KPiAtI2RlZmluZSB1
ZnNfbXRrX2RldmljZV9wd3JfY3RybChvbiwgdWZzX3ZlciwgcmVzKSBcDQo+IC0JdWZzX210a19z
bWMoVUZTX01US19TSVBfREVWSUNFX1BXUl9DVFJMLCAmKHJlcyksIG9uLCB1ZnNfdmVyKQ0KPiAt
DQo+ICAjZW5kaWYgLyogIV9VRlNfTUVESUFURUtfSCAqLw0KDQpBY2tlZC1ieTogQ2h1bi1IdW5n
IFd1IDxDaHVuLUh1bmcuV3VAbWVkaWF0ZWsuY29tPg0K
