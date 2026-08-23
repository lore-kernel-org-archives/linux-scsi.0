Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843F53128AB;
	Sun, 23 Aug 2026 11:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787485397; cv=fail; b=j9DZa4EyD3JqVNyoOFSMsFTINHgp+Z63sjSfja0uwgxBJU5JsH2d87p9dM3kYIHPBtooBWy49nkgcfEl23HtfdBMF/YIToxOlk4jvPVsqOsinzbg9sQ/XNtyQYdwcCVr4MVdI3ERPDE3Y2P2jFf72q4TSKM6tZolA9ljW6e/86M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787485397; c=relaxed/simple;
	bh=Y43iwx82gLxHBKd7hLLfXhzx+C1dMVji6a4aP7xJSK8=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Yu4JpIktUEzp7UXMqcki+CavojMgQC84QKMpAYM3/evmsijUAub/LPNADZeMu5Qd9mOS6LK6zz2knLpcMK2WikuElPv71jZafXTS5Uej1ze+8qnM8OyNg/UWmnEPlaWJR6ogL5n4wfzHLXKllWxh6pxeUJTjnd8W1AgtAq7UUL4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N4yvEs2V; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N4yvEs2V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787485395; x=1819021395;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=Y43iwx82gLxHBKd7hLLfXhzx+C1dMVji6a4aP7xJSK8=;
  b=N4yvEs2V0QwU2Xyq+OUm/QcuLCRHegBvNNUirv2P2SKeqE0n6li5BteC
   h3QHfxG/nDFn/G/vRyvqPUdJoPq3wfPi73SVNW2CHOdoP2LlSgGKsIlf2
   xXMgpytk7yJiEy8A8oykWL2YSMvoa+lgiv3wPaw7Uw77IFvXznILFjSWz
   jtY1tp/X1W65nDQaZELvYmfP16HgNg0AJePIcfbEa3pv/gVJwXSncsFfS
   lGahvUE4i5GUO8417HcO3q2hVHszHEKeSb38KQIHr0CRdc1yGxAhnS+Ym
   5Dqtf5K4JewKQex5qZytdO39A3VXWMOXwk+cmfxRfSzoi6iXpPUzz75v+
   g==;
X-CSE-ConnectionGUID: o+JtdZmJTCSgxO65VsHwuA==
X-CSE-MsgGUID: e6kPfluJSRSO9evcaK2e3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11883"; a="90473352"
X-IronPort-AV: E=Sophos;i="6.25,238,1779174000"; 
   d="scan'208";a="90473352"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2026 04:43:15 -0700
