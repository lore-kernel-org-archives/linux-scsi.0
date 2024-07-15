Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE55D18787F
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jul 2024 12:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721046194; cv=fail; b=UqVkN0QoxcQtha02Eukq94VFahgerXs2a1rV7chMn+uy+hLbQulgzefCad5FqvWdsowlxntorDRnh+9agsQ8pVB0b4sV9UVu/4I+1f5R0eShmV8Mxu2TzHjhi28Rmzy9vgmkSZVSv25kSf+R8IJr+g9f38CCGUMsGfPHMFEbV3U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721046194; c=relaxed/simple;
	bh=6rwWuc1/saIaoz3CZpm1OjtfStxLyOsQc7Ma2Za1sHQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MazfH350+yGNZ1Il5VS/RkzTbj/8rgwlHLsZRM6WrOKoDGRqcKfZNNEiNnqO6tPGvfAupooiVwqWIOV5QlIENklAbGEIO8xXa30Gfkvry8itKIm7JSm7I4Rmw912lLhPu2AFxMOP349b/JXPzVP1nff64qJIsXZub7Za3Lz2n3c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=hizth8m6; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=tZ7Xe/va; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="hizth8m6";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="tZ7Xe/va"
X-UUID: facf502642a411efb5b96b43b535fdb4-20240715
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=6rwWuc1/saIaoz3CZpm1OjtfStxLyOsQc7Ma2Za1sHQ=;
	b=hizth8m66jiuIyhvGDLBZ7gnRBljZWx84Eonyoy9HELGzNt7kkOw9iQfhGLOtnl9ZTy1XB4IVqZamNeHwSaEOZS2LEGawEbEeFnbWYsJbk5ZmtCFxmPBc0MnO/0CoNJzduwOdb0bkuTvoW+SErd203iC1BZ9VHiqEqIBcVNfUr0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.40,REQID:6d1c97e3-9d6e-4bf0-984f-caf67b324c48,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:ba885a6,CLOUDID:27277a0d-46b0-425a-97d3-4623fe284021,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: facf502642a411efb5b96b43b535fdb4-20240715
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1911802847; Mon, 15 Jul 2024 20:23:02 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 15 Jul 2024 20:23:01 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 15 Jul 2024 20:23:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ekiv1deNZj+zcso5APCIBP2bqxm0mz7c7kdbay5eJHHYi/BnpxUjYQyvQgePM9DvTcbvK9uDXa8JaB5B2Mb9tgdDN16c4h5Q79FIhdTkMBr9kv9A4W/fz27YP9eYv8grMiyuac3CoT6Tr6twpvkSSFFqYTwHli3mmXqPKhNnELucjiQ63ZMhsmVOI7bCBgzwrDdtQCqGGQ1IXxsZcM69M4WDpSmHhP3bQXVyjayFlHMX3pMegRwoma2blcaadQ2wigLGIyo/XBYxzUuXP33HoHInt6KnoIlGXiwrvL+foet7O/rCaBbqFtkwhuFrwB+mm68ZqzmS2Y+7P1ixEOu7kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6rwWuc1/saIaoz3CZpm1OjtfStxLyOsQc7Ma2Za1sHQ=;
 b=hE4JKTf1m/sBfgcVuZhvzlU9IAvrDaaZV6CWJ5QyidLHXeZr9Ao3Wk2wDsWBveluJsGZbkKGkvLqB3lL7WsfHCotQb5jx4AD6iZIBjRHzCLETYSRepPyM0sBKTvDWKdnqNBn4ZunqKyAuTFXQdf1LemFbdUYCM9oKReh5cD9Oni6uXtL+CI3NZPmuucNoJVx66zwW81MKyXQ9y+6vZUmXEl2Ho1jk9zeHHbprbr2mM1K4CSaoy7kx8/tuwHl/yu+W9fGbj4/+QatCSstwJ6uIGADAomlZpg4DR9ez4MQOobhapDbwEdbGTbjaqepriQwDc+MDb+zlK/RRH2vepFuwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6rwWuc1/saIaoz3CZpm1OjtfStxLyOsQc7Ma2Za1sHQ=;
 b=tZ7Xe/vaHC3q1oFGrJrcCi69Ppr5+jYyacbUKsFQwa8hH5y0aTXkoumXSiJ3Qd42Z5+gofZ535EuOeZh6qwssJtcHlB4TvQkeIh0tXAfcbJY/sVRzHqqwcFJJfWC2u8IsJQEyLYREIR5Crdb1vr/MuP0TgXSZeV1AjoYVUCce8I=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB7387.apcprd03.prod.outlook.com (2603:1096:400:414::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Mon, 15 Jul
 2024 12:22:58 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 12:22:58 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
	"akinobu.mita@gmail.com" <akinobu.mita@gmail.com>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"minwoo.im@samsung.com" <minwoo.im@samsung.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "angelogioacchino.delregno@collabora.com"
	<angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH v5 06/10] scsi: ufs: Inline is_mcq_enabled()
