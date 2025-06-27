Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84BD19F461
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2025 12:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751026140; cv=fail; b=rFPG0OEZGNCa+kVnzA55FNTWvWhDIwK1g6LwksdzALP2dgA+caHZaebbMM531UdiwBNW+0Xh8mgDEcM0796ux8HVGI9IArnbKTRXiDtyjP3MEPM5ybcGd411WYYNwqvfXiso637p/eqkBO0lWVrYnMO3iDluRFUwdfi0NKSX42Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751026140; c=relaxed/simple;
	bh=vUGwsvpmmJsf7+PrAyyW3AgrnCZLnAWkwpb+VV1UEI8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Andn0QRkNW/fFvH4abNXYFT0FRSH4Dg3e0sD7z2t7a8lh68qXJcFo+GuWvPTcZdYUBr4M06MrG6wzK6HsaSMKLyDWEKplffMxC+cMKYXdxKsPFU4LfcoENVLJLrPKul+l4UwefaB+25Ib7bO6SLQ4D54QOeFNLs1WyCn6PJfy34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IxhxLYDB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=piYDumla; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IxhxLYDB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="piYDumla"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55RAbG10008660;
	Fri, 27 Jun 2025 12:08:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=OONzlL9u3h2QhR5zgufz36nIMnnVWpfpEiVngL3jR6A=; b=
	IxhxLYDBxF50vfapPCri63vxzCkgyHxkSe0YZhAFwGdgTE4N39+sA1Ykf/8vu4cN
	toHHBubWPoFLF6aerUnXQeG/QtOili4+8hT/NosKXDeXEHlj4k1x6S5p1DhYlMUz
	Z48wkc8baf0yCZ36FU7Jc95ZNrqtiE29Rf6Kiv4lSaUkZ4UV6UA2bSVYSr/zRJlC
	33TGaDR6hvOKP9fOmsPPYyQvvBvvpqtQCqyrYLpzdC5w0apgybj336KUgMe6pD25
	vn4h4qKKLkwGVDShPW62V9V8cYolGN4yUN+B4T6qdJprtVH4iHH9/Z2ynJGlC6Li
	Wc0deuFW8Oylu9uNZZkJDw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47egt7jmqj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Jun 2025 12:08:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55RAUCME013290;
	Fri, 27 Jun 2025 12:08:40 GMT
Received: from sj2pr03cu002.outbound.protection.outlook.com (mail-westusazon11013058.outbound.protection.outlook.com [52.101.44.58])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ehr8r96e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Jun 2025 12:08:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NdbP/FEjBhPm+1M/bIaU7MT5aa/o+6Ww9we1L2i1cyEqT7MC4pUgzul71Dt6hhSkHS6Nfa6xvMWuIAJmHFSP9D5Vrm58Hk+5Zd7zXV/jnMt35OyV4HzIuxEvOgsw0r22PhzvBW5Am5u9dldEFIciCO2Az83BYX0ca9WqXDCsfkBTb7hTKAC/CYZZZojnXtIXooLVKWwJlkpDF9ueblZxdW2jmMEhycMXHd4uiVM1y6omrJwFKrnfb9R1Gag7cdFodOvXz8dG4tloSeW/HfJK++f2ic1OfCQzB5yjEe2ihLZ8wzZrfUOnsWmO6bX21maP5FR9EztzP2y1PF1R7/FJqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OONzlL9u3h2QhR5zgufz36nIMnnVWpfpEiVngL3jR6A=;
 b=Blgu5eLt9fuMTfi5bnTGVw2065gdY11fD++hGvoKUqOXw1stIkWs5s5tUq+7ndNoj0t/2B1DwOkAMxDz7d/IrT4ffzqBTokmweEzumh4otIPGQ93buJXStiDViQWCV/IQ0WGwYKmtzALyoJG3DKlQ+0wGGXfxphBgm6ikfTT7Pp/wfH0w8O9pHxJX1nVrevZ7kNNrDlkScFKx4zDlaSLPQSUhbZDUO2mlGPKgr4WBwmgsO0NbslD7+WLzdM7CiJG216wJfgrB0bL31rzLW4GfTCPH7xR8RP5l38o7zpYcJ5J1883HuK6b3FsNXeKF5fkFigVjyEdBTbaKpLGKp/9bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OONzlL9u3h2QhR5zgufz36nIMnnVWpfpEiVngL3jR6A=;
 b=piYDumlaJHAhWZBgfhOHdpnuFYsg4BolZ5ZoD59AsiBELe5hgCwL197CHWpczpajn+62sD09YBliVq9To0YZWNVSNpp8WuABUetovZRAYYPrecu/C2GFSR1g5VJmstDCWOM0jbppcTMZxH1kNfPOGhSw/QVtSi0cip9uBtuX5cY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CO1PR10MB4563.namprd10.prod.outlook.com (2603:10b6:303:92::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.29; Fri, 27 Jun
 2025 12:08:37 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8880.015; Fri, 27 Jun 2025
 12:08:37 +0000
Message-ID: <1fe19ff4-a266-4b0d-a90c-c6e07fc83acc@oracle.com>
Date: Fri, 27 Jun 2025 13:08:27 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] scsi: core: Make scsi_cmd_priv() accept const
 arguments
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250624210541.512910-1-bvanassche@acm.org>
 <20250624210541.512910-3-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250624210541.512910-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0119.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2b0::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CO1PR10MB4563:EE_
