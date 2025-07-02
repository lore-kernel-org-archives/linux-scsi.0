Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7D713AA53
	for <linux-scsi@vger.kernel.org>; Wed,  2 Jul 2025 06:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751438535; cv=fail; b=ejQoIpPFpWVYHHohWQctJu/RHL7kNEyZEACQ7zG/VAlJ/W1WPfC8VcodCcTvde0w2kjF9kMcKDGCZEBiC/JMAtXfaxEO2aRaONMQ4xy38ry9qXr8a6WQ24+KaacNJmdOtk3V/3+qc5nWfwsd+NyYR0uiU8u7A3BA1XTa9JStdtk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751438535; c=relaxed/simple;
	bh=14sSykC+cSYLh3scQzYE4eAnbvLBSApCx4LkRDw5IeI=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kA/QqdZfU2HjTdm9QrfAaYxaWTS+s5M/5nyCEwiEPLSyHtoAKe8gro6GkABxlA/RJY6g5iZL96ALBeeO6DMeMXrTxDhCpb7g1TBFAUzIK5/sw+p2VAnlDIkKWZgkilEWOy1GSDqNbNkgfEsfIERYfqi3D+LrhH9FPwwsxoB+uq4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xo4ikHS5; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xo4ikHS5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751438532; x=1782974532;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=14sSykC+cSYLh3scQzYE4eAnbvLBSApCx4LkRDw5IeI=;
  b=Xo4ikHS5U4AbE1i2VNcniNEBsZ4irzXM/HTe+f8qqDadbBP0NKMl9rEH
   dd5q+9CMwDKzOKsRpuNL/ftyt2LiKJZNrEYNFjOBcwRZ5kdimOU35wDJR
   N1nL98PVog3PdFV0VRO7SEda0IQSI8b3f55txl/yvl521TvUykFT9CG6Y
   /Hq0U0R5D/WWgaKRPbtmdVzuCYZJqL7A2Dvmigg8k6iWnojQZagpeo9mG
   rEn9vpDxTbZvFV+54zSPItEA6F21sG3ddTU9RUYNhoyXXndqI951m86H+
   6xGtHVXMcqHLvWJHqg7YNCMlOtc0/oXesZ6gF/YkaJkFXWro+IkXlJz7r
   w==;
X-CSE-ConnectionGUID: ZGM+bHjCSC6nAA3YvdjUSQ==
X-CSE-MsgGUID: M52+h3H2QMegYVrmK6Yu0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="57396624"
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="57396624"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 23:42:11 -0700
X-CSE-ConnectionGUID: 34Pokk+XT+yxfTC3OWXduw==
X-CSE-MsgGUID: UUrHXma1T+iDuzeFV4FwiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="153454894"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 23:42:11 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 23:42:10 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 1 Jul 2025 23:42:10 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.88)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 23:42:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xUjWtT6w8QyCOHEvp8Bfv5oKiqqa25ZwimSM/xruMxFe93G+3JtI3yTQCMruOXiKMF8LoKzrPF4uvp1NV0HMtWnoj7HslsaJrAdejqsIUYbhmS8+InEDoD8h9n8Hi5TqGeGkpeAyGwLQVzkHhzpIrnZN9x/CJZ4vjf+J1rievtTQoy62B9rp4CJU0XrLNTxKhgDY8WWDYgaXLJWpZJY1+zYIKVYJTynX6Xkum1kNSpDJklUjkzDuceuDfPMTX9VKW1rjoAoLl6EDqYsF6yhPy3++U7g85wXEuPfA7gpOXMTijPd0Ng45jyLOv5FkZZ4bmiMVB7x0RP9BJJjVhULL6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hPL2gPS4gXEvpwOMM9NQLARXatpW2vK8LvBgwDpL95o=;
 b=W7MfQ1I8numtXCC0E0UwE5ysP9sgZhwcEAIcnk0g+1B2/kbewMFLO8UbgAwdN8Tf+48GQbmaE/LxyMSBLAX2w8UE3ay9c44Drft/i/Q/RftPm8aqTfngegPuKkneJMg2IQz1rjqDXhQwLFRIRvzIjV+Ci1K0MJs0j1vs2+EGK6dfCgYCJnrQZG/ynQDDDK4DACshV4bV6JrUAB7RVdbtfMwyXbNNAtASUQsfmZYoJP6OIUCpapOE5/XhBoyDauYLpjCfpleokHapv5S+NSAzwMlnW2ip9QnHZojqrk16jP3bP6Tl137lYQYxbLO/UFlSLqmj8T3WP3chERAXWzYKkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by MW3PR11MB4713.namprd11.prod.outlook.com (2603:10b6:303:2f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.20; Wed, 2 Jul
 2025 06:42:08 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%3]) with mapi id 15.20.8901.018; Wed, 2 Jul 2025
 06:42:02 +0000
