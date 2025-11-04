Received: from alln-iport-4.cisco.com (alln-iport-4.cisco.com [173.37.142.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723F527F166
	for <linux-scsi@vger.kernel.org>; Tue,  4 Nov 2025 23:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.91
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762298397; cv=fail; b=n8pV89laeYxrBn3/zgEtcvVFTIDIjPdXHKEVsOtvZP8jl6Pc2IfWYwIY8I7w4hnM4P9OQ6gmoIZ8a68i/PXZicQ09DKlJKrizjFqkTW8lrXMHXQSGyItl8aiUxpln4sgb4Kb4CjZnNxcnDTDONbN13/B4gF5W9nRYUlFnI7sHms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762298397; c=relaxed/simple;
	bh=Q2kxPXtZc8xKoG9gOTtwUng2F/mlNyl0LMsAiqXrNVQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KxLXsSqUIQxIneQwIaDc2RGfECqWPJ50n4jc8dHbm4Kez5vLsI9YEXarxHKiiaHbTTU00dGMhtZsUoiHlYpxfTWkp1oylglkYmFHJwPpDbZXHTfJ3iiU4az6LXBqdEILO051mwxkjJM4I0JLQ0Wyq5B5yqVNZTH1BFWKTXm3Z9U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=eUXCKPI4; arc=fail smtp.client-ip=173.37.142.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="eUXCKPI4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1875; q=dns/txt;
  s=iport01; t=1762298395; x=1763507995;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1oiwktn/ecErapidfj6PXwsnD40gYmXVXjMSeUXUw+M=;
  b=eUXCKPI424zI8Nff0wjNKfMOM8e+jmedEGChFlgFkhy2/wFi06lmDrsb
   8cI3x77o8uyeXt6dO2sNEhPpvh0ZPYANneCDrZFCpaR0fy8JEPhYf/lRa
   l4hPV/kiL6d25So9dOm/mOq7sF1/bFsZ61RDiwpsuxwW9v/n/CoLATeSO
   f0u5SDz/SEZGqvuE1L68UxqiprrLg/ZMmVvALMG6eb7f++ooQsJc/CL6f
   o2ADV8ARmkc4RffJHGBzJhbRY6sCBjYmnZOZuZo3zIXYNguyRmTESnK2G
   cqlrNaB/H5NDyo01pQQJzdG9qSdTuA2KyZ21rR6paeYceb/ZTQU/HXjW1
   g==;
X-CSE-ConnectionGUID: 27RCu13NRMaDMFGlynm/ig==
X-CSE-MsgGUID: 8nZ3f3llQO+VKNjYS/rITw==
X-IPAS-Result: =?us-ascii?q?A0BDAACRiQpp/5EQJK1aHQEBAQEJARIBBQUBZYEXCAELA?=
 =?us-ascii?q?YFtUgeCG4hpA4RNX6cVgX8PAQEBDQJRBAEBhQcCjFcCJjQJDgECBAEBAQEDA?=
 =?us-ascii?q?gMBAQEBAQEBAQEBAQsBAQUBAQECAQcFgQ4ThlyGWwIBAxIVUhACAQgOODElA?=
 =?us-ascii?q?gQBDQ0ahVQDAQKnNQGBQAKKK4F5M4EB4CaBSgGIUgGFboR4JxuCDYEVQoJoP?=
 =?us-ascii?q?oRFhBOCLwSCIoEOhieSb1J4HANZLAFVExcLBwWBIEMDgQsjSwUtHYEkIh8YE?=
 =?us-ascii?q?WBUQINJEAsGaA8GgRIZSQICAgUCQDqBaAYcBh8SAgMBAgI6Vw2BdwICBIIZf?=
 =?us-ascii?q?oIPD4l0AwttPTcUGwUEgTUFllgBgQ6CMA+TKgldj1yjLwqEHKINF6prmQYio?=
 =?us-ascii?q?2aFDgIEAgQFAhABAQaBaDyBWXAVgyNRGQ+OLRbPHIE0AgcLAQEDCZNnAQE?=
IronPort-PHdr: A9a23:J3DBlhIXYXjRN7inEtmcuVQyDhhOgF28FgcR7pxijKpBbeH+uZ/jJ
 0fYo/5qiQyBUYba7qdcgvHN++D7WGMG6Iqcqn1KbpFWVhEEhMlX1wwtCcKIEwv6edbhbjcxG
 4JJU1oNwg==
IronPort-Data: A9a23:4erop69qMJgsZK4TvR4PDrUDyn+TJUtcMsCJ2f8bNWPcYEJGY0x3m
 mpJDGmDaPrYamCjfI93bNy+9k8OvJ7VydVgGQVuqnxEQiMRo6IpJzg2wmQcns+2BpeeJK6yx
 5xGMrEsFOhtEDmE4EzrauS9xZVF/fngbqLmD+LZMTxGSwZhSSMw4TpugOdRbrRA2bBVOCvT/
 4qjyyHjEAX9gWMtazpIs/nrRC5H5ZwehhtJ5jTSWtgT1LPuvyF9JI4SI6i3M0z5TuF8dsamR
 /zOxa2O5WjQ+REgELuNyt4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5nXBYoUnq7vh3S9zxHJ
 HqhgrTrIeshFvWkdO3wyHC0GQkmVUFN0OevzXRSLaV/wmWeG0YAzcmCA2lsYrcz578sJ1tr/
 NA9Bh8JfxaGwOO5lefTpulE3qzPLeHiOIcZ/3UlxjbDALN+EdbIQr7B4plT2zJYasJmRKmFI
 ZFHL2MxKk2cPnWjOX9PYH46tOShnGX+dzRbgFmUvqEwpWPUyWSd1ZCzaISFK4HaG5o9ckCw9
 mT0pGqiBhUjE5+h6hyHw0nrnM7zgnauMG4VPPjinhJwu3WXx2oOGFgNXkC6iee2h1T4WN9FL
 UEQvC00osAPGFeDR935WVi85XWDpBNZA4oWGOwh4wbLwa3Ri+qEOlU5ovd6QIVOnOc9RCch0
 RmCmNaBONClmOL9pa61nltMkQ6PBA==
IronPort-HdrOrdr: A9a23:1ziNcKu5raCnrNI/pD8xLQa47skCMIAji2hC6mlwRA09TyXGrb
 HMoB1L73/JYWgqOU3IwerwRpVoIUmxyXZ0ibNhW4tKLzOWyVdAS7sSo7cKogeQVBEWmdQtr5
 uIH5IObOEYSGIK8voSgzPIUurIouP3jZxA7N22pxwCPGMaDp2IrT0JdjpzeXcGPTWucKBJb6
 Z0kfA33wZIF05nCfiTNz0uZcSGjdvNk57tfB4BADAayCTmt1mVwY+/OSK1mjMFXR1y4ZpKyw
 X4egrCiZmLgrWe8FvxxmXT55NZlJ/K0d1YHvGBjcATN3HFlhuoTJ4JYczAgBkF5MWUrHo6mt
 jFpBkte+5p7WnKQ22zqRzxnyH9zTcV7WP4w1PwuwqgnSW5fkN+NyNyv/MfTvLr0TtngDi66t
 MT44utjesSMfoHplWk2zGHbWAwqqP+mwtTrQdatQ0tbWJZUs4QkWTal3klTavp20nBmdoa+O
 UCNrCv2N9GNVyddHzXpW9p3ZilWWkyBA6PRgwYttWSyCU+pgEy86I0/r1Wop47zuN3d7BUo+
 Dfdqh4nrBHScEbKap7GecaWMOyTmjAWwjFPm6eKUnuUPhvAQOAl7fnpLEuoO26cp0By5U/3J
 zHTVNDrGY3P0bjE9eH0pFH+g3EBG+9QTPuwMdD4IURgMyweJP7dSmYDFw+mcqppPsSRsXdRv
 aoIZpTR+TuKGP/cLw5ljEWm6MiX0X2fPdlzerTAWj+1/4jAreawtDmTA==
X-Talos-CUID: 9a23:EldekmydRUC3fMRWgfeVBgVORfoObySG6k31KmOdJ0ltWbuQDl6frfY=
X-Talos-MUID: =?us-ascii?q?9a23=3AuAJYPA+aAZduLrDLzgpz3k2Qf5du0f+gU0QJqLJ?=
 =?us-ascii?q?FheqiNx1LfC28sCviFw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-08.cisco.com ([173.36.16.145])
  by alln-iport-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 04 Nov 2025 23:18:36 +0000
Received: from alln-opgw-5.cisco.com (alln-opgw-5.cisco.com [173.37.147.253])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-08.cisco.com (Postfix) with ESMTPS id C7DB018000225
	for <linux-scsi@vger.kernel.org>; Tue,  4 Nov 2025 23:18:36 +0000 (GMT)
X-CSE-ConnectionGUID: UxZm7vcxQPGN9x/lnhBMmw==
X-CSE-MsgGUID: T9bx4OpGSDOjw5BzXys3Lg==
Authentication-Results: alln-opgw-5.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.19,280,1754956800"; 
   d="scan'208";a="36729677"
Received: from mail-ch4pr07cu00100.outbound.protection.outlook.com (HELO CH4PR07CU001.outbound.protection.outlook.com) ([40.93.20.96])
  by alln-opgw-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 04 Nov 2025 23:18:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VjQ/+xZ99MquGC72F1H5P2tihkmgD5wP+C1cFyB2W8zVlGGVYmrJheHVltIw6gYdPp0w9U2EYBegw3Nqm4rh/0rn6kHrzGaN/I6HZjADOuKB+Mf84zIZUqxW4P00QeH8xsnfFrjQVl0+Vsf3FHekici/YLfnqgIhZEriTEe/mAhpN7gAFruZf1YnyXbxuwpIUUuGLmXmosnqYRjsNLwo4EaI9hO7Ipm9DqZ0Rq+09x8qBKUXGiWp5mJ4NE+KCmQ+Y1mLnJl1Fxv0M0TYA5BV9Ru7hdXb5cDyf5SW7te26SPbPiC9fTnzIZrVkQ7dwACDnX5DdbfTFjYwxhuv2atC/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1oiwktn/ecErapidfj6PXwsnD40gYmXVXjMSeUXUw+M=;
 b=WR3iASy1Ja7leSMn+QZqsUsS//ylubUuwBHbvqCsTxOCJXLJQe4TA2Q4wpqrZCOO2bwvPeEVCjROqbF0s/97eTvqom9n657LOiIbsHlfLoZrHLp4hvV1zY4POvnsydbpgICpUdqUYb7+wuHL9sw6AVlKPalTEaNFugvvgqJGeJ369IvnW/Cp3cDNkJfQeMuz7eYElZ5mCuxlv2Y5Z7RT7LfUtnXyN5w+6Qz0TQV6hTXw7Wf3gVVZCegbeYjNlVaEjigAmnYxABNo2NsbjzDUoSaKALJGSSpNS/S06FGgyTPaPfzVBqy3nk30X7dzYkePkrQdFlALtNGNbl/gyXNCyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by DS0PR11MB7681.namprd11.prod.outlook.com (2603:10b6:8:f0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Tue, 4 Nov
 2025 23:18:34 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%4]) with mapi id 15.20.9298.006; Tue, 4 Nov 2025
 23:18:34 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Hannes Reinecke <hare@kernel.org>, "Martin K. Petersen"
	<martin.petersen@oracle.com>
