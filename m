Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DB62DB7BA;
	Tue,  5 May 2026 09:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777973173; cv=fail; b=oHLdg4d46nq+0vNWpQoZ8iPuK9w7RrbtiFQHIunHnQ7koIWjpS36ST6Mon38z4D5ZQaIOdnxT6dbrOrw76WrW4sf2gEEJbLdPbRLQ0Ey6MxquAt2jjeQ3N5SA6pHbaqdV5F0EfPTnrHaaljMbL2u0fBK3u5K6ouTbzIp75bbO94=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777973173; c=relaxed/simple;
	bh=ZfbgEjoqdbHz9xnCuDsU3gmTVEvjLZFv+ek6A4F7UhY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dxQg08hkn00YP30m+6gEP/iH1nnHzSD+wb9XgwtScVOBvnhThJFQlFNidYqnP/iNNcTDlogvBSlswW8i4LvnDQ+WsokN8h0/WTy4QdiDcibGyAdLLtHZ+fbOBXrp4M6Iid9Qb7G6zOniq4HCDert75W4Lqm/KQxcTqish6SFnuk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C5WfBFU+; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C5WfBFU+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777973171; x=1809509171;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZfbgEjoqdbHz9xnCuDsU3gmTVEvjLZFv+ek6A4F7UhY=;
  b=C5WfBFU+Zr0e/YUovMhuk5D5TCqs856NY+GzOyFf/1ildP8SKc/WjTLO
   3VK1bP8jnfKcLEI1ik56If+pvYbfLQr8T6zypeyLBTMTmlBeAHAortWlD
   Pu8aupic5/l6vuxhDo5+gcqQ/xrnYoyHZjhWPHIpK5szmNh8FvxpfFEjA
   0UiiFf95KzxZ8Q7U2KPQfM/zy083ceRklnfpFiE24r/R+6oG9uZs/pYA5
   Uy9Y1zAriQ2HGFPXg91+1kuCL3hjaowD8ebYDoXd7NDPZcgltfHO+dBBZ
   MorTdr1j4q1YhmL/MHa1ggjaOhOGvjjp1oFYxgp5Zmu59Lgny6Su4w14a
   Q==;
X-CSE-ConnectionGUID: MMFsmrM3QZ+dNSHrAL0f4A==
X-CSE-MsgGUID: k7jx0F3CQfKuIEKea5/YJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11776"; a="78830255"
X-IronPort-AV: E=Sophos;i="6.23,217,1770624000"; 
   d="scan'208";a="78830255"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 02:25:38 -0700
X-CSE-ConnectionGUID: iiMSCLFwQCWybd9gZRukbg==
X-CSE-MsgGUID: HzKza8NuS9W1tQidvEXI4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,217,1770624000"; 
   d="scan'208";a="231391151"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 02:25:26 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 5 May 2026 02:25:26 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 5 May 2026 02:25:26 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.4) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 5 May 2026 02:25:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nc0hWDPaKN0zhtzK+WrFQReurxzwwRqD7iDwVhqELGwCbyiQ4mITa7VUXkLlx74YMHDeGbJpw4J5gshI0341+4SJNVVZrPfs8OFO1NQWQzTUarJdoLABBn9EnpDSErjKerTOZHR+O1vu2QkCx7yuVydUV9UDPmsSbbVxhqGQ2hvfE+xDseGnxCWkSg+jZdzaS/2mpSmn+qO7h/9OMs/Gj/RzdSYWKXjvndS5SMH8j/xVxJXjZdSnXonKAbZzLVtw9k/2ZbqOHQP/Aqwz1hQaqN/jB4m2ALbxl7JWGdDCd68NhzvzZTU4cmvc9wrI8fmAlSsgkS659Q5Ua36f54VcIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qR8zetxEtsa2qJvsWP5+XupFbOW44AlGsRIRIz6XhNg=;
 b=JPuYcxwJzIcBQ6aF8/MHEjKhsjLkvW5VF+My6g/ZkrxrbI6pT626yuLAJLC9SHexpVpoU8aK9+1fIZQdbNJwqFU7znjXOg7Lt3kton16ApxLns72UPTUgnDNiKPuLbMXwDIJXzTmuWoA9VUpJerhl/ZBDargj+HRrrmOHs86ZaI/CmHGXhKlheMpl34Loui0DQKiFtSu/iUlfFLhgkADEjeA8JkuIKLSSsQD26FCFxPhwYp+s3TRD2Ec9jjgtebUzIwytUFhY0272G0eimnupu7YE34JckcAGJkmEkzqvI+bVTNjwE1IGmc3KBeTgX8rsUmrm5wnQjY37WAVUSFglA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by MW4PR11MB7053.namprd11.prod.outlook.com (2603:10b6:303:221::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Tue, 5 May
 2026 09:25:20 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::2c4e:e92a:4fa:a456]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::2c4e:e92a:4fa:a456%3]) with mapi id 15.20.9870.023; Tue, 5 May 2026
 09:25:19 +0000
