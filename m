Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9305ED272
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 02:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710470360; cv=fail; b=LVv1hptHJPp9R261pYQc7tncXw7HnzbIijwQ3lAhGXY7ddjDfJOkJ4tlGnAfUIqzat/ee6o4Fr89XLAunz0mBe4WcbowBJ3jYdqhmMlZKLKztFQs5wNO/NFKhZuKvtWYTc8CFFo99D+bvCJEElGso9oJ5uE+fZna/31kvQH/vDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710470360; c=relaxed/simple;
	bh=Z9E5GJcMeH2DKKvWt6fNLqbFWurHm/I8XplCiOcqfcs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Pa8mWAEMOr4DVflQRXFhwOLMnjR4aIqUrL2TG22j8ebI060uS+mrg0ZwbY0oFz/BkrXUMoJFPeXnMUhTrnfzDjGKdx7A5VW5WYvrErfgmuX9/Xn/7ggdFIh5HsjPd34Hx4qt8Cr4nwTF/GYwDkkadLaTVIGJmXW6KbhkRn6cHok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=bMQOXKuo; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Lk4xm4fj; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="bMQOXKuo";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Lk4xm4fj"
X-UUID: 364a6158e27511ee935d6952f98a51a9-20240315
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Z9E5GJcMeH2DKKvWt6fNLqbFWurHm/I8XplCiOcqfcs=;
	b=bMQOXKuoJe2DE6pK7reR2HlhvaqIU8O0LWIJjGQelmDHbLyuKsoQoy6KsSjerp5b1/5FFad8w0At9mwYi7ZOjRacSd9pyr5QOf7PmDae/V9t/Czwfjm3GwGwmQGa3v+pIDcYRWh8PnJF7lqQpKhWzgVvnyH8HTMAgsfTD8SvL4c=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:4f7f7698-f69f-4ff2-9515-27c1fa46f01c,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6f543d0,CLOUDID:bfc1eaff-c16b-4159-a099-3b9d0558e447,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 364a6158e27511ee935d6952f98a51a9-20240315
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <chun-hung.wu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 889253873; Fri, 15 Mar 2024 10:39:14 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 15 Mar 2024 10:39:13 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 15 Mar 2024 10:39:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=buQsPLJcRK0cr0DKpyG6ftoR23oSgzIKBjJbQUoVCSz+SFrz0K3kQfRzWbhg2EdHFKtjB1dJHIIhvLEeihJtHDF+LBG4MhE1mMa6H2Mee1U5/l9X41Wq2b0PzVhHcKEBqUmBRr4dozPSPm0OvZDk+fQ6Wonct+zVxjdink2AphuzRYpzun+FZD/P9NtQ/OVZVAsqDafvGP1DYezePiDRiNyh4oIVRzEMWzW0jhO7m5m/l41eCy7ZfI/RiYs7/Q+LHLZ9Ilm+HLOFPqEoOogqsHPqeqPhhO7ceYh78vqfu9gXxHAixbOJljG9Ow1UVIn9Le9KZ3/BjgmQnfKrP2v65Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z9E5GJcMeH2DKKvWt6fNLqbFWurHm/I8XplCiOcqfcs=;
 b=aLtY7pj5X/zGnSjryr1PKNdbF7mbOnAg0+vc5A1y528qCBVuMJ/pHaeFqARL7XlWG08A/Di2m2KEFpK57ggfCNWHjmua6VCTqNoPXolZ+XozEicJwmEhztp0bzbvI4iIeNECV+JS8InGhgjzzFLsuVVnChrfsbFQicVHMGWQDxtR9iJU6K6TTnl/XPMqFGIGT3TqJmXmh/1bsedM7YSWaQGsrzUdqarv4K1YAbs8yaHfAgGl9oz6O8TSMIaoDyfEkJvvYia+EVlAecMZ32XFs02Bm/1jccgtnty9jxgVZ+3kOMbxWvQpBbhGT6VwsKGIRel1686r10Kkv3QKtUDtJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z9E5GJcMeH2DKKvWt6fNLqbFWurHm/I8XplCiOcqfcs=;
 b=Lk4xm4fjDosv3o2Y3q99uYg28WQW0Z6VSp/E6d2Bqr0dxeafqtztIF4IRWHScTQZsRd0rgpxcdexEaonhRu/iz1mazHRfvsUgScMNyE0dF9r30DTKisghnITZg+GtgpkbiOk8X8TGP2JJjiclRQgmn25ucogQ2+h4G7p15k0sZ4=
