Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FFC1EEA51;
	Tue,  4 Mar 2025 05:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741064734; cv=fail; b=hCwfXttSNWMARwXIW72sdsdSrnWYDwOg9ztM8i+NEQEm+NcGqLXMl4iwpLPvj9zZz3sc2xYUbPj8bRA0qEUfDX+LezR8WLJOMgiFeF6SrhcxZXSVeLq5G4nXIN+FcBigFDxawi2hYY+dThCX8fIYHq20BXVhP8rWOX+YtVm6oTY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741064734; c=relaxed/simple;
	bh=lrLaAAk4ePKi0GM+Za7C+h5KQ2tanzxdel/DtW4FTPA=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=siRqZWI5a8EmSrbeqh/IJd5NMlwQifO1GyUKqficJB5jfpm1zGdBZOg7MyqHwWBM8qN9JqHM9KvNXHoDQDTzJbzk4CIrjqn76utXDmS7Ax5+DUU0yDBQ+d854JLvLXZ1xa7O+AZFyizn1ITHA222zVREHNXcQjv/wOcPn2QcIGg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G2UHNgZU; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G2UHNgZU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741064732; x=1772600732;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=lrLaAAk4ePKi0GM+Za7C+h5KQ2tanzxdel/DtW4FTPA=;
  b=G2UHNgZUqvEslHrC9iPcEd7eYjdBzHIsZbRUvQEyWRfzNuyZFsbmCtKI
   yHMFR4kMtnQyvjqKOFq7Qmn2OjbwKgQGez2kEIOjOh03fLOM6MVU2IR/U
   4vDOxa8Hk/hVc9lUJmR08XMr4IjVQDJtVvaITUY1eVYAnWjT64eNzhMP1
   MVRaBfjN6+Is0UpJoyfym3d34aDm6RfFxAZFaGumcnz3E0w6jNkurozvH
   b1FdxeqXMQrvbPkHduWB6YqTo10DFzNA7psrFNG+ePUb7BydOmpFJ9hTB
   sBCwx+hRtaXxtxJ2RSK5lk/24vKAEMVN6SotFKVwba02h6hOjf6wZs6dW
   Q==;
