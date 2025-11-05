Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C50E311C15
	for <linux-scsi@vger.kernel.org>; Wed,  5 Nov 2025 11:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762343692; cv=fail; b=RhkR8LNaneN8XzCAGEIIaxH3FTUsjE5uxit7Pm3X+kjibpRA/eFH1J92p+xkxJWH9aHAby43xJQo71W5DDdBRm5ZMQUqWuLyQNY8BoHit1Q0VBvXCEZFf+uIDyw2ZtHgu6Ufiz2v2Rj+jrzyjK/gnX2TQHJfv3j0T0ZW9Ung6hU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762343692; c=relaxed/simple;
	bh=gl7v9Oeip5+54GccNNUZV70jknfpBR2Wye0rp8fW5uE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tBoC4Q1Ua5rP8mgaKW0hoE0eIg8r44Qb1glp4Tpji+s8/aI6k7rCTxtWQdj9aIgd7RgX3oxKz94zpl8d/o299kcyoHq0AgHYRnwkMAoFQrKj78wRcLSxEef1y2LrOktq6P/Mq23TU3bMj+uEO+yP0ZIPXtiBIkM9DeBSBc1s5cc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=F3KNcSrZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KixLjFkZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F3KNcSrZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KixLjFkZ"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A5BnLLA024717;
	Wed, 5 Nov 2025 11:54:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0cnsT15sX2ciSXGfbVAGOkJXofOdL4lie/3tq6t8nYU=; b=
	F3KNcSrZk13ZJzyb5tHR7sgOqI+m21GEKW/3ZnTpIxqWFT2qmvrZGJr7ir4nGWI1
	89jT0s/yCFdsihI1QvZZ+n0hGjJCtrJ3YJBdxNmdzixJ5IegUntXjSmbSkHIu5Tb
	90+2B79wieap9GvtF+Mb0mdj6oBnwFsBngV3d16eBmKEvBTwmILWLDlOVpdYCoOr
	QeVRlQORbu9ZWUjNzJ2zYIxGSi+COTW+7qvpbTgGPo5ZVUYXeYjbAb1w5fsrIzE6
	2ZcWVNpJfMQSKl/n0m+ZXv//SkAdp/mJpaz0TOwiiD+hDk4X/2hmeBylzyX9HE0T
	S/En6dApFjSFLSwiybMyAg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a861x8054-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 11:54:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A5B3nHW007224;
	Wed, 5 Nov 2025 11:54:37 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010039.outbound.protection.outlook.com [52.101.201.39])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nampn6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 11:54:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rAPAC1S30fPB5RPLIQvg4sbRg1+pUZHJ+Z+JNDExO+StZJtaYU/X9eJMNdndK9fdharLvUujSf6cwnJn9xQwpZaJQYefJs/A5xDulMxCgsggKkY1v1CHNVKzr2sCffKq+5E7TpojoivHGaQolx54XUy5kPys4fTeFiUzoGSRe6acrwrW5okBzaq72xar950IrZfr761xcjiuB1cyFUml6xMir4UVijPcMDyxCuxJ6Wopmozy4bD/xP5zjPSGe0NAPQY1MThqPtfdMPsVqfiAKj/Qfhk7Zo2XQvob0/Y+d96y6HacHh/DYXnDGJpckUa0a2lzf5fGyElw+4AorRD7BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0cnsT15sX2ciSXGfbVAGOkJXofOdL4lie/3tq6t8nYU=;
 b=O2iTH+WWoRmwvGE+ys3OnqUYl17iLDebbt0ImT7DoPIQuZNaVx9vs280sjzvdVDNqeXw0YNfD78ira6vTlPszcunwUX4BR4OT4OUpYxah04MonDQ1eboqMS5iWO2cqSGmoF4R2TPcYIuNjuTbPboUTLDL7ju9CjgoOz8I0T3uQSZs07JqYxHeOx8BuaEgDOTT3Qs3wN7ubiQMr1UYg3Rzz8NkMjADHpmzESqRfDW+5pWR6waUS9icefn0U8z9oFroMJfJ+Lz++fyElvupctTzejegg7DmBa6Klr4Ev8GPr0X1VFDtnm5+1VmutGeg0GtSiVLDr3yDu9OPTCHhCvWgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0cnsT15sX2ciSXGfbVAGOkJXofOdL4lie/3tq6t8nYU=;
 b=KixLjFkZa1V+h7t1MT9sSifplISToaJUGhDZrWYYAVE9UPAzXpKK8/7SUwXu/cul2lLrz+O1KI82UTvmALz5W1O3pwim5pEsKkRl1iCWsnjnUItAsZ5haJaQXe6XHaZh0jrl9jUxydo6IV20oZ3gSpmrYS3NO9s795O7k00YtgA=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH3PPF476853C3F.namprd10.prod.outlook.com (2603:10b6:518:1::79b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Wed, 5 Nov
 2025 11:54:35 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.006; Wed, 5 Nov 2025
 11:54:34 +0000
Message-ID: <93816c36-26ae-42e9-bd2e-bf7324279c1a@oracle.com>
Date: Wed, 5 Nov 2025 11:54:32 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: scsi_debug: make timeout faults by set delay to
 maximum value
To: JiangJianJun <jiangjianjun3@huawei.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc: bvanassche@acm.org, hewenliang4@huawei.com, yangyun50@huawei.com,
        wuyifeng10@huawei.com
References: <20250224115517.495899-5-john.g.garry@oracle.com>
 <20251105120118.1639685-1-jiangjianjun3@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251105120118.1639685-1-jiangjianjun3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0144.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c4::17) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH3PPF476853C3F:EE_
