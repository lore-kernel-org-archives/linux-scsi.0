Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1F6186295
	for <linux-scsi@vger.kernel.org>; Tue, 15 Apr 2025 08:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744704073; cv=fail; b=o2XrWS31ZblXWFcMBGfQ4cLApc8fUGp82L29ktHwOS+scsh1p1s+jfX0jwkB7Uov4ZDfntANnFBTP4qIWnQnGlX2CXC+yoLuVqdf1QDQ9TcAbivr3pX6zyF9x7EtKM7cGI92JadNtGW3Hb7xuLe8E9rnf6GM6sp7j7qYQC1hC7c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744704073; c=relaxed/simple;
	bh=7CG/0Cv6So9kiL22lj06aEkXXYRpggCMUAqWUShBNws=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KfL9LQAAMzdafnPL/w0PxnzTcdsDJeYHdzO4yFanUheotmDJ1Uz3voF8l7ElSrl6yRiZG2a7J1TenVemsrc7eSJtN3ogbPqvHVnhS4+ELC8oCMk6Pdr9W6cJiZtLxJGnDgU51FMGiM7k4KcbnSchwYSJVqRoXgQvcx6TlZQEtV4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=TegAlY/7; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=oCZz9GVV; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="TegAlY/7";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="oCZz9GVV"
