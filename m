Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D82194C83
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jul 2024 19:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720640631; cv=fail; b=D921BWTSNbyI5XE+ToCfee0tmEBz9yn1jJ5d1CS7GdvF7v/N4HHRWXLqs7Z0J+FKeTxh6I/KxHTolEsY+JBuVqCRD3tDvQ4x7BedCdsblGDcMHQJ9n10+aUCv2r7+3wxLjPBzhCHQIEq+aVEp9+YPMTEwPR4KCk2r7NoP/Tfs68=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720640631; c=relaxed/simple;
	bh=JRSRArR3wCzwZHbrqJGeMejGFHWXv20Fb2bwAfNWhJ4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NeHqJekj76KUuD5J4cilLFAYGGGvcNfTi8ea3SEBcKG1UC6VEXEMN5TZVfxu/b70XTX1YL5AlnWUEGssTkvLT0+PhP58s2utalC5LPpXwCmUom57rDkvmtG8kclXFGb/1an5Cmk9z/d9U0lXwF7/yhdAb0LMRrUZMeTwwtuxm7g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mOEMLxpD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LOU4r4Cc; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mOEMLxpD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LOU4r4Cc"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46AFe1VS017485;
	Wed, 10 Jul 2024 19:43:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=Lc3NBRmJrgXakB/Kkbu78zF/HHx775ZO20Zmy+S3Wgw=; b=
	mOEMLxpDaK/TTFqs4v1ejxizdzlt/EsRY+uOnTcoPhiVhYZFSqcsHNBsnNFPP7DI
	TRoKat1kAFmkhPD6SiNGj5qJunZHQgsKVxKXpbwuOtyuRwk1qbOh7rTEjyxv2qDk
	5spfGULH+P+GJVuxQee39t8yiY6s4zBy9WEJDJqFW/67svqvm7n6xO9y2FHyWxhd
	m2NVODoTvmL38Il5WKRUcrIklBJct4aZMMhj7ZshfTez9zugbheIm4b0JB2THAzo
	9ne7MkoznLFviJmIYSxvu+Fak1xNSDahfEr2pUthvmUYFnIIyBkBW7Pb9OBgmUK9
	WcykaIp37pEqv4E1dh0nSQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wybr5r5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 19:43:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46AIfqMY033676;
	Wed, 10 Jul 2024 19:43:44 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 409vv1a1ej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 19:43:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aJ5sNDMutMlRE+r9csKczRjPJjcDat5dxIhuhMMZlg+7j7oPRtv6htsVnF+6Ra6twq7cwOshZoYiRmQI1DZm38YfPtugiPqc0fg8+/NgJdBzRkh/1vYBgeNrsdjh1/CKcgPZMvacob6EJiY4R5kPtjbac1KIIyBvemiTI17DWg2QsGmFCNbPhq2EU34Vp8LeB+SnSDMTQgQ+Q/9umaP3EL3thFolIHJQviiAmJk6/WoXKNgs14lKH1Zb1jz91O/IImnTVKUnQdDgCBph03wBCTVQ70ZKmZh63rtw25WbOg2jf0ORkdyyiKZUlk9wSbNuyFHCBaGTH02yPo11J2NxKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lc3NBRmJrgXakB/Kkbu78zF/HHx775ZO20Zmy+S3Wgw=;
 b=Fdz0A6abJi5nB3uB6Qyk/Z4RiE1TJG0a5ZEedabqXsfsbgh+WTiLlX27BooLnzIC0LA2P0kHe66J9mBW0yvZ2NqNAY+QkbDTIaXJtFQmcNlHfT6AHdtJBqlspDmIjyVSTyCkoCd/wDNWxmz0P6vfBPJsJvdEu+5HEfoBFy+Wr6ULOiAVKxOFmqYgk474vaGKecBFsLViyrFbpMsveTNbpP6SZ311TQYd8nKrHR8TBefpWHwaGSe7vJPSsBhW0ru2Jku/g8UXUoPZx1S/sAFu/S3n2RvolOPCozCPv7pLnAAUEGnvpBRWmAqQqXtz5a6eo954UizdPQ0gd8R6WA5Xaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lc3NBRmJrgXakB/Kkbu78zF/HHx775ZO20Zmy+S3Wgw=;
 b=LOU4r4CchJX0Z9gvlCMm7WPnePCxJaHqpV9rX2/m/SoSwdg5hivrLFMvu0yC9pYoFvI9s938SQuVb2Gso4zWCaMcnXJJnyrw14iKrFWtgGQRA2vHP4VGn27VRQxutEzUJoAtEeIa0hkL222QRFL/6M5VO5aHO1GgTW75STADWHk=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by IA3PR10MB8020.namprd10.prod.outlook.com (2603:10b6:208:50d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.35; Wed, 10 Jul
 2024 19:43:42 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2%3]) with mapi id 15.20.7741.033; Wed, 10 Jul 2024
 19:43:42 +0000
