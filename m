Received: from alln-iport-6.cisco.com (alln-iport-6.cisco.com [173.37.142.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F49637FF6A
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 20:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781642383; cv=fail; b=eJ7wH02+tO3tgUa6KmKmKpnpb7dRPBW97T+/+Vj7i0KhCpzHgwooECIkfrNoO8iTjV4cGaGYYNeVUR+W+zw2/7mxYFr2ukHLMH08R1oJHflj5cvdGnq793UafSyKAa4jYaDJAxq3R9B0iwj3PJ3uI2P4k9ekcY0wqQL1x7Stp3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781642383; c=relaxed/simple;
	bh=5v4KnlY+vl9h5gZJQOGseVgY24Jm92Da/hYK8eU+hMo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SwyeI8Gy+8P65CfNTSN9i7snXqjMqutUYVYq5ni5xc67MitBoUzmzWvW6DGqKQfCZjFaNMjPE1NcxG2XJO6Y9ywfpV0x9t+UfS2dlYy1VmSybQzQkv1MGQfZQuWrEDcX//2QrEdTJbUk6fH/wAFuUC6VA6mh8NSnTto1zvzJmxA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=HrtqybdX; arc=fail smtp.client-ip=173.37.142.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="HrtqybdX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=7966; q=dns/txt;
  s=iport01; t=1781642382; x=1782851982;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5v4KnlY+vl9h5gZJQOGseVgY24Jm92Da/hYK8eU+hMo=;
  b=HrtqybdXSpcFQdspTIJvnbJys9koJs6ueZV5a6wuZkKsz3Ip7fCLOG0N
   us0Ma/cQa51T6DBWlupb4/+rQs3NS2m3bBmcnE4k0uiNPOKb4ilJuqhhg
   XZuSJzMNv6aKBKPPDlghUJ3ybVc4Kaywcz1MZkt/LR7i+EI4gqXI2FIpx
   o5G6a0z2qdznGsQfbYET1Hv0DgZ/yIwE6BiNkMu1FjCsuA8Fw0dpxapXE
   eD8ksvlTnx9Rx/FboyxevhRGPV0hfOsVBoFouexI+kT2yLdj6d3yOa5DQ
   g7C+u26O+5pu3lTHoTeItO6xkrS7IFNrEaUVkSkgoepCTLMMcgTTZ/QN4
   A==;
X-CSE-ConnectionGUID: WrC36hKhQ3ShfvYf5gd5/g==
X-CSE-MsgGUID: DLOj6X+pQAG5OW8UZOfFIg==
X-IPAS-Result: =?us-ascii?q?A0CSAwB1szFq/40QJK1agS6BK4FuU4EKgSFJhFeDTAOFL?=
 =?us-ascii?q?Ih5A54bgX4PAQEBDQJRBAEBhQYCFo0rAiY0CQ4BAgQDAgMBAQEBAQEBAQEBA?=
 =?us-ascii?q?QsBAQUBAQECAQcFgQ4ThlAMhloBAQEBAxIRBA08CRACAQgYAgImAgICLxUQA?=
 =?us-ascii?q?gQKBAUIGoJhgnMDAQKmJAGBPQKKKnp/M4EB4C8GFAGBCi6IWwGBcIQGOIREJ?=
 =?us-ascii?q?xuCDYEUAUKCaT6ERRWDRDqCMASCIoEMgXKCQYFjiwUJSXgcA1ksAVUTFwsHB?=
 =?us-ascii?q?WFCQwMqLy0jSwUtHYEjIR0XFh5YGwcFEiAqQkUjAwJCNAQhPzgLQwWBXQKCE?=
 =?us-ascii?q?U4jHwM5f4FvgSVnZhUwNYEBAREfCnoDC209NxQbAwQ6ewWMaRcPgUU1IzaBD?=
 =?us-ascii?q?BggNAlRH0YsO5JpQIM1r1kKhB2iEReEBI16mG6ISJBAI4I2oRMehQ0CBAIEB?=
 =?us-ascii?q?QIQAQEGgWg8gVlwFTuCZ1MZD44tFswdeT0CBwIHDgMLkWgEgXkBAQ?=
IronPort-PHdr: A9a23:El+R3hL+KVR46t6sVdmcuVQyDhhOgF28FgcR7pxijKpBbeH+uZ/jJ
 0fYo/5qiQyBUYba7qdcgvHN++D7WGMG6Iqcqn1KbpFWVhEEhMlX1wwtCcKIEwv6edbhbjcxG
 4JJU1oNwg==
IronPort-Data: A9a23:eQdTQ6oVACmw1TJx3Hz4ZmK4UpdeBmJSZBIvgKrLsJaIsI4StFCzt
 garIBnXa/3YZTCjeYtyPImz/UgOvp/RzoBrTgNtpH89FChD+OPIVI+TRqvS04x+DSFioGZPt
 Zh2hgzodZhsJpPkjk7zdOCn9j8kif3gqoPUUIbsIjp2SRJvVBAvgBdin/9RqoNziLBVOSvV0
 T/Ji5OZYgPNNwJcaDpOtfrd8U0355wehRtB1rAATaET1LPhvyF94KI3fcmZM3b+S49IKe+2L
 86r5K255G7Q4yA2AdqjlLvhGmVSKlIFFVHT4pb+c/HKbilq/kTe4I5iXBYvQRs/ZwGyojxE4
 I4lWapc5useFvakdOw1C3G0GszlVEFM0OevzXOX6aR/w6BaGpfh660GMa04AWEX0tltKjoQ9
 d8YEWs2bh6dtuzrz77mDeY506zPLOGzVG8eknhkyTecCbMtRorOBv2Wo9RZxzw3wMtJGJ4yZ
 eJANmEpN0qGOkMJYwtOYH49tL/Aan3XcDRCtFORrKkf6GnIxws327/oWDbQUoPUH5gIzxjH+
 woq+UzVJjYYauzc0QOs3S+Lub/yrwT1dqMdQejQGvlCxQf7KnYoIBkXU0ar5OKykU+WRd1SM
 QoX9zAooKx081akJuQRRDWxpHqC+xpZUN1KHqhitEeGy7Hf5ECSAW1soiN9VeHKffQeHFQC/
 lSIhNjuQzdotdWopbi1r994cRva1fApEFI/
IronPort-HdrOrdr: A9a23:bHS+nqNwu+hE/sBcT87255DYdb4zR+YMi2TDiHoBKiC9I/b5qy
 nxppUmPEfP+UgssREb9expOMG7MBXhHO1OkPgs1NCZLUbbUQqTXc1fBOTZskfd8kHFh4pgPO
 JbAtdD4b7LfBZHZKTBkXSF+r8bqbHtntHL9ILjJjVWPH1Xgspbnn5E43OgYzZLrX59dOIE/f
 Snl616jgvlU046Ku68AX4IVfXCodrkqLLKCCRtOzcXrCO1oXeN8rDVLzi0ty1ybxp/hZsy+2
 nMlAL0op6kr+y6zRHk0WrS5YR9mdfqyNdPbfb8y/T9LA+Cti+YIKBaH5GStjE8p++irHwwls
 PXnhsmN8Nvr1vMY2Ccu3LWqkrd+Qdrz0Wn5U6TgHPlr8C8bik9EdB9iYVQdQacw1Y8vet7zL
 lA0wuixthq5FL77WHADurzJlZXf3mP0DwfeCko/iViuL4lGftsREokjRto+dk7bXnHAcscYZ
 lT5YnnlYVrmBWhHjDkl1gq5sCwVXIuGRrDaE0DtsuJlwVyphlCvhElLAh1pAZdyHr7IKM0ut
 jsI+BmkqpDQdQRar84DOAdQdGvAmiIWh7UNnmOSG6XX53vFki94qIf2o9FrN2CadgN1t8/iZ
 7BWFRXuSo7fF/vE9SH2NlO/grWSGuwUDzxwoUGjqIJ94HUVf7uK2mOWVoum8yvr7EWBdDaQe
 +6PNZTD+X4JWXjFI5V10n1WoVUK3MZTMoJ0+xLEW6ms4bOMMnnp+bbePHcKP7kFislQHr2Bj
 8ZUD36NKx7nzaWs7/D8W/ssl/WCzjCFMhLYdrnFsAouf0wCrE=
X-Talos-CUID: 9a23:rimr32A54Dcxdor6ExZ93xVKGuMlSybmzHnOEkHlBmo0D7LAHA==
X-Talos-MUID: 9a23:yt44XggJcMiFkxo26qd91cMpGONP4fqeS1g0uLpbnPbUCB5XNRm8g2Hi
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-04.cisco.com ([173.36.16.141])
  by alln-iport-6.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 16 Jun 2026 20:39:41 +0000
Received: from alln-opgw-5.cisco.com (alln-opgw-5.cisco.com [173.37.147.253])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-04.cisco.com (Postfix) with ESMTPS id 332AD18000186
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 20:39:41 +0000 (GMT)
X-CSE-ConnectionGUID: bItK6YaUQciYjI3WypFrZg==
X-CSE-MsgGUID: IXGKPuPATpazOeR/jVpcSw==
Authentication-Results: alln-opgw-5.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.24,208,1774310400"; 
   d="scan'208";a="57707231"
Received: from mail-westusazon11012033.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([52.101.43.33])
  by alln-opgw-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 16 Jun 2026 20:39:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e6QvgueT19Vu50O9Ii0FWfh3JxN1US3KDVIphKn5kg70bsQCql1F7A5oCnBUCOUaFGLv5QHpuLcLIEjIMMjsM99AjP9MuA4fq4a0imW6tskIh5Id5yQamvMwHzqqRxpton/mTeXVz9TB/HTAau33ptR1S9Mqh6htgwIlLNLM3aAhC8BT+ggcVO65SHe6Bk7Vau1OGkuHCCEEtTKGI0jJtFBEszzNN8qktKMGVST8Ft5SY3bhsqCSvtfOWpgQvRHtzCBeu8Nznaa7ZRiqmr7Z4xRd3iQOs/B5hP6QEaAnq63m2S7l+0ZqsofsqWxfD6td4NzYFNEweS9tZhZQqzWLaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5v4KnlY+vl9h5gZJQOGseVgY24Jm92Da/hYK8eU+hMo=;
 b=qj0FczpYgmsl/Wn8IKhL1HiQZnLA4SnpBJSW4Kn9e1wcRMCyZAlbxR5aHJaG5l7AEUuDTFFahcVvWturFy7HoHM1rXygCVwQt/8hiHpN4BA1+baU5EJDDugJHk7x58ILrmA45uTxOLhDldevLD+BhVwvocbEBCjhd2D0LZrih+JRphtvW1DABc0LKTUDc8k/DtFrroeh1IXqqIOQU6uQJfHv9p/Yx5tC6M2oAHb8XAVjH/Yaq7Pka7h1fVcQ28ZI8Wia+FPZWmQAnAKNJKRnGyUPSkX9MuqyAqWwDLqwnntdKo+3yxZXwCydTcMUdvxZQpn/GqXuML61w8knrEYMmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by PH0PR11MB5128.namprd11.prod.outlook.com (2603:10b6:510:39::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Tue, 16 Jun
 2026 20:39:39 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db%3]) with mapi id 15.21.0113.015; Tue, 16 Jun 2026
 20:39:38 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH v4 11/13] scsi: fnic: Track NVMe transport statistics
