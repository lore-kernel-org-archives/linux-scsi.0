Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2498F17991;
	Wed, 25 Dec 2024 06:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735109442; cv=fail; b=bEXFLXWNLwVU6OUd9Fzd15YJuvf/KTkOeY6DylmVsUzZEYBA1s2pwp4XpXPBE8hLHBevp4e7+ZE28DUW2iFw05P/9ttX9yighEFgRpHhsKMVKnmRDw9eL33kKXGkxhepLSIBpcCTyiT+Nm4BqL1kXps3oWIDXOKCFoGS6+sRLjE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735109442; c=relaxed/simple;
	bh=6viGWwynn2gDUf3WRo9HitAvvlYuwxST8c5PtJJDiNI=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=MWNLfJOaEUm+vGRgEvliJ6taRvQHIRea3VLilCCyXJ+NvMT1Ehde4nfCkwoqZZfEQ3n8u8EiScbB6jsGZ/BwkSLIXyv1wATV8JxHnh53mVT/s6pBLfVJ3Rl2QrFzv7knOV3dIRiFS/Xo3BwHGR+L/a6sCN//egEOqLYJ0gJjq1k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fjh3889m; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fjh3889m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735109440; x=1766645440;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=6viGWwynn2gDUf3WRo9HitAvvlYuwxST8c5PtJJDiNI=;
  b=Fjh3889mNUtzAy2yhDPixOXqV6AamqwcDs2ANZwXT+bgGUtXZShQGBy/
   8dgm7H24wwcxvCTleT4/nsRvkO48mDR9QQUSfNKziH0FFSVWB2a9U/q3P
   94ywy+x9QwsOuX0w2MliJ0Ss48EL7a4V9qsjc5Rhd/fuEcdH8UDX1188E
   1RqFJS2tblPWE7pKXZp4aO7GfqtQGjRsN7QPsluf+CWySOWbO6o1QKPdb
   /2Lnfk5XYWh3xqQvduDNEDgNij6AkozIoBaPkUBGBTIwfW6MjGd0GZKr9
   d4Ixk4ec7dPyy0fpDZFO0PUUdoNN7KXGSlsqErl/Nt4X60g6hlwgLM3YT
   g==;
X-CSE-ConnectionGUID: +zC3M0IfQn6gQHwvRBaU0g==
X-CSE-MsgGUID: RIe5/kolSZyFmrpZ/H5aaQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11296"; a="46937698"
X-IronPort-AV: E=Sophos;i="6.12,262,1728975600"; 
   d="scan'208";a="46937698"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Dec 2024 22:50:39 -0800
X-CSE-ConnectionGUID: 2Jj3EfYrR56qmhCKEdZ3KQ==
X-CSE-MsgGUID: ZoJT5fJwTzyOgtmwBPpAig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,262,1728975600"; 
   d="scan'208";a="99402504"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Dec 2024 22:50:39 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 24 Dec 2024 22:50:38 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 24 Dec 2024 22:50:38 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 24 Dec 2024 22:50:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PCS1PrjzK/wpGFRUSs6Uca1IHgkByWkNaEKJbCmJa5SbQ8c4eukr/ivKkqTqb6R06kUO/i6/QH7uj63XaZjN0nN03zLoplbNJOGBeQS8s/pvj+x2Nw5k5Z9zrSskcmVbkl40biFtCo2Es0GL7ZkigncDlq0c8WxfJYCO6+3xTKvQvT9OPeviKXr0kQSfN296NcBMeJS5IEkWHi0f6cUxjvHWyGaogVCVpi0n8amoM+OLTof4S68e3xDFJ3HKLsc2Jifyytn+y4vEfmLdoTGmYTAGdolKi3cg6c0M14nHS+KPPKJoMJ96HhGj0nKoKJUbYqlJeibYEmxhqtrFwnFKyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CaMOonbqt1nAF1xqeKDodXJlFkw7xUdPDEUGG6l8FtI=;
 b=E0lQvXfOT2K6mjosR2WS47Z0+2Tdhq26jaeDU32GpfJFzNaNAGcKHC84jxVj58JnQ7xLJ6LUbEKFDzEwf8xZzC0zoh5acTQcOF86pF+2Snd3FElz9upbdEGNzioniIqpKy+AtsGNTreP6ezLDX64D9y9duvfsfJyDGxD1/ip83hsMCmSvGBmn3nmq7HRxPvl4oIBxXP1RLSWGJqRfHVwm02ZNzq4NxggoDHLRxXcxrCgMVUDMX1lMyMTDdTsbh0eJ2CMmrUOzhryVqmxwHTt31bZocUIQZw3DXRprUMvp4lFPXjvnFuUrZekYrkyy9sIK3ViTU7o868mvDHHVWACZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by CH0PR11MB8143.namprd11.prod.outlook.com (2603:10b6:610:193::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.21; Wed, 25 Dec
 2024 06:50:32 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%6]) with mapi id 15.20.8293.000; Wed, 25 Dec 2024
 06:50:32 +0000
