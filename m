Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E033438BF;
	Tue,  2 Jun 2026 10:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780397937; cv=fail; b=lCQQ7CJztUEh2hovH68NIp7UfuqrL/6hRrmRX48E4TJq8/nOyrclxHAuUIlnTLvTH8YWnRor+gdfuBtoBs5AsZkOcqDv4pYpX/4Nu2e0UJaNAF4YLUF2Tcwxy13mZe50gBPBcpSx1TrO+d9wYrDDincK3wjVLkAdYyfredYQ1p0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780397937; c=relaxed/simple;
	bh=oIO9JQBw0wYUawlXObZA/O19tdOb8DsQJkd93rnBfkE=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pWzSa3wAcaVwcw5ct0sLvgKrYc7n5IqvTsjRBDMeJ8K8GXCo/9SpEKtcv/nUnOBymHuYbh3z1AkfQaLlDg1BNpz37biYhuckoODUbSm7kEv9jeBKZCy/2LTWvCa2QuSSk0QbtQtWWrMIaSlBICcr9uKARmpGxzVq5D5mqQjrgs8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lzBloeAi; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lzBloeAi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780397934; x=1811933934;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=oIO9JQBw0wYUawlXObZA/O19tdOb8DsQJkd93rnBfkE=;
  b=lzBloeAix/FxrNXJHhhTY7O5oYxCC/crrF/RI4e/+plGMq3qQRJsmzPT
   bIFWCNWlNbsfZTCcZblNHfNVTpEw/m7c5xs4L0L4p0or+o5zsLNCm6dbY
   ap+XJDeakRwMhgQov6h3Pn90DobHdHRMXipXjx6mX1da1RmMepRBhfZTx
   CLKm65tznjJsbBPqgiDkILvKmUnEmoULH7/593nD1r7Upc3pBXZMRPF13
   sf9yzbuCwxfhOnh6lxmrtwxa8KEX9UTJ5mvkzGmtlhy9BFDj5W56e/jAw
   QRwWKxcAUKJALa59y/ClvUUWU+oJEK9m2GUeaLSMQxcRnTOygZBYEW0/J
   A==;
X-CSE-ConnectionGUID: NZrQhfMvSXainv0yHdQyFg==
X-CSE-MsgGUID: 0eddli6aQzCzTr7BpJkNjg==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="85035444"
X-IronPort-AV: E=Sophos;i="6.24,183,1774335600"; 
   d="scan'208";a="85035444"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 03:58:54 -0700
X-CSE-ConnectionGUID: /XGQ2jVyRk62LcgsZ4pI0w==
X-CSE-MsgGUID: oRA2Xt5oTeGvXEoX95jWQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,183,1774335600"; 
   d="scan'208";a="239707578"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 03:58:54 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 03:58:53 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 2 Jun 2026 03:58:53 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.1) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 03:58:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lqPMNgRoxVEDARLBXlISlSSzIQZjvPZlI18nF80L3m8+LAyGPE2tdbMWVqV84c99L6kCRbF1E0URuEOpYo1g85dbVOWSVr39NrI9a72pkBVEgNhOuzLKhqazrZ/Dwtz1geN2b4lrN5EVnWUkv/J+e2c8OwXI+97Cy0uPBNEpK0U0eOFL+zw6mEq3BnnnfNSq054NJqdbzK7zXjNn+I07Y5P5/gbnhrwUJmjnPqLkz802cH/L8Aq0foSj+RzmUIARt0eHkE4mpwu30PTwZm/wBbi0Qbqf1ve41smAZ16vOyxdJYW/Ty50BTOMkkwy1Uud5EFVIqF8KkF5jWiSpMOJAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=At7s0G+HwhNP1Z4a2oRrGqbgQaBXL1+hF3PQZwt/dYk=;
 b=whJa9CYiJXTRJCK8YinC+Ustq+tOMsBrfIm3WxqgOlGx0VfTnf1UTcKzd6ZfZ2BKzoN6A0k8BPe+snU2acZPZZoh999vz0CiYfJIX9ehVj2aqJ++4+/2jUFBg7LbCCpjZgGJ0URrwNWNqbrDJGV0hnNhi6EZXIzsge99tBQ6OQAzboK6ASnsvEWX7jk0S7jqJX6OtrbEUjjbaDYsq8EutTB7Mh7u0qbe+5wy/tV67phCqwn37kjkPRkTE1V7ZD/GDSu1oJ+h1ax+Q0xyraXZAcDShGGsWkh36FpIaRNfaYhCwOrutPsr50/HNiRgp8IJb/7fnai57glVboSEw6ju9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by PH7PR11MB6858.namprd11.prod.outlook.com (2603:10b6:510:1ee::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Tue, 2 Jun 2026
 10:58:47 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::2c4e:e92a:4fa:a456]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::2c4e:e92a:4fa:a456%3]) with mapi id 15.21.0071.015; Tue, 2 Jun 2026
 10:58:47 +0000