Message-ID: <85eeb321-60fe-4380-bb90-03cb80bacd93@oracle.com>
Date: Wed, 10 Jul 2024 12:43:35 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/11] qla2xxx: complete command early within lock
Content-Language: en-US
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com, emilne@redhat.com,
        jmeneghi@redhat.com
References: <20240710171057.35066-1-njavali@marvell.com>
 <20240710171057.35066-7-njavali@marvell.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240710171057.35066-7-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0107.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::22) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|IA3PR10MB8020:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e6ad90e-5074-4720-3f5d-08dca1189a3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?K0hRNUhuNTlMS1c2ZHZwWHBlenNlNHh4SkpuQzRXYW1tQ0Vhd01HUElpcElC?=
 =?utf-8?B?QWZ0OVJNaFNrV3ZXNUdsenY2eDEraXBTUXF2cTFUNGMxaEpsWnFIWjg1bjdC?=
 =?utf-8?B?WWJHaXFpc0l0U3Y5MTJYdUk1aWFWb3g0NFFENzNvc1p2YUd6RHliTzRtVVAw?=
 =?utf-8?B?a3lmcjVpSFM5aWFlR0x4aUxXaFdFWGhrWWxSd1dSMDhKaXpyTnpHZVEyZ2hO?=
 =?utf-8?B?aUVKMlQzamNUMm1yNWtYZFpUS2J0YmE4bEo5S2RkK3lnLytRRm1Kc2NjT2M3?=
 =?utf-8?B?M0VHa0hNbjdQcFhnenZIKzhWbndKbSsxTWZRRU9xNGJYNSs2cUVHMGRTekxy?=
 =?utf-8?B?dldFRWRTNTluMVhxa1BHZjk2V3hVekdtUWMwc1dHNTNRY1FXWk1Pa3B4WjZH?=
 =?utf-8?B?ZklGcGFIT2s4bGcxK1c5MWFsRW1WUEVIa1FBeDYvN3NjRDVXOENudExwWmhH?=
 =?utf-8?B?UHJuSkFodGs1Q3NoaU5lTi8zTlVoM0tmenZhaWFDNVExZng3c1UvR1J0NGJ3?=
 =?utf-8?B?NEMyVmpPcUhRWDYybGh2WDB3Z0IxTUZpR1djKzI5akVVcS9vTmI2dFk2dmVR?=
 =?utf-8?B?SFFsOXVUYzNJc0c0bElCUTZFRlQ5b3NwamFNUE8vZE5SVFNyNXRGMlV4Q1Fo?=
 =?utf-8?B?U282cEUwK251dm9JSTk1c2xhRVE0M0pCVmw1OSs2eGYxNG11eU1PSWlxS0Fn?=
 =?utf-8?B?WUgveW50bExWa3o4bXNUNTYrdkpYazlhM3UxdnY0WFFpRFZKM2krRGlRak11?=
 =?utf-8?B?UGdrNkhIZFJkcUg3UjlLMklVS3Z5NVdaWVBtWGJFaGxkRTFCUG1MVWZ2aUlu?=
 =?utf-8?B?b3FnMllEWmM4bExtMHl5dlpWbkhwbnEreHR1R3BQZENnVGhEbUVCOU5vWmNl?=
 =?utf-8?B?UjZOZzdWSWxmZ1VGbytsZzR1Mi9lSFRRb3FwZytQaW5RcHpwNHlCY0NGazdl?=
 =?utf-8?B?RmZPS203eFlBOEwwczdVYkZQVEg0ZzBOMUdvYVhRbFNVSGtxOEQ1UFpkdWhy?=
 =?utf-8?B?dHhYcS9UcDZOODgzOWt5Z3IxVVBuT2lnbnpjWHJGaXgyUnd6OVpaV0JKMTBU?=
 =?utf-8?B?eURycFlvZ2xKVWY3QytXRFg3eThnbFA2ZGJnWkxkdGF5TjlRKzRpaTh1L3dq?=
 =?utf-8?B?eFloQ0g2UUJOSlMxTDhQd3J6TmN1NU52Ris3SHpLeU5UNUJVQXFOOEU3TWxt?=
 =?utf-8?B?SU5kN3lqc3poT2xKazZvcDF2QlVzY1NGeG82NG8wL1hHOVF4OWw0Y0hjMHBr?=
 =?utf-8?B?eU9Udzc4K0FMaWtaNWxKeFZqbVJMNzlNR2RhRDRTTkczeVhNaFFrTEJacUNv?=
 =?utf-8?B?dkd2UmZyRGd3bVBVSnRMaCtGdStTYkdVaFpYSVc3WHM3eVhQRTVvZ1d0UFhL?=
 =?utf-8?B?V2RQSXZGVXc2cXhvUnU3YTlBcjZ1SzRVdmt5M2FjTHcwazRUMHptWk0vMFI4?=
 =?utf-8?B?djRkMGp6cFFSUkthN3dUZWhURUR3U2hkNXg4YmdBY0wzeEhVdmdzbkd0a1ph?=
 =?utf-8?B?L2ViTzU5dmgrOEtIUEdYWmJEYW1aYlA1QWNLMkNDbEY0L2tLZWdpR0NJNkQx?=
 =?utf-8?B?MjRLWHNLR2pabVNuMmFYR2p2R3VPTE9hUUZsenpKWDdlSmJXZkRmc3RrNm9X?=
 =?utf-8?B?VVhJSTc5dTJ2ZHBhLzM1U2FhSGZMamcwUmFHMWM0SHpVSzBQa3R6dGdBTkpI?=
 =?utf-8?B?ZUgyWEJuR3dPTE1iWnRERlFjdk1Sd0djMXBPd2RDQSs2dzZ6TlJUdU9CZ0JC?=
 =?utf-8?B?bm0vWXJ2NCtzTnNFclV5Yk5RUFdjcFhDVEU1Smgvd2YwNUpOaEtwR2N4Wm1o?=
 =?utf-8?B?SEIrSUs5Vm5NTlhqN0lUQT09?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?N1ZvYktUTGoya1pNT0hVS3dHOWxjczFnK09vVWhCdnBzVkNHK0hWQ3h3WThO?=
 =?utf-8?B?cW85QWJUcGJQcW1IY0tRY2VaekhBdzd3c1FZTTg2cjZaNGUrcSsyZEMvSnd0?=
 =?utf-8?B?SXAxSkgrZWRYemFkVlRjS0FrR2N0OFdGN0hpaTRseEpFeWxRdUZnSm0xSmND?=
 =?utf-8?B?clNuR3RIdUxNdGRPaHRheDM3VlJlQ3R2NkMyMzEydGpmdHY0cDhERU9pSWp4?=
 =?utf-8?B?YmNZNHQrUy9uTlJZbWxrWXpCNnpZL01BTnZ2algxQU5Ma2w5a3JaYjNsWTMw?=
 =?utf-8?B?VWNNeGJ0TnlRK2ZFMWRHVTdIQW02VEFQTVZiV3Fkb080SlgyaEM2V3pHR28r?=
 =?utf-8?B?cHZ1NldsZFZUeVZoRlVUekpIRWEwcTRRR0lWRkxrZW90VzJDUkpzYUMzcUtN?=
 =?utf-8?B?UkI3MkNZTnIzZ2xRTVoxU3ppcXlDcFNEcFJzVEU5L3E5aFJLWkpYRlE1MFBs?=
 =?utf-8?B?MEJtUFRlZmhPS2g3TkdGTlhGNnBtd0VQNURKYXhYRWRWKzJDSDE4ekk2Tlly?=
 =?utf-8?B?QUN3cE5ZcXVES01SaU9HaWZleE5rc2F0a1NleGNPQW5jeXY5UjB5ZGNDbjJP?=
 =?utf-8?B?SUFOcnoxdlJOWFpKZTJvT3dYL0ZtTDVkMStIR05DVzNZeTFPOEdMbjdFZ2dp?=
 =?utf-8?B?Tytubk04cExzMWhsa21KL1hVOWJkSjBnZnZMTTc1eUR2ZWViVUd5RG0ybWdV?=
 =?utf-8?B?dU5IcmNBeU5lTDdXbzFPY3IwU0N4Ylp6MG9ISFNkZEJ5MnVwa1BLS01jQ29S?=
 =?utf-8?B?WVZ0b0x6VGJYTHEzYlRZYXNNNlZSUnFCMnNjNHBydEc4MzAyMUdPd3ppT2I1?=
 =?utf-8?B?cy9DNGh5Ui94bGJ3QVVvemcvK2dhWWxQWVMxdEJ1K0hxZ0d1VW9uVHo1QXhF?=
 =?utf-8?B?ekNHZk9LeE9vRDNYdjdzdkhrRVNmRmp6V0RRMXcyTCtBWHdpSzJOWStNNUl0?=
 =?utf-8?B?K0pDVW1URVVyT0kwTzlLakFXYTF0cGFWOW1DaXB3WnlubFA4cWFsS1NVTU95?=
 =?utf-8?B?R2ZCNFIzVW1XZXZCRk1lc2JnSDNHbVJ3Y2tjSHlaMWVxUkxYZzNRNERhc2Yy?=
 =?utf-8?B?NkJnTlZJVnRYS2I2SXJKSEgwRnBpNWtWNzNZQVRkODBLMUJOMmZsQzJaT2g0?=
 =?utf-8?B?eW5pNnF6MjFGSGcybUozVGVibU9Fb0creW0xVVhpbnNnSmc5a2E2cHpXOHdG?=
 =?utf-8?B?YlVENERiL2Z1YkdvRkdGZDgyZGpvdlFOaDE5SExlUklYOWFxYWtBQUpXRjEx?=
 =?utf-8?B?a2lTdkNkZm81Y1JsOUlNSjZWRmErUVhiK1VhMGVlQUZvVG85NERVdUpzSlBH?=
 =?utf-8?B?K241N1JaTlJpTWlyM04rU0YwdnpRM05lTUkvdXV6Qk1NV0Zld0VTQi80Y1lJ?=
 =?utf-8?B?OGcrZERmZm1VVHJoZjVMMXpVYTFqYk1jYUUzQzIwOG9hWHVFQWVRaDJPL2Vj?=
 =?utf-8?B?TUdkL1ZoSTFQbTAwREtDMFc5ZjJEbWNMb05ZRE1ISUhkbEhzaTNrU1ZudUlv?=
 =?utf-8?B?VGJGUG1WK1VyNWQ5TWdTY0tHS0M1VlJRWVlYckJpVFlpUm9wZHpyVmMwV0tr?=
 =?utf-8?B?aHprUkNBb3N4OFpZN1MzbS9EWEdMM0VjZHIxTTNwYjJHcEd6VWdZYnhwRDZl?=
 =?utf-8?B?NzVSQldGd1VSS0hQMVVIcjlOdnphcU81Y2E1cGsvT3ozcjdBSHBjSU83U05p?=
 =?utf-8?B?eU55eGpQMUwzOTJiWnFyRm8ycmxMaDJtNUdvZ25ScWxvMS9xK3Q5dVpQRWZv?=
 =?utf-8?B?eFRiMnF3dndMSFFsTmdRS0FRUFVYSDVGNm5uVERieHlTRU51eG8rTzVaaEhY?=
 =?utf-8?B?MlFhUWpuMmR1RHoybjhwOXVOUkVWQVo1Sy96RFJOTTdWU2xmT1VtM0MwSEFT?=
 =?utf-8?B?U0Vlc1ZmNlFkT09QcGovL1RUS2k3WmV2dy9FNUxEOHBBVTNBYnJBV3c2bFky?=
 =?utf-8?B?OWJ2RlBybkFiNzUwcWZyRkswcHNNR01lRE1NUnJKREF6ZnhZbHVIbzNQdUFu?=
 =?utf-8?B?MWFkSlB0Um11eE9SV2c3b1VPZ2JxMVIvc1o4VVYxR293QWk4dkVCaVFVcEZC?=
 =?utf-8?B?aURKYWlYREsyOWYwWE1URXJJTmM0RTFEejZoMnpBS2o0UnZ1K2hqVU1ybTI5?=
 =?utf-8?B?T3ErWFpRUGo1SnRhZlNuU0ZYMkdDQjNpaFJrZVJESytIWk9WcUF5bVZmZHJt?=
 =?utf-8?Q?6S7Jlx1c6InIYqKBnGVZgNs=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	c7B0nOLPRCItMifA5B2C8Z4Uf1Jc3t0wD6EKoae7xL6yrBCSM0+92symxUeZjxhywsDCbhR2LTdg/XVM7iMNQ6qsPY5MnfJ3C53nXkfX/pG217tejSIB32tRkZxClE8hbVLFQEJpZtMeBKDlUK5C+5+Hrl+zzeYXqMQ/YzoiDfhmNSGL6NyUv7Stu7Jr3eOiUj7qMas6jWHq6mo2AQUK8UyI1B32ROO4Qfo5uJOGHdeAta5rp72qSg2AYDo/MIRPGASecOBaOt559czgS3ktB5C9WabKidey3cwbGgFjc1Lphqxm1+rpbGx2X2jcgKe7s2Dt6xVd7IF7ZG84WyZK6KGU8lkS2OA3z42uMDwH1JdcsCBlgXhlk3TS3hXjBSc/+UwIH/Bq66X+Oq55WfYzCm2xOw8uVYtEfIFS32GDbTtRwpfhDc6WCp7kppqN5tIfVG+5Efap75qA1TCk63WM8THv1Cw1wHMZLZzM35aHfJmQlvumkyD1v7ch+IkJnp+xXffrqacSEk4dBzJzIjPkfDWTY3FhsQIdkdeWZgoHG/5r/VAwBOK7QTw+mwOJtT+ks7FbHYwj78vbU1FVqf8/W0rUEeIkvtXL4s9sGftF460=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e6ad90e-5074-4720-3f5d-08dca1189a3c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2024 19:43:42.1016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8HP0LgdInbBZzH7jjG4ZBO3eS7mcnjSEYDfm8tDcyowME5CLIcue6JAk882fAvADHtQep4ad6+q5BxZ3ce8UTrDcjHRVKpjMWjSv02d6SZ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8020
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_14,2024-07-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0 mlxlogscore=850
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407100140
X-Proofpoint-GUID: KKOmyQ51XEpbhVj2PXEB8DRFYKj5sDSB
X-Proofpoint-ORIG-GUID: KKOmyQ51XEpbhVj2PXEB8DRFYKj5sDSB

