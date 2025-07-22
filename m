Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9177D2BEFE3
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 09:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753176491; cv=fail; b=pOBWTCIa6PScJH93upcOnMUu9vDoyTH7zp4YsCJf8J0hWhcY/PngsJD4pGks1Toe5S6Z8yQ603x9zTjOE/4/Ozz3gs0MudqLT6Ltp8zfs4kKXh0hMY3nspcy3z/KXLetLJcb5ZJLBV+SfOxto1PmuS9ci09uGBa6FRl5h0YbjTw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753176491; c=relaxed/simple;
	bh=MZMUFQRIqZX532qi8OTk+aMnxEIlJ90464fwIRQTDtE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h+If/TYSsyNxSeHuHN96AxbZ9BjNX3dZxfpQOcaPLeMCqMCZkpJrmrJQeIJu/glueM8Idl8D0lBbvkeC1iAdXNECc/oSG2w5T/FJZ9s2SVBqcladjAg2nTzrOlti4HxuOZ+ISYCxdrJVdlt1mtMSeo0t3L5fVoAk34eJR0nJgSw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WYTzDATS; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WYTzDATS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753176490; x=1784712490;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MZMUFQRIqZX532qi8OTk+aMnxEIlJ90464fwIRQTDtE=;
  b=WYTzDATS/c64RRD/1hMhXKcMoZQArDfiyPLfCgK4+8wIsM66Ugv2zc/Z
   k7RIoAXSPW37PFHB2NTZpNeqUniaxWWu9RgWxGmivuuxwkG7vsTskNoXp
   Czf145vnXIauYWJtYzwMNiYJ8B2NA3RHJXmuh4uyomzrA6Xb39jyoM9eH
   D6HjgyC9UkzL4BW3d3DIEtCG3cVGNfyfiq45oL/bF1/0CfxUWDNinA9kX
   H4WNfA7QD7ykelBijkITXqRweWJ1fBP8W98EsSzOetrFUHYM3P9Onjsce
   KswcQh+yA4CLS3k++5UQfInPv8g3RkwHyEy2jmbxyNMs9xZ01FPOj+9GM
   w==;
X-CSE-ConnectionGUID: rdVDh+U4QvqR3OjBlmOLVQ==
X-CSE-MsgGUID: grNnnXB7S76qw5ojgbrvgA==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="55504563"
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="55504563"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 02:28:09 -0700
X-CSE-ConnectionGUID: jXeGkqQOQpKIN0UkN18t1A==
X-CSE-MsgGUID: 1StRtfahRw+1TMj/Pf/8Fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="164764811"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 02:28:08 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 22 Jul 2025 02:28:08 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 22 Jul 2025 02:28:08 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.47)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 22 Jul 2025 02:28:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZIzmkrdLRDDvavDo5YcDuSAIU2FZ35qw9SOoBUpMStQGXxBVdn53gfONCYBkYYzdLskD655+zffaeSTYKqHLKw8+UWh2lDYw9eFrSwo8nIisSTjNS1h7uNkgdQeVmzFk8XMOmj+tdwIQReXEJ+SOtuL4orcH2+AxG2OVmCjMnZIDaGaTj65grvfedhnT/lBNDq00AvQktP0TmeKAwbJw94CZXNE9SxULkecdXHTLcgArDdS3GaEjfTT23QPO3EeuhXxsM9gdzepn5048ECixPGUINik2HD2BIxdj6L+MB2UgjJkREQbn6t16VtycJPrA2mGA6NiffBuM4dWayUjrvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s3oWgzwFZKyxSIj01jLtfEIFjyGKRKrev5jAfPVHpcU=;
 b=RMQ4TvXO+txW1bCVck3cjRz1lCKoegtm5ZyE0dkz7Xduq/f1hz5wwy/HxDfipM67xHbAOzEs5SORX1aZkyHF8wvPvmULdpglSEo7HZSIoC/a86+xipFyWV43p+8j3WlxSdlnbdAVeWi2A/ENADdChh3GWUl/vcbpxEw49u0J5cjWr51oBRqOPN4yR7DTl8cPT7KM+GBglqPNlHlurL52UbKJNsCSK5AyrCIPoPd2QwLLHoJ+Fq1ZLYHUYhYQ4YlqZy7E5s6nLqT9QsYFS/ufjctfYUoL6qbWOoEWhpVFh7GacgzqL09F15h/WR4kdiN02JqROUyS0IewumjVbaDF1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by PH0PR11MB5927.namprd11.prod.outlook.com (2603:10b6:510:14e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.24; Tue, 22 Jul
 2025 09:27:22 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905%4]) with mapi id 15.20.8922.037; Tue, 22 Jul 2025
 09:27:22 +0000
