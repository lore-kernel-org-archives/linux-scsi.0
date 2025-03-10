Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1E121ABDC
	for <linux-scsi@vger.kernel.org>; Mon, 10 Mar 2025 07:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741592243; cv=fail; b=lHS6e+f2SrC+fJhe3GDbokZQejckQ7B1xbTW0lMyavxwCAJMhnzgSbFJNkRbREAWoTSPj+BrKw8GqfpuEwNDvzB7yOI9Zw0a3MBa94pp3uNgh/Q7PBYo6CY5RtgbyMh4vzUPhdXl8eAE0cFQlzlBG0EQhdtUhQBNbTDBJ9CVrH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741592243; c=relaxed/simple;
	bh=9eJM45sTcJDi0UkSY5ryDdGIAukh2IuxREwrog094Os=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XjugN39DJ+fiYl/vgHNf/HfTTf8PXD2HJyaPLIkRiiwbqQnDtsz9nTPvyl5nBRWKUgfPPF+K21s2UbJw8nP5iKDRGZWJWB36EKOJxF3KwL9S9A0qTLjdHsf3rlAw+uItqMAVBu4/diXzjL/OYuu+Lpp3eBuudfcPY1RfeWe9S+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ibzhwk0r; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ibzhwk0r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741592242; x=1773128242;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=9eJM45sTcJDi0UkSY5ryDdGIAukh2IuxREwrog094Os=;
  b=Ibzhwk0rF0Aa7hUUHYnJJYQc71MbON5/UIYBHQlWtIU54OkWyyIV+J61
   Ct+MeyyhVKUxH3M8Zonj2CpNh21cXyGiF5FUfAmM7+eKQl38llQrNe/A5
   O16CsSd/9hURcldB5JubsC2iWAnnw5c6FJAS9cKA3oNf6DEoDwu49HG1x
   4/+0UTXwuJsz/ejnJzfWutiNz6dNSqQYLGUlFg3tVoFwYlheZ4VwBsQ4e
   UZb9OGCGBP+2ST+VtWxUakG5NYDEV/2jfyGR+Py1nihI6UgsPStRN61Ic
   ipi0gSzf0rfJhPGPHVwyBueFkuBJMiDYgjGY2e9l50Xrt1YrRv07hex4G
   w==;
X-CSE-ConnectionGUID: RATYmWx3RguB+aYi+wNCcA==
X-CSE-MsgGUID: /fzQpwbjSnSmYx2uWlfzUg==
X-IronPort-AV: E=McAfee;i="6700,10204,11368"; a="65018661"
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="65018661"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 00:37:21 -0700
X-CSE-ConnectionGUID: y6zcLjZ5SDGc2jLj3ZmFnA==
X-CSE-MsgGUID: 3JRtZOLhTdiLwrcXPQejvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="120075719"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 00:37:20 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 10 Mar 2025 00:37:20 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 10 Mar 2025 00:37:20 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 10 Mar 2025 00:37:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FNYycKER4z4qXhBR1ecG4erH9wpVCDCOA6yPdZaG4sQrDnfKGuhmamqk9ga5NYUX8pVy2TaovYe4CS7nLLEPnsIM3fqQuOLtoupyJV1oWaiJ+ITQ81f6iHYLei1sQOTQou5vaCQw1tFgZR9YAvysP2wSxA8amHCQwyWpf/UDHJzOab4qF87UeeDF1Jrapbsrl364wWPz6OgTKGu7a393vMRs6egrE20Ifyds5fcPIXbzStZ+nUnQw9SHBM/O2QCmy4dkJHuEnwLobV/1Y6HA3tP08RmmSYaqSYGXcYRwpVn4cMzQnLRgX9qdCVrpG2p+yubFezQxnWgTLP6yJvpGgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pk7rotzRuNLZ41R8KDbSQF5acu8loW9el9P4MY/ux4M=;
 b=GHLQa9VGkKSsVTX3t9+NbKqynUV4jVKWlwDVswnHBVld+Ot03mo0eQ/+8kAyHs+c1k36ZNh7iwbJN7zfZ5/IBk+nSGcVuM00vdlC0aQqkU1QFgW7O7iwQnA4bEOpZ7ZAECa2aPeUXOYo/+3bjWRosu7x7v4ET7U2C+20232iz22asy4uzrQXFalSI4AsNPDl6/+c25yVKjuin4mLjIQH1/yYvieCiecAY49Dy6eHWCmkvLbrT/zN4AirEyDVzwsf6CVs9SwOSf64IUiG/28ReEBCkLGku6jT/m7Iyp3KVndnA8Nbw58a7oKIv2GYU0rYRVvG0gcgVnKrZuZ1fFJg8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH8PR11MB6904.namprd11.prod.outlook.com (2603:10b6:510:227::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.26; Mon, 10 Mar
 2025 07:36:50 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%4]) with mapi id 15.20.8511.025; Mon, 10 Mar 2025
 07:36:49 +0000
