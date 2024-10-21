Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3AC200CD
	for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2024 08:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729501180; cv=fail; b=s/EjBDMvV0/i2mOHau+3NtiCpbHNJxIGs/4ox1p2OeF07m+lrhYUmgf6lx/NCp6VnAW32Caw7CQANXSBhR9E3SejnNZL6Fas9FMxTj9l3lR9XnoFDfYlnW84vo3S5S8G6CUyM342wIUvFWpvCcC+YV5UymR+voNou/FkaoLX/U4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729501180; c=relaxed/simple;
	bh=K8/ScMQzyNhV4j8OQj46QHaJa60h7IhaoMxSrskAKcg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Vrzy7NzQPfyv7dubwT2k1hpkn1mv7rm2kXzP9wd9fVaKTByKVvDpcogQX8hDSGYFwLglhbviKmMXsJGV9V3MFukWsPJ3Y+1nbAzSqsyivBGHpwl6FLi/GCtHQe1K5kS6YCgV7GpiIjSABnCFujaWnyv/xLNXEI0gOYbmWTBqs8Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=c2c284Kx; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=iMwWxfFo; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="c2c284Kx";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="iMwWxfFo"
X-UUID: c9f21cbc8f8a11efbd192953cf12861f-20241021
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=K8/ScMQzyNhV4j8OQj46QHaJa60h7IhaoMxSrskAKcg=;
	b=c2c284KxvqWZnHZUmskJU9zjif2G6fqAMVTk77X3TdLNj76a5zou0HiLjXKhESeG7oOtx6tpnyHBg/K1I+z+zlFVQBxXasZuRhYu6Uj+LeLGc+pfnbhH9OvOg6ShiptPK6q5TM77B2KaIlgWfpuqeNwMCG9rTxjk8ApPppt1Hpg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.42,REQID:7d8da7d5-051a-4b24-a851-6eeea51597b4,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0fcdc3,CLOUDID:cf1e6525-9cd9-4037-af6e-f4241b90f84d,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: c9f21cbc8f8a11efbd192953cf12861f-20241021
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 998404364; Mon, 21 Oct 2024 16:59:32 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 21 Oct 2024 16:59:31 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 21 Oct 2024 16:59:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SFWydyAmijd1fRv+jjhxAPQnbJclppul4h1/gYYxlPoiXTGrlphIUDFX94asn2BOKWYQEfFMMdVqYo8EkTBNMw1/6KdusLlwag2aaxVConOM4E7k9O1RqelpLGmYUypY+nMQzJhIrUCq+FCZ42L9ogii2SzgeDb/ArZi6XaJZl9AUgnB+Y9zWwiTKO4vl76JeLU6+zXB/+3+Tl6sodXVqk8q5GDMkQChOavLuLLY775PBUPQutyKUFfHtbLmvOFmeT2lStYU+CtTl7BSW0HqFqdeY8a3Sw3FZchpWSIoT5PL7ggC3o+fgKlKY2+KGyQ1dpmmU4TrCDK9Rrg0NX1m9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K8/ScMQzyNhV4j8OQj46QHaJa60h7IhaoMxSrskAKcg=;
 b=nTZnNxBtkPWjmZ3ij9V2prDy9WOFJ1lECLi+1U8P/AQ6sZFhTXaULKtpbfvbwtNrA6iKhohAZ8zhT+aSB2bju9gwfZBWekCA5EJQtApz2xDLiAywCuh+bn3PUYL9NpZ7rEcB90BBB1WyM4ubv8g+N/nRwrK630+UHLnBYN5/KB1o5Nb1YlwzxrIefSqwS7sV86GX/UdnUtEJr8d913Zb/MiSd0tdM8CKu+q2DPp2OM9bAIOXp5Y3JLATtykT6xBTJVeNeqy+4818hfoGL9iXcOa5ad0cnQxfkXSFy8+OFkU5mcXZQIVXrFJb0wMvR1KofOGfEao/Ch678jMCh9LM8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K8/ScMQzyNhV4j8OQj46QHaJa60h7IhaoMxSrskAKcg=;
 b=iMwWxfFov9sUXBrPg1j9iBDqphKwXmEXkOV+0o3a03GpNiRZzkD/D4wQa6qDjKdqSo5ILDv563ln+GdUK4bWdR6fcwzDV/M0ciqg14r2vKPyKbI26fp3fFiGNTCkt3MnzA3GGNDvJNkxTgr11oIQ0RigILkZShqBE7rvqvARbmI=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7127.apcprd03.prod.outlook.com (2603:1096:820:c9::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Mon, 21 Oct
 2024 08:59:27 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%3]) with mapi id 15.20.8069.027; Mon, 21 Oct 2024
 08:59:27 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "Avri.Altman@wdc.com"
	<Avri.Altman@wdc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "ahalaney@redhat.com" <ahalaney@redhat.com>, "quic_mnaresh@quicinc.com"
	<quic_mnaresh@quicinc.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"quic_asutoshd@quicinc.com" <quic_asutoshd@quicinc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "quic_merez@quicinc.com"
	<quic_merez@quicinc.com>, "quic_cang@quicinc.com" <quic_cang@quicinc.com>
