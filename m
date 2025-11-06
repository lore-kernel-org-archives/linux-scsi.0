Received: from rcdn-iport-3.cisco.com (rcdn-iport-3.cisco.com [173.37.86.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD6E3009F1
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 21:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.86.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762466332; cv=fail; b=S53OgxWjTHPpbKhgl7iRkV7x/cJLa/tBP3y0u78tuWxrAk+nBKzBFatGf6+cXvC9AuOAPdUbHNbsuNoMABV/4iADNylpDf+crBY3URTbIWV0DrnjEj0e0mzD8t0Z4m87HFAGKAy2TTmCIvcXVLh5+y430CvwcnIXjUmAExlxwhQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762466332; c=relaxed/simple;
	bh=IeQxL0hQv2psKX/iCqbzF5FrRuqkjKqqgu+7VeFBTdE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GGGzfymywv7CWE8w9FLnFrRFNy7MXvvORwqWI3AiusMsS+O0IyaLVKgNbb19keo/elCmxhyrv+RqxKURjajfRU0efF0fKFAbsYE5zc3Y7RZYo7Oocvu2oNEj8sfL7pR95Uv5YHKv6w9fDsVOpUQjMKUoryTXW3aZ1MfnxaYFCqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=lS+VDylt; arc=fail smtp.client-ip=173.37.86.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="lS+VDylt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1904; q=dns/txt;
  s=iport01; t=1762466330; x=1763675930;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=m3KFpPdQSwdNvZVN3LgM26g6bmut3UAMjTxH/4QoeFQ=;
  b=lS+VDylticU4w3KkOfk2TRFYKmXeng9j2YE7sD8+6L54aajxcLyU+ha8
   tdSc2fPJfGgVTZR6KWfeeInyMt4xYQGuL273psRxdz/GuTWivd9YNhdGv
   uEtWO9wFQ58D34q7YnHymC8CWwmp/NlsPLPlR5KA26RNMeRlCM4jr4WfS
   0JL6BZ+xThQaTs5ryMOBx9CD0iRzj8+pXLAxSQyRUsqXrDETP2Duw5z3a
   HX7Isc3sbGor2wNSUAmbbzWdTKt1IcYdx43Pfh0NctDJwL4thlwdLmK9l
   AUoMeFXxEf9vtY+KXRxxns24Q8DI3oAcGf4KDUOZZXcr1ZTQI2p/hNvOM
   A==;
X-CSE-ConnectionGUID: 8gC8rc+tRciz3Q5N73hruw==
X-CSE-MsgGUID: utIZSKquRhiO5/IvgyQq8A==
X-IPAS-Result: =?us-ascii?q?A0A3AABUGQ1p/5MQJK1aHAEBAQEBAQcBARIBAQQEAQFlg?=
 =?us-ascii?q?RcHAQELAYFtUgeCG4hpA4RNX4h5nh2Bfw8BAQENAlEEAQGFBwKMWAImNAkOA?=
 =?us-ascii?q?QIEAQEBAQMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBDhOGXIZbAgEDEhVSE?=
 =?us-ascii?q?AIBCA44MSUCBAENDRqFVAMBAqVuAYFAAoorgXkzgQHgJoFKAYhSAYVuhHgnG?=
 =?us-ascii?q?4INgRVCgmg+hEWEE4IvBIIigQ6GJ5MiUngcA1ksAVUTFwsHBYEgQwOBCyNLB?=
 =?us-ascii?q?S0dgSQiHxgRYFRAg0kQDAZoDwaBEhlJAgICBQJAOoFoBhwGHxICAwECAjpXD?=
 =?us-ascii?q?YF3AgIEghl+gg0PikwDC209NxQbBQSBNQWWfwGBDhyCFBCTKQmQOaMvCoQco?=
 =?us-ascii?q?g0XqmuZBiKjZoUOAgQCBAUCEAEBBoFoPIFZcBWDI1EZD44tFr4ogTQCBwsBA?=
 =?us-ascii?q?QMJk2cBAQ?=
IronPort-PHdr: A9a23:6yM64hMVFcv5eiwmBSsl6nc2WUAX0o4cdiYc7p4hzrVWfbvmo9LpP
 VfU4rNmi1qaFYnY6vcRk+PNqOigQm0P55+drWoPOIJBTR4LiMga3kQgDceJBFe9LavCZC0hF
 8MEX1hgl0w=
IronPort-Data: A9a23:dLu9kKkRTYLDa8bNx35THfDo5gzLJ0RdPkR7XQ2eYbSJt1+Wr1Gzt
 xJMXjyPbqyMMGDzL9hxO9+3oUIPsZ6DmoVqSgc4riE3FFtH+JHPbTi7wugcHM8zwunrFh8PA
 xA2M4GYRCwMZiaC4E/raf658SUUOZigHtLUEPTDNj16WThqQSIgjQMLs+Mii+aEu/Dha++2k
 Y20+py31GONgWYubztNs/zb8nuDgdyr0N8mlg1mDRx0lAe2e0k9VPo3Oay3Jn3kdYhYdsbSb
 /rD1ryw4lTC9B4rDN6/+p6jGqHdauePVeQmoiM+t5mK2nCulARrukoIHKZ0hXNsttm8t4sZJ
 OOhGnCHYVxB0qXkwIzxWvTDes10FfUuFLTveRBTvSEPpqHLWyOE/hlgMK05Fd0X0bZtCiJSz
 /cZOms0Mzbc3OKs3a3uH4GAhux7RCXqFIobvnclyXTSCuwrBMmbBa7L/tRfmjw3g6iiH96HO
 JFfMmQpNUqGOkEQUrsUIMpWcOOAhXDlbzxcoVG9rqss6G+Vxwt0uFToGIaPIITbGZQEzy50o
 Erb40XLOTIDKeafyB3YtVOyif72hHPSDdd6+LqQs6QCbEeo7mgSDgAGEECwuviRlEGzQZRcJ
 lYS9y5oqrI9nHFHVfH0Wxm+5XrBtRkGVp8JS6sx6RqGzezf5APx6nU4cwOtoecO7acebTcrz
 VSO2djuAFRSXHe9EBpxKp/8QeuOBBUo
IronPort-HdrOrdr: A9a23:JlBOtq75P1x6hnHSdwPXwY6CI+orL9Y04lQ7vn2ZFiYlEfBwxv
 rPoB1E737JYW4qKQ8dcLC7VJVpQRvnhPhICPoqTMaftW7dySWVxeBZnMTfKlLbalfDH4JmpM
 Ndmu1FeaLN5DtB/IfHCWuDYqsdKbC8mcjC65a9vhJQpENRGt1dBmxCe3+m+zhNNXJ77O0CZe
 KhD6R81l2dUEVSRP6WQlMCWO/OrcDKkpXJXT4qbiRM1CC+yRmTxPrfCRa34jcyOgkj/V4lyw
 f4uj28wp/mn+Cwyxfa2WOWxY9RgsHdxtxKA9HJotQJKx334zzYJ7hJavmnhnQYseuv4FElnJ
 3nuBE7Jfl+7HvXYyWcvQbt4Q/9yzwjgkWSi2NwwEGT5PARdghKTPaptrgpNCcxLHBQ5e2U5Z
 g7m15xcaAnVS8o0h6NvOQgHCsa5nZc6UBS4tL7yUYvEbf3rNRq3NEiFIQ/KuZbIMr3hbpXYt
 VGHYXS4u1bfkidaG2ctm5zwMa0VnB2BRueRFMe0/blmQS+sUoJh3fw/vZv1Uso5dY4Ud1J9u
 7EOqNnmPVHSdIXd7t0AKMETdGsAmLATBrQOCbKSG6XWJ0vKjbIsdr68b817OaldNgBy4Yzgo
 3IVBdduXQpc0zjBMWS1NlA8wzLQm+6QTPxo/suqqRRq/n5Xv7mICeDQFchn4+ppOgeGNTSX7
 KpNJdfE5bYXCLT8EZyrnvDsrVpWA4juZcuy6MGsnq107b2FrE=
X-Talos-CUID: =?us-ascii?q?9a23=3ACNV0Empa43pt8piBTNG6K6vmUZAqWS3HxzTMGUS?=
 =?us-ascii?q?5Gz1QFZvKEl+K5bwxxg=3D=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3AuJ0BvwwgNx5o86C7T1005CUMktyaqLmyKXI2sow?=
 =?us-ascii?q?bgcmFEnE3GimSnQ2uEqZyfw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-10.cisco.com ([173.36.16.147])
  by rcdn-iport-3.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 06 Nov 2025 21:57:41 +0000
Received: from alln-opgw-4.cisco.com (alln-opgw-4.cisco.com [173.37.147.252])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-10.cisco.com (Postfix) with ESMTPS id 511BB18000242
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 21:57:41 +0000 (GMT)
X-CSE-ConnectionGUID: o+oHBFSITviuF0bcI3G48A==
X-CSE-MsgGUID: FxGnbgQfR2G3Ja+aaa+EMQ==
Authentication-Results: alln-opgw-4.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.19,285,1754956800"; 
   d="scan'208";a="57399294"
Received: from mail-ch4pr07cu00100.outbound.protection.outlook.com (HELO CH4PR07CU001.outbound.protection.outlook.com) ([40.93.20.96])
  by alln-opgw-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 06 Nov 2025 21:57:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IriSb3joj8rrg2WObMUrFnUVUf6QrjSaKPKDkxmb1O9IHauVomzSQt/Z/Ai0LewgEPfYipRXBBKRqigscbTDeu/k72MTmND6IMPG1HuQL1sJMV4hUvLd5Z2StUIoE5cAqLUd4bhZBAuhxkLFUAzYBpeqZ2QCUJeiffDsz9YqBhG6j+ltSOti7qBm/7539uUYT/auG/ngk70zhSqz88N38NeUragq/3PGu4vKM5jq0T2YG5c9MeRGuXIqC1a3XpIMTeoAU76nu7unaT7XM6hbfBcwEQesbAOirOoUeWxyE2n8uwOp4Awzras4F2eAUyfn35YFEqeJwP+Mowkqbmi1PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m3KFpPdQSwdNvZVN3LgM26g6bmut3UAMjTxH/4QoeFQ=;
 b=gZbBnBJyNP7fb8RR6VaTPycdIxbsvdTdLsENLv9SxzqF3GjMNpTzLKRyXnCrF1PzFtVR61RgsLr3S9+Nu3SBM4aYhSsedgz33IWRYsUcFV15acjCVoW6NwPtYv8Fyl1Shh6VTsGXUc96ZOhpdALmpKFs3JbTUIdSNcb8xWS1K25MBt9MZMu6+z2W4obcXfE7ZyLUDr7mi6IbdttuZdtmfCf/brTwr047svsBznyPlo5lY46ruSqlxB8ptacYr27uCLVX9n0opMemA289t5arakjuDoEo4Vcnw2Ht/Xau+Lmxq/qrQabSwMjJFb44sjK5L//eW7zZXhd6GF3UNFU2Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by SJ5PPF8622363CD.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::83c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Thu, 6 Nov
 2025 21:57:38 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%4]) with mapi id 15.20.9298.006; Thu, 6 Nov 2025
 21:57:38 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Hannes Reinecke <hare@kernel.org>, "Martin K. Petersen"
	<martin.petersen@oracle.com>