Message-ID: <8d736c51-cdf3-4007-8f47-7c1f9b606cba@intel.com>
Date: Tue, 2 Jun 2026 13:58:42 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: ufs-pci: Add AMD device ID support
To: Rajeshkumar Sambandham <Rajeshkumar.Sambandham@amd.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<bvanassche@acm.org>, <archana.patni@intel.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20260602095931.2869516-1-Rajeshkumar.Sambandham@amd.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <20260602095931.2869516-1-Rajeshkumar.Sambandham@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB9PR05CA0011.eurprd05.prod.outlook.com
 (2603:10a6:10:1da::16) To IA1PR11MB7198.namprd11.prod.outlook.com
 (2603:10b6:208:419::15)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|PH7PR11MB6858:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d7307a1-5680-41bb-121e-08dec095ebf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: 0B2rtEe029lzBmkEAGpkrcPctkoIR/pFEcZ44znJMzXMRlfM9Zo3v9zLL1qXUg+IYiegL+mLC+WU3O4Q9BsMXeq8WdMFf/EXOU1MzexO4oc/ntmMW9zlkds8JSaj38h4E1urfTnTYjhAQFNMOD+Uv2pipmG91cD5egMAtGdISsVXTc82N+bcUA6k1T+kIFBil3zMs+QfFFHKSpyuBN2roY6FzjZ3ZSq4N0UazVUqcTzDvR1hOgfif6DcTuPMVeNq+nw6YjZJS4xXDQB3zKC9NQ7FG8mRzZqMaImGhSKvPe/wcPzQgLXhBfFI9fD+F4AGafr/gAcY8VVhN5FHVeYEgNPd5H6OqR117nnJ1FqURbNMcWP7QiOM5pPbJl8VyGg4MnTEOckiWDyIVBFC+FhCH7IRP4DQnl3YiuEueVnd0l9Vf5lDdx1MlKaSL8VinroIDCe789VMAHNF+kC3UjJDb2/mtb5+jvbhWzJ1jf4HlEr7V2BBTba41XwtYWQMms1LwLX5zZmdXzsXz3aItL17/9Q1CZOAT5104OzEsKoAKB0HxLR49EtfvXu7kmk0X7+eJY9s4ZeUj64KWOVZ/MfCPE0PabKWD0WDT36xBiWFq+B6zFck2kdd7+yOHSkSCuQOccUAKLNUUSEFSPIPdWrNVx8vI3tKbENTNGlTNs/xfS0YFthtBvwa/p5PckMhton2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGx6REFWZ2V5a0JSbW9vK0QwWlZrWjM3cU9HVWszT1dYczI4MVZ2RVhpSytQ?=
 =?utf-8?B?M0NJUk15NXVCMWpyWTd6WTN6dDNjMDdoSS9kT1RIelJybEt0Wm1JN215Qjla?=
 =?utf-8?B?czBDbUlMazNIVWtXTWFJem1HaTBsNjNxMjlrZG9zWmRLU1NKSHBhZi9XRVV6?=
 =?utf-8?B?ZDJLRWxreURGNnlOR1dEUWVRUTVWT1RFYUc4OG1jL0xXSThqY21nMU1RYXZa?=
 =?utf-8?B?SDIxdUxlYWU2Q3kybW5LQ3ZhVmRoNmhIcWI4U2l3Q0NUdUlnY3QyQVFxNTYy?=
 =?utf-8?B?UWNyM3dQMzhsS3B2MDVyb2lZSW1jN3V5VzkxcTVHWk1lWSs2SWNTbENkVDRZ?=
 =?utf-8?B?aU5LYXlReXM2UnRRTGlKbi9CUzNrRlRjTzdxS1N0NkdBWkVRMUZ3dG0vRlJs?=
 =?utf-8?B?NERVbm1ZMmNqZ3I2c1VjSEJIS1RGN2xoZ2d4Vk5LVVVPM0lVYkZNQUVsWGR4?=
 =?utf-8?B?MGhRNm9SWjhISFlRYWlpdUM4Y3NOY0lyS0w2SjRvQjUxTVVDWll5VUcwY09D?=
 =?utf-8?B?eVZjOHoyVGtOSlRYZDBiajFGYWFGeTJaTjZhcEY1MHhtczRhcHNXS0xBRXla?=
 =?utf-8?B?U295TlVnaCt3eWpUNUwvaFovSTJPRHZKRDJCa0FqOVVCWG9FbCtNYjl3cmVp?=
 =?utf-8?B?QnVOZDBKaHNzN0wzNktNVi8xVTlzZE5KSDNrWmNCdXJ5QTdIcW5aT2p2RFNv?=
 =?utf-8?B?UUd2dTYwR2pLVzlxdHdoVGNBNG56eGY1b0tZZDRBb0JGc2tEeUw3TzYwcGJj?=
 =?utf-8?B?M1REZlQ3Njl0U29ieDVCdzZ4Q0d2czV5VHUwQ0JkQnhCSFNWL0tUb25RMEJv?=
 =?utf-8?B?OUFTa1kzS0wxOVJEbnBSQU9reE44dnhvNkcrRW5YL3dPcEVwV1FhSFFPbmNq?=
 =?utf-8?B?aENSdzFsQXNBTDVqcHlQT1JESkpOcVZYdVFoU2ZobFlSeE5mSlNuaFhyQ2RX?=
 =?utf-8?B?SzZJcU5mT2FlRGhYTXJWckgydFVQRVFUMG81b1ByRXBKTFoyTUl2bVdmSWMw?=
 =?utf-8?B?RWVlcG1ZdHVzV21WVmZteGwwL3B2RElIOVdPc0NvMmV6cnU3MG9MeWR2aU5w?=
 =?utf-8?B?bVovaUhaQzJxMFArNU4rZDIzdzZLbnF0b3h1ZUgzYnhDb254bWtnM3RvM2tF?=
 =?utf-8?B?Qyt6cStGbTFDV21yNy91NlNiVnJtUjNQOGYwalI2QzlLbTVpeUlGMUR3S1Ra?=
 =?utf-8?B?ZkQxdjZzanJ5dWlCQlhwY25yQlM2QkZQejRLUS9RRWdTa3hJUVp1bkozcDFP?=
 =?utf-8?B?eDgwWEJWbVlEd2E2azdyVXVxZk5GK1RQcXNVbkpUQjF3cncwQ2tKTjlJTTF1?=
 =?utf-8?B?cVQrUVNKb2poQUsrd0RHQkxhNjFJeXg5L2lsMDBzdWZpV0h0eWNWUHpweXB6?=
 =?utf-8?B?bGhZb3dCZ1NLRUpYbk9vblJRSmRTZmFDbENYc2J6M3NlQWs0c1JnZW9xNkFh?=
 =?utf-8?B?Nm5NdGYrYkFvN0QyS2d4V2FlNDlHNUFxQ2t1Y2dvd3dQa3NjUVloZlhVZ3lD?=
 =?utf-8?B?QmdPdE8wdFhSb3dRWHZmRVI2YXA3RWh3cnRPS1Q1amxYZytBVmN5OHpLZVBq?=
 =?utf-8?B?N3lRUEN5THRrQWR3TlBHZG9iOTMxZHJXU09OdHZKZm53Y2FVcEt5c0svRVBS?=
 =?utf-8?B?eDZXRVVWSk9OZEZMMFYxNjBHY1JyYkhVQlVKd1RSRlJQaXllK3RzNlZBYWFs?=
 =?utf-8?B?SHNqWVF1SEt5OGQxU0EvVEVaUjREd3psdVRlSmhtU0c3ZG15ajA1Y2NVcjdQ?=
 =?utf-8?B?ZnZDaVR4RkQ5QjJkRm8vYkZ4dVZmMW1rYWRYNVJzcUhQQXlRc2YzRkZEL1Nr?=
 =?utf-8?B?Y0lDTnRsWDdMZGNSckdhUVg4VDVVZmlvM0s4em05d3BFUFBUOUhCbkFrWTN6?=
 =?utf-8?B?RDVGNzUwZ0E1dEZPT2FONktLdGQvRzZIS0lCUWtJckd1NmFmN0l6cVZxdEhH?=
 =?utf-8?B?MzhrMURPZ01jcnBTb0hNSXFSd3h5Uk54bFpBU1E4c3RXek5GclBVd2tMb1Ns?=
 =?utf-8?B?Y2RWekRGL1JhK05pVWwrSVh1WFBpdlpxcVVuOG80Q0FoRmxkWTkzQjFFbWVL?=
 =?utf-8?B?N1VIMEgyM0FWZTdQeEZISUNvTWJvYlFZaTkvajd5Y2VPcWwwRUhqeE9tRG91?=
 =?utf-8?B?L3hpU0F3OTIvRmZNT0krMmUySnl4N1ludHFWMiswbXFSK1FHNmRYRHhKZGQx?=
 =?utf-8?B?dkQzc1QyMG5tOUYxQ2krdW01c3R2ZFNEbmZDUTVnOG00UVZLQlhMTE94NkxW?=
 =?utf-8?B?RktLdTBMZ3Y0OWI4QkZISEEreWxxQ3hHdGQ5ZlhWeFNrWG9zUW1lZkJ3NHpw?=
 =?utf-8?B?YnVrSUtUUU5rVVUzU29TMW1TSUZuWXptbWM2ODdSQXQ3MTlnK0dMZ1ZMSDdL?=
 =?utf-8?Q?0yVqBOdcknoMVUbs=3D?=