X-CSE-ConnectionGUID: c5ZVX/5JTQiNI8QZUBQ48A==
X-CSE-MsgGUID: P/8602j0Sk6nXcZsk0F4cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,238,1779174000"; 
   d="scan'208";a="296664317"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2026 04:43:14 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 23 Aug 2026 04:43:14 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Sun, 23 Aug 2026 04:43:14 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.52) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 23 Aug 2026 04:43:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oqIw366Tiaz6mBiYN75G1r2wDTAqFM7Cm9CqHecLHs+gtiJSdiHi77ztgpi76OyRaXXrwTUPQKtfuUCMFz6I0NAInEcRz8bxTadiJkLIuvZb/fE65mdtS52LFAPG2S1XQqW6BIPbroG1WaFQ1vDYMIc1l3l1FXNvFHKjlS8J20AY+BzO6uWby4EelgLWDnSUH7LVsuw1L4S9Ql8WrPOlT1LcxXTrV1eafLunVpdG2hDrxlWPtXsYou+py/0o79YydP35W/FguqOryBJA/z1g11lM6N135yM0oOWnYxrY6R+qoruo2Da2RfOMdJaV0EpZ2ksrvyzzwB5OI4+SKkx+wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=13DlSLLeFxAr5yPw3J+PvCurt3W2S/0cQIdBBiwLTks=;
 b=x6rAdwzAR1TFVZyNRf0uiyFgNNbztts1RFuWCjZweoVI/iT/JuRyCWKXly8IPq0MIyK0Oj0/TXWOObUrNL8szvZO1TvAcfglKcYaqOxW2La8Xj5rBFkK9wCJk6nsOLat7BbhKGVOrREWAaqyrH//kG0RJxEBiBpTbfujo6kVzYVKIDloMB/CyGGEkR2J97gZJARba1c5QkxP67bydt5f8sHUbYH8fVk6rUOPv3cgGzSaOLDutVuntbK6dEkByPRBMFArwBBSEP3fQzt8DCfXcCxfUxNObZzep32/Uku/r2ik9JIJq3bOKN8DB0NSofhwmBLEmTKQ6EDDOQCWRDKxmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ0PR11MB5214.namprd11.prod.outlook.com (2603:10b6:a03:2df::22)
 by MW4PR11MB6786.namprd11.prod.outlook.com (2603:10b6:303:20b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Sun, 23 Aug
 2026 11:43:10 +0000
Received: from SJ0PR11MB5214.namprd11.prod.outlook.com
 ([fe80::5926:3836:4212:8640]) by SJ0PR11MB5214.namprd11.prod.outlook.com
 ([fe80::5926:3836:4212:8640%4]) with mapi id 15.21.0339.012; Sun, 23 Aug 2026
 11:43:10 +0000
Date: Sun, 23 Aug 2026 19:43:00 +0800
From: lkp <lkp@intel.com>
To: Runyu Xiao <runyu.xiao@seu.edu.cn>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: <oe-kbuild-all@lists.linux.dev>, Nicholas Bellinger <nab@linux-iscsi.org>,
	Lee Duncan <lduncan@suse.com>, <linux-scsi@vger.kernel.org>,
	<target-devel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>, Runyu Xiao <runyu.xiao@seu.edu.cn>, Jianhao Xu
	<jianhao.xu@seu.edu.cn>
Subject: Re: [PATCH v2] scsi: target: pin db_root for metadata writes
Message-ID: <202608231112.vQxAhOxi-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260818051442.1523210-1-runyu.xiao@seu.edu.cn>
X-ClientProxiedBy: SI1PR02CA0003.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::20) To SJ0PR11MB5214.namprd11.prod.outlook.com
 (2603:10b6:a03:2df::22)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5214:EE_|MW4PR11MB6786:EE_
