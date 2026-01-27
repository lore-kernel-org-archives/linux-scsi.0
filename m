Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FDB2253A1
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 06:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769495808; cv=fail; b=aHtbK1/7VSYnILXTSRwgRhuYVpo627LX22N2bxe+dFVoH8Jkn/0tkbqBg8EXdEFwiR5/BUw8AqYUhMJIyWfkLDz3CaR3u5x23L9jeB6mjhfL869nbtXx7DtCe+r9ZyFh38zQIWW4i3/Mm40tbEbPoeB+SsBiynup9LKovPCnb/o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769495808; c=relaxed/simple;
	bh=ZPJLahQpRpxwPIsbxFUZg2WxCp4NJhwQGBvZjLbY8ns=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LUugoJ6e27kP4IUtkcSV/k5C5QAJ4lXDib4CmQYn2DKcW2/juoHG4UrcUL8wJE3tFno1B/tBxbqyO0IzkGPg7DzIHY9f1zgfaxrJnRCitioyTM3RYV0ZNNh+qcKNF0luRNzfPmRIuhIFv//IHmiXEv+Yboo8cguiUc+MktDMX5o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=kd+1WZOg; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=c5OKIYtb; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="kd+1WZOg";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="c5OKIYtb"
X-UUID: 84c7aee0fb4a11f085319dbc3099e8fb-20260127
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=ZPJLahQpRpxwPIsbxFUZg2WxCp4NJhwQGBvZjLbY8ns=;
	b=kd+1WZOg4sqrzQYP6Z2tMkEAs0ZAgJsKoJ5TDDNGRlvO3GG8iStwrM03y5MeXwE3YL3VW0B6YVQmihb2Bd5Ff1AJsTNkq4n1kqx2jZs9cDY09+ODAap2V9N23Q1NPOf+sRPelY0s7rTojwvWv3O+/PkgygzS30KurJRbk/kDvyw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:eec4c79e-d092-490a-a96a-1b6227f2a733,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:403301f0-16bd-4243-b4ca-b08ca08ab1d8,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 84c7aee0fb4a11f085319dbc3099e8fb-20260127
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1306085864; Tue, 27 Jan 2026 14:36:32 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 27 Jan 2026 14:36:30 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 27 Jan 2026 14:36:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=knpk0/6cLsnaGWXKrGC3bYa0KtqAqDJnHwQAcj/zDH+4QM6kf/qJNbwD1qayrgYV0npxY/LjXkfD+7hUullgRuMNr0Ts1iPJSrcLlC74pMWdkyKqg5X95g6ca/lAzeFStBOsBjYsZ7CRwud8PoZgFgVmSKP4oKCNtxqiHxOsQYA0ddanWOz/X31cLwiOdxwlIHkybWfCUTcDQdSVKbI+eBpu5AK4TETeKnUpfWNzXkSdPaH34I3fcIQSjVOdNX8pnkZv/qboII0DLr22/QBpMSQjh39hwO7AyyCu0PjqPEUyLUIkYqZ40AZ1MSYSlRvEMAOS+Ur3pRpqMD+K3wkZmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZPJLahQpRpxwPIsbxFUZg2WxCp4NJhwQGBvZjLbY8ns=;
 b=fLejxDGiT62WXN26gUNP1G3ofHQsAX0HNtLzvVD6HaUl2uuvtB0qhFZgBHiWDuziKQlM5oS4vg3ZLNKHOsmYyrYNJYrLXC3TxpcOxEiVdITSFQxVNeACesQghIYMtZxhvDTVHu+dxGartd97a92TX+PVqdqoHyxMC5owED5BmPl5PysaHsqJpww4uphBYOPdny4gZwl+3Os6AODtk+sjyNV5KScFYV9nGG58OcdDSLO7PDuImz6cwg7US6U6fX/MJnyLLk2frxxXSe6uFbrOvx/2AitOR3rgpPxECZsGgrPoipNlOjnVElw+dU+anBM6543VCfliPo90HKMS+TsgNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZPJLahQpRpxwPIsbxFUZg2WxCp4NJhwQGBvZjLbY8ns=;
 b=c5OKIYtblkszSaaWX0FdL3mvBjJj40E6Igo2ecVKgho+fQ7N+OVAdxaZosTDmM+8lGTLKt8Wov8nFcTUtFBw9THpSpjWj1grgHuqjSGA9FnFwtMCWZWAOfnt6qHpscuAymxxDrOTeSmcY7lAQXVmuNZgN7Ys0juaW8X8c+grzTE=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB8344.apcprd03.prod.outlook.com (2603:1096:405:27::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Tue, 27 Jan
 2026 06:36:27 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9542.015; Tue, 27 Jan 2026
 06:36:27 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "vamshigajjela@google.com"
	<vamshigajjela@google.com>, "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
	"alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"chenyuan0y@gmail.com" <chenyuan0y@gmail.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "ping.gao@samsung.com" <ping.gao@samsung.com>,
	"avri.altman@sandisk.com" <avri.altman@sandisk.com>, "mani@kernel.org"
	<mani@kernel.org>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] ufs: core: Use a host-wide tagset in SDB mode
