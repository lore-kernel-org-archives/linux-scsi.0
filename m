Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0054314A609;
	Thu, 26 Dec 2024 02:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735180207; cv=fail; b=j+ik8tK2TKRQE/JEjE+ixdXHAFoQwmsAJxY6d8tdVYtbcoTn6gp2obg8gCfTkI7jltF4Gf+IbM7hepWTgwhDXV2NbaAVUha6mVo2cbB+fP9/PypETTIAhqHgcGGSZtNoBiOLfoZXXxCiqKoOiTfxA7QRv9myjgHxxMDPimBHTqE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735180207; c=relaxed/simple;
	bh=Y1lzjj1rg224aopL4B2aYrN8DCpPb1GZRu2+eTCrfJU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rgwJaB9WTraj/GyBxZLKv+e/0q7fXWcLkdoO7ocjADWN453LGv2a2cQsntWQkILdN7YSczpP3GWVoHV8r0HjZeyb3HcjiAqJrsr98LTuIS0kQop7TakJjSRX9WCpKngDWqIJbdXc0eWrZKmm4hpB5kypjFICZlosQTEANqjYt9U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J3GPm7Dm; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J3GPm7Dm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735180204; x=1766716204;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Y1lzjj1rg224aopL4B2aYrN8DCpPb1GZRu2+eTCrfJU=;
  b=J3GPm7DmZPABDwsymGxl87ytyPvFrMe0RsUS/5RsT0uzUjOcOoVLZgpv
   LG8vkudw9cUGVxdkahWbIC2aaz7KxBU+fr293IGwjlqTsppTtI9Pm334q
   VdYk/rtKCmOvGOBm8ddqYiXg0m0K8K/bbB43fK6ii5QUMjEj8s8S5fF3t
   yOnCvnb4lxuTKpm/yQ8Dtq8OI9LWvBIq7hPLfK/Fok8kRa82ynU/wHOq8
   01FAMaCfq0U9iF8nG8G/WebtkVzS3mMqmDGZ26LqoCSyxFajKOxJe6TB4
   1fFkD4Jdk7JCzzBmhMZmiSgkoO3b1N89VBhRKlsyA3e1ctsLBsbc6YFvk
   Q==;
X-CSE-ConnectionGUID: Aslt5CgZS7u+jO7UaaHU4w==
X-CSE-MsgGUID: 7rwKDl90QlasHWVFiQnuJA==
X-IronPort-AV: E=McAfee;i="6700,10204,11296"; a="23194813"
X-IronPort-AV: E=Sophos;i="6.12,264,1728975600"; 
   d="scan'208";a="23194813"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2024 18:30:03 -0800
X-CSE-ConnectionGUID: LPZgdTXNRXCH+FqcSg6ZjA==
X-CSE-MsgGUID: mh/4+GJOQJy9bUlZUKyAEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,264,1728975600"; 
   d="scan'208";a="99666246"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Dec 2024 18:30:03 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 25 Dec 2024 18:30:02 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 25 Dec 2024 18:30:02 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 25 Dec 2024 18:30:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nEG2g2fn1qyujjOo7QfQQOtjEWEkHYTmxtF8DpD5HbzOgBvxN76/Pl7jmD0ZPJ45Xg+RL8aEdHkEcGtXVNjVBEh6vTWh5Pvn5iz3mNn0SzA/Kpy3mUjqKguobiKBrmuZlDquoHM6nJW9jcSwZZCgZtDQoOfAQMaTilVuYFVIqY6qI796hr7llKHWB4cgZnDHEElCV2MOzK9dCQuHAbLmvonFzu7GmxoJ0TW5majd7A3Q8KNO09CwCso5BPJxECiEoBXSliOium3JhQKrGGX3KPnUgfh9m5nCWv348vKufh/HlgRj35LAkXM8lXtOQm6EkGQexI+cnBA9fOI/sXe2Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fhIWnx8+7N58JKxaAF9ZUEFgQidfGRKsUkXEe4NnKcY=;
 b=KF85GdTs4it0jaRCFWhrfqmaTwlEQUlxk9m8mMsOHdO9c+Gi2F58dJ3MWhR16GWQp0qtjHfdR5ylaVWfQXwt0GEnLcwkc/FPFZHavyFCGWt6XcKNPR5gln5DBFehndHgtfIc0etVxjH4o0iFy2c+unlHXP/aMXuZC3BLzb1/kmftDMjy4MxvFFI1bSysy/3/o5A4YTI2BwSbOv47yjmIdaEIQp5IbdS2en5RZ7VvzqyttTx7TiP05N0vUv5cP3+SD6IZcm/X6jF0iBRJdcCZjB/x11iu4QJ6PIHHNYb7WVdWcw9DG4/x1JkawFwH9Vf6Za01oP70adbv1VlemWCseg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by MW4PR11MB6839.namprd11.prod.outlook.com (2603:10b6:303:220::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.14; Thu, 26 Dec
 2024 02:29:15 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%6]) with mapi id 15.20.8293.000; Thu, 26 Dec 2024
 02:29:15 +0000