CC: James Bottomley <james.bottomley@hansenpartnership.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sesidhar Baddela
 (sebaddel)" <sebaddel@cisco.com>, "Satish Kharat (satishkh)"
	<satishkh@cisco.com>
Subject: RE: [PATCH 2/4] fnic: correctly initialize 'fnic->name'
Thread-Topic: [PATCH 2/4] fnic: correctly initialize 'fnic->name'
Thread-Index: AQHcTXJySJSbNuzO2U69VTaKwnipn7TmNZSw
Date: Thu, 6 Nov 2025 21:57:38 +0000
Message-ID:
 <SJ0PR11MB589647A57566E9FD234B0DAEC3C2A@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20251104100424.8215-1-hare@kernel.org>
 <20251104100424.8215-3-hare@kernel.org>
In-Reply-To: <20251104100424.8215-3-hare@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Enabled=True;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_SiteId=5ae1af62-9505-4097-a69a-c1553ef7840e;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_SetDate=2025-11-06T21:56:42.0000000Z;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Name=Cisco
 Confidential;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_ContentBits=3;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Method=Standard
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|SJ5PPF8622363CD:EE_
x-ms-office365-filtering-correlation-id: 6cad98c3-7f7e-4af0-6593-08de1d7f805e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-7?B?QXZ6Ny9walZmV2VibXE4L3kzcmM1MmZLaldLbFYxTHpYTEI3RXE1UlpLcUpK?=
 =?utf-7?B?Qk53L1orLTNiSHRiaml6SjhkVFQ5S1g4VnJrdjAxd0UydWJaKy1rWHU0Z2Fq?=
 =?utf-7?B?V0hHbistdks0ZistbTVxRGNIM2JTWm8wUnJTdldGMjRMZk44a0VPWkhaV3ln?=
 =?utf-7?B?a1kwdmJnMTRMTEtEQWVsTGgzTko3dTh5NkVYL2xJRE53QWNvYjVDakZUNGds?=
 =?utf-7?B?cURoNG1MVUlGcCstLzFxc3BhV2lYcmV2NkhsaUczRHVUcTB6bmc3YzNNVDU=?=
 =?utf-7?B?VCstSkFSMU9RTC9WNEVRY2RFT1pkd09teHdLUnRFN1BjcG5GaFNzaGRvNS9H?=
 =?utf-7?B?cC82NHQ3a3lRVy9QMnl4MUhYbzZMaUdrTWN0cDFPVVIyNi82SlA4UkZOcFZK?=
 =?utf-7?B?UzJHQkNHKy1EcTF2eEhEejhDdzErLWxLMHJ6NTVQZ2FRSGJUMGNVejFEOTFk?=
 =?utf-7?B?d1hkWGZLQ0N6TERIOGkzTVRSaVdTRm5STWFMcG9EaXE2REpLeFNWcTA4SlVp?=
 =?utf-7?B?N0hLMFd1YXpFcUFrZk1PMW1id3ZhSFJEZ2EwYkNrQjk3Q0czZHhPWFNiL2gz?=
 =?utf-7?B?U3NLUCstNWJyOHpGYUw2cXFVVWtuZlFzZy95QkJ1eWhXdnpjSi91TXIwblZR?=
 =?utf-7?B?VTlpMFJvb2I2cGJDbnNNSWkzbnZoUU5KcTBhSnUrLVZKWkI2TlptZ08zQVVE?=
 =?utf-7?B?R1Z4NlhFbHBlZTZ0bkJHUE1GV2xSaGx3V0JkUHVDYWh4QTZ1SHg5YmlyRXBY?=
 =?utf-7?B?Ykg5UUNTeldRS2dBZEZuTVYrLThQZ3BDUmF4L3QyMjB5QVVsWTBVelk5eXlC?=
 =?utf-7?B?MDVDcDhyOGpZUTFDYXdncHllQnJqczkvb2tSUHJiZWdnOExURTUxS3FtYTho?=
 =?utf-7?B?VFVaMTkycystajF2THhRaFByVDZrbzlYeEZBUGVSQkRFeEFUL2pmZ0gwR3gy?=
 =?utf-7?B?eVZoRldzNHZoMWJwcGNVY1JDRjdxMlVxRWk5MW5iU3ZHZzQ0YnlTbzRoWDRK?=
 =?utf-7?B?Ky05enk2NkdUZENrYjRIL3dOU1hpVVA5MlhzckJKanI2dTFoUXJwc2dkRmpK?=
 =?utf-7?B?UkJOQ0RURG5pYVJGTmsvYzM2NWVqZWc0emtYYTAvUGhObG9pWWZORDdnRUNG?=
 =?utf-7?B?cGoyM0lKMk1BMG90d3VyRkZyZGkzVUJQRXN5Y0doZi9CYUJBOExXUDhjcE1t?=
 =?utf-7?B?WSstNXJPb3dVNlJLbERheksxNFVaYWNsZU1jQ25wOWJET3FpaGhDbURCVCst?=
 =?utf-7?B?ZDZkS1lZeVlOWFIzNXF0TWlkN2pkVXNKQzJVS0syeCstU1k1YVRMZkRUNFM5?=
 =?utf-7?B?dnc0WWR3T3A5cmE2eDBaN2hqWU9vOUZ3aHp4U2NkdkNGYnpjN1NLZjI0Z2pY?=
 =?utf-7?B?QzdMY2h4bVBPL3JoNS9RRGxrSElUWFIvSG8vUlZMMWlaTUhteDJlNTVJbEJ6?=
 =?utf-7?B?aystN3NvQ1FwOVRGUnhrd0ZlM3RYRmFLMXg1Y3UvNzYwUmRCMHd3R3pPWGhL?=
 =?utf-7?B?Snl5bi9wOXloUkJ2d1d5Z21WeFlOYWdjUGdHTzF2VE1udkMxcExlU1QrLTU=?=
 =?utf-7?B?Ky1xY2syZ1krLXk5UXd1eGo0SVI5MGdsUWVQamhPSGswRWZBREhmWjA1NVFQ?=
 =?utf-7?B?THBzYlJycWp5ajJ6UWRxNystU3pmNE5OVTh1ZjR3NWw5VzhVSTdqN3plTGhC?=
 =?utf-7?B?MkxxcistbHhUVnpjSmF5TFVEQ1ozKy02WVJlR2EwZTlhL3Rma2ZTKy1KbUtO?=
 =?utf-7?B?M1ppWGRqTk95bzc0YjgwakxPUi9rVystVUtRT0lUZ2lPeUcrLUlzaW9pd2Fh?=
 =?utf-7?B?bHB6RlFOZ2lQQ3IzNEp3d3psKy0rLXdMT0FmL0MrLTZHUnJXWE82ZGg4SXZ2?=
 =?utf-7?B?alRGM1g2bndWR2dELzdPYkVFZ3Y5eEV4b0JiZDJPZ0pMRDROTCstM0tJeGgx?=
 =?utf-7?B?V1R1dnNaSVpLS0Qxb3Z2N1ZDYmJYREEwRkFhbTc3am5HUVc0dVFKVDUweGxN?=
 =?utf-7?B?ejA1N2ZFSlBXYkJKN2NrSHFPc29hZWdHa3h4YXB3bkNpZklreWlDL2lsVHJ4?=
 =?utf-7?B?OGg4R0M4NW9NaEVCbnpkdGh4am4vcTlCc0p3dWRWODN0c3BtSk0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-7?B?aENIbjl2aW4wSWc3d1ZKUG9iWXhZbWxhOHltV3BKMkFGWnQ5a2VrU3hDWENU?=
 =?utf-7?B?SGpkV001R0krLUlsWTc4UTZuamI3d2o4MlBxSU9TOTlQeldQRXVrNnBwRUxq?=
 =?utf-7?B?RU1LUWNtVTRXeWFueWh4aFJYc3B5LzZaN3J0dllwSlM2YklzVlVvYzV2UU1t?=
 =?utf-7?B?UFR0aW4rLUtWM3krLUt6bmFKSlBHQUJTNElBMlFjN3Z1dU5aWXN1aGx4czBC?=
 =?utf-7?B?MXhNLzhsYkppYlJUQnhndDF6Y1VnUTliRlpXWE9LNTFrc25FVzFsRWNQMnNH?=
 =?utf-7?B?ZjZZSTVvallUZVQ3SXhZaTB6SUE1VkZnOHZhdm5lcXZwSzczdmNSRlkvTnNX?=
 =?utf-7?B?SlgzbFpZZEJsa205QnFvUkk1R2t5VTBBYlNNR296WXdUR3ExRk9NeExGZ0sy?=
 =?utf-7?B?Wkh5c2s2WXhwY2hDY1ZjRi9YZFRiUlVCbWx5aGJ0RUk5bmllZTZ3cllaenFX?=
 =?utf-7?B?MlN0N2E4UHl4dTBEWEdtUVZ4NEk5dW51MWhaVmxJVWZXWXpmZHhMZzVISTRk?=
 =?utf-7?B?UEVxOGMrLWI0MnR5NDZuUWJlS2ZTWDVOUjF4Q2FrYWxNWGlyTHlLUlROVlhh?=
 =?utf-7?B?aXN2RUU0VlVoZUVsdmtPUkNsM0JnZHFZaEtxdjVvYU80bVI0NFVRZCstaUJs?=
 =?utf-7?B?dlZ4UjU1amVTQWozbEhneDROZDNMMGJYdmlCNWU3NzZnZFp4eDI3U1VwSUlT?=
 =?utf-7?B?c3VFVDhqSUhwV0tvKy1JRE9MYlM4WWVEeHY2cm5qc1BYemJhaHBuazFIdWIx?=
 =?utf-7?B?QXYzWXZybkVOMUJoZnBOKy12N2YxTkwxTUsxWlZtOVdTNERKUGdlUkJRYUN1?=
 =?utf-7?B?Njg3VW54VU01WEx6YzEzRXRISmxoMHIxWm52THhZUkJSYTJGNmFpQ0pNOGx0?=
 =?utf-7?B?ZDFram1MYW9wVlFUTGtLUmtaWEdHUHFNMkd2TTBNQ3VaWk9FUVNIYVcyYlp0?=
 =?utf-7?B?eWlUN0JTT003eERRcGFuZy9USmIyQVFkM0VsVmhUWkM5SlduZmpvS3hJa1d0?=
 =?utf-7?B?eFF5UVI3b2lrYXZuTXpNVFJ5dzh5cFdTU2dWdWhmbDZheGFsN1M2STg1QzZV?=
 =?utf-7?B?MVRiRW1oR2JEYTdxTE1JcDhuYVhtUlIwVDc0TzlvcmZSU2hoKy0zRDR0amo=?=
 =?utf-7?B?ZistcVNGRTE4RUkxcjYxVE90VmlOS214UFRSOEtmRnpzcFpRZnlTSUNjdDZ1?=
 =?utf-7?B?Z2lUZXZlN1FjSlpsMHpaRjFFdXZGeWcvUjY3eXk4RjZUbExObVdEZm5xR1lT?=
 =?utf-7?B?cW5LcnowL0ZjSFg0ekJuQk9PSFJEaDVVZThFU2d4M2o4Tnh0aXBNRkdaRVRl?=
 =?utf-7?B?SGJCY0Y5Rlk1WGhiWW5CZE1wQTFKZGxFZFQrLWFLaGZKdzV1dUVSKy1UQ3dK?=
 =?utf-7?B?aHhUL3plS2ZFQmljUTJ2UTliZjA5VUF3dmlLenpPWGF0WGJqdjRzMHdyUUVY?=
 =?utf-7?B?b0lKNFBrRHNnNW50WDE1T1JOU1hqVGIwU0pLN1dCa2QxMkFXdEdHVi9HSG9H?=
 =?utf-7?B?L01WcGJxN1lPNXhWdXo1enNtV2lBeU5KZUk1WlByWXE0RystOFFxUnRzZTVX?=
 =?utf-7?B?OXNia2V2UVQ1Rk5vdnFWZjRwR2JzVnB3ajZiTmlDRFZoa3BYcTlsNWliZ2hN?=
 =?utf-7?B?VEIzZW9KbnZ5WjZ4a0R4dm41b0R4cDZ1T3hJZmc4SjhQZG0yd2RxMDQyenpY?=
 =?utf-7?B?NVFJakZJdzh3M0QxRkpWakVjT0F1L2RsR2dDMU02d1gvTXJ1bzUxVkkvYk1p?=
 =?utf-7?B?Ulg5TDl4ZXZPWHpJaE5aVUZncjJqUWZIUzA0T3QxM3oyTFVFajQwVWFWaW0w?=
 =?utf-7?B?Q0Ivc3JpTlFIWDlqcGZwdTBhd1k5N1p4ci8yRDIvSGFQSUc4MjBUNFg5T053?=
 =?utf-7?B?YU1VOHIzQzBVUlVzZ3JnSzFXSEJNKy1iYWhGR0NURlRsbFl0N3Vud1dEckpn?=
 =?utf-7?B?RGVrb1V1NUF5SXN0MHZMbXNmZHBTN04vUXhlNlJJYnJSQmtnVHVPL2I2dENI?=
 =?utf-7?B?Ky1QOXhGRFVaQUZPaEs1MnFzL0JLRE9URFlSYXMrLUpFY3E0Ky1pTlFqSlJj?=
 =?utf-7?B?WU15aFpwbistczF6cUllM0NpMistcmJEYzVaSHJlOXB4QzhWQThJUGsrLUVn?=
 =?utf-7?B?TE4yTWlKV0dObGJaZlJRRE5aSkMvUG9NZU9HU1lPdTVHZUN3Vmo4MDYxM1ZR?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cad98c3-7f7e-4af0-6593-08de1d7f805e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2025 21:57:38.4659
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g8WCrOhjkyfrsSbxD4+FDJZKf3D1n3iGBPebkXmRIsBoAOUxc+snFdbPx1Bw2I90zvOqTNxCAlas68xleCT9HA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF8622363CD
X-Outbound-SMTP-Client: 173.37.147.252, alln-opgw-4.cisco.com
X-Outbound-Node: alln-l-core-10.cisco.com


