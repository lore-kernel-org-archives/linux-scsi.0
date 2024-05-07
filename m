Received: from mx0b-00154904.pphosted.com (mx0b-00154904.pphosted.com [148.163.137.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F521509A6
	for <linux-scsi@vger.kernel.org>; Tue,  7 May 2024 11:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.137.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715080659; cv=fail; b=dgIQXKAu5vqRPmvP5v0feNOrDrXy4PnuVaQsBJxeRFl6yytFXSuKHM68mJ/VfmTYZuMkXTLu/KzNRQSRYI1gep9ZtbbbxNGsnVtV+q3SFWC5VG2TfbO2iM2AP8X8Ljzn7mEXPssOMobLi4d+x9XwlAQpdQ//vXJdm0lN+B/55/g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715080659; c=relaxed/simple;
	bh=ZRLzam8yV/jEsqyEU/76DHGc1UzHiSgNOesU7nfmp+U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=slpo7Vp+a8xXlH02KoJJ6FiURijuXgWRQB0t1pe2DiCVEJgfNd1oK+1uHjM+YVGlG8znLQa7zwZr9XYEPBuIBbDfMilvFlHDEAm2P8moqTYqGkmjr4zTlcWLKj+myUkOfRvv+33jVAbkvNtnvUN0han7OVcNEN758RkA3cxm5dM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=cBxPUymx; arc=fail smtp.client-ip=148.163.137.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="cBxPUymx"
Received: from pps.filterd (m0170396.ppops.net [127.0.0.1])
	by mx0b-00154904.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 447B4emr002068;
	Tue, 7 May 2024 07:17:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=ZRLzam8yV/jEsqyEU/76DHGc1UzHiSgNOesU7nfmp+U=;
 b=cBxPUymxmQYH8iTvvVxyqzaNJUQ9oyIlSft+4mgMM9327/L7fXkS7/Ys+Pq9pYS1y+op
 aPKTBsFnuBYuG0HR0M25Q5r5P3lmMz+Ykzw2E5ejDyKe5mlQXd9lTMp5kr2fle4eEbRp
 xv9MXSJLZGMBVKztOxQ6XBZKQDGXoe1xCKPwkDmwSPxhvHIBhp5XHQ/BX4QcMoPMjsEK
 /a3JwjpwjnClNHtg1ujPtjn5yA9PX0/RoXvaVUzrkLoM2G/hmvsO4wytuXoPWwic/Ztv
 Ak0NtgoulPKi26WG7juLf2MFSEyem6WjUNvlZwOVIkSOtfW0VVgxX17VubvKVODkgOqB HA== 
Received: from mx0b-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
	by mx0b-00154904.pphosted.com (PPS) with ESMTPS id 3xwgv1bj9u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 07:17:33 -0400
Received: from pps.filterd (m0393468.ppops.net [127.0.0.1])
	by mx0a-00154901.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 447B8mgt030655;
	Tue, 7 May 2024 07:17:32 -0400
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-00154901.pphosted.com (PPS) with ESMTPS id 3xyhxf99cn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 07:17:32 -0400
Received: from m0393468.ppops.net (m0393468.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 447B32M1014845;
	Tue, 7 May 2024 07:17:32 -0400
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by mx0a-00154901.pphosted.com (PPS) with ESMTPS id 3xyhxf99cd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 07:17:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DeRiuwjtfQ43OXl1N8zTn2ByZO/yOx216DB9CF1NCWTpcnIaGz/FaeVh2DQewCjObQK3D7vfBEbHsdAgBiyJL67OXVX+VTEir1ErfAqnFGvmCOxHpIRd3OCnCo9MA563zUY/5vgFncqK0xk2DkCT9V+U7y5tAqmER9dc0DlV8FNyFyQMGN4Acm+9EdPCXD9CiUtsS1disJtegAao2OqFs+QJt0M5eEzfwqBluVpKdy8cEAWBYFKISHLq7qu83+zPndD/b8iEGi3AEmdg9TJ8myuRrqR/4zgAhcnmJSL6Fk7eipkUIMb5JnjCDNeEHzx11KoGKJBWeuBWCFV/6gu7Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZRLzam8yV/jEsqyEU/76DHGc1UzHiSgNOesU7nfmp+U=;
 b=dWUROY8ao5n9aepb/usplWYcACkf6U89IzLujppjF+X9u1hsLW/8zP1zdkpaFgrmCfSZ8rhst745NIrZZpzP7OwwN65eVLNoo9dSTR5QteI0DXXLOI8ho4jaWx3eJNofFAAZjf4hN8Nsc3XjmdEhPJosWGuG5V6bM3QGHEsTQnH/8S44V96zUFopFWhrp3EnLeLb5mYyesFPESdV66au/nutVIVVxPHPYoos9BdE21RofU+G7cRhoJLjMaVe0kGyAmxcK0CrlQF9wiL8uz8xkJ2AULdPyD4VeIaaJpbd0Ewq1do7j+Cfb6LTU7/Xg94uvJUkYGtjrW0W7397Y6Yvdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
Received: from SJ0PR19MB5415.namprd19.prod.outlook.com (2603:10b6:a03:3e2::13)
 by SJ0PR19MB6799.namprd19.prod.outlook.com (2603:10b6:a03:485::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Tue, 7 May
 2024 11:17:28 +0000
Received: from SJ0PR19MB5415.namprd19.prod.outlook.com
 ([fe80::74b4:8ac3:e695:ed47]) by SJ0PR19MB5415.namprd19.prod.outlook.com
 ([fe80::74b4:8ac3:e695:ed47%5]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 11:17:28 +0000
From: "Li, Eric (Honggang)" <Eric.H.Li@Dell.com>
To: John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
        "james.bottomley@hansenpartnership.com"
	<James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: Issue in sas_ex_discover_dev() for multiple level of SAS
 expanders in a domain
Thread-Topic: Issue in sas_ex_discover_dev() for multiple level of SAS
 expanders in a domain
Thread-Index: 
 AdqWJbfhv3GSaG0rTeK0+6km85YpNwADuoMAACHtcIAABC5uMAEPIjxwADJmXIAATNqvUAALeYiAAIffgZAAQPLpEAAB4+wAAANgfMA=
Date: Tue, 7 May 2024 11:17:28 +0000
Message-ID: 
 <SJ0PR19MB5415A5F70B0D51BA96CBC76DC4E42@SJ0PR19MB5415.namprd19.prod.outlook.com>
References: 
 <SJ0PR19MB5415BBBE841D8272DB2C67D6C4102@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <09dd80bb-09f9-481f-a7a7-b9227b6f928f@oracle.com>
 <b1a5552c-689e-d220-88d3-56d24752be5b@huawei.com>
 <SJ0PR19MB5415831DB91059696672B163C4172@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <SJ0PR19MB54152CB3D611259510902505C41A2@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <c004da1f-b9fe-4641-9d0f-162eabde0101@oracle.com>
 <PH0PR19MB54115A3BDCD9319781FA652FC41F2@PH0PR19MB5411.namprd19.prod.outlook.com>
 <823ab904-33a3-4ed0-8794-cb36b9ad636b@oracle.com>
 <SJ0PR19MB5415F1D35AFB4039A426079CC41C2@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <PH0PR19MB5411390C5A29A953CAA70062C4E42@PH0PR19MB5411.namprd19.prod.outlook.com>
 <7081399f-d4e8-4af9-9cff-2bcb1e4c6064@oracle.com>
In-Reply-To: <7081399f-d4e8-4af9-9cff-2bcb1e4c6064@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
 MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_ActionId=f2b5036e-91bc-42f3-8a4b-c748d91f4bc0;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_ContentBits=0;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_Enabled=true;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_Method=Privileged;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_Name=Public
 No Visual
 Label;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_SetDate=2024-05-07T10:54:16Z;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR19MB5415:EE_|SJ0PR19MB6799:EE_
x-ms-office365-filtering-correlation-id: ffc285b4-7789-4339-607e-08dc6e8747af
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: 
 =?utf-8?B?NkVXOGQvQmdGMmI2ZEVJRTBwU1NiYTMycjVKZmZsSE1oSFE4QjdpekNCQ2Fz?=
 =?utf-8?B?bmI2dXdMUndJaURhY2laTzQvd3lyWU5WOGw1ZGlkZEh5UTg4aXhSVFlmZm9a?=
 =?utf-8?B?NkRDeXlJczBoczBUcnIxSjVOOXBMSEJCdFZVK3JoYU9OenhMd1BWMVllYnlZ?=
 =?utf-8?B?R01qT2J5V1duVFVvUXMxVmFOYVQ1M1lTMjhBM1NQcFlXRjFTZ1lydk5Jc3Qy?=
 =?utf-8?B?UktmejdocmpGekdhekthekNSNGJ2eStsT2NuTFhDWkg1WkdLUkZvY1hsbkc3?=
 =?utf-8?B?d2FteTB0QjlRS0d5ZzdNbXdTNS9DWW1DOTZCYzFQQmEwbU1GVzFPRXpGOFpZ?=
 =?utf-8?B?dExqZHZ0RUhCaEIwb0dKQktBZ01iMmtxeUl5OGcrYXBMMmFENzZRVmJBQ0hB?=
 =?utf-8?B?WW5Vbk96d0UyN041cGl4a0hrTFczd09BSlRjbVEwcC9oL0d4WFV2NDVaUUFT?=
 =?utf-8?B?MTEydDJjaE9HYktET29LZjhyUHptK25lRHEwNEsyZ2tBUmoxT0U5c1FRRTEw?=
 =?utf-8?B?a2llSG1OaGkzay9aWXozazMwVjNuZEx2L0tkWXBMVmxEN0xWc2xqZERjcnRo?=
 =?utf-8?B?eEZmK2lyK2JDNXIxYjdDOFVJeUl4MG80NUVKWEhSVzFySk5HMG5jcE16ZlVM?=
 =?utf-8?B?bmxFQmFDMDlTVHdINVRTRWdwN2lRcy8zUVA3OVBpbUdiZHZ6cnpKWUpEWnRF?=
 =?utf-8?B?TUkvclZ5ZXlQcmUvWXJHbEZGZTNZbHFYYURBalRFT1YwRm5BVERLQlRPNGYw?=
 =?utf-8?B?Z0xCRW5VMEpLbk9aSldtRVdVejdFMmx6a2pxVHRoK2ZjSWhEY3NEYXMzUDVy?=
 =?utf-8?B?R2lhSVVUeDBQRHZyRHNoY3cxdEt6Nk5lYlF3Y1B4VnkwSHN6TDA3Z0ZYQ1Vu?=
 =?utf-8?B?TW1vZ3luRnlRcG0yU2FDOGRFdDhCeE9XSHZNZWUxZXpmaGVMZTgwQXJTMDRN?=
 =?utf-8?B?YzdWTGF0VGk0SmhGWTJtODZnRXZXUjAzdFJlNXdXR0llcSswdmZVU3hXeGdm?=
 =?utf-8?B?R0xvby9hVHVDeWM3R2VsRHV1QUhTdzhjTzI4ZzVZNnFIQ0J0NkhlSm5OYktB?=
 =?utf-8?B?SUxSRm92T1dVL1E2TmtuQnFIT0RzUWRLVkc5Z25jV3kremhLaDNNRTJYL0tv?=
 =?utf-8?B?OVYvNGIydW5qZCtRbWNyT2R5QWxnaEFzVGFLaFZ6NU12NXRZcVN0eUF1WU5E?=
 =?utf-8?B?WUVsSjIxQzZYb2pQYTBJSUpVUExBRkRaRWVlVnFHS1FXRzJsYXNBSEZySUZZ?=
 =?utf-8?B?Q0pmak16TENXYmxxVGF2dWRkaHlaQ1hLRXVDNzBFU25ITkV2YjJ3bmdER0dz?=
 =?utf-8?B?RUFEZEJPR2FnR0tJUUhaOTNVdGlXemJwUDV6clZpZjJiT0RuV0FzRkhxUW1N?=
 =?utf-8?B?L0tPa0F3MkkzSkd0aTlDOUVielVhdGNBVndOTzA2Wm1SdXRuSE5XQXlHQlBH?=
 =?utf-8?B?Wloxc1lCTUg5L2YzYXBzZnl0UVpnMDRyaU1hejhtaEw2R3pPUWJyV1hSNVUr?=
 =?utf-8?B?WGdDL21TQ2R6WERDZ1hBWGVrakpCdXF4Tm9uc2dzWnNteDFXdWZxMnZlZWkz?=
 =?utf-8?B?TW1jV0FHVnhrOWFYOTBpWUFuUWltTnpnQU03Uk9Na1dZTnJkZG8xaVhnNHBo?=
 =?utf-8?B?Uy9xQWg0Y2xlS1d3eTRqbTZna2RCSmp2MmJtcSttYlVTM0xreTFBYjVPTUcy?=
 =?utf-8?B?cUhXcW84WXQ5dDFibXlZcUNEWlgyTVhpR2dHUGhtNm9DZUhzbXkxaHoveC8r?=
 =?utf-8?B?T2gycnpwRTdZb05OcjRyVTMxQ3hPd3p4NEVHekdvTUVjQmNzdG5MME1oaVBS?=
 =?utf-8?B?YXA1d3RUY3BSUFRTb00vZz09?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR19MB5415.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?WHBnWThkaytLVEJUbzYxb2p0blBiZ3lQQlJjUDltMzlCbldTakM1THR1RGE5?=
 =?utf-8?B?R3dMSHQ3dDBPUjhVNU11L0VvaTYxTjRCTWN0WGpnWUN0TzJFT1JIRHFZS1Iw?=
 =?utf-8?B?dnphc3hzeUlkYjZkZitXYm83ejRrelA1amxlOEtxTUpVenFkTDVXNTRxRjNO?=
 =?utf-8?B?SGNXc1Z1UGhac2YrYmh4c2ZvOUkxQTgvY0hxKzhMbEZjVGdQVzRVWjJRSzhZ?=
 =?utf-8?B?TDM2R1BLYVZtTTRaZTBqdEpWa2JJR1lUUDg2ZUhTbHl2OXJPVU1VeFZDSmxC?=
 =?utf-8?B?ejhtNU01N2lkZVI1ME85bzFDWlhiT25MVjBWV09CVDUrYkhDTE9PM1FaTGpD?=
 =?utf-8?B?WjVSRkFOeEp3cEducGx4Ny8xMlFzZm1nNm9wa2E4UG5venQwWkV2Qnk0VVFP?=
 =?utf-8?B?TElSWnNOMml4UC9USUdNSTJRSjUzU0NobDNlVlFCS1dTSnU3WjlWcWlqVDBs?=
 =?utf-8?B?TTUvWjlWeHFwQlFPVHJRMGpRQUEzNGxFMEY2aWtBdGFGUEMveXBpZml4Qk9G?=
 =?utf-8?B?d0ZMa2VIcEwzeTRKdk5IUDBPcWU2S0dMaVNqWHYwbjljT2EyeE9NNTZNQVJ1?=
 =?utf-8?B?S0ZJbjJJUFVjTkxoNXNGeGdBUmYzc1N4WXIvZmh5WHYvU2FPc3A5aWNWd0Rt?=
 =?utf-8?B?cEtNWFVZNjZvekl2cDU0OTdwL1hJUFozdEJGWW1iQmU3NkpENVBERzZjOVFV?=
 =?utf-8?B?RWV5WTBBMGljNTJiZWVwL2pzcjNPTHZBVVc3elRadHlTbkpHeWlNK1dqUTVY?=
 =?utf-8?B?VGVyUUlVVzhlSTNRUnB6WVR6bjh5ejNCa2VzemZ0dFZrUDdKRnZsNE0rOU8w?=
 =?utf-8?B?a3I0dm52aFpZazBwU3diM1NKM0REQVV5bVJ5S1VYOVBRNlZSUWVsVHIrWm5n?=
 =?utf-8?B?TGVkd3Noeis5czVudkZuU05LSE1OSGxxdTNhR25ha2tzV3JXTzh6cnptZ3BX?=
 =?utf-8?B?MitVZkZJc0xxVUhPdW5rZEo3UEpMcmNqSFRhK3hUamFud0ZxNFNpVmtzTDQy?=
 =?utf-8?B?eHhQT25UaS9pVnpJOW5hZFJwcGJlblo4bzdEcU5vNU93cTQ0M3hTMVdwRG0z?=
 =?utf-8?B?NHRiMXJiV0RxZXBYVk52anVHVllvT2VjNnhjU0dDamUzTzZ4ejI0OFlkRmNB?=
 =?utf-8?B?MjdOMzNNcEh0aDdtMk5JTWdqT2RJcExaaTN6N1VsUi9WcHBXWVdMMFg2aGxG?=
 =?utf-8?B?QmZrOXFsSkRTLzJrZWxibHlQd0RSU0ZhUnJDOEVGNExDMklwWm8wclJ2dU4v?=
 =?utf-8?B?T3hkdDdkM1h0clY3bnErdHlBRU5ORVlYbUMyWXpBdDMxOThMTWFla25admpP?=
 =?utf-8?B?K1NGWHhHRCt4NVp2ZFNFSjVFcDdnWkxIb1FYa05ZTXhZOUJFd3ZGelhwMkZV?=
 =?utf-8?B?QlFkN0xOZVBKYzJ4Zys0NDMzMnFwTEd4cy9adWZJdGZ6UU9YSUNzdndRY25u?=
 =?utf-8?B?OTM0TithWEtqdGNxVmt6bWlDeURuQ1d2RmxFTlVKVTFwRTMrOXltMnBPQVJ3?=
 =?utf-8?B?U2NqVG5DaTlobW1IYU1SOUFoWmMzbWFmN0lDbklpK2RhV2pIdnJ0dXNleFdV?=
 =?utf-8?B?MjBBZlZsUGlVZTdnaWx3bXhiWnI2dTc2dzBxNk5oaVJ0Rml1bU1oUVlsSGNW?=
 =?utf-8?B?VG5ZNkVwQ0N3ekdwVWpvcGZKWE0veUdTQ1ZKc0x5NXlQaFQ4anlXVWE2aHpn?=
 =?utf-8?B?SlBCYnkyYm1XYkNYVlhRRTVCOU9XU0tDRm02WTM2Tklta0F4UmJ3YmRtLzdG?=
 =?utf-8?B?SUs5QTFWcXl1Y2lkc0l2MnVqZXJJZFovejcvRTdTV09Jb0E1VTJKQTVtUEQ5?=
 =?utf-8?B?MUdyc2owUG9VbnhBelUrdEdsYVBkbVhnWDZpVlBjY2puRlZvcHhJZmxOWTZD?=
 =?utf-8?B?SDZJNFd4WUpKclZ4bjQ2RmVIY2ticXh0REpFR3ZaRXBLT0hMckZPcmVJRjAr?=
 =?utf-8?B?WXk3T0RScGI1RzF2WkZoUTZBY1FBNVljRVlFTFhiTEorblhTSFAzNGVSdU43?=
 =?utf-8?B?cFNNQWJPRUt0cTNBZlRTWHlPa2xGTzVOSFlQZ2F5Y0sxUmtadlpaWVJ1WFlY?=
 =?utf-8?B?aTFwaTRJYldZYXdBZkRGcC80Y3pMb05XaVBrUysyQnluMkptdXpSUW9LcVlP?=
 =?utf-8?Q?ZRtQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR19MB5415.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffc285b4-7789-4339-607e-08dc6e8747af
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2024 11:17:28.1892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ltg79oTHCtLXmWQLRfDtu3/+Hwkayl21V+PMNt122H/Re8Jw9o65oq2o2vbqDuL1/8TFzbgNUxxM3LlhhA1FAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR19MB6799
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-07_05,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 mlxscore=0 bulkscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070077
X-Proofpoint-GUID: cCWPJ3KOknWleZDNZrs700qeb0oh3kp2
X-Proofpoint-ORIG-GUID: cCWPJ3KOknWleZDNZrs700qeb0oh3kp2
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 impostorscore=0 malwarescore=0
 mlxlogscore=999 clxscore=1015 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2405070077

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb2huIEdhcnJ5IDxqb2huLmcu
Z2FycnlAb3JhY2xlLmNvbT4NCj4gU2VudDogVHVlc2RheSwgTWF5IDcsIDIwMjQgNToxNyBQTQ0K
PiBUbzogTGksIEVyaWMgKEhvbmdnYW5nKSA8RXJpYy5ILkxpQERlbGwuY29tPjsgSmFzb24gWWFu
IDx5YW5haWppZUBodWF3ZWkuY29tPjsNCj4gamFtZXMuYm90dG9tbGV5QGhhbnNlbnBhcnRuZXJz
aGlwLmNvbTsgTWFydGluIEsgLiBQZXRlcnNlbiA8bWFydGluLnBldGVyc2VuQG9yYWNsZS5jb20+
DQo+IENjOiBsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogSXNzdWUg
aW4gc2FzX2V4X2Rpc2NvdmVyX2RldigpIGZvciBtdWx0aXBsZSBsZXZlbCBvZiBTQVMgZXhwYW5k
ZXJzIGluIGEgZG9tYWluDQo+IA0KPiANCj4gW0VYVEVSTkFMIEVNQUlMXQ0KPiANCj4gT24gMDcv
MDUvMjAyNCAwOTo0NCwgTGksIEVyaWMgKEhvbmdnYW5nKSB3cm90ZToNCj4gPiBSZXNlbmQgdGhp
cyBlbWFpbC4NCj4gPg0KPiA+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiBGcm9t
OiBMaSwgRXJpYyAoSG9uZ2dhbmcpDQo+ID4+IFNlbnQ6IE1vbmRheSwgTWF5IDYsIDIwMjQgOTo1
MCBBTQ0KPiA+PiBUbzogSm9obiBHYXJyeSA8am9obi5nLmdhcnJ5QG9yYWNsZS5jb20+OyBKYXNv
biBZYW4NCj4gPj4gPHlhbmFpamllQGh1YXdlaS5jb20+OyBqYW1lcy5ib3R0b21sZXlAaGFuc2Vu
cGFydG5lcnNoaXAuY29tOyBNYXJ0aW4NCj4gPj4gSyAuIFBldGVyc2VuIDxtYXJ0aW4ucGV0ZXJz
ZW5Ab3JhY2xlLmNvbT4NCj4gPj4gQ2M6IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnDQo+ID4+
IFN1YmplY3Q6IFJFOiBJc3N1ZSBpbiBzYXNfZXhfZGlzY292ZXJfZGV2KCkgZm9yIG11bHRpcGxl
IGxldmVsIG9mIFNBUw0KPiA+PiBleHBhbmRlcnMgaW4gYSBkb21haW4NCj4gPj4NCj4gPj4+IC0t
LS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+PiBGcm9tOiBKb2huIEdhcnJ5IDxqb2huLmcu
Z2FycnlAb3JhY2xlLmNvbT4NCj4gPj4+IFNlbnQ6IEZyaWRheSwgTWF5IDMsIDIwMjQgNDozMyBQ
TQ0KPiA+Pj4gVG86IExpLCBFcmljIChIb25nZ2FuZykgPEVyaWMuSC5MaUBEZWxsLmNvbT47IEph
c29uIFlhbg0KPiA+Pj4gPHlhbmFpamllQGh1YXdlaS5jb20+OyBqYW1lcy5ib3R0b21sZXlAaGFu
c2VucGFydG5lcnNoaXAuY29tOyBNYXJ0aW4NCj4gPj4+IEsgLiBQZXRlcnNlbiA8bWFydGluLnBl
dGVyc2VuQG9yYWNsZS5jb20+DQo+ID4+PiBDYzogbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmcN
Cj4gPj4+IFN1YmplY3Q6IFJlOiBJc3N1ZSBpbiBzYXNfZXhfZGlzY292ZXJfZGV2KCkgZm9yIG11
bHRpcGxlIGxldmVsIG9mDQo+ID4+PiBTQVMgZXhwYW5kZXJzIGluIGEgZG9tYWluDQo+ID4+Pg0K
PiA+Pj4NCj4gPj4+IFtFWFRFUk5BTCBFTUFJTF0NCj4gPj4+DQo+ID4+PiBPbiAwMy8wNS8yMDI0
IDA0OjE1LCBMaSwgRXJpYyAoSG9uZ2dhbmcpIHdyb3RlOg0KPiA+Pj4+IEpvaG4sDQo+ID4+Pj4N
Cj4gPj4+PiBJIGFncmVlIHRoYXQgdGhlIGNhbGwgdG8gc2FzX2V4X2pvaW5fd2lkZV9wb3J0KCkg
aXMgbm90IG1hbmRhdG9yeS4NCj4gPj4+PiBJbiBmYWN0LCBzb21lIGxvZ2ljIGhlcmUgaXMgc2lt
aWxhciB0byB0aGF0IGZ1bmN0aW9uLiBXZSBkb24ndCBuZWVkDQo+ID4+Pj4gdG8gZG8gaXQgYWdh
aW4uDQo+ID4+Pj4gQnV0IGp1c3QgdXBkYXRpbmcgdGhlIHBoeV9zdGF0ZSBtYXkgbm90IGJlIGVu
b3VnaC4gSSBzdXBwb3NlIHlvdQ0KPiA+Pj4+IHN0aWxsIG5lZWQgdG8gYWRkIHRoYXQgUEhZIGlu
dG8gdGhlIGNvcnJlc3BvbmRpbmcgd2lkZSBwb3J0IGJ5DQo+ID4+Pj4gY2FsbGluZw0KPiA+Pj4+
IHNhc19wb3J0X2FkZF9waHkoKSBhbmQgdXBkYXRlIHBoeS0+cG9ydC4NCj4gPj4+PiBKdXN0IHVw
ZGF0aW5nIHRoZSBwaHlfc3RhdGUgbWF5IGF2b2lkIHRoZSBwb3J0IGRpc2FibGVkIGluIHRoaXMN
Cj4gPj4+PiBpc3N1ZSwgYnV0IG90aGVyIG1pc3NpbmcgcGllY2Ugb2Ygd29yayBtYXkgY2F1c2Ug
b3RoZXIgaXNzdWVzLg0KPiA+Pj4+DQo+ID4+Pg0KPiA+Pj4gSWYgeW91IGNoZWNrIHRoZSBjb21t
aXQgaW4gd2hpY2ggdGhhdCBjYWxsIHRvDQo+ID4+PiBzYXNfZXhfam9pbl93aWRlX3BvcnQoKSB3
YXMgb3JpZ2luYWxseSBhZGRlZCAtIDE5MjUyZGUgLSBpdCB3YXMNCj4gPj4+IGFkZGVkIHRvZ2V0
aGVyIHdpdGggdGhlIGNvbW1lbnQgIkR1ZSB0byByYWNlcywgdGhlIHBoeSBtaWdodCBub3QgZ2V0
DQo+ID4+PiBhZGRlZCB0byB0aGUgd2lkZSBwb3J0LCBzbyB3ZSBhZGQgdGhlIHBoeSB0byB0aGUg
d2lkZSBwb3J0IGhlcmUiLg0KPiA+Pj4gSG93ZXZlciB0aGUgY29kZSB0byBzZXQgcGh5X3N0YXRl
ID0NCj4gPj4gUEhZX1NUQVRFX0RJU0NPVkVSRUQgYWxyZWFkeSBleGlzdGVkIGJlZm9yZSB0aGF0
IGNvbW1pdC4NCj4gPj4+DQo+ID4+PiBXaGVuIGFsbCB0aGF0IGNvZGUgd2FzIHJlbW92ZWQgaW4g
YTFiNmZiOTQ3ZjkyMywgSSBhbSBqdXN0IHdvbmRlcmluZw0KPiA+Pj4gaWYgd2UgaGF2ZSBrZXB0
IHRoZSBwaHlfc3RhdGUgPSBQSFlfU1RBVEVfRElTQ09WRVJFRCBjb2RlLg0KPiA+Pj4NCj4gPj4+
IEFueXdheSwgd291bGQgd2UgcmVhbGx5IGpvaW4gYSB3aWRlcG9ydCB3aXRoIHRoZSBkb3duc3Ry
ZWFtIGV4cGFuZGVyPw0KPiA+Pj4gSSB3b3VsZCBqdXN0IGFzc3VtZSB0aGF0IHdlIHdvdWxkIGJl
IGNyZWF0aW5nIGEgbmV3IHdpZGVwb3J0LCBhbmQgYQ0KPiA+Pj4gc3Vic2VxdWVudCBzY2FubmVk
IHBoeSB3b3VsZCBiZSBhZGRlZCB0byBpdC4NCj4gPj4NCj4gPj4gW0VyaWM6IF0gSSBkb24ndCB0
aGluayB0aGUgY29kZSByZW1vdmVkIGluIGExYjZmYjk0N2Y5MjMgaXMgdGhlIHJpZ2h0IHdheSB0
byBmaXggdGhpcyBpc3N1ZS4NCj4gPj4gSXQganVzdCBoYXBwZW5lZCBhdm9pZGluZyB0aGlzIGlz
c3VlIG9jY3VycmluZy4NCj4gDQo+IFN1cmUsIEkgZG9uJ3QgcGFydGljdWxhcmx5IGxpa2UgaXQg
YXMgYSBmaXggZWl0aGVyLiBCdXQgZmlyc3QgSSB3b3VsZCBsaWtlIHRvIGdldCB5b3VyIHNldHVw
IHdvcmtpbmcNCj4gYWdhaW4gdG8gdmVyaWZ5IHRoYXQgb25seSB0aGlzIG5lZWRzIGZpeGluZy4g
SW5kZWVkIHNvbWV0aGluZyBlbHNlIG1heSBiZSBicm9rZW4gc2luY2UNCj4gYTFiNmZiOTQ3Zjky
My4gSW4gYWRkaXRpb24sIGlmIHdlIG5lZWQgdG8gYmFja3BvcnQgYSBmaXgsIEkgd291bGQgb25s
eSBsaWtlIHRvIGJhY2twb3J0IGEgZml4IGZvcg0KPiByZWFsIGtub3duIGJyb2tlbiB0b3BvbG9n
aWVzLCBhbmQgbm90IHRoZW9yZXRpY2FsIGlzc3VlcyBub3QgZXhwZXJpZW5jZWQuDQo+IA0KPiBC
dXQgd2hhdCBleGFjdCBzZXR1cCBkbyB5b3UgaGF2ZT8gSSBhbSBjb25mdXNlZCwgYXMgeW91IHNl
ZW0gdG8gYmUgdGFsa2luZyBhYm91dCB5b3VyDQo+IHNldHVwIGJlaW5nIGJyb2tlbiwgYnV0IHRo
ZW4gb3RoZXIgc2V0dXAgbWF5IGFsc28gYmVpbmcgYnJva2VuLCBidXQgeW91IGRvbid0IGhhdmUg
YWNjZXNzDQo+IHRvIGFub3RoZXIgc2V0dXAuIFdoYXQgaXMgdGhlIG90aGVyIHNldHVwPw0KPiAN
Cg0KVGhpcyBpc3N1ZSB3YXMgcmVwb3J0ZWQgYnkgb3VyIHRlc3Rlci4gSGlzIHNldHVwIGlzDQpT
QVMgQ29udHJvbGxlciA8LS0+IFNBUyBFeHBhbmRlciA8LS0+IFNBUyBFeHBhbmRlciA8LS0+IFNB
UyBkcml2ZXMNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICA8LS0+IFNBUyBFeHBhbmRlciA8LS0+IFNBUyBkcml2ZXMNCiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAuLi4uLi4NCldoZW4gdGhpcyBpc3N1ZSBvY2N1cnJlZCwgbm8gU0FTIGRyaXZlcyBj
b3VsZCBiZSBkZXRlY3RlZC4NCkFzIGEgd29ya2Fyb3VuZCwgSSd2ZSBhbHJlYWR5IGFkZGVkIHRo
b3NlIGNvZGVzIHJlbW92ZWQgYnkgdGhlIGNvbW1pdCBhMWI2ZmI5NDdmOTIzLCBhbmQgYXQgbGVh
c3Qgd2UgY291bGQgZGV0ZWN0IHRoZSBTQVMgZHJpdmVzLg0KDQpTaW5jZSBvdXIgU0FTIGV4cGFu
ZGVycyBhcmUgc2VsZi1jb25maWd1cmVkLCB3ZSBkb24ndCBuZWVkIHRvIGV4cGxpY2l0bHkgY29u
ZmlndXJlIHRoZSBwZXItUEhZIHJvdXRpbmcgdGFibGVzLg0KU28sIEkgYW0gbm90IHN1cmUgdGhl
cmUgaXMgYW55IG90aGVyIGlzc3VlIGluIHRoaXMgd29ya2Fyb3VuZCBhcyBzb21lIHBlci1QSFkg
cm91dGluZyB0YWJsZXMgYXJlIG5vdCBjb25maWd1cmVkLg0KDQo+IA0KPiA+PiBJIHRoaW5rIHRo
ZSByb290IGNhdXNlIG9mIHRoaXMgaXNzdWUgaXMgdGhlIG9yZGVyIG9mIGZ1bmN0aW9uIGNhbGxz
DQo+ID4+IHRvDQo+ID4+IHNhc19kZXZfcHJlc2VudF9pbl9kb21haW4oKSBhbmQgc2FzX2V4X2pv
aW5fd2lkZV9wb3J0KCkuDQo+ID4+IE15IGNvbmNlcm4gaGVyZSBpcyB3aGV0aGVyIG9yIG5vdCB3
ZSBzdGlsbCBuZWVkIHRvIGNvbmZpZ3VyZSByb3V0aW5nDQo+ID4+IG9uIHRoZSBwYXJlbnQgU0FT
IGV4cGFuZGVyIGJlZm9yZSBjYWxsaW5nIHNhc19leF9qb2luX3dpZGVfcG9ydCgpLg0KPiA+PiBU
aGlzIHBhcnQgb2YgbG9naWMgaXMgbm90IHByZXNlbnQgcHJldmlvdXNseSBhbmQgSSBkb24ndCBo
YXZlIGVudmlyb25tZW50IHRvIHRlc3QgdGhpcy4NCj4gPj4NCj4gPj4gQmFjayB0byB5b3VyIHF1
ZXN0aW9uLCBJIGJlbGlldmUgd2UgZG8gbmVlZCB0byBqb2luIGEgd2lkZXBvcnQgdG8gZG93bnN0
cmVhbSBleHBhbmRlci4NCj4gPj4gQ2hhbmdpbmcgdGhlIHBoeV9zdGF0ZSB0byBQSFlfU1RBVEVf
RElTQ09WRVJFRCB3aWxsIHNraXAgc2Nhbm5pbmcNCj4gPj4gdGhvc2UgUEhZcywNCj4gDQo+IEkg
d291bGQgaGF2ZSB0aG91Z2h0IHRoYXQgcmUtYWRkaW5nIHRoZSBjb2RlIHJlbW92ZWQgaW4gYTFi
NmZiOTQ3ZjkyMyB0byBzZXQNCj4gUEhZX1NUQVRFX0RJU0NPVkVSRUQgd291bGQgb25seSBhZmZl
Y3QgdGhlIGZpcnN0IHBoeSBzY2FubmVkIGluIHRoYXQgd2lkZXBvcnQuIE90aGVyDQo+IHBoeXMg
c2Nhbm5lZCB3b3VsZCBoYXZlIGl0IHNldCB0aHJvdWdoIGNhbGxzIHRvDQo+IHNhc19leF9qb2lu
X3dpZGVfcG9ydCgpDQo+IA0KDQpJIGRvbid0IGNhdGNoIHlvdXIgcG9pbnQuDQpJbiBteSB1bmRl
cnN0YW5kaW5nLCBpdCB3b3VsZCBhZmZlY3QgdGhlIHJlc3QgUEhZcyBpbiB0aGF0IHdpZGUgcG9y
dCwgbm90IHRoZSBmaXJzdCBvbmUuDQpUaGUgZmlyc3QgUEhZIGhhcyBiZWVuIHNjYW5uZWQvZGlz
Y292ZXJlZCBhbmQgYWRkZWQgdG8gYSBwb3J0IChhdCB0aGF0IHRpbWUsIGl0IGlzIGp1c3QgYSBu
YXJyb3cgcG9ydCB5ZXQpLg0KQ2FsbCB0byBzYXNfZXhfam9pbl93aWRlX3BvcnQoKSBtYWtlcyB0
aGUgcmVzdCBQSFlzIGFzc29jaWF0ZWQgd2l0aCB0aGF0IGV4aXN0aW5nIHBvcnQgKG1ha2luZyBp
dCBiZWNvbWUgd2lkZXBvcnQpIGFuZCBzZXQgdXAgc3lzZnMgYmV0d2VlbiB0aGUgUEhZIGFuZCBw
b3J0LiBTZXQgUEhZX1NUQVRFX0RJU0NPVkVSRUQgd291bGQgbWFrZSB0aGUgcmVzdCBQSFlzIG5v
dCBiZWluZyBzY2FubmVkL2Rpc2NvdmVyZWQgYWdhaW4gKGFzIHRoaXMgd2lkZSBwb3J0IGlzIGFs
cmVhZHkgc2Nhbm5lZCkuDQoNCj4gPiBieQ0KPiA+PiBub3QgY2FsbGluZyB0aGUgZnVuY3Rpb24g
c2FzX2V4X2Rpc2NvdmVyX2RldigpIHRvIHN1YnNlcXVlbnRpYWwgUEhZcw0KPiA+PndpdGhpbiB0
aGlzIHBvcnQgKHNvICB0aGlzIGlzc3VlIHdvdWxkbuKAmXQgaGl0KS4gQnV0IHRob3NlIFBIWXMg
YXJlIG5vdA0KPiA+PmFzc29jaWF0ZWQgd2l0aCBhIFNBUyBwb3J0LiBUaGlzIG1heSB0cmlnZ2Vy
ICBvdGhlciBpc3N1ZXMgKGZvcg0KPiA+PmV4YW1wbGUsIGFueSBjaGFuZ2UgY291bnQgY2hhbmdl
ZCBvbiB0aGF0IFBIWSwgb3IgU0FTIHRvcG9sb2d5IGluDQo+ID4+c3lzZnMsDQo+ID4+IGV0Yy4p
DQo+ID4+b2ssIHRoaXMgY2FuIGJlIGNvbnNpZGVyZWQgbW9yZSB3aGVuIEkgdW5kZXJzdGFuZCBl
eGFjdGx5IHdoYXQgeW91DQo+ID4+aGF2ZQ0KPiBhbmQgd2hhdCBlbHNlIHlvdSB0aGluayBtYXkg
YmUgYnJva2VuLg0KPiANCj4gVGhhbmtzLA0KPiBKb2huDQo+IA0KPiANCg0K
