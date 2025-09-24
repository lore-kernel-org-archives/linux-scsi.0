Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A47A2DA771
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 09:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758706005; cv=fail; b=HmgZU/2mMfHLeA/Miu6XnTNHpZzd9BLJUValDc84rruwvt3sO7VE7oB/tZ6iECpJah1WsyxssS9hX82cKhjQ0kDsHk6t4AxI4lq1ziXf58ZCFfONtOmyQrPthl6jwX7SLKejkmPn3ns8WEiQbA7yomo/C4dXQKFvMlJrpFTTjS4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758706005; c=relaxed/simple;
	bh=3iALyKQPldi5/W1XT5F+C8xm9Lbj3oKhVKMWpMX+hWc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UuGmzIo1XxWcPKbFcgpBY0dDk/7IZ7z0z6wNKm+xXbJD0VxNv3ITl64c2k84aZ/JWJ/ani5Md+nC3otNGSfpQANVGL9TJZqneB9Rc/gxiEvu/vSsKohKqVCQjicvlYsPELZ1MLBtlzHyMdkkaP5Lju0aJ6pN8H+8JQqsvwKZxvM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=sPoZp7Cz; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=RbDVacsi; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="sPoZp7Cz";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="RbDVacsi"
X-UUID: 8f03e48e992811f0b33aeb1e7f16c2b6-20250924
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=3iALyKQPldi5/W1XT5F+C8xm9Lbj3oKhVKMWpMX+hWc=;
	b=sPoZp7Czc+6Yl2GdKrfv1UoBm0YLWpBzX9uzaV/WIT/l4FxzGXHSW7zTlGoYvZ32Xy4gA5Gzyyd4uapzYzM+C7lPomX8fkcA3HI5l4vK8LblswzZ1mMQ8PP2nhnEyaVVchE92+OfW/i8r3TSwC7IF2DKRCYoi8v/jSOgMoZlFTQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:4fa25407-e6b1-4ab5-add3-4f5c7b165473,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:1ca6b93,CLOUDID:0d0ae56c-8443-424b-b119-dc42e68239b0,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8f03e48e992811f0b33aeb1e7f16c2b6-20250924
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1965221808; Wed, 24 Sep 2025 17:26:32 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 24 Sep 2025 17:26:30 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Wed, 24 Sep 2025 17:26:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IPPelidJ3yGxct5U1h7bhp40XtCiV/VCFiL0M3HIgfyOrZAkbfNvn1XgPsidTtgUAZOEZJwH3UPOVnsG75W0fhv4lVb1t/bkHjXgaXElZ3tcrD1uOd3NlRene7GZY2lygj3NCuN6aAPwPMZvM0sqdhEplg/sSH8o5qF9eYjrEo2fN36oNd5LiSpwXzvnsZOB5p7ANoijKIdWI+0SamXGA9z9XHg5uoixV2KQodnQkBXhkRSFCcNL7TZe6Rb0qaSlRCGqZMT4NW44NqhQ06HVu00Sq9IYqQdxKzpJ+zkQvytLmQQUY34CzC9Gup+DhMAkqhW9sIpJsVi1cs2MNf4YiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3iALyKQPldi5/W1XT5F+C8xm9Lbj3oKhVKMWpMX+hWc=;
 b=vz8xIoMBvih2yXn98Euj/KHrPHn43rgXvJ07U5zhWruAvwLaaCe8xLBDR803hU9vHeuybZ2Jw0tazxxHMWptq6AFw/ZkYR24czsSfSTgLj8vokme1ZRWWlAGSPMGr/t1Aj+y46dFfpruWfr+bWzSoHEui0KLTC8kl9RkPCJOAXWtGBsLLBvkmGwW1Jd/ExzykPyE0wfvNrqWog0hItWI8/u0MsOOTZSdFHcTi2++yCLRpEK4I7s0kfvQx6NNVjKeLYaFE/PPSOwk2zn8g7BgAg1wdJZ6hD2u9Q6I2ZRYy0Cx0Qfuv8MYJd1CkYyZ1ztmKIMNSND/0RHnxUIvcCutTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3iALyKQPldi5/W1XT5F+C8xm9Lbj3oKhVKMWpMX+hWc=;
 b=RbDVacsiGpPy+TQrYu9RDzRJJsrv+YyRvU2KaoB8F49z6S6c3iuF/NSZZ5mm4Vse0Puj9EFXbiU35XoqmVVmyOnNut7QCFoKX7pfBOpA+gqkODis8SjVWQ7Tnnpldovuu/ZmbtsgkzORFO92GqY/4pqGRlI72lRZOl+DnfARATU=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB6796.apcprd03.prod.outlook.com (2603:1096:101:8b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Wed, 24 Sep
 2025 09:26:27 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9160.008; Wed, 24 Sep 2025
 09:26:27 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>
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
Subject: Re: [PATCH v1] ufs: core: Fix runtime suspend error deadlock
Thread-Topic: [PATCH v1] ufs: core: Fix runtime suspend error deadlock
Thread-Index: AQHcLGMd6+SljMTAGUerWxHWzkJ+3LSg73AAgAEiYwA=
Date: Wed, 24 Sep 2025 09:26:26 +0000
Message-ID: <2ab086da45acaab5ff6ff5117670a8ae65d2f0ca.camel@mediatek.com>
References: <20250923082147.2491450-1-peter.wang@mediatek.com>
	 <ecc17025-692d-45fe-97eb-9cc4c4ce7a06@acm.org>
In-Reply-To: <ecc17025-692d-45fe-97eb-9cc4c4ce7a06@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB6796:EE_
x-ms-office365-filtering-correlation-id: 962e48d1-b1fa-493a-5382-08ddfb4c6fe5
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?QUphYVBmRUlVNjNXY0EvbXVlNmpDUVJVdCt2MW9nc3dTclJLcXBMQjIrU1Zw?=
 =?utf-8?B?WjFCNjFZL2s0bElyUHVLYWZ1OEMvNzJTRHR2ZkpxeStMaE53V3hUNmdvYmxV?=
 =?utf-8?B?cm51NHZDSW9TOWd2M3ZGSG5nQVdQc055Mm51ell0WTVoNkhzK1YyQXI4MjdV?=
 =?utf-8?B?VVpOM0ZDOU5RSi80a2NyQ0xMWlhtRWsra05TYjlPOGtKWjB3ejdsRytOS2F2?=
 =?utf-8?B?dW42a3krcml2RWF5Nnh2dm01VjQ1UFRHSUh0eFVBS2QyUms0WUY1a3k4aVJJ?=
 =?utf-8?B?WlN6OFliMDhLMkliY3gxUlRSNm1nNkdLZlpNc01xSW1KazREOVI3aXRReUJ5?=
 =?utf-8?B?emFvallsYUdTNlBielBvYWxTdldqWXdnVTVUeEhTTDNOcEZ4aVl5cVNzd09E?=
 =?utf-8?B?cDlCWCsrUnZJY2I0VGNwczBLMFRSeXQyNTFrY001Y0pKaXdIdVFYVVlYWTg4?=
 =?utf-8?B?aXlCRUpTbk5FQmViV0Y5cWtvejhsMHhtdU5LRHpPSGE3aThDWjZHMzQ4OEpK?=
 =?utf-8?B?WjVtblRjYUwxVWRzWlpsTmllT3cwZ0FRektEOE5FdXR0M2k2SUVVbmpxblc2?=
 =?utf-8?B?blNMMFdCNzlrWExlN1J5ZXR3RGpaS3hhREtXMVFrem1tRlorVCtDWGpaZStY?=
 =?utf-8?B?dzBPQmkweC9yZHd1dWtIQXY0OHdxMTMxem5HbjhSR2ZGNzNFdmZwWm5BYVFi?=
 =?utf-8?B?aGllVDVUeXZ3bHBra3RLWFNzMzV4NFNHMTFJaldJbDVFTHFOcG9KUXU0RVRh?=
 =?utf-8?B?UjBxbFBtZVNKaXVadCt1NGl0Q21yNXlxY0pTa21MRDh4SGFTTU8xTWpveXgy?=
 =?utf-8?B?SUR1cWI4UUs3TmZyaTNDblhHaUJLOHNnODdqd3FtbzBNSVRJbVpUSWpPQ3Na?=
 =?utf-8?B?M0xDREU1dTcvU3JPd3ZQcWdCMnJnWTBoQnBlMmtaOGt3U3R0ekE5UGExZDdZ?=
 =?utf-8?B?cUtVVGE2d0dhbkNTdTYzQWFZb3JyTm5yaDVwcS84RlRLUFBSSmEvSVpJK0Fm?=
 =?utf-8?B?NDRaQlRKNCtEYWpOTkZHU1ZUWXpidUM2UjFQTmhGbDhGdWtKSTFYVnJDUEgx?=
 =?utf-8?B?V3NxY2NqV1ppY2lZUzk0OVFjZEJGa2ZRUGEyK0luYmhLS3ZwRkpyZ242aVN2?=
 =?utf-8?B?M09MM1FETG5IVzBPeGF0eFhDSEF2c2YwNDU3N0hqbDVGNmlxRFNmVzh1ZEp5?=
 =?utf-8?B?NVc0RVRCbkRKcnR6MGUvZVI5ZEFtUFNpZ3hIR0NWRFFobEZMaEVmai9YeGFO?=
 =?utf-8?B?M25KMnhXdm55Nzd5QWNSdXJpWXZJRmd4ejZnVWhUTzR5dzcwWUFOZ3JyS2pT?=
 =?utf-8?B?NnAreXdOSGttK2FRYWtYdytpZ3FjVllRWGxHUEZXMTlOODhDVm95TEovYlZO?=
 =?utf-8?B?SG9lWUZ1UjFzY21yeEVTRlQ5SDgrZW1TUUxyZUx3Y096ZVRlOVVXbEdBMTBL?=
 =?utf-8?B?RVBReFE1Uy9ac2xFSjJhRVNyRHg2d000MUFwMXBMRE56b1NkV3BpbEU2Nlg2?=
 =?utf-8?B?NU5remRCbnlSVWVMZEltZFFweCs1c3hZaVJNNzRWMkVjSHdVQldSUW9JKzlB?=
 =?utf-8?B?bVZsNHM3SHRsaTB0UG0rRzFrdVAxVERtWVQwa1hxcGxGalJaOXFtWG4zdGR5?=
 =?utf-8?B?VmE4VmU0ZldVQ2lYV0d2VkoxSlVxOUMwUUNhMksxT001MzdCWEtNc0VNejB2?=
 =?utf-8?B?OEN1VEFjQmhkRjVKbm14TUlXbXM3dGd5R1Nnc3dhcUNoVWNWN3JGNWs3Sjg3?=
 =?utf-8?B?SkM1Qk5Cc2NOTEpvaGx3UzhzaSsvaUhnbDFPOFJ6L3p3Q1JsZFlBQnRuWkhO?=
 =?utf-8?B?NWFEYSs4TWNPcjRJc1JjUkY5UU52eEM2YXVCZVg0ZG1VdFNpaUlhZWJFejB4?=
 =?utf-8?B?UTlIVmxYb1E3cCthMTBmMGlNVXY2Rk1ObVp1bXZvanloQ2ZsaTlabk5RWWlh?=
 =?utf-8?B?USsvRGZoWFhNdHdYakNzRXBHWExuVUdWcUptNW8vWVE5TDJUSjBUVTAwOS9h?=
 =?utf-8?Q?zLlgd24SpP/VnqI9pCdZvSNPR0Yo/8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?azgwNkNtUTZvSmVZQ0tjY1Y5c0FBMXNma2l5M3drS25LYUJxaHdIWjROWFVt?=
 =?utf-8?B?dDFRbENIaGpnZU1JM1IydlZ3TnVOVW1HQTFVRHFSZjRSeWxCeEJqeGVDMitl?=
 =?utf-8?B?Z3MvWmhsNGlEK05HRGxUUU1JbElIVGZTdGphRGt4SU1YbkhiK2NtK0VzZnBP?=
 =?utf-8?B?NzdKbXhhSys1clZrcFExd1RIalNsaWpEWlVvV1B0RGEwMWF3SnZ5RURxVkdJ?=
 =?utf-8?B?ZWwxNkJZTjBTZWtFQ0JUUnFZRUVhY2tmUzc5Zi9DODZmWFhrb0hVQkx1UXNt?=
 =?utf-8?B?RWpmQitQUVA1QW01UjRTQ2c0Y0VOUGtTelROTE10cVlobmFKVWtIeWtlUGVN?=
 =?utf-8?B?VGFhRGtmandaR2lvMk5yR2RFZTNHZko2T25mSExXamJDWTQ5NlZLNnRIeElK?=
 =?utf-8?B?eEtRS0FlVVRITzFhTkVVZW5PNGpydXpabjBMclVLY2pOd3NtZU4wZFZaU2Yz?=
 =?utf-8?B?dnIyclRBbmdFOFJMaXk4TFh4M3FVV2dsdmJ2c0NOMlZQbUt6R3hIenNxNFBM?=
 =?utf-8?B?Ykc1ZnhjZHNvbWZURHVqb1hSWUFUaUgzVkFlRVFZZ3o2Nmo0R3Z0ZER3eE1i?=
 =?utf-8?B?dTFmRG1QSDhRak1LQlFkT0FYY3ZRa2NGVWdYYlB6aW95dFJKSEh2b2FJd21j?=
 =?utf-8?B?YVFkY3Fwcjd2eXVBRjRsY21wa090cmJiSWdUYUlWaXBiR3lrK2VscUVwM21h?=
 =?utf-8?B?a0Q1SDB0ekNjTTBUZGxTcTlMUUlTS1lNVzFjb2JtNDc5bFJ3b1NUZDlFdVJr?=
 =?utf-8?B?SFZHeHRSaVIwanJoNmxiSDFCZEx6T0N5WEN1aDVacGRtbXUwUFh1R3dQcmVF?=
 =?utf-8?B?QmFMTURTalFIVHZXQTlkSUpqclJJazNkU1RXNkdIU25nVzNwVFRZTURPc0Fj?=
 =?utf-8?B?emtLV2VieUJ4Wm9admtldlRIUnZUaUZYQWpLaUphUHFpL1d6bkFQeTJvelhl?=
 =?utf-8?B?V3ZOK2tVNkgwSGdTMnozcDFhYjJRZE9DeWk3RTZxU2hMQmFHT1pyUDhTM3VH?=
 =?utf-8?B?Y2cyaE1yanVBaUJBbGp0NWlGem5YTjg2ZWl1YWovOXJRb3lhMmpxRjJhbG5a?=
 =?utf-8?B?NEVtMzN3SVlzcWlmL1dWdTRuU1RZS005SXR0bjFXdFpaTmdTaTVnbGwzZjVa?=
 =?utf-8?B?VmlSdmU5VmYyZDc3T1FvOERpMWpkdkRTUWZJa2dIWWFGMFdGdkVEZm55RStR?=
 =?utf-8?B?Ry95WnVOUkhYQ3VkRVJJemJVRUJleW9pekVkdWF6dDE5RmZTVDVLMDNXLytv?=
 =?utf-8?B?VlROYnl0NCtqL0ttL1FKMjZ5OGlNQ3VPeWlkZHRZZllZZW5xYWVJR04zV0pW?=
 =?utf-8?B?Z0tuYzJob2o3N1RyOUErMXNIOUpTTVBmR1ZINFBsN2lkM0E3ZGtxUkRjOW13?=
 =?utf-8?B?SUtDZjZZR296enFFeTlwcDNVc0pqeXc5dzF2WkpmL3BDYzg4OVVUTXoxUE91?=
 =?utf-8?B?S3RmbWtXT2RZWTBpR3JUL1lCYWxlTThINkhhT3p0RFZXb3VwQkplNytKWlpx?=
 =?utf-8?B?eWV1Tlp4L294S2gyNUVFOUlPbThOc0s4UndqVStNd1N6SnhmMlR3WXFPdmc1?=
 =?utf-8?B?cEdpdmpqMUpBcVRyQ0NORGRsMHIvTXk4MWhqWWJiYXVIajlOTWg1RWtEU1Rt?=
 =?utf-8?B?bWNrYUNQY25EOFR0N2czWmRQWkQ3MnNYQXVEOVFVNFpkRENGV2dUdDVYb3Vm?=
 =?utf-8?B?VUdkOGs3Q3VrS3Z4RmREbWUzekFnVWFDNHYzNUdKc1dnQUI1VHJHRWJ3UWVV?=
 =?utf-8?B?WWRxYXhEenptVHgrU1FKYmVIRjNzTlQzTVFoOFMrUTRrOU5CUDF3SWFBaDRY?=
 =?utf-8?B?MGoxd05ZOXhkb1FrQ21aTVlGUnB1NDJMMGNvdFFTbDM0Z2tJNGVuOVZuMU5H?=
 =?utf-8?B?Tm41Wi8rbDFHYm1iSjZwREF0Y0ovdHpnQUNyanJxWHpCM3YvcmNPa3M2NTVC?=
 =?utf-8?B?elUvNjNvUTN3elRCNFhLc1lic0J0WHZaZUFHcjhZNU9NaDJkb2lVdVBLWm5B?=
 =?utf-8?B?WXRBL3IwY0hEK2dDMG9IZjMyOXVCV2NaOUlibGZMa0Z6dWV2VWtiN2NCdTFC?=
 =?utf-8?B?WDVpTkQ1bEVJOWIrN2tuVXVWMStDU3ZXK1MweU9ncnplaU9OeVRoUVo1Nkd6?=
 =?utf-8?B?M2NmejlEUU5seUVrdkZLMFE3UCtlZ0VXc2VydmtZRHU5ZGVwK2xXdGJXci9Z?=
 =?utf-8?B?Y0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C247B44FDD8E9648A07E081AC17B5FB8@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 962e48d1-b1fa-493a-5382-08ddfb4c6fe5
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2025 09:26:26.9443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FVQWGgNzdP+eTGUpbXf++P0syEbMLvrsE7h74eo9L279RicfLHcPjIOgIdsg7tvOpCpJ1o99qI0MggfUFVd0Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB6796

T24gVHVlLCAyMDI1LTA5LTIzIGF0IDA5OjA3IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiANCj4gRG9lcyB0aGlzIHBhdGNoIGludHJvZHVjZSBhIHJhY2UgY29uZGl0aW9uPyBD
YW4gYSBwb3dlciBtYW5hZ2VtZW50DQo+IG9wZXJhdGlvbiBzdGFydCBhZnRlciBoYmEtPnBtX29w
X2luX3Byb2dyZXNzIGhhcyBiZWVuIHRlc3RlZCBhbmQNCj4gYmVmb3JlDQo+IHVmc2hjZF9lcnJf
aGFuZGxpbmdfcHJlcGFyZSgpIGlzIGNhbGxlZD8gU2hvdWxkIHRoZSBhZGRlZCBjb2RlDQo+IHBl
cmhhcHMNCj4gYmUgc3Vycm91bmRlZCB3aXRoIHVmc2hjZF9ycG1fZ2V0X25vcmVzdW1lKCkgYW5k
IHVmc2hjZF9ycG1fcHV0KCk/DQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0KDQpIaSBCYXJ0
LA0KDQpBcmUgeW91IHNheWluZyB0aGF0IGFmdGVyIHRoZSBydW50aW1lIHN1c3BlbmQgdGltZXIg
ZXhwaXJlcywgDQp0aGUgZXJyb3IgaGFuZGxlciBtaWdodCBiZSB0cmlnZ2VyZWQganVzdCBiZWZv
cmUgcnVudGltZSBzdXNwZW5kPw0KSSBkb24ndCB0aGluayB0aGlzIGNhbiBoYXBwZW4sIHNpbmNl
IHRoZXJlIHNob3VsZG4ndCBiZSBhbnl0aGluZyANCnRyaWdnZXJpbmcgdGhlIGVycm9yIGhhbmRs
ZXIgd2hlbiB0aGUgYnVzIGhhcyBiZWVuIGlkbGUgZm9yIGEgbG9uZw0KdGltZS4NCg0KVGhhbmtz
DQpQZXRlcg0KDQo=
