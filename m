Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C16413B5B4
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jul 2024 09:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719997206; cv=fail; b=ApY/RRHJ9SdyKAia+ChlmrHK0dT0BLUaBiHOpIyfhYZAOzsRr3lX2laJ6gG5tC5Z2855NvQjnefg+LNeb5XjG2+EODzthEvmbppnZe1iYc6z1/GlBd6Bp6IAY2MeNFs5VaXjCFxNy8zk3nDmZ8FwN4T5Gm6aV78D2n+Xy+kpylY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719997206; c=relaxed/simple;
	bh=aWFvO7Ybz+az3S3w58NlMf4kpCJqjAdDj+4ULmcykLg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=s+bV9gUj7X+uEh+3dkqMKwDgYQRRweg1swG5CvOJQDz12kBRnll6zBYrE0xqaWGhAQ+FW5uCd2oy9nE9sB025gvpqBOhJupK5H+dEEtmHutYcDGh8rxjWln4ljVh4qQgVBqOz7h8GLh5SLaqoKGW2pFkOMB7/UxslbD/RXzJn/U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ScVfviAY; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=jtLdJ3lp; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ScVfviAY";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="jtLdJ3lp"
X-UUID: 9ab8c534391a11ef8b8f29950b90a568-20240703
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=aWFvO7Ybz+az3S3w58NlMf4kpCJqjAdDj+4ULmcykLg=;
	b=ScVfviAYYE6a7QiBorv7TxSD8S5gTApyfJ+GK2C5CqqwKtnvVnCU3BUXHUUo/uzoyAcEVBGf6U7pOMEMaB74cp1f0ci7opnOMbUnCMH/sRwRq54y0QeXuSqBhyde1DEG4NZg/M6e+1OOnxOMdSIKAkAnb5IWdOFVNdkgaQ5dKLM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.40,REQID:22565000-deb8-4e84-8eb9-820c1a45ab72,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:ba885a6,CLOUDID:38f6e6d4-0d68-4615-a20f-01d7bd41f0bb,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 9ab8c534391a11ef8b8f29950b90a568-20240703
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 242659049; Wed, 03 Jul 2024 16:59:49 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 3 Jul 2024 16:59:47 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 3 Jul 2024 16:59:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XCN74jreoddBHjEY09bmMLwVxd4SPeVKJ9aRqm2kN7ZsheTGdO3//h+3mIfo2apCffOhiugtalxuU5Bm50xpwfUTUyMe98OAznrOGQWxOpPownJpGeXpj48uh88xfk/BIK7tkyaHLEoQ3X8BwLtoC/g7UX2nHXkG8RD/SJWDjqRYvV8ibO6dqQUWUucW2XdQWACjED/RVHe1N0MKSAIdmzowqAS3V+ICbMqQ4Zv5YpK7QAGmGusn74pEt58e1BBQxP5S0QLalLLRqCXBYspE0YoSiv0JNv/E/46fuU7wkF6G8bwqPPrSsMnSObkmy7+8VlYSONXuD2Z5vMaI+Xc6Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aWFvO7Ybz+az3S3w58NlMf4kpCJqjAdDj+4ULmcykLg=;
 b=BrkIbSo8e3111J+zno2TMgNLRx3WrPVK/advP6nzjh9aQMGNo/6vpDDY2HmN2jid+c8wCt0mSFsk8c7EvCrLb6SxyB8/BfiS1gWkM3Gp3mfZjY/hAEmcUzIuvNtQNL1FciQaXIFrmN5fLEPit+uxO15d+kBbxhRC0UlRpO+p2BowDR3kweL+6hF+H79FzuHPyjhlGn++1+o3mG9lKoCBExayMt7yhKSj5eMx8duOsiVEdOqLdS98KDXd49XfseDyr0Pm5auvD9DNHRncXf8X0bB+EqWWp4T08pciscjMKSidZb3P1gBDqiHzx4MTEiWKCHLwjMS3N1llGbF+gCglkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWFvO7Ybz+az3S3w58NlMf4kpCJqjAdDj+4ULmcykLg=;
 b=jtLdJ3lpaimqIYWNxsNgb0f2LGTcDgSTaWACnKQ2//rb3HDRNH3tTFFSPx/7olYj5UHr9HxSm3nV2J+8Px0lNcE0hDkmt7Ix1obADSTMPVcpY0lWyWw9xw8aPste6zm69vdNyeKA46kjgL+d3ZuLGi1dSOiHnbgH/Lee2KBzj50=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB8515.apcprd03.prod.outlook.com (2603:1096:820:138::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.34; Wed, 3 Jul
 2024 08:59:45 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7719.029; Wed, 3 Jul 2024
 08:59:45 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "ahalaney@redhat.com" <ahalaney@redhat.com>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>
