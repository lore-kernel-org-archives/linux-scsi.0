Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC642AF1D
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 08:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776760905; cv=fail; b=pX7D1gfJnRiTqMMKNZGLC/suwrV1QlHNFrgAmKtxtLFi7S2W4jaxy3ABpBgUD+4i/njwP/jowHN2MNHhVe4pEQ3xbu6TmlZKYQMBbHcRUK0j6sHChXKhLeEg6fqOWFAd3auPxRj0+xhcTOHnfNElCsKsbjB8avGblZlJeEPMAmM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776760905; c=relaxed/simple;
	bh=ZDSGBJIT+N4PYkoWjFE7kBuC6kX8Yg43ZcRb5pu3kwo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j2046nCvb48VQYFyR4GRSv9FRlJaxwP4QqO1ICrRsA0TMkTkc+fXTlc6c7prJSxjtOFQ/Pxiv06zCkS1O3/2zeoE3ix6Hp8yv7luZWrZm3ztwwsCGZ6IxfYyW0WcwMAjmkR1t5NRfPGDqaussGNH7F2GOxuvnU5lX+9UeY1Au2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=aXl3qDTp; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=dREsbNYr; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="aXl3qDTp";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="dREsbNYr"
X-UUID: e8596f523d5d11f19a16598d5ca7f8ec-20260421
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=ZDSGBJIT+N4PYkoWjFE7kBuC6kX8Yg43ZcRb5pu3kwo=;
	b=aXl3qDTpZAK4JDyUnJrUwU+VWvxsYYxCNdFTh5p0khpZCT78v1XiBPn0XItyl59C3GW3xN4UwJjpo1p0bO9V8Mq+xLGvAvz8cs5s/oDQdTvsJN15tbccJxzvHm0ESIDRsSo5+ANk7RV63jYJ3AURTk+nFbO8SXJ9lEwdDOGbb/s=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:964092eb-dc1c-4282-b560-8d64f35e9a2f,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:edcbac8f-6df4-4a3d-a7a4-fbdc42d669ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e8596f523d5d11f19a16598d5ca7f8ec-20260421
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1952948842; Tue, 21 Apr 2026 16:41:36 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 21 Apr 2026 16:41:35 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 21 Apr 2026 16:41:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O8l4HY7Ybmj8MjDC/A8QpqpBkNUi7CCN7wTNcEjSFoZoF45/hPwEol5xbK9AKIU/Kl9csIiKAu9aDfN9v32bEbsX+a4T+27b7YgpxVnixnoEzepK/OPmTwehUWjdBsM6jafp/lVPRNz94Z+4qQ2ip5FJigX9gyaogNwLwkXKdQq8RpUDpVjxhjaUHQ6So4Yb6lvZSbCYcozP1qcjzS95CNTO7FXM77vUxtTLPiFYn9OXjxovvTutfS+kOb37AdrnN+C5ZNJxCGM+ENX8ELqTl1rsB3jp0TGpQCzSiJmIRMNcI2OlzKkOXwWnxnyirEubE0fDJgMa1hGzlLVRiW4oXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZDSGBJIT+N4PYkoWjFE7kBuC6kX8Yg43ZcRb5pu3kwo=;
 b=KfEVDXAXpiskulkHRh7mlD8GK+kBUWT1L6dft0kgGvCtaOxL4U981dHZfhW0ZwOg0331tTRjWFFUxS24n9ssm62NPzR1S/+j8tmJTCTiZgIF+1HExMOrh4TWHqwX5NXGv8d7o7dFBkflSwvwe+6c/Es/rhDMtpm92FA+9hH+ADg0PniIJVQg0loywYn3IL83Jp0LeLRUttAS/ltskhb1mflU1d9iCuA9KKDsuH8AAaJX3X9wczbDavdgckUARuJtMmaxVqandEiONimpXSjXV+PtolDiujdb2rYWIUegNG25hqu4pm+PhlxuZwra+5dRkb0GV+LIDFOsXoBBXzq2gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZDSGBJIT+N4PYkoWjFE7kBuC6kX8Yg43ZcRb5pu3kwo=;
 b=dREsbNYr/3sxPuV8+EBDnMnd7f8TeZ5I53nj2jN8I/uYHro/C4yKE2ojn8pSkk0bOSup0e1ZddCzm241yVOo726MtdoudY86T/gKN0Zsj4aQnpvNgh1DNC7Fv9JCfwFYaav7J1aP5K0Of6aOXR6xrSo8uLxV/PjMEz0Cv9UaWFQ=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by JH0PR03MB8210.apcprd03.prod.outlook.com (2603:1096:990:48::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.32; Tue, 21 Apr
 2026 08:41:33 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.20.9818.032; Tue, 21 Apr 2026
 08:41:32 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "can.guo@oss.qualcomm.com"
	<can.guo@oss.qualcomm.com>, "avri.altman@sandisk.com"
	<avri.altman@sandisk.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>
Subject: Re: [PATCH 1/3] ufs: core: Inline two functions related to UIC
 commands
Thread-Topic: [PATCH 1/3] ufs: core: Inline two functions related to UIC
 commands
Thread-Index: AQHczrGKHeAoViGEfUWXu+9lTErA17XpN+qA
Date: Tue, 21 Apr 2026 08:41:32 +0000
Message-ID: <34748e95d768a46929e359deb71a55730803cca2.camel@mediatek.com>
References: <20260417213027.3506742-1-bvanassche@acm.org>
	 <20260417213027.3506742-2-bvanassche@acm.org>
In-Reply-To: <20260417213027.3506742-2-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|JH0PR03MB8210:EE_
x-ms-office365-filtering-correlation-id: 1cbce71e-51da-42b3-363f-08de9f81ca4d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021|56012099003|18002099003|22082099003;
x-microsoft-antispam-message-info: p1D5XU6ol9AuM3Dxt+ih8bqQiqrsbghWmOPF8bCAr037JFf2rkZ+4yvvffyGGraIXtD3qPVzA12IMUl2ajy9hFzxf8rPjEbG7WGfIUOSF3Z43nyPm+lWgTinIITkRH/sCUk0yKPQ55ddARH08CefqO0LeKx/9ilcHc1nkbKLL/FRKyglnIcZHGi2AvKuDdZrB21EnHlwwTd+RkDvY27ZfI7EQL8ESy6zgi/i1c5URyWy/ygc0Kkdq7kGy1r7LSGV6cxDNarZ0nUXr7S7iJKwksfpXFCi/GGZCWBL8HeMNw4x0E4empmTX/hUFb5fmF1n7lMN/vZt4TjbxNL0mEX/Hcu6iFgavGVaJTzpj5YD/UTxNMWUN9M/vkwVy/wy4QKzTyEJpX4ec26sYXy+3xDcKtiZUvBxL8saMvZFolEa/CVkyScOkji7U3UHX5ArTi72aGlypLX+cVS5vLY5WNUgvXPeTnQ4j95FH07lcd1Zp5zeL+pryJ+TwH3sIN75lnFnYTZ5e2xeQFjubWRYWIv5ELkAJCmabqyLdLqsqI58jdaX/KQyFjHIMXM1J0qk6z/j+F4Jkhryhn6TJ6AKRx8sO3Y9zmC86ld/yzAeOw1vDSBDEDhDhobMIloLv07r0BX9Hy8zFsSmX6GJKQFhpbM7o5fU/jo3HLcQ0Q1pxCxAhKHA/KVB4tlihCsUx4YBFQDWREX6QJhI0+Z89+BoDdLyafLySJXNYu+sb/ezu6JM9oAoO7faKRfEp5fzYPwI5t9uF3Ep42SORf8hXC4rbN33pNWNEGN00EajRFp/sq+pWOs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cVE3aEMxK3MxZkJzb1ZVbHJRUkdWNXpEUEJJWlZEay8zNXh3YjFpaitjL1Nm?=
 =?utf-8?B?TEh4K2ZBQXNxbWNoWmVUSkx0dVhzM25keHZlajdXV1lqdFJJMHJNRmtHZFZk?=
 =?utf-8?B?bjVrY2ZJanR6V2lFYVYxVkRCek9YbVRnaUFQamlRb1QvSHlCTi9wam96WS9s?=
 =?utf-8?B?blBkNldwKzRRWFRCRjM4TC9xWVExNG1vMWJEUFp6WFBOMHVRNmcrVVNKWEJm?=
 =?utf-8?B?ZXY0RVhVenQvTjBPOG1rL1oybjFsaE9BV2dpTWs3NjFEOXc0N0QreVJIZlZ0?=
 =?utf-8?B?d284WkZSRlM1ZWZQcUwyczNnNlR1aE01eWpzQ1hSZm9KTEEyUG94RGxSMDM4?=
 =?utf-8?B?VlZHcVlzaTRaU213dVhBcDNpWUJtaVQvUEprcGtLcERDeGdwTlZtMUNLYkxa?=
 =?utf-8?B?OG45d3YvMWdpbHlXS0xMSCtGMXZmZHRFd2RuZ2RTZS9FTnl5b2NBNTUxdXBY?=
 =?utf-8?B?MGxUUUJSRmN6cXdKUndzd2s2K2NQWndQV2N0MHZzWXlPK0JUSmhmTFJXUVFr?=
 =?utf-8?B?WWJaN0daK01kSFU4aG5HemxkL0JUaHc4ZVB1L0ZmNm0wQklhU2hlOEZ3ODVF?=
 =?utf-8?B?Qm5FT2hERkxjeTlvdlNCRXNjUzdhTFJpelM5dTNFUzc0Rjg5dUpuRlpPOWFJ?=
 =?utf-8?B?Y2habkQwSEEzdWFCeWpYUE5BVmpvMUxCYkE4UmlXbkxta1JxMXBpRnEzNkpD?=
 =?utf-8?B?elY5dWI4c1ZaVzQwWFpoQ0UyajQ5NnptOFBzWU5rWEI1ZkU3cWpKREJpNzF6?=
 =?utf-8?B?VlFaTTVwZGxOMFhBYVJndnh4eEJqZW5jLzc4Z0ZtN2ZFVnRhSlJsYjUyZUpo?=
 =?utf-8?B?bmY1Z1FCVzJGUS82MnhtRTN6UmxDYVRaMHdjSmFZZlpDVVl0TkJRKzdKVnNa?=
 =?utf-8?B?WmM5S3hBalFwaVZNQlJqdEY0cm1MWkdZVFIxdnptQWVKZmVtYnljY3V5eVgr?=
 =?utf-8?B?RnN1ald6M05qVHpYaHA1c3d3SXlCcmJyMlpHZFpOVGNKc2luVHJBekd0UHVZ?=
 =?utf-8?B?SWt4ZnNnNDk4RDI1UVZTQkRoaElRS0s1QUd1QndoZThVL0F4TlZLU0p0eG9u?=
 =?utf-8?B?R01lSUpBNmg1cTFXLzVCcVk0Qk1zWnc4RU1iS09aNGNyS0NYUmhpZVNJK3dw?=
 =?utf-8?B?Y09qYzE1U3ZYTDVSWWNWL210Vi9yR2h6QWNWczBPaDBDcUdnQXFaZG4zY2dG?=
 =?utf-8?B?V2pKU040emtmRjVMdEV4NUdEbGdmdm5wM3hRTXFmaUJJMTdWS0x1KzRyM1NL?=
 =?utf-8?B?Rk1jWVcvbFU4RVRjanZQU2pIcFhiVEZiZUVKSGRNemFpQ2Y1elgzU3E0ODFr?=
 =?utf-8?B?UXpJbkZ4THE2ejRmT2lWWGFvaTNHdkQ0cElaTUR3c1I5bHp1VEF1cFpWdnRi?=
 =?utf-8?B?R2hGNXFYWGZoWEg0K2dML2lMVmR3YkFqd1F6QkVNQ0wyZlcraUJrRDBjUUVz?=
 =?utf-8?B?d254WisxMmcvT05mR3FURVo2am1BWkRLb09JaFJzUlhadGh3NllrN3l0OVJl?=
 =?utf-8?B?Um1hZEpUOFRNQ2pzYWJTekdnWDBBRVVRblh0OWpjeTJIcUUvdHJLQ0JiZ2U5?=
 =?utf-8?B?MTZyaUtDVTRRV3VnZ1lwU1o3NnpPZ2VhU0xXWUhOUnRvOWlodHZ2a3d4NkZQ?=
 =?utf-8?B?K0tVK1hkQ2phaVc2VFdJWE4yejNMWG5CN0wxYVlDVHFNRy9nTEJNVUk2T0RQ?=
 =?utf-8?B?ZStRYk5MdHUyNTRXM3RQN085SmlSN2JpcGRNeFVLd0l2cGxFVk5CeTJvSjRG?=
 =?utf-8?B?WEgzUVJRNE8yKzhRK2ZuNzRqWEJucmJMbGZEZko3c1BHQUx3cUJTSFpzUEh2?=
 =?utf-8?B?UGxBUHZCeVZSRDMxV3Q1OE1lVjJ1SU84aUwzWGFZeXZhYU0yOW9pSjUzazlY?=
 =?utf-8?B?QXZvRWI0Ky9XRVU2dmc2c3R3RlV0Z1FDdTBjZmQvYVJaUFMwTDljZTBsaEpu?=
 =?utf-8?B?MnZDbmM3Z1RHVjZ5VzI3Y2RGUmZEZ2dEbXQrRURBVUJQeXVuamJBTWQ4eGNT?=
 =?utf-8?B?WnQrRmdvendwWTBudzJKMVI3cmJmMnp0ekwrVmFtVlgxTHNmZ2NSTnJ0MUNJ?=
 =?utf-8?B?eVR3NTRZeXJEWlV6NlBMQ0NQSTJqaXdXMmYwMGd6dkpqd2RIcVl2Y0I4WlYv?=
 =?utf-8?B?QXNZdktWSmFudHcrREwwWURoTE1pSG5IODlnMjdZV0ZIRjFodk8xSE05WTBy?=
 =?utf-8?B?cUpkYUVlTTUzWVNheVFGNmtYam1Ncm1tcGRUVTBCMG81eEpKelp4Yzc1SEgz?=
 =?utf-8?B?OW5mdDAvZTRtMEJlNU53djFXbU8rVG9HK0JOa3JPYnhCZlV1Nml0eUlPOUNT?=
 =?utf-8?B?eUVQM2hJQ1o5UVV2blQzWkwwbENsTWlyWVNpOEF5MUZERmd5dFpqNTl6eXAv?=
 =?utf-8?Q?wvuzCHvp0NmdNbwo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <50488248AC4EDB4C9CE1C7D712BD4847@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: h20hRwdKkHdmM4nhWiqvEZzURtPP/clJoVUntfOMAChLlyrbx5SV6zjb/B8cMs2DLNT48+0Kmw1wqk/oQWB9obHLapZ6a3aD5HqUHcBYLHtY8EL0W7UG6Qk/yI3sipHDPK4RZAylmAmXV5AX0FRahq+aeqAQiW15A/unEJjGVsZIacUQomBPFJphvh6+/+6K06jIqTdGifZkTThQxauDq+freIF+C/Y3y3qzb0y1yhNcSI5buWzbM+A2RyY7fbVgX41Mp4bFCdToCRNo+QfEfMQIJPOxijDlPuncAF9OMpxBU79j5hcGZEJxY8oaTeiqds4hog0OfV7B2He5pZtbFw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cbce71e-51da-42b3-363f-08de9f81ca4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2026 08:41:32.6715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IzrfWzrjBun3q22ZeWMD3Kt+FY9Xxi+b07SV7/Xj3jTwFzy3RnuVnLbejHdvxnP3719dtS9X4jJKKiglBOpaNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB8210
X-MTK: N

T24gRnJpLCAyMDI2LTA0LTE3IGF0IDE0OjMwIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IFRoZSBpbXBsZW1lbnRhdGlvbiBvZiB0aGUgdHdvIGZ1bmN0aW9ucyB1ZnNoY2RfZ2V0X3Vp
Y19jbWRfcmVzdWx0KCkNCj4gYW5kDQo+IHVmc2hjZF9nZXRfZG1lX2F0dHJfdmFsKCkgaXMgdmVy
eSBzaG9ydC4gQWRkaXRpb25hbGx5LCBib3RoIGZ1bmN0aW9ucw0KPiBvbmx5IGhhdmUgb25lIGNh
bGxlci4gSGVuY2UsIGlubGluZSBib3RoIGZ1bmN0aW9ucy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6
IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KPiAtLS0NCg0KUmV2aWV3ZWQt
Ynk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KDQo=
