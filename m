Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0362F7AD5
	for <linux-scsi@vger.kernel.org>; Fri,  5 Sep 2025 15:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757084559; cv=fail; b=J/ld5Gaa3iqiPEth8y7uZdl0bH+KYzQelNtZszsHwwrbXz/pkHUAvMes64NxjSExfUoTQbPg0CQevA8eTdn91qoB4Eh8nQBzmcsD7axn3+XC8wwHvLUiLvPuqqAQ8Byb+wLp68DV2sDJF6FV24AdqqLmx5nJbOt6ptB1/ula7FA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757084559; c=relaxed/simple;
	bh=uiFxZyauso/Cu/zb7fjM97KaE73fx8aM1DAVjOfDGOI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DspHNQwgc2SSiFlJOCL+IRnU/51CrNC5I3qqqSHlfBwdGiQJv6Lzo8FY/9db535BOhg8YWe/V5iv+TgeujhvJobnzJYGpq+Z/THo9qoQ3UPzh/GIh1GPx31zw5f0p0J4FbpjivqZcnZFv/93SN/PG+jIVi/2DOxbDgEzisJbR7I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=N00vVBfj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=N0d+npwF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N00vVBfj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="N0d+npwF"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 585EMkMd025151;
	Fri, 5 Sep 2025 15:02:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=C1bUSnz5wtzQPlwW2gpWC/4+LwPoB5JOja9F0mDwaJw=; b=
	N00vVBfjKY75GCYCn+K5mOfCWUaxZscbQeAQliTVZpSxF+9LXq85phx444ofpEqn
	vYkK2bjW/YOMb44soeJlCmsQCBVqCIyVRkau+pvlTAX+j7cn7/UVmkOts3UCvywW
	djvIQt2kfHNlUB1vUQMaYjVRYmnnur//E9kLEopWVydfsd9n00eUKJQw1zRnA2AE
	wVadETndJK/2rZ8bb+ARCQDwx9+2tGzrBlPIktg74ZLT1oZyeaDCtBKS6gZNvUVL
	kX2jssMz0P/V9DMo6orKkYM1NhpYl7NseIAG6wQ5wV0hhdIlgPaFH58cNnc926pW
	YT6JbhGhh/IbnFPWCK1b2A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4901a9r465-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 15:02:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 585DmppH026206;
	Fri, 5 Sep 2025 15:02:24 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070.outbound.protection.outlook.com [40.107.244.70])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrd4gu9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 15:02:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DxnpfE8zUWZX12zsbNF7zoJ4VUQHDUQk7wZsG4ZndV6XykzrWuNIR1F2VoT4EjCRl8/mkz7wKhUjG+bFU+oJB7p3/LjZ78CWmW9ROMYYVYRN9YAZOIJrCac81FZtNBpDoK+EhtD0jS5KL0q7r2u4sXBlm7P+AKcV7fSffYfmubafh4zYpxM+jqeLw80P6xCKuWY1sPu5/0KOW9ChYiGl15vW/WHsKoJSek7E1o+ZoZCw2iqOmTHTB9e3jHqMUzaNwd8yMKbNnD6BMZzRmhOPFFJDuQsd5eMvpSmEgTFNOS3ocgoFHhWJT6JKRTwzl9O1U+yjtwdAGfmpSW6Q7G0B2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C1bUSnz5wtzQPlwW2gpWC/4+LwPoB5JOja9F0mDwaJw=;
 b=hx8BsIIS+ZR1W0b/AHJVT67vF1zvEsLUcgS5dvidPqWwwEl7EcAZrHgp5pOm7pncbSo/raNWMOeiEOQRw1xqxjr3yPAO/MbLSiyVhphiruNyMz5p9JiqocDnC6dgmkHS497wm5e2/1/I9dVb4m1ER1UooDITWPUL4KXW2D6XNpAjIjvhkgW79B6scVXM5FcIxM1ylYfgcmS5m2RxDEUocHvp/LqvmO0TTbVnewzTZK75z4xTxKqNfUxjQsQ+pPWYtTyYv8mp0cCtSfvGbhoUQB6b0cZTDZKUGcg55US2vuOkNbsS9Bn38VMQFH2NEW07KCnMB00lvHARFzWVfQWWyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C1bUSnz5wtzQPlwW2gpWC/4+LwPoB5JOja9F0mDwaJw=;
 b=N0d+npwFEX+WnwCZmUt2quxCnrlUs1RoLyDp/vPKTvjrYTozZ7L63Zxe0Q7kpd4UTYjin4+99uLkLrcuCd+SCl0XcROdOr31fg6NdhESNgYFUG/FBraPgxsLZfgTnnnS9RpWg1VVhoH6Jdzre+Ec5pt8jnuz+TLzog5Me0dHfyM=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH3PPFE0A9C68D2.namprd10.prod.outlook.com (2603:10b6:518:1::7d2) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Fri, 5 Sep
 2025 15:02:21 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9094.016; Fri, 5 Sep 2025
 15:02:20 +0000
