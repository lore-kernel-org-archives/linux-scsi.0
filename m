Received: from rcdn-iport-8.cisco.com (rcdn-iport-8.cisco.com [173.37.86.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B3C3914E4
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 20:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.86.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781642625; cv=fail; b=r2IrxKwYw2m28sPaQAo+vx/JzGz93uTObJYsADBKtAPgSKH7CR8apfqL6vsRjPG1lNQRFvW+CCKFKlBKVilfoYDd14qQ9Nar4l19JgvWVsg5MtUCiPBR8mwCFzvfjWBvAmMG4NFlWEw2oGlN4NR7iSukuELnZWknEVfsNvC4Ozg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781642625; c=relaxed/simple;
	bh=nfPvOxFaR+H5teBoQ5p0CqlgvLKc1hiftdfZwf1Q9Go=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ks016RNHK7qhER404NJOXX9uCGpdhmVqH1Tli3pdbYYEwFTOa/NP3NZjcVraveF0y9z5N6Z59WdmBEgaPo4nqgqbjyvCcrQN+Wr6CZIBa1JBVMPHJZXm22tlDlJwphEEHtjRWfwFjCT5rG+qQG/bW1rLoy0HUQv97QSicCM+KE8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=cqpVDqHY; arc=fail smtp.client-ip=173.37.86.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="cqpVDqHY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=6586; q=dns/txt;
  s=iport01; t=1781642623; x=1782852223;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nfPvOxFaR+H5teBoQ5p0CqlgvLKc1hiftdfZwf1Q9Go=;
  b=cqpVDqHYm/R7/cwsHF6dPn/yjk1WP91HQeuihSJ2l8O6GL/jwb1PV4iJ
   ESg7QWdFNWKU0FrH9WyCSvFuE65t1Z5jPMg+AfGmBoEs8AjeLsitm1zxb
   UmzbsdRgIous0fedBwi413eCkTupEPh08MbEozokHfrWDhWgKUQ5HPcv9
   ONh5SA23uXukhJrJ4agsbAySL0F1IYUqHlXh1c0gaOluwSBxYFgPy6oGG
   2kfI8+xccNI2QAS7oHNIT62ThiBsykUhiROt/haKzjmmQUcYPddrDR8Fw
   BCJHOIqnrsHslVKBvE9Us74ptM7TSa9QlHC+TBuKRRctYNeHH0Zh6Gavg
   g==;
X-CSE-ConnectionGUID: 9/aUYiYiR8CFDpW3dbkC+A==
X-CSE-MsgGUID: puPH2vhlQWaEDST+/VzNhw==
X-IPAS-Result: =?us-ascii?q?A0ApAAD3szFq/5P/Ja1aHAEBAQEBAQcBARIBAQQEAQFlg?=
 =?us-ascii?q?RcHAQELAYFtU4EKgSFJhFeDTAOETV+IeQOeG4F+DwEBAQ0CUQQBAYUGAhaNK?=
 =?us-ascii?q?wImNAkOAQIEAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHBYEOE4ZQDIZaAQEBA?=
 =?us-ascii?q?QIBEhEEDUUQAgEIGAICJgICAi8VEAIEDgUIGoJhgkwnAwECph8BgT0Ciip6f?=
 =?us-ascii?q?zOBAeAvBhQBgQouAYhaAYFwhAY4hEQnG4INgVeCMTg+hEUVg0Q6gjAEgiKBD?=
 =?us-ascii?q?JEbCUl4HANZLAFVExcLBwVhQkMDKi8tI0sFLR2BIyEdFxYeWBsHBRIgKkJFI?=
 =?us-ascii?q?wMCQjQEIT84C0MFgV0CghFOIx8DOX+Bb4ElZ2YVMDWBAQERHwp6AwttPTcUG?=
 =?us-ascii?q?wMEOnsFjGkXD4IdGQd7EwETGCBxCBZOFmeSYAo/gmxJjCmDVp4cgT4KhB2iE?=
 =?us-ascii?q?ReEBI16hh2SUZkII6NahRoCBAIEBQIQAQEGgWg8gVlwFYMiUxkPji0WzB15P?=
 =?us-ascii?q?QEBBwIHDgMLgWiRfQEB?=
IronPort-PHdr: A9a23:Ry9RzReHVTScpf5GnM6uAmOclGM/gIqcDmcuAtIPkblCdOGk55v9e
 RCZ7vR2h1iPVoLeuLpIiOvT5rjpQndIoY2Av3YLbIFWWlcbhN8XkQ0tDI/NCUDyIPPwKS1vN
 M9DT1RiuXq8NCBo
IronPort-Data: A9a23:Sx0a/KNMMZdRyKjvrR3wlsFynXyQoLVcMsEvi/4bfWQNrUp0hWYDy
 GJJWWHUPfyCMTTyedElbNmz8ksGu5bVydVkGXM5pCpnJ55oRWUpJjg4wmPYZX76whjrFRo/h
 ykmQoCeaphyFTmE+kvF3oHJ9RFUzbuPSqf3FNnKMyVwQR4MYCo6gHqPocZh6mJTqYb/WV/lV
 e/a+ZWFZgf7gmAsaQr41orawP9RlKWq0N8nlgRWicBj5Df2i3QTBZQDEqC9R1OQapVUBOOzW
 9HYx7i/+G7Dlz91Yj9yuu+mGqGiaue60Tmm0hK6aYD76vRxjnBaPpIACRYpQRw/ZwNlMDxG4
 I4lWZSYEW/FN0BX8QgXe0Ew/ypWZcWq9FJbSJSymZT78qHIT5fj66QpBXwHPLwZwLZcL01Wy
 qcUIjMmLTnW0opawJrjIgVtrt4oIM+uOMYUvWttiGiBS/0nWpvEBa7N4Le03h9p2ZsIRqmYP
 ZdEL2MzM3wsYDUXUrsTIJE3hvupgnD8WzZZs1mS46Ew5gA/ySQtgOa8boGNJofiqcN9hlugh
 jjY/2DAPRg3GOejin274FSsmbqa9c/8cMdIfFGizdZugVuO1ikIAwYXfUW0rOP/iUOkXd9bb
 UsO9UITQbMa7kenSJz5Gha/unPB50ZaUNtLGOp84waIokbJ3zuk6qE/ZmcpQPQttdQ9Qnoh0
 Vrhoj8jLWUHXGG9IZ5FyoqpkA==
IronPort-HdrOrdr: A9a23:UmtqMqwD9i811RiWiwmYKrPxI+gkLtp133Aq2lEZdPULSL36qy
 n+ppQmPEHP6Qr5AEtQ5+xoWJPtfZvdnaQFh7X5To3SLTUO31HYY72KjLGSjwEIdBeOjNK1uZ
 0QF5SWTeeAcmSS7vyKrjVQcexQveVvmZrA7YyxvhUdKD2CKZsQkzuRYTzra3GeMTM2fqbRY6
 DsnvavyQDQHkg/X4CQPFVAde7FoNHAiZLhZjA7JzNP0mOzpALtwoTXVzyD0Dkjcx4n+9of2F
 mAvx3y562lvf3+8RnBym/V4a1Rndvq2vFDCMaPhsV9EESstu+vXutccozHmApwjPCk6V4snt
 WJiQwnJd5P53TYeXzwiQfx2iH7uQxeqEPK+Bu9uz/OsMb5TDU1B45qnoRCaCbU7EImoZVVzL
 9L5WSErJBaZCmw3hgVpuK4Ei2CpHDE5kbKotRjyUC3lrFuMYO5mLZvuH+91q1wRB4SprpXS9
 WGR/uslMq+OWnqHEwx+FMfgOCEbzAUAgqMRFQEt4i+1jhbm2088m4jrfZvxEvpMPkGOsV5Dy
 OuCNU0qJheCsARdq5zH+EHXI++DXHMWwvFNCaILU3gD7xvAQOHl3fb2sR92AiRQu1B8LIi3J
 DaFF9Iv287fEzjTcWIwZ1Q6xjIBGGwRy7kxM1S74Vw/uSUfsunDQSTDFQ118ewqfQWBcPWH/
 61JZJNGvfmaW/jA5xA0QHyU4RbbXMeTMoWsNAmXE/mmLOAFqT68ujANPrDLrvkFjgpHmv5H3
 sYRTD2YN5N60i6M0WI9iQ5m0mdDXAX0agAZJQypdJjurTlHrc8xzQotQ==
X-Talos-CUID: =?us-ascii?q?9a23=3Ao0Dn4mtkpv1369xuYRutYzSy6It0NXTg/XbhInX?=
 =?us-ascii?q?oIkhFUILORVWT0+BNxp8=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3ASqNZ0wwwMpzJ543HRjlxe4CeL6WaqLyzMGBXj5U?=
 =?us-ascii?q?CgvaNGABLB3TasiaRQpByfw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-l-core-10.cisco.com ([173.37.255.147])
  by rcdn-iport-8.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 16 Jun 2026 20:43:42 +0000
Received: from rcdn-opgw-4.cisco.com (rcdn-opgw-4.cisco.com [72.163.7.165])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by rcdn-l-core-10.cisco.com (Postfix) with ESMTPS id 9FC4B1800024C
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 20:43:42 +0000 (GMT)
X-CSE-ConnectionGUID: Ynge2cp3SZaI8GHgLEAXcw==
X-CSE-MsgGUID: I1XBpDRFTN2Z+TeRgGmIQw==
Authentication-Results: rcdn-opgw-4.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.24,208,1774310400"; 
   d="scan'208";a="84858407"
Received: from mail-southcentralusazon11012058.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.195.58])
  by rcdn-opgw-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 16 Jun 2026 20:43:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ry6FBqKyA2XTxH9pS59JhpZC/40FoADBkJ1z4Kh8Fo1lg2nsriryY2NGe9wyLM4IhAp2/nnmMJ8oJ7unYUSXebYXjMR8QzPiAlWSHzZ7TRyKkeTKgUoN7//SMKtsQeYSAfwYs+Mpz1CtsDsuwhJa1YlC4h7lni+4FYvrF2VmFMRDC49OOGYn4aW958uP1A1DNdJWtntO57UOEPyoRONuFZR4pSJe+y3wTLnTbpI5cz+54aMl8tDdUBGfuBcy0mNbzPDNvl94m0Gdm0267q5kaY4hVQKSskAUGhoTG4xYyzXQjBFblcfkoC83ZTcZjp6dAkkIScqxRpciUl+GPj2JBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nfPvOxFaR+H5teBoQ5p0CqlgvLKc1hiftdfZwf1Q9Go=;
 b=sQjnMuOVnqdFaGWagvKxvjGrOtMr1/m6IpP3NFZ5RyCBIbRVCVFH1IdtBU+X92WrQNLFFeD2cYij85/EiECHS5ELmXHFnP0i8jw9d2t602XE74Hzuq4sbkkw1l8xLKLcPVFbvRsi6v/StjIkh8w4++9Qa3jBCeYpWvRpDKrbOsFDi8/hmaXzAY4ZVAOl4b7TGB/XcfNDhHFd+4dXKW5Bjtcof6JQygopK9t0liSo2v0+qxP4aRBGEKyk3xvOHI+9qjrrViTTo41z3lhkfUgzaaxEonSuXeDcIlUWuqLPYAHW3CJOaQm9x91jcBvZo7l/xPxbhJ4c1VIUW3kPg8wAgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by PHXPR11MB9686.namprd11.prod.outlook.com (2603:10b6:510:3ca::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.16; Tue, 16 Jun
 2026 20:43:40 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db%3]) with mapi id 15.21.0113.015; Tue, 16 Jun 2026
 20:43:40 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sesidhar
 Baddela (sebaddel)" <sebaddel@cisco.com>, "Arulprabhu Ponnusamy (arulponn)"
	<arulponn@cisco.com>, "Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>, "Arun
 Easi (aeasi)" <aeasi@cisco.com>
