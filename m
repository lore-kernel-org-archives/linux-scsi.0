Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E38B2749CF
	for <linux-scsi@vger.kernel.org>; Fri, 27 Feb 2026 18:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772217147; cv=fail; b=Y+0y9T2PyDpcTzp+y0tt89XygKIl9GnrXj7BaJ4VqEoRC7gYUZryGzs2ViEpCdCDZ6oXIDArE7ZVI/ULDNt1keAW9yQ0mnbIIe0xkOR0ZuhbN5lKez8rqKEPB/LWkzgq4b+dDX/Iq0xOSRWUswCY9vNrNLNp27bYEk2N4Bk8f3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772217147; c=relaxed/simple;
	bh=wjtq8FbQWV7Q4xejVHmn8/7SK2Xvpps3ssQGdaA20Vs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZwrqRVt4UX3vd3uENIPKeG81OUEglLRD/L5W9grtAhhv0mYw5I9e2RYV8pDyDZL6XKBsIbyQuv7zpow2OooCxzJpPgU80FTtKZ+Vx4iMKf6lS/oWsf4nkAeil0rC0c3lr/XzAcCe1AVWty9AWV2KT5G5Li8woBqd4Xq5MeSoBbo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FvJFbmKA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IXdw09O+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FvJFbmKA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IXdw09O+"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61RGDMsG2247657;
	Fri, 27 Feb 2026 18:32:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Ms9gCAzcAp2CS7DXKhV+Kzp4iLRNePKm5VnJcqvsGhQ=; b=
	FvJFbmKAjl1i4iNsr3GuG0YotrdZtidR29gzTq74WhUPdWVJ0genA/zRVVc4JhQ6
	vksC21NfiGPiLSiBdMk9Ik3ukdREEdnIkDeECTXgwT7do9bRZZFYIidFVVMRWaQZ
	9Af3HGQ6KnFewpBKwOMeV4LCaNljarx6RAhLhFiO7BSfAPmCbQbMCiNecTYTAeKi
	Cw5jxkthyw8VZNxZ1NFRzoSxLDP/0d+bBC0zElOF9gndq+Lxbm7zxqYxKD5uTvN5
	CqJF19IVj07z+5Q3ZIVdAJXdutZsbk/uWpicgBqgZVI44lBg/McCks/2hG/lmk2L
	rOj7UndnZx5dgC1367QiaQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cjgg3v3x3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Feb 2026 18:32:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61RGl5Ei019125;
	Fri, 27 Feb 2026 18:32:23 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010002.outbound.protection.outlook.com [52.101.193.2])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35efs59-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Feb 2026 18:32:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G6Ved6o1lmG6GN9PMx0EOgVLpftvAZ5G+DedCnDn7/ns88iucou4Vt+A5TAXT5T5BzzkRsq+YH85XVbYfLIR8O0OZAfeMHI90P/9S69gbYiUSKaJef8TC6SZkAFDz0makaeuzvYgb3u7sh/JxwWbKJXNOy6VGCry9bhGH6AEQoOsHri3PwOfil+Or65XblwTtZPBpWA71r0UWHZNi2SAax4PykQW09GWoEfIG/hIdYvHkRRSixkinXw+e1wikcU/mAw5jQVMgcydsFktyK0drIUown3iAqj92fD6Erp8o5IskeOlQaNNxUpamYEqyVhgHxsoQB3iqU9R6nbZNcQilw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ms9gCAzcAp2CS7DXKhV+Kzp4iLRNePKm5VnJcqvsGhQ=;
 b=dKFk/pB44EMTgCocwma8OW3bLldm6gSIRq0Y1jNNYuZ1GlKOLWcaEfbeu7T8C8JqctiP/LKUQXD052COBz7X7+SbAvc9LkccmROj/omRv8266Dd0/dwiQjyRl+VZnZyXf6WhEcVolezbM7i7OGbbChiIKLGhMV9MWPYL0hTJPW7gUVXbRpK/ojmXC54To/korIU0GSmfI3CyJoZg2ZijnntXfY8Xbtm3L6ba6cvE3BmGIJMXjC/DpXKiZbAtCxXXA645bQcOxaHRasK9sYOKkXfoCx0iItIJ6mv1wDxRoN+2GxjwdArpJHhy80C8GdSRO6yKqziaO0cjG0VVWzL2kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ms9gCAzcAp2CS7DXKhV+Kzp4iLRNePKm5VnJcqvsGhQ=;
 b=IXdw09O+WRyyUuPjaS8wxr36XsFU3vdp74Q2M1PIiEU8OGespTKNdb+BVFJXw6vOeMzY/lkrzNPH5jjS9FSNQRcdZq2MO3WBvcAb8+icqRyrdoRcRtGItZ5ip8e1NEAf2slBIshQQV67M28TP4yUP4pmAd99W/Ym93LN1bk4ejk=
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by CO1PR10MB4595.namprd10.prod.outlook.com
 (2603:10b6:303:98::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Fri, 27 Feb
 2026 18:32:15 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4ee0:38a:f5b6:336c]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4ee0:38a:f5b6:336c%3]) with mapi id 15.20.9632.015; Fri, 27 Feb 2026
 18:32:14 +0000