X-Exchange-RoutingPolicyChecked: QLquulQFWSYxfTtqiWltcE+xATI9GdEeeza4b03Q5anXTf3KdoSGydCt012KJMtJiXa+tVL/GFrSyx5wkMa3tUdlSRQf7LXK0f2bsO70Da5AoDTtbqvLhzs0onMjZuWZMK9Uxz0ufzbQFWFMXRclkSHL64wc2Ppy1bzetbkXqO2nDJhVDZYapIYPq7hUIUnoAJYEbXLgfhzYurbNkfB7Kc4qQDGX1wcup1z1Pm/PL3HNX/u12AMPZ+iIihlTzkflcEAx+Eq/MUV1ml+ahxlHZUJ66qC7DFbIlhHX98CERXdvSx0cUoDlaoPuPgumhxe0o4SG/EQZ7gwheCmt5PDFJw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d7307a1-5680-41bb-121e-08dec095ebf6
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7198.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 10:58:47.6912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YSGtcGLyEI040WSVI3QoQUy9eYgjFjB652sCbSuNLx164Xb6mwWJoNg0NJawRHDyHo5p3Uj60AEpHT58QIKcVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6858
X-OriginatorOrg: intel.com

On 02/06/2026 12:59, Rajeshkumar Sambandham wrote:
> Add PCI device ID 0x1022:0x1B29 for AMD UFS controllers.
> 
> Signed-off-by: Rajeshkumar Sambandham <Rajeshkumar.Sambandham@amd.com>

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
> 
> v2:
>  - Use PCI_VDEVICE to match other entries in the ufshcd_pci_tbl array.
> 
>  drivers/ufs/host/ufshcd-pci.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
> index 13293e83064c..f2433879b0eb 100644
> --- a/drivers/ufs/host/ufshcd-pci.c
> +++ b/drivers/ufs/host/ufshcd-pci.c
> @@ -694,6 +694,7 @@ static const struct pci_device_id ufshcd_pci_tbl[] = {
>  	{ PCI_VDEVICE(INTEL, 0xE447), .driver_data = (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
>  	{ PCI_VDEVICE(INTEL, 0x4D47), .driver_data = (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
>  	{ PCI_VDEVICE(INTEL, 0xD335), .driver_data = (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
> +	{ PCI_VDEVICE(AMD, 0x1B29), .driver_data = 0 },
>  	{ }	/* terminate list */
>  };
>  

