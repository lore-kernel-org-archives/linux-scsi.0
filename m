Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202B8390CB3
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 08:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776761113; cv=fail; b=JcPHbdkVjmfc4Z6gWn70JqJxEu6GWcILB9ACxDY9I9mKKo/EZPSYDji8/9nPoX3mINi7Z254mF24D4e/KYFIt60pADAXhcZbs/YS3QD2LIRzhN0mbh+rXbHCNMEDalv107OY35Sk6Hr2vAqKAj9fC5m9G74G+N6v0hbmK/uRAYk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776761113; c=relaxed/simple;
	bh=TaO4m8ALdpDoIVr1fnqp16fbCUP9LfwmFf8YUZwc+2k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BDuHCUxW8YybkFcIv3igodvBVUehL40HPmbdrfzJsHa2PL+SMOJDK9HHyxO33fbpJSKzy34l5EznGB+7la432zkDyxDDcZhjnQbtIHJJpfX35rr2sVl5rJjbiXEQdTzgfND3qx+Nx+hzCkks1YyKXh3AGdepbgtCI+YT86WtAmg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=bu0VPp2M; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=vHoOOigF; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="bu0VPp2M";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="vHoOOigF"
X-UUID: 63f8b9383d5e11f19781c1a04af40193-20260421
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=TaO4m8ALdpDoIVr1fnqp16fbCUP9LfwmFf8YUZwc+2k=;
	b=bu0VPp2MSGtFtAnHvE4gfB4EgAMDikNKY0VZ1Zybc5fGHHayK7x/icihzToHtUvZmAaYkGssujNDVwdFIHc8G4d2ZHkRCxT2v0JzBLgblCkBb8odXcCZagEYAuHfW7YF6DHOHY1rBQS0R5fr4SAlXSr2eYEVNk4s48peoN1qwt4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:62ada57d-b107-41db-960c-e9628fa3ec68,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:72daac8f-6df4-4a3d-a7a4-fbdc42d669ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 63f8b9383d5e11f19781c1a04af40193-20260421
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 884024062; Tue, 21 Apr 2026 16:45:03 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 21 Apr 2026 16:45:02 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 21 Apr 2026 16:45:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vzuvOpx2OEo/7oNDCPhL/trUqv0rrJgVr2UGC0SK4T2XA3O71fvra7vEwrz92u3GgHw26QsGw5VC/tIRABknu9plzWuCVWJrxg9MarVEihQgyTeAPxwfs95iv6FuHNjLSHov68jRZXSOUTD8LJznqRURbRsr8NUCxSEsmk0DjxBsDSCM1mOxe/9btxW3ASHdAJY+l/f4XHBE9JpXvLZ5O/qpPEU3HNCv0o+Ee73PbH2WmzrLgbetg5khVSzhaGFkK/14Yq/llydBcJorKy0LTV0aE5h8PBBl6Pjz0ypSPiABJL/TxFXo1uZbtyyOH7IBvhXHO2qKHhJN+VWzeA1lzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TaO4m8ALdpDoIVr1fnqp16fbCUP9LfwmFf8YUZwc+2k=;
 b=VwJOSsnC/2Gi+5e2J0wYw6EyFvzsNrK0Ccm0NWVom3I41IYbDdnnG/NVl85cCIYV1G7/xKSUK35foxdiRjaHF5auBOmoeSxbsXSMVTKfr1ifRrVEm1GYJ+toaWiVCrTu96xO3dwW6i4O20thfr80VFOdef98NfCLZfV+xuTe0qGYgo2yWOwmJlpdLKG6iDNRcnRytL/8xY0nnYtYFALeR9zR8qHyiV+yx4iQmQTwBNPIZG9Gokp2oaRJ/Bq9849GkVC6KE6lOT7JtMEFCOzekH2ZK2jJB1IUCi3ijy7FvuRF2Vb8VcSNSMs2+K3Wi5WeD+aeshrSXJymmmRt1p1ZXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TaO4m8ALdpDoIVr1fnqp16fbCUP9LfwmFf8YUZwc+2k=;
 b=vHoOOigFw+DVrTZYN8hOCfo6jH1vJUZEk8MRYUydzwvj/Tctyo9wTMdmhvxsGY0Kv6kUz+6hBha9ZCXGFPIWrntOYqJcD6gwetCOXglJhO/dOG/pppepDWOXINdaDiJaAHbi740S1NrjvdQINfNmUm6fIN1QasFZrz4s112NA0c=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by JH0PR03MB8210.apcprd03.prod.outlook.com (2603:1096:990:48::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.32; Tue, 21 Apr
 2026 08:45:00 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.20.9818.032; Tue, 21 Apr 2026
 08:45:00 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "can.guo@oss.qualcomm.com"
	<can.guo@oss.qualcomm.com>, "avri.altman@sandisk.com"
	<avri.altman@sandisk.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>
Subject: Re: [PATCH 3/3] ufs: core: Optimize ufshcd_add_uic_command_trace()
Thread-Topic: [PATCH 3/3] ufs: core: Optimize ufshcd_add_uic_command_trace()
Thread-Index: AQHczrGOUq1Ly3XnN0iBS/EhVvxRmrXpOOKA
Date: Tue, 21 Apr 2026 08:45:00 +0000
Message-ID: <a186b02b00694be3e89cd49d477c050df4bb1cf5.camel@mediatek.com>
References: <20260417213027.3506742-1-bvanassche@acm.org>
	 <20260417213027.3506742-4-bvanassche@acm.org>
In-Reply-To: <20260417213027.3506742-4-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|JH0PR03MB8210:EE_
x-ms-office365-filtering-correlation-id: 5e0d22be-2d76-4f67-02ec-08de9f824632
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021|18096099003|56012099003|18002099003|22082099003;
x-microsoft-antispam-message-info: /QXP2/JNbm3D3oqq1yfw/CsY31wXCBO5zH1l8GQWEeNBraYaR1OH7c0v8xrqzsGfVhXmwriB/Sh34iCBYnGkC+U8UfcIWdU9XfxDctQu5h/JYXUWO0PBlmpORhrJQIZnl2nCL29Two+ab+qireTjkgUpOBfC3sfvGRntMdxwY0dgVvPqzRpaLqVWHnnb3Ec8zsaOCr+XxhEKvRIfTKRbjRNSL3MqeO94mEIOuWXBFDuurOQUjOaoncRTc30lsZGSUn7JVo5xKFmXCCFVhW0nwzNL/RXX3dxbl2P2LK9Fq0mLo6EtQsQITt5iYtl1w6eN8+HMcRwM/y10P18iFrym3er29fKWZ7Irkle5EkKvfymEOjeAjlH44a+UUU2B4vb3Et3Qnae8TVtCpTMnD+AcbtF0QN+lR79W4SVsHH1WlHAJQJzqBIvh5/DTbuQBVa20REUVdn4hX3yJryY/pXJRn/m3sG9k+BN+3Ywhnj0LPNtcAEcTg97NNGZl5JDI30S8om7YLgbnGxHr/jSQ9h0PuO0kQdPgmKaN1/v4O8G8lG/m0NCquNjSqk8O4CfnRBpORWYntpfHmJ7VvhdzKs6hOWxphDMJ/zj6ppwd7sA1UopsWwP1i8JChRB0FVKssn+wGQs7wpkD0Vhs+SJIMF0qoV84IKsCKa3cOoeFPYJDlrbgRoP25cLlaS9zk9yv+E4FJa9PcfcqA1/ZxEzFKcqfAmpJBYzPzBkASRLb4HDjyzCUr6WomT0foRWzmEe1nWtzgXMFAqHNWsnmCX3hoFdvCEkL2J68GZxOT7YMS6yPZIY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021)(18096099003)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VHozNklPZkRxVnczQm1jQ3hYVm8wbUp3UFI0eVFRNldZajBtNnEzeURsTzFH?=
 =?utf-8?B?MHQyMUQxcEY5cm5wOUtYR1o1b21QRWcxcVViODhYNjUrbDh4UXd4ZXZDZDg3?=
 =?utf-8?B?akVRZlI2aFFFWE5kcFNPY0YrSWpHZktReFoycm4xMUNaNTZnK08rSUxocFBM?=
 =?utf-8?B?M0h4ZnlpcW5sRk40TndBRW5teURQWlZ2elhyOWUwcSt2M3ExaUNVOXEzMTV0?=
 =?utf-8?B?Zi9RN3p6T3hWTnJBMkNJMmlQRmUzQ1hWRXdEMDN6aG9OUmVXMXp5OUpXN1Rl?=
 =?utf-8?B?dmd3cnM2Uk5XMnlhTkRwTXlLR3pudVpsWitrbmpDN1pOc05pTmlzYnljRGRq?=
 =?utf-8?B?VGdSZThHYTY2NWREcTlvOHNFcm5JbUtzT3ZKbEJ1UTY2cDdYRE9JUVlNQ2VQ?=
 =?utf-8?B?a3AvY2E3YjArdlYvdkVzZGh5ellPSDArbi8xVWwxS0RXeXpQZkEwczNibjRK?=
 =?utf-8?B?WDYveS93SlJDaFB2Mkk1K3kyeVVBRUZ4S29ZS2pXSkk1bXZmUmdhUGMwbmUv?=
 =?utf-8?B?RFhacWkxMWx1dDZMblFDUUMvcFIzY1A4U1JuL0k1c2RzU0FCYW0wR0lMcjZK?=
 =?utf-8?B?S1VzUXlwWGVyS3ZZeGtaZCtwOTdPSGh3SUJTSStEK2RzdDFYYkx5dzdTcTBQ?=
 =?utf-8?B?Z1RsK1BLM3M5TlM1b25XbHUzbi9tdnlRc3ZyaGt0WDM4T2VkdXkydmozTW5P?=
 =?utf-8?B?ZG12Nm5EaFJLTG5FczBSZTE0dHU5K0p2WERFYjJHTU9iRnV2cUVJTUlGVDV4?=
 =?utf-8?B?dEJuMGk5eEJ5OTgvdG5jR1gzeUllbXpDMkhFbFhoMjIwOThyeloreW9JcjA2?=
 =?utf-8?B?WFR0aDV6aStoS1NlUURPR3JVbWJqMmtMcWNlVW1XK0FMck8yYXFJUUVMQVNv?=
 =?utf-8?B?ekFYaEo2RmVIUkdpa2NUZzY0aVJOR1ZNZlBMbXNhUUoxWkRjZkpxUUltS0dx?=
 =?utf-8?B?ZC9lelo1YmFDWm10QTlOQ2xSSWFKN0Q1T2ZTaEExcGxUTk1YNWNlMk9naXlO?=
 =?utf-8?B?VkZJUCtxeGg2NWpzMkxuaWJEeVNSaFE4emd2THdTSzEwbG1ST1RBZkVubk1n?=
 =?utf-8?B?aW1oVFIxaEpDMUFmKzlzMFQvbHY4TG9aM29rdnJvMUZwU1NYaGFYWXphMGtl?=
 =?utf-8?B?SlorUmJ0cnhJWTdsUEQybEZaOGIzbFQxcWQzbXRHbUIyNkFZMFpTYThiU0Fv?=
 =?utf-8?B?Mk5ZWVlSUmVhU2xRRFhPN2xuMWdQbmpRL0I0eVN0anpyZ3BncXhkZzJybEd4?=
 =?utf-8?B?eklHbEE3dW5hUTVrRVlZRGFrZVJUalh0OFl3RktRZmIxU1dONTdxemtaV3FX?=
 =?utf-8?B?MmFod3ZBSC8zRnArZVFCdFJhS3lxUWdEaEszYjJjSGYvaTV2bjVOelZkc3dn?=
 =?utf-8?B?N05odFNuUDZQK2NEVGpjckpBdXRCdkdISWZ1a2dURnllYTF4VFVPazhiMkgr?=
 =?utf-8?B?NE1HRjN0UU1tSWxrcSt3YXNSMG05M3pjeXMwaUlqYktKTFNleEZ3OFJRdHNv?=
 =?utf-8?B?b0kraVRQWm1IdU8zNy9xcUxKazgrU3BqUHcxN2J4N1E2TVFtcnY5Uk82Wllj?=
 =?utf-8?B?Y2NTUzBFMVdsS21seTNaRERMUVBVeE1WM2lVRThHMnFqWnBlRW51MnlJVk4x?=
 =?utf-8?B?L0Q4bWlFSzdBelphZm1QYUJQblhKTWFqNm1VWTdPQUJKMS9vWGVoRnlsSFRL?=
 =?utf-8?B?dEs5MXdsY2dmNmxidHdzU0REZVRPaTdraXZ6TkxpdTJkS1c3SndVRXBHeUdX?=
 =?utf-8?B?bEp2N1NsUWpKL3FCNTdFSEtDMi9lWXhGeDVaODNXS1l5Yit4Q3Z4bUJmd01Q?=
 =?utf-8?B?Z0hHZXJyS2N0bkZHMmRObTdxcDJkTjRsMEwxdGhkTnRidnVHWUpFL2I0N0Ji?=
 =?utf-8?B?MUdUelFUS3hhdkVYVWYvRmRFdytyUkdibEdWUEY4UTFRbVhQSkt0RjFwNmJi?=
 =?utf-8?B?QjBuMUY3V0RQa05Eb0RhUFpxUGpqYWRKVktDcTk1UU44WlVsN2pPQnQ5c1Bp?=
 =?utf-8?B?L2ZMdFg3VURaWTQ4NEF1ZFFhUTRkSXdmR0VhU2FKQUxOOUE5OE16SGhGM1Nz?=
 =?utf-8?B?ckFqL29KOVg4OXFGTXZESWxGUVJuQXlaa3QrM1lvd0JKcVB2Mnl0R2c3T2t6?=
 =?utf-8?B?T3BRVk81NlkwR05OQThMVTZuc3FKc3ZQeGp5cjZ6ak1tMTZyQThsSVlKTXR1?=
 =?utf-8?B?NU92RkxyUVlERk5hWldNcUF3TmdRR0x5MTJaUFNGeWdzdktpSDlUL2hSWHU2?=
 =?utf-8?B?emFRSU9TOU5KRkJkblJ4WkFPTlI1UmcyQS83ZGROS1RVTXIraGcxcEI2Y2FD?=
 =?utf-8?B?SXl1NmVYdTY1eUNVTGRPRytRd08xakxKbk5BK1E4OHFhN1pIYnpySWc0S1k0?=
 =?utf-8?Q?S5nXt4Mu95q7z67c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B4F308E6D574924093B8C21C4FBBD4F4@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: NFQY+T6746f+RmDhQwqyXB+5H+HW7QyMWm+561+y/PkODNi1kaHzBmavWop+DiWTw19BMR2ZPzT6Udx31sa9j+3pMy48CXVuaFEZ2JJiQns+j1n6ytYTEkoXPgY1DsGN0N9lWJMe36G7TM2VEZrT2Ph2f7nbAC2iSvyq2KI8iyAE2miS5Z0K6hO0/YZJ2vscdiGXexy9SwN3QtFNA/OP3vjvg/Twx8YGpC0fXf7KbmaWpfZFUYA1Il4Q5F6bDrEgPFrHml8wUamGW88DPCQdVLSdLabXXZhz4XDn3GmUtigmmuixMh5jkrS+2tx8Zi4w+LxgreDqkTWuSOtYwqDStA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e0d22be-2d76-4f67-02ec-08de9f824632
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2026 08:45:00.5142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tU+baiFBCCPrsTI00tlQh5gP4CuUtPwi25lhHJhth0UsMN8Cg0GDen725DtSE/pVPjTeQpouJqRYY+yAAz5MhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB8210
X-MTK: N

