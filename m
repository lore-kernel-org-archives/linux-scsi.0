Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529BA7470
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2024 02:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720407189; cv=fail; b=ULkgIQmyYowRkfy85V6aoOaxl6KhAHBURDAwA0+WFT1RAoVsCcNM06HVT6P/J0pUlDFdNrw0qhseBImW0opy6ogfbEpOonlWE+uiFeM6rJYdXWqZbrjnYlWlUvgC888mgq9Cz3e4d1jGSqLmlWSy4RTaC1+IzFAnBpTk54nvEwg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720407189; c=relaxed/simple;
	bh=S3fcykNiwSO2PDcVrDEupL6oMATpjbwyLHtKoZP+28s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Y0He9CNp12EE1IL5HN84/0DACp7KzX40NR4W1kD4GkpcCTHi28xTbI7jGz0i5+Zd6FyUiujt5s3nzKvqzcMn00/VeOBvyp+ld3RYmg0o/2OA50pgU/B0q4p6ea+VFMUdhIDq6HYQjzUVR3m0cAvmqRQbXH30K2AkG/wq4TFGuCQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=RJF2GAs5; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=NO9ZSdLm; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="RJF2GAs5";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="NO9ZSdLm"
X-UUID: 326e02003cd511ef8b8f29950b90a568-20240708
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=S3fcykNiwSO2PDcVrDEupL6oMATpjbwyLHtKoZP+28s=;
	b=RJF2GAs5vVggfDDlGImb/4MKzOhkKJQeEL/IQtlPTko/1TwtQVt/9d4mDaSWft5prSAh9Iqp+EBVsFdyUABjp1d5ekt6HC0PYodHaDLwQlpeGIYMlNhU04ZK86I2zEtBGsULcFBDgnHXZ1AwZdMFtAvM4mRLrl9cXbuXqZUw2FQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.40,REQID:6ad4b388-d12d-4dcf-b482-3ffcb4f7105c,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:ba885a6,CLOUDID:972611d5-0d68-4615-a20f-01d7bd41f0bb,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 326e02003cd511ef8b8f29950b90a568-20240708
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <ed.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 842618775; Mon, 08 Jul 2024 10:53:04 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 8 Jul 2024 10:53:03 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 8 Jul 2024 10:53:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Te8rKqexB3+YY4iRR2GZaLRxU4rDnV0nFYaYHVhpkZKrp0rH/WsKC0o7n+XCcVZ9giuXWUqPjHXYjSDajLOfjkQ7BcjGXcGyo8M9GmGqrBxioPqP7VlRPD7hgJ0m/54Gg9Pp4+GLlHs5vm2oOwd/RRUzKGfCJ8e6r4Dh4Pbny8B4142xy+5v3Gc9rjFZwpsILApdjBJQOeYbJcTLE+ABw/xOzV4F+ytsVsRdgocIfEp0av5cj+UoHmke4YoaZ3i15hjpkdW8Uunops0lw27BTxMEWNRJq3SoTxuViyF+H7SzNwYclG0Q3L3NWewSRaY9vMlufVvezFJTvRKv1+Jxrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S3fcykNiwSO2PDcVrDEupL6oMATpjbwyLHtKoZP+28s=;
 b=PJH33aKw6VLHD/FebaZ8gG6t5RVSZn5AeLIdY6SeHnex+KvU8++U8aEPvrHpRJkcFyXbkr+TARprOhfmMFh0EdYsi9kkrC0aQVQLeo/s7Vljej4qKTLREwGGPk17qQr0YdxrmQ2P+on35xv53d2jOvVEbO0M6YuxHs4XjrS1LjzQRekw/Dh+3fKG5J/0NTUBPAzOO1Vpt+2rtVFxr3TlyoBW1XJosASUoWvAryFYV8RLpDJJBwcw6vXqyZSSWQt7OWZ1QYxLvW64uNPBrprNZPMLWlvMCQ2/p9+VwtGJnmv3uILCOC3xyZEDXOuououXO5bU4t6DZVCOdvuyJ2tXaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S3fcykNiwSO2PDcVrDEupL6oMATpjbwyLHtKoZP+28s=;
 b=NO9ZSdLm4i7dkIrSBa9/ZBkBD8O+msYFAqJeQM/rnEjKqNlBvtKDfT/P0UtvNYoBQazR9KsQkqYbteEUWM6dlSaR1rF0p2gtPbEon5ogdzrl4sI18vwOMW8luwp99NpGMXBYuMfEcPmtaVd6Fu4aruVYXI6RQEaDECOTL+4jCvc=