Date: Thu, 26 Dec 2024 10:29:06 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Eric Biggers <ebiggers@kernel.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Ard Biesheuvel
	<ardb@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<target-devel@vger.kernel.org>, <oliver.sang@intel.com>
Subject: Re: [linux-next:master] [x86/crc32]  55d1ecceb8:
 INFO:task_blocked_for_more_than#seconds
Message-ID: <Z2y/cmuCmv22DiHo@xsang-OptiPlex-9020>
References: <202412251418.8e78094d-lkp@intel.com>
 <20241225213241.GA1939@sol.localdomain>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241225213241.GA1939@sol.localdomain>
X-ClientProxiedBy: SG2PR04CA0200.apcprd04.prod.outlook.com
 (2603:1096:4:187::15) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|MW4PR11MB6839:EE_
X-MS-Office365-Filtering-Correlation-Id: 5be8fd90-3b20-4b15-4e31-08dd25551761
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?shYD9xJeiLE1WDnrx61femsf3bfCLiLXsS1Kg32F22807WdufAjb8ipUM79s?=
 =?us-ascii?Q?v5JpESYhxkQWCo6Q18J/bZrV5NV5c55eVi6hCQoiwTDuYFi/A19oswhgpIoo?=
 =?us-ascii?Q?g4/mw+6hv3pi6Jvqlec4NFKc8CR42ztQAoAa7XicZwn/RXn4+Iyxz31d4AeJ?=
 =?us-ascii?Q?uBErGju/3Nc/gRLqH0yMBylMormMrKygL1Ob4jk8dtL65VFQdwS266MDz4rP?=
 =?us-ascii?Q?mfePsM76sqaY0HqKMIFrS/zud/yRJfLG0jWt7kmXDBkceeN6qvLh33d5Bbw4?=
 =?us-ascii?Q?mQY6Y079wk5l2cYjSbmgjSDM9vdzfEalVIYMSe3p3H30lGmkg2iDZ41kyI9G?=
 =?us-ascii?Q?ng4c1Jje5beyQsqMmY2lpIKVJ0nR3ZLuQHeYwbZxy89PFlIbk5dxAfPj0kvl?=
 =?us-ascii?Q?5KO16KPYOfvmEf+hEtDiwcxiZBIQ8E19IPhE8CWmf2dK8RCz/ceyy4txlrk5?=
 =?us-ascii?Q?7A+fDywlyxuuAUl4/ADxAuY5lmjDD6KJsDGUk6YielOEzNiu4W+ixu7pggT1?=
 =?us-ascii?Q?OkJeobVxVd+1AxsgLZmz6wogwzDQfeCaejjmE5lJpFZfxCjPOMG3QnHCGCSC?=
 =?us-ascii?Q?LfVKgbcLuNsNZ7D58jHHrmp1mwjRss47T/Kx9hbSlB5ht03iP6n2Jan5u6bi?=
 =?us-ascii?Q?u6EALwE6k8TTFoLcWTxQ0W32kwX8ji+LfAVdp4zxFtNSYdPZ7S+8YiU3w9fx?=
 =?us-ascii?Q?MUaF9tj3Bm/87vu0BVA4PzXB8SnrjvbebfREFbmc5H2+PM5QvKX9suyTbFVL?=
 =?us-ascii?Q?echHVa5ZKbedPPzC5ZrA1mabnYTjCZ27OuEjY9CfEF2/YFiPW1F+29qlKpIa?=
 =?us-ascii?Q?3J1gKDM7jrCWcbzZmuQw7ChwpAzjkWWz2kXyc+YGgTWAXz/zVPy2LDHTIr1F?=
 =?us-ascii?Q?Z9Saa0urQLIY32Kx0lLvkMxvO4M8nUc3nQMwpomGhgy/Z3m2IYTxK1UyOLVS?=
 =?us-ascii?Q?3HEjwMNPDYkwFbzeoXv6Myy9gJrAYcqVWdKbmp9+RjXsWOdqXQZx91iof1Gs?=
 =?us-ascii?Q?VuW6TeZLETMq55EIUDTpBqycmCJOsNrm29VMHO6E6WKvZAEzVYqPgpEbHbeb?=
 =?us-ascii?Q?kI3O983CORnrsQlzjKTHNBTZZjyFm804nMukSfMcVY43K2i5Yb3KoErQP4rP?=
 =?us-ascii?Q?5/LXAp/IR2KhdLxdRVXkIF/tZOYydBk9UgQjVfhpYz/CNYdM9Xu9OgE61v9l?=
 =?us-ascii?Q?P2bbiGqK7SffR4jkef+zutuaq/ftMaXRr3vCpnhWweaM4WjA6jTFwtYvAXLe?=
 =?us-ascii?Q?U72pB76fvzjSIep3pEJ29hCxVOleE7KLnpFimsQZoBlaIzt7nMM9ZCessT7g?=
 =?us-ascii?Q?sFQGpySaf/+hdpn83tBA195pCLqYdmtRu29lNwVK097+HQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?66MCkCUqWz9u2FOontDXGh4Fjr+nBx34zxVHrvM6OA/fHt9yqUfnF6u2DYiG?=
 =?us-ascii?Q?zv6mioO0SafSfe61AnNIwwiTxMkypJqel2Cev9JxOeo0Vz1di0zdOKUY4odN?=
 =?us-ascii?Q?l2fmuhXzf1Jxni2/Diomajal+iVkyB0jTYFgxWvOdr8ucPBjjiJ+JRlL6h8I?=
 =?us-ascii?Q?aHVeiStrH0b2GsHXXMnksZsCScFHs+YDbAVxm27/oD9ARHJamOVDJBF/QQYF?=
 =?us-ascii?Q?wN/UbLfaQC71DdovMOYntq0PdlcAGDq2s+i2h18WKom2HbzjE5e0EH6v5TPu?=
 =?us-ascii?Q?jrT7Z/mKZpWQXEOpARTG0lpHpvidj+3/K3waRpiTVekzq106b11J89qLs8la?=
 =?us-ascii?Q?uojka+Xrk2DGyIv4MXXarD1sqUqYdFByt6eZa1EGAYEAPEdXqRtWmRmrL4Bn?=
 =?us-ascii?Q?P/D++1eW7tDCDno9zITOT5y4OTAs4qIdj7rRDwS/j0uv/ag+rI4gMBgElr+S?=
 =?us-ascii?Q?3eQhLdetXkJSBW90deXLoDLCvaLxNGnLz3YSQscarS1TVe0/OAWX34jSd2x3?=
 =?us-ascii?Q?EUQZT4kb4+kZEnABZ3AI96o0S8PVzpQ1larBFAutocq3soXc5LSR5g0jckja?=
 =?us-ascii?Q?7WETpSem2As7bBYTu+iDSqk6udcvLTrTaU8R3LXK/uVUkI7orxV/RlxXYIw+?=
 =?us-ascii?Q?KPTYMBIF1vQtqIAZGzehvmNK/s7hhEi4aTnZqSqFFy3ZG5VB56FV+nDjvDIP?=
 =?us-ascii?Q?PYz4DUnhMRbHptFHnJUbZS0yLaoXZYl4mIUvG+Rp97FrBlNdWQkSnDUr8Vsu?=
 =?us-ascii?Q?06iLtD68jNOk8VHDiYS+ZfW989Nv/SERRsRbSiSaFfXcVq9BIVIFLIcPF1n6?=
 =?us-ascii?Q?VSsLGYFET72dd8XtiYoMivcsP3pZ8vy/JiHC21WfJNIrTiZnIJeSFMjox20Z?=
 =?us-ascii?Q?q0NypuMlbJQs1WWOXxt/cpcxuSvZk1P8SupZUWH/ijzdesc2TF15gaanFeCe?=
 =?us-ascii?Q?7C+md0cIS5rEgdwqTenT/vMnGTEz9CsXXy8xDhtBnS7Hf6Z5PpFrPdFTJUoW?=
 =?us-ascii?Q?CLCXvW2E9uESRGBzZxistm+XoSW+vNEPsxYrD1/FbGh8jOplxvbaJC3WiTb/?=
 =?us-ascii?Q?b5a+OooH23lVbbhFJL1iTOI+Gp7xzWFu5Lh4RvII57SmdwpDpZ4pGRtYN41g?=
 =?us-ascii?Q?7obrrE4DDtgUvB2L1Kw5srcwetynogxNz+cVmxia3nwHu1hegqtBh22IaQKR?=
 =?us-ascii?Q?ZhTzJfjODFK/+YtKWUfUlLNt4rK5VxhTGyW3QKcZEwH4UeCDYopanT+Q9stt?=
 =?us-ascii?Q?s+Cyv+ZcXiVrK9SDLc/MpI1tGY8s7gerBJctlIV2+msMivoP/Ipmo4+042/j?=
 =?us-ascii?Q?ZLX0hCYNFwkZ6H2eM7X/E9qoQu4kubayrD6NsDOqb1vBwLYUgx0Js3pQzlrR?=
 =?us-ascii?Q?+CN5iDGWV3xgpgPOHClkM02XnK+YkKa217C5Hh+JcnEO81mIEohjBkvAwV/a?=
 =?us-ascii?Q?rSGjC7atQhJVSfVhVmzXLF20hlwd9//v7bu5+s8oFLulGO3QtJuCx7CII1f5?=
 =?us-ascii?Q?PFOtzv1GugdlhXU5gkQqvWE/GjPOo/rL+9ZrLuL1QtjjsUar4xs1V54EIZgu?=
 =?us-ascii?Q?fzEajPtvYouPsLp29oeGNBJNH9MOEFgsR97Pup29AW4dpIxehWWmFE8NrRPx?=
 =?us-ascii?Q?Wg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5be8fd90-3b20-4b15-4e31-08dd25551761
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Dec 2024 02:29:15.2152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rbQvWMl2MipOPozcutyRr5IsXfqsj53sd+uT9FWqGO/LmnxaUaQwNzTOQ2gUS42+UJFrW2pgyHCqK8eX3o1Cnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6839
X-OriginatorOrg: intel.com

