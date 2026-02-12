Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7E53EBF08
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 07:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770881046; cv=fail; b=irtKnTeKk2FH0emvwuOxJIq+H9cntZha4zrNEjEYiAUoZbi6llFp69HkpDqx11IlHNMqoGgQpW+Dl54Squ+NMUZaRcYkU+KfIbzLBuAfIxRfKhdTt0OHr665JQkQ1XEPsD5JEBZQvriYPOWCqnviENMIPHc2vJ2g6YcijXYNbo8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770881046; c=relaxed/simple;
	bh=QUwzjoVPn1A9aVuAAaNqcOcgqROOojH+ko9A++VS3jw=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=knhvIlnFCWh13FNx3PSNXoJG2mOIvWOx2Zv6xRO+1TIE+SAdvtL8hpzJVRSo//lzgKYdn8/WmOWWf2H0+BoDqbpeVrx2Dlq5pGVHoJpNo2cjUjUaIYaf1Xh16TAnQjLS/wf4VG9bOPT1qTs9QRDCl6g+4tJ4VUnsfISJAJWIEJQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=QJvoW7io; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=mmyN9Bh4; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="QJvoW7io";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="mmyN9Bh4"
X-UUID: cc92cc3c07e311f185319dbc3099e8fb-20260212
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:To:From; bh=QUwzjoVPn1A9aVuAAaNqcOcgqROOojH+ko9A++VS3jw=;
	b=QJvoW7ioTM6JzjEjhEZ8JO4/5R/C/R5mf9SHyNiv2sjJBm51k1YNwQNtPn9/N2o3y/1fWEDce+fotQFuhrURhGYGiqo5KOBDfEzf4Q+yDjiZvcpLUYhaZnmR779TeM4V3LJyLoWgYmhXHfSjRaTOIUU5EMm67Vb1zAP/cj2oBt0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:180fd24d-1577-40f5-a351-5068cd260ff3,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:2a69375b-a957-4259-bcca-d3af718d7034,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: cc92cc3c07e311f185319dbc3099e8fb-20260212
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1219047487; Thu, 12 Feb 2026 15:23:59 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 12 Feb 2026 15:23:58 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 12 Feb 2026 15:23:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R7oFbk4btwFooJ/pPqrj+ONySeOxlP7HrFWbiGwA80I0CLPd75fF55D6Xor9qaJiPycV3iJdC3e21AF21mbUajENC+fd2GHsS/pztnACiSkIbHsXatwg6+L9obTTcHfYG0ePryQJB0H4v+sb46xmL+Jzj+J7gmiNQXSYQnlDwcE4q64PvU9GUg2gWMP6emrQPMpTaQMkEySoL+zlL1dGri0qB03g6nZsDi/j3+sxS5qArk5mCzly8ZRiv2SGAV5YsqZ0rCHb2gBS8lCcBMSC/8K6vy6kD0TlM3FodMILOsSNzQjH3oQfAxYs0XcnPLLIhL9TW8/+rY8o6tW4OUsR3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QUwzjoVPn1A9aVuAAaNqcOcgqROOojH+ko9A++VS3jw=;
 b=gnZkAGfEsP5c3ilQpjl2pY3BX3GsmuFCsA2ZsVgBGSUf9lFqclj7p1vRKRnWBv34a3afDDNHVS5rHa/fJkxuuYFy8pIG20PN1V/p2vpxnFa4MmPw1ije8vJBprNx4dScGWj3fV4cPK2AWlFvkQS8TPimTX5C7v7H4WsDUrmXpeNCGUiTOHepmOKts4pkgiQdQfU2LyE47whCDAL48AC1Gb8bTP86a0eZFNp186WgOgb6aFHLkiTx+g5m1+asWBdAisTdEd4YcK9aJE93uUU+1v9sqSyUTQKoLRBTihg1DwoXIlEsxTnSAMFH9f5Y8OwS2NGC3BoqSX+5fDY6oNgLsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QUwzjoVPn1A9aVuAAaNqcOcgqROOojH+ko9A++VS3jw=;
 b=mmyN9Bh4mVaqmxsvPe9FL9xfbfWREMcqEsIRRfzRMReFkV3ros2UaxVKkg1/Nk22YMiRVAP+NtkPYUZ1vZZAo9M2IScM2XsWWHvqaMuNIqVd9YxFz/qs6Nx+pc4XSjApQ9+Ml3/TR5ZsxU49b6K3kkR9PoNl3v1ql7IfEmjuQp4=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SG2PR03MB6537.apcprd03.prod.outlook.com (2603:1096:4:1d1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Thu, 12 Feb
 2026 07:23:56 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9611.008; Thu, 12 Feb 2026
 07:23:56 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>, "sh043.lee@samsung.com"
	<sh043.lee@samsung.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "sdriver.sec@samsung.com"
	<sdriver.sec@samsung.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
Subject: Re: [PATCH v2] ufs: core: Use link recovery when the h8 exit failure
 during runtime resume
Thread-Topic: [PATCH v2] ufs: core: Use link recovery when the h8 exit failure
 during runtime resume
Thread-Index: AQHcm/AwCXrE1tm3EEeaWK/ghfI9DbV+qTaA
Date: Thu, 12 Feb 2026 07:23:55 +0000
Message-ID: <7f231ff871d9f7ce62e2918bbacb39d871772fec.camel@mediatek.com>
References: <CGME20250717081220epcas1p224952b344389e4967beb893297f1ae02@epcas1p2.samsung.com>
	 <20250717081213.6811-1-sh043.lee@samsung.com>
In-Reply-To: <20250717081213.6811-1-sh043.lee@samsung.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SG2PR03MB6537:EE_
x-ms-office365-filtering-correlation-id: 7380d046-b0fc-4b6e-8ee6-08de6a07aea6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?YjhQMExjTTBpUzkwdDVFZ3Iyb25meExOeE5iNmw1MEZKZHFQTEZGemlJeUk0?=
 =?utf-8?B?T01veXltTlkwTXNrb1N3QmVUOUhnZktZeGozeVFVSjYwRDhHN0IyKzlsL3Nt?=
 =?utf-8?B?anRmd1JGSUthZ253dll0S1AwamloSEIvYmVjNEFIWVNkWG1uQzUrWWdQaDN3?=
 =?utf-8?B?Z2lBVmJaeE5ISzg2OFY3OXV6c0hWMEhndFhwa3QrUHhvWHkycmM1YzIrL2p1?=
 =?utf-8?B?cm1ia2JIZ1pqK0QwZzIzSDd6T255T2FUdXF3N2VJWng5UnV2elBaWllJYk9O?=
 =?utf-8?B?Ny94VytpZWpWVGxXZDdRSjBVZDcxdTY3dUZ6R1RNUGN3cWZXZFhBenZlb3dD?=
 =?utf-8?B?M2xjaUZTVXBaWXJWOUVXaDdtbzh2YTFSUndzbTZGejdpZnhITjFJT01sUzVj?=
 =?utf-8?B?NzF1TlJXYXRWZE5FTjRSVXhIRFhVc2x2K1ZJMkIwNS92Y1ZyVjFwaTlTZGpk?=
 =?utf-8?B?bDFwY0ZZWENaM2liWVlsMVRGcG1ZR0JWM3dXVU5Ed0RZc2YvM24zb3lNbXZ2?=
 =?utf-8?B?ZWNYMHpTTU9VR2xoZlFlR3Z2akFjcXZUYlE3QjcxT29ZRVpuU2JoUDZqUGtJ?=
 =?utf-8?B?UllxMHJ0eS9JL3BERnF4VEdVRlhnWFVPYXN5dkxnRWN3MFpkM1hzOVVPVlgz?=
 =?utf-8?B?cUZzcFNjaWdwYUZyTHBpNGVEdlpMcTRBVDlzbUIwYUc3a2pkSG5nSjQ3S3A5?=
 =?utf-8?B?UU9XbVk5RzdTUmQzbmxYUGx5Z2NtUnhrZUx1S1lsQUkyZXhjQWxjUngxWTFu?=
 =?utf-8?B?N2tPWkNKVHpMdGpCYVVQNkVldDd3NXIzRXZHTDhaUXdVTFhtMGt2YVBDbjIr?=
 =?utf-8?B?QUNRcFRiOHliOEhLY0U4MkV1aDMxVVU3T3RrN0RBUGIwMEk5ZlhvNWFFazdM?=
 =?utf-8?B?Y3Z1ZWpySGJEQTBwU203WjYvUURJWXV0ejRYc0YyL3gzaU1Jd2J3eGk2dDBL?=
 =?utf-8?B?NzBpMW5lcjFHek1GTERUcnVhU3JJSUhJcFVmL3RFbC93NU9ET2RMQ1BwdWFS?=
 =?utf-8?B?R200QjBqS0RhTUVRZWwyS3FlOW9UUzl6QkdEWnNYa2dudm9JZFB0VmxpNm1j?=
 =?utf-8?B?aExTZmdRR01Mbk5sS04vNmJncENxVFBvaHVRVzNWOUFPc0hROHpPbGYrTkxZ?=
 =?utf-8?B?OS9vSEhyUGtUSEtkeGR3eHd0bzlGcFFYVU9qZkF5VTNzQ3VMQ3RWWldzYVJ4?=
 =?utf-8?B?VlQ2bGFhSStKZjdoZU9JbDIxR0FYWmsvTmliWHE4R21UWnBQZU5Ic0xqOUFp?=
 =?utf-8?B?bjZpZEYxbXlWejVKdStEVjREUFNBbEFLMGZlUDZiYlB6emFVcjYxRWRXYjdx?=
 =?utf-8?B?Z0xUWmVWUFNiZm1BY1lWSzIvdklHTXJISDhjZGNoZ3FuRXF2NUx2YUtEQmRL?=
 =?utf-8?B?a01LRkFVODV2dFhKeEdxUkRpbWRMOThma0NsSTdCV2hmb3hLOXVDaTNNSHA3?=
 =?utf-8?B?NlZjdXFPV1k2NEdtWWhpU0YrVGlIMkhaUGhjanRiR2xsU1Z6bUFudnNBREZ5?=
 =?utf-8?B?Njg3TGlLSElPL05mQkxPd3c4ejBPZE9PczNQZnFDYmg2aXQvSlhRWFRjdGg2?=
 =?utf-8?B?VVljcFFlLzVKenRIM1JXMGN6c3hmc3lzc3E2dzJWUytNZ1A5akk4M0VKQXlW?=
 =?utf-8?B?bTYxTXFPZTZGbzJTNlp5cHNVREU3MTVGSmdlc054cHNUMUxxTHdOa2VaM2JT?=
 =?utf-8?B?cEVWRnZaZWEwMllwZ0RneC9TcFZ3WTRHeHpIVmNZaXVuNGNCWmtzZ0tnM1Q0?=
 =?utf-8?B?UlgybnBmeFU4WkNVcSt6Rk0rZHZ4MFNMWmxyaDRDYzU2R3JyZU9oWmI4U2Mw?=
 =?utf-8?B?VXpSUG1LUlVDTnQ5bFY3ekgxclM2Ty9ydDZ5a05YT25vcU9rVHlHQm52ZVFq?=
 =?utf-8?B?bkw2cjdjYzZrWUNCM2M5TjhSK28zMGxDVFNXZExCZE5mbWRpeEhnYjlxeVJk?=
 =?utf-8?B?TWwvWGtCZlg1eXlxQ1Y3VzFwL0lHZzV4QmFSQVZhU0c2WjJpU2VOOTlQbjVn?=
 =?utf-8?B?aFc3WllWZThDNzBCQ2k3KzZ4eWl0MEJlRDJoSlRsVUVSL3NvYkxIVzY2dkVH?=
 =?utf-8?B?eVBaZFpsYk5ENGRReGZPRExzZDJweEw1dEhoa2VZZWhBbjF2LytuZWZqWnZO?=
 =?utf-8?B?TmwrTTJKemN4K05VVlNUSHJqeW8zZjRXS2szTm5QblhFK0VjNjhpWlFDWlND?=
 =?utf-8?Q?TxR6IO1WaG4nk9wQ86wM0X4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y0NNdktZdG45WFhHZnE1Ym02d1JYRG4zeUFzZTIvUGxrc1Z5aklWbllpclJK?=
 =?utf-8?B?eUluVTA5ZXdvSGpaQitUVVB5M0lJVVk3cWMwcDZmbGppeWcrNm5rWkwwdnI2?=
 =?utf-8?B?TzlLemxjbko5cTJRaDhITWhIcjdMU3M5WnFjTklVS3VmUjY1cEF0dnh4T0Fh?=
 =?utf-8?B?S2N3OFJ5eGZmdHlsN2ViRWJFU1IzWlJpV2IyNkY1WGNUMTRvVkdnWi9HVytU?=
 =?utf-8?B?MllRNENzaGJqNHdnUkE3eUM3MklCdExiRWFEcGloTkptYjRFc0M0b2ZreWJU?=
 =?utf-8?B?OXJwZFFwMUZFMHFnRjQraUFUdS9MT1pkbmsvMDkxUDFqa1NuWEFOZHJleGU0?=
 =?utf-8?B?OTNETmV1SkJUNm5vVUJFaHJGWm13cm9PTWI4N2ZBSDhZaUtwT2thQyt6RW9R?=
 =?utf-8?B?ak5zTUtZb0NieUtmZ3crZ2d1UGtJc3UwbUlVamwzUVdJRUxIeFNaaU8rTE5v?=
 =?utf-8?B?aXVvSEMwZmkzNW5PVGtocmVrNVlTcDYxZktIWVg1SEEzZGVMNFRuQnplK0F1?=
 =?utf-8?B?RHkwRXk1MlBadUNYOW1XTWxvV01vR3NTb3FsSU1nRWNIM3RMcnNFSk1GMDRk?=
 =?utf-8?B?d2M2VEw4ZUNGR2ZaV2pqVi9JSExic1k1THVJTktoNWpxZ2l5dnF5ZEVzN0ZN?=
 =?utf-8?B?TFVuUCs1TCtNN29hMGdkdXpPajhBN1JMM2NYSy84RW8vclo5S0RMeTRBbjlt?=
 =?utf-8?B?eHh6dzhWUmRyWFYyV3Z4RCtnS2FFQ1l0dEcwMWprWCs0Mnh0NGRFanpCUGdR?=
 =?utf-8?B?THVNQW9yanZGZEg4cSsxWGluelRweHFmbUpYd3Jka2gzaSsweWxLSytZK1VZ?=
 =?utf-8?B?WTl3V25VOXR0a3J2L0ZrRnE4M1k1T0JvUzR4WkJrL2xpai9uTEtrRUdYZkhI?=
 =?utf-8?B?alJnbzFrUUs5UmNsV1lubldNWEZzM2kwclg0b0dCRU5ENkVNd0pkWTBIWXJo?=
 =?utf-8?B?S2FiU0pFaW9ERG5WeE9iYm9nSmF0R1loQnpDaXZCQkRLZ0xOZTZrZ1NUWmJn?=
 =?utf-8?B?b0JBN3cyY1pEeWtQc2xZVnFtMjg2TCswQldGZi8zMnRwL3VSL0lxUG9sN3Aw?=
 =?utf-8?B?RFVWR1BQLzg2TGFFQWNCTGFicjRqWkJxbzNmeHlVZytMWVk4a05wb2FGbHB5?=
 =?utf-8?B?RStUK1l1OG9RR2NycXJ5QmtTTUsrdE1kVmkzSUI0K2tDbFVwMEVoNTNienNm?=
 =?utf-8?B?NEc5SVZtVW02M0lGRUZ0S1ZFVnJNVVRRaFd2MDAybzR2Z1lwZk9PZEgvTWNV?=
 =?utf-8?B?ZEw4YVNWL0pUR1NnNm9iNVNvenprN0Z5a1I3QWhKT1c2WFFpNUFpQjdiaVh5?=
 =?utf-8?B?T2hJQmRBcHFCREFhOTlKQ0lwUlBudm1hVDBuNDZjQThWN0NMRHZ5aTJMRGJN?=
 =?utf-8?B?cGJvQmhKZmRYYm9DUHlKZGd5eE1lTnB4T3JIM1BsZGZxVjQwNm0yWVpua1Nn?=
 =?utf-8?B?WldFbnd0SGpVZlpBbFU2dkpoL3VMc1YvVEV0d3k2R282ZmYwOXhHYTFKSTB1?=
 =?utf-8?B?NFozaWovOUZzR2g4N2pXcG84cE1Qd0x3Ym1GaTV0aGtBZVZZU2hJV1paZmpJ?=
 =?utf-8?B?djJPZnVGL2JSUXQ1T3N3Yk93MDBVb2d0SHpLUExZWFkrVEdpekMvaGpYQjV3?=
 =?utf-8?B?RUhWN3pmTFlsVGJEZlpDMTZRN2c1aEFlQUtQRlY4WEE0N3lEVzZPVm9yTS9r?=
 =?utf-8?B?dXQ5MlljM0dKMGFaMXMxZGN4bGYreDdnazVLWnZvUGhOVVlTRVp2OG9tZ0d0?=
 =?utf-8?B?b0xDcVh0eW9nd3BQR0ZvYXhYaU56L21hbmNlaXN2a0xOVmZ6dEIwaENMV1No?=
 =?utf-8?B?RE14RWRDcUxZbHVoN3BDbndicVNDaG5mOTMzZ0xISmFxMFh1bVI1clJURlBT?=
 =?utf-8?B?cDhNdVdJMW9LMVVjd3cxZHM0V0MrVTkrWXAwbWxHbVFDUU5Ub2lYbzhHdUxB?=
 =?utf-8?B?MnZkdVFIcFh6a1RqOUNPMFdsUWZpWUQ1cExnSEhpSHBGdzhoVDl4M3R3bS9S?=
 =?utf-8?B?Z0tPY1doWnF3dDNJUXVaK2VkTmgwS29TS1p5RUlyRkJFRGdMSkRHcTg1dzl2?=
 =?utf-8?B?bk54M1JYZHk1VWhJSXBRNkF1SEppaUVmSTVQK1B4MjRkYjZkbUNZWERleUxD?=
 =?utf-8?B?dVpEZW4relUrd0ZHbHZ0SzQ5NEJ5Tzl3UDJyaW10RTNSaWJsM0xHeTEwbVhD?=
 =?utf-8?B?R1B4aTVZamdEeThJVWVmK0J1bFFCMURySWc5d3kxTXlSbXVnWDlRc0cwOVN3?=
 =?utf-8?B?N1R6NWZmM2tRbitGa0pQOUNmZjRScEhIMGs1ZkdtSkxKV01Oc2dFQ3pmeEV4?=
 =?utf-8?B?WC9jaG8wL2dPV0dYaStmempKWXh2Q0JFWFpLMXM2SUpwMEQ0clMySXgzTnI4?=
 =?utf-8?Q?J09onaxYKsfyfhfM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E9FE757917A1954A807463F903D8DCC0@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7380d046-b0fc-4b6e-8ee6-08de6a07aea6
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2026 07:23:56.0489
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DDIkUZsECs23Je7bXvzOBe0v6Pprf6ZK4wu0+vujXrVLEzUvZfBKb74L8T0e3rWSOGgJ5o16XoB5faLTW8/eZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR03MB6537
X-MTK: N

T24gVGh1LCAyMDI1LTA3LTE3IGF0IDE3OjEyICswOTAwLCBTZXVuZ2h1aSBMZWUgd3JvdGU6DQo+
IElmIHRoZSBoOCBleGl0IGZhaWxzIGR1cmluZyBydW50aW1lIHJlc3VtZSBwcm9jZXNzLA0KPiB0
aGUgcnVudGltZSB0aHJlYWQgZW50ZXJzIHJ1bnRpbWUgc3VzcGVuZCBpbW1lZGlhdGVseQ0KPiBh
bmQgdGhlIGVycm9yIGhhbmRsZXIgb3BlcmF0ZXMgYXQgdGhlIHNhbWUgdGltZS4NCj4gSXQgYmVj
b21lcyBzdHVjayBhbmQgY2Fubm90IGJlIHJlY292ZXJlZCB0aHJvdWdoIHRoZSBlcnJvciBoYW5k
bGVyLg0KPiBUbyBmaXggdGhpcywgdXNlIGxpbmsgcmVjb3ZlcnkgaW5zdGVhZCBvZiB0aGUgZXJy
b3IgaGFuZGxlci4NCj4gDQo+IEZpeGVzOiA0ZGI3YTIzNjA1OTcgKCJzY3NpOiB1ZnM6IEZpeCBj
b25jdXJyZW5jeSBvZiBlcnJvciBoYW5kbGVyIGFuZA0KPiBvdGhlciBlcnJvciByZWNvdmVyeSBw
YXRocyIpDQo+IFNpZ25lZC1vZmYtYnk6IFNldW5naHVpIExlZSA8c2gwNDMubGVlQHNhbXN1bmcu
Y29tPg0KPiBSZXZpZXdlZC1CeTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCg0KSGkg
U2V1bmdodWksDQoNClRoaXMgcGF0Y2ggaGFzIGEgc2lkZSBlZmZlY3Qgd2hlbiBzdXNwZW5kIGVu
dGVyaW5nIGhpYmVybmF0ZSB0aW1lb3V0Lg0KQWZ0ZXIgcmVjb3ZlcnkgaXMgZG9uZSwgdGhlIGxp
bmsgd2lsbCByZW1haW4gYWN0aXZlIGluc3RlYWQgb2YNCmhpYmVybmF0aW5nLg0KVGhlbiwgdGhl
IG5leHQgdGltZSB5b3UgdHJ5IHRvIGV4aXQgaGliZXJuYXRlLCBpdCB3aWxsIGZhaWwgYmVjYXVz
ZSB0aGUNCmxpbmsgaXMgc3RpbGwgYWN0aXZlLg0KDQpXaHkgZG9u4oCZdCB5b3UgY2hlY2sgaW4g
dGhlIHJlc3VtZSBmbG93IChfX3Vmc2hjZF93bF9yZXN1bWUpLCBsaWtlIHRoaXM6DQoNCiAgICBy
ZXQgPSB1ZnNoY2RfdWljX2hpYmVybjhfZXhpdChoYmEpOw0KICAgIGlmIChyZXQpDQogICAgICAg
IHJldCA9IHVmc2hjZF9saW5rX3JlY292ZXJ5KGhiYSk7DQoNClRoYW5rcy4NClBldGVyDQoNCg==
