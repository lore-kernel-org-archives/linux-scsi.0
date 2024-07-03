Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B118E8F58
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jul 2024 09:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719997223; cv=fail; b=BFoNI1z9jp532v6O3gyWlavD1MXMCywt9WImux6Y6zi81llLGpATim+nKu1WjsWAt3BxsiVc5n1oir4idB6h9rpXzBpJ0X1qCP5DDg6sA+8sF1YyY8tLiszBeTvuVpLB3Z5e8yGtSxY5tLDAtQPFptzLqWN71xVhcAqe7Gwghzk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719997223; c=relaxed/simple;
	bh=unpjoWEWHHzhKZ7oYefGNHmZLAlmz22C1xOF26Uquno=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jPg8NlcrI4vS80asuhM5n7/SSGBpKa0rhAKQmf/Ak+A8oyMpwyAlX4UN6hDehXyjBO5x2s9qZfHDWafark+zoZwWgai2aAytTveZWQTFk5WF/HD9OPk0YLunFXi2fI64FQmHGK8gTiSnJghoDnbRGp6rY0holrvX9xeg8BhceQg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Su/ruZKD; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=uhfqLRbh; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Su/ruZKD";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="uhfqLRbh"
X-UUID: aa13452c391a11ef8b8f29950b90a568-20240703
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=unpjoWEWHHzhKZ7oYefGNHmZLAlmz22C1xOF26Uquno=;
	b=Su/ruZKDBH6qOUgtRK7VMzA0doQ69nDg4ia4HrtwOy9RjqEcgSrbyiog5lEtJKdOk6FkSu6Hti7BC0TgFuw/KwwWSS8gxuT//kdJU6l5xqSsipIY1fZqWB8SJrunUR0BAKsgXcvf4BrafXUDqAQerY5/hV2sJRdWjbgP+EdKS6g=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.40,REQID:93b15845-c305-4093-bd20-0d04046b5818,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:ba885a6,CLOUDID:60f8e6d4-0d68-4615-a20f-01d7bd41f0bb,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: aa13452c391a11ef8b8f29950b90a568-20240703
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1013510887; Wed, 03 Jul 2024 17:00:15 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 3 Jul 2024 17:00:12 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 3 Jul 2024 17:00:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BwWOtyVp4nBfLnLiu1l793bKJUbr9EDU6SGuzow8eE6F1vVw3UVg9l4v66lAQllEOqH+N/jCGsFYn2aiduDPnsBKtGfhi5G2fYRx+SXhIqyTNCyM7+sIXOJqHHbiNXvj4gM8uBS8XAkA9+Dk+cYGNF2Wy7LJQ30mMkZuTQSE+mmsJ/Lzo7DVrAuRuYkEvRlMwiyzG9qmRR2zAwyPX4LM2rbJhoCXSFkDMxXymB3O7vfVs/HZ4HwyIARY2UWK8OLiFBRPCXmB8GMEm2XdYgj3/go4wqlT4/714kjNg4LfVYvFhPMi3b+9rSaV023wBYXOIgNfpFCrhJfg4tE5R96QlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=unpjoWEWHHzhKZ7oYefGNHmZLAlmz22C1xOF26Uquno=;
 b=CFF1x1y4hpm1l3p6DjDlLqag4jxg/FKjk68Glzx4UT++0pxUb2NNrQXn+j9O10MUaC8KYvPI9L7gppBXf9qANDZnGm6U6ZnboPqY5+o6OtiFrgVKwGNRmHvjiXlb/II91wi3rGQOTvkjokpiH2laRF8ixCOn0Lvq1qJ72TTzyk6qasdWHGV+t8iu+YumIoBQkK2mVAVDNscjVqblVZo0pxW7vReuLcPe90B7lN+sT4PBzB9JwBgYaIaCF4VMYnYXC8ZJJSqkUZ/zuP1ACLSIak29RBfECDoMMs/pA+FpPdXskbiVkqEERJjUJnr0BKcHafLQJaM9JwY9cWwFYoiMoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=unpjoWEWHHzhKZ7oYefGNHmZLAlmz22C1xOF26Uquno=;
 b=uhfqLRbhmznZtlG6uLiickNKdL3eCTxRm/wIvmxmZzXsnyEkPxGu9WQxtndpGtYNB/2ZOVCv84LZq3Z9nTNXG73uJlpy5+yEY9iQruqZB/FLnrKZ5LCG23uGuIATu1w/U9IjKW43MNRIbZVi3FSyVPOOp3+78Rc3ZSVEbsoWAOU=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB8515.apcprd03.prod.outlook.com (2603:1096:820:138::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.34; Wed, 3 Jul
 2024 09:00:10 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7719.029; Wed, 3 Jul 2024
 09:00:09 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "ahalaney@redhat.com" <ahalaney@redhat.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "akinobu.mita@gmail.com"
	<akinobu.mita@gmail.com>, "quic_mnaresh@quicinc.com"
	<quic_mnaresh@quicinc.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "cw9316.lee@samsung.com"
	<cw9316.lee@samsung.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "chu.stanley@gmail.com"
	<chu.stanley@gmail.com>, "minwoo.im@samsung.com" <minwoo.im@samsung.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "yang.lee@linux.alibaba.com"
	<yang.lee@linux.alibaba.com>
Subject: Re: [PATCH v4 9/9] scsi: ufs: Make .get_hba_mac() optional
Thread-Topic: [PATCH v4 9/9] scsi: ufs: Make .get_hba_mac() optional
Thread-Index: AQHazMBi/T5PtOnaMEi7+xyIYwePMLHktU6A
Date: Wed, 3 Jul 2024 09:00:09 +0000
Message-ID: <95776ab999dd08040a4aa8066d0309c1e232856b.camel@mediatek.com>
References: <20240702204020.2489324-1-bvanassche@acm.org>
	 <20240702204020.2489324-10-bvanassche@acm.org>
In-Reply-To: <20240702204020.2489324-10-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB8515:EE_
x-ms-office365-filtering-correlation-id: e85174ae-d69d-43f3-cd45-08dc9b3e8ad2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?eVRVOGtoTGhLYXRHdlIxOFRGRWtVK2JOb0ViTGdlNzc5Y2V6aGFXZFI1RktN?=
 =?utf-8?B?Tm5hZmpSdklkbkFNcVk4UVhXQkFxeGJ0Y2lQcjdBeXFnRElTelJ4anhLWEg4?=
 =?utf-8?B?UzVoUGJIU2drby9taUh3aHFoOFZ3UHVrZERBcUpqengwTWRBdkpXVStjSlZX?=
 =?utf-8?B?U2xmR3ZTNlh5ZnNNKzRXSkRmenRHMXM2Ujd6ZzlwTkJLb1pJK1dVZXZaSnVY?=
 =?utf-8?B?WWtaWk1aTFhqcFVSVnQvRHRZczlOeXlkcHZmYTRRcVZSNmZBNm9idjRMUlN2?=
 =?utf-8?B?bEpNNVhEemtBVW5pdVFNWEFjVjVLKzZyTmlUMmxVQzdYWTlJK1owSytFbThn?=
 =?utf-8?B?TFNjYWs3dm56Sk1XRXFpR3RLSHNwRXFNTHNQK0tqWnBUcnYxUitIZEFlcU5l?=
 =?utf-8?B?QnA4cG1Jd1VKSHU2RXVXSjRTYW80K2FRczNXeVVqSXlOak9nYTVCOStQaVNx?=
 =?utf-8?B?THB3c1g1QlZuRGdwY1R6U1J2dWtyR0JvSSt3UGdTbDB1UUVzczQxTW14NzYy?=
 =?utf-8?B?T09kV0hpUllJbjQyTDZBR3VVdUFRT0wvYkp1Znllalo0ZGtGM0dKUmNHYlQ4?=
 =?utf-8?B?OXFFV1BQbHZNajMxdjkvZktudDBBZGVrakVSVXlyUjBYeUVVVEJkR0pwTFpT?=
 =?utf-8?B?ejlrSUNMR1hHcEFtdmgvM3pkV3c3MDkxYmdNbnJGZUdWQ0dsSCt1TTA4empL?=
 =?utf-8?B?ZTFhbEsvamY3a3MxUjZZejFBQU42RC9oeDJJT01PWTFxMzJIbStaSzlGdUdQ?=
 =?utf-8?B?SUpBOUFEdTdqQ0FwT1F0SzZ0YThkOWJOMkQwVHVQd0lIeGtOWlJ3a0xwTGNF?=
 =?utf-8?B?ZHVkbkVOTjd6RVcybk9mNDhieU9qTC9QNVcxRWg2Vm5CbTgxYWhYMkFTS245?=
 =?utf-8?B?SGtiRXhnY21mOHZPRzNmdnJ1N2dLVytFM1pVb1FJaWNZZ2NhMDVXVXc4N0Nk?=
 =?utf-8?B?WWJrVGk3ZVFzM3NrOEdDczJHNEUxYXAycDVFZldWaDRaN1E2cGxNSHM3VzRD?=
 =?utf-8?B?YStEcUltQkxHRTFkbUhKZGJyTnFyUWNGL3BvNjlKemlhWFVCZ2dkQUtucDVR?=
 =?utf-8?B?OWtJam14MGt2NjZzLzRqZEF4VllweEtKaTdyTlN5Z1RvMktRQVNEb3ZORE8z?=
 =?utf-8?B?RGUyNEg1L3M5MW1lc3JJN1RYOXFDMjNyWVRlUjlvNE8yend3bm9iWXJVc1cw?=
 =?utf-8?B?VjBsaHdXMUIyN0I0UFA4azNYS05JbmJNSmNMWWw1SFNTVkZmOEpBVEk4WU0v?=
 =?utf-8?B?L2RzYjBMOGVOK3V5NDhFSi9KWWZHU21tMTdSM2pGK09VTk0yWTB3U3Qyc3px?=
 =?utf-8?B?OVBFQkxDbDdHWTdxc2Y0NjUrR0htU0tzQklWb1JVZnhsSXZVQ1VScm9KcXFH?=
 =?utf-8?B?dlZIeW04THBCNlI3NXhQcmdhVllsUjJkYkUrNkRmdVo2S212VytpT3hySndq?=
 =?utf-8?B?SFM2TkJTZSsyTFZXL0NvemI5SkNlamN0UGlUcFdqazNzUFhpTGpTZno4S2xk?=
 =?utf-8?B?T2s5aUpudGVIRDZ5dENiNm4yNFZIRC84NjZrQkVlY1BYMzNaSFhZYlBUc2dO?=
 =?utf-8?B?UkJHSTRVWDg5S3RwelUxZkh6dGFKMit6Y2JiQ2FLR1FxOURVSWI4VUg0b2J6?=
 =?utf-8?B?MDFuMzZkazBFSlFYNEk4Wk5vR3JVMk1VN2lCb244K2FnRVRPdDJGMGZQY2Vw?=
 =?utf-8?B?QmVlTWVjUkxwSzlDV2FrS2VxSFIxWURqUUJrOFpzNHlVRzNZcUs0RS82VW9M?=
 =?utf-8?B?bE5XSWxJNm0xcGhqSVBxeHJrM3crNGhFN1pDZEVxbW82Rk5ET1NhSFNGN1Q1?=
 =?utf-8?B?VEpFKzJMRGRlaWN1bUR4b1cxL083RmZxRmFQQ1RoN1J4Sm1nRDNpbWJ5VGJD?=
 =?utf-8?B?eTJaNkNKOXRIQVpJUE15RUQ5SXhjSWRnQmxGOElPdjlqd3c9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YW9NWEluRlZsUW1MZ28zYnBVdnlhbUswdTZ3c0Y2aXVrR0FBU0VCZW5Hb1BX?=
 =?utf-8?B?NjNOUFBrTmlleVR5YVhNRUUvNVN1bk51SDNJdXowUmR3TVc2TjNrMlZ5OC9i?=
 =?utf-8?B?TkpXSHVBUEVXMGVxR1JVbEF5UzJOdlRLZTFCNkZzMys4L01wT28xMXM4ZHU5?=
 =?utf-8?B?SUF4MndjMkltUDMzUXFzeXlFNmxPMFpGR1NUcWQxYklRQTFORmx4cGdCeVR4?=
 =?utf-8?B?WXRiQmZTc2hVQU9ERklmeCs5K3ZlQVBLYkJ3QzlJVElXeXQ2NTczZ295c2E0?=
 =?utf-8?B?WEloTS9wUFp4b3h2Uk1VU3dXOWYxNTJUL2d2R21PeVZ1SjV6NFZ1OUpOOXlF?=
 =?utf-8?B?MS80enNIMEIrZDlla3ZXbVZDSENPSUs5N0V1d1dzeG82MHA4aTkrOXozTzNs?=
 =?utf-8?B?V3laemxBWGovNGFKbnM5bUovUnhJVGloVGxFcnhsTklKNTRhVEdrc25QRS9D?=
 =?utf-8?B?TDQ3M08wOEYrT09Ca09NVnRyeXRMdm03RzRUdWxGdTBXQnBNRE9pS0RGQ2hW?=
 =?utf-8?B?Zm5pd3NtZjh1bExJTnFCYzlEWW5Kbm1ZbWtwVXJXNGo0eFpoMzhNQ1VGNzVZ?=
 =?utf-8?B?ekwvTG84WEM0VFMyYjA3M2Y5QUVQT2k1eUZpa3k3MDRmU0g2V3hmQXlYVVlP?=
 =?utf-8?B?TUFBV2J3OWlTdGwySlZzbkFRMlFNSlZRZFR6R0FVYlJzVTIyMzFXVkNwSGJx?=
 =?utf-8?B?NktJdm5vTzJPcUloNGZKT3JzSVB0Mk9ZNzEwWTBjR3ZER2tLeFBLeTdhMHdQ?=
 =?utf-8?B?Uy9mZklHc2F3ZzIwMDd0bi9HcEZDLy9FbzNrb0l3RjVGTXVTZEJJL2thNFBj?=
 =?utf-8?B?TFpNMW9mZUlwNGpmNjZMVWdEZnZmSXByM0hGcGsyZ04xdzk3QTBEV2FJU3dr?=
 =?utf-8?B?cGRjNnJXTE1TYTBGNDZBd0YwR3E3cmNibDVnQnlVbXcwbFZOcVBQUmlLaUY2?=
 =?utf-8?B?TFNqc0NTaURUUUtwS1hUZXU3NE9BM0xNZHVZSVppbVB6d0F5dmlDbzlPMUty?=
 =?utf-8?B?M3ZPc01NY0Q5RUtDS2RTUzA5elIwbXVIS0hyRFdpaTFNRkRLcStHeVZZRFRn?=
 =?utf-8?B?ZGpLOGhBZ1JuZkJMSDBQWVlxRVRQRGpDRmh2dHByOTBLWjJhd0dSa1hNTzJI?=
 =?utf-8?B?a2VjMWRRa1E5dnVMNEovOEl4dVNWRjhoWENTdHk1MXBkRUNvaG5FK05ZYnpE?=
 =?utf-8?B?RG1nd1dMQndLOFo4blZrR0JYeHgwOHU2UXljYjlRcE9Bd0FzaEpiV3lIQVF0?=
 =?utf-8?B?RS9mUE5VcE9kZll6MGJobzRrTEFHTUhiSDh6YUdsZVU2MFZ5bjh6K0lCd0dX?=
 =?utf-8?B?d1VFQ0hYNGg2VWUzTnFaU1A4M3RJaTdxQ3RpeXhLVG9UNHVibHJIN3RUcEVD?=
 =?utf-8?B?RDdYTWRPQU81ck1RWU9UNjYzVXhoL3dSZU1hNWh5VU16QTcvSUY3dG9ZZFZZ?=
 =?utf-8?B?UU1yN0hSR2EwcU1KSTgrdURlTHB4eWJ4MFM5WXVTcm1rU3pjS2FOdFZZS3NZ?=
 =?utf-8?B?MUtLVUJMdzNpekkvbE9yQUY0Q1ZJUWsrT051ZE1ORUhvcHduWkR6dmpyMHhN?=
 =?utf-8?B?TmVVaml6WEdjOGREUDArNVYvdEkxcVZ0dUpGdkxkWWZkbjFkQSs2YmNEakZq?=
 =?utf-8?B?YmY5ekhDVnlMdVIzMVU2VVdHeUZxS1lBaGJjeEtWeDNjQjFldVc5QUg2NGRP?=
 =?utf-8?B?UWxHeEtVanlESkpJWWNvN1ZZeER5RXdZc0x5QmlLVjBYY2JGbUt3U1Uyak5Q?=
 =?utf-8?B?VndGVW1BeC9nMUhTYmtLYnlvSGZOYitpdnk4MjFXV3p6V2s2TFdnQUpYL2ox?=
 =?utf-8?B?bDZUa2FUQmE4aEFJOEFtK2tsRkpNTndqUzRxaXA5NmY5bUI1QmJ6eklldzVn?=
 =?utf-8?B?M2RoanhLQ05qQUl3YXV4cWVIOE80UnU5VzhGbmI5LzFzWUdMdloybjhIcHBT?=
 =?utf-8?B?MFlhSnp1MGJMN3BmSUJodVM4elpPT2hSR0ZhYnMzSUdva2xueVNmZ1NnZnor?=
 =?utf-8?B?bXZBVlZmTEFVa2JnTWRGNjY4Znh4YmorcTVmeCtyYVFnT1N6WkpXbzEzWUZ2?=
 =?utf-8?B?YnRJemwzbmVjRmxPM1RjR2g2c2Z5ME9wcUhadlZndExiUjRrcER2RWhlUlYw?=
 =?utf-8?B?NW9zaWVtK3lJV1c4Njh5S1FiT1ArYzdpaVlucC9oRWZqVFpuSE1RQVJFYkFV?=
 =?utf-8?B?WUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6C5CB412C2779540909F7AFFA49D97EE@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e85174ae-d69d-43f3-cd45-08dc9b3e8ad2
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2024 09:00:09.8975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S1D2blnleOegCdEEW9GJLW3xqRS1O6A9cIVwbYAbpqBeGa7cqmrr4W3TzjYnCZQ5qiPuSTgcd4wvmk7xQOIA7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB8515
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--25.024400-8.000000
X-TMASE-MatchedRID: MDgwTWowY3bUL3YCMmnG4nbspjK6JP6qvWY9kbV8t/eNxnMeHrmB78kU
	hKWc+gwPyGJ1SiZNgOOsXAiB6VK48AbbLE2rYg/9wvqOGBrge3shmbYg1ZcOnqLBzDj4yu3DpUG
	sd8ntFkX0EtpIOEi1wcDme2I4je5WdWSASb0lZx0flhDI6DvVlkyQ5fRSh2656T1ArrMwNVqVi6
	IEPauVN0zNvhw8ch4YY4MrAoaEpLyjbvGIi5SCUO7KTDtx8CggXxT5cg8K/tccvwPYmXKyHwVSL
	5IzSUR/NWlqv3euRjW0dpwqyqI7YY9Tk4aumaeg4pdq9sdj8LX/lBG+uXYJkE8vg1FXaj1o+a/z
	dHOJ3WnjO120vk0r7TlTig+kPyJVWGr8HRlnIni20BbG4zmyXkeeKTVwRgrpFp7kniXxovMFduZ
	ip5XD7HnkytQFH7SyG+Yd2AhjmEyXBXaJoB9JZ9IFVVzYGjNKWQy9YC5qGvz6APa9i04WGCq2rl
	3dzGQ1A/3R8k/14e0=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--25.024400-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	96211EA3E3627EA9BDFD5F55F9761109B9FC47AA6DE4CF8CB3E201678574DA842000:8
X-MTK: N

T24gVHVlLCAyMDI0LTA3LTAyIGF0IDEzOjM5IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgVUZTSENJIGNvbnRyb2xsZXJzIHRoYXQgYXJlIGNvbXBsaWFudCB3
aXRoIHRoZSBVRlNIQ0kgNC4wIHN0YW5kYXJkDQo+IHJlcG9ydA0KPiB0aGUgbWF4aW11bSBudW1i
ZXIgb2Ygc3VwcG9ydGVkIGNvbW1hbmRzIGluIHRoZSBjb250cm9sbGVyDQo+IGNhcGFiaWxpdGll
cw0KPiByZWdpc3Rlci4gVXNlIHRoYXQgdmFsdWUgaWYgLmdldF9oYmFfbWFjID09IE5VTEwuDQo+
IA0KPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4N
Cj4gLS0tDQo+ICBkcml2ZXJzL3Vmcy9jb3JlL3Vmcy1tY3EuYyAgICAgfCAyMCArKysrKysrKysr
KysrKy0tLS0tLQ0KPiAgZHJpdmVycy91ZnMvY29yZS91ZnNoY2QtcHJpdi5oIHwgIDEgKw0KPiAg
ZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyAgICAgIHwgIDYgKysrKy0tDQo+ICBpbmNsdWRlL3Vm
cy91ZnNoY2QuaCAgICAgICAgICAgfCAgNCArKystDQo+ICBpbmNsdWRlL3Vmcy91ZnNoY2kuaCAg
ICAgICAgICAgfCAgMSArDQo+ICA1IGZpbGVzIGNoYW5nZWQsIDIzIGluc2VydGlvbnMoKyksIDkg
ZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91ZnMtbWNx
LmMgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmcy1tY3EuYw0KPiBpbmRleCAwNDgyYzdhMWU0MTkuLmIy
Y2YzNGExZmU0OCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy91ZnMvY29yZS91ZnMtbWNxLmMNCj4g
KysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnMtbWNxLmMNCj4gQEAgLTEzOCwxOCArMTM4LDIxIEBA
IEVYUE9SVF9TWU1CT0xfR1BMKHVmc2hjZF9tY3FfcXVldWVfY2ZnX2FkZHIpOw0KPiAgICoNCj4g
ICAqIE1BQyAtIE1heC4gQWN0aXZlIENvbW1hbmQgb2YgdGhlIEhvc3QgQ29udHJvbGxlciAoSEMp
DQo+ICAgKiBIQyB3b3VsZG4ndCBzZW5kIG1vcmUgdGhhbiB0aGlzIGNvbW1hbmRzIHRvIHRoZSBk
ZXZpY2UuDQo+IC0gKiBJdCBpcyBtYW5kYXRvcnkgdG8gaW1wbGVtZW50IGdldF9oYmFfbWFjKCkg
dG8gZW5hYmxlIE1DUSBtb2RlLg0KPiAgICogQ2FsY3VsYXRlcyBhbmQgYWRqdXN0cyB0aGUgcXVl
dWUgZGVwdGggYmFzZWQgb24gdGhlIGRlcHRoDQo+ICAgKiBzdXBwb3J0ZWQgYnkgdGhlIEhDIGFu
ZCB1ZnMgZGV2aWNlLg0KPiAgICovDQo+ICBpbnQgdWZzaGNkX21jcV9kZWNpZGVfcXVldWVfZGVw
dGgoc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gIHsNCj4gLQlpbnQgbWFjID0gLUVPUE5PVFNVUFA7
DQo+ICsJaW50IG1hYzsNCj4gIA0KPiAtCWlmICghaGJhLT52b3BzIHx8ICFoYmEtPnZvcHMtPmdl
dF9oYmFfbWFjKQ0KPiAtCQlnb3RvIGVycjsNCj4gLQ0KPiAtCW1hYyA9IGhiYS0+dm9wcy0+Z2V0
X2hiYV9tYWMoaGJhKTsNCj4gKwlpZiAoIWhiYS0+dm9wcyB8fCAhaGJhLT52b3BzLT5nZXRfaGJh
X21hYykgew0KPiArCQloYmEtPmNhcGFiaWxpdGllcyA9DQo+ICsJCQl1ZnNoY2RfcmVhZGwoaGJh
LCBSRUdfQ09OVFJPTExFUl9DQVBBQklMSVRJRVMpOw0KPiArCQltYWMgPSBoYmEtPmNhcGFiaWxp
dGllcyAmDQo+IE1BU0tfVFJBTlNGRVJfUkVRVUVTVFNfU0xPVFNfTUNROw0KPiArCQltYWMrKzsN
Cj4gKwl9IGVsc2Ugew0KPiArCQltYWMgPSBoYmEtPnZvcHMtPmdldF9oYmFfbWFjKGhiYSk7DQo+
ICsJfQ0KPiAgCWlmIChtYWMgPCAwKQ0KPiAgCQlnb3RvIGVycjsNCj4gIA0KPiBAQCAtNDIzLDYg
KzQyNiwxMSBAQCB2b2lkIHVmc2hjZF9tY3FfZW5hYmxlKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+
ICB9DQo+ICBFWFBPUlRfU1lNQk9MX0dQTCh1ZnNoY2RfbWNxX2VuYWJsZSk7DQo+ICANCj4gK3Zv
aWQgdWZzaGNkX21jcV9kaXNhYmxlKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+ICt7DQo+ICsJdWZz
aGNkX3Jtd2woaGJhLCBNQ1FfTU9ERV9TRUxFQ1QsIDAsIFJFR19VRlNfTUVNX0NGRyk7DQo+ICt9
DQo+ICsNCj4gIHZvaWQgdWZzaGNkX21jcV9jb25maWdfZXNpKHN0cnVjdCB1ZnNfaGJhICpoYmEs
IHN0cnVjdCBtc2lfbXNnICptc2cpDQo+ICB7DQo+ICAJdWZzaGNkX3dyaXRlbChoYmEsIG1zZy0+
YWRkcmVzc19sbywgUkVHX1VGU19FU0lMQkEpOw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMv
Y29yZS91ZnNoY2QtcHJpdi5oDQo+IGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QtcHJpdi5oDQo+
IGluZGV4IDg4Y2U5Mzc0ODMwNS4uY2UzNjE1NGNlOTYzIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJz
L3Vmcy9jb3JlL3Vmc2hjZC1wcml2LmgNCj4gKysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2Qt
cHJpdi5oDQo+IEBAIC02NCw2ICs2NCw3IEBAIHZvaWQgdWZzaGNkX2F1dG9faGliZXJuOF91cGRh
dGUoc3RydWN0IHVmc19oYmENCj4gKmhiYSwgdTMyIGFoaXQpOw0KPiAgdm9pZCB1ZnNoY2RfY29t
cGxfb25lX2NxZShzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBpbnQgdGFza190YWcsDQo+ICAJCQkgIHN0
cnVjdCBjcV9lbnRyeSAqY3FlKTsNCj4gIGludCB1ZnNoY2RfbWNxX2luaXQoc3RydWN0IHVmc19o
YmEgKmhiYSk7DQo+ICt2b2lkIHVmc2hjZF9tY3FfZGlzYWJsZShzdHJ1Y3QgdWZzX2hiYSAqaGJh
KTsNCj4gIGludCB1ZnNoY2RfbWNxX2RlY2lkZV9xdWV1ZV9kZXB0aChzdHJ1Y3QgdWZzX2hiYSAq
aGJhKTsNCj4gIGludCB1ZnNoY2RfbWNxX21lbW9yeV9hbGxvYyhzdHJ1Y3QgdWZzX2hiYSAqaGJh
KTsNCj4gIHN0cnVjdCB1ZnNfaHdfcXVldWUgKnVmc2hjZF9tY3FfcmVxX3RvX2h3cShzdHJ1Y3Qg
dWZzX2hiYSAqaGJhLA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyBi
L2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gaW5kZXggYjM0NDRmOWNlMTMwLi45ZTAyOTBj
NmMyZDMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gKysrIGIv
ZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiBAQCAtODc1MywxMyArODc1MywxNSBAQCBzdGF0
aWMgaW50IHVmc2hjZF9kZXZpY2VfaW5pdChzdHJ1Y3QgdWZzX2hiYQ0KPiAqaGJhLCBib29sIGlu
aXRfZGV2X3BhcmFtcykNCj4gIAkJaWYgKHJldCkNCj4gIAkJCXJldHVybiByZXQ7DQo+ICAJCWlm
IChpc19tY3Ffc3VwcG9ydGVkKGhiYSkgJiYgIWhiYS0+c2NzaV9ob3N0X2FkZGVkKSB7DQo+ICsJ
CQl1ZnNoY2RfbWNxX2VuYWJsZShoYmEpOw0KPiArCQkJaGJhLT5tY3FfZW5hYmxlZCA9IHRydWU7
DQo+ICAJCQlyZXQgPSB1ZnNoY2RfYWxsb2NfbWNxKGhiYSk7DQo+ICAJCQlpZiAoIXJldCkgew0K
PiAgCQkJCXVmc2hjZF9jb25maWdfbWNxKGhiYSk7DQo+IC0JCQkJdWZzaGNkX21jcV9lbmFibGUo
aGJhKTsNCj4gLQkJCQloYmEtPm1jcV9lbmFibGVkID0gdHJ1ZTsNCj4gIAkJCX0gZWxzZSB7DQo+
ICAJCQkJLyogQ29udGludWUgd2l0aCBTREIgbW9kZSAqLw0KPiArCQkJCXVmc2hjZF9tY3FfZGlz
YWJsZShoYmEpOw0KPiArCQkJCWhiYS0+bWNxX2VuYWJsZWQgPSBmYWxzZTsNCj4gIAkJCQl1c2Vf
bWNxX21vZGUgPSBmYWxzZTsNCj4gIAkJCQlkZXZfZXJyKGhiYS0+ZGV2LCAiTUNRIG1vZGUgaXMN
Cj4gZGlzYWJsZWQsIGVycj0lZFxuIiwNCj4gIAkJCQkJIHJldCk7DQo+IGRpZmYgLS1naXQgYS9p
bmNsdWRlL3Vmcy91ZnNoY2QuaCBiL2luY2x1ZGUvdWZzL3Vmc2hjZC5oDQo+IGluZGV4IGMwZTI4
YTUxMmIzYy4uNjUxODk5NzkzMGYzIDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL3Vmcy91ZnNoY2Qu
aA0KPiArKysgYi9pbmNsdWRlL3Vmcy91ZnNoY2QuaA0KPiBAQCAtMzI1LDcgKzMyNSw5IEBAIHN0
cnVjdCB1ZnNfcHdyX21vZGVfaW5mbyB7DQo+ICAgKiBAZXZlbnRfbm90aWZ5OiBjYWxsZWQgdG8g
bm90aWZ5IGltcG9ydGFudCBldmVudHMNCj4gICAqIEByZWluaXRfbm90aWZ5OiBjYWxsZWQgdG8g
bm90aWZ5IHJlaW5pdCBvZiBVRlNIQ0QgZHVyaW5nIG1heCBnZWFyDQo+IHN3aXRjaA0KPiAgICog
QG1jcV9jb25maWdfcmVzb3VyY2U6IGNhbGxlZCB0byBjb25maWd1cmUgTUNRIHBsYXRmb3JtIHJl
c291cmNlcw0KPiAtICogQGdldF9oYmFfbWFjOiBjYWxsZWQgdG8gZ2V0IHZlbmRvciBzcGVjaWZp
YyBtYWMgdmFsdWUsIG1hbmRhdG9yeQ0KPiBmb3IgbWNxIG1vZGUNCj4gKyAqIEBnZXRfaGJhX21h
YzogcmVwb3J0cyBtYXhpbXVtIG51bWJlciBvZiBvdXRzdGFuZGluZyBjb21tYW5kcw0KPiBzdXBw
b3J0ZWQgYnkNCj4gKyAqCXRoZSBjb250cm9sbGVyLiBTaG91bGQgYmUgaW1wbGVtZW50ZWQgZm9y
IFVGU0hDSSA0LjAgb3IgbGF0ZXINCj4gKyAqCWNvbnRyb2xsZXJzIHRoYXQgYXJlIG5vdCBjb21w
bGlhbnQgd2l0aCB0aGUgVUZTSENJIDQuMA0KPiBzcGVjaWZpY2F0aW9uLg0KPiAgICogQG9wX3J1
bnRpbWVfY29uZmlnOiBjYWxsZWQgdG8gY29uZmlnIE9wZXJhdGlvbiBhbmQgcnVudGltZSByZWdz
DQo+IFBvaW50ZXJzDQo+ICAgKiBAZ2V0X291dHN0YW5kaW5nX2NxczogY2FsbGVkIHRvIGdldCBv
dXRzdGFuZGluZyBjb21wbGV0aW9uIHF1ZXVlcw0KPiAgICogQGNvbmZpZ19lc2k6IGNhbGxlZCB0
byBjb25maWcgRXZlbnQgU3BlY2lmaWMgSW50ZXJydXB0DQo+IGRpZmYgLS1naXQgYS9pbmNsdWRl
L3Vmcy91ZnNoY2kuaCBiL2luY2x1ZGUvdWZzL3Vmc2hjaS5oDQo+IGluZGV4IDhkMGNjNzM1Mzdj
Ni4uMzhmZTk3OTcxYTY1IDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL3Vmcy91ZnNoY2kuaA0KPiAr
KysgYi9pbmNsdWRlL3Vmcy91ZnNoY2kuaA0KPiBAQCAtNjgsNiArNjgsNyBAQCBlbnVtIHsNCj4g
IC8qIENvbnRyb2xsZXIgY2FwYWJpbGl0eSBtYXNrcyAqLw0KPiAgZW51bSB7DQo+ICAJTUFTS19U
UkFOU0ZFUl9SRVFVRVNUU19TTE9UU19TREIJPSAweDAwMDAwMDFGLA0KPiArCU1BU0tfVFJBTlNG
RVJfUkVRVUVTVFNfU0xPVFNfTUNRCT0gMHgwMDAwMDBGRiwNCj4gIAlNQVNLX05VTUJFUl9PVVRT
VEFORElOR19SVFQJCT0gMHgwMDAwRkYwMCwNCj4gIAlNQVNLX1RBU0tfTUFOQUdFTUVOVF9SRVFV
RVNUX1NMT1RTCT0gMHgwMDA3MDAwMCwNCj4gIAlNQVNLX0VIU0xVVFJEX1NVUFBPUlRFRAkJCT0g
MHgwMDQwMDAwMCwNCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0
ZWsuY29tPg0KDQo=
