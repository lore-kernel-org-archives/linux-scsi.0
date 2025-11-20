Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05A621B9C9
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2025 06:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763618404; cv=fail; b=Ta8eGK8E7Fw50fXwxMg3kMfvVGRsnTYYSZxNzrRAptxtHy4JsCp/rjUR/mbVItZgJWGRMgsnG55lXSYyvBPOHUY46iIc0zUuHf9hjgUSd4EctEeQbU/hXzVAN6CGkCf/rvF+A/Fe8kK5D5uGwjfeU7LB2zmoGPBJywHqj014zpA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763618404; c=relaxed/simple;
	bh=JfnX84ucmXizTic0m49Ha5isjfPHX4cAVU3UyDFGzWo=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=g5iZCNI9RiOGDSePjENu4FMOD1g2dOYR67SIoifwjEsJhGaoqRRmON8Lw2x9v5SybbcYdvqdkdD6dTH5P1WydnCFVUltZEZK8I10QYmCluJVi2lrU9/BPRii6ZuhgZVRiS4SiyJm6rLmIipG0akkU5fDPEsHTaOLB/ZV/r8leyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D8Ji8dt7; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D8Ji8dt7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763618402; x=1795154402;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=JfnX84ucmXizTic0m49Ha5isjfPHX4cAVU3UyDFGzWo=;
  b=D8Ji8dt7tn/sfHbDS+YGNV4nIe/fbJGCm1P26+AAktxrpUHedVE772r5
   iZjQPipCLR53qRvvyBcEfSCjT08owdKMbwBCNE1A8H5xi/+8pCQ0KCFnU
   vjfCYVTKmie2eleubYhwpTQ+mSwDsMiIdfY7flYnwOf6L25FkINgjP2kU
   wRWkhybLYLBJ0ZBgffujq0qQKau3+WFGWHcY6niNZxFUok4NrbLm6B1jE
   3oF77JPmRu27QFswdXQxXFyOP34ntLuu43LW1DGET+xFCan6bhYA0Tleb
   K5C9pZgoUg6EyZNHPKCZbTXv5h6I+m+yid/Xo8AV8plBH/Rx1B2Y5vUY3
   w==;