Date: Wed, 25 Dec 2024 14:50:22 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Eric Biggers <ebiggers@google.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Ard Biesheuvel
	<ardb@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<target-devel@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [x86/crc32]  55d1ecceb8:
 INFO:task_blocked_for_more_than#seconds
Message-ID: <202412251418.8e78094d-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SG2PR01CA0155.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::35) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|CH0PR11MB8143:EE_
X-MS-Office365-Filtering-Correlation-Id: 34997cb9-6313-48a0-6d4a-08dd24b06d19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?jyg0NBi+Cbkq+cVICBigSpDwmZcZxiJzzHKi8al9Raloa4Jbt0BiyN3dBGSS?=
 =?us-ascii?Q?wBcOc/FEVMWAWVdygdZoYYMqCvB9LzwGlJ/MxKdm85UxhPFA+jhR4aZB1qFc?=
 =?us-ascii?Q?670EORbFzQ2d3cXpo4411E4x4wgsXMtJj57hXE/NpgRiKujL+CXa+Zb6o1Hp?=
 =?us-ascii?Q?cY4PEiJ9kCwEn4nUuo0m1nltsw+AB8tkB6vleyRnbYWFcmCQwMwBdNx7NzaR?=
 =?us-ascii?Q?Syx6BcmhAUvXqxvNV6DSqiZVJp2cP+2k+VNa44YsD8C230Xw6nqjQKh5ckoB?=
 =?us-ascii?Q?ezl/4M15JEI8uUN9sCWRldjJxhJY9ceLmRqudpqa6lW9MH9Ct8w6egU8n6rK?=
 =?us-ascii?Q?Klna1BD1wfQ9hhOsvNgYlYAqssz2lyzwpMrbMrDkXLUCoZB9wJowd5Ixk+8Y?=
 =?us-ascii?Q?0oX6mCIri0vLbisKQ7RBN8n4wTLzsS26EuRKbEWXb2K06Hal+yFQ4KxNEBvu?=
 =?us-ascii?Q?903IrzFmOEte6PlvUWbCd7qJxduT7gGPnxWGzCef0tNzXoTCocuhBwkHGkJ2?=
 =?us-ascii?Q?iFXDlXSV+I0V6gIK/lKz7v05CtqSHU1zDNn4ZXcrnbtBo/L5Urfzy2iawF72?=
 =?us-ascii?Q?kZbynpuaSIAqZ0viX6BLXU1+dQXZdwXn4g5h8qsqegF/yS/5dAqm+0mJl5+R?=
 =?us-ascii?Q?0K8BLBJXMIGoxGWpVX5vPOO72s7+EanB0Uf4yFn/eDQfDZyamvBNOTOKCYkv?=
 =?us-ascii?Q?zyA0KfovzD6SQZTxOthmiHuGHzCBS8JWXMZ9DNuYsoTjqKRzxvW0AlmIpy7x?=
 =?us-ascii?Q?o+R6z1CS5fFuyj50SBpTJulJFP9Z/L0nDxYPJex6ENcNJphn2EMx01To0W/J?=
 =?us-ascii?Q?0vk/5YsXgPHQKv0R3Ou1EJyuXAjiHxaEkCBkf9O4wEtFSQMV5hYgIimPHM64?=
 =?us-ascii?Q?HPNO0SG6mGdGLFnZrkZp/rxu/JD9k/WyShCVdo2kl7N/vbYZ4fc4DOguTARp?=
 =?us-ascii?Q?JtYovgjxhM6rDuyfMoYnODXOa9frddz1DU99O4D1juYugDHir7N2vwuwNSDq?=
 =?us-ascii?Q?32NrB1VLZHUsBFER0vF+gIaeVUu9yo53hMPT9mi9sRgUATkVjMCC4DZl5EhA?=
 =?us-ascii?Q?KyAUWU5zKKqSMU1/bAhEtY6Hi2odgJlBXIF1ZqrQk+h3g5V48tH+fNiZyhcr?=
 =?us-ascii?Q?FtiSuHt6mTRuVqaD/+MsozHhSQegiugwIRyeuMUcjzJr8B8RZUXPc/KZUTSz?=
 =?us-ascii?Q?nXO2OQz0eQgblgZ7rHcGv9uPRDguFccg8aJCIkCkFGr1SreblV+MvsmbmHCA?=
 =?us-ascii?Q?PY5KOGzlJ1P04UY7bzbKbf3/zSYfU8S8vY/v62ikQzT2Q/piTDKotkj8b52H?=
 =?us-ascii?Q?pli7hfthdSWRzzWBTX4mj1M9UKB6YAd9K/yNlcY3zSvczg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ea/E5nJ65ByvrS5RG3XNM0Th3K4h6oPKUGOhihSsB5hBpQ69DFT4zKfU1Qpc?=
 =?us-ascii?Q?csR/RRjucNDNJ7+s1/WU+UMBphzOkAmL3KyZN6kHDLs8P+y3hyt+mnDgNzxI?=
 =?us-ascii?Q?/uDR8nDF94T3o+SI4m/ma2Va2OntJQadO48aWF1Q8bnElnzN/4dh9gRK6ImE?=
 =?us-ascii?Q?3eYco7jmFldB5FRaCQnKXHAnxpMl+wpJzOTC0E2tmQzPb4AFwxIWYQWanGgl?=
 =?us-ascii?Q?rMIIdMxN6L044C2vhbW7rtpRloiwHm2smM5gpKH1gtheLgzfQeMrwJa+oTm/?=
 =?us-ascii?Q?zBdZMS72501d7fwY22hWufYaWgZ5tCmFvOmikUzOrKWmuGDBegvedC4tRmJ0?=
 =?us-ascii?Q?nUb0PFmzAUvlYuHcTtDMnH64WQFYxM/YewXvg8nWHaIv5ctfoKTooUct7W9K?=
 =?us-ascii?Q?SogYzUNF5R6rWMJWGqsHIu+aFVBkswPkForE9v9bZsvOHL8/PZ6kdVoI0kAN?=
 =?us-ascii?Q?2t+ousUr8EffPQ+vHA/K5/JJ9SOCPYcnk3ht1z3V1wbP1fxM5Nqnk2oPq/B2?=
 =?us-ascii?Q?m5+ZnfiRYkm2BSq78+L1UBSrYf+tmeVaNDfk/8hcrWNwgMAp5HkzR3px6QA7?=
 =?us-ascii?Q?8o10Lx2YyafOmmgldDikh4oxCP9Dr+wGphojGnkMfL1BQAvo10LAcjvMTxBR?=
 =?us-ascii?Q?tWFrq5mupq6JS+Cb4RK/Uj8+2wXhIk5hXDxVNPLTn2rAb/L7H/+2xjU0JxAk?=
 =?us-ascii?Q?0uL8x5vO0eJWWGC1+XYTBNMJKGCejYTE+TdgOkg5zhni1qDPLOqYXa7jbwy0?=
 =?us-ascii?Q?JHntfR3VrPuFaThKI94/IbyQrJG/Ju2dSo1YRp8Z3YNoA55EyUSbfkLYrHkq?=
 =?us-ascii?Q?L0NO5zRthrejmw07m9PeIEeym00slpj1E/N6KjQWRdScKnT7ybthKQv/cEy6?=
 =?us-ascii?Q?YDGCUYhZM3KY63kX14JueuVkBKa874oBdxK0NI7oWwgXIQo6uuRGeMS98HeT?=
 =?us-ascii?Q?Y791wm4SjRriYvq3+5afqhbwZnNZUc4cgC75Lt90lKo6UpZTzmg6l3F0uaQF?=
 =?us-ascii?Q?O1v7fPAdJu7QWSe0LHWs9GcrNT9Nv1fW1+LAvSJcmmhp2JBPg2n0nYiKOCef?=
 =?us-ascii?Q?iSgzH5GV0/Ge1ueP7oCa72E5+xShDvMtDDAHr1LGfFMSM6qGFpOW/fOSuJIj?=
 =?us-ascii?Q?IafeCz4bxjMyRRU79/EckHHkobUsOtIdEifiXKRQ1R/rx+isk3z3Z2FMc+CK?=
 =?us-ascii?Q?EeUnCHq9nvhCL38/Wf/dM2OnJStzBJhsKauYv1YBV0gsta1Q0XbriMf1YWtE?=
 =?us-ascii?Q?NVehJi8rTClLs1wgo4bkdbbt1lQFQrnlLecpjCDUO62yhl+usoNUxFbsLIbt?=
 =?us-ascii?Q?lGMeAs4H8yubGpJo31uL5rncnqtRyBaQl0IWTiJ5Y59J1/AUwRgFkTiZOWTy?=
 =?us-ascii?Q?RMcXKMH37OtJE3xLEyZi+RA+xKssLve+xPUpLMy95oHQDhRhZ12Ve8VzNMmq?=
 =?us-ascii?Q?wgY1HPJwWLvgyUCdfT7X4fyERmpQRArhhOs7qnqjI1uejBmc3dfbH91M+Ciy?=
 =?us-ascii?Q?1sRafx2nADVtcXIhSziGKCBpTckmsRG8SKnQeixPCf8RXuJxzbWz7wD8EcgZ?=
 =?us-ascii?Q?aLqSfPvrdjrppyXvfgtvFKq0iZB9cGNFpm4+KgEErFjzQNNQYjQORjz4qbfH?=
 =?us-ascii?Q?ZA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 34997cb9-6313-48a0-6d4a-08dd24b06d19
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2024 06:50:32.1396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X0tidnHMr6hcc18tuPTVlqVVLnOsMYSCQ/kDEIFyGBG0mLAhcC87MNNL6zKsXoZ7BUehB7r5rhAF1nkVYDUoOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8143
X-OriginatorOrg: intel.com