X-MS-Office365-Filtering-Correlation-Id: 67ee4ab0-fc8b-4779-e5cc-08ddb573586a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c0twY1Joc3cwYUZuQmp0czFZTzBaSFdUVGV1M3V3Nld3K3M2cVNueTlHR0Q3?=
 =?utf-8?B?aE16K2l5a3VabkZpVG91QmtITVNQSVcyV1V2V0xuOEJxR1c4bDRqQnN3VktY?=
 =?utf-8?B?MGlPZFZxQ2pMNWhmWXR0QTZYSTVmK2NuNGU5Y3luUkJqQTkwbkx1Z3B3d05l?=
 =?utf-8?B?M1RLTUpyMHBrNlZWT2VXU0dnSzdZNjJLSUZiMW1oQUVGVFNTOEJmZzF5ODY5?=
 =?utf-8?B?dFhXWktsOTNVdnhVUXRqd3JkU2dUdnRkd3NVNEZPTVVIU0lHQXhFcnBhMkJj?=
 =?utf-8?B?cWRxL0hCdkgzWnJ6RVdrZ0ptc1pOSU1CWVJ4Z05QQ1FNTkkyTCs5WWFxVnYv?=
 =?utf-8?B?eGNuWTYwelBGelZPTUNGMXFVVXJld0prYm5pVW84ckpOcENvQXNmSEtMQUcw?=
 =?utf-8?B?ZHVDaEFZamtLZXlNSFRsMjkwYjRLS3BCeXlXcE1FM0xOaDRUek5OZnEvVG9M?=
 =?utf-8?B?M1dQTmlodHYzdjlCM1lUMzBvSDlyMXpqNndpYTdCSXBlSjJBK2YzVDJRZ0Nr?=
 =?utf-8?B?YXNSWW0rMTBpSmVTVTJaTnJPMXlwNGFpVjJKSTJWQWhoa1RaTGVWT3F5RndG?=
 =?utf-8?B?QktWNXRJL0JzSElldmNRMXFuYTU1dStTc0w2YklCbGswbDZqWU5iZGlVdjdh?=
 =?utf-8?B?S3NEbUppTG9rTHNGdGdLV2x0eldoSE94NFJPZ3dSS1JqL2NzRHBQVzMzWTIv?=
 =?utf-8?B?THpkTkZaM3NmUlJkbmNPbWNXMUtLdkxQTGNjVlNWV0xsRElxNFBSQ2hkK1R2?=
 =?utf-8?B?R0d2QkFXR0g4TWtwb2lUZHBnR2Zkc0NMbnpjMWswVk1WWnh2MFdDUk1vU0Z2?=
 =?utf-8?B?aS9aWFg0ZTZpMWZMZVZxdG9IMUtDY3pXaE9XMzJYTkd0QXhzWDhTalU1MTNt?=
 =?utf-8?B?bXpSNVVrYll0ckFha0RzREV5VTVIV2ZyOVIxaDRsbjIrQmRxTjZhcmdPanpt?=
 =?utf-8?B?K2c5cVIxbjVwNGpNUzAvSkIrZTBjb1lVcmM2VEt6WGZoYzI2WjNEZXl5OU1y?=
 =?utf-8?B?UHpWYzhCL29aYlpaWHNMbmtML0RWZ0xWVEZOQVJqV2JhRkhJTVMzTlk5dlRS?=
 =?utf-8?B?Q1BDWnFhRWlWUzM5OFhqNGVJSzNvWmxtZDcycFdvMXlZS2hWQUFSNnBqZk00?=
 =?utf-8?B?WnA2bnEyU2FoRnBTY010QjJnRW1NdWtKK2pORFlnQVFOL1A0bHNXb3VrajQ2?=
 =?utf-8?B?ZXQrZkR2dnRzZE1UZ1loR1Q5SktCaEZVaExJbXgzK1Zmd0dMMSsxUi9wS0pr?=
 =?utf-8?B?RkV5QW1MbUJVZnc2aHUrc2NhK0hPck54aytYeUUxVnNncFJGOVduUmsweHA3?=
 =?utf-8?B?TUN2ZzFBaVgzQ01lUVdHRCtUNVpoKzZxUDV2WGJmZVdnNHZ4RStXWVZLREda?=
 =?utf-8?B?MEFFZnY4R09IcnNKL0ViL3lGK2Z5RVQ3ekthRm5laVNhKy9jQ29IYWlsL29v?=
 =?utf-8?B?S240SUZqbzE1Q3dEQ1A5d2JQb3RQTUxJSEs3ak1XWHQ0bUVDQjNZNmJlSjIy?=
 =?utf-8?B?UjRqS1J6SDI0S080TXkzS1lRWGh6UGhSbExUc0UrOTFheG9IQURlZzIwSkNi?=
 =?utf-8?B?OEorQmxhSllSa2x4bUVKV2ErcWU5NkNyTk0wSjJqRnh3QytPT0wyN1ZDMmJ4?=
 =?utf-8?B?SGhWVU9CYTFET0hzYlB2dnVVQU12U3hNMVYwRXV3ZFgwVndNUndNNjNCRXdo?=
 =?utf-8?B?MERMMXpjczR6akJNQjUvUEpVYy9SbjFtd3pnb1lBcXZYNjJjMWhkeEpsbWV1?=
 =?utf-8?B?ekwySkMzMG1LZWV3UXlEMFk5bTlVbHFjcmZaYmZMdDNxL0pzT3NqMXFtOWN1?=
 =?utf-8?B?SFBESzNWZVZlTWh4NWpDZmViazVvN0VqMU5MM2V2NVZtSlNTc3NCMEZNUTZ4?=
 =?utf-8?B?QVJnOElKTlZqN2tRQTluUDlVcG9tdFljTThuVlpFWWIyN2ZnQVVZNkZvMERT?=
 =?utf-8?Q?1CpUy6iY9NQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cW5aTk1RY1J6UkU1bmdtVXltb3kwNTkzY1VCNlFqT3UxM0FFL2QvSVA4YXNl?=
 =?utf-8?B?dDhRZlBuSi9VUUV1SkcrNFpDelZaQ0xGN0hQR3o4SUdYaExrSUM3RzYvdmRa?=
 =?utf-8?B?SE5YdVZ3S29EMlNEaWFXVVRLUGVuVUJFd3pYQTFhNEJ5QWxSK0pXd20zZUZt?=
 =?utf-8?B?dWVTeE5CZEV1QUxkSHE0U2JDNk9ocitITlR6K1RaTWcxdU5Tc2UxMjhRTzVJ?=
 =?utf-8?B?MGFWbjY1UUMzWGs3UVE3bjArSnVCa1dIVTFicUxGdndqVkpBZFpyQTZxQnFS?=
 =?utf-8?B?Q1BUMForV0t0bDNGUWZCOHVMcElqRDB5bVcvaFYxQVorcFdBOXFSNWgycE1L?=
 =?utf-8?B?N3lvRkJrM1J2WnlOMVlVVkVJcW9ueEwycXVGNEtaN1hrdGJTRGFyVGlKeXB5?=
 =?utf-8?B?VUxiNG1WQStaQTV5N0lwYUZNT2VNZUJna05sWHhWVXFGN09WUWtNQ3NacTlF?=
 =?utf-8?B?bGRjL242ZXAzUy92SVlENW0zdXZWWm5OZmgxV2ZEbnh6MzJ6RTlLamd3NUpw?=
 =?utf-8?B?d01jZC9Sbll5ZytQYm9tUlV4RFRtOTV3ZzIxN2puYXpRdkNTYlpzZ3oxSmZV?=
 =?utf-8?B?ajc0VHdVeXZ4TXE2elloYVpudFNDODFTazRzNzRoMXYyeEJFUWg5SGhDNWZQ?=
 =?utf-8?B?dzlNNHpnSHV2ejFQRlBiMHRhYzdRUnFhWGlVaStMK0x0cDhudG9FcjlyQzE4?=
 =?utf-8?B?a1Z3dWxvR1Jzc1IxazdiUmhGYytSUFhOKzNLOVlQeWgvVEhQRS91dzd2bkx5?=
 =?utf-8?B?WDMweEVIOHZDSElOSTJxTXQyaFVEV1FGRENjNkR6NDN4SGtXZTRRR3crYjBL?=
 =?utf-8?B?L3Y2azlMQzAyNUpMSnVra3JWTUwwaGVtd3B5Tm1vMktkTThqcDBmT1oxRXQw?=
 =?utf-8?B?bElWS20wODkxL3pTRWd6eFJxcWxiZ1RVMHFpYUdYOEYxOVdzanVoUkJFWTRp?=
 =?utf-8?B?bThEUndQS3MwWU1Ia21DQXpveXd3dDJWL3ZzZTBtaFBaZ3FhNk5lR2oxZFE4?=
 =?utf-8?B?QzhCS1lSVnZLQWZSejhUL2ZsTUhNb3gwcXZrV3c1SllieStyWnZ4b0JSUDAx?=
 =?utf-8?B?NXRibUlQWWU4bmRYemJuclJrZEhkbFhoc05sT3Rma1c1S1hFYUd4MGF3Ukxm?=
 =?utf-8?B?VnR0NDdFbjhMTmFTZ1B5ZEIzclBKc2UyWndTWW1kSTBXQlpyRDRMY2dSbC9l?=
 =?utf-8?B?WUZYMXVtc0cxUUhhODhmV1RiSnNBNHFzTEJNQTNmbGhRNTE1R0FydDUxUDlv?=
 =?utf-8?B?RW1SR1NLTzI3MmRraGVHQlhZN0NmcUdKWnRwU3kwUFpibnNuTWRITEZKejBM?=
 =?utf-8?B?YTRkMHZZSkN5MnV2MlNQRHJuQXNyY3pIcEF5andOeG05c2VwdHZqV1RydklZ?=
 =?utf-8?B?Mm93SEExQjY2c1V0RmhtR2NzdXNOWWhvL0dhRXhGSDdFMWZhMTd0NEpKYlc1?=
 =?utf-8?B?U1cvZm1BSGZZN1E5QzU4K0E5aGZQZGIrL1BXRHhBQnhjYmFuVExta0Z5eUZN?=
 =?utf-8?B?YlFwZFVKdlo5UDBGUVVudTZMNzdRNzFhSFdwd2RMZ1BVOU5STk11ODl1YnNy?=
 =?utf-8?B?UE1zbmh5VVlsc1dON0VjcjhPK1VFQWJBbms5Z3dvd0YvOUdoU0V2aGtvODJR?=
 =?utf-8?B?RXdNaUhGRDdBVy85Q2h3U2VBRWwwM0lOa1hTMyt0TFhqZTFRSFBLOVR4T253?=
 =?utf-8?B?MG13RERmWWZTRkdTelFSZ0QrNmJ4aUM0YU9lNUNNM2JsTWx1VnJWUkdxVG1h?=
 =?utf-8?B?Vzk4Mi9nbGlZbDhWVnltWlF5cS94MUYvNWZZSWg0bkliZVdzRUtiTkFNUVZZ?=
 =?utf-8?B?dklWd21KZDR2VEZRcW9tTTF2bk5XVUhKeEJoTEx1TlZJWmpVM2pTRkQ5eHVX?=
 =?utf-8?B?ZmJiOVgrZjZ5TE5wYXFWN3crNVozZldKSCtjUXBJbjJVS2pEd0NGVTZGam9s?=
 =?utf-8?B?T0UyYmsvWG9YNmhmTTRsVzdOZWJFRnFkSk9PQmhRYnI4aTlVVjFud1FMVmZK?=
 =?utf-8?B?N3ZXLzBaNGhRSzVzclVIekJqYkdDVUo2OE4vdDdYbjdzTXdnRTRvYkViQVVB?=
 =?utf-8?B?R3JCdnlrcGx4OXBLTm9wUzR5WEZkNlRsY3owNFdPNFAydWFEdGFqVVcxLzEx?=
 =?utf-8?B?a3pyOXkyVWl1NnRXTHhkamc1ZWtHYkY2Ujd1R3hFV0tSL29LQlRmVlA5SVIx?=
 =?utf-8?B?T2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ULP1pbowa6tUnUvoCV47H0BahuyY2MspqxlJHXi+YwDNuPVtqetKyxwSPLNv92iZMJ+UUD0qP9ExYYy4qy3z1mHN8qYSuSU7IDPKFw5w6X99hE9jrhU9zTluMrA5lZhpNrbsxRaYfNxKFXLW+ukMT4lw6tsTfQILQ96pUQx+ZCYEAPqtDULG8drZFSKwt8GYZTOfcOXuTNAKDB5DJi5fvlkEdsTryfugXV+fW8XNKgJ2PcGmRqpxrslV5qcCcXYHjNpvZl2Kl0Dv4RoxDgYkkvipu8+GNVtlkmVUX3991a0Vl3Bm5ORGnoB/D7aXWcI5JgxBceDhM2xJ2V2FVJU/CiWPiAL62v8qhjykQadakouuMLe7b5PRIcBljP4IBWdwJmDq3p5cwiPFmbYffNrA6A9k+Dn5y19Xm6ySKm4AkuzGe+E2m9eByTJXGj14p+XvciSOZLl92ZKEgSst7ASRXOKMVj8KGVy0B8exEqnFfUiWv2rcfYP/zqOSVyHsc1Bey7+M3LlBYSHnY1inoKbW6417ZQB4dE5+OF9TKEU9Y8mrITenllUPWv6TfZf9AOB1zb0vwrnOTTff3dfy9zvZGz5ohoxH6ctuSEZDPj+cWjo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67ee4ab0-fc8b-4779-e5cc-08ddb573586a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 12:08:36.9851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fWgEIY80F/3yOxRQKzLZw91E6LTPYAZbKr5zKGivuCYmWhUtx/GmIKJ6xWPLr+/l33+NnARdvRI5LJ3vzIEgFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4563
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-27_04,2025-06-26_05,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506270100
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI3MDEwMCBTYWx0ZWRfX83C3/UCa3a0+ GpL4Ukj5CTVGjj2LTBSH+gfmoCKlbl0YoscHhsLLoigOBo2cER79IVi2cq/qE9XZmzNNP22uvJ9 rjv6GtHPcCRWjM/2XJ4vsjmbDLM2/c52WMtJeoyKTKF5b21umtkHtjkikVZeu7h4UA6lFqz3HBF
 vXoplViT6pqXpNTPIUZ8ZqqN31NKWJKuZyeqNj+jbEu/7XFlbbRuBhiAV7xV1pFv59RaGTw5SHg qnAecruE24Wu16CmVwz60b5ifHbNemtQ5OuAe6+H+RYkmYYtt8clYIIGDLX7vDfQD3iXQxWD1s7 L0meincrLa7sCp/LoFfs2em89NM0K1ivXKE7oUWTYI7e8uipVSdqoEVBQOKzq+YbGBgDCypPt/B
 IsKohA6mMyfLtC1I44nOxKfVj8/Pg5A++c5LAbq2ZeD7XiROMrmGQ2ThE8msxq72lejHW0/Q