X-MS-Office365-Filtering-Correlation-Id: 47e4aad2-14a3-418b-37df-08de1c62168c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eHJ1K0V3UHVwUlVXWmpuS2haOGdYV2ZLaW0yeU50cGpuVXVCTmVyeUpjVjNB?=
 =?utf-8?B?SlBNMHUzcUFscW5iMnRuV3NINCtPQzArVXR0WFFjRitXQmJWVGs0eFVBMVAz?=
 =?utf-8?B?em1RL0x6YWJkb2cwVDdpdWhBUlpQQ0pZMnF0bXhVaVJ2SGlpWTUxTG12OExJ?=
 =?utf-8?B?VzArOEF1ZEl5eEVnU0xVdTNZWHNKeUFXdU5xWkhKWkZrQUpVS0ErZE1ab3hj?=
 =?utf-8?B?aE85Zzd6VE9WZTdZaHYzSmJ3VWtJejkxT0Q3OXNyRkdGVm5aMmF2OFpzT1dY?=
 =?utf-8?B?SmNHNzBLRWVlVnVWbTYybzZzTmI3Y04wZlJhV0liR1hOV3B6emFCY084QXpn?=
 =?utf-8?B?cTFSYjZIcHRScWVOL2h2bHc0bDBrL3J5NG5ZWDJMaDk1Wnpwcklwb3pzVjVv?=
 =?utf-8?B?YW9wb0hLcGJmNTIxSGN2bzZUcHd3ZDhDRTZmWVphejBycXpraFdjYmhMNWtP?=
 =?utf-8?B?d2c1UVhQWmd0a1cyS2J4RFJtbCt1WWE5VFQ3VUdqczZvVFRTZHRKTEF1MS9S?=
 =?utf-8?B?NHQ5a2Q5NU8xeWRNdlhuU2xKdDBlVHR3aXAwaGhvMVJOcmNoK09WVzJkeko3?=
 =?utf-8?B?dTdCNVRQd09ZRjRubXFzUnA2ckRaTHQ5bUJ5ZTFxbFZrc0RibllxWUdITG1n?=
 =?utf-8?B?RXNYZy90Z0o2WGlsTE9tOXBDbDVnUVdzYUNiWG9CendBNHNEWGtobWZxMEh1?=
 =?utf-8?B?NGFvVVRyelVubzNaS1p3YjFSY2tSR3N6WmMvaHg5RmV3ZU1ZcHR3ZnN6K0xx?=
 =?utf-8?B?TDlhR2YrUkNoVy94K09OUU1wRkJSeHhCVU1iNVNRdDVzV1p4aHk3ZVAvN1Bh?=
 =?utf-8?B?YVJNWkQrd3UwUEN4RVU3enVudlR3SkJXamF0Q0hWNzNWc1RGSko1VjROdmZI?=
 =?utf-8?B?OHhOZEllWm5NTzFQUGIyeDgrbnJIa2pTRDhPdFEyT1RrQ0pGZkJvOVIyKzZK?=
 =?utf-8?B?ODhTOG5pZ043dTg2Uy83SGNCdjlncE5OK2hQdkpUbUxNSHFmRjdrWCtpakFK?=
 =?utf-8?B?Mkp6T2g3bG9ZKzMyZjl2eVdNdlB1WUFDTGpudE85TmNKQ2pqSWswc3dtWWxN?=
 =?utf-8?B?MVFKQ3Y5OEJvaDZpWStmemx2TjdjNXJPR2xHUGRLUWxuTitOcDQ1c01kUFZl?=
 =?utf-8?B?VWY5eUZnUWErYmh1VTVQcG8wcXMyTzdja2ZYT2xFUzVFNE1reVhwZTRSU1hT?=
 =?utf-8?B?OG5wWkF5ZkluMVlUTGFTUzl4dTlFYWVKY056NzRsNjBKbVFpU3huZTZYVGx0?=
 =?utf-8?B?UGU2RjM0U1Rsb1hhRkkvalJTeU5Nb0VzWkpiK2o0Z3RlZUNaY0twaDk4RUd4?=
 =?utf-8?B?M0VHbmdabGRzbzVvMWRYVWVmRm1CUU1wa1pmY3JPZFBXaXlhRXRSV2tacWg1?=
 =?utf-8?B?QndLSWN0dm9MVFpFY2pLaGVFa016N2Y2aGxYdENFSkxyMVRyTk9NSkxzc0Ew?=
 =?utf-8?B?dEVveEtiZlN1aS9BZkprZ1lBRG5WWEIwamo2UWFVMC80RTdmSVdqWkZTcWxZ?=
 =?utf-8?B?MFhmZWVWSE12MnZOZmE1ZVFJTkhQdnFTSlhSdHpKTitNdUFtQ2FjaUNjTjMx?=
 =?utf-8?B?eWpkMmhxSkIrS1gvek5LV3pteURLVHRKWDBIc1BMdGVleC9QSFhNVUZvcTl6?=
 =?utf-8?B?a1Nkd2l6a2ZHTGRHMEdCVFp6MXhXSVU5T2o1cXdtbjM2b2VvY0RxWk4zVXgw?=
 =?utf-8?B?ZDNpdURhTWZmUllZUVpKZFM1N1dWN2xjUGpvRStvMENURGZyby9ZZkFUVWZ0?=
 =?utf-8?B?Zkk1THljQ296MkQ5MDZJeDd2ZlRCMklvV0Z4Q2pvOXZzMHE3NllMdUdQdDQ2?=
 =?utf-8?B?SnhHdHYzZXFpa0gzQVNQUU4vSGRHcVh4RkdRLzRlY0hIMDJYTTEwcFlhcVVV?=
 =?utf-8?B?dVpKSEMzNWM4bmFFSytqMXQydkZMKzRHNk9oR3JFK3BIb29pNHJ5VmJwajVa?=
 =?utf-8?Q?fEowUZMN2rYsM6sNvURqIC2VIGHhPmFc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OFRuUWVHR1pFVG11blZrcDJ0cWMxbTA5bFpvNW9TWTJSMmZHOXBHT2J3NWZP?=
 =?utf-8?B?M2xIbzZWemxKQkFLbmNYeUluQUJSZnY5VjliclRscjBSakl1ZmV3UE5wcWY1?=
 =?utf-8?B?ZnUvZERWUkd6N0JPMHQ4NmtNRmF6d2JQL2dlMjRERGNKMFN3VkZpcTkwUURG?=
 =?utf-8?B?WWxhNGZvZE5PWkd6c0hhK3N0bG4ydzZpKzVkSW9ZMnBoUWdIc0x3R3lSUHFM?=
 =?utf-8?B?cEwzQ2VvZWtlVWNSWE92Rmk2OTVyN1djSlNoOVNJVEozSXVOOXkrRWlpQUZW?=
 =?utf-8?B?ZFljVjYvajNiM1U3OTVOUjdJaFZncUR4c3ZOdDUvS2pmRk1lM2hpZDRSdFZi?=
 =?utf-8?B?QnRTRmNyaTJqUVE2N3VoUHhoYVF0SEo3d2hnajNYL3ZKSnlSdndLbDZ3SnJw?=
 =?utf-8?B?KzNiZHFWZDhWUktHN0NYQVUrQUhyd1ROdmhqSVg3dk50ZWJEWWEvbEU3QStm?=
 =?utf-8?B?R1FrUnl5WUQzR2ZMRncxZ0VuT3c5L0pNM2tRSjlhcUR1WEkrT1hxM0RXWXkw?=
 =?utf-8?B?clNBNStQc2wxd1lVUVczTWVia3FkL1JRV0J0eEZET0l5WHhUaHpnUStMb2x0?=
 =?utf-8?B?SVZVaVZBcUkxNnA4YkI0bERRU3pjZ1lJR2ZpV3IrYnIrWUNRM1oveTBUZ1Ex?=
 =?utf-8?B?K21OUm1GUjU0NlpBZC9xSm9IR2RXUTZsRjIvdVpKemlMOTZiaDVDR25pRW1p?=
 =?utf-8?B?bVZINElSY1oxWVp1ZHQ2aWhqZU5JNjVNdVU0UENlYktlQitkZUdDZzBBK3Vj?=
 =?utf-8?B?QkxxMUJITnRrNCtPTkFkR2h3QjhvQTFYRVRYZEVKMWl1d0g2UENQTEs2RGYy?=
 =?utf-8?B?SUJSMG1YdytucFVNT0wvSG5Fc0lMcE05U2hJdkNZcHRxanpQZlpsNEZ3bEFM?=
 =?utf-8?B?SWl5M3dJbTczbzViK0hjOEREN1kwdWQ3dUNqSkdYeGhCOTNjalpGTGZ5NGpN?=
 =?utf-8?B?Rk1hZDIveG42eGZGN2p5bDI2a0puQngvcTVGVURtdlA3OCtaekIrOU93V2FF?=
 =?utf-8?B?Y0pBWFhSUm5qL1prZ0xhWEhGNnFkd1g4RDVqclFRWjlzZWc0emtTMHMzVkU5?=
 =?utf-8?B?dGJ6dGo2Nkl6R2YzYkFoWDNqUVV0TWNqdVIrZk5jZlIvU05OQWdNQUZFZDRK?=
 =?utf-8?B?TVZ6OG5uK25GWGVrZjFJMU8xL21KMVd1WG92MXZaNmFSY1Z6VSt6U3Iwd0Fh?=
 =?utf-8?B?b2xZYWM0cnJ2b3JKZ0o5M3VnRHducFVZako3TmoyczZ4WVFLZTJwSmFVVnp5?=
 =?utf-8?B?UFhyN3Zidm1XdEpmUHRWSkhoSmFtOUl5bWNGMkJqRldHTG9xM3RieGtsVVkv?=
 =?utf-8?B?UmR0S24rREwvZzBha01DZjBLUGRpcUV0OGZscWZqNHhPSUIraTVnZ3dDRWFi?=
 =?utf-8?B?b1JzZFVDV3UveGpPdjg5TkU1QWFrZWJkZXY0bXlkVVhTaVM1dFBpRFNNTzha?=
 =?utf-8?B?cldFRkQ4SjJuYy9qbVp6bTA4NTVyS3FFRDB3Q2F5NjNkZWxhZ0dXekdxeHlw?=
 =?utf-8?B?QkhoNGl4aXdBdzVXT1d6S0NDTEx0bWMrUTc2cXBJQUx1TGhCTVJSRW1wd3kw?=
 =?utf-8?B?SFJ1VlZ2aGw3bC9pdWFLVWUvd1hNVU41bDNBazNmT3ZPTkJCa1lic2xrbjNG?=
 =?utf-8?B?SVJGcVZ2bGF4WVVNRnl2eVVvNE9yU1BUM2Z4ZXcxWWM5TTNZYWsxV1gxOTl0?=
 =?utf-8?B?bnZ5RjJGd3dVL1ZNb1dhdU9wRnUrbm1BUHQ1TGRLeHdQd3haQXl2RmsweHBv?=
 =?utf-8?B?UGlFekFMdmtyODlJeXpjSC8yTEhPL3RXZ2NGcXhZQUlWQkJQMFVQWW00L2tu?=
 =?utf-8?B?VkJJaDAza3Byek41UXZmQlltYnZMMURteU5qVDJMeGhsRVZxWmh4emIyb0E3?=
 =?utf-8?B?cnhIdG4yTXJJMGJvUW45cWFYV2Zya0pmaHNlVm9Ib2hLeXVONVpsNEhCRlNP?=
 =?utf-8?B?dVlocE1qQ0VXeU5UZmFLZFByQmhMbFp6eTRQemZyZ3Y0UjNRd1hTYWh6SGd6?=
 =?utf-8?B?S1o1TG1GR0p1ZW9PYXJ0NytXclhyOE9sai9vQ2lsdTU2ek4wSU9wUHQreDhR?=
 =?utf-8?B?M1dGdXJ5ajMwWHY1Nm5WdWdHUVR4SnpZSUt4VGtZOElMam1CV0xkYjYxNVBF?=
 =?utf-8?B?dXkxTFZOek9jbmw0QkF3dzhuUlJLYUFsMGdSNXk5Nk1iR0FlQTNET0xHdis1?=
 =?utf-8?B?ZFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Rm4gg7PFJpExX56e9TMIUywbStQxH91B8C8fxi7jCK8cfbSen2sU2TuTQl47BgrX/L3IyAwkOIX7QHFf2cC/9K7V3cozRJ8iDKx6hROK+hLRp4OisqDk9qxc+GHbmGiR0EW/jFnaHBhCb7KhFtM16xvvnEjT6Mvf5WQ6r8726t77gTvPuQSV+CWE2jejqB8MTaYI+5hJaqdaIXtM5jOAycLO+8FZtEpybW4ra6w+1dTdvxuSryg4J/gswI2brFySMrqhnSky+3kA2L/wqOm93zF9zRva3S+5US3pCndSZN7wbVDQaEDuHFDmioC+vWxEj2+Q1A8U7WVu2/wp53gewcYTafv0t9qck1Vd3BZ/La0SQz05/orZ2adMEWFcvhTdJVdPLBPtUPvYVCGIjl9638xpcALJbHexhEk2hPvXTOgBrDk5tDgyVG++pysKSR4esEeV2N0Hu2e0+RHld1hX9TjG9eIRbqOEwiveeMvn3fDqG3FF2LVhTyDcj7qMHsIyEwQ1hcqe96441gVzKc9r9E+1TJPd0+eZ5ghBwDOPsbjXzadd5nb067UrO9ZWIm5MoeVhI8dLPPoldZMcLBIkd9bKI0s1djn8QLHPnWOMx9I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47e4aad2-14a3-418b-37df-08de1c62168c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 11:54:34.5833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9cUeq3IB0mhGLTW1m0KDoP8k0ypso4j8OetQlbPCuby4b8yapmpS5rI++lMpTOPoAhWfDmftPorH4atvNr+wYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF476853C3F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-05_04,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511050089
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDA4OCBTYWx0ZWRfX/FKAhyuz59bi
 +u/uH/4WaV3HbGTjOKqDt093Gp1l3aZiXjU6B8Z54M/5bXJ9WemFL6+CT6oGIzj2NuEE7ytKZ9/
 VtLeefrBlkedM+Sukp96tlL/9PcvlNGAZo5UbV+Q3VMx3XPqan78BvhL3CIHaduQ8WWlXad/194
 BB2Gxvq/BCCsIaOt4CCBAmSTkIay5GqHukxummdRHnKrFRDxwXHLTANHtvsgG5/plk5UIF4xbN8
 zL9ZCmi5AxvJD9/NhDz2MFZuT3yPgQBbX1RNbLmfNO7UKV3x+tJZzjz8QajdIh9mRCfwxjNK0YB
 jAlgkdDTOfsnsffJnX1coEHw+JOfpFIAZcCDDncAj0SKQxhIf9V0du/aWefqvyAtq0+xr1dvbHe
 eCDYhxllFQ0sf3Fg2OGarhS0YaextA==