Thread-Topic: [PATCH] ufs: core: Use a host-wide tagset in SDB mode
Thread-Index: AQHchxMnto2FFYD7U0aTMA4KBGn6KbVcPxWAgACpKwCACLgfAA==
Date: Tue, 27 Jan 2026 06:36:26 +0000
Message-ID: <e3cf32885be7194ef6ed7bc7f0346c0837f31435.camel@mediatek.com>
References: <20260116180800.3085233-1-bvanassche@acm.org>
	 <a7db442bc069ffa32a3dfa5524eba0a2c6ffd28c.camel@mediatek.com>
	 <617eb7b5-358e-4257-aacc-d64ed109e2a2@acm.org>
In-Reply-To: <617eb7b5-358e-4257-aacc-d64ed109e2a2@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB8344:EE_
x-ms-office365-filtering-correlation-id: 5528feaf-0f54-47e8-6d37-08de5d6e65d1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?LyswZmFCL1J0SzVPRjd0SXRMRGFnU2p4ZWdhWUVYM1N1Q0J1UU5YTlVMUkJ5?=
 =?utf-8?B?MUo5Q1lOYnM4TEllOWJva1JBbUw0MHI3QXpCYUhmN0xvQjZSL1dady9IYkJt?=
 =?utf-8?B?Z1JoRXIzQjRJNWxaU1ljUGVRWGQ3ZURoR3VTN0IyTFNnV1RwdTg3cENrTzhY?=
 =?utf-8?B?RFIzbE5kYW84SW0rSVpvL3JzUm1KdUFua25oUHZWNHpEZGxzK0QxaWRJNnN2?=
 =?utf-8?B?WHFvekgyMGw1ZjdEZS9jbFI5YXVTd2FnWVd1aXZGQTMrQk94VXV1Tml0MXdF?=
 =?utf-8?B?cmc2V3luTzlrUUFzTHQ5TmJKM1B5SnZPSFpKSmxPUFJWQlEwQ2xWR1p5WTgr?=
 =?utf-8?B?cVJXdmNmMjBubGVsZm1ZWS93anFjK0Z5R1JuM0dBZ0lGYk5HUy9oK0pwMlhP?=
 =?utf-8?B?WnVkdHNmbXliRlA4TkFwQmJBakswenR3M2gwVXUwVVhGbW5VQkZqWTI0eXZC?=
 =?utf-8?B?R1ViMitEZlU4Vm1DQ1JzdHVJd0wreGFhbmUxSzBUQzZVamNaZHBhMHhIbzVN?=
 =?utf-8?B?TThDajBtYm45N2xrekd0a3NQWFJTUjZYM0JEYy9tYWEzUkRhRVJYRHB4WDhH?=
 =?utf-8?B?aVhKSGx3NUFWWUtKd2NuWWRraFVnWEVGTTgvczlienBaems3ZkptWDVlQ2tt?=
 =?utf-8?B?WHViRzRHZWR1UXRZcGNsQW5IMGRjbUF2dUprNVJ4YTFXUWtJWUJ0YTNMakJm?=
 =?utf-8?B?Nll4eHlBQkVFSVduRlNvbmVSRWlXQzArd1BWRWV6S0F0QXV5TFdhRFpMek5B?=
 =?utf-8?B?MmMzZmI3YlFGSXU1NURGYlpmSUxlcXB3QzMyR0NwNlRqV2VsbWpwR2duQlZN?=
 =?utf-8?B?Vzl6TjJFekt0QW5TV01YQ1p0ckRScG13V2ZVcDVTbWJSVFB6Kzc0V1p0UlBv?=
 =?utf-8?B?cVBYV3BVM1RYUU5tSFZlaHhWc1M3UERNdGNlWEJuaDEzTHpIaHRoMGNxYnJK?=
 =?utf-8?B?VE1pZUo3c2lmeUlGMDNYUlovaFBtUW1CSFpMQVAvaXhZN3BMTzA0RnN0b3V0?=
 =?utf-8?B?VWVnTit4Y2daZHUzZjBta05JRVFtQUZyRzBySmpMK3gySExDRFozTWtCUkNk?=
 =?utf-8?B?WkdiNFQ1YmJLWVIrL2RqWFFYUUpRcE5ZYXhQOW4vYk1PV3lGWEY2YndSZVlW?=
 =?utf-8?B?SHc4WjJXNWFQd3JjTnBhZ1AzYlF3MVdDNWNWZlgrM014c3RtQlFhNk1WNTVk?=
 =?utf-8?B?d3ZqQXBnSVFVNnZLZ1h6NmtTL3E1NWEwenE0aVpDNEQ2RElWU0NBZUFIb1BX?=
 =?utf-8?B?NDdHRkFUK0grM3N3dWNEK3Z6MmwzTGRHTVhkQ0R0V2NVK2RpS3crdXhJRUZM?=
 =?utf-8?B?MndjMFVOWkNLZk95NExKMHJxUGVxaTZLV3VVNzViazNwQWdpVzAxak5hQzNC?=
 =?utf-8?B?SjhPdUFsUktkeThvOGJqOHFIUmZhRktMWVdudXFRVmIxOWtUMTN3MDJVVlVU?=
 =?utf-8?B?R2dSZGpZbFRmTmJnZHVIaWFaL05scktYeFRXMEdxczgrcWpvVDlub1dJbHBr?=
 =?utf-8?B?anlIbUFzaDh2cnBJNDljYXFiZm1xeHN2enNVd280NmpTeUNta1ptRjFaNFRs?=
 =?utf-8?B?WFdVcURtQjQxYy9KMTRhMUVEeXNoZEc0OUJTYlF0dkNzT1hPNlR1dUVLYkY4?=
 =?utf-8?B?K3VFYVU2YXcrR1llcjkzSFloc2pISklZcXhOYVd3V0M5ejJKTmJtL0N0eU5m?=
 =?utf-8?B?M3Nwam9qcldMOGFsUXdYZTgxbUNBQ3E2Y3NtK1dQYXpXb2dsNDNIaXE3QVN2?=
 =?utf-8?B?akhjTzFRK1RxYXdFQXpnL0Q0N2dpU3cxeFQ0ZVpsZUZSa2xseURiYnZsZ0ZM?=
 =?utf-8?B?K0tMMmJEcW5PTU9DSnhtdStpU1ZMWTNmU2grbVlrTU5BdWtlQlhUbzN2dnBU?=
 =?utf-8?B?cFR1ckt4U0pKSmpHaVh3NTh3ZkV2KzJva2pEYVZjYjdpY0hUVUxMd1BFdGxr?=
 =?utf-8?B?TWtNaG05LzhBT0JJNFFYQno5MjNtQ21RbGlDY2k4WC9GSndqY2hFQm1ibVJ2?=
 =?utf-8?B?SXg0aHdFT01pcFVSSzVZZXp1V0JYU3l6Y2pDNkFMMEg1ek9wbzh5V2pkV2Ex?=
 =?utf-8?B?akFjL2FwUmhoVVFuY3RTbmZNRjAva243T3RjbEh5cUJURUFlWjR4allRai9x?=
 =?utf-8?B?VDlOV2lSclRhOEpFY1BxVUFzdWpwYW9UTS9wMERtRmZNOVRvYUhJR0g1SU1M?=
 =?utf-8?Q?vD9Wwb2uNLajLEtwukexCtY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TElBVEc4Z002TVoyQXM3NE80V2loV2hoRU5tdEUyMmh4bW1pYys0SmtLMWFV?=
 =?utf-8?B?MlpsRzJydE9HVFcrVG1VQlRJdkVoelpXZTF5aFJSUmN2Snd6MUREcy9QWit3?=
 =?utf-8?B?ZHdqdkFDQ1plS3hBb0NYdU90ZUZlWjRUMFFzejV0ZTcvMVlLWk1SaURLRUhZ?=
 =?utf-8?B?MkRzZ0xsbDdFNnNobVdwUnNLenNaZWhsQzJJQXNUT2tJWHlBQWtJaU83NCsx?=
 =?utf-8?B?Z1VmT1VyaWRKYlYxN1VBcUVWQWVnMjZ3OWlxWFUxVlZFT1h1cFB4cXhuZGI2?=
 =?utf-8?B?QlVUV1JiUG9KS29FeUU5cGFMVUx5eGJtLy9OOS9aQ3RDczErVWRuV2MzcnBF?=
 =?utf-8?B?TURzVXRlVWtGNW5NQ3JQK1NrTWVGeXVPRkZpS0VCdXc5SEQ5eUtUaTlieEdU?=
 =?utf-8?B?YlJRU1htRm5kWTBMM3VkUFp0V3g1aUlKQmpUQml4MGJVd2pRWUx4bzlyNHdY?=
 =?utf-8?B?VzNIalpVcmlSRElZQkZ6clpzaDd6SG8zQTB4b0FsRDBpUUdsUkZvNFNGQjZU?=
 =?utf-8?B?N3p2WG1hYng1dENFdEdBWS9GWWZuY29wWGIvUEpIV1lGM0ttV1NjQXZEZzYx?=
 =?utf-8?B?THZwUzJweUgraTVDaCtVdFo2LzFpT1Z2NnNsOW1VQ1drWnlCZ09VNis4WGpU?=
 =?utf-8?B?bDJpdW1QZXpJU3dyeTFGODJ1a0JlMitqaHhtd2dCdmtpZEJudFEvRWN0VXRS?=
 =?utf-8?B?eVNrcVEvNFRKUVVqbWxORStyODVpSllCNHd1blY5ZS9tbFNtL1JGWm1XNlhN?=
 =?utf-8?B?M1JBY0FXQXR6N0d6ZHZaUG5nM2IxQ21wYmNuc2FaVXZBaUt3UlZwM3k3QVc4?=
 =?utf-8?B?akhtSG85ZHFIV21Kc0xvUExROUw4aGRyQzNzTVA2WVNkUStDUVJUd2lSVmFz?=
 =?utf-8?B?Y0UxbEx5bzR3WmJVTCtJVTlkc1RXRStvekFGUW1ITlpabjJ5WHltVFZCQXZa?=
 =?utf-8?B?QlBFbVZCNk5wVVlCSnNZMDNRb3BPK05EZFhzajQ4VXVzZWV4TDZ4aVhISHdo?=
 =?utf-8?B?c1IyU3BqSGIvWE14TGtIRUJUdDJTYlE2S0V2emZxeFlPYWJhUzEvZVNFdzVH?=
 =?utf-8?B?NHpwMDJBbXBVdkIvNDFETEcwakpHRFdSWmcvVUdiclMwRk1qb0hhN1hyQ3U0?=
 =?utf-8?B?ZUc1ZGJNWkdmSFVlSDFWQ2R2bGhJb3dORUtReWZEUmgrRUQrbGFBUDdTK1Q1?=
 =?utf-8?B?STArSkx3Q0VHcElEZGFVSy9CMTk5TEN6TGFEaEpmMnQySTlDMkdUc0R2OW9l?=
 =?utf-8?B?Nksydm5xczNYQktGOHpad01ZZWxydHJnd0Y2V3dZUDQ1dUJhblJBM0xoU2Fr?=
 =?utf-8?B?T0FuclByTnpmK29kaFhhVGVIMGZ3MXBxVWdxMzIrQ0NDQlg0TFRVYlkyWU0x?=
 =?utf-8?B?dzkrYTZrWEpaemI1bHYxMEJyamxOenhJdTNUb21GZUhMTHlONWhjVU1QdmlQ?=
 =?utf-8?B?dEZCQ2VlYTEzSG94SXhJRDhlU29KTFkwbnUwdHkxcUVVazRwUWJYVDJyeEVC?=
 =?utf-8?B?dUJ5MXA0WHlNdXF3R0tvQ3haOVd3c00xdHlTL2Voc25yaUppUC9BT1Jvc2Zl?=
 =?utf-8?B?Zmo0MW4yVGFwTnZkZU9FbHVHZ3h1Nkk3TFRrdldUb211dERiR2Z4SktrNHpa?=
 =?utf-8?B?MGRiR21lRFo4RWl2dzZaUGtsREtMUkVORDl5SmlXUnJ3WkFpUGtJV3FYK1I2?=
 =?utf-8?B?YzAyMi80SXhOSTMvRmpFa0FTTC92aGUwNE9lQ2FaSzFDc0FOc1RldFh5S3J1?=
 =?utf-8?B?c1MzR0Yremx2VEZaOTNQdW4yMGh1LzlhVFY0K1p2am4yQTBQMGF5TFBGaTV4?=
 =?utf-8?B?V1RjWUxidU5UNFNRd0ozVHFyY0d4RWpDeEFSbThTNCt1Z1JWVkQxU3ZrSWhP?=
 =?utf-8?B?dkpKcjR6aktWZHZmRkw2WnhkZzRLdXFmdTZKZUovQU02bVhLMy9SMjZEa1FV?=
 =?utf-8?B?aG9QbWF4TisvdkFyQlNzcTN4NVlQdjlHUDlYMCtxVUwxVUJDZFdPaDNGalJW?=
 =?utf-8?B?amVvbE9MeEVPeGx2YkFtakRrbkR2WWxZNDlKYlFnaFdHZWx0czFPL3pOTzNX?=
 =?utf-8?B?YWF6NkFzbGxHcFc4enZEbVBPd0c3dzVxTEh2cmRZYjE5bHU5OEc3QkNxK1lI?=
 =?utf-8?B?bDd0bDREbnBwclQ2c3RqckRlaHpGREdQU1lQK1lZNW5JT2dETzA3bDFkUzh5?=
 =?utf-8?B?dTlPbkV2dmp3N3dLbERiMlhtL0lJRklHZ25zLzFxSEl1QXhlSSttbmlpUFcx?=
 =?utf-8?B?c3VOVU9lSStSL2VPUXo2dVJKNGo5TUUrQXByN1Y1bytNcHRYNWwzNCtQVEZ0?=
 =?utf-8?B?R3ViZUt6SFJIS29xdDRqejdxVzY2RjBoVlhrZ0xPV3llRUVYa0NGZWttbEU1?=
 =?utf-8?Q?fnGz5OUEHX49sPPg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AEF41DC99DF45F498937BE725FD75D16@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5528feaf-0f54-47e8-6d37-08de5d6e65d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2026 06:36:26.8859
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KY5rtsz3IW53/jXPvbf6RYSZ6GSe6ZzHMdbIePDmMG9ZgocF4PpXgO+5N/GxPd8YwG4BftVwo6Xr/kZcrrtQoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB8344
X-MTK: N

