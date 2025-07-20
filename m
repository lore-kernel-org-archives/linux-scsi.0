Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3021C1C6FF4;
	Sun, 20 Jul 2025 22:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753049762; cv=fail; b=OIgYvTupuX+p9CI6KA8qixkoSXIClsnsdzTg3S/+W/Q2098RY08pGbDh2OdLIjlAH5w0br6uJuXrW+6nrat7+lURTl380UrTZsNzrOd+FRtvSqM8S52JE6jvnbj5SniXRqAQmNjgx0T74iO1GMY9Kq1pd6PChLjhspVTOooBUi0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753049762; c=relaxed/simple;
	bh=REaGdtPe67tNIf5UUSN2zZH6El86JURCYNUxC6DgdWs=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gYNFh2NiIbMbtQIh7eUAMy7tM+cdEdSssjh7bTULOODrhkLgmSPtsC6OBfR+EG6s5732n6XlfX7CtJ/mel09ZJjwx5BYFqWX4Pwe7JLDJz+a97ECf5LNkwBtIOWAxEVKb02zndaTcfjF0/T5A3XZ8G/NTNYZ2540O7/AYP5ZIA8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bW2gdiTb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iTBGhF8M; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bW2gdiTb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iTBGhF8M"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56KJia5o032286;
	Sun, 20 Jul 2025 22:15:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Joz/9tKdzyxQa+ffBza/bD4tB7yZSS3jL2Io7swoapA=; b=
	bW2gdiTbGWdHUR2kZCRFckm1dx2nUfeTUjLZihTx/7DlJut9nJjPIslRca2OQgES
	wnDnJ3VH52q+7JqGujkgfa5JnCVXoPNQ9OkKZYpSc2AKBLYtxXF9EwyDCl6ws4zQ
	21HPFnmgBUETnhl9XY29TyewW9k6F7WMo62gq2uJQBtXB0/4ZQIrSUvaIZy5cwF4
	3sO9bLGW1LfH3ltQBRMNE5JU5UhrRb/A1GfEvt3XW5nuDsaLewrTEc/NE/Xvu1xI
	ULoReVIklVLMg/JhVDeXMq1lgLOQuHaMosSlxYo+SXCaLuBzHyuXJMrAMy0vnLV0
	gpAgexYqA9MXXSWxhOvIaw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 480576hgec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 20 Jul 2025 22:15:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56KMFKUq014611;
	Sun, 20 Jul 2025 22:15:58 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tdnpuk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 20 Jul 2025 22:15:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H22ClMKMGnqbRAw7KG3/VHWx0w1KyaCYhSv0NntPcwua1v5wQ3ZGOyDnhH88EZl9hkAvWIbA9nzAO9lhIMD+I3U8OOFgx8eO5UGxtWnuw5MOrcfKTTrgX7aH1F+skfI1RA32RBiUo2Z7xd98O0nS1WNgnFGnEpZMMgutjoWhtsZfh4GjDDKLMILKYPqXaoI9kfmh/oRKxF0rh4UL/ULS6KbJ5FvQSFs5bRK7+q7M2629XfTSuFmf6pP3yK746OaMVaauRSXiqDHmdKoO7TsuuKLc908WmxSjAMZDkt3D9LC9qYnhbVjDRyADhltqgFs7d6K1m3IKRQ/7iaWjvp4a/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Joz/9tKdzyxQa+ffBza/bD4tB7yZSS3jL2Io7swoapA=;
 b=UobgJKW5xmUy2tWQiTLUDjaQESIUEwSw6IQh29dxlfDgVmaeSXjxEFw5P3/YyQp2p+GYo4Afzz0d2MrFqCLjwAUOSG/SDPX6KpPLi0jJA5VIA79N5nHgMSTkBPFyAWhrEiHrSbYh/c7DS/7ngO0WWXJS0WOjFt2XR8yxAbrzcBSVZFzU6LD43B3DBVvxZvRAQGMWEh9/AlxjNdZgYgaLKmffVnnX5wW7BMdgYUMOntMI7+TrMlnsZktnpernrxAm9kCHRHRrTKZQa5k5Vxr/q2AgPfyA2I7zO+ONOenh3xBtrFMWaOlpj/tVsvv/Px0ESt6E4wzpiFzOR0RObJpGrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Joz/9tKdzyxQa+ffBza/bD4tB7yZSS3jL2Io7swoapA=;
 b=iTBGhF8MT/QXoas+JmJew5HLdH3pOaAWUFjLCejbqvcxmP6UxkE/t8Kw21jZHyAWIXUSWhLT4WLB2O68pV7j/hUab1qs31nBna4cztfPKknf4grMFJMpMsR23OKSYbqeq3gJQLkIojIDjsIcMS3jMFC29WMaGAEXA+oiiEKP+xY=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by MN6PR10MB8095.namprd10.prod.outlook.com (2603:10b6:208:4ef::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.29; Sun, 20 Jul
 2025 22:15:56 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8943.029; Sun, 20 Jul 2025
 22:15:55 +0000
Message-ID: <2eae4fbf-66ef-4602-91e0-d92838dcabe6@oracle.com>
Date: Sun, 20 Jul 2025 17:15:54 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] scsi: target: Add atomic se_device fields
To: John Garry <john.g.garry@oracle.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20241008020437.78788-1-michael.christie@oracle.com>
 <20241008020437.78788-3-michael.christie@oracle.com>
 <9e789a42-2522-4df0-8c33-db44b790a7ab@oracle.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <9e789a42-2522-4df0-8c33-db44b790a7ab@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR07CA0016.namprd07.prod.outlook.com
 (2603:10b6:5:3af::18) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|MN6PR10MB8095:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f948d34-4f83-4927-15f4-08ddc7daff4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UUI2WWM3OU5QMnorc1NuY21nS3ZkeVZiOWpLMkc1K0dLQnhVVFhVL0dEek9B?=
 =?utf-8?B?OUlvWnBvVWdQY1JQMndiVlZieUlrYm8zM3o4VXpKUWVHekxVeTF3QUhUaVg5?=
 =?utf-8?B?TDRyRlZYYkFmY2JxWDNhZys4MkIrRys4aE84SXU3bkJZUzQ0aHVUQVNZV3Zj?=
 =?utf-8?B?QzVPRUpCSlgzVnJYZE1QRXdWWi9wMFZOYjF1K3pkYUl0K21BVWFvMExlVmZ0?=
 =?utf-8?B?ZE5jbVJPS3lzVVoxWUp6OC9rQ05yRzhVMExQZlJBb2xmdFQ1MXpobWZJUkhz?=
 =?utf-8?B?aGRmMDNrbzA2TFNNN2sraXVKOUNpQ3VzMEJNOGZBVkdsZTRDekVlV2hvdXRy?=
 =?utf-8?B?RytuRlpud0pFSW82dmptcmNHV2xCcG9JMEYvWFpqT3l4SnpIelpFUG4rRUJJ?=
 =?utf-8?B?eTBGYmZYb0d3UThMRFpXWFpjVFB6V0VUNlo3THhESEtTWEZQWVN3cWxwWExm?=
 =?utf-8?B?aUZGekZpdW9Nc3BwTjFkWTFQUkRKUDMvbzNhUTBucTJEVk01UlR4MU1CUndP?=
 =?utf-8?B?dS9TRXFCQkJPZ2RxMXFlbithby9ZYnFiM3MwRmZnSDVjaGEvY3BaTmZlZUg1?=
 =?utf-8?B?ZXhWQlVYaWJRZURRaUFwSnJsTTlyUkRFaHRmczI0WW42dFRLV1IxbmdVVldx?=
 =?utf-8?B?QXY2NnJpaHhvb3RvK0FZZlR3VWVuMWVBbFBGOTdCOVhWeUowUUY3akhqd2w4?=
 =?utf-8?B?aWNmL25YbXpsS1hEWU94cGpwbUNydHJqNXozS3E5bm9RaUYvOHdLZ3BJU09s?=
 =?utf-8?B?UnNzK3NqdVJTdDJncHhaY0NyajNXaFU1RDVGY3ZYV2hweFhQclpQNittV3pI?=
 =?utf-8?B?NzFBT0M2MzNzNFU5QjhVUzg2SGxuUWR1WXFmVGp3RGhaQ0dCVzlYdkNCN3FU?=
 =?utf-8?B?WEcvTTBidzJROU5YZE1oT0Z4SWh5Snl4bjl4T1VEWTE5R1N6YnZtWGpTbzRv?=
 =?utf-8?B?OTEyQlQ0bEtSaGMwU2V2NkJ1cVlmUHQycEJvcVNNdHR5NkZidU9iZVFGZ1Bh?=
 =?utf-8?B?b1RBRnRaVGRxZXpSeFZ1elRlYzloaVJ3Wk1xMmlOSlZ0OWJlZG5SdDFDTUdk?=
 =?utf-8?B?RUc4aXh1Tkp1bEd4QmxoUWhUR0ZqWHB1VTVEbTFycWwvKzIwNytXblBpakIr?=
 =?utf-8?B?QW0vbGJUR1RPN3BYUE9qcFU3d2tBRGthdy9HNXBRUW8wSjI5UFpyTURBOGZT?=
 =?utf-8?B?Z253V3Rhc0dNdUpGNGNKUnN5UC9OTk5sOE16d3B6YTZJalg3ZDhGZ2VqSEh0?=
 =?utf-8?B?bUFySXBESjBsVXVsNjhlRDhOeE1DandTNlFuUlNNbnptbGh3cXNDc0VJR0V6?=
 =?utf-8?B?bHhiL2RxWk5IV05vVmUzcm9pN3ozVGtGQ3dsN2orQWJSUGJjQmNKMzJBb1pk?=
 =?utf-8?B?cnFqZndDNXBheVV4L1ZCYzJ1OS9nV1lvRUVHVWg2ckJwZlU5Y3FuQ1VwbkdY?=
 =?utf-8?B?aHRRV01xUWJlWVV5d0o4R2JScjdOOUV0UjE0c0tCRy9MdDR2NWkrRXlpN1NF?=
 =?utf-8?B?M2M1b3JOUUJnY0hmMVBQeU5QRm9tTjhkTXpISklwaVBCc29XSURCV04vWk94?=
 =?utf-8?B?MWJYby9SVGxXZXZOZldXdmdUZm9SRXdRQi9RcitQUThCdmY5cVBnb0UzV25U?=
 =?utf-8?B?eXlXSzVDbDVqenV1VzBuS05uR0tJclhXTGNsL290VytDVVo0TTMwUWEzTDRE?=
 =?utf-8?B?RTJlZW5hVVdmeFlXWUxWcUJMd011L2hjV3piaVJNNkVudGZVTW9pYWFQcXFW?=
 =?utf-8?B?VUpIT3BVSkgxUlYzMHB2Z2EreFpzUkVpSDRmZU4zTmlSUWxhUUVONmJVY1Nz?=
 =?utf-8?B?UEJSTXFtUVhLeDBYVEhqYlNwR3JQYUVQNHo0QWRHUmt6NDUrUlJrcWxJKzZj?=
 =?utf-8?B?QTFkaTU3bWpsUXpsYWR0ZEk3a1B2UzVwckMrVGVGR3JWbnM4M3JTcStVbnJt?=
 =?utf-8?Q?ZbqDYp7K36o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SitHaFlHOUlRKy9JaFl3OFJTRzh1SGFjSEdKOG5sVkc0V2R3bkZSamZLS3ZO?=
 =?utf-8?B?YUV0T3lNVkliUGpQYlZsMVVtbkphRndWVVpmMHM3WnpnWFVrbjV0WSttTndC?=
 =?utf-8?B?bTBjaHhSRVIrZlN6OXBkOEExWnZNeENwMWg0VzdOTjRzZERRR3lqOHBYM3dq?=
 =?utf-8?B?SERxRHRLSnhhYXpvNDYrWlZidVVJZno4eE1yaU9GcWIrajNTblFjSXVDWGF5?=
 =?utf-8?B?dEZlTFVDMTZrL1BlUkU4R1cxWkhwcUJ1Z2grMlJNa3prQ04vZ2ZWSWZQVThJ?=
 =?utf-8?B?cnkyN2NZL2Y0bXpnZldFb20xbnlwRjNFcHRwRElhNHFkejB1YllPSE5TeFAv?=
 =?utf-8?B?T3JpYVdZenpmSzFzdC9YT0NiUWQ2NXM3YSs3Y0JUQmYyYUo0OFp2VW9OUndx?=
 =?utf-8?B?WlFlc3BNdzRMcTl1WHhINHJiNnprV2Y3U2lUa1hQemkxSUFiYlZhcXpiWkhk?=
 =?utf-8?B?amlBYjBRVDZtVm9pZHlKUnp6UVZJR0Y3OCs3QUJpL1d3cm9rcGRkOCs4RG5Z?=
 =?utf-8?B?REtTeU51Tjc2R1EvcVI5eU9BTHZ0aWJqbCtkNlpqdTI0bUVnZjRDcC9jelhH?=
 =?utf-8?B?SE5GT1FHcVZiaDQzdjNvWlRPcHpSRXpwbnpoZmNWc3VjcHNWOEUyTnZTR2k2?=
 =?utf-8?B?YWNWdHpuWlpvY243M0hZeFFtak5zMWpnQTJZdHFHaTRsRHQyR1M1QkNxdXQ2?=
 =?utf-8?B?dUJ6SGxOOExjT3BoZjVGRDFKNDdYV2NyY1U5TFc1dkNWZURyRTZtTnh5WlBV?=
 =?utf-8?B?dlRKT0M3K1BBVitVb2h2VVJMUGN6N0JHbGJFNGRBejliS29kQ1llZXFEQmJs?=
 =?utf-8?B?YkwzaS9vRzRnbDl2Rnh0VnFBTDRCRGRLTGd0cHVZN3ZmL1g4UHdRTlQ0bzRo?=
 =?utf-8?B?bmxjaVZjcUlJWGpVNnN3eUdOeVRORnd4dWNEcHlGeDZVRCtMQmhZTStsZ1VY?=
 =?utf-8?B?ODRuS3FXUmF2M25zNkt0VExkV0U5ekljWWt3d0I1OEtNL1dtcFV0TGptWGtx?=
 =?utf-8?B?UEEvZllHaDhCbmxlSUxhNTlWN1U0eXpOOTBCSUVUVmV1d0lpSXB5K3czYUt3?=
 =?utf-8?B?VUJ3N2dnOHZ0YzJlQzl2aklBNWZaOTVVVmhCVmNGamQxQVZ4NzNJeS9SWGpl?=
 =?utf-8?B?YlczdGxsWDcvSU1CRmFValBaVmorZUVBNmpUTTNGeDZZQ3VzclZlTXl4U2xs?=
 =?utf-8?B?K3QwaldUbjlvZExGZVM2YjVPUmpKbzlkMU9nanpHU21VTFptRkVYYjlURWl2?=
 =?utf-8?B?UDNKU2FqQ1B4VzRXTnVsSUh5QllBMTAxUUxOYU04TmEyV2pTMWlDRTVpTFVH?=
 =?utf-8?B?OVdsNFdGY1d3TnY0WXYrcHlGOUhJZ0RHSjludnc1VUdzL1ZJSkRpT2lWbzd0?=
 =?utf-8?B?cWcvazQ3VjlpOVRjbEM0OHFvTllPNFNJeURXcFE2WTN2LzJtOHpFTnBiMEg4?=
 =?utf-8?B?U3hibDYzVTNNVWQramhZWHdaaUFrZVNTTysxQndkdlNJZnZNblgvaUtTcjE2?=
 =?utf-8?B?UmJSUWJPVTQ4NEdncFFtVXhjcUdwVFRocDR5VzM1d1BrVi83a3NkU1pBUW5m?=
 =?utf-8?B?OVZHQXhQSHdPd1J3SjJTOEQ2QTNpU0FlREQzMTRnZmFzMmZ1Sy9qcHNncERM?=
 =?utf-8?B?d2NINmZnMjdlWnNocy9jUjJpc3pPZUVsN0lNV1ZQeVhVd2poQVpxZUZkalR4?=
 =?utf-8?B?bTFPUWhsbUpMSzUrcUZUcmVPbVluR0dCQ3RGSjhyMy9WZWdTblMvbEpJazFp?=
 =?utf-8?B?clhucDVqVDFob2htNTVkaCs0bS9sV3N0amxvTUhnRGhvWUV0SVR3K01ndzdL?=
 =?utf-8?B?aVZjaWVkRFY3ZHVPUzVtVmp5RU5WWDhkYzlxSWF1MnpnZldXSURhUXdvVkxB?=
 =?utf-8?B?aEZWSjlYRW92TUNLRCs1c1JqT3RPODFudjRWOFh6cmIvaUp4Qk1kS3ZsQitW?=
 =?utf-8?B?SUpBbGJwbmFqTVRnWU5ZVTN2ZHVqLzB0TnRsVWFUdmF6YlV3aDdiRXRBYzNQ?=
 =?utf-8?B?cFlTMEljVk9RSXdNaFo2MnRucmNPSWwybVo3clhsSmQwaUNMcVErVURlQWNp?=
 =?utf-8?B?a1RXcWdGTTVDdDBONWN3L2F1ZzJITmFObWpLN0NieTBkaGxhYldxWmRkTmdM?=
 =?utf-8?B?ekZMUjBHMGxyRkV2WEFpVE91ZUx6K2k4a3daZTBnTitXYy9NcHJMdnRjTGZ6?=
 =?utf-8?B?TVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	H7kPveozhczmL6Tg0rRrW3h2qDrYGNAaJzbbLtR9tQSQ2Y1Jz9FAGQJfllL9XL/bEayEhAT03NvbHeerfKnuVYhHJDJpXHSsX1wmfHllh8Eqb4LZwdAlUQRUKCrarpWDsgQvX1AnRVVAEGfrfOK0WPTad4bjRgH+fp006VwieKYWwmz6l3wMS+pCyFVR7fySc2cCHeeNJRiz6iXU1a9SKs/bBuiQzijPXjobh4glcIGbSD9bMKOu8rKEmfneG/IUFcQ0gDjw3FvDseynyFFuzzvqtbmC4cBaTzrMrmzEnPnX+SKonEuNvafo4VQ8ewTNy8izFpqYFy4bVoY8YxSzSi1awz3JgQzpZF8drZPiFFuVFUKj37w9PLU5F3iUyieIRZ4KxkwJsCMQNG24Sfz0LGdC1U+06/ggUt9jEgyoz3TpKVdlii0+ibgjmuR3GnMo7B6E7fvo4v5gQWAn2fehNJmOuy8JGLdYu90IIqQAavdCAgeHU1sk2zSsaaIyOHxKNXBzqrgmZ3KMOtwRfaTJz+vHDS2MfoAe5Oj+5V8K+nBSjuOKRCl7aZXkgL7Xrt/z1lstGFavQBX6zc/uOX4ls5kS63mK+VmvU8GYFsT1Quw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f948d34-4f83-4927-15f4-08ddc7daff4a
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2025 22:15:55.8547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LQgyN3xNZIctQH4gHuj0OuV5ZkIR0GmmMEjLGMrSow889TYnKx0Q2mNTZMKMVMapyzGVAcQrl8BdN917kO9cJm37E6K+jNOBK8bgqp7pNtc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8095
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-20_02,2025-07-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507200214
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIwMDIxNCBTYWx0ZWRfXzH+17XIGOqsA
 CLg4Z7SK6DXcjvnDv//u/zlehTygmmZJkdCpoFWjfN01FIEmrpk7Q8NGrqlpBCYHf49fuoUMl2M
 PjWd1JyLK0nziVJPWHWO3MJ3lzI8xKKEBQ0bk7g+HyGPJv/6VeFWAhIE5mctpW7bPqC4rvO9aRo
 05kv5uFsJNrdzK1RMoxoSZUjAjBop1FqcIsnKkyMn+dlS3jtf3agZwExYQAnIBEYEZkOhlt6Wei
 GfSkLojb1i2cZd3X7/DoaKIfbc12dtV79+FBARVRy8CNcm6YDIp83A5KYZNqvfvXhw0ZAmRnNk8
 Iq8xwOQl7p6jrCini/nyogeyeTMi56VAeZbET/xqv1UF56AVAX4+qyqCiOy1odu1ddsGqNeac/O
 e3tEG+gJdy/7aR2rogR7C/sJhR1KsyazZSTuhL8qFpG2KwP0YteSvQFK4FZoLh3gF5lgstdl