Hello,


we don't have enough knowledge how to connect the changes in 55d1ecceb8 with
the random issue we found. we tried rebuild kernel and rerun more till to 200
times for both 55d1ecceb8 and its parent, still observed the issue on 55d1ecceb8
but clean on parent.

1e6b72e60a5a16dd 55d1ecceb8d6a5c9ceff7c65280
---------------- ---------------------------
       fail:runs  %reproduction    fail:runs
           |             |             |
           :200         29%          58:200   dmesg.INFO:task_blocked_for_more_than#seconds

the config diff is:

--- /pkg/linux/i386-randconfig-011-20241220/gcc-12/1e6b72e60a5a16ddda9c0669da7538f497838d0a/.config     2024-12-24 17:07:56.621157765 +0800
+++ /pkg/linux/i386-randconfig-011-20241220/gcc-12/55d1ecceb8d6a5c9ceff7c6528075bd0ce4e8366/.config     2024-12-24 15:40:46.814065639 +0800
@@ -5700,8 +5700,6 @@ CONFIG_CRYPTO_HASH_INFO=y
 CONFIG_CRYPTO_AES_NI_INTEL=y
 CONFIG_CRYPTO_SERPENT_SSE2_586=y
 CONFIG_CRYPTO_TWOFISH_586=y
