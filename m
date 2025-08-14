Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF95F2E7F24
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 08:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755160879; cv=fail; b=T9OLkOA/xVwABI1d22X8tck+CRqXY7oBh8rhE4ux6nQfjzk5vGR0O+6AY4lWy95nwUMHIvnH4KqCOue+4evdUuijtBk8+k6Wfe1EaKbhFaNgtTtRYVHlwUQkKIbodptPbv+oElnOwqPUqZbalwSwsdJOnrn0XSQ1uFL5k2upqcs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755160879; c=relaxed/simple;
	bh=1a9EIh1vLoP/bf13VX7brHKjyPOYZdfYbV0L6lA1xNA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=D2pjG4axLWWK9qHh9pRFRfpBqZ9naueP/sacAcOz82chZ4iTOA6APZCuBNPn41sMAVgGp8n9dB6tlT1W90H+uf1LnHW4fIwRqCQNiRLGVl7nAjpK8OQOJu+gOojVm5jBX76cENUXK5JreSbCJMx+xMpoxwUKkbzkTMrtaAjKehg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=k7xZM9n1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=W0Z0gUnb; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k7xZM9n1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="W0Z0gUnb"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57E7u994031529;
	Thu, 14 Aug 2025 08:41:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=P2sxxo1hvfpILPeJQPqyWL5x9mlCBCO6rNsdzBmVKcg=; b=
	k7xZM9n1Ty0AXoO3eOarBxqM+/IbUg1DHZlUsZiYdqUeIUyMEydCO7PtmZ56znUt
	oYEMqVHkdznrqCZNtXYX2NSGvkPQbvNHvKtUJVsvboMHK0WHT1IIy/towAbcUMKY
	51oiOyU64mG7BGJY4eZXNtKUTYKsz4/J0E4+wZ5lZQJU/vj16/gwx5cyaqtmVol+
	biGdINC3jkJmNga9n/R/8K70Z6SL8iYW/nfpOGyRV7FK1fPbR/VMWL2U5quvCUMa
	HvNkHQFiBjr7Lp1+6IXP5tWJig0EXYlsAKzz078kCLskA4xIKjanspF5zQRdXkKP
	I24TZpCbwZhMYBUYrABAXg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dvx4he01-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Aug 2025 08:41:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57E76SXL032734;
	Thu, 14 Aug 2025 08:40:59 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2041.outbound.protection.outlook.com [40.107.237.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvscft04-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Aug 2025 08:40:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RVmOtcU52yrmz+qbCO3SYt7Sqf+yceGgBC6yu9a6kh937ksdOmIumj4WZVeFLnsXjMcQKPMRu8kaDLKcHDPzd17s3/UZEe7dnLYlQGXC8tp7YQCUIWm6BQdDbXQccVLxzE7CTR/AtsfoCWCTgeao+Q+p2NN0faVnykxecBIZwD1ZjhjVjbgqzSng9BLS8f/gUDDSEis5S2K+xXkGc+DGTXeQXMl3hRJWIa+Uuh4t4WwJdjdUD7emYd+hJ89o3vlEWd5byTZUdPLJMZBFy11u19AkSTWwY7sxGkeFzdn1YUT83TjFsv9wExlr0SfKntzUCemKEN+pUOS1cNsQIcnK6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P2sxxo1hvfpILPeJQPqyWL5x9mlCBCO6rNsdzBmVKcg=;
 b=qYkcnQX3X4lt51Yu++3VizkjFj++lvOmwhRLwYLqiB9lVVsOL9+WDB2hBb3lHk4Iyz/a94bngQlQ/5LC3igMqWiu8LEBy/lmF8xdsB5i8TaGdHxFsioFvNeXBVbJrihtFTeWOAmL+LRRBP6qIL0fomVLUIwQg707NRQyYJ38WUZCs5+T63b9RiC5XXw0TIrfIMcAIi0GKeQ//K5L/r7N3p4/5DEAVcCr+ZgsgDIBU2dmBsjPctJ8z+JsIM+z9CefXsEHGhhbTuRrwVyUfuZhwT6g9IlDsZmqnKZDLCtAisdTI3/zjSBtUr6AlFF/rY+iF4bnn41BYjE20N5+kRlFIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P2sxxo1hvfpILPeJQPqyWL5x9mlCBCO6rNsdzBmVKcg=;
 b=W0Z0gUnbl52K+1gbjAkGUOPW9dmJgJoi6wtpSXTx2cYZtzUR34U7F38fbwG6RD+H+dOZ33Ls1lvHCBHclBSShcaDlmJCfvWYlfLmOYFZf92tgtugwciWLdzf4R/b7xohnZ/rqNQyerRA78D5KtCFsfzYrzPAZH//akQzppQkiHc=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SA2PR10MB4508.namprd10.prod.outlook.com (2603:10b6:806:11d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Thu, 14 Aug
 2025 08:40:56 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 08:40:56 +0000
Message-ID: <ff0705fe-0bac-408e-a073-a833525dabf8@oracle.com>
Date: Thu, 14 Aug 2025 09:40:53 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/30] Optimize the hot path in the UFS driver
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, hch@lst.de, hare@suse.com
References: <20250811173634.514041-1-bvanassche@acm.org>
 <d5cd0109-915f-4fe7-b6c2-34681b4b1763@oracle.com>
 <d4151040-ab1a-4b3c-b5f9-577e907b43fc@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <d4151040-ab1a-4b3c-b5f9-577e907b43fc@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0182.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::7) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SA2PR10MB4508:EE_