Cisco Confidential
On Tuesday, November 4, 2025 2:04 AM, Hannes Reinecke +ADw-hare+AEA-kernel.=
org+AD4- wrote:
+AD4-
+AD4- The instance name is required for setting up interrupt handlers, so
+AD4- set it early enough to avoid the request+AF8-irq() routine crashing o=
n
+AD4- duplicate or empty names.
+AD4-
+AD4- Signed-off-by: Hannes Reinecke +ADw-hare+AEA-kernel.org+AD4-
+AD4- ---
+AD4- drivers/scsi/fnic/fnic+AF8-main.c +AHw- 5 +-+----
+AD4- 1 file changed, 2 insertions(+-), 3 deletions(-)
+AD4-
+AD4- diff --git a/drivers/scsi/fnic/fnic+AF8-main.c b/drivers/scsi/fnic/fn=
ic+AF8-main.c
+AD4- index 7075a23d9229..870b265be41a 100644
+AD4- --- a/drivers/scsi/fnic/fnic+AF8-main.c
+AD4- +-+-+- b/drivers/scsi/fnic/fnic+AF8-main.c
+AD4- +AEAAQA- -575,9 +-575,6 +AEAAQA- static void fnic+AF8-scsi+AF8-init(s=
truct fnic +ACo-fnic)
+AD4- +AHs-
+AD4- struct Scsi+AF8-Host +ACo-host +AD0- fnic-+AD4-host+ADs-
+AD4-
+AD4- -     snprintf(fnic-+AD4-name, sizeof(fnic-+AD4-name) - 1, +ACIAJQ-s+=
ACU-d+ACI-, DRV+AF8-NAME,
+AD4- -                      host-+AD4-host+AF8-no)+ADs-
+AD4- -
+AD4- host-+AD4-transportt +AD0- fnic+AF8-fc+AF8-transport+ADs-
+AD4- +AH0-
+AD4-
+AD4- +AEAAQA- -732,6 +-729,8 +AEAAQA- static int fnic+AF8-probe(struct pci=
+AF8-dev +ACo-pdev, const struct pci+AF8-device+AF8-id +ACo-ent)
+AD4-
+AD4- fnic-+AD4-pdev +AD0- pdev+ADs-
+AD4- fnic-+AD4-fnic+AF8-num +AD0- fnic+AF8-id+ADs-
+AD4- +-     snprintf(fnic-+AD4-name, sizeof(fnic-+AD4-name) - 1, +ACIAJQ-s=
+ACU-d+ACI-, DRV+AF8-NAME,
+AD4- +-              fnic-+AD4-fnic+AF8-num)+ADs-
+AD4-
+AD4- /+ACo- Find model name from PCIe subsys ID +ACo-/
+AD4- if (fnic+AF8-get+AF8-desc+AF8-by+AF8-devid(pdev, +ACY-desc, +ACY-subs=
ys+AF8-desc) +AD0APQ- 0) +AHs-
+AD4- --
+AD4- 2.43.0
+AD4-
+AD4-

Thanks for this change, Hannes. It looks good.

Reviewed-by: Karan Tilak Kumar +ADw-kartilak+AEA-cisco.com+AD4-

Regards,
Karan
