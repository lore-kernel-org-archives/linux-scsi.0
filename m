Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE071ABEB0
	for <linux-scsi@vger.kernel.org>; Mon, 14 Oct 2024 15:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728920402; cv=fail; b=kvgK1lVdGpIH0VSHarCH8o2juNWnZ8Wv+yzOi6wJtTFCt9SPpujTQFGYQHSI8loYiUG9ibv8z5dOP3eFUIhBWPx17ZcKGsv6ZbN4KauWamUN0OoAWfPdOYDV5cNRuZK1oq3td+mRN3GkcH+BF+6l49Em6hJV1axq6noS+tn2CPo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728920402; c=relaxed/simple;
	bh=rXl3sXl4dPzrYQ7HLl1babTUaZle8iWOxHatrcWrHb8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qIKTkYlqsnMVo2qCEN1rbpX4ajAHw2e9YMGoJmHR3ihB1ArNT2fyebjdWuYgUq3xRDgDGdY39TStVj+egGxnlf1fItHt/QGANAqwlqGjp3gTbS6RFB+K9r6g2DlkdVn06qU4w2EWy6UlIU+Od28OS09ddFE1jTjNYoxMzKontSU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VU3sBVy8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LEPrFj6Q; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VU3sBVy8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LEPrFj6Q"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49EEfbMv021124;
	Mon, 14 Oct 2024 15:39:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=waEIZRB7Iy3ZTg/+S7iU6+Zk1+cFpHoKdf8YtPfnyis=; b=
	VU3sBVy8eAvKZ4UT2vZYkuBZG6OrO/jW82NF4u152KWlbEbaDz1gTUXPQuQNwcCm
	Wk4WldtBRs+r9iiEEhSePCTh1nMIypFqol/tccpkjHSxPuwT5hOwZtxDKUR0RS4E
	Y8NGWrEtuTFzUQZoxiiK97hgoge/F/nWk0tf0UqSe/kvH7JHy8zW6XCKQlbmYVzv
	dfmQyng8n2GwXUAz2UWxRwoi3JBtZldI+AJ9+xWrCANH4U0S6UERNMpPUN86ePF+
	gRJcmb/jaHDz2ZgldE02HlFps3/sctjpREU/omJmfI9IuAK0dXbFp4tJ1PnYElZ7
	nqYm1zd9pRON/3+LpVHRvA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427h5cew1p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Oct 2024 15:39:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49EEO0Vc026389;
	Mon, 14 Oct 2024 15:39:53 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fj686f2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Oct 2024 15:39:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AT8Zxw2+W/Qjj21bHyi4b7hChY1TxOnc9oC9kvldJh+qW5AMUMx9031KKRYmYs0TGym0K0P+yKa4Uf+ac4emwsGdigcCL9FYbynGYD78qfG/L+Rhpqdeturcq55i1nv/GWUesbO6+8gOXHojdftqCFZ+KyMvRcVVWVfUpFF9ZKu9fKCfwUAo6DCyMX2TYvR93gHyB3p4uIjrqZSIvApPYxRGINlG4ePHkquba8Ej5p8IjqjTBNHV4Lg/5Kjop50A+lXAltBdltCqHrIGw2ictNjaajzFstPRuftGCjvQqyeZK2TDcwmeNkYd36UaI+gwOy378u7asZvTuoJrWkIbag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=waEIZRB7Iy3ZTg/+S7iU6+Zk1+cFpHoKdf8YtPfnyis=;
 b=bKE5QDhnYTUlBAOa8OVPm8jApV0IS3VxQluWTyn7PDHMjbZD9i41/jkOuh/ZPIot+8Mj6RcfYha5iwSXAvNUgyb/k1v8UC/SCwZfaZXolmbBD6JuOUUJsfzcUXPGnM5OBeLeYwjuEtcILaPjDi/lEQlkNbfGGxC/consYjKol5pSPt65+PU9lWFl0BGTnV9o+97YOe2m2/XLeRW8vbkSssbR56tB5tOFzhf5pBsP1mZSqwmsNVXoeppS58OF8G1DRaNh+07SX0b8PC8wLp3ba6QtDQmnyjlRp3zi0yUDfgxAWAxBbfLiARCUf+XOrhCPRRs9KYgwhYWeKPtdu433qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=waEIZRB7Iy3ZTg/+S7iU6+Zk1+cFpHoKdf8YtPfnyis=;
 b=LEPrFj6Qv5gk5+Jno7z6sSK8Y9V9brsy42EcS8YYb5Cty0Q6ccpiMQ1sa0Ursjg8+advOHESgDPjit47jLwAdjRNcQC/55uJo9xeEMm20u/USTlIgz/eGZ6ij4lyIyXg8prm1j9rA58vTBOMnHKz1iDr88Nrlmj1LhBmhr7f/PI=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SJ0PR10MB6374.namprd10.prod.outlook.com (2603:10b6:a03:47f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Mon, 14 Oct
 2024 15:39:51 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%6]) with mapi id 15.20.8048.020; Mon, 14 Oct 2024
 15:39:51 +0000