Date: Mon, 10 Mar 2025 15:36:40 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-scsi@vger.kernel.org>,
	<dgilbert@interlog.com>, <martin.petersen@oracle.com>,
	<James.Bottomley@hansenpartnership.com>, Kai =?iso-8859-1?Q?M=E4kisara?=
	<Kai.Makisara@kolumbus.fi>, <oliver.sang@intel.com>
Subject: Re: [PATCH 2/4] scsi: scsi_debug: Enable different command
 definitions for different device types
Message-ID: <202503101506.7b02ef4b-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250228124627.177873-4-Kai.Makisara@kolumbus.fi>
X-ClientProxiedBy: SG2P153CA0030.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::17)
 To LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH8PR11MB6904:EE_
X-MS-Office365-Filtering-Correlation-Id: e41d0ab8-46f8-41f2-0f15-08dd5fa65196
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?jxQlq+oPlC0Hv6Hxiwae4qcGG5e2ajTjBYvGfkFFika5swlh8Lwi3awQiUK7?=
 =?us-ascii?Q?0SDMI3YQiEya9xGT/5qZPt2ubBB/HGcXw20NzX1zvu8d5IBkyCqsQfrr0M/k?=
 =?us-ascii?Q?FyGTYhIUkrcvKVqIyWld7F1YfnJA1YMFl1eYNWdthm7IA+uE9M0hq/HViX9x?=
 =?us-ascii?Q?s5GHxlWO3ngz72H34itGtPIqikoe406eYhBW/bXhQybPNEGsIYU9dCxaxlRg?=
 =?us-ascii?Q?VDmNpE4p8ymA+gYvoT+g5RCTczOiFO1COIwysbWDCveZk3FQPBpKOFokx2gp?=
 =?us-ascii?Q?/JBa2TQD22mKFiR4qr/Mo+J5n5ku6JBEgj6ZuZGwUTjF+ALf9pOAkLHO/UEO?=
 =?us-ascii?Q?t4C0NKD9qGqqQLxKG0lS2LsqnXTJ1XQGcZWk0opkWJn9k5KoMPROhmcyGnge?=
 =?us-ascii?Q?w2CLFWvs1Tug8n3AGGLJkT8Q0ySpnnTbj7KeMGCxpBkbW/laHMHLW395mqW/?=
 =?us-ascii?Q?+vJ6r0Ufei1C++G3ouH7SHbsVSM69QyqAHo+lllB/EERqmZLEHr6xClRM8Cl?=
 =?us-ascii?Q?577Hrgbt4t/hoLJVbQnw1lZIckdfzoJ2CH0qQJlJMlSiU/+M2BIPBowpUk+j?=
 =?us-ascii?Q?hgHq+08CUEU4AAyTvv/+wEBEeGLLGhiu9o3qHEK79fxq5sahPlSRIFSGMK8C?=
 =?us-ascii?Q?LleUQg69STWtsOHtlgIIt3mCUoZpXhufgTdjsN6apSd1prLDeb08X+WNha+V?=
 =?us-ascii?Q?1CWYntDlYID9qCQjnL/iXJG+//w6uZaHNfIjIVVRTWDa/0MvkLix1QQvLIBN?=
 =?us-ascii?Q?YsnhJT8R0hsFj+0z91Kv2VQgcKN+DJA5G0HzWIYFuoOUzYo/Bru7D/dV2bfa?=
 =?us-ascii?Q?gjQxE54AVT2H39BBe6YlKFfAVpIfs1ckgziBqA9BVHH0kmlAYIhj/CcWKqTj?=
 =?us-ascii?Q?xeuUInl5lftNZejSwezj3faRo9nx5n5aLqa6egTNnoawc1meXY+9cOUg+M7/?=
 =?us-ascii?Q?9OTkzaobl3H0lGSdJr3mn+wn5XmLXFR0iVBJdGt6B+HULfDfR/8ifndAKgey?=
 =?us-ascii?Q?DNXZwa/E8ipUuAjTSkunqyadhTp8jTvmhSZqDR1PDumB585SaNgmEZyIlbtz?=
 =?us-ascii?Q?amMxzhfEuRy01kZ2wcTu6bqKR32nFTIf6xl0mm9raOvzbrT+PUX2CjI0R5Ka?=
 =?us-ascii?Q?Xanmbo3XpPzbgw66sc7hQuR4qbC5TOLZ4v2RvwQxwVhmaFFmxi/lU0+xPmFK?=
 =?us-ascii?Q?imDputxh1Qi9N2PrLEeVt1VmII3k/E0Z11luUaoXoTyPIW+V1aUW+Oc6O8HN?=
 =?us-ascii?Q?qjufEfnXA98iXISiSJ/mFeLh38JYXxnwhmjEwzrNz5ThLbimXIcLbC4xnAGQ?=
 =?us-ascii?Q?XxM6VgoWYoFvoqVPbJed8QuTSwz42HxjyMgcBfGRP6+8DA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1gkbr1LNHNHw78KP+ArUtSmWLzguPzH8KIEkduNt39RViYccE9DwMk325MYM?=
 =?us-ascii?Q?U4qBsHuY9zcGmOAmRsf2nbWsIGwuPPCuMujrTL4dWgd9yDRIO4hjbuC8Ogp8?=
 =?us-ascii?Q?8lUNP4p9N7cADNevcCVFtL94CbtcTvlr0dlfEKIFXBB9DzDAE45FMNXMeSJc?=
 =?us-ascii?Q?8VGtiqm34kQHxOA4QFJH0Ucu1rILKm5+VfIR6CRnvxC4/Z1kVQzZx2FwYcU1?=
 =?us-ascii?Q?oETIRsMuaZnQ2Ln+A+dYW882xKa3CfE7WdIJsG9iRb/Gw1EBHntIW3cahBdp?=
 =?us-ascii?Q?p7lbGIoTfTtIPdtAtukpn5S//1inHnQeFD+iAa4hjVCafu3pouIwl6AjKC0X?=
 =?us-ascii?Q?qSjcpjmAVNqrjTHMYPjd7BH5Pu4/SPlX2S2X5yyyxqKkYX9HAow32M8flCi/?=
 =?us-ascii?Q?Zgx5YChHx/ZwUTFD95Byj8OOQAyw14UGWDCaKQ2Y1eTiliHSIV4C7f+VXRe8?=
 =?us-ascii?Q?bMW8hH+3XRdQbaCFbAz6+NHosmjepQm9GdUr6duThdvL36r8PbrlbxLN1vm9?=
 =?us-ascii?Q?i5n1oDjC+V4kbtBriEHvIYZP9AhuEIkJrmHJUH9tBZT06vNqUDTEuosEnzxX?=
 =?us-ascii?Q?3V0cbI6j+4Lq/kaQQxKbxnHWYC1PPxhHMZGephWfW8erMqQTofa9bplceEre?=
 =?us-ascii?Q?sDD4qmb3qPLKqVMkaIakxt+GZRyp5tmNaE3sGsYtWXl4k1es1Z1CzDM1hg/y?=
 =?us-ascii?Q?jj90Ch44qBeQGrk0lJg9lfuMNEe47Kkhu7BhuW5hpakVllEWmF3oVFsvF7ov?=
 =?us-ascii?Q?nbWbhFTO/nuiouDRVHJPbU5KubsLlD804jXHsXMRJMTxOoRrfdcNL2ipPsTV?=
 =?us-ascii?Q?YMTxgAkj3gyEQQzQqlLH30yMHysjZE12Ge7Q/aW1DrldB4dDXy72R+e0LrhD?=
 =?us-ascii?Q?H3bdSkvAgh38RnUdFuunSFb/DnNZFDJ/lTA0PooW2gGt7xSP+AMrCikWatOp?=
 =?us-ascii?Q?MwHYaAQhJiZIQCk+HzD91CGW2zf6cPoNOw0b9uXGH6pmg1AN3sR5q+ZXBNHH?=
 =?us-ascii?Q?i22Eb2fbHy1uYQHUP9v5C39jOJkV09EKLj1p6w3OTsVTtzeeOD4jOyBQ4NQe?=
 =?us-ascii?Q?yL9nfbCVi3SZcMWC7+j8BVfOqDldeRoA69JX8Ilh32xPcthZ8RHYObGRHoxq?=
 =?us-ascii?Q?DlRsPR+fvIfG5alePF21s/0Dpiq2XtCJZ90/jmfXHR6YtXhq5+hjhik2GDAm?=
 =?us-ascii?Q?5PvN8Y2X07cLjzsx2skY60OH1AVLFC6aWet5q+8FmejuhsLFoPkX0cM7Lhdo?=
 =?us-ascii?Q?IUBVdyUZrrvJQBncq1WL87MZDQXk9KVBdlDfIJVvYTHK+5CtbW8wvi63W4hC?=
 =?us-ascii?Q?7CnboUGxa2N2fsniknP12lVyIUKh3dL07nZsQnsLY7DDYL2bULhV6KsPIBl7?=
 =?us-ascii?Q?+xCoZvI551WRpGmTan1E2rltLnrrJaahW4OitnvvEXt1y3viBdep8jI6Mbi5?=
 =?us-ascii?Q?Z+hP+fl7VF3TOiskFhpyIKCUXnDJ62hmHwwpGS4KCWNRQ0kO/5CMXcwdV0eE?=
 =?us-ascii?Q?lSkVOmBxEDVQeCHhv5hGg7/sgndtw+W+TDcZOqdAPechBhPQM7z6pmkc/wqu?=
 =?us-ascii?Q?dDv5COlWactkScEK0v0zrzmP9s0sohDubYvD64Xn9EW0pZaHOHK7qwj7Lgb2?=
 =?us-ascii?Q?QQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e41d0ab8-46f8-41f2-0f15-08dd5fa65196
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 07:36:49.7724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YKYZi26IPySljUxXwlIPRMZPaV848sC0T3ati9bwHM4SywDPeadMcbRwpkRfO0C3yLiaRFdj0istR2rzWfhtfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6904
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "blktests.zbd/008.fail" on:

commit: 9dc14edd0ba7334b1d46c0311f4a43ebd3d71452 ("[PATCH 2/4] scsi: scsi_debug: Enable different command definitions for different device types")
url: https://github.com/intel-lab-lkp/linux/commits/Kai-M-kisara/scsi-scsi_debug-Fix-two-typos-in-command-definitions/20250301-005204
base: https://git.kernel.org/cgit/linux/kernel/git/mkp/scsi.git for-next
patch link: https://lore.kernel.org/all/20250228124627.177873-4-Kai.Makisara@kolumbus.fi/
patch subject: [PATCH 2/4] scsi: scsi_debug: Enable different command definitions for different device types

in testcase: blktests
version: blktests-x86_64-3fd1e8d-1_20250305
with following parameters:

	test: zbd-008



config: x86_64-rhel-9.4-func
compiler: gcc-12
test machine: 4 threads Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz (Skylake) with 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202503101506.7b02ef4b-lkp@intel.com

2025-03-07 11:44:28 echo zbd/008
2025-03-07 11:44:28 ./check zbd/008
zbd/008 (check no stale page cache after BLKZONERESET and data read race)
zbd/008 (check no stale page cache after BLKZONERESET and data read race) [failed]
    runtime    ...  0.731s
    --- tests/zbd/008.out	2025-03-05 13:59:52.000000000 +0000
    +++ /lkp/benchmarks/blktests/results/nodev/zbd/008.out.bad	2025-03-07 11:44:29.626233110 +0000
    @@ -1,2 +1,6 @@
     Running zbd/008
    +pwrite: No space left on device
    +blkzone: /dev/sdc: unable to determine zone size
    +
    +fio: failed opening blockdev /dev/sdc for size check
     Test complete



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250310/202503101506.7b02ef4b-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

