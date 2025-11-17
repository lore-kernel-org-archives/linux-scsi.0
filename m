Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FCB224249;
	Mon, 17 Nov 2025 16:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763396379; cv=fail; b=qWgSpwEnpNB030EOGfFH5t6wWZfw+P1KdvtXvP5j3VaAZrrlQXNakCZ3/pancz6lNO/DILqIy1Rb7BtOC1YNUc6TsN/5VCxV9A6HphYhSwRLO+eqhaeWJ+jqgrsVwCBFKHXO1T5FIYFzB4QRJSaJjMFeo73pVZaph8Ziy3hWLjA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763396379; c=relaxed/simple;
	bh=CTZpwIQ85Ypd8dr65zVmQtrLt8dX743q9ax+r6QdKNE=;
	h=Message-ID:Date:From:Subject:To:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QZoGdW6wbWNWc1R5Z8bDe/mnXIFtiJeQw4CYj1qW56i28H4odTEwMjMxy1S88KQTOeUWsYYq49kYK1gsMoHp3im0TBzgoKG27vuUT2QEkVpyb8/lu1SDyvNar8dS5I7P7HYHOWY9fdQxZY0WKdfH763M94rPES1afmstCgjNFhQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ecIzNu0I; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TsvIdf/7; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ecIzNu0I";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TsvIdf/7"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHC8JgF024546;
	Mon, 17 Nov 2025 16:19:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=AKOoM/EKwtHiDaV/zKDzZqn/+btDSK1DvFxP6XWir2s=; b=
	ecIzNu0IIeCQazIPVpcHKX5fkuBv9A+oqW5Li1QNnUc29KST9xZpJve9eWVMbUhI
	EtBJL5jTHT3gpfDXeiXRKxzcIdiGiLGNbIS9fnXehrlmQw6IdjmjiLDD0FePjepY
	JgabFqHEDcdLUuP/OmTFVcIb87Xgcd2TgU6sexhouIFKWNwiZr127E97ePYDRY9/
	EYt8yol7y+pru377dO0pI8kzcAsiWDOLrQlEAr4691HopZm8zM9LXUhlGWsETwAU
	c3z8VG5FX/iNdCDVgEqaLc0WNTmqNPTe3mhz/TM6vptFlSnYtzacJnrBJxEgkdc2
	+jmYHLqeG5gl+op0T3Ap+g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbbav4h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 16:19:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHFRn8O039894;
	Mon, 17 Nov 2025 16:19:34 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010007.outbound.protection.outlook.com [52.101.46.7])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyj6cm3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 16:19:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OLHvcOIgQtELl391G7GY7B+j4DRXYdH8ergxi/VZASCFIq3oGM/f3pQnK480bH4sQc75fpT+gkx2JUYc4qpDcHXA5Phf0BMrYN5hstY+MjyA9MKZDr2Yp3sOx8zX308r2VyyBWpi19MQZsSLJAJF+7cagqgnAA+QUbawIonPVliqMjg1fqI04N+uyNQIIxqGTewzaIIR15OgWD+9AMfgITzzlxndXEVSlODYr8ZupotNwvK5vk9SokNg/3ZMIxGABtz0rYf0uk8ZToczMWr1OjmLC17BoRuOTh0iVGCBJyMxAEtUOWwgxO8Soi5PpuGMYchFr8YR1nOuT5A8Ht1ytg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AKOoM/EKwtHiDaV/zKDzZqn/+btDSK1DvFxP6XWir2s=;
 b=lGwZSDvpt8PjfzFnB99MHEuNC2jNx/MVpYzAJazgS9rt/4miao8xF2DTgFZLLbUWmZu3OlMOXnjEi8ia/o9eCfJAPL2+/cXv92NN/mVXZHtf2YnDticW+uIOwSPYcAK0O27Ly7QSksFuD5rZ6oxGyRCwZ8mlsDs6eF6JiqQ8Rq9WkpuZMntrIz80jSS2WGF50eduyEa5X6Tv5jD8J2hMeoLTouzyB3A1z1fhVc2u7ku5uzx25D67mMcOT7RTeBV0lEpooHThnWjtoYI+ZzhDOdsu/m6lvF/8X2wQw/VJOfr8W9KQ2ks/8HyxJaDaImk8qjbKFhVeybmLRfdmi34NCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AKOoM/EKwtHiDaV/zKDzZqn/+btDSK1DvFxP6XWir2s=;
 b=TsvIdf/74J0/QpJ/XMzqHbqpZ4aWaHm6Oj8M7/hCLQw2IQbYLq/kF8tbdT9Bq2OtJ60EMB1XXNw1x/y4joe6FS8tDOjxo9j4R2klRlW90k/aFXnC7zSW9HBWmUDG2db/paWRGOLD1Fh/PbKBmpN9ogkUFDdplpgRb28X3ejmgK8=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH7PR10MB6988.namprd10.prod.outlook.com (2603:10b6:510:27d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Mon, 17 Nov
 2025 16:19:30 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 16:19:30 +0000
Message-ID: <b3c28b7f-503d-4e83-b4c2-b756150bfbd9@oracle.com>
Date: Mon, 17 Nov 2025 16:19:28 +0000
User-Agent: Mozilla Thunderbird
From: John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH 6.19/scsi-queue] scsi: target: core: Add emulation for
 REPORT_IDENTIFICATION_INFORMATION
