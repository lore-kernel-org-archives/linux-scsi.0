Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501502D249A;
	Wed, 10 Sep 2025 06:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757484378; cv=fail; b=RmJMSDWtNfesgS2XejvSxhdfnDEawOkOrn/N+NkOJTHS0yuM/P/QK05JJgy/Spxj4g+Pxh7eVR0ytAgxURmI8Biz+wTKya/Xw3zMO4BFeMyGKW7HPMsdWiUiKEWL+2hgm7oM1wNRWibKS+LiXLAiwmuWeQnFPfbssXbiTMN/RZ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757484378; c=relaxed/simple;
	bh=JJCQTMbSxu56E6v3KqPT1/fRkHkmvD5kUhm7yr+Fa4M=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HPMaQnGkTETIEA14NlN1MjIAWFFOfjyQdBd26fazbxT/1gELAEexa0kAaOv1VrJG//qzMGW/i4LpebnO3ihXL98bavIU+e/yB/4Zu2xoJTziLVl+CCJkcWJQE+R0sFBTq8vMQwvSHYu627kEpudZbnpRuYwb8mwePnFierI6318=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D154SvSM; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D154SvSM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757484377; x=1789020377;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=JJCQTMbSxu56E6v3KqPT1/fRkHkmvD5kUhm7yr+Fa4M=;
  b=D154SvSMbRqGQD0Zx4kSNWifQsbQ4SxDLs2yOP1Hv463rYbm00E9Ql6G
   BfoYeCEHMxIsoc3To/UgTeqxyGjgEC69H1cV189ooLmiyU4yw+GHq5KDC
   fga/74iVH/SxUXyKmNjPIXZin7Eap9Q6C9qc/SP3tubKHXdUGpQ6ygcDm
   4WeJOmmvQj6lx/Z9YuB1FvlhWPvWP7Pdzu4+waj4AzWw4TpcEpkSzb6G1
   HHL/sS4J/NP6IfLfL1C/NFNLK/oOUYfhmzk3nNgpegNH3V/uH+o3dCEgy
   0dYqN7S0QkCcpkKlu2Trpd1o391hrEpDsEM+ZB2CTiFX5AOX2d0ff4pjc
   g==;