Subject: RE: [PATCH v4 12/13] scsi: fnic: Expose NVMe transport state in
 debugfs
Thread-Topic: [PATCH v4 12/13] scsi: fnic: Expose NVMe transport state in
 debugfs
Thread-Index: AQHc+pejic8UJTCd/kmHCNoxVZ1VkrY7j3+AgAYcEjA=
Date: Tue, 16 Jun 2026 20:43:40 +0000
Message-ID:
 <SJ0PR11MB58964F512AF185BFAA75A70EC3E52@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20260612180918.8554-13-kartilak@cisco.com>
 <20260612232232.1C5FA1F000E9@smtp.kernel.org>
In-Reply-To: <20260612232232.1C5FA1F000E9@smtp.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|PHXPR11MB9686:EE_
x-ms-office365-filtering-correlation-id: f723d50a-af93-4e12-8e42-08decbe7f2e5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|6133799003|56012099006|4143699003|11063799006|38070700021|22082099003|18002099003;
x-microsoft-antispam-message-info:
 etBfFXCXCEKZiJOSs/Pli8czcbGKvMeyu/q59fG4UAL5wJRRm+Cy8pad/Vvx5PL+hFPTJSThXMP1asBpgKQ/JsFUkmAbygAnfkF0ijlUpNIIJQWQzbQiPHVO76ivEtbhiY1ScOwA2bVg++Sx4DNUfNCYijvUItz0axrsclOuLBGiGkszrgcrjaHP/MXVQ0nbO2NiZpO9eXBzn9jYIzijpYRB1sot2N1qJpI8R1Mx6/cNreZraziFIwSdujQ2DhVth6jk7yLJ1wnkP1qzS2r4vjFcZkCH2hWXJDdR6mxkDtc/b+UEo5lT8ifOidEC08qljTmP0Fh8I9GuyDMGN712SJQW+rVbTi8qY8cfJyHAn4J6//N5appKcYOVGM+bI2KW56yaxjQ0iALdWPunGkMMG7h3vuu82Y8HXG/DcE3W6z9iwcz2Yks751servor1RV6AzRvv8aozOy7RtHOJDBmiBH8/59WPOJxPKIMhHdRq5B0kNPk2abhgbQStUAYsrF2W9rivk0LI45yi+sGvsSlB7Cgp2qRDuzT1OpU6QOQ9cNfkBA4e2zCMBEooavGklOgC1rO+ZVGkXvYeNKjStCD4uvQPJ2rz71VWC2mWM3x56I09ZS/u6N5gc4KKvuxCUdOXSsdRqhnn2eyiwesN+3EI7xQy2VYJM/QN00WKac8WYmTM3aqJnd2hcZ+rNSmUkIq
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(6133799003)(56012099006)(4143699003)(11063799006)(38070700021)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MnYxRXRKVjlKY0dNUDZNa28wLzJUd0hYTVFqb09IOHdoRXBEdm9JRFVzakti?=
 =?utf-8?B?RkVobU5yaFhLdkxTQkVXVndaQlE3Zm9BZ0dKWWVsT2g1aFFXeDhYU1FSWldh?=
 =?utf-8?B?WXRMd0xxT3VCenpTSVRBYVpGMVdKUTlIVENTbkxpUFBSbUtSUHVUMC95TVBh?=
 =?utf-8?B?YnQvTnFvZmVyVXZJTWwwV1Q3R0VmaW1kVWdPRFV6d3puaHp5ZW5UUG9xRUND?=
 =?utf-8?B?TGc1WGVtZGFtbG14ZDdpRWw4K0o2NFJxOXIxOTAzRDBvMlc5S0JrY3M3bTc1?=
 =?utf-8?B?ZUozd1RmWFpBOUJQVC9tWE9NcENOTHBsbVJPU2hFN0xQTEhyYlZYcWIrSGFD?=
 =?utf-8?B?NVFzMTZJaE9RSlpybGFXeHdYOWNWS0ZLQk8vc1dEUFRnU1VTVGw3ZjB2YjUy?=
 =?utf-8?B?bnhFZ0lHWXo1VzdBZ2dQVDJ1NklRMmxPSUdVU0l4ck9uSWFIazFOTVpXdStX?=
 =?utf-8?B?UWdLSFRCUTZ4RldxZmNrQUc3M21HTmlKdnA5K2djU1RGOHU0a1pLQ2FoSllE?=
 =?utf-8?B?aUxqeXJobTdoU2t5NG81V2pyRmk3bTVQV1FVUmhweTRjeDc5UnpBcndVaFBF?=
 =?utf-8?B?TktiWWZTU2FsQy94eHdLT3FMOGl6dW5IdDFYM1RuK2dwZzBWK1l2S05XVGlJ?=
 =?utf-8?B?Nm5tYVpEdSsxYWFvTWRPakcrSTBJdXgwUDBibmFHZEdtSExIdm5FMTFNTk9v?=
 =?utf-8?B?bms4QXY2QWdRU01kN0ZTTnJ4dG1KZnVzY0ZINlhTOGk1Z0ZzY0Y0eThYZEhL?=
 =?utf-8?B?NXRDejdmOU9qd1dQamZyUU94NFVUdmtSZkdGQnV6SEtCZFVCMG9DZGVqTDB2?=
 =?utf-8?B?K1JjbEhXZjhZa3llV3ozQlpIRTdkQUs3dktoY21sWEVVL1JrVGdXajdSVFZ2?=
 =?utf-8?B?d2Qya0JLWnNtcDFiRXRMWHF1R295R05JOUVvR1VwcEY2K1lZa1NNbEpOOUcw?=
 =?utf-8?B?UkhvdTVGTDFmNHBIVXEvN1ZMcndGdGlqVlZSWW5CeEZBTXRqZE1QUjVtZGE1?=
 =?utf-8?B?RFlpd1hxS0ZKNXlmd3ErKzFJY2xHVm8rSHlBMTdtaytnVExlSy9VdWpDWUdw?=
 =?utf-8?B?eEY3S3FNVjZubW9ocG9vOVc3MzRxbnk1Znd1VHM1ekpSL0k0aUNGZlo3ZjVE?=
 =?utf-8?B?V29zUkhIS2t0K0RwdEIxOU9JVzk5TEpoQzNFOFltMjY2YktPalQ5bXRVOE9B?=
 =?utf-8?B?czRUWUViVXBZVDdEZ1NwYUcxVXZEUGRPTExocW1LeVhQdGdsRDdlMmRjUzdZ?=
 =?utf-8?B?Qzk0MEJzYllUVVFsem9SWDlGRkRtVGdUcTVKM01XVnlrT0lTVjMvSFZOVFRT?=
 =?utf-8?B?QkUyWHFPdjJWdGFPU0N1Rm0wRXBuYWV2OTd6aUFnME9SdTlkZ0xlZzlWeXMv?=
 =?utf-8?B?WVlycnVzSlBXZ2RIMUhQcGY2WnBqOFNLNHRoVWp5dUFVc2tTSnZab1BPTHVJ?=
 =?utf-8?B?R3E4eSt3eXN3eHg3UWZZTkJaRlNhMFBtNWhIbW5Ub2FxcmQ5MGpvZVprY3Vi?=
 =?utf-8?B?NGprVlA4bS9BVnB1Z0NNa3hUOGUxQ3RSVG9jUE01d2Z0Qmg2U0RXaDRXblVO?=
 =?utf-8?B?U2F6MisrOWZuYnh3RS9Za2p6WmhzbDhRVWplTjlRdzQxRkdZcW43OGpSQlVw?=
 =?utf-8?B?ZWR2c01oSjEvcFlhOXBuNmtQaVgvQWNXNzlZTHFHZkYvYkw5Y2hIRWZJV29V?=
 =?utf-8?B?YVM5dC9jd2RPZkdHbmNpU3d5SWtNbHgvOENEbUIrc0wvMkJZUWV1YVN1QTZM?=
 =?utf-8?B?OFA5QTdvNTRkMjBxZDA0TWxOQ0xldXhpdnl5VWVJS2N3ZVVweENIK1grb0Fz?=
 =?utf-8?B?b1EzZnNmbkpDbk1pS0o3azF2OXRqRWdqRmdZdVdHZmx5QUQ1TGZvMzA0RTJy?=
 =?utf-8?B?S3ozdlIzek9odFNrbG9jTlk3K1R3dStJQTJ2d0dxeVJQbXdzU1I1bGY1WEYz?=
 =?utf-8?B?QzNDR3IyT1lIcE9jRDMxMTh2OWNCeUxYRnJwUkdDckFHTWtGV0ltWWtGa2g3?=
 =?utf-8?B?aEZZcFhtbzU3WXhiWEVTOWhXR08rWVFlOEMxSWYveDRzNVhSR2JibFdzWENH?=
 =?utf-8?B?d2NIUUxxRGtJY0hod2xPM1hnTlFIOC8veU0rZVRoaXp0a0RjNjA5QnpyYWhp?=
 =?utf-8?B?RHpTOEg0RlFRbk0wTkdlRHlFWmdvbHJEdXNiVHBaVnRhMTBGK3A4WlNpdmxn?=
 =?utf-8?B?dGxndUs3U1JCQnYvalV5T3NjSnBWR0NEbDU4UWp0NnJnWm1MMkFVaHNvdnBx?=
 =?utf-8?B?U0Fjc0llcmVHdG41SzlqcWduclZoSmhoL2hxY0gvVWJZKzRjRWk3eFdEbk5u?=
 =?utf-8?Q?acpbpHF3IoZ+Ry2GsZ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	dEqCjOVVRMFLzEGij44UvTNDQ5aHssAocGnOJlhykF8yv1s00qhgY3w6VwPGYXjSgmEtICyzpxQHYnjpcr/PuH/8X/ZHiBgPKCRFC53pKo0T9RO7uUF2nnKJUO7Td/i8BVt2OZiO4G6nbt64gni21x34j0/mNwEWnQl8Q5frXUv9Jhvxe1uZxak6yicDlAbXLlxIGdnyvC/qPvV/g61kCke2JKN5R51WHRbY2jXBpJ1y7sYTlnbcFdxx84Q4miC7FERO/6ETW5+noVcEq+aNzkxQsR1WchiCpVdO1KgJUqI43tmDlpKVs/ru6m9o3gagv+xg/DlyKdwqaaLXf6jfXw==
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f723d50a-af93-4e12-8e42-08decbe7f2e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2026 20:43:40.4721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wHctTfq3WIvcs97h47DcGgpQtCgqIPX1PoeqKzNQpzLvH9HeLYJAr+/2QVvFk/W5ic/7Gej7/sCqQsA4SkOIjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PHXPR11MB9686
X-Outbound-Client-TLS: ANONYMOUS;rcdn-opgw-4.cisco.com [72.163.7.165];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 72.163.7.165, rcdn-opgw-4.cisco.com
X-Outbound-Node: rcdn-l-core-10.cisco.com