Thread-Topic: [PATCH v5 06/10] scsi: ufs: Inline is_mcq_enabled()
Thread-Index: AQHa0Xx8Z8p9T/0O/U6SKqBdLh30prH3wHgA
Date: Mon, 15 Jul 2024 12:22:57 +0000
Message-ID: <433590b933701e74fbb100c70902313b5af30900.camel@mediatek.com>
References: <20240708211716.2827751-1-bvanassche@acm.org>
	 <20240708211716.2827751-7-bvanassche@acm.org>
In-Reply-To: <20240708211716.2827751-7-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB7387:EE_
x-ms-office365-filtering-correlation-id: 592d556e-c244-4c36-8645-08dca4c8dc7e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MTVlRVFaTXY2Qk0zSVBZbVppQWpmMVBmSDJlSW1JOEtvUE1vb2NWQWtxK1U0?=
 =?utf-8?B?YU9TbFZ3ZmdjRDRSMTM3QWFZYnIvKzY4UGptc0szM2dBcmF6M2tENzBkWkZO?=
 =?utf-8?B?SVUvSmZoZ0J3SmphS1lqSnA5ZTFtejJXdEV5aDQxRFpHb2hzVHdzV1hkRHRU?=
 =?utf-8?B?UDIzWUZmRHU3ZXNpdDlheGc5ZnpPS29wYUI1M2RBdU1VSXoxamV3bTFLYkRE?=
 =?utf-8?B?M0JGTE1nTCs2NUt3ZDA4Z3crcDZ3Qkl5Wll6Ni9CU3dEMjE3NWJwdDJTcXNE?=
 =?utf-8?B?VUVnOTlTVWlzOStqcUhUOEVJNC9TczJidWZ5UW5qTG5zcitzVlQvbUdwWkxE?=
 =?utf-8?B?SDNKUFM5L2VlcHd1Q0pmeDF3QzBNdjBqM1ErclJmR3Q0S09KcnY5M05pbVNL?=
 =?utf-8?B?QjhiRnU4Y3FucUtsZkRzV0JlTExjQitJZkRBOFlUNnZQSk9NbEh2bnhBdTRX?=
 =?utf-8?B?MmJzTUtiWm1aaDhURkRvRlVGVXNCWkR2eXgrcWw2NGw0bWdKREFBQ3V0RVNT?=
 =?utf-8?B?NFFCaUxGWXpEZlhQS0l3UlE5UmlUbEthMGN1SUlJbnVESTZaU2N4NXowZnM1?=
 =?utf-8?B?aUpMODlTQXRQRHdTaUp2aFo2V2ZNNUkydHZMN0s1OHB0SlNBQTBwU0xSOWd4?=
 =?utf-8?B?d3U5YkRIMTY3eUI4c3RwVmFDM3ZpME1QWUt1enFFYjNGazd1WHlkcTR0YWx1?=
 =?utf-8?B?SWJUR3RTeitrUERRWEEyc0xId0JVSGNOOGt0cFg5ZUJ2cGV3anJZdXRjUG5X?=
 =?utf-8?B?bnNxUWlEc2ptS3lMT21Vd0F6MmVHZGNpSnRNQmUvVkZWUUtXMzZCenh5b3dZ?=
 =?utf-8?B?bDd4UzNUV0RsOVFZYmZ4aHFzSXExQ1FMN1ZxNG1FZUpMelE2dXRLdVpaRXFJ?=
 =?utf-8?B?RlFGU1pDUFNVTHp3MG5rOTlDK3pSNWNTNmhtSHVyNDZ6RmhhVk03bkNscVoy?=
 =?utf-8?B?V2NjYTZrMXJVNEpXWUpCeWlOTnMyNk4xOXkxa2w0aEU0NS9Sb2VycE9GS1Nn?=
 =?utf-8?B?aC9rd2RBaStIcUhwL1BWN1BJMzRrREQ2aGdiSk5seGlVVWl5SnVRZlJsRE1k?=
 =?utf-8?B?ZG1OM0dOcjhsUmFkU0VQOURid3dZT1dPdHFiNzRFWEw2Ti9CNDRDUTNieHlF?=
 =?utf-8?B?TFBncjVUMGdXQThHaUUwU3k1SVo0NFBqdVR6dDBoTmNXQmY5M2VyRGQ4UDZi?=
 =?utf-8?B?c2tkdDF4YVBQcmF5Y0NES2RBRUptdm9semc3YWozWWY2SW5aMXFQOG9IdS9a?=
 =?utf-8?B?WERGc3RLTXhFK3ZJL0c4WjZpQk4vQkpjcHBXUEoyVUR2T1JlNmpYem42QzNi?=
 =?utf-8?B?eVdGeW4xaUpJaUVZNndlbjRYLzdaczAvSS9nb2psT3c0V1pEQURxTmkxcSsz?=
 =?utf-8?B?ckpReW9OUW9vU0RnOTNXWVJlcVJTVWpwWmllVDg5YUNZVGtPU0hVZHFHbTNL?=
 =?utf-8?B?V1F0dncweG1OalJhQzN5bENSWVZJNmRvcytiTDY2Ym1EbFhwcGVWT2JZRlh1?=
 =?utf-8?B?SHVQNjJhZ1FsUURyWGVWejBtZ1BkYlBhQ1RKYTl4bUVEYUVPR1lHVHIzYS9I?=
 =?utf-8?B?RUpFUjlvNGRab1N4YUt3MEhGRUJTcFcrcFZVQjhheDloSGhWZ3NmUDN5REps?=
 =?utf-8?B?M3h2T3pRa2JmK3NoVmx6cHhsSlpLZ1RoUUw0TG95aXJTVDVUVk9COFZUVVJs?=
 =?utf-8?B?QzRFNmVMTGF5SzF6THJkbEtndVJvd3BHK2RqbXp4VkVPb1lCd0hZcEp2cURl?=
 =?utf-8?B?RVRZZUhYY3VQM2I4NFJaN2pkYW84SFhmdTQzVXVCN1hPL3ZacHBVK0lEbnV5?=
 =?utf-8?B?aEhoTnE0eXJLakpVdG5TNUJUZVdROUJlRGgxVmdYWS83QUVGWllOVlJlSVRT?=
 =?utf-8?B?SDhZV0NpMFlobkl6Q29HeEpYejNRUW1rR0Zrcm9YanhrWmc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q0JaZndWdzFqb2svc2txUzR6K212Z2ZBNjdoTTRpWnR0R2grSUlBbVRkZU5X?=
 =?utf-8?B?SVkySU9NTzEyWWo0NmFOa0h3TjBDTmhhcmpBdVgySVZtdHI3QlNSTVV5dmhK?=
 =?utf-8?B?bFVoeWt3ekExUlBzNERyTlh3alNwclFqdEpXb0oyb2Z5SkxxN0ErYzlicm9m?=
 =?utf-8?B?c0tuVU9wWUU0VUZ5TUZySjI0MDRheFhJUytFd0diWFYxTUpqK2R3b2dOeWpR?=
 =?utf-8?B?TU42Yk5CTDJES0hWWkczM0JmR2REUzl2UU5JTTlQNlI4ZENjaUJIZjZrcHN5?=
 =?utf-8?B?Tnc4aHZZcm0rYlppN1pZRzF6bzNlNzhPb0FCN0VuaU1NWmVFOWdLMmVrWUo5?=
 =?utf-8?B?QW1CVDRzSHRXb2tVY2lXczlCdzBtdFlpbkNFd0xrY3VJd2IwYkxlUEJtdnRK?=
 =?utf-8?B?di8yT2l3c29yemZrNGNtVEovOVFhYUd1RFVyWVFUaWxiZks0SFpFRUZrdE4z?=
 =?utf-8?B?V29mRTFyNGw0QWp0cWlQSWNPazdDRzl3ckcwWDZYLzhqZHlhd1lROVhhb2c5?=
 =?utf-8?B?Q25XcjZDTkZMQVRCZ0FWVnVwNWFha0VBUGVVNFMwS2JYZDVjcFZuN1NDUXRi?=
 =?utf-8?B?RHQyaktkYVBNcUZRR055WVZwRVpiclo4ZXlEMzA3Yy9wTWtZZC9KRjk5TmRE?=
 =?utf-8?B?bjRDeVFQOTE5Q2Jad1YrZHBra0tnQytQTi9yT2gwanYrT2RXWWd6d2tSSkhH?=
 =?utf-8?B?R09oRExiR0tIK3VRelN5dGZ1SE9lLy9relhCczBXcDVIajdWK0dkUzNEMGl5?=
 =?utf-8?B?L254VHBIeUxWRzEvNnp6Mi9tcEVETzVncTFEN1NPTUhEbmt5eGMxdDRIRHda?=
 =?utf-8?B?bDhwcVlQQmk3b0kyV2E1aHdLN2k1dXg1aTFvWnhXZTRvU0NSQ0lNaXhHOGFu?=
 =?utf-8?B?aTF2U1k3TFk0UXZlVkJMcmlSSUYxSUFvcUREUklCSk41MEd0Tkw4Y0FGUmt3?=
 =?utf-8?B?ZHdoZEl6OHIwNTMyNmkyWnNETzBHOXJobCswcldOQ3NNYWFQQ3JYajVXd2xt?=
 =?utf-8?B?NVR0cHlMQXZ0UENQcnZHZXhRZnRUYmlBS0s2ajRVR3ptOHZvdzJUak5ZTXpG?=
 =?utf-8?B?dGNBcTNnRytJOXQwa0FSVm85WG94OTN1WDNTWkhQWHpYMTlLampoY29qNXZF?=
 =?utf-8?B?M1ArOGVQdzRTd2NlSGJpTFArVnZ1dzY4VTNWUlFyS3BxNTRCSElRKzdIcXNY?=
 =?utf-8?B?V0Q0aWxsa016dXVyMlVXdmlBRkJSUDNKSTZGc2J5VlM4cW5ZdFhGVXlkdDR6?=
 =?utf-8?B?cWs2YVQ0Vi91ZUZEOG0zeUNMTG9pTXFtMlN4Q0MvQ2VXWkZtL1JqSG5zN1hG?=
 =?utf-8?B?b2ZITzZvTG9FZDR5aXBIOUNZMGYrdWtPRUkzeXJKcDFVc2Z1aGkraHEzbUM3?=
 =?utf-8?B?VVp2cTNwb0d3NG4vU3B4b0ZMVmNscUM3RGNjcERzbDBFKzJ5ekg4N3FiNHVN?=
 =?utf-8?B?Q2t5RzMxMDNDelRVaTR6alIxaDZYVmoydnM5WVhtb3BrSUZObWJXVS9vWENE?=
 =?utf-8?B?YlErMHBsa0wrQUxLbzF4RTUydjJ2YmE2d0FYdC92cWtlaHczUkFUZ01vVDFZ?=
 =?utf-8?B?V2I1V1hodnBCUHk1eEFHdFc3VXFHUmV4aXY1NXY1dDdhOXJOdVhZaGMzVkZK?=
 =?utf-8?B?d1UvWjBXV29paTFYc2EzazBGM05qT1VjanVzR1RTY1FhTGtHUHJ4Rlh4cy93?=
 =?utf-8?B?RTJPQm4zcHdqa0U1cW1ZWW1oaVBjWjdvOUZvdWFLZnBvUk1xc1ZTdFlMTVc2?=
 =?utf-8?B?L3lNdVZORGh2Umh0c0pHc1pmYlQzSVNLakJBSjA3V2V1MGRnamVETUMyaTQy?=
 =?utf-8?B?dVJUNUhVQmJneE10Q1k2OHQwbFk3MHdGUVY1RFhQVHZkNGhqRzdQSldpaHNi?=
 =?utf-8?B?NEduNU4yOUcxZit3OTJzcXVZdlNmYzhLNXpZbk1OWVdLa1NkYm40ckR5azg5?=
 =?utf-8?B?Nmc2OG9lUWdRWllSdjNtTStJdFdVYzhrMkJaK1RnTWJ6OFpOc0svT2s0aVdH?=
 =?utf-8?B?d210bjFoYk51eVJJeUk1Umh0UWpNaWlPRS8yV0lzbE1FUnp4eTNtU1RXL1BR?=
 =?utf-8?B?Q24ya3htbHYvUDhuQ3RQYktSM2pxRnpkOFVpT00vcjlITzVLWFVCbjdWNWxj?=
 =?utf-8?B?OURTQ3dqaTVMeWJVQW4zTEJsVGk4NEx6eHVld2NCYVpPbzB2WHU4RmE0cnB6?=
 =?utf-8?B?UFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <11706DEC1400934BB95B849BA592926A@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 592d556e-c244-4c36-8645-08dca4c8dc7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2024 12:22:57.9414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8N4c0oER2UR4eQiD7RyRGL+XLyz9/Pp+EtaqPmrpvOC3OAfnCPagFlDpdo8qHOIE3DVGgw0ArpW376Xbyspq4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB7387