On 7/10/24 10:10 AM, Nilesh Javali wrote:
> From: Shreyas Deodhar <sdeodhar@marvell.com>
> 
> A crash was observed while performing NPIV and FW reset,
> 
>   BUG: kernel NULL pointer dereference, address: 000000000000001c
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   PGD 0 P4D 0
>   Oops: 0000 1 PREEMPT_RT SMP NOPTI
>   RIP: 0010:dma_direct_unmap_sg+0x51/0x1e0
>   RSP: 0018:ffffc90026f47b88 EFLAGS: 00010246
>   RAX: 0000000000000000 RBX: 0000000000000021 RCX: 0000000000000002
>   RDX: 0000000000000021 RSI: 0000000000000000 RDI: ffff8881041130d0
>   RBP: ffff8881041130d0 R08: 0000000000000000 R09: 0000000000000034
>   R10: ffffc90026f47c48 R11: 0000000000000031 R12: 0000000000000000
>   R13: 0000000000000000 R14: ffff8881565e4a20 R15: 0000000000000000
>   FS: 00007f4c69ed3d00(0000) GS:ffff889faac80000(0000) knlGS:0000000000000000
>   CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 000000000000001c CR3: 0000000288a50002 CR4: 00000000007706e0
>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>   PKRU: 55555554
>   Call Trace:
>   <TASK>
>   ? __die_body+0x1a/0x60
>   ? page_fault_oops+0x16f/0x4a0
>   ? do_user_addr_fault+0x174/0x7f0
>   ? exc_page_fault+0x69/0x1a0
>   ? asm_exc_page_fault+0x22/0x30
>   ? dma_direct_unmap_sg+0x51/0x1e0
>   ? preempt_count_sub+0x96/0xe0
>   qla2xxx_qpair_sp_free_dma+0x29f/0x3b0 [qla2xxx]
>   qla2xxx_qpair_sp_compl+0x60/0x80 [qla2xxx]
>   __qla2x00_abort_all_cmds+0xa2/0x450 [qla2xxx]
> 
> The command completion was done early while aborting the
> commands in driver unload path but outside lock to
> avoid the WARN_ON condition of performing dma_free_attr
> within the lock. However this caused race condition
> while command completion via multiple paths causing system
> crash.
> 
> Hence complete the command early in unload path
> but within the lock to avoid race condition.
> 
> Fixes: 0367076b0817 ("scsi: qla2xxx: Perform lockless command completion in abort path")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shreyas Deodhar <sdeodhar@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_os.c | 5 -----
>   1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 70f43eab3f01..e4056cddb727 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1875,14 +1875,9 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
>   	for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
>   		sp = req->outstanding_cmds[cnt];
>   		if (sp) {
> -			/*
> -			 * perform lockless completion during driver unload
> -			 */
>   			if (qla2x00_chip_is_down(vha)) {
>   				req->outstanding_cmds[cnt] = NULL;
> -				spin_unlock_irqrestore(qp->qp_lock_ptr, flags);
>   				sp->done(sp, res);
> -				spin_lock_irqsave(qp->qp_lock_ptr, flags);
>   				continue;
>   			}
>   

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