Subject: Re: [PATCH 4/7] scsi: ufs: core: Fix ufshcd_exception_event_handler()
Thread-Topic: [PATCH 4/7] scsi: ufs: core: Fix
 ufshcd_exception_event_handler()
Thread-Index: AQHbIBAtyEdjQsJ5W02GNnoGUokUOrKMA0MAgAC7XwCAAAbCgIAAJFgAgAQFMgA=
Date: Mon, 21 Oct 2024 08:59:27 +0000
Message-ID: <efedf22012876b4a30f4cf71cf053d5e4bad9982.camel@mediatek.com>
References: <20241016211154.2425403-1-bvanassche@acm.org>
	 <20241016211154.2425403-5-bvanassche@acm.org>
	 <DM6PR04MB6575DD9E354A70A9EA97E439FC402@DM6PR04MB6575.namprd04.prod.outlook.com>
	 <608f86d5-0f27-4c88-a2b2-6504348f2f18@acm.org>
	 <DM6PR04MB6575010F498BC3F480EA198AFC402@DM6PR04MB6575.namprd04.prod.outlook.com>
	 <793f958f-353e-453a-b2eb-288853a38dc2@acm.org>
In-Reply-To: <793f958f-353e-453a-b2eb-288853a38dc2@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7127:EE_
x-ms-office365-filtering-correlation-id: 3a252998-f1f5-4bc9-c94c-08dcf1aeaad8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?T2wwQnFqZml5alhEaFpWNXVwR2FGQldobHZWRXRvMlU0UElUaDd2b01HODNy?=
 =?utf-8?B?anFVUVVqeThTTVdCYXRDZmYwRUxEUFdQUXhkZDd6aU44amRMYXpScnhTb2ZT?=
 =?utf-8?B?ejJWTGthSVpZRnVkSGZIUWlaaFhLMnFia3c3QTBWaE1CY2tYdHFpTi8wZDhE?=
 =?utf-8?B?NXVnbjZadysvQndNL1hnZnArQ21MbHNRKy9YeUVUbjFVUVhxYk93OGlGdVl1?=
 =?utf-8?B?ekJJaEVsUDJPZktHZE9aOTMxYkFEL3pwSk1VR2h2UWUwSllyMG1SK21sc2dJ?=
 =?utf-8?B?RmVQaWtmdmNGK28xSHhNelNQN3BCSjUxVW0rNDZ3SEIybVIweEUzVEFObkM0?=
 =?utf-8?B?QjFFMFZyVjB4cjZGcGFKRUszSXZoa2VOVW9QMGZ0a0paa01GUDZBQmxyQnpt?=
 =?utf-8?B?dmgwZGV1S3VpN3dmdXdsRHdubWM3T3ZVSVBsM1E3dmJUY2ZPclRLYWlXdThs?=
 =?utf-8?B?UnFZMW9RWVRhblRWOHdKRHdFU2ZGbW40QTZFNGI5MDg4WWlXTlhzVnM0dmxS?=
 =?utf-8?B?OGliRkZvTk5nWnZXaS9aTUJtZmIySXNRY0ZCWFl5QUlPUjgyclJJa1VFcWc5?=
 =?utf-8?B?RnAvQzBmZFF0dFZDN25HLzIzQzFBdHFYa2VUOUtKQUlmdFNYNlRsaTc3UDhU?=
 =?utf-8?B?UGJ4VWcvTEdXRUxsWTZQNjBUYU9JVFZCQjNhTVFUSVVLTGd3YzFNRGNKVlhh?=
 =?utf-8?B?NDREbVgwaTBOcGxWbGxzQ3NWY25yR2tUb0l1MGJhc0lNVXRlYldINDcvd083?=
 =?utf-8?B?czhJdlpQNFVKTjNmMURTQUpVVmpKd2NmaGdJVFdQdzBkWXdrS2pHR2pxTHo4?=
 =?utf-8?B?VndkOWg5ZWdGNXZrVERRMVJBd2Q2T3pDejZJT3MwbXdEb21jZVI0ejZWN3Ry?=
 =?utf-8?B?Z3FJeERBWkZaSHFNUDZLSXZrT1RYem5ham9lUys1ZHo4czdQb2hRUFdaSi96?=
 =?utf-8?B?L3dnTXR6WG1yVXRaUDhFZ3dYVGF4U1J6eS8vMEFwUUVvRVlRT2V5bUFIaFNK?=
 =?utf-8?B?NHRXalAxRXJwcDZLRGpzbW9KMFVJekRHa3NycDdBZ0dpOFI2d3dhdmM2eXpP?=
 =?utf-8?B?UXZSdW4vdDNJKytqV0E4QUk2MTlCbVRFSkdONVUraUErbS9VSG9YOElOSzMr?=
 =?utf-8?B?VExHTFgzbCtmSTJseFA5T09XbVRiVzd5UlBOT1Y4aWcwZVZzOWNEcWE5Y0Mw?=
 =?utf-8?B?L2dWd0cxUzRyNXlxZ0ZMR2JaeEM1dmJ4VENjR3FaQlFKc2ZVWU5kL0ZJV2hD?=
 =?utf-8?B?ZzNGSlpzQkY4SVB5dEg2UFB5TGN4Ym82c2wvRkJSWkRTUFo0dFRFM3BYNFRN?=
 =?utf-8?B?b1BzaGJGUWh1Sk9QK1Q5aysxQkR3a0thY1FSeTNWWndWdU5PTDYzYWtMTFB0?=
 =?utf-8?B?N0NKZ0RSZ05aUnFUOW1nWHl0cEFQZ0NVYnVFTEZlTFM2MEhscjU3RW50SVdG?=
 =?utf-8?B?Z1JUWW5uQ1psK05NcUFNc2FCN1dxckhQVEJZa2d0WVVlVUtibEhlRDJzN3VL?=
 =?utf-8?B?RCtsaUFlMzRrV1Fjb0xKQlFXUVRzMTcrampkYWdEcEIxYVZ3TDg2emNQdGs1?=
 =?utf-8?B?bkRCUWFsM3h3ZDVqWVl4SUhET0tZVlZBQ05RSGU5eDFNU1N5K2lXOWFSb3hJ?=
 =?utf-8?B?RXQrbHVqSVNldFJNNWhMQ05NSnBCYmJ2NWY1K1hYQ1k4eGtiblNPOUtYKzd0?=
 =?utf-8?B?Zzh6dXdBWUpxc0tXKzB1dDNlcHViMllPWDZvY0dCV0RDbENiVXBncWx3VE9y?=
 =?utf-8?B?aVhhTDNuOWVkNCtMd2txMG1TdHRRVElBa1I2Yy9zRUhGTHl1SlNkNXZxczlO?=
 =?utf-8?Q?yL4kWDSzQsLaHMXE5q0AMFI0TsniLkcaFyjcw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T3ZBMzV3RDVCZys1MEwwSDB0bVpEOUJPQ2Z0bnltaHJ4U3IwRTVtN0dBNTh1?=
 =?utf-8?B?WnY1bkVWZm5JNysvMnI0R2tVZTZtM3U5V2pFRTBucEJWZFd1bDRKYXB1Ung0?=
 =?utf-8?B?UTFzWkhVellUM1lIQTNDUHhFYXpuOVlDaXd6aFNnNTVselREYi9rUXR6ZlZt?=
 =?utf-8?B?eVNEY3M1QmRiTDY3a3ZTemJCZjZkRVJTQ081ZjYwN0pPTGtqVFpCcElQQkJY?=
 =?utf-8?B?MWExZDZyak1BS3FqTnlIUFFIRGtDS2xyckYyblRZOG96d1ExSEM2WmJVN05u?=
 =?utf-8?B?OE1kNnZxSUdjUEtJNTcyd3RraG9mMXBoWEUyWm9VakViRGdMemV2azN3dDdj?=
 =?utf-8?B?NklDY011dFZXZDVnK1p3RkJNMjBQai82S0ZueGdHSmplRjg5N21KM1R6QW9y?=
 =?utf-8?B?TGNiVTBtQTdnNkFzdXBkTElHV2dLbjlrTk1mTGM1ZWFTUUlrd3NlRDlsUkls?=
 =?utf-8?B?SG95N2QvOGVLZ1VFL2tic1VveWcvMURlRktjOE9uMitKL2xRQ2toKzI1am1k?=
 =?utf-8?B?bWRjZit4Kyt0d3p2VDhSQ25RRGhqcVN1ckEvOS9jSlAzbmZobEJHQ051UURj?=
 =?utf-8?B?YU8wL1ErbVZPZ0crci9Qb2ZWdHdzN0d2Sm9DNldjdCtkWGZNbml6TFQ0N2V5?=
 =?utf-8?B?VDVwQnIydjdrUHdsZGlGam5nNjZDcnM0MlZSRkdiUkNMdGhTdm9TTDZpaG1S?=
 =?utf-8?B?NHdHVGlLM3prWUJtODQxYkxDK0xESTcvVnIyeENKbFpySUNZTUZDYWZGM1ZO?=
 =?utf-8?B?ZTJINlZQbS9FdzU3V1c0MERXL1FEZ1EvT0ZyZk1MZ3hTWTZWMHBzQVNjNk5N?=
 =?utf-8?B?MHNSSzR6NE9UeUsvQTZvSVJOTk9oZTI2U0ZjUWpNbHdjRTdoRlBicFFBenpZ?=
 =?utf-8?B?SHZ2U3R4QWhzUDVyaU9lZXM1bmIyRlBsV2tpczl5RXVQVlNCd1lYRlpCK0p2?=
 =?utf-8?B?cy9OMzRLemVBaVN0dm9OTGF5NHZzcFBJcnJrR0QrZjBKTWZZUy82UVpKdzBC?=
 =?utf-8?B?K0xlaWVmK2IxR2gxaXIxZlI1cS9tQWgyaXFscHZJYTEzN0wyWTdNVHlKRWJX?=
 =?utf-8?B?czZ2aW9FUnZaRjY0cHRSa0ZVU1l3QTdHblA0aXc5RG5mN081NENCbkMrMU1I?=
 =?utf-8?B?OC9jb0U4bmxRUUoyNW1nSHFtWE5UbU85MnJYTHFIelhYVEo4QVVVS1BkNkNF?=
 =?utf-8?B?TXNXazhITGdHSmJyNGpzbzkzUVFteC9mOVBXcHhmSWk4blFmbG95M2dGUGhl?=
 =?utf-8?B?eHF1WEgwM3NQNE45NWF5MkgrRnBubkVHYWRiUUZFSzIza0lKQXRiQnZZTVcz?=
 =?utf-8?B?dExKcythelZnckVkU2Y0WGFwdTFlWTVsa1dIQy9JRStzeS9SMHpCQ3UreSsv?=
 =?utf-8?B?NEhuQWo5WG5Pd1pRTHZBSzJQa2l0aWZEZlcyVGVqZ2gyZU1UN21ZMTE2M0Fs?=
 =?utf-8?B?VmI5ZVk4RDNvVHhUSUpSMDJPZGFDVXdRb2dZa3lTRW91M2M1YktINHZsbGdq?=
 =?utf-8?B?MGhaZ2ZUc1pyVklOSE9ENmRDaVN6MVN1WldYelZmWVFHMklpV3QrbjNvMm00?=
 =?utf-8?B?S0VBeUFIMzFWL1U2ZXczSDl2ODI0THRMd1Nvc2R1bmFoQjRMS0UvQmtBKzN4?=
 =?utf-8?B?eXRtZ2kyUmpBbk83d2kwLzVrdE5ZeXFrdElCUGc1SHRhRHNsM0lpRm9RbTdr?=
 =?utf-8?B?cUFHUkdaNGhOdm1VMDdJR1laVm1GYlFRU2pUamVVdXU0SStGcHpyL3hySEhi?=
 =?utf-8?B?aDI3bDNQb0RTcVN6VEV4OUJLYXErbmhBb1lqaUNNQWpHUFMyWGEyTDdUaG8w?=
 =?utf-8?B?aVZpaEVEdkI5emhsYUp2T1Y2ZWxmMVF2WjloSVU3bDhvSzU4V2dvejU4N3FF?=
 =?utf-8?B?ajBSYnBpaEhzay9yRHFjRnR0R1hCeEp0UmYrN3B0QStJbU5Vbi9LV2dDK1Jv?=
 =?utf-8?B?UXloVGU0eTVwVFhaMmNvOHFqQ1BVSkY0TkFuVmpHV2tqVjJtUnBvaVlpQjdG?=
 =?utf-8?B?azBxTlBwVjZPOHFhVnUrYTdmb2dDYXZYWjNBOWF6MjIrMjNaem93VkIxQ2h3?=
 =?utf-8?B?eHJSWVNZZWt3RFhieUNWS0RCRHNuUnRjOEM3Z2dGd0R3T0J4aEVhczhBL1pk?=
 =?utf-8?B?NG5va1JKSVZ3UkozNE9xd3lBT1FJeDlhb3VKamh5WkhlOHBrUzE4b0Qwdm5h?=
 =?utf-8?B?NFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C4B119B5271288469D0CB1127C78AB2E@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a252998-f1f5-4bc9-c94c-08dcf1aeaad8
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2024 08:59:27.2135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i5r68rwH3/Kc4WLfvWAhMWIwsF5Lf8GdPhCvw0r01ak8l7SwwPGGRhiryFRanBp2zeUxtiwdcKzaA813MI5D+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7127
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--26.788500-8.000000
X-TMASE-MatchedRID: GBgFBUqwD4HUL3YCMmnG4qCGZWnaP2nJjLOy13Cgb4/n0eNPmPPe5KWz
	WoIRiV9DM/Se/q/gEyf5MiS7M8c1eGmXMi7Ntyo2mlaAItiONP2RPtwwl97om8j0Eew4TN42++3
	gQ26tbbiAIqIxZ/d1wXa29EXMuQPoRnImuVhjWQq5kfgtJfb41XFvlcB5q2DllL1/3IuU47KZ9y
	ZibX/kj9CQaPiFU4JxAbY5HH0TJqkIKTbeRIBWzEOK/W8SXbFb4wHGXjSYGPebKItl61J/yfmS+
	aPr0Ve8oTCA5Efyn8CNo+PRbWqfRJBlLa6MK1y4
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--26.788500-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	78D9BF310DF3A6FC72D7568DC3D7ABBC3092351601ECA248FD8076A8E49E35022000:8
X-MTK: N