X-MS-Office365-Filtering-Correlation-Id: 48478ebc-85c6-4dd4-6a40-08df010bb511
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|42112799006|7416014|376014|23010399003|1800799024|366016|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: 5iL/yVWnLwopw66Lgnmz3ZGQeLKHs7hnSfXONM3nuOsV1pha9hzYpzHSv/360k0rlDNBJR7D4OjgHINdokcrRGH/eEl8WO8w5o+i5grfXmcyGAnO/tZ8SnLrAOYzISP8oSIzMiAjWCM/H7qGswPCLhO763nrPBQX58f3sgA/GpqmbTJFsU5avHVL+vlxw+tH74P80njYzFjA1GmjhcoLjnk1+J/plw5cHTOKlCd5zli4dT7B+w6uUzG4fwwxxQ4zgZW8b5wBeJrrFKVoST9WAjUd50Xen3BCABs3vfslEsW8wTdq3OsVPn40pNGzYnOvoUqzl7zMPUA0DPZSaPOXn/QcXMhBDNrGm4yQNzYfqn66c4ONYppuRB6uUQpyGni99QPNtTxZHTfXyHu6GiFMutZAmuYj0K/x84xHZD/9pUsOgRiWYND36+EzjUH5Fk6tZKtI/PDBzYiqIRsA+2mY4bEqnC/O6+lO5Og1rfZj4LBuLdsYWJd7kCpBNhLxhOk5WBs2Ki1lfeXY9sN2r2anPboLwd6TANzqgUdtvAxh0n+bFyw4gpT4cJPRlGIKdme17hafA3dEG2SyAluwbdhkmDDxmmtFDQvi/MAbDMoLveidvJ6NoevzuCoby9bAvcks
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5214.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(42112799006)(7416014)(376014)(23010399003)(1800799024)(366016)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W2UeEFgRKNgVYOykjh16MW2gjSQldOT8TXd8cfliWmh9ugTdml020leQLdnJ?=
 =?us-ascii?Q?Bh7aa+dDMJMAAWhlxIb5WYQ86fy1A3fNiMH9S1Pby9dkCqviMRWhjpvjBzyb?=
 =?us-ascii?Q?p3MX3y2k4V5/2WVnc4HdoDFeRqOxw63tP4ubpUuADfGnk1+T+K5lNJQr7zIX?=
 =?us-ascii?Q?1yF8ad6LdHez6LjVEhs4G7r0hu/GhUCEoV6gqcAZZggAVC5Eoh1HteJ/CZU2?=
 =?us-ascii?Q?nxo2accE9WfIIGTCDwnAMw9un0GLCqN3DT6Nw9CzdfZuMG9M4b+5KM0aeZxm?=
 =?us-ascii?Q?vex1IIFk4EQFzKGVp+EU/YCJO6mOnY60zWXLaEe6K/OHWZnlEPGWDt5rHwB7?=
 =?us-ascii?Q?sYqod18n0u6NOkRIafwOt2sEUG1NQSuQE5oxTIZsqkOz8xKs4hYcQtXVNQCy?=
 =?us-ascii?Q?bxNQo5eKdiAtLX/xVWlfEMCw1vJ7lu5JK/9/UzkkG8TUTobPBdrjFmxJfEAd?=
 =?us-ascii?Q?7YDdmA8LCW4iCimilFFeKgnAHgdDLZslnDPbBSQKg+0iRZtqgvtaDo3RiipO?=
 =?us-ascii?Q?eyGEPRj/ok8vu/JmCGvGyWvDwqwZlAlVSV4D5CHPyCjI7muHMcguhkCAMxAL?=
 =?us-ascii?Q?5XyfkBy4MrVKTO0xbaq8kfA1HN3wgekhoQHPZfypSF7iLdy5F1OBkbDvfNVW?=
 =?us-ascii?Q?IpMad9AETBzom1/C6gz8Ogx0L2zUmXf8J0mtsV82G2y1j10xvqMmqmIBkv3P?=
 =?us-ascii?Q?tjCa2TcBCD+wySildYRLqtaGW9vlE+z5PjBEX/JQfNevqa0WDMiBtVXwuqed?=
 =?us-ascii?Q?l/4qjU1cEwY1TWdPHLROk9oKbnPMZlTr1TcOlbsGNVnCHJtH5XtdJOj1fG2r?=
 =?us-ascii?Q?O9xk6lGw52+KFCepujpeLp3MdQomcCCGMboxS13x6KM7EiSypTGjmNkzsxnR?=
 =?us-ascii?Q?v8PbMArWFS1seN3IM3sBbOyjdT7PgI23JBBKqdFoMGq+mgsxLbE06L568zD8?=
 =?us-ascii?Q?5dngSgbg11HbfoB9sFLa1bKT0kGYH97WYfsI5rTxONon8gMDsqRYUFfU4LlW?=
 =?us-ascii?Q?q1xt1uAh0my27murXoppi2nyMwYijghuuZPw/OI8tCbvaWFTkzG9+KToiyx4?=
 =?us-ascii?Q?gj0PilneDkRbe/r2wFtBaD89+AZHpZabLYdmxoS3C6vaQFz+dbN+3NtakOeb?=
 =?us-ascii?Q?5ymcLRlmndTTTszeKblGfcsRPM/svkcKP8yUBOh9IAd814eZtLfblHbksISv?=
 =?us-ascii?Q?WM++M4edn09C+PkJtMeNxcfz4mWpGT0uVebFA6dHJotPY7w5vnBItfcBLwno?=
 =?us-ascii?Q?1CA0xBU1Q74Y7cwovdsFuaMYsjwXHr4YjEIjlOWoH7jdRoJexUQwy+mFUV65?=
 =?us-ascii?Q?KF+3TmHdRET23rcoVn3zCVu9bLnhzBlij7TF6O2ALtVo594hUaMg/wBC2Agx?=
 =?us-ascii?Q?QbLtgQq/rFZA8BqIWTo1yiYGHsgZJY3+SmwkWvcyzlA+U7o/XsoMPCkf4WOs?=
 =?us-ascii?Q?nyTGdRllIwf/swsjZTlmCtibw0/71OBaPWrQRJp4gbkw2SMH8m9qn3PIiVy1?=
 =?us-ascii?Q?YNi1LJBpdCxrLQaBJn2MNgMezyPxaJ+gMdirbRdseY6FzuXRqCdUmS9zuog6?=
 =?us-ascii?Q?BiyO2qhKF8/p42G7CCWp/EIvQAFE0OyffNPfzOv5eHe5dWUMmHIC+jiGbhLv?=
 =?us-ascii?Q?V9gGH0bR9O+SAcvqxWjTt4FfzEz/Ec0/LLElmb+XOP3eAJGnQ3sdyC1Kl/F4?=
 =?us-ascii?Q?5uypQIt5Ume1XF+2JBrwbBhFipAxwfb3Q/JYMsSMe7Rmp06HQKqag+O2QW76?=
 =?us-ascii?Q?d7AXN6gMGA=3D=3D?=