Message-ID: <489f0413-f627-4c54-b840-0519be1ffabc@oracle.com>
Date: Fri, 5 Sep 2025 16:02:18 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/26] scsi: core: Support allocating a pseudo SCSI
 device
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250827000816.2370150-1-bvanassche@acm.org>
 <20250827000816.2370150-3-bvanassche@acm.org>
 <5070296c-5fd2-4698-88f2-0870caab051f@oracle.com>
 <ff39215f-3900-426b-a273-60c7ebe83c82@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ff39215f-3900-426b-a273-60c7ebe83c82@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0274.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::9) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH3PPFE0A9C68D2:EE_
X-MS-Office365-Filtering-Correlation-Id: 84acf8e8-baa8-419e-063f-08ddec8d368e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bGZKNVY1OXBMb0ZleE5IcUQzc0V5aDhCMGhGQmIwbnViUVlUM3p2KzY4dXc4?=
 =?utf-8?B?cG4rSStmWnVoenBJZFliWm5VNU1zbm4wVFZ1emJRZmdVMWVpby8yN1Nza01l?=
 =?utf-8?B?QnFJOTBNWG9qNFJUYisrV2hEZllDaEV3Zm50Skh1cC9KYjNXVUdnNVcxNmx6?=
 =?utf-8?B?K2VnWDFGK3k4N0prRTVnWnBYaXFJM3VVaVJ3Ni9WR2Jad3g4QUhFZUM0Qi9N?=
 =?utf-8?B?RnByWDZMSkp5OHZwbGJncXhhQmxsRmpJdTRybG8xRVB3TmpXSzZ1THhKWURQ?=
 =?utf-8?B?eEJ1WDBod0l3ajlkZ1RyRldVRHpQMWlNT2lxWUFrL2gvdzVZNEtqc3lIN29z?=
 =?utf-8?B?akh3Qi9RQ2R1UUlqbEs1WHRpK3pxUTVRMTFjSWdXTDhET0dvZis2ZFNUTm92?=
 =?utf-8?B?aEFrL0FNMjNnUkRLbFY2WWFkSk00UG52cHRIUlFPZjBWQi8vYzRhdDhGTno0?=
 =?utf-8?B?NG9lS3RIMnBEK2I1YzRaaG5tL3N0bHVEQ0FGMVhkakJyTVowazhrYUloRFVn?=
 =?utf-8?B?QUJwdXpHN08xTlVtL1J2TkhlTmNaclpJSFc2VU5PaFYrZ3ZMaUZZTUdVVFpF?=
 =?utf-8?B?Z1U4NFdRWkpoOVlSS2NTRGU1TFg0ckpWSSs1ZEZ3TE1SMVlUT21NRUM0aWgw?=
 =?utf-8?B?bVhWTmRWUGVkTUMxZnN1blpaUTVySmtCbU10bFRzRmI5SnVGdzcwekM4UVV4?=
 =?utf-8?B?c0hESE1GRE9VK2FkcXRUMDd6cGhPUDNaSUFqZThxV1BVRWFPNnFTdUdIcEVX?=
 =?utf-8?B?ODBIcU85WUtSSDFidHdoZVQwYXkwazUvbHNPbXRtdmRiRTFoV3NsMHFaZlV3?=
 =?utf-8?B?d2c4QmNFQnFKeXZuQSt5eEYvbVJKTnRtNllibW9LTlRXZUc5VjZhazdiTnlx?=
 =?utf-8?B?Z2ZnaFJZclhzMFJEb3hmWDRSK2lXUWZHVG5ITFk2aDJvMTBiSnhmTHBkT3ZG?=
 =?utf-8?B?clNncWhIWEwyUDUwcUdQM3pNOE92RnI3TG9lVm03Y05uZUNER2t4R21HV0xN?=
 =?utf-8?B?bEZBSFFDUTU0OSttYUJDSlpYTGErMm9MdDdGZnpMR1pvMUNkWG95amdVZFV2?=
 =?utf-8?B?ZVZQZ0Z6TjV5MEJBeWxIcTY5dis4U1laNlV1YUJxaTdib3NSc3BFUVN2L3d3?=
 =?utf-8?B?YzZNNW1BajlOZmYrdGpocjFZb1FlREhJeGdEeTE4RWtJblBMa091aGc4emtr?=
 =?utf-8?B?UHRtZnduZy91QmFydERqK1BsbVNML1NsakgwQ2wxc2U1RGJOUDBSb1NObm5i?=
 =?utf-8?B?anJrY2RWbFp2em52SU9MSENyNldjT3ZzTmxUbGNNak0yZEtybHcvcTByeGpu?=
 =?utf-8?B?ZjNZVzZNZW15R2I5Wk1PTjJ5U3hORXdaK1gyVFZkb25Rb0R6U3NsTDhRd2lM?=
 =?utf-8?B?WmxkanFpL2VpNDRhWUpWU3dKWUFHYzM3MklOek0rMjM3Z3JqMVhNTXdBclF1?=
 =?utf-8?B?YWQ3ZnBZTklwQ2oxaWlVU3pBQkVTQTczZGtHcXFNa2VXZGRKUEFGdTRLRXFn?=
 =?utf-8?B?TE4wQkRQa2tzOXR3bGZ3eWhzdk5SYXdiV2tkeUM4RFVIbVEvczJ4bUUxTWhS?=
 =?utf-8?B?MFBKbnkzQkZoeUpQeWpSNnNBL1N6Vm9zMlJuR25BTDEzaDBzZDQxeXZNZDBj?=
 =?utf-8?B?N3JEblBGbmIzNGk5RTk1cVVubnRtRFM4N3gyRUpIYjRjWjgrdXVSRFZOckZM?=
 =?utf-8?B?SnR5VHkxTW95bFFGL1hlQnlualZrb0RNcGFua3B0UG1TTm5yWXhJdnJ4Zmli?=
 =?utf-8?B?UkRQcFBaVnBWbDVFWjZWLytEaFl4VTd2NUxUTzhwR2tXR2dWRVg4Y2Qrakw0?=
 =?utf-8?B?K3krUjR3TG43ZGxuRXNncEZla3hlM0JlZjZyQmdLbzFNUWZBYjcxZmE4Y29Z?=
 =?utf-8?B?N29lM3BGVFNxcmNKOXdMRmJWUGFvTkZNRGdiNTlZSFZhdmNrOE9EVDlZUFFU?=
 =?utf-8?Q?/mMdkSyqcoI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SXh2NXNIbFZXYzFLMWJIK00vWmFHMUFDamFoVDVEVjVPcFNveXJPekZUV2tF?=
 =?utf-8?B?bW13S3p3eTZQVzFKdTNZSFpJeVZVdkNGdmNMSDQ5QjNybWRtcFB5aGdIYlJO?=
 =?utf-8?B?YURBbEd1bEhQbUFNNVVLc3VNVlg5c2Vka3ljTDlUQnZCT29MTGhQdHkvTzVJ?=
 =?utf-8?B?Q2VHV2hsUHl5czRYVGpyUEZRYWVrMDBZWURESU9vN0w0NDBTSmN0RGhTV05J?=
 =?utf-8?B?MURNQzNtNWVnZ0RIMk1OeWhBTU53Z0kwODh1eHJiMXB0V2E0aTdIUUh0NVd5?=
 =?utf-8?B?TGdYYXdkM2RTOUxqQ1lVaTZ2VWkwSFk3Rkk5QXlEd2lCRXN6bVRMQnFUNWN3?=
 =?utf-8?B?ZGFmdVpyMVhtTGhxTmpWb1AyK1UxMXdCaitzbmVDV3RLTU5VaktVaDltM2hx?=
 =?utf-8?B?UVUxOWx0TzVPZ1pybHZCZ2c2bDVxSVc4QmtUYktjNllKYWdEcWNnYTVMKzFw?=
 =?utf-8?B?ZUI2QitsTHgzYm9paU1zU3ZwbE9LOW9kSzM0TXl4SkFtQ2ZJMmNjeW1uNkdG?=
 =?utf-8?B?MDlFbzRRczlZNEs4ZUlQYXdSeEwrckQ3TWtwc1JVbTV4NEpqczRzMFJJTzZN?=
 =?utf-8?B?d2F2L002YVN5ckI0RFc1em1KZVQ4WExXZkQrQkZDQnJGdWY3dXB5RWxNRUkx?=
 =?utf-8?B?Q0RNMittV1IvQVp2cFVJbmdFK2pXNDAwd0tSenRpdXJSWjdrTnBLcUJLT0tn?=
 =?utf-8?B?Mmt0QXpyMDB6SW5VNnh1R1NESHdvWFJxQVdoZTArYU1QSndXWHk4OHFYNndz?=
 =?utf-8?B?SmtFa1hQWndBbmNOd0thRFV3KzJDTGVlNi9sWnM2WEZlekRMMXZ4QklmWkho?=
 =?utf-8?B?anFxVjN6citYb2hPdHJmMXp6WUI1cm9xUDlQNjBkTVE1ZGwxWFdsRGJMS0J1?=
 =?utf-8?B?Q3V2RW4yZy80ZlZaRENRMXhiMFZLaXV1SEZiRFFuTVBKZ0tTUkZYcGloblJv?=
 =?utf-8?B?dWxSdmNENkpHKzkwMVZzbkdEdHZ3TFBFRUNneUk5cG14aTY2b2d5bEJBVHJQ?=
 =?utf-8?B?L09jQUZtNGgwTHpYbENxSW0walhNaGFNM0IvS1NYemZsQmVQb2FkcUgxV3FC?=
 =?utf-8?B?QmppWUUxSXQwUkl5SkUyMWwrSFhiOUF6L0N1TTVac2Frc1kvaWdHelpneG5U?=
 =?utf-8?B?bWI1ZlJWVVJCMy9TbVdhbDNtc0lTVmFobTZPWjZwMm9uRk03SFZIc2xsUUdJ?=
 =?utf-8?B?LzJEL2Y0MllkNTlnV2t5aWwrcGFvSTdxMy9QMjU3RklwOTZwLzBlU1pQM3dy?=
 =?utf-8?B?anJMY3FhQnhjNDZaWHJtdHZTQ1FhY3pUWGMxdUx0Wkc3RFpOR3BNRzJlS1RC?=
 =?utf-8?B?OVJNdlJaaHlFZHk4bGU3VGtCalBsWG9mWkZITlQyQlNBYjZqeldMazdrKzhi?=
 =?utf-8?B?cWdUM2R2Rk51eUFrRTdkN3VaRThDNEVTRzNpQVJQazBVd1duMnZHNkg5VFpk?=
 =?utf-8?B?STEzSEhzVU5WU2g3dW1WeUJFNXJhVWhLWFRuYVQ5c3kwdEhZQkk1eTRWbENG?=
 =?utf-8?B?bXA5OG94RmVRL3lMdlprd2ZhTlNuN1VvQ0l1TWY2V08yUUtJak9lRnJ6Z2Nt?=
 =?utf-8?B?dGNuMTlPdDhDeHBpNm9CdE5Ra0VQR2xsNzdpOHdzbEc4OVpwdDdUbS81eGdl?=
 =?utf-8?B?a3JiN1NaNWxhcWZPMVRpR21Wa2RVK0ttU0FONjJ0cXU3NzQ0d0lXOTlwa0J6?=
 =?utf-8?B?Z3B0WlFKcUhjOXRvRVNrcC83c3BBUkdxMFhxb01scG5sbnpQckR2emVUUWZq?=
 =?utf-8?B?SVVPYlBwUmZyMWhWalRHOWExQWl3T2I2Y1c1bmlTZHFIRDluTUFYcTNpaGho?=
 =?utf-8?B?dVJIVXhWdTZwK2ZaUmh3QTlmN20rTUpLOEZmc0ZBc2hudzVwdGNDM1NUS2JY?=
 =?utf-8?B?QWN3TVFXTFJEVEJRSWFyeitmOGE1N2MxZ3dnSEJkQnM0MnBwWmZTUlpFbS9v?=
 =?utf-8?B?U3doQS9kc2k1aTBGaG1wcmlwdUM0K1JsTkFtM0R3N2g3ek5GdGVUSzl0RjNZ?=
 =?utf-8?B?bmhXTTc4TmVWNHZsTk94N0g5NWZIc0lpK1A2QVozTVo4QWZaVk5TOWp1NTVJ?=
 =?utf-8?B?RkJnR2Mrc01Oc0pWdDdxalVDSjhsZ2taUXpXbGFXaHgxTm1DQnducGxwVmJ6?=
 =?utf-8?B?a3RSdnVPTWhQVGJuSFpxaGp6UFpZVlJ3R0R1ZmN4cEpyZm5BUGcrd3BDdk5G?=
 =?utf-8?B?L2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uIxsEEl1oIvZG9AvS2Qc+r4usezTJCkm9/KY3g8kFzoUWh4AaObk+pukZxfWrrYPX2qIjCnjstvPeckd8hwU4CB0jajL1iTzmYgyp36L9cnqS2h0H4wDChkbjsYsosK59YBsv/AJjkLVPzMkYfsCy8lojGGpVfJjg/kAatO1E8CeQXhlDpKqo1sA8sksUox4FMbo7B5OJF1gZtj95BWKyvZ41XCm5OIeCCgpiMmpUN2D1i24aKceeoEJJneElPPYvrVWA/B/5qebql16QRXJnC6MQD69CsKs/DB9TbndLrtl0W8wAdH1n2aCa/0yDrTlYsspp2PXVkeug9mGgPNKz4kU5P6tQ+/7xg/Csyjk+QYBhn8ieXWOWdx1XzEQMbzJ+JLjYlJ3gFbWJtoQA+1WFOQMhTt+rAp0j8vV4dnGBv9g4zZGN23Qz6lSpgdFHeoVFWW75Mizn4Lyn5JuMFn4UNf5Du4BjPt2UVqJ/V5FK6/HCPcs5VX4Z5l5vmSeSNDOksSHPxuPTh2ZfnqMRy9b4EtW9424MPfJpSrytTHWCPMDw+Jo9doKQGPJep7Fs7UMf7F7342STBo3DwF1drBzV97h5sAkj4Kuw1BGz11BEDY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84acf8e8-baa8-419e-063f-08ddec8d368e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 15:02:20.8556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3BuyETv9zz/EmiZe38CLDpaSJ0UneFEYZw30minwJn6sF+N2CFzsCz/+53M+oQkNpqdCJ9qPEqaQ0fQ0SKTRzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFE0A9C68D2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-05_05,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509050147
