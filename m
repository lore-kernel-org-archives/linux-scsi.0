Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C2027733;
	Wed, 19 Jun 2024 07:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718783472; cv=fail; b=nwrvrRaZEkaVa9GFq2hanYm2RIlyTa3IFTiWasqcn93TzsCpWTIAU+0FPDI4vqrvJYN1BO3/H0ig03XpCCpRwaUxHGTLgs/2Q10YL8LbeYdUR57bg7p8OaVv/tfqKH1DeIh5XxUSpxZyZP8vZxZODlD/e8JWYXPGp9laGCdOwUQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718783472; c=relaxed/simple;
	bh=vS0wpEPvSvUIzQiGBEYZ0Tl2AAe5RCe9M1ubcib98aw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=g/T0RX73LTmvoNCG7TgF0n+uVjL56PFRnTKr64sQ/0pcrpuSj7ngtKDqmodDyuig4UEYsa2Cekc5HfLweKmPnimeDZ/Jyb6KJggJ6TdExRyatXS3EhoHlr1orqZft2nQ9XdD4QRccCj+pgqRoDBUrRnGjkFBDC9xHmG+Oe5hPkA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HlJ1QH0S; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cR2imPao; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HlJ1QH0S";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cR2imPao"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45J1tTCb031217;
	Wed, 19 Jun 2024 07:50:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=RrB0scX8Ruz8sFrbBjyZXZ511SfeSRrKWvlCs/YFllM=; b=
	HlJ1QH0ST1n7wfY6ltoe0jGyZONUtV+7hsTieSXgzaCiqNPoxKcTUQtltzmzanEQ
	fql6RSc/sz7U5WjtY5xPSMwdegNy7lKaPfJ1hK4NKO3+DYOBJ9fldq+pjFjrqrcN
	whmz4p0U389UXPWIjaGtp132Ey6HkIQ6QmmcTZRhdxLExKysIvaoOHr4PgQvzBag
	yqs+T10PDleFatt5F6GNjFwm8Xkdvn3HEoRCeZQT3tMQQbYhyVWBiyRO3nej6UR3
	VO4K2ZUUL0HcXH+H49Yo5KWpAnUbrycUAd4NL6bKVf03DPjIHnDdOK1Gbc1Wymh1
	vte+ktMybaFlsot1o2Xfcg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yuja00p8t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Jun 2024 07:50:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45J691kj032872;
	Wed, 19 Jun 2024 07:50:51 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1d8ytgq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Jun 2024 07:50:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HpMkd+0bnQzUCHzr75/Ro9UcaJIb2MKdTw6dQPGraV1iQkQGwF/19aGbaRCQLq/FL6U7ztGHtNy9BgKPoLAZSTvoJSJ/SHqw87DB9H743Z9MsDA5+SKT6mXFJVLmeYGAgwjow10KtDkiU8dSLo4qByuCN9ykK8YIxpR4t2wuJUpyBtzELjvl++9aGFD/MfQS2owyXJwLKBRwF4c8FzenOZcktBFf3h3grz2LXgTFanfZawYjYOE0ZaBmHBwK06fMCNKI+3LVA5FbOmepoPMs7EbsqUuBWsn/CjtbPiUHeySjQpfl2JUA3nKvzcN4/5L5tQKBSN/mgBZ//F5ObAs7NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RrB0scX8Ruz8sFrbBjyZXZ511SfeSRrKWvlCs/YFllM=;
 b=foQkgl9gdSTf1e61o0DyhgjEp+FtOj1EzKw2txDQ2EbIKnNmK5TMGgoYcULYslcLdr6fphVvsnrY+pXiDmcqSMg/2Ii+pRMGhOjLgc7C5FUWYhDHULmFx7hN/yDNR/Ud6vQE5G26U4qKlpVaYLW+xXXSWVPY8bTOz5ssi4o8YqJGQddu8J1MbUQCenUcKM+n6mHW4pAG8IevGtev6sN9Ljyuhm4XTSQ58a2wHijF6fBnkcDP4YB5C9lz03PBn2ZDWccc61Ez8m+kSMNfl9AgDYmgRYtf5Zt7EC5xnIJlnGcgKmjVcquROpXmVlt5GwD3I8MlTh+R9CxMEg+ITPk3oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RrB0scX8Ruz8sFrbBjyZXZ511SfeSRrKWvlCs/YFllM=;
 b=cR2imPaoeCAB43BWIGyTrw0MM7jhDnZY1C1y+QimvfdPlliUGKdh7w7cjsH/O+CAY1k/dq1AQn1vKwRpZ8t9CBZAN4uKJXyykfmN4K2+Amj+rNy0k/02FYb0tbFf62w5Y8Gn7QoZpe7OYc2pgEfRoQ2YVg3vzSmRwAhf1+4wEOY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB4792.namprd10.prod.outlook.com (2603:10b6:510:3d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Wed, 19 Jun
 2024 07:50:48 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7677.030; Wed, 19 Jun 2024
 07:50:48 +0000
Message-ID: <45175ca4-d0da-42ca-97b9-f3891bf13c53@oracle.com>
Date: Wed, 19 Jun 2024 08:50:44 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] scsi: libsas: Fix exp-attached end device cannot be
 scanned in again after probe failed