Thread-Topic: [PATCH v4 11/13] scsi: fnic: Track NVMe transport statistics
Thread-Index: AQHc+peL9IgZjxMF/ECeU5pmYwnRC7Y7jbOAgAYc9pA=
Date: Tue, 16 Jun 2026 20:39:38 +0000
Message-ID:
 <SJ0PR11MB5896A0ED80B7944E816CBF8AC3E52@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20260612180918.8554-12-kartilak@cisco.com>
 <20260612231606.1976E1F000E9@smtp.kernel.org>
In-Reply-To: <20260612231606.1976E1F000E9@smtp.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|PH0PR11MB5128:EE_
x-ms-office365-filtering-correlation-id: 65d46e21-48d5-4773-8477-08decbe762d6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|38070700021|6133799003|22082099003|18002099003|4143699003|11063799006|3023799007|56012099006;
x-microsoft-antispam-message-info:
 ykb+ACIwHiTcLNiyaEh2voAa/Wp3aJsmIFNwp5muFpQ888OIJCP5KSP3akTmkjF+Shxf+dnbCkKWx13y61Q54HPC9doSL515JzZvJiq1KZTq5IH5yPikDs35ZKk3lp30sIM7lCMZBvR8bN48yVfCXdPI/Kv/4bxryYhR725XCggMOOXrAj2CWmDioCOm0UGfUn3l8iTWWaIZAWIrEiGgxuoPLYrd+KigWRzD+moaO/xTru8BlnBRCJi+zBh94gIqs6rDhKg2fHbvjxtY80z0i2zDv3xpXd0To63f0EScCvgl/9NsLrJqye4eTAg+zzOzpel6U7f8wf3Y9+XS4XAjLU0Ki0LDmg1Jnvt1kntZ7W8fRqFjjnPo8T5odxMPFQ6/qk0thhe2vjj/DjuMq6ap4XsWJ2w5h3FwCYOWxP0uxn+xkeaQDuqykRv8sR9Pqn++Jf3mfMe5rHafS2etllVkPPP17icElcGNdYYHjH6efRnfyYko5TtElSPPKMlQLbjxaeLeEL9Lq1Huy64LpgtXu3Q3mCRdpfqG54A9BbvUBk0YNhCIdfmwZnWciSITMe6S2moxfxSSiefHHmGB8nKFt9whk2F0OTwz8GwEpZ6nujTG9IbPEvhga7alErKgZtpMFZgANEsnwO4cSVI5S1qMwDSaJ9S2vkuYDJCMM72G2wXSJM5II2b0reLTkN+NGue3
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(38070700021)(6133799003)(22082099003)(18002099003)(4143699003)(11063799006)(3023799007)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?L1pKQ0JrVis3Nnl3VWVqb2NPR0tFTEIwZzZvRDJUTVFFdmc4M1lQS3ROWm40?=
 =?utf-8?B?UVB4RWszczBFSmpRS1E2NlphL0E1QUphZFdNWklCTy9sUjlwZk9hMjVVYjhU?=
 =?utf-8?B?VENBaERmcG9YbE1pREFQYldGRnhxQkJPeDl6UXE5L0hORVpKaUZmdmo5Z1I4?=
 =?utf-8?B?emhQQnRzYmpFUHpPbG9ldFBXU3g3Si9SS1VnTFZpMjhKKzVQa1F0Wk9icVBZ?=
 =?utf-8?B?S3pvMTl4T2tZZWNMSHBScE5CZkZVSWliOGNRelJUZTFGWUNaQnI1ai9zSEll?=
 =?utf-8?B?a1I2UHhhVUlLTDZ4YlhYNk9OOTV5UXBKSURIUDlJUW9hYTZTcDBDQUZPdFlK?=
 =?utf-8?B?Ui9aaG4rNDBIYXBWdWNvekMySkd2YmlNdnBmTytaWHJHTGJNMndsSm5yTHVW?=
 =?utf-8?B?cmMvZVU4UHhEdk1jMFBxcm9VRjBya3RQaVN4UzhxV3kyN0NMRG1vQzlnemxY?=
 =?utf-8?B?QXQ4emdhNzJ5Y2RzWVJWNVlxL0dXbTFmREpnaUV2b1ZoYm9RUUlQNHJyMmpC?=
 =?utf-8?B?bDBuenI2eElyYThMUUw0WXN6QnFyaFl4TjRPdXNIS1ROT1AvQldZRStOdm9z?=
 =?utf-8?B?cGxVQ0d2cFNZYUFIYkNwYnNsZW03V2pXWWpiK3ZsckNHbkpSTXFUTWZSVzdV?=
 =?utf-8?B?MWxzaXZmOVV2OUtab25vZW4xR1J2ZExlMjhXOGY0bTdIWDZKUUM0Q1gvakRD?=
 =?utf-8?B?NjdZbTlLQzFwckNDL0xYbkNmV3JDOFFUZUZIMkVMQUhiTituQ0JaU3RtbFJz?=
 =?utf-8?B?aGRVUU5obVlCTzJ2dGR3YUFENWhSbExubW9adXduYldwM01BajV1U2xYV1VZ?=
 =?utf-8?B?M2c5aWZHUkl6eXJUQ05tcmpOWTk5UUFKRW5jd0Q0TWdIc1RIZGtTeks5Z1dH?=
 =?utf-8?B?S1BBT2RYem5USEZQRWkyWlBEbXJNQnFjQzAreVBtNklXTzU3emdFNE41QnJ4?=
 =?utf-8?B?TWc3MVAzOCtJTDBPczZaN0JsUjd6bk5mdmVwVWhoSEF5UHI1MUtoRGdlNnl5?=
 =?utf-8?B?NG1yQzhRZlN5ZitNeHIzalMrTWE2YXFIdGJhWmg1MEkrNTJpWjBjSHdIdE84?=
 =?utf-8?B?QXc5WVpxOG1YVVRWdDVDbDFBS00wazlZVjEwdkoyTkNhV0ZSdXhUenlGaS9y?=
 =?utf-8?B?YmpnR2NUVVlZeG5VWkN6UVVvMnNvQnBDVVBEdEV1WnFjMjd0elRXVzNvU1dv?=
 =?utf-8?B?bXJjbDVUdDcxQktObXlrVHdvdGNaZ1lZQ3c4MzlWTGk1L3FQUDM4RmxFOFRS?=
 =?utf-8?B?K014N3FiNjRhYzJjQjlmVVFpY01RRHNPRG5SVUErL0h2T1VRNU1uUCtrQytj?=
 =?utf-8?B?Q3VUWVhTRE9iNEtOa0xxcXhlYnZWdWRhVHBGRnB5WGpXTFFWNkxCL25XbXFj?=
 =?utf-8?B?ZloyZ1A4QjNaOWtUZ05WM0hJZHlpTGwrdVNZUU1oR2lyT0NnNlJKcm9NN3VU?=
 =?utf-8?B?cGYzQUVjMlJJRTVxcVRXUk1EMXk5Wk81UTBYQ1NIcHkzcWxMOUd1bEtad2FG?=
 =?utf-8?B?NUlIbWl4cTNZWjlRM212UkRCQ01yRHVZbW11R2dWRGh1TncyeTY5WUVVSkE4?=
 =?utf-8?B?eGNhVlBTTFBlVlkzeTNsNFlQOXN3Q0EvaFp5YnJHaUdRR0VRdEM3Wlk3RFpS?=
 =?utf-8?B?Q0w3ZUU1c1dKNXovamZnUTQxMVQzeEc5T1dETmlxaXJkQzdYSk5HYkVORFVw?=
 =?utf-8?B?WkhmSlF2UkRDcDFMc2cxMERSUGhDWTNkZHQ0S0VzNk53aXRYdVE3Sy9GUDdJ?=
 =?utf-8?B?eExqN3ZIRjdNalV6cUhXbXFFcmFpVGV4MUc1WUpiVzB2SGo3MllqNlZkNy8w?=
 =?utf-8?B?VnpudXU0OUd6TTFFRkhKcmFZMnhyYzJyK3NtQXdlcWhzb3U0SzVNeGlNMmh5?=
 =?utf-8?B?QmlxOGZxTHJHM3NpRzdCMGFnL1N2UnpWeXVPYS9kaW5wV3lleC9IMFNyT0V2?=
 =?utf-8?B?eWhvRWI2UzdnOHBWYlBHVVdMNUFvMHhzdU0wOEczajhORDB1Y3d5WTVtNS82?=
 =?utf-8?B?S01ZWk9lM2lTTnc0TkMvN3FRN3BjMVNEZGZlb2JvQkMyb2tlSjRUaWVKQ09x?=
 =?utf-8?B?Y3cwZGhYclI2MkRjYjdGS1pOL1dYN2lFRmp4Z3FnWEsvWjU5WmZQMFRLWnJJ?=
 =?utf-8?B?V1YrMmdPZ3FUV1RhallPZmVTS21wVmpvNWhGRllqaDliRHhESjVxNlZTdEdB?=
 =?utf-8?B?dGlqTDhtNG56WE5TQTZtV2hnY0lUU2c1TVlKSjlFK1ZGRStHTnJycVNsZmcv?=
 =?utf-8?B?d2J5K2IxYVBYV25Mak1MMWxjZEhabTlMUC93NWVvRkVpYk85dEFJRzhhb0Jr?=
 =?utf-8?Q?onrPX88Nltn5KDdRZ2?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	QcJI3XWkYlJALKRTuYjX3G85f8okVihpCDLa+wFNfkG66wHqqH2ejb8/NIwKX11CTT8PyTRKbKKyjwLK3EWt6OfueqqJNS1DhA0jReFrKiYhHVq/c5MjBENFFLbVyqKttLbLhBO+kjOpUJPYrZNzUJZle/mStwkgIGVJ+ucVXYzv4MS8OYk6cqopIs1Lpikm2l+34xj4diXFPpopRvO4PFQLlh3bBBOL3R4DVrGd/SprCgQpOWzTXwOguYUJiN8BFAAdvAbVkVfkUlZvYzCFSjkx7h9uP7Sjl0J8w0pJiwjNtSpG6XjA+o9pAJ7KIOnXLM4iPtrT9luNxVLeG9/5oQ==
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65d46e21-48d5-4773-8477-08decbe762d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2026 20:39:38.9030
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: olIItrevr5yuQWFsnQbojLWpWrTPF8Z7w13agtVSuLlIzCB9jo25tgUpmHoUCJBfVfFSIk7ohl72FWVAP2hGOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5128
X-Outbound-Client-TLS: ANONYMOUS;alln-opgw-5.cisco.com [173.37.147.253];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 173.37.147.253, alln-opgw-5.cisco.com
X-Outbound-Node: alln-l-core-04.cisco.com

