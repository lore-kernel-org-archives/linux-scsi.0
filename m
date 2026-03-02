Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B401733B6DA
	for <linux-scsi@vger.kernel.org>; Mon,  2 Mar 2026 10:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772448261; cv=fail; b=tSEC/HSyLos3g/wGBAqFKT9prw4eyWjbeDJT7omG+z+c5io3RTEcD0lh7THI51vEESqRUqmTYo91gDdiaD1ShbHycgHIxvQF2ZrpAeg7WEnjozZQFiILqotiO7EaiMa/9nXODgPBK+S/RA13tu2wTPIJ3t2wZiHyxuXFNm10nDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772448261; c=relaxed/simple;
	bh=5RuvePVrs+OC35zez+y1dmnf6HS8yo7yyfetsGb+EMg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jvO4BS193dy5vLknEy9yyeNIUzu/l+OLc2PkXGbaipDi6vnAgRVbMtOnRM3UXCU7FKqtP17XvHVn70z1Dyza4YH5DKhbL1/qg81K0wShgglALcyDiOTe4VR4V23+rZAeNsFEKUZRCOLvkcyNjGOKqLMYsmCwdT7Z2qDagTfSgAc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VNvR07BO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=O7Oe1p/D; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VNvR07BO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="O7Oe1p/D"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622Aacdv1522602;
	Mon, 2 Mar 2026 10:44:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ftFQ43t1NXHu27WVdncK90UvwYDekVKWQ8+iWxlU8G8=; b=
	VNvR07BO671UWh3x4MT+yrnC4rQ9Sb4eg8NBF1Zftw8YDptuOfh01u2umY/K4xwx
	S7KnTVqFAzZ4Zz9bwDIX9P60WvIgVO9uaRN7J2s96SgnDyLzwn51HLjBWED/5Jxy
	qqQF3bcgrVn6OBveQbNJKGBTEMNtRYJFs/mnzvcRT2RVvMjsOFxLv87DORAkobbI
	EvuRCe6YRHRgo1LsE2pR4QgNmwB3R32WfyARsw1KOg5vEwGEUTi71f9w5OHybqms
	1DPW0dTHQTC7ch3FQdb9At+kU8CqU4ODa1sizZbAIJG78XAkh5Ig1gjaoXwDvkpb
	Vx5ny+XEp8gs+J4/zkDTKg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cn8xs806v-16
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 10:44:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6229wu5w029707;
	Mon, 2 Mar 2026 10:30:19 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011053.outbound.protection.outlook.com [52.101.62.53])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt8rshq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 10:30:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KrMyV/Cb+1e6zYhQn0KPsalHKANShp85upEMojHalNz2j9cL2h71G6yV7eL/wSVXzwBRQlbSJuoMldmu07JM97NzZIOGxcIc4lpxYNVhh7Kb+C707PBrl9inWsyytY9himg0Yr6eYvfuNXFii+5ZbGNtRG6B8vBdkdOAZ3Qb0p+Hm13qHNMvEQ9hiuhticJ/FqZchCibrHUtMfkfueEY6SmxlK6kOorpxM89rT4gfN0pLwFVM8T5OkLTLtDUuMa5Tyi+ApXX/lmSrdJ/+wM1YQUK5KbFEt46WJcguilYSI2pHqr3lkUu/sqvhtkTATgHYIgQWTJPkpyN3HVjX8l2SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ftFQ43t1NXHu27WVdncK90UvwYDekVKWQ8+iWxlU8G8=;
 b=KK3TioBhiZTq7GcmbDvGaQTBcnQfVxNiCTG2VHh/KZ72WeM0Kr15MramXmNc9C3i+23gF5JLs41HzOm7s93dUsGuuqV8BWPM0oApOZb0bCvH4A5tbkX+Buzxt3eGqRa0Y7cjcPWX/72SON8X7cnH3327w5MR/njvCnnKOib/BuQ9gvz545L0xZLrwaycMUEPq6riYn0aPX6EjSg8ABhWc3rQ7rcYIFvZUfM0jvWEN9wr1oF0TtdUakZA+Mgr0JxPJSQ1Cyo5J229WKAFlHlbEcTroDPYQHMlZj38Llf06QttsxmstkdcZx9RTHDugefyq/Wxzi77dSBBR3DfB8+MLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ftFQ43t1NXHu27WVdncK90UvwYDekVKWQ8+iWxlU8G8=;
 b=O7Oe1p/DMuPHsjP0eYd6XXyX3ixXW/W0XxKbVTBVldFCrhEYhH4JLxfQbMqKJRrEUQznbPqbB1W+C+5U2sbfsgE9OdushUCRRN8/CBDx/BtM4DPGruxY6mZhMN4B1z5RGyJ8F2wnaRSQL4n0CJIqFM6vi54mOOkBmwEgHMAEKyk=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CY8PR10MB6586.namprd10.prod.outlook.com
 (2603:10b6:930:59::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.18; Mon, 2 Mar
 2026 10:30:15 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Mon, 2 Mar 2026
 10:30:15 +0000
Message-ID: <7ed13647-8b26-4c88-b1fe-af6c3ac41751@oracle.com>
Date: Mon, 2 Mar 2026 10:30:11 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: fix refcount leaking for "tagset_refcnt"
To: Junxiao Bi <junxiao.bi@oracle.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
References: <20260223232728.93350-1-junxiao.bi@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260223232728.93350-1-junxiao.bi@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO0P265CA0006.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:355::17) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CY8PR10MB6586:EE_
X-MS-Office365-Filtering-Correlation-Id: 37064f10-9fce-4d38-a378-08de7846b18c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	FeTZ7P/xwUir9v0zgCdXS6R8Ok1wjB+pOktrb76ukgsLZ7+JyAYiWHcUnQgA1fpx6p9Zdo0KmSLYXd3wpOmEMtt5cHswGCBS2eBcqHWX8sco9+z08EG8QAITBjzRCd7iLb7Gnr1tfnT2tQ139O+bdrgk45lv6D58Dk0ISIht6NYuMSolr5ijb+awvGJhNNR4Ke1fi57joW1HvlV9+HUK7Chkpp3L6Vc2i7RCYySJmBZjfHlPf4X2JyWE0d+/xfSO3dPFp9cDgg1h7gFUhh+XBa83+/9SsaS9Kq/YIJwWcQrb52IGudKOUpfTkWouhCFWBqpGejx0S4weXvlFlDANR38RkYHtwHxHGy0soKfVcCymViRMgDmnAu8wKZ6pdzF+5AU5Go/SP7bqVoimCVUrpseyQLXuXrCwrV5tlm05LOPF5u90SnREiPrlLKHtkUFfHm8CLZvBmmxzz7vUxU1B15EMVFPMhH2dpPbC5F1fKTVSScxcXKPXjKLMWQ56MAP5edR4j+baIojmVN9k6VrEdM0WiZJEulASjDCweVI/01BL9NT2Dz3AHr1gWl66K1u7yhAlqFng0ckGg8ASavh9RdZjgK1OVxk3OMb/qsoQjA4/TU1Z9HR91W0CW/keq3w7ADNEegwvA5hnqWa89PJeo4DCQdC/Y45Whr3Bbs+//2+Ov/eSoMWMwZYi6+qLKTLarl8AiAk/nkp3Fu5uiPFfMKjTEhSKHFhz8trs34tLZLE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RXpsajk3NitJRkZoVExCWjRiVWJvQmZuaXFyOWQxVTdzQ2F3aDBvVHpocXNk?=
 =?utf-8?B?ZVN3a1RmbU04cTkrZzNVRUpFWVJDUlRlYkFVTWQxaW5HMC9zaTZxU244MEhw?=
 =?utf-8?B?ZmhZNnJYSVdJcWpUT0NacWxtTHJNSkZqWDBvUGl3VFFHWEdpRVVta0dkak5I?=
 =?utf-8?B?ODBqdVZ2SCtHMEtWZWdZaWJaTXhvRmpoclU0SXFRTzRFMUE5NWJNNkM0MGhk?=
 =?utf-8?B?Qk53dkdTY2pkeC9pVGs1NTl3OWRVUVhKWlU1eVB3ZU5NUEpvK0FlWWhtVjdt?=
 =?utf-8?B?NGFqVkRZTjJPTENHd1RjSGhXNjBHa1JNeHlnakVTTk1QUktOQkRXS3FHV3lN?=
 =?utf-8?B?NXZpMzhqR1FHNWxNUmpuUEtrYk45WHpCYUZVWWxNemQ0SnR3eGdJTkdlbmVL?=
 =?utf-8?B?QXlGKzZpMms3L0h6SnVXM2E4djdBajgzWFhvNVVpcmREaFdZNndhaWU5Vk9k?=
 =?utf-8?B?WHAvZ1pmSHM0SjhlQ2xNZ3RLZm04VHpGMUlLSElvcmhzVDlhRFdRQ0JjNXVW?=
 =?utf-8?B?WTZNdTdDNmtmeWl6R09vOUtubWQvektjc2R1Q1JXYTI0dzR5YmdOSG1JdWNG?=
 =?utf-8?B?VXVQdDRBdzZ0c1REU24xNVpMR1EyNW9MckRjNndYclFqUjdTazNvMDl3WUVQ?=
 =?utf-8?B?VWtZMktKamVUYVIrYjlnZWFZZWRsOGNIb05qUVhtQk1xSm0rSlpuNFYyWURU?=
 =?utf-8?B?RmVwUGlRMXgrUUhKUzZZK1oyMjRiMDZlZE1MbC9NdTlpRm1SR3VZK2FWTTBL?=
 =?utf-8?B?akdkeWgvenFZUUhIaERYOXpPQzZ1cHNxTXQreHQwaGV0NFFrRVVRL0g0Qy9U?=
 =?utf-8?B?NnJOdEZ3YjlkNDM2Nm9ZaTVRNE53MHRoL0VuVE5KTFZsdFVrNnYwU1dxOUlQ?=
 =?utf-8?B?NyszYVQ0U04vR3lFc2RnQmU0L2xrS0JQM1FuZlljY0pmeG1ia3c2dEZxcXdz?=
 =?utf-8?B?Q2dtZ2hhVDN4K0VzdS9uSWJnQmtPUmJqcVdMVGJ4Z05xR0RuNnZjSmhYS3ZI?=
 =?utf-8?B?ZWNEbVNLdWNOM1pRRTFHbmZYNW1LeTVLamgxUkE0K2xTdnpuWG1SYkZyS2FO?=
 =?utf-8?B?cnVXMTJRUHhGNGhRL3dldCtmM1UwUXI3ZjJONkVRV0RYcGpKRndqOFdCalIw?=
 =?utf-8?B?N2ppVW5xU28ySmFKYzY4dmthK1FCQzVBYWFkbmRjUHJ3Wk16Q3MvNHBSdjNm?=
 =?utf-8?B?eU1mMHJkc0RqenpKeVJjZ0gwMlJlZGlsTk91TG9ieUJLVUJkT3MxbmhtU3Jw?=
 =?utf-8?B?NjNEOVQ3d1FSajdsMEVFTnEvMktwU2VBTVBYb2doL2hndVcvWXM3V2g0M25D?=
 =?utf-8?B?ZHI0bzltaEJhaFBBcGk3K1dlSXpFMzBWSTBNUWI3VlQxV1UyR04xV1pQbnNs?=
 =?utf-8?B?TGhNRk1EbmI1MzZGd29GS3kvZndONDlvNkxTeHJQeUN1bUJ4YkZBUFU3UDRx?=
 =?utf-8?B?ZktaaHc1Q00rQkx6cnMvdFJFMWZtNmJjKzFlK3FUT0ZRY1RNbTdCTjVqWFpu?=
 =?utf-8?B?ejdkN2J5RmVaSEMyOGpXam1qNmQzQThQUnVVVHVxUTgvaEYxMHRLZkpqeTZN?=
 =?utf-8?B?YnVFTnZZeHkzUStac1ZxamtiV0FZY3h2alJwYk5rcDNlUWZ3TDJFNDlMc09t?=
 =?utf-8?B?UnEzMlptUnJZOXE2UTVYNm9vWjlvT1Q2QjU4KzNSZ0pQVzZJSU10L3M5ZGhy?=
 =?utf-8?B?cGtzMDJuMUxGMUw5RFJCaTJ6VTFrVGRNbWttdWZxWTk2YWR1QU4ybXZtQW01?=
 =?utf-8?B?REo2OUs3WlVUYTZ6anIzWVFveGltTlI5VFJjS0RHM1ZwdSthSWM5dWlraHFM?=
 =?utf-8?B?blhvSlZTSEJKYTRabCtSYWdVZG9SSEltOXRzaXhpVHhtSUVveVNRRjhCaXdr?=
 =?utf-8?B?SGFpdmM2Rkg3MmtnbWp2ZnQrajJVVzY2aXEvMXFBMWMvOTFUbGpJK0ZSeWNF?=
 =?utf-8?B?VzhKZk9lRnJwRFk4MWFJL1I5Y2JheDQ3SFpoRnFyNHp6M3NFcDFrYUs0a2lq?=
 =?utf-8?B?WHl6TjJtZlZvUWxKTXVaZ3JPemcvSTliLzlBZnpXRVM0eHZtUjhodncwODNw?=
 =?utf-8?B?SnZ4d2VCbE0zSEhjMGxtZlQ1bGowRWNEQXIzdkNxdVFLUGFHK2dzdEVvUGo5?=
 =?utf-8?B?Z0tQU25OOThMc1dNaDFWcGdaZjFMcENRYm1yQ3ZjKzFzYkhqWERobllrRWJT?=
 =?utf-8?B?WFZNd3Qrd2c5TkVISjVMcnlWQktYdVpFQVpEbzE3RE1SbmN3b01YMnNiRnVW?=
 =?utf-8?B?UmdSczlRdEUzYzZOdFZCRHIzNWxob01iWkI2RW5jYlY3WStEbUtrRjB2Uitj?=
 =?utf-8?B?M1VRZXN4TmVGZEtGbFNCRk9NaXhTZUQwYzg0L3drREF4NWJueDNTQT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fWER5Ye4Q3kURMO/FBYn+kGYZNEgl8ObNKq77dlVF5NIjR9lQas9ZTZlLERsHvs3E+63g57gglbp4VYtIvK/LQbUIZrMcgHEMmuoKeUwx1j4IVkvGWT76A15v8ozlwESko9t7w2KnR569BBsQzoYEES7zUmbLVNg4d50p6KD+BY/rYVKKVrCJRUnM/y52dGpGkwgJXiz2bF+MGBaCbTOem6MY7QhVdAxFFT5CH12AhzeFESDa3+KAY2jyNF+8viVGjISQmUrd2uZmjzDv1m1Bzhempfr0jGB2BbvqP37KGnjDzmX0i5ay+Bz+CnGFnnuO9iRlkp/mIfB/OzbgwE7NI6rrErGahoM7Vb+DN3yx5CbS3dPLt/g+4v0n2+6Ao5UXYxmozY82usMLu58Ewf/PNzf3MtoOuTrXnqmaqMgGKMTfQ88n7Izy520pUNk8eAeycYuBrbZ76dHG4GIoV1tNyuNOnR76/RUXAOTjjIF3HU3zfNPP5v/1a8T4kZvGZkiODZAiA2Jy/H28vqT48JSoCKbZW1lk4guvnt5ou8GK7ok5c1qgFgV6q79j0xlvREokEZX9Vd9tHRXCuXKbV0sb2idBGKaqZ6CUQ9BBcd6yKA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37064f10-9fce-4d38-a378-08de7846b18c
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 10:30:15.6667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uieC94GZ8CzcHWv4qeVeVv9AmCgHn5Bm7+OS5cB7ydFB5OPyS1T3Ra5sxu8VVE28CUjF8IWu79gaqmLlE/f56g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6586
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_02,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603020086
X-Proofpoint-ORIG-GUID: qqA1nuo9d-0ThAG2S3Sx-Pkjuht0KQur
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA4NyBTYWx0ZWRfX2EIj2VRdTRIf
 HOGEwY8oKw1kl/Ib6L5KCmd0UpWHeoMcCPtFsw6UTjh8CeZT37cmbcs3JqYSPZ1+dwmefP7WeBR
 W+qKhqCuKFTMl0nMvA9656Bj9cmr2DXFufv9Dx2mQ7xe4jWQEx31Gijiqn8+3dOIXvCzTWvJah/
 6djd1XFZVcP7ePSzN2/q/259sQ5dOm0+QykcsKLN22xMVDU/WCO4akI7Ez7cvlBSYNQIv4kfYQt
 d60A6GJu1+yO22AyLH821riRUieMA6R6XyWuAIZCK/cE4QaiZocORcsdNQSOT2i1RpDlvv1g1Fm
 np0rsV1t7PneoQm/yYNW8gf0Edahy3VJL7eUEFruh+j5kNqqyTKnT4L7jWIcoJkpExrtTsEZzq5
 2NLKSAu0Jpn6cWTe8NXGVYe5HDW5i0q8h5hj6NjhsCWxayoGKjl+IGS/aVoLueXSqy731rjtn0X
 irTa7jZpMhSyl2NCs7A==
