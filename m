Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A591D63C6
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2025 06:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753339443; cv=fail; b=dKTqeJ8YFnFlgaDUjla04w8iQpXYEve5hj6Qc3dpttI0QbwGFvVr5Z5sOkRQ8BuXYyHFqlJvwU9bZYgGiOZoRQ1hZBYx0xhQ7g0UJpkjVeHyYOoe1ttNSWto8Q+HheusSZpsEGXOcgAX5bMZTdcKJkmaZHAfwQtXethdIB1aQnk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753339443; c=relaxed/simple;
	bh=cg67FsCkQFkbrDpnZJVH8hgngu8u2vVUUCFAbe/h8Fg=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kJl7DJnXQypFQm359WeqJbF7Gywkyo4LeMcrMVxvK1Iwtg4uLdOE85MfjC1tNBkVvUHe3112w2b953I7A5TsSjNe+EflDRHipyxMg0q3U3Z/3qmeT26VtwCGBfTAjoBbcX0q2pdPHHG1nmauUFOZoPmv/Pq4KGJDjBU9sKUDaaY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eUZy/8Y6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FNKTKll+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eUZy/8Y6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FNKTKll+"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56NLQrKB022449;
	Thu, 24 Jul 2025 06:43:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=BQP1J4Sc6tYLuPJBSdDq3nJ5HWcyrpSV2cv+asSsoU0=; b=
	eUZy/8Y6VuvWr7rPIKPuz498nDO6ihF6s246joic4I5j8vqW68s008QPnYY3RfST
	E2PTJ3ulwqc9dnlhJEnxJZIdf675dFzTe0WAwr5oMtRn3UOf1KiXPOmiNwaxgL7Z
	syU96lZABMkbBTbGVgtCsatH1PMAUZnLgHmpK7iWNriJJofiyVADvAH07w6SJCvV
	go6JEL6R4PHswC8v2tl04fSwmcivFDNKLj6EZriJYv45HqyXNzF3YLV4fEdBnBCV
	f+4L5HDASWwIIntgnxFPebmrA7Z1/LCOB2GdhJDgxtzWm/klyOP3ZQl6ZtD7Ldoo
	Tbscud0OvgwWzxndiiDc2w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805gps0wq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 06:43:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56O5P3q7011115;
	Thu, 24 Jul 2025 06:43:51 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2071.outbound.protection.outlook.com [40.107.93.71])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tbg86f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 06:43:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T5MIGtnD2531gho4CxbPEFC3S/YKN1yOulnosJU/EYC024eu4j9nssoBug0qs91L6Bl67Yl68C8YAz33q/pWs8oxp0FKlngRM05e2ue5VzFh/Qx4DAgY9fYbhhZZq+Lnp1LOKeN0jl+0VIl7xhjxrMOWKl1IAQtP/vVhSDFPGew667UcOl58qizTd6TeNayoj+kxvtdGlKAgWaoWGjIMbYrs8QReYeaNkUXzq8tKJgoZr56VDNcM3BeoBXXXjd1ebvBx8e2VTQuIcIy8kXvZxGfuU/S4tM+iiSyIefADjj5UhGAJxaO0dz7FytslEQoz1FqRmchW7Jim00plClp+rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BQP1J4Sc6tYLuPJBSdDq3nJ5HWcyrpSV2cv+asSsoU0=;
 b=Cd69RuusUT+UZWiU/6rnmAc88R8wF+vUeQPwgb824Hg3QDPiWNeAIdZ3n07PDzgr9ym/YFuWmMSZB5omzyoFPkYRsmInOt7d5NKnv1I7ntkkm1WSONi09cN7hhfFGDDjhQXSsJ0geeAP4ylc8zFumw9JjAIXowFYcZB2lNd38U+AgoaK6lffNjVYJVcBCEisb77vIbEl1wZ7bb8ux7vrgZIJ0w3GFnLcDjXnZkfpWvhqKQg22g+0MMDaJHuC9Kz81t7zFtEbtp/rrkj+7mV4bhASE0crUfPLZahKjI22h2XI20JyvNDb3K1xd2LFZU+ceGBNHyoGbm6rgQhqNih7Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQP1J4Sc6tYLuPJBSdDq3nJ5HWcyrpSV2cv+asSsoU0=;
 b=FNKTKll+08roD11iHbHTv5kean8IBPC/5/1bVOoepN6xseYzFoitapukIT0L/rUiX9+9iYYfGLaVN9o2Ou0l8Ffg+bE0aPoZxjWdszjNSpevs3lYr+6Apm2GoKWbEvWyjTohDngciQPNBmxt/aY2NEMj7Be+bhoyytG5Pk5Umvg=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by IA1PR10MB6074.namprd10.prod.outlook.com (2603:10b6:208:3ae::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Thu, 24 Jul
 2025 06:43:47 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.8964.019; Thu, 24 Jul 2025
 06:43:47 +0000
Message-ID: <d3b881fd-89f3-4ae5-b9c7-335aff739698@oracle.com>
Date: Thu, 24 Jul 2025 07:43:45 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] scsi: libsas: Simplify sas_ata_wait_eh()
To: Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20250724000235.143460-1-dlemoal@kernel.org>
 <20250724000235.143460-3-dlemoal@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250724000235.143460-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P123CA0024.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::7) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|IA1PR10MB6074:EE_
