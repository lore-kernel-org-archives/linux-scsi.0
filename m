Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38B972635
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jul 2025 06:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752734295; cv=fail; b=YPro+sMUmbLru+aY2/UkOQf+1Op6HMtoMU+ndW9DXQb8zEGREukJbM/C8FjM21oXseMU2a2RWrzJhNCbcQk06fXgENDaYC46KzFy3zJjXnqV1orwLy9Wc+aA7YbwWB0ksaurTnSTd2JDRWMYC5hun+bSy1ukiuIdXjPV9Xtq+Vg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752734295; c=relaxed/simple;
	bh=k3TjwPfZdngjL1D2ix8GSpcWSizNIDAUluPNusS9om4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=p7KsN+zXrLcpznSYQrpa1YBxl3OAYxe3PB9iFygbM3t5XeMxvNqWc0GlTFG4kYSGyK6E83Lk63qzDUG5Az6DV4E9Yx7gASplYvFXKjQkd/2s3SuoKo88hgwrO1U5f1xhAZJ0UAjHsM+4qO1eMTr2X+8PAt2kPFK/pQx2EtSB64E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=LivDcD/W; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=CPmehV0w; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="LivDcD/W";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="CPmehV0w"
X-UUID: 95be155062d811f08b7dc59d57013e23-20250717
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=k3TjwPfZdngjL1D2ix8GSpcWSizNIDAUluPNusS9om4=;
	b=LivDcD/Wtq6F9mOr2BYwfqVSJD0z7yE6ud9/3TJvtwGViciYVMzAx8A+xFxlAawJyjW7KtajmoAXOY636w0twiKlKOpgygo1FTo06sJx+oT2p8ajH/B+PVIo3VQ8gBCALAAOHoH6iNf0IGy4mpsZCOYRDSRVP56s76c3XhIXyVk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:ffccec8d-7cca-49f4-b899-c68922f2dc40,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:17908984-a7ec-4748-8ac1-dca5703e241f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 95be155062d811f08b7dc59d57013e23-20250717
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 351144371; Thu, 17 Jul 2025 14:38:01 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Thu, 17 Jul 2025 14:38:00 +0800
Received: from SEYPR02CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Thu, 17 Jul 2025 14:37:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wCXtcnuYucmrGOXgDaLl0ZAQidXQhHjb53tXrJZOn5pupfRGAYYAkxpwqjjSrNGvHy5wjX4f/RecdQZoHesDfbjnHQ4uXDYdrW2POqjEifeP3bbCE6kBkNJQZLubhd1Y8s2C/2qYpGsU3b7+Rw5cO5YXDRvFwWbncvvD2lGugFwufCqkRw/V/R3mLQr7zqtHJzzUURmLGHmSIxJwbTd1xWDu7FAJJ4M8R8du5/GhoQS/eXSoDRk98MwGSGhnMp6eVPGxhLVwWJzy/nW0K0KpyUnVrT7FubrAnMRhK+oPWNPq1M+iQCe4ex8WgiNB3GCnyz/WfMoG2LCf95q8+jgvbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k3TjwPfZdngjL1D2ix8GSpcWSizNIDAUluPNusS9om4=;
 b=OlK19VPIED5VcGOt4/eIL8zGYvTnlf9vF9G/fok11kZOKD985NGBu1/wNapw/pE8+oVslLN5T3iCjxc6EkMSgJKv1AcX39tuf6ZsjVjy7zO/uRhT1QCtsSkko7h8yWg76RI3WEw+WfUCSYFXrC21xqafYlqamJD5zdmM4J7B2ygMH7t7DcyQ8DblYWbozGjuiac4dOJCKeOxFDX4M7uvyPdBoL8L208AhwKy+YwfpFKxoQsiU2A0A2rutKcjhQNAkV4apcEALfoTEkSEVtfo6X9fja2kN7DJ7OkqPBIHTyrmngfkszhFcT3xMHAGxEbavZD6pOrm7rEQAI/NqctBhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k3TjwPfZdngjL1D2ix8GSpcWSizNIDAUluPNusS9om4=;
 b=CPmehV0wW8KpfYqboi9/U+qzE/37ZBmuC1jXF1p3Rw3niG+sb9L9SjCqLS+D1namhN53CKDfUwgBYymUrwaYsmQU/ApBdT4iFknmh9viy/1qiJ612XASyC9Aw1DQvZ1J9mLad8pJCk+MOmwp0T6552UoSN99m6luFo5NZbCz2tU=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by JH0PR03MB8336.apcprd03.prod.outlook.com (2603:1096:990:48::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.28; Thu, 17 Jul
 2025 06:37:57 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.8922.037; Thu, 17 Jul 2025
 06:37:57 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
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
Subject: Re: [PATCH v1 01/10] ufs: host: mediatek: Change return type to bool
Thread-Topic: [PATCH v1 01/10] ufs: host: mediatek: Change return type to bool
Thread-Index: AQHb9hr4EuXwCuNiPEyOu8dVzcFIM7Q03fEAgAEAgQA=
Date: Thu, 17 Jul 2025 06:37:57 +0000
Message-ID: <c82877e4d1c1f8f7bb39d0ad7dccd4cbec0c91bd.camel@mediatek.com>
References: <20250716062830.3712487-1-peter.wang@mediatek.com>
	 <20250716062830.3712487-2-peter.wang@mediatek.com>
	 <f3679ca4-9c77-43cb-a0eb-a4915f0f2c3d@acm.org>
In-Reply-To: <f3679ca4-9c77-43cb-a0eb-a4915f0f2c3d@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|JH0PR03MB8336:EE_
x-ms-office365-filtering-correlation-id: 1b85d216-3bcb-4825-bf82-08ddc4fc7793
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZGROUkRNTTJpaG40STZVTk52RGRvNEFVSFlteEVjODBOUkR6S0hwRStDSHU5?=
 =?utf-8?B?dFQvcVgrYVFlVWRVK01HbWQvWFJ0Mk9YZ1pzUDRZYmZkY1lMQ1JqRDF4bHhl?=
 =?utf-8?B?aEI3WFU2WGNQV3QrZ2FsN2ZlQXFuSmxZc2dnNGJ1TjF4bEtNcVNNZWxuYytC?=
 =?utf-8?B?R3dNNEhJaXdSZ2xtc0gyVkplN0ZhbjNJWWVVaFFpY2RQY3pPNzg1NmNRWDBv?=
 =?utf-8?B?ZHR2TktueE1BTHJUSEludldIaHMwWUZWcEsyTlZzaUVUQjhDRVhnKzYyN09B?=
 =?utf-8?B?RzNzbVdQTlJkL2NtUVRuamJNTjc4ZS9qTUJ4ZDlIMmFZVVd1UldLR0ZDNFJv?=
 =?utf-8?B?SEVDYU5YT3d3OWNtQ1NyMFJCLzZoZC9vMFdGNUg2SFJvek0yb2c0b1V0bjRm?=
 =?utf-8?B?WmJoYUJoMWdVckdLRlM4dGVDdEFaUlJQeFRQTk8zZXJxRzJ6U3ZyUFMxRnlG?=
 =?utf-8?B?bitVNHZlU2V0RGREUkU2NzJyNlNtTTNUT3pSTlVjaVppT2RkRm9ZdGQrVG5a?=
 =?utf-8?B?QStGYnFYckJqZDJ0Wll1aFBmeGd6ZlZNWUpCWFI4Y2piV0VCZ3l5Znd4aGE2?=
 =?utf-8?B?ODZCU0hwQS85NGp0RnlUUkVaS3p6YkpxYXdHbEN5OEU2aTUycXhxNkRnTUVl?=
 =?utf-8?B?K0dFS0lzQ2EzQW5IT3pHNm1Tanc2bVJiMXE4aWpuVGM3OUVJN3dOMnIxbDZL?=
 =?utf-8?B?eDk0YXMyMmxqbEZBUDVMNTNSNmdqdDBzdlliYktuZ3NDU2NNWHpBNjhNb0Z1?=
 =?utf-8?B?WjQ4N0IrcENSR0hCUyt5b3p3b3NPbWxJV2x5VVRwUWtYRjhJNXo5OWI1Z200?=
 =?utf-8?B?MFd2NXRVOVQwM0Z6c1Q4Nzdid2RKa3o5U1UwMmxaSTg5NGRXajBzU1dpbWxX?=
 =?utf-8?B?dlhrSFM1Ulp0K1RIRDRvMDZESERoNlFrYXAyck84cDNYUUpHdHg3YXBMYkZH?=
 =?utf-8?B?THRJa21mZkhHNnJQdWNQdUFmZTdvV2x4MUlnQ3VidjBKTE53eG5STy9UcGpm?=
 =?utf-8?B?RkVsUlVuM0FxNkpjVzNsTUUyVy9xejlyT3pBTEJYWUV1aktmZ3MwcjVNOHdk?=
 =?utf-8?B?WkVzR2FSdXpWdWh3LzNqUWR4aWhaTXpibmdwZ1JxQytKUTBybnN6QzV3MWdn?=
 =?utf-8?B?SFNUeWZzSFpSUXJhOWlJMVdoZng3Tk1LLzBpUVpUSms2UUJkYlI5NjY2MmEz?=
 =?utf-8?B?SDM3VTlKY21DY2ZHSUV3QTNXYVcwSittemRoQlNWL1JOL0x0WFZwY2hubm5j?=
 =?utf-8?B?ZUY0S3VUcG5RaVlDd0xrMHNKc2wwdjc1Zy85RXBBazRTTW9wYjNvT0dSanRa?=
 =?utf-8?B?TFltdXp0QWxyNWg0dmtsUS9VS1cwSE95S1dhN25iSGpjKzhxUkdzZERmOHJr?=
 =?utf-8?B?SlFxOGpGTEJqZTBpZmkrUk5KaHk5WXAvZlRtVjh5L3JaQVI2U0tVbUlWRzFk?=
 =?utf-8?B?Ym1KdUdLcUF1aDJhRkhxYmhwTmVJdzdJR1dNejNuVDNxRU1hUEQ0RmFvY3pS?=
 =?utf-8?B?Z1VxTHpTWWNCUU1jb2RVZ2lKMWFmVFd3bFFiOVF0MTl4QTZhQkRWYlZDRzY2?=
 =?utf-8?B?OHlXUWhLRjB0KzVmZ3QzditoNmJJWVJtWStCMXZDblhyRmlwc2w0VmZUTkpD?=
 =?utf-8?B?ejQxVWRmbEFJZER3OHZxVHlSdEpEWjhLZHFUR0NYVXFSb3FneGhPRWN5c2N4?=
 =?utf-8?B?Y1poWFM5bHlxcWNxd2NjZDBPME43VWdTcHRsZ1RlSmsxMkNkUFJjWFBnRFRj?=
 =?utf-8?B?QU9LU3hiNTBzdEFKOFN2dUI2ZDN6VFdzeW4wZUJJdDRqVmtrNGUvNkpoc3dv?=
 =?utf-8?B?MWRWNWZwT3lqckJLZHZabncvb0kxQU5HaGxNcGMrbjBvbVVGTU9KSi95dDY4?=
 =?utf-8?B?Zjd4ZytXd005N21xZm1JeVEvcEs2b1FCd3RXdE1TOVZqVnQ3b3hiWGpOZXB3?=
 =?utf-8?B?OVllM0NPRWhxZUlEVjc2TGU3RGQyZHZzVitQUHMyeG8wWVVjRUI4K2xLZGNK?=
 =?utf-8?B?RUl2MFRvd1ZBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VUFBcGVMenUwb1Y1ZTA0MENZWlVuTE8vY29uM2tURTQyMmpSSlVCUkhNZm00?=
 =?utf-8?B?eWhuOG95dk04NzBiVkdmVGJaQ1MxUzNXZFc4UmhsbDliVkp1a0ZOdVBIQlJz?=
 =?utf-8?B?clNSbjFPNThQVTBCZ295L3BueW4wTTM4VWtRVWdJeTdxRkJDUVNpN2EreGxq?=
 =?utf-8?B?WjJaaGh4TU9FdWt0UUsyZUpHdGJZT3BzV1VnM0M3RjRRbjdkWHhQVjROL0tF?=
 =?utf-8?B?N0FHT1F3dWhHcm9IbmJidmFhQlE5RjdLV1VSZisvaGUwUEV0bFBZNC9UVGZu?=
 =?utf-8?B?ZHRvOVUraVQxejk0YkR5bkhNcjJzY1Jsc1FYSVRvUmZZdWpTaTY3Q1JZdmdH?=
 =?utf-8?B?MWpWRTRXS0FIcG1RdXhCekltTmZueTBUYW5Ub0lkVllIMTE1THl5SnU5U2pP?=
 =?utf-8?B?dnZHTW1CUFRDNlE3aGcvOUp4S1h4R2FTdVlPVVNraXZraE9TZXgrK3gwYUNn?=
 =?utf-8?B?VWh1TzNnZGtTVlpyVTErakVqS1VIOUd3aHgyL2t0UXdaMjZVQjhUOHhCU0o0?=
 =?utf-8?B?YU92Tnh1bHR6MGZIYkc4a2NJTG42Z1hCZjFVTWwrR0dXcnBnZ2tuNUlkbnV4?=
 =?utf-8?B?MUtzc1VBcVA3TmVCQlJzUTNuU25BcVlhNGdPei9mcXlrblE2TzdqS2xzNngy?=
 =?utf-8?B?ZnU1QzVqdzdlMmhUdVZYc014bWVpaE5tMkVNVEdkbXBwKzlkWUJYMzNlZVQ3?=
 =?utf-8?B?VlBMYkRyZ1k4WUJhSE1taEZET3dKS2J4R1NEY1dIUytCTzdVb1VycXNGOUVQ?=
 =?utf-8?B?K0UvZUVUL0VHaER6TVhYbnV4allIQUl2UWpITHNPcmtlMVlRTGF4ZWJRZmk3?=
 =?utf-8?B?UGZWSEg4ZXpRWkJwYW10R2I5b1RhWngzcnZ4TVdtbEQyT2RRNlM4TnFnbjUz?=
 =?utf-8?B?amNDRmRkK1hsVzhWblJRdW5takNxc2tCTHVsbERKY1JXdnZNL1UwSGdzcFhS?=
 =?utf-8?B?VlNXS1hwajh3TmtYd3paMmhLc1Z4VG5ER05QeEI2cFNXODhWbXZ0VnNwOFVO?=
 =?utf-8?B?N0YyTEVWSy9SU3NxcjBjdXpKTjRJQUxSczBuTlJYTVRmV0I4NWsxTHlnQTVI?=
 =?utf-8?B?MWlvcFd4Y242NUdwZUxCcGVpTDNyQUJkcGVqM3NmYjR4a0tlSm5uc29oOVVt?=
 =?utf-8?B?cXVhcWxhcHVIVGxHU3FoWW03MlJpV1g2K2xjamtTWUpxTU8zeUtEWUJIMnJw?=
 =?utf-8?B?UEF1Nk9GRGV6MUpxVjVkNTFtT0VwSTJEaFRwM2FPaWhqL242aTJSQWNDWGRM?=
 =?utf-8?B?L0dYT1F3K25yQ3FyN2YwaFppdXhVaU0vekFyUXRha3RXRkxZTHZPM3BBdW52?=
 =?utf-8?B?NnB4Mng5ODJ6am1rOUY0TG9YRjFsOEs5RHA1N1ltcWdKbDBweW9OeExpM2FD?=
 =?utf-8?B?QkRySnZjdk0rNmRMRm96WHg5bk5Nd1NEV3dwdkQvMlJHS3laU0VqZCtIUkIx?=
 =?utf-8?B?OGVLZTE3MWhwNEd6WFB3byt6Mk56cTBIUDVORkhFeFc0NEhDaWp2RTR4clZF?=
 =?utf-8?B?b1h6V2lIamg3cFFuT25TZUg0N3VVK2hhSG1ZU1FKbmlKWTBBd25rUmJCZFNo?=
 =?utf-8?B?Mi9lcXh6ZDVzdlczZTJiajVNc1h1OGIvWGVvMGlFRDA1dDBvcHBDayt3TVNF?=
 =?utf-8?B?TGhQdVpjaStLTW5VcDJFakdWWVRQNFgzaEFDODlyU0lHTUJMdXJGRFFqVzh5?=
 =?utf-8?B?S0ozaUxCcWZwK0tkNEhsRmpzaUE1YmJvamhRdGFGS0F0MVF0VzdSSjdzRGNk?=
 =?utf-8?B?VnpURktycDhDdW00ZWJONG5yUEJ4UGRSeVhUSTBVNmdBd2JkNzNWTzN4VytN?=
 =?utf-8?B?MUVqUi9lR2svZ0d2R2tzdmlJME50R0dERk5WMVpLTnBDK0RUaHFKTFUxWnR4?=
 =?utf-8?B?eTRtSkJ0dTRpZUJQQ1F0aHdtdXBiekk0RzY3ak1IKzY0Y0UzbzNrU3ZWMWZC?=
 =?utf-8?B?cGpYTFFhMnUrWkpVZlRBWS9LUlBOQXhUdzBFLzdVZ04weStJV3ZUU2NJcmRG?=
 =?utf-8?B?aFBzVFcyamphTm9ldW5uSXhVdlRTYlYyUkxjdnlLd3ZBWmVFWURGQmlHZnVs?=
 =?utf-8?B?Wk9UTmMvNGdkcGRXM1dOZ0d2UHBaV0l4WlkrQWJpdXZGdGlwN0JVK0I1WEUw?=
 =?utf-8?B?aGp6eUoySWZQME4reUtNZ1Vqc3EzR1pCSVR5MEVKWFB1S2c4SFFqSlFsbUlw?=
 =?utf-8?B?ZGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C56594926BEC54B8642EEE2D62C75C4@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b85d216-3bcb-4825-bf82-08ddc4fc7793
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2025 06:37:57.3181
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MEegnAcy/DwwStIHbWAsQ8N6/oIdaNPVaVrc9mD9DGNBvXHckSXcwJgRIEguN998DAzvr8QWL5fEQmyCNf2zpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB8336

T24gV2VkLCAyMDI1LTA3LTE2IGF0IDA4OjE5IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRo
ZSBjb250ZW50Lg0KPiANCj4gDQo+IE9uIDcvMTUvMjUgMTE6MjUgUE0sIHBldGVyLndhbmdAbWVk
aWF0ZWsuY29twqB3cm90ZToNCj4gPiBUaGlzIHBhdGNoIHVwZGF0ZXMgdGhlIHJldHVybiB0eXBl
IHRvIGJvb2wgZm9yIGNvbnNpc3RlbmN5DQo+ID4gd2l0aCB0aGUgcHJldmlvdXMgc3R5bGUuDQo+
IA0KPiBXaGF0IHByZXZpb3VzIHN0eWxlPw0KPiANCj4gUGxlYXNlIGZvbGxvdyB0aGUgc3R5bGUg
dGhhdCBpcyB1c2VkIGVsc2V3aGVyZSBpbiB0aGUgTGludXgga2VybmVsDQo+IGFuZA0KPiBkbyAq
bm90KiBpbnRyb2R1Y2UgYW55IHVubmVjZXNzYXJ5IGV4cGxpY2l0IGNvbnZlcnNpb25zIHRvIGJv
b2wuDQo+IA0KPiBCYXJ0Lg0KDQoNCkhpIEJhcnQsDQoNClRoaXMgaXMgdG8gYmUgY29uc2lzdGVu
dCB3aXRoIHRoZSB1c2FnZSBlYXJsaWVyIGluIG1lZGlhdGVrLmMsIHN1Y2ggYXMNCg0Kc3RhdGlj
IGJvb2wgdWZzX210a19pc19wbWNfdmlhX2Zhc3RhdXRvKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQp7
DQoJc3RydWN0IHVmc19tdGtfaG9zdCAqaG9zdCA9IHVmc2hjZF9nZXRfdmFyaWFudChoYmEpOw0K
DQoJcmV0dXJuICEhKGhvc3QtPmNhcHMgJiBVRlNfTVRLX0NBUF9QTUNfVklBX0ZBU1RBVVRPKTsN
Cn0NCg0KT3IgZG8geW91IHN1Z2dlc3QgcmVtb3ZpbmcgYWxsIHRoZSBwcmV2aW91cyB1c2FnZXMg
aW5zdGVhZD8NCg0KVGhhbmtzLg0KUGV0ZXINCg0K
