Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807A536E464
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 11:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768563530; cv=fail; b=Uk07h8WgdrgwF6UzcCSfW6jNbgIdU9VFN6F5cvUUeM2+ihFL0IM+MNpJh7cteEbO5gd36vx1DJzIjz3h5cHPZiNT4L3PFB7l9zyfWRHknfmMG1mFpBvHqO1pHB4eTwCjCt3UdnU0E1hxRWf8+upb0EeN53H4Tvum6wg4/iiaWfY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768563530; c=relaxed/simple;
	bh=6xvCueggogGPXxNpVY0iAGTo3zgZT9TJGzdIc4HBZts=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gjfpCXFN6mErBxjfMYyVEGeSo42aXi+LvKu39YaVCCaZaAr3bp8xP2f+o73HaPFktXo8HRv3f+Lb91MU+BFmEtkHYrxm7plz14SZd3O7vVjJEZpnBEvOJsX9Yw/CAhuzhYRl8ouGnfZoBrxTmXn0K9ktmLJIZYMiQo+l6xLX2A0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RJ5XyO5+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hrWxeZmj; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RJ5XyO5+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hrWxeZmj"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FNNVxa1738322;
	Fri, 16 Jan 2026 11:38:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Y2PzCSlYRltz5lWL0JaSnxd7r0PPUQMpDG+JbjXRdsA=; b=
	RJ5XyO5+OvV/dv44bGlYTNSw/rJ+soZMZYToqQQn6ScUrnSk6uFvpF4japAnwmRV
	TwewkxSlB9lzlVkDtuvzwxdHGeuOb9BpaHRErSHpuLopFL9akK6y9II8/nrve0us
	2lSeagkmjjGUz/KcBZPvcj0rselLUAw3xyKDWo6me8Ud6R0nZvUifae1N/qbojqb
	b03igQRhdVlYeevuDO1oFDkgwfoiCDodpTC98Tky8/RR+N1DtzbsknQUwdi6aZjM
	mgjCjlQ+8wRLuxXIcOnObazI5S7STTrjap6T30pe1iUbWnJK7ohgwKnRrI/QBFzl
	qFQOSHdj7Z5XYWjL7jzu+A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkntb9ttq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 11:38:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60GBQvIV040481;
	Fri, 16 Jan 2026 11:38:39 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012012.outbound.protection.outlook.com [40.107.200.12])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7gkbjk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 11:38:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wgA6URk6YAN22QazQDE78/QHyK7zoNcoNI464ciHcy9nnX93G7MVrUOgXP2jvhdKSRgo1gLPnNlSmKOG7FwKkKvSa0r2nfO5LYujAQcLJF3hP1m8oVyOx6GXk0N5iXw75tPq/uy7M4nD57Zqlrn+meg9ZGKugVbWSAFXDLE6rQV8EFnSHnwQkUTaImKOBQ7bFzarSMZHzuhS4H/dQ/gaZcd0JTH/putkf5cXB9HFt0znOvD+xkwmYYAzf0muOBLeS18qpOrSRjEiqT+ujWr6brwkmhsCxN2NJlcUdgoIg8yTZx+VOac69UOE8fay+HTmSUNsw3gtEZ79A/uHFqqgcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y2PzCSlYRltz5lWL0JaSnxd7r0PPUQMpDG+JbjXRdsA=;
 b=vJeFXojlatUaqwYBx0TpG6lNHbnwfJ29fKLpCsnDZBoKR6GP3kwuz/H6GzHIkNomntGN7kcUbP+SWcsSS7g/SRnzu8PUQGz8/aKLoJl1oD1uGEwt8fFt5NlFZenIA2FM1vjn5XZxsaZRMKGN/BgvyjNmDaCZvaNNwdThsatY3t7618fsoq1SnBy/HYZK7hX0Lj+xv7TmO9GR24jJUznH5lion00r4r8Lp1XQxB7Djbd/7PgzotS0Pz4o/6V6eFDK4CO/QP2S/0LAOUkIH/pKFM6c1LcFGtB8x+/K4Hsm6zWNiWh6w5MPpPl+o35Hdhq23rMjBoMSCqHu28D9ZoaFZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y2PzCSlYRltz5lWL0JaSnxd7r0PPUQMpDG+JbjXRdsA=;
 b=hrWxeZmjn/SwxXOb/0pYSyJCJwcq7FAjXtK8XbT8/BlCQEOjScKX/KU11wfKelwWNjF9UQqWLHyhWTYM1YbVqxEpJjX6ezEQFaPhhmQPkKW52lPy9QUXEu24ErGyA3pQIxAh1WuVXt3R3gBKfxOna7TeSSfhnajgCwzWzwJeGNo=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CY5PR10MB6096.namprd10.prod.outlook.com
 (2603:10b6:930:37::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Fri, 16 Jan
 2026 11:38:36 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861%8]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 11:38:36 +0000