To: Xingui Yang <yangxingui@huawei.com>, yanaijie@huawei.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        damien.lemoal@opensource.wdc.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, prime.zeng@hisilicon.com,
        chenxiang66@hisilicon.com, kangfenglong@huawei.com
References: <20240619032815.3499-1-yangxingui@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240619032815.3499-1-yangxingui@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO0P123CA0008.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::7) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB4792:EE_
X-MS-Office365-Filtering-Correlation-Id: c0c829f5-575e-4e9b-520a-08dc903488b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|7416011|376011|1800799021;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?YnJySzdUeHFSYVdLNTMrV0Zjbzc2WWFHSGhJUDYxMG9vVzF6S1pISGJTYjhx?=
 =?utf-8?B?Z2E0MEVYdlJGYmhlZTREejZXRWFsd3gwZk5kbE5ETDFzdlFTK3Z6MVdYb1Ey?=
 =?utf-8?B?UCtvNGl6MUdJYVpZazA5RUozczBGSmtCTnc0OGpLd3pBM0VmNHBZVWhnQU42?=
 =?utf-8?B?SzdudTVSWFlFWmlSVEVCc2oyWGgzbld1eVR5Um4wTjR1aFZpWnZyelNWQ3dB?=
 =?utf-8?B?cTJjNVkwdHRkbTZYMjhaSzlhQXZVZUZHelgwSGQ0K3NUclhhWGVIcG9JT1VJ?=
 =?utf-8?B?dDZaM1N1WHNNS0tybEhtZW5VbXBhdUlQTGtLNDdnaXgxaFpRSkhWU285b3Nr?=
 =?utf-8?B?eTlZeFBSMGNUMjVpYVpEWGppWlNZRDZoZXZ1OGRHVFp2YStzN0MrT2xsN0Fh?=
 =?utf-8?B?QzdjOUxaa1FoTFF0NVBWcUFrbnN2bm1IdXVYL3FzY3dDR2Yva0ZMNmpyU3Vz?=
 =?utf-8?B?S3dYNXZQYjNKTy9iOUNnS0JRNWxmVnV1WGpkU0VVZDVpMjNWWWN5VFRCcnha?=
 =?utf-8?B?Rm9xaWg2Q2ZXQXRGN3dURlEwN1UxTkJvQ045SlRLaUJibVJ2dUN1N05KZmhy?=
 =?utf-8?B?Q2ZFblZzMFAvY1FDcUw2MnVzSEw1U3lOV3BYZnlOejgzNHZtMVI1eGE0c2py?=
 =?utf-8?B?TmpLcTQ3bEtYbUlSdzRTOGxWRG1lbFN2RUpkKzR3ejlEeHRPV01HTEpkc2Jq?=
 =?utf-8?B?emN0R3N6Y2s1emlUTnBub2ttM3FFY3ZZRnBhK0E4aVZlZkYrbTRBeDJQRVpI?=
 =?utf-8?B?ZW1ON0QyZmw4YWNYRG5rWG1oTm9ITmdCMmZhTXJUb0Y2MlNFdENLcVZVNUdo?=
 =?utf-8?B?RThSa3hCQnhITVpBVlVGeTdxWUZ4YlhvUnJLd2xOeUtHWVhkZFFJWXpxT1Bw?=
 =?utf-8?B?TVA5Mkp6QzBSTmRmZzQzT1F4b0lOSTJaSlYxRS9CYmNLak1ibWhsYUo3RUpO?=
 =?utf-8?B?SUFZL3p4NVBKMWhBbE1JcHEzYjdqTzZIdHF3SzJmQUFjbFFCZXFjODBpMk1p?=
 =?utf-8?B?UVordnJqbk1vaFpNOFhvN0Y1UC9HaXh3RUE2alRCbVlCQTdHbUJ0cHRyTTQw?=
 =?utf-8?B?aFRZRmxrZW1STjg1aGZSRzRpZ1BjZVZ5ZEtGRzVaVnpyQy9tSk1xSzBhcGFJ?=
 =?utf-8?B?NVVMcEc5M3k2SVJBWGRvYTMzRVNMOVMxVWlrMGt5L1hxWTBUOFNRQnl1L0F0?=
 =?utf-8?B?TlJqSTRQbko1R0hwR0hRWnFHQXVxUzZKZDQxYjFjZ3NHZ0Njc2ZlZ3lsTmVU?=
 =?utf-8?B?YkI4R0NNZzlZVW1icnQ1eDZFUUhvaUxaR1NqT0ZVRnNZYjhyeUpmL1RHYUMr?=
 =?utf-8?B?TTBmL3NheXlUWGJsU1VGcjlVR2hSZ0h2bmN2eDc3R3Z2eUQ4dGZJV3lOZDFi?=
 =?utf-8?B?aFpVeGNzMWhvUVhXV3plU1RDTDlraXhyZUtjc3JObFR0dnBWYU9YdlJxK2dR?=
 =?utf-8?B?SnBWMXBqd3BmNW12NFQ2QUZya2RNTkhna2Z2NkMrM2FjQ0V6Z2lWUVVNNVlv?=
 =?utf-8?B?ditVYjM2NU1xbDYvbFN2bUFzK3ZncXMvSHpaelRrYjNZd2tlaXFMOFpMU3pE?=
 =?utf-8?B?T2UrOVFzT3hkbkVWWlU2WHJ3RmdUVW1nWlRYajVsSU5tUUttTnM0eDJ0bU44?=
 =?utf-8?B?NjhMRlQyYWdlemtkT1BiYStZcmdhZXF4YXljTkd1TFpFRmZyQkJ4K2JqeDd4?=
 =?utf-8?B?RnZpV25hbUV6SXR2SGJuU0tqck82NWZ5RFhwdXBFemdyL2dKbzVOWkEzc28r?=
 =?utf-8?Q?6wT22ptAVu0MAvsr6tG3gFc7l+Fp6Fp0wV2FpZI?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(7416011)(376011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Z2V1ZFJYV2w0QnoyK0FkTjdEbHE5NXpMTEovSjMvZ3FWdmFlV2JSeWhOSlAw?=
 =?utf-8?B?MkphVFBucW9aS0wvQ0dnRGFzQnhJdEtIa3RyNHFqeU1jb3M0RE0wVWtibXFK?=
 =?utf-8?B?elltL1VnVG9INTZZeGQ5YjlLL2ZEVEJ6R2N3SGduTFozN3k0Sit0cmR5SEFn?=
 =?utf-8?B?QkpUTWMwdzhpemwrcXMzRUswNFNmdFB5QWJGV0JNZ2ZkanZ6djk1TDZlby9Q?=
 =?utf-8?B?TWlWZUp2YS9XbWMxUTZoN2ZJK3VnWGp5aUljUnYrbnNLSnJhWUlUd1Fqdkhu?=
 =?utf-8?B?SDB6ZmhpaFhXczBNQVNISGd2MTNQK01hdlY0TWU2S1dadmNIRTlXUGxVcS9J?=
 =?utf-8?B?cVAvYVg1TUdXS3hibVcwK1FLbkxZa2JjTFBLVHprZXhveE1rZldzbkI0bXA2?=
 =?utf-8?B?bGFudzhtd3Q1enVialgwZytPME5NQkc3dHE4MkZhVjJUa2svQWQ0TXpLK2VU?=
 =?utf-8?B?a1U4YlFoWTYxQ2JuTWlMWGl6aUwyMmsxQmx3MGdmazVTWnBQWlNCNE5xdG5l?=
 =?utf-8?B?UTU5RjRQMEJxZ04xbHFDOVBuNVQyQ25YOFYwN3BsZVlydTIzV0xYYWNtWGN0?=
 =?utf-8?B?enVCTU9naWp6R3psUzhRRk8ybXF5aHJ0VGhKcGQzNzBtelplV2RhQlRxTFA0?=
 =?utf-8?B?TFo5a3dKSUc5dUk1Y2p0alFpL21wMG9HcitMM05td0RWWTdNa3ZKdkc5V0pI?=
 =?utf-8?B?ZTFVeE83dGtXaFpQakdCM0lSSnJQSU15d0Y1L1pRamZhcDZZK1FFOWRiQXVC?=
 =?utf-8?B?bCt3OW4zLzFjNVg5d1JtcnZDSEtFZWpualpIcm9sOVlPNVo0a0V3K0JnajVG?=
 =?utf-8?B?VVV2MXFQRzJQdFNPcFFjL3N5Nk1qL0VuL2xpQ0pXdXVzUmVKd2xIM0Myd1RD?=
 =?utf-8?B?bzM1Z3hKaW9YVFJmOTB2VW1FVk1aNmQ3a0ZNTGZTbXQ1UmR1UEdjVGdmRWVz?=
 =?utf-8?B?QTJ3cURxUGNwc01GTXJiY1ZMVTA5Z1dWeERqMVA0RWNtT3VDR1NxbDJJNDdn?=
 =?utf-8?B?WHhwMkcwcWlWT1V2Y3ZhZ1JFWE8wZ2xtYkF3K2RWQWZ3Zlo2Slc3VFhHNjQ0?=
 =?utf-8?B?ejNUOXc4aisxanU5SVZSWnFEaFFxQUNXak0xcHhzaUJaMFZDZktFQlZTYnVz?=
 =?utf-8?B?NXhoK2kyUktQU3BMeFN4LzdRWGFpQzZMZ3NVczlYOWFhN3VUTS9XODlWeUJP?=
 =?utf-8?B?T2hYZTVRM2EzV3B1UkJsbHNmK2JxSFlWVi9zMTF1QzFzMzQ2SkJBalFFdUtW?=
 =?utf-8?B?ZTVPTVlubVBqL3g0YStpOGpWMzJNZHo4aWIvWlArR2NjWHNYQ3k3YlBxYzVH?=
 =?utf-8?B?MDg0NSs5Rmc3cFMyamJPWk5nOFc4SzNpYkw4akNyaGs2ajFRbVd0TWRpVjVh?=
 =?utf-8?B?dzE1T29uRThybVpzNWRsdndaN01RRkl3bzJyeExSdmxiczlVK0d1dVA0enh3?=
 =?utf-8?B?UTJxWTdaWERhZmI1YUFaWm04VHdYSUxSZ2IwNmlTMjh6T1BvNHV1eXNQbHZJ?=
 =?utf-8?B?MWUzTVZwNCtBcHgwV3lESjJRSkdrTDFpd3Y2UVRUajEwQVMraVVnc1poL3VT?=
 =?utf-8?B?SlBqSUQ3OS9mN1h0aWo5aXZldGdKWXhVVUF4TkUwSGdRSDhod3ptdDRWSFUw?=
 =?utf-8?B?U3ZTZEdybHFCNVFKTFRhUmpkR3FnUHNtYjg5c2dwajBGMHJXOVpvSEZrRERB?=
 =?utf-8?B?ZU51aUZzakp3ZFNEVzFhZ211QWMyZktucSs4dWdEeWMxbGxKc0o1UWNJdTVh?=
 =?utf-8?B?cWd5TTJqUkZyeC80YUYzd1VUQU1QVnBMdVdKTGREY3NoUDJadVkrUmRCVFBu?=
 =?utf-8?B?MmlwbUlrUTQ2RDBUblNyci9TTUVzeThYbG16ak0wdU5aTDArR0pFZUN0ck5J?=
 =?utf-8?B?MEpMemZOSTF1dHowaGltdm9teGt0Tkc4bkRCVHdmNWZiZURob0xLVDJ0SGZx?=
 =?utf-8?B?ZlJjajBzc1d3azhzTVowUXhVM2hTK0FuV2dEQUwzQmhuV2RCZ3FKQi9XdWNo?=
 =?utf-8?B?UCt4amVySi9Ib3ZCR0MyUk1NdnJCaVdFM0RFTjNCdExtRzNGNXRqNXdsakcw?=
 =?utf-8?B?c3MxOGNiK1RUTWxjNEVkeXZMM3VxWjFGSElvNjVXMlNQTTRyTkoxZFpUVFhP?=
 =?utf-8?Q?SI22SF2OMZ9tCF1G83O+YVO9I?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	cXjfZYOAeNAeJ6alvI5AtW7g1IvxXvREUVRRuMDUtUS3UeLC+yWauGvs0H3UTFnxO85I5X+DbKeQyHWmdND0e+5oivhJTc5/PmNbHUNB7GqtXeWxURpnQ5vtW4qZFCWQCIbqty/4wKIx3LKJPhaZv2zv4UbUDEvMO8O18rCt05CvayKcBrnhaCRrTO8OCDsV0g6/P+2cux3xgLvU7WKJLghP8z+QhdH8P8iajAGQxFx4vdZGU8SHzOrLhgbvwvfruQtAz3GxAiQ2eXo3w5XPpNwKNcgLK/XUbvuIPZ0nfkoy1BrQyqnpdQdKgiQrlbFvYqtUDmqR0OJ3D7/OyI77ulSPUFVhpL7DJxKigrLin/6wasAW8iOGtAbeu07AMGOlGShhfrIHxf1xFBwvlXO17JD3/VY5iTJ7mNc2w4XSd+EHxA5En1SdzlzmX20aURBcGXm2lCUyBy+nlb9qtSn4bv5gDbvYf+p7vxXrwA4uwaSwEwUUfobHIPN14Vyp1+FhzzgGoA6sjwxkfzsbtrPq7sz0GHfERFdPaCQHCTvyJSt7zDBQFmUeI9bfMu02DVPRa2duqM3zCJESdsM+WP23sYSwEL0pHtUPJj7NgE7XtVI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0c829f5-575e-4e9b-520a-08dc903488b7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2024 07:50:48.8362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J0n3GPqj+74rv5bsQVwagCYnpwR3xffiTIwacvN2qwEQk05GbkxQOXOFQpcwUujGaAD2oRak8TkNdJqB4y8f3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4792
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-19_02,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406190056
X-Proofpoint-ORIG-GUID: OnZXunLxOtOKbnlUEIrpxiFeyfc7edDD
X-Proofpoint-GUID: OnZXunLxOtOKbnlUEIrpxiFeyfc7edDD

On 19/06/2024 04:28, Xingui Yang wrote:
> The expander phy will be treated as broadcast flutter in the next
> revalidation after the exp-attached end device probe failed, as follows:
> 
> [78779.654026] sas: broadcast received: 0
> [78779.654037] sas: REVALIDATING DOMAIN on port 0, pid:10
> [78779.654680] sas: ex 500e004aaaaaaa1f phy05 change count has changed
> [78779.662977] sas: ex 500e004aaaaaaa1f phy05 originated BROADCAST(CHANGE)
> [78779.662986] sas: ex 500e004aaaaaaa1f phy05 new device attached
> [78779.663079] sas: ex 500e004aaaaaaa1f phy05:U:8 attached: 500e004aaaaaaa05 (stp)
> [78779.693542] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] found
> [78779.701155] sas: done REVALIDATING DOMAIN on port 0, pid:10, res 0x0
> [78779.707864] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> ...
> [78835.161307] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
> [78835.171344] sas: sas_probe_sata: for exp-attached device 500e004aaaaaaa05 returned -19
> [78835.180879] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] is gone
> [78835.187487] sas: broadcast received: 0
> [78835.187504] sas: REVALIDATING DOMAIN on port 0, pid:10
> [78835.188263] sas: ex 500e004aaaaaaa1f phy05 change count has changed
> [78835.195870] sas: ex 500e004aaaaaaa1f phy05 originated BROADCAST(CHANGE)
> [78835.195875] sas: ex 500e004aaaaaaa1f rediscovering phy05
> [78835.196022] sas: ex 500e004aaaaaaa1f phy05:U:A attached: 500e004aaaaaaa05 (stp)
> [78835.196026] sas: ex 500e004aaaaaaa1f phy05 broadcast flutter
> [78835.197615] sas: done REVALIDATING DOMAIN on port 0, pid:10, res 0x0
> 
> The cause of the problem is that the related ex_phy's attached_sas_addr was
> not cleared after the end device probe failed, so reset it.
> 
> Signed-off-by: Xingui Yang <yangxingui@huawei.com>