X-Exchange-RoutingPolicyChecked: mMQWTX5hL0XS6ctf8hV50gehJZyrd7Fct+7eQrhfNHmiToUkf3Uq63hYGSVbTC2CMTslq2mTXMnw181DE6DiwZeoGqYwvuZgUCQVEb6Z5fX7H/2gJbOMdYXM56dHvEJ5oiyG2NJL3cHhWETUsZZFDWhEmpcoy7Nyu//ufO2mA2D0sQsnAaAtgzUWsevK3klGs5lXbXG5aAxxoKCHMmdTZ4VzzGA1x4YOGAJey7+LLC9IuSP2MCvUtkYe1/m5eotrAWba/WuysFf26wRKGPH0WxcXGsXm63XCsTNz8IY0AiWG+Yv+AIu6aXH4PrB6m6y4r0z4x3jdiJDHVV1Avy095A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 48478ebc-85c6-4dd4-6a40-08df010bb511
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5214.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2026 11:43:10.7517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AplOereal9lpgACd/nXYHQbw+Dq1fdYLyQKFgIO3x3dEP/mQmcY7wJYmzHGgc/33sfGkuBHBEOwMKORc01PkOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6786
X-OriginatorOrg: intel.com

Hi Runyu,

kernel test robot noticed the following build errors:

[auto build test ERROR on mkp-scsi/for-next]
[also build test ERROR on v7.2]
[cannot apply to linus/master next-20260821]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Runyu-Xiao/scsi-target-pin-db_root-for-metadata-writes/20260818-131442
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20260818051442.1523210-1-runyu.xiao%40seu.edu.cn
patch subject: [PATCH v2] scsi: target: pin db_root for metadata writes
config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20260823/202608231112.vQxAhOxi-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260823/202608231112.vQxAhOxi-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608231112.vQxAhOxi-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/powerpc/include/asm/paca.h:16,
                    from arch/powerpc/include/asm/current.h:13,
                    from include/linux/thread_info.h:23,
                    from include/asm-generic/preempt.h:5,
                    from arch/powerpc/include/asm/preempt.h:5,
                    from include/linux/preempt.h:79,
                    from include/linux/spinlock.h:56,
                    from include/linux/mmzone.h:8,
                    from include/linux/gfp.h:7,
                    from include/linux/umh.h:4,
                    from include/linux/kmod.h:9,
                    from include/linux/module.h:18,
                    from drivers/target/target_core_configfs.c:16:
   drivers/target/target_core_configfs.c: In function 'target_init_dbroot':
