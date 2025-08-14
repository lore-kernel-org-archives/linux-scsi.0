Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC6D134A8
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 08:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755160127; cv=fail; b=CsHUUr+YmGqMWmJzqMPJgzGYQLqGbWB/0aWTwsgTkjkOydVeaDS0JuGnsDzzSZFzPW8LTlHv9flxC7bu44BdgVgb9O35hlBQXf5KAJiwjhq5zDERZWzEvB6b61P11ZAAtYxJZx1T30UAWFrBQlm25Ew8vZSdjXayUFH87bR0C74=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755160127; c=relaxed/simple;
	bh=hRS/Q0JEtfvP7GWeDpByBWFfB+wiRXUjwhNZCYNUZCA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Xcf2SBW1NwNBMPnBRbGyHQtyAocKy2vKlDBi4Kqypkka1vqQG8/4UyIlXCTJzhMb4P223Svm6WokLiFpEq0Ae5/uRdT0RKJehPCpRZ3fYt9CQ9jFOqf9mWB3rNGkMhYUSV1sXn9Yp+18Le0y1jFCKPP+41NpgIQQpnpI2DA5NJ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=W0o8szr+; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Z7ajEEUu; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="W0o8szr+";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Z7ajEEUu"
X-UUID: af9019bc78e811f0b33aeb1e7f16c2b6-20250814
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=hRS/Q0JEtfvP7GWeDpByBWFfB+wiRXUjwhNZCYNUZCA=;
	b=W0o8szr+9V0pTX9w7CMGR1PLAT5Q3UWbOFzZaSM9N5vDFjuAEWOCiRm5a3L6ru3vxErsv10HhaKrm0ItBIK7oaaggYQOsr/2UhWCfen+Uiouoai9xLMDv0yIzd9MT4fL/QqYtY3UI/IoSnxNwP1Gq9MiaoWEt27n/TqYhcRpbdM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:e850b7e8-077a-4970-aebd-85ba7fe3aea6,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:f1326cf,CLOUDID:0759edf3-66cd-4ff9-9728-6a6f64661009,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:-5,Conten
	t:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: af9019bc78e811f0b33aeb1e7f16c2b6-20250814
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 375097420; Thu, 14 Aug 2025 16:28:42 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Thu, 14 Aug 2025 16:28:41 +0800
Received: from OS8PR02CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Thu, 14 Aug 2025 16:28:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K9hjOLL33ZaE2ZucaaP7Gg5vlIDmoFUlMZNK0bv2gKpAaF2LIhoTNe/3ID6ZL6MDU7TsenSDEIWPOrezSq8Oy7t94XjsUgWzH8PRGaDZEvrR8KYMxiNxYzTYTaY04cpCqsqzjVGd2ye1vyu5EhVGQlDUxoYvvnVg2hG/w8rcuOoqx4uRq/+VZPnRU3sVkooKaXDqNuchXEAzDSGisFRJZ5PXguSUVkYfbaXlJwZfeewfgd5jWahda2kRWeTU2XutimtibMeHoUK7QDdmjHxMXiQo+vaWnVbBLjpd04qs499dR+jRoAQDe8HZmaRQpW/ZRNzZr/0MtkqTMgQX6KGEmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hRS/Q0JEtfvP7GWeDpByBWFfB+wiRXUjwhNZCYNUZCA=;
 b=UY28XzDRHCOOemaBAc/qLPWlyqlG8/vWxDvz8NLb8TBvM1YlXJ/V8N127WmIEYTwlTzld+KJsDLzrtn67PnpG+UDMipo8GAJ8/cghpAcUhUWzv1iQu7fb0i3uPfFNHS/76tINrJO0U89Kssvwx16mgsYPSWDO9sROOo7fUW+0cAP2EH7nukPj1DwD6Rl0J7z4g4knByHvJTDG6LpDvKqbcpBqfFqafh0B4yTtI45pqbOMI7m+XlwyAeT0QtxtHwu7SFL9Rcaw/ohh3dnKeBOWr3ENQjxaKk2qkiqqDu4EJCTcegxnhNFkobrVXQvObFjEYnDJ++OGHR+Ay4Gx5Y8+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hRS/Q0JEtfvP7GWeDpByBWFfB+wiRXUjwhNZCYNUZCA=;
 b=Z7ajEEUumLew4YnSNgR2BpDApw1mycvDUjoaSB48plYO88cOseKuS1qvX2NnPCF9Wiv8ewy3JboJh1+bIsxgK0W2pbBitJ48hV1fGvOEDWxKpjGFjyrZbLGShTHSiu3CagAhuj0InvZrwkY1C+EnefwqekokH61iU4Pzg8DCto8=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by OSQPR03MB8698.apcprd03.prod.outlook.com (2603:1096:604:28f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.14; Thu, 14 Aug
 2025 08:28:39 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 08:28:38 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "mani@kernel.org"
	<mani@kernel.org>, "avri.altman@sandisk.com" <avri.altman@sandisk.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>
Subject: Re: [PATCH] ufs: core: Improve IOPS
Thread-Topic: [PATCH] ufs: core: Improve IOPS
Thread-Index: AQHcDHVWtz3rU9kVDEiO9hO+dWi6vbRh0fGA
Date: Thu, 14 Aug 2025 08:28:38 +0000
Message-ID: <6413b3a930b073440793f2dd1578dd2ec8bd7b18.camel@mediatek.com>
References: <20250813171049.3399387-1-bvanassche@acm.org>
In-Reply-To: <20250813171049.3399387-1-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|OSQPR03MB8698:EE_
x-ms-office365-filtering-correlation-id: 8bb26717-14fe-48fc-d9c6-08dddb0c91a7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TFA0d09vbVRJSVI0RXFmZUdSUmU4N3N0dW05SnhlY0dQM1cxOUVzT3ZXOTA3?=
 =?utf-8?B?bUN0bUxqYXRmM0dIQUFWOEVBS05TbGpEMGhVRDE3bDdjV285dkUrTHBWanBj?=
 =?utf-8?B?UFpMTFYyWWJmK2IrcFZRZzFKQW80MWorakxtVytwWXIzd01QMnp2Q0p1VE0r?=
 =?utf-8?B?N0tDd1NvbEl4KzNWVU9wZzFaRk5FMit5cGhrN1NJUzNSdWFiNDJWc1ZwMUYw?=
 =?utf-8?B?RUhCc1EzSXcvSE5aeXRMNkVyK3VNcHZVZmxZNmJtdS91RHRHNkI3OCtUaG15?=
 =?utf-8?B?L292SXVQTlV3MExJVnhrYmJFei81aXZWdC9LcmQwUnpYZnVkVWZZYlQ0MXNZ?=
 =?utf-8?B?R0tHSlJEcVJ0ZCsxQTJVaUJRMmJidUtITWlKa012V3dnTFRYZ1pVdGhabWxF?=
 =?utf-8?B?Umg1ZkphWFhWVUljbmhVTEE4WFVZRDFXT3ZmZk1HL0crR3JEcXdOSFJyRmZi?=
 =?utf-8?B?WDF3RVdzMHNQbXFINksvNGk4c1Jqd0YxWjROcTU0Q2pIU1J2SDlCMHdhdUFX?=
 =?utf-8?B?ZzIzUDVWOU1STnZZVFFybVV1bkNIekVuYytvUTY2eTZGRFVZNlhqSFlBZW9n?=
 =?utf-8?B?NHU4a1pCeWhKYUt4RVBzYjFGQldCUHlLaTBicE5GR1htZzV5NzJ3T1MvMDRj?=
 =?utf-8?B?QXd5akcyZjduazNXRndDTEFDY3ZkRmNNSEliMWZSYzd5bFM2RS9TM2thUGk5?=
 =?utf-8?B?Q1p4QWwreW9IR2hZRnpGcWJYQXJPTU9MdmpOaDltNFV6VEdVVXdrbEdNdW1s?=
 =?utf-8?B?UjF2ZEtyQVJONnJhc1dMeVpvSzhEU1l1Z1hqOG1MamNoVHRZTXlsbHdCdEla?=
 =?utf-8?B?YWR4a2krZnhMQjNpaWh5M2dlWkhsZlY0RjZXMjRRQTZFTVMzUy9BNnR6SEpG?=
 =?utf-8?B?Q0YrUWtqb1dudjBYbkR2U3pweGV4czN4T2N4MkVkdS9LcmFBeDlpTVVKZHFP?=
 =?utf-8?B?VlVsdmxCdnR1SW9WaiswQ21hMy9UYWJvbElzZ0Z5MUlLRVVtdWpQSXFKU2tF?=
 =?utf-8?B?Y0tIOHNjL2ZDbVBLNzBPb1JhalpLUkt4YjYwTHJJR3RNZWtvNzFXYzRCWUY0?=
 =?utf-8?B?MmRiWldrb1JsbkttS2FYQmt6WDdoNk5zdDFYUVdBMW1FOEptaWNKUmJOWDVK?=
 =?utf-8?B?TFhiTHlSSFFoYkxSWENQU3dGZUxsQkcwQlVON1BCcng1eTRzZmpiTGNoUjNO?=
 =?utf-8?B?K3lGZDR5bGFwNmFuYlpiaFNVWVdud0tCZkcrRi9yWThia0UyVFpHclRHSDQr?=
 =?utf-8?B?dVlaTWdxcUJ4S2JLZGxFR1JyOCtjdXFlUWdJeHIvTmlMdHBFVVBkcUxia1h2?=
 =?utf-8?B?UlhRS28yMHlwczBCcCtqVXJwdTEvQlVZRzdiNmk2alZKb0dSWUxVaEhsdjV2?=
 =?utf-8?B?Z0cwQ0x2Wk9PV3RNRjZZdmxkcWxZWE4rSkxwZk5jbEk3TVV2aUVJK3J1TmM5?=
 =?utf-8?B?KzRDU29uYTVRZDBOUmlXYk5JeEhJY0h0T29GODhXSGdHZyt0Ykkyajc1RUls?=
 =?utf-8?B?R0ViZmM5dE5LYmpzekxKNlllN3BKa2xDZVpJTm1ZVG9yTDJQa0EyQkhuSkU1?=
 =?utf-8?B?QkY4c0lDMnJ1NXcwVm8yZFlNcnV2c3dRaVphSDRWVmpZODkrWFVYTGFGd1hp?=
 =?utf-8?B?RDBkV3Fkc3cwMDNGdFZEVGxPNmw5eGhsQ1U3dk1KT0ZlVHRaUHRzSzRhSS9Y?=
 =?utf-8?B?eW0rT2pCLzBISEcxY3ZsLzZvdk9UUWlVTW5mTzV5MVNwMDFUMjRBci9ETDJF?=
 =?utf-8?B?b0Z1OVowazJqVnVieXNJUkVrMC9uRGlhcXNOcDBVWXNlS2lsaFZCYlArWldo?=
 =?utf-8?B?VzJHMkFPbDJEVEVtWmgzcjB6ZlptZ050bGprWjgwMTlkMnBsakoycm1ORklP?=
 =?utf-8?B?ajFjQ1V3TzNKNy8weFdwY0FNN2ErM0M0cG5HSGFsaUtxVWMwbFpDckozRFZQ?=
 =?utf-8?B?TjRobTVEWFRjYm9nQmNmZGRNN1ZrMFZJWXJGeXphYUVybG9aelloL2RNN0NI?=
 =?utf-8?B?RjVTQzlIL2x3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M1g0c3dNeTgwNW9lRGpBSXJPWmlrNHBITTJyWUVhYzBnQVo3ZGVseTJZNVB5?=
 =?utf-8?B?eGdOaWVja0hXQ0svNDVsL0tjRlh3ZWp1Vyt2aklGcEdaQVQvNUhxUFR6ZDZx?=
 =?utf-8?B?aGZpS3RKdHVLYjRxb3NpMGM0cDBGbERndUlENUs4T1FNTFFvbVhVbDd1QlVL?=
 =?utf-8?B?TXFvQUNZTWxnK0VKZmcxRW9LekRCN3JiVFFiT2syVGRKRDdSVTh6MGU1bHBX?=
 =?utf-8?B?Y2NXbHR6eDFrWmhsNi9GMlYvTHQyWHYwWmN4UlJBSzRvUno0NzNrSXBwamdO?=
 =?utf-8?B?eStKZS9nQTh2anhGVkpibU9EMWwxK3QwTkVld3pZSldFcUpMSThXS0hURS91?=
 =?utf-8?B?WHJvUzFpM3pLZzlGZFNXSGErV0xIeUhnRDFWbHpWL3B1Zk1RL0VnSHFmdUx4?=
 =?utf-8?B?RG52YkRzUlhra1VUZ0hwMjFDNUZYZC9EM0lpY21xWEFoRDdNK3NiMldibnNR?=
 =?utf-8?B?cXE3N2FIZnVmU2U5K1BEM2MxUVVtYmVTUE5XU0hzVE0xYVdzU1J1SXBLU2JO?=
 =?utf-8?B?d1B5ZjNLcmNHU1Jva3Z2NndrVi9QTFB6bzBZcy9GUHMyUDVHV1RIQUQ5WEFl?=
 =?utf-8?B?c2FYTnhhQlVXWS9Fd0lYUVlPRUhtTXErS3JmdHBCam0zSHIxRTFFNGpCZnoz?=
 =?utf-8?B?L0pBbEI3UUxtdWcxNnkzektuNmwvNFZ6d2t0NHJrZmxMejNpNS9EdVk2bXZo?=
 =?utf-8?B?NVBKcWZoWjJzVU53WC8ySHAwbGovL3FDZW0xS3I0ZXhoN2FUS2pEOEJ3VUFX?=
 =?utf-8?B?MnNXRlhha2wwQm5hKzdEMWsrRkhaWnVrTlpPL0RGTUd6eWxXSC80ZlEyVUFD?=
 =?utf-8?B?MlVLeURWRVhxQ295K3ZEbjkrMmRSb1VLa0RzSWxJZS9EY3hyRU5oRmxZMHEy?=
 =?utf-8?B?VkZjRVhnSUNoNmQrQWtLTk9YdmZDOEJaOWpVcDVRcWRQOWdWRWQzZ09EVXdh?=
 =?utf-8?B?SzJ1TzNmWVlJS0o3bzRCbGgrYTMvUXZidHBZelJJYk9hTmtOUm1TRVNtOU0y?=
 =?utf-8?B?ZGE0UFhMMUd2QnBaT0NzUkFBUHF2dDFCazZPNnBxejg1NlBwa2dUaCt5Zmta?=
 =?utf-8?B?VUZSQU9YQU9mQ3JUbHpBK3A0MDRXWVR5alZKWjZtajhjRWxRRW9LeUJVZGsw?=
 =?utf-8?B?SW8vUWh2SmkwK2lZcCtqejVVR3Irem1LdjhIbEZtZ0VYdHFtZHNDOUFjM3po?=
 =?utf-8?B?WEhmaHF6TFRDdWM0MWpWWjNZNFphTGhTaFNVWjZKZWxWeldBS1pLUmxadFBB?=
 =?utf-8?B?Q0xjKzN6ZW1DMEw1dE9IVUdlTWFvekdEeWdCY3ZnQ1NyMkErWDBKeXIwVVdE?=
 =?utf-8?B?OVQzbXd2bjhsLzJqNStBSFoyamdaYnZzMlhHdkN0L1BOVnhUdHFEZmRYQWxl?=
 =?utf-8?B?K1VUWmlQSkY5eGZqdHFDN1c4TkdDcFFqOUlZaEN5MEtaUWFVU1lER1FVWlk3?=
 =?utf-8?B?WUJpelZobEZKVjlCcERvVjd2UWcraVloT1NmVSszZS9nTk1mSXNBbElEWCtD?=
 =?utf-8?B?cjg3bUl6ak5YVWZMWEFxZ0toQkpSUHBiL3FnUTlCbVU3WC96ZlNuamt1amZ4?=
 =?utf-8?B?YnhtTTJpcXlHODNkNXArTlUxVmpHNG9ZcGJTL0ZQS3JjL2VqeVk2dUFnUXEv?=
 =?utf-8?B?aGxMeE5yVUk2SFRYQU94aVp2R3MxWkdhUE8rWXJBYjhlZXUwQkJzQTJWNXdt?=
 =?utf-8?B?S1pEdjlNYWlkM1VYVk04bGN1YzBKSXRUQ2p5eDNDT3poMVIyTitJZGdzc0Q2?=
 =?utf-8?B?eUxOVGhFTmt0MDk2WTM3TmpXZkdFT2lPVnpuYVp6WGtUMG1ENGIyL2kzKzhm?=
 =?utf-8?B?bCtJaXRtZ1FlYzhVZW80QlU5OHhpQ1lrRWhRcDBiNmFQN2dBelhtZTdQTnFR?=
 =?utf-8?B?ZCtVRGZPMU5pUHFUUmF0eXkyNHcyMytvTGZFeXdqV25HZ1hYUGZWKzhwSmN2?=
 =?utf-8?B?R3IvV1BQeXlGblVteWJzVnNsaWpXU0pGMXgzK29xS2dlVU5sTWdhVmdISjFV?=
 =?utf-8?B?Ukg2UnJJejlqZEQzcEp5TVhKSUR6YjJmdzh3MkxnUHRBMHR2cFJkTjR6dmhX?=
 =?utf-8?B?ZmlzM3RiclZCOG5pVkpzdm1VK3Y1RFk3VS9pZ2J1RnJiRm1xRkRRUGxKRTZG?=
 =?utf-8?B?MFNvYXdWenA0UFZ0U1R4MVRUZ3MvWU9xTXZRemZHUXJKOTVlV1czWjdHU09B?=
 =?utf-8?B?ZUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E953478622C2B74BAA45801412050FA0@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bb26717-14fe-48fc-d9c6-08dddb0c91a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2025 08:28:38.5732
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kzj+31kKxPvskVq82tH5kNkY3+fZVOcfNQhhzNL4pRHMQKO65P2f+E+sY+cZnoSVfbQtI2m6ign/4VsM2uyNXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR03MB8698

T24gV2VkLCAyMDI1LTA4LTEzIGF0IDEwOjEwIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE1lYXN1cmVtZW50cyBoYXZlIHNob3duIHRoYXQgSU9QUyBpbXByb3ZlIGJ5IDIlIC0gMyUg
b24gbXkgVUZTIDQgdGVzdA0KPiBzZXR1cCBldmVyeSB0aW1lIGEga3RpbWVfZ2V0KCkgY2FsbCBp
cyByZW1vdmVkIGZyb20gdGhlIFVGUyBkcml2ZXINCj4gY29tbWFuZCBwcm9jZXNzaW5nIHBhdGgu
IEhlbmNlIHRoaXMgcGF0Y2ggdGhhdCBtb2RpZmllcw0KPiB1ZnNoY2RfY2xrX3NjYWxpbmdfc3Rh
cnRfYnVzeSgpIHN1Y2ggdGhhdCBrdGltZV9nZXQoKSBpcyBvbmx5IGNhbGxlZA0KPiBpZiB0aGUg
cmV0dXJuZWQgdmFsdWUgd2lsbCBiZSB1c2VkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQmFydCBW
YW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQo+IC0tLQ0KPiDCoGRyaXZlcnMvdWZzL2Nv
cmUvdWZzaGNkLmMgfCA0ICsrKy0NCj4gwqAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCsp
LCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91ZnNo
Y2QuYyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gaW5kZXggYjIwZjI2MmZjOGU0Li45
NTc5ZTI0ODEwNjIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4g
KysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiBAQCAtMjIzMSwxMSArMjIzMSwxMyBA
QCBzdGF0aWMgdm9pZCB1ZnNoY2RfZXhpdF9jbGtfZ2F0aW5nKHN0cnVjdA0KPiB1ZnNfaGJhICpo
YmEpDQo+IMKgc3RhdGljIHZvaWQgdWZzaGNkX2Nsa19zY2FsaW5nX3N0YXJ0X2J1c3koc3RydWN0
IHVmc19oYmEgKmhiYSkNCj4gwqB7DQo+IMKgwqDCoMKgwqDCoMKgIGJvb2wgcXVldWVfcmVzdW1l
X3dvcmsgPSBmYWxzZTsNCj4gLcKgwqDCoMKgwqDCoCBrdGltZV90IGN1cnJfdCA9IGt0aW1lX2dl
dCgpOw0KPiArwqDCoMKgwqDCoMKgIGt0aW1lX3QgY3Vycl90Ow0KPiANCj4gwqDCoMKgwqDCoMKg
wqAgaWYgKCF1ZnNoY2RfaXNfY2xrc2NhbGluZ19zdXBwb3J0ZWQoaGJhKSkNCj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybjsNCj4gDQo+ICvCoMKgwqDCoMKgwqAgY3Vycl90
ID0ga3RpbWVfZ2V0KCk7DQo+ICsNCj4gwqDCoMKgwqDCoMKgwqAgZ3VhcmQoc3BpbmxvY2tfaXJx
c2F2ZSkoJmhiYS0+Y2xrX3NjYWxpbmcubG9jayk7DQo+IA0KPiDCoMKgwqDCoMKgwqDCoCBpZiAo
IWhiYS0+Y2xrX3NjYWxpbmcuYWN0aXZlX3JlcXMrKykNCg0KSGkgQmFydCwNCg0KQWx0aG91Z2gg
dGhpcyBtYXkgbm90IGNhdXNlIGFueSBlcnJvcnMsIGl0IGlzIGNsZWFybHkgYSANCmNvZGluZyBk
ZWZlY3QgdGhhdCBpbXBhY3RzIHBlcmZvcm1hbmNlLg0KSGF2ZSB5b3UgY29uc2lkZXJlZCBhZGRp
bmcgYSAiRml4ZXMiIGFuZCAiQ2MiIHRhZyB0byANCmFkZHJlc3MgdGhpcyBpc3N1ZT8NCg0KVGhh
bmtzLg0KUGV0ZXINCg0KDQo=