Message-ID: <3196e13d-fc27-4883-87d7-0c6dc77f0121@oracle.com>
Date: Mon, 14 Oct 2024 10:39:49 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: libiscsi: Set expecting_cc_ua flag when
 stop_conn
To: Xiang Zhang <hawkxiang.cpp@gmail.com>, lduncan@suse.com, cleech@redhat.com,
        ames.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
References: <20241014053645.17619-1-hawkxiang.cpp@gmail.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20241014053645.17619-1-hawkxiang.cpp@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR16CA0019.namprd16.prod.outlook.com
 (2603:10b6:610:50::29) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SJ0PR10MB6374:EE_
X-MS-Office365-Filtering-Correlation-Id: 207e2ac8-a85b-4e50-8c8d-08dcec66714b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VlFUV05LUlk4MFNWT0Z3eHgzR3BZcE9vNkxualhDZmdqc3ZIaldDdVlCd3gr?=
 =?utf-8?B?VU0yT0JoS21rQUYrc05iNFhKZkxxSXZsbWlxSVEzenYyU3V1NnIwTENOVUx5?=
 =?utf-8?B?NW5obDNTV2J0UmhJQWgyNmJmMUNTdWhPWGxUZUh2NWEzMkdrajNhVHJSMG9h?=
 =?utf-8?B?SFlkcTRJV2tBNzJtaGZnRElaNFVqdkIyYTA2bHNaS2I5bUZ0dzVkaTlLVkhY?=
 =?utf-8?B?dG4zdDJNVmVkdzRGU3FZU000VEtzYnorYkhJQ2JjRzV2aTk4VjJkZVB3YXNo?=
 =?utf-8?B?dVU0NVhLZ1NWQnRnLy9NcWxrNC9La2REQ3Z3djEzdmRzMnRlZ0dVZndicU9r?=
 =?utf-8?B?OXpiR3Zsem5LamtNS3JCUWVOYksrUXhaNWZpODFhSHg4ZkZMTUdpUjhlWmZU?=
 =?utf-8?B?SlBUR1UrdzVScWE3V3pPT1pnODNRSk80eHRzejU5YjFOTXJVTUdjU0NDQTRN?=
 =?utf-8?B?a2s0MHR5R2NpR0o0dGFyZDBvYk9rR1pEcTN4RUIzb3NKK2UwU0dYUys0UU9W?=
 =?utf-8?B?U0ZINzJoYk5TTWZhSzVVNVhmUXhvcUFPOWpjai94SE9iWkIvcnJMWGhyd1RC?=
 =?utf-8?B?Uk1oa3MvejVjWkl5OVZvbnhkWjRnbm1QdnZ0OHFwelp5ZkdKNUFqSDVOY1M3?=
 =?utf-8?B?dCtkNEwxOTV3dEpkcjNkY1doUHNZNWxUVkJ3ckk3THhEMXhyZXR5WGFKVnZQ?=
 =?utf-8?B?b2IydVhTYTdUQ3FsZS9mMHk1U3o5K3lvcVJpd1Vhb0ljbkh3cnNaeHlGVmo0?=
 =?utf-8?B?T2pVaTBCWlIyR0R2b0JJMkE3OE5nazdPM203SVlHc0dHb1FhdXpianhrKzlO?=
 =?utf-8?B?MFBQWEpBR1RHVk03V1Q0cURDb0hVMzdqN1Vxd1B4L2NhcjhUcmRtSDk5NU0w?=
 =?utf-8?B?aTR3dldFbmEwQ2I1dXIrczFxVm5Xemk1YkU2VlVTV1FMRWxvWng4UUZyYlFH?=
 =?utf-8?B?d2x2cUs1Y1lhUSs3V1N6MmFiZVZpOEoramI5c29hazQ2dGJwOVpndzE4QWhW?=
 =?utf-8?B?NzhCVHlnK2NyZ09rNThyRHhmYVlITjFwTGR1ZGVvaVBGcUpDTEk3ZmNyL1VW?=
 =?utf-8?B?TWJhdUpNdkdFdGZuNFFKMVlYUnpxaFZ2dGdMMnIvVFBMallNamw0cFQ0ZVh3?=
 =?utf-8?B?V2F6K2Q5MnBNSDlpd3BsOEZlZUduMlcwTElSZktMVmRtL2JkRWJ0NGI4cU1a?=
 =?utf-8?B?a0xsTDFaR29Kclc4NDlyc210azdSTGNYdUJHdXlhQktpZDYxend1YUZtbDFa?=
 =?utf-8?B?Z1hLQWlZU2pCMkVTVzNyaWQ5UzY0RFMzd0hFbHFBa2ZzZlFZSzZsZDVGalh4?=
 =?utf-8?B?dW9TSG1uUHV2LzFCTllqU1EwK2ZxMCt3cUhuRXJPZS9XQjFaYm1jYzRkSjg3?=
 =?utf-8?B?UVpXbU8zNEN5aFdnYlB5K1gzeEEzYTVNYmd5YTNKcjVUN3kyb1FLOHcvOWNv?=
 =?utf-8?B?N2ZoK2hUVHU2U1RIREU0MzlMcDVMNTd5eWozRzJLOEdXYW9WSGVvZjVkYy9H?=
 =?utf-8?B?Wmo5MzNzQk1VUFdsRTZPbEE1eFpkTjU5Ti9YaXkrZWN0UjlSc0FNNTJTZDBI?=
 =?utf-8?B?MDNVNFlDaVlaTWxjWGNpR2NQWTZSNlBMWW41VkJ2UWpITWFUaDRtU3gvRDdK?=
 =?utf-8?B?NTlLOExXNWZCS3dxSXNLV3Rhbk1rUnN3akxYMndEWkhOK3RPQkVRT21GRENk?=
 =?utf-8?B?aE1EN1JuWjU4QzRnbC9DZlBaVElud2FRR2s2anl1YjVQYWJpU1k5VmFRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eHV2WHhCbVZEMHo3eXZvdlhCRUNONk90RWhGUlhnU0czQnVKQU56VFp5SXNQ?=
 =?utf-8?B?TVcvZUxJTDJyTC9nM0VDb1JUbkNBTFRzUmZKekYwdXBNa0YrUjM0NVFVM0Yz?=
 =?utf-8?B?RE9hbFJjNCsrYkRweWlzZHNlR0QvZEFUdENReWtIdEJVbDNTWUhFTUlUakE4?=
 =?utf-8?B?bUZKYSt1KytzNnNLdGlqa3N5M2ZyclVXVEtHL01nOE5BcVhaS3JrekJVYWJx?=
 =?utf-8?B?OGs3SkVYR3dUM0tTNGFKcnR4UXRUcFVDQWF4WEFtRHRiUUhET2xjUlZCdXhu?=
 =?utf-8?B?ZEFaQk9OMUdkTWJKV3NtVkwvdUJON2NjMGZmeGFGRTBiZUxNYWw4M3p6eTVi?=
 =?utf-8?B?R21hc0xSSUxneDM1STUrUFdwbFcyVndyVnA4NEZreTB3eFRwWHdDRDFhMTMz?=
 =?utf-8?B?amNxT2ZSdEJ3dTllSnRrVytsWUU1WU5Md0gyOWhqQXFuQ3Q2aTNMZ0l2Qkx3?=
 =?utf-8?B?R2gwSk1HdkpMSmpvS3hxeXZaUE9MNG8yQ3daa1loL25xeFBRU2NtdWlqY1pB?=
 =?utf-8?B?dXROTCt2NUhrR2NZNHNqd0RzUzlhbS9EbndHUmpYQURnd2psUVd4TlRaNmJ4?=
 =?utf-8?B?cGdBM2dRb3NEVDBFTUlKRHU5YUVjTXRLRGd3cW0ySkl0WVcwOER0dDRSbW04?=
 =?utf-8?B?UU8yTEtxMDE3WU5CbEk5UnFnaUMwamd1UE51NjduQlBaL2Jua05BWk56UTQz?=
 =?utf-8?B?SGoxVFpicUlDdmFmU0d6ZGZSQ2F5VUxHd3B5dUpldnpWWmJtU1RWZHFiN0Er?=
 =?utf-8?B?cXJyZ2dIeFpnek1Mb1UrRmxJbFFxMmtFWUNCYXpJVWpUZXRaWWJnYnVkMStN?=
 =?utf-8?B?UlYzZ3BYQkhuUDlDRnlYTktPWlZpdE9yMVhkZzZpdFNodkwwczhtSVhJbFVa?=
 =?utf-8?B?d0VFMEtSWkExOERCNzlVOTJTM0kxd1pIZ1Z2UE9nTFFaS2tNRldtdGgxdXhY?=
 =?utf-8?B?M3ZnMVh3Uml5YzBWR0ZGck0xaEhYcXptbHA3RXNRdDRKbkdYV0g1RnBUWTBW?=
 =?utf-8?B?UTVVQjBjTXpXbWU1dE9kMFdMUERnNXErZzkyb3hlRGRxWjVaTFdHSEZQamhH?=
 =?utf-8?B?OHBwTEhqMVdLMXZ3ZjE5eFNjR1dTbDJLRGZnV2hZSGpXOHhzZFlWVS9kSk81?=
 =?utf-8?B?QStQdzB0WmNJbzJyalNvNExrWVJLTG5xUUY2cmx2TW13UWprYmErbVBMUnFm?=
 =?utf-8?B?dXJJNm9ldWl4VDU1QTFlWUZLNlJtYytuQXBrSHVKV1V1QWoyVkxpYWVBdmdt?=
 =?utf-8?B?Y2xZVmsrQnYxVCsrVUNNSmdaZFdCekZZbTdHSkxoSkVzMWhEaVVpbUhlSG9N?=
 =?utf-8?B?cFZtRC9IUzQxaHdQSWtCZkZDNy8vWjZ1aGNpV3M5UEZTRlJ3UEcyWk1lVmtn?=
 =?utf-8?B?c3QvUkFleTNUcEJsakVpN1pMY3lMR2Zncjl6TFEweHZVemg4UVdkSzMxSnBO?=
 =?utf-8?B?eDZ3MzFUL1paUkI2eHkvRnJvdmRTMTQreE8wRmFqaXhiazhsT2ZJUEN2SjBM?=
 =?utf-8?B?THhleWh3dGh3dFpIZE5PdkdJNVRVUG5QL1hGemR2Q0ZuOWt0T1A4a3JwOWpB?=
 =?utf-8?B?YnQzVnNCSDlpZVRVaXBaQ2hEM0FkVGtOdkVid2NDTzZtYk9MemR3bjZXWjdO?=
 =?utf-8?B?R1hMQmM3czMvaVhza3QvblVXbFdKbFJOTmdsQlNSWkV4T1dsQWE0UzhRRm9E?=
 =?utf-8?B?TmFDdzFlZ3JNRDFONGxjcDg2Y0I5TmdiVSsxMEdkWklDUjJLVFd2OXRkbEFT?=
 =?utf-8?B?ZzIyMzEwTWZidVQwVFk4R2E3UlVGR3BFOXpIc1JNNkl3OEc5QytOR1VNajJ5?=
 =?utf-8?B?QlVWWW4wOHVoYVZHSU9JL2pwREFON21Nc2s4Zkp4dXVNU0dWSGNkK1pUVzR2?=
 =?utf-8?B?empDOHg5Y1Z4ZGxIVXMyVHdXeTlNQVJsTWwwOTErWitkaHVuRlAzN0EvZzBp?=
 =?utf-8?B?dlFwYkEyajN3a2FzZFlFN3ZydmRHUzVNMGlXckxNd3cxa1NPM1A2RE1yQmlm?=
 =?utf-8?B?dCtlajlPNUplYTUrQzNVQTJIbTBoLzRPcGZDMEhZcjRzTmZtajh2dStQY0N6?=
 =?utf-8?B?Q2o5WS84WDhJMVNZN211eHk3dU92QVpXK3NRQmZBQ2h3LzFudFA5Q2lsOERG?=
 =?utf-8?B?ZmZDTWowVTFMdk5vd3VQY2JyZmNsbzhrRFZ1SzRaN3l4MmtIWUVsK2VJMXVu?=
 =?utf-8?B?Q1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wxzOkpvv1kNc9+cySNgxS14cpbHrCor29oHogO4IVIaCyEM3KyzGjR/xhoqa4Y6xNDquI9OLAhklYncslZqG/yKlMVNiNHpky60tP7L6y6MqAd3QvY42kh1hdfVLUrNcOaSgpDfSDcEWklZUBbQlUcF9N1BHEFbTGLl9QL5Ed28gWo17uAMfa2DQ8GLnV91/ivuz9vwWZXReWaAmlcKU0gDX/hRkRZg88C5+KY0qHZKXk7ROebKCcAusvESKy+0M7e6p6xlwbLNnTrzGFMOrtzisOw0XpV6q1rFAXo9RV69G1fGOtPD8SFVUe4NbIcXxUybM8jHpGCoHGVAPWyCkjZMOoiKJrB2KhPtK7EBmjkQpHrVRlqJg1ClJOX5HKKC5pEY0VQl47qbhYJY9h2lk1X0c8CSbJ3QMDFz9C6QOa7tvqDDkSe/8Kcxv72nwVltZWSYa1hNjZ6q9wLz5oI0lZ1zLQtWC/RHgH4J1Fk2zhZYKw3coRJB0GbITa/zB1VNBtN5bQx7oh0n3SvTAtpZW6V417XGyAZA9CN997F+ssZYU7r4NwanseFSeDuzwUv/Anar3MtygFF9xGTJHEJBfnoitFN3GWrektGREKdoXy6U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 207e2ac8-a85b-4e50-8c8d-08dcec66714b
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2024 15:39:51.2708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FH/0uPqXJCODxF+vEufQ9cZbXWZWOjJdt1joz4kF5ffyA3gvghwxX97J/ceExthOGJozFSz8CTqYLtHdfg3w+IQGmx4TNxVBrpqJ7hBOy94=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6374
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-14_10,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410140114
X-Proofpoint-ORIG-GUID: 7p5vIy8gX3uhmaRy2mfqpkdfDka92J2Z
X-Proofpoint-GUID: 7p5vIy8gX3uhmaRy2mfqpkdfDka92J2Z