X-Authority-Analysis: v=2.4 cv=doDbC0g4 c=1 sm=1 tr=0 ts=687d6a9e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=yPCof4ZbAAAA:8 a=ahEf7ioQh_h2tjnAcPkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12061
X-Proofpoint-GUID: LjIV8c7LX-SQQQcjsCcfutfN6mkdyEOz
X-Proofpoint-ORIG-GUID: LjIV8c7LX-SQQQcjsCcfutfN6mkdyEOz

On 5/14/25 5:26 AM, John Garry wrote:
> On 08/10/2024 03:03, Mike Christie wrote:
>> This adds atomic fields to the se_device and exports them in configfs.
>>
>> Initially only target_core_iblock will be supported and we will inherit
>> all the settings from the block layer except the alignment which userspace
>> will set.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>   drivers/target/target_core_configfs.c | 42 +++++++++++++++++++++++++++
>>   include/target/target_core_base.h     |  6 ++++
>>   2 files changed, 48 insertions(+)
>>
>> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
>> index c40217f44b1b..f3c7da650f65 100644
>> --- a/drivers/target/target_core_configfs.c
>> +++ b/drivers/target/target_core_configfs.c
>> @@ -578,6 +578,12 @@ DEF_CONFIGFS_ATTRIB_SHOW(unmap_zeroes_data);
>>   DEF_CONFIGFS_ATTRIB_SHOW(max_write_same_len);
>>   DEF_CONFIGFS_ATTRIB_SHOW(emulate_rsoc);
>>   DEF_CONFIGFS_ATTRIB_SHOW(submit_type);
>> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_supported);
>> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_alignment);
>> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_max_len);
>> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_granularity);
>> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_max_with_boundary);
>> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_max_boundary);
>>     #define DEF_CONFIGFS_ATTRIB_STORE_U32(_name)                \
>>   static ssize_t _name##_store(struct config_item *item, const char *page,\
>> @@ -1266,6 +1272,30 @@ static ssize_t submit_type_store(struct config_item *item, const char *page,
>>       return count;
>>   }
>>   +static ssize_t atomic_alignment_store(struct config_item *item,
>> +                      const char *page, size_t count)
> 
> What is special about alignment that we need to be able to configure this?
> 
> Won't that be derived from the block device queue_limits (like granularity)?