X-Proofpoint-GUID: OG3ie3479PxWJwIOu96ksDjrL8ZAlePb
X-Authority-Analysis: v=2.4 cv=QNpoRhLL c=1 sm=1 tr=0 ts=685e89c9 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=N54-gffFAAAA:8 a=224zxjebeZxPBVwSzUcA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13215
X-Proofpoint-ORIG-GUID: OG3ie3479PxWJwIOu96ksDjrL8ZAlePb

On 24/06/2025 22:05, Bart Van Assche wrote:
> Instead of requiring the caller to cast away constness, make
> scsi_cmd_priv() accept const arguments.

Are there even instances where we are casting away const (for calling 
this function)? I assume not, since there are no changes to get rid of 
the casting away const.

> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   include/scsi/scsi_cmnd.h | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 154fbb39ca0c..09176b07e891 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -154,10 +154,10 @@ struct scsi_cmnd {
>    * Return the driver private allocation behind the command.
>    * Only works if cmd_size is set in the host template.
>    */
> -static inline void *scsi_cmd_priv(struct scsi_cmnd *cmd)
> -{
> -	return cmd + 1;
> -}
> +#define scsi_cmd_priv(cmd)                                         \
> +	_Generic(cmd,                                              \
> +		const struct scsi_cmnd *: (const void *)(cmd + 1), \
> +		struct scsi_cmnd *: (void *)(cmd + 1))
>   
>   void scsi_done(struct scsi_cmnd *cmd);
>   void scsi_done_direct(struct scsi_cmnd *cmd);