To: Gulam Mohamed <gulam.mohamed@oracle.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20251026191309.34968-1-gulam.mohamed@oracle.com>
Content-Language: en-US
Organization: Oracle Corporation
In-Reply-To: <20251026191309.34968-1-gulam.mohamed@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0481.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::6) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH7PR10MB6988:EE_
X-MS-Office365-Filtering-Correlation-Id: 181310b2-6e38-480d-ccea-08de25f515f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SnZ5bXNNVnNkZ015WlZIMjNxVTJudmlyT3lxU0ZReDE5cnJvZ1BFUWd6Z3Rv?=
 =?utf-8?B?SHlRMWwrQks1Y0k0YkRBSE1qcGxHWW11MDlnZXExL1RvbGRrK3hNc0N0NkRw?=
 =?utf-8?B?QzRoU1NsQVFGNFN0RXo1eHlxODZ2MFUxRE1HNlNDcldKYVJPWFJMUU1DOURN?=
 =?utf-8?B?OEMvNjdyTlgyd0F2UnhVZkNzd25PcVRBbnlBUVEyeFlBNlA2VGVvT1p0ekw5?=
 =?utf-8?B?Q0ZrQ3J5UGx4akU1dkhzdW1ZSkFlR3VGOW1qblZILy8xT0RhUU1QaTRsTTJu?=
 =?utf-8?B?cVhJbmlGbmJBYkhNZzBjMEdkUE9RZndJWi9FNDlyai9Gd1JkOExVRktHZCtv?=
 =?utf-8?B?Zk5DN0pmdTJsRm44cFNsenFJZUpuUVVKRWd4QURPM2Y5d3lpZzdXTzJXcFlx?=
 =?utf-8?B?c2hqOVEwRDEyVndwelFwcjJ1T3RnSGJ6MWxjY3BjZEVqcStzTTZUTitiVGJm?=
 =?utf-8?B?SzR1aWJYTkk4cnRZamY5blZuTVFwZmprb1dVQ05lUGFCQlB1Wkdxd1dUeGFa?=
 =?utf-8?B?WUpKeUg0MS9QVEpSZnZpTzk0WTVtT0dIa29aekVDYW9GdzM1c1BOcmZxVHFN?=
 =?utf-8?B?RzRIcFUrbm1DNTRsekZ5WWxSU0F6dE9UcEROQzd0bWV1b3hTRXQ2cEpPT0V5?=
 =?utf-8?B?dUwzWTJjWG9HNDBaVEpSMHk5UjFKTzM4SnIwVG9WZnVhNk1qYVNqaGN5MzNj?=
 =?utf-8?B?c012VVhMV0o2bTJVbVJXMWRzVXZWcnNabnlpSWVzSTZKY0lRdXhjU0xpaHl3?=
 =?utf-8?B?T2FSNVBWUUtpZHMveWF6eUgwSGF1OG94emtoWmRkNW9oczMwbGpBR2RBdnVl?=
 =?utf-8?B?K3ovVnZBQ0x2cFdjU2tvQloxSkhaTlNVZVZGR3N2OGM3V2g3UHl0RFNCS2N6?=
 =?utf-8?B?VUNnSWE5eFNWSElvNzl3UUplcERldmdEd1V2eStUd2tYWUx2ejd2TE9SVU5J?=
 =?utf-8?B?VmlCcWtzd0Npd1BmSXFieFhyazFkUzFYM01pRUpZV2VTRjg1OWxiWkNNang2?=
 =?utf-8?B?KzRzRDNRdVZBUHcyWEppWktRT25TaGNRa3owUWNkUUlqbnpKdHRLMWxsK0tJ?=
 =?utf-8?B?dzl1WDRPdm9DYXZySHRRL3JoYVdERmQrVnZPVWNQMHFjRHRJNkNIcmsyYVUz?=
 =?utf-8?B?eFpQUUtmUmdxVjBQcjRTOTBnUE0yUFVoeW5aajJxTmwvUS81ZEhVbVl2NXlw?=
 =?utf-8?B?Vlp3Vit4QWE4YU1wV2loWml3R1dGUndNT0dIc1pBR0tQZmJraTAxelQzaDd4?=
 =?utf-8?B?YnZ0dkx1Q3U2alF1STI1Q3RMM3AzRk1HUEhPbHJSdjBjb0NnenRJemMzb1I3?=
 =?utf-8?B?TUVCQkw0K2NOTm0zNWtEamVzdVViU3VpTkpaOEwvU3pZN01TcGlKWkJhTjFN?=
 =?utf-8?B?aXdHODJCQ1ZQdTdBMzZjYVNaWHg2bjNldyt0Z2dyczQvZUZpWnRNQnRvVVdr?=
 =?utf-8?B?MFpMRG93NHJkaEdIUWVIekJONlFnQ0lQSWhQcUJKUENZbUc5RllsSzB0K1Ri?=
 =?utf-8?B?M3NWcjBQbDJXaUhqSjdFYkFmeTRQTEhrT0pXTVM1bkRNVXgrWmpJVC9kS2FD?=
 =?utf-8?B?ZVhCek5GNEI1d1lvV25Ib0pUSHUxYjZaVzdxakh3b1ZIQXF0VlVmM08yMmJ1?=
 =?utf-8?B?QjZ1SHV1YmFpTGZzSnRRWlNneTFqZGwrSzZzYVFZdU5NQmxHQXVOc1p0UDRr?=
 =?utf-8?B?M0ZueGxBaUdBMjRGUG05T3QwVURHbGhaSkZLMEw2cktyd2trckRDQTA5ZGZh?=
 =?utf-8?B?cnNFSGhXRUdGemFBUFRhNjlZTlFKTVZyaU5mN09kN0xuSTVhQnJLOFZOM2Qy?=
 =?utf-8?B?dWRiaVNHakptMU1hTFpxSVlzQktvd0tyT0ZEWUx0Zi9mRlBSZVdCWDVOcThF?=
 =?utf-8?B?Tjc5R1pISndGUnNNSEYwckNnWUpJOVhKb2FJaWRXQ3A4SFdLUE9aU0QvOTU2?=
 =?utf-8?Q?LQMxa9pYPW3bB8WfUGl91SQFLOi+xafz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M3VXdjZNdjlNZ0lIZ2w4dE1qMkw5cHJxdmhiejVvbmZMclJXbVhGUFJTUVZv?=
 =?utf-8?B?THdrQmhWWEFSYjFOdWpxaEJPMUlyUGtQK1dJQkREZTRYclo1Smo4QWF4QlRM?=
 =?utf-8?B?UFpPVWtIZDQ0YStQeWVUOFNMNnhpVnMwMjJyeWRXdkJjVjI5S3FKZ2lLR09L?=
 =?utf-8?B?bGZYRk5yODdqd3czYytzQkZrcjRwSzJIQUFEMjR3UzlDOXRRVytKK20yVFVm?=
 =?utf-8?B?UUFXVEE0cU4ybndIcGp4ZkhCM0tLbFlMM1YxQkduTjE2VnVMZHZNRW10U3FG?=
 =?utf-8?B?MThFYkFINVB6bjNXdmZNM2hJNUxWbkRvWG5sYktLOXBYZUlpUVdkVkJDWmFI?=
 =?utf-8?B?dXZEV2Z1aGZOTGpvVVpFMkFsZ1B5aE5mRENQdGZLSjVPQlptRGNSQ3ZybC9W?=
 =?utf-8?B?MWZDVEdZS1FjZFdoVkUvUy9WRjlFUXdtMWN0QWZoRVM2SXI5ZlhmRGFER1dF?=
 =?utf-8?B?NlNXK0xwRmRhQ1I4S0dLbldYVngvS1ZVOTU3WEN0eXVnbFZ4SmRtYStvY2lP?=
 =?utf-8?B?Mng0d2hLbHNPR2ZTMjZocTA4OS9vTWxGMTNwNkI1UzZKQkFXSmZmRGpyNFFv?=
 =?utf-8?B?M2hWUHJaQ2lwSTcrR2luSU93ZytIUy82czkwTEZ5bUlGeDdlQ3JaY0pTamdG?=
 =?utf-8?B?dURJRUprdk5VZCs1SVB6L25pQ0hPRHB3YXozWUthUFZ1VGl4aWZ0L2h5Mk0v?=
 =?utf-8?B?Qi9SblN5UHN6cEtZTm1zNk5BTkgwMjRKaStIUmZ4TkVuaXlDOWlxdEdPeThj?=
 =?utf-8?B?UmRMeHdMYUpUSzRkMWpVaXpvVFd5clVZeFo3ZERrSDFZbFNGbmoxTko4NmJo?=
 =?utf-8?B?S1ZLV091WStsblNxWTVoYVUxQXJ4THk1bUxKODlLUitRVXpBMUlqdVlmWmFD?=
 =?utf-8?B?a3hqenIvUVRwSjFpYnpxQTdVcC9ORDR4aE9zRHdKL085dGN3MVBOelVwaWNJ?=
 =?utf-8?B?cEdSQzZXMlRxNlJyc2xTZStyY2ZPRDBEbUFhM1hHOFR0RFBvZlVaWTN5Wjhm?=
 =?utf-8?B?UlFEcy9DTzRZMFpCd1p2cmFNZjNRV0ZIQkFGRXdMcytjbEhrYmVZL1dLWlJT?=
 =?utf-8?B?T2NvV1hlZDNQNFI3eVhzOXY0eW94MkJMZUhmOVdjQzZJdVVlY0d3WWkrQnRo?=
 =?utf-8?B?Uktic1pZVFA0cG1pUnJpN3pWcExPZldxUFlPRGlNYTF0NHY4eHhkaVN3L2c2?=
 =?utf-8?B?R2g3VXdGb0RyNXdNMXJkcll0OHh6TEVnSlRIOXVxWlJsamQwNmg0RkpHY1Yz?=
 =?utf-8?B?azJlUkJub1ZKbmtZM3U3dEp5VlF1WDN3MTBKMlh5WFV1Z3pRWEhGMkMrQkhB?=
 =?utf-8?B?N0k2b1VRVmVXS040M2pPUjNyYWlEL2RxZnk3cVdGZGh1M1d6aTQ3S3BHQUp3?=
 =?utf-8?B?S3FobGViK0RFdSs1MGRpVzJFTXJsUUI5K2htUUdGblErUkZSV3Vwbml2RzBk?=
 =?utf-8?B?SWpDc01nZTVnTGI0UlJSNkpGbHpaaGJpeHhqNjZvQW4zYkNSZE1mbU1sUVBH?=
 =?utf-8?B?Z0xWeXdhVllJZ1BGRUZMS21RcDJhVU9uOElwdWlJck4rR251NjRYUUNNUXVN?=
 =?utf-8?B?WklXaktIWnloMDVWNThLMnhrNzFWTnBKT2tNaDZmZUc0Vjc3MmpMRzZRQlBU?=
 =?utf-8?B?TERRME1BUURia3hTc21GSGdGb1ZPMm1yVG9zTmN6V3MzVmVpS20zRUFuTXlK?=
 =?utf-8?B?OWNoSDFBS0V6aElDR1VGM2Y2eDNyL1dGc0lQY1d3amJYY2Q2RUJSMXdjR0p6?=
 =?utf-8?B?RnZmSCsvV29URENqVGRZUjFRcW1CekNTR2ZZdE9rYWQ3K1I2MER5Q3p6Skph?=
 =?utf-8?B?b0hSbDZ6dm1UVXkyZEJsVHVwMSs4aE93Y0YzdkpXVUNRNWk3d0FwQjFaQ2dD?=
 =?utf-8?B?M09JVEQvNWhqd0tvZFZPOGpxNjhrb0QrNis5YmczazgzWkZJNDFrZnhUVWhw?=
 =?utf-8?B?TGVUM1hjcVBGYXpvWVZoSEpuK3lEZkMwZ3JhaVg0SXVmVWdvZnBYN0FPV0pk?=
 =?utf-8?B?SXNFZFpoVVQ0Q1drWEtVd0ZXY0c4cW41UDY2ak0zQ1pqWDJyTUR4YmZIOCtq?=
 =?utf-8?B?aGgvSmVxek8wbG1GR3M3U3FJM1g1R0ZRRzV4aWZNMkJzR1RkeHBObFQ0L010?=
 =?utf-8?B?UmVrK2JETk5KdHl3U2s2NkFGMkhZQ201aGs1YzhUTEV3VlJpOUxkVjBmR0FC?=
 =?utf-8?B?YXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HA9sHLzvmUTAlmDlQcyXY2BBexrXxHOioaB9ULPJ+o4ypwXiawtY3NdFS0GUcKrzsXnQ7rdfJQ+10tb80Pj967yYLWUra4KvfyVbEqtAy1TrW+t+zYN7iATTRP4ZUQ0Q8CFdG+qZYQcqJ1UU/NMHS8JOMAZvivPvisICUP49UnLDqCgFYAujDUUnhLeQ6Jrgv7uAMhws7FJtCQhafoMt8CsErs7eXyiuHsxQ8l9pUnfXN82rGEqN8vSo361GdIjNYPXJj1jCBjThwvUQmgeeQx4owvZMSk/8ub6G1UQgLlFQry1aEFdyZN24RCvdbLZPsmPduPy9lmzixlFU0G8T5BhhH0YZyAhbx8aSLQQy9nHyDBeCg7+J3gRg7iGm6BNpu14qC21eArilFTH1V9YxhVuj5wYM0ngbBHHCv7vP9JpyNMvZEdLP703aN6YyQ0RJgJ3kibZit8HShOqZyzhszyUve+YPlJKP9Jii9qNLaOjA780DLcCBtWjcTfB7f2Zj8egzqoyVK7BE4bRV5JJh5bcBIPDgEBq26piUShT4XyTRpHWCMARayh4KumDuGY7jhzgs8Nk/pNTd1W4JcgVHQ1ojBtLkSUvVs95F5lrY2mE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 181310b2-6e38-480d-ccea-08de25f515f4
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 16:19:30.1959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mXQ5k6GuJKaB1ud1ExhNfIv94b04fNanXzDyUdsQzWubOFVDuCk+AZgztpsyXEWtMiZnbrm/J32GYuC0NWs1Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6988
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_03,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511170138
X-Authority-Analysis: v=2.4 cv=BoqQAIX5 c=1 sm=1 tr=0 ts=691b4b17 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=xb5MBGX5lddL9gw6Ds0A:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12099
X-Proofpoint-ORIG-GUID: FP8aJpcLaqw2z9-1oo1Bv_Oeaf8rr8GK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX4/UkOWUCHh+t
 gaJuXvg6C6BV6Q/m0xFF743OEQ5xBJja3kZxqy8gpAlkBNy93P6NDUW5PIqLvCQC8RULgnvzJWw
 mnaC7d7Ml3QuGAqzwqvYBeg6HEBmM54BoQQBFk0mI+yo9gBeQqwDOfF0ag+LJraA5Ui+V34lVqY
 KYCaQVM4dnTQ9jv3MLTvqAv0GcSGxlVmq3IUvV+fVLhMu37vXVuTr+qjgAaB9TiDex0WmZSUbDJ
 JwxIZIuogj2ftdHCFZDL+eRlImPKAK+aIZ/umyfJbbhKOn+mKN5CZ2V0aeDG/wM113h+2p4hpaI
 O0W4oSVynl5nXWmXTcUDtQ1aQsgIwjwsZC1MJNxUhc1BqE+vx6tlT6oM6vWfUu3Rto9x77eYdS5
 VKpnOE+OzkxYzXG2UPa2/x1vxDZhanresbNI0TMA/Mt59v8pzzM=