Message-ID: <cefcc0cc-f7d0-4286-a2cb-c9d5b339d6a2@intel.com>
Date: Tue, 22 Jul 2025 12:27:18 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] scsi: ufs: ufs-pci: Fix hibernate state transition
 for Intel MTL-like host controllers
To: Bart Van Assche <bvanassche@acm.org>, Martin K Petersen
	<martin.petersen@oracle.com>
CC: James EJ Bottomley <James.Bottomley@HansenPartnership.com>, Avri Altman
	<avri.altman@sandisk.com>, Archana Patni <archana.patni@intel.com>,
	<linux-scsi@vger.kernel.org>
References: <20250703064322.46679-1-adrian.hunter@intel.com>
 <20250703064322.46679-2-adrian.hunter@intel.com>
 <4e28a401-6316-429f-b6b7-d682280190f1@acm.org>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <4e28a401-6316-429f-b6b7-d682280190f1@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0621.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:294::21) To IA1PR11MB7198.namprd11.prod.outlook.com
 (2603:10b6:208:419::15)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|PH0PR11MB5927:EE_
X-MS-Office365-Filtering-Correlation-Id: fe81bc4c-7eb8-484e-349d-08ddc901f642
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SnE3cGNhMEJoWW5OY2lXUDdocTJEWno3S1lkckRMYmN5VzFBendBbndNYVRB?=
 =?utf-8?B?Z1ZHMnFBQngxcnkwblVoUUh4U05YRGU2Y28zSUVmMjVoTEVSb2RacnNreTBk?=
 =?utf-8?B?RjkzUklVN05sRkNhdG1YaWtUVE5Jdi9LZ3YwVFRmYkRTaVAvT0E3a2MxaUhy?=
 =?utf-8?B?eTNjMkhNeWRvK1NmQlZ1NmQ4Wm9XOG1BUFRiU2N0NmpxSlJaUVo5M1RWK2cw?=
 =?utf-8?B?WFJ1dlEwaHpsYm9yd2tISThoWHliMjZ4b1dJbUdPWjl1a2h2bnhuY3BaTTZ4?=
 =?utf-8?B?MHpNdnhLUkQzVkJTRCtGd0pDWHErSTVjZW5GcENOYWY0ZkhwNUU1VzdxOERy?=
 =?utf-8?B?dmQxcWhQZ3dtdGdsNW56ZENTdHQ3U2F6eVZPSHdpSUxmelBRYjBrb3hoYjBB?=
 =?utf-8?B?VVFpaGN0UEpKWHpXbFh3ZXlNUFA3NzdnY0pRckZmYzlDdjNicUI3Z1NpU3ht?=
 =?utf-8?B?TTdMMnFWVWEwRmdsZU1lTllZSnZxWTYwcENLYVdHQlIxZ3orUFVOeHdySkpJ?=
 =?utf-8?B?aTI2bHFQSmFMRHpJQ1M2UXZTRXJHa05Xdy9KN2tKQktJM2dUNDk0YzVuaGYr?=
 =?utf-8?B?NEtZeUgrMzVnVXRGaVZZVWlGUGNTSXFPSG5XdXd0L1NibVZpSi8wMmowRC96?=
 =?utf-8?B?L2NjbTF5a2c2Z2pTcmdHYW53VkZtakdhaHFLaTMyVk9GMUhjV0RVZVNXREk4?=
 =?utf-8?B?YVhZU1lwaWorZ2QrenFUbURMYXp2Zml1Ni91M3NORHQ2ZytuNnpVeXRhTHdU?=
 =?utf-8?B?cFM0L3ZySTF4YzVyUDJBK3BQQUdSWS81a2R0OGlRdURqNkRhaVFjNVlkd25G?=
 =?utf-8?B?VnR2MlMzcUdQd3NIUStTb2I1MXZ5Y0grUkJqQjdQc3M5S1puMzg0MnhoWm9P?=
 =?utf-8?B?T0hhRW9PNmt0ckk3bXBITTl0bUwvam56Sm5LcVdzYTZ1Vnh2bk5Tb09FRlBM?=
 =?utf-8?B?ck10MDBjblJZZW92bXhIamNJcXpwUktOVkc4K3ZoVHJwaTIxL2NBU2tRTGJZ?=
 =?utf-8?B?K2twNGIvOXNRc09sVmE5UEVuYkdTUWdlUDRGYU5Jc2ZtL3ZmNEhDS3luR1ho?=
 =?utf-8?B?cUtiRmdFeTF4cFQwTm8zRGszOVZLK2FOQ0thUlVZL3RCQmZFeXgwdTJTalRp?=
 =?utf-8?B?ZmhoV0lzNExoWTdkYm5neGdRTk5XUHBOUlNwQUtPRUxKbG4zbDZRNTVRZ1pZ?=
 =?utf-8?B?dFgwaldJWmtJQ1dOcGFqVDBhNUlVYTRLMnc5V2ZYc284ODAxc3lYVzZyR2xx?=
 =?utf-8?B?TTZoSTJ3S2xhanpFODdnemYyRGlLV3FhSVJ5bzJMZXRyNGgwM0orRVFWdkM0?=
 =?utf-8?B?SHJIQ0U5S3VyeVlsZlA3NUVTYmcvMUpBNFNXZ05jRFZZRXhiV3NHek9MLzda?=
 =?utf-8?B?bFlQazFqb1IvRGpZWEd4aEtjd2ZhYXpkZDdueWFYSndmeE9NQXVWM0t3eHVh?=
 =?utf-8?B?OTBCNWlkUFpoczZmQkloSGZnRHJSMGgvZXpocDVxNzU1WXoyM1liVTRnTmxB?=
 =?utf-8?B?eFhTZW92SmRGb2Z5Yy9EeHNWMU9sRWlGMEhRZkhVK0NMUlRLY1A2MDQ5WWQx?=
 =?utf-8?B?K1B4STRLa2hZRExtNnNoUTBVMG9JWi9XdndzQlBNV3huR2IwMi9xR0ZCeThH?=
 =?utf-8?B?dHdsWkUydnFwVTFLQXJ4NGhoMkVobFBkQ2hJUzVwUnNSbmlvZ3ZzOHY5MUZo?=
 =?utf-8?B?aThES0RHSFpNVXRHZllIUE9KMG00K0M2RS9EdTIxcFEwYVo3NEpWS2RrWlRu?=
 =?utf-8?B?Z2FXZlBJT0dsUXI4cUh6c1Z4S2VvaUZqMEg0NUhTdGZZTkMxSk0wTjUvQlE5?=
 =?utf-8?B?SzNOTm1GbnpNRVV3bkVLWnBydEpVVDRvVVJZYkZwR1ptNTFibVBFS1kxajNu?=
 =?utf-8?B?RHk0bVg2bmhpU09HeE8vb2pmdVR6S0tFMFloZmRjV3NQMDhHTGZleVdmZjFq?=
 =?utf-8?Q?vCVsaIt1UEk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZzVUSG9JZHRaZC9QWk05NXRwSEJFNUJDYVRXc2o1L2N1ZUpUdlQxbUdXZ25B?=
 =?utf-8?B?Z1NQZWtoYytNQWNBSFNYOU02NFVobEI1bmtYeDBtWXhXLy9DVnI0NUlVZm5q?=
 =?utf-8?B?UXZDVHZRYzZxeStvTWF2dk9GVWQvd0NtV2svSUEzUnVSZ3Ara004c0NENWdQ?=
 =?utf-8?B?TW9ycDNCMHozU2Y3Nk9uV1NaanV4U3NSK0tNRGhacjIyakhUNFFodG5uUVdx?=
 =?utf-8?B?Q211bWlsOVJPUi9GSXJISGo1ZWpQU0tMeTNzMWd3ZEYvaWxTaTF1MlF1ZHFs?=
 =?utf-8?B?dENlMXJFenBpaUwrSXZQa1lWNU9iTVc2andiRnVyQlhzTlBrK1p6Vzg5SGJ3?=
 =?utf-8?B?ckpnSHBYSDVtZTdZUkQvUEdnYURQQ2k1RnVaU0V5YVg0VU40Um82dVhCMHU3?=
 =?utf-8?B?ODk5cjQ3T3E4QlhTdnhhbW9EMEFPMnYyUkhLOFdBVUpNQUNiYzhMMXhVWTIz?=
 =?utf-8?B?TTQyQXdGSGdCNGhVWXZUOUpGN2JxUllSVWxIMmN1M01malJhUFpDVzZKL1FV?=
 =?utf-8?B?YTlBMmgvaXZnb1lhbnVjblJMbmJudXFBZ00rdHNFLzZLbk0yKzNQNC9WUlJn?=
 =?utf-8?B?Z1ltTTlvazhCbENQQzNVVlU4Wk5JeGdRVWlOei9PNXR1YXJRQUZGeXI4RGk2?=
 =?utf-8?B?SXNheHppVm9weWx4RDJvZW5Yc2dxRGg1enpMOGtSUWRhTlBub1liazN6RzdQ?=
 =?utf-8?B?VExsQmNhL2tDeSsvNE1vRjdpbkRldXpocGtCSnpuSExBUjkxWDZDUmNGVFRC?=
 =?utf-8?B?UWZiWmRER0tEcUlxQWpnVmROT2E5YlB4WTFZeWgvUzdkVzFXQzAvK3cvQTd4?=
 =?utf-8?B?eS9nRks1cG0rL2FZR0xKeTdZNU00dll5OEJndmJGZkFzVWJ1TkNndENhVFhm?=
 =?utf-8?B?ZmJhQlhBVG5tUWlRTlRkVEVtellzVTZOSWVlaTNVRlcvaGo4TVBNbnNHUWh0?=
 =?utf-8?B?VVhxakhDb1RpRFpTWU8zeUNsb3NuWWhzd041Qi9ibjEwYkl3WXpyRmwveE1y?=
 =?utf-8?B?MHJKK0NpRXJLVmZOaXNqNU04anNEUVd2SCsvbHdMR2FjZ3I3TlppUTFsMCtq?=
 =?utf-8?B?eHovbG54a0dkTnQ0azBrZnhLcGp6eC9oSmtuRTNpVlVRNG9FcCtSNjVMN2g2?=
 =?utf-8?B?VzRIWEJuZTlOLzRYRTh6SDRCQ1NHaDZFcVkzakxleTNKVWY4b0t1MmR6RTY2?=
 =?utf-8?B?UXVmSW1PeXdQZytqd0J0YzRFRS9yT01ZSUU5K2NiNzFWTkswbzNWMTVEZ2Z3?=
 =?utf-8?B?aTQ3YjdHNElrNFo2ZVh5WlVkZExDTW42N0hPYXprUzZudE92Wnlxb1c2bmtQ?=
 =?utf-8?B?T05iek13SHBsYkQ0dzU4aFp6RmxwMU4vWlJxNHpjNlVuZ0pseDJTOENVVTJs?=
 =?utf-8?B?cFJya0JpTHBrV3BaMTNBRXFLMEFmQlBJUkdtaTVIeFBZYXc4VDdvUVNiUExI?=
 =?utf-8?B?MmNjUkFjV1hKam5ISTZxSUZpTk1PRk1wV2JWOTc5Q2I4d2V5aXBjeEJxZUVw?=
 =?utf-8?B?Rko2ZDBsV2lZZ1FrWkM3UFpQaVBQa0hHQ1Q5eUlRUHA1S0dsMnRJM0hkdkNv?=
 =?utf-8?B?OE0ySzJXM0tpN0N3YWQwRS9KTy95NmFHaGMzbEptbUVBanMvSEVkQkFCQmQz?=
 =?utf-8?B?YnF0QlhFeEV3NjlKRXI2MGhYTTk3SldBbjBsOHJNQlJkcUt4NFZnZkV0NFJh?=
 =?utf-8?B?S3o0R0tseG4yK3g2dFpQZCtDTm1Tb3ZPWkVKZ0dMbmt5NmpFVGFqUW9JenNP?=
 =?utf-8?B?aGw0bng4U1ljdmFodUlYY0RwZDJ3VnBmMFBVcjlNUHFrWjMwNjR6RUd3Z0w3?=
 =?utf-8?B?aDJBSVZwWUhuVTlIYVhkTDlqYkwrN2ZJT2ROeTZ0ZkNlMno3ZHNUREljRmlI?=
 =?utf-8?B?TEJKSGM5aXVQKzRvUDlUQTF1Tkw0bEZTRzBCVzE3VkxmaS91RVUvSklEWTRm?=
 =?utf-8?B?alJGdHlqUUwyZktJQUU1dVlCb3B0aVZBck5jRjVBUmNocGJSN1p6Y1lKcHY1?=
 =?utf-8?B?MVJ3bUJMeGNERStRQjF6eVBJRFhvWnJqWnJ3VVY3MllrWWZqOVp0eTZOMSs1?=
 =?utf-8?B?RjlwUGZyZSsvbmIvOGRNSUpFZGN2ekVuL0tHZjBsTGcyc0xCb1ZTd1EzT1hH?=
 =?utf-8?B?ajI3a01nYWxXZ1haanpQcDhjYjhWNUl0T29WcFNXa2VKRFc2ckc1N0F6MThh?=
 =?utf-8?B?Q0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fe81bc4c-7eb8-484e-349d-08ddc901f642
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7198.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 09:27:22.2641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QyybbMNo6yqm7tkJK7Ih2W9dd4j9GDpS9cA+STbQaOb5ujcrCmo36B9CJzWjNdgciovSkJKjs/fUJwVOhSiXQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5927
X-OriginatorOrg: intel.com

