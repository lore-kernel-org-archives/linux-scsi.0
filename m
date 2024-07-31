Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4E81DA32;
	Wed, 31 Jul 2024 13:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722432173; cv=fail; b=EZJViLue5y6ypq2Q+9Vq2LN6HST1oF9LBaAuEG6yT3y6kBjb4x49j0I69c/5n7wFRMO683GQZlf5JNlJNhOy1sSfxFgfQScBwh8hqX4vpeHrsHRhGCiHmc2iXMoylYllJAC69yV0hW3BpMyOzX17uITMk3CyH8OuVFpNXgfzTzU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722432173; c=relaxed/simple;
	bh=6urWfZP23Utf97i4B4OeMsGShsA+d7EnLXzvj+O82IY=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=XaL6pObXes/0NGaOaSVBDGrV8hjzPkG6lntaYkrHKAWhRzJUjSprTbg3SFX8qgQKzDr9kK14V2x4m2Rk9fq8grotyfxf9YZ9zYY2WPmVt+xWmEu590Nr3JgOSFch6kwv3TdmWB9XgYw14H/8PVyb0MjyRVNoPfteqqIQb+l3BNA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EBStb0t2; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EBStb0t2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722432169; x=1753968169;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=6urWfZP23Utf97i4B4OeMsGShsA+d7EnLXzvj+O82IY=;
  b=EBStb0t2owe1WQKKgY9GxXVPZ6l9SIE9MqfpIYWAnPc2fJogqfq2B3ND
   vkKx/OdzfhSksSCBUsI2Cq/ph/adPNcbnbnPdt1vtWn+PeOpnYrohX2/x
   Gxgj9K0fbY5r5245rMXAYi1lAAXtrWuLkMGcqP/xz68gTy169Hu4uMHBf
   RAAarBrHeK104wO0EFu/+z3qSSQhhsPRbMIPudQbxHqfHlPZb/gua2Net
   Cy+IrQ9536ZssZhatz7EPPj5NdYvV3vGZLx1Uc1fPRKnk/ZkBUokYUYcW
   imbYdafdB1HZvKb9lQu1FTfN97XwNLpQw7KRC2qliVH5VLrYbT1YhgibV
   Q==;
X-CSE-ConnectionGUID: XbviqUG8Qf61YP7R4vAwgw==
X-CSE-MsgGUID: kRD5ZwP6S+aTcOytx8OE7w==
X-IronPort-AV: E=McAfee;i="6700,10204,11150"; a="20125697"
X-IronPort-AV: E=Sophos;i="6.09,251,1716274800"; 
   d="scan'208";a="20125697"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2024 06:22:46 -0700
