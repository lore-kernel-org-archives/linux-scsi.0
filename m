Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A35AD23
	for <linux-scsi@vger.kernel.org>; Wed,  4 Jun 2025 12:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749039327; cv=fail; b=tccAebsbsINtptL12Y9Ss6h0gBpehX6t1DBbIw3NltgpbsMzFyQHCYjquswVXoNG+GNbnldGYNaO0N2TP3bo2ZynwJ6zkG0hdFI0i1JIAOcjB6Tce/VSzVn0AMBqw0g4ZvDD4iLBntay6Bk8eGu732w/BT2rmQtL/RqeiGOCnPU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749039327; c=relaxed/simple;
	bh=UsQsHfFF7aAa1EH2vxhqavJBKdLQCT59nz5aLDPPi8w=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=d/aXVw5f1FfDyF6xoldi60VoRagnSv2jVmBRzvx2kBUE5rxWB76NTuGm2fcHGj+66aoMuEeDUQAEPi03xnsU3W4tfddQAUAzaH53VOshsyJrjWvlq53U/qTmx1X+QiGfG7RJ5/uPymT3/o+RhdQfOtsvDlYMUTc4xMFnYbwjZC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=KpjYYU+c; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=SIi9+S+t; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KpjYYU+c";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="SIi9+S+t"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1749039321; x=1780575321;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=UsQsHfFF7aAa1EH2vxhqavJBKdLQCT59nz5aLDPPi8w=;
  b=KpjYYU+cvnfvf/oFvxcsj5rOFqehwVtuGky9U15FZ6xIHYDMvQUzMR1d
   AC9n86pWW7AxkwIBvYFyiPtdVAmgtmW/IbMb5jRuwyc3Am04sY8mtBgxq
   7v2Fe1xvK9lRPiRtXXDkPoWPVC2lghReAuquDUK/XPE2jNOxIY6wmZHln
   kELwvU+upLx1Feh5lVGCAcWWR3vg73atyOCgkYeBdUxr2EpkrDguOAKS8
   zku8CJwvUQUoczdcs63YndsfbPusvuInNT/ll0jCz4Y1JPW+nSFPvuok2
   3Rv5sa+RbcGBu1TNKpB2MCvYYXM40ToNY8t1LNLEXuswznF2kiWrnoK1f
   Q==;
X-CSE-ConnectionGUID: 8i+O1ZfZTfCLS2MvGfZSRw==
X-CSE-MsgGUID: EF9uVyzbSvWTMkY/AHJKWA==
X-IronPort-AV: E=Sophos;i="6.16,209,1744041600"; 
   d="scan'208";a="83415129"
Received: from mail-mw2nam12on2077.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([40.107.244.77])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jun 2025 20:15:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y33UWMwR5Yvsr1xvL2tVQ/sBFN2iSWNBOG+G6Zf46gDuxSmMh1FPbNrG2hPZIleUMkZGV1gToP6BSTDUkQm/Mn5/fn3yn5o+XzE9IK3jVMg+m39eDS+ncV5Ph5pUJ+BYEH6vE6xfirV2Z5Gn9eRZ6GftwOcnR1Q5YqGGD/4ZhCcEifPOtPx3oo/cLzPRI5CatUZNUdVEc36IeLbR6GmHClK/iB7tlugASALCkdsHSCmvNvodUMvlv2Oj9jT4fHO7xACMW0HU9U38vZvTkG5WMaY4GO/KRt+3gDxAQoqX8tRx9U0nJUnUU6O1gwG51LwFlP1gOUslcLOCimwmaiznTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UsQsHfFF7aAa1EH2vxhqavJBKdLQCT59nz5aLDPPi8w=;
 b=Eva1UfEsp+UBMyt86aiZ09qPcyhC7U22pa6VC37GI9kz0vDtovQHTPPooo46C09wR78PnOZ1cJ7EJtRxQdpMZNXctCDHKgxkfTbusXHNJHfbyXhRxvBgo8gLCwUO8vNAYS1R/3Y/cUVsl15hdjJmBEvZDRGES+c/Ptc6yFrn6yoksmPJx6QXdl2QIygm6+l+P/6sCFSc3+YHoGK3ZLY4chACC5wGm2ebkNntXXh3dKp3SORn+MSSwPpQ7fj98l+qWHVuqslHYEckV8mWianIERCzlJzGm8SQSLN8SCMZ6ARcbSYJf1lMT3MIRpaTmKVg8f0xu+xJqFbVNLNexCgmkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UsQsHfFF7aAa1EH2vxhqavJBKdLQCT59nz5aLDPPi8w=;
 b=SIi9+S+tY9aAgdS3Xaspt5RxeQtfmIWB7/vUL/KauWqKb3AaDhlszUabcB6iDcEwILtDwjGVWwyLpJ6nJlumptj+DhjgDPPZk1zZaCYvqklKKV5twGEzCnlnLXwlVpauaCBtg1DURc1h27UnEzQvWwK26F3M5N+owDOoIyaVPUQ=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CO6PR04MB8331.namprd04.prod.outlook.com (2603:10b6:303:136::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.27; Wed, 4 Jun
 2025 12:15:13 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%6]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 12:15:13 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Li Jun <lijun01@kylinos.cn>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: arcmsr: return the value of fun directly
