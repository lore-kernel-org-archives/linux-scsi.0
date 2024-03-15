Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897356119
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 02:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710470522; cv=fail; b=ROoPbwegh02Yjy+qQ87ake0eSuAYGNYHxXB7rDpcVxG9E5KHrQxigDe0oI9K8JPGRjuaQIOF2UbI7fsfK6BAD7vSSwpJKQFyPIOewlsk2OvgN5cHq5Rvp+j9DSrC2jFRdSRV4Ij2n+aBssjeN6EVDN1yFW8+q9TA8MJOq1fSVRg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710470522; c=relaxed/simple;
	bh=zK2LKZWjVhI8KhtkcAru9dvetnFvUdjtreg8gxO88yA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IPm9GgJg5UAWEA/U7AOTpCQ5N7apgQmf/wyGxG9ckFc26K9Op/XCfyWHevzQiWrlAy1uQlKAxdHf6Gi46wBT6b52Ouyfnmros3AwqQ1RmlTB+EdQP1z1o76xcX3ChpaVQWypjaopuvcB75HFV/eTBfG1M93B//wBpI720tMsmyU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=f12/OpMa; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=fRnESAdu; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="f12/OpMa";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="fRnESAdu"
X-UUID: 94d06fbae27511eeb8927bc1f75efef4-20240315
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=zK2LKZWjVhI8KhtkcAru9dvetnFvUdjtreg8gxO88yA=;
	b=f12/OpMaLsKc3vCmH4tPh8l14SoYjCI2eMTnrAb1DGqxC5RpPuQe123SFTkiqLwO+1aZUo0aaqEH6sALO+qhr0/HRAsGPiM+9yJAjZmCbhLRzCfpkZ+R6hhDOqL+mjPV4Rzy4A7qg08ne42SL6JNLuLTr9YvsPJPzgc4SFeIgCo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:488eb821-3907-4bfa-92b5-9d26890d45e5,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6f543d0,CLOUDID:42fb6c90-e2c0-40b0-a8fe-7c7e47299109,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 94d06fbae27511eeb8927bc1f75efef4-20240315
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <chun-hung.wu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1005737406; Fri, 15 Mar 2024 10:41:53 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 15 Mar 2024 10:41:51 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 15 Mar 2024 10:41:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EiepN+pVWt6KhuJsFi6xzFiCZPgkX3xao5hyLGz0e4yI1cVSBxXzi2u4UIdbwBV/6fYwij/epq61Lyc9S5PiIdWpJhhdxB87QS8R6NLvbKXtDiCPOxpj+hZyBX3htY6id8ZMGCjL/BeVhKEqmH7wZW/wUoikfHTUVQydgigti0F9c7r4GtU7+oOWCX+JriT+/riKha0AAGYW5CN7w/xDVAi6lZXEsBj7BRvUO6xcY2HCfnR5OzGnAr2GmarpufBln1h+H9we7PZpotMSZApZLhc9BFNTa9NvSU6IZkuf2s9cnmIhnXGC1H0Rzu/vmu9YAVSYp66k6K5NSzu3eO9iqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zK2LKZWjVhI8KhtkcAru9dvetnFvUdjtreg8gxO88yA=;
 b=aCu5ecwcaZzEFHU0R0iJWWMrTqs7m1UsNgnRS64f9fkk2kBvIffGURMIGMoKMDq7hOpql7rjF8Ur/nftna+IfZdtnBgCkj04P28qMyMyuefOg2gfqRCh1eHB+WgXUNKw1SJUEIepdUw/X9p2qTVNZoZPxSv76iZbz8255YhYEmOFL1hQ941XdE2eVM85zKM97OlXQKFmxEKzi6Jh0QpQCnsffP61NMbTpE3vaxZj/vJpQZC70ROkzko3FF/V82wjkKaJK9lXtd5gK9oU6POl4F/e5/x6HVw1CdCT4R2co3rhKtsEp/qR1Z0/pmMwhA/4hUVXirM5eZNllSbQdJESbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zK2LKZWjVhI8KhtkcAru9dvetnFvUdjtreg8gxO88yA=;
 b=fRnESAduJ1gL60EFKEcVkR60/4njMGP2KrJPwYM47rmEHk94A4qSlsXa+YAZQ/m7hMGpu6Die48Eb8fKErFcJ9mpzrEnDOyli/tBVQDmwOfWymlc9C9nxDiEBkbjpTfP5yRdosP8SPx57yb8yOSNsoAS4Bfl2LA+kR5fRiI2YlI=