Message-ID: <297259e4-5d9b-4f20-ba33-228210a8f2f8@oracle.com>
Date: Fri, 27 Feb 2026 12:32:13 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: fix refcount leaking for "tagset_refcnt"
To: Junxiao Bi <junxiao.bi@oracle.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
References: <20260223232728.93350-1-junxiao.bi@oracle.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20260223232728.93350-1-junxiao.bi@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0197.namprd03.prod.outlook.com
 (2603:10b6:5:3b6::22) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|CO1PR10MB4595:EE_
X-MS-Office365-Filtering-Correlation-Id: 2410f032-7861-493d-605d-08de762e871e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	+U/RxDdxf5/tmDeSDFFpUtdAkgD3B0zdqEAtWy290QnKvFBwMQV0X2NR3jMwCHXoOVXUaL49ZSJi7Z/qCVzBJvopinYYwSBdF5Hk6FRp3BGft6cFOMYL9PXYSHrk8YzzQ0/sELjsjHreBcIjE0IuO1o2fRZZ+rgAK61JyXHGYPF3r42J8Af3lE6oRkCUHqR+40NnMPkpmbWGKIF6GDlb6n7AYqr8fA1c34gIQWAbRZJXPtYiabxX5wLTQl9lVo0VsIsDPzy7NTGOS+844S2+RIRlWQspODsD6KdmYYGjelgSo0QrS0h7lY0OGZZR7FXMMUsykgqLB6hqyEBY/6PmgUJ/ZIk3COob3L5KWtOGNavt8KfkhW6tZ2OwhAW4YIUfzbavl645HXf2ZCvtxtbRkEyhtuoHlZweX6TgeG8rne6qX2a2pTW5vVfsG+gmzLGlqQrDsttyxaZLx3EpNtnOWTAHI6sXmRnCdtxp5mHp2aIkIZsp0wQ9QN8i17fS4c2l+Kgn3D2V0G1AxckYc75t2wp9On76LFnSoAngDJbe39dCGbt+jUbKy8vIAgDHJRKt4ctYkMhHSzaug377lt0zYyG9yQl3F8AoLeaOukhwlWahIjOih2YDdJD3BRB0Y00vTuJ7pd69XQCDAEgKedXEoJY/0bM5nVKSOeTpUH5XJF+kgbu70cy8DzvfSZuvA29U59vpDrHGhwH34iWh+kSUyggZCtPtgF9JsoORmCXRNJg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bVdXNC95TmNUSHFTY1J3R21jbEN5SE1zLzJNN2lJK21FVFhad1FwVjFVOFl1?=
 =?utf-8?B?bzFXVGRHSFRKa3dBYVBTcGxGQzVyOEg0R0lEWVd4TkVkQkt4NmJTWm9Cb3Yr?=
 =?utf-8?B?alYwOGFVaDg5b0RDckllNHNFT0s4aFpwcDFMRERsemVSMTc1dStHTk9pbGdU?=
 =?utf-8?B?R1pjaUptcWVLaDRjZ095dzBzL1pIaHlodmFyQ2Q4eEYxbmV1VkZ6c2lwSG8v?=
 =?utf-8?B?Smt0TTJYMFBHZXVvNG91WTVVMkZsMUcxVFVRUUpvanNzQ0NNV0VVMi92RExi?=
 =?utf-8?B?eUFtNGRFelVEWmNhKzlNWTF5YnA4TWtnNnB3YVFiVEFEVU1iYVJDUjB4ejFS?=
 =?utf-8?B?a1IwZ3A3QmU2ZldDdmhPdXZEdGdUa1EvNjJ6SmpZT3lSbUM3Qmh2OExYcEdR?=
 =?utf-8?B?dzRvUTVEN2hxOUNRbWtrMW1sOEdyclNlcG0rcGZzbGVHZ2QvRUU1Z3lrUjk4?=
 =?utf-8?B?bHh1L1Z3L3dJek5IYUNsNjJQc2NXQk1DbnB0bGt5NWZ4dGdKaTVOTm5OWVlN?=
 =?utf-8?B?UW1YdnJDa1NqZkdydmI5ZEFsT2kyRWpGZDJxVlFjeHFBOWQwbUxvamxyVmg2?=
 =?utf-8?B?SnpFMjVaZXJpbm5DQXkwV2tsd3Y1dU5jSCsxVmFoeUNJbTBTMnZqSzRLZHRp?=
 =?utf-8?B?KzhIUW1zNm5MZU5SdGgxaHR2Y3U0bFduREVsYWNNam83NmZ4LzhjbTUyVEJk?=
 =?utf-8?B?SUw5b3IxTk9OSjhTaFd6NVhCWDMvVFg4cEVSS1orRi93VnVjYkZvZmQraDVB?=
 =?utf-8?B?WEYzWkc3d0NWS3FtQzZHUWlOK2g3WTRqUzlrZkhZbUtNTDUzTVlxVmtpRnNG?=
 =?utf-8?B?MlV6OGZ6ZExENlhIOTFsWDNPV2pFYzV4T25zeEhXVkZiZ1c5REcxc01FYUhP?=
 =?utf-8?B?VzRIcVdtYkNCNjN4RDBkNUhRNEhFSkFKaWlMN2gvc3VoMlRkTXJpdk9zUnFE?=
 =?utf-8?B?Q0hMZVEzUHI4S3dhMi9tZjVVaklZUjQ3em5Fck5Sc1VTb0NTTmVtK040V2gx?=
 =?utf-8?B?NURsU0RRcStKT3hpbitkNTZ3MGNkeGg3c3R6eE02V3ZQTTVYTHd2U0tzUGdm?=
 =?utf-8?B?RllxRUhRdDY1aEpZQk1hcnVJSExWbU5pbURTbkZUYk5mSnlRNlIwTCt6azlZ?=
 =?utf-8?B?RllSUittaEtmRFJlSjRVYU1wbEpEUjRESjZmQTI1ZUhRdFFsVjJZYVFJR1Q1?=
 =?utf-8?B?aHREVlZYRVAxUWJtSzVpaCtUZ3QxeFJGdGh6d2pYZDJQYURGTjVScUNESmFV?=
 =?utf-8?B?UGUwUUdHTEExQjBGOWpycEh4L05QWDVrSGJlZjJSdVJ2NFI5QkdaWmJ6Rllv?=
 =?utf-8?B?SmgwMWxmVWVvOEdLZUV3TUovejFBQmIzakJ1QU9zYUFNZFlacUV2MnNaOFpU?=
 =?utf-8?B?d2RLem9VYlJmYlU3YUc4a0l3dUxDS2NsdEZCNHJIUUtOYzFIa01qYlUyMEFE?=
 =?utf-8?B?L0Rnd3hWZzgvQXBTQ0dIRVhWajJpQ2FkUkZiUFdhWEo2R0g4T2NWWXIvZ2xM?=
 =?utf-8?B?VGdpN2d3aU5NdVRNaWpYS0J4TjlJN0ZEd1NMcnVTcjdqQXlBQ2s4NU9mc2Zr?=
 =?utf-8?B?NUpzaXQzcVI4YUJBb25EREY3azFCVjQ0U3FyZGtjci8rQUpkUTQyeHA2enp6?=
 =?utf-8?B?Z093MHNoT3UyVTFpS3VDL1I1NTFxemFBVm5iamtZTitmT202OTZHVE95L2VG?=
 =?utf-8?B?V1N0azN4YlBtSEZpRWtQWXZQWXQ2Q0U0QlJQaWRBaDl2ckRwQW1YaENJa2NO?=
 =?utf-8?B?Q2JONnNoWlVzTVNrN0ZuMTlQL25aNHp0OGFoYTNkV2tiUWhHMGUrT3V4NGtB?=
 =?utf-8?B?MnY3cG1vUU41NU1zdzQ0Vnlpa2JIdXVoZmRYUWxsNmtiYkc3UE1WeHBZYk9K?=
 =?utf-8?B?Z3BlNEM4Z29JNEExeUtVK1ZjQXJKNnkzTkM2bFRBQnh0bzkyUkNaY0tDc1Vu?=
 =?utf-8?B?cnZRak9tbnFwd2JuZEtYVGhoVEJGREtaZWM2NzU2ZTNYS1dXNzRpRVpBczNn?=
 =?utf-8?B?QUpDVVhBTVVONVBLcFprRVArMnpwaFhYbDBDSzZIVmV3UmxiZG5XcS9IRGFW?=
 =?utf-8?B?OElqSlRRSHdOSU1RV3ZHNEw0ZlNtRDRVS1pzT3VIVVJGYnhWUC9tbllUZUYw?=
 =?utf-8?B?eXVKMG9Mbm52ZVAwZlNINUxydWhyd08zWG94Wk82UjZGZFVHd2hUeXJqSkIv?=
 =?utf-8?B?a0dJdmpnaDdHeUZsSG50RG91VmxNbUZuTkV0NkJLS09PT1ZuVzhadmdoMDlj?=
 =?utf-8?B?bERXTWZxUjZLTnlEVXUrTXRUUWtZVDlITEdoWDZ2QkJDT21pc29JS2xERHl6?=
 =?utf-8?B?S1ZIU2s0UVZoUzdENG9FWUd5ZVhhT3NtdTU5blA0Q1loOVpHOUgwaWFITUkr?=
 =?utf-8?Q?n0dm8iha9A3T8z7A=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nQ8KzQvBbYWJvSpHFzeLvD/kwgwJpLxg+g/rV7W345E2D9aPiV5Es7EmhTk5Wv4kRun6Ie9VDe5AXkTwUDXjc9Je0BMpd0Op56CnaQds64PI04yxZ7t2XMWvXdZvKaD4HZVCpOYUS9iAIuIQMI2D+mkqyj09dXZa7893ntphwYphN8QGdaajwWmKsMK01f3Tdnpg3jM6H1WT5hlFMYr4QyGF+BPDy0yj1wL6FFvQZuYreFo7qORixjUjBWSMoCd2wIDBDHLQHYSkf2bsliuJfrYO4a5kbydYgkIK+hpRB56bEA8aSrC2wb2isGrlOz6F9MCBouPfkQbmXnMFoDl1SfTKY1qwo3U6Ewas5nKu3qLp+GwIlhFR2q8ges+Q3n0IQmE0xLk3cHVKUjojagWWdbpyA167ftmTohDkKunlvunkOq5mR1s5LXwmNUlKfLhgC6bD4JHwirDj42+QdZYExL1fZGon2boACPTRXe8fZNf3OT/kFyG+hQTWZHbzjl3b+MI6nL6FhF/oc0oSpaXJ3A/YUbVbP3pyygnlclT+2toRWYIJbCgwkmdrOjhibRkBZUyzBXKrLlZ1rbOgVRLXat1nnx0BkmPPTYwkhRXa1Qc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2410f032-7861-493d-605d-08de762e871e
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 18:32:14.3481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eM0zi2Zqnu1Gz1FPC9GizA5qrjk1Lcavwp2iKCrOKT0SoZ1/+mLHFaokRLg06B48r6uT2PTnI0GNFVIJszZW9jMaf4Zf29+pv+lX2tgxbPA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4595
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-27_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602270163
X-Authority-Analysis: v=2.4 cv=XZqEDY55 c=1 sm=1 tr=0 ts=69a1e338 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=73EVitq7pRXKZpIRPpkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 87WrVfSWEpCYve0NeusJo4C8cUkV8xRu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDE2MyBTYWx0ZWRfXxG32DU7/wrVu
 OsYp4Agv/BxkpxAe/bpcmEuDWNkVe7Rdy26iJRoqOL9xJC4Mk2C1GqtSIgoKG6ZrhKuDUOs8aL7
 v/95HP7a5ovKp+Jng0EC7q5jaGxvxI2b4bqRnPRDky7TsYDIqLlBz3sXYXUxpGXrA/FME3p6G9f
 PG4i6D2WNSwPukLH3wdg99q0WnOCWlLyaH1NWvoethuz8ZGMUHbJwo9iUqKm84rkffY8EWhmccL
 Hq1Z/hDvrzHNEI00N/jDY3AzKHX5+VyT0dyNRwqQmdd8dkf5nXwwkd+XcW8AEOZ0X+pfdnIDnel
 DNC7BEqh++CfhLEEjII3lJWpAfXLv7bViMUOZmi7AEYR0AohFBbITirARQmtomQ5Jt4OSzzbyd2
 JAl6ZpSZppcacrPysgbia3b+IR3PozqbkrR1YF6C3H1fYCUV98Z/49OUxRMdAzfCZgHhz+un3Ys
 4g/ks43DNID1XyTde4g==