X-Authority-Analysis: v=2.4 cv=BNi+bVQG c=1 sm=1 tr=0 ts=69a56a01 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=-lJZzBaNzpi4HHeSNtoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: qqA1nuo9d-0ThAG2S3Sx-Pkjuht0KQur

On 23/02/2026 23:27, Junxiao Bi wrote:
> This leaking will cause hung when tearing down the scsi host.
> This is an example with iscsi, iscsid hung with the following
> call trace after this kernel log.
> 
> [130120.652718] scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
> 
> PID: 2528     TASK: ffff9d0408974e00  CPU: 3    COMMAND: "iscsid"
>   #0 [ffffb5b9c134b9e0] __schedule at ffffffff860657d4
>   #1 [ffffb5b9c134ba28] schedule at ffffffff86065c6f
>   #2 [ffffb5b9c134ba40] schedule_timeout at ffffffff86069fb0
>   #3 [ffffb5b9c134bab0] __wait_for_common at ffffffff8606674f
>   #4 [ffffb5b9c134bb10] scsi_remove_host at ffffffff85bfe84b
>   #5 [ffffb5b9c134bb30] iscsi_sw_tcp_session_destroy at ffffffffc03031c4 [iscsi_tcp]
>   #6 [ffffb5b9c134bb48] iscsi_if_recv_msg at ffffffffc0292692 [scsi_transport_iscsi]
>   #7 [ffffb5b9c134bb98] iscsi_if_rx at ffffffffc02929c2 [scsi_transport_iscsi]
>   #8 [ffffb5b9c134bbf0] netlink_unicast at ffffffff85e551d6
>   #9 [ffffb5b9c134bc38] netlink_sendmsg at ffffffff85e554ef
> 
> Fixes: 8fe4ce5836e9 ("scsi: core: Fix a use-after-free")
> Cc: stable@vger.kernel.org
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>   drivers/scsi/scsi_scan.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 7acbfcfc2172..c64ef71633d8 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -361,6 +361,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>   	 * since we use this queue depth most of times.
>   	 */
>   	if (scsi_realloc_sdev_budget_map(sdev, depth)) {

At this point scsi_sysfs_device_initialize() has been called. Then if 
you check the comment in __scsi_remove_device():

Paired with kref_get() in scsi_sysfs_device_initialize()*

So I wonder why we don't call __scsi_remove_device() instead, which 
calls scsi_target_reap().

Indeed, the current error handling in scsi_alloc_sdev() is odd - we only 
call __scsi_remove_device() for ->sdev_init() failure, but nothing 
happens between calling  ->sdev_init() and after 
scsi_sysfs_device_initialize() which means that at this point we should 
only now call __scsi_remove_device().

* I think that should be scsi_sysfs_initialize() and has always been 
incorrect


> +		kref_put(&sdev->host->tagset_refcnt, scsi_mq_free_tags);
>   		put_device(&starget->dev);
>   		kfree(sdev);
>   		goto out;