Received: from TYSPR03MB7350.apcprd03.prod.outlook.com (2603:1096:400:413::14)
 by TYZPR03MB8102.apcprd03.prod.outlook.com (2603:1096:400:44e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.36; Fri, 15 Mar
 2024 02:41:49 +0000
Received: from TYSPR03MB7350.apcprd03.prod.outlook.com
 ([fe80::913f:a95a:231e:cd2c]) by TYSPR03MB7350.apcprd03.prod.outlook.com
 ([fe80::913f:a95a:231e:cd2c%3]) with mapi id 15.20.7386.020; Fri, 15 Mar 2024
 02:41:49 +0000
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
Subject: Re: [PATCH v1 7/7] ufs: host: mediatek: support rtff in PM flow
Thread-Topic: [PATCH v1 7/7] ufs: host: mediatek: support rtff in PM flow
Thread-Index: AQHacSa3xdTNDQw9HEqUo/sRIkH6ibE4IlkA
Date: Fri, 15 Mar 2024 02:41:49 +0000
Message-ID: <e7a898d85b447ad5541aab287d8d29de45360745.camel@mediatek.com>
References: <20240308070241.9163-1-peter.wang@mediatek.com>
	 <20240308070241.9163-8-peter.wang@mediatek.com>
In-Reply-To: <20240308070241.9163-8-peter.wang@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYSPR03MB7350:EE_|TYZPR03MB8102:EE_
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PIyrCf2wsSxMOTxTki/Izbq3vpIVci0nVH39qe4fuwN8HLfR7UY0YICHvdfkILsdhK0x9PKzKbFGKA9PnZr+5YT0Z8nVE2nTrtpKkR4Dsyt3kdyGSnvrq9YVByspulIhaCIjsaOqasrDwEG9QuRDOnzw9k82saNg7vJ0xUtT5qeBK2qHOlgmUs/XbodCXPZaWKlUb1FFezUuXMs+MYNqPkWkde+T+JAJl5JtWudMvjvvwd3rmy+IpmhrL+UQy5KA75m/b30hi9oUpjOsMcTLi3STn2uCklLA85rdsZIpDG57Jq7hrdAk2SIRixmS2IFJjShpId82ZoHuUiGou4c46vjLR3q8N8yKZTfM6YhPHRru+ipKyNqDM9ViIlSQhIyCk43NXQ/cMk35IfMmzuVtB+7I0hyx9GoI7+6/Lub0/45xi6Z0uc/uKrRANqhQ6+yrgqrqG98FdpKrkmA53KTjVquRNIPtdHO/N6Y7KY4zdXWzScDI3k+EzcaDV9si+9eZwP4AZqX2MmJfgcoRgsYr9y1FsWG6m8P4dfbbbthlDWE3tIRJUYwf5xMFea2Ec57DXlpdEYnPyUa6gdocLAFO2ihjh+VjFgmT7nyq74yF3sp6KG9yzmbw1p5+0vP+AdbFwkeuR9klGjpkynU0diY6Y7i+WvFrNl3cFgMN2JKWoJg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR03MB7350.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TXJHa09RRFowalp2L0I2WlFmSE5yYTJjVHFvV1hrbFZvaTBHT1Z3ZlY5ajE1?=
 =?utf-8?B?Y2taZmlsMjdMaEtGTThoYkp2MVNmYzdjcE1wcjBscVRYQngwWFNaaEdpbzFB?=
 =?utf-8?B?SmQ3emxCMGZFVUt6YTFkSnBneWswUGZMZ0lHcDFnMGQ5VXJsdzlFTmJDd3dv?=
 =?utf-8?B?UG1mZHZPQ21RWldlaEo4ekxhNGhSd21qVmIvVjlsY0VlTkpsemFTS3RKZVRO?=
 =?utf-8?B?UHc2SVZ4aTczUTFoaHRBVjRqOHlFaWRXRC9mRUY4T0dUemw1SXI1RW1haFdF?=
 =?utf-8?B?aGVNbUxUKzVWYlZLMzZ5ZGVPeTdiQVhidnBzZnRPWjlNS2FnbWVNK2ZlMVpJ?=
 =?utf-8?B?U29kRmphWE5yS1ZGSTBRYTlOT01EM2ZLYkw1ZWltSlZheUFSd2lyQjh4Y213?=
 =?utf-8?B?OXN1TXJmeVdjTDk4WnpRSFl5QlQ5VUREVHdkVFZZdzUwU2x4aVRDbmZsSkVB?=
 =?utf-8?B?cGpkSmZkOU5hTU9kTmJ4ZkF4UTk0bThnM283a1JJNHlreERyOUl6aGFXd0xi?=
 =?utf-8?B?S2xIUUVacHF3YVpSejd6dUxjVkt1dFNiM0xqSTVEU3ZQVE5Bdnl2SGpGOG1Z?=
 =?utf-8?B?R0JYL2hZd21IUXQ2T2JVZHVpRks4bDlMQTRvVTVhbGVqd1BCa3NtWEdKZ0p1?=
 =?utf-8?B?ajQ4aVl5bXdFclFNdEFKOHRFblgwOC9lUE5vSjlHcHRVQjYwUEJkbjBsQ0NU?=
 =?utf-8?B?VElqajZGMHI4MWNVa0pybFZodDF2Wjh3U1hlQzVWUi9rbVJrdDFyb0FDT1Jt?=
 =?utf-8?B?NlVqOE11YzRzV2xuMVFOVExQRTVjTHQvQnJOTXlPYll0NmNBays5TnFPbldT?=
 =?utf-8?B?ZytCempiUStPazNoMWZHOGdMRjdwdFlGcXdEL0lLb0FOYkJib2VINzVQdjZN?=
 =?utf-8?B?eStrd2Q3NGNadzR6ZVJpL3NaOWtZL0hvckczK0RGdWhDZlRZdkt0bGVmYnJG?=
 =?utf-8?B?ajV4L2RjUm0rUnN5VExBZEFLVTBKajlPdEVNMW9WTFVIdWpDMUVRZ0ZoYXFh?=
 =?utf-8?B?dCsxRHloRVpvdW5PdW1zelE1ZG5OdjhCbDczcWpwQnZnV1hQVy9GcjNNZXdx?=
 =?utf-8?B?aTBiNXlIdVZheUJpaDNSRGVPM2V4YURIdVViT3E0UW9ETGVCT1NEUXVYUm5o?=
 =?utf-8?B?WmhrRC9XNnc5cW1PbHJCUVRlZFR6NXFnSnpQaHVTeDhPNStBcWxXeVFnZ1d3?=
 =?utf-8?B?bFd4NDF3Vlh6VFFnRFlQOHlQNmc5cythdkVvR21sVFBGNTdJOHo0RWE4bjBL?=
 =?utf-8?B?K3JFbitwOENoWTNWazE5TE9BR2huakxXMFkxelRENzhDMDNTSkxCVlJnSG5R?=
 =?utf-8?B?V2hjSzlKb2trNEJkbWczQU5JUHg2YktXeCtROGp3TXdIcnNxa1lpV0RMZURX?=
 =?utf-8?B?OXQ4eUVOUklycysrdXNxTG1oclhRZjB0bWgxSkM5ekhqZHIzSE1yMC93WlhE?=
 =?utf-8?B?MXJlT0I1emlvTW8wUnNrQkZ1bThGRnZTeHZkT1p2amc1eFFJVmpUMEVMQ2Jk?=
 =?utf-8?B?L3Y0SWgxSld0ZHlVRzRWNENPeHpPajF4QTkwMjlqNnNzTExDVm5nUEUzWlJL?=
 =?utf-8?B?NEdxY1VicEJVcXY2RThkbE9OME01M1BLNHZ3UFlZRk43Q2lCbCtyZk40SUpy?=
 =?utf-8?B?TmxtYzVWcmliZEpkSlphU1pTeW9YWUlwYTMxRE5tdGRudWN5anNOWEFROGd5?=
 =?utf-8?B?Q05PM2tPOW45MkFiaVdOUUpBQnRZS3k2ZHNsNTZZTktwOEt2T3ZpYldoekIw?=
 =?utf-8?B?NDdFbC9kVnQ2MzFwNWlxSG41QUpkUU1VMCt5SElvQndXV1Z4OWJVVHlzWFcw?=
 =?utf-8?B?QjFDWEorcUw3S0JGOUJ2QzQ5S3dFRzdMSjUySjloN1BLZUpkbnBZK1Bpankv?=
 =?utf-8?B?eks0S0FIUkNTTlVkOWVrT0pFMXVuV2dEWHV4UkRZRjVqOWY5Y0V0ZUlJNE5y?=
 =?utf-8?B?SWR4WjI1WTlEc2hyYXh0QjByak1zc3BSVzVBM0dkaEJLcjdTamJFc3c3TElw?=
 =?utf-8?B?MStuTnRieGJhUjgraExOZmxEOTJWaDNqbVljZDZTRzhJbWhOTVlIcEZyekNz?=
 =?utf-8?B?YW5TcXdrV2EyRnBpd2tzQzJiUFU5V0luZEFVMnVtWWhGcDhYZ2pNS1NPbWNP?=
 =?utf-8?B?RSt1REN0cWlmV3NTbVh4RERLN3c3NmJLTzBsTFRLV0RYSElGZjhqeExRL1NE?=
 =?utf-8?B?QXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE5239E5427A8E469FF7074D0A2062DC@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYSPR03MB7350.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffc529e7-4d8a-4d50-38dc-08dc449976eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2024 02:41:49.5061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OJAYS5VTpI04UO0Sr2YylzplcRFYuPctA6FSH0GnMxa3CM4+wOAQpe0/6aKpZGdHHHtrE7qRcKDbOlH7x9jvpZEQkImlvolAxWi4vzWHtuI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB8102
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--10.818100-8.000000
X-TMASE-MatchedRID: u8usGLXufdjUL3YCMmnG4oei/mZCYVwugDRlwc+wR6cNcckEPxfz2Iu3
	renu5Y0weeTK1AUftLLijpjet3oGSIOI2R+9sePeFYJUGv4DL3zt/okBLaEo+AbVfobBGumj6s5
	IQlEERpdHtHbPEukkeT2+qVno7r3yDHlMveoJOASO0rt0LpQGeXyzymMiw5QHVI7KaIl9NheYNR
	TjDkKH0eW7/mQkrMSD4z7DmZ7yV3hC/bXMk2XQLIMbH85DUZXyseWplitmp0j6C0ePs7A07YFIn
	LyeDAoZJi0aWE48HR6G+7z6C+VYKH+O+8Bgnnn4nCHuMRtC7O+eBqpXlD9s+g==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--10.818100-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	49620835C5F7DDF2BEC5A6E2742B6B3DAE1A31CE949EA682ECD2C207B06196D82000:8

T24gRnJpLCAyMDI0LTAzLTA4IGF0IDE1OjAyICswODAwLCBwZXRlci53YW5nQG1lZGlhdGVrLmNv
bSB3cm90ZToNCj4gRnJvbTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+
IA0KPiBGcm9tOiBBbGljZSBDaGFvIDxhbGljZS5jaGFvQG1lZGlhdGVrLmNvbT4NCj4gDQo+IFJl
dmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCj4gU2lnbmVk
LW9mZi1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+IFNpZ25lZC1v
ZmYtYnk6IEFsaWNlIENoYW8gPGFsaWNlLmNoYW9AbWVkaWF0ZWsuY29tPg0KPiAtLS0NCj4gIGRy
aXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLXNpcC5oIHwgIDQgKysrKw0KPiAgZHJpdmVycy91
ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYyAgICAgfCAzNQ0KPiArKysrKysrKysrKysrKysrKysrKysr
KysrKysrKw0KPiAgZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuaCAgICAgfCAgMiArKw0K
PiAgMyBmaWxlcyBjaGFuZ2VkLCA0MSBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWstc2lwLmgNCj4gYi9kcml2ZXJzL3Vmcy9ob3N0
L3Vmcy1tZWRpYXRlay1zaXAuaA0KPiBpbmRleCA2NGY0OGVjYzU0YzcuLmVlYWIwZjkzMTQ2ZSAx
MDA3NTUNCj4gLS0tIGEvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWstc2lwLmgNCj4gKysr
IGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWstc2lwLmgNCj4gQEAgLTIwLDYgKzIwLDcg
QEANCj4gICNkZWZpbmUgVUZTX01US19TSVBfR0VUX1ZDQ19OVU0gICAgICAgICAgIEJJVCg2KQ0K
PiAgI2RlZmluZSBVRlNfTVRLX1NJUF9ERVZJQ0VfUFdSX0NUUkwgICAgICAgQklUKDcpDQo+ICAj
ZGVmaW5lIFVGU19NVEtfU0lQX01QSFlfQ1RSTCAgICAgICAgICAgICBCSVQoOCkNCj4gKyNkZWZp
bmUgVUZTX01US19TSVBfTVRDTU9TX0NUUkwgICAgICAgICAgIEJJVCg5KQ0KPiAgDQo+ICAvKg0K
PiAgICogTXVsdGktVkNDIGJ5IE51bWJlcmluZw0KPiBAQCAtODcsNCArODgsNyBAQCBzdGF0aWMg
aW5saW5lIHZvaWQgX3Vmc19tdGtfc21jKHN0cnVjdA0KPiB1ZnNfbXRrX3NtY19hcmcgcykNCj4g
ICNkZWZpbmUgdWZzX210a19tcGh5X2N0cmwob3AsIHJlcykgXA0KPiAgCXVmc19tdGtfc21jKFVG
U19NVEtfU0lQX01QSFlfQ1RSTCwgJihyZXMpLCBvcCkNCj4gIA0KPiArI2RlZmluZSB1ZnNfbXRr
X210Y21vc19jdHJsKG9wLCByZXMpIFwNCj4gKwl1ZnNfbXRrX3NtYyhVRlNfTVRLX1NJUF9NVENN
T1NfQ1RSTCwgJihyZXMpLCBvcCkNCj4gKw0KPiAgI2VuZGlmIC8qICFfVUZTX01FRElBVEVLX1NJ
UF9IICovDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jIGIv
ZHJpdmVycy91ZnMvaG9zdC91ZnMtDQo+IG1lZGlhdGVrLmMNCj4gaW5kZXggYzRhYWUwMzFiNjk0
Li4yZjE5MTUyNWMzMDggMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlh
dGVrLmMNCj4gKysrIGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYw0KPiBAQCAtMTI3
LDYgKzEyNywxMyBAQCBzdGF0aWMgYm9vbCB1ZnNfbXRrX2lzX3R4X3NrZXdfZml4KHN0cnVjdA0K
PiB1ZnNfaGJhICpoYmEpDQo+ICAJcmV0dXJuICEhKGhvc3QtPmNhcHMgJiBVRlNfTVRLX0NBUF9U
WF9TS0VXX0ZJWCk7DQo+ICB9DQo+ICANCj4gK3N0YXRpYyBib29sIHVmc19tdGtfaXNfcnRmZl9t
dGNtb3Moc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gK3sNCj4gKwlzdHJ1Y3QgdWZzX210a19ob3N0
ICpob3N0ID0gdWZzaGNkX2dldF92YXJpYW50KGhiYSk7DQo+ICsNCj4gKwlyZXR1cm4gISEoaG9z
dC0+Y2FwcyAmIFVGU19NVEtfQ0FQX1JURkZfTVRDTU9TKTsNCj4gK30NCj4gKw0KPiAgc3RhdGlj
IGJvb2wgdWZzX210a19pc19hbGxvd192Y2NxeF9scG0oc3RydWN0IHVmc19oYmEgKmhiYSkNCj4g
IHsNCj4gIAlzdHJ1Y3QgdWZzX210a19ob3N0ICpob3N0ID0gdWZzaGNkX2dldF92YXJpYW50KGhi
YSk7DQo+IEBAIC02NTMsNiArNjYwLDkgQEAgc3RhdGljIHZvaWQgdWZzX210a19pbml0X2hvc3Rf
Y2FwcyhzdHJ1Y3QgdWZzX2hiYQ0KPiAqaGJhKQ0KPiAgCWlmIChvZl9wcm9wZXJ0eV9yZWFkX2Jv
b2wobnAsICJtZWRpYXRlayx1ZnMtZGlzYWJsZS1tY3EiKSkNCj4gIAkJaG9zdC0+Y2FwcyB8PSBV
RlNfTVRLX0NBUF9ESVNBQkxFX01DUTsNCj4gIA0KPiArCWlmIChvZl9wcm9wZXJ0eV9yZWFkX2Jv
b2wobnAsICJtZWRpYXRlayx1ZnMtcnRmZi1tdGNtb3MiKSkNCj4gKwkJaG9zdC0+Y2FwcyB8PSBV
RlNfTVRLX0NBUF9SVEZGX01UQ01PUzsNCj4gKw0KPiAgCWRldl9pbmZvKGhiYS0+ZGV2LCAiY2Fw
czogMHgleCIsIGhvc3QtPmNhcHMpOw0KPiAgfQ0KPiAgDQo+IEBAIC05OTMsNiArMTAwMywxNSBA
QCBzdGF0aWMgaW50IHVmc19tdGtfaW5pdChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiAgCSAqIEVu
YWJsZSBwaHkgY2xvY2tzIHNwZWNpZmljYWxseSBoZXJlLg0KPiAgCSAqLw0KPiAgCXVmc19tdGtf
bXBoeV9wb3dlcl9vbihoYmEsIHRydWUpOw0KPiArDQo+ICsJaWYgKHVmc19tdGtfaXNfcnRmZl9t
dGNtb3MoaGJhKSkgew0KPiArCQkvKiBGaXJzdCBSZXN0b3JlIGhlcmUsIHRvIGF2b2lkIGJhY2t1
cCB1bmV4cGVjdGVkIHZhbHVlDQo+ICovDQo+ICsJCXVmc19tdGtfbXRjbW9zX2N0cmwoZmFsc2Us
IHJlcyk7DQo+ICsNCj4gKwkJLyogUG93ZXIgb24gdG8gaW5pdCAqLw0KPiArCQl1ZnNfbXRrX210
Y21vc19jdHJsKHRydWUsIHJlcyk7DQo+ICsJfQ0KPiArDQo+ICAJdWZzX210a19zZXR1cF9jbG9j
a3MoaGJhLCB0cnVlLCBQT1NUX0NIQU5HRSk7DQo+ICANCj4gIAlob3N0LT5pcF92ZXIgPSB1ZnNo
Y2RfcmVhZGwoaGJhLCBSRUdfVUZTX01US19JUF9WRVIpOw0KPiBAQCAtMTgyMyw2ICsxODQyLDcg
QEAgc3RhdGljIHZvaWQgdWZzX210a19yZW1vdmUoc3RydWN0DQo+IHBsYXRmb3JtX2RldmljZSAq
cGRldikNCj4gIHN0YXRpYyBpbnQgdWZzX210a19zeXN0ZW1fc3VzcGVuZChzdHJ1Y3QgZGV2aWNl
ICpkZXYpDQo+ICB7DQo+ICAJc3RydWN0IHVmc19oYmEgKmhiYSA9IGRldl9nZXRfZHJ2ZGF0YShk
ZXYpOw0KPiArCXN0cnVjdCBhcm1fc21jY2NfcmVzIHJlczsNCj4gIAlpbnQgcmV0Ow0KPiAgDQo+
ICAJcmV0ID0gdWZzaGNkX3N5c3RlbV9zdXNwZW5kKGRldik7DQo+IEBAIC0xODMxLDE1ICsxODUx
LDIyIEBAIHN0YXRpYyBpbnQgdWZzX210a19zeXN0ZW1fc3VzcGVuZChzdHJ1Y3QNCj4gZGV2aWNl
ICpkZXYpDQo+ICANCj4gIAl1ZnNfbXRrX2Rldl92cmVnX3NldF9scG0oaGJhLCB0cnVlKTsNCj4g
IA0KPiArCWlmICh1ZnNfbXRrX2lzX3J0ZmZfbXRjbW9zKGhiYSkpDQo+ICsJCXVmc19tdGtfbXRj
bW9zX2N0cmwoZmFsc2UsIHJlcyk7DQo+ICsNCj4gIAlyZXR1cm4gMDsNCj4gIH0NCj4gIA0KPiAg
c3RhdGljIGludCB1ZnNfbXRrX3N5c3RlbV9yZXN1bWUoc3RydWN0IGRldmljZSAqZGV2KQ0KPiAg
ew0KPiAgCXN0cnVjdCB1ZnNfaGJhICpoYmEgPSBkZXZfZ2V0X2RydmRhdGEoZGV2KTsNCj4gKwlz
dHJ1Y3QgYXJtX3NtY2NjX3JlcyByZXM7DQo+ICANCj4gIAl1ZnNfbXRrX2Rldl92cmVnX3NldF9s
cG0oaGJhLCBmYWxzZSk7DQo+ICANCj4gKwlpZiAodWZzX210a19pc19ydGZmX210Y21vcyhoYmEp
KQ0KPiArCQl1ZnNfbXRrX210Y21vc19jdHJsKHRydWUsIHJlcyk7DQo+ICsNCj4gIAlyZXR1cm4g
dWZzaGNkX3N5c3RlbV9yZXN1bWUoZGV2KTsNCj4gIH0NCj4gICNlbmRpZg0KPiBAQCAtMTg0OCw2
ICsxODc1LDcgQEAgc3RhdGljIGludCB1ZnNfbXRrX3N5c3RlbV9yZXN1bWUoc3RydWN0IGRldmlj
ZQ0KPiAqZGV2KQ0KPiAgc3RhdGljIGludCB1ZnNfbXRrX3J1bnRpbWVfc3VzcGVuZChzdHJ1Y3Qg
ZGV2aWNlICpkZXYpDQo+ICB7DQo+ICAJc3RydWN0IHVmc19oYmEgKmhiYSA9IGRldl9nZXRfZHJ2
ZGF0YShkZXYpOw0KPiArCXN0cnVjdCBhcm1fc21jY2NfcmVzIHJlczsNCj4gIAlpbnQgcmV0ID0g
MDsNCj4gIA0KPiAgCXJldCA9IHVmc2hjZF9ydW50aW1lX3N1c3BlbmQoZGV2KTsNCj4gQEAgLTE4
NTYsMTIgKzE4ODQsMTkgQEAgc3RhdGljIGludCB1ZnNfbXRrX3J1bnRpbWVfc3VzcGVuZChzdHJ1
Y3QNCj4gZGV2aWNlICpkZXYpDQo+ICANCj4gIAl1ZnNfbXRrX2Rldl92cmVnX3NldF9scG0oaGJh
LCB0cnVlKTsNCj4gIA0KPiArCWlmICh1ZnNfbXRrX2lzX3J0ZmZfbXRjbW9zKGhiYSkpDQo+ICsJ
CXVmc19tdGtfbXRjbW9zX2N0cmwoZmFsc2UsIHJlcyk7DQo+ICsNCj4gIAlyZXR1cm4gMDsNCj4g
IH0NCj4gIA0KPiAgc3RhdGljIGludCB1ZnNfbXRrX3J1bnRpbWVfcmVzdW1lKHN0cnVjdCBkZXZp
Y2UgKmRldikNCj4gIHsNCj4gIAlzdHJ1Y3QgdWZzX2hiYSAqaGJhID0gZGV2X2dldF9kcnZkYXRh
KGRldik7DQo+ICsJc3RydWN0IGFybV9zbWNjY19yZXMgcmVzOw0KPiArDQo+ICsJaWYgKHVmc19t
dGtfaXNfcnRmZl9tdGNtb3MoaGJhKSkNCj4gKwkJdWZzX210a19tdGNtb3NfY3RybCh0cnVlLCBy
ZXMpOw0KPiAgDQo+ICAJdWZzX210a19kZXZfdnJlZ19zZXRfbHBtKGhiYSwgZmFsc2UpOw0KPiAg
DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5oIGIvZHJpdmVy
cy91ZnMvaG9zdC91ZnMtDQo+IG1lZGlhdGVrLmgNCj4gaW5kZXggNjEyOWFiNTllNWY1Li41OTlm
ZWE2NjY2M2IgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmgN
Cj4gKysrIGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuaA0KPiBAQCAtMTMxLDYgKzEz
MSw4IEBAIGVudW0gdWZzX210a19ob3N0X2NhcHMgew0KPiAgCVVGU19NVEtfQ0FQX1BNQ19WSUFf
RkFTVEFVVE8gICAgICAgICAgID0gMSA8PCA2LA0KPiAgCVVGU19NVEtfQ0FQX1RYX1NLRVdfRklY
ICAgICAgICAgICAgICAgID0gMSA8PCA3LA0KPiAgCVVGU19NVEtfQ0FQX0RJU0FCTEVfTUNRICAg
ICAgICAgICAgICAgID0gMSA8PCA4LA0KPiArCS8qIENvbnRyb2wgTVRDTU9TIHdpdGggUlRGRiAq
Lw0KPiArCVVGU19NVEtfQ0FQX1JURkZfTVRDTU9TICAgICAgICAgICAgICAgID0gMSA8PCA5LA0K
PiAgfTsNCj4gIA0KPiAgc3RydWN0IHVmc19tdGtfY3J5cHRfY2ZnIHsNCg0KQWNrZWQtYnk6IENo
dW4tSHVuZyBXdSA8Q2h1bi1IdW5nLld1QG1lZGlhdGVrLmNvbT4NCg==