X-Proofpoint-GUID: FP8aJpcLaqw2z9-1oo1Bv_Oeaf8rr8GK

On 26/10/2025 19:13, Gulam Mohamed wrote:

In the title, why "REPORT_IDENTIFICATION_INFORMATION" and not 
"REPORT_IDENTIFYING_INFORMATION"?

> This patch

git grep "This patch" Documentation/process/

> will implement the REPORT_IDENTIFICATION_INFORMATION using the
> configfs file pd_text_id_info in target core module. The configfs file is
> created in /sys/kernel/config/target/core/<backend type>/
> <backing_store_name>/wwn/. The user can set the peripheral device text
> identification string to the file pd_text_id_info. An emulation function
> "spc_emulate_report_id_info()" is defined in target_core_spc.c which
> returns the device text id whenever the user requests the same.

It would be nice to a mention a spec reference for the command.

> 
> Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>

Generally the code below looks ok, but I'll be nitpicking a bit...

> ---
>   drivers/target/target_core_configfs.c | 55 ++++++++++++++++++
>   drivers/target/target_core_spc.c      | 82 +++++++++++++++++++++++++++
>   include/target/target_core_base.h     |  4 ++
>   3 files changed, 141 insertions(+)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index b19acd662726..ac78a106e0f3 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -1726,6 +1726,59 @@ static ssize_t target_wwn_vpd_protocol_identifier_show(struct config_item *item,
>   	return len;
>   }
>   
> +static ssize_t target_wwn_pd_text_id_info_show(struct config_item *item,
> +		char *page)
> +{
> +	return sprintf(page, "%s\n", &to_t10_wwn(item)->pd_text_id_info[0]);
> +}
> +
> +static ssize_t target_wwn_pd_text_id_info_store(struct config_item *item,
> +		const char *page, size_t count)
> +{
> +	struct t10_wwn *t10_wwn = to_t10_wwn(item);
> +	struct se_device *dev = t10_wwn->t10_dev;
> +
> +	/* +2 to allow for a trailing (stripped) '\n' and null-terminator */
> +	unsigned char buf[PD_TEXT_ID_INFO_LEN + 2];
> +	char *stripped = NULL;
> +	ssize_t len;
> +
> +	len = strscpy(buf, page, sizeof(buf));
> +	if (len > 0) {

Can you just return early if len is too short?

> +		/* Strip any newline added from userspace. */
> +		stripped = strstrip(buf);
> +		len = strlen(stripped);
> +	}
> +
> +	if (len < 0 || len >= PD_TEXT_ID_INFO_LEN) {
> +		pr_err("Emulated peripheral device text id info exceeds"
> +			" PD_TEXT_ID_INFO_LEN: " __stringify(PD_TEXT_ID_INFO_LEN)
> +			"\n");

I think that this can all be a single line.

> +		return -EOVERFLOW;
> +	}
> +
> +	/*
> +	 * Check to see if any active exports exist.  If they do exist, fail
> +	 * here as changing this information on the fly (underneath the
> +	 * initiator side OS dependent multipath code) could cause negative
> +	 * effects.
> +	 */
> +	if (dev->export_count) {

I would check this before any of the string correctness

> +		pr_err("Unable to set the peripheral device text id info while"
> +			" active %d exports exist\n", dev->export_count);

I think that the following is better, i.e. keep fixed strings on same 
line to make grep'ing easier:

pr_err("Unable to set the peripheral device text id info while active %d 
exports exist\n",
	dev->export_count);

> +		return -EINVAL;
> +	}
> +
> +	BUILD_BUG_ON(sizeof(dev->t10_wwn.pd_text_id_info) != PD_TEXT_ID_INFO_LEN);
> +	strscpy(dev->t10_wwn.pd_text_id_info, stripped,
> +	       sizeof(dev->t10_wwn.pd_text_id_info));
> +
> +	pr_debug("Target_Core_ConfigFS: Set emulated peripheral dev text id info:"
> +		  " %s\n", dev->t10_wwn.pd_text_id_info);
> +
> +	return count;
> +}
> +
>   /*
>    * Generic wrapper for dumping VPD identifiers by association.
>    */
> @@ -1782,6 +1835,7 @@ CONFIGFS_ATTR_RO(target_wwn_, vpd_protocol_identifier);
>   CONFIGFS_ATTR_RO(target_wwn_, vpd_assoc_logical_unit);
>   CONFIGFS_ATTR_RO(target_wwn_, vpd_assoc_target_port);
>   CONFIGFS_ATTR_RO(target_wwn_, vpd_assoc_scsi_target_device);
> +CONFIGFS_ATTR(target_wwn_, pd_text_id_info);
>   
>   static struct configfs_attribute *target_core_dev_wwn_attrs[] = {
>   	&target_wwn_attr_vendor_id,
> @@ -1793,6 +1847,7 @@ static struct configfs_attribute *target_core_dev_wwn_attrs[] = {
>   	&target_wwn_attr_vpd_assoc_logical_unit,
>   	&target_wwn_attr_vpd_assoc_target_port,
>   	&target_wwn_attr_vpd_assoc_scsi_target_device,
> +	&target_wwn_attr_pd_text_id_info,
>   	NULL,
>   };
>   
> diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
> index aad0096afa21..9fa84202ee4b 100644
> --- a/drivers/target/target_core_spc.c
> +++ b/drivers/target/target_core_spc.c
> @@ -1963,6 +1963,18 @@ static const struct target_opcode_descriptor tcm_opcode_report_supp_opcodes = {
>   	.enabled = spc_rsoc_enabled,
>   };
>   
> +static struct target_opcode_descriptor tcm_opcode_report_identifying_information = {
> +	.support = SCSI_SUPPORT_FULL,
> +	.serv_action_valid = 1,
> +	.opcode = MAINTENANCE_IN,
> +	.service_action = MI_REPORT_IDENTIFYING_INFORMATION,
> +	.cdb_size = 12,
> +	.usage_bits = {MAINTENANCE_IN, MI_REPORT_IDENTIFYING_INFORMATION,
> +		       0x00, 0x00,
> +		       0x00, 0x00, 0xff, 0xff,
> +		       0xff, 0xff, 0xff, SCSI_CONTROL_MASK},
> +};
> +
>   static bool tcm_is_set_tpg_enabled(const struct target_opcode_descriptor *descr,
>   				   struct se_cmd *cmd)
>   {
> @@ -2049,6 +2061,7 @@ static const struct target_opcode_descriptor *tcm_supported_opcodes[] = {
>   	&tcm_opcode_report_target_pgs,
>   	&tcm_opcode_report_supp_opcodes,
>   	&tcm_opcode_set_tpg,
> +	&tcm_opcode_report_identifying_information,
>   };
>   
>   static int
> @@ -2266,6 +2279,70 @@ spc_emulate_report_supp_op_codes(struct se_cmd *cmd)
>   	return ret;
>   }
>   
> +static sense_reason_t
> +spc_fill_pd_text_id_info(struct se_cmd *cmd, u8 *cdb)
> +{
> +	struct se_device *dev = cmd->se_dev;
> +	unsigned char *buf;
> +	unsigned char *rbuf;
> +	u32 header_len = 4;
> +	u32 actual_data_len;
> +	u32 buf_len;
> +	u16 id_len;
> +
> +	buf_len = get_unaligned_be32(&cdb[6]);
> +	if (buf_len < header_len)
> +		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;

isn't there a limit of 512 bytes for code 10b?

 > +> +	id_len = strlen(dev->t10_wwn.pd_text_id_info);
> +	if (id_len > 0)
> +		/* trailing null */
> +		id_len += 1;
> +
> +	actual_data_len = id_len + header_len;
> +
> +	if (actual_data_len < buf_len)
> +		buf_len = actual_data_len;
> +
> +	buf = kzalloc(buf_len, GFP_KERNEL);
> +	if (!buf) {
> +		pr_err("Unable to allocate response buffer for IDENTITY INFO\n");
> +		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> +	}
> +
> +	scnprintf(&buf[header_len], buf_len - header_len, "%s",
> +		 dev->t10_wwn.pd_text_id_info);
> +
> +	put_unaligned_be16(id_len, &buf[2]);
> +
> +	rbuf = transport_kmap_data_sg(cmd);

is it really ok if this returns NULL?

> +	if (rbuf) {
> +		memcpy(rbuf, buf, buf_len);
> +		transport_kunmap_data_sg(cmd);
> +	}
> +	kfree(buf);
> +
> +	target_complete_cmd_with_length(cmd, SAM_STAT_GOOD, buf_len);
> +	return TCM_NO_SENSE;
> +}
> +
> +static sense_reason_t
> +spc_emulate_report_id_info(struct se_cmd *cmd)
> +{
> +	u8 *cdb = cmd->t_task_cdb;
> +	sense_reason_t rc;
> +
> +	switch ((cdb[10] >> 1)) {
> +	case 2:
> +		rc = spc_fill_pd_text_id_info(cmd, cdb);
> +		break;
> +	default:
> +		return TCM_UNSUPPORTED_SCSI_OPCODE;
> +	}
> +
> +	return rc;

I don't know why default clause is required and not return result from 
spc_fill_pd_text_id_info() directly?

> +}
> +
>   sense_reason_t
>   spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
>   {
> @@ -2405,6 +2482,11 @@ spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
>   			    MI_REPORT_SUPPORTED_OPERATION_CODES)
>   				cmd->execute_cmd =
>   					spc_emulate_report_supp_op_codes;
> +			if ((cdb[1] & 0x1f) ==
> +			    MI_REPORT_IDENTIFYING_INFORMATION) {
> +				cmd->execute_cmd =
> +					spc_emulate_report_id_info;
> +			}
>   			*size = get_unaligned_be32(&cdb[6]);
>   		} else {
>   			/*
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index c4d9116904aa..c9b5edcce1eb 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -108,6 +108,9 @@
>   #define SE_MODE_PAGE_BUF			512
>   #define SE_SENSE_BUF				96
>   
> +/* Peripheral Device Text Identification Information */
> +#define PD_TEXT_ID_INFO_LEN			256

as above, I thought that it was 512 bytes

> +
>   enum target_submit_type {
>   	/* Use the fabric driver's default submission type */
>   	TARGET_FABRIC_DEFAULT_SUBMIT,
> @@ -347,6 +350,7 @@ struct t10_wwn {
>   	struct se_device *t10_dev;
>   	struct config_group t10_wwn_group;
>   	struct list_head t10_vpd_list;
> +	char pd_text_id_info[PD_TEXT_ID_INFO_LEN];
>   };
>   
>   struct t10_pr_registration {