-CONFIG_CRYPTO_CRC32C_INTEL=y
-# CONFIG_CRYPTO_CRC32_PCLMUL is not set
 # end of Accelerated Cryptographic Algorithms for CPU (x86)

 CONFIG_CRYPTO_HW=y
@@ -5798,7 +5796,10 @@ CONFIG_CRC_T10DIF=y
 CONFIG_CRC64_ROCKSOFT=y
 CONFIG_CRC_ITU_T=y
 CONFIG_CRC32=y
+CONFIG_ARCH_HAS_CRC32=y
 # CONFIG_CRC32_SELFTEST is not set
+# CONFIG_CRC32_IMPL_ARCH_PLUS_SLICEBY8 is not set
+# CONFIG_CRC32_IMPL_ARCH_PLUS_SLICEBY1 is not set
 # CONFIG_CRC32_IMPL_SLICEBY8 is not set
 CONFIG_CRC32_IMPL_SLICEBY4=y
 # CONFIG_CRC32_IMPL_SLICEBY1 is not set


so we still make out below report FYI.


kernel test robot noticed "INFO:task_blocked_for_more_than#seconds" on:

commit: 55d1ecceb8d6a5c9ceff7c6528075bd0ce4e8366 ("x86/crc32: expose CRC32 functions through lib")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master 8155b4ef3466f0e289e8fcc9e6e62f3f4dceeac2]

