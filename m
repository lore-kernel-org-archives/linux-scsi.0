Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66B61758F
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 08:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710490636; cv=fail; b=V1pzhU7UJSIduwitM2ZlkkHTqazO6V9NssWkXKyzf7tCKq68m6vnnh27teNHLHZ8/FynUPdf72d+5yz/86IkVmcvoUufWmu1gYreFDZi2JtnsinDtJRkRzaJgSw3BQPIULNL2CsY/QB4hBMouiTuOFqgQg0eIQQx04AN/iuVPjs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710490636; c=relaxed/simple;
	bh=es3FCaWe9CB2Iv7eK0u0YrVXav4cuXehKL5pis9oEEw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aaSDjJ3fVQqtOKGE2AtNTAEJUJQbP9lDMylgpbPeKPg+W7k25q4lBjjcgyp/D+47OtoYDSoY/EJoVaFcvga9CLZus3xFA5ryF9+lJzY3Z2CseWYJLHb1GNM2aYHrd2OQxD36PjqwkX9ujlZ2Bp5nqCYHTw8+Lm6GMmqh/3O+9qw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=I9DFk/hT; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=u7OND77v; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="I9DFk/hT";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="u7OND77v"
X-UUID: 6ae47f3ce2a411ee935d6952f98a51a9-20240315
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=es3FCaWe9CB2Iv7eK0u0YrVXav4cuXehKL5pis9oEEw=;
	b=I9DFk/hTxBdAoRKyIgwo6D1A/1TKIOP8mNmJyCTLyJKBxgZviLvB9xkzA5R8KMcQfLuofIhwAIxgbf3Y2x5shZt9bWTMWqfyMcM7wCLjT/9Ap0ZLFoXWQYc0osJRK9S7c4g0fm0mp0XEifIjSPkvs8L7+W5sBm9Ps5VrFmtaLkk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:27f05433-ccca-40ab-ae34-73e9d84cfed7,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6f543d0,CLOUDID:8499eeff-c16b-4159-a099-3b9d0558e447,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 6ae47f3ce2a411ee935d6952f98a51a9-20240315
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1778552316; Fri, 15 Mar 2024 16:17:09 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 15 Mar 2024 16:17:07 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 15 Mar 2024 16:17:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OpIoM6yHJH3bsaO/TV4GvqhNydHa0Z8eJDQZiG6SGrVndw+INUFKhspTKsRRfM0SQ8EXTDrygHhWc7VXEuo6kkvUzK7XhOJWX4fFTTb/8wh59CpPbOiPEm5dIjTc18RuIaZSmE2h3jTYK9gcZejYrB+s1G+9jhqSXsabvFhpDcXNRSmwgVzxcAO2SeP0fYqS9dTb7GU7j4xmD8r4cVnSUp0J7sSt6UOGp4EhLFPCWkaiCxUKGLYTi8CuMz2Un+rR5luSt7KQ/a+1b3NW7oZ+BSe8OXfWr3gePPD6NTdG16+qgklOhyUUuEN1Zg2BkOl0kCaBIE90XD0GhDrurqvahQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=es3FCaWe9CB2Iv7eK0u0YrVXav4cuXehKL5pis9oEEw=;
 b=HUDZpN/Qg1yZqwGRCFigRso7xPh08GhY1Bfzm/NjVUC0qGsjI98ds2ec4RshE8HmENsk5ZwVL6lq73A66xdYDzmH1BKRaG0ioAWYWCJX2r6I0YTxsVM0zD+YpG3W++6K9f31Pk5IxvXAJ+8Ems5mS3idpaHTWTb5Wk5sxXIeaOGVBibxm+96F5vswBqLkhwKpg6j/usw1uagi5yb4s+3UePJ+/+eDUkn1oKfMNxtrQlhPZ1RUkzvFXo2BLMjPt7vSuit02IPPBHie37HjIPEjP04j7gbdWQocOpDI8bIw+Iy2O76m4xlS+fgcvdfIMIKgBuISFKiw4wYXeJAHxWTOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=es3FCaWe9CB2Iv7eK0u0YrVXav4cuXehKL5pis9oEEw=;
 b=u7OND77v7dcnW+ZZQB81xegxcnWbkc2JCJf6CTserfYpgjJdAT98EmgcoSPgZrMEoE8zRQMVUjO5zsevklgZxXRmwUQa2mOpTuNqlnWDSablmjxTuvGpbJsVusdILssI4YRwI/NdVF1M4+3hwOzQd1rA8ArtY9tjFa9gAQ5252c=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SI2PR03MB6520.apcprd03.prod.outlook.com (2603:1096:4:1bf::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.19; Fri, 15 Mar
 2024 08:17:04 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::9756:b4e8:ff47:55c4]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::9756:b4e8:ff47:55c4%3]) with mapi id 15.20.7386.020; Fri, 15 Mar 2024
 08:17:03 +0000
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
Subject: Re: [PATCH v1 1/7] ufs: host: mediatek: fix vsx/vccqx control logic
Thread-Topic: [PATCH v1 1/7] ufs: host: mediatek: fix vsx/vccqx control logic
Thread-Index: AQHacSahZz1lcJjAtkeKwnk108X6z7E4H/cAgABgBwA=
Date: Fri, 15 Mar 2024 08:17:03 +0000
Message-ID: <3f381e4e722f5d3c6e6b942dae1ccf32cfa9acc3.camel@mediatek.com>
References: <20240308070241.9163-1-peter.wang@mediatek.com>
	 <20240308070241.9163-2-peter.wang@mediatek.com>
	 <e84ddf57-566b-4f1f-9357-07b983ba28e6@acm.org>