Thread-Topic: [PATCH] scsi: arcmsr: return the value of fun directly
Thread-Index: AQHb1TgOBqeesh8Ks0Cv6QoyLnyan7Py6jQA
Date: Wed, 4 Jun 2025 12:15:13 +0000
Message-ID: <663cd2c9-020b-4895-80a6-750193c114b6@wdc.com>
References: <20250604100342.128769-1-lijun01@kylinos.cn>
In-Reply-To: <20250604100342.128769-1-lijun01@kylinos.cn>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|CO6PR04MB8331:EE_
x-ms-office365-filtering-correlation-id: 5d05602d-200f-4dd5-70de-08dda3617558
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|10070799003|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?dEg0ZW1udndhR2czb1FQRlFCZkp4OU0wVFRUMC9zaEZCNlNERjJtK2wzWFJz?=
 =?utf-8?B?QmxWMWQvZ1dBNGRDc05Vc1lPaWRHTUxLMm16NDVGUnl3dnBYUjlycGxmRk5a?=
 =?utf-8?B?TjFBMzdoS3hac1BqbElGV080YzNDK1NGSXRad0FpWTJteEV2NkI4ZFV1TllE?=
 =?utf-8?B?Zi9pZTJGdFVMYWVCTXBVNUoxek9mL00ydTJ1RzNSZVNMMStZMEZsQ3RtRVNR?=
 =?utf-8?B?Q0EvNUNKUExNS0cwUGJ1QmJPalNqMHU1bHdTdVg2VUd4TDg1SVZGY01vMkxt?=
 =?utf-8?B?TCs2bW5uSVg2VS9GbldjaXFDeU95S1FFdVB1a2txVHl5MHpCVmh2UjFwOHVQ?=
 =?utf-8?B?VzFUMlhPdmM3MEVLTk1weGRyZzVPSWc1SU85d1krVXNlaW56cWRuRGl1QzFa?=
 =?utf-8?B?SjR1M2VGUWZwbHFvY3N4dXlpVGN5SzNTaGpiUGtxc0JCRFkySUREMEFvT2pw?=
 =?utf-8?B?bGdOY3RGUzJ6ZSs4eWUvWXNOYUFEVnA2cjVOQk1McEw2RUh6bTNYd0tlcEVJ?=
 =?utf-8?B?TEMrVy9FZ0kyVS9XK1VxQlZoSWVHMlFydkkrdnFOQVR5QzdvK2kwdWFIU2Zy?=
 =?utf-8?B?L2xocENEam5Ib3hPVVh5L2JZU0NGckF4NklWRzFybW0xcG1GS2YyU0dmbldh?=
 =?utf-8?B?b1RFWVphc2dUWUwvWlhONnBKQ2gvZVh6VFhUMnBWTjBQbDlyNDQ3ME1zQjNO?=
 =?utf-8?B?U0pnT3IybXhvQTRONmJReGxONUlnWlVoWjUrc2pkbTI1VU1iU3pneW1FbE9h?=
 =?utf-8?B?UWoyOXRKbnlsdmdFUkpoZWsyS1Y5a2V6TVZjNzZURmpUREFuUlF0aThXZWQ3?=
 =?utf-8?B?cXRTbXpCM1pLMUdYZkp2ay95QnB3WXoydzhncG5rV0VtZk93WDNwL3NrZWc3?=
 =?utf-8?B?UG5iRE5xc1JZbTNiRXRLbmlPUTJRRW5MNmRlckNxS3kzcndTQXJuUnVDa3RQ?=
 =?utf-8?B?b0V6eUhBVk5WbVdMTXlCT0oxSGlla2kzYWRGb2RNZzNoQ2cvWHkva3Erekla?=
 =?utf-8?B?NThLQUR4bHRWcE1Dc2lQUWlKSUp2RGxmclcwTjhFT211c0s2cms2aDIrMlIr?=
 =?utf-8?B?a0tKWVZqTzkvNTFPUDRJc0Yza0ZrSUUzVjhUc0NKTWFIdkE0TW1aTnJrWHli?=
 =?utf-8?B?WmpOMEtjVFB3dG5SbTJYZkMrNFFDQ3FNOWdHOVRBMUVKK2g4Wi90N0hzb3NN?=
 =?utf-8?B?RDBIQTZ5NDlYL1hRNVFOdVk5VkRmNC9OZXFXOWdQTGkxU1RyUU9LS3lSQUpv?=
 =?utf-8?B?dGRwckI3YkhESWprNVhreEEwWDhFd1EvNi9ZYkhaZTF4V1MwRmFrVWRFR1BB?=
 =?utf-8?B?T2ordDNQQVc5aWxJMFByQ3VQUjI1NGF0d01uSk9DZFdMVmZtUjVGcXFoWEcz?=
 =?utf-8?B?QVE3NWhWU0I1YThzOVpqblJxbnlDNDZ6Z2xkdVk0anE1WTFRNmczY3pEM3NM?=
 =?utf-8?B?WWtRMkN4NzJuRy9DZm85RXhwUjNPRDRkSnZqdDAxN1FCaWw0T09uVlVzOXhF?=
 =?utf-8?B?dGdCWGNCRG5lWEpyVkVabVVQMUF2VC8yakI2WjhuWVBjMUNxcThNTVpVSHpx?=
 =?utf-8?B?bDhqSWdXZTdjQlhLRWFQNHJxeUo2NGU5NC81SElGSmhWNVRNZ1UwSHd3MHgr?=
 =?utf-8?B?bXRKOWhtdDk5UWVCNDBEeW5RbEl6bnFyVzQ1eXFQRWh6MmJLaU9wUHB6alJY?=
 =?utf-8?B?SjJXekZlRnJjaUx3eFR3enE5bmhIMlEveG9QVDMrSmRKdXVpM1ZyVHA1R1NI?=
 =?utf-8?B?V3ZoZmxrc0JEK1VJVTN5QjY3SG9Tcmo5NWNOSDRVaDdXNEdOOHV3N2tBam5r?=
 =?utf-8?B?NFRXRjVPVHprTklRVHVvLzlJemlFaHYyRmd1SUFkckFXZnlYM3lwNUltVnhJ?=
 =?utf-8?B?R2hwTGZDQWI0dzd1UUVCREZmcHlvcmppS3pVK1poQVdyeSsyeU5xUkFYYXZ4?=
 =?utf-8?B?dDdoZHNHZXBpZmlFM3YyeXNKQ3Myd0ZUSzNCOC9jZm1WQzdRTE1WWTE0Wk0y?=
 =?utf-8?Q?YiYh9o0l1q/ctcX9jL3fIcqE6+UcYE=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Uk9KZ2VNL1dMTUtUM2Q4NnRneFJQRDdPRXBYakRZQ2JiQUR4aTlNd2hNTU94?=
 =?utf-8?B?RHY2UnBYS2VsTUl4Vk8rQ2JxeVRROW10dmd4T1U3RU15U3BNSUlzVUI3NlBm?=
 =?utf-8?B?QU51ZmUrSHI0bWZOaFNWeGdNSElzaXZHZklNZVYzTkdockc2ekxVRW9PVUJD?=
 =?utf-8?B?VVhvazNnR0JaK3M1KzNuTnQ0SDFPaVAxcGx5ZDVPK3pURWQvMVl5L0t5U2JC?=
 =?utf-8?B?VzhhM0ZhNWRJTEd6dXNQdG5vQzU1YTB6N1NlTFExWUFYNHhvZHNtTjRvK2hO?=
 =?utf-8?B?VXJocENNQ1ZnVmxZUkpDTzVEa0o5bVhlTmpIcHpTMVhxL3lSdFhBYkVpRDJR?=
 =?utf-8?B?dTVlejJSZUFCSTFVNFVOUGNtQXVLWFhaT2hrUVMrL2NZV0pSaklpQzkxWkZo?=
 =?utf-8?B?T2JZcXcwNVpCVTFqdjdlRnlWTTVHQ2tBeGJzTm9hMzh4OThoOVRKK1R3L3Jq?=
 =?utf-8?B?UWpJSWttTk5UT3gveitvRUpIQWNMTm1qdEVTMmFSdjVHZlVkOENkaW82Z01K?=
 =?utf-8?B?WEJGZ2Z0SzJXSldZbkJxcHBNRlVnSElhdEh4Ky9JOWhIakxpMUFnaEpUM2xl?=
 =?utf-8?B?Z3N0Z3JudlJ6UmZyNGNKUU9rUnI1d0ZJMWpHeEZwRm1VWi9oMWc4TTJZbWE0?=
 =?utf-8?B?eGRtam5ObDkycW4vNjd0bFR3WVNIUUdudUZ6N2hIekpLWHd2TWtPUVBwRytn?=
 =?utf-8?B?R2FNNFQxdG51R1pGNzhtd3NDQU96dExLTldFWXlzTS9UQ25rdkZibnFpcENX?=
 =?utf-8?B?QnRvaGhMMUd2bU9mcmZYS0ZPV05PLzdMaklydHJLNmF1QlFSOHNRTW9wcENV?=
 =?utf-8?B?cURWbjMyVVpteWdlcm5aZ0w2WU5ib1pJNnlmYVhSTXBiZzA2QXh6Q3A2QXZ6?=
 =?utf-8?B?Rzk1bEQxa1R5QmJZWG5USjAzVWJBMExpRnNhejdzQUMvb2JXaUFGUkx3T2hm?=
 =?utf-8?B?NjRZVnhycmthRm1iVWtXZGFDWkQ3cWN4ZjcxREJPWkk0ZUZkZXlQb3g3S1k4?=
 =?utf-8?B?ZUFndEQ3RjJOVzNyV3J1WHNkOXZEN3VFN295T0IxR25kdUF2NVg5aGVFNEFw?=
 =?utf-8?B?N1BHNjhVSWRPZmFjUVN5VlhJUExqVlJ6K0QxeGhuWENuKytzY1VLQlpKVWdw?=
 =?utf-8?B?WW5TeGlYQ1RBS3FvcjFWUERpcWdlRmZHNUtiaXNKTHdvWncwc005N1ptVEFJ?=
 =?utf-8?B?Q3h4OEhEM2IySHBsV1k1OGlNMHpPYXFGT3ZwSzlVdjhzd1owU1crZjRleGFx?=
 =?utf-8?B?V21sajlzTnArSFZKaEh1Q2RIdTQ2Qitud0dhK24wZFAzUWx2b2xuTWpiSklj?=
 =?utf-8?B?aWlrZXU4OWZvOG9oUzZZVFA1VHBvNWd0ZHFWQkc1ZW9MNEQveHRHYlkvY1Bp?=
 =?utf-8?B?MFhhT1hMZ2VPc1NIZElPdXFDNStvQ3J3dFBsZ1ZrakV1eVNGbStJZXlXQUpy?=
 =?utf-8?B?c1YrWHAzaWVmbU0zd0RmWjFJaE9SRmVKTDRaM01RR0Fqak1jUnN3ZW8yRys2?=
 =?utf-8?B?cTZ0K0NBeFBYSGR6NENISy9NWnpwQ29KMTlIUEhUeVJhdzlQOWhNWGhTbnc0?=
 =?utf-8?B?REY4dVBNaS9ieXRmQjAwTUpsRUtiM2ZVbnVITE96R1NCeC9MK2pFSTFRWUxh?=
 =?utf-8?B?R3A1WTc2aVhWMHo3ZytCYllmS1lqem1NL3JBc2N2MG9jbTJ1eHVrdjlpS255?=
 =?utf-8?B?bEVPSnFoUjFqRkNFM2FyWndZREI4UHFYdVZyd1lYQTh2Qm1pYVVYZVNVTjJ4?=
 =?utf-8?B?ZUZEcHRoTkRYc0xYTFA0ZG1ZMmFUVFRIQTlLSVdTN2FMZUkrUXRZNitGTk5V?=
 =?utf-8?B?TzNpSGpERUN0d1U1T0hZblU2bUNaaEdzQnRpbmtxOTlqcHU3SzFYei9HY1RT?=
 =?utf-8?B?SytUNU5kdjdJMklzNFZGbXZNdlRrRVByZktmTWVNbzZ4YVNkNmhIS2s0L0dh?=
 =?utf-8?B?Wld1MnJIVC9iTzBidHdHMnVzWXR2aGpJY3dKSkdwZU9sSm15S3Noc1hxWUg5?=
 =?utf-8?B?MnNyR1VsQjB2dFIwNHJ2OG5tUWdzODBYQUpVK1JWcE1IUWhJZVB2N2RkNkJo?=
 =?utf-8?B?MCszcUVzSjdLYitJOG1QSnd6ejhTc3F1TzUrUnVWdHl3dGo1bHY3VWlmNXpt?=
 =?utf-8?B?Y09FVDNmbEhLVTZsREJBU1hZcWhRc3d2WGZnNTc0SUVWNVpEZ1JQZ29ydk1o?=
 =?utf-8?B?d0ovK3R1M2R1UlEyS1djRjVFSG5nL1BFT3VBQVg5dzUyNlFTN3VxRmhlTE9z?=
 =?utf-8?B?U25sZ0VOeVBlZG92SE9CNFREM05RPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E76AFC6261559D4CBD1313A59F74A323@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nlGfoBtsbf4UXjVur/Y3YZqU1clK6+JQTtw9O1+VKrd5sXCes57bf8aGmwCLF5n1G9IDAIQa5BzQePis2aDw8AKZOnwlaNrLvGyHXfDobQ8pXQu1lWgtxdUb5YH/9MeigLqVhnJmEATtWvCQ2os4zW5eEobKgkOeiloUlFYsFHtARb1q2MCIMRxC1QZIN9reAaN46F3qZYnfmwAwi//wqpVB3Mzk9tiDumKJk0oCyD4fDDbaWIylZLpKZm7KZ2mnNziFkuches75zbOeOcVnRGVheA3ADYO6TDh0iNW8HYUHocqEDeZ3fk91ytijmPVV567u/pLXLmZuMFQPpEJOJJneOpBv6ZBKc8Z9z47wdUjAN3MAE47SgJXA/N0ID8kQs59As44xahd6CnHlrfOTmMUGYnw5zm1Y8lA3cYG9lbrLkSBDztcsEVULEBjnFaEVjgwAMJEDTt+btHOCBRh2JxpldkqF2RGSJXZjDlDfv/tjiHirfO0p6Q7+f1bzBUGsUJ4HtRbt4zTB9EiQoE5HktejA5wQLj5wqPAMoi68l9JIv6Rg6h41teBb6c+OkPs3kOyBenpqAygAkcFMx6XFDhpz8kMQMbSzS8WMmri4yvdbKPZniIAsbWA/On4+Zs1l
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d05602d-200f-4dd5-70de-08dda3617558
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2025 12:15:13.2221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5+s5UF0sx5wICSTU4RP4AljUBcOHrYLLFspltFPe8YrpDJdck5LMjf4UG2yCZ2mABR/D+KLehoEDQ7eZeChlQcckTZrOppe2HaJKSvIK6kQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8331

