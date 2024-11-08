Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4CFE567
	for <linux-scsi@vger.kernel.org>; Fri,  8 Nov 2024 07:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731049231; cv=fail; b=lkv6EgdcMq4yhdV7SHlLWtxAySKT4cyAZSFFdR8oYS1zwV/Q2jrw974nG40txw32Z4Oi4RF+TJILxYl37qfCm6MMbTMPXKPbbKxrpZiDcM2ZJBGh43lwbqZa9HqBQLUOhlfizNMKdONHYQi0zUXeKa0QJWaba7uvE5FUfoaw5Zg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731049231; c=relaxed/simple;
	bh=Qs7cg9Tl1AIcGOfQh0EJPLMDF2XsI6iqdJWkXw9sFms=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e829QO+nL7LjT+dMujosm4dBdfsRK5j2cMq62GanulgEKQxSBSpV/IycltU/0YwT500clz/2r56rbIMZD3+SEkGGup65vyXh5fCR47zbFAq6zbV63541DhUExseLfE5xXvZa3G/oFlgF3jGwg35cuVOHajZfxxSb4SF9/WpEEso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=mEiqXRl/; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=tCd/gYhL; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mEiqXRl/";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="tCd/gYhL"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1731049230; x=1762585230;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Qs7cg9Tl1AIcGOfQh0EJPLMDF2XsI6iqdJWkXw9sFms=;
  b=mEiqXRl/OFUQXmZ8NcL2hmY9Qz+HttItiIMWTJsSsVJhOcisDt/i37NU
   OyXX+ZqwuxNt4ZGKAYeNooShcXT4GqWmC/QSL0loTdZmSOeL6MzB2Scfv
   Jd/kuUfA1eH/d0y1l4r6mwGPojglC/c22K7Vk5HNbveSmB3yyk5jTOP59
   9ZXCUZXbe1vVQgQ8LjFGYvQSjmBI/vqu7RKFF1xFKpYgtfv/50wyGuztG
   60OHVGoj43+j8Vw05vAer8BieXzngc1nNNEnRyPI4wRn2Z3ctRg3ahvqE
   IuPv3pHfkdidQqY1T+oVsycfmX4qd1VHI1tzZNJgCOG6K0ktHepXhSpvj
   g==;
X-CSE-ConnectionGUID: snZJh4DERCeICZ1e7ojYuA==
X-CSE-MsgGUID: o1iWUv3eS5i0YTI1F3WI8Q==
X-IronPort-AV: E=Sophos;i="6.12,137,1728921600"; 
   d="scan'208";a="31075854"
Received: from mail-southcentralusazlp17012013.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.14.13])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2024 15:00:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xUuHSFM+a2muMvkTvc4b+Uo54USonOtODO7o+EZM6qA1Q81RUVW8TRn2htkD4anYbYlqWFJNrY9Hs/3d3J9dvITbQd3BHlWALMOzYBgPxjgmMZrQEOc/dBbMO/ckpPdnSFk5rI/UGTAAZRgSq8oYcrPZ1uXmH9tZ7Gi83IHshhAvcKDZtIpDKXaWgQMzW7e+Yxk9DgXOiz4UD3fyiir0TaDCH1nmzoMPiCJ4PkoiiSG3ZtzXl8MAWizq4wuV3jHkDIwrzcu8ydTFrJC3Kv5oBwDICPhDjyohFCkCQpr0RoPwCp8xtX3Ju3rcJ4bnK34s8eZ7rorjsg/KAfGdjYgeEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qs7cg9Tl1AIcGOfQh0EJPLMDF2XsI6iqdJWkXw9sFms=;
 b=WPHB2MApn+jx48k96btdE/BNPs2F6dbzOSeXJiJutkg3M+3gs5jJLtI6coCjZEuj4sUlp9398k48alaTtZ4QPmk/SooZo/7I3/24fwkDG/yMg5s8Deeg6dFbzg00m5IUnf0nmK7dDDxsuivG/LESKzWnZIqoaT//3mhq4wg69N6eRCK8HTFaHO0yv0ik58w+VN/1ZduA2OqxAvhS7I2rJ+by1QTzkFGr7uQjnaPVB3xS6PWcfylQQXlD6QLGNdBE3M9rzuUkl2eqgifWS4OxUOQ5LUJ+Df2JySV1SG5GC/wtdEAg4GydZTcjrj9qmoEKnhXEr70WfZjac1I+Gq884g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qs7cg9Tl1AIcGOfQh0EJPLMDF2XsI6iqdJWkXw9sFms=;
 b=tCd/gYhLRegzD0FLx/K1Zlhl4Az3pU5UB2I65v2p3PSHWEuLvYOM/HbZlmIeMk/Zq4OwXaBLn9jDTEsNYyUQXomnwDhUnU7jk4B5Yjenfft6puIG1Vn08/qBLji4I720zrgCEawYa0Ve7ZxMou2wY1cg3tlQLznEkvD5BNTIf/U=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DS1PR04MB9537.namprd04.prod.outlook.com (2603:10b6:8:220::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Fri, 8 Nov
 2024 07:00:18 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%4]) with mapi id 15.20.8137.018; Fri, 8 Nov 2024
 07:00:18 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Johannes Thumshirn <jth@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, WenRuo Qu
	<wqu@suse.com>, Naohiro Aota <Naohiro.Aota@wdc.com>