On 07/07/2025 22:51, Bart Van Assche wrote:
> On 7/2/25 11:43 PM, Adrian Hunter wrote:
>> UFSHCD core disables the UIC completion interrupt when issuing UIC
>> hibernation commands, and re-enables it afterwards if it was enabled to
>> start with, refer ufshcd_uic_pwr_ctrl(). For Intel MTL-like host
>> controllers, accessing the register to re-enable the interrupt disrupts the
>> state transition.
>>
>> Use hibern8_notify variant operation to disable the interrupt during the
>> entire hibernation, thereby preventing the disruption.
>>
>> Fixes: 4049f7acef3eb ("scsi: ufs: ufs-pci: Add support for Intel MTL")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Archana Patni <archana.patni@intel.com>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>   drivers/ufs/host/ufshcd-pci.c | 27 +++++++++++++++++++++++++++
>>   1 file changed, 27 insertions(+)
>>
>> diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
>> index 996387906aa1..af1c272eef1c 100644
>> --- a/drivers/ufs/host/ufshcd-pci.c
>> +++ b/drivers/ufs/host/ufshcd-pci.c
>> @@ -216,6 +216,32 @@ static int ufs_intel_lkf_apply_dev_quirks(struct ufs_hba *hba)
>>       return ret;
>>   }
>>   +static void ufs_intel_ctrl_uic_compl(struct ufs_hba *hba, bool enable)
>> +{
>> +    u32 set = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
>> +
>> +    if (enable)
>> +        set |= UIC_COMMAND_COMPL;
>> +    else
>> +        set &= ~UIC_COMMAND_COMPL;
>> +    ufshcd_writel(hba, set, REG_INTERRUPT_ENABLE);
>> +}
>> +
>> +static void ufs_intel_mtl_h8_notify(struct ufs_hba *hba,
>> +                    enum uic_cmd_dme cmd,
>> +                    enum ufs_notify_change_status status)
>> +{
>> +    /*
>> +     * Disable UIC COMPL INTR to prevent access to UFSHCI after
>> +     * checking HCS.UPMCRS
>> +     */
>> +    if (status == PRE_CHANGE && cmd == UIC_CMD_DME_HIBER_ENTER)
>> +        ufs_intel_ctrl_uic_compl(hba, false);
>> +
>> +    if (status == POST_CHANGE && cmd == UIC_CMD_DME_HIBER_EXIT)
>> +        ufs_intel_ctrl_uic_compl(hba, true);
>> +}
>> +
>>   #define INTEL_ACTIVELTR        0x804
>>   #define INTEL_IDLELTR        0x808
>>   @@ -533,6 +559,7 @@ static struct ufs_hba_variant_ops ufs_intel_mtl_hba_vops = {
>>       .init            = ufs_intel_mtl_init,
>>       .exit            = ufs_intel_common_exit,
>>       .hce_enable_notify    = ufs_intel_hce_enable_notify,
>> +    .hibern8_notify        = ufs_intel_mtl_h8_notify,
>>       .link_startup_notify    = ufs_intel_link_startup_notify,
>>       .resume            = ufs_intel_resume,
>>       .device_reset        = ufs_intel_device_reset,
> 
> Having both the UFS core driver and UFS host drivers modify
> REG_INTERRUPT_ENABLE makes the UFS core driver much harder to maintain
> than necessary. Instead of introducing a new .hibern8_notify callback,
> please integrate the above logic directly in the UFS core driver. One
> possible approach is to add an argument to ufshcd_uic_pwr_ctrl()
> that indicates from which context ufshcd_uic_pwr_ctrl() is being called
> (ufshcd_uic_hibern8_enter(), ufshcd_uic_hibern8_exit() or another function). I think it is safe to activate the behavior from this patch
> for all UFS host drivers.

[ Sorry for slow reply - been away ]

It is still possible to do DME_GET / DME_SET while the link is in
Hibernation state.  Refer UniPro spec Table 105 "DME_SAP Restrictions"

The MediaTek driver does appear to do that:

	ufs_mtk_suspend()
		if (ufshcd_is_link_hibern8(hba))
			ufs_mtk_link_set_lpm()
				ufs_mtk_unipro_set_lpm()
					ufshcd_dme_set()
						ufshcd_dme_set_attr(DME_LOCAL)
							ufshcd_send_uic_cmd

In other words, disabling the UIC completion interrupt while the link
is in Hibernation state might break the MediaTek driver.

I would suggest sticking with the current patch for stable, and
considering improving UFS code going forward, for example setting
and clearing the interrupt as needed, instead of leaving it set
always:

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 50adfb8b335b..1401aa03f7e9 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -364,6 +364,32 @@ void ufshcd_disable_irq(struct ufs_hba *hba)
 }
 EXPORT_SYMBOL_GPL(ufshcd_disable_irq);
 
