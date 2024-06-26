Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C518A5916B
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 03:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719374069; cv=fail; b=k0nlYR/SBCZr0q+n1CwwiKIE35T+KysXsAwhzZs727Mg9SaqYuUXf8XF4jXdpLCXyb+6s1B7gj7FZoq4pebIHl8zfgz33W1oHRhu3BZytcmi2lpVqPJmHbKUVtv41MX4F1efWldKNMWfRpBAyyB1xhhGOwQuhgbw14qNnk8gvBg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719374069; c=relaxed/simple;
	bh=fIVYQpDTOr7AJ93/haOyG/7pt6lPHhwcF0YdxaN5zP0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aaREsI0fdlrY0W59u3KdVvY94KCRqA71soMd/gPHrpZM0tIPFIEpHLG9dnisCO6FVhpwSmoo93YLbvGJFr53rVKfcoxBjOYILoNh1wcDPN2WR60YSppL3lbmlE0O77ZssV1Z/yuPjsFPzV0B/PS7OoQJPcAA3eM6EvyH3rQWPZI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=nxVSuE/5; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=J8/WBvyn; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="nxVSuE/5";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="J8/WBvyn"
X-UUID: c438f47a336f11ef99dc3f8fac2c3230-20240626
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=fIVYQpDTOr7AJ93/haOyG/7pt6lPHhwcF0YdxaN5zP0=;
	b=nxVSuE/5Rz7Xe0cyTLnCNMmNtnzKOGpVsDO6uez1QBxcu3mvjWJenssdI4MadMNpXWC+wiu2/9uKOAMlfUd1PYrm4ipaNVgjuFs34sMsoKQsycO5gLXABgSpSKcKo5DdUmUUcLQUc4JBXKN/I4WVUJo6PdZrRUgnvs84IHT6Sl4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.39,REQID:dbc92ee8-1049-42ad-95f3-c512f8b8b07a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:393d96e,CLOUDID:d6497194-e2c0-40b0-a8fe-7c7e47299109,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: c438f47a336f11ef99dc3f8fac2c3230-20240626
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1050065962; Wed, 26 Jun 2024 11:54:19 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 26 Jun 2024 11:54:18 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 26 Jun 2024 11:54:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kHEyNtW/JKH2AM7WBUHXwYZ0klmt9ma4aysTDtH7FYHt5YVp1dLRUewtqaeUb3yt/2luNqPJbLmh1JH0JXNyhelEWOrnZVXh0123kPhxEkFpcHwpzfckBcZQHo3I4xKD8UJzf6Z8v2RgHvoea6W0LIQ0P3VvRH8NNHbKmIjLz5kRiMlp0sac+4q1Cf/b0Nku+/afcc4I+GW0Sg86rKBT6l0w9cQTreonIcmRLZTwC4axJxiIju59xuafKIX2Y6ILorT41+QPDU8VJfJ5mDdQ9w/xcBhKEHkJ5hVBQXSAbNu9a5ogkEVcaO4rYhB4NhI4P3mnr3xrDFthNgcoZd8hFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fIVYQpDTOr7AJ93/haOyG/7pt6lPHhwcF0YdxaN5zP0=;
 b=mAVT1+s7QbWDO55wUR8J/cVVKI3OzvxVyJ2oz5NCDdJjVBjGYjaUeif0UeszaA4/TDrkgF+tucaZVFaBJvOR7nJX95Un+fjofECt4Tc4t4pd02SnirDvldhRk5dQJMMNjc8TRPHgAQ5DbxFTX0wWAgunisSY7LRXe9NUeRNb3zSxVPQUOl8tCxFQKC3DePPQo+TY7f4WiSa6VD7UGBnStDLHycjrzhervcOZOn+6JyzTQVUqpQFKNgzMiyF9SBEXXsKRdN3DZk/BoMhaOJl5ka39Qe6KdihdAcKX+wohZZyn4l+nWS/kDZ5auNC4nKviAgaD4uBH7m+tpWv7gUS2Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fIVYQpDTOr7AJ93/haOyG/7pt6lPHhwcF0YdxaN5zP0=;
 b=J8/WBvynqzarFc/9BnyAfuDSWOXcsqFz4/aIUcbdWSJuC8/o7sOFWjWQ8l7+wsy2OHBpBvbwjj/BowjogMBqeaHjPu8jIh2I+m4FURkpHKqW9i0X7UFfM/ttDdeM7F98zXMMvG5jiKSwUzWRMSA+sI/8Y+HPJfz8sXu3yeW2pJk=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB8536.apcprd03.prod.outlook.com (2603:1096:405:68::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.30; Wed, 26 Jun
 2024 03:54:17 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7698.025; Wed, 26 Jun 2024
 03:54:17 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"ahalaney@redhat.com" <ahalaney@redhat.com>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>
Subject: Re: [PATCH 8/8] scsi: ufs: Check for completion from the timeout
 handler
Thread-Topic: [PATCH 8/8] scsi: ufs: Check for completion from the timeout
 handler
Thread-Index: AQHawPrEvEtR2PxEBkyAfPJ3MA8LCbHRzdSAgACvsACABCixAIAAnAsAgAEJ1YCAAGyzAIAAvkkA
Date: Wed, 26 Jun 2024 03:54:17 +0000
Message-ID: <5bcf25bb6f0d3338febf350716df8590a41af852.camel@mediatek.com>
References: <20240617210844.337476-1-bvanassche@acm.org>
	 <20240617210844.337476-9-bvanassche@acm.org>
	 <054eef8dec43e51aec02997ad3573250b357bee2.camel@mediatek.com>
	 <1f7dc4e4-2e8f-4a2e-afbb-8dad52a19a41@acm.org>
	 <d6d329a3d822cb34c8a5bee36403c59ceab015a0.camel@mediatek.com>
	 <671bb45f-22a1-4f81-ae93-65bd5a86f374@acm.org>
	 <167b737c45ff3c9b9422933d45b807929d0b83de.camel@mediatek.com>
	 <b302c1ae-2cbb-4906-81f2-285c2b913109@acm.org>
In-Reply-To: <b302c1ae-2cbb-4906-81f2-285c2b913109@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB8536:EE_
x-ms-office365-filtering-correlation-id: 2a04621e-12b9-4ded-9e68-08dc9593a6f5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230038|1800799022|366014|376012|38070700016;
x-microsoft-antispam-message-info: =?utf-8?B?cFJzY0xTVnJpRER0K01OVWhkL2wvYW9VQXBSV1BLdGlHRGZCWDRRWVlmekJ6?=
 =?utf-8?B?clVHY3ZGbnk4ckVNQ3pPdmd4RSt1UVEwcU5pbHBzQmJjeGUrVm5vM2NHSExh?=
 =?utf-8?B?bXFZdVBLd2JuVytnd2xyTERMSmVxcy83M0tQOExORHRPVVhTWnd6Qy84cmtj?=
 =?utf-8?B?RHAvaWc3eGNpejM1R1lLaUh1ZEoxMHptejVnVXlPVEFxSUt3MkxHYzJoenIz?=
 =?utf-8?B?Z3ZVVUZINHRHR2RXTXhaOGtzSSthSGJ6SkVXNnZZZlF4NXVMbFBDVlZYcEdU?=
 =?utf-8?B?VHhrSnVzUVgrTlVUREsvOG5ibGZ2S1BLRTZKN1FnMnRSclpuNHBBRzh0dCto?=
 =?utf-8?B?MXZTWU1zdXhZRW5iN2haNXpOU01NTVAyTmorS05mdDVCOEJ6dVBFbFZjZkpQ?=
 =?utf-8?B?VkkrNlBXcUtGeGg2aVhCN1RGMTJkYk1uUTFEb3ErWDlMVE1JZHI5OFVESU9S?=
 =?utf-8?B?SW9GQ1ZpaW1PY2xXWkFmSHdrei8wSE83Q0dXNlhwVTVPKzBnK3BYSFZ0d1Fn?=
 =?utf-8?B?bnI4MGlCb1VJekYzTUxGR3J6alUvWm5NdFpYc1dEa21YblRjdkw3bkpqUEht?=
 =?utf-8?B?UkxzbE54TVVGSkVkbjNTUlNlZVd4L2JMRERhTmEyalhsaThBTFp3TGZtY1pm?=
 =?utf-8?B?OW9NRWhSeHdFR2ZTQjhqUS9pL0hkekNHc0Z1YlZuVGNlTDFhb1JtRXQ2TS9K?=
 =?utf-8?B?aURNTG40N3l4NU9WUDlnQjNGOG1IdGJsZG9FNW1ZdVBxV3pBSE1DK3hYTXBJ?=
 =?utf-8?B?VjhpdERGSkN5TndIOVpzSHFzSVh0WlV3anJkZ3lhd1RFeGUxamVRb0lFVmww?=
 =?utf-8?B?RjByc2dReXptWk1VY3lvZi9MbjRZcU5QNit2N29jQ2lreEkrZlplb3hhTmNH?=
 =?utf-8?B?Z2pqK1VhMzJxSVlRMEgwd2dhVThRdXVqck03blUvSjArYnJzc25jT2lGVmo1?=
 =?utf-8?B?b1RtWGQrTzlGRzVja1hRUERwcFk0a1U3L2xOUWVFeFBEYUNxR2w5MEFiWHhJ?=
 =?utf-8?B?dlZ4WTRhWUg5azdXMWxSWERZcC9FUERub0xCVERndFZuRUtvTlVSS0VQMk9p?=
 =?utf-8?B?dWtiTFFaWlNaN09CV3JZdWFqVmVtU0xQV0g4clgycnVPRkRkaVc5K3phSzk3?=
 =?utf-8?B?alJlK3ZtNVBJdFAyNTNKZGFuOElBSndmZGdFYmlVWlZ0UmZKZ2h1cE5uMkw3?=
 =?utf-8?B?SVE5dEpCaVppZUp4azR5RzNPd0d1cGhtRW92cHMwQjNNdVlmb0V1bHNwbnNx?=
 =?utf-8?B?eXFsaTA2Z1JPWlo4QW1xaWErMUhOT2JwUDZMNEpjVDhVMTFwSFhrSWw4bDVB?=
 =?utf-8?B?L25MNnluTVpuK3VSaU00WlYzUXltNWFwMjZkQkFVZlh4VHJtajNRdm1aa1d0?=
 =?utf-8?B?UzUrblByY3NsVGJseFFrL3p5V09BVDZIcTZKaHhtbTVKUGcwQmpNN3VFajA2?=
 =?utf-8?B?UDFyYnB2VDNGa29UKzJWSHliZlg0cldBQzFMRGN6OWZyZHRlclV5Um16TTNz?=
 =?utf-8?B?cjBnREFCc1FITkVjWi9iNDBxOEY4QXBYSkdPMlo5QnpvSHAyc3BPV24zdW5z?=
 =?utf-8?B?dWNDQ3dINnJLdDJUZXQyTEFDWmlaaUtDUWxmR3hxVHFWVCtSZHAvWFVQeWxC?=
 =?utf-8?B?a1ZtMWlzN2hkQlFhQkFtRTRhNURpWUhXSFNNakxia2hYemZhZllzL0Y3WGx5?=
 =?utf-8?B?UWFvcEM5M2RhQkg2UGFlNVdVK3dxZ2E0WjhBMlYrTjBuR2Fpa1BpL21wTHBz?=
 =?utf-8?B?VGNubnhsQjM5dEMxb3VWZTVFbjVlZzNiMzhQZzYwTVFPSnBaK1lCdFhrZmhG?=
 =?utf-8?B?ZVlKSkY2WmZmRFEwOFhMZEpqQ3ZZVDRTL2IvSXdpOFl2OVN2eGtEZ1J2VkFp?=
 =?utf-8?B?ajZUSllsQi9KZWQ5MDZ6UTBkTmhYWjBldmkvWm00MjNld1E9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(1800799022)(366014)(376012)(38070700016);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q3prRUJXVEFlS1hrOXVSZ0liMkNYRVhpbmVrWlpyOEJQS0w5SHlYNWRQcEVM?=
 =?utf-8?B?d2FKNWVCdGE2cXphaDB4Y0ErS2pIU2gyN0VxTWdXOVJVYUMyaXJKaGFLL1dX?=
 =?utf-8?B?MUs3UnlFYlRTQ0piT0tRU2V3QjAxeTdaZDJRYWdkU2xDRzZNSHA4RFJQVEto?=
 =?utf-8?B?eVBPQXpkWWFwcHYvV1Z2d0pxUWRiNk81SmQyZ2F3Z0dKWXdxNHdjMStDSkp0?=
 =?utf-8?B?d1B1VVJTNk5HREt4TEplVlBpd3kveHlLcVpQR3lOZnVQa1VOTWowelA3RkI0?=
 =?utf-8?B?WjJ2YjNBNGZiTHBwWDVnMStOZGlCeC9zaGc5cTJiRHhVcW1RT3h5NjIyVkxP?=
 =?utf-8?B?R3ZvV3V3aXM1UmZBcmlCMGN2SjA5N1FsM2Zka1pCV3piYUI2bzNkQlVxMU1M?=
 =?utf-8?B?T25QamlwNkF4aEsxYlhNdS8yTktCVlh4eWFIRHl3WmJkQ0FtRDMwU3BlNjEw?=
 =?utf-8?B?T3RFYzIvc1krV3RjMmpwcjdib2VNWUNUWjN1Z2RLYU9EV2JkN0dtNmgvS3o1?=
 =?utf-8?B?bjVEVm9GVThWYjVORGpQZTJWWUUzc2FqYzZUenBIMm1NU1hjdXM0bDltbGpj?=
 =?utf-8?B?WlZ2K2txNERodWRnTTU4ZktSdm5tTSsrZlQ3dXR5Ym9FRHB1b1RJdUM3Wi9h?=
 =?utf-8?B?WVJaYzdlcUpBTEpZTEVJWUVWbTZMRFFHTW9uemtiOEptMFhuUFhBZ2s0dkow?=
 =?utf-8?B?UkFmQXR1MHc0bmg2R2dIRU5DREhQNWw3cGl2VHZMMFo3OGFKcjl1Z0JkaW91?=
 =?utf-8?B?VUZjN1BiNFBYMFVzTk9hT3JubXBFOUQzSkYzRjJ3VTZIV3NXbEFlY2pYU1ps?=
 =?utf-8?B?QlllS1Bub2NTMEthYk5GQ3NxNk9jaWRPVThLTm1OM2k3aW03QUFkSG9GenVQ?=
 =?utf-8?B?MHAwSFNxcEFMU0RuM0R4N3MxVWpFWFFUdEord29sMkNVVmJIWUJVdzhHZHcz?=
 =?utf-8?B?TkJBQzZKREJsNk4ydHQ5VHBhRWFHcW5zbU9WcHhsS0FWQXE4QTg2SnljOFN4?=
 =?utf-8?B?UmtHdngxeloyT04wbkZjdFY5UFZUNVdhaG5JODBCR0JtdjFGTTA2bnVuQnN6?=
 =?utf-8?B?Q1NCSC9BSGdab3l5bHNlM0d0NFkvSlV5eFJqNFord2Z6dWlJMnJhUnVVVHJY?=
 =?utf-8?B?aTk5WEZoWGNPbFpZY3UvSk15YXZOeVNMdER2dVYxcENKQW92K1Bnbm5TbXBQ?=
 =?utf-8?B?SkJHRG9WbHVMMW9OcFkyQThTam5qNlFXNDdIVnZDRDM1SmRNQXI0cElQUkF0?=
 =?utf-8?B?bEpyUkxYSzJ6ZEhhVFgvV3FWdnNkbTcyL1N0MlJSYmMzSTRRTVpXM2Ixc2Fo?=
 =?utf-8?B?UG55MitYakNiZGpHSmMremZpRkt3WitHUjcrSnN6QTZBUUZkN3Zpc3hEYW9m?=
 =?utf-8?B?LytuNW9LMzVCeDYrM2NSMmY1NXZZNG1qTWg4MWZFeFFvM1QyNWtqeEtWRVRu?=
 =?utf-8?B?WHNmbVFGbmRSWGdFbE1MSzlFSmhhczBBbndsbFJ3TVVOVmsrVXo4bVpVaVRD?=
 =?utf-8?B?Zy92UlljV2RxN202bGFydEtkSHlkUXNzTS9hckJ1RWszNldpd1Jkanp3MDYv?=
 =?utf-8?B?cVZaUGc3M1ArQVVUNDVDQ1N3RFE1R1hjbmgxV3puUVJ2YzRJQnppRmNJQWxB?=
 =?utf-8?B?M21OYzlwRytYZnJ0OWJzNG1yN0xqbmhieUVhSktwNjVFZFVycy9XeFNzWTly?=
 =?utf-8?B?YU9aeU0vQnczNFV3djlWWHc4MlgwTFkrd2RFdTBMVC9qVEpYbEpSRG43ZEJh?=
 =?utf-8?B?Y1ZCVzRqVTVtYVFIbTJpbEFPaU1ENWNBc2tvMThNbU1HczF3NzBkTm84R3d1?=
 =?utf-8?B?UWlXeCtick9MMUVPU0tIUXA2d2NFajAzRnJuUHdWWjZLT21KZlBUV0tHeDF3?=
 =?utf-8?B?TGdvb0htWHAzZUt2NFlHTnkyR0p6N2d5S1BIcGM3YjF4UjZWdmExdDgzWGR6?=
 =?utf-8?B?UWZpVFAwMUU2NGVMQmZWWXFaM2l5ZlhIOFEvdjBTalF0QUdBSGtqODlGWXlZ?=
 =?utf-8?B?aTlGV3daTE00blNyMXNHMlp1Mk5odzlNbFpXb29TeXJZRXlqUk0rbmNobEJX?=
 =?utf-8?B?bllPbEtQSFlFTWhtd2xCbzl6ekV1eFVRNE1aMVZWVVZ2aS9tcTM1YWtCQU43?=
 =?utf-8?B?ckNzTDIxbnYrMFh5ak1ocUs5bTA5UmpkS3I3dkxEVlQrZm5pelIvK0hmODFL?=
 =?utf-8?B?VWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E525C981260B5B4F8049F1DB006ED0FD@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a04621e-12b9-4ded-9e68-08dc9593a6f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2024 03:54:17.3562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pDRr0vumiGvCPhNwL4aVoMQZFJeu3NliR68S3rBnA5g8EkIwZRBBD6/9oD86NEMJc3sYUTctmgzpYa0ImNDaNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB8536
X-MTK: N

T24gVHVlLCAyMDI0LTA2LTI1IGF0IDA5OjMzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiANCj4gV2hpbGUgdWZzaGNkX2VoX3RpbWVkX291dCgpIGRvZXMgbm90IHNldCB0aGUg
U0NNRF9TVEFURV9DT01QTEVURSBiaXQsDQo+IGl0cyBjYWxsZXIgbWF5IHNldCB0aGF0IGJpdCBh
ZnRlciB1ZnNoY2RfZWhfdGltZWRfb3V0KCkgaGFzIHJldHVybmVkLg0KPiBIZW5jZSwgYSBjb21t
YW5kIG1heSBiZSBjb21wbGV0ZWQgd2hpbGUgdWZzaGNkX2VoX3RpbWVkX291dCgpIGlzIGluDQo+
IHByb2dyZXNzLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0KSGkgQmFydCwNCg0KU28s
IHdoZW4gdGhpcyBjb25jdXJyZW5jeSBpc3N1ZSBoYXBwZW4sIHdoaWNoIG9uZSBzZXQgdGhlDQpT
Q01EX1NUQVRFX0NPTVBMRVRFIGZsYWc/DQpzY3NpX3RpbWVvdXQgb3Igc2NzaV9kb25lX2ludGVy
bmFsPw0KQW5kIHdoeSB1ZnNoY2RfcXVldWVjb21tYW5kIGdvdCBudWxsIHBvaW50ZXI/IHdoaWNo
IHBvaW50ZXIgaXMgbnVsbD8NCg0KDQoNClRoYW5rcy4NClBldGVyDQo=