X-CSE-ConnectionGUID: q/SF0/P9TSKc9Z9MohVjfQ==
X-CSE-MsgGUID: u//2kUIWRdO6zvpMsdwJCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="71164348"
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="71164348"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 23:06:16 -0700
X-CSE-ConnectionGUID: haSthKRpQQyEqdbnIGEkBw==
X-CSE-MsgGUID: qeI8m4AtR4iOrCmdOXudlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="172460308"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 23:06:15 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 23:06:14 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 23:06:14 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.50)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 23:06:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qc08r2hTyq92DvM1dWV5iIaTfMqh/X5HziqghS48ntNNwtcQ0wE5Yyk/Dq3jxTukY64j2ubWu9XLzoALaLeBGFArrbv4z1hnU+nY/rvWSbBlzbTEgXyqtD7QZKz7LKjlCD2NT7+rp+MWGgBbfnNOPf2Gd3kwFc3fE4IhcXG/0kCrwsqnWgWOmINYc1SybyfxxG+beFP2Lyv4YyBI3krW2DggvuF63jNUm/f6/VAF9Z+6B0v4bnylkfJQdVHvGjKcVmH5+FI/8NPQgGabHQ3SF3Rx8Uz6srL78YMO8AYpr2JxoAuB+NTX666clpRjaSy2lDi748Yx6fYnpXJNEfvExg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y+gfDv8FpJ1qqR7+eq6A/TPJXnfhSSAIg1381ffgyV0=;
 b=Y/ZAXR5kS4YpatMRJyeZKtS9b3cgJxAmQwV0vvB1m+Q8LLgKGyA5/8EarC9/UzxGpUV21AGsk56odRQYFLtv+lC8L17V24u2nCW3DLOYk6PvQFrdDyTQoci2Awx9ZeaiL/Pk3nPxUDuEHjBl2NhhRO4UemjHZq9HbG72NlZ3tvzmmthq7WTsfyV9hqDu0isIT9njMB1HaFRwVzYBGZB1cTXQbzoW1qYX9ANF+ImqUXzQBaveJJWpxPOvqLrc4PjHHPszHnqRyvLfiHdyadHnOOZ6qz6sPWIKhsAxkRA0J+Stua+uWHpvgy4MnVVn9ZX/dlLqo1bhfMAILehWivEWqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SA0PR11MB4560.namprd11.prod.outlook.com (2603:10b6:806:93::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 06:06:06 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 06:06:05 +0000
Date: Wed, 10 Sep 2025 14:05:50 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Daniel Wagner <wagi@kernel.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-block@vger.kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, "Christoph
 Hellwig" <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "Michael S. Tsirkin"
	<mst@redhat.com>, Aaron Tomlin <atomlin@atomlin.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Thomas Gleixner <tglx@linutronix.de>, "Costa
 Shulyupin" <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>,
	Ming Lei <ming.lei@redhat.com>, Frederic Weisbecker <frederic@kernel.org>,
	Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>, "Mathieu
 Desnoyers" <mathieu.desnoyers@efficios.com>, <linux-kernel@vger.kernel.org>,
	<linux-nvme@lists.infradead.org>, <megaraidlinux.pdl@broadcom.com>,
	<linux-scsi@vger.kernel.org>, <storagedev@microchip.com>,
	<virtualization@lists.linux.dev>, <GR-QLogic-Storage-Upstream@marvell.com>,
	Daniel Wagner <wagi@kernel.org>, <oliver.sang@intel.com>
Subject: Re: [PATCH v8 10/12] blk-mq: use hk cpus only when isolcpus=io_queue
 is enabled
Message-ID: <202509101342.a803ecaa-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250905-isolcpus-io-queues-v8-10-885984c5daca@kernel.org>
X-ClientProxiedBy: SI2PR01CA0022.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::14) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SA0PR11MB4560:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f7c8847-68a8-40dd-31c9-08ddf03020e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?g9wiFFDTdLwldRbiKkxoeA0nnpJX28c6t2gygmWFRrp8TV0RU1y+AA3cIRfA?=
 =?us-ascii?Q?zlZX21deJKu3Rhi88yX2syJlpqArycGH/FlXPe9+GnC3tBpCCfPnuA82q3Fq?=
 =?us-ascii?Q?CAOVNLKLPD9+oz2yYKh4ZI8DrCXJSR+KYbfzRpArWozI+KcfdYnRtsDkeWEU?=
 =?us-ascii?Q?Mvv1cshpY/w0gQXD6St1gAHCdXrczzpDEzfL39SVK5ggOSYsdkWS61LIlz46?=
 =?us-ascii?Q?+Z5vmC8eaY41qHV3ZRKTJZ2hT+XZgZ4+OPc105UrNvLkw4JJ1xsKAu5KaGmk?=
 =?us-ascii?Q?TpxBP+IOsAstfy50KI5Vbj/fcIUSnViollxNJynszWWpLz5y/4CtPsnNZwDn?=
 =?us-ascii?Q?pUUUqucOMTLpclvWSTrzK2LVXgsUcqVxX/Ro4R6GnDHJowE9v30+Fen9VYlO?=
 =?us-ascii?Q?ym7vPD4jI9jsru3VUFdQugBH4hqtRDYrLSwv3vd/xsv7ABsnm0oWEwDn8AlT?=
 =?us-ascii?Q?l7h7jK6xzqYNXeqDZ64C61eMhpwefYqeP2z5k/bg+nA5VSvaVoSmkm1TKlKi?=
 =?us-ascii?Q?G/NMUYIScvPStcQ7UYiFFGht808VX9miBZUYhHr5OAJstVPiLU07I5rY2mSQ?=
 =?us-ascii?Q?Njfdm2LYHeta/kgnJ27XHTBpobjQEXzUnFtud36MIZpDI6f+CwmurFRzXb/W?=
 =?us-ascii?Q?E7QhEkDKVFKq/yJs4nGbqFJ/T+3WtL7+25Li6En9XRAyQQ97fCA/xOfAkwNh?=
 =?us-ascii?Q?xKNkTByK57HcfNUINpXiOnsVPgvd9r5mCmVasPG8DYkcJsmCQLacn/cyN+l5?=
 =?us-ascii?Q?7qsfsqMAhIbeDKw9kPotRvbJThsVGPf28lKRT237VIRNtTibw46+O18q4Cnu?=
 =?us-ascii?Q?/w7SPFIDz6nGuITmL2bmnhLa4MHwAqmrmyNkvCT9lvdpcceEJz91jM2Mzkj3?=
 =?us-ascii?Q?xhWalUsmcNXJmgxLR2xqRXKW6qzXGp6uGyALbMF3kLgK7YxyKZpcw9UIWzBd?=
 =?us-ascii?Q?nHjHX+oVIWUaDtInZhbm/qkrbi47WJhor6bjRpMkUDO0Nnh835F5Reo6b3rB?=
 =?us-ascii?Q?AkLQhTF7ocbnqJI5EYC0Wgyiju422PJYEX3Q5rWppAKNv1lx5bu1yN/iXI2u?=
 =?us-ascii?Q?fzAO1uWXZo4A3HyPIO3SHcFH7kU4Yx3q2j/2hVORbkuOPEUMJ2vQvQw97DLe?=
 =?us-ascii?Q?cQHECr4CYFh+S1ESkWD4wM5dBNQt6LkVgw0mlK1ov2FAjrJpQU5lxHkGT6mW?=
 =?us-ascii?Q?+AsN2Wx2vue6HTb3jXJ5MPfazH85IXwliqUEtu+QYsiTH/9H1mEYgR/jcGOM?=
 =?us-ascii?Q?5ZYJlL+JIZ1Qje+2ElJ/r+SObwWVLw+PEVkXBvPQojKX5UkVQiXytU9CbAhj?=
 =?us-ascii?Q?eshTvEzduB8dTKTxotD8N8uSqEutOqlRAmmdUzouK0OwcE6hAh66i+Pp+/rS?=
 =?us-ascii?Q?XjYm83IIW/s3EpaKpXzpUIlSEa6s?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m5eLQnjwratRlkmpHwYz49RSoqja2VA/rgXmOAqKqB/byWxfRbnyFElmUr9D?=
 =?us-ascii?Q?fRbmK1ZdLT7dDqpXQiSRuFO5h9Q/wTuv+8+sxYO1xUS1V8En6GrexlSdwmND?=
 =?us-ascii?Q?AcHmFE3OGy/93zAA31LUs9Ii22+H0EOkNR1glO3RrgVGmBQc4V/9b5mJ2rIR?=
 =?us-ascii?Q?OAorKcDyvMvvLb7hZs3Igr0/WRhH0/052fMHGwniYtSgC00XZc0BZhCXcsh6?=
 =?us-ascii?Q?2miTPWujI5MEYK6IieYI5zxl/swbaGcQsEZvfnVl7GWSZZzJRjz+G9qGCwKf?=
 =?us-ascii?Q?X3NbLNPqdRhHQC9SUVbU+/4PbnvXOBsEBEsrC6l6y7wDvY6ipeQZ8sc7GnoC?=
 =?us-ascii?Q?SFrlhcdMKCc63PMzlYJO1PgingHpNf3+HTf6oRFNfJ04Ew9/fQ4I/Af6bn7p?=
 =?us-ascii?Q?njJRFmfhbtqIRyXVmRQ590k6sO5FFy5gNYliG84DwwfqMwVA1CJeLgzhgyVH?=
 =?us-ascii?Q?eX6jLoy8r97ATNUpNiSsGR2UFK/X2PqRv3oZIOSFDfppZ3mZOeqtIn3pENEo?=
 =?us-ascii?Q?9pUxC4BLMtEepS6X8hp9gA8CsvwasCyJgMVFpEEql5kBHjmRgvJ4+WM+oRY0?=
 =?us-ascii?Q?gaFT32Q+MQBu8NOmrvzmreq0krcmy2+TuRGq8nDnJrhZt6GegLadJLxEvg3s?=
 =?us-ascii?Q?fxEiAlal12Ghbdv1JR2tgA6sKDDiDDwh5sOoNl/IvbtMndsa/imUqDCrMEVI?=
 =?us-ascii?Q?1FlqIvEH5ooaRMei148fQJQB2MmOEdF1ToN8Galm9YaK9u4RjMtNdp38Umi4?=
 =?us-ascii?Q?6SvdCCcGS/wnugyRtm61MriFIxifr09yICRUyFOJY55LLsXoOSGMFy7HiJIf?=
 =?us-ascii?Q?4B4cuEEzcbibFSpW7p6NTKu7zgOQYOz04nsbvDgI3czyuk+k4GzrgtGfh/GA?=
 =?us-ascii?Q?p8KsAyPVB00EnOgiT9/siA7a6EOsVt9e40tcKaCIxfhxk1JWX/yOv9LkJdqY?=
 =?us-ascii?Q?vy2JBaxUnASHBetm5Ey2NqCRVxWVfAmX7nQJJ9TAsp/JvOoBfa037nrWGLp3?=
 =?us-ascii?Q?ATvrqDXv7pQNe4P2AunjFNiDtOMwcot4mcuHKw102BGW6FGOcjqsX+vGOn1u?=
 =?us-ascii?Q?85hgyVrPpG0JA1mujkwfW+ztGXr4ygn22hIrKbDj4caxMWHvx+ly6G4kh9TP?=
 =?us-ascii?Q?CVZozI9i3CRqoDobq1BsFrnLCyNJCBlGJCp0ADQ1rFDiGzGUNd9Q3y05tiYC?=
 =?us-ascii?Q?VtqTOLHAjPdkVlgrT9UKCpSp5/5BHV6qWGBFrnQ9J5Bd53MEwBpX8o7hiQvg?=
 =?us-ascii?Q?/C8uyIhHOs4rfXdsH0NOKSS0WFRCoY5SL7/DQKyIiyAQr2K0lPJm6Ic9nK8c?=
 =?us-ascii?Q?qo22uIMP2ughYPC+tSrZbzUVvBOeFS0bSgomH4ByDPyNyXrACHt/hoAvIE9N?=
 =?us-ascii?Q?q4mVVgeJBYMb2BpzQYm1Jnk6s62LoxaICiTqQiO5q6xQmtAOwNrCpS7K0PBZ?=
 =?us-ascii?Q?x1067YUIkMJ27R/LrG2H1JeEA8zD4vaHQ6BXQtPgT2ewiLcgHpg1cS4u6Ny7?=
 =?us-ascii?Q?IMif8WQ9x5Bvovo6T8/A85Ir6GLNKE4NAB/UYRk6ImShx8kmGIuTAF/tVFvf?=
 =?us-ascii?Q?a5JBK9gZRQd8e5evNhWxgOf0ndF1snn9C7mHcONB8chpMAnMdxF/Lj3a6Sh4?=
 =?us-ascii?Q?ZA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f7c8847-68a8-40dd-31c9-08ddf03020e3
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 06:06:05.8587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: flPRvYv3nmrUoX6X6+pvfisUhm+zlU7YNMkvNJ0YOYQLEmiAneicH/KPI20ScBZ/neiqt8v5Hw9gL29PnfO1CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4560
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "BUG:kernel_NULL_pointer_dereference,address" on:

commit: d918b4998cfeebf2116443c533f7e3e593658465 ("[PATCH v8 10/12] blk-mq: use hk cpus only when isolcpus=io_queue is enabled")
url: https://github.com/intel-lab-lkp/linux/commits/Daniel-Wagner/scsi-aacraid-use-block-layer-helpers-to-calculate-num-of-queues/20250905-230949
patch link: https://lore.kernel.org/all/20250905-isolcpus-io-queues-v8-10-885984c5daca@kernel.org/
patch subject: [PATCH v8 10/12] blk-mq: use hk cpus only when isolcpus=io_queue is enabled

in testcase: rcutorture
version: 
with following parameters:

	runtime: 300s
	test: cpuhotplug
	torture_type: tasks-rude



config: i386-randconfig-017-20250909
compiler: clang-20
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)


+---------------------------------------------+------------+------------+
|                                             | 0365b94791 | d918b4998c |
+---------------------------------------------+------------+------------+
| boot_successes                              | 12         | 0          |
| boot_failures                               | 0          | 15         |
| Mem-Info                                    | 0          | 15         |
| BUG:kernel_NULL_pointer_dereference,address | 0          | 15         |
| Oops                                        | 0          | 15         |
| EIP:__blk_mq_all_tag_iter                   | 0          | 15         |
| Kernel_panic-not_syncing:Fatal_exception    | 0          | 15         |
+---------------------------------------------+------------+------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202509101342.a803ecaa-lkp@intel.com