X-CSE-ConnectionGUID: 8DunaprhRfaMi/OLeIJ1Kg==
X-CSE-MsgGUID: f69IjO5KSgGHazDnFmKFaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="76003311"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="76003311"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:00:02 -0800
X-CSE-ConnectionGUID: hH4IEwwJRPeRvvv6SRcI5Q==
X-CSE-MsgGUID: 5W5pu1dHSNmIWuSZtkqeNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="221915149"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:00:02 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 19 Nov 2025 22:00:01 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 19 Nov 2025 22:00:01 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.6) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 19 Nov 2025 22:00:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OSAgFlk9GTNfNQhRJ8hD4W3t8QbfnQZsShQdAs6BbC0WrUZ2V4DvSpZqGd/nxSpAB27HFjRs2+F2INiEjPWeIeQiRKJgHJ0BU1wSWMkeYI1vL+iW5F7T7NAlHD4Kb2wAhPAEqCbhZB9XjSB9A6qUNCadmgGpAEVmxmk2xrWNOj89mjBhHglyNxOSaUVooc0QIVdZ9DwD49qP9+9T+LKq7HChS+u6GY38YSbjcKv7NlwDtFSp7P04RREkVQvw3utg5A7jQcyCfJnQp4ZJD5oqwPrO5xKpdO6KB4yuScXc66AAbPIHrLI9ayRLDGAPlY0t0uWBbPDFdF+WSww7YYEldQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FcUZrKvEQZZAyWrYmfDh+AusSS7kxYAEciXt27Rl9Ew=;
 b=AO2JVDJWziLH3Y/foSjZPCkoeedZVuY+puP6hUEJ4goAOY7JWn/Ix8vion7TjBpZWhY92s+C/7sgosGH5I58hnZiHWzVJwcyyqD0+XdSaI1BlND8+V4flSWwIO0xIKYAXkiaKO0lLyOxs14ntWdyhubuYpYpEIhx4C1MuIxOWLlxXCUcn0Leu+kantXQL30Oisg/5V7uBcurdecp2wVZrbE2TPEv2SmXWpOvBl2k8u2oYUGDPQyhm7zu+DJhJ1kGDyhVWhdFKF/jvijs61QchDqqYdGoQxN5OpSqDlxPkCNijYE4oQfEJ/nZ8ar5PJGRHSA/jPD1QmR7GGjEGrRkyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SA2PR11MB5068.namprd11.prod.outlook.com (2603:10b6:806:116::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 05:59:53 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 05:59:52 +0000
Date: Thu, 20 Nov 2025 13:59:43 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Bart Van Assche <bvanassche@acm.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>, Ming Lei <ming.lei@redhat.com>, "John
 Garry" <john.g.garry@oracle.com>, Hannes Reinecke <hare@suse.de>,
	<linux-scsi@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [bvanassche:block-scsi-iops] [scsi]  fb5a7f1b2b:
 INFO:task_blocked_for_more_than#seconds
Message-ID: <202511201331.ab9300d2-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SG2PR01CA0184.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::9) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SA2PR11MB5068:EE_
X-MS-Office365-Filtering-Correlation-Id: 51abcbf4-2b23-422a-ad6a-08de27fa05e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?EnmqZalUUlhiRNw41giuMKan2Makt/FsDJc/LO0BS872asCLRuyrRBSubMAR?=
 =?us-ascii?Q?UAFIHjSrobE8Ze0JW1qnZoYq/lzGSJgcSlOBZXkVt8oDAh3zz75cNV99a8c9?=
 =?us-ascii?Q?ol91o58tTyN0yu7PkYnkT57iU5DEIvSU5H7Dnb0kwXyqNyWiKsy+oP82F7UA?=
 =?us-ascii?Q?a1RE3doI0UWu+IDCBvYQq29IY8f0+Nw7rLggASGK6CF/AMQvfSA0VL8QrCd5?=
 =?us-ascii?Q?DPahqRfDGmMg7VoWLgHY5cW4mqJgODVuD5q5ABWgu1vOvXNWoQknD3oIP6PY?=
 =?us-ascii?Q?W1p8zrsOhNtjElGhVwIqbn8+JmHMsctMkA3ctJE2yTNxe1XSmpUXOahumB7h?=
 =?us-ascii?Q?O7aHlVfhU7zYHpCndkIto1PiSH532A6VifwAiHLToxb0oWtdovo1qgViV0Re?=
 =?us-ascii?Q?8QdOheaqGopH2XK4Cnq15tiVGPViCIY1AALGZrKCRo1Hw5EfGtE/gWeu9IYV?=
 =?us-ascii?Q?hAZ/XSz7QNMO8jFawv5yRJTiYP2wAJb0TayGPJhcHIko8kysYsUWGRUd7L8A?=
 =?us-ascii?Q?cVqSdOqRy2Z/cEoQelFZexgEuy2QUIXcHxwmGm7svQNm4a6165kQss5RHW26?=
 =?us-ascii?Q?jhn01iKzZslBXCVo+adwh594be7KjJiouzH6DR55hj1g9GzKG1Nodi824oZh?=
 =?us-ascii?Q?/g/RS3DYHyCuKvp6VffLfJKs3CGwjT1enohd7Z5elXT913efSnS/V48+oRqz?=
 =?us-ascii?Q?eG33iRMoOOKb2aj1OxU3JAV9g8G5HPzBVTpW0PAoNTZF08PyJv0SUdZBtJrP?=
 =?us-ascii?Q?PA7FsEfZS6C0yHYbY2lshw3AnSEHDy6KqTm1ful3aGX+Maepo6bl1SWSSZ6T?=
 =?us-ascii?Q?A3tnftM109kjHPXCNpx7HEaqfVg32yw8KmWaW7Gx5dWi4GBLm82NWMSAeg4k?=
 =?us-ascii?Q?14gHltSNaKzAkgDQ8rzDIykUyuJe+j33FLrUtcgE/ojkWCX35bhT20DhHfjI?=
 =?us-ascii?Q?BL/DigT0gc6Vzj8oS5DfUbQh3ZZz/1cOh/YB1eUcIf7kM4XK5rzgxaOMg6AP?=
 =?us-ascii?Q?A1ZuW0ZWbnZKExU47SFki4S7o27tM+HwJCnX61lh7D3HxsJN+yeZq/oeNewE?=
 =?us-ascii?Q?2dqu6mrPVN+h46itqQKw/OVVyNX+Amc61Ore0z5lWP6AtsMnNR79R+n4amdO?=
 =?us-ascii?Q?l3+y95CZwsSUibyioBme+xVpDxwWOCbH6O7UYWJlAvTDFHgVTYguQ2KKhgVy?=
 =?us-ascii?Q?BIxl9j6oH3y6dxeIrRRAO308BY1NSMPv0ZivMWfXZ1nN0OmJCpBZiZwvwix3?=
 =?us-ascii?Q?/vV6QW6JDhau3ppsWWI+fKiWMYkSErNL+au53vHS2yToNe/VichcF+2oTXoz?=
 =?us-ascii?Q?RQCYxFlcSj/ARTaK1Q5aqtb7KN2gMo1+MFYLY+ZfPwUBe0HwneKVd68PBMw8?=
 =?us-ascii?Q?qjO/y7k/nAXG9H6PMPoGGMqa1Dsn/vzmN85EM8vqjcDRloA0B9YHI0kr5z3W?=
 =?us-ascii?Q?pUC943cH3TWVGA7rvgr2OEF/xMt+rjImN/d4VaguFcStXsFtf/Po7g=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5SfwmQLe9hmqIOUMCzhVwGLl+FlSP7OOHfHLitplrg83w2nn9jM6KE3G637a?=
 =?us-ascii?Q?VHv9r45OKnx38At7WCLRloJDa/UcA2r1VTmQYeCEldW9tTvWjGvNKugZGSTg?=
 =?us-ascii?Q?LwA50/mFRm43civ1zwtQNi16UvQnBS94cQKsMjH7FCxWn6V94btg5LVk2W9M?=
 =?us-ascii?Q?MgzczLTp7YBcBVdPUiGIjp0L5Atj1kp+GIe7b8iLQO9vPk52M3pKhNeu1cfZ?=
 =?us-ascii?Q?FA+Vq5o/H6qpZdvDvmEup/ILBCDC5tfJn5sn3Ft94ZEvhcfXOCR/isi6qtSn?=
 =?us-ascii?Q?m3y0YAqxCl9GPBcrxUaAOu4OUQ30isWjGbEGrGEk/7tD1Y9AvXP/CLkE/H6T?=
 =?us-ascii?Q?9DPJwurb8M2H9stv9/xjJ3MuNsyOjhs9YWve/CDisqKVgw51hloWkHDXEqen?=
 =?us-ascii?Q?/GDFMw26VQJ4D14Ru+LgCaOEJSBY1zO+YExbOyEgb77ntzvKlTUXl/UC2sSQ?=
 =?us-ascii?Q?gfp0bybdjoSYm/kStWYv+Luq6fZrLIiHRPVNLQx5jtwMSi+yu7bSJV3Eftj1?=
 =?us-ascii?Q?zcQR7eN1lA5ukJgK0FDfFrAPwnID9yAnumOTnjzAY8XPgoNTDjs2e7+0THQI?=
 =?us-ascii?Q?+6wIMKHktlLyXH6ak0Qqj2XUupJxByr/Y4pW8Cgf9GkTjBokhqp1GQvLpBob?=
 =?us-ascii?Q?/j3ow4Z2OMdv3Di1gwPcHuap7hPtztkA6pZqwDgNN3muXIwz71Y3i+OLrI42?=
 =?us-ascii?Q?vBcVt8PKwzfe0NgUy0Xixh45IGf7slzS2lRVI3m59WtSW6fiCh+VRxpwJdvK?=
 =?us-ascii?Q?0AWEA7qykYJJb2QIdL+ITfXI9U2/vfS5EttksvRctClHiwaJPUYaNG9o7pT3?=
 =?us-ascii?Q?8MxkS+/wVBG0AmrDiauQuhJvDsgAYi/mux0MXVPU1znLyY+qQ61Ehz04h66V?=
 =?us-ascii?Q?ZK1aOHkXb+ctGJKU655ONKYifg04D5WQWb/ypna3g0SsXQPnDQfIwk3Fq3XL?=
 =?us-ascii?Q?AeBUcnKzvkedpE22nksC4a1gsjjKILb6xiKxvbkkkWIj3z3ZxG+d0Yeim+/9?=
 =?us-ascii?Q?fvtIP9CvDFvRdEjCdwN6tqTVFtCnv4FPk++ycQfPowc7AKAbKAf5DPpW/OWG?=
 =?us-ascii?Q?sH82FhZbOgtgweL/OI+sdbhbJ/iMKmgUdSbFviwfyEOQSwwGX4/Gm8zfFak3?=
 =?us-ascii?Q?hqdhxG045QKRH7jqp/7L2BS3XjzZ1e960sbjoKxjyULU2+75O14+kEORwLbG?=
 =?us-ascii?Q?XeSJ09i1ufGjTc7suFLbId9MC++LaJet0wf0R1j4FW1XKsX1PEec27GiwdDb?=
 =?us-ascii?Q?DMoRYOm0vQnQUuXfoUi1hALWMsLT+tUSNTVvbbQet6n4lF/46Pw5GscyEU22?=
 =?us-ascii?Q?CAQWBsj7NR/kBHIqvSBTjoq67Nmehx5mMnAxbUCbjKO/n3HOCGOx3Jml1OIh?=
 =?us-ascii?Q?KoqeepTpzm5u0bRIKEEEqeYFInuRzII6pDL5zX1mXY7awRVVaxqV9ALhfr7h?=
 =?us-ascii?Q?XPV+I50vCjlCSOmBl5YNKDIu7KpxEYQdptBLQG1C6hXNRKH8OJJHvpflT7Hy?=
 =?us-ascii?Q?uAp7mPCyDg1ze4uvDtufHWrr5V9wJEiEcskMqIehiH4cGqhXB1iHE2Kd7VJR?=
 =?us-ascii?Q?LqnHPqo+rnCy0m7v3oi2vPzhRY9TngzOX8qWv79iFsSqKe2VhzIDn1y94yHW?=
 =?us-ascii?Q?qw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 51abcbf4-2b23-422a-ad6a-08de27fa05e7
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 05:59:52.8791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zdm1zQRMLT8cJ7hFYorj22EltspXAIzmMlOhkk3K4m7KspEXyu8b4Y+zlUBtl/lbq0Z/UMEwyrD2CNoB1UYLfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5068
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "INFO:task_blocked_for_more_than#seconds" on:

commit: fb5a7f1b2bb3442ab270404463be4f0d7578295f ("scsi: core: Improve IOPS in case of host-wide tags")
https://github.com/bvanassche/linux block-scsi-iops

in testcase: boot

config: x86_64-kexec
compiler: clang-20
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G

(please refer to attached dmesg/kmsg for entire log/backtrace)


+-----------------------------------------+------------+------------+
|                                         | 0997980774 | fb5a7f1b2b |
+-----------------------------------------+------------+------------+
| boot_successes                          | 12         | 0          |
| boot_failures                           | 0          | 12         |
| INFO:task_blocked_for_more_than#seconds | 0          | 12         |
| BUG:kernel_hang_in_boot_stage           | 0          | 12         |
+-----------------------------------------+------------+------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202511201331.ab9300d2-lkp@intel.com


[  972.310477][   T31] INFO: task swapper/0:1 blocked for more than 491 seconds.
[  972.325924][   T31]       Not tainted 6.18.0-rc1-00154-gfb5a7f1b2bb3 #1
[  972.328555][   T31] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  972.331938][   T31] task:swapper/0       state:D stack:0     pid:1     tgid:1     ppid:0      task_flags:0x0040 flags:0x00080000
[  972.337218][   T31] Call Trace:
[  972.338813][   T31]  <TASK>
[  972.340068][   T31]  __schedule (kernel/sched/core.c:5328)
[  972.347907][   T31]  ? prepare_to_wait_event (kernel/sched/wait.c:317)
[  972.350544][   T31]  schedule (arch/x86/include/asm/preempt.h:85 kernel/sched/core.c:7012 kernel/sched/core.c:7026)
[  972.352679][   T31]  async_synchronize_cookie_domain (kernel/async.c:317)
[  972.355241][   T31]  ? __pfx_autoremove_wake_function (kernel/sched/wait.c:402)
[  972.357773][   T31]  wait_for_device_probe (drivers/base/dd.c:777)
[  972.364734][   T31]  ? __pfx_autoremove_wake_function (kernel/sched/wait.c:402)
[  972.367566][   T31]  wait_for_devices (net/ipv4/ipconfig.c:1452)
[  972.369621][   T31]  ip_auto_config (net/ipv4/ipconfig.c:1510)
[  972.371610][   T31]  ? __pfx_ip_auto_config (net/ipv4/ipconfig.c:1477)
[  972.373727][   T31]  do_one_initcall (init/main.c:1283)
[  972.375828][   T31]  ? __alloc_frozen_pages_noprof (mm/page_alloc.c:5183)
[  972.378358][   T31]  ? alloc_pages_mpol (mm/mempolicy.c:2416)
[  972.380533][   T31]  ? new_slab (mm/slub.c:631 mm/slub.c:3250 mm/slub.c:3266)
[  972.382406][   T31]  ? sysvec_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:1052)
[  972.385612][   T31]  ? asm_sysvec_apic_timer_interrupt (arch/x86/include/asm/idtentry.h:697)
[  972.388164][   T31]  ? __pfx_ignore_unknown_bootoption (init/main.c:1329)
[  972.390842][   T31]  ? strlen (lib/string.c:420)
[  972.392746][   T31]  ? parameq (kernel/params.c:90 kernel/params.c:99)
[  972.394571][   T31]  ? __pfx_ignore_unknown_bootoption (init/main.c:1329)
[  972.397175][   T31]  ? parse_args (kernel/params.c:153 kernel/params.c:186)
[  972.399055][   T31]  do_initcall_level (init/main.c:1344)
[  972.401133][   T31]  do_initcalls (init/main.c:1358)
[  972.402859][   T31]  kernel_init_freeable (init/main.c:1597)
[  972.404994][   T31]  ? __pfx_kernel_init (init/main.c:1475)
[  972.406897][   T31]  kernel_init (init/main.c:1485)
[  972.409309][   T31]  ret_from_fork (arch/x86/kernel/process.c:164)
[  972.411068][   T31]  ? __pfx_kernel_init (init/main.c:1475)
[  972.413229][   T31]  ret_from_fork_asm (arch/x86/entry/entry_64.S:255)
[  972.415613][   T31]  </TASK>
BUG: kernel hang in boot stage


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251120/202511201331.ab9300d2-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