On 10/14/24 12:36 AM, Xiang Zhang wrote:
> Initiator need to recover session and reconnect to target, after calling stop_conn. And target will rebuild new session info, and mark ASC_POWERON_RESET ua sense for scsi devices belong to the target(device reset). After recovery, first scsi command(scmd) request to target will get ASC_POWERON_RESET(ua sense) + SAM_STAT_CHECK_CONDITION(status) in response.
> For command's response coming, according to scsi function calling: "scsi_done --> scsi_complete --> scsi_decide_disposition --> scsi_check_sense", if expecting_cc_ua = 0, scmd response with ASC_POWERON_RESET(ua sense) will make scsi_complete ignore "cmd->retries <= cmd->allowed", fail directly. It will cause SCSI return io_error to upper layer without retry.
> If we set expecting_cc_ua=1 in fail_scsi_tasks, scsi_complete will retry scmd which is response with ASC_POWERON_RESET. The scmd second request to target can successful, because target will clear ASC_POWERON_RESET in device pending ua_sense_list after first scmd request.
> 
> Signed-off-by: Xiang Zhang <hawkxiang.cpp@gmail.com>
> ---
> V1 -> V2: Fix build variable 'sc' is uninitialized warning(Reported-by: kernel test robot <lkp@intel.com>).
> ---
>  drivers/scsi/libiscsi.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 0fda8905eabd..f6bfe0c4f8a4 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -621,6 +621,7 @@ static void __fail_scsi_task(struct iscsi_task *task, int err)
>  	if (cleanup_queued_task(task))
>  		return;
>  
> +	sc = task->sc;
>  	if (task->state == ISCSI_TASK_PENDING) {
>  		/*
>  		 * cmd never made it to the xmit thread, so we should not count
> @@ -629,12 +630,12 @@ static void __fail_scsi_task(struct iscsi_task *task, int err)
>  		conn->session->queued_cmdsn--;
>  		/* it was never sent so just complete like normal */
>  		state = ISCSI_TASK_COMPLETED;
> -	} else if (err == DID_TRANSPORT_DISRUPTED)
> +	} else if (err == DID_TRANSPORT_DISRUPTED) {
>  		state = ISCSI_TASK_ABRT_SESS_RECOV;
> -	else
> +		sc->device->expecting_cc_ua = 1;
> +	} else
>  		state = ISCSI_TASK_ABRT_TMF;
>  
> -	sc = task->sc;
>  	sc->result = err << 16;
>  	scsi_set_resid(sc, scsi_bufflen(sc));
>  	iscsi_complete_task(task, state);


This should be fixed in a common way like I mentioned in the other thread.
