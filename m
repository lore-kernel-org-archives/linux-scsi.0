Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543A81E0DD8
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 06:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776320754; cv=fail; b=UPqDFiaTQfTrNqp2sq6I8Wng/J4f/fN4d2y7myiWh4PHraRXGc1PNShakEu241anr458j3HHlVHi09br2bwB7gjinaQ+ggSqXYBWd5UUkrns5uZZCoimUlOg6fX1Z4rJcMTBj4oFNpJ34v1xv10hrkiB9mWaa67zFIesyXPs4Zg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776320754; c=relaxed/simple;
	bh=U8aWOBueARvzHK+URyvGH/klNNABN7n+iDoXWBZURgA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PsN1uYxqPiyRn5UEnfib0UhrRHjawZhHih2Yi1Nz3/Nouu03+mEKNOsWutNVXpgTByqvUAJZ/yef2bhb5b8IFJkGTE0518U8ipukfG7fk0QcaANSklraG/3hmlCWz27IpG2LavxDfX+9MZZW2rbhZnE9ECEeNE31bs+13sfA7f8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=F3axXMrL; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=MAPcBkIE; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="F3axXMrL";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="MAPcBkIE"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1776320753; x=1807856753;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=U8aWOBueARvzHK+URyvGH/klNNABN7n+iDoXWBZURgA=;
  b=F3axXMrLrKnKDiHi4ViX29U7wdJ/BQXUgQVYGg2BUMl9yBJhRV30Sma4
   FSlIq8lnQ6Ub2y7FrkBAXK+zQ7ha46R63diGflDem4JrdbF7994a/o8Nt
   CYICWm/MaD3MK9CHTvxe/ZZ0uZnjQUFTROdl8aZCWHlYIZct3rhhc/JG/
   iNrLPtbzxOUZotsuHUq6+zKvxxD/XfXB21oPhTILVzwJy59/UVwLSzlc1
   k9yT4iQrXo2K/TpWJNhD1dvsqr+aCKVEmyADxWTwOLORSGIN2o/3xPtqx
   Ta1sAbfIH/z42/I28sTuvbJ7MMB++CpezWKsfHCpJUpoT1hQ/DDBu2Bdm
   w==;
X-CSE-ConnectionGUID: vn0zzInfRi+5jCoW/dwpnA==
X-CSE-MsgGUID: p+GF2XkBQ9GuxxBzAGA43w==
X-IronPort-AV: E=Sophos;i="6.23,181,1770566400"; 
   d="scan'208";a="144136152"
