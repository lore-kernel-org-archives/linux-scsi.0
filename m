Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4872215ADBB;
	Wed, 29 May 2024 02:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716950990; cv=fail; b=A6RxDnRqoaCCmQbDT/35XG8KcvpkJ0G5z20gnygntuJZoKBqPItkYkhoYWaHTZdEPngxzT6P6gisLSHP2nnf5OmZiIoljK0cyIT3Bj0lf2+Ngeb1aQ8UQCqjwc3NXpkBDD55/SegkOsQSIda3BX5Xzgm8aa6hPPqSkOvd5q/nak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716950990; c=relaxed/simple;
	bh=XYzv6pHluo7prOrmYDoJhSjq+Kvel/Rt9D3in0Qa7B0=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Rmfv7wsPFOes6/Nkg7YB09hHzD2qpThrTq8+yn7czNe/LQ53dGb5Dlx2BAQ/vo0Ar+7Fo2jC0YUelk3ei90SLoTfjMt36OaT/YvXkSLu+I2FxJjajS/kFYlvfhRDH/oeA2QM0NZdMt5r/trP6Z6hmzvjx63HfSrF3RbIMjuxP4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Do4NVZvN; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Do4NVZvN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716950988; x=1748486988;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=XYzv6pHluo7prOrmYDoJhSjq+Kvel/Rt9D3in0Qa7B0=;
  b=Do4NVZvNr158VqvPgC4SmCDzo4dhcyGBjkNnX+9L8MDHedXT190ZL63Q
   P7zJwYaR23WFnmtbVEA/E/5r074svphd7LZu3ZUYyyaC1P/B6WyRNRskS
   orLGeM9qadSKYUq65rk/0SV4Phk+HaaLfAsutdUIwCUF0AtsLX+H4G2IT
   MZYD6cGYlcEtljkUc+p/U/iQo/MNifBLxBxmnaMGmQModu8ss5fos1/nA
   395FKqrV0HyHpbr57OIV7bWa3NCo2UQxte5dTVqFVjeXQnrRoTWEz3Wod
   4Y7EWZUOZI5eH4T7ndbc7Gr/VkCG7wdG4mhyoAfmowgn+HZ+KJZXEvHP6
   w==;
X-CSE-ConnectionGUID: jCEWjSH9TGa2WFsheeppUA==
X-CSE-MsgGUID: bvaKmtgISTCCkdliTWSTXg==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="23988457"
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="23988457"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 19:49:47 -0700
X-CSE-ConnectionGUID: Qqlvy25vRR2+ARFnVKxiBw==
X-CSE-MsgGUID: WRCUNIjyT9aS78GvpEDvCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="40150469"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 May 2024 19:49:48 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 19:49:47 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 28 May 2024 19:49:47 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 28 May 2024 19:49:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKF86YmTouzxlWcYsDVW/VWzn3wuhAjU9pLegCGP6qF1a1zifCrkGglOvU5dUJ0nWog4/WHkIDj44Fzvca7+3Ots5YbQkx4LOzAlkWFgJFWjgHzE243sTGQK4yxchv2L/z/rHJkd4adHJlc7I87KBEDODHPvLnNnughFESheUXYRVjeuNjPTtEOqtXrdI5wf/c5JQ4S2j3n0oZqkxYNE7GX4x4kXFAOF204btFQnTokCKTcSap8QUCP52hhA3pHct/eYjy5umEcDlXRZYEbsrGAvvrbPnp+GAsIyhZN+eHKdHgOdpa32I5eRJwAQlE4HX+3IFj4wKDeaLTbfqVb4qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2uUbXs8qQwfEr1ro9fvka74F81Q/m57HTPm5Ikr4ooM=;
 b=maD/cWrHhiO9w/KbluEynOBgFo7d7VEkvNMHbpd/+AuifjV9bXxZkl/PjjUqAB2SjYM16zeBnlfV0F7aCHNwblRKCCloGPufncbGV45IVYgWpTXsvQdOpYQji9DGLripQucLgzN66Sos7+yuWffmPlLGfBQoWdJ/GTimOstFrptv7R/FTgppHZIPqlu+uWuMHm/EYfZckETYuJj4nPfvy/hViAbJ8Cd7r/bvxmAz/mizlQ6GAriqj7Zf88YdN5oo9CEF+tMFguMq+d+mKtXdJQwOQnKYbf45bksacpf8ecmcAORcGnBpGab42AEyOryXtE8T0BaHkwPZxJaa1rbEYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by MW4PR11MB8292.namprd11.prod.outlook.com (2603:10b6:303:20c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.31; Wed, 29 May
 2024 02:49:38 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%2]) with mapi id 15.20.7611.025; Wed, 29 May 2024
 02:49:38 +0000
