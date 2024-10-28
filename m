Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D648718EFC9
	for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2024 20:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730146671; cv=fail; b=lKGAZ6ZwUY7bn5ny7dnDCxEoYP6izbh19mueKpuj//FDEIkGKOfj4MsBkg7J0Fb7pDn5uq28zDVd0zHqqeDWrOs8HZTP+g3NS5dCxNsw90M6msHHuHjFdTG8naf5QeprzAgWRIiSMRqJ0frGLOKlMEgtXx5USEyc+7XVtoCtza8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730146671; c=relaxed/simple;
	bh=ccrGCvpPUv1/81GtTDK6fzXFXF3HmSRYCdaSG0QQWNE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rT3m6JmyV9B5hIoEPtBc8w+Pi1ppTflBirPNOO2zR/JkHxxE+ujvxP/8ZCng7Vjlz5H7hTr6CyHHaBzuIEcySgIrwp6jiEP/FSxNz/bFQl5+WN6N00TXnLjtgfWXSIo1BkAt34+w3Gt6CUNaPCjbtdvo9/SSU7dnZaJ0nRrj0ek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=micron.com; spf=pass smtp.mailfrom=micron.com; dkim=pass (2048-bit key) header.d=micron.com header.i=@micron.com header.b=luhwf2FO; arc=fail smtp.client-ip=40.107.94.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=micron.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=micron.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=micron.com header.i=@micron.com header.b="luhwf2FO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ua04eAvDzC7+v66+ZWfCVu+cxmwSaT7bAkQkrU5pcGJNNFQPV/LDCJL6515ivcomY5Co61/sDA7M6XBGRSZEwtjPlmNMPctspenr/qgKwOhmZgITCAmSflUCCuynPCafBBi/3VFCAWYPskSD1ESwpA8LgEAmy4KEdAjtaayDt+ROwpFvrkofoYFmTu3igEKqmNIRYskxR0F2TdxdU83De0rEj58UdN/M1MN8peWVJzJqU8FPDIKC7SDbV6R7XYjbl2b4Ta690Ud30iyEozh2nxpYhWQ71civUbOuUi41387zSTpMoR0x+KW1dDbjOTtNrZl5xD3XkDtLcuG0Z0KvnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ccrGCvpPUv1/81GtTDK6fzXFXF3HmSRYCdaSG0QQWNE=;
 b=VNDAhAPeG0DqL1ETGVHPt8qmSS4uO7a76lp5XdboH4zuC/ikoYRULftKFF3jxgH3KtjP0k0FlD1zI2fRzxb79Q6KYjDwYt0aATqf/9qDA+/4jH8GFaGmRY5U9doW/nGKdwwZf4EtL6s2pGTmaJ8Aq/gNXfAzISLXTO4FkeLrWg8Zvra7zc0rHjHxNiCXY9ztbeluu8CYsiol8HpIulfAWXkHR5uvx5N4G/gZO9dX9MOODnSXyjPtbfMte/IG/GzXuIy24+Ta0K5HvzlURo/Oz1zWR7djpfRwTnnaMurr2t7TF2IyzE8oWicW5R0xZGQzMNIt0/awFpNoLrs5NSbdFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ccrGCvpPUv1/81GtTDK6fzXFXF3HmSRYCdaSG0QQWNE=;
 b=luhwf2FOy43YAd+wB5rdGnM/VPoB+B1bR86yQM57N2B8wmTe7+EIAOXzRV6EhbcoDV/h9eoBlBC4IFl2WhrhaVAjdiQhTvkvDs7Etux0T9Gc6uJmgCDCUfYtmkcKC3JefEn/XmR6WrjwSxggtL5zG+XnpALXp5yL6IGczr1JCRzi0qSWQaOHp0fP1fCI6iUPJJcJw1Qi0rkLgc/1RgFD2sXC6r8jyakdZdtpANJIV6GtZXyYVk1Sx+J4vLs51Ja5BFz14uhUN3sW2aGHLMKllY36FszE0PlAq5EomkG/YmaloW7gjMHVRisiIzZDIgGueEJ1RPC8BezcjAJvFez4qQ==
