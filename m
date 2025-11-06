Received: from rcdn-iport-9.cisco.com (rcdn-iport-9.cisco.com [173.37.86.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39D22E543B
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 22:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.86.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762467053; cv=fail; b=dFYkuddbbpFLv9+gICo1ps9Y+g2N9BW3DEleV59ZMZ4KApbqmbfRl7p1FrctlNcrLCEJsk4pSpupqRQo5J9RHVdloYSL5hehNDa35J7UiTD5XfE500PfBaUwlkNwuvE0vukJovQntk2MBOEslrO+0ThEAqv6pfAylStV8hQSdBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762467053; c=relaxed/simple;
	bh=6PmsHFF59zpWL5ooBvGdouP2YUUSGXeoncjv/cYyyUs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=B4gzOTrU7Qr3ZvNlVlINpt0GYPyMx1dVxSygqIH3BhDZ41pA2+RKZoiAXZVCX1yRPcdkkhmfLoryfcvRzyiAHsFg317hh7YGCiJuHHp6TC++2ybq8w4ArMAWwEpW/6+G/4KFcKhtbeqvPUnoHnxs6LHiLrIGgxWrEj7J+52EtD0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=O7SV6cDt; arc=fail smtp.client-ip=173.37.86.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="O7SV6cDt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=5324; q=dns/txt;
  s=iport01; t=1762467051; x=1763676651;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=k4N9RzaOkUKgmnqgaRKaujOEJnofrQqymaJYPKa7Lbg=;
  b=O7SV6cDtQxskP/xaZYIW1mPe0qX4KBNVeXp5uk2eKaOSebYuZOcVwFh8
   3mBVrj8srMt++lcU1Ys9zYx3ZlC/oZi3TkJlbZMRuvWEU+gOX8hmOhtTM
   0sYQUxJO3LfNkJf035m4CHsX/oFwx3yJLGdPbZOQAUUAbjS93meZFoLc7
   aadJi7mO9BX1aXO2v7jQ+s6MEOIMiA/aTxJbwryAa1xomXCQrO+AOdvjA
   7ZlrQqrG3W0gVU8vTF2QHpfRx+GNzNC3Bk6c4nuqFvfIrEonjza7Pdm1N
   DCTZcQHxRO7la6DwzVnPjTnPpUUW5u0izyy5aQ25PCeQj4WAoj6136/Yt
   Q==;
X-CSE-ConnectionGUID: ZrYcV/3CQl6ucgM8QNallw==
X-CSE-MsgGUID: LxR+8V7STzabe7PRN3IRXA==
X-IPAS-Result: =?us-ascii?q?A0CrBAC5Gw1p/4sQJK1aHgE8DAILOoErgW5SB4IbiGkDh?=
 =?us-ascii?q?SyIeZ4dFIFrDwEBAQ0CUQQBAYUHAoxYAiY0CQ4BAgQBAQEBAwIDAQEBAQEBA?=
 =?us-ascii?q?QEBAQELAQEFAQEBAgEHBYEOE4ZchlsCAQMSZxACAQgOODElAgQBDQ0ahVQDA?=
 =?us-ascii?q?QKlfAGBQAKKK4IsgQHgJoFKiFMBhW6EeCcbgg2BFAFCgmg+hCobhBOCLwSCI?=
 =?us-ascii?q?oEOhieTIlJ4HANZLAFVExcLBwWBIEMDgQsjSwUtHYEkIh8YEWBUQINJEAwGa?=
 =?us-ascii?q?A8GgRIZSQICAgUCQDqBaAYcBh8SAgMBAgI6Vw2BdwICBIIZfoIND4pMAwttP?=
 =?us-ascii?q?TcUGwUEgTUFlwAxXhMveYEDZJJPFAcCQJMyn1kKhByiDReqa5kGIqNmhQ4CB?=
 =?us-ascii?q?AIEBQIQAQEGgWg8gVlwFYMjURkPji0WvieBNAIHCwEBAwmTZwEB?=
IronPort-PHdr: A9a23:sSMZpBITShJH1yBGBtmcuVQyDhhOgF28FgcR7pxijKpBbeH4uZ/jJ
 0fYo/5qiQyBUYba7qdcgvHN++D7WGMG6Iqcqn1KbpFWVhEEhMlX1wwtCcKIEwv6edbhbjcxG
 4JJU1oNwg==
IronPort-Data: A9a23:dJe8QKxhLCkLV+NJSth6t+d9xyrEfRIJ4+MujC+fZmUNrF6WrkVWm
 jAeDTrTbviMZ2L9KowlYI3npBsE78Dcm99jHQE9/lhgHilAwSbn6Xt1DatR0we6dJCroJdPt
 p1GAjX4BJlqCCea/VH1buSJQUBUjcmgXqD7BPPPJhd/TAplTDZJoR94kobVuKYw6TSCK13L4
 IKaT/H3Ygf/hmctajxMscpvlTs21BjMkGJA1rABTagjUG/2zxE9EJ8ZLKetGHr0KqE8NvK6X
 evK0Iai9Wrf+Ro3Yvv9+losWhRXKlJ6FVHmZkt+A8BOsDAbzsAB+vpT2M4nVKtio27hc+adZ
 zl6ncfYpQ8BZsUgkQmGOvVSO3kW0aZuoNcrLZUj2CCe5xWuTpfi/xlhJHMsDIYmvb1cOGUQ6
 PcXDWA0SBmHg/3jldpXSsE07igiBMDvOIVavjRryivUSK58B5vCWK7No9Rf2V/chOgXQq2YP
 JRfMGQpNU+RC/FMEg9/5JYWn+6ymnj7ej5wo1OOrq1x6G/WpOB0+OS3aYOFJ43RGK25mG68t
 liFr1qmOS0IPdaSlgK/1CmNvN/myHaTtIU6UefQGuRRqFmSwHEDTQYdTlqTv/a0kAi9VshZJ
 khS/TAhxZXe72SiSt37Ghn9q3mes1tEAZxbEvYx70eGza+8DxulO1XohwVpMbQOnMQ3Xjctk
 FSOmrvU6fZH6tV5lVr1Gm+okA6P
IronPort-HdrOrdr: A9a23:AW6GBKkrV5LwKSkrjX+EqoCX1DHpDfNqiWdD5ihNYBxZY6Wkfp
 +V7ZcmPE7P6Ar5BktApTnZAtj/fZq9z/JICYl4B8bFYOCUghrYEGgE1/qt/9SAIVywygcz79
 YbT0ETMqyVMbE+t7eE3ODaKadg/DDkytHUuQ629R4EJm8aCdAE0+46MHfmLqQcfng+OXNNLu
 vm2iMxnUvZRZ14VLXdOlA1G8L4i5ngkpXgbRQaBxghxjWvoFqTgoLSIlyz5DtbdylA74sD3A
 H+/jAR4J/Nj9iLjjvnk0PD5ZVfn9XsjvFZAtaXt8QTIjLwzi61eYVIQdS5zXMIidDqzGxvvM
 jHoh8mMcg2wWjWZHuJrRzk3BSl+Coy6kXl1USTjRLY0I7ErXMBeo98bLBiA1zkAnkbzZdBOW
 VwrjukXq9sfFf9deLGloD1vl9R5xGJSDEZ4J4uZjRkIPgjgflq3MwiFIc/KuZcIMo8g7pXSt
 WHAKznlYRrWELfYHbDsmZ1xtuwGnw1AxedW0AH/teYyj5MgRlCvgElLeEk7z89HagGOtJ5zv
 WBNr4tmKBFT8cQY644DOAdQdGvAmiIRR7XKmqdLVnuCalCYhv22tLKyaRw4PvvdI0DzZM0lp
 iEWFREtXQqc0arDcGVxpVE/h3EXW34VzXwzcNV4YR/p9THNffWGDzGTEprn9qrov0ZDMGeU/
 GvOIhOC/umNmfqEZYh5Xy2Z3CTEwhpbCQ4gKdNZ7vVmLO/FmTDjJ2uTMru
X-Talos-CUID: 9a23:uNsbj281bgsRElqMD8eVv3wOK8sbNSb29XOOPkS3LDZQbrSRTUDFrQ==
X-Talos-MUID: 9a23:F/rUIQl2TWWlzKqQRAy9dnpGJP0rs5rxM3wfmJ8L5PG+E3dRAQe02WE=
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-02.cisco.com ([173.36.16.139])
  by rcdn-iport-9.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 06 Nov 2025 22:09:43 +0000
Received: from alln-opgw-3.cisco.com (alln-opgw-3.cisco.com [173.37.147.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-02.cisco.com (Postfix) with ESMTPS id A8E1C18000174
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 22:09:42 +0000 (GMT)
X-CSE-ConnectionGUID: UPqGeKBcRwybAzsziVcG9w==
X-CSE-MsgGUID: j1tLJLCPT4WhROVmOQzbqQ==
Authentication-Results: alln-opgw-3.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.19,285,1754956800"; 
   d="scan'208";a="35866968"
Received: from mail-byapr08cu00300.outbound.protection.outlook.com (HELO BYAPR08CU003.outbound.protection.outlook.com) ([40.93.1.104])
  by alln-opgw-3.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 06 Nov 2025 22:09:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t299rT9cdW1MkeMcUZwNAyGyDXaNPri5+QGtAZbr8HMsAz523OIxQA+d0CNYWQQB96fYAGvcNyMX/Bqkm6+GudJAVC9Poz2id+AvCotO5X4wxw4YWm8CM45Hl6a1bw4FVeJK/CURZAwSwpGqzOMqVssDnSta+3vBsTA3S7MwrrmkafrIXMN1AvpivM98FROkFvHRWKV53cVEmY3oD/EhyKFZ5mlPSAJ6SuLxcHm2R5cLoz9CeouiTWQRvxqWQWKlWDXwDrOieSqo5gmajfM8FggkRoCPtzQJDLVDyHpah+7nD2eVG1oj//BRiO7dtjRAqw5eK6f9z7HFC/kd5tV0NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k4N9RzaOkUKgmnqgaRKaujOEJnofrQqymaJYPKa7Lbg=;
 b=ibXIIy/LTS62h6XFo89Hbsmp49yrGGnjS9Sp5HkNUoEydbOKoRKkwN648A0h82H6SCLipNlQ409D+IH/IXXVQE5x0bxnq7JtFPz7/WzIDnrozPPPxwOQEpwwr5N8CL7fhTS92NC0mAKHobmGsGqwa3T5+9kQC8M4qMmtj8/6YbkQo/oLkwuRjUAKMCw4aICGlKMqkSmsXhQP4rGmQS+74dWdbdISCgmergDBeCfiTs+g2FzmZcz1CN/qrEjerV4bqy4nkuig+JLIjzaWnXoidzuKZdFOSZSXwXIII8dlTixPXdexekJRl6XMtUZ217QX6xNFJPCOA9igy3wgM0K2HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by CY5PR11MB6367.namprd11.prod.outlook.com (2603:10b6:930:39::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Thu, 6 Nov
 2025 22:09:40 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%4]) with mapi id 15.20.9298.006; Thu, 6 Nov 2025
 22:09:40 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Hannes Reinecke <hare@kernel.org>, "Martin K. Petersen"
	<martin.petersen@oracle.com>
CC: James Bottomley <james.bottomley@hansenpartnership.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sesidhar Baddela
 (sebaddel)" <sebaddel@cisco.com>, "Satish Kharat (satishkh)"
	<satishkh@cisco.com>
Subject: RE: [PATCH 4/4] fnic: make interrupt mode configurable
Thread-Topic: [PATCH 4/4] fnic: make interrupt mode configurable
Thread-Index: AQHcTXJy2FynwvhbtEuofvwLS32KDLTmNqmA
Date: Thu, 6 Nov 2025 22:09:40 +0000
Message-ID:
 <SJ0PR11MB5896BDD3102F17EA15356C95C3C2A@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20251104100424.8215-1-hare@kernel.org>
 <20251104100424.8215-5-hare@kernel.org>
In-Reply-To: <20251104100424.8215-5-hare@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Enabled=True;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_SiteId=5ae1af62-9505-4097-a69a-c1553ef7840e;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_SetDate=2025-11-06T22:00:35.0000000Z;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Name=Cisco
 Confidential;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_ContentBits=3;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Method=Standard
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|CY5PR11MB6367:EE_
x-ms-office365-filtering-correlation-id: c74612cd-fff9-49c2-383e-08de1d812e93
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-7?B?d3ZsTVE5V0l5UDd5MEc2Q0toYXFyeEFlMDRzYjBCRGlzdVVWNkJpbVFtUWdx?=
 =?utf-7?B?S3BZNVNvd2xmSFJQWkFEcEc4aXpZdmhJc2YrLXQxT3l5S3VpdDFGTUczMVdh?=
 =?utf-7?B?bkZCdmpLQ2tmL2s4WEFoSi82a1QwNXRzV0JBcXhmM1hZbmlxZzlVVGF3aGdv?=
 =?utf-7?B?T3hjSGEwcml5ZkpBblJ1OWhhaWxhelZyWkc0em1zYkdJSDVjV3RXa2FwYm9I?=
 =?utf-7?B?a1l1Ky1INEJBN09IMjIyVS8rLWJqV08xaW5OKy1xWktEZERwT00zSUorLUZx?=
 =?utf-7?B?QVNyVnFCVjNqOFBEdHR5L0NJclVkN0VQSXV1L2YrLU96c21IZFVQN0VRSVo3?=
 =?utf-7?B?aEI3RnlGRkNHOVl0NWszaldCMERZa3VyOGtITGhoS0EwaHNZb1hZVVorLWx1?=
 =?utf-7?B?ZEE2TnRveUg4U1ZkUUZhSU8xb203U3pHR25UTS9ZcVVMQmJSa1B2WTBmZ2xJ?=
 =?utf-7?B?U0ZUL2YvTXJIUk96SEg3QmloemFZN3lFOEx3MFRPTjZuQUQ0U1RzalZtY0tz?=
 =?utf-7?B?SlNFVEdjKy1SbVZvTHhDT3FIZmpKYmxFcm5KdXh5YVFROFpPVnh5RWJjSlU=?=
 =?utf-7?B?MSstUjhlYW1GZG5iYUFsUE83TEVacDF5TmF0OEQ3NUJSM1dCMDBReEJFUE5r?=
 =?utf-7?B?NVh2TGl2NE1MT3ByaTZvaFFKYUJPcG9US1owMEZYckRoT09lZW5waUgzaExE?=
 =?utf-7?B?UE1vanZyYmxFKy1HTistazcxUkc4RmI4SHdDeXpPNVhWc2kxb3NqQUZqS1NY?=
 =?utf-7?B?cy80ck1SRXQ2Tk5yd0w2dmJDblZqOTVKTVl0R1I5NnNObXdUUWM1cWdVZmUz?=
 =?utf-7?B?cjVGNmlQZ2grLWx5QnNOMkxVMmYxcFpEZFlQdEpkaUhwa0pRMWJMbElLMmFG?=
 =?utf-7?B?RlkrLW1jNGliUVhyWUxYMElIdnJXZzhxWXBLZHhWdVlzd2FtUm5xaDZUenBG?=
 =?utf-7?B?d1F1QXlIL0pPNGdlUVNVcmVsZ3hGdWpMNnF0cE13N1JNeVp4ZENielRpS0M=?=
 =?utf-7?B?Ky1mZWZCWmlZa1dKVS9USUNvbFZKVmpUdGFCcUVHbjlVcU1ldk9wUFJ0aTNo?=
 =?utf-7?B?M2ozRktDYVRkUkxNRVFHV0JsWkd3VWtVWlZKRVhuRnp5M1RQcndFRjhPQTJs?=
 =?utf-7?B?QUN1S2ExV09MdmtLSzVUS1lLQWFwanpSdUdRTlVYRlh4RXpOdUR6QXRBdjRp?=
 =?utf-7?B?bXB2NkkrLW9uaWJFcHE5THdQZHdBTEFkc1l5NE5EaDliM2VOV1lIbld0QVJW?=
 =?utf-7?B?TDNZZzM1ZHVsZjFadU9XUWczOXd1bHdNSlBFREQxRE9laUFOWE9ueDJaZnNm?=
 =?utf-7?B?QUxlanVWSWY3S0piMW5BQXVscnRmcWgzWGxXKy1WU2VSSWhaeVdUdm9sMDhG?=
 =?utf-7?B?bGpPcGlWaW1BU3QrLWhVUjFoNkZUOUpwcWh4ang4THVQWWh2cHZkSmVTZnA0?=
 =?utf-7?B?ZDhXc01uejNxKy1hT1NxcFd2RkZhZXJLdTN1ZlVCTjJtOHNTMC9jRGkyQ0pj?=
 =?utf-7?B?cW9OdDVPVmx5b1lYVkZDaUFGTjhXYzNDNHJ0RnVKKy1LZGpmMkZzakMyZVdR?=
 =?utf-7?B?UXMrLVJ3OHF6cEF2TXJ2V2NBaGNyNURFSUhCbjllcnJVRCstbU0rLTBGRHVj?=
 =?utf-7?B?dlZhZHNaZWhMMmZvNllSdzRDbnpraVk4ajFrVnNJZjl1ZGs2VWZFTEtzR1Bm?=
 =?utf-7?B?eElYN0xRS1dEWXZEQXpIZzZ5OXBrUm9qd2hZZ01ib0JxNWpYT0dxaFRGWGp3?=
 =?utf-7?B?S0lwNS84Z1JQdU1DQ2dRRnczNnlkbjR5UllFbXIrLW1PcldYamJyRzAwQmlH?=
 =?utf-7?B?SlRYMWxzd0ZxSHE3eVQ3YWlmeHBacHRnUXNmYmNIN2NCQThsa0RIRlVkNVoz?=
 =?utf-7?B?SjZqQm9WTUNwU1BiWTFvdkpQMDFycVVxYUNURy9VNnZwVUJ5TGZmdjM0d0o2?=
 =?utf-7?B?NGQyeFAyM1Y2YTgya3VqZ0FBOHgxUEo5cjFlN0NQR2w4MFpXZUd3TEExMHV1?=
 =?utf-7?B?anhZcTl4WXFJaWhJWTFZRnBVTXlsNDl3cVJaN2xRSXhJYUM0dVhYaEthbS9G?=
 =?utf-7?B?bE1uRzM0Mmc5blFGNW9lRWVoRXJmenFKbFR5THhndA==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-7?B?RHhMejl4Ky1UbkltRDVWdVlpYzVxcFVMMWRYeEJqVEY4eXJTcWpqTWpTclMx?=
 =?utf-7?B?U2hlNDc1YzRaUTd4ODRtM0RIbmdXL3h5OHdaQ0JNd01NTVR2WExQYUhWRkVa?=
 =?utf-7?B?YlZRb2VQRHMzT3Fpd1pGTmgzWlhQQ0xUVjZ3R21LcmhJMnkzdXdpUjRESWRU?=
 =?utf-7?B?YVZwVThIc3EwRTl3YystZXFJQlplM3J5Y0tYUXhnM05XSENhQWFpazJ6eWFq?=
 =?utf-7?B?RystcnpUKy1LUHc3ME5laU80R3hWQ2JqcW9rUFhZMGthVGY0NnJQWUs5SzNK?=
 =?utf-7?B?R1B0ZzhpcXRNMHVuUkp1UXhJd2lXOW4xV2lMMmNuQzdUT3p2Ky1xeU51TXQ3?=
 =?utf-7?B?YmMrLWM1alU1TlBPZnFRTEJ1cjlPZVQ2ODV6ZVlRZktIWVVrbGtBRjhEWTRN?=
 =?utf-7?B?RkFoODI4RzAwYi9GT09la3E1QSstVW9INkd6T0N5RVgzbCstV01uR2JMejZY?=
 =?utf-7?B?T3E3U3lEeEZ5bkRsQUZRVmY4T3JabmQ3a2tIaDNuR0VQaUJsWEFkQzk1eHpT?=
 =?utf-7?B?U0RRYjRsZmdiVU5jVzZTQU1HVVhESllKVDRwRlBWcDI3d3V0bGl3ek1uOE1o?=
 =?utf-7?B?L01XT09UcGlpRHJsNVphYkpmck5pYnQ3WTRGa1hyRkh1anh3WUdUNGRDaE1l?=
 =?utf-7?B?MEFremNpbmVJQXdKKy1OeistY0U3M29aOE9qanMzclQvQmtuS0piYnNIMU4=?=
 =?utf-7?B?YystbENrZm1MOHE5Yll6c1lYbGI4U3pncW1aSzRQUGdrcXRDMWUzTWluZU5r?=
 =?utf-7?B?bkhrMUN1NE9GZ0k1ekpOb0dObG5mNnBWVWV5clN0SjdobFBhcTUwaEVpbEpL?=
 =?utf-7?B?ckNCMHpxZi9TQW44bEI2R2pJaXR3Sm9BWG9qWDVUS1krLWt5T3NJcEhLbk5l?=
 =?utf-7?B?ejdEVFhGOG5qZDRDYkNtMGtETDdnbTVqZCstWmtaelJNbVZVUTRmN3QvQ0s4?=
 =?utf-7?B?RWI2RGMxVUY4cnJQZDZhenRTUkJoWEFyOVYxbjAxd2h3OERMUlRGY0FtanBK?=
 =?utf-7?B?S3dqZU4rLTJoSUJSWnphVUpVWjFaZVJFaHRXazdKeEtCTFVFTEh0eWZ6S2Ux?=
 =?utf-7?B?SzhQUTBOUjBSeTdHb052T3o4bFk5d0h4TFRCTFpJM0FOUGxlT2dmL1Nxb3Fl?=
 =?utf-7?B?b3IvVnRVcXJHVkNrUGl4Ynh5OFYxZystU3R4TVoxbkZoOUxCUjNKeVAvcmxC?=
 =?utf-7?B?L2lNUFhzSXpNZ3ZQM2UvZystZnhlWEQ0aCstT0Q4UjFJUXZ4S2V1SmYrLUt3?=
 =?utf-7?B?UVV3Q2Q3dHhuNXpLbUczKy1JOGRhUlNYZk50TVEzSnJIanNuSmxMNU5PR0RX?=
 =?utf-7?B?WU5wTEF0ZTZrU3ExWDcvV3JoR0RHdVc0OHZDaXhxN2hTMUV3RHIxRjFvWFdn?=
 =?utf-7?B?b0k5ZjVKbS9zRDd2cGJabWZ0TnRiajJlem5hc2RWMmV6cDNVZHlKSU9XTFo=?=
 =?utf-7?B?Ky01cy9KRndUd0lYbVFhc0FvNU5na1ZocGRxeVByVmRwUzRXZnpEemI2dXk5?=
 =?utf-7?B?TkxxNVdvVFJpaFYvMS8wVjhOSVBqVisteFBpSHNkVG1LVUd4UW9FRzc0UWV4?=
 =?utf-7?B?QjNjbnJYdWFGYmRkTHBQSlhiRXZIYllWNTBIbHR6WWVSWkVjQ2dXSTN2RmVK?=
 =?utf-7?B?bG1WWVhpV3R6TmxsbnhLTnNiVUtydGhVZ0oyeDNCcW5oNG9yOXZMTWNTSTBC?=
 =?utf-7?B?V0pNT3ExYVdvUGlsWWJNUWhVaHcwN3BzKy1MRUdLQVJmOWQwYVlVZlJqKy1I?=
 =?utf-7?B?MForLU9HUjhIUGM5L0RLN2tvNTRaU256UG80dEZ4YXNJWG1nTU9ONFMvMEk=?=
 =?utf-7?B?Ky1qVVNuTjZHa3JiNi82N2pTRlE2TUhOZFhQTystMmhHekZiNU5tVXRSeist?=
 =?utf-7?B?QU1iY3kwRTNzbjM5UlJ2cFJNSm55aHIyVTFiSDFIKy03NEhRb083eGcwY0ZE?=
 =?utf-7?B?OUtmVDBFTEwzRTRPNTZGN05SYldpSUdtaGU4RFdWNjMxbzJGenB6NEZ3aVA=?=
 =?utf-7?B?Ky1aZTJtcjVMRjNzTW9NY1cxWC90VGNNbkRsb3FHZmtzN3JWYmo4ckRhZ0sw?=
 =?utf-7?B?Wmd6YlJnS1duVWNSQ3ZTOEpxTUMxeWVpTUJQUDlSSHNhTThSa0c3czZjUGZp?=
 =?utf-7?B?SVpHOWdtSFVtOTF5czIrLXE3MWhXKy13azNrbEczaWJNKy0wRWhnVkk3bjRr?=
 =?utf-7?B?ZncxemdpdC85Zi9KNistU0g=?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c74612cd-fff9-49c2-383e-08de1d812e93
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2025 22:09:40.2168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LqKE5I9vrtAPCr6pZ5yIsPC0BgppgqWoQxxG9kdJt070nlvqmASty8WBPpc6Ui6kzipH359MypA42Gs3CqcKYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6367
X-Outbound-SMTP-Client: 173.37.147.251, alln-opgw-3.cisco.com
X-Outbound-Node: alln-l-core-02.cisco.com


Cisco Confidential
On Tuesday, November 4, 2025 2:04 AM, Hannes Reinecke +ADw-hare+AEA-kernel.=
org+AD4- wrote:
+AD4-
+AD4- In some environments (eg kdump) not all CPUs are online, so the MQ
+AD4- mapping might be resulting in an invalid layout. So make the interrup=
t
+AD4- mode settable via an 'fnic+AF8-intr+AF8-mode' module parameter and sw=
itch
+AD4- to INTx if the 'reset+AF8-devices' kernel parameter is specified.
+AD4-
+AD4- Signed-off-by: Hannes Reinecke +ADw-hare+AEA-kernel.org+AD4-
+AD4- ---
+AD4- drivers/scsi/fnic/fnic.h      +AHw-  2 +--
+AD4- drivers/scsi/fnic/fnic+AF8-isr.c  +AHw- 13 +-+-+-+-+-+-+-+-+-----
+AD4- drivers/scsi/fnic/fnic+AF8-main.c +AHw- 10 +-+-+-+-+-+-+-+-+--
+AD4- 3 files changed, 19 insertions(+-), 6 deletions(-)
+AD4-
+AD4- diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
+AD4- index 1199d701c3f5..c679283955e9 100644
+AD4- --- a/drivers/scsi/fnic/fnic.h
+AD4- +-+-+- b/drivers/scsi/fnic/fnic.h
+AD4- +AEAAQA- -484,7 +-484,7 +AEAAQA- extern struct workqueue+AF8-struct +=
ACo-fnic+AF8-fip+AF8-queue+ADs-
+AD4- extern const struct attribute+AF8-group +ACo-fnic+AF8-host+AF8-groups=
+AFsAXQA7-
+AD4-
+AD4- void fnic+AF8-clear+AF8-intr+AF8-mode(struct fnic +ACo-fnic)+ADs-
+AD4- -int fnic+AF8-set+AF8-intr+AF8-mode(struct fnic +ACo-fnic)+ADs-
+AD4- +-int fnic+AF8-set+AF8-intr+AF8-mode(struct fnic +ACo-fnic, unsigned =
int mode)+ADs-
+AD4- int fnic+AF8-set+AF8-intr+AF8-mode+AF8-msix(struct fnic +ACo-fnic)+AD=
s-
+AD4- void fnic+AF8-free+AF8-intr(struct fnic +ACo-fnic)+ADs-
+AD4- int fnic+AF8-request+AF8-intr(struct fnic +ACo-fnic)+ADs-
+AD4- diff --git a/drivers/scsi/fnic/fnic+AF8-isr.c b/drivers/scsi/fnic/fni=
c+AF8-isr.c
+AD4- index e16b76d537e8..b6594ad064ca 100644
+AD4- --- a/drivers/scsi/fnic/fnic+AF8-isr.c
+AD4- +-+-+- b/drivers/scsi/fnic/fnic+AF8-isr.c
+AD4- +AEAAQA- -319,20 +-319,25 +AEAAQA- int fnic+AF8-set+AF8-intr+AF8-mode=
+AF8-msix(struct fnic +ACo-fnic)
+AD4- return 1+ADs-
+AD4- +AH0-
+AD4-
+AD4- -int fnic+AF8-set+AF8-intr+AF8-mode(struct fnic +ACo-fnic)
+AD4- +-int fnic+AF8-set+AF8-intr+AF8-mode(struct fnic +ACo-fnic, unsigned =
int intr+AF8-mode)
+AD4- +AHs-
+AD4- int ret+AF8-status +AD0- 0+ADs-
+AD4-
+AD4- /+ACo-
+AD4- +ACo- Set interrupt mode (INTx, MSI, MSI-X) depending
+AD4- +ACo- system capabilities.
+AD4- -      +ACo-
+AD4- +-      +ACo-/
+AD4- +-     if (intr+AF8-mode +ACEAPQ- VNIC+AF8-DEV+AF8-INTR+AF8-MODE+AF8-=
MSIX)
+AD4- +-             goto try+AF8-msi+ADs-
+AD4- +-     /+ACo-
+AD4- +ACo- Try MSI-X first
+AD4- +ACo-/
+AD4- ret+AF8-status +AD0- fnic+AF8-set+AF8-intr+AF8-mode+AF8-msix(fnic)+AD=
s-
+AD4- if (ret+AF8-status +AD0APQ- 0)
+AD4- return ret+AF8-status+ADs-
+AD4- -
+AD4- +-try+AF8-msi:
+AD4- +-     if (intr+AF8-mode +ACEAPQ- VNIC+AF8-DEV+AF8-INTR+AF8-MODE+AF8-=
MSI)
+AD4- +-             goto try+AF8-intx+ADs-
+AD4- /+ACo-
+AD4- +ACo- Next try MSI
+AD4- +ACo- We need 1 RQ, 1 WQ, 1 WQ+AF8-COPY, 3 CQs, and 1 INTR
+AD4- +AEAAQA- -358,7 +-363,7 +AEAAQA- int fnic+AF8-set+AF8-intr+AF8-mode(s=
truct fnic +ACo-fnic)
+AD4-
+AD4- return 0+ADs-
+AD4- +AH0-
+AD4- -
+AD4- +-try+AF8-intx:
+AD4- /+ACo-
+AD4- +ACo- Next try INTx
+AD4- +ACo- We need 1 RQ, 1 WQ, 1 WQ+AF8-COPY, 3 CQs, and 3 INTRs
+AD4- diff --git a/drivers/scsi/fnic/fnic+AF8-main.c b/drivers/scsi/fnic/fn=
ic+AF8-main.c
+AD4- index 870b265be41a..4bdd55958f59 100644
+AD4- --- a/drivers/scsi/fnic/fnic+AF8-main.c
+AD4- +-+-+- b/drivers/scsi/fnic/fnic+AF8-main.c
+AD4- +AEAAQA- -97,6 +-97,10 +AEAAQA- module+AF8-param(pc+AF8-rscn+AF8-hand=
ling+AF8-feature+AF8-flag, uint, 0644)+ADs-
+AD4- MODULE+AF8-PARM+AF8-DESC(pc+AF8-rscn+AF8-handling+AF8-feature+AF8-fla=
g,
+AD4- +ACI-PCRSCN handling (0 for none. 1 to handle PCRSCN (default))+ACI-)=
+ADs-
+AD4-
+AD4- +-static unsigned int fnic+AF8-intr+AF8-mode +AD0- VNIC+AF8-DEV+AF8-I=
NTR+AF8-MODE+AF8-MSIX+ADs-
+AD4- +-module+AF8-param(fnic+AF8-intr+AF8-mode, uint, S+AF8-IRUGO +AHw- S+=
AF8-IWUSR)+ADs-
+AD4- +-MODULE+AF8-PARM+AF8-DESC(fnic+AF8-intr+AF8-mode, +ACI-Interrupt mod=
e, 1 +AD0- INTx, 2 +AD0- MSI, 3 +AD0- MSIx (default: 3)+ACI-)+ADs-

Based on fnic team's review: there is a way to choose the interrupt mode us=
ing the UCS management platform.
We do not want to expose this as a module parameter.

+AD4- struct workqueue+AF8-struct +ACo-reset+AF8-fnic+AF8-work+AF8-queue+AD=
s-
+AD4- struct workqueue+AF8-struct +ACo-fnic+AF8-fip+AF8-queue+ADs-
+AD4-
+AD4- +AEAAQA- -869,7 +-873,11 +AEAAQA- static int fnic+AF8-probe(struct pc=
i+AF8-dev +ACo-pdev, const struct pci+AF8-device+AF8-id +ACo-ent)
+AD4-
+AD4- fnic+AF8-get+AF8-res+AF8-counts(fnic)+ADs-
+AD4-
+AD4- -     err +AD0- fnic+AF8-set+AF8-intr+AF8-mode(fnic)+ADs-
+AD4- +-     /+ACo- Override interrupt selection during kdump +ACo-/
+AD4- +-     if (reset+AF8-devices)
+AD4- +-             fnic+AF8-intr+AF8-mode +AD0- VNIC+AF8-DEV+AF8-INTR+AF8=
-MODE+AF8-INTX+ADs-
+AD4- +-
+AD4- +-     err +AD0- fnic+AF8-set+AF8-intr+AF8-mode(fnic, fnic+AF8-intr+A=
F8-mode)+ADs-
+AD4- if (err) +AHs-
+AD4- dev+AF8-err(+ACY-fnic-+AD4-pdev-+AD4-dev, +ACI-Failed to set intr mod=
e, +ACI-
+AD4- +ACI-aborting.+AFw-n+ACI-)+ADs-
+AD4- --
+AD4- 2.43.0
+AD4-
+AD4-

Thanks for these changes, Hannes.
For the other changes in this patch, I will need to test and get back to yo=
u.

Regards,
Karan