T24gRnJpLCAyMDI0LTEwLTE4IGF0IDEyOjM1IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgDQo+IE9uIDEwLzE4LzI0IDEwOjI1IEFNLCBBdnJpIEFsdG1hbiB3
cm90ZToNCj4gPiBOby4gQnV0IHRoZSBGaXhlcyB0YWcgc2VlbXMgc3RyYW5nZSwgaXNuJ3QgaXQ/
DQo+IA0KPiBIb3cgYWJvdXQgcmVwbGFjaW5nIHRoZSBlbnRpcmUgcGF0Y2ggd2l0aCB0aGUgcGF0
Y2ggYmVsb3c/DQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0KPiANCj4gDQo+IHNjc2k6IHVm
czogY29yZTogU2ltcGxpZnkgdWZzaGNkX2V4Y2VwdGlvbl9ldmVudF9oYW5kbGVyKCkNCj4gDQo+
IFRoZSB1ZnNoY2Rfc2NzaV9ibG9ja19yZXF1ZXN0cygpIGFuZCB1ZnNoY2Rfc2NzaV91bmJsb2Nr
X3JlcXVlc3RzKCkNCj4gY2FsbHMgd2VyZSBpbnRyb2R1Y2VkIGluIHVmc2hjZF9leGNlcHRpb25f
ZXZlbnRfaGFuZGxlcigpIHRvIHByZXZlbnQNCj4gdGhhdCBxdWVyeWluZyB0aGUgZXhjZXB0aW9u
IGV2ZW50IGluZm9ybWF0aW9uIHdvdWxkIHRpbWUgb3V0LiBDb21taXQNCj4gMTBmZTU4ODhhNDBl
ICgic2NzaTogdWZzOiBpbmNyZWFzZSB0aGUgc2NzaSBxdWVyeSByZXNwb25zZSB0aW1lb3V0IikN
Cj4gaW5jcmVhc2VkIHRoZSB0aW1lb3V0IGZvciBxdWVyeWluZyBleGNlcHRpb24gaW5mb3JtYXRp
b24gZnJvbSAzMCBtcw0KPiB0bw0KPiAxLjUgcyBhbmQgdGhlcmVieSBlbGltaW5hdGVkIHRoZSBy
aXNrIHRoYXQgYSB0aW1lb3V0IHdvdWxkIGhhcHBlbi4NCj4gSGVuY2UsIHRoZSBjYWxscyB0byBi
bG9jayBhbmQgdW5ibG9jayBTQ1NJIHJlcXVlc3RzIGFyZSBzdXBlcmZsdW91cy4NCj4gUmVtb3Zl
IHRoZXNlIGNhbGxzLg0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNk
LmMgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+IGluZGV4IDc2ODg0ZGY1ODBjMy4uMmZk
ZTFiMGE2MDg2IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ICsr
KyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gQEAgLTYxOTUsMTIgKzYxOTUsMTEgQEAg
c3RhdGljIHZvaWQgDQo+IHVmc2hjZF9leGNlcHRpb25fZXZlbnRfaGFuZGxlcihzdHJ1Y3Qgd29y
a19zdHJ1Y3QgKndvcmspDQo+ICAgdTMyIHN0YXR1cyA9IDA7DQo+ICAgaGJhID0gY29udGFpbmVy
X29mKHdvcmssIHN0cnVjdCB1ZnNfaGJhLCBlZWhfd29yayk7DQo+IA0KPiAtdWZzaGNkX3Njc2lf
YmxvY2tfcmVxdWVzdHMoaGJhKTsNCj4gICBlcnIgPSB1ZnNoY2RfZ2V0X2VlX3N0YXR1cyhoYmEs
ICZzdGF0dXMpOw0KPiAgIGlmIChlcnIpIHsNCj4gICBkZXZfZXJyKGhiYS0+ZGV2LCAiJXM6IGZh
aWxlZCB0byBnZXQgZXhjZXB0aW9uIHN0YXR1cyAlZFxuIiwNCj4gICBfX2Z1bmNfXywgZXJyKTsN
Cj4gLWdvdG8gb3V0Ow0KPiArcmV0dXJuOw0KPiAgIH0NCj4gDQo+ICAgdHJhY2VfdWZzaGNkX2V4
Y2VwdGlvbl9ldmVudChkZXZfbmFtZShoYmEtPmRldiksIHN0YXR1cyk7DQo+IEBAIC02MjEyLDgg
KzYyMTEsNiBAQCBzdGF0aWMgdm9pZA0KPiB1ZnNoY2RfZXhjZXB0aW9uX2V2ZW50X2hhbmRsZXIo
c3RydWN0IA0KPiB3b3JrX3N0cnVjdCAqd29yaykNCj4gICB1ZnNoY2RfdGVtcF9leGNlcHRpb25f
ZXZlbnRfaGFuZGxlcihoYmEsIHN0YXR1cyk7DQo+IA0KPiAgIHVmc19kZWJ1Z2ZzX2V4Y2VwdGlv
bl9ldmVudChoYmEsIHN0YXR1cyk7DQo+IC1vdXQ6DQo+IC11ZnNoY2Rfc2NzaV91bmJsb2NrX3Jl
cXVlc3RzKGhiYSk7DQo+ICAgfQ0KPiANCj4gICAvKiBDb21wbGV0ZSByZXF1ZXN0cyB0aGF0IGhh
dmUgZG9vci1iZWxsIGNsZWFyZWQgKi8NCj4gDQoNCkhpIEJhcnQsDQoNClRoaXMgcGF0Y2ggbG9v
a3MgZ29vZCB0byBtZSBhcyB3ZWxsLg0KDQpUaGFua3MNClBldGVyDQoNCg0K