hi, Eric,

On Wed, Dec 25, 2024 at 01:32:41PM -0800, Eric Biggers wrote:
> On Wed, Dec 25, 2024 at 02:50:22PM +0800, kernel test robot wrote:
> > 
> > Hello,
> > 
> > 
> > we don't have enough knowledge how to connect the changes in 55d1ecceb8 with
> > the random issue we found. we tried rebuild kernel and rerun more till to 200
> > times for both 55d1ecceb8 and its parent, still observed the issue on 55d1ecceb8
> > but clean on parent.
> > 
> > 1e6b72e60a5a16dd 55d1ecceb8d6a5c9ceff7c65280
> > ---------------- ---------------------------
> >        fail:runs  %reproduction    fail:runs
> >            |             |             |
> >            :200         29%          58:200   dmesg.INFO:task_blocked_for_more_than#seconds
> > 
> > the config diff is:
> > 
> > --- /pkg/linux/i386-randconfig-011-20241220/gcc-12/1e6b72e60a5a16ddda9c0669da7538f497838d0a/.config     2024-12-24 17:07:56.621157765 +0800
> > +++ /pkg/linux/i386-randconfig-011-20241220/gcc-12/55d1ecceb8d6a5c9ceff7c6528075bd0ce4e8366/.config     2024-12-24 15:40:46.814065639 +0800
> > @@ -5700,8 +5700,6 @@ CONFIG_CRYPTO_HASH_INFO=y
> >  CONFIG_CRYPTO_AES_NI_INTEL=y
> >  CONFIG_CRYPTO_SERPENT_SSE2_586=y
> >  CONFIG_CRYPTO_TWOFISH_586=y
> > -CONFIG_CRYPTO_CRC32C_INTEL=y
> > -# CONFIG_CRYPTO_CRC32_PCLMUL is not set
> >  # end of Accelerated Cryptographic Algorithms for CPU (x86)
> > 
> >  CONFIG_CRYPTO_HW=y
> > @@ -5798,7 +5796,10 @@ CONFIG_CRC_T10DIF=y
> >  CONFIG_CRC64_ROCKSOFT=y
> >  CONFIG_CRC_ITU_T=y
> >  CONFIG_CRC32=y
> > +CONFIG_ARCH_HAS_CRC32=y
> >  # CONFIG_CRC32_SELFTEST is not set
> > +# CONFIG_CRC32_IMPL_ARCH_PLUS_SLICEBY8 is not set
> > +# CONFIG_CRC32_IMPL_ARCH_PLUS_SLICEBY1 is not set
> >  # CONFIG_CRC32_IMPL_SLICEBY8 is not set
> >  CONFIG_CRC32_IMPL_SLICEBY4=y
> >  # CONFIG_CRC32_IMPL_SLICEBY1 is not set
> > 
> > 
> > so we still make out below report FYI.
> > 
> > 
> > kernel test robot noticed "INFO:task_blocked_for_more_than#seconds" on:
> > 
> > commit: 55d1ecceb8d6a5c9ceff7c6528075bd0ce4e8366 ("x86/crc32: expose CRC32 functions through lib")
> > https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> > 
> > [test failed on linux-next/master 8155b4ef3466f0e289e8fcc9e6e62f3f4dceeac2]
> > 
> > in testcase: trinity
> > version: 
> > with following parameters:
> > 
> > 	runtime: 300s
> > 	group: group-00
> > 	nr_groups: 5
> > 
> > 
> > 
> > config: i386-randconfig-011-20241220
> > compiler: gcc-12
> > test machine: qemu-system-i386 -enable-kvm -cpu SandyBridge -smp 2 -m 4G
> > 
> > (please refer to attached dmesg/kmsg for entire log/backtrace)
> > 
> > 
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <oliver.sang@intel.com>
> > | Closes: https://lore.kernel.org/oe-lkp/202412251418.8e78094d-lkp@intel.com
> > 
> > 
> > [  996.907142][   T25] INFO: task swapper:1 blocked for more than 491 seconds.
> > [  996.911246][   T25]       Not tainted 6.13.0-rc1-00013-g55d1ecceb8d6 #1
> > [  996.940897][   T25] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  996.960487][   T25] task:swapper         state:D stack:0     pid:1     tgid:1     ppid:0      flags:0x00004000
> > [  997.029537][   T25] Call Trace:
> > [ 997.046615][ T25] __schedule (kernel/sched/core.c:5372 kernel/sched/core.c:6756)
> > [ 997.060058][ T25] ? async_synchronize_cookie_domain (kernel/async.c:317 (discriminator 9))
> > [ 997.070156][ T25] schedule (arch/x86/include/asm/preempt.h:26 kernel/sched/core.c:5865 kernel/sched/core.c:5885 kernel/sched/core.c:6834 kernel/sched/core.c:6848)
> > [ 997.079936][ T25] async_synchronize_cookie_domain (kernel/async.c:317 (discriminator 9))
> > [ 997.090893][ T25] ? do_wait_intr_irq (kernel/sched/wait.c:383)
> > [ 997.109522][ T25] wait_for_initramfs (init/initramfs.c:767)
> > [ 997.118460][ T25] populate_rootfs (init/initramfs.c:778)
> > [ 997.126493][ T25] do_one_initcall (init/main.c:1266)
> > [ 997.136390][ T25] ? do_header (init/initramfs.c:771)
> > [ 997.147147][ T25] ? rdinit_setup (init/main.c:1312)
> > [ 997.160654][ T25] ? rcu_is_watching (kernel/rcu/tree.c:738)
> > [ 997.178488][ T25] do_initcalls (init/main.c:1327 init/main.c:1344)
> > [ 997.195442][ T25] kernel_init_freeable (init/main.c:1579)
> > [ 997.199167][ T25] ? rest_init (init/main.c:1458)
> > [ 997.208072][ T25] kernel_init (init/main.c:1468)
> > [ 997.218814][ T25] ret_from_fork (arch/x86/kernel/process.c:153)
> > [ 997.225966][ T25] ? rest_init (init/main.c:1458)
> > [ 997.231504][ T25] ret_from_fork_asm (arch/x86/entry/entry_32.S:737)
> > [ 997.240527][ T25] entry_INT80_32 (arch/x86/entry/entry_32.S:942)
> > [  997.318483][   T25]
> > [  997.318483][   T25] Showing all locks held in the system:
> > [  997.346428][   T25] 1 lock held by kworker/0:0/6:
> > [  997.350161][   T25] 4 locks held by kworker/u4:0/9:
> > [  997.396160][   T25] 1 lock held by khungtaskd/25:
> > [ 997.399871][ T25] #0: 83f91ab0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks (include/linux/rcupdate.h:337 include/linux/rcupdate.h:849 kernel/locking/lockdep.c:6744)
> > [  997.478673][   T25]
> > [  997.501376][   T25] =============================================
> > [  997.501376][   T25]
> > [ 1161.445030][    C0] workqueue: psi_avgs_work hogged CPU for >10000us 11 times, consider switching to WQ_UNBOUND
> > BUG: kernel hang in boot stage
> > 
> > 
> > 
> > The kernel config and materials to reproduce are available at:
> > https://download.01.org/0day-ci/archive/20241225/202412251418.8e78094d-lkp@intel.com
> > 
> > 
> > 
> > -- 
> > 0-DAY CI Kernel Test Service
> > https://github.com/intel/lkp-tests/wiki
> > 
> > 
> 
> Thanks.  Unfortunately, the issue does not reproduce for me when following these
> commands.
> 
> The kernel does panic from not being able to find the rootfs, both before and
> after.  That seems to be caused by the rootfs from the job script not being
> available on the 01.org server, as indicated by the following output:
> 
>     /usr/bin/wget -q --timeout=3600 --tries=1 --local-encoding=UTF-8 https://download.01.org/0day-ci/lkp-qemu/osimage/pkg/quantal-i386-core.cgz/trinity-static-i386-x86_64-f93256fb_2019-08-28.cgz -N -P /home/e/.lkp/cache/osimage/pkg/quantal-i386-core.cgz
>     Failed to download osimage/pkg/quantal-i386-core.cgz/trinity-static-i386-x86_64-f93256fb_2019-08-28.cgz
>     cat: '': No such file or directory
> 
> It doesn't print the error information from wget, but I checked and it is HTTP
> error 404 Not Found.  Thus, there seem to be bugs in lkp where (a) it links to a
> non-existent rootfs, and (b) errors downloading the rootfs are not fatal.

sorry for this. I just made the upload. the issue should be gone now.

> 
> Anyway, seeing as you disabled the x86 optimized CRC32 code:
> 
> > +# CONFIG_CRC32_IMPL_ARCH_PLUS_SLICEBY8 is not set
> > +# CONFIG_CRC32_IMPL_ARCH_PLUS_SLICEBY1 is not set
> 
> ... that code is not even running in the kernel.  So it is hard to see how this
> commit could plausibly have caused this issue.

thanks for information.

sometimes kernel test bot generates false positive. it's also very hard for us
to connect the code change with random issues. however, by rebuilding and
rerunning, there is still similar results. so we just made out this report FYI.

if you have patch want us to test, please let us know.


> 
> - Eric
