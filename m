Received: from rcdn-iport-5.cisco.com (rcdn-iport-5.cisco.com [173.37.86.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78ABF301022
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 21:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.86.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762466239; cv=fail; b=GR0qTBbjxu0C1yfANTASLrPDkJ/PbHuUtPk0GO8vjvDUOzwFqc/GX5Sx280XKL0C8zKGl/RUQukHeXnRVB8MCE3QAk1ttFMQYKhT1UVoI6VMGGgC2OAbTN/+Hvb+e7QHLLjUyqAsOeLYHBGSrH0EDEE+VtvsvlJr+Z5XO5NVcHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762466239; c=relaxed/simple;
	bh=0bpHnzoZ4rMHru/4WQOpCjIo1FmvIhvBU58p/AtOQXQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dhFTBtsDB+1YCLiygDbFVIRAjcAzWGFcGiam5mAVLBleaFdfes0StD7iY+1rrPegsJfmbr2RXFjtzYwgF4NybIRKpAQF9Zo6/gHRuN0MRLWuIBBKtWKO56zd3NjfPgd8W7py/R0GTncC5YiwAofcmqJybtKozwvarNGh2sTayfc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=E8Pa61P9; arc=fail smtp.client-ip=173.37.86.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="E8Pa61P9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1645; q=dns/txt;
  s=iport01; t=1762466236; x=1763675836;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O17Knt/zBhbtN72RRXjRR4uoSZ8g79c7PuIladurESs=;
  b=E8Pa61P91nHAFYDd3t4qczErkKbn5tz2KXRpcQ3yAE9OUm42Qh3lIfcu
   iualbkFdRT73VzdYYgEFpHF6OaCjrxvq9bexc0ADyjvjlCWB8+R/qKdQg
   4MPxKwHErocGUyTGnO/oMR0v3Bmqb5zMSjUdPqbPspXLJ/GeYv1IVccH0
   MeYzYhyseEu2b1ZpdKjRQdTM6bVXcq0fyZw6eh7PxWDhhh89RbetsOXgg
   Qt/MB+zMs7qM9wZ1ps7efPUIDaFdNk1FC/9Xboq81rlS+V0t/HiQeBZ4k
   qMogVnuSffk0Yg32KsTtVhSl+YlJZZXt9re3OLRmvnevBHOBcfvdmvJpm
   w==;
X-CSE-ConnectionGUID: i7X5xrmTSYCEtuKDwK9Lmg==
X-CSE-MsgGUID: 8y+fbGfiTQ2pGBP+Nq2nWA==
X-IPAS-Result: =?us-ascii?q?A0A3AADjGA1p/48QJK1aHAEBAQEBAQcBARIBAQQEAQFlg?=
 =?us-ascii?q?RcHAQELAYFtUgeCG4hpA4RNX4ZYoD6Bfw8BAQENAlEEAQGFBwKMWAImNAkOA?=
 =?us-ascii?q?QIEAQEBAQMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBDhOGXIZbAgEDEmcQA?=
 =?us-ascii?q?gEIDjgxJQIEAQ0NGoVUAwECpgABgUACiiuCLIEB4CaBSgGIUgGFboR4JxuCD?=
 =?us-ascii?q?YEVQoJoPoQKO4QTgi8EgiKBDoYnkyJSeBwDWSwBVRMXCwcFgSBDA4ELIw88B?=
 =?us-ascii?q?S0dgSQiHxgRYFRAg0kQDAZoDwaBEhlJAgICBQJAOoFoBhwGHxICAwECAjpXD?=
 =?us-ascii?q?YF3AgIEghl+gg0PikwDC209NxQbBQSBNQWWfwGBDhxegUaTMoNJsB8KhByiD?=
 =?us-ascii?q?Reqa5kGIqh0AgQCBAUCEAEBBoFoPIFZcBWDI1EZD44tFr4ogTQCBwsBAQMJk?=
 =?us-ascii?q?WqBfQEB?=
IronPort-PHdr: A9a23:vmEeFRDQCLt8J3XMTX6hUyQVXRdPi9zP1kY9454jjfdJaqu8usikN
 03E7vIrh1jMDs3X6PNB3vLfqLuoGXcB7pCIrG0YfdRSWgUEh8Qbk01oAMOMBUDhav+/Ryc7B
 89FElRi+hmG
IronPort-Data: A9a23:63ikDquoq9AyWGCMVSywzMGc4efnVBxfMUV32f8akzHdYApBsoF/q
 tZmKT/XOKncZmCnedwlPI+09R4FuZ7UmoU3HAdvqH9kFyoQgMeUXt7xwmUckM+xwmwvaGo9s
 q3yv/GZdJhcokf0/0nrav666yEgiclkf5KkYMbcICd9WAR4fykojBNnioYRj5Vh6TSDK1vlV
 eja/YuGaTdJ5xYuajhJsvvb9ks11BjPkGpwUmIWNKgjUGD2zxH5PLpHTYmtIn3xRJVjH+LSb
 47r0LGj82rFyAwmA9Wjn6yTWhVirmn6ZFXmZtJ+AsBOszAazsAA+v9T2Mk0NS+7vw60c+VZk
 72hg3AfpTABZcUgkMxFO/VR/roX0aduoNcrKlDn2SCfItGvn3bEm51T4E8K0YIw+7lHXHFU8
 MAjGRsgcg2gq/2VkZa+Rbw57igjBJGD0II3s3Vky3TdSP0hW52GG/uM7t5D1zB2jcdLdRrcT
 5NGMnw0MlKZPVsWZgx/5JEWxI9EglH8eidEqVacpoI84nPYy0p6172F3N/9JobQHZkOwBbAz
 o7A1zToQR8QG9Ke9QPf6l2GvqzphHn9Z6tHQdVU8dYv2jV/3Fc7DBwQSEv+uvKii2agVN9Fb
 U8Z4Cwjqe417kPDczXmdxS8pHjBulsXXMBdVrVkrgqM0aHTpQ2eAwDoUwJ8VTDvj+dvLRQC3
 V6SlNSvDjtq2IB5g1rEnltIhVte4RQoEFI=
IronPort-HdrOrdr: A9a23:czv5LqP9n4YEAcBcT4f255DYdb4zR+YMi2TDiHoBKiC9I/b5qy
 nxppUmPEfP+UgssREb9expOMG7MBXhHO1OkPgs1NCZLUfbUQqTXc5fBOTZskfd8kHFh4pgPO
 JbAtdD4b7LfBlHZKTBkXSF+r8bqbHtntHL9ILjJjVWPH1Xgspbnn5E43OgYzZLrX59dOIE/f
 Snl616jgvlU046Ku68AX4IVfXCodrkqLLKCCRtOzcXrCO1oXeN8rDVLzi0ty1yb9pI+9gf2F
 mAtza8yrSosvm9xBOZ/XTU9Y5qlNzozcYGLNCQi+AOQw+cyTqAVcBEYfmvrTo1qOag5BIBi9
 /XuSotOMx19jf4Yny1mx3wwAPtuQxeqUMKiGXoxEcLk/aJAw7SOPAxw76xtSGpsnbIiesMlJ
 6jGVjp76a/QymwxxgVrOK4Jy2C3nDE0kbK19Rjz0C2leAlGeJsRUt1xjIOLH8NcRiKmrwPAa
 1gCtrR6+1Rdk7fZ3fFvnN3yNjpRXgrGAyaK3Jy8PB9/gIm1EyR9XFoj/A3jzMF7tYwWpNE7+
 PLPuBhk6xPVNYfaeZ4CP0aScW6B2TRSVaUWVjibWjPBeUCITbAupT36LI66KWjf4EJ1oI7nN
 DEXElDvWA/dkryAYmF3YFN8BrKXGKhNA6dh/129tx8oPnxVbDrOSqMRBQnlNahuewWBonBV/
 O6KPttcrbexKvVaPB0NiHFKu5vwCMlIbgoU/4AKiaznv4=
X-Talos-CUID: 9a23:7+oVXGyhCZvadJfx1dnvBgUVRfB4YmfY8EzhCGKkFEVFV57EbVqfrfY=
X-Talos-MUID: 9a23:DzJsCwhbxhSmccsTG1kuW8MpZNYr7a6BBkExqM8elOO8dgppYTGipWHi
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-06.cisco.com ([173.36.16.143])
  by rcdn-iport-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 06 Nov 2025 21:56:07 +0000
Received: from alln-opgw-4.cisco.com (alln-opgw-4.cisco.com [173.37.147.252])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-06.cisco.com (Postfix) with ESMTPS id 4467518000116
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 21:56:07 +0000 (GMT)
X-CSE-ConnectionGUID: S8g0cavtT/i7MrC+2D0jYg==
X-CSE-MsgGUID: JkPiHm5nQ4+VANpkn3HMMw==
Authentication-Results: alln-opgw-4.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.19,285,1754956800"; 
   d="scan'208";a="57399199"
Received: from mail-bn1pr07cu00307.outbound.protection.outlook.com (HELO BN1PR07CU003.outbound.protection.outlook.com) ([40.93.12.7])
  by alln-opgw-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 06 Nov 2025 21:56:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hZbav2uOpDL6hYylojSk5Xo8rRpazLmGwH24IWTK1h6Km0kl7I8HuH2v2L4wpdLSRz5yEl9UzirO8rmxb2b391oROi5cHli8UwsbTXSMmMgEgYJ7+Ss21EhMj1jPZ/24px7Q59GZaksOr6E1XbYXE5SK2c2BulmiNsPGYcDN+9cCfqf1zrly6svb/LpNWViLDRzg6jsRd/Uf8E2IbNW6ioRIqaCeAph6/RWkCD1hL+OHgAUxWdea6whVPDl9myxVhYYYeZZfaqjuLGOKLMN6+PjyD8WFZ2FDj60ptUlmQJf1x6EWw2XOyEFY+9tkxpApyopCIvfFUfl6XhVz4FObjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O17Knt/zBhbtN72RRXjRR4uoSZ8g79c7PuIladurESs=;
 b=xlWLK6yIbiKXit37Rq17XmrFmuC8A1NllIdtFGh0HQC0VDlM376jS9QFWUMjZZqK4Z9WANeghExQfNyeL6aWcIDEaUCtFpF344Neg1IQTsSjBAKyXhwCONLFD1pfpD3G3s/3GH9R8/XODU+VyqcuqxSVwaTKAaLeD6MP9q8nfaxUyEK6mELxVKyLQkpNG/BQ6AfL0PYGZDu1I/rjDZ+UZC7dtUQ4JxZ3Sg8d9iluCJrpCfJkR84uLrUTGApqi/Dbfxz4PYqepeL8+gzdDaoTSl/Fp5srJP5BStV9lIuixLLJu873d2oJRrUbLT3J9oVapf3k5gJpryg+ddm1rkqNvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by CY8PR11MB7800.namprd11.prod.outlook.com (2603:10b6:930:72::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Thu, 6 Nov
 2025 21:56:01 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%4]) with mapi id 15.20.9298.006; Thu, 6 Nov 2025
 21:56:01 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Hannes Reinecke <hare@kernel.org>, "Martin K. Petersen"
	<martin.petersen@oracle.com>
CC: James Bottomley <james.bottomley@hansenpartnership.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sesidhar Baddela
 (sebaddel)" <sebaddel@cisco.com>, "Satish Kharat (satishkh)"
	<satishkh@cisco.com>, "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>,
	"Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>, "Arun Easi (aeasi)"
	<aeasi@cisco.com>
Subject: RE: [PATCH 1/4] fnic: use resulting interrupt mode during
 configuration
Thread-Topic: [PATCH 1/4] fnic: use resulting interrupt mode during
 configuration
Thread-Index: AQHcTXJy7fGMryEGHEKw0bgU95oVpLTmM50A
Date: Thu, 6 Nov 2025 21:56:00 +0000
Message-ID:
 <SJ0PR11MB5896CF7FF4472550302ACAE5C3C2A@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20251104100424.8215-1-hare@kernel.org>
 <20251104100424.8215-2-hare@kernel.org>
In-Reply-To: <20251104100424.8215-2-hare@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Enabled=True;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_SiteId=5ae1af62-9505-4097-a69a-c1553ef7840e;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_SetDate=2025-11-06T21:49:40.0000000Z;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Name=Cisco
 Confidential;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_ContentBits=3;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Method=Standard
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|CY8PR11MB7800:EE_
x-ms-office365-filtering-correlation-id: 3eae1532-9f01-4f4b-0fac-08de1d7f4648
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-7?B?QkVkZ1RraHlBOFQ1YVh2Z1RTejFoeThRU0ZzSFdPTnFDUmFkWEhPYzA2YVpW?=
 =?utf-7?B?MmxmbURXSEhqa3FWa1VEUGJNZmVaVERVNE5TTU52MXlGZ1AzQ3pTek9QRUdJ?=
 =?utf-7?B?TlRTVWFnMzFGV1lSZGZBMVNyVThFMGt1NmlRVmE0Zko3S0Q0dS8ydWd6UlVh?=
 =?utf-7?B?SEh3eE10T3dJL3puYzNTazNGVnJobU5OM2NxL2FqVVhLTUFpQjhKaGVvNCst?=
 =?utf-7?B?R292Y3k0N1YzZ1Y2OFdrdS9JWTR1L3BQUHA3YlBHMmhDSmE4ckxTWW5HSEhF?=
 =?utf-7?B?TFNicW1WZ29sY2RRZHZka2ZMT1g3czh5SDdCMjNRSVpDOFNYKy1wcistKy1i?=
 =?utf-7?B?a3VDYXZCKy1jb3FBTUt0TTFtcFRzU2dUR0dBOERDRUlOdmZxNjJLcExkaFpR?=
 =?utf-7?B?WXJoT1cwREFxakx2Z2Q5WnpEcFlTRmZZNXdnbzBWMmp3NklTQm1MeEdVTktT?=
 =?utf-7?B?bUNtZlJ5VjVwckpLYXl5ZFlLMlRDc01pamdrSjFnbWh1MDlXdnE5SGtYbHRI?=
 =?utf-7?B?dTJtWmVEV3pRZlByKy05SS9UWWtVTGhaL1lWZjVJQzl6eHBBbmpMb0NtbHdn?=
 =?utf-7?B?cWF5TldvY09sNFlyczg1OVpZMlRBdkNSeDdod0dUZFdINDJDOWJiMmQ5bnFU?=
 =?utf-7?B?cmZkQXpUb0hndWhOcVA3eGFuaFNYVWxTNHQ4MHJObjNGNmlyMFR3VnFFV2ZP?=
 =?utf-7?B?WHBrdjJuc0VVN2lBTGxPNnUvcHFjbzNnclhiTmVlMDlnMWlGeWFXamVnQWwx?=
 =?utf-7?B?VWowZjFHVEdRcHVGWW01N0NqYXBtMEw0RnRzYkN3VVJBNnVmSjZIWmw0NkJI?=
 =?utf-7?B?UTROb212UU9ia0dJVWpHYXlYaXRBVWt3Qzd0aU42bzZXdFc0WFhuUmE2SGlv?=
 =?utf-7?B?eUwwU3I5YWlJNzlqN29iRGx6ckZUZWxxMkgwbXMyNGJ2U2hQYmRRVkJZdTZX?=
 =?utf-7?B?aUZCQ3BRMzEwc1BDOUdBQVE1MjJwMDh2WHBaVDhmU05KSzFxUC9oTTRiUGVn?=
 =?utf-7?B?MDlabE1EWFJObWp0RFpNejVodVA0aHptMk9HeVZUci9IcUs5eTR3RW5pbktX?=
 =?utf-7?B?bystYzlQKy1XTFZhaGx6M1VmaXBKNW1sMUk5azhlMmJHblIyczhyandsKy1z?=
 =?utf-7?B?QldqZTdSNkE4aXFsTnpkazBhc2UwTllNa01id25lUlcwMGloY24xdXpvOGpG?=
 =?utf-7?B?UUdUV2xPRHh1VFFwbWQ4OVlFRzhmazlKNXVHL2sxbVBYRFdjcklwQWVFVzc3?=
 =?utf-7?B?SWNwOTIyTHhBL0RoSHpzUEdjVWV1S1kzcjlIKy1PRmxMU2M0WTZHQTRXSTZX?=
 =?utf-7?B?N1FpbWZONEdSVEVsTmZqUUxEbGNKcDNlcXhWSkd1bmlYeFNsQXJPVGxsUTk=?=
 =?utf-7?B?Ky1NUU1RM3VkUWlXbmpiL3RocloyOFo2NmRLVDdjVEV5aVpwcThKVkk0Um9z?=
 =?utf-7?B?QWNyV1pPTmVodHFVRzR5UjUrLURmQlNNU0I5bUIzMVAyc3VJUnJOcjYrLXhw?=
 =?utf-7?B?dURHVistLzF6OHdOZk1vMDBmbDlnRzVJN1IrLTl5TlZRSkM1bnRrNDcrLTc1?=
 =?utf-7?B?NGRkU1VxYTZ4MlFYbzJmeDNQc25YRHR0dVFERFFpUWMxMk9DQU83bVJmcklL?=
 =?utf-7?B?OFlLRGx2czZBQmpiNDd5cEs1S09oc2Z6Mlk5UzhYeHNrT1FrdUFLWVJjcDhh?=
 =?utf-7?B?UTZ3bmsvZXFRaVliWmoyWnNnUExZOXBnTE1FRHd0S29wM2FLdkxwa0VDZ2ZD?=
 =?utf-7?B?aEpNTG1lU0gyOFFuemUxaEVKSDFhYVVEa1VKajB3SGhoV3Q3SVpSdTlBaWRo?=
 =?utf-7?B?MWNWU0tJKy1CeFJVRlVEMVdBWDlRak1iL3RwdGZRUTd6Rmk1aXpQTDgxSVpX?=
 =?utf-7?B?TU5qRXRrempmY0ZQWVh0RzJFdVg3ZFF2RGlrbFpJNW9kZjhaeG5HQWtWRi8y?=
 =?utf-7?B?Q3hpclVHZWhFSDBMRWRYM2VNeG1NRVM4eXBoMEZZSFo0d1gzdkhLWDNIcGVJ?=
 =?utf-7?B?cmVHTEdSQ2RlcnZKVGN0ajlETkREQk1jVHpCUGhuVU9sWXdJNlljVzROeGpH?=
 =?utf-7?B?S0YzczFBREZzcllnZ0ZiR2FBcjdJV090?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-7?B?M2ppV0wxd1RyMXhZT2tEL1BmdFVmWWRuZlV1amZsaVdTY2hBNWRtampoNWhC?=
 =?utf-7?B?a0R0dzUzQ0ZPVndQWTdpMTVsaXlSelh1SGN0eHYzeGlrKy16TGE5QnVDNXRU?=
 =?utf-7?B?VGMxb2Rvb1UrLW1HWXdRNjJVcUgwOTlQcXh2eXVLbnNzRGd1Z3hhRzNwYWRO?=
 =?utf-7?B?WkorLW5yV0NTdGNqN1ByMWNubGkxSkppT1V4REg3ZGI0ZWcwY1JWMjFxZkl5?=
 =?utf-7?B?TVJsZm9RYlNqWEsxZlVNTVBLQ1B3a2JLLzBacm9uOTVyb3k5TlFiV0xsYUw1?=
 =?utf-7?B?SGpxQkcwU3dtMWNBSDRMQ3JvaFR0eVdxU3FSMVBEU0RqekpQRWV5TlFQKy1Z?=
 =?utf-7?B?SlY5N0VlMk9YanBUbURrRjVKMVVHYlJrWEZ4WWsyeU9mV2dKVlY0Ky1rU2VR?=
 =?utf-7?B?ZHUwOWpHZnZ0SE1tRnZ6Zkx6Q2NTdDFUKy1jS1ZnWWtLcmVyZHJ0ejllYnE2?=
 =?utf-7?B?blNwVTV3MVBMcU4vVDJwakFBdXBWbVB5REJkWkRZRThXNWRBZmg2ZmUvYUNv?=
 =?utf-7?B?aTNmUUVOSVFoWTRXdFcrLXpNRkE1NmpQNTBsRnUydXhPczhLZWVwRy9aQmxu?=
 =?utf-7?B?YmQ1clozRk1BNlVMYzNkSW12Q3FicGRoNXUxWWxiU09GUTN3Sno3Q3JMMUlS?=
 =?utf-7?B?VEJrKy1ORDlLUFNhdlFramJWSTRZSnVJY05BQkRqVzR3QnpuZ2JuZ2cwRDhl?=
 =?utf-7?B?akQxVGl4TVhPOFBXUzFJKy1IaDlDSmhaTERycU50bTZGcSstUkdPV1UwemxY?=
 =?utf-7?B?TXA5SnQ4RTdORHFhSnBuNEJJRVR1TkR4L2UzYWxiODZhSE51Y3N3b0F1S21s?=
 =?utf-7?B?Ky1PYVlrMjMydEdDV2hiQXU4d3VXN2JVQkFtbkFZOWQzOXM0Vkd2anlNMjI0?=
 =?utf-7?B?b2NQZnpiQ01yalltQjVEdElxZGo1QmIwZUNiQ0FnQ3VOalkzbk9wVnk5UUMy?=
 =?utf-7?B?L1NRdmZuVW4rLWRaMUcvOG0zY3UrLWc4R3ZFOXVnU0J6NWRORVhWdjRKaEVT?=
 =?utf-7?B?TUEwSXkxcW52ZDI2bHE1SThXdUxISVBLa3dLVGkvanpvamI2UGlrVXVqZVll?=
 =?utf-7?B?SHNiblJDL2tHbUxDZnE5dUNMRUo0RHpPU1N2WVJyNXl1RW5CMnVCdk9EZjhm?=
 =?utf-7?B?YTNSam81VlI1WEk1bGtXc2p3am1xU2hFaUk1ZTF2bGFPNGNlM3d5WCstalR3?=
 =?utf-7?B?dk1EbmZWVDV1M05sZllETzJXS3d5ckZWbTRYWHhWaistM1JWSzJuUjhiRUJz?=
 =?utf-7?B?V1N3UFN4dUNoZkpNL2ViWlIwa0djUkFsdDVXY2RpMW9tYVlwZWE1TTJXeThL?=
 =?utf-7?B?eEtPZHJ5QnhuMy9ldHZsODdmaFlvRlAvaGxpa2ZPZVRrVkV6TktnQUpLa3Ry?=
 =?utf-7?B?T2RsTTVHWW1meTY1bUVya2E1dFZtQkF3Ky1vTnZaejQ5QVYzdWVKSldxY2dN?=
 =?utf-7?B?d0xTbjJzMlFIdVhSTVhDazZKKy1WWUlBS2QvbE1JUm12N0hWUystSXBaeXN2?=
 =?utf-7?B?YjJCOTU2eEhSVnplKy1rS2xMS2EzNmFsUlgyVFNKSWJTVlYxdVQ5cDRtY0NZ?=
 =?utf-7?B?eFBFcEFZaFpPR2JJQWZiQ1JNdm9nbGhwYUZ5clVHNzZhRU9MTllrbUUwdmlL?=
 =?utf-7?B?ZUlITUVQemQrLTRab0J3UjRkU1NVZFVHcTU3ZHFoTU9KKy1xbGhhcGRjNjNq?=
 =?utf-7?B?Z3BRRFdRVTloM0dCMlZDOU9MMU9KcjJ2MkFHajJ2RlREajJWZENWUllTRWlF?=
 =?utf-7?B?MUdITXc0c201Z2dydmh5UGJoSHR5L2RYYXZpcE85bWZXSnJNZ1dzclIycER4?=
 =?utf-7?B?a04rLXo2Ky1ndkVCKy15dGNuQ1U0Z24zRlFtYm5NektnY1NJTCstWmRPN3dk?=
 =?utf-7?B?dTVBb0xaNXJmVWV1eFo3Ky10LzJhNjVGaC9Ld0FGcldwMVNCSDhIbXNUNVJW?=
 =?utf-7?B?ZnJBOXV3ZW9ZdTNiVTJxazQzRWVJUXM0WGVTVEVqckxJanVBbmtSUTl5eTZn?=
 =?utf-7?B?cjQyc0FNWnRYaVZZUjZmMXEwaTR0cmg4TzRQZ0NPRWlxUkpmVXNiYVllMGEw?=
 =?utf-7?B?QlU5c2ZvZDJZejlCS1ZrQkFoVEdHdFZDNHp6YUxVd3ZQU2o1Wm14MnRuazVn?=
 =?utf-7?B?eHlUSzQzbTcvQ2lHNzZuclNwZTVsM3VuTTFkVUFYYTRSd2xsN0ZYSVp5NEVD?=
 =?utf-7?B?bk9icDRF?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eae1532-9f01-4f4b-0fac-08de1d7f4648
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2025 21:56:00.9961
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zI38QxYt79fEdTMyQNnuBme6Im9iDG3YBdaljsfLz83epu82bMkYKAVveT3gcPlNPw4aQXh+/Hp1Hv5MPw1Rsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7800
X-Outbound-SMTP-Client: 173.37.147.252, alln-opgw-4.cisco.com
X-Outbound-Node: alln-l-core-06.cisco.com


Cisco Confidential
On Tuesday, November 4, 2025 2:04 AM, Hannes Reinecke +ADw-hare+AEA-kernel.=
org+AD4- wrote:
+AD4-
+AD4- The configured interrupt mode might be different than the resulting
+AD4- interrupts mode after all configuration limitations have been applied=
.
+AD4-
+AD4- Signed-off-by: Hannes Reinecke +ADw-hare+AEA-kernel.org+AD4-
+AD4- ---
+AD4- drivers/scsi/fnic/fnic+AF8-main.c +AHw- 2 +--
+AD4- 1 file changed, 1 insertion(+-), 1 deletion(-)
+AD4-
+AD4- diff --git a/drivers/scsi/fnic/fnic+AF8-main.c b/drivers/scsi/fnic/fn=
ic+AF8-main.c
+AD4- index 4cc4077ea53c..7075a23d9229 100644
+AD4- --- a/drivers/scsi/fnic/fnic+AF8-main.c
+AD4- +-+-+- b/drivers/scsi/fnic/fnic+AF8-main.c
+AD4- +AEAAQA- -678,7 +-678,7 +AEAAQA- void fnic+AF8-mq+AF8-map+AF8-queues+=
AF8-cpus(struct Scsi+AF8-Host +ACo-host)
+AD4- +AHs-
+AD4- struct fnic +ACo-fnic +AD0- +ACo-((struct fnic +ACoAKg-) shost+AF8-pr=
iv(host))+ADs-
+AD4- struct pci+AF8-dev +ACo-l+AF8-pdev +AD0- fnic-+AD4-pdev+ADs-
+AD4- -     int intr+AF8-mode +AD0- fnic-+AD4-config.intr+AF8-mode+ADs-
+AD4- +-     int intr+AF8-mode +AD0- vnic+AF8-dev+AF8-get+AF8-intr+AF8-mode=
(fnic-+AD4-vdev)+ADs-
+AD4- struct blk+AF8-mq+AF8-queue+AF8-map +ACo-qmap +AD0- +ACY-host-+AD4-ta=
g+AF8-set.map+AFs-HCTX+AF8-TYPE+AF8-DEFAULT+AF0AOw-
+AD4-
+AD4- if (intr+AF8-mode +AD0APQ- VNIC+AF8-DEV+AF8-INTR+AF8-MODE+AF8-MSI +AH=
wAfA- intr+AF8-mode +AD0APQ- VNIC+AF8-DEV+AF8-INTR+AF8-MODE+AF8-INTX) +AHs-
+AD4- --
+AD4- 2.43.0
+AD4-
+AD4-

Thanks for this change, Hannes. It looks good.

Reviewed-by: Karan Tilak Kumar +ADw-kartilak+AEA-cisco.com+AD4-

Regards,
Karan