X-Proofpoint-ORIG-GUID: eraOQWwehb1UoXEgo0qyinM3ft0bbj7n
X-Authority-Analysis: v=2.4 cv=dMimmPZb c=1 sm=1 tr=0 ts=68bafb82 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=WlRhPVXPhYNiQrs8E1IA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13602
X-Proofpoint-GUID: eraOQWwehb1UoXEgo0qyinM3ft0bbj7n
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA1MDEzOCBTYWx0ZWRfX3Eri2K3ctTJ0
 88/qL8PyxwY5xFdfMq/+Vo4tJm4mpwIPQFulIETBWJ4oA++Oq7bZeBGyguAOpxlLopuT/kO4HOA
 ciw8X+z9UlxhqsLoTQbZs1zn14IDATLGSLKNYvyjlQl5v4SJmpn3SH4PsnlcQk9B5cRbkkwyeu2
 wy+QOcM20+lf/QAL1D2anbNa46ZypNPpCmiTmj0IbNZryJRHALnpD1+2NMHxK2RyzgB4M92OuSz
 yKdy6k+czgcsGBiaYjo3loYqghvAqEZ07qvtiH0Taqx6NaHvLYQTJgQ3jASWJh4RKpS79LQGcKc
 0DdH0tGSVM+I/NcQvSCi2abr28i4gXuPmT7WsClzNZE2/RPDPF5WuPR+vJRnvIZPqkev0tcCFFJ
 qLgPprxw30QZN4KVStULg0tytFD0Bw==