X-UUID: c62ebeee19cf11f0aae1fd9735fae912-20250415
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=7CG/0Cv6So9kiL22lj06aEkXXYRpggCMUAqWUShBNws=;
	b=TegAlY/7qRVUblYMkut5mXrqvagpvgGzXxovBR0IyczMPAEqF4tGwkj4whftQBnG+yF5U+07OK30WHoDq1y1raLdp8ygYBaK05BzDOUzZl5zepDgpCHdLWA+ImanBA1fgTlpfKQdD7lMaMozuaQtHkT+MgR9yrdaOEPxva6sRs0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:570937e0-89a5-440a-9345-490410894714,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:312e448b-0afe-4897-949e-8174746b1932,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: c62ebeee19cf11f0aae1fd9735fae912-20250415
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1654007756; Tue, 15 Apr 2025 16:01:02 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 15 Apr 2025 16:01:01 +0800
Received: from HK3PR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 15 Apr 2025 16:01:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ag9M4VXqNShJ2r+AjejFntK6hCFBSJB+4xmTV1RZRl1zWjSpQ/pfVfSjERkMKi4Vo1q+YVx0akxIEya+o1NuayEqYpL3Z53p8vyQLu83tWj+dWx26sEBeo+cGQe2exAvJC+3Q1yzBdH2GxV5Bxb/v56RgSQU/MlSAuHniX9D0EuTWdF/48zBPKcKoKQec/plInc43NGvtbF/gdDnFcYwyrI3Hm3evC5DZESYTKRNO/63I/gHMInBJVT2z3s4+7qAuE84KxqC9QlnEYk9fiexmxbMGgWMBMW5fF/TNxdVPe71uKxL+gyZ8uDkY+LMsHGJ0MDNtL5Myd5PMfIO4Achng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7CG/0Cv6So9kiL22lj06aEkXXYRpggCMUAqWUShBNws=;
 b=cb5TEtKK7BrhWSxUH8U1IyG6rEuikldJ+WySCX+jxSe+UFFoD49/0+PNt8KnVayoIGXemuqXcKw0qhR5sWXana/XHBYEVjQW9WXEZTi5Ep/tvZeZJaqJNlM80s6NFzGJwl4W8rVooFqnG65sVMgH5I0xl9Q1fj0uwyAMiAAryFZe75v0v3osyV1Vwk+ZCqyjxItdodDzJ01NBCu2tl5VJXYVP/W290FcwGTV4eUjoFLrCW2C1Rn26EILA9eq/y9qHbBHcZG1dVjUbvMre0y9LTPBmMWckhqHxeyBv5+8CPx/vgtddYWNMNou1xl3NP3UVUxsNkOwTmD7bN7wMiQjIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7CG/0Cv6So9kiL22lj06aEkXXYRpggCMUAqWUShBNws=;
 b=oCZz9GVV96rn91ihN8FJjyfz2CwoV6uypBiSereCNWikYkNT5SrM+IFZq6l4ACfIU+Y3kvCvlriuJpO0fqViDLEgYc5+RJRDhq5fFKnpjEp/zYbIZHIrVxsFq06iWXzAB3aJ84mu26VMZCtRsy+cqlD7tnEDIbSZd9AsAlRscUQ=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7902.apcprd03.prod.outlook.com (2603:1096:820:fa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.32; Tue, 15 Apr
 2025 08:00:58 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8632.036; Tue, 15 Apr 2025
 08:00:57 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>
Subject: Re: [PATCH 12/24] scsi: ufs: core: Rework
 ufshcd_mcq_compl_pending_transfer()
Thread-Topic: [PATCH 12/24] scsi: ufs: core: Rework
 ufshcd_mcq_compl_pending_transfer()
Thread-Index: AQHbpN56xYfiOTSZp0K/37ODiF6R37Okb0yA
Date: Tue, 15 Apr 2025 08:00:57 +0000
Message-ID: <0390adb9d0ebed4ba4b386453d20175b1f3a0709.camel@mediatek.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
	 <20250403211937.2225615-13-bvanassche@acm.org>
In-Reply-To: <20250403211937.2225615-13-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7902:EE_
x-ms-office365-filtering-correlation-id: c3f68a9a-f57e-458d-2090-08dd7bf3a7d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?V20xSjNGTHZaTU5YRWlnN1dPNE5NbFBUWGI2dmdDbzBBcWI3cmtHTWVnT2lt?=
 =?utf-8?B?VzBoeVIxV0pLMjhaUWtMUXBNODZCWXMxeW9yVkpXdmZxRFBNK2kwcmNwb3RM?=
 =?utf-8?B?TDk3MmUvUlFuWG4yK1hVelROaEFYeXh3QUxuVG4rd2FEd21ZaVBjVjVqUllj?=
 =?utf-8?B?Z05LaWltTWU2ZEprTmJnai9XN1puK0tIbmtWMmxZMFJCY2tYZ2JENVdZcmtq?=
 =?utf-8?B?NzZvK0x3UVV2Y2NPdm5vVHdLd0lFRHVpQWNJbUJKa2VhNFB0RUMrNGJvN2Y2?=
 =?utf-8?B?WjkrVVlnUjd3ZmNsTEkzc3R3Y3UraXJ3M2RTbHRIN0hVU1U1LzVSTlBvanNV?=
 =?utf-8?B?MXdiaXg5WFRCVkZ4NHRScmRtM1NSdUpteEtTT296MWY4c0pCVlR0SFJENHNY?=
 =?utf-8?B?ZVRSMmo3N1g5N2lNQzhnU1F5cmFtRW84UzBhSmk0N1liWXd4bFNhS3dyZ3Qz?=
 =?utf-8?B?eDNWNTh0dXVzMDRtY3U0THBZL21LTEFRbWdjWi9ZMzNDYUZIb0F6eDJza0Ey?=
 =?utf-8?B?OFhNUE03WVNsM2hVK1BDbCs1SDlxQ01PSnluWU8xN3k4MjFyVDFOMnVHazhP?=
 =?utf-8?B?OWEvYjY1aENENEVMTWRKQS9waVgyVWp6ckpvL0ZaOVF0MGY3NHdHVnBEcnpp?=
 =?utf-8?B?MUFld1JKRW90R0FtWEcyWWZpVENkU05LVVFjTGdaQWFDa1BDMGRIc3BRZkwy?=
 =?utf-8?B?ZGc3TjZ6YURzQjlaczFMcXRjbUQwWEU4L09FYlpZRHFMblA2ODVmSU9UVXl6?=
 =?utf-8?B?Yy9pV0drbEdscDFGeThsaXlyUnFqdjZkNWZFMS9jTlMwaDQyc2Nha20yNlFS?=
 =?utf-8?B?Vm9kMGdKZHoyS0lKbUpBTnF3Z1orQ3BQUWZJcys1NjFZNHN0WlZ1N2xaTHlx?=
 =?utf-8?B?ZHBSNDcxL2pxSC9vK2hmSlNFZCt0OS9hZTFvNWU3TFZabmU5NUR4eFBGb0ly?=
 =?utf-8?B?aGJQYkpMeUdIdkVSQjBMYjIxSWZxRXRPUkQxSjR3ODNYSU9ZRFpiaDJjVS9w?=
 =?utf-8?B?emtENksxaENQcEFDekhobm5GdzR0bDJCRUd6OWhBR3JUcTdJYzYyNzJyY0Y2?=
 =?utf-8?B?bjBSd1Z4cU5CQi94SDEyQWtINGovVk40YTRtR0dmdmV1L00waEh2K2k4K0p5?=
 =?utf-8?B?dXBDVnFFVXRzUDZjK28wKytSa2JRVXc4SWZGT1JZenNqMGltaldUa0lDNTZj?=
 =?utf-8?B?WWdqblZrQ1EvV3AzaXFvNVJtaGd2VlFnU0JBeStwUmZUSEkzZTRKRGF6M0l4?=
 =?utf-8?B?SmJkQS9YREZlK3F4REx1ZU1iblRWRk45M05IK3AxQTJzbjdwWHRackhyY0lF?=
 =?utf-8?B?WUZVSHRvbVZNcTM4SFRWVXpLaGthTTl6RU5SS3NNS3dnYUNaUk1mMUtsUjFh?=
 =?utf-8?B?cExwdDdZMUFYVzd4emFwWk1Oak1GdkZTZ1RyRGhFMjA5WnlwUm40b0hhMVJF?=
 =?utf-8?B?U3VDNGhNMVBlZzNFeGpQYUptQ0ZKaVpDaEhPNVI2SVhqREdEbHRqUnhjK2sv?=
 =?utf-8?B?d3dWQ3VaUEcxeE0rRTZjbnJaUVZPdFJOSDBrU0dpd0p6VUR5OHBPdUw4TXFp?=
 =?utf-8?B?NGZ1UnZMZzVoMUN3SGx6WDRlVkN0QlNoejExTjdzTXFBa3JOSStHMEVIZ2FR?=
 =?utf-8?B?UFc1bHhCTFdwYjc5bEFYVHo3Z3lzakR6clBMQ090Yld2WlpTZE95N2ZPYVoz?=
 =?utf-8?B?VDVUUlNoRXdubXRKNUVQWnVjbFBFMzhham8waW9sMzJIOE9YcFl4dFRHSUJ6?=
 =?utf-8?B?dURmczVPNlRST3dJaTVsOVpqdXkzRit2eDkzY3phMzN5MmgyOFFIc3l1a2dI?=
 =?utf-8?B?RlM1b0xRdkZEM1pENGd5ck81RWM1WUEvUTNIemE3Sk5qZnNCTFA3bXViaXdr?=
 =?utf-8?B?bW9sSy9ya1Z2ZThEaHJBYWp6WmdySk82aUZhWmY2cFpUc3JBYzQ3NEZCWWlT?=
 =?utf-8?B?enJXTHlCWGFLbWZ4MnlIOWd3KzJwclNzRm1ML3l6RjU4V0FTSGhSVERmaDlw?=
 =?utf-8?B?bVFSQml2WFlnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SFNxOHhYQ0k3TFRNcm5hMUZqVmhBUmdqOHIvNkZ5TzBvU29jSktPYnJZckp3?=
 =?utf-8?B?M002N2pLcjkzaDVEZ2szUTBjSUhYRzlaQ0t2Q2FHNjNNT2EzMllmQXpKaFZ4?=
 =?utf-8?B?L3JoeUZaRWIrYjRFSFRwR2ZucWhyaXpJL3p1VFpid21tUW1sTTgva0xyT3U0?=
 =?utf-8?B?QmNUbThmcVdJR01sUmRiYVNZTHVhcXdWQW84NTRiVVB1RXVTQ3RaZXlXQTN4?=
 =?utf-8?B?bVd3RE5Tc083RkY0Rk9mb2FjZVRkckR0Tyt5b0k4WXJEWElORDVqbGhjYUVw?=
 =?utf-8?B?RXdsM2hLTyszSkF5OUdGY1ZDbFRkcGVsSEJ2QkVzY2ZMZFR6MnB2RGE3ZDBG?=
 =?utf-8?B?dVRjYkJVaXQvc1lZN3BuV2lWQ0tTcElXdUJKcFZhL2o0dDRQWElXK1ZyUi93?=
 =?utf-8?B?b3F3Vzc3MmNuTzFZSUM0WmhlMlhBUFBRblBmVngrL2dBQ01VbVd2b1lTUm16?=
 =?utf-8?B?Uk41bEE5eW40ZnBFZkt6OTZzaGVpRVlsSUpPMUNuV0NaS0JVanpZL3FZUkpT?=
 =?utf-8?B?RlV5dnA0QUlpUXRraFNGcFozb2RuaVVnVDJvcGlVQU4vZmNIYWVrMTd3bFRB?=
 =?utf-8?B?aXhKa0gzUkNnTlZxMlJBM2J2VmIrQ0MwRXZKZ0VSMkV0VkRFbTZWL1hsWURm?=
 =?utf-8?B?d0VqOTR6cWRNck5WUHlxOHU5eXJYMk12ai9sb3k4cWV0MFhSTEQ3bjN6RDlJ?=
 =?utf-8?B?NllOcnNjWi9nV0RrMFhXczZOSGJ2QnhQTkVwUTRNamFHRGN5UlJzYlFPc1RH?=
 =?utf-8?B?aW51VXdyK3huWGJsRDlnWi9saFMvcTNqMzdKdjZCbWZhd1B6cEJ1M3JGTW11?=
 =?utf-8?B?MjJjZzk4RmlmQ2F2a1EvckRBa2YzMVpVdmFLWndacEVRWE1VN0N2VkhBd00v?=
 =?utf-8?B?Q1BBempwdDllTDFoV0JWTXhVd1ZLUXcyK2cxSCsySEpXNXpCblAwRlVmSGVU?=
 =?utf-8?B?ZC9sLzZQZldZVmZZNXlqZlQvN05WeldPU1UwQlI0Mk1ocFA4TWlMMXI4RDV4?=
 =?utf-8?B?dWlVKzFVVFEwb3ZQOUl0b1FiWnJtTGF0TVB3cS95azhYdmVGRGMyaVMwSTl2?=
 =?utf-8?B?dzN5eWYrcitsM3RZSm1VTE9JdUFqd3NtQTlDWjB6Sm5ncEdCQW5EdWJxMStm?=
 =?utf-8?B?MW02b1A1TUFBZmJBOG5YZ0hDTHdxd3pvTUdzb1VBejY2VGRqeFlGYndpdzV1?=
 =?utf-8?B?cnR0NU1OLzFSemhqaDVnK1pncmVDdUdZQnh0LzVDS3dYSlBhazFoRTh5Vit6?=
 =?utf-8?B?V1laeE1zM0JVeUh1NTRKYmk4NnJnbFZOTW9mMXdjNXVPcEtpZFJRZURCSTJC?=
 =?utf-8?B?QW9VWSs0aXRnMjBhUVlvbXY2aUlMaDVsNlV2MllySmZUNXNFWEl1QUhVanhs?=
 =?utf-8?B?ZTd0SFd6REgxVVZMazFPU0sxVEF0NmJhQVJVVnFUQkIrZkxRenhuWmtMdWs3?=
 =?utf-8?B?TFNOQU8rQlZaTSt5NjV0akRFVUVCUko1dG5SQUh5T0lMWWpPS3VIcGVHVDRY?=
 =?utf-8?B?Z0YySnhyWGVjSkRSZ2hsZnQ5eE5hWkFCSlhMR3RncDNzNGg1Z28yRnRJK1Fw?=
 =?utf-8?B?ZVBPZlY3U3ZrVWQvMStWbjBka2ZvZFlKZ2lRUm0zenFxVURwSVY5OEswdjlu?=
 =?utf-8?B?REdQc205bFcrWTZBaWhtWnJWYVZOWnE0YVJTTTZrSk5kYW5Pbkl3WDRtSW1W?=
 =?utf-8?B?NTVjSTFSTlJnYmp3OTlLOG51Qm5iYUFHMWc3UEFxbUVBK2RMSklEeDZ3bnNt?=
 =?utf-8?B?cnkwRUlhREhzV2ZPR2JVMGVrK295KzRMREdLR3dpVmFsV0xXVVF2bFZPREJa?=
 =?utf-8?B?TWhRSGdYU1lJZ2I4Tmpka2tBdWlRTC9uNTEvaGNpdEh6aE5FNmdNNmNnU1NP?=
 =?utf-8?B?enFadHNRbnpJemc2ZjgxM1JIcWlmV2p6a2ZqL3ltNjIrbENxRWxiVHNnY0xQ?=
 =?utf-8?B?MnVpQXdsanhwSTM4YWNSWkhwQWN0dHB1TGxNUVdnbFNLRUdmeHpwV3BIbXdv?=
 =?utf-8?B?R2pORm5LYzBCd0t0YUx4WDN6VjZralJid2dvOFdzcms1WkIwcU0xNEczbElE?=
 =?utf-8?B?aHQ4NWJwc1B4R2JkNmx5T2NaeE1xQ1ZrVDlNbEN0Ylp5QW04b2FtbldtVk1r?=
 =?utf-8?B?V2N0K25YOUgwTXcvSE1tcG5BTjU0MDF4K0NMMkUvU1NjeHN5Y3pGVmdpVjFn?=
 =?utf-8?B?RkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1F79305467747D4C93A6CCB95D155B2F@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3f68a9a-f57e-458d-2090-08dd7bf3a7d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2025 08:00:57.8962
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: shjMWXHaY1Ya2c0TI2FGidIc2EGe7uMVBdH9aNBXN7587FLHAQ7ESPCFvSuXAcCLK+OvubA8sBPVX6eTSYGrHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7902

T24gVGh1LCAyMDI1LTA0LTAzIGF0IDE0OjE3IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
Cj4gCj4gRXh0ZXJuYWwgZW1haWwgOiBQbGVhc2UgZG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4g
YXR0YWNobWVudHMgdW50aWwKPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRoZSBj
b250ZW50Lgo+IAo+IAo+IFJlcGxhY2UgYSB0YWcgbG9vcCB3aXRoIGJsa19tcV90YWdzZXRfYnVz
eV9pdGVyKCkuIFRoaXMgcGF0Y2gKPiBwcmVwYXJlcwo+IGZvciByZW1vdmluZyB0aGUgaGJhLT5s
cmJbXSBhcnJheS4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3Nj
aGVAYWNtLm9yZz4KPiAtLS0KPiDCoGRyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgfCA3NCArKysr
KysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tCj4gLS0KPiDCoDEgZmlsZSBjaGFuZ2Vk
LCA0MiBpbnNlcnRpb25zKCspLCAzMiBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy91ZnMvY29yZS91ZnNoY2QuYyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMKPiBpbmRl
eCA0YjU3MzRiYmIxMmIuLmE1ZmFmNWFmNDYyZSAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL3Vmcy9j
b3JlL3Vmc2hjZC5jCj4gKysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYwo+IEBAIC01NjUx
LDYgKzU2NTEsNDQgQEAgc3RhdGljIGludCB1ZnNoY2RfcG9sbChzdHJ1Y3QgU2NzaV9Ib3N0Cj4g
KnNob3N0LCB1bnNpZ25lZCBpbnQgcXVldWVfbnVtKQo+IMKgwqDCoMKgwqDCoMKgIHJldHVybiBj
b21wbGV0ZWRfcmVxcyAhPSAwOwo+IMKgfQo+IAo+ICtzdGF0aWMgYm9vbCB1ZnNoY2RfbWNxX2Zv
cmNlX2NvbXBsX29uZShzdHJ1Y3QgcmVxdWVzdCAqcnEsIHZvaWQKPiAqcHJpdikKPiArewo+ICvC
oMKgwqDCoMKgwqAgc3RydWN0IHNjc2lfY21uZCAqY21kID0gYmxrX21xX3JxX3RvX3BkdShycSk7
Cj4gK8KgwqDCoMKgwqDCoCBzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXYgPSBycS0+cS0+cXVldWVk
YXRhOwo+ICvCoMKgwqDCoMKgwqAgc3RydWN0IFNjc2lfSG9zdCAqc2hvc3QgPSBzZGV2LT5ob3N0
Owo+ICvCoMKgwqDCoMKgwqAgc3RydWN0IHVmc19oYmEgKmhiYSA9IHNob3N0X3ByaXYoc2hvc3Qp
Owo+ICvCoMKgwqDCoMKgwqAgc3RydWN0IHVmc2hjZF9scmIgKmxyYnAgPSAmaGJhLT5scmJbcnEt
PnRhZ107Cj4gK8KgwqDCoMKgwqDCoCBzdHJ1Y3QgdWZzX2h3X3F1ZXVlICpod3EgPSB1ZnNoY2Rf
bWNxX3JlcV90b19od3EoaGJhLCBycSk7Cj4gK8KgwqDCoMKgwqDCoCB1bnNpZ25lZCBsb25nIGZs
YWdzOwo+ICsKPiArwqDCoMKgwqDCoMKgIHVmc2hjZF9tY3FfY29tcGxfYWxsX2NxZXNfbG9jayho
YmEsIGh3cSk7Cj4gK8KgwqDCoMKgwqDCoCAvKgo+ICvCoMKgwqDCoMKgwqDCoCAqIEZvciB0aG9z
ZSBjbWRzIG9mIHdoaWNoIHRoZSBjcWVzIGFyZSBub3QgcHJlc2VudAo+ICvCoMKgwqDCoMKgwqDC
oCAqIGluIHRoZSBjcSwgY29tcGxldGUgdGhlbSBleHBsaWNpdGx5Lgo+ICvCoMKgwqDCoMKgwqDC
oCAqLwo+ICvCoMKgwqDCoMKgwqAgc3Bpbl9sb2NrX2lycXNhdmUoJmh3cS0+Y3FfbG9jaywgZmxh
Z3MpOwo+ICvCoMKgwqDCoMKgwqAgaWYgKGNtZCAmJiAhdGVzdF9iaXQoU0NNRF9TVEFURV9DT01Q
TEVURSwgJmNtZC0+c3RhdGUpKSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2V0
X2hvc3RfYnl0ZShjbWQsIERJRF9SRVFVRVVFKTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCB1ZnNoY2RfcmVsZWFzZV9zY3NpX2NtZChoYmEsIGxyYnApOwo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHNjc2lfZG9uZShjbWQpOwo+ICvCoMKgwqDCoMKgwqAgfQo+ICvCoMKg
wqDCoMKgwqAgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmaHdxLT5jcV9sb2NrLCBmbGFncyk7Cj4g
Kwo+ICvCoMKgwqDCoMKgwqAgcmV0dXJuIHRydWU7Cj4gK30KPiArCj4gK3N0YXRpYyBib29sIHVm
c2hjZF9tY3FfY29tcGxfb25lKHN0cnVjdCByZXF1ZXN0ICpycSwgdm9pZCAqcHJpdikKPiArewo+
ICvCoMKgwqDCoMKgwqAgc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2ID0gcnEtPnEtPnF1ZXVlZGF0
YTsKPiArwqDCoMKgwqDCoMKgIHN0cnVjdCBTY3NpX0hvc3QgKnNob3N0ID0gc2Rldi0+aG9zdDsK
PiArwqDCoMKgwqDCoMKgIHN0cnVjdCB1ZnNfaGJhICpoYmEgPSBzaG9zdF9wcml2KHNob3N0KTsK
PiArwqDCoMKgwqDCoMKgIHN0cnVjdCB1ZnNfaHdfcXVldWUgKmh3cSA9IHVmc2hjZF9tY3FfcmVx
X3RvX2h3cShoYmEsIHJxKTsKPiArCj4gK8KgwqDCoMKgwqDCoCB1ZnNoY2RfbWNxX3BvbGxfY3Fl
X2xvY2soaGJhLCBod3EpOwo+ICsKPiArwqDCoMKgwqDCoMKgIHJldHVybiB0cnVlOwo+ICt9Cj4g
Kwo+IMKgLyoqCj4gwqAgKiB1ZnNoY2RfbWNxX2NvbXBsX3BlbmRpbmdfdHJhbnNmZXIgLSBNQ1Eg
bW9kZSBmdW5jdGlvbi4gSXQgaXMKPiDCoCAqIGludm9rZWQgZnJvbSB0aGUgZXJyb3IgaGFuZGxl
ciBjb250ZXh0IG9yCj4gdWZzaGNkX2hvc3RfcmVzZXRfYW5kX3Jlc3RvcmUoKQo+IEBAIC01NjY1
LDM4ICs1NzAzLDEwIEBAIHN0YXRpYyBpbnQgdWZzaGNkX3BvbGwoc3RydWN0IFNjc2lfSG9zdAo+
ICpzaG9zdCwgdW5zaWduZWQgaW50IHF1ZXVlX251bSkKPiDCoHN0YXRpYyB2b2lkIHVmc2hjZF9t
Y3FfY29tcGxfcGVuZGluZ190cmFuc2ZlcihzdHJ1Y3QgdWZzX2hiYSAqaGJhLAo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBib29sIGZvcmNlX2NvbXBsKQo+IMKgewo+IC3CoMKg
wqDCoMKgwqAgc3RydWN0IHVmc19od19xdWV1ZSAqaHdxOwo+IC3CoMKgwqDCoMKgwqAgc3RydWN0
IHVmc2hjZF9scmIgKmxyYnA7Cj4gLcKgwqDCoMKgwqDCoCBzdHJ1Y3Qgc2NzaV9jbW5kICpjbWQ7
Cj4gLcKgwqDCoMKgwqDCoCB1bnNpZ25lZCBsb25nIGZsYWdzOwo+IC3CoMKgwqDCoMKgwqAgaW50
IHRhZzsKPiAtCj4gLcKgwqDCoMKgwqDCoCBmb3IgKHRhZyA9IDA7IHRhZyA8IGhiYS0+bnV0cnM7
IHRhZysrKSB7Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbHJicCA9ICZoYmEtPmxy
Ylt0YWddOwo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNtZCA9IGxyYnAtPmNtZDsK
PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoIXVmc2hjZF9jbWRfaW5mbGlnaHQo
Y21kKSB8fAo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdGVzdF9iaXQo
U0NNRF9TVEFURV9DT01QTEVURSwgJmNtZC0+c3RhdGUpKQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjb250aW51ZTsKPiAKCkhpIEJhcnQsCgpSZW1vdmlu
ZyB0aGlzIGNoZWNrIG1pZ2h0IGNhdXNlIHJhY2luZyBpc3N1ZXM/wqAKTGVhZGluZyB0byB0aGUg
cG9zc2liaWxpdHkgdGhhdCB0aGUgaHdxIGluIHRoZSBzdWJzZXF1ZW50IGZ1bmN0aW9uCmNvdWxk
IGJlIG51bGw/CgpUaGFua3MuClBldGVyCgoKCj4gLQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGh3cSA9IHVmc2hjZF9tY3FfcmVxX3RvX2h3cShoYmEsCj4gc2NzaV9jbWRfdG9fcnEo
Y21kKSk7Cj4gLQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChmb3JjZV9jb21w
bCkgewo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1ZnNo
Y2RfbWNxX2NvbXBsX2FsbF9jcWVzX2xvY2soaGJhLCBod3EpOwo+IC3CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAvKgo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogRm9yIHRob3NlIGNtZHMgb2Ygd2hpY2ggdGhlIGNx
ZXMgYXJlIG5vdAo+IHByZXNlbnQKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCAqIGluIHRoZSBjcSwgY29tcGxldGUgdGhlbSBleHBsaWNpdGx5Lgo+IC3C
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICovCj4gLcKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNwaW5fbG9ja19pcnFzYXZl
KCZod3EtPmNxX2xvY2ssIGZsYWdzKTsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgaWYgKGNtZCAmJiAhdGVzdF9iaXQoU0NNRF9TVEFURV9DT01QTEVURSwK
PiAmY21kLT5zdGF0ZSkpIHsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNldF9ob3N0X2J5dGUoY21kLCBESURfUkVRVUVVRSk7
Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCB1ZnNoY2RfcmVsZWFzZV9zY3NpX2NtZChoYmEsIGxyYnApOwo+IC3CoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2NzaV9k
b25lKGNtZCk7Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IH0KPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3Bpbl91
bmxvY2tfaXJxcmVzdG9yZSgmaHdxLT5jcV9sb2NrLCBmbGFncyk7Cj4gLcKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgfSBlbHNlIHsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgdWZzaGNkX21jcV9wb2xsX2NxZV9sb2NrKGhiYSwgaHdxKTsKPiAtwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB9Cj4gLcKgwqDCoMKgwqDCoCB9Cj4gK8KgwqDCoMKg
wqDCoCBibGtfbXFfdGFnc2V0X2J1c3lfaXRlcigmaGJhLT5ob3N0LT50YWdfc2V0LAo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
Zm9yY2VfY29tcGwgPwo+IHVmc2hjZF9tY3FfZm9yY2VfY29tcGxfb25lIDoKPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1ZnNoY2RfbWNxX2NvbXBsX29uZSwKPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIE5VTEwp
Owo+IMKgfQo+IAo+IMKgLyoqCgo=
