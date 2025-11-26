Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E30274B48
	for <linux-scsi@vger.kernel.org>; Wed, 26 Nov 2025 05:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764133241; cv=fail; b=nZHKaojO//KruSeTHIk2LrakeZdZA9El//IPNovEY6/bNS5zwhHI05VXEOvOiZdljEDqx6kc9PIzJXnl341vshcJxembtKpAClYp/jb/D6YGndMWPnr2+tSFYhH+52tul2RrMiknktqMRpGNXCXvJ0kWqJBoaOD7XUx8BUTI+Js=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764133241; c=relaxed/simple;
	bh=6hnBXFDqRLJ+p4Y+MdL6KxLQBdf1pgS4DuEiAvP1pLo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iE6Hhb0u0W6wmWsKXpZE707Q0jBkS6vwZzIYaJIa7reRbdFeHsNGYaK96EbwwKEdNXpPu3GjKIWEcnq6noz2qv5WzV8ffE7KBFWBC06NNSVXN3IVix1+GN06uhZ62YExMGj3hFm4mPl7tsz1PnRB7t15uR/Uko9+Zu1SEBBqWjk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KvOEF5fx; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KvOEF5fx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764133237; x=1795669237;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=6hnBXFDqRLJ+p4Y+MdL6KxLQBdf1pgS4DuEiAvP1pLo=;
  b=KvOEF5fxfRX6Fd7h4KDBZC6ZxftRZNfO7fVnzZbGTaz6tWq9gSusurta
   FrRs2jvD2gBxaC76lH3ufzOnuzhAWhSfDmk5iEgsV5Wk+3UqmkKSGqohR
   7Uc1+Raz9gKqCIl2MDWfQMB78HVGIIctWaHbukEOjF+kXrJG+GTCqCy8l
   Y23J+NTo1zSir9dvsfnJ1U7ITMnksjiL99jrXhbQR8z5uMqClKBaJjgtS
   vDHP3zJ3Ot1ODm83yQeXeiJTvqJ6ayyONiecjtBu/Uk3DYiCr7fqgQ6Ni
   biV7ehcAmX5Lb+QNLNTrvTG8ZjZrXy6iT1vDtjOFqPYcbbKCBMt1r+YLM
   g==;
X-CSE-ConnectionGUID: fmwmdgqzQ/WzSCecGNaexw==
X-CSE-MsgGUID: wledWviVTuSXtFrEFhGA5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11624"; a="70021240"
X-IronPort-AV: E=Sophos;i="6.20,227,1758610800"; 
   d="scan'208";a="70021240"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 21:00:33 -0800
X-CSE-ConnectionGUID: ekZfBezBQiWAed5lIkCldQ==
X-CSE-MsgGUID: aFiNJ3QrSJ6VerfolZY34w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,227,1758610800"; 
   d="scan'208";a="197153566"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 21:00:32 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 25 Nov 2025 21:00:32 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 25 Nov 2025 21:00:32 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.50) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 25 Nov 2025 21:00:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X3V0T4z2U1nkRrhU+B67PTusq4sgBk8Pv8rP+1cQmhw/VBA+Fj7UJ9D4RmLQsXKYtd6j/1f9kja7T0k4eFE0AGDI6uAzkwVCUYZKv6aeihC+GBq8qdzrizAjS11rRFarxNyUez9ZQuiMteHCnuoct/06txoG2cUxzfu/qfD131sU3/JnKMxt/28Oymnc6XwB9KCt1wgTX6VveKWVM3y2jOLIZvwjN911dZr/8git9Y/cqt4mFIuf83DKlCbdcnv+0r4ZaVp1aGSnJz0brWSMGHmv/KI4LqbQ9VnVBAqvFPQKIPcsn5Yvx/fahAz3HSOdWZelWnr5sJvWV2HlsOy1KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DHv4ZVVeRFzLCgVe1+3tkZIxqKRLnGHqHqAeseebJMQ=;
 b=W2LfqdfFMiCOHH9bUbkwsQowB415ALeoLPY2nn4kxyNQxehWnG4Qu584GLyQciehbIYxwBLUU9oszEz7fibznGSaOyMtU1d8AbkgMau9AFlubxo/AxoKQ510A42YZebxBAE5zzgAZX65NbYu9DJpxNECvskVR0m9Tze/zxTeFtt3e5Ttp31GRBe7/Lu7zn3z4l99jfIxjoIKBnygwPdaJSzgAFCrF9GK//ZuP2JGOrZokNTtc3iDqB95LN06pTpF8poVLuPaFY45AANeN/qLqBGmLj72Ld721TgIkpktOKJNe/zFsz5C3X6w5lFWgkS0O9t88JCfxJs9dfe1DXGLVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SA2PR11MB4811.namprd11.prod.outlook.com (2603:10b6:806:11d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 05:00:28 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 05:00:28 +0000
