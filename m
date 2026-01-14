Received: from rcdn-iport-5.cisco.com (rcdn-iport-5.cisco.com [173.37.86.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0462C274B5F
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2026 17:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.86.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768410245; cv=fail; b=e85PDI2oBVYmQi6BfO+gzcKFQkQBMuKkadAdqKUte4NhkId2RlF0/jwwHoS35mhXJMbiHgulrOrq7TNWbmBV47fUo+QtS5Kmtsaz3CJoBSKSQaRmZgu16C92T2c8kdBQzqoIILyfYmz5nEG8u0vGKjU6d73vru2aQequEZHQGZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768410245; c=relaxed/simple;
	bh=vyOq8CwsIoI8+1vta6DOpRxAf6FzWFazHKw+5Ow8gIk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rBNaChHyHKkvWu8fIowWV0dUMnQAzuGBG5I+AJpNYoj2ANYJkNlEUkZbpoyQ74FHp99wwe2slxOLxcWkGFlAPXXQEsrRPCu8zcqo3LorI0zcuc/HXQ5NAXmJu19pOblLWRMdUoKqCLRZdggPdVjFDTyXd84r8DEhlKkNLkPM2dM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=IKv6acAd; arc=fail smtp.client-ip=173.37.86.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="IKv6acAd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=8609; q=dns/txt;
  s=iport01; t=1768410243; x=1769619843;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1ef87nUEfLasJAQcCVNKri4jXXHhgjYEIHAeAyTXTY0=;
  b=IKv6acAd5q4fEbAqNu6wU2Ku6iEAmJzJElB2HOGzJQ4Bf1IIv03KNzr5
   SOvY71J4HZ29QWGgH4bb5Cc2gARDM0iVtX+yIyCV11HBlXYbAJ/z88nNQ
   mySgJXlTi0yQoQ7/uUp+jJpIp6jleGeHQZu4kWnJ0zXb36UnOJKSkEJ29
   iCjjLU3ibQoBirSckBv9Hleq3HupwGd9ZP8RMflfyWZrYYGoSMiuoq6lV
   sKqjBP8/4urSHz011ksCYE/zJ4OhF9LwdAjXUHwTwNUEqtOYmNg7PNy9H
   XRLP0JdEi6Y81osGJWUD3h0AKHZ1taTwqlbySGW3OlvoqmJG/HP6P+5A9
   A==;
X-CSE-ConnectionGUID: b+8adS8VSRmMebGsNS3r5Q==
X-CSE-MsgGUID: Wkd9K/aaQHyl94EwI9O08w==
X-IPAS-Result: =?us-ascii?q?A0A/AAAky2dp/4//Ja1aHAEBAQEBAQcBARIBAQQEAQFlg?=
 =?us-ascii?q?RgGAQELAYFtUweBAIEhSYgjA4UshliCIZ4dFIFrDwEBAQ0CMSAEAQGCE4J0A?=
 =?us-ascii?q?oxtAiY1CA4BAgQBAQEBAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHBYEOE4ZPD?=
 =?us-ascii?q?YZbAgEDEmcQAgEIDjgxJQIEAQ0NEweCYYJzAwECoF0BgUACiiuCLIEB4CwUA?=
 =?us-ascii?q?YE4AYhSAYVvGyCEPScbgg2BFAFCgmg+hCoDGIQTgi8EgiKBDowaiABSeBwDW?=
 =?us-ascii?q?SwBVRMXCwcFgSNDAyovLSNLBS0dgSMSDx0XEx9YGwcFEyOBIwUBHAYcEgIDA?=
 =?us-ascii?q?QICOlMMgXYCAgSCEHuCAQ+HHYEABS5vGg4iAi4WJwMLbT03FBsDBIE1BY8Yg?=
 =?us-ascii?q?nEBMV4TCCd5gQMgRJJPFAcCAT+CbJBGn1kKhByMHpVwF4QEjROZVJkGIqNnh?=
 =?us-ascii?q?Q0CBAIEBQIQAQEGgWkBOoFZcBWDIglJGQ+OLRaEEb8neDwCBwsBAQMJkWuBf?=
 =?us-ascii?q?AEB?=
IronPort-PHdr: A9a23:L7NYKxyuaC8O4rDXCzPsngc9DxPP8539OgoTr50/hK0LL+Ko/o/pO
 wrU4vA+xFPKXICO8/tfkKKWqKHvX2Uc/IyM+G4Pap1CVhIJyI0WkgUsDdTDCBjTJ//xZCt8F
 8NHPGI=
IronPort-Data: A9a23:pcpzGKxujBv9J2UNV396t+dixyrEfRIJ4+MujC+fZmUNrF6WrkUGx
 moZWm6DMvaJMGryLd13bdm/pkMFv8PSyd9rQABpq1hgHilAwSbn6Xt1DatR0we6dJCroJdPt
 p1GAjX4BJlqCCea/VH1buSJQUBUjcmgXqD7BPPPJhd/TAplTDZJoR94kobVuKYw6TSCK13L4
 4qaT/H3Ygf/hWYtaz5MsspvlTs21BjMkGJA1rABTagjUG/2zxE9EJ8ZLKetGHr0KqE8NvK6X
 evK0Iai9Wrf+Ro3Yvv9+losWhRXKlJ6FVHmZkt+A8BOsDAbzsAB+vpT2M4nVKtio27hc+adZ
 zl6ncfYpQ8BZsUgkQmGOvVSO3kW0aZuoNcrLZUj2CCe5xWuTpfi/xlhJEt1bYQUwbZJOltL0
 PESBysrVUuZ2tvjldpXSsE07igiBNPgMIVavjRryivUSK54B5vCWK7No9Rf2V/chOgXQq2YP
 JVfM2cyKk2cOHWjOX9PYH46tOShnGX+dzRbgFmUvqEwpWPUyWSd1ZCxbISPI4LUFJk9ckCwm
 WHKrke+CxgjFM2bmGao7VP9obefgnauMG4VPPjinhJwu3WXx2oOGFgNXkC6iee2h1T4WN9FL
 UEQvC00osAPGFeDVNLxWVi85XWDpBNZA4QWGOwh4wbLwa3Ri+qEOlU5ovd6QIVOnOc9RCch0
 RmCmNaBONClmOf9pa61nltMkQ6PBA==
IronPort-HdrOrdr: A9a23:chF0g6xXzNupX7l+jmXXKrPxaugkLtp133Aq2lEZdPULSL36qy
 n+ppQmPEHP6Qr5AEtQ5+xoWJPtfZvdnaQFh7X5To3SLTUO31HYYr2KjLGSjAEIdBeOjNK1uZ
 0QF5SWTeeAcmSS7vyKoTVQcexQveVvmZrA7YyxvhUdKD2CKZsQkzuRYTzra3GeMTM2fqbRY6
 DsnvavyQDQHkg/X4CQPFVAde7FoNHAiZLhZjA7JzNP0mOzpALtwoTXVzyD0Dkjcx4n+9ofGG
 7+/DDR1+GGibWW2xXc32jc49B9g9360OZOA8SKl4w8NijsohzAXvUjZ5Sy+BQO5M2/4lcjl9
 fB5z06Od5o1n/Xdmap5TPwxgjb1io04XOK8y7bvZKjm729eNsJMbsHuWtrSGqe16PmhqAk7E
 t/5RPci3OQN2KZoM2y3amSa/ggrDvFnZNrq59hs5UYa/pfVFeUxrZvoX+81/w7bXjHAIxLKp
 gdMOjMoPlRal+UdHbfoy1mx8GtRG06GlOcTlEFodH96UkdoJlV9TpR+CUkpAZKyLstD51fo+
 jUOKVhk79DCscQcKJmHe8EBc+6EHbETx7AOH+bZQ2PLtBKB1vd75rspLkl7uCjf5IFiJM0hZ
 TaSVtd8Wo/YVjnB8GC1IBCthrNXGK+VzLwzdw23ek1hpTsAL7wdSGTQlEnlMWt5/0ZH83AQv
 62fIlbBvfyRFGeULqhHzeOLaW6BUNuJ/H94OxLLm5mivi7XrHXig==
X-Talos-CUID: 9a23:NSKNOG35YoU91UdwrJmvYbxfEIN1e3HmnEnrGUqdBGxGU5uuEkXNwfYx
X-Talos-MUID: 9a23:sV0/IgvaXGN71lVzDs2nuzJuZeQv6q2XKFEJwMkrpOjVEnQgJGLI
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-l-core-06.cisco.com ([173.37.255.143])
  by rcdn-iport-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 14 Jan 2026 17:02:55 +0000
Received: from alln-opgw-5.cisco.com (alln-opgw-5.cisco.com [173.37.147.253])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by rcdn-l-core-06.cisco.com (Postfix) with ESMTPS id 2A6091800026D
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2026 17:02:55 +0000 (GMT)
X-CSE-ConnectionGUID: CO7gN+W4Q+K/c1iiYOcShg==
X-CSE-MsgGUID: TRw4SPrbRDeITsjsLXp6xg==
Authentication-Results: alln-opgw-5.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.21,225,1763424000"; 
   d="scan'208";a="41990113"
Received: from mail-ds2pr08cu00101.outbound.protection.outlook.com (HELO DS2PR08CU001.outbound.protection.outlook.com) ([40.93.13.73])
  by alln-opgw-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 14 Jan 2026 17:02:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IwKDihxh3i3k8JAWZM+1GBSl3vm0hh1MTx314OBELE+GafxbPK3i0sr57doGETzEf7fOaJukmpRvVasLYz/dhKjxeGG2ynvyqmpwShE8TAlGoRq/UqvFVOJNVzzh5aCo/7Z4pxGMcQP4iooZu0SUqtc++MjWHNfKdaQMCOBXeujNGrhNxuyQXu2adrtG1DaYXOa0/TNXHCzOYqtWCpIFvZWMg6dbxuv0NIUud6c7c/IzN+dxqXzSJa8iBKYx1XJQQjVhq0P2/z1dFIUZt/SRij3bkqfD9H/HNhPyMvqbmLBzfJi66AF73s9zsGymz//q/Pk0KdzEnkty2lt3NdW06w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ef87nUEfLasJAQcCVNKri4jXXHhgjYEIHAeAyTXTY0=;
 b=pMx0YtD5rsNnIu4JNLmAXPU8EbviB1PJmMRyv6CE2XQt4IDY13A4i9suJRSoRhG/UecD8I+vL7MD6MikF5fty8Ze6Zdl608G5OkLOeVTWj7DXnsO733D1bWO+yM9RCDGym4+C9o5T9vqjI0rQ2GSHX7PLZ5SANzzWlkr/HQmfrZhaCPZqgi5gMnIprmlGL4T3lF21X9GDUBHWxe8peuMG9R5SdOXeB/9JNcTeGlKBLYNG9yz55K1+cHXtL1yYejAjHWNDvq7v17xIAVJmFvBMwLdqgZUadkkojqXEsllQHF6huiTLRsm7VlG3IzFFu/kMQMGxcLInvuXOgijq+OAbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by PH7PR11MB6932.namprd11.prod.outlook.com (2603:10b6:510:207::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Wed, 14 Jan
 2026 17:02:50 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%4]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 17:02:50 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@kernel.org>, "Martin
 K. Petersen" <martin.petersen@oracle.com>
CC: James Bottomley <james.bottomley@hansenpartnership.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sesidhar Baddela
 (sebaddel)" <sebaddel@cisco.com>, "Satish Kharat (satishkh)"
	<satishkh@cisco.com>, "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>,
	"Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>, "Arun Easi (aeasi)"
	<aeasi@cisco.com>
Subject: RE: [PATCH 4/4] fnic: make interrupt mode configurable
Thread-Topic: [PATCH 4/4] fnic: make interrupt mode configurable
Thread-Index: AQHcTXJy2FynwvhbtEuofvwLS32KDLTmNqmAgACvswCAAOdagIBqhQOA
Date: Wed, 14 Jan 2026 17:02:49 +0000
Message-ID:
 <SJ0PR11MB5896BEB89C838BF3E4929135C38FA@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20251104100424.8215-1-hare@kernel.org>
 <20251104100424.8215-5-hare@kernel.org>
 <SJ0PR11MB5896BDD3102F17EA15356C95C3C2A@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <b8631995-a3df-4232-9f89-514d7a502bc0@suse.de>
 <SJ0PR11MB58964721E3ABEF2CF62D7D10C3C3A@SJ0PR11MB5896.namprd11.prod.outlook.com>
In-Reply-To:
 <SJ0PR11MB58964721E3ABEF2CF62D7D10C3C3A@SJ0PR11MB5896.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Enabled=True;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_SiteId=5ae1af62-9505-4097-a69a-c1553ef7840e;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_SetDate=2025-11-07T22:17:28.0000000Z;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Name=Cisco
 Confidential;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_ContentBits=3;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Method=Standard
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|PH7PR11MB6932:EE_
x-ms-office365-filtering-correlation-id: 62f40d60-3a35-4ad9-53b1-08de538ebf4a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|10070799003|1800799024|38070700021|18082099003;
x-microsoft-antispam-message-info:
 =?utf-7?B?Ky1kZG9yUGFIcThjRTFlSjI5TlVHMistcGYrLW9oTGN4Y1N4VGVYWFRIMVpM?=
 =?utf-7?B?bGhMSVM5MXhGZnZLRjFkM1VQS3ZiUFZpUmZ1RkNXRDU1VWlyakNoSistQmxw?=
 =?utf-7?B?Q1dhNHE0RDN2NzdNKy01Z283bmdCUlhzbkRROWtpdTc5VnJMQmYxSTh6WWZL?=
 =?utf-7?B?VXM5ZXlYNUxRWmlhQlZTVmQxMFpPQ3BxVmQ4dFV5Z00rLTBIUkd3bjhVTVJh?=
 =?utf-7?B?d05EKy1JY3NJSistRUJIT1ZpTzZJWEtKci9KWUZEMU45L1IyVUs2bDhaSzJR?=
 =?utf-7?B?WGo1aEkwajdIbGszVnpLbHlQWnBaZjRGSldQQkY4MVl5aTJKVmNnbHRkaHkx?=
 =?utf-7?B?SVFhaEtrTzV3WGh5cHBmNjR4Y3MyZUptL3JsRVZrZHppVllPYnVCZWNDVFFp?=
 =?utf-7?B?T0w1eXBMOHhUMTNWN0FCYnd0akg2V1VkdzZMc282MnRCbVhwKy1VMDFzbGF4?=
 =?utf-7?B?bHlmT1JHV0g3c1pkY2dLeWhhblZxaHR2NW9mNVREdGhUa0tENjkrLU55dWtE?=
 =?utf-7?B?elBMQzMyamxJWkdpZXlyZmozTmx1R0JtQnhvWnlhQm5XMSstWXIwNndBTVk4?=
 =?utf-7?B?a2xLWHgyUGgwSEZTd3dxeFE5SUNYeEhlb2dzcnovVFVOWGZTYkU5U0pQNXc0?=
 =?utf-7?B?L3g2WlNBeG9uUENsZFgyUistcVBYRHU4SWV2U0s4ZE5ud0NCRlI5WGNTZGRF?=
 =?utf-7?B?Q21BL1FoWVBOdldTTU5YUFhZM2JILzNSRHRGNHppV3RjNEpKZTBRbC9KWkxn?=
 =?utf-7?B?N2t1Z1Y5L05oVmRPU25PS1BFUXFLODBYank5TmJySWFZL1Q2ekppVE5Na1pX?=
 =?utf-7?B?MVYvY0hTajJVNFFEQXJBTHhqNDZId1R3Ykp6TGJqQistVHBYQ3RnWEJzMUpE?=
 =?utf-7?B?UUpHd2pvL2h6UXJBQXhkZ0U3ZGYyVGQ5Q1Z0VHorLUgwdjFKSnpMYlNPOENK?=
 =?utf-7?B?RFpCNUJsei9keG9KZ2Z2dnpKbklZbGREU2lzM2hSTjlCSERLclFTMUtDYWZJ?=
 =?utf-7?B?SVpITlB3NWRpN2NFZ1FCeVJLanFRcVRsdXA5UjZxZ0RhSS82blVTRSstR2FD?=
 =?utf-7?B?Z2hKL05Fci81bU1VTDYvaTB1Ymw3WE93MERzR0NuNlYwR3NpN0FnSkRCSmNE?=
 =?utf-7?B?UW9McHJTN3J5bDBPV3ZVWVdsYzNpckVOa3hpaistNTRMS0Mvc0xsUCstQzJh?=
 =?utf-7?B?eG1XMERXKy0rLWNBemNCKy1QRXdmNDd5TVFWcHU0ajBOVW00ZTZ3UTl3Wk9h?=
 =?utf-7?B?Q1BWY3VPekhPd0k0Yy9DMDl2RmVYVkI0NHQ5TDQ4R0xFN3BCY1RUd2o1MDF6?=
 =?utf-7?B?NDVmaUVIRGhUTWdQczdXTEMzTzFUMmx1Q2hyVXJmaVk2L0QwQm0yNWJZM0da?=
 =?utf-7?B?YTRXOWc1WFU5c2E1M25IRkNDcG9OWW1PTHJmSlZ3UlZ2R01ldzhLcXNCU0ZU?=
 =?utf-7?B?TjVVSEo4ZFZldExjUGdySzhBQ3BUZXgyTk85NWNHSy80S3RSc1hQUm9hM2dx?=
 =?utf-7?B?VXRxMG9MQUNwb1h2MXhWYkNlaUlXYngxRzkyYkNGaE9hRWFleGl2aEZyVyst?=
 =?utf-7?B?MHpFZEJiVEcyQXhOUU1HQXdoaUUyYmRUR285NnRBbXYrLVVReG9BKy11TFZT?=
 =?utf-7?B?a0lSOXFMMXBuT1Npbk84S3M5Mk5HMVUzT01aeU5HMUVHQUdnTVU4NFFPWXZr?=
 =?utf-7?B?cEk3UThXY0FSeUh6Ky1BQ2lXWkdURjBjVE1KbWQrLUNNL3Jld2lWMmxhRXJO?=
 =?utf-7?B?M0M1bG94UVArLXpDNXdhcW5pbHRBRVRBeWJmcDVkSUNPSjRUMGFiSW4xTDI4?=
 =?utf-7?B?V3NUNGpubmt5NHRvTERQcjA0U0lVN1RLL3BOVWQ1emw3aHNNcDlOcTVhaHZB?=
 =?utf-7?B?TXF1S1BPeE9hSGlEUE9PcW4vZlNNdWg5RmYzMGxSTVlxRkg2eXJTL0JlZlRk?=
 =?utf-7?B?VHZZc2F1RW8vN1Ewa2V2ZjdNMUpHQjhGRmFIT0RQZmFHaU8zSkgzay9tVm5n?=
 =?utf-7?B?bkpKTFNjdU00WTYxVUFVb1dNMHNhUVVLZE9zRzFwSzJ4VmFDZ1JwOFJadUw1?=
 =?utf-7?B?Yy9PMWVuM3JnTWVsenZZWVkwM0gxWG9QbFNyU0NoMEZRMVNMVW5QUEcxY1ZU?=
 =?utf-7?B?WGxuY25LTCstYUhWU2ZKVXBXcDJ5MHpZOVVZcFdFMkFUdWVIc0hLMjBVUDVS?=
 =?utf-7?B?M0pnTXlXMzZXTVd6ZkJ4dCstYnFUTWU0emlkc05keVhIV0RSdm1SNVlUaVY5?=
 =?utf-7?B?akg0ODhNK0FEMC0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024)(38070700021)(18082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-7?B?RFpETy9IdWVXZkZLcmh1cjhnTlR4ekJKbnQrLVcyakVQVUNTQzE0enJZZUpZ?=
 =?utf-7?B?aEdoVGdveCstMTlPaDdxSmlGYVZnQjNralN1WmhRQmNzMmQzRW9kTG4zN0dq?=
 =?utf-7?B?RktXdnNtdk4vamcxQlRSYW9lVG12cDdxNTRsaUlRKy1PaVRlcGlTbEJUTzB2?=
 =?utf-7?B?TGc4MldEY2FUckpIcWJEbkliSXdqWkFsU3JGUFMwQWZrVlF2WXZ0bXdyaDBF?=
 =?utf-7?B?QUJUanVKMTc3dkN2V084WDlwa0tYRFZwSFhqajk3aVBwVGsxOXByc0N4V1NH?=
 =?utf-7?B?MnJYZ3FSOEN3OExoY1FaU2dPTUQ5SGlCN2RqVG1tenpyb2RoZ3VDNzRHMk5S?=
 =?utf-7?B?NkxISUFYNEpTZkpyZFdWbnoydmFxVG9qTk5GWUErLTVNTlVDelBHdWdHOHRh?=
 =?utf-7?B?MGp5RUxvUTdsUG5ZcEVPWGZSc3ozQWFFYlMxYlJ2MmJ0QzRRclA2b2U5R3Rk?=
 =?utf-7?B?THU1c1hPZ1V0UUpqZXJvWG9XNEYrLUg2T3hoVFlEZTE0bmtCeHBraU9pTklV?=
 =?utf-7?B?cWJvMSstRnlybXBlR1k5bFFHZWdYb0s1UGdkWEJrcUJieGNaazZMTTdqQlhU?=
 =?utf-7?B?VHVKM0RiajdYaHcwRlcwSFBwblNUZExoR0Z2T0ZFZk9jc0hTd1hXYVRGL3o2?=
 =?utf-7?B?Y01KVWplMTA2MXZ4TXhKbjlYL3NvZEZSRUtqZjJkWkhsNGs4eUFTRG9DcGpR?=
 =?utf-7?B?aEZaTHBLV05UM0NUR3dMZVMvdmtnZmdlOWkvTW9lNVRkY3l6NFgxbSstZWxI?=
 =?utf-7?B?b1RPbXpibEVBaXpIYU1hQ2xVbnZoaDhhYWhQbGlCM21CaUJPeVFyYVBtWVJy?=
 =?utf-7?B?NzFIZHZOUEhKWUJ5TEErLVV2YWNCWnhGNmhyMUszbE9oSlJ4MXgyQm5JTHR4?=
 =?utf-7?B?dUh2Ky16Rk45Ky1PZWxyV3liRGJMY2lBNm5TSktiZ00xVW9CbEM3Z08rLWxS?=
 =?utf-7?B?TmZyaVNzbVRQTlhQOXZ4MXZueUI1Mml0YlJnTXhlUTRVSVFvMTlBZExQdi9w?=
 =?utf-7?B?UXN2elJyZHNYcnh4ZHQ5TEUwL2JOSW5aSWw2Q0gySEJpa3JNTi9BZFQyN0o2?=
 =?utf-7?B?UllPSVlndkxzWEN2YXB5OVkzdnRCbkhyR1pialkveWdLTTJYUk4vdkEyOTh2?=
 =?utf-7?B?U2R2OElpdTZHNFZTS013N3huOTIrLWlHaTAxbDNPY21nNldvazRDbW1YQmto?=
 =?utf-7?B?NTJIMWNJYUxybGlmL2VrZ0FVUE9OWXdhZ1BIWW9qMU4yOTc1ZnA0eGtKMlp0?=
 =?utf-7?B?Q1h1N01GY1dGT1pJRkpkbTdLdFJYYWRodTBPczlNRWNSZ2VSZW4rLWVLQkdQ?=
 =?utf-7?B?a25mMmJvZzM5MXZFc3UvWVVpbHJPRHhEaTlMWkN6SlZ6UlZFQjNtVCstUVhN?=
 =?utf-7?B?R2ozUEVvVDVFTzdHWnIvcURBMlFKUGJ3VDBmVGsyaWdMbWQ5d0lXakJkWEs=?=
 =?utf-7?B?Ky1JQWI5dmNsdzRVWExuaGJkdGdidXp4MnlURjBGNWhpKy0xNTJNR043U0Fm?=
 =?utf-7?B?ZnA1RVVRaEtWcWFTSWl6WjdzWEsvdXcwSlhDTXM1UHQzajN2ZFFxMlZ2MTZD?=
 =?utf-7?B?Z1l4djFFRnJRdzFIejdyejZPL3VUMFVqNXRqdDRiKy0rLXczeFVGdTlMd0tp?=
 =?utf-7?B?Z0ZiRFlKZi9pSUloNnNzUFhrVWtrd3N0ZWRrWUlPbXZSaG5vRlFBZzg1eXFZ?=
 =?utf-7?B?QmF3NkptL2JaN3M1dS9KNHhyTjh3cCstSFkvKy1LeWRGRWVlV3ZCRmhSWmNl?=
 =?utf-7?B?bXZtT003Ky05OElKcEhTejVXOUFrWm03YzgzdXZDdGlSNXJVRnROMnZzYTlE?=
 =?utf-7?B?QmNZS1gxbGNONTJ1WjJrV0hZKy13S2dGM0FNc3AvKy01Smx0cW9RMHJaeVF5?=
 =?utf-7?B?VnNmQ3RFaGNVZDJEcTMrLVQzMlFBNTFCQXhXU2t1UmFGTGVDTGhnelNzdHVo?=
 =?utf-7?B?L1NDTVdEMmdVYU9oTG9jM3ZZdWVETjNoRTIvbllCMktPWWh1SlZUSW1LZElx?=
 =?utf-7?B?NVFpUmRlaVQ3Tnh3dnErLTNYdUg2elV4ZVZ1M2tmeFJsWVpSbFBHUTJRcmNL?=
 =?utf-7?B?NzNRYysteS96UE9FN01LNFJqTistUTRydU9paHJKSTE2bWZmaXkvRGQvenZK?=
 =?utf-7?B?bGNraWxnVGNnUVEzeUdKM1p6VE9zTistQkpqRnZ2bWg5VXR0bzdPdmMzbEtx?=
 =?utf-7?B?VCstNU9GOEcvOVd5OWcwZlNWcVdFTHV3UjdLWExSSnlrVi9hWmRKeEIxUWl1?=
 =?utf-7?B?U3RxUTJ6R2tVSG5sT21EY0I3bXVIeVl2T0hLZ0lQZ3pwTkZnaldhZ3FxdlNq?=
 =?utf-7?B?eDNtZnM1OWVFZFhhWjYzTzRqcmFxN013cmdmVHFtbEJ4ejU4MHBKekVyY3cv?=
 =?utf-7?B?SldGQ0ZJTVFGakFzQ0hPekRHTzlRQXREVy94VTNOci81azZuY1VwUk12Njgw?=
 =?utf-7?B?bmZWNXArLTBTT2xaTVkwSU81Y1hadzc=?=
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62f40d60-3a35-4ad9-53b1-08de538ebf4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2026 17:02:49.2861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XWDLLTSUF+O3szqby7Ft9hSe82Wc2HR6OfUZp4+cj2Q5VrvWBf1m8Q/tOYIcMqvNLduSBFVVHverdddTPyqT0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6932
X-Outbound-SMTP-Client: 173.37.147.253, alln-opgw-5.cisco.com
X-Outbound-Node: rcdn-l-core-06.cisco.com


Cisco Confidential
On Friday, November 7, 2025 2:23 PM, Karan Tilak Kumar (kartilak) wrote:
+AD4-
+AD4- On Friday, November 7, 2025 12:29 AM, Hannes Reinecke +ADw-hare+AEA-s=
use.de+AD4- wrote:
+AD4- +AD4-
+AD4- +AD4- On 11/6/25 23:09, Karan Tilak Kumar (kartilak) wrote:
+AD4- +AD4- +AD4-
+AD4- +AD4- +AD4- Cisco Confidential
+AD4- +AD4- +AD4- On Tuesday, November 4, 2025 2:04 AM, Hannes Reinecke +AD=
w-hare+AEA-kernel.org+AD4- wrote:
+AD4- +AD4- +AD4APg-
+AD4- +AD4- +AD4APg- In some environments (eg kdump) not all CPUs are onlin=
e, so the MQ
+AD4- +AD4- +AD4APg- mapping might be resulting in an invalid layout. So ma=
ke the interrupt
+AD4- +AD4- +AD4APg- mode settable via an 'fnic+AF8-intr+AF8-mode' module p=
arameter and switch
+AD4- +AD4- +AD4APg- to INTx if the 'reset+AF8-devices' kernel parameter is=
 specified.
+AD4- +AD4- +AD4APg-
+AD4- +AD4- +AD4APg- Signed-off-by: Hannes Reinecke +ADw-hare+AEA-kernel.or=
g+AD4-
+AD4- +AD4- +AD4APg- ---
+AD4- +AD4- +AD4APg- drivers/scsi/fnic/fnic.h      +AHw-  2 +--
+AD4- +AD4- +AD4APg- drivers/scsi/fnic/fnic+AF8-isr.c  +AHw- 13 +-+-+-+-+-+=
-+-+-+-----
+AD4- +AD4- +AD4APg- drivers/scsi/fnic/fnic+AF8-main.c +AHw- 10 +-+-+-+-+-+=
-+-+-+--
+AD4- +AD4- +AD4APg- 3 files changed, 19 insertions(+-), 6 deletions(-)
+AD4- +AD4- +AD4APg-
+AD4- +AD4- +AD4APg- diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/f=
nic/fnic.h
+AD4- +AD4- +AD4APg- index 1199d701c3f5..c679283955e9 100644
+AD4- +AD4- +AD4APg- --- a/drivers/scsi/fnic/fnic.h
+AD4- +AD4- +AD4APg- +-+-+- b/drivers/scsi/fnic/fnic.h
+AD4- +AD4- +AD4APg- +AEAAQA- -484,7 +-484,7 +AEAAQA- extern struct workque=
ue+AF8-struct +ACo-fnic+AF8-fip+AF8-queue+ADs-
+AD4- +AD4- +AD4APg- extern const struct attribute+AF8-group +ACo-fnic+AF8-=
host+AF8-groups+AFsAXQA7-
+AD4- +AD4- +AD4APg-
+AD4- +AD4- +AD4APg- void fnic+AF8-clear+AF8-intr+AF8-mode(struct fnic +ACo=
-fnic)+ADs-
+AD4- +AD4- +AD4APg- -int fnic+AF8-set+AF8-intr+AF8-mode(struct fnic +ACo-f=
nic)+ADs-
+AD4- +AD4- +AD4APg- +-int fnic+AF8-set+AF8-intr+AF8-mode(struct fnic +ACo-=
fnic, unsigned int mode)+ADs-
+AD4- +AD4- +AD4APg- int fnic+AF8-set+AF8-intr+AF8-mode+AF8-msix(struct fni=
c +ACo-fnic)+ADs-
+AD4- +AD4- +AD4APg- void fnic+AF8-free+AF8-intr(struct fnic +ACo-fnic)+ADs=
-
+AD4- +AD4- +AD4APg- int fnic+AF8-request+AF8-intr(struct fnic +ACo-fnic)+A=
Ds-
+AD4- +AD4- +AD4APg- diff --git a/drivers/scsi/fnic/fnic+AF8-isr.c b/driver=
s/scsi/fnic/fnic+AF8-isr.c
+AD4- +AD4- +AD4APg- index e16b76d537e8..b6594ad064ca 100644
+AD4- +AD4- +AD4APg- --- a/drivers/scsi/fnic/fnic+AF8-isr.c
+AD4- +AD4- +AD4APg- +-+-+- b/drivers/scsi/fnic/fnic+AF8-isr.c
+AD4- +AD4- +AD4APg- +AEAAQA- -319,20 +-319,25 +AEAAQA- int fnic+AF8-set+AF=
8-intr+AF8-mode+AF8-msix(struct fnic +ACo-fnic)
+AD4- +AD4- +AD4APg- return 1+ADs-
+AD4- +AD4- +AD4APg- +AH0-
+AD4- +AD4- +AD4APg-
+AD4- +AD4- +AD4APg- -int fnic+AF8-set+AF8-intr+AF8-mode(struct fnic +ACo-f=
nic)
+AD4- +AD4- +AD4APg- +-int fnic+AF8-set+AF8-intr+AF8-mode(struct fnic +ACo-=
fnic, unsigned int intr+AF8-mode)
+AD4- +AD4- +AD4APg- +AHs-
+AD4- +AD4- +AD4APg- int ret+AF8-status +AD0- 0+ADs-
+AD4- +AD4- +AD4APg-
+AD4- +AD4- +AD4APg- /+ACo-
+AD4- +AD4- +AD4APg- +ACo- Set interrupt mode (INTx, MSI, MSI-X) depending
+AD4- +AD4- +AD4APg- +ACo- system capabilities.
+AD4- +AD4- +AD4APg- -      +ACo-
+AD4- +AD4- +AD4APg- +-      +ACo-/
+AD4- +AD4- +AD4APg- +-     if (intr+AF8-mode +ACEAPQ- VNIC+AF8-DEV+AF8-INT=
R+AF8-MODE+AF8-MSIX)
+AD4- +AD4- +AD4APg- +-             goto try+AF8-msi+ADs-
+AD4- +AD4- +AD4APg- +-     /+ACo-
+AD4- +AD4- +AD4APg- +ACo- Try MSI-X first
+AD4- +AD4- +AD4APg- +ACo-/
+AD4- +AD4- +AD4APg- ret+AF8-status +AD0- fnic+AF8-set+AF8-intr+AF8-mode+AF=
8-msix(fnic)+ADs-
+AD4- +AD4- +AD4APg- if (ret+AF8-status +AD0APQ- 0)
+AD4- +AD4- +AD4APg- return ret+AF8-status+ADs-
+AD4- +AD4- +AD4APg- -
+AD4- +AD4- +AD4APg- +-try+AF8-msi:
+AD4- +AD4- +AD4APg- +-     if (intr+AF8-mode +ACEAPQ- VNIC+AF8-DEV+AF8-INT=
R+AF8-MODE+AF8-MSI)
+AD4- +AD4- +AD4APg- +-             goto try+AF8-intx+ADs-
+AD4- +AD4- +AD4APg- /+ACo-
+AD4- +AD4- +AD4APg- +ACo- Next try MSI
+AD4- +AD4- +AD4APg- +ACo- We need 1 RQ, 1 WQ, 1 WQ+AF8-COPY, 3 CQs, and 1 =
INTR
+AD4- +AD4- +AD4APg- +AEAAQA- -358,7 +-363,7 +AEAAQA- int fnic+AF8-set+AF8-=
intr+AF8-mode(struct fnic +ACo-fnic)
+AD4- +AD4- +AD4APg-
+AD4- +AD4- +AD4APg- return 0+ADs-
+AD4- +AD4- +AD4APg- +AH0-
+AD4- +AD4- +AD4APg- -
+AD4- +AD4- +AD4APg- +-try+AF8-intx:
+AD4- +AD4- +AD4APg- /+ACo-
+AD4- +AD4- +AD4APg- +ACo- Next try INTx
+AD4- +AD4- +AD4APg- +ACo- We need 1 RQ, 1 WQ, 1 WQ+AF8-COPY, 3 CQs, and 3 =
INTRs
+AD4- +AD4- +AD4APg- diff --git a/drivers/scsi/fnic/fnic+AF8-main.c b/drive=
rs/scsi/fnic/fnic+AF8-main.c
+AD4- +AD4- +AD4APg- index 870b265be41a..4bdd55958f59 100644
+AD4- +AD4- +AD4APg- --- a/drivers/scsi/fnic/fnic+AF8-main.c
+AD4- +AD4- +AD4APg- +-+-+- b/drivers/scsi/fnic/fnic+AF8-main.c
+AD4- +AD4- +AD4APg- +AEAAQA- -97,6 +-97,10 +AEAAQA- module+AF8-param(pc+AF=
8-rscn+AF8-handling+AF8-feature+AF8-flag, uint, 0644)+ADs-
+AD4- +AD4- +AD4APg- MODULE+AF8-PARM+AF8-DESC(pc+AF8-rscn+AF8-handling+AF8-=
feature+AF8-flag,
+AD4- +AD4- +AD4APg- +ACI-PCRSCN handling (0 for none. 1 to handle PCRSCN (=
default))+ACI-)+ADs-
+AD4- +AD4- +AD4APg-
+AD4- +AD4- +AD4APg- +-static unsigned int fnic+AF8-intr+AF8-mode +AD0- VNI=
C+AF8-DEV+AF8-INTR+AF8-MODE+AF8-MSIX+ADs-
+AD4- +AD4- +AD4APg- +-module+AF8-param(fnic+AF8-intr+AF8-mode, uint, S+AF8=
-IRUGO +AHw- S+AF8-IWUSR)+ADs-
+AD4- +AD4- +AD4APg- +-MODULE+AF8-PARM+AF8-DESC(fnic+AF8-intr+AF8-mode, +AC=
I-Interrupt mode, 1 +AD0- INTx, 2 +AD0- MSI, 3 +AD0- MSIx (default: 3)+ACI-=
)+ADs-
+AD4- +AD4- +AD4-
+AD4- +AD4- +AD4- Based on fnic team's review: there is a way to choose the=
 interrupt mode using the UCS management platform.
+AD4- +AD4- +AD4- We do not want to expose this as a module parameter.
+AD4- +AD4- +AD4-
+AD4- +AD4- Yeah, I know. It was primarily used during testing to easily ch=
ange
+AD4- +AD4- between the various modes.
+AD4- +AD4- I can drop it for the next round.
+AD4-
+AD4- Thanks Hannes. Sounds good.
+AD4-
+AD4- +AD4- +AD4APg- struct workqueue+AF8-struct +ACo-reset+AF8-fnic+AF8-wo=
rk+AF8-queue+ADs-
+AD4- +AD4- +AD4APg- struct workqueue+AF8-struct +ACo-fnic+AF8-fip+AF8-queu=
e+ADs-
+AD4- +AD4- +AD4APg-
+AD4- +AD4- +AD4APg- +AEAAQA- -869,7 +-873,11 +AEAAQA- static int fnic+AF8-=
probe(struct pci+AF8-dev +ACo-pdev, const struct pci+AF8-device+AF8-id +ACo=
-ent)
+AD4- +AD4- +AD4APg-
+AD4- +AD4- +AD4APg- fnic+AF8-get+AF8-res+AF8-counts(fnic)+ADs-
+AD4- +AD4- +AD4APg-
+AD4- +AD4- +AD4APg- -     err +AD0- fnic+AF8-set+AF8-intr+AF8-mode(fnic)+A=
Ds-
+AD4- +AD4- +AD4APg- +-     /+ACo- Override interrupt selection during kdum=
p +ACo-/
+AD4- +AD4- +AD4APg- +-     if (reset+AF8-devices)
+AD4- +AD4- +AD4APg- +-             fnic+AF8-intr+AF8-mode +AD0- VNIC+AF8-D=
EV+AF8-INTR+AF8-MODE+AF8-INTX+ADs-
+AD4- +AD4- +AD4APg- +-
+AD4- +AD4- +AD4APg- +-     err +AD0- fnic+AF8-set+AF8-intr+AF8-mode(fnic, =
fnic+AF8-intr+AF8-mode)+ADs-
+AD4- +AD4- +AD4APg- if (err) +AHs-
+AD4- +AD4- +AD4APg- dev+AF8-err(+ACY-fnic-+AD4-pdev-+AD4-dev, +ACI-Failed =
to set intr mode, +ACI-
+AD4- +AD4- +AD4APg- +ACI-aborting.+AFw-n+ACI-)+ADs-
+AD4- +AD4- +AD4APg- --
+AD4- +AD4- +AD4APg- 2.43.0
+AD4- +AD4- +AD4APg-
+AD4- +AD4- +AD4APg-
+AD4- +AD4- +AD4-
+AD4- +AD4- +AD4- Thanks for these changes, Hannes.
+AD4- +AD4- +AD4- For the other changes in this patch, I will need to test =
and get back to you.
+AD4- +AD4- +AD4-
+AD4- +AD4-
+AD4- +AD4- Thanks.
+AD4- +AD4- The 'reset+AF8-devices' thing is primarily there for kdump+ADs-=
 might be an idea
+AD4- +AD4- to make is explicit by using 'is+AF8-kdump+AF8-kernel()' direct=
ly.
+AD4-
+AD4- Yes Hannes. That would be better. Thanks.
+AD4-
+AD4- +AD4- Cheers,
+AD4- +AD4-
+AD4- +AD4- Hannes
+AD4- +AD4-
+AD4- +AD4- --
+AD4- +AD4- Dr. Hannes Reinecke                  Kernel Storage Architect
+AD4- +AD4- hare+AEA-suse.de                                +-49 911 74053 =
688
+AD4- +AD4- SUSE Software Solutions GmbH, Frankenstr. 146, 90461 N+APw-rnbe=
rg
+AD4- +AD4- HRB 36809 (AG N+APw-rnberg), GF: I. Totev, A. McDonald, W. Knob=
lich
+AD4- +AD4-
+AD4-
+AD4- I'm bringing up a setup to test. I'll wait for your next revision.
+AD4-
+AD4- My plan is to induce a kdump to test out these changes.
+AD4- If you have any other tests in mind, please let me know.
+AD4-
+AD4- Thanks,
+AD4- Karan
+AD4-

Hi Hannes,

Please consider sending out a new revision of these changes.
I'd like to test all the changes and add a tested-by tag to them.

Thanks,
Karan