Received: from SI2PR03MB5545.apcprd03.prod.outlook.com (2603:1096:4:131::9) by
 KL1PR03MB8799.apcprd03.prod.outlook.com (2603:1096:820:143::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.35; Mon, 8 Jul
 2024 02:53:01 +0000
Received: from SI2PR03MB5545.apcprd03.prod.outlook.com
 ([fe80::8b7a:97d8:96f4:2e6b]) by SI2PR03MB5545.apcprd03.prod.outlook.com
 ([fe80::8b7a:97d8:96f4:2e6b%4]) with mapi id 15.20.7741.033; Mon, 8 Jul 2024
 02:53:00 +0000
From: =?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "k831.kim@samsung.com"
	<k831.kim@samsung.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "gost.dev@samsung.com"
	<gost.dev@samsung.com>, "minwoo.im@samsung.com" <minwoo.im@samsung.com>
Subject: Re: [PATCH V2] scsi: ufs: core: Check LSDBS cap when !mcq
Thread-Topic: [PATCH V2] scsi: ufs: core: Check LSDBS cap when !mcq
Thread-Index: AQHazrW1BwsHuFJpOkCgypIgm4aWX7HsJncA
Date: Mon, 8 Jul 2024 02:53:00 +0000
Message-ID: <6eeecf00c1602751d97bf8d5855fed05d64408b3.camel@mediatek.com>
References: <CGME20240705083050epcms2p85f6e53e075a0d8f6d7980cdad7e62b80@epcms2p8>
	 <20240705083050epcms2p85f6e53e075a0d8f6d7980cdad7e62b80@epcms2p8>
In-Reply-To: <20240705083050epcms2p85f6e53e075a0d8f6d7980cdad7e62b80@epcms2p8>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5545:EE_|KL1PR03MB8799:EE_
x-ms-office365-filtering-correlation-id: 847e6736-8eed-44c7-9d5c-08dc9ef91474
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ejZYUGhkTW5aKzJManQ2U1gzWCszMFBCWk8razRmUWg5N0cxUGJpUlN4WnFm?=
 =?utf-8?B?TlZsOGIxNCtzVHFXd3NmdDN1KzVIQ2xYcldPODI2Q2tOOXpZWkEzSU9xMFVR?=
 =?utf-8?B?UUpUd29XNTMvS1BvR1ZTSzZxMTl1Rk02WUFpZmd6d1lIc0VacTR5aGd5SGQ5?=
 =?utf-8?B?Tk9rUVVualVlbmNLRitEVVBUeFJVRml0SW11UnJiT04rS3RhWDhDS29OWTEv?=
 =?utf-8?B?REZUbmpmcVdTbGYyN1YvVHNuNUJoc21zTFpaUEpzQVFaVmk0K0l4R0t4Y3Bq?=
 =?utf-8?B?RWE2K0JMODhzOHVRR0hlRWY0UGxLWm94UnpMTmpxTGQzcnR5THpxdkFTVk5U?=
 =?utf-8?B?enR5dmdTb1Q3MTN4U0wzYlp0WGdGa2RCWnVFNWVEQnpVcXFtMDBmdXhMQVBT?=
 =?utf-8?B?ZHZvcG1hYVJBNVNqMkVjV0lUWHpIN2tsbWJ5akRjbmE4ckJOTFRUcVNVamZT?=
 =?utf-8?B?SzBJSlZoeC9yY2VOaHk4RG90V1pnRE1sV3d1eEdJZU5KdFBsazBRK1UwNmxQ?=
 =?utf-8?B?SURMc2creXgwck14Mm51OXpWVUZySUJiblhlT0xqUGkwVjJPWDNVUlVXRndU?=
 =?utf-8?B?ZEF0THRDNGd5bXlGYjBlZU1NMGNVRkphMDVFNjBqTCtjM0hueEtKM1Q2aXpk?=
 =?utf-8?B?ZHV2WGJDQ25hRzFIdzlsak1JVkxidDJORm9IWkFvbzhHWWVJZmpCTU95TFVh?=
 =?utf-8?B?OHNVNHUrQzlaWDJld2k3Zm1jcmxQaDFnajV4UzRCb3JMdUpraEwrdjBIUEJ6?=
 =?utf-8?B?cnJPVlFRN3R3NmJNaE1wUSsyVS9oR0I0S0FobjdpT1VVczN1V21KODhXd3k2?=
 =?utf-8?B?cDdGWC9YMjE5RW9zR1ZXZ1VQUWJYSDNQMUhDT1d6ekhVYko0cGZudlkrZ3dk?=
 =?utf-8?B?Ni9LT0h2OHpOZjBkMytoM093Sm1wU3Q4QjNnK25aZ3Zyd01rUVAvTFRMd3lV?=
 =?utf-8?B?NWdUOHpNaHlDdm55S2Y3RHl5L2RiVlFqUFNXZDdybS9yK3ZWRWJJaVMzdWpr?=
 =?utf-8?B?S0F0bGZJT1JiY2s1M05PcVMxMHRwTWxKbWI1Y3ZQMlp4bCtUaTdtSzVUMUhP?=
 =?utf-8?B?MHFDVGpLeW9OTThrTmpTM0RPV0R2N2dmQnh5R0R1dTFUdnZDSVAvc2t1ck05?=
 =?utf-8?B?eEZiMWRFbWpkYmNGR2pHa096NS95VXdoZ2Vwb1UrVk1uZG93clBGODVSc1FB?=
 =?utf-8?B?UHZ4b3N5V3JrZ0dBaGxqUHIyQ1pkcWJUSjM0aEp0d2VnN2JjM0J2dGczTVBx?=
 =?utf-8?B?My84UzF4WUM0VmQ0N0xLUnVxV3QreXZUSDVhRWhuZEtjUVE3amNlNFpERk1Z?=
 =?utf-8?B?TjRVRWFPdUlhN3BVNjZSODhJYW83ZWlGR1Q2NW1BNjRoQnJrQURZQklhc3JM?=
 =?utf-8?B?Tm5NQXBRUHF3NmlDeS83K2xLSWtjKzNpVTFUVzZBcm0zVU9QWUN6ZUQwZWpa?=
 =?utf-8?B?M05ERVI0NEUvSFdHVTV3YXRyb2lFRmNIQ1JkZmx2cDhhd01KNzNnZjFCWHFS?=
 =?utf-8?B?MmN3Q0lOTi9XMjBIbXFpR0V0WVdjYytsTmpldTJoeUpRMFV2MGpEUHIzT24r?=
 =?utf-8?B?WjlVYStmckxZczlySFFaSThEemJQOE0vdUJsQWxBMTR3bFlhLzV6OXQzdUJM?=
 =?utf-8?B?cWV3SDMwdlRTWHhqSFdYQ0FiZUl3VUloUStlcjg3OFV1NFlhdWthdlJUOWV1?=
 =?utf-8?B?VzFIaFdaVHA2endsSnF1NHpVcWhVMjFrQnFoamNUN3VzMmd4c1VPa1JhcEtE?=
 =?utf-8?B?MXNJVzlldmZiL1QxSDBsNlRMRnJDSW53cisvNGZDUVhRaFlWUWVsakU4cCtB?=
 =?utf-8?B?RXRDWk9RUDlsWDR4MVk4eENKSjJuczYzYTNNOGd3Z0dvRnNqbFZSNlh2Z3JZ?=
 =?utf-8?B?QVR2ejRWSUpkRmg2cGlBa3VITURMV2dqQ3k1bndTWlI5cEE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5545.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y1JxbFMwTDF4ZWxLTkpmd2J0YitaaHYvc2pabG0reHBicUpETnpCV2d2ZUNl?=
 =?utf-8?B?U2hKbjhVTUsybjZVZUF0WXZTUHVFbWVUaThndUJINHBSZlNiN3JFbDd3dU54?=
 =?utf-8?B?NXVNU2tpT3l2S1U2ZklQVzFCVS81QktzVDg3ZzRyTTVybHF6WlZpc1VDaURJ?=
 =?utf-8?B?dVJ1c0QwcjRuNGNFTEtpTnFQaHRwQ0NiRUlBN0U4SEl1SmV6akR2UVdRdGdM?=
 =?utf-8?B?eHE2U3BzM3QvVU83UHNoZ3FWSGpYbTljSURPMVZPMmx4N0RQeHNKMUQxazBB?=
 =?utf-8?B?MWg2b3RrM1dkdEhQVGVQWE1RMGNCZ29mZUtDc3FyaWphc0pWdzk1WXRCeHpK?=
 =?utf-8?B?MXdZNGJaYTRWaFpXWGVnWVVhWmcxaENleWF1T3F3b1dwY21jbnhoSTRYbHM0?=
 =?utf-8?B?b0FvOHpETGFsVm95ellhbENkYWprWnV3N0NIMm53S1JtaHo1K3g2QmQvTU9o?=
 =?utf-8?B?dUVNYlVVZjNMY0JKM3ZzUUVsNFdzQ2VIUDVOMFFFc0U5T2hSWnZzMEVEVTZq?=
 =?utf-8?B?aXV1UWwzdU1SNmpqV0t1T1FlRjNwQ1p0RFNRL0FEckVDK3k0Nko3RnBDNVZQ?=
 =?utf-8?B?VnBvamxwa3lUNkxaUUMzbVFUdlNWeDYvMFdvcldWZFNtQnFCdjI0SWN4WmND?=
 =?utf-8?B?bW9jZWZJMmhMZEd2bXRHL0ZXTFc3MnkxTko4ZE05MG9sS0gvelUzZ2U1OG5R?=
 =?utf-8?B?VUJabUxnbFo3TXh0Z1RYQzRqQUoyaDVQM05DS3ZjOHUzVUhEcHRScERtWmdU?=
 =?utf-8?B?cHorOXhSdUxiOVcwOTFXMS9IQzBqYU1EbjlkNE8xcjg4RTdrMDA5WVBaK2VG?=
 =?utf-8?B?SkcrVk5heDNwejAxeXI1ZlcyUGxxQ3NYd0dyMzl2YW0zZlpUMlpVMWZUaTlW?=
 =?utf-8?B?R0FpWjJhOEEvR29MY2l4MkZkYXZvdzZmTXRqSStCYXQ3MEVIK3dBZXdzVEx1?=
 =?utf-8?B?cmpVMFh6OUZmRm5MenN2TzBLYnlKQ2JRTTJoMUtLQ2g0N2hxVkwyOFl1TTBt?=
 =?utf-8?B?QkxhK3NwZ2RtbHRQckR6UnJxbFU1TElPaGZ4U0VlMVcwNllVUGU3QkxQSTFD?=
 =?utf-8?B?L2g0ejVaMW94aFVhd0F3Uko3QzB1WjVQREpuS3BqNEM5K0F1OFBZUlNhRTM1?=
 =?utf-8?B?TjAvY0t0czhPN1JaTG1PU2dockZZRnJtakM5SmNwRE1MWXNCMXY5dStra1E2?=
 =?utf-8?B?MmtDTHg5RWNqWit1aU9NYUpZcndEUVcrQmIrdWY5Z1dkc3k0YVNmQU1XZFJl?=
 =?utf-8?B?Ni9NRHJSZ21LYzJuNFp1UGx4dGM3V1NZekRYcmJ3RXBuWHN0b0U3SnZnbTRG?=
 =?utf-8?B?YUNuNm5zWER6azh4ckZNWjRXUlhnNzRKS0lzclBTbVZvSlZnOVoxYmhQSnhj?=
 =?utf-8?B?UWZKN1Izelh1TG1zRXBOTDNCbUJRVHZ1UU8yNEtJWkkyUzd2TEYxYUZNSnNw?=
 =?utf-8?B?Z3RWbHBkUmE3dXBzRTFSRlJCOWpJdHB4WkhSRlZXL21yckFMUnlERm9hbHds?=
 =?utf-8?B?MXN2V3RVZnlWU3RqZXg4QVhvVG5zZ1hBZmM5NzkrVnMzeVVSUmx2dFIxV3l3?=
 =?utf-8?B?eGk1bWo3b3c3WHY3WlF1U21CNW45b2Y5S2tVbjkxVlI5V01YTFJiVGdaanRs?=
 =?utf-8?B?M2JCYllFMk42b2lwTWJtV0pBTHg2b0o3bzJKak9FeXljSWdremRzaWR6bDNR?=
 =?utf-8?B?R0NsQXpYTnUrUXI2SllEZVd4ZmFZL0NQRVo1TDcvYS8yRk40eDVHQ0s1VFpt?=
 =?utf-8?B?THU4Qk10a2pvcm5NQ2dGTEhMZ1RvUndudUY1ekhScGtjdVl1RWxaK0s1c2dO?=
 =?utf-8?B?bnR1aW1xN0ZSTGN1UTBmNTltcUVQTEdoaVk1Q2JWOHM3WkVBcGpWUktuL1Z1?=
 =?utf-8?B?WTZtR2lBaERqZy9nUXozck11cFdsemFid2l1a0Y4aDZrVVY5d1JhY216OUJ0?=
 =?utf-8?B?T01iM1p6MUNSeldkUEI1Z09nK09mVjJVZ0ZHMEdlOXhWbGZXUlQ4YS9MOGVp?=
 =?utf-8?B?TUpwemFGZmV6endWc3dKRHZMKzdMNUt0SmcxN0d1NDEzYnNwRVIyMkhBbEVG?=
 =?utf-8?B?Rm5ENEdRejZRSkljQVNDU0RqTTNrbWdFKzh1SzZPL29DcHRmRWthQ2pkVjhp?=
 =?utf-8?Q?O2mPPjwkTfbzPhEpttMesQOWI?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0821766F2A548A438754EC043F0676D2@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5545.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 847e6736-8eed-44c7-9d5c-08dc9ef91474
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2024 02:53:00.6457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wBEv9DSfebZzM6whWPJo3Xhh6gxeGjMMAZW5Wia2u/2fRHzgvDEC27RawvgupFGBka0AhYzA25Iqma4ECrnHLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB8799

T24gRnJpLCAyMDI0LTA3LTA1IGF0IDE3OjMwICswOTAwLCBLeW91bmdydWwgS2ltIHdyb3RlOg0K
PiBpZiB0aGUgdXNlciBzZXQgdXNlX21jcV9tb2RlIHRvIDAsIHRoZSBob3N0IHdpbGwgYWN0aXZh
dGUgdGhlIGxzZGINCj4gbW9kZQ0KPiB1bmNvbmRpdGlvbmFsbHkgZXZlbiB3aGVuIHRoZSBsc2Ri
cyBvZiBkZXZpY2UgaGNpIGNhcCBpcyAwLiBzbyBpdA0KPiBtYWtlcw0KDQpsc2RicyA9IDEgaW5k
aWNhdGVzIHVuc3VwcG9ydGVkLCBub3QgMC4NCg0Kb3Igc2ltcGx5IHNheSBob3N0IGNvbnRyb2xs
ZXIgZG9lc24ndCBzdXBwb3J0IExTREIgbW9kZSA/DQoNCj4gdGltZW91dCBjbWRzIGFuZCBmYWls
IHRvIGRldmljZSBwcm9iaW5nLg0KPiANCj4gVG8gcHJldmVudCB0aGF0IHByb2JsZW0uIGNoZWNr
IHRoZSBsc2RicyBjYXAgd2hlbiBtY3EgaXMgbm90DQo+IHN1cHBvcnRlZA0KPiBjYXNlLg0KPiAN
Cj4gU2lnbmVkLW9mZi1ieTogazgzMS5raW0gPGs4MzEua2ltQHNhbXN1bmcuY29tPg0KPiANCj4g
LS0tDQo+IENoYW5nZXMgdG8gdjE6IEZpeCB3cm9uZyBiaXQgb2YgbHNkYiBzdXBwb3J0Lg0KPiAt
LS0NCj4gIGRyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgfCAxNiArKysrKysrKysrKysrKysrDQo+
ICBpbmNsdWRlL3Vmcy91ZnNoY2QuaCAgICAgIHwgIDEgKw0KPiAgaW5jbHVkZS91ZnMvdWZzaGNp
LmggICAgICB8ICAxICsNCj4gIDMgZmlsZXMgY2hhbmdlZCwgMTggaW5zZXJ0aW9ucygrKQ0KPiAN
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgYi9kcml2ZXJzL3Vmcy9j
b3JlL3Vmc2hjZC5jDQo+IGluZGV4IDFiNjVlNmFlNDEzNy4uYjVhMDVmODQ5MmM0IDEwMDY0NA0K
PiAtLS0gYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ICsrKyBiL2RyaXZlcnMvdWZzL2Nv
cmUvdWZzaGNkLmMNCj4gQEAgLTI0MTIsNyArMjQxMiwxNyBAQCBzdGF0aWMgaW5saW5lIGludA0K
PiB1ZnNoY2RfaGJhX2NhcGFiaWxpdGllcyhzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiAgcmV0dXJu
IGVycjsNCj4gIH0NCj4gIA0KPiArLyoNCj4gKyAqICBVRlMgMy4wIGhhcyBubyBNQ1FfU1VQUE9S
VCBhbmQgTFNEQl9TVVBQT1JULCBidXQgWzMxOjI5XSBhcw0KPiByZXNlcnZlZA0KPiArICogIGJp
dHMgd2l0aCByZXNldCB2YWx1ZSAwcywgd2hpY2ggbWVhbnMgd2UgY2FuIHNpbXBseSByZWFkIHZh
bHVlcw0KPiArICogIHJlZ2FyZGxlc3MgdG8gdmVyc2lvbg0KPiArICovDQo+ICBoYmEtPm1jcV9z
dXAgPSBGSUVMRF9HRVQoTUFTS19NQ1FfU1VQUE9SVCwgaGJhLT5jYXBhYmlsaXRpZXMpOw0KPiAr
LyoNCj4gKyAqICAwaDogbGVnYWN5IHNpbmdsZSBkb29yYmVsbCBzdXBwb3J0IGlzIGF2YWlsYWJs
ZQ0KPiArICogIDFoOiBpbmRpY2F0ZSB0aGF0IGxlZ2FjeSBzaW5nbGUgZG9vcmJlbGwgc3VwcG9y
dCBoYXZlIGJlZW4NCj4gcmVtb3ZlDQoNCnMvcmVtb3ZlL3JlbW92ZWQvDQoNCmFsc28sIHNlZW1z
IGxpa2UgdGhlcmUgaXMgYW4gZXh0cmEgc3BhY2UgYXQgdGhlIGJlZ2lubmluZyBvZiBlYWNoDQpj
b21tZW50IG1lc3NhZ2UgPw0KDQo+ICsgKi8NCj4gK2hiYS0+bHNkYl9zdXAgPSAhRklFTERfR0VU
KE1BU0tfTFNEQl9TVVBQT1JULCBoYmEtPmNhcGFiaWxpdGllcyk7DQo+ICBpZiAoIWhiYS0+bWNx
X3N1cCkNCj4gIHJldHVybiAwOw0KPiAgDQo+IEBAIC0xMDQ0OSw2ICsxMDQ1OSwxMiBAQCBpbnQg
dWZzaGNkX2luaXQoc3RydWN0IHVmc19oYmEgKmhiYSwgdm9pZA0KPiBfX2lvbWVtICptbWlvX2Jh
c2UsIHVuc2lnbmVkIGludCBpcnEpDQo+ICB9DQo+ICANCj4gIGlmICghaXNfbWNxX3N1cHBvcnRl
ZChoYmEpKSB7DQo+ICtpZiAoIWhiYS0+bHNkYl9zdXApIHsNCj4gK2Rldl9lcnIoaGJhLT5kZXYs
ICIlczogZmFpbGVkIHRvIGluaXRpYWxpemUgKGxlZ2FjeSBkb29yYmVsbCBtb2RlDQo+IG5vdCBz
dXBwb3J0ZWRcbiIsDQo+ICtfX2Z1bmNfXyk7DQo+ICtlcnIgPSAtRUlOVkFMOw0KPiArZ290byBv
dXRfZGlzYWJsZTsNCj4gK30NCj4gIGVyciA9IHNjc2lfYWRkX2hvc3QoaG9zdCwgaGJhLT5kZXYp
Ow0KPiAgaWYgKGVycikgew0KPiAgZGV2X2VycihoYmEtPmRldiwgInNjc2lfYWRkX2hvc3QgZmFp
bGVkXG4iKTsNCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWZzL3Vmc2hjZC5oIGIvaW5jbHVkZS91
ZnMvdWZzaGNkLmgNCj4gaW5kZXggYmFkODhiZDkxOTk1Li5mZDM5MWY2ZWVlNzMgMTAwNjQ0DQo+
IC0tLSBhL2luY2x1ZGUvdWZzL3Vmc2hjZC5oDQo+ICsrKyBiL2luY2x1ZGUvdWZzL3Vmc2hjZC5o
DQo+IEBAIC0xMDc0LDYgKzEwNzQsNyBAQCBzdHJ1Y3QgdWZzX2hiYSB7DQo+ICBib29sIGV4dF9p
aWRfc3VwOw0KPiAgYm9vbCBzY3NpX2hvc3RfYWRkZWQ7DQo+ICBib29sIG1jcV9zdXA7DQo+ICti
b29sIGxzZGJfc3VwOw0KPiAgYm9vbCBtY3FfZW5hYmxlZDsNCj4gIHN0cnVjdCB1ZnNoY2RfcmVz
X2luZm8gcmVzW1JFU19NQVhdOw0KPiAgdm9pZCBfX2lvbWVtICptY3FfYmFzZTsNCj4gZGlmZiAt
LWdpdCBhL2luY2x1ZGUvdWZzL3Vmc2hjaS5oIGIvaW5jbHVkZS91ZnMvdWZzaGNpLmgNCj4gaW5k
ZXggMzg1ZTFjNmI4ZDYwLi4yMmJhODVlODFkOGMgMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvdWZz
L3Vmc2hjaS5oDQo+ICsrKyBiL2luY2x1ZGUvdWZzL3Vmc2hjaS5oDQo+IEBAIC03NSw2ICs3NSw3
IEBAIGVudW0gew0KPiAgTUFTS19PVVRfT0ZfT1JERVJfREFUQV9ERUxJVkVSWV9TVVBQT1JUPSAw
eDAyMDAwMDAwLA0KPiAgTUFTS19VSUNfRE1FX1RFU1RfTU9ERV9TVVBQT1JUPSAweDA0MDAwMDAw
LA0KPiAgTUFTS19DUllQVE9fU1VQUE9SVD0gMHgxMDAwMDAwMCwNCj4gK01BU0tfTFNEQl9TVVBQ
T1JUPSAweDIwMDAwMDAwLA0KPiAgTUFTS19NQ1FfU1VQUE9SVD0gMHg0MDAwMDAwMCwNCj4gIH07
DQo+ICANCj4gLS0gDQo+IDIuMzQuMQ0KPiANCg==
