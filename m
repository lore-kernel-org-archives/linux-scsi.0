Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A169B2753E8
	for <linux-scsi@vger.kernel.org>; Fri, 14 Feb 2025 05:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739512313; cv=fail; b=sEHNQk3RsmvTDGUsFImFtzy/f2UTec/C8DHqq4elUZIupEy5NIETpIdauFGEFnNtOtX6i48Mix58a5wGiYstCCjOqyT2MJfGxSiMZDtan4CD31vixbMvAbVd+Y8CBpiVteIQw7kNtzBgJqrcPgVCv1H2RQ5T9Pg80njwoDXqT/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739512313; c=relaxed/simple;
	bh=Mulh71KlryAJwXNlyLu9BxjC1tn/IFR7aH5jRKf0mJA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BBnCjX7mSTbA4RA18Nmit6kPM+IQR+Ugjo4thT4Kq43SMDnG5K6cq8POcmWZa6DX25ioKP3iZ/Bhjzz9PNkHzJ3np4WZ7J+zzFTp/8tWCHlrfmnJY42cBYyrtZ8P/3hKiRCvNA/aSUm7qFI2ldvZ7KmZkfWrGrM46TKsCCnlBAY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=J7+Kizoo; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=O0Fvf0HO; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="J7+Kizoo";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="O0Fvf0HO"