Subject: Re: [PATCH v4 7/9] scsi: ufs: Move the ufshcd_mcq_enable() call
Thread-Topic: [PATCH v4 7/9] scsi: ufs: Move the ufshcd_mcq_enable() call
Thread-Index: AQHazMBLSd/yQlC1ukeIJHQaVz0s17HktTEA
Date: Wed, 3 Jul 2024 08:59:45 +0000
Message-ID: <718fe2c3cac9d7298f56de351494e64ac60b8871.camel@mediatek.com>
References: <20240702204020.2489324-1-bvanassche@acm.org>
	 <20240702204020.2489324-8-bvanassche@acm.org>
In-Reply-To: <20240702204020.2489324-8-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB8515:EE_
x-ms-office365-filtering-correlation-id: fb311e46-4df1-4b36-b9a7-08dc9b3e7c4d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RFN5MEs5bEROdWJVNEtsYVBpbW1lWHNDTlFuUHEvM045Z2dRcEpyK0ZHVDlZ?=
 =?utf-8?B?cE1oeTg2VysvZDc5djdudzh3eXhQd3NVbXlBMGNncUd4Tk10Ny9Cc2VOM0hq?=
 =?utf-8?B?eGhzTUdDN1l0Tm95MXRWVnZ4RnhRSHdXS21xQkQ5aWVSMS9pbFNqWlRldEhR?=
 =?utf-8?B?QlEvUm1RTXNYb01aK0ZGMXZNRnE4Ny9KUWJtdS9PNWh1K2ZmV1F4T3piMkMw?=
 =?utf-8?B?OElhaXEwZjJaTG96ejJLVFhKSTZKdFphdmVqV3hLV3hDMSsxb2NqN05ubUxM?=
 =?utf-8?B?T0RKM082Rk50emhtWjdxdThMQ1BLRnFwdmdoRFViL1BCUHowdzBJZVRBOVk1?=
 =?utf-8?B?KzBNTTh4S1pTUFdCNEVmUEdRNUhEMGtudWJoWmJhQWE4YkUwbWxKOGpXSWU5?=
 =?utf-8?B?YjIzY1p5TGl1UjA5SFhJSHhpSkd1ZDVwNENrVHJ3Z2htaW56RVc2ZC9jbVFm?=
 =?utf-8?B?M04rVzVRK0pva1JyZHZBQWZ4QjFGK3NUQS9Bem9zeHlLcFdncXJGd2lPM0c3?=
 =?utf-8?B?blRYaEtERG1SRGxZNEc2aEo0aENEZ3JxOVpKNkMxc3BuSmtuTHRiN1Zucysx?=
 =?utf-8?B?Tms5dFNqSHQwcnFvaWFKMHhwQ01Odm1vdkg4N3pZaEVWcldzemdJMFE3VEhM?=
 =?utf-8?B?OVJuZXEvdkkxcHcyN2tXV2FrY1dHN29lbHR6RXV6R2huWXhnQVF3UUdrc2g2?=
 =?utf-8?B?QnpJM3BnOEI4Y2JNdVMrdnJPSEN4ZFA3WXhpKzhhMU90OGlTMkp1VWdhQXlH?=
 =?utf-8?B?SXhHSnU0SkltN1hzdVZRMURvRkltTDl3NG5vNlNmakxOdVVKT3VjS1lBQzQ3?=
 =?utf-8?B?VzlBaFl6UlNkcG1qTkR3eWZPQXgxV2NFLzM5QTZVU0h1NDJwUUFPYjFuQVd2?=
 =?utf-8?B?TUhES0NmUmtMR01qN1JFdFhFNzlVdGNsK1hXRk56N3ZkOFVLT3hUdTVaRFg0?=
 =?utf-8?B?OWlGNGtqV2QzQWl0NTFpWTZhc1pFZXRFVFRCVEpIUTRUeGZtY2UrVEMwMWxW?=
 =?utf-8?B?ZmNIRDNtRWJ4KzBYZm9oemV3aXRCTVd3THg5cmszKzN2eXJHRzBEdzBDdTUx?=
 =?utf-8?B?T0FLYlRxcEU1QmVHb253dFR6QXZSSnNXdFlKYmlQM1o0cW9YQTNZTW1PWEpP?=
 =?utf-8?B?L2JueVlKdEtBc3lsTnpRdUovS1dmUkt4bnM2Q0I0MERxdHZTUUJnUll4SlNv?=
 =?utf-8?B?Q2lpWFZGdUg5R0RHVSt0UTA2amY2MU95MHN0d21UUGUxaFNxM2lBM0RjYm5i?=
 =?utf-8?B?cEVPMU9DaDA2NkpRSVhOeWZtNlBZTFRIYjYzb3RwOUlZYnhxL1FkcXFoQTll?=
 =?utf-8?B?U3RQaWZCSTFvb3FqaVBoWkFrdmVYRUkyZXFhQkljYkRxSlg1ek5ZNGQ5Mito?=
 =?utf-8?B?Q1dpdHYrbkZtL0paYis4L0ZxMGZtd2JFY2ljWWZDWDZnZjljRkw0enoyU0Js?=
 =?utf-8?B?V091T3lQeWhHL04zbW1OWm05UTVLYUZvY0pEQVROQlBmdUliaUZSSGl0NUVl?=
 =?utf-8?B?L1RBakNmUjNtOXdodjVId2Z5em1JQWlHSGVnOGhUaktyNXF6eVBpVTFqTExY?=
 =?utf-8?B?Ky9aSk9CSEp2NDZvOTZZUXNxSnlrQkVhVTJ6aU83NFpGRjIyclhHdFg2Z29m?=
 =?utf-8?B?bEJQRWpuMUhYMXE1TWxwYWlWUXJZa2JiY2xYRklsL1VodjYzZ0NwQitSRFdY?=
 =?utf-8?B?UGZFS2tCQ0VERDl5SjNNVFNWak9JcHl2dDZmbnBRcFByTk9pUTJ4clBFUWU2?=
 =?utf-8?B?UDJPUE1hZTJmbDREQmJqc0xRUjZTb0RwSEkyMzl3bW14RFhId3pHYVEvT3U4?=
 =?utf-8?B?RllNSnZ6Yk9FZ3FtNSs4VVliTlNtdzNZMDFvVVhpc2lYNE04aVZkSmU3ZW1L?=
 =?utf-8?B?aGxETGFkaWhZK2ZIbGxYdURvbnF1Q1A3VnZhWmU0Q2dRcXc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YWtVVlNjV0RzNkNNdXNhQmdkemM4ZFd2T1NNckplK0NyQnFsdnRXcEo2b0Uw?=
 =?utf-8?B?N0ZQdmh0bStXN3grdnp4Q1hJSVRaWThrR0ZlTGFFQ0x0TElsK3Z3ektFRDNJ?=
 =?utf-8?B?Yk1FNTRIMDRlU3Eyd3hNalFuaGlobENkeHVycitDbVFxZzN1WmVWZURPa0E5?=
 =?utf-8?B?a0h1eGY0ajU1TWo5TnJURTdPWHJNUHF2dW5pRGhoVGJ2a2Q4WkUzOG1XT1BP?=
 =?utf-8?B?TjBYakxtN3YvM3piM3B5eXVlU0pMRjMxRi9GTzRUdmtrd3dGcEZtTHAyOXJu?=
 =?utf-8?B?TnIzSkp3WldVWHhGWTh4d1VCdkREZ2FJeW9YL1IydFBtTWRPRXFSb0R2TEVa?=
 =?utf-8?B?cFBTdWt4Y0NrVGNKVUJsL1lUQ25wUENPQWl6M1dOM0pFcE1wWjZWSXBBM1k0?=
 =?utf-8?B?d3J1ZVhvVFZLVE1lWHZUaFlwU0NTTThSMy9Jam01Vzd1UlNLMzhwbFQxVkJa?=
 =?utf-8?B?czl6K0d2bjNlc1RxU2ZQb2pzengvQUZvTU9CNGtNNDZxVUY4cmR1cmFHcmdo?=
 =?utf-8?B?NUVLS1NuVFl1eHBsZllQaEZuT2hZdC9wRmpzY0RObkVLcmVPcVBkMzcvVnBX?=
 =?utf-8?B?Nk5sbHNHUHRqSnV1QVZOS01jbVZndEU5d01xMGhSZVkzMm43N2lGbjUrcnB4?=
 =?utf-8?B?RHpZQ0ZUa0lDZVY5cGhTM1owaFlxTE53WW0zd2lKeTQ4bFE5VGlmRW9Wclpo?=
 =?utf-8?B?QjdoMW9EWG9XazlmSFRKMy80VU1PbFhHUFdMNGJrdlVxRzI1aWlvZ2czQldK?=
 =?utf-8?B?eEtNeGRUYzNLOVE3b1lRTzErV3pKYk14cGpGb2toUEJoeCtuY082VnZOdEhR?=
 =?utf-8?B?Z1ZlWlF2QVhlMDhtK280aTRYaHUwRWVVQ0pKZzUzeVVIRFMrdnlmK0JueW9m?=
 =?utf-8?B?TFhpdmtxU0lxOWUrN3p1ZVlKbDhIcEQ1TDBiekg0TjJYUEV1d01ZRWZ1a21T?=
 =?utf-8?B?bVFoNCtRaGpkT3kxMWgrOHpXZEtLT0VCRHZaQ01ZRmZlMHdDd2pHQ1M1dzRq?=
 =?utf-8?B?WVFEMmhBaUFXbzk0NFB4YThDNEJmR3B4c05oQWZsOWV6YjNzUHRpdkZ2dmlj?=
 =?utf-8?B?elB1bFlTOUorRFRvcmgvRmhPSEpvWHcwU1ZGb2t0dHJoU3UydTM4eTVJRjNT?=
 =?utf-8?B?L3V4ZVNOVjhqM04vSVFKTGtIRVM3VWptRlNnMkZHd0RMZ29pQThJT0pIbG5K?=
 =?utf-8?B?cDBuZGdBdVVNR1FoRlh4bVpPTiszMEc4bnJ0R2Y2RmhTZmcrWmtsZWw0R1ln?=
 =?utf-8?B?N0tZQzZScDNuQnZyYnJZSTJScDJHaUZmaHp0WjRXSGpueDMyeXFwY2YrVlhK?=
 =?utf-8?B?bG1UZTVkMmFGWjhaUVZ2cEI1Zmk5NHpocFpXODIzYTVadERlaTFqaVlnYzNp?=
 =?utf-8?B?UERqWlE4cGZ3RTRyY3ZWRGtEM3g1R2tGWGRrRUNuMkdtTUE3RFY2Q3Z0WjdI?=
 =?utf-8?B?VThiWkJ1UDExYnpSMWQrVU53WHdkWmRXd01qK2hsN2VTV3gzUlhzSkRaN3c1?=
 =?utf-8?B?dUlUeGRxU3RMeTNoZUtRaU41QkQ5azlSZ2NnZ2NoRlNML2U4RnAzUHBtTTdu?=
 =?utf-8?B?VjFYdURLOTBuUHQ2cWRuU1hiZXlDOHVEMmpPODc0VDh6TkdzanpPQ3oxRSt4?=
 =?utf-8?B?RHB1MldDd3V4cU05OEhLK21HbzhJR1Y4R1JPNDF1YkR4cEJGTFpvd3o5Q2ph?=
 =?utf-8?B?WnhsU05hd3E5dk9HU1FnREtvSHNNY3FZTDhmUFRlL2hWNXNhUDVmcndGVEFm?=
 =?utf-8?B?U1gydHBsaEI3U2I5Vk45UVgyRndOM2NrNW1xT3laelNua1IreFVxS2t1bDY0?=
 =?utf-8?B?ek9ZMnNQOEM2bnFNbnFzdC9xMmFvL29aSkxjVm94QjhNNnAwaWl3eUNkakRS?=
 =?utf-8?B?MTRhUm02NE1QM3JLVHlQdTM4bGxjT2NYdUozV2xJOU45bXkxTUttVVd6RWNC?=
 =?utf-8?B?d3BQUjlmZTBKK3NDU0J3bTBoZmxZQkxsMXlqbnBDcGtYY2NKSDVuM2ZyZnhv?=
 =?utf-8?B?VGliQVQweU1yTFZubVpHRk10Z1BraFRuVDhLN1hYN3c1YVJzZEw1aDcxNmJW?=
 =?utf-8?B?RkI1aUR3UUdqZzB1NHQ4UzBYL0RmS1dPenRYMnNWVitPY1BsbXp5aERVZHZQ?=
 =?utf-8?B?czN2VU1ITmQzOWlCbTloMWRYLy8yREtERHdGTUx6VXpHY2hIY3BHV3JFNzJs?=
 =?utf-8?B?UWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AA0EDF637D37674195F273D8C4AA536D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb311e46-4df1-4b36-b9a7-08dc9b3e7c4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2024 08:59:45.5490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cVtv296lIzFCicET4iiXnZS4FRsEhHeUCyWvaThcPvs3d3NMuDtk8i1TCLjwPQY3iYWFktfhAnh2qwi5XpM7Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB8515
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--14.816100-8.000000
X-TMASE-MatchedRID: dc8Jy61QoRrUL3YCMmnG4omfV7NNMGm+1GdxOr7L6H2NxnMeHrmB78kU
	hKWc+gwPyGJ1SiZNgOOsXAiB6VK48AbbLE2rYg/9wvqOGBrge3shmbYg1ZcOng6QlBHhBZuw88y
	Ax0zkDh5Dh46X2zKVIAG2ORx9EyapIaVPgU+koVER7kPXQyW0tm73ma3jsPM28cWgFw6wp7NVJ0
	ADqZV4hlZ+hsNOnjVGoVEXsELNzu1F/TNFimjSuLMjW/sniEQK/5QRvrl2CZBZ+M9E/Hx6KCqz9
	bm0+YwHeeTK1AUftLIb5h3YCGOYTJcFdomgH0ln0gVVXNgaM0pZDL1gLmoa/PoA9r2LThYYKrau
	Xd3MZDXWuMagoy0dMAj3gu3Jq0W/uFJtQshVeOqZotbAKdpfOs7uZBcD2q8d
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--14.816100-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	61CD51C57478B8B88DCABC418BEC81D7F3150126C13CF5B61BEF8A9FB3FE1BE82000:8
X-MTK: N