in testcase: trinity
version: 
with following parameters:

	runtime: 300s
	group: group-00
	nr_groups: 5



config: i386-randconfig-011-20241220
compiler: gcc-12
test machine: qemu-system-i386 -enable-kvm -cpu SandyBridge -smp 2 -m 4G

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202412251418.8e78094d-lkp@intel.com


[  996.907142][   T25] INFO: task swapper:1 blocked for more than 491 seconds.
[  996.911246][   T25]       Not tainted 6.13.0-rc1-00013-g55d1ecceb8d6 #1
[  996.940897][   T25] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  996.960487][   T25] task:swapper         state:D stack:0     pid:1     tgid:1     ppid:0      flags:0x00004000
[  997.029537][   T25] Call Trace:
[ 997.046615][ T25] __schedule (kernel/sched/core.c:5372 kernel/sched/core.c:6756)
[ 997.060058][ T25] ? async_synchronize_cookie_domain (kernel/async.c:317 (discriminator 9))
[ 997.070156][ T25] schedule (arch/x86/include/asm/preempt.h:26 kernel/sched/core.c:5865 kernel/sched/core.c:5885 kernel/sched/core.c:6834 kernel/sched/core.c:6848)
[ 997.079936][ T25] async_synchronize_cookie_domain (kernel/async.c:317 (discriminator 9))
[ 997.090893][ T25] ? do_wait_intr_irq (kernel/sched/wait.c:383)
[ 997.109522][ T25] wait_for_initramfs (init/initramfs.c:767)
[ 997.118460][ T25] populate_rootfs (init/initramfs.c:778)
[ 997.126493][ T25] do_one_initcall (init/main.c:1266)
[ 997.136390][ T25] ? do_header (init/initramfs.c:771)
[ 997.147147][ T25] ? rdinit_setup (init/main.c:1312)
[ 997.160654][ T25] ? rcu_is_watching (kernel/rcu/tree.c:738)
[ 997.178488][ T25] do_initcalls (init/main.c:1327 init/main.c:1344)
[ 997.195442][ T25] kernel_init_freeable (init/main.c:1579)
[ 997.199167][ T25] ? rest_init (init/main.c:1458)
[ 997.208072][ T25] kernel_init (init/main.c:1468)
[ 997.218814][ T25] ret_from_fork (arch/x86/kernel/process.c:153)
[ 997.225966][ T25] ? rest_init (init/main.c:1458)
[ 997.231504][ T25] ret_from_fork_asm (arch/x86/entry/entry_32.S:737)
[ 997.240527][ T25] entry_INT80_32 (arch/x86/entry/entry_32.S:942)
[  997.318483][   T25]
[  997.318483][   T25] Showing all locks held in the system:
[  997.346428][   T25] 1 lock held by kworker/0:0/6:
[  997.350161][   T25] 4 locks held by kworker/u4:0/9:
[  997.396160][   T25] 1 lock held by khungtaskd/25:
[ 997.399871][ T25] #0: 83f91ab0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks (include/linux/rcupdate.h:337 include/linux/rcupdate.h:849 kernel/locking/lockdep.c:6744)
[  997.478673][   T25]
[  997.501376][   T25] =============================================
[  997.501376][   T25]
[ 1161.445030][    C0] workqueue: psi_avgs_work hogged CPU for >10000us 11 times, consider switching to WQ_UNBOUND
BUG: kernel hang in boot stage



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20241225/202412251418.8e78094d-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

