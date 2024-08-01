Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A8C142642;
	Thu,  1 Aug 2024 05:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722491365; cv=fail; b=BYTu3obn3D014EfeZ8hoQrXKkr09pBIHcGClnyTY79XxTwvJruedxeV62LbhgCU9RPTIiP6J89yhixrV93+rwGWlo8D488b3AiWjLWrYzJ0/qQSCxcNb6hDhL1yA+kRNrzhuWw87s1YxFfnSxRkwx7h9Gws2dkpqk2P2/v6c6Fo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722491365; c=relaxed/simple;
	bh=gfX0erSObs5R1OPPESGK/h/2lw4mJDUDQlmvJQSJpQw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SfXAbRLrHe6HQ5JtQ11SWdGQgi3A/K15k0dl8tT+Cdnf25qfVdw5qPp8trzDEleW1AZ5131eJcgf2bkGk0yyMMRdAWDB4diM53yVW4XpdyNeYKDzUXXY6K8LigLtJhjOEGRBUMA+8WWOtO4isEKrL0Lz6CqW/kHbIqgg3munrVI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JlsDZCYF; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JlsDZCYF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722491363; x=1754027363;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gfX0erSObs5R1OPPESGK/h/2lw4mJDUDQlmvJQSJpQw=;
  b=JlsDZCYFtoR4g/geaSorecmTt4weMfmUpdTHfo+7zHjNyKzuh3JqRhCg
   quPLArbGr57LA/l+E0SEFI0Lt5iRGjvJ7arKsXfHrmKEsa9jgNNFdbFmW
   90vfpjUJ+Uswii54tHzc9dsW5UxiMjA8YEAWRLaQajAoFDXt0OJmWJt2B
   GpJw3ZTp21DvCeLroImYwl4TNTZLXeYf8oTzzRdEgFmfRFhDpCEEZAncY
   J3653zGl+eJMdKf9tn7HyXfgPnupItlcio4EyQLKBjak+MaSaCVXj92+X
   UL6LIFP3pMVLpup6sYXCS9CVS1k3wHuSiccpcf7MeyRVHh9U840ba9LVf
   g==;
X-CSE-ConnectionGUID: KQOgt9FrRiGWTibybkUZpQ==
X-CSE-MsgGUID: yc3KVqaIT6udMZGXSc+svA==
X-IronPort-AV: E=McAfee;i="6700,10204,11150"; a="31806201"
X-IronPort-AV: E=Sophos;i="6.09,253,1716274800"; 
   d="scan'208";a="31806201"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2024 22:49:22 -0700