In-Reply-To: <e84ddf57-566b-4f1f-9357-07b983ba28e6@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SI2PR03MB6520:EE_
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4QzP5+GUlXE6Y+BAxKZ38K/EGgpf1Jw5q8FauiB7YRFndGkH8yyoicScXzuIAV5gtgsHf6a9K3w03hUFCMKCG1FqNqoQinZbA/pfQ5/rglZNvdw0OHkEBb+YU8klf9PKaxRbxDyIILemJfkr5VT9ag8Nk2gielC/NZnyr3o16dvO3KK/nfCHfEH+rUcaiCjPZt52pc+6Vi2QO8X32CQ0fvGLbfrp4t3RUxR33UJocwH2ckfeQE1p5J7xMzMTxqg3jn7sFzpG9UoNEXwXzQsTAZvOdLFdyIbjzD6HAdwEXn0sSoXfYL9+I8fN6lOCKZzjacDogXt72aHym5avSNjQBhvT2oIkaIphs8gyZbabJoiTTYc0XpUkBf8Is6TcJ5Az8EUi3j13OOJfEx/tz+eeT0AwTo2SJ97E2WR9wJ3p1R6Ml/HIOdpW8HTDKtBoZCoD6xyZe+zUjMYTI6pIOMgNtdJ0B97YW1hLxJiOwJcDehppOjc/K9k2bWXjQCiH5+wraYj3pTh1BN6EOfFAmFlWfAS6xvyZ6Hm+SD1maVSTaZrRdYk1VyFLjS4nxRytziaLe55FoIb1ZdatcqECAKoposDV0aI2mCVqmzt3URJuC2uFmVB+EjrpBm6U37MVJ6KXFdnQgyOk/jlMj74nheB/TSiQvDMsWZlNB8tHsG2Qw6o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UlhxSGIyaHR0d2lhUXBTaUJqMmtYZlJQY3FwQW1xL2NNMTBWcDBSZEFDUXU5?=
 =?utf-8?B?cFlKWEVmNC9xWjNHTzVxRGZ2aTB6ejFXUnF0aGx5NStTcW1HbFpyT1J5NEZv?=
 =?utf-8?B?RFRGa285M2VVNEZaNW9uWDlYMU5tTU5kSlZjcjE4MUdzRnVDN2FyMHlyaVgz?=
 =?utf-8?B?TkNDZDZLVzZnZjAyLysxVmwwb3Q2QUJJTEZVUDZOUWtEQ0MzZ2ljazRmZS96?=
 =?utf-8?B?eUxVK0JNR29IWUpMcVA3enh2cXJhaUJIVzFLZE8vdUhTSVVLMGQxSzZxeHh6?=
 =?utf-8?B?WHAweVJuMGJWZURybVBiS0NkTkluV0ZZb0VoaXp6WEVsQkFzRnFON3A0L0Y4?=
 =?utf-8?B?NDhWZVFZRXExTkRZd3B1QjVRODNQTzgrU0Vrc25taDN1dFlnTGUzc1NZdVZw?=
 =?utf-8?B?WDZLOFdPZDlWWitwVDR2dmFRaGdnT0RmS1BGSXRnVFYwWkxEdU5yaG1IaHUv?=
 =?utf-8?B?UW1OcXN4VTh4bUZHQkxScEc2SWdKQThIWVFaSEsxMVVGY2pDL0ZuaDRpUkMx?=
 =?utf-8?B?cVRudUxKb254K3o2MldDaU5zeDROOEE5M3pqdjhwTGVyejlRcHhFYURQYmUw?=
 =?utf-8?B?YjZxUEdXY2UwNEhoVDNzQVZJdVZaQTJjME13MHphSjBxSFNMTWVJejh1cVcw?=
 =?utf-8?B?ZGhYYmZBUjd3cGZRSzJGWnVYcERMVU03ZGhXVWlLc050U1RmNGtFR3d0bzls?=
 =?utf-8?B?dytVeVgxNWdZcjZOMDlEZGpDOUx3WXc4VnF5WGZWTkt1d3l5aitxbzdUNHJj?=
 =?utf-8?B?TDU5WWhYK0x3eGtLNTluSUgyZkVxSzgwOUpuRlhpMEFCNitvNHdPSzFVd2ZX?=
 =?utf-8?B?amhLcFNTTFpEa3loTUczNTF2MmNwOUtEZGdoTEhsd2VhWGNnbGlPRDY0QVJ6?=
 =?utf-8?B?U0QrRVZNZWg1cWhyVDNBOWdDM04ybGpydHJrN2ZQRVZ3NnhFQVZjZXB6eEpR?=
 =?utf-8?B?Mk01Y0hjNzQ2d3ZRbFdweUY1V3MvOWFOOFJQR0pERTlpZ2Fpb29Sc3RYVXl5?=
 =?utf-8?B?VjZyTjlDQTlWRnoreWY2WFBIMmZ0TjhTa012TFI0WmF0OHBpdE5KUmtVaUp2?=
 =?utf-8?B?N0JTRUlsVkpVSElWRjFuR1FLU0ptTjE0S3JRc3puMUh5NnRUTnVxVXNSQjVr?=
 =?utf-8?B?bFk5Yk5kRjBvaTQ3YVlTZHNWQlNXMDY0RXhYR1o4dUp1OUpkYVRPM3FwVFpp?=
 =?utf-8?B?SmMrSjZsdWdLdEdXZWduQktTWllRTzhwak1RTkZxSFA0QnhaVGJzSWVlRjJv?=
 =?utf-8?B?TUp0RGlBUVJPbDFuRU9DVnJaM2tzLzh0RmcwNVVPQS9LZmZUbDRnTlAxNDFY?=
 =?utf-8?B?WlpXV2w5bDVsUlBxYWowTkRRTVBkV0wzRUkreTR3YnZWM2ZBOEQzUEpHb3VH?=
 =?utf-8?B?Y2hHblZlUlp4Nk5qSGxrQVZjNVkxeFF1SkRReHNzWmJ4VCtyRHJzQ3JEdGdl?=
 =?utf-8?B?RTZkVzdPa0NvdlpHVXpGWC9NaUNac1RiVDY3UTBMN3NVSHdjVnQ3SmZFbkFV?=
 =?utf-8?B?VXlXdHlLSTQ3R0grZi9mb2pzT20xOUhTZG1jbXg3S0dIRlk3ajBWR3lxN0d5?=
 =?utf-8?B?N0d2ajFiaEZoRm1malNZamdOZDUzK2hZTWhpTmZ2dFBKM2s4a0Y3N25pQXhM?=
 =?utf-8?B?QTA4KzhocVNoU21EMThvcll2UTFQdmVYQ1VyUVFIVFZXUzg3aEpMVVhqYVNG?=
 =?utf-8?B?VWxLVmkxeE1TWXYxN2o5ZG11a1hEVXRyZFF4WWVBR1JmeVU1OENrUjFvRG1H?=
 =?utf-8?B?VGM0WHp5M1hRU3BCNkJ6bmU4L1JlZUFnOEdPUXB1NjBBWFNaWUdveXREbjZG?=
 =?utf-8?B?K1p6MEx5YXpjRHlISmhsUENnNElLMjlNR2d2MkxoQVBITm44Zm9kbHpiaHJr?=
 =?utf-8?B?Y2xBaVRVcjNaSGcyZWh5T0ZqN2ZIZzB3YWIyYWY0REhMZitmbk5Sb3A2SHpV?=
 =?utf-8?B?SXI5cTVHeC9malFDeFpUUTJKNytUNVMvM2M1T3dvTkZqcnEyLzE2SzJyNlUx?=
 =?utf-8?B?NzBWVC80T3pLQmZmZUtzZDE0NEkxQXFSTk9iRi9aWnZxQkFEY2g2bmxpRnV0?=
 =?utf-8?B?cjdzNzg5UEdmYURPVzRIZUNPOEZYdFN4bUFtY0l1UHpiWkV4MXI1Nlgxd1dI?=
 =?utf-8?B?YVlXOGw5aEowRzZxN254eVJ0Y1cxRUsvM1ZBSXdzRTZsWCtoM3JtMnNEOHBx?=
 =?utf-8?B?dWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2C75F7DC1F6B4F42B4440D9C4061F2E6@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60780a07-6bce-4ece-10d7-08dc44c84bdb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2024 08:17:03.6085
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +0I0m/EcjfNI2c3EqHZQ5f5+C5LiKtQrosMjaDpNRUzwJGx2DdWm90oYBdMGq68QRVwW4h7j510I4/pQZitisQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB6520
X-MTK: N