X-MS-Office365-Filtering-Correlation-Id: 47b65742-e5c1-4713-927a-08dddb0e4940
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a2dzRDdrb3gzQkVhclVXcC9Sa1NFaVVNKzBxbW5VVmVtWXlNS3Q3Y044dTBI?=
 =?utf-8?B?YmlNSTduODVtaG4zM3VTdWNLdFBXbGZ0bWVJTldGMUlLNGF5cE1PR3ZISWVx?=
 =?utf-8?B?dDc3TDBpTGZDRWtNNmZxYm1SbzhyL2lWSHZPL1ZpdFhYVkE0YkRHb3pnNG5P?=
 =?utf-8?B?Q3dlekxHNnhUalEwUkN0UU91QTlCWWl0S3NESy9OSDl0eCtPZWppVnZDcC9s?=
 =?utf-8?B?T1VRRzA1NW5WczNZTzFwSDNaWkNlRzZrU1J4dk1peWI2VXMzY3FzcnBhVTNw?=
 =?utf-8?B?Z014YjkrTFNIanNReXIyVWtrQ0k0NE5vYTB0QUp0VHUrc3RIcHEzY3FEODdP?=
 =?utf-8?B?dmZGa1o1bHJhdW9QTWtIYU55U0F6Z1hxOE9oMlB4ZGpBYjEvSndSUlVXcWZh?=
 =?utf-8?B?WU1LMmJzMVpEcGp5c1RIYWlLNHlFZTkzQVREM01CUS8zNEF6eTJzUlR5L3di?=
 =?utf-8?B?TUhGOE1tYUZMcnhycHZ6K0Nqa2pkQVBLYzkxekhHYWs3MUZoSXNrM0xNQmV2?=
 =?utf-8?B?VjR4Q29BY0NzbngrdVh2QkpmNTc0YXpIc1ZWdGZOejZvRU1ETnFRek5XenFx?=
 =?utf-8?B?U201djdiRmNOQnRuOUxuRG5jRmJseWhpQlN3VUNQRWswNXVwakpneFgxZ0NN?=
 =?utf-8?B?M1MxTzFTZUVJSitvSkJXWlFhMkxhNjdJSFowenZ2Mm83TWJYRERBdEo4THYz?=
 =?utf-8?B?cGE3bk94Q09Ka0sweVJXVDNaT3k5aUZrcHRRcUZLMUczbjRmNjBTVlhZVURs?=
 =?utf-8?B?MTMxOGl1a3BpazJNdlNYRWxFNDZITktyRXN4TnlqL2ZGTFljWTRFYkZtYk5r?=
 =?utf-8?B?VlgrL2NBdWZLcEl0OTgyYnZicGJTSzFqZ0V2UEpEWnZEQzlqbzMrV05tVHFj?=
 =?utf-8?B?K21NSlVOYkdkbEtaQzhFR2ZKWWFQVndUcXRENTdRT1pPS2tCQlFpTTZMU2tq?=
 =?utf-8?B?emFjOExNZWZMb2U5QXBHdnNGWWNQNUVma205KzY4Q1RDYVZZVmhudlRDTHpn?=
 =?utf-8?B?MjhGdm5EeVpmQUpoTkpSZ0MwSW1GSWZzL3k5Rko3OC9UeW9CZTJXL3pXZ1B1?=
 =?utf-8?B?V1FMTVRScVZNZXJPVFUyWFExamlxM0syb0hkYUU5SkYrZVEwaC9aUzhQUzAw?=
 =?utf-8?B?OTlFS2JnS0tXNmtoSWhwc0VuOVY3ZG9Vc01EUTdrVlk1aU8xRWF0a2NSL3JM?=
 =?utf-8?B?eENLTGFmdDcvSXJiREJucEpJcDVmVEordlV4WWhrSVVvVWs5bEw5UHFNRVl2?=
 =?utf-8?B?NHBsOEtoSkFVVStOVTFtVXo4cXBDZHR0TzZyaEtOK2R1RGk4S3lmbTJFZytM?=
 =?utf-8?B?L3dXaDJrbHM1TVRMR1VYc1BHSjd0Uy80ZEtQeE0rbGZSUnRnZU5oeSswa0d2?=
 =?utf-8?B?a0RQM0VxVmNtMkpjQlM1bUo2eG5wMXFWcGs2TGJDdmYyUmFINlNoNG5zRmpZ?=
 =?utf-8?B?T0FkYnl4amxFSXhRS01xcFpyMDlTTkM1aXhwcE1weldUMURobkZ4eXQydUQx?=
 =?utf-8?B?WU5UY2xBL3UvRytpZForWUZ5VDVmak9tcm8zckVRRDRrekZSWG5VMEZpaUFt?=
 =?utf-8?B?c1MwaWxoMkZCWEljMytoM3pNc29mWURocXMzY05jMzJZaWlGREJ3cjR3Y2F6?=
 =?utf-8?B?S2xFZXdtZ2VDSHMweEVnNVMxUEFBSjFnUy9UK1RaeE9vaEUvWTdKUWFBWllD?=
 =?utf-8?B?emNiZDhjSkVpaWU4Y3VzR09sNW0wdEpoR05vck5CRDVZeStEak5aMC96T2d6?=
 =?utf-8?B?Y1RwMEdJaitkUi9ZYnlvSzhDKzhYUHpYUXY5NVgxUmVEYzJNSWpDMVljbkNF?=
 =?utf-8?B?b21JUWt0YXZJZEp4YUZqelJ4eXpNTnhKTVhLMGkxUDI5NlcySzlmQmtTWHNO?=
 =?utf-8?B?d0pwNXRGMEx1QW5hR0pXSDRkVnFubS8yb0NubWphMHBvR2JyRE1ES0ZZdTJh?=
 =?utf-8?Q?YZS+WWRsWwaecG4XUvYE5m5d5E0A/Q1K?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UXhUWThuOGNuR2FFUHhRUXBRK2RFbTJRQ09XYXo0M0l4NTlvQjY0MDM4YmxI?=
 =?utf-8?B?amJIY2tmUFNGNnpXZnIzR3FRaENiOVlZdXJYT2Q0TDZGb0JBOER0VEpHb2ph?=
 =?utf-8?B?b1JWMDdOYUFzeWtDbzQvanRsTkVGZ1RKTDZDdHNXZmNUOWNKZ3NNdE4zaXpS?=
 =?utf-8?B?amVJWGZKZHM4dFF5L05zcm1tL2FzMnRnaHZSYzBpenpsaEJPczgzSXUwaGlT?=
 =?utf-8?B?eW5pTGtNS21BdTlKOGpIY2R3UENIaUN6ZnlZSjQ2UzNoSjhTY0ZHTU5SbzZ4?=
 =?utf-8?B?TXdsMzZHaTViT04zZlFkMkloVytRTUVtR3h6OTlWRnRpZ2l4RFErT0NiOHE4?=
 =?utf-8?B?WU53ZGx4dDhDZHlyTU1tbU5VREJQV1RQQlk3ald1R2diYWYvQlBsVmY5cmpq?=
 =?utf-8?B?YUhxZ2xzU0hpSk1lcXhDVG5NVmFMbVBmSnVUYWJNR1g1cE8va3Zhb1VibGoy?=
 =?utf-8?B?OVVsZWxMejB1RDhURzVWb3JwdlVYRlBxNWNaNzhEU0lYTzZ1ZnY1WEtwbGdJ?=
 =?utf-8?B?UEpDVGJMcEluenprWWNRNHltdVFxRGswcFM5NTVQNVRlYkJrdlZpTXZ5TjVI?=
 =?utf-8?B?dEpRTUpMTmpKUHlSR0lxSEtKOENSZlB0VXNnd09MRVc5bzRwdWorc0RZTUEy?=
 =?utf-8?B?UTZLK1VPQ0o5UEZXOTl5WE9HeFVteUVXRUdUeFJvMEFZaHVtVUtWd1h0WDVl?=
 =?utf-8?B?OFlmcENBRmVjb2VTQXhRWVVnejlsTnFFSzdOVFl1Ry9MTkVSOGRhRGwxV0tM?=
 =?utf-8?B?a3IrRmY4ZEUxV2FEbkFXRkNxcnZqM2M0OFp2MjB6WHkxTnllY1lhTHhuclR1?=
 =?utf-8?B?UkxUaGVNT1Z6UHVNWFYwZkN2VHgwQ2o1NGVLVkZUSUFQSm1NSHFjNTAxVVhk?=
 =?utf-8?B?eGtzKzVjbHAyZzRWekRvcFlOSjhDQkUwNHF5QWdJTHdlMkxvVkFRQWI2VkE3?=
 =?utf-8?B?SEl3SldSQTZOdDNYQTBXeWFNSEhyRVB1OHpqV2I3TkZOYkxJQis2U3pUVXNv?=
 =?utf-8?B?L1FzNFZ2TEJsRjRzRjhaNllUYzFqWDdNWVFUZTlFNlVGS2tKaHgxY09uTjRu?=
 =?utf-8?B?b3NMNUVrZ0p0QlRnakJtNjh5V2lKMW5RUzZ0Vm9zUmZxMXRMaWNIejNvNFhk?=
 =?utf-8?B?WTBaMHQxQ3BZQlJyVUhTOVBxZGtaNEF0dW13K0Y0azI4Z0FDWTl6TFhsK0k4?=
 =?utf-8?B?a0E4ei9KTmcvbzNENEFEdHhlcitDNW90eC9FRmd3cVRTcW1Xcm91QllkVW1s?=
 =?utf-8?B?UllvbGpnakRwOXVQWEVaUmpwbHBVTmcwcDZkTENTNWRONmZ2aHlManRKbE52?=
 =?utf-8?B?N1ZlMG42L0ZCbmw4bnl2YVQrKzAya3h6WkdTZG84RGtBdFVIWDA3cGZQK2V3?=
 =?utf-8?B?QlB0TGZQM2hJVFNlRDk5ZlB0Q3hFLzZhdGFoRFNaeWpiSEx2K256ZTBnOUZK?=
 =?utf-8?B?Mm5VaHN6VXFRSGhWRUNTQU9YZUxUeUl5d0FxL1RJUGdHa3hmWldkbU95TXRu?=
 =?utf-8?B?UjYvUnVMblNqYWRZV3F2emRPemJRQlRVSjJWazhFZldNUGNJZlRmdVJvb2pH?=
 =?utf-8?B?N2VWNGl2bVNSM016NEVtOHRTOGpKYVA4UldPYWx6MUc1QXZnakFtOE94cXIv?=
 =?utf-8?B?d284eXBVc0pPaXNxMXFQUXBwSzZMeHc5T0JlR3hPU00vZmRiQVNHSUR2MERw?=
 =?utf-8?B?WkpySVBQRGJLVWliWk5BY1lVRXFrcHpJa1BSRHBwdTlVOGQwcCtCL1lvZWJH?=
 =?utf-8?B?NlhSdE5CaVd3OUxPRlFqUERQOGtBMHVIUjV0eWNWMStwVlRPQm1sWGRQd2Ux?=
 =?utf-8?B?QVRya1g1Sm8xQ1dXSHBGQjAwa1VkWkltU2VWWEVDZTZWUlBXbldEVktjSnRo?=
 =?utf-8?B?TEdhN2oxckdOQThnNVhYZ3Q0QXBlSm5XTFliRnV4QlYyZHMvbTAzRjltcVdV?=
 =?utf-8?B?a0NpVzZIMFBpN2hNRjBaVndlOWpwNEl3ektPQ2oyVXc5WlFZQ3p3bkxqLzhv?=
 =?utf-8?B?Skh0azVrOFE2bDZnRTY1M0h2emZVYnZMUDNxUG90SXo2TkdoMVdOeGk2UkRp?=
 =?utf-8?B?SFM3TFRCM2MzOEk0RGQyOXVXdXkwek96d3krSEYzYWZTTFdQMnBCamNnU243?=
 =?utf-8?B?ZW5LdUw2dzNwVEMwbG9EbndlSGlQekM1VGRDZ2FjVzlFTDNhRllYTGNqZ0hH?=
 =?utf-8?B?K1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vT6b5CagsLZxe0YEIygh/TbZ6DVzjaS5vvwOO2auQrFKlNETr573AcFCrBt9k+SdbAjprcte0YIJ42JSxxFhRBJ7fEfjOXkI7CwdcaazlgZtTeXi+ldR/fTXd1puhk+31YwK2mIPJ6jNn0en77MQ3vOujer6ojA1y+RWTxwmkGTQ483+58idjG6cc4ZtsgePvNQusoenNdKRiGvTCCMzGb3FJHq3zGUT77uv1H59jvFqmRcWTu7QTPzECIIlXTo9AQAMHANlMKyc9hrNqxr/BrQnaDXttVpfCURYy0IVZTGNhjryLb5PJJ/zzExkbnHXAXLYgwiWon2ANiR7E0HW8AtzyHVqfOW1C4Y2/Ad8gLZpIr1E7xmUupvKOiWL590BBT2ryJI57IiN6EnFIymuV81gheyzp6CnJZS+x1w2DDNLh4DRyqGoR5J6CuiqmYzX7S837J8YcbdMuhBg/zeQ78QeegXlvFw93cmQSjuOP/iC5nENY7E9pGxEqKWx/UPWFRTpBanT86+W1hwVAc4JPEGxt8DPRznit3EeQzNY/z5erj/BtHXZ8WokP1hvxc08UXZfo8w7sgxc87Q7PzfIQom+6mp5Bf0jS4km+2L14L8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47b65742-e5c1-4713-927a-08dddb0e4940
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 08:40:56.3181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5LJk/+VuqIhgdgkhn2/5geuNIBb3A0n2cwCcK5EpXYqj5NyRK6Gumrc3cf4aYC9r5we9S5Ti+TEMw/xONHTdTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4508
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_02,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508140070
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE0MDA3MSBTYWx0ZWRfXyVk3yHoI3VuF
 iVbbo2yXibi7Z400aShU1W9rfWnJBBWotdRbbrwOB3kK3wkUOQnfxe6k9Sgd1e6e0lAc4H9POJs
 6cXVMrkqV2uH86SJV45rlBak3SlGo3MOkV4OBlczNWn6etIbpRIZGEQ+C4X4Y1ZHkcaC1LS3Q1A
 AhyiZWHMN4i8KrgaQFqGamlXV9IFPnJ8cmvCiFhfSiwS+WCG+76i/UX2jNhVZg525gSp3GqXbr3
 PVCsKsLQ+r+gy15Xww609ZnVYnRaMIHOjXynonAFKJ3mpjGU5Gn7L9iRFXStf7Dw0QadxABB59U
 e6W+9DTO1X7jJ4kWvifDVF2Ty2sy7bZNuOM//HDzx/xH9th9jMTaicnq6NkQsQSc5xb4Sj3PCy+
 kIvZ8Yy7RZTpg75t7Acds99B7b6W14yD1FMl1yFxHPrasbt8o/UBo2v3tdUsQBhZODKp6k/6