X-Proofpoint-ORIG-GUID: 87WrVfSWEpCYve0NeusJo4C8cUkV8xRu

On 2/23/26 5:27 PM, Junxiao Bi wrote:
> This leaking will cause hung when tearing down the scsi host.
> This is an example with iscsi, iscsid hung with the following
> call trace after this kernel log.
> 
> [130120.652718] scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
> 
> PID: 2528     TASK: ffff9d0408974e00  CPU: 3    COMMAND: "iscsid"
>  #0 [ffffb5b9c134b9e0] __schedule at ffffffff860657d4
>  #1 [ffffb5b9c134ba28] schedule at ffffffff86065c6f
>  #2 [ffffb5b9c134ba40] schedule_timeout at ffffffff86069fb0
>  #3 [ffffb5b9c134bab0] __wait_for_common at ffffffff8606674f
>  #4 [ffffb5b9c134bb10] scsi_remove_host at ffffffff85bfe84b
>  #5 [ffffb5b9c134bb30] iscsi_sw_tcp_session_destroy at ffffffffc03031c4 [iscsi_tcp]
>  #6 [ffffb5b9c134bb48] iscsi_if_recv_msg at ffffffffc0292692 [scsi_transport_iscsi]
>  #7 [ffffb5b9c134bb98] iscsi_if_rx at ffffffffc02929c2 [scsi_transport_iscsi]
>  #8 [ffffb5b9c134bbf0] netlink_unicast at ffffffff85e551d6
>  #9 [ffffb5b9c134bc38] netlink_sendmsg at ffffffff85e554ef
> 
> Fixes: 8fe4ce5836e9 ("scsi: core: Fix a use-after-free")
> Cc: stable@vger.kernel.org
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>  drivers/scsi/scsi_scan.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 7acbfcfc2172..c64ef71633d8 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -361,6 +361,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>  	 * since we use this queue depth most of times.
>  	 */
>  	if (scsi_realloc_sdev_budget_map(sdev, depth)) {
> +		kref_put(&sdev->host->tagset_refcnt, scsi_mq_free_tags);
>  		put_device(&starget->dev);
>  		kfree(sdev);
>  		goto out;


Reviewed-by: Mike Christie <michael.christie@oracle.com>