CC: James Bottomley <james.bottomley@hansenpartnership.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sesidhar Baddela
 (sebaddel)" <sebaddel@cisco.com>, "Satish Kharat (satishkh)"
	<satishkh@cisco.com>
Subject: RE: [PATCH 2/4] fnic: correctly initialize 'fnic->name'
Thread-Topic: [PATCH 2/4] fnic: correctly initialize 'fnic->name'
Thread-Index: AQHcTXJySJSbNuzO2U69VTaKwnipn7TjJ4uw
Date: Tue, 4 Nov 2025 23:18:34 +0000
Message-ID:
 <SJ0PR11MB589680558302C547642F9286C3C4A@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20251104100424.8215-1-hare@kernel.org>
 <20251104100424.8215-3-hare@kernel.org>
In-Reply-To: <20251104100424.8215-3-hare@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Enabled=True;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_SiteId=5ae1af62-9505-4097-a69a-c1553ef7840e;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_SetDate=2025-11-04T23:17:42.0000000Z;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Name=Cisco
 Confidential;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_ContentBits=3;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Method=Standard
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|DS0PR11MB7681:EE_
x-ms-office365-filtering-correlation-id: 45f459af-04d4-4f37-9ec5-08de1bf87a01
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|10070799003|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-7?B?bUc1TkVnZGtoYmNiZystZkpXTXAxWUU5NCstcDNOUmU4amV6RTVUZFRsZGg0?=
 =?utf-7?B?MEcxQTRoVnhqQ0xxWVdmalhwb1R2dkh0TmxBTTFEYnA2c2VrMEkzdVc2dnl6?=
 =?utf-7?B?Ykx0NXhMTVZEKy1LNkdPcE1IZW85MUIrLWY1UkM1NkFWdDlIQnFLbnlMMjhp?=
 =?utf-7?B?QlFqVzNJOXlzQ2IyMVdQMEhrVGkwbG9pczVTWGxpbFFQcndtUjE1RmtMSXF5?=
 =?utf-7?B?OFc1Y1F6YU42VGVHWCstbnh3MzNSSjJVaFpEOEhMM1I4WEJXMDNRcE9aKy0=?=
 =?utf-7?B?Ky1pYWtvNWx1dDJ6V2x6L2w3MlZ0QlUzOC9LRElGem9uZlE4VksyUVNSRnlE?=
 =?utf-7?B?Ui9TUCstYistOHZvWlVkWHRZZjhrcUo5ZVVaSmxyTEZaTm1vRG03L1A0WlAw?=
 =?utf-7?B?NUc3OHhraVR1bm0yUmV5NUlFcUxUZ25OMUhRcW12YWRkWGhzZHNjY1I2ek5D?=
 =?utf-7?B?ZjhnaWl4N0tSRGxLOEljY0ErLVdXSy9NT2pLOVhzeG56bnNYaEJwV1l6VmtG?=
 =?utf-7?B?d0ZFNWMxdDgyQmhxWlVnYjZZTistbWxhV2R5T1ZyNzFWSllZTVJVNU1aZWNW?=
 =?utf-7?B?Sk5qVHFPTnVveDEzTUM0Q2lGQjdrL2xjaCstKy12Wk42OVRSb0pwaXpaMmU2?=
 =?utf-7?B?dy9qMmE2eUc1SlEySW9YOGhIR2xya0hRd1g0eHlaVW5nUkRNVkptTHAvVEk3?=
 =?utf-7?B?RURxaTFlOGlhTVRRUzdSWEZTY1BZazhBY1JCVnZOV3N1bTJqb1U3MmxXdFht?=
 =?utf-7?B?UEgrLS9iYmpPZDlPMFRPNnkvTlBITkx0aCstZ09hUUJTMGthRmYydm9wT3lO?=
 =?utf-7?B?NmR3RzkvV3lJdk1sMTV0em9malN3NFBXT0c3cnhjdzFLRTFZc3lrVGlQV1hk?=
 =?utf-7?B?Y3c4cEpqb0tzYU9aN05RMXg5Ky1YRTN0NHVuQ3ZGaXMzYmdhMW5JKy0zYTN0?=
 =?utf-7?B?SWlCaWhoNGtTM2xQT1NpcW1TT2pNd21Ra0JVUUpzZWtIRGhhMHd1czNIcFVz?=
 =?utf-7?B?VEdNNnlZNEUwTFJIUEt4TGRvNGRzOWlPcmdYT0JYdlhCdUg4REIzTmgyRDVD?=
 =?utf-7?B?bEpRL256THhHQjdaYzltRmxKaG55UW92NWZ0RWMwenF6UWJjY0JCM2h1ZHBT?=
 =?utf-7?B?bysteENlbVV3Mzc4RFBEVnY5c3dqR2lIUWlueCstOWFxRzlCUjlkQXNXR2pC?=
 =?utf-7?B?Q3VabmY0VDFIMHRKSzE3YkVKbGdGNDJ2NHFjUmt4VHExRGU4MmVHSklqTjJO?=
 =?utf-7?B?M09aOFJFckpJMUpmM3IxOGpqTjdLbTREQ2NOcS9EcFFEZE82em05b1hDN1lJ?=
 =?utf-7?B?Ti80dEY2SmFmSHcxQk83YmMzTVNOb3NScHNZdk5udVVFTlVpSWdhazhBZEpH?=
 =?utf-7?B?MXlFdFJYZGY4OFNIWEprKy1jV3lUTUpnazQ1b1dWSTM4SW82WWdnbzZrT2RH?=
 =?utf-7?B?WXhjR3VSQkZhNndxUDVmMXYvU0NUbDZYcmJzbDY5S0hlS0hFUistbzFWZWNW?=
 =?utf-7?B?NDJaVWVCWmd0SDFiajMxZUQ3MzRCL0doMmJueVdVemwxVDdNUTFXR0tDZXdZ?=
 =?utf-7?B?a3NYUDg2M2E0RTdHcFViNVcxSlo3NkFKaXFUKy1IRFdUaTlnQjU0eHB0RzFv?=
 =?utf-7?B?aW9KbWtaaEZwRzdpSzhxQzRZV3JzcTdTMjF6VEpDVTUrLUtKUGYvZ1ZINFQ0?=
 =?utf-7?B?aExKbi9DZE1mb3RpdWFPMjNCMkg4UGU2RnJ4RWN6SUdGZmtrdjQ0eDFCRFVy?=
 =?utf-7?B?UnV5S0ZNR3NSMEJVU1YvZmRLUWZWajNPaFhaVmNFN0l6cy9zQThMVGtmQkZV?=
 =?utf-7?B?WSstcDlCdzBhVWVGQnhyQkZ5QS9lMERKTnVYc244czNVOW0vMjF4ZkNRQWNR?=
 =?utf-7?B?aXhqOXQzV2JQYmlVZUtEcUYvSzErLURoYU9ySW5GSi9Zdk9ZcCsteDRlNGZT?=
 =?utf-7?B?NUY0M3lqMXYvTW41MnZCM0ExeXdwOEFyM05NVEVxSlRQMm9URWx3QWhFYkpS?=
 =?utf-7?B?N1BXNmpDUjhJWXdqWDI1UDgwcHFBUGk5V3BzZk9wdS9ubjBkSzBuZGZLL3pT?=
 =?utf-7?B?d3RPNkQ3U2xnRkZzQkhWSW1rMkU4VE5uU3FzS1o5UW1m?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-7?B?ZWJXQVE1anhZWUFDRnNVSlpOT2ppVjhmdGNiR1RvUUROY0phQWRpSTJhZmxY?=
 =?utf-7?B?MGFlbWNzdDl6RGF0bS8zMm1ackxWdHpvU3ZSNTcrLXFYL3FpeE5LcVNGSTJ5?=
 =?utf-7?B?V2k3OVRkVHcva09aN3lwQkoyd1FnOEJUSFdiR3FZNVI5T1BWbDJJdzFIa252?=
 =?utf-7?B?U3Mvb0RodTU1WmVHZ3FvYzRyc0hnTFBGR2FxVlBsVlN4M3RzdHo2L0l5MHBy?=
 =?utf-7?B?cGhWSEhuKy00ZDJwLzQ4ZFFVQVNKSlNtUmwwNjd4Ky1ZTWc2cDVVZTFjQmtK?=
 =?utf-7?B?MW9pR29JWHVuU2RrS05DTmtpRi9PeDhtWUxaMmFFTmlKVkhWL2FWU2REcDln?=
 =?utf-7?B?bkJ4VTYvVG5waysteTBDRGx5Q1ZhNEJGN2FqbkY4UDhRQXFVTllldy9BQzBC?=
 =?utf-7?B?RTN1OFc0TFlOU1dnYVFzRjBVZFZ0TkRPLzZKbGt6UVNXMTh1R1NTRGQwakMz?=
 =?utf-7?B?NjF2WjRmTlNLaEcwSWlPMlcvZHpMc0xqTHpjR0dvaEZJakJhOEZQKy1jUDlB?=
 =?utf-7?B?WlgwZHBoNDJqTnVKSm5qdEpiUmdId05TQUIrLUVPVHRlKy1YeDJHWGZ4Rjdx?=
 =?utf-7?B?ZWthc29lWUtHUzlsL0NYNHE4U0FlbDFwRVZIdmoxUW9va3BrUk9mZFdMNjRa?=
 =?utf-7?B?bzFTQm9hQ2hsOTkrLUFkT1ZvSVFyRlVUVTMrLVAvYm9sWGJqWnB2d1dpcmNR?=
 =?utf-7?B?WlBKZWE0UE1INGR3c0ovbmJxRi9HUS90QkhWSWpKTDZzdHdnMkRzanJVTEVu?=
 =?utf-7?B?OURoSWErLWcyWFB1VHRJY1ZHL1hDMUxub3ZiclpJa3EwTXJtbUwyNystb1NB?=
 =?utf-7?B?ZjRvcFpKSkRXaUZZMXliNHpYeHJVTSstR1ZYRjU4eW00WG56Y2JYUnFSQW9y?=
 =?utf-7?B?VThBZVhjaTJ1YklQRnZXdlk2N0pYRFFrd0Y5aDlNYXk0NUNETXg0eUpFeWpL?=
 =?utf-7?B?Tkh1dlBNZ0NDSEFyZmNBeGlhU2paQVRxMExVdzNoS3NHSDByTkJhdFEyUlY5?=
 =?utf-7?B?WGpsVGwvKy14MUFEd2xLZG43a215bnZvQW1EWU03bmY2VHE5ektUc2VXY3du?=
 =?utf-7?B?SXNQTzJ2YnppWjk3VTJMZWRJZkYwZ1VyUlJrT01ZWlRvblRMZHN2L3JoZnhn?=
 =?utf-7?B?Z0ljeWt3S3RHWnkxZTlDc21adnJjUWkrLUFZSmxHMU1hVGNwMlFrY05nMHVD?=
 =?utf-7?B?aFBaM3BvUkVyWDdJSzYybmg1MkdSZmxaY1RYNDJveEUxeXV0dVVVTystYUFv?=
 =?utf-7?B?RFVHM2pBV0ZDTjFRdG9hbCstTm5lZWpla3M1Ky0zTENpVm1SL1RDZEtaTlNs?=
 =?utf-7?B?L2lMKy1FbUhZeXhWT3pEWVVnWEY4RkF2VDR4bTBVTUFhWWsvbzlLMjVueXdH?=
 =?utf-7?B?QmVpY282MGpJZ3JqS3BsaGY0b2VSKy1HZVZlTEtsUjFPZ0cxUFROQzd5VXFP?=
 =?utf-7?B?OW5scDlZKy1ITEFFMTF5aW83RUh4ZkJoNWNSZXZqZ1dPUGJBcFlUWlpSWWtq?=
 =?utf-7?B?U05IVTlJT0hHTk1DTGoxUm8wOUVObW5Od1Y1MTVjVDJGU2hyR2YvUEZKWDRx?=
 =?utf-7?B?MEFSSnlYN05uOEtYWGdxZFk1dk50a0w4T0xEaURKNzF1ekZmbGVXc0hwMkRH?=
 =?utf-7?B?MjNucystbWtEWFM1SEY5NmFSdDhQRWQrLVQ2cFdhcGJFWjZIVW1nM0hNeU5J?=
 =?utf-7?B?aUhuKy10clhFeFdwNzFrdGo2M2tYYi9YWmljMnVKODB1Ky1yTFNEbFJpdkxr?=
 =?utf-7?B?UGsxUU1VcG5qSUxsN0xua2UzajhOck13dW5iUlV4elQ2UHBlUkxCUnFxL01X?=
 =?utf-7?B?cXZBYklmMkZkbGtlS1RJWSsta2UyYVhmMUZXbmtaZ2hPbkFwbSstVzRaamtN?=
 =?utf-7?B?TTBrNDRVTUMwWnNBdnlRbjR1ejZiR3JQNWlpQlFQSlREQkc2Nm5yS1VwcXJq?=
 =?utf-7?B?aVJNNmowYmw0L285VFNKTlA4L0VaLzJtVFMvek9UVWJYUnFuaTVZNHA1VWVv?=
 =?utf-7?B?dWdjMGRJTlhYd2lYTzE4V3p1TmZmOGc3YVRxKy1UbVFRb1pwMkJUd1VUenU4?=
 =?utf-7?B?VFNTTzJlQ21HMzJTd3h0cnlLOVpWVFllbWkzV09rVS9IdW9BcUJzR0hwMGpE?=
 =?utf-7?B?M3FPcEJqbVBwOVltVHJWYWg4cEFyaDFQeTdQQ21YRXBrTDZpR0p4RjVXOVdJ?=
 =?utf-7?B?R2F6SjhuLzBzTm5yRU5MWWU0VGJMN3hobmNOSGJpTjhrTHA5MUkrLUV5d1Jh?=
 =?utf-7?B?SlR3TXV1U0dVSVV1MG93OUhoMlRVS0ZyLy9R?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 45f459af-04d4-4f37-9ec5-08de1bf87a01
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2025 23:18:34.5644
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PbfzbMHQEpWTVxWUeC9RSPs5aiunKNLWozWmhyXGNVr13XQXz472TW0P/fgs/dxDiu6ry4urGELQ5OMMIok8Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7681
X-Outbound-SMTP-Client: 173.37.147.253, alln-opgw-5.cisco.com
X-Outbound-Node: alln-l-core-08.cisco.com


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

Thanks for this change, Hannes.
The fnic team will review this and get back to you.

Regards,
Karan
