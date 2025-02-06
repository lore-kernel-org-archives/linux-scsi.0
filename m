Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071.outbound.protection.outlook.com [40.107.223.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7E1481DD;
	Thu,  6 Feb 2025 06:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738821661; cv=fail; b=G/FmAZ1FeBQU6sGhqe6upgPel08g43RpHc86M08wutlTegHGURzrhyhDexNs0v7idaIGeM2/SRfEVdVmMNBUEnK7rxEQAOOe4avGgP78p+ls1FGFlV4V6ibY0pf2w2jrrRxWZqaXFBKAEjB2AyMrdWpP+ZYJ3fUcgGahE///4vk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738821661; c=relaxed/simple;
	bh=5A89cr3rL4lI6QGFT4IAaffzy00m2/QvB5a+3ZSHfD8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=n4A7TSekJN9k/MGsuxSanUcxAt6nkoNCGoHu6A0OYZ8aEX1uG+IW8l4oe4I7izdY1h57Vqy3Ru+GS/rM+s1cUZOtb/fFvuPkF/3gMq2/LUxzlFY3t6azSXNKky923yo+ZVK5q0AE3ex5vhE7sSP7NB1GyrL0s008MH5uC/AWPKo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=azgjZ6Lp; arc=fail smtp.client-ip=40.107.223.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="azgjZ6Lp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bQK0m9K99LyiQ0zYdHmaf4/2xivyfi9+8Yh1+tcPE0yZQKeSW7J7idLLdm8SG5JsxtMFsyMa0kaAP5Qs+LeXH5tGyrXYx3i8xFxdVNCAvRgUK2biYzXKymUQsq7+eE5nl6sfng5IOVJq5Ykpg33z2mro9fEY3xSqe0oVju+l5wq7Eolc7WALGBGh3wDA4w13MDMslNdpj19Jgd/jhImo75EdwGezSfve327bxbLUnAQO1/SJPvOzJ84DLOYJM2CsLt2y1a7J/uyoXZ02iFFS+nmlDf2w5tqmBZP7MOHCVyC4YGSDQyGk/UYLrr1TX/DJYGN5rFV1JQDcy6YTQyOIKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5A89cr3rL4lI6QGFT4IAaffzy00m2/QvB5a+3ZSHfD8=;
 b=Z5BQq/jpnGnwhudJqKidxVluYN9AgeqCUooWjIUO/5HjkQGL4PZgiwaT1vRunxvSw/tV23nh/lOfH4EK43edVJhY6P9H1w+Wr7Ei49TUzy5Bnrue/H/0Yu/Ae8VeowGXOuJ/nN904TZISfvyIxa8eHd9Rq6L1Y0WBPFpd5b3m5UuH1/SdAzqnBIawnYy6USacubdDrSw1wNxB52L+jpyJ6IWfKtxiJ6U0ASR90h1wqiI6Lvbr5TsYnIajPv7exnnTIAW3mkdo5nErEE7eg7lSpp2g5EBhusIPWtKiYw3+MpgD7he6lekYCqwpDyU0GcltDSowydEVr/YK1NyJZ8xFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5A89cr3rL4lI6QGFT4IAaffzy00m2/QvB5a+3ZSHfD8=;
 b=azgjZ6Lp2hhVvzPFDy7I+lt7mpyeT0HoiB86U+CxBEiclDtzpfwgybSmC0QJ651/MvpgjAoUYj7AXFrfoIiKMgvQTVUihvpjuEP35vDcFedWtUIrq+7pQfxqn5szJlNdgpAPx3aBdgSidOoBkX7g9LtXJ7xWiQvSRXkzsde+RIjqiOzRTc7BXm3FMmWmGKFhjZV9LMpOKCtT7wPM8pxZeueynxhEm7+mh9ef2hmwJyPg80IaUDYLWjJ44QDJtPN8hrwThHLt8HcFBbZk3Fe/p9ZNU9e9fqxL8vo5Xknk/ph6YFoQcevNZJgof3FeWeV0qCR8l4FYU6KWjR/+jV+FQw==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by SA3PR12MB7805.namprd12.prod.outlook.com (2603:10b6:806:319::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.11; Thu, 6 Feb
 2025 06:00:56 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.8398.021; Thu, 6 Feb 2025
 06:00:56 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Alan Adamson <alan.adamson@oracle.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"shinichiro.kawasaki@wdc.com" <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v3 blktests 1/2] scsi/009: add atomic write tests
Thread-Topic: [PATCH v3 blktests 1/2] scsi/009: add atomic write tests
Thread-Index: AQHbeCIWwkYc9aMlY0OgbxcOc88OiLM5yLOA
Date: Thu, 6 Feb 2025 06:00:56 +0000
Message-ID: <521729f1-3999-4527-aad7-0872970aa052@nvidia.com>
References: <20250205231100.391005-1-alan.adamson@oracle.com>
 <20250205231100.391005-2-alan.adamson@oracle.com>
In-Reply-To: <20250205231100.391005-2-alan.adamson@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|SA3PR12MB7805:EE_
x-ms-office365-filtering-correlation-id: b4bba059-b3c5-471b-c18d-08dd46739f1b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?MzFWUlVwcHpzQm9mT1dKM1dIZWYyck96T212aVp6UXVIbHE2emJWUDVJRDYy?=
 =?utf-8?B?ZEtvUHBvNDdEdlFNTTJiR1FNa2w4SEV3T0FoWUdjai91NUJJNDE5MkhRTnE5?=
 =?utf-8?B?amVlYnMzdFBzc0VZQ0thdXZoOEJZWlcrbldzME9KSkdzY01nR1BPN0E2VmNJ?=
 =?utf-8?B?bVpTU3VVSERDdXJpNS9saFNuUGtiSS9NcWdvVXFzaGpvVDFrM3lyS1RZS0lT?=
 =?utf-8?B?UUhQcWlJOE4xaUpoZ0w5US9IWWU2SnFHRFFHcXErQWxlMzF5ZUVLYko5UHlM?=
 =?utf-8?B?YjcyQ3FEZzJXdDlyT1dHdE1qa0k1QXIwQ0ZjQnhGanlaV1JRQ0wwVkt4S3h6?=
 =?utf-8?B?Nk4xSUhCZ1IxZnNZcnVDbGxoaHI1UnpIcHZBLzBGU21jOEM1RTFyUWIxak5z?=
 =?utf-8?B?ZjZSYlBVMi9NbUpkaTU1dHQ1YWVNUFFjQk92K2d4dEdxdW5XUTdoa0s5TzM4?=
 =?utf-8?B?b1FFWEg0Sk1oSjFQMVZNejFCa2x5SThsV2FHcVdlVmNzdUFBckh5c0xHaUFp?=
 =?utf-8?B?MmhxK2U1QTJpOUtPMzRBVjl3dXBJbklwT0lkZWFZaE1mSlB4dElUcGRpUHZm?=
 =?utf-8?B?c05TTUF6OG5XRWxuQnI5S0tadTNTdVBhQnJHUERBcUZRYVBGQ25YSEc4OExl?=
 =?utf-8?B?MmhKcjNzTVBKRlE2R1JiWUR0bmw1bHVvQUtzbGs0Z0JwS25hQVBhZ0NVb1lE?=
 =?utf-8?B?RG40QjhlcDZGd2lGTTV6U2llZkdVQ2hkTWdCNG1GVWN6dnBKcTlkTVpZM0NT?=
 =?utf-8?B?NktKMFJoaEhuWHpMNlNCRkN3MElUQ04wRWRSazRwNitaQ09tY0REVW1yUnd0?=
 =?utf-8?B?WnlwSUl3TzFuWG9CYlZQeXQwTzRtYmpuMlFwdXd2S0FrKzl0eDRITEhVRmx4?=
 =?utf-8?B?UnpVdVcrUHRhMWVFWVpzdktoVE1uVDQ0VmhwYlFTNFoycEhRczh6WE9YcWJk?=
 =?utf-8?B?RGJJSERLTmdhajU4eExYTmZBOWQ4RngwNERVSkhrWUo4TkJ1dWJXem4yUi85?=
 =?utf-8?B?YmJ5Umt4RUFuRk9USERLQ1h1MFdxRkFVazJJcVFabTBuekVOajdXcVBVWEYw?=
 =?utf-8?B?VytYWlpPbnFFVGZNQmQ1djBrd1V1TGdsVTJpV3NTZ1l1aE95R3hxWlNiRHRJ?=
 =?utf-8?B?a3gyd2N5U3ppdDFla2tNMm50YU9rOXh2OHpTU0tOYWpoczhPWVpKaHcxbEVN?=
 =?utf-8?B?RkErY1JoTXJXYzlyNVQybDB4bnN1aUpTUG5MYVlqV1cxT3F4MWhtYXBaMy9u?=
 =?utf-8?B?WGE1RzVtRk9qa1luOUFCQ1BQdnJ1RjlwVldXTm14RVZmank0RFozbmNFMjVW?=
 =?utf-8?B?RTB0L1ZKQXk1S0pRdGdyVS8vTEhMQTdxekJYc3RjOW8yM3Y4Wlh6L0JrZlpI?=
 =?utf-8?B?NGR3YXBjTFVwV1dwcWxNaHhRYiswV2kvQitEZ3d2eXJwZjdqK1BhcFlwR1Vp?=
 =?utf-8?B?TUxSRWhvMjRXRjc4bWlxenhDOElFMUhDNmVtWm1neUxuNmRuZEN1N3liWnc4?=
 =?utf-8?B?ZXFtbEYweXdmVVVnMGUzMHdDRThjcGFHU3cyN0VGWkZCcDNXWXJTNWlMNnRM?=
 =?utf-8?B?SzdYY0JiNVcvdWhsYWRCV0QwVUF1RDY2RXNSSTVkK3BtNUZlQWVoWUZMaDlq?=
 =?utf-8?B?MU90YnpIMXFQcDFObjFjWWZzaTlWc3hhcWRXRE1EQ2lFaXZjL3FuN2llV3NF?=
 =?utf-8?B?NVBFbExFRnA3TytQcXFwbUhtbkg1SnVYamhucHQ1Y1p6eEFoVHErR3Z0TUZ0?=
 =?utf-8?B?QnAzNGk4SEtyNzJtT29DV3NrT2RUbThVRHJvY2xYRUdkWC80b3RRVkk4VVJN?=
 =?utf-8?B?anBJRSszYytjZHMyYWZ1T0dWWSs0ekFnaG15UXplTGpmM29CTm1aWkV4cHpa?=
 =?utf-8?B?MVlSOTRheGVQQ3dkb0RmWXRWUzVzRmxDOUJSaGFyMFkzUzBMaVpjQ0RQWEEx?=
 =?utf-8?Q?bsx0NY3jtoVELDs/FHmtJFonYfy8GZ2m?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?enRBVDlsRVg4YSswN3cyS0hmMEVjRmZqbWNVeGhkVWxweTV3RTJhNmhEMkFj?=
 =?utf-8?B?Y28rMFBqUW9TaGtkM1JMTVRvWHNDQU1oZmYvNWQ3cjRobUpTUHJaZnFoaU1a?=
 =?utf-8?B?Qm9mb29xYm4xZWZmMEY0bURqWENnWmd4aU5xSTlPbTZ2VkQvQnRFQUtNdW5y?=
 =?utf-8?B?ZEd5VlZpb3V3ZnUzdWJOandRZDZDU3pYUW9MbTNLZ2FkUnNVVk9xaUl5SVNr?=
 =?utf-8?B?RE5BVmdFejAveVZ3VDYwdEhBZjNiZjdHcGVKaC93MDZvWkVyZmI1bGZsaEhH?=
 =?utf-8?B?K2RENGl1WUI4d3luRkhFWWpZbCszc1NIOUhod04xOTIrOHNhb0JhMHdwS3Fk?=
 =?utf-8?B?cjRTenRiTWN0THAwTFVxMW1IRjVCaGw5ZFpPanZZaVpFRllJY2RBN3dNKzVw?=
 =?utf-8?B?RE1ObU1HM25MRXVkSFBta0Eyb3oxcGlEMy9tUmtHSUY1ZHQ4NXUzcVVHbyt6?=
 =?utf-8?B?K1dVN2R2K3YxTWVWTlUwb2tRWjJlMW9SbDNnSUNqbUZ0ZkdWZjZFZjdjVXBm?=
 =?utf-8?B?VXVLNVRCY3I1VFpGQW5zSEpacC9TWUVzajgyMS9kYW01amZsQnpnNjFMaDR1?=
 =?utf-8?B?azNCcjlKN0FUT2lIYUxDOU1WNTA4MWpnM2Z4VlgwUDdnYkxXV3pybElpQjNw?=
 =?utf-8?B?KzFEMTkwMzhUN0lxQUVxRzVaTWRiSGo3WU50Yi9qaFVQRjM2eGpNY0d1WHFl?=
 =?utf-8?B?SDM3SHNtMVZSY0t2b0k3clFyVlF4M1NpM0llRmQ0ZXFoQzZ4QlgwNDV6VytS?=
 =?utf-8?B?NGNzenBOV3o2QmhkTzZIbSt4TXVLQWQ2aVptdkhCQlROTEc3cXZVSkFRMWtQ?=
 =?utf-8?B?TktxNDY3M2VpSHFBMDNLdFNKM1A5eVZON0hidm5qWjZBRTlJNkcyaGtJdEFW?=
 =?utf-8?B?YUVYNDZPUE1VckoyOUZiQmFqa040akUwV0V6RWdleVZIV3A3S2RZY3o2dG5C?=
 =?utf-8?B?Q1NaQ05ERXlOeEk3M2xQTWZCSHQ2YW96NE9GWTFpYnN1UTVuU0VtWjRBbU1h?=
 =?utf-8?B?VnJkTWlpeUx3bzR6bERhTTlsdFIxOUpjVFJLYzJjSWFJWXpsSGpQMXl6RTdy?=
 =?utf-8?B?WEdLV2NESjRScTU1R0ZEdjhzK3hkSEVXdElCcHVqS0llSWxnNFZibnVSTnc2?=
 =?utf-8?B?WHV3RnhGS1cvbGl0dUhqQmhvNkpuQ0o2eDdNK28xc01DMGJQakZCV2I2S2xO?=
 =?utf-8?B?d3E0dVR0d2tKUGp2aUxndjRiczhiejd1bnZrMFdEYzJsSDU0c1dnTThYdmtp?=
 =?utf-8?B?S0FzZ0lMVWpaaTFIV3BTd2xJSldLT2NkbnBFdjlZeEJqVHhya0VZdnpkWlAz?=
 =?utf-8?B?WXVVSkRtWjdiMW5veGhKT3RCOUgwM01ybmtCK1JhNGRTMDBJTm9iOUFzaXlS?=
 =?utf-8?B?aEs4QmpsWS9hSEFZa09sT0NYZC9VWmZMSWxGUkZSNVNQb01LMVcrMkE2Q1Ri?=
 =?utf-8?B?bEwwRm1NL2JUaHU3Mzk1T0x5UWZWekRWZzVTM2dxQ0RqZ3JjMStubzFxTTJG?=
 =?utf-8?B?TnpjOTlndHJieXRaaHhYbVpScnE4aFp0NVRPSEhBaUhCakViMnY5OVJvS1Nn?=
 =?utf-8?B?NGk5QWRUTEdPWWc0VVBRZVlURG1ZSFNDSmNSQUVsZ3FmKzdUN2FjZG5DcWxv?=
 =?utf-8?B?b3g4aUJNYWpzNWI0c0VnbHM1Qm84MDdNZlNTWHlwUG1tODdVRDhMVUNza2xG?=
 =?utf-8?B?dHVOQ0dFQmg5V1N3VHpLMEdvTWx1bXBmVnliNDVRZ2pKRkZ5bjJjckxHRDk2?=
 =?utf-8?B?NXFSRFplS1o1Wk9iUGN0eGd4MnlLM1pSaWRPd2FYNERFdzhSMWVCTEpJU3A2?=
 =?utf-8?B?cU9ZOEFoQzg5UlQ3VnBjY083Y2hHR2N2N2YwWFJVeSs2aDhWOWJGQ3plNzRD?=
 =?utf-8?B?SC85alBJN0Q2eTlaY0JHV1BOVEp3ZGxSeHhEcytnWVpSdStjZ1ZoZWVKNVRE?=
 =?utf-8?B?RFM5NmlBempRMW1aMmoxMjZVWldwWVBEYkpMalFZZUpyOGZmaXFhQnM3L20z?=
 =?utf-8?B?cStVeloweDF1Z2thYXE5OE5FQ0M2UFpwL2Y4ZWdZZXNIdXRmWjdjSURpUFBC?=
 =?utf-8?B?WDh4N3ZXMDhVWnhUUS9OWVJKTlhJVzUvdThnVTNvNHAranl0c2s1QmltN1Qx?=
 =?utf-8?B?L0xWQTFNcThvcnNvc1lSdlRFTlNQYUV5cjliUmJyZjFidXYra0REb3VHdmI3?=
 =?utf-8?Q?9I2QT0cVOs3OsvSeBt/2FVOrqLn/ZrygGSptFzJjCUtx?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CACEABD747383F4DBF80104CA63C4EEA@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4bba059-b3c5-471b-c18d-08dd46739f1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2025 06:00:56.0489
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lGKJCjV13+BoTrQ5edrJcJuhztSurPHt1Soy7TbcxdpZfWAPK3lRxyvz9diF9FVNz5r/LgGY2JSTm3bwu9EY1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7805

T24gMi81LzI1IDE1OjEwLCBBbGFuIEFkYW1zb24gd3JvdGU6DQo+IFRlc3RzIGJhc2ljIGF0b21p
YyB3cml0ZSBmdW5jdGlvbmFsaXR5LiBJZiBubyBzY3NpIHRlc3QgZGV2aWNlIGlzIHByb3ZpZGVk
LA0KPiBhIHNjc2lfZGVidWcgZGV2aWNlIHdpbGwgYmUgdXNlZC4gVGVzdGluZyBhcmVhcyBpbmNs
dWRlOg0KPg0KPiAtIFZlcmlmeSBzeXNmcyBhdG9taWMgd3JpdGUgYXR0cmlidXRlcyBhcmUgY29u
c2lzdGVudCB3aXRoDQo+ICAgIGF0b21pYyB3cml0ZSBhdHRyaWJ1dGVzIGFkdmVydGlzZWQgYnkg
c2NzaV9kZWJ1Zy4NCj4gLSBWZXJpZnkgdGhlIGF0b21pYyB3cml0ZSBwYXJhbXRlcnMgb2Ygc3Rh
dHggYXJlIGNvcnJlY3QgdXNpbmcNCj4gICAgeGZzX2lvLg0KPiAtIFBlcmZvcm0gYSBwd3JpdGV2
MigpICh3aXRoIGFuZCB3aXRob3V0IFJXRl9BVE9NSUMgZmxhZykgdXNpbmcNCj4gICAgeGZzX2lv
Og0KPiAgICAgIC0gbWF4aW11bSBieXRlIHNpemUgKGF0b21pY193cml0ZV91bml0X21heF9ieXRl
cykNCj4gICAgICAtIG1pbmltdW0gYnl0ZSBzaXplIChhdG9taWNfd3JpdGVfdW5pdF9taW5fYnl0
ZXMpDQo+ICAgICAgLSBhIHdyaXRlIGxhcmdlciB0aGFuIGF0b21pY193cml0ZV91bml0X21heF9i
eXRlcw0KPiAgICAgIC0gYSB3cml0ZSBzbWFsbGVyIHRoYW4gYXRvbWljX3dyaXRlX3VuaXRfbWlu
X2J5dGVzDQo+DQo+IFNpZ25lZC1vZmYtYnk6IEFsYW4gQWRhbXNvbjxhbGFuLmFkYW1zb25Ab3Jh
Y2xlLmNvbT4NCg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJu
aSA8a2NoQG52aWRpYS5jb20+DQoNCi1jaw0KDQoNCg==