Date: Wed, 2 Jul 2025 14:41:53 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Shankari Anand <shankari.ak0208@gmail.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-scsi@vger.kernel.org>,
	<James.Bottomley@hansenpartnership.com>, <martin.petersen@oracle.com>,
	Shankari Anand <shankari.ak0208@gmail.com>, <oliver.sang@intel.com>
Subject: Re: [PATCH] scsi: sysfs: replace scnprintf() with sysfs_emit() in
 sdev_show_blacklist()
Message-ID: <202507020840.90a6d3bd-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250620105344.455283-1-shankari.ak0208@gmail.com>
X-ClientProxiedBy: SG2PR06CA0223.apcprd06.prod.outlook.com
 (2603:1096:4:68::31) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|MW3PR11MB4713:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bff70e9-5bc9-4f6b-5921-08ddb9338d87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?zw5rqKBcJH1JqyCj5+TO9UWOsjqpnxNGclULOBfPtf81f59qpH+Ed0d3AHeV?=
 =?us-ascii?Q?gBNLGWKlEkYRIe4lhDgpI32fLhDSsHtVIlvD3Cq3sbfbbwD8H+A6g2tfHjS6?=
 =?us-ascii?Q?N50b9egiOKA3MBSW4RUUBiKWFBdQXFqIybXgrWjK+hn0SLTccK65apLq1TU7?=
 =?us-ascii?Q?Y+vcwePz4C7QQ2gDwZW7auP/rwf5YY0GFXHc4iww+d+3xThP+VhyTiCZE/jD?=
 =?us-ascii?Q?rv5DBppSaiNAh9s9x1uihguNgEVkcI2I5Zwcv8zMLDehJGxzVsRezqyhgVve?=
 =?us-ascii?Q?XQLuO1tdTHBxlU0VIhjRcecZADxSDDnICVLZCfKH++/5CUQnxrLfKOC9gPh1?=
 =?us-ascii?Q?WwYbG5GaY98GTsv+BRg1VJsyKYvtbZ2hljTSqEd38zkTjhUmpLqCWtz5fo6a?=
 =?us-ascii?Q?zjvLGO/PY3ZDh2bgfNLIsX8ZTbtLyKwKf7fp/n7/Q1JkzUDL+AY/A1Ctj17V?=
 =?us-ascii?Q?xostbN+paK3FPgPO4gTAJgw578U77Vg7E/7owMumwdTStmLnm3OIqg541Ft0?=
 =?us-ascii?Q?0BKG7z/P/YN98rUeNdiOwXpjTunF+TPRspnO2rP4tByqbWnYEXIt1t4NcWME?=
 =?us-ascii?Q?qBmuyWgxhIVh3s0edsJYHnWQiUQWZ0EQd6QhOicgUxzx1jDqe9uGtilqF52x?=
 =?us-ascii?Q?88BAM93OTUUW9KOFOGU9v2RTiViRlpO7WbGVz/7xKCOZ1EetCLGjRX0rQrQX?=
 =?us-ascii?Q?fUEjVlLjhf8d22zNtlzI4DiyRDDf1Ux+TmBJKFcfdTcss475L+/3RP24cDWE?=
 =?us-ascii?Q?+HuKhb6bR9azsbBSWa3u64Kw1vZ8yvsUYvK7jTRg5grKyDgxHHTkQ4AvLp4Y?=
 =?us-ascii?Q?tfKkMxFS6Op5iRXEDcXsL5Y+x8TPNg4NscRUIxDQwe5ZU2BLXRq+1nbjZw8o?=
 =?us-ascii?Q?qnOsaLOYYgw/nYUlB3hII/Jzoq+W5+EClTIQ0S2OXVVMm+gVZ1uraTiugE9J?=
 =?us-ascii?Q?Zsa3XnsSXE5xBxvjBA/v9rkJXEeu3r6l98YWbKouvdQty8uHk6xDwK/3W0Sx?=
 =?us-ascii?Q?IbAKI0F1h2Gor+5MpDyFhRYkYaTFFmyHEDvSR3Awk3AlAr8MeLrjam3pC0g/?=
 =?us-ascii?Q?iySPmuUFR75eUyx7I0vKIt5K5tq7AJTfmiLudMnIUu7+w/dzwn+Nc/DSwGp2?=
 =?us-ascii?Q?CMsbXV+2323uTYyZ92lezxpL2I1baAGMdC4mfw+9rUTW1xccXTT4d3l5ZMXE?=
 =?us-ascii?Q?JKG9zRfNoTvo1GN0Txk3XhJXOWC7sPYM18u2aroMOLArQChHgrm9fZH3qvGW?=
 =?us-ascii?Q?1m5hZdWJx5OrWNwhcAo5BtpR30lo13TsHuGWkXKx0rYaKWJf+w2h1v8wamFp?=
 =?us-ascii?Q?cfdhoz+RRnJU8ZV+YLNsI73AcO6X+aaFF0GJjz508VS61J+/DbrK93t0ntE+?=
 =?us-ascii?Q?4A603pNKqWPbRgCi2GKt1xxGQGFY?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zzCDXWCR4lBBTYRhoLsrFWJq1mHlxOsJLUIpxtS6CRPilPl6HwQTMSS6lXTH?=
 =?us-ascii?Q?H51OHqITRVW12SYiF3274VF9OI9lhWtDJ9j2gZdfMrMuW/FMe7henfkTpnQg?=
 =?us-ascii?Q?kWHIa7NIKNeL7K4wvC7JYVicMAXYCFfWxti4T2UxGuz/DfckeOfjTWnKUBIt?=
 =?us-ascii?Q?PjY5VqvmH5+I8uH36M7kyXKH0KSuQSOlwFA0YGjM6t/t/QPvWIepYvU8gQJQ?=
 =?us-ascii?Q?6fBdnO+OzvIZ6oU1Vt4llJwg9DN3/7GS1+7Iuf7s45zK72oAuFJZeRgGmIKC?=
 =?us-ascii?Q?gr4IDz7+O0aPiOFxU/K20KUVBt6AGWcXhDR3uhWmZpij9fjDyYMV7izbooOn?=
 =?us-ascii?Q?gLkk4ZMh5Zgu98+DdgSOGcWRk9roskKM+DFYBAQr0Oy5Xuu1fumN2SRqxQEi?=
 =?us-ascii?Q?4A1xyU0uH3qJGilcPN01Ynck1Pe1xmGq02qDCzs+1tpQVVxgQP9voiQMl8AB?=
 =?us-ascii?Q?2Inc0tRo74foeL2nn0mE8qG+tpzOEXIuH2wxikhhxV91fFO1ugHHk+9pEgJV?=
 =?us-ascii?Q?fnthk9QiEAC89kQ6xZznlOC07+pNsJy4hx1D12XUf+n1dVIlQBWqqfZlBrBD?=
 =?us-ascii?Q?M745p912QCHjeUdubAymFzypPa4WIboS2aOpXat1L6CCYpJ6HOjRi2vAE3c/?=
 =?us-ascii?Q?iUcRlfk+L1jtPh62aQqay+kQsWeKmjj9uQz3ulhKungc4tvyunmZ3S0rSjfy?=
 =?us-ascii?Q?VfT7mYXopu5/1H73lzWEd4BHonHovFDsDGhPq6Em4ILRjjCm20/Qd9iyvtka?=
 =?us-ascii?Q?nL3Bvcs/a/pcyMQqwXacvt8McAlwq1XX5R5KU4DPHslVxLnGcpWz6BG2q8Ls?=
 =?us-ascii?Q?8F0uxCHhqjce4WyKuOPod5R45bQzTqmb7guriEBCPUY8Mxxxua0uC41qVgkr?=
 =?us-ascii?Q?y0rS8s2LB7czYb33kFDI99Qrg6JHEyvw4CHJgRduY2ufZyjW4ZECGFcVyYOc?=
 =?us-ascii?Q?ixPkXxm50s+UBlSJ+kQO4E/i8mv6LKdqgqxY0SMHKXYm39Acy0yCbPtoySC1?=
 =?us-ascii?Q?v/veETlRYfzQS0ZQ6+/F5k6HPRmRKpXEnp2fO6nGWpvrr3snTgB7H07n+iLY?=
 =?us-ascii?Q?ZsHEp6iMaQ9v8i7ldFgwB5YeB+1iZFFLbi9Li9+GTDcOzHvwjrMzxpkjdiH/?=
 =?us-ascii?Q?SGkoELtG/mqlxNgUef7JvUxp3y+IotBUhrnVK2p59onGNPIGQQ4yC5fN1aFi?=
 =?us-ascii?Q?l8E62YKZil12v7vOiq0wTfbQHm+Grpo7hF6Dj1gmiPjObpLi9z7wgJobrLu3?=
 =?us-ascii?Q?5EEMgw/j89hBmlwPefFvBgcdXsGn4O4vjvY3M8GROUIhOElA+WULvpQZDbmn?=
 =?us-ascii?Q?8F+cgw6cpMlpR3IAdSo5G1XffuBMZyTib4ChQFU53g3e7Cn/NgK24vn+VW4a?=
 =?us-ascii?Q?IVS7sllDBhE/C7ij+565qRahfYmkvrq11AwhM6Co2GQAjUwYaJ1SY8MY3i83?=
 =?us-ascii?Q?n18+Nmb6SKKskEVbMx+NXSyGrNxFYMFfwZVyHkGJIsCtFGB7juyGLn7YW7ie?=
 =?us-ascii?Q?6KolZi98M0HH+ncYMr0Zw/rwaOsstXdwbIwK901Vy2HMww/uu8JBoPigYUaK?=
 =?us-ascii?Q?jps4W5Q448ZuN/veIiZse4VL5ObiaWPBr6Os8u8immej/ukN+evSMwf2iC6Z?=
 =?us-ascii?Q?LQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bff70e9-5bc9-4f6b-5921-08ddb9338d87
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 06:42:02.7869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ul+DjAHMG++n088VEdjJQppZTdY8ojD0P/Y8wqfDIMAfHruLZ7tO2G/1qXPWUJygiWkE4gqXvO6vEF0sHHNyTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4713
X-OriginatorOrg: intel.com