Subject: Re: [PATCH] scsi: sd_zbc: use kvzalloc to allocate report zones
 buffer
Thread-Topic: [PATCH] scsi: sd_zbc: use kvzalloc to allocate report zones
 buffer
Thread-Index: AQHbKrtVwp8kiWr8ykWHdn/Za9uyTbKrjXkAgADNrwSAAKceAA==
Date: Fri, 8 Nov 2024 07:00:18 +0000
Message-ID: <831b8155-49ce-4770-afc5-08db850e176a@wdc.com>
References: <20241030110253.11718-1-jth@kernel.org>
 <cfea0fb9-b361-4732-849f-baae9edeb920@wdc.com>
 <yq1ldxuydlv.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1ldxuydlv.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|DS1PR04MB9537:EE_
x-ms-office365-filtering-correlation-id: fe8428c1-7eb7-4dd2-70b6-08dcffc3017b
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?dWhEMDB2SUk1RFJqNnBaQ1A5MEk3cVEzMzZ3VEcvR3Bmdmh6SFZaOHlRZjFo?=
 =?utf-8?B?QnY0MlZydWI2TWh1NlRsMVBKUGRzWG9Ybk51NnM4OXJ3VVJNRUhuV0lCUW16?=
 =?utf-8?B?dWZVSGp6K0dPRUJWRjRnS0VhNUM2QTgwRUFzUW5uellYSUE5eXZLRVdydzIw?=
 =?utf-8?B?bDU2SzlxR09CME5CRkVobWFRbmw5TVplMERVSWF6NVJKbEo5YUVzS0pXcEdy?=
 =?utf-8?B?U2V1SVRjczNCNmd1TDNiTVZjTVp6MENnVFkvUGJZK2RvV21KbC9jeUxGZDVG?=
 =?utf-8?B?Q2NzN3ZUVm85cCttWlN5WklxcE5uNVY4M2g0b3htOFJOTmx0S2wzYzg4Y3Nn?=
 =?utf-8?B?ckQ2SE5CUFBOL1FVT1lpQmdhVDNNTlArOEhJdDlvbk56clRPdlMzRE83b3Fk?=
 =?utf-8?B?UlBkQnZ6L05BdTdPQUgvbUhVRG5TTVF5TG92WWEvdjlYNzdYaWNoYlFvZ1hX?=
 =?utf-8?B?cXpBTjFUM1FNbmhGTzg4ZW4zeFpZRWtzbmZ2QjBNWVA2MGwyUHRMeENjVEtR?=
 =?utf-8?B?UVF6RC8wWGFsRFB0c09RVDdiUHd3QlFDTFhlc240ZXlmczRrc1dvdmgvU09a?=
 =?utf-8?B?b2E0ZFNidnJyNW1pZW9NVlBSMndRMG9rRlRRajNxNkxZck5PQURrcWRpNW14?=
 =?utf-8?B?YTcyVHBSUmhEeVdnK204WjBtVHRBTGFpeDRDd2VlNzZnNmI0YWNGTEdVK3hz?=
 =?utf-8?B?a1l6c3hhQ3BLU0hxWFo2dFlmeXFra0hnUTJWQjlyaEdtWkcvN01oMFVZZmNK?=
 =?utf-8?B?N1FkSDB6ajNGdVJSZ0hWamtUMzVWeEZmWlcyQUdTYWNYTGpxUStGSU5Wblgy?=
 =?utf-8?B?aWpBR3FQTCt5ZWI2V1FvUFVSVElNYUNzUjhERXgwWlNRUWZoWXBmaTRPcFl1?=
 =?utf-8?B?OVViZ0pJOXlYZW01ZTY3cWZZNm1KSWh6VDhhQnllVTBqeDBmNTMySTBtS2w1?=
 =?utf-8?B?SVRXTkZFZWVXOUFxZVVQbWUwdWdZRGNXb3djdUszU3BRaEh3MnA2YjdEaHVp?=
 =?utf-8?B?NHdkclVBRS9HOEh0NVFCY3JLOFNnU2RrZk45SHRmVG1XY2RocHk4QWRuYVBE?=
 =?utf-8?B?MTZEclRBUnRSc1FEOTZ3N2hxUFFqdFg0dDNndWFxVWFya1ZhLzJCc3BqYXpK?=
 =?utf-8?B?akNvcDZ5NVc4QWRBZnd0eVBIcHBsNjZpekhycWJIeWxueUdhd2pOdy9vUmVj?=
 =?utf-8?B?dmxQT09sWHBIOHRxMEZCdE02KzRvaFZVTTFUQSs1d0ZISWxPYlFKQ0g4SkZJ?=
 =?utf-8?B?aDFEOGdqY3h3MXJidFMzOGtvOGpqOERxMlFKbkRSRmpQR0xmZjRVTWVsZ3ho?=
 =?utf-8?B?T2RqaDdaRnZPNGxjUUZ3U3owNEFmMlhHUk93TDhLZ3JWTWZLQ0VudnNGTTJY?=
 =?utf-8?B?OFVxMWRSc3FXWTNqN2QyTnNVTG1OUjZnQnlQNkV5QVBRZDZZYURqME9BNGhl?=
 =?utf-8?B?MWZTYTgweVdxTWFpR1JkM1VGYVZKNXJENjlLY3RRT2NtY09oRHM0RkMrakMw?=
 =?utf-8?B?YVNWV0VCd2RCdkJxUDJlejgxK2lHdzNzSkVUQ053eFBGUkJnUzV2dlg4N09j?=
 =?utf-8?B?UU9CbUwwMTl1TXBBbmp2VXlXcVQwY29PTWg0a0ZZbDgwanFTZmVJNGFKQ2h0?=
 =?utf-8?B?WHVvQ1hoTEZGRFBsL0xzaVRuNVpmejJrZTQza3BzVGVmSFE0eDU0SFEzUG9j?=
 =?utf-8?B?T2IvVzhTdFVSSXo3ZDB3emJKR1pDVFRCUWJLbDRubWY5cVJUaWdoWDBWN0xJ?=
 =?utf-8?B?eExHeUtoTlVyZUZRT0x5V3N1dUxsR3Y4V2ovUzd2b2YxbTVSTWdBR3YrWVI1?=
 =?utf-8?B?K1RjRDk1R25EZ1V6WVMycUJVSnJ2b21HRDZwb3QxYi84U2NSZVJscmdUelhO?=
 =?utf-8?Q?ozVzI9S8MF+yQ?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZzFZanNBdVlSaE0wb2lySEVjN0VOb0l3UThmdTVHWE01WDYzSUhHNUJUdG9j?=
 =?utf-8?B?RmZIWDNQMFlwZktxT3kyamJpTTU2NnMwUkljSEdlQzdaaHJidlBYakFoUTlO?=
 =?utf-8?B?LzE5c2tiM0k5ZDJzZ21NVng4dFlXZHovTnc3MUQ0TVVkTWk1ZlVUSzFJK1U2?=
 =?utf-8?B?WDB1TlRBQTRBT0dNcVY4MkZncEJtb3ZFaXd6MHBPUEtvTjRUMzIwWlQybWdV?=
 =?utf-8?B?L1ltamlsck5DMGdUNk1ZODczd0xxbXRtemlGSDk4RVB1SFRQN2MwclFHWDZK?=
 =?utf-8?B?MEVLcTVrOUIyK3hPRVN5UXJFb00xTCtUa2FaWnZ1Sklac1FWLzdHNUtjWlhW?=
 =?utf-8?B?aGlPK0lLWTEzWldWbnVzT3ltbmZsUjZQTG9obVdjeGdEVWlmVE14d2hRWC9j?=
 =?utf-8?B?NFNreG53bFl3cjZ0VlAweUMxWnF3cTZhWE10cTFVTnVHMGFUNVpuTWVoK3o5?=
 =?utf-8?B?SGdINTMzVkQvc05WTlNWTE1STlAvdmxud3A2SWUrcGFFa3djMlZkeUNNYy94?=
 =?utf-8?B?WldtQnRKYXBmakZnTWE3VXNLSTM4MHhmVzlLSk9DS2d5ZWJxYVM0ZFZJMUx2?=
 =?utf-8?B?OVpGRzF5NVFJSlpMblBqOENia1prN1VEbi9CNkhkUU1pYjM3K1JhcGozT3Nq?=
 =?utf-8?B?d2Y1dk9BRmZOSUxaeUY5UXBRdGl1Y1MwcnlJNkR2aVp5YXBQRFdDTWZRMGxz?=
 =?utf-8?B?SnNzK0picndqK1JpTFFteS9jS1pBOE83Zi8wVGp5dm9NaE8vaGdTYnR5YzdC?=
 =?utf-8?B?bkNiZ3k2cFlDSlFJUG1WVjd0U05iRVVrR1VMRXEzd2UxT2R4aXhwYTZ2c3lv?=
 =?utf-8?B?ZU90OWt4NzEwRW10N3o1T1BXY2RVYTNzcmxVOHAzSWExWVp5cU5oUTFJUGpQ?=
 =?utf-8?B?YjlSa0RqNERGWVhzOEQ4RVI4V1VoZGhia3BQZWNNRzlITHE4dnNkRU1IWnFR?=
 =?utf-8?B?eHh5WGpNYjJGWWhXK1J6QnZ2KzFqcEJsT05FSWh1azNrTFdVc0ZvblZjdnd6?=
 =?utf-8?B?VWRhcEplM01wU3lCSXUyYjV6V0lMbzZrWkRWbFd0Zno5RmFYdStoM3dUQUNX?=
 =?utf-8?B?ckNHTENWbnJIdWJNYjNSSTdnSEZKdjcyMHlwY1Z0NmdSYjNyaDRJY1puMGhM?=
 =?utf-8?B?RSszV0dzWHFObHB5cndOS2l5Q3FJaXNVNXdBckZ3NXZMOUlIb2ttU2VSZ1k3?=
 =?utf-8?B?NXJQM2ZjeVJlbWFHVEFaQjlhWmd1aTZ2Q1lSVllrZ29ManRERmZhZnlFUmNl?=
 =?utf-8?B?YkJ0R1JPL3B5M3BsL0J4Vm9aS05RRWYzR3ZWb3VQNUgvZUpYUHlWbzR3RWo2?=
 =?utf-8?B?a3p2MzQzTlVmb3BFWjRmZitmL3BMOXNxa3hyd0Z6dUZqQm5CTWg2anR5Tm5t?=
 =?utf-8?B?TXhCWDNoSDNYdkRsV3NJMGN2Qjl6dmJwWUM2ajEyUERLc3dEUWpqd1UzUitQ?=
 =?utf-8?B?bXF2QzVnclhVTXRoWUNaT2NoaitVZmU3M1VsZHZOWWNPSUttK21rYTcvRDJv?=
 =?utf-8?B?R2hicGRNVUVrOXJ5bWYwWmoxTWZERks0V0kxcExteVBWTlU2UlNRK0dxQUdN?=
 =?utf-8?B?a1FWWWl0Z0RObmFOSXpxSVVRcWlLZWkvQzNpS3ZVL3pxV3MrY1hLbDhLZ2dm?=
 =?utf-8?B?SVlFZEhRUVpDMEptbEZha0tnRnY4UzE3NjZhNGtSRmM3Q0Zpd1VPbVlKUUtt?=
 =?utf-8?B?d09sSlFMTU5sVkRXOUdiK2VCcjJGWG1KUVlHWCt1RHVLcWFoNzN2OFF2OU0v?=
 =?utf-8?B?bDNFQmVDeml5YVZ5Zno2WWhvUHFoNEt1NWVETEFUaml6SGc4OTdJU2xuRTV2?=
 =?utf-8?B?QnEyWUlwUGVvTWxwWE1Fc1cvQUkzM1F1eDlXL1lQOU5kKzJUaG1laCtqVXBP?=
 =?utf-8?B?L01mZ2FJdzMxNXBFeWdDNHh4eS8yRkE3cmVWNWZLdjRkUTZ5VnhySGtJdnJ4?=
 =?utf-8?B?Q1Fpai9UbDBrb3dJckhSTTVvOW5XSVFMdDRxZ08rdEw1VmdNOUVGbk9CQlFX?=
 =?utf-8?B?WTM2VFB2UUJia2pkZ2EzbEp3RTcwcm5LY2lwUlUzUEhFTmJoelk2eTBXYjls?=
 =?utf-8?B?OG55ZDJhbWF6ci9NZHZvRzh4WXhSQzNtR1c3bGlmZFQ4eWpwb2lpS0VVNTBh?=
 =?utf-8?B?S3BGbHJFUWRsbFNLbW0vRG9KYjhJcVd4ZW1aanY1ZjdKaHQzVHBDY1lhQUYy?=
 =?utf-8?B?THc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <59CD888A6DF78343871328393C87A7F9@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Pb/d4TiEvcFiEDSBlE/3wCHXfr1RbD6ZnklFJRbJ/W4AxelslTyUwSPYsNHF28iooDXTFY0x74fSZBBPTxm3DKwVvIR2EwWW0JEpA2CnaWnJDe9hY7vQp0e+Jg1L9pdZ0HeCVLEqHIDow/UM4SASlKztCwOUtWjj34tynHlaJQm6uKUT5gA7LXSTjwC6Sc7hapokoZRbsDwLOiNAiRPfg4ifzmx+cgchpjdwGq3KupyPkKDTGmkQRjdqt7+jijnloltdLQSHtCwK5DYL+hYtExyg4RThvPxzj2SrFiPZc8Wfv9Rya1ODP7dfM47sJaI28vqPqY/9APC4HRhPwgN2cdy2cCTzl93Ty/Z/3gWWRVK3YT0XtK/CV6f9wd9smccJySseyyKRWYvwuA3KL7J8ksz6rnOk86CEzdhjYsJjjdIhPe4xl7Z5ho4IwwgkPnLIh9vPBXzAyUMIryazVLUSUCxY8tUwzsBItmzg2BiBUJex74il3fFJuJIriorYd1MOg9FYg0hj6JUeZM3Val9IPvFhhywWvn/bce8JyDwg8BKTBn63N1Yw0YRE4Ql8bxis0O4U3lb6IyCIQk3wujd3wgN4Jq+Wrr4nwYf5HZdV+0wr6e/tN7CrMDoRRf6/9YH/
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe8428c1-7eb7-4dd2-70b6-08dcffc3017b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2024 07:00:18.7733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kTwYW4pj2fOc62NEHLZWtDKNT1+CsP0dcDsMSLvLEMsG9J8EIAw9J3LdZjogbWB1I6wurnsfoD5LF6NqKkTIonPZ7BxgWTS6acdI7ag8Qyo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR04MB9537

T24gMDcuMTEuMjQgMjI6MDIsIE1hcnRpbiBLLiBQZXRlcnNlbiB3cm90ZToNCj4gDQo+IEhpIEpv
aGFubmVzIQ0KPiANCj4+IHBpbmc/DQo+IA0KPiBJdCdzIGFscmVhZHkgaW4gc2NzaS1maXhlczoN
Cj4gDQo+ICAgIGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvbWtwL3Njc2kvYy83Y2UzZTYxMDcxMDMN
Cj4gDQo+IEkgZG9uJ3Qgc2VlIGEgY29ycmVzcG9uZGluZyBtZXJnZSBub3RpZmljYXRpb24gbWFp
bCBpbiBsb3JlIGJ1dCB0aGUNCj4gcGF0Y2ggaXMgbWFya2VkIEFjY2VwdGVkIGluIHBhdGNod29y
ay4gYjQgZ2V0cyBjb25mdXNlZCBzb21ldGltZXMuLi4NCj4gDQoNCkFoIHNvcnJ5LCBJIGRpZG4n
dCBjaGVjayB0aGUgYnJhY2gsIGp1c3Qgd2FpdGVkIGZvciB0aGUgZW1haWwuDQo=