Apart from a couple of comments, below:
Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
> Changes since v3:
> - Just manually clear the ex_phy's attached_sas_addr instead of calling
>    sas_unregister_devs_sas_addr() and deleting the port.
> - Update commit information.
> 
> Changes since v2:
> - Add a helper for calling sas_destruct_devices() and sas_destruct_ports(),
>    and put the new call at the end of sas_probe_devices() based on John's
>    suggestion.
> 
> Changes since v1:
> - Simplify the process of getting ex_phy id based on Jason's suggestion.
> - Update commit information.
> ---
>   drivers/scsi/libsas/sas_internal.h | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
> index 85948963fb97..7c0931ccea23 100644
> --- a/drivers/scsi/libsas/sas_internal.h
> +++ b/drivers/scsi/libsas/sas_internal.h
> @@ -145,6 +145,20 @@ static inline void sas_fail_probe(struct domain_device *dev, const char *func, i
>   		func, dev->parent ? "exp-attached" :
>   		"direct-attached",
>   		SAS_ADDR(dev->sas_addr), err);
> +
> +	/* if the device probe failed, the expander phy attached address

please use standard comment format, i.e. /* goes on a line on its own

> +	 * need to be reset so that the phy will not be treated as flutter

/s/need to be reset/needs to be reset/

> +	 * in the next revalidation
> +	 */
> +	if (dev->parent && !dev_is_expander(dev->dev_type)) {
> +		struct domain_device *parent = dev->parent;
> +		struct expander_device *ex_dev = &parent->ex_dev;
> +		struct sas_phy *phy = dev->phy;
> +		struct ex_phy *ex_phy = &ex_dev->ex_phy[phy->number];

this could all be put on fewer lines, or even 1, like:

struct ex_phy *ex_phy = &dev->ex_dev.ex_phy[phy->number];

you could even add a helper, like:

static inline struct ex_phy *sas_expander_ex_phy(struct domain_device
  *parent, int phy_id)
  {
  struct expander_device *ex_dev = &parent->ex_dev;

  return &ex_dev->ex_phy[phy_id];
  }

However, I am not sure how helpful it will be, since we often require a 
struct expander_device pointer when we would be using that helper.


> +
> +		memset(ex_phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
> +	}
> +
>   	sas_unregister_dev(dev->port, dev);
>   }
>   

