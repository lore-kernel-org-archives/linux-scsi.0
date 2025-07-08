Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FFC264F9C
	for <linux-scsi@vger.kernel.org>; Tue,  8 Jul 2025 16:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993289; cv=fail; b=cSWgBcWxhcusuHa/2WwYsl1eamOzOgkeD3WSkatnZx7m3lrsIpoDS77hOOuFlALHmLVZwkjNQeY8NG3/HYL+VLRDXXRyBsQxNy8/xOBvSRNuZBpTl0QCwH4/7r9gZf+le3XM3N0aaifde1t8tLYH7xF34B48yl6oJRsaFLU7HL0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993289; c=relaxed/simple;
	bh=Ktp5N5r2xdOSytBPRwEgoG0NfW/sRDiDfnf2mK5LPQE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AgIK2L+U9eamBpYEYMZZnqCMPVYe3JIzx21Pwg/EGzMif6gJ/CWWZ3rt/JB5vwSKWpguB/JyI5/JJgHxT6K7cv8/eMuecNyfG932tLPihKHv/J1U9CERIp097YS+PCQs4vO4wRRQh7V+s7Q+mNpdMDrFJeR+7nR1/sLe8DTNeYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SGL5C0qx; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SGL5C0qx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751993287; x=1783529287;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ktp5N5r2xdOSytBPRwEgoG0NfW/sRDiDfnf2mK5LPQE=;
  b=SGL5C0qxcU6ABDCmeNooGwNBTjrsRbpM6AWxniwVCm27FxbQDqAslx4g
   f9vcvl/wqLCPXlSbxpaSGJfPEwbPZrtC8T8ZfCM3EU2PL5hvBaH/osb2E
   kAOL7q8bqbYJqEyUrCc8H/9F+N+cyCdcNJWTzSnR2icknLh+pxrIZVORA
   z5TkyafCrABzYownIX1BgrsaIj3M+h0yRWFdqZGRaZR71O1MSodNnIcn3
   B+hxd3PYRgpZ4kHrmt5chcjx1A7H8gMYcPaJyjzS1pZe9tT2kuTCgoNQW
   9yPHE/DITcDCvQGl5EkxB6Qwa0gBGt3BjUhWHQdALSRw8UvF/ix+zGtyE
   g==;
X-CSE-ConnectionGUID: XPFCVqcOQI633BSWT0BD4g==
X-CSE-MsgGUID: Yw6q7MYQRzyRz3CGx98yTQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="54368844"
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="54368844"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 09:48:07 -0700
X-CSE-ConnectionGUID: VF4a7sXcTP6oNxOR3OUt9Q==
X-CSE-MsgGUID: WR09KDTARm2xBacLL73aLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="159863917"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 09:48:07 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 09:48:06 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 09:48:06 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.55)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 09:48:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HI00bJ4ZT55G6EOgcuc07wnSqz254zed8RkdQhARiLGy32dTGCvzGwBwFK4ndiA/OI5nGMlmJ0GLe/pDt6/+RTps+trlp7cgJvgxOg2hVuy/NK36zYUFGJdvNMx5d0IHWH14anb86/vBNrrujEytaQkfyGIR3JgjKgWalG7KbLa7tCIbUHq+zB0fzqQvdTj7IFeidpLWFjfqLPEAfVzJ2ifbXf+62C6u9OOW+okWLoAcz0lz5KyHIjQPDBidLOi9k2BD4zC7Ii/JAybKFBDHdezm5DPjKdnU89xzPO+jdT1dUO8ZdKJP7xdxE2EJUDXK3I+iKJSo7MlCviH8vf2C/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qBBVC0D7KXW3VTFZYK6J/MszMcT51TxYdOO5hOd5xyA=;
 b=gSqFRwjwuS/jYmhwTpYsn4ARNA02Q64Tk/PrsEiBoVTDMIR01g4tpPUYyyaBLjw+vQXGlKldRWCY7Fd3cHlEsFLhQBVZ0kVELr29v3Gv6YdtjzIsmoMGzM0osGgaJ9fN2k5LFP8RZNQ15HBdCCCuhYp5HkEPtGvbPNf/4S2hr+Oee710in4hq8EbMCgiDO6kH995804Rix5rJJ2mUFK9bfB+f07k5RCN1a2H04GBcezAJyqS98DdcShmCvnAn5anJipTpjxR5JI6JudkvTVtkcW6U/CgyLWRh8rlLukPJAdnNIb2Q3jvdJtwnQ+ee3co7kmFAkqNh+iZySPtLvA5Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by DM4PR11MB5245.namprd11.prod.outlook.com (2603:10b6:5:388::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Tue, 8 Jul
 2025 16:47:21 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905%5]) with mapi id 15.20.8880.029; Tue, 8 Jul 2025
 16:47:21 +0000