Received: from SA6PR08MB10163.namprd08.prod.outlook.com
 (2603:10b6:806:40a::22) by BN0PR08MB7421.namprd08.prod.outlook.com
 (2603:10b6:408:150::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24; Mon, 28 Oct
 2024 20:17:44 +0000
Received: from SA6PR08MB10163.namprd08.prod.outlook.com
 ([fe80::74f0:61ed:1b4f:6a36]) by SA6PR08MB10163.namprd08.prod.outlook.com
 ([fe80::74f0:61ed:1b4f:6a36%5]) with mapi id 15.20.8093.023; Mon, 28 Oct 2024
 20:17:43 +0000
From: Bean Huo <beanhuo@micron.com>
To: Bart Van Assche <bvanassche@acm.org>, Bean Huo <huobean@gmail.com>, Huan
 Tang <tanghuan@vivo.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, Can Guo <cang@qti.qualcomm.com>, Richard
 Patrick <richardp@quicinc.com>
CC: "opensource.kernel@vivo.com" <opensource.kernel@vivo.com>
Subject: RE: [EXT] Re: [PATCH v2] ufs: core: Add WB buffer resize support
Thread-Topic: [EXT] Re: [PATCH v2] ufs: core: Add WB buffer resize support
Thread-Index: AQHbJ97yrEYEmW+CFkOY1GKmd8K2QLKcgTKAgAAWhhCAAANjgIAAAHaA
Date: Mon, 28 Oct 2024 20:17:43 +0000
Message-ID:
 <SA6PR08MB10163D9B8FE4BE9DF5A47D9E1DB4A2@SA6PR08MB10163.namprd08.prod.outlook.com>
References: <20241026004423.135-1-tanghuan@vivo.com>
 <e992d83526fe722af8cef1b9ca737c8d0646417a.camel@gmail.com>
 <04e443d0-2968-4d63-b05e-ddb7b2aa5680@acm.org>
 <SA6PR08MB101635BB17A5B1B2B13363344DB4A2@SA6PR08MB10163.namprd08.prod.outlook.com>
 <38872318-f2dc-4af6-b64c-10bb107e8015@acm.org>
In-Reply-To: <38872318-f2dc-4af6-b64c-10bb107e8015@acm.org>
Accept-Language: en-US, en-150
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_ActionId=a3b66b34-bd79-4e5b-934d-5b9981ec18c7;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_ContentBits=0;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_Enabled=true;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_Method=Privileged;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_Name=Public;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_SetDate=2024-10-28T20:12:24Z;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_SiteId=f38a5ecd-2813-4862-b11b-ac1d563c806f;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=micron.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA6PR08MB10163:EE_|BN0PR08MB7421:EE_
x-ms-office365-filtering-correlation-id: 4a8dc411-4562-4072-75b1-08dcf78d94d9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZWtLZEd0WDR1NWZ6ZUpTa3FoSENaR1JoVEhhbm1KaUU3a2Fvb3QvSzJ6ckNJ?=
 =?utf-8?B?Y3BuUk9mb3IzYmtCUEV1OFg3OTJGcUY5ZlEyb3d2QmRNQXZpTlBpMytPWlJo?=
 =?utf-8?B?OHJwVlZFaDFHWmpkcXFrNWdENDRVUFpseVlhQndWQ1hhQUtOYm40QzdnNEpt?=
 =?utf-8?B?ZGFvd1J0bE5xOVFVVUkzKzEzblNaaEUwRkNoYi9ncFZsWXVYbStEanI3SGJw?=
 =?utf-8?B?QVBtQWl5dFpiWDEyYkNiT1pJaU5JZzFoYWY2cEd0OFR3YnIrTGloZ0ZLeHpk?=
 =?utf-8?B?cVBHaE1MMXhpVmJ3VWV0RHF5cFZ4RWN5emNTTFFuUG9ZbDdCM1c1ajdzcXZ5?=
 =?utf-8?B?TXoxLzd4cFRMZWxOQUt0QzNWVzBhaUxyMktJeG8vTnV3RmVaUUo5dmU5TThN?=
 =?utf-8?B?ZlI0VEVQMkZ5NkhSQ01qZGpsQXoxRVlLMW43SUIva2gzNWVvR29RQjNqOXFL?=
 =?utf-8?B?OEZDNTdZd0M1RlBBeTl3RVVsU0hUVzlKRzRnbGF2eGVhSml5SnRjb205SGlB?=
 =?utf-8?B?dkE5SkkrMEFBd3BwWnFzMlo1ZkNXa2dNaGFodkQ2V3Buemk1K0R2UlZBbjgz?=
 =?utf-8?B?OU51dkJxR1ljMHdRM2pWclFMZnlMRGhCVm9iS3FQZVBlcG15b1labjd4YXMr?=
 =?utf-8?B?a241MmFwbzlsU3VnNGdXRWYvRUZhRitZV1JYRnNhdnhFemRUR25CYzdCUkJK?=
 =?utf-8?B?UzJHM1N4YjZYZERsd2c5TmRDSC9RVXFQU0hvNFd6S3ZPQnpVVU9KMlNxTlda?=
 =?utf-8?B?NzUzNjNIT1l1ZHZLclovcUNKNFc5NzVQNFVZck9Xd3MyVm5YSlZYUFdjWjZo?=
 =?utf-8?B?MzNaaU90SDRQU1pIMzltQVFzNTBzaDRRZ25NTEsrVml5c2paa2ZJSUlaelhl?=
 =?utf-8?B?L1NrcUIxMU13UEFuMVdtVjJIYWRMQTZoTGQxQVNHdytlYXBUVkl5c0RGVXVn?=
 =?utf-8?B?NkgyZ1hZZHhaNkZSR3pMcGt1MUc2cnk4ZnhZcExNbXY3ZllsVVkwZGkvWjd5?=
 =?utf-8?B?cUVOYmxERkhOWHhJVm1qeUVubjA4ZzlzT3ZOT3dOVUhjSmRrMHpnOFJ2YTRt?=
 =?utf-8?B?cHVESk1HeERtUkVBcUFZeW1CTHIrNUdlQjBpcEFUNjc5cDh3Y0VwUGJZbUtm?=
 =?utf-8?B?QVhIVTVURWYvck8xZmhmdjV5WWNKOWxGck9FdGtYOTlQRlgyWFpubkd0VkxS?=
 =?utf-8?B?MDBGRmZxVXZLVW1mUUJtT05TTDJjeUNKK05qVjZTbHdKNkdYbEpNT0hpTlFL?=
 =?utf-8?B?L0g4cU0wdzJFVzdDTlRMbEwvclRuWkFxT1l4c0lzZDNxQ1g4c2twbUZlNFRJ?=
 =?utf-8?B?Wks0UUpoNS84aTVYRkljQjlraUJZS0RuZ25MNWVaUk9yM1ZsYmZ1TkFEVnRr?=
 =?utf-8?B?T29FSkVuTEVwRmtvTDE4bDZaRGpsVXppRWZzYkhVekNZOGZlTnFKbjZIam5i?=
 =?utf-8?B?Ri9qaFczc0VqQTJpL1orakRlQmlYTTJJN1R6RDlsdWpJc25WcWtwVWtvOXpy?=
 =?utf-8?B?QW81VTRtS00zeksyYVZnbXJES1VnUDhFd1J3U0NraTBCZHA0Q2ZpR2kyZUNW?=
 =?utf-8?B?MU9lelZtbHB0bmh6bUp6WUE3cldQbDQ5azZYdm5sMDlBTnQvMXpWaUw3YlhM?=
 =?utf-8?B?M0ZWVmJvZmd0eTI4dTNzMzdsa09ndXBYeFdBQlFxRFRHdUhEb00yMzVqbEJZ?=
 =?utf-8?B?bmdsb05rUTBiWElMNzE5K2dSa3lxbU00SjBSMFZWRjdTeGxNRDdoNlJyaG5r?=
 =?utf-8?B?NmZzTVlFTDZEamxZT3dDZGZuS0pzSGtBb093VEliMlRUTis4SkJ2QTNPNmZl?=
 =?utf-8?Q?mVqHajUxQ7vmNtGNmzYa0slmeok8owbsGxMyQ=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR08MB10163.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WGNLTVBmbWRIQjRyY0dTeW9ueWFLOGpVVE4xNnJGaUI3K1FNekh5SGY1SmdK?=
 =?utf-8?B?eHdvWU1HVjV1TWtCN2JvN0Q5ZnFpZlFENG1DbWpQdnlGQkdPVldFTHNkdCs3?=
 =?utf-8?B?M0ZoSW1NcXNtZUY1QVNiZWErK1BCMzlkQ0lzTVkvNi96WXFYMW14R05WT2dK?=
 =?utf-8?B?ais0UHE2dytUZnh2V2FIMEp6Q2NsSno2WEVYcnJEU0x2NVdGN3FXZ0E0Wmp0?=
 =?utf-8?B?czc5cUtRN211bGNPdWU3YlB6TFVsc3BUZW55ek1IeElNVGwvUUxVMGQ1WVky?=
 =?utf-8?B?d1JWTlJYZCtVVE9WbFllbi9rQ3V2Rnc2SDBzWVhDVDZOblgxQS8yZTU0Um0y?=
 =?utf-8?B?OVRyenVBbnFSYk5PRTcwME1vbVZEc2RsU1owMEMrU0NXN2ZRWGxVTDA1UXBE?=
 =?utf-8?B?S09PeWY1eExBdEZHSW9BclM1bWJWSlFONCtKR0RvU2VJYXVVbHlxdGczdmRv?=
 =?utf-8?B?emE3emNITnRCdnV0d2dQOEhaV3VmSmRnaDJmS1NsM3BMZ2lmTWlaZ3BmUnlq?=
 =?utf-8?B?c3A4TnZkYWdpVnVJMk5tVDZVcTdhQVJlQ3FZdWF5RlFUOFJPaGFRQzhMcHQr?=
 =?utf-8?B?TnZ5OXpvYVBMZmF0QTliYi9XS3FEc3dzWm4zdXBvSXRrVGd2VnI1RU9BT2pZ?=
 =?utf-8?B?cDRMNjZyZGlBNUd2NHU0Ymp1Z2hWQlV2dXV1VVBMTWhpNjhNY0xNVjkraG0z?=
 =?utf-8?B?NTBORkdxNEp5Q0M3dy96MHVLS05iRFJxTVA3T2p6NzRpWFIyQ25GdkpqQjEv?=
 =?utf-8?B?TTR1RTIxT3Z1UDdsNlUvT2Ewb2RBeXA4OFgzcW5hZ05hckdNdVpIdU5ZaFRC?=
 =?utf-8?B?Y3FxU05EUFpycVNFNXpyZ2J6T0dFeXByMHFpakVwTTZWalFNSDc0RDVhWG96?=
 =?utf-8?B?Myt6Z0h1RDhiRXVjNi9vZUIxZkVRblVGNzBwQkRVUU1haW1jeXdUQ2swZkxJ?=
 =?utf-8?B?S0FiNHZnSEd0ejNNelJwTWdQQjVFQlpNVGQ3RkNsREgyMUY3eTRZZy9uc1VY?=
 =?utf-8?B?c0toZmtENmZ3dHY1em9UVi9UZWZHOVZOaHNyZ3pRMWFkNFVTb1hPVU5MYUI1?=
 =?utf-8?B?ZFhvVmNGYnh1YThNMkk5NW4xL3FXR2tXVUJackZ6Yi9iUlYxSFFPU3R4UG84?=
 =?utf-8?B?VzAwdVZDSkE2dUtjejE3eEtPQ2NlZlM5TG0yRHUxL1kzYjd0TmxwM0w4bnJq?=
 =?utf-8?B?d1BtZTl2TEJYejVVY2tUTkIrQkpSdDllR2huZCt1Q2tZRGhxOTRtaVpuL0ZL?=
 =?utf-8?B?eDlSMHRkbm9KazRlNlBoQlArSnpsLzRSeXNGc1FoSUtqWng1WDJ0czg1dkd2?=
 =?utf-8?B?YktaR29Lc1FSbnRCN2JKTHQ5VW9IUUo5WHlmM1hyUE55cW10MEdCZnZWV0Zn?=
 =?utf-8?B?RS84eTV1cmFkSjlQeVlPREtYVkJiRW1CVDFvOC9wUU5xQnN3c3pFOEpIZTQ5?=
 =?utf-8?B?T0tGZEZaYnErU0VkSTJzTmdJb2ZGczFJanRmamJTY0t6WEg3VjFyZUpxeFhp?=
 =?utf-8?B?NnRONHJqYWdXc2RuVjJWcnVZcXJ1cDhZRStpUFRpRnhxOWxmVUlUVkdRTVFW?=
 =?utf-8?B?ak1ld01laGtMWmhhQXhZdG1paGxvTUFiV3BreFZSS1htVXgyV1lnVGowU2xw?=
 =?utf-8?B?U2R3N3FQRFYza1pvZFNMRzRNSzlFampnWFZ6SDMwUEt4MnZXM0NQbUlxTzlH?=
 =?utf-8?B?S1pvRmpMM0dNekZKVytnbzlpNldVUUp4c0dKSStjU3BCUldrS1h0TlFzbm5K?=
 =?utf-8?B?d2tDNGxUc1p1a3IyNVdXTm5Ra05xeDhSNlVsTVplVERBV1QyWmY1RWtvY3pU?=
 =?utf-8?B?a01jem0wUm42UENzZFk3c29EOW5IbjlwRDM0SnNuOWJLRHg1LzFDcnVrbWhr?=
 =?utf-8?B?U1orQWo4Z3ZVOHJmMTA5MnEzOVN1b1JBSXFkcCtkbC9yRTdTWXVKa3B6cWlV?=
 =?utf-8?B?ZDkxdmU5cG5MUnh3OGVqcjUwNVd2ODNNZ3FjTktMZFdabjhtOUZWOFhla2dn?=
 =?utf-8?B?T0g2bVVqNXB0K20zRkxlSFlXKzV2ZnAwL2NzNkFWdzVFTkdoczRqV2RwOUZt?=
 =?utf-8?B?QUhXVFVYejFneGNISWQ4dWdSTDZpTTMvdUtScm5USllzdzNsYVRFZDVJcWZU?=
 =?utf-8?Q?VbO60LpQrFOTORNH7RTqfgX8Z?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA6PR08MB10163.namprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a8dc411-4562-4072-75b1-08dcf78d94d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2024 20:17:43.8987
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /YrzyZoJosg3KgBJU+q3TR3xLJHcA24QKNvWVcxZbQT4nSav48izX8UhiPUlyBmKJy3ESBSjhw1fFuvuYcr7AQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR08MB7421

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCYXJ0IFZhbiBBc3NjaGUgPGJ2
YW5hc3NjaGVAYWNtLm9yZz4NCj4gU2VudDogTW9udGFnLCAyOC4gT2t0b2JlciAyMDI0IDIxOjEw
DQo+IFRvOiBCZWFuIEh1byA8YmVhbmh1b0BtaWNyb24uY29tPjsgQmVhbiBIdW8gPGh1b2JlYW5A
Z21haWwuY29tPjsNCj4gSHVhbiBUYW5nIDx0YW5naHVhbkB2aXZvLmNvbT47IGxpbnV4LXNjc2lA
dmdlci5rZXJuZWwub3JnDQo+IENjOiBvcGVuc291cmNlLmtlcm5lbEB2aXZvLmNvbQ0KPiBTdWJq
ZWN0OiBSZTogW0VYVF0gUmU6IFtQQVRDSCB2Ml0gdWZzOiBjb3JlOiBBZGQgV0IgYnVmZmVyIHJl
c2l6ZSBzdXBwb3J0DQo+IA0KPiBDQVVUSU9OOiBFWFRFUk5BTCBFTUFJTC4gRG8gbm90IGNsaWNr
IGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzDQo+IHlvdSByZWNvZ25pemUgdGhlIHNl
bmRlciBhbmQgd2VyZSBleHBlY3RpbmcgdGhpcyBtZXNzYWdlLg0KPiANCj4gDQo+IE9uIDEwLzI4
LzI0IDE6MDQgUE0sIEJlYW4gSHVvIHdyb3RlOg0KPiA+IEV2ZW4gdGhvdWdoIEkgZG9uJ3QgdGhp
bmsgaXQncyBuZWNlc3NhcnkgdG8gZW5hYmxlIGEgU3lzZnMgbm9kZSBlbnRyeQ0KPiA+IGZvciB0
aGlzIGNvbmZpZ3VyYXRpb24uDQo+IA0KPiBSaWdodCwgYSBtb3RpdmF0aW9uIG9mIHdoeSB0aGlz
IGZ1bmN0aW9uYWxpdHkgc2hvdWxkIGJlIGF2YWlsYWJsZSBpbiBzeXNmcyBpcw0KPiBtaXNzaW5n
LiBBbiBleHBsYW5hdGlvbiBzaG91bGQgYmUgYWRkZWQgaW4gdGhlIHBhdGNoIGRlc2NyaXB0aW9u
Lg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0KSSB3b3VsZCBsaWtlIHRvIHNheSB0aGlz
IGFjdHVhbGx5OiBjb21taXR0ZWUgYXBwcm92YWwgb2YgYSBiYWxsb3QgZG9lcyBub3QgZ2l2ZSBh
IGNvbXBhbnkgb3IgaW5kaXZpZHVhbCB0aGUgYWJpbGl0eSB0byBkaXNjbG9zZSB0aGUNCmZlYXR1
cmUgb3V0c2lkZSBvZiBKRURFQy4NCg0KVW5sZXNzIEpFREVDIGhhcyBwdWJsaXNoZWQgZGV0YWls
cyByZWxhdGluZyB0byBhIHBhcnRpY3VsYXIgZmVhdHVyZSBpbiBhIG5vdC15ZXQtYm9hcmQtYXBw
cm92ZWQgc3RhbmRhcmQsIHRoZXNlIGRldGFpbHMgc2hvdWxkIGJlDQpjb25zaWRlcmVkIHByb3By
aWV0YXJ5IHRvIEpFREVDIG1lbWJlcnMgYW5kIG5vdCByZXZlYWxlZCBvdXRzaWRlIG9mIEpFREVD
IHVudGlsIEpFREVDIGJvYXJkIGFwcHJvdmFsIGhhcyBvY2N1cnJlZC4gIEZvciBVRlMgNC4xLA0K
d2hpY2ggd2lsbCBpbmNsdWRlIHRoZSBXQiByZXNpemUgZmVhdHVyZS4gSGFzIG5vdCBvZmZpY2lh
bGx5IHB1Ymxpc2hlZCB5ZXQuICBCZWZvcmUgdGhhdCwgdGhlcmUgaXMgbm8gcHVibGljIGluZm9y
bWF0aW9uIHRvIHJlbGVhc2UgdG8NCnRoZSBjb21tdW5pdHkuICANCg0KDQpLaW5kIHJlZ2FyZHMs
DQpCZWFuDQoNCg==
