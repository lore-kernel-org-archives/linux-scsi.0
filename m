Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969616FE07
	for <linux-scsi@vger.kernel.org>; Tue,  7 May 2024 08:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715069022; cv=fail; b=XIrGf7t6922SQj0W/OV3WYK/11ohMDVMcQyJbYVA7QIIJdX/MRVN2y+MsZUspNaxPTf3Swe4LKBrjFcGjcwXksbL0BtEg8HVyzpmILKifx/hPAgqWpSPCtYjHNiQoWBWaf3wsZ4kmHFFJEtLMg5cfyoSUxtRBeVqsXyWKAGUEnM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715069022; c=relaxed/simple;
	bh=VRkbUccNBF3xSyhRxGKcjl2nClZsv0hlzzFz79M4uF4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=X8fi2xb/beXTrDzRgjPnxk+ZgF2DgVkTvfsVFsei3lto8LvjsHt0UksAXyGwW0vn1LT1WXNe+lrZnaWhFlS9+uMxQnhrgoYHN3Rwo7rCOv/ea20Hbb2o8JzIkyF/7ECPt9g7AylQ0eeXbcnxuDJk3jti8MLEi2J3k6VQM5kZm5Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iliZJ1oN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UE7n/EC2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iliZJ1oN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UE7n/EC2"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4477ijdt001297;
	Tue, 7 May 2024 08:03:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=VRkbUccNBF3xSyhRxGKcjl2nClZsv0hlzzFz79M4uF4=;
 b=iliZJ1oNm68jf5ulJrXAinfPaEJXRFplqAmvyTkCQ/ypN1oN6HfYwo9GOyqj5Mu18xLQ
 wJ+zWfbbe9Mzxz5O/wCTs9IqV/MtfguKBXCOufzpT5epiM0KQI5KbALZmt7AedLKl5HU
 moKREOr3J9T57SBTdWwt0scEV5Nw4UBOKspdGsObZoE9y/zpsG2ahShFjzJ4f1Pq7V//
 RLZV/QaBDv38mfPApE0qyu8LT4zQSCc8Eoe2R4vXOTQcv4sQUCNtCf/96dBMtY9tu5FC
 01OYI6KB/3396ggRt1L3Q/tOg39pf/+sBLZJIVdAy3UpmwjWinCCjB+vdLZJZ7iVneHI eA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwbm5mchf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 08:03:26 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44778M4M039457;
	Tue, 7 May 2024 08:03:26 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbf6nnat-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 08:03:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N9d4n4lna+Lo2jgfsZTG8r8kIhAn1A1jWB7lD93Ha1O7/mp13M3tCayS6MSVodvMC6Nh37oqJAkbp643P0QAw9n91xdTQmmmH4f3ZlaxA+pHj1aO85fUJqXl68Hds42VbbZotYPHw07YHbkAwJE0ubZZLPGs+UI+SJt1qt1VEAKKWy8VWKwZTocCKOV/vEFY+e6jWrJYiUgOpzx3azIz7tZtrlP/2zEYxv8BB0Y2c3cXT6A2ps+a032+HVDeEW1AF1dWj+m0AKzr96tsx8uRjPzZvgFHAxHs9w8ZnHql6ru0KbaaA1h+/EfiqF7+jPVG22Tw88Ox917qmcXpr/pfpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VRkbUccNBF3xSyhRxGKcjl2nClZsv0hlzzFz79M4uF4=;
 b=jCq3xgxIqsw1/hupZzPALDq8IeiRxg1Dxjvy7S15JyWj1v7cfloO8PODY6t4rjpYdvc2/rv4gXhMDxxLx6krR7rCzfT+jq858ENehuU8fyPoFKQSYUNJjn303oYFifYTg+UABSuu+6LGaqW4b4ATM6Y1tt1PCkRvF/wjgklfT3t9zdjav3a9mTT30V3PKMQX+l322lc4H8R0aQw4ASToR42plR33mZMDqQ4PO0k92GKEH+eNgADFC/PAdOg0OSc12hXznnyUZcdAd9kXptTj5DFOXusQhhKtEmGWHfjAHjo/QiUufU0QcmeSuUrvmlhj0uHVFrTAacaHwDTHROCWVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VRkbUccNBF3xSyhRxGKcjl2nClZsv0hlzzFz79M4uF4=;
 b=UE7n/EC2vE65tyTZHOxdZw2ymQ+hXvQGUwr+qk3hn+WGY+mXO9D+5rddPcf91lLB6AJs7uInV93z6uKxJ27y2aRZeYUAKHsTCGeriffXDmTVmcYHx4sDjCjy7mageoa0mPxu0G+T1ePmOugfLZeaZYIJp5lkrcg2Ly0nI3R4DjY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA1PR10MB6075.namprd10.prod.outlook.com (2603:10b6:208:3ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.43; Tue, 7 May
 2024 08:03:23 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 08:03:23 +0000
Message-ID: <c3c73427-30d5-42c9-ab87-42218650434c@oracle.com>
Date: Tue, 7 May 2024 09:03:17 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: Issue in sas_ex_discover_dev() for multiple level of SAS
 expanders in a domain
To: "Li, Eric (Honggang)" <Eric.H.Li@Dell.com>,
        Jason Yan <yanaijie@huawei.com>,
        "james.bottomley@hansenpartnership.com"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <SJ0PR19MB5415BBBE841D8272DB2C67D6C4102@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <09dd80bb-09f9-481f-a7a7-b9227b6f928f@oracle.com>
 <b1a5552c-689e-d220-88d3-56d24752be5b@huawei.com>
 <SJ0PR19MB5415831DB91059696672B163C4172@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <SJ0PR19MB54152CB3D611259510902505C41A2@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <c004da1f-b9fe-4641-9d0f-162eabde0101@oracle.com>
 <PH0PR19MB54115A3BDCD9319781FA652FC41F2@PH0PR19MB5411.namprd19.prod.outlook.com>
 <823ab904-33a3-4ed0-8794-cb36b9ad636b@oracle.com>
 <SJ0PR19MB5415F1D35AFB4039A426079CC41C2@SJ0PR19MB5415.namprd19.prod.outlook.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <SJ0PR19MB5415F1D35AFB4039A426079CC41C2@SJ0PR19MB5415.namprd19.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB8PR06CA0006.eurprd06.prod.outlook.com
 (2603:10a6:10:100::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA1PR10MB6075:EE_
X-MS-Office365-Filtering-Correlation-Id: 052a38c0-4c49-4b76-4246-08dc6e6c2ace
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?QnVvZ3VUc0hsNWtoT1pMWHZmOXRFTWhzT0JVRVlYeHV4ZDkvOVg2bVRObVYy?=
 =?utf-8?B?V0NhRmYydnNiYXdwRktSeldnL25IVVM1ZTFEc0ZCU05tUnpsR212cW1TY2FW?=
 =?utf-8?B?ZERmL2QyTmdJMHhJNUlMZ0NXamZFTS9mL214a1NXdnJmWmlIYlVOY3pPQ2Zv?=
 =?utf-8?B?UVkwc3c3WWJyNVk0TlJGcFlmL1k0NHNNKy9pKzdyQ2YxNEx5MnNKbHlrdGhJ?=
 =?utf-8?B?aDl2UE0wdmdPc2VTS1MzRE94TFlJbGl2aHBlbEpjSWVkcVR4c1czY1ViY0dv?=
 =?utf-8?B?MDZjcElZOWhUa0dIcnVEMlNwaEVGNko5MzFEMnMrZ2FIZWlzZWc0MXNuOVNG?=
 =?utf-8?B?cUprY3FWbUM2WmhncTA4Z3NLVm1vd0F6V0s0ZTVpTGQ1aVF3QThxcTRoaUp6?=
 =?utf-8?B?dkVkTWZ2NFMxd2FEekdnQnI0ZkpIU0Z5OU12R2wzUG15cms3QUgzcWdSaVZy?=
 =?utf-8?B?aTNZdWh4N05sdVpNWGFhZ3RDZ0dDUE9CZHc5WG9abFcxV2dSalpuSHRTdXZh?=
 =?utf-8?B?c010MFczbHRsbUhkeVZjbURBcGlMUGdrQlZRUE1ldFZTTW1VRlhpNkFzN1Zj?=
 =?utf-8?B?VE5xK1pBd1dabjFhVTduaHJMdzlsNnFiNmxZdld4Mm91OTMxSVJ1dUR6TDJH?=
 =?utf-8?B?M2lwWHA2WURDdHNaUU5zTGQwWTFyWU5XM1ErNnFCMlZOcFRUVVJ3bitLMk1B?=
 =?utf-8?B?MFlCaUFlSjlLc1A0OG1GUSt3NDFVbURWbHJTcFdPTFJ6QW15YWZJeUl4Njcw?=
 =?utf-8?B?aTJBc0o2Q2lTTkttTHYweUxPRm03V1ZwYWVsTGFMR25iTm95ZGdBTzV5Snc3?=
 =?utf-8?B?S3NlSWtJbVRFcGo3ZUZ3d1U3QWRpWXRxU1BrSmM3VmIyNkxmQTZMc21NNDFX?=
 =?utf-8?B?R01KS3pSRTFpMUJ0b1hpMHVGMXZKWnU0MklQWlA2SnJUVUFPVjNQa1Azcnc2?=
 =?utf-8?B?Ly9tWGswMVB6cGt3NE9Beng5YXlVMUFQeHZqVmdDWCtzajduYnVTQmZGdTZQ?=
 =?utf-8?B?TGJPbHBrbVZvOUpKK3Q3UkROQ3E2bm1GVTFDRVpmUkFMQ3FnTW4wSkU0Ukky?=
 =?utf-8?B?bUlUS1FoaWU3WDEzSFpYWU1DZUJiaEFHajEyMXNaKzBQMERzNjY2SUFGWlZh?=
 =?utf-8?B?ZHR4U3VVUkthRVUrTTRBSE1NdDdTZE9SMUcyWlo0TjBsMmNmYWE0U0trNUdl?=
 =?utf-8?B?TGxxOVZRWXdmYjF4aUFxMld4Z3JZZFl1NUJ1aWx4bE1rUmEvc21PS2VFWjlX?=
 =?utf-8?B?M1RyMDBTU2piWFdVOWtKVG41SktadTcyVU84UzRybzNiYlM5MUkwS0cxbDZL?=
 =?utf-8?B?V0d2S2JBblBoQjhzOHJ1VjNlYWQ5dGhGbTZSa2RUeTlmQ0xyb2lBZm5kUVpu?=
 =?utf-8?B?R2JZM3ZRcmNqeXlyZk5yOXhBYWdWUkNSTjBUbmZoUjFQWjBaSjBiSDg5Q3Vs?=
 =?utf-8?B?TnhjOVQ5UDNoVlRHS3J1cUp4bEVXRVYrYTJ1ZmdjckhtZkRud0RGZlZaakdE?=
 =?utf-8?B?Skk0clJCYStKL0tNcHNaTnYzdjBLWGtTVVhwdEM2eDg2SDlEZmVwejd6bHhX?=
 =?utf-8?B?Rmw0KzFjN29sTHp3UDE0L1cvQ0w1SGE1dnIrL2ZPQmlmSEgzNkZ5bzB5Q2pI?=
 =?utf-8?B?b0Z5VHdLS3dRaWhyNDJSZkd0ZldQbDJKTHV4MEc2MFhxQUEraFE1V2tyTGNy?=
 =?utf-8?B?YlJic2ZNK09qbE5IcndKZHprcVE2eE80Tk0rRVVXZWFqMHBIOEdxMHN3PT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZlMrN2lGWjk2L3p4Rm0vOVg5d01RWmhqeTF1QnhzSFdxS3lqbGp1RFR4U2Z2?=
 =?utf-8?B?USt4N3MrTCtNekVYQStoNUVZRWx4dHlXVW0yTFpTeGJPQVhCWTlUaGk1KzJR?=
 =?utf-8?B?bTc0NmdYK0xGZGRKdWR2NmF6RjU0VDRubi9ZbzBoSkg0THVDZGEvQUxBZ3ha?=
 =?utf-8?B?dWtyWEFVcjdPbzVGaFlRRDZac0NyR09HWmpKYTJuYU1sV1NJa3pOSGVXQ010?=
 =?utf-8?B?T1BjZDhESUlGVWdOUTBZU2dIQUMwUDkwbnJWWDRCejZESFZoOGFnSndQeHJZ?=
 =?utf-8?B?cllFWmZJb3lORk84L2tuMWRNaVpVZm9IajErbnc1Z3g4YjdydGZxaS8wVWhr?=
 =?utf-8?B?Yjd5cHFDVUhoYlNES216TE5EVm1oeEpydnFyV3ZXeWQ1cFhxQXRWQmtoTzNJ?=
 =?utf-8?B?WUc5SE9lRkFzSkNXOHBzSTBEcitOU1RvQndoa1FXZWZ2SXN6TjBlc0JUQ3Jl?=
 =?utf-8?B?T2s4aDNLVmlkNHRsUzNORkxRZzMxL2FqTm1MMjcvam82aHh2SUJoMThiSVF2?=
 =?utf-8?B?L0JWdjlQQ1dzbVZGbllzM01xUWNmWUdGeSs5ajAvNWJBUnNQQklpVWgwRVhx?=
 =?utf-8?B?eVlhSEhxUzExZTI4a3lwR1B0aE14djhlOWMrUHUvRnJac01IRDJ6SWYwNEZh?=
 =?utf-8?B?eDgyWUtzd2Q3MTBnRFUraGkyMXI0OFZ0bUYzL1grUmt1ZHVGRUZWeTJlS1Zw?=
 =?utf-8?B?bVl2V1ZtMjBaaW4rYkErZEIyVyt3RCtBUVk5bFkxbHBSZEpYNlpPeVJBOU44?=
 =?utf-8?B?VzhNRjRIOUd0VFQrSTExNGxwUjlOYnRUZlo4NS9lRE1NeGk2TkxKcTlDYlVX?=
 =?utf-8?B?T3A3dHF0dlNONjhLdURrUFh4RVUwa1ZEMW52SVpKeXRTT1QzVERVS3A1cnlY?=
 =?utf-8?B?c1V1QXFCb0F6YXZQOHdmUG1xRTYwR3VxNDJHNDJQdHhuTFJ5NFRLQkFYaUti?=
 =?utf-8?B?MVFsVzI1bkNYZ1NoMUFlWUlSK2RiWGRmU0hOdzIyL09PUndOWUw3NzdvdkVP?=
 =?utf-8?B?RXNkWERReTNOKzN5TXR0c3J5a0tqTVNXL3FoRXljaTdaMGFXOFlURURzSy9N?=
 =?utf-8?B?bEN6UGplU1FrWVRsR0gwc0Jub1pjQ1FGaWVHUjFMeDlGQzlkZzkxYjJNL1pi?=
 =?utf-8?B?SG9mc1pHa3BCeXJGdy90VEJvWVhQbitwNk1ELzk1OWVESUJDQUppRjEwVVY2?=
 =?utf-8?B?aml1NFYrVG9GODgweVZiU29sN2R6Y011UXBqUVZnR3lXVlkrZHhuVTVNWVRH?=
 =?utf-8?B?T21JTlJzQlZoc24vMFVrd1ZrL0s2MEhwQ1dyL0QvUktVSytBN0FnTmg5L0tB?=
 =?utf-8?B?R1o0NFFsUE8vQkMzbTRyV3BQSXlvZXk2c1lVN1ZOUHZNTmVWK1ZGYUU4b2N5?=
 =?utf-8?B?cG9HSUJ0ZXREM0crYlNMWjJuODFic0o0bjBJVWJDaXM5NzlsS1FnWDlUYjBV?=
 =?utf-8?B?OENvNjM3Y2k2NUJqWE5WUUpBMGFPLzltNHJTREtPNjdmdzZFcG1jd2Q4eCsw?=
 =?utf-8?B?WnF2MjNCY2IwQmE4T2lHQ3hrL0J5RjZHSVY5RkpDMmw5cUpaUy9RbUhaTlRN?=
 =?utf-8?B?L1RORVZIMkJlQmFzMllhSlg1U2FoY25qaDlGdlJJNi9wVjZxdVI3MXZNMWZl?=
 =?utf-8?B?bWJBZEhkandDSDhhWWJiS3VVSThjUDJ5dXJHVlNkd3l6SE04ZmZXTzl0V2hq?=
 =?utf-8?B?MDhxa0U3WnhCR1lwZm9kckhNL2ZtRmk2V1plTldvZjBDVVc2VFBkb0VZWjdp?=
 =?utf-8?B?OEhsRFJ1RFZvVHh4Sit4OFFvNE9OTEh2aGpwNWJVSjhDTEl4L0c2SVh2UWs2?=
 =?utf-8?B?SGl2WEk1SUxaZVJOenA0RWVVVVgvNGx4aHZHODFGM1F1N2tKZDhlYitEdHFa?=
 =?utf-8?B?T3hxQTlSVGVNYnNzakVNbkFpZXBkNDNuaEQ5NzA4OGpPa1hVZGFJK3k4TjFI?=
 =?utf-8?B?bHY0b3RhV1NJOVRsQjVhUzdidlRZU2lFcTVUTHJMWHBncGtmazVwbVNWVktY?=
 =?utf-8?B?SThxMW5PQWYxQncyQU85bzB2K0VJai9oZE1pNkdnR2p6QXp2a2tzdVZsSzd3?=
 =?utf-8?B?aytGaTdKeThwOEV6VWUxRjU0Uk5GcWZ0Uk1lcm9WclE1cEFPdkx0QTVKT20y?=
 =?utf-8?B?UUllS1lJMUk4SUNjU2dWMlBTTnUwdkYwSVVmZjNha0RvT2tJQjY4SVFJelFQ?=
 =?utf-8?B?WUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	wqOJu8N5PoEZ+bio//ObyTrsMsZf1PAmB+JNMSifVecSVjwjokvZ3XWBHw3tVmjS+4xcKrEiVJZIZYmUY5Rs4py8TeCNoe0QNXSHYeLlzkcBEjK8WKmEGXNzClzv4WFZWAt+NUcnkfWcCtDK0CRScTQH3Kep2eek9frE7q6fp4gt8Z0yxyzl/bjngh+Ru9krSJQnT7eHuojbxXgVGx6kTZmjMCZO7lcxgjOeBRvn7chWz6fet3exowsYFTtWDO50eRu9z2UPkNP/8Sb/TKnB8tjQhuDJmenfItOSyYLXPf0YFa1o234qpqWEdiD1vdRBq0+upVsYhj8/J7IPVoWh+jQhEPz90Ri4gaVAlZ8Lg5u2dv3/tjohwf1gLxX31t6mgatNMxOcSi/m7fSc2W8y5rGI1PbVDbPqhRJXylAkiHvbervS8pXubj5JEn+xLQQgzNr//QjowQ3DANHLZS4DYe9CO5Ll2AM7taeOgNTLXUN/55tx7sKI30aobNRRwwitv5VltApt58ZvhKtdFt/fDZVJyKanmULaOWfnoBf4NqTpav+SMJNmZgsN6GvfOnllXk3sECsrisMVGPy3P9GvDzeNLwK3xAqWkVkonw46Kgk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 052a38c0-4c49-4b76-4246-08dc6e6c2ace
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2024 08:03:23.7615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8wOfOJSfjsi05vYKLaZw6tCxLho0NbBVQfDguKQaM5w0nktafhgDnPagVBmzNCwCK94WK4sQQ24vEksco5Zwvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6075
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-07_02,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070054
X-Proofpoint-GUID: Mkabj6YlsWICEYwzF6wHR4OBp4pAluch
X-Proofpoint-ORIG-GUID: Mkabj6YlsWICEYwzF6wHR4OBp4pAluch

On 06/05/2024 02:49, Li, Eric (Honggang) wrote:
> Internal Use - Confidential

This was added again. Please resend without this.