Message-ID: <3671c436-a4a5-4832-9816-8fff30005755@intel.com>
Date: Tue, 8 Jul 2025 19:47:17 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] scsi: ufs: ufs-pci: Fix default runtime and system PM
 levels
To: Bart Van Assche <bvanassche@acm.org>, Martin K Petersen
	<martin.petersen@oracle.com>
CC: James EJ Bottomley <James.Bottomley@HansenPartnership.com>, Avri Altman
	<avri.altman@sandisk.com>, Archana Patni <archana.patni@intel.com>,
	<linux-scsi@vger.kernel.org>
References: <20250703064322.46679-1-adrian.hunter@intel.com>
 <20250703064322.46679-3-adrian.hunter@intel.com>
 <83eb436e-a76e-472b-9d50-c6db52b399d2@acm.org>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <83eb436e-a76e-472b-9d50-c6db52b399d2@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DB8P191CA0021.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:130::31) To IA1PR11MB7198.namprd11.prod.outlook.com
 (2603:10b6:208:419::15)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|DM4PR11MB5245:EE_
X-MS-Office365-Filtering-Correlation-Id: 89a3cb77-675b-43ac-9a1e-08ddbe3f1b56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Z1ZZb3h0TkNRd0ZDd3JMVHMzL2Z4dlQwN2R1dEhzNVMzeGRsWTZXWkJwWjZ3?=
 =?utf-8?B?b241VmtibG5ZNXdZZVRNcHV6VjM5aGtLSmhZNlpGNEJ2cVh4cVBwREEyS3Bn?=
 =?utf-8?B?STFSNFYvYTNyMnBHSFVzVGIzcjNPb1hValRFeXh5S2Yxc2dKc0FKOUZYanh0?=
 =?utf-8?B?ZFphS1NpN3V6TWR3WStNb2JCbTRwa1B4dThmVm5uZ0J2Wktidjliem1kckUv?=
 =?utf-8?B?aThwUmxoNVM0UncwUkltWitRRE9nVFBzUGdDSHZvWTUza2szRC9lOXhLR28x?=
 =?utf-8?B?cXFiT25CczliekRQUGJpcDRwVnBsbGR4MlIvdnhIa0JkU1RsY3c1OG1hQmpM?=
 =?utf-8?B?OTRsTVY4cGJXSUZWc2tISitnUTZ2cVlJekgvQWhncGV5UHhoZTNVbmJYVlAv?=
 =?utf-8?B?dExKVUpYWUI4T2RUQndERWtOWGdRUDQ4Z3g3QTdwc1h0aktIaHA1MEh4dFpL?=
 =?utf-8?B?cDdFdHNNQTVsNmpEaXBMdU1xeThzR1JEamFrOG03RWtITUlxbmJQZ0hoY0lE?=
 =?utf-8?B?T2xmZ0ljU3NFR2Y3MU53NUdMNlZOQUIzc21IVFdhSmphckRYeEVnekxja2k2?=
 =?utf-8?B?N0VCWUliVUxCQnNvRWRMQjdZYThEdlUzZE1NaklpaU91SGplWnprdVlVTnR5?=
 =?utf-8?B?eVk4dVRpSnhQRGh6QWZFUWVzdCt4OWdnbWwyU2V6aXJIK1pOai9DeXJoT1or?=
 =?utf-8?B?UEovM3pIcWdGUVh6OHNaRHhFZEZmYWI2YkRicE1zMlJOMEpiNnNlQXlEczVp?=
 =?utf-8?B?QkZZUnRqdzVPK3dIQzRCTjlnYzFDWEFMTy94Y0EvNTlHdi8yaGhEYXNQUU1M?=
 =?utf-8?B?d2ZWQnUwdFdtTURDR1ZaQ3RNUGlvTzN0TUp1MmtmS1JuRGdZSFo4R251NTd0?=
 =?utf-8?B?OHRuT3I1cmYrQUJSUWJrSVdWd3Z0ZGUxd0tWdFA4VHhGSjM3SWJJamo3OGRB?=
 =?utf-8?B?c2h5YTllbTd6Q0tiUmllRU50MW5ZSE9mUG40c3o4UHpRWUV3SXVxR1JWczQr?=
 =?utf-8?B?YkViL1Bjb2NtRWE0dGNCd3ZRUFpxSVZ5c0Zpd1U4WGZLa2lmdmo4dHV3ZHhh?=
 =?utf-8?B?MTJQeUVYMTB6MTlaQUw1ajAraUgyNSt6cEh5cEFtVDk3TXF2L2dCaXNwcWR4?=
 =?utf-8?B?cWVINlhsSCtkR1l2OXVSeExxOThwRGMvd2tpWWVGaS9tN0x5SjJRdlJvL2hY?=
 =?utf-8?B?VElLTlJOZGEwRGYxWW9PNkFYN0wzYi9GMnRqWk1BMFpDam82NWtnZDBQOSto?=
 =?utf-8?B?RTdSc29RN1lreUQzTkdxNStlWW14SFhGTXh5Z09nbWNmaGhReDNmaWFMVlZw?=
 =?utf-8?B?UXJUc29hV0txdVBhMGZjVVFUTmE3WWVVamNRRjl5TEFyQkY0VkowUitKdWlU?=
 =?utf-8?B?UEFwczRFSGcwc0xzK2dhYWdyU0dvdEhtSVVwMXV1Sk5sNG5PRUZtaGgyZE1w?=
 =?utf-8?B?VjJtOWZ3b2dzdVdmdmFFUmc3WUpFSEJoUXZKOHBkbStSTklIMS9YdjlhL2VX?=
 =?utf-8?B?MVdNTGxHY2swV1JMMTBuYk53YVBucU9pdnA2dUVpelFwZkRFYVpDem80TlFI?=
 =?utf-8?B?b3lYOElpenlwcXliZERHdlNJN0J0NDZ3bmxSSHV3YzFuVDNoMXZmZzZiOTZa?=
 =?utf-8?B?WmZ3VW5WMEpwbWFZRkd1ODE2L2dRQ1N6SDMwMEh5WTVHc1lMRUhITGN4dFlR?=
 =?utf-8?B?YXBDdk8yenpCQUhYOVBWMHdNNXZOR1QzWm5xSjRycTU3c0gwWGZ0NWtwLzZ1?=
 =?utf-8?B?MUo1aE44ZDZXNVN4VnhnaGs1cnFlbjEraS9YQmVqQ0lOakdLOVBYR295eDFp?=
 =?utf-8?B?U2txTGV3bHBMT01VOUovS0xLZEROWm5FZGY3SGRHQm55aXBjWXorYVdET3FH?=
 =?utf-8?B?aTBCOEowZml6MVpFaGRjTjI0K3M0UDBpS29aQnBUZzRHSHFITlY4ZlNRUE5D?=
 =?utf-8?Q?9gFMhgBC1jU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXc3U3A0cWNwbUVIZU5BaXpXMW1NcFhsK0RkUng4dkJMa0ZvWGpyV3RiT1F2?=
 =?utf-8?B?VjdUaUloeWZLbnNRMU1xc05qbHpaS3ptM1l1STk3Y1V4cmhlaGo4eVVkZFN6?=
 =?utf-8?B?VG1iM0o3MU50OU9HSHNnNW5TUTIyenpwT2JWM0U3cjBBK3ByeFA4R2swOUk0?=
 =?utf-8?B?Ym5Sa1FtOVNpMXZJMGlVbDFobFh0RTBaZEVZM3ZVNldQeXg0Yk14K1NkWlBv?=
 =?utf-8?B?Q2tHeEYyWTZQSXFGTTlEcHNxbkpXUVpRWXJIMGZsUlRTY3Q2bDlQZDRIOHp3?=
 =?utf-8?B?T0p4Y1VKdDZHTk1EUFduM0FNWUFzaGQzTzEyTlpUV3RaYjZrUjQyeUhzKzlh?=
 =?utf-8?B?ZmxvY1RWbXZrWFJtQmEvMzhobThxbkV1UTdCWHhTM0Q4eklMbHlubGE3YUVY?=
 =?utf-8?B?WkVocE5GQ3BFL1gydVVJYmY4NDF5L01kM1VBTFB1MTk3S1JXaW9QV0ZjR1hJ?=
 =?utf-8?B?K2UwbUMxU0hzdlRpVlg3UUZMbnI4OUdEZnZuZEdEWFgweUJyRHdta1E4aFNQ?=
 =?utf-8?B?SDNxSkFUdUNqNWxuNHluTkI5Ri9CMkhLN3d6ZlJGR2V1Y2N1MWJaV01jdlZh?=
 =?utf-8?B?VVJnejZLTmppcWFSY2xjU2hmUUJWTFBRT1FqaE1Ud3AvSWRaRVVhN0JucGxt?=
 =?utf-8?B?bk0zeUtGMndDeU85TWFqUXk5T0xTVWYrOWVOcW5haW9MbUwvMUZDNDhtcE05?=
 =?utf-8?B?UW43VkFuUG16V1l6MWJiTndvR0oyZDVNd1dOdkdGVU1TdGx6M05FV3hidlhs?=
 =?utf-8?B?VEpySGpkSUJHYXhmeDd4ZlljaHp4TDRnOXAydVlybHl4VzhRK2RraGRLcHdI?=
 =?utf-8?B?WVVHdFdJWm8rckZpYnZkbzJkQzRNQ0o5NXNHR0FKeEdyZTdvUmg2Wmpjc1VF?=
 =?utf-8?B?Sml3dCtGZjk3dGVKWXhxRDUvRGNNQWhlTDlmaTJYNDR1cTYrUVh1UUZOYVpR?=
 =?utf-8?B?UWtSUWdKamUwd3ZOc3RwakZEY1RFR2NmcW1rYjBiOWdndzloVnNGSEdZaVV0?=
 =?utf-8?B?TzRSaWdiM2NvSWZjdlBFcll0MS9lVXkxZTZtd0pLNjM2VWJWY0VYTGFDSG9Z?=
 =?utf-8?B?Ujhsd0NDYjhFU2ZYWUFiQVBWV1IvWWlQR1F2OEEzYnFrQ3BIOFJWMHZnck9s?=
 =?utf-8?B?Mkh0T0tHN29RN2lEMGpwK1M2SXBqeHdBYnl3MVF5RnpwNVUyclA2bW9ZeXRC?=
 =?utf-8?B?dGNWTUlKVTVSM1NlajRNL1piTk1LcTNGVkw0Y2lUR3FvbHhKNVY0TzBMMWM1?=
 =?utf-8?B?dmphajlZZjc5MFkvTlZpUm90OUFZa1VzTyswVmdIdUszcHFCRzBKQmYwZ3B2?=
 =?utf-8?B?YW5ydzgwMHBIM3VobWFNU3hmZmVrc0ZwbU40Vk02UGxwRG56NzNJU3JPS3JM?=
 =?utf-8?B?YUd0OWdjaGR2eGZMQjc4RE9xeTFvTTB0eFJUemxQVlNEUDM5dVpvRHhaQlhp?=
 =?utf-8?B?bGFkZk05OEs5bUhDNnVqK1FSeDhSRzRtSHZjcWdrMktlRWZPOG1iRGR2cEFL?=
 =?utf-8?B?eHYvSUg2ZFVzQUphblpJNWxHSEZoVHh5TUtJSmcrWVYxSmJ4dHJWS0Y4aUVj?=
 =?utf-8?B?SVdSNWJRUVZOMjdMWFVaNCtFa0pJa2RHOE1HUGg2dnIyR2VQRFJxa1E1eFdo?=
 =?utf-8?B?TVE4NUxqcVkwMmIzS2ZPMmpubW8zQnVVcWgxVWpFL1JUVlRNSjdHV0ZrZVFG?=
 =?utf-8?B?bngrNXdiSGNSSFZxWFRoSE1INlRYVkUrUEJmQXNWQjhobkk2SG45NENZWElj?=
 =?utf-8?B?djBlZ1IyWjJnWlRaRzdUckZCZys0eEE3R0pRcTZndjBqZERmWlNLa3Q1Rzg0?=
 =?utf-8?B?VGp5Y0pVSjhFSFltazcySGY1QjBuZ09MUUVwemMzd0tVOWFjY3ZGNURTWHZW?=
 =?utf-8?B?Uk1KaXVCZjlrS3doT0RjR3hNQXdYMXN3L0oxemlSOEVnbjZQVXZYcUZkZGZs?=
 =?utf-8?B?d0VpSXZ5aTJhcEtWRTNBOGtCSG8xM2UvQ1NvbmJ0dEZSdGZheGhMa2NWY3ZY?=
 =?utf-8?B?S0dPL1lkTXpNdEwrK2srZkdDRG1Cc3VPd1Q3cFd6QThKbWNBMWRRQ2RyK0hH?=
 =?utf-8?B?UWpTam4wZytzL1dRUTBnUE9UaXN5TWJIVWl2TFpFWTN2VzFFUzN3VlNBQnc2?=
 =?utf-8?B?dUtSRFJMU0VuN1k5cVBWYVB1T3Z4OXpkMnZrOGUySXhQWkloaWRYUkExOWZv?=
 =?utf-8?B?Vnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 89a3cb77-675b-43ac-9a1e-08ddbe3f1b56
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7198.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 16:47:20.9804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: saIUi7I8u0VQXEgM2zOkF0y/WCxuJf2eOT/8N2p/gMHdI8SV7ZQ/KRNtZVOLiso6lls5rOQyGSPB0zFgi/fJPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5245
X-OriginatorOrg: intel.com

On 07/07/2025 22:57, Bart Van Assche wrote:
> On 7/2/25 11:43 PM, Adrian Hunter wrote:
>>   static int ufs_intel_mtl_init(struct ufs_hba *hba)
>>   {
>> +    struct ufs_host *ufs_host;
>> +    int err;
>> +
>>       hba->caps |= UFSHCD_CAP_CRYPTO | UFSHCD_CAP_WB_EN;
>> -    return ufs_intel_common_init(hba);
>> +    err = ufs_intel_common_init(hba);
>> +    ufs_host = ufshcd_get_variant(hba);
>> +    ufs_host->late_init = ufs_intel_mtl_late_init;
>> +    return err;
>>   }
> 
> Shouldn't the ufs_host declaration and assignment be combined as
> follows?
> 
> struct ufs_host *ufs_host = ufshcd_get_variant(hba);

The variant is not set until ufs_intel_common_init()

> 
> Otherwise this patch looks good to me.
> 
> Thanks,
> 
> Bart.