X-MTK: N

T24gTW9uLCAyMDI0LTA3LTA4IGF0IDE0OjE2IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgSW1wcm92ZSBjb2RlIHJlYWRhYmlsaXR5IGJ5IGlubGluaW5nIGlz
X21jcV9lbmFibGVkKCkuDQo+IA0KPiBDYzogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRl
ay5jb20+DQo+IENjOiBNYW5pdmFubmFuIFNhZGhhc2l2YW0gPG1hbml2YW5uYW4uc2FkaGFzaXZh
bUBsaW5hcm8ub3JnPg0KPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3Nj
aGVAYWNtLm9yZz4NCj4gLS0tDQo+ICBkcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jICAgICAgIHwg
MjggKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLQ0KPiAgZHJpdmVycy91ZnMvaG9zdC91ZnMt
bWVkaWF0ZWsuYyB8ICA2ICsrKy0tLQ0KPiAgaW5jbHVkZS91ZnMvdWZzaGNkLmggICAgICAgICAg
ICB8ICA1IC0tLS0tDQo+ICAzIGZpbGVzIGNoYW5nZWQsIDE3IGluc2VydGlvbnMoKyksIDIyIGRl
bGV0aW9ucygtKQ0KPiANCj4gDQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5n
QG1lZGlhdGVrLmNvbT4NCg0K
