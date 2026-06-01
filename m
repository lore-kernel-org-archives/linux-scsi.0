Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8CF368D70;
	Mon,  1 Jun 2026 10:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309623; cv=fail; b=oXCqZFuVZPAkAlt/ojjlwcK2yAe7gefar0siiyyxObF23IAzaah5+/hZLq38xRHWbhF7F7feve1ZXIv8VBep5cbw+dRdqrPWxITINJquXbn5wfNVZzJIx643EsZeH0ipoMSaAZA8l6puS+O1//UGL5dCRUKFMww6Rx2iz4rNRH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309623; c=relaxed/simple;
	bh=ryzfosNPtSjyuCTY7IN7bknNCdDqs9PJC26mvUsrePE=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hZs7cRlddBi7mC3bX7SHFBByNvO0DOeyJE8UDoWqb7mZs0RSfJeU1pThVwkADS+LQp7xi7ByRdRPhj6JwT9OMZCHu4QEDHP4TloN2p7zC0L3W6JWWXJWpO6MzH08s9S+SUsHIMRi/y5n1hPtpPmoe58W9ef4dnDfQ0E2U6DHFkA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MqGJA226; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MqGJA226"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780309621; x=1811845621;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=ryzfosNPtSjyuCTY7IN7bknNCdDqs9PJC26mvUsrePE=;
  b=MqGJA226aLmvL51DsnOdbc87vEIzaGL0zheOGFRAxsKGWJE/R2xpgdO6
   Vu8RuoZTqbbeRRVvfgkylc1FBgX9focVvTcTEPIvfdB6AQnOdlqzwOCm/
   VxwQRqhvh6eEv4Qq5U0hZNfimu+nD9L0QpXAlw0KkUrmNRC17g16hKHcA
   4U1GDBqJbpw/Zsutyf9mYR+3NjdibaXbJJsXBKZxD5dopLK5Y9tOX3SW+
   uJ94O59AsAkzJfG1KxotbaIT5B7hnYf10nOBIcPpBx2Mgab60Q8zNeIjL
   UuYjYARnA7SbVKlE02XadbyAcQCr9anO0g6McABLFyY2/C52mOZJlXFq+
   w==;
X-CSE-ConnectionGUID: XSHcWvcaSruVjrI7WHmGuQ==
X-CSE-MsgGUID: rYms27OARnyAxaYc9tOeIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11803"; a="84923225"
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="84923225"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 03:27:01 -0700
X-CSE-ConnectionGUID: r6gUKT2aRcK1PZnG85ZTqQ==
X-CSE-MsgGUID: T2LCGhrLSByUXK7yUGJV9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="248628953"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 03:27:00 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 1 Jun 2026 03:27:00 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 1 Jun 2026 03:27:00 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.71) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 1 Jun 2026 03:26:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ru7ftHPu8WMw/U7luRBUiZLy65l1Wj5RQNU9sFLcLy+ie5890lwmOwAlQwc7LMyLri6jPcIHF7CcbUykqXQztxhgRYPdJfgiWi3uWXDDjED14qbcdvyeUxXCnOjbPAyyecIoER7Q4AgmtOt9v1c/JkguJ7TpLkty1O39G9ey24eCqlpUTvhPHN9qHfrHNugIvLNZqxJLy5NAgXIT36ejkWpCljQyWoHMhewkH7j4cW7DspRT2WOOP57vjVTL6OCDNMBoZILa5hLNtkkRNU/SAg1SsBqWaWjmAoWTh5oClSTIUR/06qjS5wXSnkT4yaUZQnZ/IN894cDwayisWnhCAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UOAZ0pA4KXdihbfNgbJ8ApFYcZ/Fjue3PZOv2SvgMQA=;
 b=qt9J18Uqtn4MzFRaID2A2KUo8f+zHccjLBUspxI6UhzmB669vcrKVGcubQbzOlZv/jzL+XqzT5/BqE6+beLycATimh0QCrvieDlzw3sUQGx+qLGXMaKlsSDAUt/bFbyZtkcwRO9pSLBs+0b95OiAajxDIXctBkIS9I9ZAm9+52fsmk1X00iW1opKbJWHE4SxCKw5gOMoW0FCG9yxiT2fZaRcd+wf1GSiW7O5p8woNack4hIlwCvVMv7d5mQwO7uEcTjH0E/nAO4h9aPRp0C/ndGcm312H5Vhzbn+VOe9NsRpu/R1aVZ30ruTb20E/hSwlE2J1G1a5K6Ut21Iy4hHEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by CYXPR11MB8729.namprd11.prod.outlook.com (2603:10b6:930:dc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Mon, 1 Jun 2026
 10:26:58 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::2c4e:e92a:4fa:a456]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::2c4e:e92a:4fa:a456%3]) with mapi id 15.21.0071.015; Mon, 1 Jun 2026
 10:26:58 +0000