>> drivers/target/target_core_internal.h:169:33: error: passing argument 2 of 'sized_strscpy' makes pointer from integer without a cast [-Wint-conversion]
     169 | #define DB_ROOT_LEN             4096
         |                                 ^~~~
         |                                 |
         |                                 int
   include/linux/string.h:80:28: note: in definition of macro '__strscpy1'
      80 |         sized_strscpy(dst, src, size + __must_be_cstr(dst) + __must_be_cstr(src))
         |                            ^~~
   drivers/target/target_core_configfs.c:3757:9: note: in expansion of macro 'strscpy'
    3757 |         strscpy(db_root_stage, DB_ROOT_LEN, DB_ROOT_PREFERRED);
         |         ^~~~~~~
   drivers/target/target_core_configfs.c:3757:32: note: in expansion of macro 'DB_ROOT_LEN'
    3757 |         strscpy(db_root_stage, DB_ROOT_LEN, DB_ROOT_PREFERRED);
         |                                ^~~~~~~~~~~
   In file included from include/linux/string.h:383:
   include/linux/fortify-string.h:227:83: note: expected 'const char *' but argument is of type 'int'
     227 | __FORTIFY_INLINE ssize_t sized_strscpy(char * const POS p, const char * const POS q, size_t size)
         |                                                            ~~~~~~~~~~~~~~~~~~~~~~~^
>> include/linux/string.h:80:60: error: passing argument 3 of 'sized_strscpy' makes integer from pointer without a cast [-Wint-conversion]
      80 |         sized_strscpy(dst, src, size + __must_be_cstr(dst) + __must_be_cstr(src))
   include/linux/args.h:25:24: note: in expansion of macro '__strscpy1'
      25 | #define __CONCAT(a, b) a ## b
         |                        ^
   include/linux/args.h:26:27: note: in expansion of macro '__CONCAT'
      26 | #define CONCATENATE(a, b) __CONCAT(a, b)
         |                           ^~~~~~~~
   include/linux/string.h:111:9: note: in expansion of macro 'CONCATENATE'
     111 |         CONCATENATE(__strscpy, COUNT_ARGS(__VA_ARGS__))(dst, src, __VA_ARGS__)
         |         ^~~~~~~~~~~
   drivers/target/target_core_configfs.c:3757:9: note: in expansion of macro 'strscpy'
    3757 |         strscpy(db_root_stage, DB_ROOT_LEN, DB_ROOT_PREFERRED);
         |         ^~~~~~~
   include/linux/fortify-string.h:227:93: note: expected 'long unsigned int' but argument is of type 'char *'
     227 | __FORTIFY_INLINE ssize_t sized_strscpy(char * const POS p, const char * const POS q, size_t size)
         |                                                                                      ~~~~~~~^~~~
>> drivers/target/target_core_internal.h:169:33: error: passing argument 2 of 'sized_strscpy' makes pointer from integer without a cast [-Wint-conversion]
     169 | #define DB_ROOT_LEN             4096
         |                                 ^~~~
         |                                 |
         |                                 int
   include/linux/string.h:80:28: note: in definition of macro '__strscpy1'
      80 |         sized_strscpy(dst, src, size + __must_be_cstr(dst) + __must_be_cstr(src))
         |                            ^~~
   drivers/target/target_core_configfs.c:3760:17: note: in expansion of macro 'strscpy'
    3760 |                 strscpy(db_root_stage, DB_ROOT_LEN, DB_ROOT_DEFAULT);
         |                 ^~~~~~~
   drivers/target/target_core_configfs.c:3760:40: note: in expansion of macro 'DB_ROOT_LEN'
    3760 |                 strscpy(db_root_stage, DB_ROOT_LEN, DB_ROOT_DEFAULT);
         |                                        ^~~~~~~~~~~
   include/linux/fortify-string.h:227:83: note: expected 'const char *' but argument is of type 'int'
     227 | __FORTIFY_INLINE ssize_t sized_strscpy(char * const POS p, const char * const POS q, size_t size)
         |                                                            ~~~~~~~~~~~~~~~~~~~~~~~^
