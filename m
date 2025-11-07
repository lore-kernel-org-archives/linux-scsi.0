Received: from alln-iport-1.cisco.com (alln-iport-1.cisco.com [173.37.142.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E2524BBE4
	for <linux-scsi@vger.kernel.org>; Fri,  7 Nov 2025 22:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762554263; cv=fail; b=q8tSQSTpoyQQx2kSf4oVGNHWoHzaR523rIJDvvYTCNwGTD7FGPqvN6sjg2vhHrafA/7I7MUc0QWRNnMLk64+4yiW3/v/sco29NCWiFRfniP1klmCB3HE6nB3hh1aoAcO+7px/mzBCO2B1hh8oi0CMYgRAXmxi+6pFo2Q6l8A7Io=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762554263; c=relaxed/simple;
	bh=qS+YBc+Ob/GYUW9EObkE5IucneUpYtkDbj3C52LUVX0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DeCHkxec2y/nGlA37Lc8KWyMkdpCcBKfxfqrxSo3/3he2OQ8G+ArS08gBt3eb5eIqGvOOX44EG7J547y0ZE+2Qog2viTYOpAllIr3r7GDKMQLgZQosGBmXphDh+M62Tg5TqATrtv3vvoMy5icVNIeBE7svhVIzC93yjKzQRCfHQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=iAcxErOi; arc=fail smtp.client-ip=173.37.142.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="iAcxErOi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=7456; q=dns/txt;
  s=iport01; t=1762554261; x=1763763861;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eBuMwakau0z49oQI2j7ztl0f6bAk2bujoAe9C41xmZA=;
  b=iAcxErOi3/WRmcWK4zqY1PQMQW/XWz7SfI1G9ISijq+aB+FB2r0lqvC5
   PIkcOZ5WixKqePnDklOSAV8IzTFgaIrOUPu6t1/cin/7DiEO+2dGQDynp
   yWiY6kmygrhCaxm2iTWKLd9tgAPQsa8hMyZEttqIj5979HjFZVclpUrOl
   uTqDqQsXNMKuGtn1lhtvdhnbPVxmY1lAgQ7SzS7tWfSR1/e9zDDkGj7q2
   +lnCf1sSrkRAT/Pb/yfvDYESA9DyYxNYscDuKzcd4FjEXgrXqmbigPI4L
   zu+fpD0H7NCHfLnyPkckrUj2wFxRptXfHeSPSApCgjiXTIvHsjVf5e/Tq
   g==;
X-CSE-ConnectionGUID: MYm3ZJw2TTakTSq3f1VRjw==
X-CSE-MsgGUID: 32VM8S9yTOCEfx07mkIdiQ==
X-IPAS-Result: =?us-ascii?q?A0A0AADZbw5p/5IQJK1aHAEBAQEBAQcBARIBAQQEAQFlg?=
 =?us-ascii?q?RcHAQELAYFtUgd7gSBJiCADhE1fhliCIZ4dFIFrDwEBAQ0CMSAEAQGCE4J0A?=
 =?us-ascii?q?oxZAiY0CQ4BAgQBAQEBAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHBYEOE4ZPD?=
 =?us-ascii?q?YZbAgEDEmcQAgEIDjgxJQIEAQ0NEweCYYJzAwECo0kBgUACiiuCLIEB4CaBS?=
 =?us-ascii?q?gGIUgGFbhsghD0nG4INgRQBQoJoPoQqAxiEE4IvBIIigQ6GJ5M1UngcA1ksA?=
 =?us-ascii?q?VUTFwsHBYEgQwMqNC0jSwUtHYEkEhAfGBFgVECDSRAMBmgPBoESGUkCAgIFA?=
 =?us-ascii?q?kA6gWgFARwGHBICAwECAjpXDYF3AgIEghx+gg0PiiA8AwttPTcUGwUEgTUFl?=
 =?us-ascii?q?BGCewExXhMIJ3mBA2SSTxQHAgE/gmyQRp9ZCoQcjB6VbxeEBI0TmVSZBiKjZ?=
 =?us-ascii?q?oUOAgQCBAUCEAEBBoFoPIFZcBWDIglJGQ+OLRaEEbs5eDwCBwsBAQMJkWuBf?=
 =?us-ascii?q?AEB?=
IronPort-PHdr: A9a23:E0ASChQ3n6vR3XToE3bhOXADaNpso47LVj580XJvo7tKdqLm+IztI
 wmCo/5sl1TOG47c7qEMh+nXtvX4UHcbqdaasX8EeYBRTRJNl8gMngIhDcLEQU32JfLndWo7S
 exJVURu+DewNk09JQ==
IronPort-Data: A9a23:pTds8qlt0xKhFcFLYo4h1IPo5gzLJ0RdPkR7XQ2eYbSJt1+Wr1Gzt
 xIYDDuHO/iCZmSmc9l0atvk8BkB7JfTnYdlSAo4qyoxRltH+JHPbTi7wugcHM8zwunrFh8PA
 xA2M4GYRCwMZiaC4E/raf658SUUOZigHtLUEPTDNj16WThqQSIgjQMLs+Mii+aEu/Dha++2k
 Y20+py31GONgWYubztNs/3b83uDgdyr0N8mlg1mDRx0lAe2e0k9VPo3Oay3Jn3kdYhYdsbSb
 /rD1ryw4lTC9B4rDN6/+p6jGqHdauePVeQmoiM+t5mK2nCulARrukoIHKZ0hXNsttm8t4sZJ
 OOhGnCHYVxB0qXkwIzxWvTDes10FfUuFLTveRBTvSEPpqHLWyOE/hlgMK05Fagp/71FI34Uy
 cARKww2d0uN3tyMwq3uH4GAhux7RCXqFIobvnclyXTSCuwrBMiSBa7L/tRfmjw3g6iiH96HO
 JFfMmQpNUqGOkERUrsUIMpWcOOAhXDlbzxcoVG9rqss6G+Vxwt0uFToGISMIYDQFZ8Exi50o
 EqdpVrcUipLJeC44heL4irzg+zukSLCDdd6+LqQs6QCbEeo7mgSDgAGEECwuviRlEGzQZRcJ
 lYS9y5oqrI9nHFHVfH0Wxm+5XrBtRkGVp8IQqsx6RqGzezf5APx6nU4cwOtoecO7acebTcrz
 VSO2djuAFRSXHe9EBpxKp/8QeuOBBUo
IronPort-HdrOrdr: A9a23:0iDmsaPsZpXmHsBcT4f255DYdb4zR+YMi2TDiHoBKiC9I/b5qy
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
X-Talos-CUID: 9a23:A7XUvWzWPFeuG1l8jpd3BgUxK8V+QF/ClkvsKkyEMn8yRuSrc12PrfY=
X-Talos-MUID: 9a23:mS8yVgjaykUcgfAcF78xksMpb51WxvSVWVExtr4rtdncailzGjuctWHi
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-09.cisco.com ([173.36.16.146])
  by alln-iport-1.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 07 Nov 2025 22:23:11 +0000
Received: from alln-opgw-5.cisco.com (alln-opgw-5.cisco.com [173.37.147.253])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-09.cisco.com (Postfix) with ESMTPS id 858C718000175
	for <linux-scsi@vger.kernel.org>; Fri,  7 Nov 2025 22:23:11 +0000 (GMT)
X-CSE-ConnectionGUID: y73agW5URz68Dj7CeZI5YQ==
X-CSE-MsgGUID: GqEhN103SimOaAB940icRQ==
Authentication-Results: alln-opgw-5.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.19,288,1754956800"; 
   d="scan'208";a="36867067"
Received: from mail-bn1pr07cu00305.outbound.protection.outlook.com (HELO BN1PR07CU003.outbound.protection.outlook.com) ([40.93.12.5])
  by alln-opgw-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 07 Nov 2025 22:23:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mp3EDeKAQ2le+STlrbTOoz4bKQvDLze4eVr9sezqFL8udngJph6lX2avhDWcrGVrfi11+G7djBCMCEeXiR9ChQsPIrFvyPhGddZbiXySARy8jCk36HONu42bCJI8i+DMpVWS4GzQtHvckklohmF86alewdU9vvCXUwSsJpqVpxH0sPjaeHvyUTnSeg9tQIxMj9kI3qR2mUyWykvD1TBvPRYTAG0AgFGhXvg2AwQXhmjmbxRPz04yi5aS4gfotkta8w8wy/ewsy1kaOq+So5AXohp2wogFsftZPFLZIc2uhHWhqZh8QKInjEI5Yx95R4UX87+2aWKhfX5eL5wZ0Qn0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eBuMwakau0z49oQI2j7ztl0f6bAk2bujoAe9C41xmZA=;
 b=KprJ19QQ0iofOhAG9KU10tuwuYe+LOYo8Frz7Ba7M4WunxqICdh4IB7oQHeKtPfhobrLyEYaCxoguyO0rJGWqOb8GIjXh7i0WBOWWOCUX9nUvWFtYWkhv8y4l/+QsGb62xubJ0+i6QGducTuq8XziYRERzTif0cxgF2xOiMZ0F0nJXUAvJEEE3s+bQKJsJn30pm46zjHvb6UXz7WoeElB4IrXqWTI6IRC39hcK/pwsadFUc8w6Bxjy09nzTy2+7FGF+kr0OG7ZELFmGEvmfjeUDyv9jrto9NyJHVbfI1WaelajtQOVFHl2p9v3SoLMBMMbOVejyf8wbJNZWxYyTrtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by IA1PR11MB6147.namprd11.prod.outlook.com (2603:10b6:208:3ed::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.13; Fri, 7 Nov
 2025 22:23:07 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%4]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 22:23:07 +0000
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
Thread-Index: AQHcTXJy2FynwvhbtEuofvwLS32KDLTmNqmAgACvswCAAOdagA==
Date: Fri, 7 Nov 2025 22:23:07 +0000
Message-ID:
 <SJ0PR11MB58964721E3ABEF2CF62D7D10C3C3A@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20251104100424.8215-1-hare@kernel.org>
 <20251104100424.8215-5-hare@kernel.org>
 <SJ0PR11MB5896BDD3102F17EA15356C95C3C2A@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <b8631995-a3df-4232-9f89-514d7a502bc0@suse.de>
In-Reply-To: <b8631995-a3df-4232-9f89-514d7a502bc0@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Enabled=True;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_SiteId=5ae1af62-9505-4097-a69a-c1553ef7840e;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_SetDate=2025-11-07T22:17:28.0000000Z;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Name=Cisco
 Confidential;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_ContentBits=3;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Method=Standard
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|IA1PR11MB6147:EE_
x-ms-office365-filtering-correlation-id: 1f0c2c3b-827d-4fa7-0c77-08de1e4c39e8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-7?B?bDJRcGN1NHl5Y3dGUTl3NndsdmhhQXJuMy9IbjlkRzF4SmdtVHZsaGVWL2Y4?=
 =?utf-7?B?ZEw4aml2QlBLRjBCakw4WG5YNE5OMWxxeFMrLU5Hc0hVaUFnSkQwNGRUOEJa?=
 =?utf-7?B?RUxVc2d0WHc5N3YzRm9GbTVrKy04YjMwTzNWQVpVWnZOQ2pzWWl0VnY3OWlh?=
 =?utf-7?B?d05VSjVCWGdJelZHSUZ3b0VoOFAxbGFvbGh3eVNEMmdJZ0QvYmpidFBnOGE4?=
 =?utf-7?B?QistQjJSUnF6Unp0WWN2Tkh1VG9zQlJCNVZ1Ky1OQWhZdDZxOGRSVUNPc25Q?=
 =?utf-7?B?eENmMVFOWnlCbnRwZ0w1NmZiaTBLRmtyYktQNmFNMVQ2YldkY0ErLUhMWkVN?=
 =?utf-7?B?Q2IyZHluTElOalhtQkM5UlcyY3FIdWhWWlVKaHZTdXNCeEVYTUxDb1IxUElJ?=
 =?utf-7?B?RENsOXorLU1vRy9TUHJjQWh6Q3RRSUptL2tqbnlwYnNSYVlpam5JTGN4bjNt?=
 =?utf-7?B?WTZlSUN2N2RWN1h2OExYdmRBUlBLdFpROHNrd2owdzVPbzA2OWNPdTg1cHBz?=
 =?utf-7?B?bFY0ZVZOWjhQMGsrLVNDQ1ZSbjlDVDVIelhmTjQ5UmY5Q014eFNzWEsxOWox?=
 =?utf-7?B?bEVhOW9jQ015WDFHbSstWFJTWmRjeTA5WkRrcEJ5Zi9BUVNieER0Z00vNXcy?=
 =?utf-7?B?ejJFMndseDJEbXVpRjVOOUdYN3BxSHEyeEF2NnMyRlRzZ3FDcE1kTFJYSE1k?=
 =?utf-7?B?c0FhUGtmM3hFQ3ZFWGhhODZSZ296VWRYQmJWTUFiREE1Q0s5Qm1rSmN2Ky0y?=
 =?utf-7?B?MWU0cjhjRW96OEhFeWJhd3JPVEYvc05VbUxMREM5TjJxZHJYR28xQWFFUHdr?=
 =?utf-7?B?THQwRmVJTXorLXZJUUxYQ1lhcjBONFVsd1ptcTNpNVJVaElRNVE0VHEwVVV6?=
 =?utf-7?B?UGZqblZTVlJ0Wm9NRG5GZjAycGZVN1FBZistQmh6M3VDS0tGMlNzR0tUZzZi?=
 =?utf-7?B?NEpub1BsSFgzQUwxV0MyWUF6cFJEU09VcEdVckF6MzVETXhPNTNwNWh6dlV0?=
 =?utf-7?B?UndKZmxEMm1mMjFHWExrRnhXTFVOeUpOSkVWeEJvZHVzc3hsNDR6QXVjNUNJ?=
 =?utf-7?B?Ym92OGdxcloxWXVxQk5pa09BM0RtaEZUR1p0MGdCcCstM3U2Ky1kc2RXNHRP?=
 =?utf-7?B?M1huOUpRMnh3OXdlWUcxNVFjeUpQbTVXcGNweTNiM2tZN1pDZXFZM1QrLTFa?=
 =?utf-7?B?ZWkxeUNIeElJdVp4elFVQjA5VjB3cWFYa2puZVA3S1RqeVh1Ky1wcVNibzJh?=
 =?utf-7?B?UHl0aldhSVpYajF0NFlZT1ZJQTc1Um1zRVRTbVFFWVlmV0h0ZDJaRjg0d2lF?=
 =?utf-7?B?U0R4WUJCdmdBSmI1UDVlLzlRTlNuanZ2b3l2SjQ4S0NweU1ocDNmSW91WFNk?=
 =?utf-7?B?ZHI1eU4rLUFGVlpnbWFFWVN4VU94TzE0c2NSQ0ZHeFVLZ2pXb2Y0VlJvWUFL?=
 =?utf-7?B?VmxNM05YdzNqd2RMNEV0SUQycDBubDUwMXQrLU1hNktDMDFJcjRSWm10WEFP?=
 =?utf-7?B?TWx5UUZVN2lkbkMwdmFoZVlGY1NtY28rLTVra1NSdmY0YkkyMnk5WkM2Yzhq?=
 =?utf-7?B?Yk9VYjVUUk83YnRUMkFzUVpsaksyRjA2VkhreHUvODhrRDNGS2x5bk9jQUNY?=
 =?utf-7?B?RExYY2Y3M0RibTZKalMxMk00eFdvVmovN3B4L0lDdWJ3dy9Xc1JlR2pWbk40?=
 =?utf-7?B?aTRsMGdyODc3dGwxT1JDZEZRbUJyUjJIWHZqOHJqQzZ3a2pBUnBEUWpQNmo5?=
 =?utf-7?B?YWdrQXYwKy1uTjNiNG1qc1VqVU9aeUxsRWE4ZXhOcE85eDdjVHg0YU5FRDlF?=
 =?utf-7?B?Tzl6ekFaZlFJT0V3ZkM5VmY0Q1MwM0FiS0J2V3M5WGJBRk40S2pvb0tjc2ty?=
 =?utf-7?B?WUhYZ1kyanpuMEdQcWVrZ3JtU0lPMXNzWkszVSstY0FObExTbTNiNi95RUZD?=
 =?utf-7?B?WTdNeVd3LzN4SWFtelIwVWcyYUFFcWN6M3NqbHYwL0VrTVdHM1BwMFV0enV3?=
 =?utf-7?B?OXpFbista3VETkRSRUFEazNBM0RzdUpEU0p1c04yT3BQTWwwZ3VzQzFXbmxK?=
 =?utf-7?B?a0svY2VYdEpFbmVrZDJ6UEFRZUhyVUpPVkJL?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-7?B?Z290eDV1UFRLZWt1a0toZjB1bGU2UThTMk5PMlA4ZFlBa0FSbEZ5QjhjZmxi?=
 =?utf-7?B?eURDRVVsekt5c25VblIvN0d5TW9CTFNsVUZHOHpJT0xPWDB6QkdCc3JFblJQ?=
 =?utf-7?B?WmxZT01HaistN0NnRTFXWXBVTG1ZenpVOXlxWCstdjFIZFNkaFR2Rmx1dzZM?=
 =?utf-7?B?bDVVa2xLNVVGcE8rLXdkNTRuUmVSYistaFVKMWhqQ2pVYkM2Q2dsWGxLZTFP?=
 =?utf-7?B?c2Q1OXJkd1Q4MmxGb0tFZURjbXNxZmpSSkpBaWNVbi8xZVRUVkRKVVlRRVBO?=
 =?utf-7?B?VHd6N0FFTjczUWNYSjIxQ0g5dGVXTVhkQWV1aW1VL1RRaktIUklNWnY2UGVH?=
 =?utf-7?B?NlJVRlhYa0JQYTFyVWVsQzdjRU9RRUpubjNnbjhRKy1yYWpzUTZzOHVISENl?=
 =?utf-7?B?OXNGYXdOd240bVVXKy00bmRPMlY1V2pSL1Fvd2tkQTY1Rm15RVNHZS9WcHdw?=
 =?utf-7?B?bystQldUSTVjbDhueUg4VmZqWjJ4WUJHa3Z6TnFQRGNMRWlzQ2p6bERBaWJC?=
 =?utf-7?B?Q09QZkhZVi81THQ1cnRWaHBKQnJBd1NtS3VxRmRMMzduV0dMcmEwekZkUnNM?=
 =?utf-7?B?OC84UUxPZFVBaDdmam84cFRDQVB6c3JQVXppZmhTNTNJVVdpMmZ3dGxBR25W?=
 =?utf-7?B?OSstdS9YZTV2M203UnNMdE92WUZsYVc4MnNuVzE4bktQUUJMQWV4TDRKdkFS?=
 =?utf-7?B?TWFOUWNLRE13TG00TjJuTkF6cUR1Tm5oamg4amRuTkxPSkVIa3cvNkVZenFt?=
 =?utf-7?B?NWVNMVZkbXRqenI4eHZRU1k3TnJjUm9VRUVONFpnYUhkODQ0bXpuMGd5WG82?=
 =?utf-7?B?Y3htcGRWeURpWGJXQXQ3QTUrLVZXeWNIbHk0cDNUYk5QcEY1OWdEOFMwQmtm?=
 =?utf-7?B?WHFSTzhaWkM1NFlYaTZWbzhvcUVRdG1IZjhkNHRVSm1DRDBqUFFIL3JWSG9h?=
 =?utf-7?B?TmRwQTJMTEhidTRIOEhZRGpyOFFFZUNSVDNVb09lM2MwVTlOZmxWODRnejh3?=
 =?utf-7?B?UWJYM0FZcVlXV0JsNGhIa2ZzRSsta0RkeUFHMzlMRzZMV2VqM3BRKy12SUFq?=
 =?utf-7?B?RjArLWNMb2hMMEFtbjhuelZrc1JzeWFSZUNCazdQWUwyam5RL2FnaUJxdTJQ?=
 =?utf-7?B?U3NBYndsNlBiVmVGWkFScnFVMHBzWFJZZEJBYTJHUUw5VkpsRmZkSGtCc1U1?=
 =?utf-7?B?WUFicXZ1MVBHdWxzNUdxQnY0NUg2cVd1RUw1blBIY0dzYXV0WGJwMVk4ajFo?=
 =?utf-7?B?NTRENDJwKy1MenBuNEErLUhRQ1B3TmhNcVlLVzZ5M0hHaGJaLzQrLU9namdW?=
 =?utf-7?B?cUlLTzFjYW5abTNCN2JSdERISUwzSC9CTWt2cDUxbGx3d085aVlzS2Z0L3Bw?=
 =?utf-7?B?emwzU0YwcTdHNlFsa0VSbkdUY2o1S1dIaEJpQjhvV0ZuOWQvTGkwVjdpN3Q3?=
 =?utf-7?B?cTNwd1RtQ3VYWHdpM1VQeG9MUXNjck1tMkZXeXFJTVltQWdwNlNwTnhsZVhu?=
 =?utf-7?B?S2NMelUzbTJYYnhBZTgrLWJXTUJRWSstTmxCeW95Ky1VNDRpUmxVMWVZSHVa?=
 =?utf-7?B?cnVzcUgzMmxnUnpJakN5SnV4UDgxNVZHY3cyZlFnNFllNVd6elp0d0FSQm90?=
 =?utf-7?B?SGtXZGsrLTdoSkRXQ3BNbmc2S2ZHaGl6NnJpVlo5ZkpiSFlrWHlPRGJuelll?=
 =?utf-7?B?TE0rLUk3ajRLQjhDeFhFMystdFFNT2tHRjcyQkNNNG13Zm1XZmpTa0ZMcEha?=
 =?utf-7?B?QnVvVnRMdi9wcTJGTWFxZTByZlVwOG5jeHdraFF0QXAzSTRwSHFDWXMxQnJN?=
 =?utf-7?B?M2VYcGlVTy9NUTllVistQ3dJaXQ0eUZrNENxaUZRRXp6eS9GSE41VWhzZ093?=
 =?utf-7?B?STgzNWlyT09UeFNMbGJrQUxTbGVOQnEzWFBrcklQMFlCdUh0SHB3ZlorLS9i?=
 =?utf-7?B?S055d3ZGbWNxck5lR0tlU3RSRGRKdEwvUVFjTksza0VMdzQvZUhLR0NaZi8w?=
 =?utf-7?B?MHZyTklUTmpIZTZZUkJOZUNaQXRLa2lLMUJTRjdxWFFoR3NxeTRVYnAzNFR6?=
 =?utf-7?B?eGRPR3o0aW9la0Z3V3h0TW9saVM0M2lMN0diVGpvMVA0MWhua21RQzB2MWty?=
 =?utf-7?B?eUhOUkFXS0pMUHVPSm1UVUxaUms1UnVST25sckxWVUVndjYrLVpPT0VYKy01?=
 =?utf-7?B?cW85bzQ=?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f0c2c3b-827d-4fa7-0c77-08de1e4c39e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2025 22:23:07.0773
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ko4ooymFpEFzbveUeu8YNoFhAqIy9TpTLvBVlmnYBFUQt1o/Wgma2VsgyPqcu2cnlA95OnBSv879fWXq6vKm9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6147
X-Outbound-SMTP-Client: 173.37.147.253, alln-opgw-5.cisco.com
X-Outbound-Node: alln-l-core-09.cisco.com


Cisco Confidential
On Friday, November 7, 2025 12:29 AM, Hannes Reinecke +ADw-hare+AEA-suse.de=
+AD4- wrote:
+AD4-
+AD4- On 11/6/25 23:09, Karan Tilak Kumar (kartilak) wrote:
+AD4- +AD4-
+AD4- +AD4- Cisco Confidential
+AD4- +AD4- On Tuesday, November 4, 2025 2:04 AM, Hannes Reinecke +ADw-hare=
+AEA-kernel.org+AD4- wrote:
+AD4- +AD4APg-
+AD4- +AD4APg- In some environments (eg kdump) not all CPUs are online, so =
the MQ
+AD4- +AD4APg- mapping might be resulting in an invalid layout. So make the=
 interrupt
+AD4- +AD4APg- mode settable via an 'fnic+AF8-intr+AF8-mode' module paramet=
er and switch
+AD4- +AD4APg- to INTx if the 'reset+AF8-devices' kernel parameter is speci=
fied.
+AD4- +AD4APg-
+AD4- +AD4APg- Signed-off-by: Hannes Reinecke +ADw-hare+AEA-kernel.org+AD4-
+AD4- +AD4APg- ---
+AD4- +AD4APg- drivers/scsi/fnic/fnic.h      +AHw-  2 +--
+AD4- +AD4APg- drivers/scsi/fnic/fnic+AF8-isr.c  +AHw- 13 +-+-+-+-+-+-+-+-+=
-----
+AD4- +AD4APg- drivers/scsi/fnic/fnic+AF8-main.c +AHw- 10 +-+-+-+-+-+-+-+-+=
--
+AD4- +AD4APg- 3 files changed, 19 insertions(+-), 6 deletions(-)
+AD4- +AD4APg-
+AD4- +AD4APg- diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fn=
ic.h
+AD4- +AD4APg- index 1199d701c3f5..c679283955e9 100644
+AD4- +AD4APg- --- a/drivers/scsi/fnic/fnic.h
+AD4- +AD4APg- +-+-+- b/drivers/scsi/fnic/fnic.h
+AD4- +AD4APg- +AEAAQA- -484,7 +-484,7 +AEAAQA- extern struct workqueue+AF8=
-struct +ACo-fnic+AF8-fip+AF8-queue+ADs-
+AD4- +AD4APg- extern const struct attribute+AF8-group +ACo-fnic+AF8-host+A=
F8-groups+AFsAXQA7-
+AD4- +AD4APg-
+AD4- +AD4APg- void fnic+AF8-clear+AF8-intr+AF8-mode(struct fnic +ACo-fnic)=
+ADs-
+AD4- +AD4APg- -int fnic+AF8-set+AF8-intr+AF8-mode(struct fnic +ACo-fnic)+A=
Ds-
+AD4- +AD4APg- +-int fnic+AF8-set+AF8-intr+AF8-mode(struct fnic +ACo-fnic, =
unsigned int mode)+ADs-
+AD4- +AD4APg- int fnic+AF8-set+AF8-intr+AF8-mode+AF8-msix(struct fnic +ACo=
-fnic)+ADs-
+AD4- +AD4APg- void fnic+AF8-free+AF8-intr(struct fnic +ACo-fnic)+ADs-
+AD4- +AD4APg- int fnic+AF8-request+AF8-intr(struct fnic +ACo-fnic)+ADs-
+AD4- +AD4APg- diff --git a/drivers/scsi/fnic/fnic+AF8-isr.c b/drivers/scsi=
/fnic/fnic+AF8-isr.c
+AD4- +AD4APg- index e16b76d537e8..b6594ad064ca 100644
+AD4- +AD4APg- --- a/drivers/scsi/fnic/fnic+AF8-isr.c
+AD4- +AD4APg- +-+-+- b/drivers/scsi/fnic/fnic+AF8-isr.c
+AD4- +AD4APg- +AEAAQA- -319,20 +-319,25 +AEAAQA- int fnic+AF8-set+AF8-intr=
+AF8-mode+AF8-msix(struct fnic +ACo-fnic)
+AD4- +AD4APg- return 1+ADs-
+AD4- +AD4APg- +AH0-
+AD4- +AD4APg-
+AD4- +AD4APg- -int fnic+AF8-set+AF8-intr+AF8-mode(struct fnic +ACo-fnic)
+AD4- +AD4APg- +-int fnic+AF8-set+AF8-intr+AF8-mode(struct fnic +ACo-fnic, =
unsigned int intr+AF8-mode)
+AD4- +AD4APg- +AHs-
+AD4- +AD4APg- int ret+AF8-status +AD0- 0+ADs-
+AD4- +AD4APg-
+AD4- +AD4APg- /+ACo-
+AD4- +AD4APg- +ACo- Set interrupt mode (INTx, MSI, MSI-X) depending
+AD4- +AD4APg- +ACo- system capabilities.
+AD4- +AD4APg- -      +ACo-
+AD4- +AD4APg- +-      +ACo-/
+AD4- +AD4APg- +-     if (intr+AF8-mode +ACEAPQ- VNIC+AF8-DEV+AF8-INTR+AF8-=
MODE+AF8-MSIX)
+AD4- +AD4APg- +-             goto try+AF8-msi+ADs-
+AD4- +AD4APg- +-     /+ACo-
+AD4- +AD4APg- +ACo- Try MSI-X first
+AD4- +AD4APg- +ACo-/
+AD4- +AD4APg- ret+AF8-status +AD0- fnic+AF8-set+AF8-intr+AF8-mode+AF8-msix=
(fnic)+ADs-
+AD4- +AD4APg- if (ret+AF8-status +AD0APQ- 0)
+AD4- +AD4APg- return ret+AF8-status+ADs-
+AD4- +AD4APg- -
+AD4- +AD4APg- +-try+AF8-msi:
+AD4- +AD4APg- +-     if (intr+AF8-mode +ACEAPQ- VNIC+AF8-DEV+AF8-INTR+AF8-=
MODE+AF8-MSI)
+AD4- +AD4APg- +-             goto try+AF8-intx+ADs-
+AD4- +AD4APg- /+ACo-
+AD4- +AD4APg- +ACo- Next try MSI
+AD4- +AD4APg- +ACo- We need 1 RQ, 1 WQ, 1 WQ+AF8-COPY, 3 CQs, and 1 INTR
+AD4- +AD4APg- +AEAAQA- -358,7 +-363,7 +AEAAQA- int fnic+AF8-set+AF8-intr+A=
F8-mode(struct fnic +ACo-fnic)
+AD4- +AD4APg-
+AD4- +AD4APg- return 0+ADs-
+AD4- +AD4APg- +AH0-
+AD4- +AD4APg- -
+AD4- +AD4APg- +-try+AF8-intx:
+AD4- +AD4APg- /+ACo-
+AD4- +AD4APg- +ACo- Next try INTx
+AD4- +AD4APg- +ACo- We need 1 RQ, 1 WQ, 1 WQ+AF8-COPY, 3 CQs, and 3 INTRs
+AD4- +AD4APg- diff --git a/drivers/scsi/fnic/fnic+AF8-main.c b/drivers/scs=
i/fnic/fnic+AF8-main.c
+AD4- +AD4APg- index 870b265be41a..4bdd55958f59 100644
+AD4- +AD4APg- --- a/drivers/scsi/fnic/fnic+AF8-main.c
+AD4- +AD4APg- +-+-+- b/drivers/scsi/fnic/fnic+AF8-main.c
+AD4- +AD4APg- +AEAAQA- -97,6 +-97,10 +AEAAQA- module+AF8-param(pc+AF8-rscn=
+AF8-handling+AF8-feature+AF8-flag, uint, 0644)+ADs-
+AD4- +AD4APg- MODULE+AF8-PARM+AF8-DESC(pc+AF8-rscn+AF8-handling+AF8-featur=
e+AF8-flag,
+AD4- +AD4APg- +ACI-PCRSCN handling (0 for none. 1 to handle PCRSCN (defaul=
t))+ACI-)+ADs-
+AD4- +AD4APg-
+AD4- +AD4APg- +-static unsigned int fnic+AF8-intr+AF8-mode +AD0- VNIC+AF8-=
DEV+AF8-INTR+AF8-MODE+AF8-MSIX+ADs-
+AD4- +AD4APg- +-module+AF8-param(fnic+AF8-intr+AF8-mode, uint, S+AF8-IRUGO=
 +AHw- S+AF8-IWUSR)+ADs-
+AD4- +AD4APg- +-MODULE+AF8-PARM+AF8-DESC(fnic+AF8-intr+AF8-mode, +ACI-Inte=
rrupt mode, 1 +AD0- INTx, 2 +AD0- MSI, 3 +AD0- MSIx (default: 3)+ACI-)+ADs-
+AD4- +AD4-
+AD4- +AD4- Based on fnic team's review: there is a way to choose the inter=
rupt mode using the UCS management platform.
+AD4- +AD4- We do not want to expose this as a module parameter.
+AD4- +AD4-
+AD4- Yeah, I know. It was primarily used during testing to easily change
+AD4- between the various modes.
+AD4- I can drop it for the next round.

Thanks Hannes. Sounds good.

+AD4- +AD4APg- struct workqueue+AF8-struct +ACo-reset+AF8-fnic+AF8-work+AF8=
-queue+ADs-
+AD4- +AD4APg- struct workqueue+AF8-struct +ACo-fnic+AF8-fip+AF8-queue+ADs-
+AD4- +AD4APg-
+AD4- +AD4APg- +AEAAQA- -869,7 +-873,11 +AEAAQA- static int fnic+AF8-probe(=
struct pci+AF8-dev +ACo-pdev, const struct pci+AF8-device+AF8-id +ACo-ent)
+AD4- +AD4APg-
+AD4- +AD4APg- fnic+AF8-get+AF8-res+AF8-counts(fnic)+ADs-
+AD4- +AD4APg-
+AD4- +AD4APg- -     err +AD0- fnic+AF8-set+AF8-intr+AF8-mode(fnic)+ADs-
+AD4- +AD4APg- +-     /+ACo- Override interrupt selection during kdump +ACo=
-/
+AD4- +AD4APg- +-     if (reset+AF8-devices)
+AD4- +AD4APg- +-             fnic+AF8-intr+AF8-mode +AD0- VNIC+AF8-DEV+AF8=
-INTR+AF8-MODE+AF8-INTX+ADs-
+AD4- +AD4APg- +-
+AD4- +AD4APg- +-     err +AD0- fnic+AF8-set+AF8-intr+AF8-mode(fnic, fnic+A=
F8-intr+AF8-mode)+ADs-
+AD4- +AD4APg- if (err) +AHs-
+AD4- +AD4APg- dev+AF8-err(+ACY-fnic-+AD4-pdev-+AD4-dev, +ACI-Failed to set=
 intr mode, +ACI-
+AD4- +AD4APg- +ACI-aborting.+AFw-n+ACI-)+ADs-
+AD4- +AD4APg- --
+AD4- +AD4APg- 2.43.0
+AD4- +AD4APg-
+AD4- +AD4APg-
+AD4- +AD4-
+AD4- +AD4- Thanks for these changes, Hannes.
+AD4- +AD4- For the other changes in this patch, I will need to test and ge=
t back to you.
+AD4- +AD4-
+AD4-
+AD4- Thanks.
+AD4- The 'reset+AF8-devices' thing is primarily there for kdump+ADs- might=
 be an idea
+AD4- to make is explicit by using 'is+AF8-kdump+AF8-kernel()' directly.

Yes Hannes. That would be better. Thanks.

+AD4- Cheers,
+AD4-
+AD4- Hannes
+AD4-
+AD4- --
+AD4- Dr. Hannes Reinecke                  Kernel Storage Architect
+AD4- hare+AEA-suse.de                                +-49 911 74053 688
+AD4- SUSE Software Solutions GmbH, Frankenstr. 146, 90461 N+APw-rnberg
+AD4- HRB 36809 (AG N+APw-rnberg), GF: I. Totev, A. McDonald, W. Knoblich
+AD4-

I'm bringing up a setup to test. I'll wait for your next revision.

My plan is to induce a kdump to test out these changes.
If you have any other tests in mind, please let me know.

Thanks,
Karan