Message-ID: <64a65c35-ae47-4e88-8975-988998ed5e82@intel.com>
Date: Tue, 5 May 2026 12:25:14 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ufs: ufshcd-pci: Use PCI_VDEVICE and named
 initializers for pci array
To: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig_=28The_Capable_Hub=29?=
	<u.kleine-koenig@baylibre.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>
CC: Bart Van Assche <bvanassche@acm.org>, Peter Wang
	<peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>, Can Guo
	<can.guo@oss.qualcomm.com>, Archana Patni <archana.patni@intel.com>, "Markus
 Schneider-Pargmann" <msp@baylibre.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <cover.1777968942.git.u.kleine-koenig@baylibre.com>
 <6cac1c22381f7026edad9854d70833381d14929a.1777968942.git.u.kleine-koenig@baylibre.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <6cac1c22381f7026edad9854d70833381d14929a.1777968942.git.u.kleine-koenig@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DU7P250CA0006.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:10:54f::21) To IA1PR11MB7198.namprd11.prod.outlook.com
 (2603:10b6:208:419::15)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|MW4PR11MB7053:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e21ff30-bc63-4d8a-980e-08deaa8839da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: jqgvcsuQ+X5pbsRa42gRk2j3Hwn1yQxfLOGvwmsWh2aR/OFGp4tgE5PWj3WYyqbKUWJcSZEe7ZP/tX8n/J13vtrRDwpmik58NF+eHxEkw+zOauyBuh63rJPNYyG8COy3eSfVcxMkTPAKjXVgZwNk7NkdVUTizip42CkBsKmorMjEFJ5yvjdZi5rPSrYAP7zbMXnpK4zTJbrtW5yk0w8BLdjs1hcNb9uedsW9Bs/m+FqW7OC9RDcEp0XZEf2mihxn3oTSC0r81zymjEXekSLB5nNt2SvG35q9kBBwWEDdkeFJAbHtPGe2s9r/huEZmWGXMRMwwM0Hv1dX/cPYSvqpDqkhChUksn+Bt8jvYqYA7lhLwdJYYgd+voB9mqtJCpsixN5oITdAdo+4iT4q1m6lDyQJpm4/A4Gg03i517T2o1WZReJpEafruCnPEimrwIWRbe5J+TiJo+SLqbSLHmNnl3Wo1uXUeD7aJ1zl1dtZCg3xX6raJFdSiWr7hFRW6rwZ9rW86YbRpj3Jjp/4YN2h/6ws9tkCb4EbiivMLB/FYEaF5EkNYuPTmh5iwDGCRGM1sOMh4b8i6zsUQjgire6rWtGpQbKG7fcZiuj6/0p+3sAYMJsHkUMX9uI4vk7HpyYcnlYRyboWYHNxo0vyOEM5De3FT3uPMPr2Y/TGzCT22jJDQN65sMC0VJTrIQF2Wd+l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RlM3Q0ZTN0NBUmhaMWZWaUVvYmVXMDVzdzEwY2FQeUprOG9tZ2NJWFhZN2Nv?=
 =?utf-8?B?NGtZSVFWaE9GcFIrbkcydFR4a25XaFQ1YXAxalAvc0JxVmFFRWN3UitrdWd5?=
 =?utf-8?B?NVlCTVB5U1ZQSGNSQlkvcis1eTlmVXVUZW5mc1lvblltQlh3S0lLMk01RkJC?=
 =?utf-8?B?TXVpeHAxbXJnWU1LaWhidVhpOGVQSU1FY0FuM3p3U0IvYVUwZUM4bzg3WXh5?=
 =?utf-8?B?UEZSUGJyNHJoSnlWeG0yS0wwVm1odkpwRWtxbytEV2tTMVI1aUlrSEZKRS8z?=
 =?utf-8?B?S1dnd0RUU216eHcvYVV3dzBMNkpHRCszdkdhS3lqWU5HYURBd2tUSDFoS2t2?=
 =?utf-8?B?eFZQUGhWeWRaUWVSaWVUYWd1MnYxSFRLS2dOYXpqcVBXbU16c2hSUmFPMlNW?=
 =?utf-8?B?Rm1xUGxIODZhSmhLUDFteWFjNk01YlpKYy9jcC9kYlh5dlk1TWpMZ1hvTnpi?=
 =?utf-8?B?cUNZNUFtV1d2U3Nkc0tiOEhoYkVBZlNHdFVTbVE5bnhwZ0lzczdpbUFZZlM1?=
 =?utf-8?B?cjFvVUZNWG5DUEtsNkZ6OCtkSy8wcCtZL2x2czZJUHBqU0M2ZCtYOElyditU?=
 =?utf-8?B?RmwxS0taOUxibmwvbnp1dGFOaUVvZEZDNUhCNzVkbkh1M2NFZ0hNN05odDhS?=
 =?utf-8?B?SDdTdG9KQzNVUEtVRmNCZkx5RFNuRVJab0lmeC96SUhuNlJEdk1rY05CQWRo?=
 =?utf-8?B?UHdJWVhwU0VXaElDSzJtMjRoVDBsN3VxeEI0L25WMmREMEtBL0tWVkZsQjB3?=
 =?utf-8?B?L1pSSTNIMDdoWFhtenFGSTgzRkJXQWxOaHlMN2E4dEllOXNtUWFwTmZEb0c4?=
 =?utf-8?B?V0hUakRUekw5WmE3RC9jNGgzbUZ6RUk1MDZGcDVlTDNmZzJyZnhCUUY5aEpM?=
 =?utf-8?B?Q1ZreHZZcGhoZ3hLVXNIWCtwSUxWS0R2NGpXWlVFbkJsNXN0R3Via1gvU1Z5?=
 =?utf-8?B?Tm1CZ2ZZWkVzVjZsOHlFZ0NvM1FnSkcwMXRoWG4zZjg0LzllOVhHRXNQd21M?=
 =?utf-8?B?aGJsTnN3bnhwKzhPbnVTUlA2THNOei9Nc0FOcVpEU3VSZkx5YWExeVg0eFJi?=
 =?utf-8?B?QmFyQ3VoVVJWcnBpd0wzTllqOHRQVW02SUNtMExFY211QnB6Z1BwUjJ0RkRV?=
 =?utf-8?B?b0o3UzN1dTdwNVpJL0J0Q1NsQVVINzYyT3FUTVd0ckF1cEk0MmJiT0ZQNDQw?=
 =?utf-8?B?MVRQMEhMT3FFNEZvWWprR3FFSFAxaUJUYUExU1ZzUnNPZC8yTCs0QkZSSzda?=
 =?utf-8?B?ZW02T0VGSTBCQWh0NTl5a1VleEVTZDBpNWZXNTZqK2o1QmliT29IdzVNSkdX?=
 =?utf-8?B?WStGWEQzaEp0d1d4a1NleEdmWG9yY3A3cEZjY095V3drRGlCQk13MXd4Q3Fk?=
 =?utf-8?B?MkNTTUJFYWgrcTZEZWJDckhaRFVzSndaQXpiYlR5M3VUWU9rVjhhNXRtKzZk?=
 =?utf-8?B?UUVwcnVuS2pCY0JRZlFsYXZUMGwxQkNPNWdLakpIdnUwVmp6NGtGQjhQckFR?=
 =?utf-8?B?bmZucURQTmFTNlMvbW5aeHNXWElldUZWRnNtaE1GUmcvbGtUdloveFduQmww?=
 =?utf-8?B?SHMzT21CYmg4ZmhnNFdpdG5Vem45S0N4TXZJT1RTM29ZbU9vRG81d25EUjdz?=
 =?utf-8?B?OThrQktmeVRoL0JrWjFFNkEyTWErWE9XSnllQncvYXR4endhc3ZwWTBlWnZM?=
 =?utf-8?B?d0hKVjVuMUpONXB0bzMySjhrR3JaSVl0Q0ZMUzlNUC9SVjFXVUJQVVl2NnJx?=
 =?utf-8?B?NS9lcnpaTXVIR05BbjdUVFBseWVoYlYwQmpta1Y2YzBQcWRlbTV6RVpnNlJo?=
 =?utf-8?B?YktHVVdaS05BZGJNbTRwUDIvR2ZReGFqRmcvSDlWTmJrNTMxZ25yUmhIWitt?=
 =?utf-8?B?eHVyVHV4emI5Z1ZzYjJRU25xQUx1MkpReDBQdG1ubzJwemw5enlKMUd6bXk2?=
 =?utf-8?B?ZGFMaDZmNFBRSEZlQnI5VmNkTkFGRHEvUmpudkpVR1NXbHFIaU9hWnFZWHUy?=
 =?utf-8?B?VEEydll5eHp2QTh5dVVUZDVybklCR1hSUlVLUDgzL0xuWFo1Yk54Z3VWSVp2?=
 =?utf-8?B?QzlKYWxkQitsZWVtU2tWV0UxYVdDanM0RFgxMzZ5T2FuQ3FScC9JZWZWTU5m?=
 =?utf-8?B?WWNUSVNxWWpYbTlQSnFRUkw2NGt0WGlzTGVja1BiZXp6dVpYblVpeEY5b3M1?=
 =?utf-8?B?ZjBiaEpzYzc3N2ZiNXhlazAxR2VvZnpqS0UxSXNCVzVBK3VHdG1TWmlVci84?=
 =?utf-8?B?R0YrYVpmaFEvdGkzSko2UWhtYS8vRDZDNlVWTm9TdWFHYmJ5VUNJaDNBTURS?=
 =?utf-8?B?eDhVdWV4UzZRWU83aHlKMThIUkQvT3ArclJobUFIamxQQi8zOWUzSzRpckMz?=
 =?utf-8?Q?M7Dofoa7lv1K678U=3D?=