T24gRnJpZGF5LCBKdW5lIDEyLCAyMDI2IDQ6MTYgUE0sIHNhc2hpa28tYm90QGtlcm5lbC5vcmcg
PHNhc2hpa28tYm90QGtlcm5lbC5vcmc+IHdyb3RlOg0KPg0KPiBUaGFuayB5b3UgZm9yIHlvdXIg
Y29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJldmlldyBmb3VuZCA0IHBvdGVudGlhbCBpc3N1ZShz
KSB0byBjb25zaWRlcjoNCj4gLSBbSGlnaF0gRGVhZGxvY2sgYmV0d2VlbiBmbmljX2xvY2sgYW5k
IHRpbWVyIGxvY2sgZHVyaW5nIE5WTWUgTFMgcmVzcG9uc2UuDQo+IC0gW0hpZ2hdIFVzZS1BZnRl
ci1GcmVlIG9mIGlvX3JlcSB3aGVuIHdyaXRpbmcgd2FpdHFfc3RhcnRfdGltZS4NCj4gLSBbSGln
aF0gTWVtb3J5IGFuZCBhY3RpdmVfaW9zIGxlYWsgd2hlbiBJVE1GIGFib3J0IGZhaWxzLg0KPiAt
IFtNZWRpdW1dIGFjdGl2ZV9md19yZXFzIGNvdW50ZXIgcGVybWFuZW50bHkgZHJpZnRzIHVwd2Fy
ZHMgb24gRVJTUCBjb21wbGV0aW9ucy4NCj4gLS0NCj4NCj4gY29tbWl0IGI2OGI0MGM2NmRlOGQz
NDdkYjdiZDkxYzllYTI0NTA2MDUxNzJlNzENCj4gQXV0aG9yOiBLYXJhbiBUaWxhayBLdW1hciA8
a2FydGlsYWtAY2lzY28uY29tPg0KPg0KPiBzY3NpOiBmbmljOiBUcmFjayBOVk1lIHRyYW5zcG9y
dCBzdGF0aXN0aWNzDQo+DQo+IEFkZCBjb3VudGVycyBmb3IgTlZNZSByZXF1ZXN0cywgcmVzcG9u
c2VzLCBMUyBoYW5kbGluZywgYWJvcnRzLCBhbmQNCj4gd2FpdC1xdWV1ZSBhY3Rpdml0eS4NCj4N
Cj4gVXBkYXRlIE5WTWUgSS9PLCBjb21wbGV0aW9uLCBMUyByZXNwb25zZSwgTFMgYWJvcnQsIGFu
ZCBhYm9ydCBwYXRocyB0bw0KPiBtYWludGFpbiB0aGUgbmV3IGNvdW50ZXJzLg0KPg0KPiA+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvZm5pYy9mbmljX252bWUuYyBiL2RyaXZlcnMvc2NzaS9m
bmljL2ZuaWNfbnZtZS5jDQo+ID4gaW5kZXggOWNjOGYwYmFmMDljYi4uMmNjYmZhMGRmYTkyZCAx
MDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Njc2kvZm5pYy9mbmljX252bWUuYw0KPiA+ICsrKyBi
L2RyaXZlcnMvc2NzaS9mbmljL2ZuaWNfbnZtZS5jDQo+DQo+IFsgLi4uIF0NCj4NCj4gPiBAQCAt
MTkzLDYgKzI1MCwxMSBAQCBpbmxpbmUgaW50IG52Zm5pY19xdWV1ZV93cV9udm1lX2NvcHlfZGVz
YyhzdHJ1Y3QgZm5pYyAqZm5pYywNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICB0cG9ydC0+bWF4X3BheWxvYWRfc2l6ZSwgdHBvcnQtPnJfYV90b3YsDQo+ID4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdHBvcnQtPmVfZF90b3YpOw0KPiA+DQo+ID4g
KyAgIGF0b21pYzY0X2luYygmZm5pYy0+Zm5pY19zdGF0cy5md19zdGF0cy5hY3RpdmVfZndfcmVx
cyk7DQo+ID4gKyAgIGlmIChhdG9taWM2NF9yZWFkKCZmbmljLT5mbmljX3N0YXRzLmZ3X3N0YXRz
LmFjdGl2ZV9md19yZXFzKSA+DQo+ID4gKyAgICAgICBhdG9taWM2NF9yZWFkKCZmbmljLT5mbmlj
X3N0YXRzLmZ3X3N0YXRzLm1heF9md19yZXFzKSkNCj4gPiArICAgICAgICAgICBhdG9taWM2NF9z
ZXQoJmZuaWMtPmZuaWNfc3RhdHMuZndfc3RhdHMubWF4X2Z3X3JlcXMsDQo+ID4gKyAgICAgICAg
ICAgICAgICBhdG9taWM2NF9yZWFkKCZmbmljLT5mbmljX3N0YXRzLmZ3X3N0YXRzLmFjdGl2ZV9m
d19yZXFzKSk7DQo+ID4NCj4gPiAgICAgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmZm5pYy0+d3Ff
Y29weV9sb2NrW2lkeF0sIGludHJfZmxhZ3MpOw0KPg0KPiBbU2V2ZXJpdHk6IE1lZGl1bV0NCj4g
U2luY2UgdGhpcyBmdW5jdGlvbiBpbmNyZW1lbnRzIGFjdGl2ZV9md19yZXFzIGZvciBOVk1lIHJl
cXVlc3RzLCBkb2VzIHRoZQ0KPiBkZWNyZW1lbnQgaW4gZm5pY19mY3Bpb19jbXBsX2hhbmRsZXIo
KSBpbiBmbmljX3Njc2kuYyBuZWVkIHRvIGJlIHVwZGF0ZWQNCj4gdG8gaW5jbHVkZSBGQ1BJT19O
Vk1FX0VSU1BfSFdfQ01QTD8NCj4NCj4gV2l0aG91dCB1cGRhdGluZyB0aGUgc3dpdGNoIHN0YXRl
bWVudCBpbiBmbmljX2ZjcGlvX2NtcGxfaGFuZGxlcigpLCB3aWxsDQo+IHRoZSBjb3VudGVyIHBl
cm1hbmVudGx5IGRyaWZ0IHVwd2FyZHMgd2hlbiBOVk1lIGNvbW1hbmRzIGNvbXBsZXRlIHdpdGgg
YW4NCj4gRXh0ZW5kZWQgUmVzcG9uc2U/DQo+DQo+IFsgLi4uIF0NCg0KVGhhbmtzIGZvciB0aGUg
cmV2aWV3Lg0KVGhlIHRlYW0gd2lsbCByZXZpZXcgdGhpcyBmZWVkYmFjayBhbmQgZGV0ZXJtaW5l
IHRoZSBuZWNlc3NhcnkgY2hhbmdlcyBpbiB0aGUgbmV4dCByZXZpc2lvbiBvZiB0aGUgcGF0Y2gg
c2VyaWVzLg0KDQo+DQo+ID4gQEAgLTc2NiwxMSArODc4LDE4IEBAIHZvaWQgbnZmbmljX2ZjcGlv
X252bWVfaXRtZl9jbXBsX2hhbmRsZXIoc3RydWN0IGZuaWMgKmZuaWMsDQo+ID4NCj4gPiAgICAg
aW9fcmVxLT5jbWRfZmxhZ3MgfD0gRk5JQ19JT19BQlRfVEVSTV9ET05FOw0KPiA+DQo+ID4gKyAg
IGlmICghKGlvX3JlcS0+Y21kX2ZsYWdzICYgKEZOSUNfSU9fQUJPUlRFRCB8IEZOSUNfSU9fRE9O
RSkpKQ0KPiA+ICsgICAgICAgICAgIGF0b21pYzY0X2luYygmbWlzY19zdGF0cy0+bm9faWNtbmRf
aXRtZl9jbXBscyk7DQo+ID4NCj4gPiAgICAgaWYgKGlvX3JlcS0+YWJ0c19zdGF0ZSA9PSBGQ1BJ
T19TVUNDRVNTKSB7DQo+ID4gICAgICAgICAgICAgaW9fcmVxLT5mY3BfcmVxLT50cmFuc2ZlcnJl
ZF9sZW5ndGggPSAwOw0KPiA+ICAgICAgICAgICAgIGlvX3JlcS0+ZmNwX3JlcS0+cmN2X3JzcGxl
biA9IDA7DQo+ID4gICAgICAgICAgICAgaW9fcmVxLT5mY3BfcmVxLT5zdGF0dXMgPSBOVk1FX1ND
X0FCT1JUX1JFUTsNCj4gPiArICAgICAgICAgICBhdG9taWM2NF9kZWMoJmZuaWNfc3RhdHMtPmlv
X3N0YXRzLmFjdGl2ZV9pb3MpOw0KPiA+ICsgICAgICAgICAgIGlmIChhdG9taWM2NF9yZWFkKCZm
bmljLT5pb19jbXBsX3NraXApKQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgYXRvbWljNjRfZGVj
KCZmbmljLT5pb19jbXBsX3NraXApOw0KPiA+ICsgICAgICAgICAgIGVsc2UNCj4gPiArICAgICAg
ICAgICAgICAgICAgIGF0b21pYzY0X2luYygmZm5pY19zdGF0cy0+aW9fc3RhdHMuaW9fY29tcGxl
dGlvbnMpOw0KPiA+DQo+ID4gICAgICAgICAgICAgbnZmbmljX3JlbGVhc2VfbnZtZV9pb3JlcV9i
dWYoaXBvcnQsIGlvX3JlcSk7DQo+ID4gICAgICAgICAgICAgaWYgKGlvX3JlcS0+ZG9uZSkNCj4N
Cj4gW1NldmVyaXR5OiBIaWdoXQ0KPiBEb2VzIHRoaXMgY29kZSBsZWFrIG1lbW9yeSBhbmQgdGhl
IGFjdGl2ZV9pb3MgY291bnRlciB3aGVuIHRoZSBhYm9ydCBzdGF0dXMNCj4gaXMgbm90IEZDUElP
X1NVQ0NFU1M/DQo+DQo+IElmIHRoZSBhYm9ydCBmYWlscywgdGhlIGZ1bmN0aW9uIHNraXBzIG52
Zm5pY19yZWxlYXNlX252bWVfaW9yZXFfYnVmKCksDQo+IHRoZSBpb19yZXEtPmRvbmUoKSBjYWxs
YmFjaywgYW5kIHRoZSBhY3RpdmVfaW9zIGRlY3JlbWVudCBiZWZvcmUgdW5sb2NraW5nDQo+IGFu
ZCByZXR1cm5pbmcuDQo+DQo+IFsgLi4uIF0NCg0KVGhhbmtzIGZvciB0aGUgcmV2aWV3Lg0KVGhl
IHRlYW0gd2lsbCByZXZpZXcgdGhpcyBmZWVkYmFjayBhbmQgZGV0ZXJtaW5lIHRoZSBuZWNlc3Nh
cnkgY2hhbmdlcyBpbiB0aGUgbmV4dCByZXZpc2lvbiBvZiB0aGUgcGF0Y2ggc2VyaWVzLg0KDQo+
DQo+ID4gQEAgLTEwNjcsMTEgKzExOTEsMTQgQEAgbnZmbmljX2ZpbmRfbHNfcmVxKHN0cnVjdCBm
bmljX3Rwb3J0X3MgKnRwb3J0LCB1aW50MTZfdCBveGlkKQ0KPiA+ICB2b2lkIG52Zm5pY19mY3Bp
b19jbXBsKHN0cnVjdCBmbmljX2lvX3JlcSAqaW9fcmVxKQ0KPiA+ICB7DQo+ID4gICAgIHN0cnVj
dCBmbmljICpmbmljID0gaW9fcmVxLT5pcG9ydC0+Zm5pYzsNCj4gPiArICAgc3RydWN0IGZuaWNf
c3RhdHMgKmZuaWNfc3RhdHMgPSAmZm5pYy0+Zm5pY19zdGF0czsNCj4gPg0KPiA+ICAgICBudmZu
aWNfZnJlZV9mY3Bpb190YWcoaW9fcmVxLT5pcG9ydCwgaW9fcmVxKTsNCj4gPiArICAgYXRvbWlj
NjRfaW5jKCZmbmljX3N0YXRzLT5pb19zdGF0cy5udm1lX2lvc19xdWV1ZWRfZm9yX3JzcCk7DQo+
ID4NCj4gPiAgICAgbGxpc3RfYWRkKCZpb19yZXEtPm52Zm5pY19pb19jbXBsLCAmZm5pYy0+bnZt
ZV9pb19ldmVudF9sbGlzdCk7DQo+ID4gICAgIGF0b21pY19pbmMoJmZuaWMtPm52bWVfaW9fZXZl
bnRfcXVldWVkKTsNCj4gPiArICAgYXRvbWljNjRfaW5jKCZmbmljX3N0YXRzLT5pb19zdGF0cy5u
dm1lX251bV9pb3NfaW5fd2FpdHEpOw0KPiA+DQo+ID4gICAgIGlvX3JlcS0+d2FpdHFfc3RhcnRf
dGltZSA9IGppZmZpZXM7DQo+ID4gICAgIHF1ZXVlX3dvcmsoZm5pY19jbXBsX3F1ZXVlLCAmZm5p
Yy0+bnZtZV9pb19jbXBsX3dvcmspOw0KPg0KPiBbU2V2ZXJpdHk6IEhpZ2hdDQo+IENhbiB0aGlz
IHdyaXRlIHRvIHdhaXRxX3N0YXJ0X3RpbWUgY2F1c2UgYSB1c2UtYWZ0ZXItZnJlZT8NCj4NCj4g
VGhlIGlvX3JlcSBpcyBwdWJsaXNoZWQgdG8gYSBsb2NrbGVzcyBsaXN0IHZpYSBsbGlzdF9hZGQo
KSBiZWZvcmUgYXNzaWduaW5nDQo+IHdhaXRxX3N0YXJ0X3RpbWUuIEEgY29uY3VycmVudCB3b3Jr
ZXIgdGhyZWFkIGNvdWxkIGRlcXVldWUgdGhlIHJlcXVlc3QsDQo+IHByb2Nlc3MgdGhlIGNvbXBs
ZXRpb24sIGFuZCBmcmVlIHRoZSBtZW1vcnkgYmVmb3JlIHRoaXMgYXNzaWdubWVudCBvY2N1cnMu
DQo+DQo+IFsgLi4uIF0NCg0KVGhhbmtzIGZvciB0aGUgcmV2aWV3Lg0KVGhlIHRlYW0gd2lsbCBy
ZXZpZXcgdGhpcyBmZWVkYmFjayBhbmQgZGV0ZXJtaW5lIHRoZSBuZWNlc3NhcnkgY2hhbmdlcyBp
biB0aGUgbmV4dCByZXZpc2lvbiBvZiB0aGUgcGF0Y2ggc2VyaWVzLg0KDQo+DQo+ID4gQEAgLTEy
MTUsNiArMTM0OCw3IEBAIHZvaWQgbnZmbmljX2xzX3JzcF9yZWN2KHN0cnVjdCBmbmljX2lwb3J0
X3MgKmlwb3J0LA0KPiA+ICAgICB9DQo+ID4NCj4gPiAgICAgbnZmbmljX2xzX3JlcS0+c3RhdGUg
PSBGTklDX0xTX1JFUV9DTURfQ09NUExFVEU7DQo+ID4gKyAgIGF0b21pYzY0X2luYygmZm5pY19z
dGF0cy0+bnZtZV9zdGF0cy5udm1lX2xzX3Jlc3BvbnNlcyk7DQo+ID4NCj4gPiAgICAgbGlzdF9k
ZWxfaW5pdCgmbnZmbmljX2xzX3JlcS0+bGlzdCk7DQo+ID4gICAgIGxzcmVxLT5wcml2YXRlID0g
TlVMTDsNCj4NCj4gW1NldmVyaXR5OiBIaWdoXQ0KPiBJcyBpdCBwb3NzaWJsZSB0aGUgdGltZXJf
ZGVsZXRlX3N5bmMoKSBjYWxsIHJpZ2h0IGFmdGVyIHRoaXMgYmxvY2sgdHJpZ2dlcnMNCj4gYSBk
ZWFkbG9jaz8NCj4NCj4gbnZmbmljX2xzX3JzcF9yZWN2KCkgaXMgY2FsbGVkIHdpdGggZm5pYy0+
Zm5pY19sb2NrIGhlbGQuIFRoZSBzeW5jDQo+IGNhbmNlbGxhdGlvbiBibG9ja3Mgb24gdGhlIHRp
bWVyIGNhbGxiYWNrIGlmIGl0J3MgcnVubmluZywgYnV0IHRoZSBjYWxsYmFjaw0KPiAobnZmbmlj
X2xzX3JlcV90aW1lb3V0KCkpIHVuY29uZGl0aW9uYWxseSBhdHRlbXB0cyB0byBhY3F1aXJlIHRo
ZSBzYW1lDQo+IGZuaWMtPmZuaWNfbG9jaywgY3JlYXRpbmcgYW4gQUItQkEgZGVhZGxvY2sgc2Nl
bmFyaW8uDQo+DQoNClRoYW5rcyBmb3IgdGhlIHJldmlldy4NClRoZSB0ZWFtIHdpbGwgcmV2aWV3
IHRoaXMgZmVlZGJhY2sgYW5kIGRldGVybWluZSB0aGUgbmVjZXNzYXJ5IGNoYW5nZXMgaW4gdGhl
IG5leHQgcmV2aXNpb24gb2YgdGhlIHBhdGNoIHNlcmllcy4NCg0KPiAtLQ0KPiBTYXNoaWtvIEFJ
IHJldmlldyDCtyBodHRwczovL3Nhc2hpa28uZGV2LyMvcGF0Y2hzZXQvMjAyNjA2MTIxODA5MTgu
ODU1NC0xLWthcnRpbGFrQGNpc2NvLmNvbT9wYXJ0PTExDQo+DQoNCg0KDQpSZWdhcmRzLA0KS2Fy
YW4NCg==