On 04/09/2025 19:05, Bart Van Assche wrote:
> On 9/4/25 2:29 AM, John Garry wrote:
>> On 27/08/2025 01:06, Bart Van Assche wrote:
>>> --- a/drivers/scsi/scsi_scan.c
>>> +++ b/drivers/scsi/scsi_scan.c
>>> @@ -365,7 +365,7 @@ static struct scsi_device *scsi_alloc_sdev(struct 
>>> scsi_target *starget,
>>>       scsi_sysfs_device_initialize(sdev);
>>
>> is the pseudo sdev visible in sysfs?
> 
> Pseudo SCSI devices are not visible in sysfs. 

ok, good

> scsi_sysfs_device_initialize() does not make a SCSI device visible in 
> sysfs - it initializes multiple data structures and also includes some
> code that is important but not related to sysfs visibility. As an
> example, the dev_set_name() calls in that function initialize names that
> are used by SCSI tracing code.
> 
>>> @@ -1077,7 +1077,7 @@ static int scsi_add_lun(struct scsi_device 
>>> *sdev, unsigned char *inq_result,
>>>       else if (*bflags & BLIST_MAX_1024)
>>>           lim.max_hw_sectors = 1024;
>>> -    if (hostt->sdev_configure)
>>> +    if (!scsi_device_is_pseudo_dev(sdev) && hostt->sdev_configure)
>>
>> we also have an sdev_configure check later for calling 
>> scsi_realloc_sdev_budget_map() (not shown) - should we have that call 
>> (to scsi_realloc_sdev_budget_map())?
> 
> No, since the budget map is not used for pseudo SCSI devices. I will
> make sure that scsi_realloc_sdev_budget_map() is not called for pseudo
> SCSI devices.
> 
>>
>>>           ret = hostt->sdev_configure(sdev, &lim);
>>>       if (ret) {
>>>           queue_limits_cancel_update(sdev->request_queue);
>>
>> should we really be updating the queue limits (not shown) for the 
>> pseudo sdev?
> 
> As far as I can tell the queue limit update calls in scsi_scan.c are
> only relevant if BLIST_MAX_512 and/or BLIST_MAX_1024 have been set. 
> These flags are not set for pseudo SCSI devices and hence updating the
> queue limits for pseudo SCSI devices is not necessary.
> 
>> don't we already have a pointer to pseudo_sdev in shost->pseudo_sdev?
>>
>>> +    if (pseudo_sdev)
>>> +        __scsi_remove_device(pseudo_sdev);
> 
> Indeed. Let's use that pointer here.
> 
>> can we do better than jumping backwards? Maybe
>>
>>
>>      sdev = scsi_alloc_sdev(starget, U64_MAX, NULL);
>>      if (!sdev) {
>>          scsi_target_reap(starget);
>>          goto put_target;
>>
>>      }
> 
> I will include this change.
> 
>>> +}
>>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>>> index 169af7d47ce7..f1d509f74f17 100644
>>> --- a/drivers/scsi/scsi_sysfs.c
>>> +++ b/drivers/scsi/scsi_sysfs.c
>>> @@ -1406,6 +1406,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>>>       int error;
>>>       struct scsi_target *starget = sdev->sdev_target;
>>> +    WARN_ON_ONCE(scsi_device_is_pseudo_dev(sdev));
>>
>> should we also error out?
> 
> That sounds good to me.
> 
>> Can we seem to be able to call this from scsi_add_lun() - is that proper?
> 
> It's a bug that should be fixed. I didn't hit that code path because I 
> only tested asynchronous scanning. I will include a fix when I repost 
> this patch.
> 

great, thanks!