X-Proofpoint-GUID: n_Yun0GybLpiSgeAvjKmh335xh1wIZkE
X-Authority-Analysis: v=2.4 cv=VO3QXtPX c=1 sm=1 tr=0 ts=690b3afe cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=i0EeH86SAAAA:8 a=7S-gV6KAOEKUBkHuZoMA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: n_Yun0GybLpiSgeAvjKmh335xh1wIZkE

On 05/11/2025 12:01, JiangJianJun wrote:

I got this patch 3x times...

> The injection of timeout faults is achieved by directly discarding the
> SCSI command.
> 
> However, after the timeout, the SCSI mid-layer cancels the SCSI command.
> At this point, if the command is checked during cancellation, 

What do you mean by "checked during cancellation"?

> it will result
> in a "not found" outcome, making it impossible to cancel the command properly.

I don't know what is meant by "cancel the command properly".

> 
> Therefore, the approach has been changed to avoid direct cancellation, and the
> delay is set to the maximum value(0x7FFFFFFF).
> 
> Signed-off-by: JiangJianJun <jiangjianjun3@huawei.com>
> ---
>   drivers/scsi/scsi_debug.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 353cb60e1abe..7d86a6f10130 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -9249,6 +9249,7 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
>   	bool inject_now;
>   	int ret = 0;
>   	struct sdebug_err_inject err;
> +	bool timeout = false;
>   
>   	scsi_set_resid(scp, 0);
>   	if (sdebug_statistics) {
> @@ -9291,7 +9292,7 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
>   
>   	if (sdebug_timeout_cmd(scp)) {
>   		scmd_printk(KERN_INFO, scp, "timeout command 0x%x\n", opcode);
> -		return 0;
> +		timeout = true;
>   	}
>   
>   	ret = sdebug_fail_queue_cmd(scp);
> @@ -9398,7 +9399,9 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
>   		pfp = r_pfp;    /* if leaf function ptr NULL, try the root's */
>   
>   fini:
> -	if (F_DELAY_OVERR & flags)	/* cmds like INQUIRY respond asap */
> +	if (unlikely(timeout)) /* inject timeout */
> +		return schedule_resp(scp, devip, errsts, pfp, 0x7FFFFFFF, 0x7FFFFFFF);
> +	else if (F_DELAY_OVERR & flags)	/* cmds like INQUIRY respond asap */
>   		return schedule_resp(scp, devip, errsts, pfp, 0, 0);
>   	else if ((flags & F_LONG_DELAY) && (sdebug_jdelay > 0 ||
>   					    sdebug_ndelay > 10000)) {