Received: from mail-eastus2azon11010027.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.27])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Apr 2026 14:25:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FzfjPLPWn747eKJgXOvxEk0JdZUOxXSej5p5ibm0FhHylgHB5BndYXnmdX64OkVoYS6zfz8cZc2HytaEpLYxH1yBPHQ47XsVB9LkAZ/DrZsiV59oKtAi818A50SjKbbZ51Fe0wu8l72pI3u+E7SZOJsHT2yokJzTjxBOSLHrCocOZWNephVb1xFwy/sNDJI6g5R4DZqkTVWLJ1Zprsb/hJnAx+Baw4he7Ry7HULnJvMv89fO9DZBIYRGNN/SUcquikaxR3yNhPD1KHihlj4sUw+B/nKyPTlAiA9j08shPNP3OBXFyxiH8a70zEBxGMuhMSKTNv8rqyQ4YtV5ct/2aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hwBvTz8nqn6uDwpmUeQKRFZW2MljtSpA/NiTkwaQWzM=;
 b=P3ZiQTRaknKJ7Aw7R8nbFwyTIfux76O3BE/3+ozW9x+BTA2tLvA04RhkeWkGu31urt5cWiI3DRQ6MrZCbDh3Q3/xdgpvSCayN7pmkE3ePo/tL+gQLSXNh6PjIgF4ZgzztyRZcw+Pf27ue2WlcAuCnepVTR8Cy+iatskooetlvNCyHIF/h9d/B3CvOM0P7SfWTxRAD9OH/uHHndS0Q17mNhFcnC9BEQED1O1Z64d5/Q9bbVS17EtchRuxt8DdV4gr36vD0fBh3NWEqnKfXTf2SbVXaaFFAmQ2ov7d0GkvCXHbPLmLrgg7YrDJwYM9pOb1ugMTsFkiWem54ubE82tlZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hwBvTz8nqn6uDwpmUeQKRFZW2MljtSpA/NiTkwaQWzM=;
 b=MAPcBkIEWpUOrnXvyfs6qAnIQ57LjR8w3OAxictRY8bEGDJN39dIw8vpdWq9AVrKstKwJNrqpyGz5AQHMEAXyOHfnKrdnWym3F/jS7Q/TMtr6qPC3ILGOiz2dUvORJL73yMXkZZSPov0m003jz5jXkiokiGp9Ks3mG0jv2LaaaU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SJ2PR04MB8987.namprd04.prod.outlook.com (2603:10b6:a03:557::20)
 by BY5PR04MB6374.namprd04.prod.outlook.com (2603:10b6:a03:1e8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Thu, 16 Apr
 2026 06:25:44 +0000
Received: from SJ2PR04MB8987.namprd04.prod.outlook.com
 ([fe80::cfc5:d779:604d:ece2]) by SJ2PR04MB8987.namprd04.prod.outlook.com
 ([fe80::cfc5:d779:604d:ece2%6]) with mapi id 15.20.9818.017; Thu, 16 Apr 2026
 06:25:43 +0000
Message-ID: <cf8a43fc-b0bc-4ba7-b91f-1d361487814c@wdc.com>
Date: Thu, 16 Apr 2026 08:25:39 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] scsi: scsi_dh_alua: increase default ALUA timeout
 to maximum spec value
To: Hannes Reinecke <hare@suse.de>, Brian Bunker <brian@purestorage.com>,
 linux-scsi@vger.kernel.org
Cc: Krishna Kant <krishna.kant@purestorage.com>,
 Riya Savla <rsavla@purestorage.com>