X-CSE-ConnectionGUID: 70WSNSGeR9SyVR+6odwjag==
X-CSE-MsgGUID: PUTlPI31SgOITd4rg9l6wA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,251,1716274800"; 
   d="scan'208";a="59486214"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Jul 2024 06:22:47 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 31 Jul 2024 06:22:46 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 31 Jul 2024 06:22:46 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 31 Jul 2024 06:22:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kuW9XifugI+tZrpGP8s59xT4kUAMVYeTA2+H4llSPAZfr7ukv7AEG5jhlh2puEmqC0RQNspmxP/d4zqF3KqsiZR8z34hQq+DCFiXnQn4Oq6i2sckBxQdjLVgkIk5vOGlnoQnew/R4uDMpfWpQKLB6iXL0OXY3ryE3zyCHzD41EvrlKnChr3yVoczEuKtZoVZDmLBztK6dkGCdCJ8qqwAvGBCRUlJslo0t7/bM9+KQtr0xjP17+W9vopj6L6L0oM+BzfW1+kGMMgD+CqMOfRigOJC60Q2zeTeTARy9Jxic49A0Jh5fYupZeiqFvXPeB2ocuzOaWROYFGL6CDpwdEYsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6urWfZP23Utf97i4B4OeMsGShsA+d7EnLXzvj+O82IY=;
 b=uuHvZVlOGwlf5+OGrCfOKFBtojxARPv3KeF1EXfiUMQCJBTXCRMqJ7kPA8ZSMaWCfyyXWnOcK710G7rk10j0QbvRGk0SZ72mBuCRtY9JBist+YPbhGL4dcnp+Glnr6LhxCgldO0HgOfihDtF3Fh5Cxjy86d4MJeBZGVQ5bCQ9v/t25VMykOep2TrVFP0r3lnMVev1aypzyp7nTLLWVm6mqSA+vCSOlsDeJ/Kqv/YueZgg9I5LlfUY8Gj3s7v85QNn5itYC1hPI+2QkGfApgZu/Bzf7aZHIT33Czck1iBD/MaLfv1uomutY8W8K4HMz+w6gwDcpoqRBGVpUX5fca/yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7382.namprd11.prod.outlook.com (2603:10b6:8:131::13)
 by PH8PR11MB8258.namprd11.prod.outlook.com (2603:10b6:510:1c1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.28; Wed, 31 Jul
 2024 13:22:42 +0000
Received: from DS0PR11MB7382.namprd11.prod.outlook.com
 ([fe80::80b3:e6e7:efec:dbee]) by DS0PR11MB7382.namprd11.prod.outlook.com
 ([fe80::80b3:e6e7:efec:dbee%3]) with mapi id 15.20.7828.021; Wed, 31 Jul 2024
 13:22:40 +0000
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC: "Saarinen, Jani" <jani.saarinen@intel.com>, "luca@coelho.fi"
	<luca@coelho.fi>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>
Subject: Regression in 6.11-rc1 in scsi/sd?
Thread-Topic: Regression in 6.11-rc1 in scsi/sd?
Thread-Index: AQHa40y3WIO/IrY1Q02LkwmBgEOUYA==
Date: Wed, 31 Jul 2024 13:22:40 +0000
Message-ID: <b123b699569f3a85bcfa521b2511e9e2698f31b7.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.4-2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7382:EE_|PH8PR11MB8258:EE_
x-ms-office365-filtering-correlation-id: 82e1cfba-54a0-4ced-746e-08dcb163da6a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bEJDQnFyL2JjN1BuQjlXbnE2eTl4anFaYXNNaURwS3krNDhkR2ZFNmdWZnVy?=
 =?utf-8?B?ODN3RFNCRWpoT0xRRWMxWjVpWkhSUk5yMTF5WE1qUkQyeVVBNmlFajRFbWx2?=
 =?utf-8?B?WlkyOW9QQTdMak85ZEgwWEdFUkhIbUl1TUxzdVpjN3FvTGV2TGVLcjYrWW5C?=
 =?utf-8?B?dGFyQUt3WjlQaFFISDlBREdmZVNoaDBnZFB6RHcyNmFxWWlLSWVZL05lalEz?=
 =?utf-8?B?dzdQV0FuWEcvU1JGUHMrSUpwMzZLMnhxb3V1bEEwR3BRRnlTMnFKTXZDQ29t?=
 =?utf-8?B?RXNWakR6TXFHOFVjVUdwU3JtMGhqamlhUnFRd2xLY1pyM1dwUjVKdTUyOHNx?=
 =?utf-8?B?TWRJc092WStwamxKYXhlZjFFdFM1V0Y3ZldkYk5mVjJRR2xFeW1vQTJOamNh?=
 =?utf-8?B?SGxuY0VBR3lFMDVLN0ZWNjgrZjU1eFIxTTIydUFieDQ5U2RhSE1NR1VwcUM0?=
 =?utf-8?B?ai80VWFvcGFWU2x3NkUzd3FTTGxXcUcvUUxJU3ZJTVo0UStUYk8zd2lYR3Fn?=
 =?utf-8?B?RnpIN2hOd0dTVU5wNXR6MEtKSGJpWjAvYWxOT1l5Q2xFbHBSQnR6Z2FmOHZS?=
 =?utf-8?B?cHpTZFBML1pOY1o1OTRuNDlDNXVnWnUrS3pQZlR1NUNTQ3BXRVAvOURYVGdv?=
 =?utf-8?B?MzhCc0QxOFM5VUYrRUlmMjk4ZlIrUjRGYUV6dWFDY2pvQ3pXQnVqQjhQay83?=
 =?utf-8?B?em4wMnZsVm0rcWc0MmVQLzBLSmZ6VllWa1ZJODliSm9DTTJ6ZC9Qd0lGQlZh?=
 =?utf-8?B?YW5Qc3Z2TE9zMjM1K2hmQU0zbGQwUkh3NWlNVDhzazllM1VrMFNkY1dWOGFC?=
 =?utf-8?B?TTF2TzB6a3lNenVnVzFCSzBxcHBDaXBQWmZNTUthNU0vK0pGZlFRblpjQThY?=
 =?utf-8?B?emFrUzM3TU9ZcnBUa0RvdmNETkRmNit3dHRqcUx1NjRiaTkxK01PZllEM0V3?=
 =?utf-8?B?T2d3ZzNLTXAybUo1VTliZXJpdk8vVjRlbGxNbEZmTzk2R0VaeTZ0TDdhTU1T?=
 =?utf-8?B?RHJ6ME02Z01OTXNMVElBVHNTUzRVTHBSK2kvSXJDSldZbzN3WGtiK1FwOVB4?=
 =?utf-8?B?eithdkZ5WndDTXlPL0xQR05NZ3ZOejVSM3h6YXZzWktuL0pLWGI0ZVNBa08y?=
 =?utf-8?B?OFBNN1FtTUgwbjluT05oRjFBdGlCT0FuaWNKWHBMSnhkemFHdzR2OEVDQ1dD?=
 =?utf-8?B?RzlTL1pmLzBaUjJjb2pNTHlMZmhGNTFaZEo1K3NDZW1mNm8ySXlIdlcraEpo?=
 =?utf-8?B?NmhmS3BJYmdscGprQzV6cEpSd0xxTW1GTGhtTCtzUHdIcm9UdGFuMFBUQ3Bv?=
 =?utf-8?B?SXROZ2RkNDBQUDF0S09EM1BsdXFZVXdtQ25SdGJ4dDAzVTh5TlZBQ0dVVW5n?=
 =?utf-8?B?UHpTWmlPdVRHdllaTEp3aEZuVkpZKzlCRFBFMVNuR2lGVkFJckJCSDB2RG4x?=
 =?utf-8?B?L0VkUEtnbjB3WHFMYkhHdHJiSm80b1E3b3ZvMmFEdjdHN1l2UWV3cFJLeVRL?=
 =?utf-8?B?aHVSQ3BLc21ZWHkwVTVkb0RiSURERDM0VTMzcDgxdFd1eHU0L3VyZllUNlVP?=
 =?utf-8?B?eTVyYytDQ2hXeTRmMmg4YjFQbjRscjVETzdDdXRneGsvcGloWFR3clNEdVhH?=
 =?utf-8?B?WkpZNWhGWVU2VUMzcHhocFZuc05RQlVyRWt4U0VZcGN3WVR3c1pocHJsU0hr?=
 =?utf-8?B?d3lHcjkvVTZzcFRqYTZaem83bWNsUyt1RVBpY2twRTBoUkZOTTFzSmxxV2Zl?=
 =?utf-8?B?MlFDaHlqczY5a1JrUzhDZTFBNS9ocVAwc0dudm9YSGpObkQwaWpPenA2OHMz?=
 =?utf-8?Q?+uT7ys7U6kTG8v0U2t3HVBJSUIHaoUiYW4xZo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7382.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K0w2OUFvekhnWVRPNzZPdDAydHlGNjNQemk0RTd3azJ2WGFqUkYwV1ROMUlV?=
 =?utf-8?B?RHNZY0ZIaDA2Mld6OS9vY24zS0JLMi9VaHI5Y1V1SnlrS2xKNVVzT0l4LzND?=
 =?utf-8?B?T2MrbHp4ayttL0RoUEM5aE5QWmplMlJHa2pjSDNZVHRRcG5VT1RNWlgxUEdw?=
 =?utf-8?B?cGhBTzg3WHRKMEFpeUt4QUhwSXNWbkVWTW5QS3RFd1JsNTE1S3VSaFh4bStM?=
 =?utf-8?B?MEhkdVh6aWNtcGxoeTFybjF5Y0xPczlHbWJXUWFIMmtISkVBMFl6T2RaMWdF?=
 =?utf-8?B?MHdKanRvZFloT1VaM0RHYnNsejRHRWtRNlNkVElKdVdHTVhFWjlHQnB3UWJt?=
 =?utf-8?B?REFLQWtZNmNEemUxL3ZHNUNPeGhxdXZIQVYyWWVHVUZiaGJXU2FKc25XSU5k?=
 =?utf-8?B?RS90bHJzQXFGekJKL2dkZFU1cVF3RUpnejhUTjJSODJmN1orUURZM0NkcmM1?=
 =?utf-8?B?L2pmU3dKRllsQmt0S1FRcnlWQjN5a1cyTjNvcXBMa1B4TlkwbG1FZkZscmRW?=
 =?utf-8?B?Z1plVVlvcjlreVR0dEpHTC80Y0pSaWlMZTBMQ2JSRHlFeVNMeTRDaU5OSWZ5?=
 =?utf-8?B?WGR5NXNKSEpmVUpIekQ5ZWZ4bU9IcUJuUmJ1cFhMckNIbTN3bi9zMi9WK3cy?=
 =?utf-8?B?Ulh6MDZKQytDV0hZWWJBcHkxOTVtR2Q5RkdxQnF3YjlmRzlQVkhQaUxZWStu?=
 =?utf-8?B?ZHozQU9BMk5HOWtDK0trQ0plcnB2VEdIZ3FLLy8zeURXcVdBZ3pwSzc1S0p1?=
 =?utf-8?B?NTBTTUZvSi9TaSt4YjVYM3NFYzBtMHhLejgyUmVaMFhNY2dWT3RIQVE0NHZk?=
 =?utf-8?B?Qm9PQmg5eGdGZGxGL1VtUGJodkwybnRUa1JOblE0cU5jSVk4L01lZXhTNk5S?=
 =?utf-8?B?ZlkwZkY2d1RYNDZrZjdhM3FXSE40eThja3pLQUxOVFgwYUpmUGhWMldkUzJL?=
 =?utf-8?B?UHQ4dC9XeWpPdmI2bURKMEhyanpzNm40L1dhcE1leHhOV1Z6V2p0amRKelJ6?=
 =?utf-8?B?UG9mRWZRN1lnb2w1QVFsbGY5MHR2dmpRYmFLekJPTmVpWkpOUmMzMTIxZG8x?=
 =?utf-8?B?bTlOTk9KNk1tU2puZE9GaWE3Z2wvVGIwTlpiZndLS0JXMlNNRXRwWlU1dXZz?=
 =?utf-8?B?MVpUOC9yZTdldlA0QW1Bc0hvSGJiMDZkdlNVei9tTFJMcldsSHc5WWlPWVNQ?=
 =?utf-8?B?ZHRTMUx2N0VkcW1PU2w3T1Q4bENOWE5hc3Qyem9hazhITnBOTnVpbG9YTnlE?=
 =?utf-8?B?SEZGSlNLM3E2SC9JdlI0OUJ3UStSUlVxWkdKUXlEdFg0WDc1SWFLS2FGZVVJ?=
 =?utf-8?B?bkwvRjdhTzRjY0dWMFhtTmhhZnpKMm41RjNqNE5UbDkzUVdYb3pTajBTVURZ?=
 =?utf-8?B?RDBzOWROV21vcWNpZHNDdkRDWEo5VFdvTkdTeXJqTkRncHEwSEYvUUpDakVs?=
 =?utf-8?B?YXRoQThSYUd5dHZZbWE5d2xRdk5RNkt5L29DdWVQS2EySmxzUmF6UkRpalBo?=
 =?utf-8?B?cGcrbW1jbXNuZHJ1NXVDM1VNbENEN015bHNrUldBMVhXelVJQkRMRHMzOEtL?=
 =?utf-8?B?T3kzZXRhdUI1bjB0aUphMWNaNWZKVTR3MWR2Vm9LVHVLUjFBQ3drRjJ0YkNO?=
 =?utf-8?B?cFVNenBDRkZxTWpzZjFYN0NEWTk2Wkg2T3E3OWZ5Z1FaRFgwM2lWZVNoK1VX?=
 =?utf-8?B?Z1Rwbi8xTHc5TXVTWlNWV0R3WUp4NDZYUlBpdEIwQ3dzYXl6SVh3TkpkWkZp?=
 =?utf-8?B?cEpkU0RrV0R3MlF1cU8rcnhpdVF4dXNEOENkSEVncS92cU1kVjdGbFNZRVpY?=
 =?utf-8?B?ZE5sb0lPZXFUclZiRWd0V1hhMUZkQmtvaWtkOHNxZ2ZrcXByTDFKQkIxM3Nl?=
 =?utf-8?B?aTZIbDMralhXbGxyZ0MzSGRjVTk0a0wrM044ZmN2V3VBMEJmWWVQTzJOUU9o?=
 =?utf-8?B?a2w3VlVibGhyTXFvNXBVTUh0OGN0WEoyWmpaYWlSK2VxQzNRcURxakVLb0Jv?=
 =?utf-8?B?aGp3TGgrUzB2R0FIbldHTm03MHJMUUxDMW0xdVRLV1ppb1AzZ0dRWnVUZVFR?=
 =?utf-8?B?VkFlbUNzTjlrSmtabU5hTTkwWkNGRXgzTWsyaFJ1ZnI0TnpPZDFSaTlLNm56?=
 =?utf-8?B?OVVwM1A0Z2hBSWZKaE51Tk9SNExwL0k1T3dVWDFXajl0NkhZM2NsTGs0cFI5?=
 =?utf-8?B?NUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E45162333E7254EAAAEC6B90529E8BB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7382.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82e1cfba-54a0-4ced-746e-08dcb163da6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2024 13:22:40.3928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WvFeFm3+q/1e6gpDHapSfQrdIuAdQrFjvytZx/74pK5w2dcMuCGTVLu9DMJtmrf1YRIj2oZqlFbS8vMvB5ONSzSrgVKG1JRvohBl6vtsrQI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8258
X-OriginatorOrg: intel.com

SGksDQoNCldlJ3JlIGdldHRpbmcgc29tZSBsb2NrZGVwIHNwbGF0cyB3aXRoIDYuMTEtcmMxIGlu
IHNvbWUgb2Ygb3VyIG9sZGVyIENJDQptYWNoaW5lczoNCg0KPDQ+WyAgIDI1LjM1NzEwNl0gPT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQo8ND5b
ICAgMjUuMzU4MzgzXSBXQVJOSU5HOiBwb3NzaWJsZSBjaXJjdWxhciBsb2NraW5nIGRlcGVuZGVu
Y3kgZGV0ZWN0ZWQNCjw0PlsgICAyNS4zNTk2MzZdIDYuMTEuMC1yYzEtQ0lfRFJNXzE1MTUxLWdi
NmY5NTI4YzdmZmYrICMxIE5vdCB0YWludGVkDQo8ND5bICAgMjUuMzYwOTAyXSAtLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCjw0PlsgICAyNS4z
NjIxODRdIHJjLmxvY2FsLzYwOSBpcyB0cnlpbmcgdG8gYWNxdWlyZSBsb2NrOg0KPDQ+WyAgIDI1
LjM2MzQ1MF0gZmZmZjg4ODEwMjM1ODY3MCAoJnEtPmxpbWl0c19sb2NrKXsrLisufS17MzozfSwg
YXQ6IHF1ZXVlX21heF9kaXNjYXJkX3NlY3RvcnNfc3RvcmUrMHg4ZS8weDExMA0KPDQ+WyAgIDI1
LjM2NDc5OF0gDQogICAgICAgICAgICAgICAgICBidXQgdGFzayBpcyBhbHJlYWR5IGhvbGRpbmcg
bG9jazoNCjw0PlsgICAyNS4zNjc0MTBdIGZmZmY4ODgxMDIzNTg1NTAgKCZxLT5zeXNmc19sb2Nr
KXsrLisufS17MzozfSwgYXQ6IHF1ZXVlX2F0dHJfc3RvcmUrMHg0NS8weDkwDQo8ND5bICAgMjUu
MzY4NzczXSANCiAgICAgICAgICAgICAgICAgIHdoaWNoIGxvY2sgYWxyZWFkeSBkZXBlbmRzIG9u
IHRoZSBuZXcgbG9jay4NCg0KLi4uZHVyaW5nIGRldmljZSBwcm9iZS4gIFlvdSBjYW4gZmluZCB0
aGUgZnVsbCBkbWVzZywgZm9yIGV4YW1wbGUsIGhlcmU6DQoNCmh0dHBzOi8vaW50ZWwtZ2Z4LWNp
LjAxLm9yZy90cmVlL2RybS10aXAvQ0lfRFJNXzE1MTUxL2ZpLWJzdy1uMzA1MC9ib290MC50eHQN
Cg0KVGhlIHN0YWNrZHVtcHMgc2VlbSB0byBwb2ludCB0byBzZF9wcm9iZSgpIGFuZCBzZF9yZXZh
bGlkYXRlX2Rpc2soKS4NCg0KSXMgdGhpcyBhbiBrbm93biBpc3N1ZT8gRG9lcyBhbnlvbmUgaGF2
ZSBhbnkgaWRlYSB3aGF0IGlzIGNhdXNpbmcgaXQ/DQoNCi0tDQpDaGVlcnMsDQpMdWNhLg0K