T24gMDQuMDYuMjUgMTI6MDQsIExpIEp1biB3cm90ZToNCj4gcmV0dXJuIHBjaV9yZWdpc3Rlcl9k
cml2ZXIgZGlyZWN0bHksanVzdCBsb29rIGNsZWFuLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTGkg
SnVuIDxsaWp1bjAxQGt5bGlub3MuY24+DQo+IC0tLQ0KPiAgIGRyaXZlcnMvc2NzaS9hcmNtc3Iv
YXJjbXNyX2hiYS5jIHwgNCArLS0tDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCsp
LCAzIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9hcmNtc3Iv
YXJjbXNyX2hiYS5jIGIvZHJpdmVycy9zY3NpL2FyY21zci9hcmNtc3JfaGJhLmMNCj4gaW5kZXgg
YjQ1MGIxZmM2YmJiLi5jM2E3MWEzZmRjZDAgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS9h
cmNtc3IvYXJjbXNyX2hiYS5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9hcmNtc3IvYXJjbXNyX2hi
YS5jDQo+IEBAIC0xNzc3LDkgKzE3NzcsNyBAQCBzdGF0aWMgdm9pZCBhcmNtc3Jfc2h1dGRvd24o
c3RydWN0IHBjaV9kZXYgKnBkZXYpDQo+ICAgDQo+ICAgc3RhdGljIGludCBfX2luaXQgYXJjbXNy
X21vZHVsZV9pbml0KHZvaWQpDQo+ICAgew0KPiAtCWludCBlcnJvciA9IDA7DQo+IC0JZXJyb3Ig
PSBwY2lfcmVnaXN0ZXJfZHJpdmVyKCZhcmNtc3JfcGNpX2RyaXZlcik7DQo+IC0JcmV0dXJuIGVy
cm9yOw0KPiArCXJldHVybiBwY2lfcmVnaXN0ZXJfZHJpdmVyKCZhcmNtc3JfcGNpX2RyaXZlcik7
DQo+ICAgfQ0KPiAgIA0KPiAgIHN0YXRpYyB2b2lkIF9fZXhpdCBhcmNtc3JfbW9kdWxlX2V4aXQo
dm9pZCkNCg0KV2h5IG5vdCBtb2R1bGVfcGNpX2RyaXZlcihhcmNtc3JfcGNpX2RyaXZlcikgaWYg
eW91IHdhbnQgdG8gbWFrZSBpdCBsb29rIA0KY2xlYW5lcj8NCg==
