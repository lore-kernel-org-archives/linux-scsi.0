Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BED11D540
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jul 2025 07:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753083077; cv=fail; b=FCUanTFSdVls9xeiZCz8k3tTJxZbM8Bs/i5pNF8bmAAHG8KnkoxgWcGWgJ0SruXl4hXJKqw9FEQisk6+WM15waKew+vyYF/vAN+JSl/lRtDyorMOWy4SAx1kb0Y+Uhuvdf1fZf3gxQc3kyFhDhJd+lBJ6W47OGaBzybPfPrXSCY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753083077; c=relaxed/simple;
	bh=7iizNh8sq6MnaNUqszImKTC3viUaMAz1GqTE/ihdeTw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PpdMYOqzyzwjIKpawcUHSaFiZ6sg3Ve4kta7VkpdR2YiSijjMITZkEA+Qi/3460QhCp/3z1ESv/sowhLKVxFQTzHkHZgaMNuluBo2qkvvPvyHl+VKniPUw2fWo7fD9F7Bye5miJwrXbELj7Vax+U0aTPLzyRFOcolE3t6KuJ4M4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Bmwgz8mJ; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=r/OJurRC; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Bmwgz8mJ";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="r/OJurRC"
X-UUID: ab632a1a660411f08b7dc59d57013e23-20250721
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=7iizNh8sq6MnaNUqszImKTC3viUaMAz1GqTE/ihdeTw=;
	b=Bmwgz8mJBDHYOAx2fQS1GxnanAgm9gIc8IEDyOya3ndyfZeFQ2ZkkqoNCKNbksgnRdwbIATrxyWPQq5Gjl3xMLM309nDe9GjmCpVh0WKE+rptk3p4aJmbkEUl7yrfZrtalzAsLOEiv1ISI5VttnX8VXhoHe0ImguKqhdu6sYQuY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:532ff8a7-6ea7-4eb8-88e1-70a1c04858eb,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:f917199a-32fc-44a3-90ac-aa371853f23f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ab632a1a660411f08b7dc59d57013e23-20250721
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 254417476; Mon, 21 Jul 2025 15:31:08 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 21 Jul 2025 15:31:06 +0800
Received: from OS8PR02CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 21 Jul 2025 15:31:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UorHs4KxA72u4ksSaOcgsirB3Fys+c8ol9Dm3Biz5TVypYqgtg2myE4DnNOydhXqL0D4MNRNoaSUEOQCJrOA+KJ6Fns3jJp9sn7PATe5DCUXniVJgB8Tx/V9MbcvP/BTeb1RbM8FAE7zJf6s/A7gAdZCl4VCp/HVitPYt3fcgDbQouX6QRtSiLLuvNmgwndVmFjz+UDWvgADmSiB5IA1poDw4DA8B7reDowXx1JkmK3gq5BSWiD4oI0fIi1Tu0KSxVoHh/YybEdvF1GLwHOc1jw+fG6xR6Vnn7rK6tgBZxAUUdtnL3HB/MC6CrjLNUEGEUeAxFser3k/Uh6eM9oDiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7iizNh8sq6MnaNUqszImKTC3viUaMAz1GqTE/ihdeTw=;
 b=lugWxvhSbG0/YWsq3yKzqF02PvTpmFj+yblWsCXYDxtSeACLsFlXm8keyw/FeFnklxCpTBtx501rKeXKzfj1nK0xoAuxOrOcTYbMPAMDtsqz8e1nhHJdR1YiuYk6Pi5G2FWY8j3jCXOapqNugr9RGuwqQI/6Nd2r5zXUaGlSxsiTHxJeTTRIfMCPlQ+bfv6tOagw+YbdZV0ntG0PqDgpXUQByVlqOiOgmYCl1DOxACHBHyL4h/SXTUr19yKPfd1GSLjvcYNQ1ZKF4Wx4O5eFamRcOq5CapSWoiXZGkKhr/4IVI8Wvqkrid4XMoPLznzkinlBE8SvPeGT3RfGKhBGug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7iizNh8sq6MnaNUqszImKTC3viUaMAz1GqTE/ihdeTw=;
 b=r/OJurRC2S3OmsgEHACW2ON5xUh3889ZB3n5fiyv8hRot7lkV6jTlQ1PSHflapiPL/Y/8/8cS4VxWaTd5ZvRbdT+FWFxnx2sw6x2jvGfbczPcViO6hHB8C4SggXA7gHu/pvW8bZVt9t0fg9ieomee9Q8sN2xCJQf4bN3jvHEhfM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by JH0PR03MB7509.apcprd03.prod.outlook.com (2603:1096:990:15::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.29; Mon, 21 Jul
 2025 07:31:05 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.8943.029; Mon, 21 Jul 2025
 07:31:04 +0000
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
Subject: Re: [PATCH v2 2/9] ufs: host: mediatek: Add DDR_EN setting
Thread-Topic: [PATCH v2 2/9] ufs: host: mediatek: Add DDR_EN setting
Thread-Index: AQHb98oxmiJ5DuYijkWHn3Htf90eo7Q3/ZyAgAQ1owA=
Date: Mon, 21 Jul 2025 07:31:04 +0000
Message-ID: <84da5ba7d85b8307d209de1cedf0c5cfb4c05940.camel@mediatek.com>
References: <20250718095524.682599-1-peter.wang@mediatek.com>
	 <20250718095524.682599-3-peter.wang@mediatek.com>
	 <a2352960-0586-4e34-8f80-446010383778@acm.org>
In-Reply-To: <a2352960-0586-4e34-8f80-446010383778@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|JH0PR03MB7509:EE_
x-ms-office365-filtering-correlation-id: 1cb7b003-e598-4bd8-48db-08ddc8288d20
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NlRFRWdSKzJWOEpONXFKdmcyNmltU01PQ3ZjMWt0dHlaTFcwTXhkWDBxSFJ6?=
 =?utf-8?B?WlZtU3VYU09mcFFad2FlZ0prd1pCK3ZtNGxvSmFXKzRISGt4L21KUVFUS1VO?=
 =?utf-8?B?dDNtWldCUU9NNkZvb0wycTdWT285U2hOVVhBUWk1Q2RxTGY1NUdhREU1ZnNY?=
 =?utf-8?B?aWZSa1lMWVl4WDVzWTR5UVZINDAwek55STd6ckh3SEVScmd1UjBnSTVuamdJ?=
 =?utf-8?B?dWFPZ1F6amVlZ2l5cHl2ZkdBNmlnRGNoYTVDa0hGdWZIbm8va3R5eDFaL3ZQ?=
 =?utf-8?B?OTdHTm5hMjUxbjQwVVJqZG9kZWdlWGsxRkNWZVFTbE10amgvRWFwbHRwMHB5?=
 =?utf-8?B?VHRxdzkrUDZINTdYNGk0aDYyRzNCdGtVUHdyU0Y3VXF6ZUh5cU83VEM3dGk1?=
 =?utf-8?B?TFpuMWJHUFFwYUlIc3BVa3h6YUlhd2xkRWZEUmpvSStVRE9KT0oxU3cxMW95?=
 =?utf-8?B?VmhwKzM1Tit6N3JCNnZ6eEhPUWpWNHFlZm9Gd21POUZMVkJMZ2VJNGRoT0FX?=
 =?utf-8?B?NnN1SS9ldlA5UzJlaGdXbitCall5dmJuZXpjMnpSTTFDUlRRN082Q2xLdnVw?=
 =?utf-8?B?a0E1ZjVtWm5yb2Q2OFZvaWUvQ2Zvc0htN0FKREtWcWE1UnlPQmU4dWNadmFi?=
 =?utf-8?B?UzV5ZTZNUG9sMGdza3BxVGJpaUUzZkJLTjI2VjNETlh0RituWmxhTnpaYzJ6?=
 =?utf-8?B?NzlvNTNlblNidHhLR1JjeC9XK0hjVEh2OWVXR0paaFZHa3JYNnJvLzJXMmY2?=
 =?utf-8?B?VEVsZHJ1VVZjdTBoZ0hHbG5sZHQycUlOejIrRUEzbUl0VkhoS3dNNGVVd0lL?=
 =?utf-8?B?Wi9FUnU5KzdVeXo3b2pWbHF4L2Vqd0dNRWhIcFhCMitBTlNxblhybjBDYnhu?=
 =?utf-8?B?R1FCRG1SR09nOTdHdVBkTmRtbU1XNHZmeWRPenNqQ2ZGWlhkL2tSSmR4dGtn?=
 =?utf-8?B?SnlKL1ljRUtxczUvUUg3c240NHErQkxHVWN2blV3R21qVDhwZDFPVWQzOVNv?=
 =?utf-8?B?MlZNMnlzTUI4UFc1WENSeEN4UlhUVTh2bmg0NzFYK2Q1U3hKRmx4N3JBcVlm?=
 =?utf-8?B?VldRajhmQ1FuZlUxRWt1TER2VG81MDIyeUovbWZiS0ozZUZUeVQ2ZW5vNzdU?=
 =?utf-8?B?QXI2R0M3RDFGN2ZYdVMwU0dOaGRXTGcrcXlXbm4xTk94bm1MNE9veGl1Nmg2?=
 =?utf-8?B?TnBvMkVhbUY4UkMyM2czWjhXZmRIdWplNDdDY0JGNXoyTEIwVENRSGh0eFdR?=
 =?utf-8?B?bitzK2d6N0M1Zzd2MFo5YW9pKzBpc3pIaDFjRW14V0dMRURMU2o1QjNSaE0w?=
 =?utf-8?B?aVFaeW9IZUhHazNRaWxPWk9wc2F4aGR1dXY3U3FNSXNkY2lTS0dzSytlZ2dM?=
 =?utf-8?B?bFVoV0dDTzZwdHBZYUFwblROWTY5aFFRdG5nTGFrT1dHb29CSkFXSnZXMzRQ?=
 =?utf-8?B?Q0dSNll4MTVuV0hEZjAwLzVNY1FJc0dhcExuM3JnOTZPZXM3YzZwQWY5OEtM?=
 =?utf-8?B?THU3L3JBUnBHVjNxSEJZdVhTWFJ3SWFwT29jS3BmUml2K1NaWU9Xa25lMVk1?=
 =?utf-8?B?T2hqN0R3Z2NUYlRQOFJhdEwzYWNoandiS2YvK3l3SnhaZm1XczF1TnFlQmZa?=
 =?utf-8?B?WHE2QldqUWVzdEFQQlBKSGFFK051M1RPU3BDc0hzbHIxSnUxNnJxRkNSVTJi?=
 =?utf-8?B?S2dOcHgwcWtVK0J2T053SEdJamhWY0NHT3hqa3FuY0h1cm52OTd2Nlc2azVn?=
 =?utf-8?B?UjNaRDRpdUUzRDBHVjZVU1NoSnJKL0Y1eXRjY200d1NYWUxzZjhSMHVXTTVG?=
 =?utf-8?B?MWJFcDJKc2VlUkJ0V2NncnJ4QVZPTmhsVkhobkRNY1A0dGVMbzljdUdJWDdN?=
 =?utf-8?B?Nm5DeWJXY0FRZEJjbHdZQnBHRE1UeVU4azAwdEozdWM2dVY2QjlKRnMrVDlm?=
 =?utf-8?B?ZDZMU250aFE0YVlKd3dBVG1LTlVqREpFQnlER2xJYWNwbzJGSEdHMWN2aklP?=
 =?utf-8?B?VTI4aHhaOW13PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SGVrMlBXWmNCZHlTSmJraXB6OUFEenZVK0QxdWd2WWNKa3BxNDFzaHFRM2xE?=
 =?utf-8?B?ODI4QzFqYlY5R3ZQWlJXeVJOYUhQT1hORThjQmRqR2ZOK1ZJT1g2MjZ6MCt1?=
 =?utf-8?B?aVB3QzMycTNncUJJNWJHbUg5TzhQYjRMK3BndTdRdlRMUmlYTDlaeCtLV2h4?=
 =?utf-8?B?VWVUNVdOc0Q3YzJiYlVNbW4vVHpxMExMWnA1V013ZEhrZk9MNTNFMmpOL0Jz?=
 =?utf-8?B?eXVVWCtIN2s3RFkyb1dWeVZxTnlZdjFXcGFJRnpxT2RzcmpUWjJTK0dXYnJO?=
 =?utf-8?B?amMrNFo0RkgzUDlKcWZ3cDVVSU8zdkdrZTRnSnBESU00VGxuNVBiZ3NzSSti?=
 =?utf-8?B?RkVVMkhWbld4VSs4R2l0ZTRaM3AxWGVDUjJEOTRxc2k2MktDR0t0Y0FBNjJF?=
 =?utf-8?B?SDdrWWxyTElxTG5BekU1UHFydUovRklDVzhqd2hiMnZwbkxEaURBZnpPcHZX?=
 =?utf-8?B?enpSZHVFYW4zZ3ZHNXZQaFBsNUVQSDRJUlRWc1FsN3dzT3FSZmVlMmw2Y1Nx?=
 =?utf-8?B?SkZGbDZJYm4xUXBEbXk4WERXVlFpZ0dqMFUzakV1bXM2c3hOeVlTSzhHMTN6?=
 =?utf-8?B?dllFOHEwRnNYeEdMV0VXQ0VYZndncXN5YkVrMUpyMUo4dWxlTHl0ZzlNRU1H?=
 =?utf-8?B?enVrQy9va09OdkpEYTZVeVBjeDZVQThxWjI5T29TVG4wZXV5RE5hUmNrMm1Z?=
 =?utf-8?B?dEpaS2tlcTNkWXFHWDBZajZhZ25MQndrSWg1b3hTbE0wd25mYzhxaVllMFhk?=
 =?utf-8?B?NjFBRTlXMEhwQncwZTBTai9jTHMvUVExK1NHUHQyeGpQVyt2ems4RzNBMERq?=
 =?utf-8?B?WEhrWHVid1RvNHRia0JjUkNNL3VUR1lzek00UWIzamd5bXkyczVhM2FDTmhl?=
 =?utf-8?B?NWVWOWF0Y0RzaGpFUG9nczVtakYwOTJGc254VGlvaHBTdkxmZTA1L1lvVUh2?=
 =?utf-8?B?QXYwVFAzZVlzWDFuRWNjV015VllVM1NxYlVxQzVwU1JINVMwVVA3a05YOHIw?=
 =?utf-8?B?REpKSUQwMHVzNnJqanVQR0IzQTkxOFJyS2pLeDN3Q1dYeW5LSmRQRTBmaFND?=
 =?utf-8?B?dzBqZ1BqRTRQcGQ3SGtLLzJkVkh4SU9VbW95SnFuK3dKUWVGZk1mb2RWRVdZ?=
 =?utf-8?B?bEpWN05IVXVNWEZrd3RyOU55cmg4Wi9SNXhHNGk5TC82eVZQUDR3SUlrK0Rv?=
 =?utf-8?B?UWtCdHhzUk9QZ0dnVjN0Zjl5bEV6TTdzajFoL0liRDRMMjNBWnBnUWtvR2F4?=
 =?utf-8?B?ZmtpTmw5cGVNT29rTHVSRzlQS0NhelVBdUZqTnJQbXBZYWhlSlBTb3JmUzFG?=
 =?utf-8?B?b0VqRnZnZXRyaFBsN2doQVhvYVRFYUpEekRReDJBcmttYzVNNUtuYThadGMr?=
 =?utf-8?B?cW96Z3RRUWNSRlRjaWpHOStBSTltR00rWEtJdldTa1lvWG1HSDUvVE1PVnhx?=
 =?utf-8?B?N1cyYWZDV0Q3R0pmRHBnK3ZRZjByR0pBVjVOdG1ib2xGZGtNY042QUNJVFhC?=
 =?utf-8?B?Nk9NTjR0ZlczVkxWMWV3djZTdWpJL0JXTjZZVU5PL2Q0OWJSL05PSm9SM0RW?=
 =?utf-8?B?SnpuR2RFclQ3b3ZsVm4xR05uUmJ3WjZETU5WSEw0dmh2aStoY2ZTS3BodzRE?=
 =?utf-8?B?cEprbjNaRHFmU2ZnYjFQUUZBcVZZLzE2Y25CdWUzZHpjTWxIeW12Njd1dzRW?=
 =?utf-8?B?TTBHZGpNd1NkazVvbWR2SXZoL2o3aTVyWEszOTd3dzJSU1NBK0ExaTRBVkVZ?=
 =?utf-8?B?K3pYd3h2cks0eVY5YUpicVo4VjBuVE5lTnZZbnp1azY4dFBkTXBwNjJvSDAw?=
 =?utf-8?B?ZGFJeHlPc096WUQvMlVlWE9lWU5lZWxKWkttR01MRXBmdXR6Zk9oTzBKeXEw?=
 =?utf-8?B?bXZ2UDJBUEFTWHdTeS9PR1p4OUQzUzRsM1NkcE9VQzVjeSt5U0pSdmN6U3FC?=
 =?utf-8?B?OGpwRXRJRlJidVR2WWFsdnVnYy9vRW55MGwzWDBTN2NEc3VPa1piQmFvcDFq?=
 =?utf-8?B?clVIeXV2eE0wTHB1Zzh6ZFZ1UXAzazZNRTVGY3BlcWVQNDZnT2RRQWwxZmYv?=
 =?utf-8?B?WXVpMWFyTnVSMVRDbDQvSzZWODVHQXJ5Z3QyNVBuQUg5Q0VIQm5xYXFtV1NM?=
 =?utf-8?B?RHROSkdDWXBIL1RiVStEL2l6QnNmbnBKdkdsVkcvSmJCckdGNEJmMEo2U3or?=
 =?utf-8?B?REE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE5F8560336C054999A56D7BE348137C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cb7b003-e598-4bd8-48db-08ddc8288d20
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2025 07:31:04.8080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yemiKfKLRz4pel4MIh0zq/xhK3Jx3vYjSCppdEGpdUgteDkiiVZVdUnTMWmaTnjVO9q7FEAYmQoIlNbA//tZeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB7509

T24gRnJpLCAyMDI1LTA3LTE4IGF0IDA4OjE0IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ID4gK8KgwqDCoMKgIC8qIFVGUyAzLjEgKi8NCj4gPiArwqDCoMKgwqAgSVBfVkVSX01UNjg3
OMKgwqDCoCA9IDB4MTA0MjAyMDAsDQo+ID4gKw0KPiA+ICvCoMKgwqDCoCAvKiBVRlMgNC4wICov
DQo+ID4gK8KgwqDCoMKgIElQX1ZFUl9NVDY4OTfCoMKgwqAgPSAweDEwNDQwMDAwLA0KPiA+ICvC
oMKgwqDCoCBJUF9WRVJfTVQ2OTg5wqDCoMKgID0gMHgxMDQ1MDAwMCwNCj4gPiArDQo+ID4gK8Kg
wqDCoMKgIElQX1ZFUl9OT05FwqDCoMKgwqDCoCA9IDB4RkZGRkZGRkYNCj4gPiArfTsNCj4gDQo+
IEkgc3RpbGwgc2VlICJVRlNIQ0kiIGluIHRoZSBjb21tZW50IGFib3ZlIHRoZSBlbnVtIGFuZCAi
VUZTIiBpbiB0aGUNCj4gY29tbWVudHMgaW5zaWRlIHRoZSBlbnVtPyBJcyB0aGF0IGludGVudGlv
bmFsPw0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0KSGkgQmFydCwNCg0KU29ycnksIEkg
dGhpbmsgSSBtaXN1bmRlcnN0b29kIHlvdXIgcG9pbnQuIEkgd2lsbCBtYWtlIGNvcnJlY3Rpb25z
DQppbiB0aGUgbmV4dCB2ZXJzaW9uLg0KDQpUaGFua3MuDQpQZXRlcg0K