What if you are not using a physical block device like using LIO's ramdisk mode
to perform testing?

> 
>> +{
>> +    struct se_dev_attrib *da = to_attrib(item);
>> +    u32 val;
>> +    int ret;
>> +
>> +    ret = kstrtou32(page, 0, &val);
>> +    if (ret < 0)
>> +        return ret;
>> +
>> +    if (da->da_dev->export_count) {
>> +        pr_err("dev[%p]: Unable to change SE Device atomic_alignment while export_count is %d\n",
>> +               da->da_dev, da->da_dev->export_count);
>> +        return -EINVAL;
>> +    }
>> +
>> +    da->atomic_alignment = val;
>> +
>> +    pr_debug("dev[%p]: SE Device atomic_alignment changed to %u\n",
>> +         da->da_dev, val);
>> +    return count;
>> +}
>> +
>>   CONFIGFS_ATTR(, emulate_model_alias);
>>   CONFIGFS_ATTR(, emulate_dpo);
>>   CONFIGFS_ATTR(, emulate_fua_write);
>> @@ -1302,6 +1332,12 @@ CONFIGFS_ATTR(, max_write_same_len);
>>   CONFIGFS_ATTR(, alua_support);
>>   CONFIGFS_ATTR(, pgr_support);
>>   CONFIGFS_ATTR(, submit_type);
>> +CONFIGFS_ATTR(, atomic_alignment);
>> +CONFIGFS_ATTR_RO(, atomic_supported);
> 
> isn't a non-zero atomic_max_len the same thing as this?