X-Exchange-RoutingPolicyChecked: eVdt5xnp7Gt2Mw1afP/j0D9ZLKmSrMJwCraIsfBDhtg4bRTJtnFOTZ3xYylfRp9sI6y9rCAbJ18kWbPGkKBpNyCJaAZ1KAllf14pkJVGo7qcjgpo1n2hHl4iZeIcJY1dXruhV4NmQz7xs5uj8FIkByAV0/bGkSP0/I8xp0tl/LPMxhK4ESXvMWbapPmkMinICRw1QVZ0ULLrvYgjFTOwHP3Y1i5KNkyKJxhxx8ez5SIFU88PzvGChHgJCo2ByZPJ+eiaxITUTr7u3B/ormIMbm01lznXj2WA7Dqk9xalHYF43e+oXMMii3Ld0REpKg+ms33jVP8oW/+VGbFj4Jew+g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e21ff30-bc63-4d8a-980e-08deaa8839da
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7198.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2026 09:25:19.8326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X3eexy8pGvbVx8862K1xUZaFeFd/NPxy2UeAvKWtV4Ef2wlRcMrwfbpMXBwkTbMPfk1+H7YuOzMqGUGkROu5LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7053
X-OriginatorOrg: intel.com

On 05/05/2026 11:28, Uwe Kleine-König (The Capable Hub) wrote:
> The pci_device_id array uses a mixture of ways to initialize
> ufshcd_pci_tbl[]. List initializers are hard to read unless you memoized
> the order of the struct members. Use the PCI_VDEVICE for all entries and
> a named initializer for .driver_data.
> 
> This allows to idiomatically assign the members without using zeros to
> fill the fields before .driver_data (either explicitly or hidding in
> PCI_VDEVICE()).
> 
> There are no changes to the compiled result of the array; verified with
> builds for x86 and arm64.
> 
> Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/ufs/host/ufshcd-pci.c | 29 ++++++++++++++---------------
>  1 file changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
> index effa3c7a01c5..13293e83064c 100644
> --- a/drivers/ufs/host/ufshcd-pci.c
> +++ b/drivers/ufs/host/ufshcd-pci.c
> @@ -680,21 +680,20 @@ static const struct dev_pm_ops ufshcd_pci_pm_ops = {
>  };
>  
>  static const struct pci_device_id ufshcd_pci_tbl[] = {
> -	{ PCI_VENDOR_ID_REDHAT, 0x0013, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> -		(kernel_ulong_t)&ufs_qemu_hba_vops },
> -	{ PCI_VENDOR_ID_SAMSUNG, 0xC00C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
> -	{ PCI_VDEVICE(INTEL, 0x9DFA), (kernel_ulong_t)&ufs_intel_cnl_hba_vops },
> -	{ PCI_VDEVICE(INTEL, 0x4B41), (kernel_ulong_t)&ufs_intel_ehl_hba_vops },
> -	{ PCI_VDEVICE(INTEL, 0x4B43), (kernel_ulong_t)&ufs_intel_ehl_hba_vops },
> -	{ PCI_VDEVICE(INTEL, 0x98FA), (kernel_ulong_t)&ufs_intel_lkf_hba_vops },
> -	{ PCI_VDEVICE(INTEL, 0x51FF), (kernel_ulong_t)&ufs_intel_adl_hba_vops },
> -	{ PCI_VDEVICE(INTEL, 0x54FF), (kernel_ulong_t)&ufs_intel_adl_hba_vops },
> -	{ PCI_VDEVICE(INTEL, 0x7E47), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
> -	{ PCI_VDEVICE(INTEL, 0xA847), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
> -	{ PCI_VDEVICE(INTEL, 0x7747), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
> -	{ PCI_VDEVICE(INTEL, 0xE447), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
> -	{ PCI_VDEVICE(INTEL, 0x4D47), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
> -	{ PCI_VDEVICE(INTEL, 0xD335), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
> +	{ PCI_VDEVICE(REDHAT, 0x0013), .driver_data = (kernel_ulong_t)&ufs_qemu_hba_vops },
> +	{ PCI_VDEVICE(SAMSUNG, 0xC00C), .driver_data = 0 },
> +	{ PCI_VDEVICE(INTEL, 0x9DFA), .driver_data = (kernel_ulong_t)&ufs_intel_cnl_hba_vops },
> +	{ PCI_VDEVICE(INTEL, 0x4B41), .driver_data = (kernel_ulong_t)&ufs_intel_ehl_hba_vops },
> +	{ PCI_VDEVICE(INTEL, 0x4B43), .driver_data = (kernel_ulong_t)&ufs_intel_ehl_hba_vops },
> +	{ PCI_VDEVICE(INTEL, 0x98FA), .driver_data = (kernel_ulong_t)&ufs_intel_lkf_hba_vops },
> +	{ PCI_VDEVICE(INTEL, 0x51FF), .driver_data = (kernel_ulong_t)&ufs_intel_adl_hba_vops },
> +	{ PCI_VDEVICE(INTEL, 0x54FF), .driver_data = (kernel_ulong_t)&ufs_intel_adl_hba_vops },
> +	{ PCI_VDEVICE(INTEL, 0x7E47), .driver_data = (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
> +	{ PCI_VDEVICE(INTEL, 0xA847), .driver_data = (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
> +	{ PCI_VDEVICE(INTEL, 0x7747), .driver_data = (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
> +	{ PCI_VDEVICE(INTEL, 0xE447), .driver_data = (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
> +	{ PCI_VDEVICE(INTEL, 0x4D47), .driver_data = (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
> +	{ PCI_VDEVICE(INTEL, 0xD335), .driver_data = (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
>  	{ }	/* terminate list */
>  };
>  