+/**
+ * ufshcd_enable_intr - enable interrupts
+ * @hba: per adapter instance
+ * @intrs: interrupt bits
+ */
+static void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs)
+{
+	u32 set = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
+
+	set |= intrs;
+	ufshcd_writel(hba, set, REG_INTERRUPT_ENABLE);
+}
+
+/**
+ * ufshcd_disable_intr - disable interrupts
+ * @hba: per adapter instance
+ * @intrs: interrupt bits
+ */
+static void ufshcd_disable_intr(struct ufs_hba *hba, u32 intrs)
+{
+	u32 set = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
+
+	set &= ~intrs;
+	ufshcd_writel(hba, set, REG_INTERRUPT_ENABLE);
+}
+
 static void ufshcd_configure_wb(struct ufs_hba *hba)
 {
 	if (!ufshcd_is_wb_allowed(hba))
@@ -2596,6 +2622,7 @@ __ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
  */
 int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 {
+	unsigned long flags;
 	int ret;
 
 	if (hba->quirks & UFSHCD_QUIRK_BROKEN_UIC_CMD)
@@ -2605,6 +2632,10 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	mutex_lock(&hba->uic_cmd_mutex);
 	ufshcd_add_delay_before_dme_cmd(hba);
 
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
 	ret = __ufshcd_send_uic_cmd(hba, uic_cmd);
 	if (!ret)
 		ret = ufshcd_wait_for_uic_cmd(hba, uic_cmd);
@@ -2681,32 +2712,6 @@ static int ufshcd_map_sg(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	return ufshcd_crypto_fill_prdt(hba, lrbp);
 }
 
-/**
- * ufshcd_enable_intr - enable interrupts
- * @hba: per adapter instance
- * @intrs: interrupt bits
- */
-static void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs)
-{
-	u32 set = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
-
-	set |= intrs;
-	ufshcd_writel(hba, set, REG_INTERRUPT_ENABLE);
-}
-
-/**
- * ufshcd_disable_intr - disable interrupts
- * @hba: per adapter instance
- * @intrs: interrupt bits
- */
-static void ufshcd_disable_intr(struct ufs_hba *hba, u32 intrs)
-{
-	u32 set = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
-
-	set &= ~intrs;
-	ufshcd_writel(hba, set, REG_INTERRUPT_ENABLE);
-}
-
 /**
  * ufshcd_prepare_req_desc_hdr - Fill UTP Transfer request descriptor header according to request
  * descriptor according to request
@@ -4275,7 +4280,6 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	unsigned long flags;
 	u8 status;
 	int ret;
-	bool reenable_intr = false;
 
 	mutex_lock(&hba->uic_cmd_mutex);
 	ufshcd_add_delay_before_dme_cmd(hba);
@@ -4286,15 +4290,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 		goto out_unlock;
 	}
 	hba->uic_async_done = &uic_async_done;
-	if (ufshcd_readl(hba, REG_INTERRUPT_ENABLE) & UIC_COMMAND_COMPL) {
-		ufshcd_disable_intr(hba, UIC_COMMAND_COMPL);
-		/*
-		 * Make sure UIC command completion interrupt is disabled before
-		 * issuing UIC command.
-		 */
-		ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
-		reenable_intr = true;
-	}
+	ufshcd_disable_intr(hba, UIC_COMMAND_COMPL);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	ret = __ufshcd_send_uic_cmd(hba, cmd);
 	if (ret) {
@@ -4338,8 +4334,6 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->active_uic_cmd = NULL;
 	hba->uic_async_done = NULL;
-	if (reenable_intr)
-		ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
 	if (ret) {
 		ufshcd_set_link_broken(hba);
 		ufshcd_schedule_eh_work(hba);
@@ -4360,6 +4354,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
  */
 int ufshcd_send_bsg_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 {
+	unsigned long flags;
 	int ret;
 
 	if (hba->quirks & UFSHCD_QUIRK_BROKEN_UIC_CMD)
@@ -4376,6 +4371,10 @@ int ufshcd_send_bsg_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	mutex_lock(&hba->uic_cmd_mutex);
 	ufshcd_add_delay_before_dme_cmd(hba);
 
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
 	ret = __ufshcd_send_uic_cmd(hba, uic_cmd);
 	if (!ret)
 		ret = ufshcd_wait_for_uic_cmd(hba, uic_cmd);