X-CSE-ConnectionGUID: u7lHyovkSQqzjCyz1iM4lA==
X-CSE-MsgGUID: mfF5DkDURamb/BRXG8n/ww==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="29552819"
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="29552819"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 21:05:31 -0800
X-CSE-ConnectionGUID: F4RA/WSrT0yi9ViYGLmRFw==
X-CSE-MsgGUID: sYxIp1nlQiC7W5rdiyhACg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="149169900"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Mar 2025 21:05:31 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 3 Mar 2025 21:05:30 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 3 Mar 2025 21:05:30 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 3 Mar 2025 21:05:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hXOBSKSxOoyPenGBirWO0/rx3u9DgpRAPjD3Mk8q4F/RR8IzBVjD8USX2uSZoexPHsKWFg/O3WqE1fb0wHEsjUZ5ddgRdzWQgFvjYYtC5K0habWirOxbNED+EUX68AzWQiv+y0fL9qCGDhhW7y0laYwY9w4UwTPqtHtiXHKqnfG8ub40GFBz2cSsnjkIykOXBTH7FduNhkPpkW8JMnblpSU4UXapkEbPqo3vKqa5z6gJgja04yT44HSzuH9SbG8fGxnsoKUQJ1AdSn4aES9cBQPzt/OA4iRTUfteD3FSvgh6HiGFAaFV5uBkJZnSH3kjYDEz7EkNJyuC8pNy8FZuEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iy+ojv4MdaKAiFztgHvzzrfoFuf4VM38Y7HDx66lZXQ=;
 b=I82lGyxv0E17ZfLHbiFfrtBJx3ylCg5zSdOiGHkOvtw02yq8pCM0Zpy0K7NZHWtV9hd2Q+5oHkCQU9EIjXNd68pkqcws450gVarSYqGevikbFU442HOGOVhFguPZwU/FUqzAfd1XhhCrJxjaV64I3ATcXUvhJ7fdUqZ0bo+qix3S01omeRsM7CRjDmxBW1SB0ThyYqdDJKQimqxHCKvZOao+vaAt3XYmLyGl9QXgDhfZZ7lnU5ecdCZDrGdOUOrikJw5xg6LFcUNhjI5iRKPwgZj27r/MsBKgBIDHxUG1Opqr89KbsV6el+sDANHNrQf7cCS7l2n+hUFCrIyqX3WEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8587.namprd11.prod.outlook.com (2603:10b6:a03:568::21)
 by CH3PR11MB7273.namprd11.prod.outlook.com (2603:10b6:610:141::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.26; Tue, 4 Mar
 2025 05:04:59 +0000
Received: from SJ2PR11MB8587.namprd11.prod.outlook.com
 ([fe80::4050:8bc7:b7c9:c125]) by SJ2PR11MB8587.namprd11.prod.outlook.com
 ([fe80::4050:8bc7:b7c9:c125%7]) with mapi id 15.20.8489.025; Tue, 4 Mar 2025
 05:04:59 +0000
Date: Tue, 4 Mar 2025 13:04:50 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Chaohai Chen <wdhh6@aliyun.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-scsi@vger.kernel.org>,
	<James.Bottomley@hansenpartnership.com>, <martin.petersen@oracle.com>,
	<linux-kernel@vger.kernel.org>, <bvanassche@acm.org>, Chaohai Chen
	<wdhh6@aliyun.com>, <oliver.sang@intel.com>
Subject: Re: [PATCH v2] scsi: stop judging after finding a VPD page expected
 to be processed.
Message-ID: <202503041036.ad427cb-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250227060618.15787-1-wdhh6@aliyun.com>
X-ClientProxiedBy: SG2PR06CA0227.apcprd06.prod.outlook.com
 (2603:1096:4:68::35) To SJ2PR11MB8587.namprd11.prod.outlook.com
 (2603:10b6:a03:568::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8587:EE_|CH3PR11MB7273:EE_
X-MS-Office365-Filtering-Correlation-Id: 0dc40801-7ddb-43c5-49e0-08dd5ada1cf4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?fJClI5VrEw1+ErSGzJZZibtVAnXJOlND5dkho8hqWTMtby6JduPPNWZ19qlX?=
 =?us-ascii?Q?df+HQoRAFtpaQ7K8uaeQvJ7qtx3sCdy/EQWr2KQrzcoDOmZdfmJZVG1t1jrK?=
 =?us-ascii?Q?05tjl0ozVnIKXTUfYqDKutHXRxNPJliNeu9ncq7dzSuLKk0IXLGKVXycyiCI?=
 =?us-ascii?Q?XVMb+LJNrFm065JJix/ae4jgEHxxu+3DFIamHEINxgxPqz2afvvawDhwiVGX?=
 =?us-ascii?Q?BY5wcaRj6B5shmKZO76QTIlqx3LRWgsNuDA3vSTtoKUmpuGbUckIWYYasQOu?=
 =?us-ascii?Q?Q8HiKdjuGmrv8YEJIfIg9BiYKVbfH5Ag6mnelFzf3XwH33owjrgL/9pU+vbn?=
 =?us-ascii?Q?CouQxOrgoHMD4cjXskOZ/LRLG+C9VSBXoOmD819WxTgim4YY4oxagwNzB3pL?=
 =?us-ascii?Q?03STh10IF+8tXXoW8AV7eCEhKgcxYpwD+Z3Y2W1RNtOGLkRlGr3C34KtXwFj?=
 =?us-ascii?Q?FKKOVwjfFDePabi9sj2VgOXjrsZN+ES60+C+yy6b5/YNnmgfthy4/WtWbSjh?=
 =?us-ascii?Q?hMz2lcKqwIBNXzq4xKhQdXWl3mF/DQGyiKWZ652OU5Ferrk1jWP//kTx5OFK?=
 =?us-ascii?Q?ryJSsmIgtYKoYE1L1psC/k4O8i4F6/iVUPRcAd75JzXFbpBU+AyS/1mDSbPw?=
 =?us-ascii?Q?hHe/5HgbMTGoLl5sqXlZ/ETg31TquatrcqqQMVB5uyCzHdzgMWaizk3azSY4?=
 =?us-ascii?Q?yyo5qoR5X3+hqwWKc1KAl0crFcFpgCW0RdCMGaQ35zuj3o5gfCbm4EMEa+l2?=
 =?us-ascii?Q?XhHsBXZ352J2jim/KAB4p78W9b7VPGArdRm2c7gw0qc7HVmTRltJnn2/9Tmp?=
 =?us-ascii?Q?g40uP+AMS3L4V0LtS7aL9B7KUX6oHSQKJz632gF7mOemlGiR1rieS7dFOKGc?=
 =?us-ascii?Q?ey+XDpuf9ZbYtF/gyBW2mqaNNpK9CDLBul2LIbJe+gQwf+lZMafFX3YTw5u7?=
 =?us-ascii?Q?N4cOEuy0LrecwogSKi7VKVe9jz66HpCjiTiYoak4pB0DTTrc0mk1Vpxy0VCE?=
 =?us-ascii?Q?LYmp64ZqtDmkZQTtOmFp2v6F066Ue7BDyTpXuUO0kyknx+dDTEte+MvY6oUO?=
 =?us-ascii?Q?ic6s+NnNrFy0RhAA1OkwRv6choK6L9A9xISnD5g3PLyDnBdf3Llwi4uA+Ojh?=
 =?us-ascii?Q?B0+VvwjaTPcsx71ZJ4vIzpRpXMJFu5VLTCIMLR/wgBnyar1M2NzZ2FGnRqbM?=
 =?us-ascii?Q?ltqFKSJCjXj6mZfqe4KIG8fhJqv0bEQfXJ4tMQGXKEt7/YyapqqUUOVP+65O?=
 =?us-ascii?Q?GbHQjl26Np8eAWa8YGjT4BqsEre+Akr4ufIZ5F3Twp6IUdI64t3qB/a568c+?=
 =?us-ascii?Q?flcFTahT64FlqvdzI0AlZFKKGdk1DJKY3fsY6A3/4UKQgA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8587.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fd0bicG+8XXe4TdSzULnTvxsGKnX/C+X5bf3kfkC9D1Of9Wd848K+LRWHpff?=
 =?us-ascii?Q?PXKGVc/aXP2RJ+75/7BOXDXN1t3fi/kjHjL6Vx5ADlTHDPCY5EgKRGv8Vpnt?=
 =?us-ascii?Q?2VHCgQCvzeeLVW60vJUwz1s7+mKyIwChZNmU5fOXI67mJ8DbwCTpt05n07tX?=
 =?us-ascii?Q?ei0MtNJhqk0V134UF6y3jTnG2MTaT6ybnfzTpRxaA8d30JAvq19+7I109dv5?=
 =?us-ascii?Q?TM6jMQQ0kdbdtwPmQDoFLVNQWxesswZUUAqZ99UPP0wMk0DGvx6ovGApwtAX?=
 =?us-ascii?Q?ARNJNNyLkV2Dpfq1ulD8lwv2iqhcgzahsNjVWguSsDj1kdO17N5em4DPLikl?=
 =?us-ascii?Q?XthmhY5+ZdMre2tHKczL2bVsFwC/o07qiFhw4o4DQO030ygza8HRYtn17w2n?=
 =?us-ascii?Q?1+++PV9vB6RqVHtGghb2AxUIaRiYPuhFlNs1kdBFIG0iBuivww1fW26NeuJX?=
 =?us-ascii?Q?zWiV8i9yux2IBb1jcNq9H2vF0Xz8RMPVSGp/vrTDMpsoXQBUbf9x1OUM+5zy?=
 =?us-ascii?Q?OXIZRlOsIifdrv6Th9HmAvMKb+zDJbGMrUHyA0GBBdiHUJsBMvBhIhWwwJvF?=
 =?us-ascii?Q?T+t4DgI44yZh7mvC119XcHyNxl5IdaDi3XPEM8voTcCEhApz4YZ4i6av6PZI?=
 =?us-ascii?Q?DWSsuh7P5su8AVlSc5DVHnK1LKHzkLKkIDPzlXUbKrTGf+PqArOs4dgbN7zc?=
 =?us-ascii?Q?64wrmBgTXHp+0cULu1pEkmSqQdnkBFm+m+3tck91DZnfJHzW0zlj6W6zdgl6?=
 =?us-ascii?Q?G4oOiex1pnxS2YNwksfFnnsipLedsopIBMmiHbqi89fBWqaxgtvA5zE+REZF?=
 =?us-ascii?Q?OJXHgnQhWi0ZvkAAtAcgdBNMMrn+TgtVx+JoEV18r0L+o39EWisTRgtvfjYp?=
 =?us-ascii?Q?6aex+B0EJ5WHFn2tVBXxEXyC3Q1z/TepKe3KBk7zZEUorIU963jsRW7cST3O?=
 =?us-ascii?Q?/63OLhlv53oaEqP50nZdE4Rg0kR8bBkaOyiVktG7nbF9pKfo5Ywx7oUG+yxJ?=
 =?us-ascii?Q?1/e+rZZ8eCmMcIdV/iFg2dh9YwNt/hr+wC1fgKRsIawEy6v104eCi8yyVm+V?=
 =?us-ascii?Q?1ISPHEPeamJnuEETuqu3xR4tAtf9CXDAxHyIP+hktLHfjm7K9kS3kc6NvOrT?=
 =?us-ascii?Q?10ew4DlV0e+dGYSKYlF5Tl+XQ3et8+yrEa+EtTCsVkJBPjYHldno8akOzY/I?=
 =?us-ascii?Q?4tt/+EcaPZcNvdO5tqCmoitEKyOc/CipjL90K0eHW1jNpeCCFzZYEBUj3p5v?=
 =?us-ascii?Q?KaK+4xJhGrWuUrD69vVW/J3hdtS3HI0tkxw6+CIeoQ331zMh3GM9+tU13Hmk?=
 =?us-ascii?Q?AZd7yLXDVPpKVn/X2yIVIspMI0auGFnvv1MrmFLOeGwx9tIM5b8GMGJ6cRcm?=
 =?us-ascii?Q?a+wt6OyT4Tb7Sn/oah1A13I83eLDtlaONvDBgKQzDaDMefdLWFT+Oga1227T?=
 =?us-ascii?Q?uaddLYpCi/8tLBskSetiKk8oNtFe35bUrSWeGarFRT8NPkzCa/9vlVzGJGe4?=
 =?us-ascii?Q?0yu2sgIhPktWVFG9tQ/9UfT6GImcQdzOejGWOLoH9A6DYcxj9hqFoXU0VRRW?=
 =?us-ascii?Q?PPgN5ZQAlJKjIWtXFc+bknE1/r4bYdrq+jgssz1obp60zi5JoxODd1wihZmx?=
 =?us-ascii?Q?jQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dc40801-7ddb-43c5-49e0-08dd5ada1cf4
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2025 05:04:59.2869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1IpDWOr/BneoQZ2Aj0MKjgmpQHDHMim5vGgM/teZgaTS12AefQa13wS4sin6NBtNHbJQYnVDmF6Io6VV2MRHxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7273
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "BUG:unable_to_handle_page_fault_for_address" on:

commit: 8e44a5176a631b6b5ba7efa557d8b1895eb56d85 ("[PATCH v2] scsi: stop judging after finding a VPD page expected to be processed.")
url: https://github.com/intel-lab-lkp/linux/commits/Chaohai-Chen/scsi-stop-judging-after-finding-a-VPD-page-expected-to-be-processed/20250227-140720
base: https://git.kernel.org/cgit/linux/kernel/git/jejb/scsi.git for-next
patch link: https://lore.kernel.org/all/20250227060618.15787-1-wdhh6@aliyun.com/
patch subject: [PATCH v2] scsi: stop judging after finding a VPD page expected to be processed.

in testcase: boot

config: x86_64-rhel-9.4
compiler: gcc-12
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)


+---------------------------------------------+------------+------------+
|                                             | 5d51aea463 | 8e44a5176a |
+---------------------------------------------+------------+------------+
| boot_successes                              | 12         | 0          |
| boot_failures                               | 0          | 14         |
| BUG:unable_to_handle_page_fault_for_address | 0          | 14         |
| Oops                                        | 0          | 14         |
| RIP:build_detached_freelist                 | 0          | 14         |
| Kernel_panic-not_syncing:Fatal_exception    | 0          | 14         |
+---------------------------------------------+------------+------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202503041036.ad427cb-lkp@intel.com


[   14.245211][  T124] BUG: unable to handle page fault for address: ffffdeda9e000008
[   14.245852][  T124] #PF: supervisor read access in kernel mode
[   14.246293][  T124] #PF: error_code(0x0000) - not-present page
[   14.246740][  T124] PGD 0 P4D 0
[   14.247003][  T124] Oops: Oops: 0000 [#1] SMP PTI
[   14.247375][  T124] CPU: 1 UID: 0 PID: 124 Comm: kworker/u8:3 Not tainted 6.14.0-rc1-00076-g8e44a5176a63 #1
[   14.248100][  T124] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
[   14.248837][  T124] Workqueue: events_unbound kfree_rcu_work
[ 14.249283][ T124] RIP: 0010:build_detached_freelist (include/linux/page-flags.h:243 include/linux/mm.h:1297 mm/slab.h:211 mm/slub.c:4941) 
[ 14.250299][ T124] Code: 8b 03 48 89 ca 48 01 c2 0f 82 ed 01 00 00 4d 89 d3 4c 2b 1d 74 b4 57 01 4c 01 da 48 c1 ea 0c 48 c1 e2 06 48 03 15 52 b4 57 01 <4c> 8b 6a 08 49 89 d3 41 f6 c5 01 0f 85 dd 00 00 00 0f 1f 44 00 00
All code
========
   0:	8b 03                	mov    (%rbx),%eax
   2:	48 89 ca             	mov    %rcx,%rdx
   5:	48 01 c2             	add    %rax,%rdx
   8:	0f 82 ed 01 00 00    	jb     0x1fb
   e:	4d 89 d3             	mov    %r10,%r11
  11:	4c 2b 1d 74 b4 57 01 	sub    0x157b474(%rip),%r11        # 0x157b48c
  18:	4c 01 da             	add    %r11,%rdx
  1b:	48 c1 ea 0c          	shr    $0xc,%rdx
  1f:	48 c1 e2 06          	shl    $0x6,%rdx
  23:	48 03 15 52 b4 57 01 	add    0x157b452(%rip),%rdx        # 0x157b47c
  2a:*	4c 8b 6a 08          	mov    0x8(%rdx),%r13		<-- trapping instruction
  2e:	49 89 d3             	mov    %rdx,%r11
  31:	41 f6 c5 01          	test   $0x1,%r13b
  35:	0f 85 dd 00 00 00    	jne    0x118
  3b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

Code starting with the faulting instruction
===========================================
   0:	4c 8b 6a 08          	mov    0x8(%rdx),%r13
   4:	49 89 d3             	mov    %rdx,%r11
   7:	41 f6 c5 01          	test   $0x1,%r13b
   b:	0f 85 dd 00 00 00    	jne    0xee
  11:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
[   14.252909][  T124] RSP: 0000:ffffa8e5004ebcd0 EFLAGS: 00010286
[   14.253973][  T124] RAX: 0000000080000000 RBX: ffffa8e5004ebd50 RCX: 0000000000000003
[   14.255143][  T124] RDX: ffffdeda9e000000 RSI: 0000000000000177 RDI: 0000000000000002
[   14.256313][  T124] RBP: ffff95f9e637b028 R08: ffffdd3284e15900 R09: 0000000000000000
[   14.257464][  T124] R10: ffffffff80000000 R11: 00006a0700000000 R12: 0000000000000178
[   14.258661][  T124] R13: 504d56b8f995ffff R14: ffff95f980042200 R15: 000000000000017d
[   14.259806][  T124] FS:  0000000000000000(0000) GS:ffff95fcafd00000(0000) knlGS:0000000000000000
[   14.261074][  T124] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   14.262173][  T124] CR2: ffffdeda9e000008 CR3: 0000000167df6000 CR4: 00000000000406f0
[   14.263363][  T124] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   14.264575][  T124] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   14.265747][  T124] Call Trace:
[   14.266530][  T124]  <TASK>
[ 14.267349][ T124] ? __die (arch/x86/kernel/dumpstack.c:421 arch/x86/kernel/dumpstack.c:434) 
[ 14.268182][ T124] ? page_fault_oops (arch/x86/mm/fault.c:714) 
[ 14.269105][ T124] ? exc_page_fault (arch/x86/mm/fault.c:1478 arch/x86/mm/fault.c:1538) 
[ 14.269972][ T124] ? asm_exc_page_fault (arch/x86/include/asm/idtentry.h:623) 
[ 14.270888][ T124] ? build_detached_freelist (include/linux/page-flags.h:243 include/linux/mm.h:1297 mm/slab.h:211 mm/slub.c:4941) 
[ 14.271810][ T124] kmem_cache_free_bulk (mm/slub.c:4706) 
[ 14.272840][ T124] ? dequeue_entity (kernel/sched/fair.c:5488) 
[ 14.273683][ T124] ? kvfree_rcu_bulk (include/linux/slab.h:791 mm/slab_common.c:1498) 
[ 14.274542][ T124] kvfree_rcu_bulk (include/linux/slab.h:791 mm/slab_common.c:1498) 
[ 14.275389][ T124] kfree_rcu_work (mm/slab_common.c:1576) 
[ 14.276255][ T124] ? finish_task_switch+0x85/0x2b0 
[ 14.277161][ T124] process_one_work (kernel/workqueue.c:3241) 
[ 14.277998][ T124] worker_thread (kernel/workqueue.c:3311 kernel/workqueue.c:3398) 
[ 14.278830][ T124] ? __pfx_worker_thread (kernel/workqueue.c:3344) 
[ 14.279670][ T124] kthread (kernel/kthread.c:464) 
[ 14.280456][ T124] ? __pfx_kthread (kernel/kthread.c:413) 
[ 14.281263][ T124] ret_from_fork (arch/x86/kernel/process.c:154) 
[ 14.282106][ T124] ? __pfx_kthread (kernel/kthread.c:413) 
[ 14.282915][ T124] ret_from_fork_asm (arch/x86/entry/entry_64.S:257) 
[   14.283726][  T124]  </TASK>
[   14.284397][  T124] Modules linked in: ipmi_devintf ipmi_msghandler sr_mod cdrom sg snd_pcm intel_rapl_msr ata_generic intel_rapl_common snd_timer ghash_clmulni_intel ppdev rapl snd bochs drm_client_lib drm_shmem_helper soundcore i2c_piix4 ata_piix i2c_smbus drm_kms_helper joydev pcspkr parport_pc libata serio_raw parport fuse drm ip_tables
[   14.287967][  T124] CR2: ffffdeda9e000008
[   14.288794][  T124] ---[ end trace 0000000000000000 ]---
[ 14.289744][ T124] RIP: 0010:build_detached_freelist (include/linux/page-flags.h:243 include/linux/mm.h:1297 mm/slab.h:211 mm/slub.c:4941) 
[ 14.290724][ T124] Code: 8b 03 48 89 ca 48 01 c2 0f 82 ed 01 00 00 4d 89 d3 4c 2b 1d 74 b4 57 01 4c 01 da 48 c1 ea 0c 48 c1 e2 06 48 03 15 52 b4 57 01 <4c> 8b 6a 08 49 89 d3 41 f6 c5 01 0f 85 dd 00 00 00 0f 1f 44 00 00
All code
========
   0:	8b 03                	mov    (%rbx),%eax
   2:	48 89 ca             	mov    %rcx,%rdx
   5:	48 01 c2             	add    %rax,%rdx
   8:	0f 82 ed 01 00 00    	jb     0x1fb
   e:	4d 89 d3             	mov    %r10,%r11
  11:	4c 2b 1d 74 b4 57 01 	sub    0x157b474(%rip),%r11        # 0x157b48c
  18:	4c 01 da             	add    %r11,%rdx
  1b:	48 c1 ea 0c          	shr    $0xc,%rdx
  1f:	48 c1 e2 06          	shl    $0x6,%rdx
  23:	48 03 15 52 b4 57 01 	add    0x157b452(%rip),%rdx        # 0x157b47c
  2a:*	4c 8b 6a 08          	mov    0x8(%rdx),%r13		<-- trapping instruction
  2e:	49 89 d3             	mov    %rdx,%r11
  31:	41 f6 c5 01          	test   $0x1,%r13b
  35:	0f 85 dd 00 00 00    	jne    0x118
  3b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

Code starting with the faulting instruction
===========================================
   0:	4c 8b 6a 08          	mov    0x8(%rdx),%r13
   4:	49 89 d3             	mov    %rdx,%r11
   7:	41 f6 c5 01          	test   $0x1,%r13b
   b:	0f 85 dd 00 00 00    	jne    0xee
  11:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250304/202503041036.ad427cb-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