X-UUID: c59874d2ea9711efb8f9918b5fc74e19-20250214
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Mulh71KlryAJwXNlyLu9BxjC1tn/IFR7aH5jRKf0mJA=;
	b=J7+Kizoo/AVNNe5fx/ZUwFKqFU5Xb3RAkQ9AyjlSfamH5yeBn3MDQeovrWnlZdPgsgtYAfJUcCVkcoLVcqbeNttKTyh59hJNXDlaNhZTo32zHfwj0soF5+yB2H06k4u1cHhKjCh4d0ahz4ZEeafwiSc8aNTGMR0UJIIHbvYBTeg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.46,REQID:8b4434ad-0282-4769-96f5-924320ad804b,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:60aa074,CLOUDID:40145c8f-637d-4112-88e4-c7792fee6ae2,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|50,
	EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OS
	A:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: c59874d2ea9711efb8f9918b5fc74e19-20250214
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1444473990; Fri, 14 Feb 2025 13:51:44 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Fri, 14 Feb 2025 13:51:43 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.28 via Frontend Transport; Fri, 14 Feb 2025 13:51:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wqmE7zylRBpXE+q8kmpxSI4WJ66kgIXabgNbFHlhzsysgmSrds0Peheqo0b0j6ZNF6S2X25SwG1tcghXkzzdLbHaf3XmS8FVyj0aSwdmlkvMa01xtmVaD+H2QKGWCg5U16t/GAYJbqf0+5nqfNeqjGDd26ncWq2M8IrNSidhVuH7YqNI2coyqIVwjLlF7p9fzqmamR5z/d1y1eLBLQAD9qUuXPM9tHzV1PxUmxd8DFJ4zlwr8AIVyULRVRt4VAPXRJol6GYr2FloTmxRJMCtpr56sJcXuyt10N3nGe/ZAC1FVy05AC/T+pk4pxHl8uMVlEPwpy0bDeh842XeQ6hZMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mulh71KlryAJwXNlyLu9BxjC1tn/IFR7aH5jRKf0mJA=;
 b=VYaiH1xRJf7RlvmnJ+zXf0GhALaw60hV4xG5rV0bwATbtdi1VvhyiVwwEbdDAz5wfUEOxMuBMv49BbgXhpneosxAXfKjJHecPGSzA5ZyBjh08Jb+OLk+9VJW4PJVCTFa69j2DoDFse7+3RBONWTelGBSra2cUNaQzXxJJfRoulB5+I1aAuat1qUTdiEgSbtN7xuxjcCUzxTFG6xQ3MfsyG3L0r76RprB3tl5OugmEFflbrHIgflSFcqxdO4haUbGWwViDp0Bqn+d+gcPGN4BFdaIlDb3uzh+Lj7px6MNWeB38Bi0178Fz/lfQuTMEgnR8cJKc8kSktvKrbG8XVRWbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mulh71KlryAJwXNlyLu9BxjC1tn/IFR7aH5jRKf0mJA=;
 b=O0Fvf0HO9bCeRT8WZAvV5LAbMWduoiYVfNwI9sNV0XcxmyOzGiU4sLFfg1ik+hjt/TqvP4UzV+hblY+EzU3m1jUvFnUEwz5nMtK1iCYOBSbGdm5EkIoWZ3f/fWmn3JO4HJmh6OB7E+PvRgteWvloGyHtOIBDkhyfPCMsTPRftTM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB7319.apcprd03.prod.outlook.com (2603:1096:400:422::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.13; Fri, 14 Feb
 2025 05:51:41 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.8445.016; Fri, 14 Feb 2025
 05:51:41 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "sutoshd@codeaurora.org"
	<sutoshd@codeaurora.org>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>
CC: =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?WWktZmFuIFBlbmcgKOW9ree+v+WHoSk=?=
	<Yi-fan.Peng@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>
Subject: Re: [PATCH v2] ufs: core: add hba parameter to trace events
Thread-Topic: [PATCH v2] ufs: core: add hba parameter to trace events
Thread-Index: AQHbfguhneMiEYZSwk6SiJZoYdLasbNFetgAgADSGoA=
Date: Fri, 14 Feb 2025 05:51:41 +0000
Message-ID: <fec12eb65f9e2cd3a871d2805b8c8ea5fcfe0ab6.camel@mediatek.com>
References: <20250213113707.955255-1-peter.wang@mediatek.com>
	 <16f26ea9-69d6-4f2f-9adc-c576c288a2f5@acm.org>
In-Reply-To: <16f26ea9-69d6-4f2f-9adc-c576c288a2f5@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB7319:EE_
x-ms-office365-filtering-correlation-id: a846f6cf-38f6-4765-833b-08dd4cbba7f7
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dXNVd1RCTTVlVk9EWkRxS01Lam9mUm5Xb2pXQzdTR0Y1VkxXZXJxVjk3VXpQ?=
 =?utf-8?B?ZFF2NGxaeTVtV1k1OW05UE5uMElpdWlONE43YkhjRnJWSWM1RVNLN1JCekZx?=
 =?utf-8?B?SWlwVzBjSHRTTU5vaVFMTFl0TEdPQ0lnT1RJT1pleXMvMGJVWVprbVIrRVFn?=
 =?utf-8?B?dmhZTktoMDJiV1E5NDJ5QzVNNER1RU93YmlYZDNBREN1TGxYbnhKVnRJcWQw?=
 =?utf-8?B?WG1DUGd6ZFJUcUZoZzZlQ0RkSEtUbzJRcXVkTzc0bXBvajQ4RGhUbktOSldC?=
 =?utf-8?B?L0NpeFFXeTJoVEZoaG9JWnRyMFcveEpEcTBNUWtpbjhDYUdoOEFmd3lwTU9q?=
 =?utf-8?B?YmEvM04rTEJrU1BaYWxOYXRYWDF4bTVqNDJGeVhxS2NzU01zbHZ5aThmQ3ow?=
 =?utf-8?B?MjhvdklFVjJCWVc4dVRBM1lBdi9qWFl5Z2t3MUg0RW9YdUY2LzRnbU9hYy96?=
 =?utf-8?B?dXFRT2N4Z1YrZFBjUVFZMm5Fak94cGo4K2F4WmRiMjJpMnBUV1cxSUUvMkdl?=
 =?utf-8?B?bUg3Nm5SNmwzUlkvNHl4L1YxNEF1dWVQZHFqVkhFWWlHMk51NGc3aUZaQnRQ?=
 =?utf-8?B?MWNhOW92Y2JWY3pXUjVVQXRVUnMrUk5jaHhiSCtyN0o4ZEQ0bERXemRRd3Nj?=
 =?utf-8?B?VWsrVGMrV1l1WFN4enYvMWQzTThxWnRzM092NU50UDlKL21OTlJKd0FFdW1q?=
 =?utf-8?B?ZjNHTGs0ekpvaUZLL2JZVUI5dXVIV0R2ek9oUVJKNFk4N2FvSndFWEg5bmYz?=
 =?utf-8?B?MXNKVUdoRFR5ak9JYitmbVBoK2x1ek1ZZ2cvWTdlcGJUL1U5WmpTeVcwK2dR?=
 =?utf-8?B?aER4bW43UTdQZHc1SjZYRWJsMy9hTTNNT0VUNFFVR0t0cWY2VkgwT3FvNkVD?=
 =?utf-8?B?MDFDQTk2QytrWEhQTk5oeHRqZGZWYytwYlRDZU14enlUODlSNy9YeVhLK2NQ?=
 =?utf-8?B?VmxOSHdRVDZmYitjQysrdFJYM3RPbDdialQ5NmcxaEJaQkFpa09hWkFXdFhk?=
 =?utf-8?B?QnhKc2lxN0lEYUJrcms3MUQrTFlINnRlUExoeTJ2dTg2eEl1dmlQVW9mRWM5?=
 =?utf-8?B?QjVQTk9QTmpyODJjUzNSc0daTjloQkZ3YW5WVHlwYUFCRXRPQzJKWTRNSWxM?=
 =?utf-8?B?NkZJS0FqRGJwL1htVG1IT3UwTkJxZjJzWXJ4emtXbmMxOWJXUng0dHBSbS85?=
 =?utf-8?B?eWpMK0xoUHlLOXk3MGdwaXZNUjVBbTZENkdGdHZHZFdBZktZd3pHd3J0ZTlm?=
 =?utf-8?B?MDVyaVFaNFZrNy9IOVd0TUl1UThxRllVQ3lvTFArOVhIOVh3bTMyMGFhUjhU?=
 =?utf-8?B?QktORkxNR1lROTVROXYzNi9CK3RzL0NUTkZxZXVJOGxTMmxzVVV0eEZwbnpB?=
 =?utf-8?B?SWhyRmFPanNOVXZ3NjVkd0paVTJzOFFYa2d6YS9CU2loUkMxU1BWdEVlUUMx?=
 =?utf-8?B?a0JaalkvektWQlNhbEtSVkYvaGEwTGdnZEozWUNpQUVxKzVrOHdWbmtjcmNY?=
 =?utf-8?B?c1U0UGxFbUErVVhrUXQ5R2VmNWpGSXgxdURTc20yMCsvKzdiaUtFdGtEVHRU?=
 =?utf-8?B?Vmc2VTNUc0ViV3RxaUxaQlI3RnRTMlJoazNWcnpIN2k3cWhUN2doODRmQlZS?=
 =?utf-8?B?UkcwcU1XUGdwa1JCaTR4c0dVOWwreHZzSHk0ejgxR0FyOHVIY3pPWjlxRGNU?=
 =?utf-8?B?U2N4NTZabjhZeDlaU0R4aktHN2JGYndYalV0emJ4VkViL2xCY0psdFhYL0V5?=
 =?utf-8?B?WjQ1QnFKNnVzbHlkL0tIaXNJQXpkcVBudS8zSlN3eng2ZFhhY1h3TFN4N0c1?=
 =?utf-8?B?N1FLdEl5MFVEclcxeXJmWUVTK1Q4R2Z0c2NBMUhaOTBSbnEwRnFBQXNLZDZ3?=
 =?utf-8?B?SWh1TU5KN011MWhXZHBUNUo2eUVuNnRWU2V1R2NZQWx6ZjRyYkpRZkZ6aFNm?=
 =?utf-8?Q?fLpnAifrJwQEeMojCdo0mm8UDmoFMO+b?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZVIyWUxGdFh0MVgrbWJwek5OL1NFTHp4UjdQT2VDYlRVMjVMZVR5clZIMEJM?=
 =?utf-8?B?b3RNK0hjUVJJNUxsdmM2QUtwWG5GUVFNSkNWU0hQSXlGTDg5cm43Q2xtdzA0?=
 =?utf-8?B?OEtBWVVrRHpwTERDellHMFlvajRuOExDRHF5blQrZGJIdDFyRXRydU9waFpV?=
 =?utf-8?B?YUNRVTkvTVc2MXVObTk4Z1JibmJDc0h2a2R3MDZ4NDZ0M3l1eFpVSTNxcGNF?=
 =?utf-8?B?L3E1ekw3aVhnanpTam95UGtiNWVIUXBvSEhoaFZKVHpKNjhTZFVrVHBoWlpw?=
 =?utf-8?B?WUFQQ0VpOXA2SDVrbEk1SmJ2VDZ0V3Z5NnFYZ3E3amZ4ZFFOU0txZ1YxcWlX?=
 =?utf-8?B?S1NyUy9RZmk5ZGptYWhtL2VBSXVWbXRSZHRYSm43YW1qTEdsZitqd2s1TEpR?=
 =?utf-8?B?TmVxd1BPMXl6S0lPNy9tUktWcFI1ZDdvaEdXbmlJbmFneElvWUR2T1NuMThi?=
 =?utf-8?B?RUI4a3FWcTU3TXpKc0g2cFBxVWlqVDlESUZtdGlpTFJnRmEwT0xsOGNxeWMw?=
 =?utf-8?B?YXdhSjZRaUlrbFBHRm5PR2pQd1o5UStLb0N1YTZyY1VHK0pHbGI4MnIrL2F6?=
 =?utf-8?B?N2hFc2NiZFg3YXZlcnRNVldueW9RSlF2U0N2UHQxN2F6b040L2FSVWYzVUli?=
 =?utf-8?B?T25XTThQNTFxM1Q0Y0pRMFpJOVFFMklncU12eGpWazgrdU9INUpFK1ArS1Zh?=
 =?utf-8?B?dnhpVzV4N1dCT3VJbjhTQmVtN2ZqeU1QeFdBSGtMTUNlRFFoaVoxbC9VMTJi?=
 =?utf-8?B?VWdVaFVOd3dIcWtEMkZKbkxRMEVwaUxES2hSUTJWK3l3d2dZRzF3NHpGbEhD?=
 =?utf-8?B?WVUrTllvR2FEQngrd2JhcUllc1RuU1dKblgrWDFHMFBnUFpadUNZWnpzN0gr?=
 =?utf-8?B?bXVMSldWdDR1V3kxWVB1Q2hrSTJhcG9lQXdNYTAwSlE1YkN0N2Y5eWluYXlE?=
 =?utf-8?B?Nm5HMjljY2UzcnJnUTFTenV1VXozN1JRcEdtTU1SVzkrWHpwL0ozOHV2Tko2?=
 =?utf-8?B?M0pwS1ZOTzZ3OVhPdnc0MlgyZ21tSklWZi9DWUpKb3BRUWY2UlBsNGhaNlNN?=
 =?utf-8?B?bmplRWY5S0ZWNnBsSS9INVViM0Z6UGJmQS9TVlQxTGhtRnB2RkhITzJ0SXJq?=
 =?utf-8?B?K0dZLzZpZ2s0emtUUWNqcnk4Mi9TNkkvekpld2VtT1hTNjlFNXJTVU9pOVZB?=
 =?utf-8?B?SVBmR001SGprcSsvVncvVDBBbUtPZVk1Q3ZOVTI5MnoreFJ4VElCaVN6eTdL?=
 =?utf-8?B?V3ptWU5RTlV6aGhjazlWNTVGK3pHbUpnNTI3RFE4cTE0ZWhDS0YvL3plYzJD?=
 =?utf-8?B?bWZRUWkxVi9VSkdEMmFJKy9kZG96VzUzRC9USzFqMXlCY3Y0VW9wOE1qWlNQ?=
 =?utf-8?B?d3NvZXZrNU0yaUl0ajVHZU1LTjFLbDF4NmlGSkNPR2xMbmtPVHY5Y2tIRmpM?=
 =?utf-8?B?MldzdjRwcXZBWm1tNWNHdTdnb0VjS216akw0bzROUHFjOHIvUWhzT3R4em1Z?=
 =?utf-8?B?VU9DUFJ0R0l4Y21SaFFOa1pPNzYrWnB0TGtDcms4ZVR4b05hOFNIUmNza055?=
 =?utf-8?B?czhKb0lrNjJUSEZMbnhDN3ZhVGczaUduaDloeXRWMGYzcE41eE5PUmxnZis3?=
 =?utf-8?B?Q0JyUDRRRlU3TExIdWpPV1RwcERXYXQyMDYzU1dmc0F3b0UySWovSEFnMnRl?=
 =?utf-8?B?NHNyUm5GYmFWd0t6ZDY4YlFVODRuK0dkNWNtVWthc01hU3lCSGlPckV6YTAr?=
 =?utf-8?B?eld5Q0hCdDYrc292NUlkdlNBdkwvVW1iVmdGaSszcXJ1R0I0Njl2cDc3M21K?=
 =?utf-8?B?cU9mOVNKUWZ0OWtBRWhhZkRkWWZKcmtJU3pRQkw0bEpiVDlNaGZ0eHBJUFlX?=
 =?utf-8?B?TmdtNFhrVENIVkF4Z3NwK2hmZWE3VHpxbENzaFM3QTZNVmprSnVrRmEybmxX?=
 =?utf-8?B?R1B2UVE2OXdNajhkbzYxcEVjWkhPaU9KdW1kalRRV2dFVTFCMGZHNXdlSFY4?=
 =?utf-8?B?dDY5YTlJN3NHTGVXcW90cHRGWDJ6MzZ3cFV0bVZxRS85WWJmRmlORHQxVFpn?=
 =?utf-8?B?QUE4WmczWjA4dFYzUVhJRG9hUXlId3B2cnJ1NVpUd1REblUxZUFLVU5nV1dB?=
 =?utf-8?B?aXF5WWg0OVYrQ05OZGJOR2p4ekNsbllBQ3E3TGRIVGZ2ek9ndHBXZzR6OEQx?=
 =?utf-8?B?bEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <56A75956FEBD1149B83A29DB5714B8A9@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a846f6cf-38f6-4765-833b-08dd4cbba7f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2025 05:51:41.7056
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 52aVI3w7ooFPIOBsOb+t6ziRMK+ahfufjlgwaQ8gn3ccPIDkn3Z9xeaebeQ+2omz7qN0dtlGfQPQWiTZyX1umg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7319

T24gVGh1LCAyMDI1LTAyLTEzIGF0IDA5OjE5IC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IFBsZWFzZSByZWR1Y2UgdGhlIHNpemUgb2YgdGhlIHRyYWNpbmcgZW50cmllcyBieSByZW1v
dmluZyBkZXZfbmFtZQ0KPiBmcm9tDQo+IFRQX1NUUlVDVF9fZW50cnkoKSBhbmQgYnkgcmVwbGFj
aW5nICdkZXZfbmFtZScgd2l0aCAnZGV2X25hbWUoaGJhLQ0KPiA+ZGV2KScNCj4gaW4gdGhlIFRQ
X3ByaW50aygpIGNhbGxzLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0KSGkgQmFydCwN
Cg0KVGhhbmsgeW91IGZvciB5b3VyIHN1Z2dlc3Rpb24uIA0KVGhlIGRldl9uYW1lIGVudHJ5IHdp
bGwgYmUgcmVtb3ZlZCBpbiB0aGUgbmV4dCB2ZXJzaW9uLg0KDQpUaGFua3MuDQpQZXRlcg0K