Date: Wed, 26 Nov 2025 13:00:18 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Bart Van Assche <bvanassche@acm.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>, Ming Lei <ming.lei@redhat.com>, "John
 Garry" <john.g.garry@oracle.com>, Hannes Reinecke <hare@suse.de>,
	<linux-scsi@vger.kernel.org>, <oliver.sang@intel.com>
Subject: Re: [bvanassche:block-scsi-iops] [scsi] fb5a7f1b2b:
 INFO:task_blocked_for_more_than#seconds
Message-ID: <aSaJYutAOf1Yw2AN@xsang-OptiPlex-9020>
References: <202511201331.ab9300d2-lkp@intel.com>
 <47d33069-90a0-4da7-beb2-349a164c5d3e@acm.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <47d33069-90a0-4da7-beb2-349a164c5d3e@acm.org>
X-ClientProxiedBy: SI1PR02CA0011.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::19) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SA2PR11MB4811:EE_
X-MS-Office365-Filtering-Correlation-Id: d1a930c2-31b6-4453-638e-08de2ca8b7f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|13003099007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?w9LIFuzPH3RemSj8qg/717aAilCtYm/J+0cYLdpfggv2q3gDUL5NW28gMc4B?=
 =?us-ascii?Q?yDN48BXV6J629rWPQ4y/3HKyd4CFZj7Kd4qOmZ7BfL3WI6ByCJL1PAo8b/XV?=
 =?us-ascii?Q?u/hOoE9WCYj7wyfttamg7O9T7hp0ukeiBYr/jBXQVrxfcL2ytPFenXaN+RwA?=
 =?us-ascii?Q?ibJeh5dYuJXXXYeouC4tB2dIuriZSl8kTl7OZLybGthk5hp3hZ7FbczNjFeh?=
 =?us-ascii?Q?+pn5fkrmPWwzOPyh7hPKwPOiDlNQzzVoufiAWvvEzZO0kd03mXlSU4SlOJDQ?=
 =?us-ascii?Q?6HsuH7FixSLZSOh/6Mh8wuVaR9ZYfR1jGlqMvdvYncdHreutNTUgqR0myquU?=
 =?us-ascii?Q?5xEKuQegxEmAFz6MBfbIipBxm5hVGHioQH7Evl+3YVt/vXDFcv9GigsaQasb?=
 =?us-ascii?Q?fO4/JY7p3QfnQEzAxwRTsh7dPZi3weUT6O1E8gWLXatvRCuu/3Vqcgp9urQd?=
 =?us-ascii?Q?XtsE8ljJRtaQ5sEHg+s9LaGK9o1fpu94yl40s/99UWMA0DgOGldi8UmMepdD?=
 =?us-ascii?Q?BfK9J+K5Jlm0tlVOeNjd9Kx6f1k4DjfX8NxDRa9ilC2Mm3yuce6m7Lf7MEdz?=
 =?us-ascii?Q?eSMmiuLB3mrOJ+XP5krMfMNFRIaUKU4GOZfOCnzhPn15usMFKlffTYw+p46B?=
 =?us-ascii?Q?0+ihyZrjhN+kl+CnbhEw1t+mvxXOLjrBU0bPM4btADrPFUYRFlVGyjjs612J?=
 =?us-ascii?Q?JHQKgQxmIWBbLmp+Zx8mFU5czqOcJRoHZIpyxEErCH3jcxw2epAYb+rt3H/U?=
 =?us-ascii?Q?oeKkilSioiVU3dD1XAui2PW5IFaEkiLYt1joHQMih9/YAol7Tz6Tir05GER7?=
 =?us-ascii?Q?t4DErSQ+T+sAcVb6YON4LwooqndrYjleZZuphal4Uv9PhSYAHhaFdcF9y8wW?=
 =?us-ascii?Q?LExzXHeA5CbHzwBccem7XymiPdprKbhlhz+mmjaOiWhKI8smPbY5rp17D06i?=
 =?us-ascii?Q?7YpTambzdR4zUgaq5Dl5ikt4qodDwrReQgfPDiTXztHrtm8QFcDpY33XBZ6t?=
 =?us-ascii?Q?uxuv2xZGJkdG4hoY3lVGstD4c8rwDwqgSg0Xv8hcAQUAvY7DyhWHOpl7r7Mj?=
 =?us-ascii?Q?Zl9qIQadvo7GF5HfWHlZvPU+2LsHW5yqTGW/pTnWJ8YZc8nUfJiVb2XgkYIo?=
 =?us-ascii?Q?hTsiJpVWhYAs6kVYUmm52cnVRWIKqhWFXAE+JtJbN5NoNwEKXySv8BxereNl?=
 =?us-ascii?Q?IuaMID/ZsVZSnZdkAIJL2q+PaoUcIHrXXKzjVbckqY3WqJ+Zwc+us6+uG+DV?=
 =?us-ascii?Q?drSQeq3uY2ANhj76bnqbW0zde6bvByKcr70+F/irp7U2OQ09bkmkRF2uA8CB?=
 =?us-ascii?Q?QP11W8spZfQAVxQ3gVEQ9WCRSGdt+ea/PmM7zGdHJUm9ydBDW9wL1+AdJK6P?=
 =?us-ascii?Q?gRjKADXapnjlq9jnYjaYgHhNFUlHkGF3V0lu2eBoRACAIhPyPEyMZhQefGD3?=
 =?us-ascii?Q?nfV00LzLE4qzmB9TJRKUR+XQ/Tras/aBtP0d+dYyEGEgOkn1ugY8gw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xSObzpPK9kTwq9G5/SuHZNT7dGo+i84JTHV7WnYG/L1bUwxOJaKsTUc50kwn?=
 =?us-ascii?Q?DSWl5dr1Gm5X2KU2aJ8i6haypcQCkHV91+szyh7wiizT7K984VyoF/LzL2Nr?=
 =?us-ascii?Q?KS1QMDhv45oQl61Cd75gBkdH4XVpSTNlx5/thC/bENBqJEAQD3s3icSLHVxk?=
 =?us-ascii?Q?n0hs1RXOQYw6VMfHJRDcJS8uAUa2v/4NJ3GdJ+0CR1pEr6Ti68s75v5WFwcV?=
 =?us-ascii?Q?aZBBm/hZrFpdH+P3mJMw1RyY/LkfNIVVkAYqejZmMIHboIJac83GmZo2eBqD?=
 =?us-ascii?Q?WX6MCNbA3GtSXK3Ynfpe7DXiWux5AnbxxmtI2u4RdTvRUu5ISilTYSrXpGlu?=
 =?us-ascii?Q?EZ6MN3f822Io0yuBPp/5VRLs7WcCDnNSQMHKqY+NQJJ8Y+SEmXUnjmGTAfVR?=
 =?us-ascii?Q?ss1Ow92S3Mi5mVBArhQ55HAoLQPUloWqrqz4341xOKKlTen0UzaxIvA9+xJs?=
 =?us-ascii?Q?d0q64VgjLvG6+mGHTquOwClBwxsEN2YMs5JHJHDrHiTPeGuSydTeZ4zIeiaq?=
 =?us-ascii?Q?ZGbJmXUNOkeU3lSgz/1RhWc2Ju6+PfMCBExnhhB1tkuJ2MfBm3NOTcvX5Z0C?=
 =?us-ascii?Q?lzBodkbmnOyBvDYN/9BxkPn1uSXDkiRvpAxJUsEjl4hFJKi9pCSyXMZ3ZJlG?=
 =?us-ascii?Q?6pjY1ZPhGNeFfQYmLfAPLnYu0hD5Puxfzi1jDYuVN+JvPHrn5KN1nEF8ZCy0?=
 =?us-ascii?Q?FMuaWQUPxucWOQXSl4wm+rD0hUCKS0XCcuLvWhrD8MwJsQ+IjL7mV5uIUbLu?=
 =?us-ascii?Q?e7OMqLQ/MdDVvK5V/rrXgud4/+/2hqbDmQ0TokkTdMUBIShp88Gcz9S3to7J?=
 =?us-ascii?Q?1dYqJ3rDrm4o09xJ1kXdb3hvnrGX+9gJNxY9TKd/jAFonBEKKDr7rErdLDKs?=
 =?us-ascii?Q?XHolyuhPl0MF7YqSMwUwqvMosJ6CWHeI9pHA/2OWeQf9NuYGCMt3AAUpCMc3?=
 =?us-ascii?Q?FcKRoyxgrQ2Lr52TOlg/H9g67Fnbben2WlUPrkci3gtfanIR8AbGkdrW7f75?=
 =?us-ascii?Q?iqcp0AzB1HISruZN5uWX5iMqVkImOYW0MCMDnJwq122pMSMR7IRaLavLQYij?=
 =?us-ascii?Q?JyJc/vOqba0qKmarNJY1YydPMJozaFdY0Liie7QiWKycSnPr5G0OAXTwQuI5?=
 =?us-ascii?Q?uDj4mG9LEwr2ZuVI0dQ47oVACYM2uq+AmYTFtp/PUIBp+prXT1Bzx1xtJ/gK?=
 =?us-ascii?Q?LFoqkHGn839YY+NUDiW0PveD8fu84IlklYP2+t5sWKkULGVwmGjXeqoI2YN3?=
 =?us-ascii?Q?sWBAppOX4gjZPM1K1poEgrxqjYi1xIIpwuCPB7OnceO2UwSkpPTKyicM2sGO?=
 =?us-ascii?Q?izQ74Tx8U/9D535ySsFtutRaY/yYljB8u9kZrWNuALPT6yi13yzLNc/UqCt2?=
 =?us-ascii?Q?n2MRs9HP4sG+GhBH/2ETTyMKfG7qoiiTDvh5uoYBhZLOt9my+hzLvNWEReVV?=
 =?us-ascii?Q?1shQAVNd0nFWRp7waiBpX1WubifTcfd5YGcN3pWBFZHtvbqdNGa1uapv90q/?=
 =?us-ascii?Q?FUPulEbflHfJUu7gHcGdeubb2SJvvDjfuNa7KLJaDvDYww1Zz9vEJAipfGBp?=
 =?us-ascii?Q?GhezH3AANVZ3QfbGWJ3VWWjW5dX/JPN+NpJ9ly/oBsCnmKqENQqh+226YFkP?=
 =?us-ascii?Q?4g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d1a930c2-31b6-4453-638e-08de2ca8b7f4
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 05:00:28.6812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hJMKC79lYDmQjJ9BXQt2Pn4Z5L3WFAFT+u7dHBBl0Kugp2zGQcfnf4U5Xawh/7jbo6xjLyvQwGhrEtFO9RirYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4811
X-OriginatorOrg: intel.com

hi, Bart,

On Fri, Nov 21, 2025 at 01:15:27PM -0800, Bart Van Assche wrote:
> On 11/19/25 9:59 PM, kernel test robot wrote:
> > kernel test robot noticed "INFO:task_blocked_for_more_than#seconds" on:
> > 
> > commit: fb5a7f1b2bb3442ab270404463be4f0d7578295f ("scsi: core: Improve IOPS in case of host-wide tags")
> > https://github.com/bvanassche/linux block-scsi-iops
> > 
> > in testcase: boot
> 
> The root cause of this hang has been identified and a fix has been
> pushed out to https://github.com/bvanassche/linux block-scsi-iops.
> Let's see whether the kernel test robot is happy with the new
> implementation :-)

we tested on the new tip of the branch:
272816567e072 (bvanassche/block-scsi-iops) scsi: core: Improve IOPS in case of host-wide tags

confirmed the issue we reported now gone. thanks

Tested-by: kernel test robot <oliver.sang@intel.com>

> 
> Bart.