>> include/linux/string.h:80:60: error: passing argument 3 of 'sized_strscpy' makes integer from pointer without a cast [-Wint-conversion]
      80 |         sized_strscpy(dst, src, size + __must_be_cstr(dst) + __must_be_cstr(src))
   include/linux/args.h:25:24: note: in expansion of macro '__strscpy1'
      25 | #define __CONCAT(a, b) a ## b
         |                        ^
   include/linux/args.h:26:27: note: in expansion of macro '__CONCAT'
      26 | #define CONCATENATE(a, b) __CONCAT(a, b)
         |                           ^~~~~~~~
   include/linux/string.h:111:9: note: in expansion of macro 'CONCATENATE'
     111 |         CONCATENATE(__strscpy, COUNT_ARGS(__VA_ARGS__))(dst, src, __VA_ARGS__)
         |         ^~~~~~~~~~~
   drivers/target/target_core_configfs.c:3760:17: note: in expansion of macro 'strscpy'
    3760 |                 strscpy(db_root_stage, DB_ROOT_LEN, DB_ROOT_DEFAULT);
         |                 ^~~~~~~
   include/linux/fortify-string.h:227:93: note: expected 'long unsigned int' but argument is of type 'char *'
     227 | __FORTIFY_INLINE ssize_t sized_strscpy(char * const POS p, const char * const POS q, size_t size)
         |                                                                                      ~~~~~~~^~~~
--
   In file included from arch/powerpc/include/asm/paca.h:16,
                    from arch/powerpc/include/asm/current.h:13,
                    from include/linux/thread_info.h:23,
                    from include/asm-generic/preempt.h:5,
                    from arch/powerpc/include/asm/preempt.h:5,
                    from include/linux/preempt.h:79,
                    from include/linux/spinlock.h:56,
                    from include/linux/mmzone.h:8,
                    from include/linux/gfp.h:7,
                    from include/linux/umh.h:4,
                    from include/linux/kmod.h:9,
                    from include/linux/module.h:18,
                    from target/target_core_configfs.c:16:
   target/target_core_configfs.c: In function 'target_init_dbroot':
   target/target_core_internal.h:169:33: error: passing argument 2 of 'sized_strscpy' makes pointer from integer without a cast [-Wint-conversion]
     169 | #define DB_ROOT_LEN             4096
         |                                 ^~~~
         |                                 |
         |                                 int
   include/linux/string.h:80:28: note: in definition of macro '__strscpy1'
      80 |         sized_strscpy(dst, src, size + __must_be_cstr(dst) + __must_be_cstr(src))
         |                            ^~~
   target/target_core_configfs.c:3757:9: note: in expansion of macro 'strscpy'
    3757 |         strscpy(db_root_stage, DB_ROOT_LEN, DB_ROOT_PREFERRED);
         |         ^~~~~~~
   target/target_core_configfs.c:3757:32: note: in expansion of macro 'DB_ROOT_LEN'
    3757 |         strscpy(db_root_stage, DB_ROOT_LEN, DB_ROOT_PREFERRED);
         |                                ^~~~~~~~~~~
   In file included from include/linux/string.h:383:
   include/linux/fortify-string.h:227:83: note: expected 'const char *' but argument is of type 'int'
     227 | __FORTIFY_INLINE ssize_t sized_strscpy(char * const POS p, const char * const POS q, size_t size)
         |                                                            ~~~~~~~~~~~~~~~~~~~~~~~^