References: <20260414182748.39776-1-brian@purestorage.com>
 <20260414182748.39776-2-brian@purestorage.com>
 <26877b12-7c19-40af-9c1a-e96a84975acb@suse.de>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <26877b12-7c19-40af-9c1a-e96a84975acb@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0096.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cb::10) To LV8PR04MB8984.namprd04.prod.outlook.com
 (2603:10b6:408:18b::13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR04MB8987:EE_|BY5PR04MB6374:EE_
X-MS-Office365-Filtering-Correlation-Id: a6ef0fef-6745-46a6-1166-08de9b80fc42
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|366016|1800799024|376014|10070799003|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	3VorPPN4CG3ci0Vgt1V3ToF0Zq6QvCUpHpKdqoFWG7wlLVVDi3fMgdmuDkY+zHBLBP1DJaPk4NyeA6Oz0xcOzUNNKs9q7A0I7iXbNYYhm5FKi6HvmxaTcftAID3hEBbrQs43FDqV4xBwX7zaTQnsjdNj8MZMHxqdNLzrj7lU6UN4ntlM2m9JyqvpT/U1vonbP9ECNhJvNz+OVTKrVYiebK0nXkW1KXj78ZWUIaiKy0wbPftu4xjyXIiXB+ALhflpnvHXnLkTyIchFjNePIRUlIkcrYsYBM+XWiIdNt2UCzwizV5bk0NGOjhh3z5Nm/BMihSbdp5DmpQMHi19Fph3EwgrnJtpjtuHxeSRki19FhFbiz2/tKQj69lPPrP8UqWhVN0Z3EgZe9sclDKw/l6U60kyqFWdWhmrJuO0B7RjH4JYAnqzf+G82U0JyIlgk3+2dM72td+X1KN89EaZbHxotMa0CTCPoPuXYws/c4S8CQAGBWD2PU+RmjjjzSl4x2AVoVRKZrCQNMa7BahxQ+oofihkchucGCmZaa6XLQ9UkL2plh+bf/PhDla+CnE8lcgvbg9L+37L9EEZtxd1/hou8llwNR2cnKbiZrzbyVlU6r2txNWhhkt9c6AkfsYELktniZT+lShadhkHOD1IXzVgXxrsn37RTqCtWDNqA9eSJs5q5aUrHj0nvFVguXOpG0s3mAzhU4cHCz79eyT4THiPdORB7pkQW9ZS05/c7ZD7ah8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR04MB8987.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(1800799024)(376014)(10070799003)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dUlQRGZ1MHJnenBmZ2pQTEhhQ0pJWGxMRzB1dDBqdHdqS01Iamhzak5FRnRR?=
 =?utf-8?B?djQrNDUwd3czeGQxNVFHQ2VQamM4K2xIRHlHdDBwMmNuUWRtYlRIOEVPS3Az?=
 =?utf-8?B?R1hKdWsvV1FTZ2Z0N01qYnhET1hqSWdrRHFiZmpnTXFjdVJJQ0hkRzFMSno5?=
 =?utf-8?B?Q0FnM3NjZFFoeEZZU0ozeVBvTDh3WWpieXVqSkV4ZStLdmxNUXM2anFnenhj?=
 =?utf-8?B?clNCWTA5WGtHalZMdUNINnRnYTRHSkhETjB2WUdIQmJvbEZsd0pkZkZTckxh?=
 =?utf-8?B?dkU0cHZzRTZSTHRFS3JKUTg5Q3VicjZnQmhleUlSMTJLK01uaUYxSHdCMmlV?=
 =?utf-8?B?bVlucldNdHpnT0xzSGNxNG01bUV0YTcxMlQzOTZ0T0RSYy9SMmlDclBDNXRn?=
 =?utf-8?B?eDVON1FuVmQ3YUo4bGtpYjNsN09Xek1PczN4MU50MU0yQmcxRG5BTFM0ejBi?=
 =?utf-8?B?VmJzUHVMYjV4R2wyM3RvNTBtUDFoRnA2Z0FRZ2VvOFhMOW9wNGJtUXlsTWVk?=
 =?utf-8?B?MmhZWExyNkdPdys4UDM3cW9WU1hjWTRvMXR1ZzVXSS94cXl2TlVxdnlKendB?=
 =?utf-8?B?OG9vbVhyc3kvRExQVHBRcWltL0dRdXNydUgyRGtrWlFsNGUvOEVlV256d3hk?=
 =?utf-8?B?OERTUHVsQWs1T1Z5YmJMV25lVjZMQTArbTBZRFJpYzZoVDJDQVYzemN0ZXAy?=
 =?utf-8?B?eWtidm9LUTdJV3NENDd5RkNCZEt5M2tuNUVoaDBCcTh0eHkwKzQ5L3pzUWt1?=
 =?utf-8?B?VVR4SCtXOTNEOXpZMFRmVnJQLytBUndhZkhYVC9wV1JBd3pDdXRkQURYUFJM?=
 =?utf-8?B?SFEyUFVRR0prZjR6RTZ0aVVmV21ndks2VCthejV5MkxNNHBHcTQ4dkVLY05k?=
 =?utf-8?B?TzBpbzV0Z01qb1lBbHlmSnZ1dDJsZXhOa1YvR0hRby9sV1NMZ3RPV3hFazZI?=
 =?utf-8?B?dDVFNDFWb0MyN0FTTjRnNFlzSE5uY3BhMHNPV3dXV3hwZWpnNjdjbFEvQk5K?=
 =?utf-8?B?V21tcUtscVJLZkt0Yjg2QVNaZitQRy9BelY0aUNiaGpYckJ3ZVQ1cVc5WFRl?=
 =?utf-8?B?YjM5MC9DdElQZHB6ZlA4VjJVU1dVSExqdUYxWmNFaUxVUXhWOUk4Z21wLy9Q?=
 =?utf-8?B?T2VFODFIYm5jQWF0QUUrRUFUNG5YL2NKcnFBSXNDcmdLMTQzQ1hiUVZZZldG?=
 =?utf-8?B?V2N6Wmg4Z0tiWHVHc0FEcEJvdk9CY3M4eGVudEZsMCtjdndrWGkyMnJWM2JJ?=
 =?utf-8?B?MStCSmd4MnFGOGdoanh3T0Z5RVdiWStBVE9Qay9oaFZGL0czUXp5WGpqa0Yx?=
 =?utf-8?B?S0lmUnYyc0k2ODRTays1SnZqMFkzWHB6L3RHU2t0aitFdHlBckc0V3RPakxk?=
 =?utf-8?B?dUxudUhkOU8rT3VBT0pVT2p1S0dkbjJEU0FJcUVhTEFsUkp4SjZrc1N3WmJs?=
 =?utf-8?B?SlhLM2FSbXV5eUVJQ1FyMVQ3Q0VqR0JPRDdLVSt6MFFBU3lsWC85MlpJVWh0?=
 =?utf-8?B?MnBtTk1aby9wZlhBNkMrbGxtbE5MSzFMa1gvQm8vRHNCODlRWGNJYkpFT09D?=
 =?utf-8?B?bkRsMXMyRTRWekp1UGFiV0tqRXRnRUZJeStUZ0c1Nko0WFJRaDBxbE9MMDBa?=
 =?utf-8?B?cnB1bGRDeGRMUEJXQm11Z0xyamRtRmxzeWFYRFF5QjRYamVGcXU3RHY5d1dv?=
 =?utf-8?B?RVI0TUJUQmVHSnJOYU5kNzRSMko4Nnd5Q0dLUGMvMHJ1RDF4V1U3elRYL1Iy?=
 =?utf-8?B?ZjlMSis2dENhSTJvQUo1UDdIQlE5YjkyTDRudjhjak1ydXZZN1Y2M0RRWFNa?=
 =?utf-8?B?QXRHYXFLVGY0VERTaDA4THRTNkIzTVhaU0tFUXhHVlpyNzZsZFJCN1BoZGI4?=
 =?utf-8?B?Umt2enN1UnZOenU2TnVCMDdDNVpXRnJGSSt5SzdaVktxbVVhd0UzdENYb2N0?=
 =?utf-8?B?am9qaTcyaWhXQmxWYnRIUGJvTHFyU2pZcnQvWkJlUUJpUzFRTDUzTXBFWmtN?=
 =?utf-8?B?S25qNDU1YUNZMDFhVjhFcklmUGVzNWVUSFNTSEE4RGZYYjdaUDRleXJJMFE0?=
 =?utf-8?B?V2VHUEtXM3MyM0hVSGJScDlWMVh3U0hDd2drWDBjOWozMTBjMXlLRzRBRU1J?=
 =?utf-8?B?cm9zK0F4cW8xdndJM2pqaHlkbEtSdmZRMWJQMVZMYlNuclFENXhvR3d1QUxv?=
 =?utf-8?B?QWp5bURZbFNPS2hjODlPdXhOZUdqejYwTTkyZVNMbVhRSHFZSmE1VnNkZWh4?=
 =?utf-8?B?NDhCL2tvUEg2U2xnNjRCdFBxcElLaGdhb2wweHluNlhVd0tRbERzZ2dQZXAy?=
 =?utf-8?B?KzJrVDE4Z0RLUWY5KzFpSW9peFgxWTFwV3ZHWDBQK3ZHZ2RNY09VYXVsUFp2?=
 =?utf-8?Q?FllFnqFRIorASx5lYe0prZmZM+Bp8aeIOlLG6mCT+xpQh?=
X-MS-Exchange-AntiSpam-MessageData-1: MJXxJYHBqaPIqV5S6z+iECcRUG9uRCUQMu8=
X-Exchange-RoutingPolicyChecked:
	qny7liI+MOm2mv6nHxFD4PIQYumiN6v3Yj2ukVKfHz3NEJJ9iY5CCMEMNnxlkaZhgqYrCmyM92t6uhwREiuEYPHytLRDNpAQ5jKWCgf4c1mD6OFG6X5SdcFm6os7nhmNPE5h+D3lsx88A8f2Al7NWfyUZqHAivJVWTAXM4DcQiO2aCiy/j5HNl5/YXrYn4HIdghKpKZsi2c+NeaT4N+QeBfvjrUUMVO/riQvhYv8930rJ8ve5LE6STB447c4B6BEohOvtc9kUBFS9dCJr+tGRRkgCzoENjxb3oDQ3ULSb3gnkmQGzEtJPKnTw/TT01WoVL9BVCZo7CBVHFGUNH2Lpw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	e30M8XgMeSvJe5BSgYlP+z4dksQ+PHzxN8KOWwW8rdXMsAxAddDkfb6x1Scj7cxlWgdUJO9V2EUXXLeSQb8GjCONmGnhyF233BPhuHgEprAFhOnT+LaGElOTGLKfLX8mESD6s25AQCo3EiayCibCy4Da3IV6mFGeIUBgjTTcKXg08yOGCuA/F9X4OC4Yp1Ncz0AyV5wq7EYiM4PxbusLOGTvly5wa4WUHNE2GTLxKfZaHLH7sogS5Y5TV7RY2tksuzaBahK5d8oSDGzMLXwSjyjnEtMGPZNeq6+Lqz5/mufgGYAdG3CNjKnKSYUCNAd3XLUgBjEfQVHgVzYLk/zF7A3SGtr+ejGNHlbEq856ff4/Uwiysu58JPoVr7VOlCilRbqwjGnrWrr8/lp2s8fgsqExwgbWeFmioyigWHXlluPqBY5KweDso1tmhWLef06+pjPG4xPRHUB/wloddSd26aTIZmLBYrLym4UGqnEX2m9ziLHC0jotPZ7H6rfhWKOOtc+dlp9tyyp0u8CtTdkXxYc0M8mHvKTM6FG67izgyIqVz8aEitM0wbWBZHAqK8kHGEV+5f5dgOCQ3DC18jxzPSiMqRE0p0whn+ZONX379TgtzDA50Up1t9wm3DHICSeZ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6ef0fef-6745-46a6-1166-08de9b80fc42
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 06:25:43.5635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XKQZ4U6W3vOqvrExtvsX0k632zzveM7cLAWdJ2U4ZFZKWBGokyJLEgjjW6EF5CBGnWwYnjGvbB3jkKw7c0iErQiaR+VDPwegO/PMBDT4pYA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6374

On 4/15/26 7:59 AM, Hannes Reinecke wrote:
> On 4/14/26 20:27, Brian Bunker wrote:
>> The ALUA handler maps a 0 value (no implicit transition timeout provided
>> by the target) to the ALUA_FAILOVER_TIMEOUT constant, currently 60
>> seconds. This means the kernel already does not accept an infinite
>> transition time.
>>
>> However, 60 seconds is insufficient for some arrays that may take
>> longer to complete ALUA transitions. Since the highest value allowed
>> by the SCSI specification for the implicit transition timeout is a
>> single byte (255 seconds), change the default to U8_MAX. This way,
>> when a target does not provide an explicit transition timeout, we
>> default to the maximum value the spec allows rather than an arbitrary
>> 60 second limit.
>>
>> Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
>> Signed-off-by: Riya Savla <rsavla@purestorage.com>
>> Signed-off-by: Brian Bunker <brian@purestorage.com>
>> ---
>>   drivers/scsi/device_handler/scsi_dh_alua.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c 
>> b/drivers/scsi/device_handler/scsi_dh_alua.c
>> index efb08b9b145a1..8ef1eecf9f9c3 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -37,7 +37,7 @@
>>   #define TPGS_MODE_EXPLICIT        0x2
>>     #define ALUA_RTPG_SIZE            128
>> -#define ALUA_FAILOVER_TIMEOUT        60
>> +#define ALUA_FAILOVER_TIMEOUT        U8_MAX
>>   #define ALUA_FAILOVER_RETRIES        5
>>   #define ALUA_RTPG_DELAY_MSECS        5
>>   #define ALUA_RTPG_RETRY_DELAY        2
>
> I'd rather use the numerical value (ie 255), and add a comment that
> the timeout is an 8-bit value to deter people from raising it
> further. 

(u8)-1

that'll have both properties. 255 and documenting it's a u8