T24gRnJpZGF5LCBKdW5lIDEyLCAyMDI2IDQ6MjMgUE0sIHNhc2hpa28tYm90QGtlcm5lbC5vcmcg
PHNhc2hpa28tYm90QGtlcm5lbC5vcmc+IHdyb3RlOg0KPg0KPiBUaGFuayB5b3UgZm9yIHlvdXIg
Y29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJldmlldyBmb3VuZCAzIHBvdGVudGlhbCBpc3N1ZShz
KSB0byBjb25zaWRlcjoNCj4gLSBbSGlnaF0gTWlzc2luZyBjbGVhbnVwIG9mIE5WTWUgZGVidWdm
cyBmaWxlcyBkdXJpbmcgYGZuaWNfcHJvYmVgIGVycm9yIHBhdGhzIGFsbG93cyBhIHVzZS1hZnRl
ci1mcmVlIG9uIHRoZSBmcmVlZCBgZm5pY2Agc3RydWN0dXJlLg0KPiAtIFtMb3ddIFRoZSBkZWJ1
Z2ZzIGZpbGUgaXMgY3JlYXRlZCB3aXRoIHdyaXRlIHBlcm1pc3Npb25zIChgMDIwMGApIGJ1dCB0
aGUgZmlsZSBvcGVyYXRpb25zIGxhY2sgYSBgLndyaXRlYCBjYWxsYmFjay4NCj4gLSBbTG93XSBU
aGUgZXJyb3IgaGFuZGxpbmcgYmxvY2sgZm9yIGBmbmljX252bWVmX2RlYnVnZnNfaW5pdGAgaXMg
ZGVhZCBjb2RlIGJlY2F1c2UgdGhlIGZ1bmN0aW9uIHVuY29uZGl0aW9uYWxseSByZXR1cm5zIDAu
DQo+IC0tDQo+DQo+IGNvbW1pdCAyOTU1NTI5MTFjNmI3NzU0NzExMjM4NjJhYTRmNmU2MzI1NDE3
ZjM2DQo+IEF1dGhvcjogS2FyYW4gVGlsYWsgS3VtYXIgPGthcnRpbGFrQGNpc2NvLmNvbT4NCj4N
Cj4gc2NzaTogZm5pYzogRXhwb3NlIE5WTWUgdHJhbnNwb3J0IHN0YXRlIGluIGRlYnVnZnMNCj4N
Cj4gQ3JlYXRlIGFuIE5WTWUgZGVidWdmcyBkaXJlY3Rvcnkgd2l0aCBhIHBlci1ob3N0IG52bWVm
X2luZm8gZmlsZS4NCj4gUmVwb3J0IGxvY2FsLXBvcnQgYW5kIHRhcmdldC1wb3J0IGlkZW50aWZp
ZXJzIGZvciBOVk1lIGluaXRpYXRvcg0KPiBpbnN0YW5jZXMsIGFuZCBpbml0aWFsaXplIGFuZCBy
ZW1vdmUgdGhlIGRlYnVnZnMgZW50cmllcyB3aXRoIHRoZSBOVk1lDQo+IHByb2JlIGFuZCB0ZWFy
ZG93biBwYXRocy4NCj4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL2ZuaWMvZm5pY19k
ZWJ1Z2ZzLmMgYi9kcml2ZXJzL3Njc2kvZm5pYy9mbmljX2RlYnVnZnMuYw0KPiA+IGluZGV4IDQ2
N2ZiYTI5ZWE1ZjguLjY5MGIxYzZlY2YwMTAgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9zY3Np
L2ZuaWMvZm5pY19kZWJ1Z2ZzLmMNCj4gPiArKysgYi9kcml2ZXJzL3Njc2kvZm5pYy9mbmljX2Rl
YnVnZnMuYw0KPg0KPiBbIC4uLiBdDQo+DQo+ID4gK3N0YXRpYyBjb25zdCBzdHJ1Y3QgZmlsZV9v
cGVyYXRpb25zIGZuaWNfbnZtZWZfZGVidWdmc19mb3BzID0gew0KPiA+ICsgICAub3duZXIgPSBU
SElTX01PRFVMRSwNCj4gPiArICAgLm9wZW4gPSBmbmljX252bWVmX2RlYnVnZnNfb3BlbiwNCj4g
PiArICAgLnJlYWQgPSBmbmljX252bWVmX2RlYnVnZnNfcmVhZCwNCj4gPiArICAgLnJlbGVhc2Ug
PSBmbmljX252bWVmX2RlYnVnZnNfcmVsZWFzZSwNCj4gPiArfTsNCj4NCj4gWyAuLi4gXQ0KPg0K
PiA+ICtpbnQgZm5pY19udm1lZl9kZWJ1Z2ZzX2luaXQoc3RydWN0IGZuaWMgKmZuaWMpDQo+ID4g
K3sNCj4gPiArICAgY2hhciBuYW1lWzE2XTsNCj4gPiArDQo+ID4gKyAgIHNucHJpbnRmKG5hbWUs
IHNpemVvZihuYW1lKSwgImhvc3QlZCIsIGZuaWMtPmZuaWNfbnVtKTsNCj4gPiArDQo+ID4gKyAg
IGZuaWMtPmZuaWNfbnZtZWZfZGVidWdmc19ob3N0ID0gZGVidWdmc19jcmVhdGVfZGlyKG5hbWUs
DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIGZuaWNfbnZtZWZfZGVidWdmc19yb290KTsNCj4gPiArICAgZm5pYy0+Zm5pY19udm1lZl9k
ZWJ1Z2ZzX2ZpbGUgPSBkZWJ1Z2ZzX2NyZWF0ZV9maWxlKCJudm1lZl9pbmZvIiwNCj4gPiArICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFNfSUZS
RUcgfCAwNDQ0IHwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIDAyMDAsDQo+DQo+IFtTZXZlcml0eTogTG93XQ0KPiBJcyB0aGUgMDIw
MCB3cml0ZSBwZXJtaXNzaW9uIGludGVuZGVkIGhlcmU/DQo+DQo+IFRoZSBmaWxlIGlzIGNyZWF0
ZWQgd2l0aCB3cml0ZSBwZXJtaXNzaW9ucyAocmVzdWx0aW5nIGluIDA2NDQpLCBidXQNCj4gZm5p
Y19udm1lZl9kZWJ1Z2ZzX2ZvcHMgZG9lcyBub3QgaW1wbGVtZW50IGEgLndyaXRlIGNhbGxiYWNr
Lg0KPg0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgZm5pYy0+Zm5pY19udm1lZl9kZWJ1Z2ZzX2hvc3QsDQo+ID4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBmbmljLA0KPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgJmZu
aWNfbnZtZWZfZGVidWdmc19mb3BzKTsNCj4gPiArICAgcmV0dXJuIDA7DQo+DQoNClRoYW5rcyBm
b3IgdGhlIHJldmlldy4NClRoZSB0ZWFtIHdpbGwgcmV2aWV3IHRoaXMgZmVlZGJhY2sgYW5kIGRl
dGVybWluZSB0aGUgbmVjZXNzYXJ5IGNoYW5nZXMgaW4gdGhlIG5leHQgcmV2aXNpb24gb2YgdGhl
IHBhdGNoIHNlcmllcy4NCg0KPiBbU2V2ZXJpdHk6IExvd10NCj4gU2luY2UgZm5pY19udm1lZl9k
ZWJ1Z2ZzX2luaXQoKSB1bmNvbmRpdGlvbmFsbHkgcmV0dXJucyAwLCB0aGUgZXJyb3IgY2hlY2tp
bmcNCj4gYmxvY2sgZm9yIGl0IGluIGZuaWNfcHJvYmUoKSBpcyB1bnJlYWNoYWJsZSBkZWFkIGNv
ZGUuDQo+DQo+IENvdWxkIHRoaXMgZnVuY3Rpb24gYmUgY2hhbmdlZCB0byByZXR1cm4gdm9pZCwg
b3Igc2hvdWxkIGl0IHByb3BhZ2F0ZSBhbiBlcnJvcg0KPiBpZiB0aGUgZGVidWdmcyBjcmVhdGlv
biBmYWlscz8NCj4NCj4gPiArfQ0KDQpUaGFua3MgZm9yIHRoZSByZXZpZXcuDQpUaGUgdGVhbSB3
aWxsIHJldmlldyB0aGlzIGZlZWRiYWNrIGFuZCBkZXRlcm1pbmUgdGhlIG5lY2Vzc2FyeSBjaGFu
Z2VzIGluIHRoZSBuZXh0IHJldmlzaW9uIG9mIHRoZSBwYXRjaCBzZXJpZXMuDQoNCj4NCj4gPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL2ZuaWMvZm5pY19tYWluLmMgYi9kcml2ZXJzL3Njc2kv
Zm5pYy9mbmljX21haW4uYw0KPiA+IGluZGV4IGNkNTQ4M2FhYzQ2MjkuLmRhNWY5ZDUzYWQxMDQg
MTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9zY3NpL2ZuaWMvZm5pY19tYWluLmMNCj4gPiArKysg
Yi9kcml2ZXJzL3Njc2kvZm5pYy9mbmljX21haW4uYw0KPg0KPiBbIC4uLiBdDQo+DQo+ID4gQEAg
LTkzMyw2ICs5MzMsMTUgQEAgc3RhdGljIGludCBmbmljX3Byb2JlKHN0cnVjdCBwY2lfZGV2ICpw
ZGV2LCBjb25zdCBzdHJ1Y3QgcGNpX2RldmljZV9pZCAqZW50KQ0KPiA+ICAgICAgICAgICAgIGVy
ciA9IC1FT1BOT1RTVVBQOw0KPiA+ICAgICAgICAgICAgIGdvdG8gZXJyX291dF9mbmljX3JvbGU7
DQo+ID4gICAgIGNhc2UgVkZDRl9GQ19OVk1FX0lOSVRJQVRPUjoNCj4gPiArICAgICAgICAgICBl
cnIgPSBmbmljX252bWVmX2RlYnVnZnNfaW5pdChmbmljKTsNCj4gPiArICAgICAgICAgICBpZiAo
ZXJyKSB7DQo+ID4gKyAgICAgICAgICAgICAgICAgICBkZXZfaW5mbygmZm5pYy0+cGRldi0+ZGV2
LA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICJmbmljKCVkKSBGYWlsZWQgdG8gaW5p
dGlhbGl6ZSBkZWJ1Z2ZzIGZvciBudm1lZlxuIiwNCj4gPiArICAgICAgICAgICAgICAgICAgICAg
ICAgICBmbmljLT5mbmljX251bSk7DQo+ID4gKyAgICAgICAgICAgICAgICAgICBmbmljX252bWVm
X2RlYnVnZnNfcmVtb3ZlKGZuaWMpOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgZ290byBlcnJf
b3V0X2ZuaWNfcm9sZTsNCj4gPiArICAgICAgICAgICB9DQo+DQo+IFtTZXZlcml0eTogSGlnaF0N
Cj4gSWYgZm5pY19wcm9iZSgpIGVuY291bnRlcnMgYW4gZXJyb3IgbGF0ZXIgaW4gdGhlIGluaXRp
YWxpemF0aW9uIHNlcXVlbmNlDQo+IChmb3IgZXhhbXBsZSwgZHVyaW5nIGZuaWNfc2V0X2ludHJf
bW9kZSgpIG9yIGZuaWNfYWxsb2Nfdm5pY19yZXNvdXJjZXMoKSksDQo+IGRvZXMgdGhlIGVycm9y
IGhhbmRsaW5nIGNhc2NhZGUgY29ycmVjdGx5IGNsZWFuIHVwIHRoaXMgZGVidWdmcyBlbnRyeT8N
Cj4NCj4gTG9va2luZyBhdCB0aGUgZXJyb3IgcGF0aHMgYXQgdGhlIGVuZCBvZiBmbmljX3Byb2Jl
KCksIGl0IGFwcGVhcnMgdGhlIGZuaWMNCj4gc3RydWN0dXJlIGlzIHVsdGltYXRlbHkgZnJlZWQg
dmlhIGtmcmVlKGZuaWMpLCBidXQgdGhlcmUgaXMgbm8gbWF0Y2hpbmcNCj4gY2FsbCB0byBmbmlj
X252bWVmX2RlYnVnZnNfcmVtb3ZlKGZuaWMpIGR1cmluZyB0aGUgdGVhcmRvd24gc2VxdWVuY2Uu
DQo+DQo+IENvdWxkIHRoaXMgbGVhdmUgYW4gYWN0aXZlIGRlYnVnZnMgbm9kZSBwb2ludGluZyB0
byBhIGZyZWVkIGZuaWMgc3RydWN0dXJlLA0KPiBsZWFkaW5nIHRvIGEgdXNlLWFmdGVyLWZyZWUg
aWYgdGhlIGRlYnVnZnMgZmlsZSBpcyByZWFkPw0KPg0KDQpUaGFua3MgZm9yIHRoZSByZXZpZXcu
DQpUaGUgdGVhbSB3aWxsIHJldmlldyB0aGlzIGZlZWRiYWNrIGFuZCBkZXRlcm1pbmUgdGhlIG5l
Y2Vzc2FyeSBjaGFuZ2VzIGluIHRoZSBuZXh0IHJldmlzaW9uIG9mIHRoZSBwYXRjaCBzZXJpZXMu
DQoNCj4gLS0NCj4gU2FzaGlrbyBBSSByZXZpZXcgwrcgaHR0cHM6Ly9zYXNoaWtvLmRldi8jL3Bh
dGNoc2V0LzIwMjYwNjEyMTgwOTE4Ljg1NTQtMS1rYXJ0aWxha0BjaXNjby5jb20/cGFydD0xMg0K
Pg0KDQpSZWdhcmRzLA0KS2FyYW4NCg==