T24gVGh1LCAyMDI0LTAzLTE0IGF0IDE5OjMzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gMy83LzI0IDIzOjAyLCBwZXRlci53YW5nQG1lZGlhdGVrLmNv
bSB3cm90ZToNCj4gPiArc3RhdGljIGJvb2wgdWZzX210a19pc19hbGxvd192Y2NxeF9scG0oc3Ry
dWN0IHVmc19oYmEgKmhiYSkNCj4gPiArew0KPiA+ICtzdHJ1Y3QgdWZzX210a19ob3N0ICpob3N0
ID0gdWZzaGNkX2dldF92YXJpYW50KGhiYSk7DQo+ID4gKw0KPiA+ICtyZXR1cm4gISEoaG9zdC0+
Y2FwcyAmIFVGU19NVEtfQ0FQX0FMTE9XX1ZDQ1FYX0xQTSk7DQo+ID4gK30NCj4gDQo+IFBsZWFz
ZSBsZWF2ZSBvdXQgdGhlICEhLiBUaGUgY29tcGlsZXIgZG9lcyB0aGlzIGZvciB5b3Ugd2hlbg0K
PiBpbXBsaWNpdGx5IA0KPiBjb252ZXJ0aW5nIGFuIGludCBpbnRvIGEgYm9vbC4NCj4gDQo+IFRo
YW5rcywNCj4gDQo+IEJhcnQuDQo+IA0KDQpIaSBCYXJ0LA0KDQpXaWxsIHJlbW92ZSAiISEiIG5l
eHQgdmVyc2lvbg0KDQpUaGFua3MuDQpQZXRlcg0KDQo=