Received: from TYSPR03MB7350.apcprd03.prod.outlook.com (2603:1096:400:413::14)
 by SEZPR03MB8322.apcprd03.prod.outlook.com (2603:1096:101:192::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.19; Fri, 15 Mar
 2024 02:39:11 +0000
Received: from TYSPR03MB7350.apcprd03.prod.outlook.com
 ([fe80::913f:a95a:231e:cd2c]) by TYSPR03MB7350.apcprd03.prod.outlook.com
 ([fe80::913f:a95a:231e:cd2c%3]) with mapi id 15.20.7386.020; Fri, 15 Mar 2024
 02:39:11 +0000
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
Subject: Re: [PATCH v1 6/7] ufs: host: mediatek: support mphy reset
Thread-Topic: [PATCH v1 6/7] ufs: host: mediatek: support mphy reset
Thread-Index: AQHacSbCE/yc+N8qskOJtU4Rx07rAbE4IZ0A
Date: Fri, 15 Mar 2024 02:39:11 +0000
Message-ID: <34945346dd7cc3bdcaf3dfb474ddc81a67e926ad.camel@mediatek.com>
References: <20240308070241.9163-1-peter.wang@mediatek.com>
	 <20240308070241.9163-7-peter.wang@mediatek.com>
In-Reply-To: <20240308070241.9163-7-peter.wang@mediatek.com>
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
x-microsoft-antispam-message-info: WcvjvpaC+hIyOO/8O48SY1FoAeOt4NPNgT5PlQ6nBm44cXg9Uul/ejFFB3jfT7DtMrwJQzsCaoeT+khsbtTdfv2EUWu3YYhjRXUZbb3K/ljh1T0D5FW1kgb4cYuTlrhPfYin7a9ilCq8D85PcFWaURYUN4BH1c0QnANpKB+Of6no5wmP3CcCYNC76wQUWT5gN+M1pV8Pvko+6hHEtaK7YadZFwoAcoxyFYmL4JHwh6eh3GiEc7T7Ebesk5vIwGG5ci0PpQRtOQYazcHMkEYL8+V+EoOMm8vQayHJ5X8HcGYoH2UmSetYT283sVHa8+eMD3dfv0yVls+lVC0lFKZvWWSizjh2pPZpai+CY0dqIuFHT4UqvKwZPZgIILnq+SGvdlvujLHDkMBE28VM5B1pYuOl3wP9/bdcnsA/QEXq3ALoxYEyr3fTsG+3p80YQdKiljDjJLaUOpllPK9K2xr6IocOMBIdc8Gy3kX8tnPw9xLv8dCCpxXYg0YL4fKIOs+gwyldddFL40YGKwG8rduKOAhVNiEly1MJpViJFyWkbT+92rOgRxusDy/gdh1LnvguGU1oD8omcUdO6UAqUY9DfA6flQmeNnigPu6Y+MAZRsQqeUnqUh8DHZ+TCLBe9WFfKdiHfAA5zt36lKk4u3Vf6b3l1+E5pjmN/BrU2w1uTVY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR03MB7350.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cVBTNER5TWVPbHY4cDR2OVZIQjJuS0lvVW8zQ1FKWWlWOFdrTXVVL3Y3SG8z?=
 =?utf-8?B?OTJ3TkFWRTNLQUwyTGxVQnFBdFpNNzhrNXh4azd5dEYwMGsyZ05ISTUrZkR4?=
 =?utf-8?B?OXd0R3JlMUtUQjZlc0lqWkxKeEN5VTlxd0VlNHBhOFVaRElrR3pxcTI1SkZk?=
 =?utf-8?B?UWN1Nmw4T01BZXNtNER4dzA1d2RpMnZtRXlUd3haTDUyWXc4OFJobGcyZXFP?=
 =?utf-8?B?UExxRlhETWFZMnBpbmhnenphSDBaUjVXanVpa05DNlZXem1QdWhSWjFQOUw2?=
 =?utf-8?B?c0F2d0QvMU1nL2lmVHRGMTlidGpiWUZNYXQ5QVpKVjZuYUo4M1hVaGZiTDF6?=
 =?utf-8?B?SmpZemJSWmZOeDNlUjFHNW1sVnMweFh0MlloYUJubjdFOVVQSlQxZUI2R0E2?=
 =?utf-8?B?MWN1eDMySWd3OC9LUWVoSHR5bVdUbGNLKzJmTlFxWVkybFBXL05LRk1xSjFP?=
 =?utf-8?B?RDNRM3dUa28vN3M4aTVFVWNXSm81MHZhWjk1M2p2ckhxTTArTGxIVmhJVUNR?=
 =?utf-8?B?U2M1cmlicUQ1OW9OWkNlQ3N1bzRFa2NMV01sQnhSWmI2MW1QTnRodFZlb2Nw?=
 =?utf-8?B?RVlwaHk1RTRrOXo3VmxmRlVRRlZqTlhzU2w0VWwzajBvaC9VZlFsYUJiYjhv?=
 =?utf-8?B?bDB5MnJVUWhYWUVwdDRNd3hRdnIzZ3pVMnZaNkVEeFFYVm9pYmtaUy9jTjhX?=
 =?utf-8?B?and6bXovK0ppeERwd05UTkk5YzJsSUo0ZER3d0dkUUFZajl6VnU2RTJDOVdj?=
 =?utf-8?B?M3JLTkQwcE1qL0FpaHdtK3pDcGxoOElHV3lScjFmRzJVcGZqckdrcjd6amFQ?=
 =?utf-8?B?ck5PaUR5cWJEYW0razRpam5VK2UyYXluMTRGNlNrc0RoSTBHVEpMNlBnNnZr?=
 =?utf-8?B?bXVodmlBa3krUGJjckEyS0pCaS9tdERYSXpOeTFjZDl4LzdycHQ2RkxYY1Zq?=
 =?utf-8?B?akFRd2dQRytScEpKdGM0dWZWNzZOMGNkVDF3blVDeDdxbC9VQU9oSUdOM0xM?=
 =?utf-8?B?ditpcXlDeVlndHR3ejNmeVJUUkVabUlTS3A2VVM2WXF3c2xVRlhiOXRTUzRI?=
 =?utf-8?B?SVErWUtxMURlNmdWTVFOWFVBN3M1TGV3S1d4M3NjNi9CTnhXcVVWdG1NRWJh?=
 =?utf-8?B?SGNSOVdoVGRTTU5XOEdSeC9iZ1ZCR0VwYVlicFhLTnZiRmw0dGZCQkdoYndj?=
 =?utf-8?B?ZnFjVHlUWktwL2xRRHVwL1hwT2Erb0lLczlOUGc3SzIrdStPUkdiOE9KUTB5?=
 =?utf-8?B?SUY1THZrNkgyR0taY1VhZFdqQWZwN1grVFcxaVp6by9ubkFxWWV6T2s0emJn?=
 =?utf-8?B?dnpBYWtmOGJRYVQxOW5RRHVvN2U0b1N1a0I5T0pPaTNZSjlETHZNT09VSlJq?=
 =?utf-8?B?QXBmMEM0WG4vSUNJcFZ4bUNHME1nOTVaSm1FNUFGTnkyb0ZSM0laclp6RWQ5?=
 =?utf-8?B?SjROcDhSMUdtL3FsSzB5d0VZTDVudXh6ZXdCK2pBZEswbk4yS0hXNGVOT0tP?=
 =?utf-8?B?eUFMa3NSSy9WZ1NlV3ZBQ3RTaGkydDRGV0VDUlJHWVFZSzZlZjNtM1oxQy8x?=
 =?utf-8?B?bzVJSUpNZW1GRXdxQWJJcWo1cjBxeGZySHRwUWVSRmQwOUptNGJxUm5IYlBV?=
 =?utf-8?B?ZFZuM3R0cmcxL29LdzAzRkxUWDBxdllyd2wxZi9RMHF6TnJ2Y2Q2Z2hIVTBG?=
 =?utf-8?B?dmUwNmxHRmJjdGliS08ydXFDZ1JkRzcwKzhMRUdJZGZiUGxaZEZ6ZDhiQzlR?=
 =?utf-8?B?YVFJWmxud2hiVXZYL0tQNVZkM3psNjhjamJsdEpWWVVqdGdxK05uVjRJSXJX?=
 =?utf-8?B?dHk0eC92aklLak9xbXhOdlZwL0dxV1pSQ1hpaHdFYXhacml2U0pvOXc4T0pW?=
 =?utf-8?B?aVMrYVlMVllhc1dRTUhaSEhRSWVXNW1GRThuamlvV3k3V0hFa1ZTZld6aTlY?=
 =?utf-8?B?YVBFblZLUGNDUndsdjNRVTFiSzFuZ0JkY1VydEhxbmpTTHAvYXY2S3E1T0Rw?=
 =?utf-8?B?UVp4c1UvaTNZS2hDNjlxamVPSWp5RlZ5OVRZc2E1TXVUTGhTY3E0OU5sY050?=
 =?utf-8?B?c2FmY0JtR3JIb2ZVY1dnc1BwWDhMd1JTdFR3R3d2dEVHOVR0eFIzUVdHZC9V?=
 =?utf-8?B?OU1lb2lSNWJJa1VJb2ZQVDJaYWtKTFVjU2UvQzMyT0xEd3V4R2ZrRVNGdlR5?=
 =?utf-8?B?MlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3A84C7211E22484D8D76B01716FC4B3A@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYSPR03MB7350.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e697ed8d-907d-4bea-3bc5-08dc44991880
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2024 02:39:11.0919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eC7YF+DtewIzrwJbgIz2zAx738JXRST2MzurXCMjzRqiA7wKF8e8ZFpOb6tMLUoCSVhvjnX/19CFA8HJYaIwVjHaV1CVyNxk4RPZNJk/bxc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8322
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--9.271200-8.000000
X-TMASE-MatchedRID: TDQWNTPftUDUL3YCMmnG4oei/mZCYVwugDRlwc+wR6cNcckEPxfz2IP+
	YDa/Dhu92p/aaR/nx05isDrIDgWLgIJrRWPc34Z+A9lly13c/gGuiRuR9mCaun5h6y4KCSJc88y
	Ax0zkDh7IrNi4B9W0wg39mrk48Dt1Z28ZQS4q9JwZXJLztZviXDJcsSAcBZLamyiLZetSf8n5kv
	mj69FXvKEwgORH8p/AjaPj0W1qn0TKayT/BQTiGm77KDBx5uGIO/0MxHPHekhpS2Z55KUWSdmeZ
	blmF9pdSJwd6cndV7U=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.271200-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	453EC74D665777593DD44630E1E4133EE59ED92A591DDE83F520CB488C2FD3EC2000:8

T24gRnJpLCAyMDI0LTAzLTA4IGF0IDE1OjAyICswODAwLCBwZXRlci53YW5nQG1lZGlhdGVrLmNv
bSB3cm90ZToNCj4gRnJvbTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+
IA0KPiBUaGlzIHBhdGNoIHdpbGwgcmVzZXQgbXBoeSB3aGVuIGhvc3QgcmVzZXQuDQo+IEJhY2t1
cCBtcGh5IHNldHRpbmcgYWZ0ZXIgbXBoeSByZXNldCBjb250cm9sIGdldC4NCj4gUmVzdG9yZSBt
cGh5IHNldHRpbmcgYWZ0ZXIgbXBoeSByZXNldC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFBldGVy
IFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvdWZzL2hv
c3QvdWZzLW1lZGlhdGVrLXNpcC5oIHwgIDkgKysrKysrKystDQo+ICBkcml2ZXJzL3Vmcy9ob3N0
L3Vmcy1tZWRpYXRlay5jICAgICB8IDE0ICsrKysrKysrKysrKysrDQo+ICBkcml2ZXJzL3Vmcy9o
b3N0L3Vmcy1tZWRpYXRlay5oICAgICB8ICAxICsNCj4gIDMgZmlsZXMgY2hhbmdlZCwgMjMgaW5z
ZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZz
L2hvc3QvdWZzLW1lZGlhdGVrLXNpcC5oDQo+IGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0
ZWstc2lwLmgNCj4gaW5kZXggZmQ2NDA4NDY5MTBhLi42NGY0OGVjYzU0YzcgMTAwNzU1DQo+IC0t
LSBhL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLXNpcC5oDQo+ICsrKyBiL2RyaXZlcnMv
dWZzL2hvc3QvdWZzLW1lZGlhdGVrLXNpcC5oDQo+IEBAIC0xOSw3ICsxOSw3IEBADQo+ICAjZGVm
aW5lIFVGU19NVEtfU0lQX1NSQU1fUFdSX0NUUkwgICAgICAgICBCSVQoNSkNCj4gICNkZWZpbmUg
VUZTX01US19TSVBfR0VUX1ZDQ19OVU0gICAgICAgICAgIEJJVCg2KQ0KPiAgI2RlZmluZSBVRlNf
TVRLX1NJUF9ERVZJQ0VfUFdSX0NUUkwgICAgICAgQklUKDcpDQo+IC0NCj4gKyNkZWZpbmUgVUZT
X01US19TSVBfTVBIWV9DVFJMICAgICAgICAgICAgIEJJVCg4KQ0KPiAgDQo+ICAvKg0KPiAgICog
TXVsdGktVkNDIGJ5IE51bWJlcmluZw0KPiBAQCAtMzEsNiArMzEsMTAgQEAgZW51bSB1ZnNfbXRr
X3ZjY19udW0gew0KPiAgCVVGU19WQ0NfTUFYDQo+ICB9Ow0KPiAgDQo+ICtlbnVtIHVmc19tdGtf
bXBoeV9vcCB7DQo+ICsJVUZTX01QSFlfQkFDS1VQID0gMCwNCj4gKwlVRlNfTVBIWV9SRVNUT1JF
DQo+ICt9Ow0KPiAgDQo+ICAvKg0KPiAgICogU01DIGNhbGwgd3JhcHBlciBmdW5jdGlvbg0KPiBA
QCAtODAsNCArODQsNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQgX3Vmc19tdGtfc21jKHN0cnVjdA0K
PiB1ZnNfbXRrX3NtY19hcmcgcykNCj4gICNkZWZpbmUgdWZzX210a19kZXZpY2VfcHdyX2N0cmwo
b24sIHVmc192ZXJzaW9uLCByZXMpIFwNCj4gIAl1ZnNfbXRrX3NtYyhVRlNfTVRLX1NJUF9ERVZJ
Q0VfUFdSX0NUUkwsICYocmVzKSwgb24sDQo+IHVmc192ZXJzaW9uKQ0KPiAgDQo+ICsjZGVmaW5l
IHVmc19tdGtfbXBoeV9jdHJsKG9wLCByZXMpIFwNCj4gKwl1ZnNfbXRrX3NtYyhVRlNfTVRLX1NJ
UF9NUEhZX0NUUkwsICYocmVzKSwgb3ApDQo+ICsNCj4gICNlbmRpZiAvKiAhX1VGU19NRURJQVRF
S19TSVBfSCAqLw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsu
YyBiL2RyaXZlcnMvdWZzL2hvc3QvdWZzLQ0KPiBtZWRpYXRlay5jDQo+IGluZGV4IDJjYWYwYzFk
NGUxNy4uYzRhYWUwMzFiNjk0IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1t
ZWRpYXRlay5jDQo+ICsrKyBiL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMNCj4gQEAg
LTE4NSwxNiArMTg1LDIzIEBAIHN0YXRpYyB2b2lkIHVmc19tdGtfY3J5cHRvX2VuYWJsZShzdHJ1
Y3QNCj4gdWZzX2hiYSAqaGJhKQ0KPiAgc3RhdGljIHZvaWQgdWZzX210a19ob3N0X3Jlc2V0KHN0
cnVjdCB1ZnNfaGJhICpoYmEpDQo+ICB7DQo+ICAJc3RydWN0IHVmc19tdGtfaG9zdCAqaG9zdCA9
IHVmc2hjZF9nZXRfdmFyaWFudChoYmEpOw0KPiArCXN0cnVjdCBhcm1fc21jY2NfcmVzIHJlczsN
Cj4gIA0KPiAgCXJlc2V0X2NvbnRyb2xfYXNzZXJ0KGhvc3QtPmhjaV9yZXNldCk7DQo+ICAJcmVz
ZXRfY29udHJvbF9hc3NlcnQoaG9zdC0+Y3J5cHRvX3Jlc2V0KTsNCj4gIAlyZXNldF9jb250cm9s
X2Fzc2VydChob3N0LT51bmlwcm9fcmVzZXQpOw0KPiArCXJlc2V0X2NvbnRyb2xfYXNzZXJ0KGhv
c3QtPm1waHlfcmVzZXQpOw0KPiAgDQo+ICAJdXNsZWVwX3JhbmdlKDEwMCwgMTEwKTsNCj4gIA0K
PiAgCXJlc2V0X2NvbnRyb2xfZGVhc3NlcnQoaG9zdC0+dW5pcHJvX3Jlc2V0KTsNCj4gIAlyZXNl
dF9jb250cm9sX2RlYXNzZXJ0KGhvc3QtPmNyeXB0b19yZXNldCk7DQo+ICAJcmVzZXRfY29udHJv
bF9kZWFzc2VydChob3N0LT5oY2lfcmVzZXQpOw0KPiArCXJlc2V0X2NvbnRyb2xfZGVhc3NlcnQo
aG9zdC0+bXBoeV9yZXNldCk7DQo+ICsNCj4gKwkvKiByZXN0b3JlIG1waHkgc2V0dGluZyBhZnRy
ZSBtcGh5IHJlc2V0ICovDQo+ICsJaWYgKGhvc3QtPm1waHlfcmVzZXQpDQo+ICsJCXVmc19tdGtf
bXBoeV9jdHJsKFVGU19NUEhZX1JFU1RPUkUsIHJlcyk7DQo+ICB9DQo+ICANCj4gIHN0YXRpYyB2
b2lkIHVmc19tdGtfaW5pdF9yZXNldF9jb250cm9sKHN0cnVjdCB1ZnNfaGJhICpoYmEsDQo+IEBA
IC0yMTksNiArMjI2LDggQEAgc3RhdGljIHZvaWQgdWZzX210a19pbml0X3Jlc2V0KHN0cnVjdCB1
ZnNfaGJhDQo+ICpoYmEpDQo+ICAJCQkJICAgInVuaXByb19yc3QiKTsNCj4gIAl1ZnNfbXRrX2lu
aXRfcmVzZXRfY29udHJvbChoYmEsICZob3N0LT5jcnlwdG9fcmVzZXQsDQo+ICAJCQkJICAgImNy
eXB0b19yc3QiKTsNCj4gKwl1ZnNfbXRrX2luaXRfcmVzZXRfY29udHJvbChoYmEsICZob3N0LT5t
cGh5X3Jlc2V0LA0KPiArCQkJCSAgICJtcGh5X3JzdCIpOw0KPiAgfQ0KPiAgDQo+ICBzdGF0aWMg
aW50IHVmc19tdGtfaGNlX2VuYWJsZV9ub3RpZnkoc3RydWN0IHVmc19oYmEgKmhiYSwNCj4gQEAg
LTkxOCw2ICs5MjcsNyBAQCBzdGF0aWMgaW50IHVmc19tdGtfaW5pdChzdHJ1Y3QgdWZzX2hiYSAq
aGJhKQ0KPiAgCXN0cnVjdCBkZXZpY2UgKmRldiA9IGhiYS0+ZGV2Ow0KPiAgCXN0cnVjdCB1ZnNf
bXRrX2hvc3QgKmhvc3Q7DQo+ICAJaW50IGVyciA9IDA7DQo+ICsJc3RydWN0IGFybV9zbWNjY19y
ZXMgcmVzOw0KPiAgDQo+ICAJaG9zdCA9IGRldm1fa3phbGxvYyhkZXYsIHNpemVvZigqaG9zdCks
IEdGUF9LRVJORUwpOw0KPiAgCWlmICghaG9zdCkgew0KPiBAQCAtOTQ2LDYgKzk1NiwxMCBAQCBz
dGF0aWMgaW50IHVmc19tdGtfaW5pdChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiAgDQo+ICAJdWZz
X210a19pbml0X3Jlc2V0KGhiYSk7DQo+ICANCj4gKwkvKiBiYWNrdXAgbXBoeSBzZXR0aW5nIGlm
IG1waHkgY2FuIHJlc2V0ICovDQo+ICsJaWYgKGhvc3QtPm1waHlfcmVzZXQpDQo+ICsJCXVmc19t
dGtfbXBoeV9jdHJsKFVGU19NUEhZX0JBQ0tVUCwgcmVzKTsNCj4gKw0KPiAgCS8qIEVuYWJsZSBy
dW50aW1lIGF1dG9zdXNwZW5kICovDQo+ICAJaGJhLT5jYXBzIHw9IFVGU0hDRF9DQVBfUlBNX0FV
VE9TVVNQRU5EOw0KPiAgDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRp
YXRlay5oIGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtDQo+IG1lZGlhdGVrLmgNCj4gaW5kZXggMTdi
ZTNmNzQ4ZmEwLi42MTI5YWI1OWU1ZjUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdWZzL2hvc3Qv
dWZzLW1lZGlhdGVrLmgNCj4gKysrIGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuaA0K
PiBAQCAtMTY2LDYgKzE2Niw3IEBAIHN0cnVjdCB1ZnNfbXRrX2hvc3Qgew0KPiAgCXN0cnVjdCBy
ZXNldF9jb250cm9sICpoY2lfcmVzZXQ7DQo+ICAJc3RydWN0IHJlc2V0X2NvbnRyb2wgKnVuaXBy
b19yZXNldDsNCj4gIAlzdHJ1Y3QgcmVzZXRfY29udHJvbCAqY3J5cHRvX3Jlc2V0Ow0KPiArCXN0
cnVjdCByZXNldF9jb250cm9sICptcGh5X3Jlc2V0Ow0KPiAgCXN0cnVjdCB1ZnNfaGJhICpoYmE7
DQo+ICAJc3RydWN0IHVmc19tdGtfY3J5cHRfY2ZnICpjcnlwdDsNCj4gIAlzdHJ1Y3QgdWZzX210
a19jbGsgbWNsazsNCkFja2VkLWJ5OiBDaHVuLUh1bmcgV3UgPENodW4tSHVuZy5XdUBtZWRpYXRl
ay5jb20+DQo=