X-MS-Office365-Filtering-Correlation-Id: f5edc358-a7be-4cca-12e0-08ddca7d70ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dUZwdEpNTEVlVjJlYzk5SUMxcGRraXRFMUdyKzVJL3hzRnhleFFPNkZ5RnQ0?=
 =?utf-8?B?SWtDVkIxOGNBYjhIWHVTczBIdVVBSmtmWmEwZzRkVHZNMHJyTDE5aVV6dlFh?=
 =?utf-8?B?akUvM0JXSEhNcHVpQTZaelhIZGk0SlJsQUFybjNqdjBUSnUwTHNJSklyWnlP?=
 =?utf-8?B?ekNuYTlrS2ljdTBLYVZvOW8wUnQwMVJlMzNIMEUxZHhvWHFGcVU4OHk1T21j?=
 =?utf-8?B?Q2FrQ3AvdGh5cEV6cUNuQ2ViMTdJSW8yNkpobHg0MDlIcFFYa0pvWW9BcFBG?=
 =?utf-8?B?WkRsZWhBRnVvL0tiakZmVVJlWUx6RFNpVUFPcUY3MFhmL1FKck90Zy9MU2p2?=
 =?utf-8?B?WEJldm9HeTdZdG1UV0tXcDQ3MXNKR0FieTE4ZUVDMnpxRjR1cDRzM00wdTJM?=
 =?utf-8?B?VjFOMlNSZnc4V0FGVlgxb3RkdHVkL1dlM29nZnczL3RoRVBYYW9DOVUwWDFF?=
 =?utf-8?B?RjhaK0dZa1VIM2xTalZqMStxZ1oxb2gxWmZlYzB4bFJ0bFJPbUZSRFlYTFNY?=
 =?utf-8?B?VGxuZkMxQldocEt3NFdUVTVnWjF0ejRYRUQxQ3JsT1NuVVFYZWI5cmVCQno1?=
 =?utf-8?B?b2lMajBEOUdvRWpwVVg5T01PVUVTZDFJVVU3WWVDb0RpUG5Tem1TU2d6dGZK?=
 =?utf-8?B?NTVTVlNrTzAyUFBORkl0RFZSR1ZpamlLODlRSnhtQW5FOUN0cFBxZnI2Mi8z?=
 =?utf-8?B?dFpjMVY0a3RuME54VmxYblpialZyWERjcXl6MlkxcjRBenRpcitJVmU1MHR6?=
 =?utf-8?B?WGFHRzVxN3FMYjE1S2Rva1N3UENEakRoeERhZ1ZTMFFEcFBaQ0x1WlM4UEty?=
 =?utf-8?B?V1hHVHFPdktvbjdWbW9sVnVnNis1b0hxeThrZzRIUFNia3lpRnptQ2hqeTln?=
 =?utf-8?B?dkV2VlpzRm1BYUtxWHorTEZZckR6RFEwbkdzNkxraTZ4dFpFSVRtWUlwTEkx?=
 =?utf-8?B?TEdyRHQvQUxMbGxPQ2dmTnBlN3JTem9SNGhoSTJad3NsL0JZcSs3OU81QjRa?=
 =?utf-8?B?VDdET0xiR21JOS9tR0Uva1NoRURkM1l2MXB0ZkY3Rzg2RzRWKzBUc0RBZVpm?=
 =?utf-8?B?bzhwQnQzOHovNTBHZmlyQW1PQVBLNHVuNG5JRTJmSVF0aUE5ZzBnTnVvYVAw?=
 =?utf-8?B?dklOSWY4R2xoTWVZOWQ4NE9wQkdSZ2YwRjI0K0U4eE9PYjBPNG5rQ0k5b0xs?=
 =?utf-8?B?c2dkWXUrZjF0b09yNUZ3ZEpFY1dXOU1aOHdmR216S2lkbW1ya1Y0WER4YUVO?=
 =?utf-8?B?QjF4T0ZJQXhoM1RsbDdqRFp4OHpLRVVyeG5rRDZIMXd2V0Q4UytXK2tadFpl?=
 =?utf-8?B?c3hoR3lhZGtwMDhlZ0Rvc3ZkcWp2VXVVV2xMVng3b2x6RklUeDdrYlR0OXdF?=
 =?utf-8?B?OWF0QmFiUHEvQVd2VWRXZDFkQWFPeDJscXBSTElqYlVWVWlPa0VhMENsREpN?=
 =?utf-8?B?NmNIMFpHSWhIa3ZhWDlnVVlBNldnczNHZStvOTdkc2t4Umpnb29IWGo2cG9h?=
 =?utf-8?B?QUZHclB2Ty9kblpYc0FmU1ZwT2JTQmp5bWJpODRYVm9WQk53UHJ2OTRaVXlD?=
 =?utf-8?B?V0lwU2tKeXVsQUxXK0NlaC8xTHArbWVFZ2tNQk5zWVlOTFJBVWhWc0pTZmFO?=
 =?utf-8?B?VTk1NXlZK2J1eEkyT3oxUnlQcHNzNjZGcmlmSjNRMmFJWkp5am54bzRmVlJM?=
 =?utf-8?B?WU84UWx1N01WZy9XdVdvR2pNZDBNUkJ2S3FBNE4wRHVDTHNLSHFycjQwUjlJ?=
 =?utf-8?B?eXM2eVVzZWdiWFQ4TE4yMVI1QzlEZm1NRXc5OUlBZUZpSVE5eGZRbmYyWGwy?=
 =?utf-8?B?MTU1Y3pxTlpnTHNLYUhTUUhQYXJpdW50Mktqd1JZVVJ0dE1VZ0hmSDZ1T2dG?=
 =?utf-8?B?SmFLQ2J4RGp1V0dzQ3ZSQmJpNDR5NDlCVEorRSs0cUJxSDJlQjVOL0VydnB6?=
 =?utf-8?Q?x55c8so/Xbc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V0txeUx3RXpDNmNwcTJ0M0xrMWRxazRldzg0cFJIUU1wVU9NUi9hTjkvcTRN?=
 =?utf-8?B?RTVKRG53NjlyWEdLQklnNXBRQjZlQk5yNWN4VEdZV2wxRFltVkVycUFGcCtx?=
 =?utf-8?B?Y1dCSFlheTUzNUJjRmwwTUdCL0I2cW9YYWt5NXVGRXdiQnZpakhvMW9kNTZD?=
 =?utf-8?B?dGlqU1N5Y3p1ZGlqa0dvZmltTnkwcVU2dEZnQ0htU0o4SHlqcVZYWUx1MW1w?=
 =?utf-8?B?S1k3V3VIUWlRYmF6L1FHQjdEMTd3SmdKUVdwTkp3MkNqMkNGYU9QazN2bWZR?=
 =?utf-8?B?Z0tpR0UwOWlpZ3BzSjZXUHFzc3VJcFUyc3EzNjdWUld1d01MeEpWK0FBY0FO?=
 =?utf-8?B?QklyS2hmVDg4dmFJbVJ3UCttWEJEdzMxVVNheGwxMThCS0JLdzZrSWxod1Za?=
 =?utf-8?B?cVMxYWJSOVNmSFpEeW9YMWI0YWVGaVFWWk1VaDFLZWdnWjhmdUNObGEwaldG?=
 =?utf-8?B?RTk5NEV6Z2RiL0ZpU2lrUWpHK01CeFdyU0toTzBMcEhUWUFGMkV4djVnemlL?=
 =?utf-8?B?Z0g2aGZab0h0S3NwMTNBekRiSTBSL2FyWVZqTXI1S3pudVptYWdJaXMwRHJy?=
 =?utf-8?B?ZHl1MThvUzR6b052QjN0aHBoR1lPZ2Z6VTNCRXZjc1ZhMnhXNHRrVWNsVW5S?=
 =?utf-8?B?akxYa2RZY05FQ2JiTVplQjVKTVZuOGZTRm4wQkRpeWN2N2xYb1g4RXJRbDZn?=
 =?utf-8?B?SFJwYXdwN3Y3T2M0UkhRa0RvTjJyTmtHMDBwcCtSeTNPaW80WVpSS1BucDZM?=
 =?utf-8?B?Zi9oME13ajdhYzAzTjZ6VVNpYTBjV2dIaHRVdFNZT3ZjeTE2Qy9rQmJIdUlp?=
 =?utf-8?B?WFdWK0xPQ29qOXJXaUJXeGZqZzdibG5TMm1xaXV6cFVSN3ZUazlsbjVub29D?=
 =?utf-8?B?d2FXUXYxN0p1Uk1hK3RsUjNsa3ZMZU55bXVjcy9Yb01yM1Fsa3hJb1dGRUda?=
 =?utf-8?B?cm9odHgyNEpBKzBpUEVJM0VyRFE4VHN4RTZPKzJLSmw1czNFMnNVenBPUjMw?=
 =?utf-8?B?aGFXbVlPUXRFUjNCK1BJNU54WUtOZTNLWHM1Nmg5b3RTQ2FaWTcwQ3dTcElZ?=
 =?utf-8?B?dmJvU0lkb2JsbjVmb1Vma21jL3M5WWUwRmVQL09RYkZyZk1ZZFVuc2JFNVVv?=
 =?utf-8?B?RkpuenU3Qzh6SGd1ait3dkMvaGdSTGlpbWpLZ0wzeHpSdmE4emg5akxzcm55?=
 =?utf-8?B?dTRyMFpzZkEzb3VyRnpoOEJ1VEg3QVkydEFTVFBVREtVbVBSZ1A3ZzgwcDBQ?=
 =?utf-8?B?aHYwOWdEN3RENGx2b1E2Tk5vM2o4ajJZTHdaZG1VZDIwbVY5ZXZrQlpSZHJq?=
 =?utf-8?B?d281eFgzRjRzbnE5U0xNOE5EZWE2UWp0dnhrQTRFa21jZTBKYk9xczNxTVJr?=
 =?utf-8?B?dlVJc2NTMURtTUs1NmZNQkVBalVTTGM2enp0TkNST0I5MmZaN2hUTElOUW9q?=
 =?utf-8?B?cHgrak5PYkk5WWtTUm5ySEdKU2JBRUUzRitDZFVCY2EvK2RvdzliS0NJaVJy?=
 =?utf-8?B?N1IzSmIzaG1USC9WNXB0VnpOWkdGcnpOYTZDM1NzeGcwVlVnUVRLQk41QjVu?=
 =?utf-8?B?TkZwMTl5K3cyS05KKzBBdko1Unl4N2h3b1FqOE91OWRraDY5WmYwSHVSemNS?=
 =?utf-8?B?d1pnU3N0T2lKTkZJN01SSXlDRE5lMEdoeC94RGhXYTVvZ1RiUklVcE41WE5k?=
 =?utf-8?B?Y3gzR0dFa2pqb2FLbUNmS1ppTFVSVWtZbHVYa25kOUMxUVBFaUt4Qkg2NllO?=
 =?utf-8?B?ZkJxbDhWcVo2T1V1WFdOcDlORHZCQ0xCM205d1NDTGE0K3R1MXREUTFBY1ZU?=
 =?utf-8?B?eDM0NHd3RFFSWW9VemUvcDgzVTB2bUMyUzNUdk82bVhIcTc2eHh5N21XQUEy?=
 =?utf-8?B?QWRacmpyUlpMaC8zdnRiY1RwR1hZL3ZKR1NRWmlHcGdjblpVekIxdjFCVjRC?=
 =?utf-8?B?cXBacEx3b3A1bGdkNEV1eWxUOFRZMDA5dHZyZnpHbGxvOFdOV05GVU9DbHpX?=
 =?utf-8?B?cDJlMDhnZVF2NTNjaDYxamdlb0ZWeVR3TWhJZnY2dVlGQWJHSXoxYUtNQ0pz?=
 =?utf-8?B?MU5JMXJKV2hqVXBWVWlOYzFYcTU0cVBVK2tlK0o4akZtWEpWMFBNcEFrZEQy?=
 =?utf-8?B?ZnZSRlFMUWFmNkEyQVJWRzBOa0VpTDhWUlU5ZmI4US9NRWdnMk8zMisxaUJR?=
 =?utf-8?B?VEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	puJeii9l8qZDZlPeiztxFmbErgyHwLjH8lr+9NgzhaZCvR9MbWSw19P4DihYfSJG9pdJqMDLvKORvcEZFWnbQ8mNV1r32UjKFqz9sPZa2u71vgHcdHGJ4erQMsyD9rxOQllwiAdrPC9sERWz7jXYvunlFX29WUVna9OrKMER5mJ8EJ8cekWtWOSt7tK1SQQd4pIcAqOMdYQAd+s5IEQ5AZwA3UeVB9agv+4yjORVttBAL+LZIPT/zB4kaz9FfTLEZ8/ZbhjNK10r2n4MoW9Ll1wTYzINL+1F7JFvakkAHD8UW6mMnNVLtRxerIZ+BYKmpqoFSFTgbNaV92fdt6r/IlnzyEBWoUmAUv9vn+y2OzS89dSbSas4G3bUFaglrsuGcYiKhOHmgbibZGq3tn+6ctflvhXCaNjjzL61bOR2J2O0tN9XzOpdj2HVm9MK7HO1gn6cK9Gpo3c6IGcan0etdpLOwFo3HSazo62yE9J5tXzdX4rWNdYHsLRWZa2y1Ao0Z4t2e/8injuTXCLZ/iV8jDHC9g+w7/NDmFbcZw2v9SPZUDyQaL58ud8d6RaA29RMoLYFrI+hywmpdNGWklErbYwqlECZ0IhPNqZJDMww9gQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5edc358-a7be-4cca-12e0-08ddca7d70ec
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 06:43:47.6279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NIFIRTNwVeBaptbEN+VQEeSNiJWImna0LmzJ+L+eX+1/58k6FSbJVVE3jn4Syz24KA7Ad1HkZV3Dgr5cymj5NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_03,2025-07-23_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507240045
X-Authority-Analysis: v=2.4 cv=TfGWtQQh c=1 sm=1 tr=0 ts=6881d628 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=SsmVy_y-IffJH0FETpcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: owlsjKIxqNbMEW8KeMjyUijrNkN6e5cK
X-Proofpoint-ORIG-GUID: owlsjKIxqNbMEW8KeMjyUijrNkN6e5cK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI0MDA0NSBTYWx0ZWRfX0Smt4yBxYb75
 N3ftJaatvwqwfJV/e2BRCcqnJEEKOP1TSt2aksT4+VyCX3z1F0FR7pBz9fS0S+uMFwAB+OajzMp
 RHJs2v7gNbUVvXgE3a8H02nNsB5uh9YrIyeWPeo9jymnmg46yNdvKP+R/a7PeM+jVX+11y9RWk5
 IqRH+Op1a96GEEC/NnkksDyvhIG/nnOEwR6Z3xEgkV+N0PrbwErljV7h+PQRHv5nXKj2SIkbZYB
 A8OfFWb4vEnLWsAqICNDXlGpyjmbHIuuLwwa5YAtnXDNaUtxkRlVE3uvAL1u3Gk6KKNCdhNV9hX
 pW0x7jT87+GfSJmzli73rCjSkhWcvVhTOL+Lt7VmnspCis5oAFMyRrORLtJYL0PF+oeBaN7PAJW
 fVxaUNhsjBDOUZ3MBKXII7HXir/LbEfie02WgqYBmTwsD5rXLZJwkPONxgUCx0n2C8GaP5Jt

On 24/07/2025 01:02, Damien Le Moal wrote:
> Simplify the code of sas_ata_wait_eh(), removing the local variable ap
> for the pointer to the device ata_port structure. The test using
> dev_is_sata() is also removed as all call sites of this function check
> if the device is a SATA one before calling this function.
> 
> No functional changes.

You did lose the dev_is_sata() call.

> 
> Signed-off-by: Damien Le Moal<dlemoal@kernel.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>
