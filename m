Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8187310A1E
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2025 10:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753699581; cv=fail; b=XY+7z3rWDldpaxTB4WhHy01E3tqIHaY7oBDl/ax1hj0EJEsAzEG3qhTO5sq2TJ9HZp2/3HTm5cCGyIzMcmfpPUQWmRFd7l5TeBxH3MUgLCP/ljj0O5v5yl9i9U4hlC3lOm2lZRo5bsec2vRy2YJsy+IjwzlNqiTahV0WCQIaM5Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753699581; c=relaxed/simple;
	bh=5WiRCK/Q84n/DnMRQupyZmJml8WtM32f+MCHnzkyCX8=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=V+LR/om7a5YJPehloCaIgVOd024fbf64liUw9Nlc6+MAJ1HD1mUFYFNQ3tao6jfys8kUuBuqS5xYbkgRuReMeEx61xSwriyxzDCkLcy8Nis5fG+vYqsA9Ovoj05jcYUc5PqGY4byayrRJozo92pDU50VCmbQ6VcH2db16KL9zNk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=jqD2XFn+; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ZvAUmFn6; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jqD2XFn+";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ZvAUmFn6"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1753699580; x=1785235580;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=5WiRCK/Q84n/DnMRQupyZmJml8WtM32f+MCHnzkyCX8=;
  b=jqD2XFn+8g/iE6DAL/s24avuIskmrAvSOH5TT/GXBdEVCdxaGSiHVZHI
   spRD3xzu1Lo7NI0ks9CFsXSZdPyu8Z7Wf1rM7zaK7ujozNNs3KhAg+GTv
   8Hu419HFgZw2qHyRSGS5uHVP0ra+zy+7dombfwSo6fxEBmtnqH2YWrRHS
   N7KLP/gen4KSdNimgZOyTC2Lws9ZWuBhKscX9PGLdbNQcwnN8leEW0inW
   Yu3CkXdndAypNeXTba6n3bPzW6tKDW/wKV95MzMvsst7b9TZk7+g0aXe7
   pAhE0t96fXYHXA34kCQs0D32j8eVT4eN8bxLsBKZYcO7EGutJVB1T/1Xa
   g==;
X-CSE-ConnectionGUID: KbsKBUibSYW/nIqG9o7OeQ==
X-CSE-MsgGUID: SzXuFbLES5SOJ4kbuMYUYw==
X-IronPort-AV: E=Sophos;i="6.16,339,1744041600"; 
   d="scan'208";a="99909439"
Received: from mail-dm6nam12on2078.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([40.107.243.78])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jul 2025 18:46:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kP8S13zPXkWzG7SSgmF4lnbvIouOq8vlk35BqnIghVQgqkbL/yG7L45W0EsXQ3Yu/sc1Mz51+hZgN2yyygAxTYWPWhEqC7jLOKEWquzJB9atbBlj0IdptMyz66B4jR0tSdCUk5zvN4x1bH562Vh8GVZHO2h1uLx6UOoO84sayOYyS9Mv6tc4TMSCOy7Lfm4s6SK55R799F59t0m0Bd3anzi8WglnjEmPo13dnhfEYDM5S/c00z6CVL7GviSw7Aa4iKeaexud8V+32s3MvwHkASMoGnbGO13FItM1BA1Ovkt1jQEucHJ/D2LCxeaKhy/sRjCsRaWq1UO1lIZP7OxJsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5WiRCK/Q84n/DnMRQupyZmJml8WtM32f+MCHnzkyCX8=;
 b=b9qd40VWSO5GPOAJPk+ueH7TCTrsdXjUHLn7pDq54PEnzrMccmn3aGHgGAgAuICgd1IIGFx41LZu5DKfga17nC0RwuVhFP2QJ727uxzERE0LbfMeicz9fv/s7yTSIy3nLqfbMzk7kvZ8q67IyGxbHAKJZ8vJGIBzOD14BZA0hYa3Nr6YAjrl2ccdJnG7O8sh/smk40FRKMqnC50AqQRJjyPc2Z0k0VhrkC9FQDwpCLlp4/nIVeBXRNWTthTw2dbB38FQZeOYFJ8cVH3kRQctQdwbFA2mXfRIHxPWade4rz3Xwf3erEPnWsrNTGzIdAKSqVWomLGN8c9kzQghPYokhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5WiRCK/Q84n/DnMRQupyZmJml8WtM32f+MCHnzkyCX8=;
 b=ZvAUmFn6m5EQDVZsAWyzcxpvuZYH3kOhoDrSzOJkiDo0qWP4yjFqluQl43obsPnFPCWs9fJ9/fYO0y5aRuMx/At2ja9RBZ4qxLU/k00u0w2HQHrpmdk05cekxgVHL9pvIIMOOgVyPEJwRfQGWAS/x9EYVV5AQHjTt1dSf535GvA=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by MN2PR04MB6302.namprd04.prod.outlook.com (2603:10b6:208:1ac::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Mon, 28 Jul
 2025 10:46:11 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%4]) with mapi id 15.20.8964.023; Mon, 28 Jul 2025
 10:46:11 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: Correct sysfs attributes access rights