T24gRnJpLCAyMDI2LTA0LTE3IGF0IDE0OjMwIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgYi9kcml2ZXJzL3Vmcy9j
b3JlL3Vmc2hjZC5jCj4gaW5kZXggMGZmOWQ3YzJhN2FjLi4xMjQ0NWUwMTJjYWQgMTAwNjQ0Cj4g
LS0tIGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYwo+ICsrKyBiL2RyaXZlcnMvdWZzL2NvcmUv
dWZzaGNkLmMKPiBAQCAtNDYwLDIwICs0NjAsMTEgQEAgc3RhdGljIHZvaWQgdWZzaGNkX2FkZF91
aWNfY29tbWFuZF90cmFjZShzdHJ1Y3QKPiB1ZnNfaGJhICpoYmEsCj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgY29uc3Qgc3RydWN0IHVpY19jb21tYW5kCj4gKnVjbWQsCj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgZW51bSB1ZnNfdHJhY2Vfc3RyX3Qgc3RyX3QpCj4gwqB7Cj4gLcKgwqDCoMKg
wqDCoCB1MzIgY21kOwo+IC0KPiDCoMKgwqDCoMKgwqDCoCBpZiAoIXRyYWNlX3Vmc2hjZF91aWNf
Y29tbWFuZF9lbmFibGVkKCkpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVy
bjsKPiAKPiAtwqDCoMKgwqDCoMKgIGlmIChzdHJfdCA9PSBVRlNfQ01EX1NFTkQpCj4gLcKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY21kID0gdWNtZC0+Y29tbWFuZDsKPiAtwqDCoMKgwqDC
oMKgIGVsc2UKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjbWQgPSB1ZnNoY2RfcmVh
ZGwoaGJhLCBSRUdfVUlDX0NPTU1BTkQpOwo+IC0KPiAtwqDCoMKgwqDCoMKgIHRyYWNlX3Vmc2hj
ZF91aWNfY29tbWFuZChoYmEsIHN0cl90LCBjbWQsCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHVmc2hjZF9yZWFkbChoYmEs
Cj4gUkVHX1VJQ19DT01NQU5EX0FSR18xKSwKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdWZzaGNkX3JlYWRsKGhiYSwKPiBS
RUdfVUlDX0NPTU1BTkRfQVJHXzIpLAo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1ZnNoY2RfcmVhZGwoaGJhLAo+IFJFR19V
SUNfQ09NTUFORF9BUkdfMykpOwo+ICvCoMKgwqDCoMKgwqAgdHJhY2VfdWZzaGNkX3VpY19jb21t
YW5kKGhiYSwgc3RyX3QsIHVjbWQtPmNvbW1hbmQsIHVjbWQtCj4gPmFyZ3VtZW50MSwKPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgdWNtZC0+YXJndW1lbnQyLCB1Y21kLT5hcmd1bWVudDMpOwo+IMKgfQoKSGkgQmFydCwKCklu
IHRoZSBjb21wbGV0ZSBjYXNlLCBhbGwgdGhlc2UgY29tbWFuZHMgYW5kIGFyZ3VtZW50cyAxIHRv
IDMgCmFyZSBmaWxsZWQgYnkgaGFyZHdhcmUuIElmIHdlIGRvIG5vdCByZWFkIHRoZW0gZnJvbSB0
aGUgaGFyZHdhcmUsIApob3cgY2FuIHdlIGJlIHN1cmUgb2YgdGhlIGFjdHVhbCB2YWx1ZXMgd3Jp
dHRlbiBieSB0aGUgaGFyZHdhcmU/CgpUaGFua3MKUGV0ZXIK