Message-ID: <0b812b4b-2683-44fe-8983-5322a9632c05@intel.com>
Date: Mon, 1 Jun 2026 13:26:51 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: ufs-pci: Add AMD device ID support
To: Rajeshkumar Sambandham <Rajeshkumar.Sambandham@amd.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<bvanassche@acm.org>, <archana.patni@intel.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20260601095336.1396787-1-Rajeshkumar.Sambandham@amd.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <20260601095336.1396787-1-Rajeshkumar.Sambandham@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB9PR05CA0002.eurprd05.prod.outlook.com
 (2603:10a6:10:1da::7) To IA1PR11MB7198.namprd11.prod.outlook.com
 (2603:10b6:208:419::15)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|CYXPR11MB8729:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b2b6b11-b3ae-43e6-af04-08debfc84f45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|56012099006|18002099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info: UkgluoBXLPEOHj+02pIBlKEDOKIsNN04BlIqEOU1yhzyhFlOu/R0Ya2qUWAGvoskHjpFaWOvmBZMw9qlzzyTHrum+vYQenN+xT9yoRGXTF/MyDIjpfphcjO7RjyWhTF1RCUEIrjui+8YGMCo/FYpHkPCJqcKQIegiV+eTWr2vbRrefv7yJKWXDq/wRqJAQdvtbaYI84DLfeU/vzh55tK+8hal3xvYn+KEcmTBunBz6PGoEvHg4GFB+AyeSVRVNLn0J7bJRwlKe3T2ypFnMtQFUEqWeQDmBwo4pxzB0/axkfDIgeHtQaxAe3DkOOzjNRBBr70oaKQCRgzjABoHeCfIf98aDPuoUPWuDOCFgkKu1k/I84zNnfpnL4IuQMEEQVwZlDLs15xc/Zmf8bomf5wQGLaUmuSuLY7kj0co6AnkCiiNbGe5ZF4LoTX3nMSUoMpKBmjsn48J5JSbnPtv8b5Dc34iFHbVBIbC3lGy0s3omrj/+yDLWTbE3jDxuE1idP3mKr0od7AomdnbZQaao00+vLAakLYTiNc3V+Yd1OvFSZA7CYz/bmJCIYp7JbfcqpCiPPjX0sc+gnQ/IMt5gITMQi/T63nLgA6lRbM6ExgDsSfQy8UQMuMOp2Y6ZC1WzvzhORdoWHIgF0p9gVeeaTz4kncB3RjB/ZG5xE8OUUeTdlqR6lbN1ID3u873BE4NFym
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(56012099006)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ajJYSGdNdFNEOWpGZmF2UUR4bjc5OHMxbWJTdy83N2tZTXdxdnJSbUs4c0lt?=
 =?utf-8?B?N0xXZHFoY0VQOTU3MzNoS1g3VVlsd0JUZjFzOUhsQXhjMG1mc1JYY242NGY5?=
 =?utf-8?B?bEgyTlgwOWJWT0tjR21PamNUclpIVTRaUmc2ZkhycG5DbSs0VGI1MmxoUi9W?=
 =?utf-8?B?OVlneUdJZkJ0bWYwY09YajZ0SGRjcVZNaHNDTUthb0xkOWVTYUpvUkhPT1ZB?=
 =?utf-8?B?bFozRS80ZmdPalcxWVhKZVFkU2ptZCt3ZUFxdE9pZ0ZqaENDOU81TUN0L0Ja?=
 =?utf-8?B?TXlzN3FuREc0bDBGUEhzbnkyOERWbjJOQUlrRVZQc3NsbUs1MUNsem1IcUlB?=
 =?utf-8?B?b1ZlTFR6OUZXV0lJRU5meWVCbUZRQXVWczlLWU05SVNERlpBVm1KenZzbWZi?=
 =?utf-8?B?R1Vud1NWRWFIcEJFbmVjVEd6RXRHSjdFWm1Oc1l0SHpjWTRFenlsby9LY1Mv?=
 =?utf-8?B?a0NvWjV0SkVReE8vS2N4WUV5RDByRWY3RzdMakdvZnNobkE1cnpXWTNsazlT?=
 =?utf-8?B?RUVqUXdQcCtKdkZaVkVwVmN4UzVwVjNpVzJ4U3ZDNDVWazFYTVU5MlV3S2Ro?=
 =?utf-8?B?a1RTV3hUYjZYZlFROGVqcDVkL0syWWY0TlJVS0huVndCMVFSUDZIZ3o0YzNN?=
 =?utf-8?B?MWk1T1owWnNVN0MxTHNVc1habGNUNTlSajdlbE5NMytJNC9WRUNMQmk5ajRP?=
 =?utf-8?B?dUxWa2VWbTVCNUgwMFhRbnY3UGMwc3ZNNWNoRmpwMUs2SzAvem1sZitpajV5?=
 =?utf-8?B?U3FOQVhlTWlaNWhWTTA1MGFlNXFsMHcyd01xWmFmZ1BkQjNuOXdZUndiZmtQ?=
 =?utf-8?B?UU1TTjdOWWF3S2Z3OG9QazZrNTZESjF4QU9qeURZSGFCbnhuZHF5cURFc1Nw?=
 =?utf-8?B?TTJUblhpWktlVzE3QzNlTzdyUi94cHdCUzhTRE1CRHpoKzJZcDJNejVESStx?=
 =?utf-8?B?ckNnRkNUSmJHSU16MGI2dk1GMG93a2trQSsxb2VKWnh5RktQKzlnN25VU3Ez?=
 =?utf-8?B?bGxWZ3ZCMjE5MnhlUlZRZ3dRNlVINnQ2TEgxdzF4RGVtMXBodmtTVG9Uekha?=
 =?utf-8?B?eFVycXAyUUh5dDhmeFpnUkR0Zlp3Tzg2aGp6WTVLajdYYlhEc01VNWhvTTdX?=
 =?utf-8?B?aXJpWTZsMzNZR01tR2xtYmdOZjdDb1VCU215VlVNMndmSEdjZEhrMzh2djJM?=
 =?utf-8?B?MHVqemNjOEJ2Tk9KS2YzSmI3UENjZjVoMHBQREdaTFdOVHVnYjJWbk05Q1VQ?=
 =?utf-8?B?SmRDK3FwZmYrM1BIcUtRNlNZODlpRG93OE1JTzdLNXE4Um9nNW84VTFud2JY?=
 =?utf-8?B?ckFFV0RPd0J4VktCZndvK1ppb0R6L0tiSGJFTjJlbGdWSjFDMkVOWFlEMlB6?=
 =?utf-8?B?ZWVNTnovYk5oL3cxODR0TkZrbmRaRWtzK1BDWkMvY3VoaThJcHVUbG14QWkv?=
 =?utf-8?B?VzhIMTR4RkV0aEdpSmxvNEYvNzNjOVN6QkdUZFFLM2RVeVFDTFRWNy8rVjR4?=
 =?utf-8?B?c0k3VnJGWHF3ZURSWU1CYTNia0VqOUpJQXU3bGpLbUFuZExvSnRFeVRiRXp5?=
 =?utf-8?B?V1BKYjliLzFaaWkzakU5R3BUQmlGdC9qcGJpTUorb0dRb1kvTTA2QnBjYzlG?=
 =?utf-8?B?VUwzMHBlb2RBcmdoL1NLMWl6dlZWNUlyczJIRm1uMmdxUXowQjcwWngwUXpU?=
 =?utf-8?B?Zk9LYWtpU2VqZHlCZWE2R284cklHV05uSUxJYjVGUHowMzZZNnNjNTcrMnZy?=
 =?utf-8?B?Zi9lLzBQeGFxWE9PK2tnSnpXZkhTd3c3c2V4bi85SzBtTi83SngyWXp5Vmow?=
 =?utf-8?B?T0JGVDZiUjdsVXVpa1VkUG1DR2pobUg4L1VudC84Tmh1RHFGNDFpUlptTWZz?=
 =?utf-8?B?SXFBZk54dWpwVFYvcy9OdEV5RnFZdlhySnh3anRqMDJad3BtRWtQSUtLblY3?=
 =?utf-8?B?aTRRTHVqaktYT2U1Q3pCNU9PbGpVMW5WQnErZXhUSUpUcjEzYUNVVkFXQUQy?=
 =?utf-8?B?UHN6akJxRElaU3NwK3h4VFF0TDhnemZaODhFbGJ3MldsVlVRc3JLTmtuWVBs?=
 =?utf-8?B?eXJkQUlYNll1WUNlaThxUmdRWURMKzFaRXJlRlA3VlNmNWVtQm5CTlJ3N050?=
 =?utf-8?B?NWVoeGRCR2hIb0wvYU9VbHVrWmpkSzRqclVTenYyYlhsdWpWRVc2ZXZ3bjVu?=
 =?utf-8?B?MDZzUGd3YWpLemRubkNBR01MeE83dDRlVlU1K0Rnd2FvSUxJNGtMVGlGTEZ0?=
 =?utf-8?B?ZytlZU43QU9lUE9hTWN0aDZwbk55bUFHL3N3amlMbmZHZHhMZnZ6aTFHNHlE?=
 =?utf-8?B?UUFBYnhxa1F6dll3VmxFVWszZUxzWHZuYi9SUlhxc0FCUHJzR2g4QUdtTWk1?=
 =?utf-8?Q?+pU6LccFbEngE5Is=3D?=