>> include/linux/string.h:80:60: error: passing argument 3 of 'sized_strscpy' makes integer from pointer without a cast [-Wint-conversion]
      80 |         sized_strscpy(dst, src, size + __must_be_cstr(dst) + __must_be_cstr(src))
   include/linux/args.h:25:24: note: in expansion of macro '__strscpy1'
      25 | #define __CONCAT(a, b) a ## b
         |                        ^
   include/linux/args.h:26:27: note: in expansion of macro '__CONCAT'
      26 | #define CONCATENATE(a, b) __CONCAT(a, b)
         |                           ^~~~~~~~
   include/linux/string.h:111:9: note: in expansion of macro 'CONCATENATE'
     111 |         CONCATENATE(__strscpy, COUNT_ARGS(__VA_ARGS__))(dst, src, __VA_ARGS__)
         |         ^~~~~~~~~~~
   target/target_core_configfs.c:3757:9: note: in expansion of macro 'strscpy'
    3757 |         strscpy(db_root_stage, DB_ROOT_LEN, DB_ROOT_PREFERRED);
         |         ^~~~~~~
   include/linux/fortify-string.h:227:93: note: expected 'long unsigned int' but argument is of type 'char *'
     227 | __FORTIFY_INLINE ssize_t sized_strscpy(char * const POS p, const char * const POS q, size_t size)
         |                                                                                      ~~~~~~~^~~~
   target/target_core_internal.h:169:33: error: passing argument 2 of 'sized_strscpy' makes pointer from integer without a cast [-Wint-conversion]
     169 | #define DB_ROOT_LEN             4096
         |                                 ^~~~
         |                                 |
         |                                 int
   include/linux/string.h:80:28: note: in definition of macro '__strscpy1'
      80 |         sized_strscpy(dst, src, size + __must_be_cstr(dst) + __must_be_cstr(src))
         |                            ^~~
   target/target_core_configfs.c:3760:17: note: in expansion of macro 'strscpy'
    3760 |                 strscpy(db_root_stage, DB_ROOT_LEN, DB_ROOT_DEFAULT);
         |                 ^~~~~~~
   target/target_core_configfs.c:3760:40: note: in expansion of macro 'DB_ROOT_LEN'
    3760 |                 strscpy(db_root_stage, DB_ROOT_LEN, DB_ROOT_DEFAULT);
         |                                        ^~~~~~~~~~~
   include/linux/fortify-string.h:227:83: note: expected 'const char *' but argument is of type 'int'
     227 | __FORTIFY_INLINE ssize_t sized_strscpy(char * const POS p, const char * const POS q, size_t size)
         |                                                            ~~~~~~~~~~~~~~~~~~~~~~~^
>> include/linux/string.h:80:60: error: passing argument 3 of 'sized_strscpy' makes integer from pointer without a cast [-Wint-conversion]
      80 |         sized_strscpy(dst, src, size + __must_be_cstr(dst) + __must_be_cstr(src))
   include/linux/args.h:25:24: note: in expansion of macro '__strscpy1'
      25 | #define __CONCAT(a, b) a ## b
         |                        ^
   include/linux/args.h:26:27: note: in expansion of macro '__CONCAT'
      26 | #define CONCATENATE(a, b) __CONCAT(a, b)
         |                           ^~~~~~~~
   include/linux/string.h:111:9: note: in expansion of macro 'CONCATENATE'
     111 |         CONCATENATE(__strscpy, COUNT_ARGS(__VA_ARGS__))(dst, src, __VA_ARGS__)
         |         ^~~~~~~~~~~
   target/target_core_configfs.c:3760:17: note: in expansion of macro 'strscpy'
    3760 |                 strscpy(db_root_stage, DB_ROOT_LEN, DB_ROOT_DEFAULT);
         |                 ^~~~~~~
   include/linux/fortify-string.h:227:93: note: expected 'long unsigned int' but argument is of type 'char *'
     227 | __FORTIFY_INLINE ssize_t sized_strscpy(char * const POS p, const char * const POS q, size_t size)
         |                                                                                      ~~~~~~~^~~~


vim +/sized_strscpy +169 drivers/target/target_core_internal.h

adf653f92f38e8 Christoph Hellwig 2015-05-25  167  
a96e9783e05851 Lee Duncan        2016-04-14  168  /* target_core_configfs.c */
a96e9783e05851 Lee Duncan        2016-04-14 @169  #define DB_ROOT_LEN		4096
a96e9783e05851 Lee Duncan        2016-04-14  170  #define	DB_ROOT_DEFAULT		"/var/target"
78a6295c71cb27 Lee Duncan        2018-04-06  171  #define	DB_ROOT_PREFERRED	"/etc/target"
a96e9783e05851 Lee Duncan        2016-04-14  172  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