T24gV2VkLCAyMDI2LTAxLTIxIGF0IDA5OjI3IC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIDEvMjAvMjYgMTE6MjEgUE0sIFBldGVyIFdhbmcgKOeOi+S/oeWPiykgd3JvdGU6DQo+
ID4gT24gRnJpLCAyMDI2LTAxLTE2IGF0IDEwOjA3IC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3Jv
dGU6DQo+ID4gPiBJbiBzaW5nbGUtZG9vcmJlbGwgKFNEQikgbW9kZSB0aGVyZSBpcyBvbmx5IGEg
c2luZ2xlIHJlcXVlc3QNCj4gPiA+IHF1ZXVlLg0KPiA+ID4gSGVuY2UsDQo+ID4gPiBpdCBkb2Vz
bid0IG1hdHRlciB3aGV0aGVyIG9yIG5vdCB0aGUgU0NTSSBob3N0IHRhZ3NldCBpcw0KPiA+ID4g
Y29uZmlndXJlZA0KPiA+ID4gYXMNCj4gPiA+IGhvc3Qtd2lkZS4gQ29uZmlndXJlIHRoZSBob3N0
IHRhZ3NldCBhcyBob3N0LXdpZGUgaW4gU0RCIG1vZGUNCj4gPiA+IGJlY2F1c2UNCj4gPiA+IHRo
aXMgZW5hYmxlcyBhIHNpbXBsaWZpY2F0aW9uIG9mIHRoZSBob3QgcGF0aC4NCj4gPiANCj4gPiBX
b3VsZCB0aGlzIGFmZmVjdCB0aGUgcGVyZm9ybWFuY2Ugb2YgdGhlIFNEQiBtb2RlPw0KPiANCj4g
SGkgUGV0ZXIsDQo+IA0KPiBJIHJldmlld2VkIGFsbCB0aGUgYmxrX21xX2lzX3NoYXJlZF90YWdz
KCkgY2FsbHMgaW4gdGhlIGJsb2NrIGxheWVyLg0KPiBCYXNlZCBvbiB0aGF0IGFuYWx5c2lzIEkg
ZG9uJ3QgZXhwZWN0IGEgbWVhc3VyYWJsZSBwZXJmb3JtYW5jZQ0KPiBpbXBhY3QuDQo+IA0KDQpI
aSBCYXJ0LA0KDQpBZnRlciB0ZXN0aW5nLCBpdCBpbmRlZWQgZG9lcyBub3QgaW1wYWN0IHBlcmZv
cm1hbmNlLg0KDQoNCj4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5j
DQo+ID4gPiBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gPiA+IGluZGV4IDA1NzY3OGY0
YzUwYS4uODg5ZGExNWE2MWYwIDEwMDY0NA0KPiA+ID4gLS0tIGEvZHJpdmVycy91ZnMvY29yZS91
ZnNoY2QuYw0KPiA+ID4gKysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiA+ID4gQEAg
LTkzMjAsNiArOTMyMCw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgc2NzaV9ob3N0X3RlbXBsYXRl
DQo+ID4gPiB1ZnNoY2RfZHJpdmVyX3RlbXBsYXRlID0gew0KPiA+ID4gwqDCoMKgwqDCoMKgwqAg
Lm1heF9zZWdtZW50X3NpemXCoMKgwqDCoMKgwqAgPSBQUkRUX0RBVEFfQllURV9DT1VOVF9NQVgs
DQo+ID4gPiDCoMKgwqDCoMKgwqDCoCAubWF4X3NlY3RvcnPCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
ID0gU1pfMU0gLyBTRUNUT1JfU0laRSwNCj4gPiA+IMKgwqDCoMKgwqDCoMKgIC5tYXhfaG9zdF9i
bG9ja2VkwqDCoMKgwqDCoMKgID0gMSwNCj4gPiA+ICvCoMKgwqDCoMKgwqAgLmhvc3RfdGFnc2V0
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCA9IHRydWUsDQo+ID4gDQo+ID4gU2hvdWxkIGJlID0gMT8N
Cj4gLmhvc3RfdGFnc2V0IGlzIHVzZWQgYXMgYSBib29sZWFuIGFuZCB0aGUgY29tcGlsZXIgY29u
dmVydHMgJ3RydWUnDQo+IGludG8NCj4gJzEnIGlmIHVzZWQgYXMgYW4gaW50ZWdlciBzbyBJIHRo
aW5rICd0cnVlJyBpcyBmaW5lLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0KUmV2aWV3
ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KDQoNCg==