[  874.700557][   T21] BUG: kernel NULL pointer dereference, address: 00000004
[  874.701560][   T21] #PF: supervisor read access in kernel mode
[  874.702264][   T21] #PF: error_code(0x0000) - not-present page
[  874.702940][   T21] *pde = 00000000
[  874.703513][   T21] Oops: Oops: 0000 [#1] SMP
[  874.704091][   T21] CPU: 1 UID: 0 PID: 21 Comm: cpuhp/1 Tainted: G S                  6.17.0-rc4-00010-gd918b4998cfe #1 NONE
[  874.705003][   T21] Tainted: [S]=CPU_OUT_OF_SPEC
[  874.705657][   T21] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[ 874.706497][ T21] EIP: __blk_mq_all_tag_iter (block/blk-mq-tag.c:399) 
[ 874.707121][ T21] Code: c9 6a 00 e8 d8 4f 94 ff 83 c4 04 89 da 83 e2 01 74 02 0f 0b 8b 5d 08 b8 30 7c 33 45 31 c9 6a 00 e8 bb 4f 94 ff 89 d9 83 c4 04 <83> 7e 04 00 8b 5d 0c 74 2e 89 d8 83 c8 01 89 75 e4 89 7d e8 89 4d
All code
========
   0:	c9                   	leave
   1:	6a 00                	push   $0x0
   3:	e8 d8 4f 94 ff       	call   0xffffffffff944fe0
   8:	83 c4 04             	add    $0x4,%esp
   b:	89 da                	mov    %ebx,%edx
   d:	83 e2 01             	and    $0x1,%edx
  10:	74 02                	je     0x14
  12:	0f 0b                	ud2
  14:	8b 5d 08             	mov    0x8(%rbp),%ebx
  17:	b8 30 7c 33 45       	mov    $0x45337c30,%eax
  1c:	31 c9                	xor    %ecx,%ecx
  1e:	6a 00                	push   $0x0
  20:	e8 bb 4f 94 ff       	call   0xffffffffff944fe0
  25:	89 d9                	mov    %ebx,%ecx
  27:	83 c4 04             	add    $0x4,%esp
  2a:*	83 7e 04 00          	cmpl   $0x0,0x4(%rsi)		<-- trapping instruction
  2e:	8b 5d 0c             	mov    0xc(%rbp),%ebx
  31:	74 2e                	je     0x61
  33:	89 d8                	mov    %ebx,%eax
  35:	83 c8 01             	or     $0x1,%eax
  38:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  3b:	89 7d e8             	mov    %edi,-0x18(%rbp)
  3e:	89                   	.byte 0x89
  3f:	4d                   	rex.WRB

Code starting with the faulting instruction
===========================================
   0:	83 7e 04 00          	cmpl   $0x0,0x4(%rsi)
   4:	8b 5d 0c             	mov    0xc(%rbp),%ebx
   7:	74 2e                	je     0x37
   9:	89 d8                	mov    %ebx,%eax
   b:	83 c8 01             	or     $0x1,%eax
   e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  11:	89 7d e8             	mov    %edi,-0x18(%rbp)
  14:	89                   	.byte 0x89
  15:	4d                   	rex.WRB
[  874.708716][   T21] EAX: 00000000 EBX: 4632deb8 ECX: 4632deb8 EDX: 00000000
[  874.709385][   T21] ESI: 00000000 EDI: 4192ace0 EBP: 4632de9c ESP: 4632de80
[  874.710046][   T21] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00010212
[  874.710741][   T21] CR0: 80050033 CR2: 00000004 CR3: 158ad000 CR4: 00040690
[  874.711424][   T21] Call Trace:
[ 874.711911][ T21] ? blk_mq_all_tag_iter (block/blk-mq-tag.c:420) 
[ 874.712479][ T21] ? blk_mq_hctx_notify_offline (block/blk-mq.c:3736) 
[ 874.713083][ T21] ? blk_mq_hctx_notify_online (block/blk-mq.c:3713) 
[ 874.713672][ T21] ? cpuhp_invoke_callback (kernel/cpu.c:217) 
[ 874.714273][ T21] ? blk_mq_hctx_notify_online (block/blk-mq.c:3713) 
[ 874.714861][ T21] ? cpuhp_thread_fun (kernel/cpu.c:1105) 
[ 874.715433][ T21] ? smpboot_thread_fn (kernel/smpboot.c:?) 
[ 874.716005][ T21] ? kthread (kernel/kthread.c:465) 
[ 874.716528][ T21] ? smpboot_unregister_percpu_thread (kernel/smpboot.c:103) 
[ 874.717144][ T21] ? __do_trace_sched_kthread_stop_ret (kernel/kthread.c:412) 
[ 874.717763][ T21] ? __do_trace_sched_kthread_stop_ret (kernel/kthread.c:412) 
[ 874.718378][ T21] ? ret_from_fork (arch/x86/kernel/process.c:154) 
[ 874.718945][ T21] ? __do_trace_sched_kthread_stop_ret (kernel/kthread.c:412) 
[ 874.719574][ T21] ? ret_from_fork_asm (arch/x86/entry/entry_32.S:737) 
[ 874.720128][ T21] ? entry_INT80_32 (arch/x86/entry/entry_32.S:945) 
[  874.720667][   T21] Modules linked in: rcutorture torture
[  874.721260][   T21] CR2: 0000000000000004
[  874.721773][   T21] ---[ end trace 0000000000000000 ]---
[ 874.722424][ T21] EIP: __blk_mq_all_tag_iter (block/blk-mq-tag.c:399) 
[ 874.723094][ T21] Code: c9 6a 00 e8 d8 4f 94 ff 83 c4 04 89 da 83 e2 01 74 02 0f 0b 8b 5d 08 b8 30 7c 33 45 31 c9 6a 00 e8 bb 4f 94 ff 89 d9 83 c4 04 <83> 7e 04 00 8b 5d 0c 74 2e 89 d8 83 c8 01 89 75 e4 89 7d e8 89 4d
All code
========
   0:	c9                   	leave
   1:	6a 00                	push   $0x0
   3:	e8 d8 4f 94 ff       	call   0xffffffffff944fe0
   8:	83 c4 04             	add    $0x4,%esp
   b:	89 da                	mov    %ebx,%edx
   d:	83 e2 01             	and    $0x1,%edx
  10:	74 02                	je     0x14
  12:	0f 0b                	ud2
  14:	8b 5d 08             	mov    0x8(%rbp),%ebx
  17:	b8 30 7c 33 45       	mov    $0x45337c30,%eax
  1c:	31 c9                	xor    %ecx,%ecx
  1e:	6a 00                	push   $0x0
  20:	e8 bb 4f 94 ff       	call   0xffffffffff944fe0
  25:	89 d9                	mov    %ebx,%ecx
  27:	83 c4 04             	add    $0x4,%esp
  2a:*	83 7e 04 00          	cmpl   $0x0,0x4(%rsi)		<-- trapping instruction
  2e:	8b 5d 0c             	mov    0xc(%rbp),%ebx
  31:	74 2e                	je     0x61
  33:	89 d8                	mov    %ebx,%eax
  35:	83 c8 01             	or     $0x1,%eax
  38:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  3b:	89 7d e8             	mov    %edi,-0x18(%rbp)
  3e:	89                   	.byte 0x89
  3f:	4d                   	rex.WRB

Code starting with the faulting instruction
===========================================
   0:	83 7e 04 00          	cmpl   $0x0,0x4(%rsi)
   4:	8b 5d 0c             	mov    0xc(%rbp),%ebx
   7:	74 2e                	je     0x37
   9:	89 d8                	mov    %ebx,%eax
   b:	83 c8 01             	or     $0x1,%eax
   e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  11:	89 7d e8             	mov    %edi,-0x18(%rbp)
  14:	89                   	.byte 0x89
  15:	4d                   	rex.WRB


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250910/202509101342.a803ecaa-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