I separated it because like above I was thinking maybe users will want to
use this to do some testing. So I tried to make it more generic.



> 
>> +CONFIGFS_ATTR_RO(, atomic_max_len);
>> +CONFIGFS_ATTR_RO(, atomic_granularity);
>> +CONFIGFS_ATTR_RO(, atomic_max_with_boundary);
>> +CONFIGFS_ATTR_RO(, atomic_max_boundary);
>>     /*
>>    * dev_attrib attributes for devices using the target core SBC/SPC
>> @@ -1345,6 +1381,12 @@ struct configfs_attribute *sbc_attrib_attrs[] = {
>>       &attr_pgr_support,
>>       &attr_emulate_rsoc,
>>       &attr_submit_type,
>> +    &attr_atomic_supported,
>> +    &attr_atomic_alignment,
>> +    &attr_atomic_max_len,
>> +    &attr_atomic_granularity,
>> +    &attr_atomic_max_with_boundary,
>> +    &attr_atomic_max_boundary,
>>       NULL,
>>   };
>>   EXPORT_SYMBOL(sbc_attrib_attrs);
>> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
>> index 97099a5e3f6c..6c87bd018983 100644
>> --- a/include/target/target_core_base.h
>> +++ b/include/target/target_core_base.h
>> @@ -715,6 +715,7 @@ struct se_dev_attrib {
>>       bool        is_nonrot;
>>       bool        emulate_rest_reord;
>>       bool        unmap_zeroes_data;
>> +    bool        atomic_supported;
>>       u32        hw_block_size;
>>       u32        block_size;
>>       u32        hw_max_sectors;
>> @@ -726,6 +727,11 @@ struct se_dev_attrib {
>>       u32        unmap_granularity;
>>       u32        unmap_granularity_alignment;
>>       u32        max_write_same_len;
>> +    u32        atomic_max_len;
>> +    u32        atomic_alignment;
>> +    u32        atomic_granularity;
>> +    u32        atomic_max_with_boundary;
>> +    u32        atomic_max_boundary;
> 
> these will always be zero, right? I don't see much point in even storing them.
> 
If you use target_core_iblock yes. If you use some other backend then
it will be what's set in configfs.