X-CSE-ConnectionGUID: 0iLxAzpRS/+bB1InvCZXtQ==
X-CSE-MsgGUID: 0zJX4VtKQ9Swp0EKI8tQUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,253,1716274800"; 
   d="scan'208";a="59954199"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Jul 2024 22:49:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 31 Jul 2024 22:49:21 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 31 Jul 2024 22:49:21 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 31 Jul 2024 22:49:21 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 31 Jul 2024 22:49:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bzo9Vi2ktzMNrCekG0WYiBE33ej74pTJMzzCfpE1yR5KEOoKxnKjhwxwyAztrjZYCsz+BYonhg3KwQ2f3aR98JWRtZgPkQm62m7h1bavIsMS/Cgomm8yLFkpYz4Q6+Pgjm7IOz17YpgTBTNAw9cAD6kPee4g+V0CRwoqi6Nt6AYQgo1G/Mqsa6WoFEx5uCGO2MSFg117itp7RgMmHNrAO4DaHqiVXZYNaxHQ+AA4dl0pv/hv3zpaLpzQtWq6Yv+0I0ntB+sUlBmPKix7mnf3tV7GFzZ1rQzS48WYx+hNI7Y5i6tuA0kMEpH7PZn5jpN1A5bbCBpIozyGNa73JSCaLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gfX0erSObs5R1OPPESGK/h/2lw4mJDUDQlmvJQSJpQw=;
 b=poPMWyjZwtcHoKJtLp4MY7KIUKccaA4JwthhWR04m2SJ0RuZ8n/fxumWFdc0oG/9HPWN1H1SjXwhRWG57mpAwiJVLRZ1ljCm978+Az4hkCRgPo0wwxmQ/FZ5FYWMo3xnSLp0VJ9j+TWjbuxvZdgfExaRwdjwNmm3ivPNTWBGfsUmbKscCcz/Zw23aZBGWQuvY9zSHgNPKDXFjEnL9f3JgByZ5PnZgsdkI8dfh6fkB4UafG2qTB0Kg2eLrhbwuMDJJwcJ5TVb4Bidqqs1JqnJPv8SVCwjNB3qFR0cOq7P+B7lXFEqT9WWAiSsWqUFNgd137s3eyucqvWMiL/csLxbhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7382.namprd11.prod.outlook.com (2603:10b6:8:131::13)
 by PH7PR11MB8252.namprd11.prod.outlook.com (2603:10b6:510:1aa::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.28; Thu, 1 Aug
 2024 05:49:18 +0000
Received: from DS0PR11MB7382.namprd11.prod.outlook.com
 ([fe80::80b3:e6e7:efec:dbee]) by DS0PR11MB7382.namprd11.prod.outlook.com
 ([fe80::80b3:e6e7:efec:dbee%3]) with mapi id 15.20.7828.021; Thu, 1 Aug 2024
 05:49:18 +0000
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"shinichiro.kawasaki@wdc.com" <shinichiro.kawasaki@wdc.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
CC: "hch@lst.de" <hch@lst.de>, "Saarinen, Jani" <jani.saarinen@intel.com>,
	"luca@coelho.fi" <luca@coelho.fi>
Subject: Re: [PATCH] scsi: sd: Move sd_read_cpr() out of the q->limits_lock
 region
Thread-Topic: [PATCH] scsi: sd: Move sd_read_cpr() out of the q->limits_lock
 region
Thread-Index: AQHa49WwOtiSlBLn3Uys7HJAxlK78bIR5WmA
Date: Thu, 1 Aug 2024 05:49:17 +0000
Message-ID: <09c078416b5df42978f3c26ac69d2c75d8cedb7f.camel@intel.com>
References: <20240801054234.540532-1-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20240801054234.540532-1-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.4-2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7382:EE_|PH7PR11MB8252:EE_
x-ms-office365-filtering-correlation-id: 454d819a-1070-41ca-d3f0-08dcb1edaee7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?OHgzL2xDNDArU29lNnV6U3NRclRhaEhFZTl5ejhaMzNNcXp0Qnk5UmJHcDhC?=
 =?utf-8?B?VTVpRTc2aWZqUWh3ODgyWDN6eEpyQmlPVFcyMEUzdVoyV29FdVBnSVp1c3dD?=
 =?utf-8?B?bTkxMzlPZjVTS0liVmpxZUhoR09sTHJRV3docmtSRUV0dTUxUmZvc2grdnZS?=
 =?utf-8?B?azZBejlVWjJrZlJXZERGNHFaWWxoWWZzVHdYK1U2UjF5V0tSeE9WNkdwNjV2?=
 =?utf-8?B?OG1oTFhRK1BjMmtkNnRIR015Y2VlQ3FDanJxNU1LbjZZWTRIYTdtbDc5Rkpa?=
 =?utf-8?B?U2RzekMvTUJwVmNTdXU5aTN2MHFXWEdrdlNZK2VZbnZXQTFSZnZhVThxOURi?=
 =?utf-8?B?RHFHYW5qVm1MMkoyVTVTVGJWWVZiWnRyMjRkTzVUN0FzVFNTR21DdmVBZE4z?=
 =?utf-8?B?ajUycmxEdWhrS3FvM2dTR0QzdkhZYjNNNURjVTM3Sk43TXhhMHRQZmMxMFJV?=
 =?utf-8?B?c0xaam04aGV4eVplenJtc3h5aGh0WVZqOWhwNzNldmU2dWdxa3pxNlFtZnY1?=
 =?utf-8?B?QnNlTnVnUjFEKzFDeFByWTBUS1RDUFgzUXFYMXIrQjNMSitjVkVhUjZEZnVV?=
 =?utf-8?B?ZVBibXJwenV1bUxmaCtzNTNJUnlhcWlWU0hYdndPeGZsNTdyeVJBMzVveHhZ?=
 =?utf-8?B?MzFQRzkvUnFBelNFUnpucS9rMVNpRUg4OU4zUnAzc0lpUjY4Uy9SZEw4bjg5?=
 =?utf-8?B?aDJ5QVNMS0xiUmw3bTRyY3hhRDU5emNyVzJaSVRiRkdjQzkreEUyYUVXRXE5?=
 =?utf-8?B?TlQ5d0ZIUGc4UzBkanBaa0d0T1N2VlF0Wkw4QURvVkJsN0JvbFVXNEpaSVA2?=
 =?utf-8?B?SXJ4MEd5UXlMT0xWT1hPTWtnWmtnOW1JMlZVMTJNVjJhY1lSVHlRYjJDUnRH?=
 =?utf-8?B?WmRvU2czVzVXUHZ0ajQreWoxQndURUtkdm00UXpOS2NaYjVQdzRGSVFxWUQx?=
 =?utf-8?B?QkM4dnROTU1aYm4zZlpjdDU5RzROd3JNbkVxTlZrZjl0ZEg0aFYwOXlXMTRw?=
 =?utf-8?B?a1hnWk05TVRVTUtWRWNSQm5DNEIvc1lTSGN2Z3g0YWQ5K0ZWT0dGL0dvM0tO?=
 =?utf-8?B?STF3SlVnclZqVDF6VXo1WVVmOFZrUS8zMTU4Z3ZXUHRtQXNFSXlnVUFFdndL?=
 =?utf-8?B?YWEwb3dhUDZSZTJqdG52ZjlnWVhPWk9WYWEvSXdsNjZQOUpLQzJsVXBqYTFl?=
 =?utf-8?B?a24yMUh1NkMwdTQ1SHJjckkzRlMvbTE0VEdWbjF4YzdieVVmdG5ySldvbGh5?=
 =?utf-8?B?T3p1a2FnVUhGOHBBN1cwZmREY2kwZnRzV2JEdjkxc3l1Sm5BVVdoQmQ2Ti9u?=
 =?utf-8?B?WU1TWGM4ZHBSRXVpUDNaRkk2dWxLZ21LQUZ2Ri9DVmg4QW5hMjZRMUxkdVFz?=
 =?utf-8?B?cGQrV0paSkh1T0tUVVdsL3BTQnRGODdvQlZsaVdUWGR0MVVEQXB6dWlIdk1o?=
 =?utf-8?B?OUZLUkFuWHRlNDVIYTFYa3RaY3dORzR1SW1zVG9UN0NrYlU3ZFArMVEveG5n?=
 =?utf-8?B?VHNzSWh2WkpaeUI1U2Y5YnFwcUdIM1VqdzRwaEpRd3IxRVZqbTdkRENRN0ty?=
 =?utf-8?B?SS95bElkbk9TVkdKdkFnMzVKay9hRTNHaEV1cXF1NkpyV3JMR0FUTzZOQ2ln?=
 =?utf-8?B?WEFtS3pHMVNsOGRJQUJIR0VUY0IyY1J6ZTZmU0xaTjJRWnR4enFRaGVzN0R0?=
 =?utf-8?B?WWk5aXh2K1pEblNXUUM1cWMrUkFGYytGaVBMMEJGSDlCc1daVTdDbkN1d2Zs?=
 =?utf-8?B?V3hPc05obnk5Q1BTd09xcncySEZCNHovOVovb0syZXA5Wnh1OUkzNG9sd1Bt?=
 =?utf-8?Q?YeyowzxEoRtzVNdsA3R3ZRrSbVkf0PxfJefq8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7382.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WUJmdXUzY21raklVZFhxczdrZThHZndyYURPWnBqcFYrNGNSTGt0V2lzRVZL?=
 =?utf-8?B?cnBCc0tNeDk4RjQyOG1qN0NWQTJVbXRib1pIZkR3elIwOHhPOGV5OHk1bTdi?=
 =?utf-8?B?UTlpVG5KWWplVzV2Z3FmWFZJYzNUK3JHb21NbzUxbzFyUkZsMVRFeHZSa3h1?=
 =?utf-8?B?VlNsSTd1UzZLREZUN2NpUXhvMW1oY1htMmVkVnh2dDFVNFRzYUhmSGt3bUtV?=
 =?utf-8?B?WTFDNzc1Q0VYZUNSTU03Sk1rYnJGaXFXTU9QVDJyVDBSMGxBOG51NnpuWnNz?=
 =?utf-8?B?R2d0MjNRZ0VLSWpjMHVXRndLc0NFT0k3UVZvVHVOcGw0K05TWVpuRTY5SFZ1?=
 =?utf-8?B?cjlXYlh4ajhiL1VDZEFjT3ZzUnA3N2hHQ0hBVGxSYW81dFZEbWwyeU9pQWJ2?=
 =?utf-8?B?anlYaHpkQWxtR0FVRVVqSCs0UUNBNXF5YzlzQVYxTUlmMGRaMytsVlRGczM5?=
 =?utf-8?B?dXRrSGhxVktHcndRQnJYRFdKMk00Q2dsVFJ2Qzc2Q25OWDF1SjZ0c1E1RGhu?=
 =?utf-8?B?ZEJmVVdQcFBNUmsvckhGenA0OG53Zk1vV1RjL1VLOUVHSzgwOTB0SWdHTWly?=
 =?utf-8?B?dFVzb25VS0ErUHUvbm41OHNCWjQ2Tmk1WFlWdjlRc0JqQS9EZjFzSkMxOThG?=
 =?utf-8?B?eVlBSGs3WnNtY1JqYlMzNG10aENsK1IrM2lRV0dVQm0zelRUWnpDVGp5UXpq?=
 =?utf-8?B?UWZPem5NQ0ZZUDZMRlZsKzhlcHZVaVVYU2tKYnBSQmhHSTVpUjJXaE1NNnJk?=
 =?utf-8?B?WHdXWTNZaEp5ZUtRNjA3elVuZlZZaFZobmJPVHlBeXo3c0FHUGJxd1drZnhQ?=
 =?utf-8?B?b2FvTnpaRzBvMlZSbCsxQ1JibDZYMlArMVF5VExnLzBSYXJvVkpXbEFodWtV?=
 =?utf-8?B?VmVrNm9LWkRGZjltR2Uwc3NCVkdhNWdmYkx3MDVpTTRaYVRNaVVLeUV2NWFB?=
 =?utf-8?B?M0xuQ0FTc09ObGg1b21nV1M4MkpycXpCaVhOYzZNVHYwY203TGZMT1k4NTBM?=
 =?utf-8?B?cC9vUHBIaStDQmt4VGp6ZFhCbDd0dCtoSFNLZ05oUml1b3dpbmRiQlI1dldK?=
 =?utf-8?B?TXFjTmFXcVdkSHhNejJXZzYrc29Jek9Uc0E2a0xVQVI5cmg3V3pRb2tadlpo?=
 =?utf-8?B?ajlFTVZnUVkxYXoyQ0R4d3Y0MVhMZHlWSEF5RkhwdnQzLzVLVFgvcjFabWFX?=
 =?utf-8?B?Wml5QXlzMW56ZEZjWkJVQktvQ2ticms4dm1JV1NKUnh2TFk3WVpmU2lMdDM4?=
 =?utf-8?B?YzU0MnFGanhoRkFhN1pRYnNBd2p2azcrMlIvTGlDcjNqUDd1ODFWdzdIOVd2?=
 =?utf-8?B?ZGt5NnNQUTh4THZmblFEb2tWeWdBckQ2Z3JCMW5XQkpmS0ZUODZwTVNoZjZI?=
 =?utf-8?B?eFlMYWc1UmhNWUxYNWk2OU0xRnF5MG9jNXUvZ0RkOXRrOFBXeGJqMEtWemIx?=
 =?utf-8?B?c2NHR1grajMrVWEvalpDQ1lwOURWYnJpWnVmZ1p1T2czT0JZWVRoMGpkczJv?=
 =?utf-8?B?YWV5TjI0Yjh4RFhjaXlXaXBneGd5eGdEa2s3SWNuRUlDSWoxcklRRGE5aUF6?=
 =?utf-8?B?aGJUeDg1SXhuMUVSZkNWR0V4VWt6QzEyU1g5WFlMK1pDQktGeitIYWxZa0dm?=
 =?utf-8?B?bUlYMXF5MlY4eEprQ1NmVVFnZEpMNWpkeCsxbm1rOStRajlDUHF1VXArS1JG?=
 =?utf-8?B?UFdtQWV4ZitNM2ptcUp3bFV1K3d6VmRYeTJxMlpFRjFtRncrWll0cnlKRUky?=
 =?utf-8?B?K3lHRG51MVVEa1JSK0V3M3FvSDNmeG5lREZQK1crbzZzbkpNd09jTnkzNU0x?=
 =?utf-8?B?RC9vVHlJNmY4eisrSFpOa3lMUEJwZmFKM3Z5Y3E3dTMybmNhOGR3UEk0Z0hu?=
 =?utf-8?B?c2dGVEIwd3ZhSWdyR2Q1enJvV3VnaUIzVGYxcFU1blJWNVRLS2phbEJVL0VF?=
 =?utf-8?B?Y2JPZ1VBNFVOMjJwY3pVVHdNVDkwc2FhZjM4dUdqSm83WHJRL0V1Wk1GblBX?=
 =?utf-8?B?RTRYN3FYb0dRMGtHQSs2SFJQSkhib1FLNW95aXJaTUppV3RPVzErVFFVVDRO?=
 =?utf-8?B?RGFZanZPS3cwNnR1YWNHYXJ4Y3BrOUVJOUx5QjAxaVEwNkJJWFhjd2Jkb0xH?=
 =?utf-8?B?U2tmRlFGVklqZmdmR3ByNVJNc01KTWpQYnkwYlpleUxrWTg5VFF3R3VhNlo5?=
 =?utf-8?B?Y2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <67237C35A3DD654FA424750F7DDE5432@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7382.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 454d819a-1070-41ca-d3f0-08dcb1edaee7
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2024 05:49:17.9268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gWLzTq1B/OxLXMnhFWXY5nI2vb25jbVt4lzOBjZqP7amaLheHOZ3YZvqp7VEzgKkLoPpMvC3pGdS595eHRiBSMNxqrOK+gEGtbXFLLa6M6A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8252
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA4LTAxIGF0IDE0OjQyICswOTAwLCBTaGluJ2ljaGlybyBLYXdhc2FraSB3
cm90ZToNCj4gQ29tbWl0IDgwNGU0OThlMDQ5NiAoInNkOiBjb252ZXJ0IHRvIHRoZSBhdG9taWMg
cXVldWUgbGltaXRzIEFQSSIpDQo+IGludHJvZHVjZWQgcGFpcnMgb2YgZnVuY3Rpb24gY2FsbHMg
dG8gcXVldWVfbGltaXRzX3N0YXJ0X3VwZGF0ZSgpIGFuZA0KPiBxdWV1ZV9saW1pdHNfY29tbWl0
X3VwZGF0ZSgpLiBUaGVzZSB0d28gZnVuY3Rpb25zIGxvY2sgYW5kIHVubG9jaw0KPiBxLT5saW1p
dHNfbG9jay4gSW4gc2RfcmV2YWxpZGF0ZV9kaXNrKCksIHNkX3JlYWRfY3ByKCkgaXMgY2FsbGVk
IGFmdGVyDQo+IHF1ZXVlX2xpbWl0c19zdGFydF91cGRhdGUoKSBjYWxsIGFuZCBiZWZvcmUNCj4g
cXVldWVfbGltaXRzX2NvbW1pdF91cGRhdGUoKSBjYWxsLiBzZF9yZWFkX2NwcigpIGxvY2tzIHEt
PnN5c2ZzX2Rpcl9sb2NrDQo+IGFuZCAmcS0+c3lzZnNfbG9jay4gVGhlbiBuZXcgbG9jayBkZXBl
bmRlbmNpZXMgd2VyZSBjcmVhdGVkIGJldHdlZW4NCj4gcS0+bGltaXRzX2xvY2ssIHEtPnN5c2Zz
X2Rpcl9sb2NrIGFuZCBxLT5zeXNmc19sb2NrLCBhcyBmb2xsb3dzOg0KPiANCj4gc2RfcmV2YWxp
ZGF0ZV9kaXNrDQo+ICAgcXVldWVfbGltaXRzX3N0YXJ0X3VwZGF0ZQ0KPiAgICAgbXV0ZXhfbG9j
aygmcS0+bGltaXRzX2xvY2spDQo+ICAgc2RfcmVhZF9jcHINCj4gICAgIGRpc2tfc2V0X2luZGVw
ZW5kZW50X2FjY2Vzc19yYW5nZXMNCj4gICAgICAgbXV0ZXhfbG9jaygmcS0+c3lzZnNfZGlyX2xv
Y2spDQo+ICAgICAgIG11dGV4X2xvY2soJnEtPnN5c2ZzX2xvY2spDQo+ICAgICAgIG11dGV4X3Vu
bG9jaygmcS0+c3lzZnNfbG9jaykNCj4gICAgICAgbXV0ZXhfdW5sb2NrKCZxLT5zeXNmc19kaXJf
bG9jaykNCj4gICBxdWV1ZV9saW1pdHNfY29tbWl0X3VwZGF0ZQ0KPiAgICAgbXV0ZXhfdW5sb2Nr
KCZxLT5saW1pdHNfbG9jaykNCj4gDQo+IEhvd2V2ZXIsIHRoZSB0aHJlZSBsb2NrcyBhbHJlYWR5
IGhhZCByZXZlcnNlZCBkZXBlbmRlbmNpZXMgaW4gb3RoZXINCj4gcGxhY2VzLiBUaGVuIHRoZSBu
ZXcgZGVwZW5kZW5jaWVzIHRyaWdnZXJlZCB0aGUgbG9ja2RlcCBXQVJOICJwb3NzaWJsZQ0KPiBj
aXJjdWxhciBsb2NraW5nIGRlcGVuZGVuY3kgZGV0ZWN0ZWQiIFsxXS4gVGhpcyBXQVJOIHdhcyBv
YnNlcnZlZCBieQ0KPiBydW5uaW5nIHRoZSBibGt0ZXN0cyB0ZXN0IGNhc2Ugc3JwLzAwMi4NCj4g
DQo+IFRvIGF2b2lkIHRoZSBXQVJOLCBtb3ZlIHRoZSBzZF9yZWFkX2NwcigpIGNhbGwgaW4gc2Rf
cmV2YWxpZGF0ZV9kaXNrKCkNCj4gYWZ0ZXIgdGhlIHF1ZXVlX2xpbWl0c19jb21taXRfdXBkYXRl
KCkgY2FsbC4gSW4gb3RoZXIgd29yZHMsIG1vdmUgdGhlDQo+IHNkX3JlYWRfY3ByKCkgY2FsbCBv
dXQgb2YgdGhlIHEtPmxpbWl0c19sb2NrIHJlZ2lvbi4NCj4gDQo+IFsxXSBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9saW51eC1zY3NpL3ZsbXY1M25pM2x0d3hwbGlnNXFudzR4c2wyaDZjY3hpamZi
cXpla3g3NnZ4b2ltNWE1QGRla3Y3cTNlczN0eC8NCj4gDQo+IEZpeGVzOiA4MDRlNDk4ZTA0OTYg
KCJzZDogY29udmVydCB0byB0aGUgYXRvbWljIHF1ZXVlIGxpbWl0cyBBUEkiKQ0KPiBTaWduZWQt
b2ZmLWJ5OiBTaGluJ2ljaGlybyBLYXdhc2FraSA8c2hpbmljaGlyby5rYXdhc2FraUB3ZGMuY29t
Pg0KPiAtLS0NCj4gIGRyaXZlcnMvc2NzaS9zZC5jIHwgOSArKysrKysrKy0NCj4gIDEgZmlsZSBj
aGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL3Njc2kvc2QuYyBiL2RyaXZlcnMvc2NzaS9zZC5jDQo+IGluZGV4IGFkZWFhOGFi
OTk1MS4uMDhjYmUzODE1MDA2IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvc2QuYw0KPiAr
KysgYi9kcml2ZXJzL3Njc2kvc2QuYw0KPiBAQCAtMzc1Myw3ICszNzUzLDYgQEAgc3RhdGljIGlu
dCBzZF9yZXZhbGlkYXRlX2Rpc2soc3RydWN0IGdlbmRpc2sgKmRpc2spDQo+ICAJCQlzZF9yZWFk
X2Jsb2NrX2xpbWl0c19leHQoc2RrcCk7DQo+ICAJCQlzZF9yZWFkX2Jsb2NrX2NoYXJhY3Rlcmlz
dGljcyhzZGtwLCAmbGltKTsNCj4gIAkJCXNkX3piY19yZWFkX3pvbmVzKHNka3AsICZsaW0sIGJ1
ZmZlcik7DQo+IC0JCQlzZF9yZWFkX2NwcihzZGtwKTsNCj4gIAkJfQ0KPiAgDQo+ICAJCXNkX3By
aW50X2NhcGFjaXR5KHNka3AsIG9sZF9jYXBhY2l0eSk7DQo+IEBAIC0zODA4LDYgKzM4MDcsMTQg
QEAgc3RhdGljIGludCBzZF9yZXZhbGlkYXRlX2Rpc2soc3RydWN0IGdlbmRpc2sgKmRpc2spDQo+
ICAJaWYgKGVycikNCj4gIAkJcmV0dXJuIGVycjsNCj4gIA0KPiArCS8qDQo+ICsJICogUXVlcnkg
Y29uY3VycmVudCBwb3NpdGlvbmluZyByYW5nZXMgYWZ0ZXINCj4gKwkgKiBxdWV1ZV9saW1pdHNf
Y29tbWl0X3VwZGF0ZSgpIHVubG9ja2VkIHEtPmxpbWl0c19sb2NrIHRvIGF2b2lkDQo+ICsJICog
ZGVhZGxvY2sgd2l0aCBxLT5zeXNmc19kaXJfbG9jayBhbmQgcS0+c3lzZnNfbG9jay4NCj4gKwkg
Ki8NCj4gKwlpZiAoc2RrcC0+bWVkaWFfcHJlc2VudCAmJiBzY3NpX2RldmljZV9zdXBwb3J0c192
cGQoc2RwKSkNCj4gKwkJc2RfcmVhZF9jcHIoc2RrcCk7DQo+ICsNCj4gIAkvKg0KPiAgCSAqIEZv
ciBhIHpvbmVkIGRyaXZlLCByZXZhbGlkYXRpbmcgdGhlIHpvbmVzIGNhbiBiZSBkb25lIG9ubHkg
b25jZQ0KPiAgCSAqIHRoZSBnZW5kaXNrIGNhcGFjaXR5IGlzIHNldC4gU28gaWYgdGhpcyBmYWls
cywgc2V0IGJhY2sgdGhlIGdlbmRpc2sNCg0KVGhpcyBzZWVtcyB0byBkbyB0aGUgdHJpY2shIEF0
IGxlYXN0IG9uIG91ciBzZXR1cHMgd2UncmUgbm90IHNlZWluZyB0aGUNCmRlYWRsb2NrIGlzc3Vl
IGFueW1vcmUuDQoNClRoYW5rcywgU2hpbmljaGlybyENCg0KVGVzdGVkLWJ5OiBMdWNhIENvZWxo
byA8bHVjaWFuby5jb2VsaG9AaW50ZWwuY29tPg0KDQotLQ0KQ2hlZXJzLA0KTHVjYS4NCg==