Message-ID: <31a76a30-d948-4677-8aa0-4fa12a45ae11@oracle.com>
Date: Fri, 16 Jan 2026 11:38:33 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] scsi: aha152x: Return SCSI_MLQUEUE_HOST_BUSY
 instead of 0x2003
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, "Juergen E. Fischer" <fischer@norbit.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20260115210357.2501991-1-bvanassche@acm.org>
 <20260115210357.2501991-2-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260115210357.2501991-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0331.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::12) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CY5PR10MB6096:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f626dc7-9e3c-4ded-a5dc-08de54f3c926
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cFV0a2p5MExlbVhwT0w3dnlDa0gvN3ZBYVRWOGZuemFCSy9iZlZFeGpNK3pW?=
 =?utf-8?B?M20zNFl0WmNPdHIvL3o5YTI3Z1VpWEhEK2ZWcXlrYnVieUlhT0FoRlBHR0lj?=
 =?utf-8?B?MGZES0g3ek10cFI4bUVpcVFuK0l5amIyQWhKM1BVZ0FhbnFTQ0dMWlBWWnlD?=
 =?utf-8?B?S2N1cjZoYzUxQlNvWERiMEFZalF3RHY1VlQ2RUExNHhBUzh1dGV4UmVKelJL?=
 =?utf-8?B?enFnTDhFcDhIempBRjhKeWZzaXpJek14ZEpnNVhveUJraC9tSjM4LzRwYWlK?=
 =?utf-8?B?UGlFV3VZWXd5bHpHNTFFclRQVnFNb1E2ajZSZmlQak9kaHNIUkhjTlh4MkVF?=
 =?utf-8?B?M1JCUStoak9WOGdhT1dKM0ZDMm1jNDdtUnhydjdKaURwSDF3WmdFU1FyUVo0?=
 =?utf-8?B?RDBQNVhsS2hxRlZwYWpkYXhZd2tnbEhPVGR6V1RBOXdpUC9nVTlBTGg4eU5j?=
 =?utf-8?B?d1FMSzl1cVJqaFBjMDB2S25sTXVOTVkyOXY3YlhvWDQ4SGZ4VCtXR2NRR0NZ?=
 =?utf-8?B?OXN5U2VHZkUyQ2JoMHhlcHhWS2crY1I4VGExZ052VWNIMjlyVGtPaU1taFp3?=
 =?utf-8?B?S2hQVGNrU3B3Q0JZUy9IWEs0UlFJVmE2c1BOT3hSWml6d29OME55NzZNc2Jl?=
 =?utf-8?B?WG9LOHdyNjhEVU91Rm1vZ1JrYkdmcmoxeTh6S2EyTmUzdnR3cGpPT2tQSG0r?=
 =?utf-8?B?dUVmbmtJL240ZjhSRk5PY0daSGVrSEgwTG5vcm5MWUpMdGRHb3MzSlNBMWlp?=
 =?utf-8?B?di9RV3dRVHdBWTk5eFRmUUp3VmdMZGtIUE1jdVNSRkV4TlBCYitCYmZGNCtv?=
 =?utf-8?B?ZlhsWVpyWGUvZlI0S1VNNkRyV3F6Y08rYjBSSWROeEtnb0lRMDFNWVBvTFFM?=
 =?utf-8?B?K3hDUkpTdWcveEVwaC9kbjJ0M000MWJlZ0Q4czY5M1RaTndINHBiQm55U0dR?=
 =?utf-8?B?YnBJOTg3L3ZFeGxmdWtPWFhnMys3ckZCZG9wSy9BZ3pRVXlSTWRLZndEVkc4?=
 =?utf-8?B?N3dRQWRMZndyWXdhVzZmWi9SN1lTNzQ2UGdYek9UeWlPcDlBRmxJeVVBRVlo?=
 =?utf-8?B?bElCQWNENTEveWJxSi9NRTRPTXh5L2w2RDRtS0o1N3dDNDQ2VU4xTG1RRDkw?=
 =?utf-8?B?SFA5NmhMV0l0WUpSMHAralh0OWlDdWxYU0Z5VXhURFZwZ0ZFb2dBVnpuNkgz?=
 =?utf-8?B?K2h6bUphdkVlQXI2elZBTjRWODBtTGc5TGxBbnRKWHpSN0QxN2xCeGF4b0Uw?=
 =?utf-8?B?TUZVU2puNkt3WTBXNnBMNHYvUm9Wb0ZIT3FjSS83UHJBUWFqZTd0ZXNxMGZo?=
 =?utf-8?B?MWhMZWlOdFJ6V1hTKzFzSHVQYkdrS1UwYW00RHpoODJMWlFCVVYxTkx1K2xS?=
 =?utf-8?B?UXMyM2gvN3lwTXFFcjQybXFaNFhCTXVQT0w4eW1BajZRR2dJU083K1N5Mm1Q?=
 =?utf-8?B?N1orVGNuQml0TWNEd1VDYUtDaUZiM01LbUJ6MFkvZGRlZ3pVdXl5dmxNQXFC?=
 =?utf-8?B?UlJwMUsrc3lkTHZsVDBFMFo4SVIxQUk1US9yS0piempOaG9pYThiRFQ3RDhS?=
 =?utf-8?B?Y2lRaFBXbE9ObXhCZFhVMVNINzJ0UytNQ0V3bWxrNkIxUzN6WlVaNWJkV0Vl?=
 =?utf-8?B?M2RzMS96SDUvb2ZZcEVocjlaL1pDNGl3Z3hJaTU2M0VrZjRMUUllT0NkNlI1?=
 =?utf-8?B?dTErMlBBeHUxMnpQaGpDRkc0Q01WM3plbDZia2ZQOEtNYm9SZGk4YWxsMkF6?=
 =?utf-8?B?dDFqU2hIOC8veG9NSnZZYXo0QlEybDNiM3ZzZHp6aGphRER3YzltSTJlTXVY?=
 =?utf-8?B?QUxrNFZBU1B4MWVjbEtTRjhka1RMME9WRlBSM3VrM1EwUndSVE9FbVZJUjFJ?=
 =?utf-8?B?ZFRLbTlBTjZid1dwamNxR3BuYW93TjV6czIvRFhnbEVBSE9mRVFRMzNZVnlv?=
 =?utf-8?B?eVVtWGpjcy92bno2aGl4R2QzSk5CSjBqL1MxL2pRaHJ2N015TmppMXg3UWFL?=
 =?utf-8?B?SU9QRHR6RW5oWE9xY3Zqd1dad3RtU1Zxb2Noc2lTNm8wTXBjRktsaUwzMHV0?=
 =?utf-8?B?WU81VE9pcTE3RW9TVEZ0TGZQUlBqbE95UVdLWGxqUWxzM1pmbmptN2twY0Zy?=
 =?utf-8?Q?PS6Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?elEyT3VZZjQ5YTRERmZQTjBjbmREeFVtZHU3OGNyZmV4L2ZnbjFQWG5vOGlZ?=
 =?utf-8?B?RmR5OXNVL1JsN05MY09FR2toZEFXZVliblkrd0txbzlpN0RuUjhMc0J0YUpX?=
 =?utf-8?B?cFgvM3IwQkY5WDB1U1Q1OFMzRy91RXhOSy9qS2VXVTZqc29yRVhsa09zaUow?=
 =?utf-8?B?SHlHaDgxemlpUFdleVZDaU5QdmZaNkE1eTdieldTQlg1aDdCZUNFa3lyUTVG?=
 =?utf-8?B?OXFiN0tMdVlOOHBQbWh6K2hValZ0eUsrRDNwYWhTMXhsMWxCUzNGcjZaNU5R?=
 =?utf-8?B?bWpiZDdlMDBaVFFVaWxQUS9tYWp3UHZaY1FoUXBqZENPMlRMbmVWaUNrVjNB?=
 =?utf-8?B?cjZWeFN4eVNtUjVZc3VkYWhmYWtrSWdQMlFjMXh0dFdOSG00SVdueG5wTzhX?=
 =?utf-8?B?c0pGdmsxUjhIOVQrQVpxNS9jNnRJcGt4ZlRRK0Y1WnRXMUx4MnU5ZjBGVmJ2?=
 =?utf-8?B?Nm5HODlCdHJYZXdNbEJKNzFiRDRzZElBZW1LY0t3V0ZGSEQwZ0VTVThDcXE4?=
 =?utf-8?B?SXFxZ0hNeXJ3enVMRUNMSFdsS2M5QU9HV3RDNFFaTzZKU2lBbk5CVnVQdlQw?=
 =?utf-8?B?YUFZMWI5L2Rkek5aSnh1OUZjcDV3K2U1M3ZUbHRVbkNBbWlQYVNPK3VFbnNh?=
 =?utf-8?B?WHp2NnpKUUgxMk1PWU1NNGdvdXlHeGVCMnVtOWVSamVHNUtZRUNmRENtRWhG?=
 =?utf-8?B?ZnlCUXNab2RCM2dmYTVlN3ZaQUJLRkduVStLU1UybVRnUFJvTUVhWno2L3dh?=
 =?utf-8?B?Y0t3S1FMWURPZTJUd0hzR2MwSHQvZ3huREpTbU4wcXdWM2htNVpBQUE1QTZl?=
 =?utf-8?B?VmZkZXd3NXRNTTM2eGdhNFlsTVhzR01yZlhxVjhnS3NqOEJyemVuVEZnMmtX?=
 =?utf-8?B?S1ZQbk1vZlowZ1g5OUs0VWU3THByc1RwR1JicmYxeHB6dUNHbkkrT2MxWFBH?=
 =?utf-8?B?YXlLc3dYK1JqbnZqT1ZiNmlwZHh1aDNKeE1oTE5SMDRBc3FrUS9paGlyTXJV?=
 =?utf-8?B?eG02UVlvamRpL252ZUZ6ZEkyOWZrZ0lCMCsrV2V6Y3pkWlZUSG8vZVdJRXpz?=
 =?utf-8?B?a1puMXpnd0lkY3I0TFpLVVFVWlY4VU04RVh6WFZpYnE0M0FwTHp6anhKa2Fx?=
 =?utf-8?B?WFpRQi95NmVUeXVnN2FRR25HWlVNTTV1b0VVUEhpc3JoVk5WZ3RCNFRralNP?=
 =?utf-8?B?NkhZbWhpSmcvNU9ySHpPdVpsUTBaUVVFWlg2MHo2N1RpaDlWUmU0VmdNcG9r?=
 =?utf-8?B?eVUxcThKb2VMbHprOXZqZm9NajQ3SGlaVHc3TGNxS3dYcU1ON2JCSGVmR3Yz?=
 =?utf-8?B?WHoyTFJlNFlHRC93NmZIclA0ZnZ0VzZab2lmcEhac3doTkZEcnk0c1IyV09D?=
 =?utf-8?B?TUsyeVZxNHE3Y2tweTk0MzQ3SXVGWTdQdnI4dloySHlZU3VHZ3R0cVpXcnZG?=
 =?utf-8?B?dkhjU1d6ekRJdGJuaEZ4bUI4dTFyOWhkSkluY0EvTWtZWEIycmJ3NGMrSmcz?=
 =?utf-8?B?MForTVd1QjdLMWErYnc0UVZnZ0s0b1pGQjJ5NCtFV2lzanZwLy85NTZ3bUo5?=
 =?utf-8?B?NmdyVGRFUzRxekhYdEV0VXpEK29OYVVheVk0WjBjQ29GdUEwZUpuVzNYbEp3?=
 =?utf-8?B?dWQ4bjAvNkJNQk5ieHRxRDVNRGg1a1oyUGhIM3dXZ0ZHYlhHeU9JWFhuSDQ0?=
 =?utf-8?B?cEhOVVBkZW0yTGJBWWJFaGhNVVRQN3F4N1JjT3NPV0NVdzlaM1ZwWnl5L1hi?=
 =?utf-8?B?d0R3WHNuNWhqQzI5a2gyTmV6ZVlFNUhCWGRuYzE4bEFhKzI0RlpOc0x4Rzkr?=
 =?utf-8?B?b25XU0lCZzBueHdQM0JNN3FNa21rWmRPVktpV1pEOVhVTFZrNklwTStyRkRR?=
 =?utf-8?B?TkxHenhSUTNWbGgzSENTL0pkcUNiMllteDY1S1BHdGhkaUdlUHorOVdEaEI3?=
 =?utf-8?B?WkJwSTFBT0Q5RWhDRm9zUWJId25nYmtPNWNSbWpBNjlLTkhpVC9oRUFrV0d3?=
 =?utf-8?B?cUZHbThwOEk1cTZ3Y0dkc0x2ZlczYmFReTFRTmZQQW1teTB6bEE5NzN5K0Nt?=
 =?utf-8?B?Q1V5dE1TR1MwWkFkWEZMZ2dEcG1FdTQwU0doZjVDTEFpcFVyUllnbTJCR0dC?=
 =?utf-8?B?NmxvMCsxUnJIbkJQYTgvTXQ2cEhyWDhWWmN0NnNaRUY4MmJHWlljZ1ZkY2xx?=
 =?utf-8?B?VGZBUGcrcG4xVHYzWUhhc1lueS9FZWR5c2lNcWVoemJwT2N2TkFQRzJhOER0?=
 =?utf-8?B?YVBMaVFBcW80WE0vWFBDd01tZjVvRWd6R0RaN2paMlVHUUdqb0FOVjFJT2Qv?=
 =?utf-8?B?OUROQ0dpRTRFVVZhTldIQkQxS2xqbXQyT0kvc1hxOWluR3ZVTnJkdz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+o6Aritt9uEPrP95IDiUvslWFd57JJnH9ssgFaCL+ZV0EESah67L9ruLzot3hIrBBAKNPkhuC2lxwYWUBOt/7G44wBB0yI8/+AVjZ+j/8pFf0rd8n6Gm6uOyYjsCueTi7X2q9PZxPKfRJXli/3JumFTZF1ptfBzAzH5cVObAo69T5iInDeqR+6FmEVWYuz+VvChCVVxgW5Y5mZmDyO8xDvEBArQictgmzhUy+M/SaKwYkD0QMdjtZuWgMwdg9edqc+EIjqJW4BDB6fX2j5oHk9Ctn0UBdHOae4gBZ743pJYmRPAe2tWBlVmo/PnUcGViXdtGz00/xdFWsSIJMcq7gC+1TDKhy3eoItYuV/eJnRGAXV24RmM+NzRisQXQByyJ0UEwhcMMAjkCjj/pEjwWG/KOTVoAGfzTRxJ7+eMNuB19XL0o33wQwhTu/j3/Y40XCOMTGyT7m2CgYzxJ5iV3/quHP7eSIsmMahfwHbe0+DkkMPc/gIA4JROu4B2uODTL5qJ1ipBFKFKeCvBp2oK54u5GXc+YbROy63WMsCb04OhKzK08SHXTnKj78Zetdcjupgowt+iHhWYmgSnJ+ggUdejcsOCbku7AstBjxuxHaYI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f626dc7-9e3c-4ded-a5dc-08de54f3c926
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 11:38:36.4276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hldqwyYwl+5HgVUvn05uu3YdVCkS8LvH7hpet/jTYZkbwwJRb5intiZ6HpfKWvbyFvFNlUQRyfJwkZZ/U+gb6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6096
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601160084
X-Proofpoint-GUID: GPDgOxfCo8E0yFrFp1KEY6weIrsYJOfs
X-Proofpoint-ORIG-GUID: GPDgOxfCo8E0yFrFp1KEY6weIrsYJOfs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDA4MyBTYWx0ZWRfX1gJ4+9kXjiGb
 R9nzRdKpMSg1PEVvaDlEplS6fslqJmISh+noLgZU1pl9cgSFs4wrNy2Q3vHIKKDRAoMDCIUkiJ6
 x0beIQEzsRiRWZUsmDqh25LSe6x0MnZOJAKI4b/c+bHWCsaI0oBTAgMhujRxKXfYSCP2J5umOHW
 w9+RRMf2C2X/RwEnNDSl1PMPIPxANPhdYGaAyC1SSBLFnIK7xfP9I1U5yNLluCxBjTT1G4eXn5d
 3KGqBJVmQoN8wxRzf4nDEX45cRIFJ3jPCho/XbHqc//ljPiLovsBAVTI+hHvyT/MMARELIc+CkT
 7u7yYE7qyn4/JA+Ka97hjftEegcWKEPae3Az0mzK4mX4AGt9YLKXzqUOKxN0AjtbvZkBnfJUvg5
 CeVx7A0COVwjNdcATLBTX7CY73I2b+pg5Y/mgy1tQDnMwuLFVGtO4l0tv53Vsb7pwYboJGQqkeu
 ECx8s8NvQ70xifEw5glr8uN7a8jw+l2nZx04azgI=
X-Authority-Analysis: v=2.4 cv=fIc0HJae c=1 sm=1 tr=0 ts=696a2340 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=N54-gffFAAAA:8 a=yPCof4ZbAAAA:8 a=CDYvOT1307i0KV_F1-AA:9 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:13654

On 15/01/2026 21:03, Bart Van Assche wrote:
> .queuecommand() implementations are expected to return a SCSI_MLQUEUE_*
> value. Return SCSI_MLQUEUE_HOST_BUSY from aha152x_internal_queue() instead
> of 0x2003. This patch doesn't change any functionality since
> scsi_dispatch_cmd() converts all return values other than SCSI_MLQUEUE_*
> into SCSI_MLQUEUE_HOST_BUSY.
> 
> Cc: Juergen E. Fischer<fischer@norbit.de>
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>
