Received: from rcdn-iport-6.cisco.com (rcdn-iport-6.cisco.com [173.37.86.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08F82405ED
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 22:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.86.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762466505; cv=fail; b=tmyIipuzfWgbAIOaV0fkoIUlfSZkj4xIDDjWIssRuoGbrRD1yFuFJGa3HwMt0d+FfOBn6SC14KomK8/26ksJTi06y8PLO/jgdzFFnGYE0KJK9CUpvFi0G9vV0xWe3SL+W7J43/RST31n2WaJzz5wUAn/3eFXEql3XxIuI44+bXA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762466505; c=relaxed/simple;
	bh=dR4rs/KITYEmEDHI0V+lmL2o53Wa6uzCW7tBRRFh5Nk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cQtBIAqtjNbAOOz+4ifbV95hNZTWqvgDbEoLPZHd+jtupnvwlxM0eQ+fTlwGQSY/zfg8kvi7A7ur09OeFaMxR+iT9K/Ee7tYBJzpry5ojmbHDXFxP6e16typbKAV0HL3LtNC0gB6oFUxt/ZrvqZA5mItv/HTosiSGdV/IEBioHM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=EbWOkDnk; arc=fail smtp.client-ip=173.37.86.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="EbWOkDnk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2150; q=dns/txt;
  s=iport01; t=1762466503; x=1763676103;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=maPOCcOuhz+gh2uOD/3loHnNzUrdoXSfhBRngBz/+Po=;
  b=EbWOkDnkeC3t2ruXxkPbepPI4atyz8+st85Upj/gSTOkJb7wQAgJ8kZg
   JT4SLmRIHmRfcnfuG2qI422jqUsqvQzrqygetq5c3nz/15FJv8pkQzkds
   joSNnm7A4seA0mS8LiTka0qroIy0LLenxajI6SEKOK3soHa8g667x6Dpo
   maBVIB56r9zk696zhhVVP7ZF2o8OYUMGK+ylxVyXJD45zp3hTBxwN3y8U
   gJWHPKhKOOpIs8dEXAg6Bnq/tMAj0XiD9ulqGtx1A8MAefxm6ZY1tmJRl
   gko4nrFH0umtS6sJ84PxslKrARlT1lqScfrmpGpZECGDOm4YOsSAqOs2K
   A==;
X-CSE-ConnectionGUID: lbxS1HgMSXO/s5EUISs2iA==
X-CSE-MsgGUID: 9SgZJL9vTjCWJ4FoJ6ZQqQ==
X-IPAS-Result: =?us-ascii?q?A0AEAABUGQ1p/5AQJK1aGQEBAQEBAQEBAQEBAQEBAQEBA?=
 =?us-ascii?q?RIBAQEBAQEBAQEBAQFlgRcEAQEBAQELAYFtUgeCG4hpA4RNX4ZYoD6Bfw8BA?=
 =?us-ascii?q?QENAlEEAQGFBwKMWAImNAkOAQIEAQEBAQMCAwEBAQEBAQEBAQEBCwEBBQEBA?=
 =?us-ascii?q?QIBBwWBDhOGXIZbAgEDEmcQAgEIDjgxJQIEAQ0NGoVUAwECpW4BgUACiiuCL?=
 =?us-ascii?q?IEB4CaBSgGIUgGFboR4JxuCDYEVQoJoPoRFhBOCLwSCIoEOhieLAAaIHFJ4H?=
 =?us-ascii?q?ANZLAFVExcLBwWBIEMDgQsjSwUtHYEkIh8YEWBUQINJEAwGaA8GgRIZSQICA?=
 =?us-ascii?q?gUCQDqBaAYcBh8SAgMBAgI6Vw2BdwICBIIZfoIND4pMAwttPTcUGwUEgTUFl?=
 =?us-ascii?q?wAxXUyCHZMJg0mwHwqEHKINF6prLodlkHMio1mFGwIEAgQFAhABAQaBaDyBW?=
 =?us-ascii?q?XAVgyNRGQ/Ma4E0AgcLAQEDCZNnAQE?=
IronPort-PHdr: A9a23:DlGWExFCCtckBpT4UJhV+p1GfhMY04WdBeZdwpMjj7QLdbys4NG5e
 kfe/v5qylTOWNaT5/FFjr/Ourv7ESwb4JmHuWwfapEESRIfiMsXkgBhSM6IAEH2NrjrOgQxH
 d9JUxlu+HTTDA==
IronPort-Data: A9a23:W9VxUqK0BLK22qugFE+Rm5QlxSXFcZb7ZxGr2PjKsXjdYENS1jMPy
 TQYWmvXa63bYWTweIwia4W+9RsBv8TQmIM3SFMd+CA2RRqmiyZq6fd1j6vUF3nPRiEWZBs/t
 63yUvGZcoZsCCSa/kvxWlTYhSEU/bmSQbbhA/LzNCl0RAt1IA8skhsLd9QR2uaEuvDnRVrc0
 T/Oi5eHYgL8gmYqajh8B5+r8XuDgtyj4Fv0gXRmDRx7lAe2v2UYCpsZOZawIxPQKqFIHvS3T
 vr017qw+GXU5X8FUrtJRZ6iLyXm6paLVeS/oiI+t5qK23CulQRuukoPD8fwXG8M49m/c3+d/
 /0W3XC4YV9B0qQhA43xWTEAe811FfUuFLMqvRFTvOTLp3AqfUcAzN1qBlENZK0X391HJiZVq
 NElCQsWNBGq0rfeLLKTEoGAh+wqKM3teYdasXZ6wHSBUrAtQIvIROPB4towMDUY358VW62AI
 ZNHL2MzMHwsYDUXUrsTIJE3hvupgnD8WzZZs1mS46Ew5gA/ySQtiuG9boeNJYfiqcN9z32Xl
 EDirnrFADolFoCxzhjbwEu1v7qa9c/8cMdIfFGizdZugVuO1ikIAwYXfUW0rOP/iUOkXd9bb
 UsO9UITQbMa/UivSJz5Gha/unPB5kFaUNtLGOp84waIokbJ3zuk6qE/ZmcpQPQttdQ9Qnoh0
 Vrhoj8jLWYHXGG9IZ5FyoqpkA==
IronPort-HdrOrdr: A9a23:7tR0k6hWtn7k8bg8ub+l+lQWfHBQX5x23DAbv31ZSRFFG/FwyP
 re/8jzhCWVtN9OYhAdcIi7Sde9qBPnmaKc4eEqTNGftXrdyRqVxeZZnMXfKlzbamLDH4FmpN
 1dmsRFebnN5B1B/LnHCWqDYpcdKbu8gd2VbI7lph8HI3AJGsRdBkVCe3qm+yZNNXB77O8CZe
 GhD7181kKdkBosH6OGL0hAddLu4/fMk5XrawMHARkI1Cmi5AnD1JfKVzKj8lM7ST1g/ZcOmF
 Kpr+X+3MqemsD+7iWZ+37Y7pxQltek4MBEHtawhs8cLSipohq0Zax6Mofy/wwdkaWK0hIHgd
 PMqxAvM4BY8HXKZFy4phPrxk3JzCsu0Xn/0lWV6EGT4/ARBQhKTvapt7gpNScx2HBQ+u2UF5
 g7hl5xgqAnSS8oWh6Nv+QgGSsazXZc6kBS4dL7x0YvIrf2LoUh7bD2OChuYco99OWQ0vF8LA
 FjYfuslsp+YBeUaWvUsXJox8HpVnMvHg2eSkxHocCN1SNK9UoJhXfw6fZv1kvozqhNAKVs9q
 DBKOBlhbtORsgZYeZ0A/oAW9K+DijITQjXOGyfLFz7HOVfUki956Lf8fEw/qWnaZYIxJw9lN
 DIV05Zr3c7fwbrBdeV1JNG/xjRSCG2XCjryMtZ+59l04eMCYbDIGmGUhQjgsGgq/IQDonSXO
 uyIotfB7v5IW7nCe9yrkTDsllpWA8jueEuy6EGsgi107f2w6XRx5jmTMo=
X-Talos-CUID: 9a23:ACmF3233L0GN61qYc4zIELxfHso1SST9w1LrE2j/EjtEdZyuUgWR0fYx
X-Talos-MUID: =?us-ascii?q?9a23=3A4XDg1A9maPE6h0SA7AZMKjmQf5ZT7JaMLBETrZc?=
 =?us-ascii?q?thOvYGytSZQWklQ3iFw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-07.cisco.com ([173.36.16.144])
  by rcdn-iport-6.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 06 Nov 2025 22:00:35 +0000
Received: from alln-opgw-3.cisco.com (alln-opgw-3.cisco.com [173.37.147.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-07.cisco.com (Postfix) with ESMTPS id 1C9B6180001FB
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 22:00:35 +0000 (GMT)
X-CSE-ConnectionGUID: Ibsb3X5xTyiXh5closdkuA==
X-CSE-MsgGUID: VNFyJ3ghRW2e4gmqQeQfoA==
Authentication-Results: alln-opgw-3.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.19,285,1754956800"; 
   d="scan'208";a="35866699"
Received: from mail-ds2pr08cu00107.outbound.protection.outlook.com (HELO DS2PR08CU001.outbound.protection.outlook.com) ([40.93.13.55])
  by alln-opgw-3.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 06 Nov 2025 22:00:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xPbv+EJV/LjqDk6oHo3CdXmo0hbHc/bSGDqF2k13/hMDKYOfj/7+e2UZf8KQBJ42oM7VQKnKv3jS0UIalX5wV9NNJB+dQMUHZX3xhvmv3/JXziUmIPR1VkCCEZeD1CxrgBcAHmtAS97XlBr+yuckTOxa4iL8wPsY30mC+r+ORpUpuFU1DL560NLA55ATYJlHMojDYb1X0tOJenYN4RIjF+EmTW/E5ajFpOWS2/E+WDl99rl4ykCsX1g8wKGhrokIYhSt0T51Q37xZt348PhLDZG2NIjPq4J+fBQ6eCy7t620v+xoorvUIGmQGrJEzC45TH+ZgSFsOEuO7ghx9HRBwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=maPOCcOuhz+gh2uOD/3loHnNzUrdoXSfhBRngBz/+Po=;
 b=SF7sWYoiERSaB5pZtsBw55OIT1cErTYPd7OvSlDI7Cm9IiQKWywAQ4BqEDSk1msLq+yBY70T91PxH0zs7XtsOyDtkZ+Gac9B2oFmCpRhFPoferbKDcCuKGXDljo8FM38YpAZgXMp4LjeRXtWXta/AknN+/+wyWRmJ4hgqPvl+GWc8x1M7bjoAak7mnWYOw3qWlRHmWCwKgqxMCXILqbO0inCjQwyf4Sypnvu9sNMAAKH0zDWcj+v+zzQm2tS8cxSToTCR8pGXMdOzkfVBnMecCccTbODXr0q5mJmWBKeR87wLPPgBROlgMxO7gaTAK5NrO737jtV2x0fTxAfZQbGdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by PH7PR11MB6881.namprd11.prod.outlook.com (2603:10b6:510:200::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Thu, 6 Nov
 2025 22:00:32 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%4]) with mapi id 15.20.9298.006; Thu, 6 Nov 2025
 22:00:32 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Hannes Reinecke <hare@kernel.org>, "Martin K. Petersen"
	<martin.petersen@oracle.com>
CC: James Bottomley <james.bottomley@hansenpartnership.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sesidhar Baddela
 (sebaddel)" <sebaddel@cisco.com>, "Satish Kharat (satishkh)"
	<satishkh@cisco.com>, "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>,
	"Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>, "Arun Easi (aeasi)"
	<aeasi@cisco.com>
Subject: RE: [PATCH 3/4] fnic: missing initialisation for wq_copy_base
Thread-Topic: [PATCH 3/4] fnic: missing initialisation for wq_copy_base
Thread-Index: AQHcTXJyB4hzo+4fOE+PiZ5vsIOgZbTmNftA
Date: Thu, 6 Nov 2025 22:00:32 +0000
Message-ID:
 <SJ0PR11MB58968F03BA207693D01FD3BCC3C2A@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20251104100424.8215-1-hare@kernel.org>
 <20251104100424.8215-4-hare@kernel.org>
In-Reply-To: <20251104100424.8215-4-hare@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Enabled=True;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_SiteId=5ae1af62-9505-4097-a69a-c1553ef7840e;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_SetDate=2025-11-06T21:58:09.0000000Z;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Name=Cisco
 Confidential;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_ContentBits=3;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Method=Standard
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|PH7PR11MB6881:EE_
x-ms-office365-filtering-correlation-id: 67c46bd1-cb73-49dd-859c-08de1d7fe7dc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-7?B?OFk1RU5tWDNpMGxUa29QaU9aWnRrdWcxdWJyOUpieHViNzZZbUZXZ2VFQ1Y0?=
 =?utf-7?B?Ky1tYWxBYW92QlB6cnNYVnE0V0RMSjlrNC9DOVhGUzN4YWxIMXk1RHd5NmhS?=
 =?utf-7?B?cjVua3lKMHFCS25CQ0VDcDBlcmJReEJxR1I2YzlNKy10aUFESEZ2UnBhcjI=?=
 =?utf-7?B?Ky1Ud2NGSmZKaS9KaDE5YVFEeW4vTllmR0dwNHFwempWRlJJOHVGOTQyWGJK?=
 =?utf-7?B?RXIzMW1ORmNHaTZ4OXZkS09tWE9LTFk0TXk2NUxFNXIwZFpFRDdTZWNYWlh2?=
 =?utf-7?B?dXhRYXdjaUtFOXRGMjJ3eHd2d2pMMTBXTmZaNUVKQkM4a2RYS3dyWnk5anhO?=
 =?utf-7?B?RHYzSkZ6N3lzQ0dIc1ppb29rcFZhUjRlazlTblo4SkZObER6Sm1wdkZ5Z1Np?=
 =?utf-7?B?dzkzRnZoN296ampEdXAwSzR1Snl3ZzZsL0JPN3V4SjZ5RDZsY2pXcnlGRmNz?=
 =?utf-7?B?YlJaUDZGSzd4V0owMystMkhMb1hYbXM1UDFJdUZ2bXZDbEd3dHRMcDRzbnpC?=
 =?utf-7?B?RkRxeDJHL3VXcEhlZWF6bG4zMU5lRXJySlZnWEJkR1ZEOVc2NzR1U3E4bVJR?=
 =?utf-7?B?TGQ3bGlFYXVDam9GZmNZdElLNnJjTjNFeUVWQTM5RFNiWmYvcDF2TUJ2WUIv?=
 =?utf-7?B?TjlsSnlUL2c3UHhKNVc0b2dUV0pJSjRobFhsVzRrMXlpZzFyNUE3dXcwRmlL?=
 =?utf-7?B?VTBHaHpCb0p5SG9zVlNkMmd4MFpGcmp6THRrWC8rLUltTFd5L1NYcEp1VlFL?=
 =?utf-7?B?Vk5DeTVIYVZVS1kyajJqajd6QWZZNjhNblV6WHBka0ZrcjM4dWtTaUd2Y0RU?=
 =?utf-7?B?WnVmZnR5Z0haeDFzTHZiRUVZdlpydGJZQ2ZUUlo3NWNXd0Q5Mm43OUxxa2dV?=
 =?utf-7?B?QjFDRGFOdkRxbEZNZ1A4RWJqYnZFYXBMejgrLU9wcldMMXdjd1F2NnJIa2dE?=
 =?utf-7?B?NGRJSUxLOGlsU254VnB4U1lYVlpBSlhRNDM0Tk9LL0JSWUU0M0hrOTdqN3lB?=
 =?utf-7?B?Ky1BRkMwaistc1BGTXh4a0ROczR5TnJDT0dzcTlaREsxL2dPUHRHOEpwWWN3?=
 =?utf-7?B?N0RpeEZNaVoxcmUxZWFNQVBvVlRXZE9sWDlXTHNDV2VjQzhTY0d0aGFUamdn?=
 =?utf-7?B?ZTd5eCstMTNvTjUvWlF4VkhjY010eGxFNVorLXFaVSstTVJtWng4NnBHa08w?=
 =?utf-7?B?N2FkVkcyckljZEZ5Y2ZOSm1ESElJeHBqdFlkU3A5NkxXcWNQWlAzcWJtcmM0?=
 =?utf-7?B?TU9ldS85di95eHdpdGsrLTNzWnk2VGg4WWlpTmxSYzdzdkp1QlQ4OTc5a1Fn?=
 =?utf-7?B?Y0tKVzIrLTlYdlovZ2IrLWVkbS9xbllraU9ZeEtQRFhROSstTTZoL3FWUUQ=?=
 =?utf-7?B?NldiKy1sdUIyd012bU9vbGI1RFViQ3ZtNDJzdjdFMk9NcnlnbmpGL29mcGNR?=
 =?utf-7?B?NEZNYnRxbzVYcWVWY2JNSXc0ZFhVbENHYnlOaWo5L0JWNlpISE9ubkd0WlQ0?=
 =?utf-7?B?azNoM2RFdFZLMG54djFuSWxQckV1QUF1Y2RKZU03Ky1SckZ4NE1Ja2hONDlR?=
 =?utf-7?B?SDNJekNCMUt3ekxaQjREQ0tGNnNUZWNFOTEyN29DZnBKUHZQbGJtUldwZnBs?=
 =?utf-7?B?bi9kdmNnQlhGSkFsUFVGU3huM1lCemM4SWF1dlVBSUx1Y0p1VlFZSkpUZlhw?=
 =?utf-7?B?RC9Ba21GRkNMcFYwWistc2s5TWxWQ1lDbVU1ZFM0cndVNXhrd25RVHVDWENH?=
 =?utf-7?B?VHB3clVLcG1ZaGhXRXBDaUZuT0F0a1pSRU04TGxraHhOaVFZSEZIV1dETlBK?=
 =?utf-7?B?ZEQvNktodWN3VHVQeVBlb2EvRFNjNDZweWZkc3dXSFBLQzducGtqN1E5ZzQx?=
 =?utf-7?B?Rk9hbGtXTHBsMlhkRFQ3YlhPUXdIQ2lBTHhZVGI4SGdJY0JiRm9pRTJmbllO?=
 =?utf-7?B?a2pSNlFOTWZ5Ky16VE81NkwxUlFkckI1S2xmZ0RPMUJBNmE3NThkMGRFV0VJ?=
 =?utf-7?B?R1NmREtJbjNSNXhxWjRCV08xblo5eG5ueGtSMURIRWprTEsxLzlFNlZyWXp6?=
 =?utf-7?B?WkgxR3ZySlFuU244eG4vRDFHb2dJOUxWN2xQ?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-7?B?VlNPcDZodkVYbUVFb3VvMmNlNzd1YmkzVXkyVkZsaHEyYnJWNUZvQU10OWRM?=
 =?utf-7?B?a253SDVGRSstTEx3V3loR2gwSUt4Tld6UjFVV1p6d29oR2huVFArLWtNYXVz?=
 =?utf-7?B?YXNFSHhmTVJiV2NyRHdxVkI0UEZPU1gwb09LeWNjOHZGeVI0amlCQjVJM1NQ?=
 =?utf-7?B?NktCaEFMd0J2SGk3REtDa0ZXTzVTTjkvNDB2dzMwaHNuazJvVTBUWlA4U0t4?=
 =?utf-7?B?RnpVcnJ4QndsKy1PcXgvKy1va21VcTAvREpuazErLUpRN3hobGZaVVh5MEpB?=
 =?utf-7?B?bDY3TGZRcVZ0ZUxzaFVwRklURktpbTNCN0xka3RWQVU4Qm1vNCstYUNlT1NZ?=
 =?utf-7?B?M3Vadk1rYzBtQ3BrNlZiaml2MnQ1WkFtN2szZElwTXFnVjJQZG8zemtEdnpn?=
 =?utf-7?B?cU9iUkxHQUtDSkFHWmVSaEQxSlpVOG1GZmFCd1A0aG9iV1FJREExMTh2cDRn?=
 =?utf-7?B?RDNxME5PMGdtUU1HaVh3ajZFNDVNNVN3MGpXNUtSek9VUi9ERVhta0lIT2hm?=
 =?utf-7?B?RE96OVZGQ3JuNlhTMHhoVjVrYzlyTTRNV2hFcUE1aGwyNUF0YW9yOE9qbVJr?=
 =?utf-7?B?c1hCRWlzSGlpTllpa2xNKy1VS2llTGJlRmVMUGlaOFN2ZjNJWVZRYUtZTXRK?=
 =?utf-7?B?Qjh0RW9UTGZjOXZzZnRJSDRRWGQwZHFsUVJyS2YzWk12YXUxS1UxVVQ4NlJW?=
 =?utf-7?B?WUdhVGIrLTMyZjlQRlJMUjJ2Y1VXbFpzZXcycnh1MCstNFFEeHlOWFM5MHI=?=
 =?utf-7?B?bSstMFltKy1UMTFrRUI0Yk1qNlRsTnNBM2k4dzZPampNaHlDTHFCTENDUGxq?=
 =?utf-7?B?RkM4bEp3bEhuNW0rLUFUUnF0NnAvajJIWnpEN2VWenMvaWVnZXY3TDJaMzRZ?=
 =?utf-7?B?Y2VKREFUOGxBcE1QNmxMM3J4M3FxTzM3YUVWR0MrLVMvN09BT1ZnUFF5ZkRQ?=
 =?utf-7?B?aVVFT2FNV0ZrS3ZXUW1qblJtWS9wd2UzWVdRcnFsNXVXSlVYNzlESnlCOXFu?=
 =?utf-7?B?eXFDdklTNGoybUNHeHFVN0ZUWEhCbFN6ZFBCKy04ZE56TmNDd0RTMVJ1R0to?=
 =?utf-7?B?WmhBeWU5ckRWcXk4ajlqMDA0ZjR3OU9QRktldXBzSHh4Sm82d0hkM0FTTmVh?=
 =?utf-7?B?cHd4bWFnVDZJNFhGb1o2aVdTKy1sSWRvUWZDMm5rMmNhRmJxOHNtY1NWY1Bo?=
 =?utf-7?B?TU1XaUxCMFVJYXQvL3VYUlpvSXdub3JOQndRajVIUlVTOVZINnFVVnNFSmxJ?=
 =?utf-7?B?N3RWeTZhRUEwNmxGaldXOSstTG9HZFViUkZaRW9XRXBvbWtHNUtxZUlVUS91?=
 =?utf-7?B?Zy9BajRzRkJyZWsxKy1uaEN3cmxEV2xMWDk2aUVub3J4ZURWVUVROTh2TjVT?=
 =?utf-7?B?N29iZFhkeFpTVnlxVjBlTmRudWNzRGkrLTRTUE1BSEt3Q0JUbDVZTmtGclJ2?=
 =?utf-7?B?Z3hxS0dPN2tEN1htSnUwZE5BcVF6UGl6NDd2aTd2YnhsMXM1R1RyQWhKbTR0?=
 =?utf-7?B?ekZna3ozNFdHQm1aemZISHNFZ1RuUnQxWUUxL3B2Nm9ISHpaN0ZoTzhGMC9Q?=
 =?utf-7?B?OFVIVistbDNETkJoTGZhd3pLcHBIcVlIMVFZTlY1T2t5VVJGaVNyT1l0Q0Qy?=
 =?utf-7?B?UTJ4aXgyTUVPZDZ1akF3NnhjN3lPdUc4bWZvUDYxdGkvR0tOSlRzelhheklz?=
 =?utf-7?B?dEh1WmFhZjVES0pGQnQxdXJnY0dFOXN4RGFRVkk1ekhGOGtrNHVaV3VDVkVX?=
 =?utf-7?B?Q2FQVFd0ajF5elZUMHg0VVljZVRuNGFEcjJaOFhmT29lWWtoNEhScVpocXlv?=
 =?utf-7?B?TS8ydFF3VzVYQnBYTTArLU01clNOajBHUU50MVZBa2p5SFVhYmdXdzFBeU5J?=
 =?utf-7?B?WXNnYjlHVHpGb3dhaHZJc2RzeFRBUjZNRVRVMjhrdDczcistZ3ovZi9yQnds?=
 =?utf-7?B?VEEvVWgyKy02VEU5UWozZVdRMTI3N0gzMnh4bmZVdWJpaG9iQjBCN1ZkTzRz?=
 =?utf-7?B?VU5kSGNpdnNnbnhjYkh2SDZEYThsNURVTVBXWG9kYU5XTlhsbUp5MVRDcHFL?=
 =?utf-7?B?ZHBlQm84UmlXVnRXZ3ZJZHlESGg2aVNmaGxjMC9aYWhaWmNVNk5FZHc2UDB4?=
 =?utf-7?B?Z051NnFlOS9rQWU5eVJQd3c3RWplTG5RcThSNVd2R2ZPWDdjT1NaYUZ6RnJ4?=
 =?utf-7?B?T3dp?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 67c46bd1-cb73-49dd-859c-08de1d7fe7dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2025 22:00:32.1044
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EldIySnUth8IxWDHITgs9ynwjkVuDoaPLzMG1xq8KxbdMxvfxJv9b0nrgJTtqfshQ15oiCUy5hUOygeH/vqvDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6881
X-Outbound-SMTP-Client: 173.37.147.251, alln-opgw-3.cisco.com
X-Outbound-Node: alln-l-core-07.cisco.com


Cisco Confidential
On Tuesday, November 4, 2025 2:04 AM, Hannes Reinecke +ADw-hare+AEA-kernel.=
org+AD4- wrote:
+AD4-
+AD4- With the conversion to multiqueue the 'wq+AF8-copy+AF8-base' value we=
re left
+AD4- uninitialized for MSI and INTx interrupts, causing the driver to issu=
e
+AD4- a message 'FCPIO+AF8-SUCCESS icmnd completion on the wrong queue' and=
 finally
+AD4- running out of command tags as the completions would be accounted on
+AD4- the wrong queue.
+AD4-
+AD4- Fixes: 8a8449ca5e33 (+ACI-scsi: fnic: Modify ISRs to support multique=
ue (MQ)+ACI-)
+AD4-
+AD4- Signed-off-by: Hannes Reinecke +ADw-hare+AEA-kernel.org+AD4-
+AD4- ---
+AD4- drivers/scsi/fnic/fnic+AF8-isr.c +AHw- 2 +-+-
+AD4- 1 file changed, 2 insertions(+-)
+AD4-
+AD4- diff --git a/drivers/scsi/fnic/fnic+AF8-isr.c b/drivers/scsi/fnic/fni=
c+AF8-isr.c
+AD4- index 7ed50b11afa6..e16b76d537e8 100644
+AD4- --- a/drivers/scsi/fnic/fnic+AF8-isr.c
+AD4- +-+-+- b/drivers/scsi/fnic/fnic+AF8-isr.c
+AD4- +AEAAQA- -350,6 +-350,7 +AEAAQA- int fnic+AF8-set+AF8-intr+AF8-mode(s=
truct fnic +ACo-fnic)
+AD4- fnic-+AD4-cq+AF8-count +AD0- 3+ADs-
+AD4- fnic-+AD4-intr+AF8-count +AD0- 1+ADs-
+AD4- fnic-+AD4-err+AF8-intr+AF8-offset +AD0- 0+ADs-
+AD4- +-             fnic-+AD4-copy+AF8-wq+AF8-base +AD0- fnic-+AD4-rq+AF8-=
count +- fnic-+AD4-raw+AF8-wq+AF8-count+ADs-
+AD4-
+AD4- FNIC+AF8-ISR+AF8-DBG(KERN+AF8-DEBUG, fnic-+AD4-host, fnic-+AD4-fnic+A=
F8-num,
+AD4- +ACI-Using MSI Interrupts+AFw-n+ACI-)+ADs-
+AD4- +AEAAQA- -376,6 +-377,7 +AEAAQA- int fnic+AF8-set+AF8-intr+AF8-mode(s=
truct fnic +ACo-fnic)
+AD4- fnic-+AD4-wq+AF8-copy+AF8-count +AD0- 1+ADs-
+AD4- fnic-+AD4-cq+AF8-count +AD0- 3+ADs-
+AD4- fnic-+AD4-intr+AF8-count +AD0- 3+ADs-
+AD4- +-             fnic-+AD4-copy+AF8-wq+AF8-base +AD0- fnic-+AD4-rq+AF8-=
count +- fnic-+AD4-raw+AF8-wq+AF8-count+ADs-
+AD4-
+AD4- FNIC+AF8-ISR+AF8-DBG(KERN+AF8-DEBUG, fnic-+AD4-host, fnic-+AD4-fnic+A=
F8-num,
+AD4- +ACI-Using Legacy Interrupts+AFw-n+ACI-)+ADs-
+AD4- --
+AD4- 2.43.0
+AD4-
+AD4-

Thanks for these changes, Hannes.

I will need to test these changes and get back to you.

Regards,
Karan