Thread-Topic: [PATCH] scsi: Correct sysfs attributes access rights
Thread-Index: AQHb/3bjV4upSfz50ky/gIKPsuxxC7RHWroA
Date: Mon, 28 Jul 2025 10:46:11 +0000
Message-ID: <e3ab5183-fcd7-4857-ac81-a75ff9a59701@wdc.com>
References: <20250728041700.76660-1-dlemoal@kernel.org>
In-Reply-To: <20250728041700.76660-1-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|MN2PR04MB6302:EE_
x-ms-office365-filtering-correlation-id: 0622bf1a-0a9e-451a-7041-08ddcdc3f78f
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|19092799006|376014|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?REFpMFIzK2tiamhQdVdEdm9zbnk1NjFwWTlXUXpyUWpodXl5T04yTWlWZitz?=
 =?utf-8?B?WFZFVG44M0krWFJCSlJmNGFOcmdyVE10eUx4Wjg0dVlZRnU4S1ZsaVN3K08r?=
 =?utf-8?B?aG9TZVFMNjN1MG5Ec3JEWWs3UnhMTzA2YUQ0Vi93d1BBcTJwRHF0d1FOYjYy?=
 =?utf-8?B?OThTN2FXckpDRk1FT0dYQzJaZ291Q3FmaTl4dm9VTXhIUXNpMjlTTGFmSTBH?=
 =?utf-8?B?djgvZ1JnalhNWkxaQ1dpdGxRMkQ5MjFzWGQxUmQ1M2h6Z0hTZElMSlUyVHJr?=
 =?utf-8?B?Zk8wMkx2SlVBaHFsWEhKTlk1UU9jMnZ4bUR5WlZlUW1EUzVwSVVORVlWNUpo?=
 =?utf-8?B?cGFIcjN1YTNjdnpiT2JUc1VJU2E4Q3BQZzZZcjNrQ1B5cEFUYmZSVmFjM2w4?=
 =?utf-8?B?ZTR1S1IwQUswSHcxb3ljWDByRkdrNk9wZmhRYU1OaVNxN09QbFBjT0o4eEdp?=
 =?utf-8?B?aisrT3lxb2dSVGVCTkdwTWVtM0xRdy9aSDFkRS9yR3RTY1NHQ0hXRlJmMzNI?=
 =?utf-8?B?bk4vWWRpTk5GSERhUzdhWWlObkw1VnlmbmswOXZnUCtzUG9NZmJUYUFXakFK?=
 =?utf-8?B?c1NIQ1ExeW1JMEV2YUI1RlRTV2dHdkRmNnkyR0RUbW0wN0RDU0tyK2taSTJs?=
 =?utf-8?B?QmtOZHJ1U0ZPR2EvQWJnWnVvTUl4cVFKa05tWndrbXM3bHZpR2ErN0VxMjR4?=
 =?utf-8?B?dUtHWXJrM1VHelp4eGxtYm5GaHZTb0F4L0VzRlhkSW1TbHJHNGY0TXp6czhR?=
 =?utf-8?B?YnJkT2JJd0pkc2tMNzRxTlhDd3REQmJlS2FTTDExQUF1NEJjYU1tL29vZUNC?=
 =?utf-8?B?c0FVUG4wT1htVWdrN2JiRXY2NWcyOVcrZkNkVFNiRTVHRkdjSmRZWlJ1cGFW?=
 =?utf-8?B?VzdOd1Q0N1Q2SlB3SWc4MDJHSXRteXRYb2dXeDNBaUxGbUFsWGVXNXBIL1Mv?=
 =?utf-8?B?TDgzMDVYK2dXMlR3WSt0Z28rZldWNE1KTXluZzFFdkZMVkN2bzIyTitsSVAw?=
 =?utf-8?B?Y0E3Qkk1SVA3ZGhSRVRFQ3NkKzJMcEIyeUZjd0wxZyt3N2R1RXZLRmhpTytm?=
 =?utf-8?B?YjlxZVFMelNaNHpVS1NKalZKeGx0ZFZvUTd0dDNuZ3JzRUp0cmpzbWFremw5?=
 =?utf-8?B?ZHAzaWJFTEJrUEVOdUFVZ2FlbGlnSU54K1A1TzZia3RZU0VhdFBXcHJRTDhh?=
 =?utf-8?B?M2tvZmx0YmJVWDNha1dGa08vODNYQ2ZSRElxVjlaeDd0YVlLNjNac1VJa3VN?=
 =?utf-8?B?akFFd1hoc05YY2RRM3ppcFFNRVB0YllSSHpUVHk4ZUxJVWk2R3VsRUtRaC93?=
 =?utf-8?B?QVZHTTl5L0loQlcwcmlkTHpHOG9mWUM1a0NDNmlIeGlZRE9FRHJTekdydENv?=
 =?utf-8?B?QllpTVpDVDIvY3ZJcDRwVnArTGxzT1FSSWZjTFVHVXB6dzBYUUtwR2txNDZG?=
 =?utf-8?B?czBkVE03Z0RGR3FiU241VmlNcldHQkttVmo3TCs0eDhPVUV1ekZzckYxRTNB?=
 =?utf-8?B?WU0wWjVrejJhV2ZOVHYxYkxOWW16dktXcmM2aktMb1hsQ3BYZGg4TTVBSU9k?=
 =?utf-8?B?azZSY2kvUlVXUWtjbnltMTVNamxiVnA4T1JIUHlYT3drUUhhRm5XWjlPNE5l?=
 =?utf-8?B?VktjSUxPYTZWRmRtQk9ZT3pmOEwrclNSOGZDcm92aTkvMjVnUlJrTXo5M2N1?=
 =?utf-8?B?ZjdVeEU4R2JMSU1zVk8xTWxVdWIxeDd0eG9xYU1SbGVVVGdJYXFaaGUvcTM0?=
 =?utf-8?B?OWQxekJvdkFPMTc0aWhqQmk2MS9vRmxlVll1Z0VZVjI1VEdaUFI3TTFkMHg0?=
 =?utf-8?B?QmFHRGhTYUhma0d0YkhFa1ZnOFQ3eVBweFh0bWpnemZjcXgxQUVDN0F1NDNN?=
 =?utf-8?B?aEtYL1J2aEQwOFFpNFVXcmZGN0xDc09tcHhLbzNIUzBMQUJ5bWtSa0x0ZFk2?=
 =?utf-8?B?cmRJTmZvcUpYYkhFMno1M000M3ZtQTg1V091c0Y5aTZ1aFdWS1lrdWRsUHlW?=
 =?utf-8?B?aDEwNkxkb09RPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(376014)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZGhrYlM5ZHdGQ1JuUDhkUUtRcFgvTVNQY3pROVBqN2plNndHWVRiU0Z4RFNh?=
 =?utf-8?B?bWJZSmNYTlRtQ3VaMW5CMmt6d1diVm96cXM4T3EzMENlcWFNYTB1UDFpMXhZ?=
 =?utf-8?B?VTJOcndEVjVpUEszY0xKbW90OE5vYi8yRGZ6cjhQa3d4bVEyeGRvUnpPeWp1?=
 =?utf-8?B?UW92ckxXbGd1QUk5RSsxVk1aa1V2Yk1kbmx1b3BuNWRsY0RGOHJwRXlVYSsv?=
 =?utf-8?B?eEdsYTdqWVFzQXNxSi9iRkg2YTFXV2ZiOUVqN0F6WGZKWTNXOUlSQi9idzIy?=
 =?utf-8?B?WFp4N1VCemJiRGtzSFZpNTlwaVNBbEx4aElCV3pkVUR2YStjcS9HaEwvcnVi?=
 =?utf-8?B?WTN1b0VRRFpnNFVLcUhzbzlFWk1oQWZCM0w3UmFiWVM1Mi81QnNTOVA3elZB?=
 =?utf-8?B?MkNQMDdmWVdiakhNLzBqem5uaHdXeVhNTGdEajhBNUJ5cTFFdmRwOXlPS1Ay?=
 =?utf-8?B?VWtxdThjV0xRWURQbFYwUVR2d3F6WlRmQXNNcUVwTitYbGFzaVRnV20wR2ZJ?=
 =?utf-8?B?VUY1bXVIVExFSzB6QmI2U2xaL0dNaWxaNjY1eGR6RFFYWlRlWjRJK2EvQnBB?=
 =?utf-8?B?VXpsclhjaEIvZWpXWEVHT0IrTDlSU2VWL2NtWW4vOVFUR0hlZk1qcFZlSVN3?=
 =?utf-8?B?MTlONGRMajJCcTVJRjFCYlVJOGw2VlV6b21GS09XQkN4VHU3Vi94endIdzNs?=
 =?utf-8?B?RWNROExtZDJmbkJxRnZZT3JFUllsQTRuc1hqWXZuc3JEWjlFMVo2bGZINkpE?=
 =?utf-8?B?VTBTOFFmN0pBUUVoLzNCRS9WR054enZTTytCaEVQRWsxQ3M2YUhMV2dYMUZr?=
 =?utf-8?B?UUR1eDF0VzM0d2p5ZytHZElhUjBjRjV2L3paV1RNTCtRSFRYeTc2OEx5bkRj?=
 =?utf-8?B?UUNFRzBkUVhwVEpINHYvZFdYdEE5cWMrTFpFOGJSbUtvcmNFN2IzY20yci9U?=
 =?utf-8?B?SFdvV1lHQWJjaHdlSU0yODZ2M0RzckN5aStxUWRqMlJ0M2daeEZyUDRWSEJu?=
 =?utf-8?B?ZHUwakJwR2E1SXBZejNONkpheFNlRGkvN0dteTcyVnlCclM1OC81Q3pZVHJv?=
 =?utf-8?B?M3c0bXJCT1d1Z0VpQU9KR0xvY1V6NzZSb08zRkQ4RGt1VWkveVF2bmJmOWQ2?=
 =?utf-8?B?WFJYUTBudHM4YTZwVVRzbkVuTzlWNldZY0Rmd3NBL21RSzZmOHZoOTBjL3ds?=
 =?utf-8?B?dElDNC9LZm8zL05Zb2pFd0NMKzluLzlWR1N4U0QrK0RmejQzUzVUZHFhVmE3?=
 =?utf-8?B?OEVGaVhpYWN1NzJ2WThvWG1MVnhIVSsyczRBVDZEYlpiNEtSK01ETy9vOStN?=
 =?utf-8?B?NUM0SjV3bEZ0cUk3cldjWXl3QWRERkJuS1ZsQ2trN2I2VzlHeThCZ3lTOC9r?=
 =?utf-8?B?VndjSis4Z2lvK08wc1lzTmZYdVpIeUZBRG1NSTZhNnAzbzVBZ1JGZHBUVHpr?=
 =?utf-8?B?TDRHb1JTWCs2V0dqYyswS25FbGJYVTdrQ3NRcnp5andhMGpyZmhUdHp2SmRG?=
 =?utf-8?B?S0RMd0JLemJsdWtNSVZ6bHpvWGVySlU3SmRiUUhaZFROZmwvMFBKbFI5UW1W?=
 =?utf-8?B?NzUwWFFyZ2JkUmRLOGZ6NFZjYWtGc3M3V3l2VWwzMXpyTmpvWnliVlN3UVcw?=
 =?utf-8?B?M1lObTBWM3lSL3FGd0kzcGI0YVB4Vi9EN1JRNndMVlVhN1hrRU94ZllDcEdz?=
 =?utf-8?B?Q2Qzb2FnZ3RBSUVzMFMyQm4vK0NWRkJLZUkySXMwQjA4anAvcmtQTW1Tbnp1?=
 =?utf-8?B?c29nLzhMdXB5UEJnT2UyWStYTHplQmZBYm02eFlVWHBnc0hmMG9XaWdRR1F6?=
 =?utf-8?B?MzBkWXdCdDNLd1RKMHU5MC9sZ2kwN1VNYWdSSHFrTHFza3FSZEpOR2JJaXlj?=
 =?utf-8?B?SlRyVm9HbElNU2RqVUFXTjA5MEx2TXhwZUV4ZmwyQ3NlMktleWVGdUxuVTZr?=
 =?utf-8?B?T3p1TGlwdGdwekNHR2dZTDdGN0prWXk4bVNKT3ArM0pnSUExTFVNak5EWjVZ?=
 =?utf-8?B?dWNMZTFEQ0FBVkR1NjN4eEowVHA4bzJaUE43VHFUc0piZGJ2MElGSjd4cEYz?=
 =?utf-8?B?QjU3Q3A4TWxmVG1rTkQ0R1pkdHg4ZVF1b1hXeFBOTG9SSXd5V0F1SytMSnBh?=
 =?utf-8?B?Y1VnZ2FHL3JOVURMTktNekJwTEM2dkgwR0pWb0NPblV3MEc5U1ZaSkhQQ2Fu?=
 =?utf-8?B?NVRwRWhQTkxSd3RlNjdZZ3M4ZW1xWHZES2lFWmZqTlBYTFpQZVVDbyt5Z2Qv?=
 =?utf-8?B?REpublRIRkZ6dTBLLzIxMlliMzh3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EBA7FED28AFB974DB01AE13D1AE6FAB0@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1DcHV17NRuWPtArSW1jIkAmKVG9tQ6QTMtjD7k6M2k8OCKve2i+i/RrR7DkgOu7fUvDwszLrXUzcK/yg9mT3iw9cdlIB2p4pP7T6TyxACm2H9W6bbQe93nR4wUIVdfPj8hJxuypOh9CXHDMEaWTOtRWhwC5VriQIBHAiHjjtr+sWA5xqzt/s7AZqhezrhWPqwx9zn9KG+by3yMRnYHmmXxGN/MpMRgqoUI277m+WqvPFkib5WJa3c/7DfYXgh0ps8vCwHR6Q21Py/1+WO80FdLxfyp97g8zhG7tix1TFXZOcoqCtJQIzIXTLgU2kdo4SOTfp0yN5bsAkIg9Hqk1fljlNg7jDG4D9Q85nCIYLAEJMDXhrK38YaAgPRH/sM2+y2s8D79pX5UbeRROLKaRZDqFsYIIZKx8aSsZDF6zmGX/EGz82plECBFaYasadnVcqkBe4QCfJjLWD99W3SiZmNuPaxT38NgKP9E5afVUIcb8Gumg2usE92HPotZbhnGOdK4zdmDP1q6BsoP0BAjY+i7Qnk7KkfSSJmi6N1V5PDp0/4y6chdgZ4cdh0aLhrNclP6Wxy7kz8JAjOwN0+LSo7yMsZjoYv1KUKFTSMLtXPBKiGEdV+x98mrlwtoIhu0al
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0622bf1a-0a9e-451a-7041-08ddcdc3f78f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2025 10:46:11.1918
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7b767ihF8EgiCzxrIgXEO+l+SXmVavcaIcZB5KXOAYORWJQPmVcsLqYVZRn9iRkhu9vkXGk89yV9/F2G0ng9eVQJ54f+rRQOg1+lqyCEtw0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6302

TG9va3MgZ29vZCwNCg0KUmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGluIDxqb2hhbm5lcy50
aHVtc2hpcm5Ad2RjLmNvbT4NCg0K
