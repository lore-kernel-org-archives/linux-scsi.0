Received: from alln-iport-5.cisco.com (alln-iport-5.cisco.com [173.37.142.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5C22C326F
	for <linux-scsi@vger.kernel.org>; Tue,  4 Nov 2025 23:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.92
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762298505; cv=fail; b=aNb6Oslu+L6S6E3Ef938ykkXefSWbAmq55lvbCAsIJz7YupGma72I2EFZHVJoNsrVF/yZzEAAHp5/WAV8LCmyNSklUb4Zj99W9IDjhvZdIzvdZyNMNIlF/Sj9wlKB24mpDVbxo/07NncMGJhXAFhdRIR0VR+fa4tG+x5MQPYgC4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762298505; c=relaxed/simple;
	bh=eptACMbltKXfdKGlEd93b/aMZpO17oV1fsslyKe/Hvg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FWIXhe6hbZ4V9GaLvTdmMYXEL2BzYrTvDq4R4nR1ZCSb8+7qC9nqk/Fbp66AwBwNRqR4DOjzRzTrM3SaJtbLcqBhyMmn129NDgZyfnVfMdnpquVqi6GL88i44KGnbilNfu5r18OHwRSqt2Osi9bblRsb0a0SjweaPtLBO9EQSko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=LYy5QLle; arc=fail smtp.client-ip=173.37.142.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="LYy5QLle"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=5133; q=dns/txt;
  s=iport01; t=1762298503; x=1763508103;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JnT4ResFI8OoBncEsCmVb00qCZ0FCk2rPv0yp9rz4XY=;
  b=LYy5QLleC/ejB7a/SF31n2g98FIMkH5rQ6f3Cw/sWxxm9inAmo7BGhRq
   pgoYBVQtcl+DnFnRQ+Ds6h6usmOsXyUO7/ti5KNvP3qbIw1IeuuV1kjzq
   Wuwc7PWMXMj/IVt4K8D880ACIS4yPxUVlpw3O2u8U/J7gvE41ZVVBtvjW
   k/x/Yy+lFfoCgOg0Zq3JEUI/OZwPXgyRPaHG7ehjnRDqMPlEFVHsEKzO8
   kLLSHJtHv6SDNUbsHIgTdh6Bj7sK18YQuNypsMhe3ZB0Y42ISFCWSj3O4
   qNgJ2bCYRcktjOOceb1EhHEP8DP8T6DYu9vHstp0Xyzja1gitioh27A1o
   Q==;
X-CSE-ConnectionGUID: cvvMkLPnR2+n3h0h7rg75g==
X-CSE-MsgGUID: DidkX0WdSze2fwt6wkeUvA==
X-IPAS-Result: =?us-ascii?q?A0DeBgAIigpp/5UQJK1aHQEBPAEFBQECAQkBOoErAoFsU?=
 =?us-ascii?q?geCG4hpA4UsiHieHRSBaw8BAQENAhQ9BAEBhQcCjFcCJjQJDgECBAEBAQEDA?=
 =?us-ascii?q?gMBAQEBAQEBAQEBAQsBAQUBAQECAQcFgQ4ThlyGWwIBAxJnEAIBCA44MSUCB?=
 =?us-ascii?q?AENDRqFVAMBAqc1AYFAAoorgiyBAeAmgUoBiFIBhW6EeCcbgg2BFAFCgmg+h?=
 =?us-ascii?q?CobhBOCLwSCIoEOhieSb1J4HANZLAFVExcLBwWBIEMDgQsjSwUtHYEkIh8YE?=
 =?us-ascii?q?WBUQINJEAsGaA8GgRIZSQICAgUCQDqBaAYcBh8SAgMBAgI6Vw2BdwICBIIZf?=
 =?us-ascii?q?oIPD4l0AwttPTcUGwUEgTUFllgBMV4TL3mBA2SSTxQHAkCTMp9ZCoQcog0Xq?=
 =?us-ascii?q?muZBiKjZoUOAgQCBAUCEAEBBoFoPIFZcBWDI1EZD44tFs8cgTQCBwsBAQMJk?=
 =?us-ascii?q?2cBAQ?=
IronPort-PHdr: A9a23:zVdKlRTIDdmrpPa2zlrMOQVSGNpso47LVj580XJvo7tKdqLm+IztI
 wmCo/5sl1TOG47c7qEMh+nXtvX4UHcbqdaasX8EeYBRTRJNl8gMngIhDcLEQU32JfLndWo7S
 exJVURu+DewNk09JQ==
IronPort-Data: A9a23:VkYzPKDfRI80URVW/2Piw5YqxClBgxIJ4kV8jS/XYbTApDN212RVm
 mtMCDjTP62JM2X2c4pxb4uy9ktUvsXdmtFkOVdlrnsFo1CmBibm6XV1Cm+qYkt+++WaFBoPA
 /02M4eGdIZvCCeA+n9BC5C5xVFkz6aEW7HgP+DNPyF1VGdMRTwo4f5Zs7ZRbrVA357gUmthh
 fuo+5eCYQb9h2YvWo4pw/vrRC1H7ayaVAww5jTSVdgT1HfCmn8cCo4oJK3ZBxPQXolOE+emc
 P3Ixbe/83mx109F5gSNy+uTnuUiG9Y+DCDW4pZkc/HKbitq+kTe5p0G2M80Mi+7vdkmc+dZk
 72hvbToIesg0zaldO41C3G0GAkmVUFKFSOuzXWX6aSuI0P6n3TEyOtwKUISBYsioKVxWmEW9
 aMCJ29QYUXW7w626OrTpuhEj8AnKozveYgYoHwllGufBvc9SpeFSKLPjTNa9G5v3YYVQ7CHO
 YxANWsHgBfoO3WjPn8UAYgineOhhVH0ciZTrxSeoq9fD237klQhieS2aYqOEjCMbelUkkWo/
 l3KxHb0WB8FKIKAyje47Fv504cjmgu+Aur+DoaQ8v9snU3W3WcICTUIWlah5/q0kEizX5RYM
 UN8x8Y1haE28EruSpz2WAe15Sfe+BUdQNFXVeY97Wlh15bp3upQPUBdJhZpY909v8hwTjsvv
 mJlVfuybdCzmNV5kU6gy4o=
IronPort-HdrOrdr: A9a23:sSPvYK2hdeyDuwTSDlMbigqjBfRxeYIsimQD101hICG9Lfbo9P
 xGzc566farslcssSkb6K690cm7LU819fZOkO8s1MSZLXjbUQyTXc9fBOrZsnLd8kLFh5RgPM
 tbAsxD4ZjLfCdHZKXBkUiF+rQbsaS6GcmT7I+0oQYOPGRXguNbnntE422gYzRLrXx9dOEE/e
 2nl7J6TlSbCBMqR/X+LEMoG8LEoNrGno/nZxkpOz4LgTPlsRqYrJTBP1y9xBkxbxNjqI1OzY
 HCqWPEz5Tml8v+5g7X1mfV4ZgTssDm0MF/CMuFjdVQAinwiy6zDb4RGIGqjXQQmqWC+VwqmN
 7Dr1MLJMJo8U7ceWmzvF/ExxTg6jAz8HXvoGXow0cL4PaJAQ7SOfAxwr6xQSGprXbIe+sMiZ
 6j6ljp86a/yymwxBgVqeK4DC2C3XDE0UbK2dRj/EC3F7FuKIO4aeckjR5o+FBqJlOh1Ggqfd
 Mefv309bJYd0iXYGveuXQqyNuwXm4rFhPDWUQavNeJugIm1kyR4nFojPD3pE1wv64VWt1B/a
 DJI65onLZBQosfar98Hv4IRY+yBnbWSRzBPWqOKRC/fZt3d07lutry+vE49euqcJsHwN87n4
 nASkpRsSo3d1j1AcOD0ZVX+lTGQXm7Xz7q1sZCjqIJ94HUVf7uK2mOWVoum8yvr7EWBdDaQe
 +6PNZMD/rqPQLVaM90Ns3FKu9vwFUlIbooU4wAKiezS+rwW/nXitA=
X-Talos-CUID: 9a23:Y3oQ+WHZ+mb8FLnrqmJs6lAxGeQddEeHj3GLIxe4VnxmF+CaHAo=
X-Talos-MUID: 9a23:idfcTgYGTlL3EeBTmz7ghwE6C8tT8an0Bl8Rz4oFtvSaHHkl
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-12.cisco.com ([173.36.16.149])
  by alln-iport-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 04 Nov 2025 23:21:37 +0000
Received: from alln-opgw-5.cisco.com (alln-opgw-5.cisco.com [173.37.147.253])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-12.cisco.com (Postfix) with ESMTPS id 310AD18000156
	for <linux-scsi@vger.kernel.org>; Tue,  4 Nov 2025 23:21:37 +0000 (GMT)
X-CSE-ConnectionGUID: F83yOYcBQXu8HZAuonXwZg==
X-CSE-MsgGUID: VBgEM78MSzKvqYrhiHZGoA==
Authentication-Results: alln-opgw-5.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.19,280,1754956800"; 
   d="scan'208";a="36729824"
Received: from mail-sn1pr07cu00103.outbound.protection.outlook.com (HELO SN1PR07CU001.outbound.protection.outlook.com) ([40.93.14.99])
  by alln-opgw-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 04 Nov 2025 23:21:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aC39PejhCi1lhEUuOncdV3PIb8xQDPkbQNmbPv0/DaqSxZ+h477+tSlvu7/u3+7Vk2S8Z5LkF6M+adEpe2iXX2ylu7OxA7i8GCMfPTz8QPaQoAnwrjId+rJB+O54SVDKZopV/orvOkmrXVrg6djk2IxVjSIXEXnOcka4YqoOrBzzYmtJ+9v2wjaUFX4W889EBs5AeRtAwBFAMMggmpygIDAIWrOjAPvU0/6QSyw/bdNrp91jL+AHCYLfidAjUvre8VXyVnsxL0TaGUhxu+mALRFRo31T4nT0Wl0gM7ChtIb9jWiq4QMwtDVUveT0pACquKSOKxetKhW5R4jQZGSiXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JnT4ResFI8OoBncEsCmVb00qCZ0FCk2rPv0yp9rz4XY=;
 b=c6sj756rkt4lWGbGALqjSgqj1jaT2MrG9LQ2hGIzVAkqPgiIvqgRDPTAVK7Sszsnv6Eh57uCWDKY8osYrNnwgFoQSW66n0+eG8x/zkWvt1t+8D3Ig6/bbAu3sUHZZb5iv/0SDO3HmLTd7P8ooTtPUeTdNuih2ytO14bmY7x0wW3Bl4Ak1BIEjMn1Xn4vqpbfnCCDl2lQTzIcjl1pOR52RvRaHEXVcrFpw1S7OHArHkLzW0RvUuxOUh/4FSV+mzFvS09Hq7K6sL+HQxCQoS3z0307ztrfoS42UZctHqHmle/4rYsJ6aTnJwL/zaXIKI1InfMKKch98Z6nQlwo4OTgvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by DS0PR11MB7411.namprd11.prod.outlook.com (2603:10b6:8:150::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Tue, 4 Nov
 2025 23:21:34 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%4]) with mapi id 15.20.9298.006; Tue, 4 Nov 2025
 23:21:34 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Hannes Reinecke <hare@kernel.org>, "Martin K. Petersen"
	<martin.petersen@oracle.com>
CC: James Bottomley <james.bottomley@hansenpartnership.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sesidhar Baddela
 (sebaddel)" <sebaddel@cisco.com>, "Satish Kharat (satishkh)"
	<satishkh@cisco.com>
Subject: RE: [PATCH 4/4] fnic: make interrupt mode configurable
Thread-Topic: [PATCH 4/4] fnic: make interrupt mode configurable
Thread-Index: AQHcTXJy2FynwvhbtEuofvwLS32KDLTjKAlQ
Date: Tue, 4 Nov 2025 23:21:34 +0000
Message-ID:
 <SJ0PR11MB5896948F0D14CA49860552ACC3C4A@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20251104100424.8215-1-hare@kernel.org>
 <20251104100424.8215-5-hare@kernel.org>
In-Reply-To: <20251104100424.8215-5-hare@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Enabled=True;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_SiteId=5ae1af62-9505-4097-a69a-c1553ef7840e;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_SetDate=2025-11-04T23:19:27.0000000Z;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Name=Cisco
 Confidential;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_ContentBits=3;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Method=Standard
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|DS0PR11MB7411:EE_
x-ms-office365-filtering-correlation-id: 55bfcd39-cda5-41fd-de57-08de1bf8e55e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|10070799003|1800799024|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-7?B?WDZmeXhsSEM0S2NXRHhYcHhveDE0Sy9ieS9hQ3FaQmgxKy03RGFhRWE2OTN6?=
 =?utf-7?B?VU4wa01aSjFXYjVDaHdEa1V3aUJTN2R4MGZmV1N2MHpSM3JxS2k2TkpFSCst?=
 =?utf-7?B?NVdWc2tnc1dtYmxsbHFGUVZ1NkhqQnVxbm5lSnh4UkwvNW5WREhERkVUS2l1?=
 =?utf-7?B?RWJKTDNGL1JsTTk2WDRpZ2p2Ky03NnlMQk9WN2NRZy8zYTZ6aU83RURWenR3?=
 =?utf-7?B?QWlSS21SUistaWpUeHNKOGwvMWpLYWJpS0NGSVJJL0NJcm1SVE13UldqOEJU?=
 =?utf-7?B?Y21zRnJWNmpEazFkTUdRQnJNNUdKT0V1WkMxajBod0QyYjU1VW9mLzVObUw5?=
 =?utf-7?B?cU9IakhTQVFjdG5yS1dSY1QwSlZHL2taSkFBeUc0d0wxVWVRb2MyT2pPc3RJ?=
 =?utf-7?B?N3RlY2VSU3BtWmlRdDE0ZENrVTE4QWIxVFRWbUtFUkl1UVBtRUU0MmVnZUVI?=
 =?utf-7?B?ZFVnTTVSWHNuOWpjd3FYdHZQZDdDVDh3SFI1YjZSaU9QZjdJZWIwTElSNGI=?=
 =?utf-7?B?Ky04Z3pQU05rWnRIaUxhc0lmSDhaL1lzSmZta1JvTkJaMEtqaW45SzRaMFpY?=
 =?utf-7?B?Mystc1ZsbnJCRk5kS2xheXFtKy0ydkhtaEFuTGxLY3ZiM3VFRTlPbVRwVmI=?=
 =?utf-7?B?S2IrLS9jaGNSUjR0MFBMYUUrLUsvY0VsUDNGS1daN2dQQ0ZPeDNwc2dadUFj?=
 =?utf-7?B?MWFGUjV5eTR2SDhwRHIyRTVseVc1NlBsSFU5Y0ZtNkRyQW9YUnhyaUgyam4v?=
 =?utf-7?B?L0hLRnVlWUFDN1Q5MkJuZDhoc3N5MUVNWk5QTWFpcGh4Yi9Ja1EwZHpiUG1w?=
 =?utf-7?B?bnAvZVA1dlliaG1qanFlSkx4RnNNeENUU0pjWTFYTHVxM0s1MXdnbmpaMlo3?=
 =?utf-7?B?akVxc0kvc3QyT0RldExFYmNTaDUzaWR4dzRiNndrMFZwVUtLMVExRWcvYkhI?=
 =?utf-7?B?Rkl5Tlg5MzVzKy1FOTNZSXVzL05obkVNVmppRTRVZXpIdmRDbGdOc1ZmNlNW?=
 =?utf-7?B?cVp4YjFqZVRIbS95NjBZRTBhL0phUy9qaWNvL1NOMEhWbjhFa0lnZjFoWUJw?=
 =?utf-7?B?enVyNng3a2lkOUVtL0JVQlAxelhjeWpmT2lxaXBadEFUSUEwR2l6aDdKWnVP?=
 =?utf-7?B?akEzeFdWNk1UU00zY1JoY2lFSXVoWGtWdFlWNXhkdWtYWVMyUjF2aGJmRlli?=
 =?utf-7?B?Q1p2TGkrLTlvUUxIa3ZHVjJQUDVLSkE0Z0ZzQnVVOE5NdThLQ0V6akxJVGd6?=
 =?utf-7?B?bGFCUGlIYzFIM1BlWHMvbGswdHdvcVpWME1Vbks3U2tXTlNvai9uZmdmcGF3?=
 =?utf-7?B?NUVUME9HZnlvNkpkRnA1MEI4cHJKdWd3TlR6TXQ5Q1I4eWlHY1FYN2k4eG8=?=
 =?utf-7?B?Ky00d1IvM2ZtZ2hkTFFQc2VuZW1odEw5N3BUL3RlYmNncmdqb2QyRFBOSjZV?=
 =?utf-7?B?WHB0c0tvLystdDg2UjdZZHNvS0hvdm44NjJOYm1laGJqOEhMWlZ4T0VtUW1D?=
 =?utf-7?B?clhQZGE2L3NZY0dRMksyM01GV2tRMmorLTJFUG96R1gvU01zSFN4Y1BIVU5D?=
 =?utf-7?B?Ti9kT0NITEpCR25JTXFuV2tyb1ZxU1pmSWpzdDhWRFlndk5vZDlRaTFJVEIz?=
 =?utf-7?B?OHBmWlkvMk1RdTlyc3RYTEMydkw4TTUzN1Mydkc2c3pFdGpvbkw4b2l2RDZx?=
 =?utf-7?B?WlhVS1ZoR3d5RS9jNXJrTThQQzF1RlRxcGRCdm1Vd0J2U1lXcmVoaystbGZL?=
 =?utf-7?B?NFkzbTVicXhDeGFWMFNqU3hmdThaNVJTdFBiUzl2NXdmdVEyUzRFS3hZTmQv?=
 =?utf-7?B?R1BzVEZLRXB4eC8zOVRZdkpDbTE2bUpOU1pCeFhhZkI3NkdYeGZkQlR0UFZq?=
 =?utf-7?B?WU82NHkyTFNqckdDMlFpMFlKR3VteVo3MGRLZzhmS3JscU8wKy1XalZJOVRz?=
 =?utf-7?B?TVorLVhQTHpyTmx1RUozSFJtemFpSk5VcXRhTSstNDM1d0wyNThVcjNXQUtV?=
 =?utf-7?B?Z2t5U0NYWSstWmF1M0Y1Y2I2dHZGN1B4UERrWGdTMkdLSlo3d2RDOHhQNEtQ?=
 =?utf-7?B?OUl4UG1naFhVY0Rwb3pvMFFiKy1DRmIxNzlMdHA=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-7?B?aXZEZkdLSU1qUHl3cC9qQlZXVGRTbzNPa1ZheGw1WnV3UWp5R2lvd3ArLVd0?=
 =?utf-7?B?akhteWwzcXNycXNwUC9LTlhDaFN2Ylo5Qjc5aUpsU205RkhzL3U3ZmxPQUs4?=
 =?utf-7?B?SzBNNFlwUVdRYmE5ajhDUTJvcHNEbVBxZFhkZ3JkNy9QUmtFKy1jdDR1Sm9S?=
 =?utf-7?B?RWZYdmlzSDZpMUhLNG9lMGoxaVE0Y1BzTDRXYUhIckdoRnNCWjR6c2U4YUxz?=
 =?utf-7?B?YzVTMjM0aEpId3NuNmRpWG0vWnlhSWFnY1R1dTlDZGdPc2FxVTlaMnlMYmFa?=
 =?utf-7?B?bVJkMDdIVk5abHgzZG1WQ1lyaWNHWUFuZVFCbVZhZHNZV1U1MmpZWUgzY1pk?=
 =?utf-7?B?dEdCQkNVYmVwKy1CNmZ1WURWOFBIZXFmU1hWMS9WTHB0b0hjZjJwQm1mVlRo?=
 =?utf-7?B?c0tQMzZKbzRiS0tibXVyTHhiTC9QWVZ1NGVYR3QxSVFubXk5YlpRM0dKS3ps?=
 =?utf-7?B?czYzRVU3VnpYRTUyamxvU2Nub1Y3WnFOalRYYmJ1UFpXaEIwNFlHREdJMlEx?=
 =?utf-7?B?UzVRaXdnYllGVzV0YzZ0R1ZuVElZTU5ITkFKbjczdnB6c3lsYystL0ZMRTRY?=
 =?utf-7?B?MHlMMVg4dkZyOFI3Qlg2dmYyUVJwak9GdWJWalh3TS9GWWRONnFQR2FnYSst?=
 =?utf-7?B?UWhTZFlhN3MrLU81RTMrLUNYUGJhSDV5d1NZbVYyN1VpMjdmZGV5cGdiOHlC?=
 =?utf-7?B?YXR5UUQ1N3hSdG0zcjMrLVNGWWI2Mzczc0UzaUY2Ulp5OTFncGJnWjNHbzh0?=
 =?utf-7?B?UFcxVXZRdy9tN1pYMEZjRDNRV1N2ZnkxMGVUZE9DTzJibUYzUkZLQWVXSWZI?=
 =?utf-7?B?U09GWXM3b3Nya1dad1V5Y2pyZHpGZmUyQWVEd3lYM1Zubzh1RDJlRm00TmJ4?=
 =?utf-7?B?MnZ5Rm5ZQ3d2NzZDbDA0SThVbDFlTjgyeEFtTDBpQ09CTkQ1ZDhHZE9LMlo0?=
 =?utf-7?B?MjJocVZOTm4zYmZITnEybEFybGpjd2UwQjljQmNZZWdpdzVtSTZBS3lqYUFK?=
 =?utf-7?B?bG91VHdaVllCcWlDdG92Ky0wM1lyYWNFMFNMVGZIMXBVc0ovRXEwZ3EwT1Q3?=
 =?utf-7?B?WEoydjI1c0dXRUlDUTN5NFhnMXI5a1VWRlNkMkp2NmtnbUJqRlczbFN3WThK?=
 =?utf-7?B?bmkzQkwyOXhjdEZ1bHcyOVBSbVBPRmJmV0VEdWxhUFBIUjM2eFd0SDBkWW4x?=
 =?utf-7?B?eTBsY3piYlZQbnlDaGprUGNUY3Vod0ZVMlBUVFNJMHAzNi9SQkhaTjNrOXg1?=
 =?utf-7?B?aHpuem5EeG0yNmFzZ25sNnFtU0wrLUxNVFZPTU4rLW5nNVRxZE5YWFZ6UXRa?=
 =?utf-7?B?NWVXSk9TSUhkN0RMQTdkZks3RkJGMGZrWWdrNDZTLystQm5yYXI5R3N6Q2pn?=
 =?utf-7?B?ZllUSEc0QkNFYUVhWWhtUE9BWGkvb1QrLWFJVCstRWhSQ096cHdFQVdrY01s?=
 =?utf-7?B?cW5WaEJFaXI4bXhLRFVvUmlmNjdpVWxkN01mN3E1SC9RVjhvUlNQdDdsbVFw?=
 =?utf-7?B?MHgzNVNVOUhJbERIdHhDSGIyc2I3eGNwdFFzWFphT09yRjQ4M1N2VWwrLUs1?=
 =?utf-7?B?Z0lSVHg0b3RFdjFZaFhVLzh0TktzMGFJYW1qM2tEZ0psZUp2RE1uaUNLdk1a?=
 =?utf-7?B?ckpRVEd1TWRTUFN0L3IxWXd0OFZJYk5OOTN4T2xPWm5GY2o0NkF2UGIrLUh0?=
 =?utf-7?B?UTRkTDNuMVZYN0lpVlJYWkU2cGVFNm83TFB1dmlTZHlTVTg2UHU1Y0lobmI0?=
 =?utf-7?B?Ukc5TVlrajV6d0x4a1RWT2VscXEwM2dYSTZHbDFFenNMMmZicTJmdUNqTUs3?=
 =?utf-7?B?ams4NGJta2pSbUY3b0NkMWV6a2o2THFweDE2SUtQZTg2UkNoNTdVUDZVL05T?=
 =?utf-7?B?NmtSdGw0ekZiU1RQZjVlc2ZMNEZxNGJLUElvazlBRXdBSjNYOGJhWWU0YTVZ?=
 =?utf-7?B?dTB6ellGVzZHWDRHOXA5VkJ2VHhPSjFCeU1ZOXMxbXBkSEdyaGNTMkRpV09J?=
 =?utf-7?B?QVFOMVdmdWFpWU12bWVXN0JuYjBTRVVMMjhPa3FIUW5IaFgzdTFIbUpreTRS?=
 =?utf-7?B?T2RlMzV0RDZxamJZclpjSW42czB4VVVkU1dWMUoyQystaEM4UWhEbVdJWkJX?=
 =?utf-7?B?dm51RHdyS0dHMVlsdXREWlVZU3hFUFl5Ky10Ynh6ZEpwYkxORVVkTVNtZDYy?=
 =?utf-7?B?L3NneTRqSklja2xOWW1DSU15T3p0dHkwb0x4SWZCeDYzQXBmeGZKZGh0eQ==?=
 =?utf-7?B?Ky0rLTZHeDRqcnA0VE9PdWp6cDRO?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 55bfcd39-cda5-41fd-de57-08de1bf8e55e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2025 23:21:34.6650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zQmO3Oc+EGmyLio8tDZhT2L4rMiSgvSOZxgkX+BvwSgQb84SnXtk/bjCBc16tHQOvYk6cpAWzIvGqCN/CYmdJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7411
X-Outbound-SMTP-Client: 173.37.147.253, alln-opgw-5.cisco.com
X-Outbound-Node: alln-l-core-12.cisco.com


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
+AD4- +-
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

Thanks for this change, Hannes.
The fnic team will review this and get back to you.

Regards,
Karan