Date: Wed, 29 May 2024 10:49:29 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Xingui Yang <yangxingui@huawei.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>,
	<linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
	<prime.zeng@hisilicon.com>, <liyihang9@huawei.com>,
	<kangfenglong@huawei.com>, <oliver.sang@intel.com>
Subject: Re: [PATCH] driver core: Add log when devtmpfs create node failed
Message-ID: <202405291031.54c11515-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240522114346.42951-1-yangxingui@huawei.com>
X-ClientProxiedBy: SI2PR02CA0016.apcprd02.prod.outlook.com
 (2603:1096:4:194::9) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|MW4PR11MB8292:EE_
X-MS-Office365-Filtering-Correlation-Id: f56cdbb1-3ca5-4140-5761-08dc7f89fb5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?yOU0oM/Y58Y7N/LL0mTt7L9HdhMv/oRq5AMMueToH8tJWDLy4Tnnkojb0sms?=
 =?us-ascii?Q?TVZSdF9K4qGwVtMijfas4jLLyjJliwghNLXxN+6KMep4GtH69y9kXNIupQKW?=
 =?us-ascii?Q?Yg4YH88klZKCpiNEmoAsevRhtPk39pScpZn4o6Oam2RPhIIoxz5MXBsl7mBG?=
 =?us-ascii?Q?2AhIy+BUfO3pWqTbst4LAP2+aQPEMVJE+xsfIG5FHvcDB/yDltseD49b5sDE?=
 =?us-ascii?Q?EUCYofIm1bVKMlTO8Md0qQQdc7JGQMDpa7/XM2l2LzZfH+4b0jJyKgSi8BdM?=
 =?us-ascii?Q?NN64mWVS9eyCWIsX9+N7BeT9OMO4ertMISLThiIwaUNEtk34ly/i1Cdwe/Gq?=
 =?us-ascii?Q?nVt7rqU2EgzCPsgWXzyXb/NRliqA+XfkpVLm/Zb5PZzF9eEds3wyzboxFUHC?=
 =?us-ascii?Q?w51t9JwILy+UP+wL6Stia1V+v9YEUB+S/xDUASMjN2PWLxwrfQb69Exdjc+9?=
 =?us-ascii?Q?0H0XivRHBsNFks0QShMHytAUYS+IgymjC8ncLjyhvsGAvM5ZrM6FrZivRlYD?=
 =?us-ascii?Q?euVXvjEsaSgOOM1OGDoooCDIanQSjRjeyZUjbrWWqn9CgqNsbU5dIYMFmDxN?=
 =?us-ascii?Q?eFb3B/OA/Uu9dpBGivUgth1xStPEQzi4PEfbHGrarP6adSB4jcuCjcVJlbvF?=
 =?us-ascii?Q?wKO2/f7/KE3yVNG6xqslbpQB8F5jLMk8oRhv1RL5ffyoNGK74nnE74m6Ccty?=
 =?us-ascii?Q?TMXl3n5gE1L02z90xnbAglWpdI+YQNz6GauQhjLFA/2UDdu7iWIe/3jm1BlN?=
 =?us-ascii?Q?ChNvNirt9NCg9MZD+6rktKerEuKHLGb+ZiEkwCTQuqYtSUb0THQPOxIEhpse?=
 =?us-ascii?Q?C8sNmN+tA3VE/2hnaSbSvBHc9a3kYJP15RIjDotdfEgq8UFm9qVGeGQbJ1ZF?=
 =?us-ascii?Q?1ClMdk2cLNpgRgD6ocLQlsYat8loB9RQqzSOERi4RSDHgOMBNGmGT/6gYeFK?=
 =?us-ascii?Q?5QA9ukH3IVPdFhCAMRIpJsZgQMWiAID1KGvxNxQVYaKRev6vKyKwxT0PIA9Z?=
 =?us-ascii?Q?lQSYBsHz/n9yFiYEQOQBGpi6TGbcym1Q1zLJLhcR7E7cU3OU28W4nOR0tRof?=
 =?us-ascii?Q?tZ4FcFizJeOqbEACpdTmLWxFwrnv6t3m9E1g4SaBXTmb19I76bEVC2QZxyO4?=
 =?us-ascii?Q?ybxYoQFb7yNJYlAh7PiYhCtUIvvuQ4igQOlxlossFwjQtInzPjmjZweXPwe+?=
 =?us-ascii?Q?dW1xrBWHDl33usNqZwoTNVWmZlXTB/ZGRlA4kJtqFcWzYdxTApW3/3nLmTo?=
 =?us-ascii?Q?=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b0uuiF5k6DMAUS6XiB1hA3cBFVgYnpdvWrG6X6ynuawSU1sEUp0+7a3m1zSU?=
 =?us-ascii?Q?5+yYZcwMO/uZ40sBaRz72HEgb+031JAltKV+fVJx+DE2wjY5kjHTBjrDQjCy?=
 =?us-ascii?Q?RXYY5DCu/zrwJuBwpeQxsVtmU0ZbSXWe35IbcaHIJtfmGyBm173QbpXtQt+C?=
 =?us-ascii?Q?niobUbHaDVARR8xs2V1rO65qWXLdty5GU3MpAyl8Fs4cb5jkROAPhLrihWxn?=
 =?us-ascii?Q?5ZvgvrE84yACNlzkG2J7V/ZphzV673PUMEmw90u+/502nc+u19MWZWIrTA2u?=
 =?us-ascii?Q?tKFBmHciKNRpsTcjykf0yGnJHbOIwzx2oLWc827n2rj8HzMmPIRV4B9JXmTy?=
 =?us-ascii?Q?o1VTBKinkCXytLRKdlQbKUi6dpy7Va+NsPTPmwtAadH3VEBSeHJdxv3jAT0I?=
 =?us-ascii?Q?waBnRX4ejtrKKLEK4bzSDZ5qW8T89XBz37j2Y2/4GXxB39NNCZGUGuP5bH3X?=
 =?us-ascii?Q?sETSHl0des40IebT4b4ikc893kUG11amDupBcrQ6DJhW3GlPX7bg9X2YGaj7?=
 =?us-ascii?Q?NUa6BxwspkUmHc92+R0tLPov9VDbCKTD32+oO/oTNVnO2qKUOMkM2AyDdUJK?=
 =?us-ascii?Q?lEuDxLt5BW36WM2C6G56qO4t5KiMuuJqwCaGRAPEgP0edLygU/Vn9UN/Ilfd?=
 =?us-ascii?Q?m2Gb3pdz7GA7L1vg95uZ2tgD/7hSX6GONN4sEhAUtxyrmgMaNElm84S7tVL/?=
 =?us-ascii?Q?pqpn1+5RCw1NCFG5XgqHAtdvFvKw53xhFpXvOFiapktW94m6otHqQ6kZYPl2?=
 =?us-ascii?Q?z7UTlyrd8x/HWhTMoeajsSmwF+MGXqR/FWO/3Ha0+mcxY2lRn1cBy0HZNJxQ?=
 =?us-ascii?Q?+MimHoeUFCLonXJqpBI1LIrQxaRMg53x6hRCDkArm0Ug2W5dIZIeoXHCZBUT?=
 =?us-ascii?Q?YuzgDb88hcma489Ur/vcZee6CEiLwd2YsKTuTTRwvg2og6HhMvIljTSG8SRD?=
 =?us-ascii?Q?6N8F32QysWfghchR4+cIOkJBuFavQZfQ7tYW/SXCCf5VovHX7hLWsTBzZH9v?=
 =?us-ascii?Q?jgUCaJ0ydZ2nTrIhhBLNJ0757r3rMFxjnYVALlNACaVs/zdsq92x4EWIgdYo?=
 =?us-ascii?Q?ecL1UKdOpxiUnrIIwR9i00uZQ2nkdQg0NLS3UASrB3EvklL8ADyu+UHv3l9E?=
 =?us-ascii?Q?EMl2l3CUknIreAqRZyiOqCdEhRT/b+kzU3Ris2Hp6BxPAWarSQfnARnVoDv1?=
 =?us-ascii?Q?pCa0HIMpdTxdotZWTAJnpV8aXkJVTej8EbeIf1wRaewBsOKV3vo30/WXXYcV?=
 =?us-ascii?Q?nbdW+f3llVDaWGgsd1SbDitKKDylgX81mWzOn/hPE35KkB5WBpagCqiJfQpo?=
 =?us-ascii?Q?Y/rIDUaxzW9v2hTcrSIcs81SsAw2bDiR56N6LDKXW+fqpnONsP9HVIGw3sDx?=
 =?us-ascii?Q?khymJUA85ld5/P5n/iVlYQjLEM+ZUjgjZeB8gManSOd6xlPetnt4mhoOJSHd?=
 =?us-ascii?Q?2i72SM2GwbwdtGTi8MO2us/2iULze7vdRGgivHzQwe2SEJ1MwHNenmXBjdAQ?=
 =?us-ascii?Q?v3lb3ymhB/SZWB6V1oxMoYuzooqJS4RpZDD7BbzwcaqPQafS36NebHuvEjtG?=
 =?us-ascii?Q?6NF2pqDt2ZBtLv7tnYDF/S3pGWDhl/JD4fNg7MEeKxp/Xyop+N3nS9+xk/ds?=
 =?us-ascii?Q?Mg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f56cdbb1-3ca5-4140-5761-08dc7f89fb5d
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2024 02:49:38.7356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: peVYyNi1fsie8XUj68aE+PUujoO7uGMnf4CaZr8m/VHAzON5w8m75uVGb4iU7EtHyjHCRQpWMrcbx1aWgRWRtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB8292
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "sysfs: cannot create duplicate filename '/devices/virtual/misc/btrfs-control'" on:

commit: 691a646007c85103cbd339985b08bd336230f611 ("[PATCH] driver core: Add log when devtmpfs create node failed")
url: https://github.com/intel-lab-lkp/linux/commits/Xingui-Yang/driver-core-Add-log-when-devtmpfs-create-node-failed/20240522-194825
base: https://git.kernel.org/cgit/linux/kernel/git/gregkh/driver-core.git 880a746fa3ea5916a012fa320fdfbcd3f331bea3
patch link: https://lore.kernel.org/all/20240522114346.42951-1-yangxingui@huawei.com/
patch subject: [PATCH] driver core: Add log when devtmpfs create node failed

in testcase: xfstests
version: xfstests-x86_64-98379713-1_20240527
with following parameters:

	disk: 4HDD
	fs: btrfs
	test: generic-group-16



compiler: gcc-13
test machine: 8 threads Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz (Skylake) with 28G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202405291031.54c11515-oliver.sang@intel.com



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240529/202405291031.54c11515-oliver.sang@intel.com



[   40.509648][ T1244] sysfs: cannot create duplicate filename '/devices/virtual/misc/btrfs-control'
[   40.518489][ T1244] CPU: 0 PID: 1244 Comm: modprobe Not tainted 6.9.0-rc5-00014-g691a646007c8 #1
[   40.527223][ T1244] Hardware name: Dell Inc. OptiPlex 7040/0Y7WYT, BIOS 1.2.8 01/26/2016
[   40.535263][ T1244] Call Trace:
[   40.538384][ T1244]  <TASK>
[   40.541162][ T1244]  dump_stack_lvl+0x53/0x70
[   40.545496][ T1244]  sysfs_warn_dup+0x75/0x90
[   40.549830][ T1244]  sysfs_create_dir_ns+0x208/0x280
[   40.554766][ T1244]  ? __pfx_sysfs_create_dir_ns+0x10/0x10
[   40.560221][ T1244]  ? _raw_spin_lock+0x85/0xe0
[   40.564727][ T1244]  kobject_add_internal+0x272/0x890
[   40.569752][ T1244]  kobject_add+0x13b/0x200
[   40.573999][ T1244]  ? __pfx_kobject_add+0x10/0x10
[   40.578762][ T1244]  ? __pfx_mutex_unlock+0x10/0x10
[   40.583611][ T1244]  ? kobject_get+0x50/0xe0
[   40.587856][ T1244]  ? kobject_put+0x50/0xd0
[   40.592101][ T1244]  device_add+0x218/0x1220
[   40.596348][ T1244]  ? __pfx_device_add+0x10/0x10
[   40.601028][ T1244]  device_create_groups_vargs+0x1be/0x230
[   40.606570][ T1244]  device_create_with_groups+0xab/0xe0
[   40.611854][ T1244]  ? __pfx_device_create_with_groups+0x10/0x10
[   40.617828][ T1244]  ? mutex_lock+0xa2/0xf0
[   40.621987][ T1244]  ? __pfx_mutex_lock+0x10/0x10
[   40.626664][ T1244]  ? __kmem_cache_create+0x37/0x60
[   40.631602][ T1244]  misc_register+0x1d3/0x680
[   40.636022][ T1244]  init_btrfs_fs+0xa6/0x260 [btrfs]
[   40.641139][ T1244]  ? __pfx_init_btrfs_fs+0x10/0x10 [btrfs]
[   40.646852][ T1244]  do_one_initcall+0xa4/0x3a0
[   40.651361][ T1244]  ? __pfx_do_one_initcall+0x10/0x10
[   40.656483][ T1244]  ? kasan_unpoison+0x44/0x70
[   40.660997][ T1244]  do_init_module+0x238/0x740
[   40.665513][ T1244]  init_module_from_file+0xd1/0x130
[   40.670543][ T1244]  ? __pfx_init_module_from_file+0x10/0x10
[   40.676180][ T1244]  ? __pfx_userfaultfd_unmap_complete+0x10/0x10
[   40.682252][ T1244]  ? __pfx__raw_spin_lock+0x10/0x10
[   40.687282][ T1244]  idempotent_init_module+0x23b/0x650
[   40.692478][ T1244]  ? __pfx_idempotent_init_module+0x10/0x10
[   40.698193][ T1244]  ? __fget_light+0x57/0x410
[   40.702610][ T1244]  ? security_capable+0x71/0xb0
[   40.707290][ T1244]  __x64_sys_finit_module+0xbe/0x130
[   40.712399][ T1244]  do_syscall_64+0x60/0x170
[   40.716731][ T1244]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   40.722447][ T1244] RIP: 0033:0x7f3baa34e719
[   40.726694][ T1244] Code: 08 89 e8 5b 5d c3 66 2e 0f 1f 84 00 00 00 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b7 06 0d 00 f7 d8 64 89 01 48
[   40.746041][ T1244] RSP: 002b:00007ffd80ff8248 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[   40.754257][ T1244] RAX: ffffffffffffffda RBX: 00005612a1b66d60 RCX: 00007f3baa34e719
[   40.762039][ T1244] RDX: 0000000000000000 RSI: 00005612915e94a0 RDI: 0000000000000000
[   40.769820][ T1244] RBP: 00005612915e94a0 R08: 0000000000000000 R09: 00005612a1b69c60
[   40.777601][ T1244] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000040000
[   40.785382][ T1244] R13: 0000000000000000 R14: 00005612a1b67030 R15: 0000000000000000
[   40.793165][ T1244]  </TASK>
[   40.796080][ T1244] kobject: kobject_add_internal failed for btrfs-control with -EEXIST, don't try to register things with the same name in the same directory.
[   41.142508][ T1243] request_module fs-btrfs succeeded, but still no fs?


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