Hello,

kernel test robot noticed "blktests.scsi/005.fail" on:

commit: 2f688d0bc23ecf97b4f5255343dc891b196d1360 ("[PATCH] scsi: sysfs: replace scnprintf() with sysfs_emit() in sdev_show_blacklist()")
url: https://github.com/intel-lab-lkp/linux/commits/Shankari-Anand/scsi-sysfs-replace-scnprintf-with-sysfs_emit-in-sdev_show_blacklist/20250620-190212
base: https://git.kernel.org/cgit/linux/kernel/git/jejb/scsi.git for-next
patch link: https://lore.kernel.org/all/20250620105344.455283-1-shankari.ak0208@gmail.com/
patch subject: [PATCH] scsi: sysfs: replace scnprintf() with sysfs_emit() in sdev_show_blacklist()

in testcase: blktests
version: blktests-x86_64-55d3d61-1_20250617
with following parameters:

	disk: 1HDD
	test: scsi-005


config: x86_64-rhel-9.4-func
compiler: gcc-12
test machine: 4 threads Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz (Skylake) with 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202507020840.90a6d3bd-lkp@intel.com

2025-06-30 16:29:51 echo scsi/005
2025-06-30 16:29:51 ./check scsi/005
scsi/005 (test SCSI device blacklisting)                    
scsi/005 (test SCSI device blacklisting)                     [failed]
    runtime    ...  6.188s
    --- tests/scsi/005.out	2025-06-17 17:08:29.000000000 +0000
    +++ /lkp/benchmarks/blktests/results/nodev/scsi/005.out.bad	2025-06-30 16:29:58.087863341 +0000
    @@ -1,7 +1,7 @@
     Running scsi/005
                               
     AAAAAAAA BBBBBBBBBBBBBBBB 
    -HITACHI  OPEN-V           REPORTLUN2 TRY_VPD_PAGES
    +HITACHI  OPEN-V           REPORTLUN2
              Scanner          NOLUN
     Inateck                   
    ...
    (Run 'diff -u tests/scsi/005.out /lkp/benchmarks/blktests/results/nodev/scsi/005.out.bad' to see the entire diff)



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250702/202507020840.90a6d3bd-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