X-Exchange-RoutingPolicyChecked: O8BYYCr+iBr8JTd+JoXUx0EinKB3oWb6SV7KdxRNfweXnKQFiSyVGMCI2NTNBMn207lT2ovE+h4qGjgm386q4uHBqzuuZIJzv+vaXxoynMXZ+wdArjYM2NLrsn/rPyIGxhLdCmkkg64wWcl54spCzqP1y73oLoLj5ne/5LZ1rubEGdNjYgfFbknNlsg0+7zwBmjgS9LL9tljIOD3alHVYXQiZk5UFeXuaAjsJrk4OwUchjv7Gj+dKHmBNvkDo48j8i2/oWGxUH58awGMccKccK9Z+/8UiAsi75SmeBBA9ZDVpHTNrkQK39c/K4JCLA0ilFclAxw2Lk/LDkvgmITI7Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b2b6b11-b3ae-43e6-af04-08debfc84f45
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7198.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2026 10:26:57.9773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pRBCo00zfFkyDjo2GhGyO+QXV8zTcKEA5RfihV2u65//VgywEjX531zMsLX94mLRj01A91Mbw+j8NFx2jn4Whg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8729
X-OriginatorOrg: intel.com

On 01/06/2026 12:53, Rajeshkumar Sambandham wrote:
> Add PCI device ID 0x1022:0x1B29 for AMD UFS controllers.
> 
> Signed-off-by: Rajeshkumar Sambandham <Rajeshkumar.Sambandham@amd.com>

Does not apply anymore since "scsi: ufs: ufshcd-pci: Use PCI_VDEVICE
and named initializers for pci array"

> ---
>  drivers/ufs/host/ufshcd-pci.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
> index 5f65dfad1a71..9ad42e07a94a 100644
> --- a/drivers/ufs/host/ufshcd-pci.c
> +++ b/drivers/ufs/host/ufshcd-pci.c
> @@ -684,6 +684,7 @@ static const struct pci_device_id ufshcd_pci_tbl[] = {
>  	{ PCI_VENDOR_ID_REDHAT, 0x0013, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
>  		(kernel_ulong_t)&ufs_qemu_hba_vops },
>  	{ PCI_VENDOR_ID_SAMSUNG, 0xC00C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
> +	{ PCI_VENDOR_ID_AMD, 0x1B29, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
>  	{ PCI_VDEVICE(INTEL, 0x9DFA), (kernel_ulong_t)&ufs_intel_cnl_hba_vops },
>  	{ PCI_VDEVICE(INTEL, 0x4B41), (kernel_ulong_t)&ufs_intel_ehl_hba_vops },
>  	{ PCI_VDEVICE(INTEL, 0x4B43), (kernel_ulong_t)&ufs_intel_ehl_hba_vops },