T24gVHVlLCAyMDI0LTA3LTAyIGF0IDEzOjM5IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgTW92ZSB0aGUgdWZzaGNkX21jcV9lbmFibGUoKSBjYWxsIGFuZCBh
bHNvIHRoZSBoYmEtPm1jcV9lbmFibGVkID0NCj4gdHJ1ZQ0KPiBhc3NpZ25tZW50IGZyb20gaW5z
aWRlIHVmc2hjZF9jb25maWdfbWNxKCkgdG8gdGhlIGNhbGxlcnMgb2YgdGhpcw0KPiBmdW5jdGlv
bi4NCj4gTm8gZnVuY3Rpb25hbGl0eSBpcyBjaGFuZ2VkIGJ5IHRoaXMgcGF0Y2guDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4NCj4gLS0t
DQo+ICBkcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jIHwgMTEgKysrKysrKy0tLS0NCj4gIDEgZmls
ZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNk
LmMNCj4gaW5kZXggNGMxMzhmNDJhODAyLi5iMzQ0NGY5Y2UxMzAgMTAwNjQ0DQo+IC0tLSBhL2Ry
aXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gKysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2Qu
Yw0KPiBAQCAtODcwMiw5ICs4NzAyLDYgQEAgc3RhdGljIHZvaWQgdWZzaGNkX2NvbmZpZ19tY3Eo
c3RydWN0IHVmc19oYmENCj4gKmhiYSkNCj4gIAl1ZnNoY2RfbWNxX21ha2VfcXVldWVzX29wZXJh
dGlvbmFsKGhiYSk7DQo+ICAJdWZzaGNkX21jcV9jb25maWdfbWFjKGhiYSwgaGJhLT5udXRycyk7
DQo+ICANCj4gLQl1ZnNoY2RfbWNxX2VuYWJsZShoYmEpOw0KPiAtCWhiYS0+bWNxX2VuYWJsZWQg
PSB0cnVlOw0KPiAtDQo+ICAJZGV2X2luZm8oaGJhLT5kZXYsICJNQ1EgY29uZmlndXJlZCwgbnJf
cXVldWVzPSVkLCBpb19xdWV1ZXM9JWQsDQo+IHJlYWRfcXVldWU9JWQsIHBvbGxfcXVldWVzPSVk
LCBxdWV1ZV9kZXB0aD0lZFxuIiwNCj4gIAkJIGhiYS0+bnJfaHdfcXVldWVzLCBoYmEtPm5yX3F1
ZXVlc1tIQ1RYX1RZUEVfREVGQVVMVF0sDQo+ICAJCSBoYmEtPm5yX3F1ZXVlc1tIQ1RYX1RZUEVf
UkVBRF0sIGhiYS0NCj4gPm5yX3F1ZXVlc1tIQ1RYX1RZUEVfUE9MTF0sDQo+IEBAIC04NzMyLDgg
Kzg3MjksMTAgQEAgc3RhdGljIGludCB1ZnNoY2RfZGV2aWNlX2luaXQoc3RydWN0IHVmc19oYmEN
Cj4gKmhiYSwgYm9vbCBpbml0X2Rldl9wYXJhbXMpDQo+ICAJdWZzaGNkX3NldF9saW5rX2FjdGl2
ZShoYmEpOw0KPiAgDQo+ICAJLyogUmVjb25maWd1cmUgTUNRIHVwb24gcmVzZXQgKi8NCj4gLQlp
ZiAoaGJhLT5tY3FfZW5hYmxlZCAmJiAhaW5pdF9kZXZfcGFyYW1zKQ0KPiArCWlmIChoYmEtPm1j
cV9lbmFibGVkICYmICFpbml0X2Rldl9wYXJhbXMpIHsNCj4gIAkJdWZzaGNkX2NvbmZpZ19tY3Eo
aGJhKTsNCj4gKwkJdWZzaGNkX21jcV9lbmFibGUoaGJhKTsNCj4gKwl9DQo+ICANCj4gIAkvKiBW
ZXJpZnkgZGV2aWNlIGluaXRpYWxpemF0aW9uIGJ5IHNlbmRpbmcgTk9QIE9VVCBVUElVICovDQo+
ICAJcmV0ID0gdWZzaGNkX3ZlcmlmeV9kZXZfaW5pdChoYmEpOw0KPiBAQCAtODc1Nyw2ICs4NzU2
LDggQEAgc3RhdGljIGludCB1ZnNoY2RfZGV2aWNlX2luaXQoc3RydWN0IHVmc19oYmENCj4gKmhi
YSwgYm9vbCBpbml0X2Rldl9wYXJhbXMpDQo+ICAJCQlyZXQgPSB1ZnNoY2RfYWxsb2NfbWNxKGhi
YSk7DQo+ICAJCQlpZiAoIXJldCkgew0KPiAgCQkJCXVmc2hjZF9jb25maWdfbWNxKGhiYSk7DQo+
ICsJCQkJdWZzaGNkX21jcV9lbmFibGUoaGJhKTsNCj4gKwkJCQloYmEtPm1jcV9lbmFibGVkID0g
dHJ1ZTsNCj4gIAkJCX0gZWxzZSB7DQo+ICAJCQkJLyogQ29udGludWUgd2l0aCBTREIgbW9kZSAq
Lw0KPiAgCQkJCXVzZV9tY3FfbW9kZSA9IGZhbHNlOw0KPiBAQCAtODc3Miw2ICs4NzczLDggQEAg
c3RhdGljIGludCB1ZnNoY2RfZGV2aWNlX2luaXQoc3RydWN0IHVmc19oYmENCj4gKmhiYSwgYm9v
bCBpbml0X2Rldl9wYXJhbXMpDQo+ICAJCX0gZWxzZSBpZiAoaXNfbWNxX3N1cHBvcnRlZChoYmEp
KSB7DQo+ICAJCQkvKiBVRlNIQ0RfUVVJUktfUkVJTklUX0FGVEVSX01BWF9HRUFSX1NXSVRDSCBp
cw0KPiBzZXQgKi8NCj4gIAkJCXVmc2hjZF9jb25maWdfbWNxKGhiYSk7DQo+ICsJCQl1ZnNoY2Rf
bWNxX2VuYWJsZShoYmEpOw0KPiArCQkJaGJhLT5tY3FfZW5hYmxlZCA9IHRydWU7DQo+ICAJCX0N
Cj4gIAl9DQo+ICANCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0
ZWsuY29tPg0KDQoNCg==