X-Authority-Analysis: v=2.4 cv=eIsTjGp1 c=1 sm=1 tr=0 ts=689da11f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=NEAV23lmAAAA:8
 a=N54-gffFAAAA:8 a=_SxfYSafkh61Wdt_N8sA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: fYZ7dF_LOREJZQ49qhTppRk3WSdlHiwH
X-Proofpoint-ORIG-GUID: fYZ7dF_LOREJZQ49qhTppRk3WSdlHiwH

On 13/08/2025 16:06, Bart Van Assche wrote:

+

> On 8/13/25 2:49 AM, John Garry wrote:
>> what is the baseline for this series? It does not apply to v6.17-rc1 
>> or mkp-scsi 6.18 queue.
> 
> Hi John,
> 
> The baseline for this series is Martin's mkp-scsi/for-next branch with
> this patch series applied on top: "[PATCH 0/4] UFS driver bug fixes"
> (https://lore.kernel.org/linux-scsi/20250811154711.394297-1- 
> bvanassche@acm.org/).
> 
> See also https://github.com/bvanassche/linux/tree/ufs-lrbp-as-priv-data.
>

thanks

Some further initial points on this series:
- the driver still has the separate tmf tag set. Why cannot the tmf be 
allocated as a reserved command in the shost tagset?

- I like that you are using blk_execute_rq(), but why do we need the 
pseudo sdev (and not the ufs sdev)? The idea of the psuedo sdev was 
originally for sending reserved commands for the host.

- IIRC, I was advised to have a check in the scsi core dispatch command 
patch to check for a reserved command, and have a separate handler for 
that, i.e. don't use sht->queuecommand for reserved commands. I can try 
to find the exact discussion if you like.

Thanks,
John


