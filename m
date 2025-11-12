Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D8C23B628
	for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2025 16:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762963402; cv=fail; b=ek4rnSCm7OKQBv/RvjuS8Zhy+n8DbfLuYmETAJ2Z+lrkgqNj+m02FvKE3AnV3ma95cUdIlj97XtJJ50l5JvSmGaj2DBluuQx5RN1YvDJ+ohDi5aifyvEv6m2wPsQZqPXnXQ1sMYNLW7gdAwNMdPKhjRwzR86+E/cYqDuM7bx3GE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762963402; c=relaxed/simple;
	bh=3SD5o9+xwyxEq07lg3X7k92lKls7ORVa7G/qhTrczC4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BHL+1ryFVVt0EGEPWJiDBQ+YGgldOGMFL+wLjGTbTYUZKXkXxCv3eim8MD3dqvIavG0Y4AiLYEhbVVV+IOcSzQpmUhZ0zvmp1Jw3xSLfh3dP4Rm4e/0NpitgzMWyt3oTKQLtwKDQTvoPbBOnMLVIebYFFs0ISRZOEvisUBDB7CU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=r1CcGFPO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TvihixTq; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r1CcGFPO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TvihixTq"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ACFj2j3006158;
	Wed, 12 Nov 2025 16:03:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=S8r+nBg30FJ+jg+CQlJQ11LQvKHeP3RxBIP84a3U9UI=; b=
	r1CcGFPOKyTpXJdmT1tzw8y2S+YqlbyhJ+CCylNi4EID9J0jD4p3alFlCypUx+SG
	fJDXVR3eJtM++ihbRjPePpi2ePkpVVkmbkAf8Ap/MTNP5Dk4O8wjevWOVcTCD7ud
	B4DDdgFYcSklczmu2Yr7LGzUISqG6yQ0R4NlulSkVRBW9owi+vq6TizV5HP2i0ef
	K1qiToDrzRyFNbjsXY1OaJ/Dq8YUzdfjn7qStXdWcaL/PvLtphPlCmBgMc6bp+11
	GWVey2yp4nIWYZuS6ejtZRf7kC1ce0DYgRjXSfUUIzrVoupfJCDPNP4wDT9qqfBI
	aAz4q3AkX5DSpnp46oHY/w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acw5f01t0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Nov 2025 16:03:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ACEG3Ic032351;
	Wed, 12 Nov 2025 16:02:47 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010003.outbound.protection.outlook.com [40.93.198.3])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vammmve-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Nov 2025 16:02:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WSOi5SB8H2Kwe7MKhExsBKD4M4n7rArP+AvsqmAV4ZVHqN5VUhjk8fgTCXAmjN/2kA5gsn0iL2139PsoRgf1NxFYpLLKm9dlyqayQ5aZN0KQErHT3lrkU05I5uf4lkj5QFMENXrnC6u7oLmydB4g+SSRqeSLW0MGdzTlgjlpeckbtOXJ+j4Q+8iRQqaJoPrPj0EbQo+AezOgKxoOH5gGi3wGrkaLPB0yESdNWFjdTKgfjQqESvAGDF6BQ6GCARie5SoU3HIjB+Cy3/JvRWjNCciMHo2cnguKoov/RhVEdD6QmNvfa2KEbv7bBWu/iWqOJUjuPAp37KjRb5/hLnhXkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S8r+nBg30FJ+jg+CQlJQ11LQvKHeP3RxBIP84a3U9UI=;
 b=Bxr36h+keJHNgiU7vLJcmY3wknv0BDFH/HzEuFiL32nhjVo2pTqywatgyznpa/PfXf8uOvVbYG4o80i6Qux4grR5dZHOq5JD8Aksf2MrxyQgSilC/vtDBupOgeEeazRwnC0aMMxQSLqWBTbPGvtn4N56YngPylrgrNJPyg2IJgdQF0Z+lmLrC6rVOpZyuU2oBabqI9yggsZCeySuSiYaUvnNaR7WerJlHJ7Wx2QvOqn8YsZz4OeD9rqURQlf0AfD375LpQ1bd/0GkZMkfVQ4dNdpQIpAruXdgnR2ivBgJON6gCruq0KkMlTPQOoORWKZHggC8FfActdaCZ6tyR1DBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S8r+nBg30FJ+jg+CQlJQ11LQvKHeP3RxBIP84a3U9UI=;
 b=TvihixTqF/ENTDbegqTAgNyV83u5I+eHhOaZag99+jTjDEiyNak7yMhhsll99iFHuAUSshWN8HXnv8BbA8CrDqTaJXESqHsKirv06BBfeNr2a5j139JnanOQD68K88K5oACUABviuPsFrSM0N+3m3WSh9JDXHz9uPeHYvQIWEvQ=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DM4PR10MB6085.namprd10.prod.outlook.com (2603:10b6:8:bd::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.16; Wed, 12 Nov 2025 16:02:42 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.015; Wed, 12 Nov 2025
 16:02:42 +0000
Message-ID: <7b020e5f-3fca-48eb-bd20-cb0521120f5b@oracle.com>
Date: Wed, 12 Nov 2025 16:02:39 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: scsi: scsi_debug: make timeout faults by set delay to maximum
 value
To: JiangJianJun <jiangjianjun3@huawei.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc: bvanassche@acm.org, hewenliang4@huawei.com, yangyun50@huawei.com,
        wuyifeng10@huawei.com
References: <be49d9df-2738-4864-839d-99f24d77a058@oracle.com>
 <20251112133816.343-1-jiangjianjun3@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251112133816.343-1-jiangjianjun3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0024.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::11) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DM4PR10MB6085:EE_
X-MS-Office365-Filtering-Correlation-Id: d8fe2ba6-37ed-45f3-e973-08de2204e94b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZU0waEFhUGFoOXA4TDJvSldZdFBCRk42V3ZDNlZhMVV0QVRaWFpNZmdudGgz?=
 =?utf-8?B?RUZoU0M4VUV4UGtpQVhFdjRoemNFMFZKeDdua0hpUXovL3dWVlpRNEsxQ28r?=
 =?utf-8?B?cDd2ZUdSS3BBb0ZYSmMyWUpTR3IwWjlXa2pabVhya2ZUMi85UXVWb0hvNGlL?=
 =?utf-8?B?S1pPQjlDaW11Z0dBb0NIclhjTlI1aDdwVkpMS0o3eTl5cU1rbTJjemI2ZjNQ?=
 =?utf-8?B?RDVaSnB3eVhqblZ6dnB1YUh1RmxCVUhzemR4N2JkUzhlckpPVmM0QWFMTHRS?=
 =?utf-8?B?SjF5NnRKdmd3V2FldnpKNVg5dFM2RTZaeGJSdUVPemNXRGRITHF5V051NHlt?=
 =?utf-8?B?aTdNZkoyVzZlL1hGK0FrY0p5TXhyTU1DWEZmakY1VEZIbWNPbkJ6SkZIMWtC?=
 =?utf-8?B?Z3I3eVUvZ283QnVvQjBuQ1E2WnUzNXVrcUtMaytaMy8wT0h6U0kraThPc3ZZ?=
 =?utf-8?B?R0NwYnpkYXluRXZFOHZmUVdtNVA3WEI4ZnBoK2VSTGpMWlJsR1dYV3cyM1Q4?=
 =?utf-8?B?OFdIV0d5N0IzaXU1Mm4rOUU1WVRWK0YzMEdLY3BrYjlKU2JRTnMvYXIzNHBr?=
 =?utf-8?B?QldWVnJWaUk4ZjNhQWV5UXBrUkk1L1lUN3J3Q1lYMnYyejNXV24zZ3EzY3Z0?=
 =?utf-8?B?VEV3T2R5bWxNZ0I2cUlySFprTmFaUm9DODNJU1dDWGZRVlpnZTRJM3pvOW94?=
 =?utf-8?B?M3cyMEhLdTBHcUJ2eUpuZEwrTlM2SmdOaEpjaVJEZnJYUnM5Mm9qaE1zMEty?=
 =?utf-8?B?L3YxUklHRWkzQm5ySTNzQnpDQXptaSs3WW9VMERCZm04Z3Z4c3VHenNPRmJE?=
 =?utf-8?B?cGd1SWNjc216czhmaDJsUjMrL1IvMWhlMXhPTVdWRDBTdm83UmVxSkdrWm5U?=
 =?utf-8?B?aStxZmhlbWZ5RGJWQjZWendiNE1FaDdNcDR4SWphRnExeEg0Z2crWnFwYll4?=
 =?utf-8?B?ZEJoRHBKUnh6MGFlY0YrZjB4T3hQUUVlbWJCZkVOTmFiRXhBUFA4aEFIWjZM?=
 =?utf-8?B?ei9qTjgwNHB6MnYxc3ZVVXpmTDN5VTdjcXg4bmpmZE4xQ0cxL25VclVsRWln?=
 =?utf-8?B?ZWl2d3Jvd3VIWERqa2ZYQUxPSmxkczFjU1N3TWQ1dXBhYm5tNGdHZ2hvNk5B?=
 =?utf-8?B?a0lzL1Jrb3JrVksxVEc1VEJWUGlFTlliaW1QQVQ2OFBnNHY1UzYxV0I1SVg3?=
 =?utf-8?B?NVJmZ0xNQVJqd2pqR0VuRkxZSXlPZUVNZE1peVBaZG5jelVSM2RKYVY5bWlB?=
 =?utf-8?B?Vmt3NHhPMUE4M3RSaHBjck9TdVFCcDgzcUI2cXhnOXVSQkVmazlkVnVyeWN6?=
 =?utf-8?B?NlBDODEzcXgzbFlFMitxTis2dkhudlpwNTIvK2VIS0lSTDdoMGxiaXIrQmdv?=
 =?utf-8?B?QUh1Q3QwYkdzNmorQW50VGQ1eGswalBOMEY3K1QxQ0hYZCtVa0JlMytNZnIx?=
 =?utf-8?B?NDhZNXRHRzVLUmxnbEsvTHlWZWRDV3V0OWFwSlJiQkZyWGhQWU1DTWJob3B0?=
 =?utf-8?B?TDRabEhuSW1ONVJodUdmbTBTRlYrcTR1MGd0c0pmcjZkdXpxVjEyTGVKSnVS?=
 =?utf-8?B?UTlldnhZd2RWUG1YeUcrQlpXUW1oZFNBcGZHVUs5OGh4Z2EzN2FNY1JROTc5?=
 =?utf-8?B?Y0dndHo5bEoySEZXK2xJRVRyK05lV1RiUFZyanZKT29icW5YQ2xRMTdJamd3?=
 =?utf-8?B?WGNMTk0rVVdtNlcxa0k3aFoyc3JZZFNKVjJhYk5uTDVNMHRFZGtYdEFxRzRy?=
 =?utf-8?B?KzZiYi9iQWxldWJxOG1ZWlpUcS93VEN3UGhCelljZGVYVW10cENQWi95U3U3?=
 =?utf-8?B?bTd1ZStGcUxBUVJxTVNzcnZrbGd3ejhZdzNTaHJhOGJBaGlIdEx6em90OGZm?=
 =?utf-8?B?Wjc3cjBUZXdkUEFTSEIvOWlXN3BqdER2eFV4VUZXNnVUSWxKQm96OFZIbFFF?=
 =?utf-8?Q?WtAsGLmDfI1UI6Fpped/8o2EjfwRuoky?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c1hlKzh2SnlCT1c2bUQ1dHIwNUJ0cW5vdldSU1hia1dRcHB2ZHc1SnlJenBT?=
 =?utf-8?B?eEx3SXZMWENxNVUwcXhnb2xocVh6L1dTY3MwZHBhVW9FME4raHRuRU42VnJI?=
 =?utf-8?B?ZldWMUZoYXpLTDJhWjBkRThBV0tIUE1FTkJ3VU9mL1k0Q1puOExqb0wremly?=
 =?utf-8?B?VXdwZXA3d0ZGZjV3NWUvTENOejNLYmFVMnpoZlZua1ZsVStNVlF6VWxnNUxh?=
 =?utf-8?B?NG9PbVB2UFR4V1dzeFFJd2VsTEtNTmxMN1BoMDRiYzdjZjhwczlrYmRvSWJ6?=
 =?utf-8?B?VkVxVk10K3crdkExekdpdUNUZTNLSzJETytQQTdseWdNZHA5ZjhmYWJsVTkv?=
 =?utf-8?B?VVVNQWU0bUJXRHdxalNqWUt0dEhoamI3MjhxbXc4VURVU2pERm5BUUM0Yk5u?=
 =?utf-8?B?VlAwd2ZTeFVRbGd1eUVxKzh5RkdXbkJydlhwWXQ0QmpWemFqV2dReU44OXp5?=
 =?utf-8?B?OFdMbERPNS9jdDRCS29HV0hqK1Q3ZU5DYzhhZUtVRjFtTGllOEcrYmluUFJR?=
 =?utf-8?B?dDdRZDVWMUExZ1dBWTFva3BpWG55T0hmRW1Xb3hrazF1dUt2VkZCYWRUWkhE?=
 =?utf-8?B?ajJvZXVKQnBOTUYwODJMaUh3NGM2Q3ZscHN0NzJYRVVUQkRqd3E4bHZUbHdE?=
 =?utf-8?B?eTN3bFhJTmhKcG1LVmFlM3RqaEVtdUxueGZWYldieHZ5dnMwWnVPYng0Lys0?=
 =?utf-8?B?ZDV5bklhR2E1TGhsQ2plWnYxT0tGZ3puYjVYN0lqNUFmc1p1MU5HQlErMmpC?=
 =?utf-8?B?UWMrcG1vSlZYTUlMSDllRnRXd00rZHZ2cTRVNVB3Z3hJNlg4UFVsYzNyYTdq?=
 =?utf-8?B?K0U4M2tqTWROWVA3Ujg3T1N6NEhxTW1EbHQ3MktnNlNyT0ZsK3FWaVdvK05q?=
 =?utf-8?B?ZUswekM5b1dkY3pZMkNzeTRYMm9tY2FlOFlneGZMbTIrNHp3V25nTXRHclhV?=
 =?utf-8?B?R0l3Q09iNEQ1a2dqMkhLb1E1SVB3TTUxWEZWTTc0OHd6VkpQTnhSejZYMUVw?=
 =?utf-8?B?NG9hbWFkTFh2Z242UUpqdktmN2ZlbUNxSEMxQytpc2x1alI1Zkkwai9sVlhx?=
 =?utf-8?B?dy9lcXE4VC84V0o4VWFpOE5Nd053WldZS0V6b2hxQk1wSU0xYTRyb05zRGJM?=
 =?utf-8?B?bXpTd3k1VWF0QVpCMkZwRTNuZTR3V0lwbTJSTE9mOGlKai83TWJxK3d6aTIy?=
 =?utf-8?B?R3RsM0ZQTTdaRGJub05rMkptU21RUE16eFQzSVd6L3ZTUUtGNHh6N1k1NWZM?=
 =?utf-8?B?SVowTnFVK1NlVTI2OUVycEs2c0RIZHpCMGJMS1dhUXFwb01zK0h1Z3NtZmZI?=
 =?utf-8?B?dkYzcFA3RU1yYnMyT2wvVkVSUFovYzdkVEh4UEx3YzBtdzdxUXBZajl4empV?=
 =?utf-8?B?Snc4Qk1DQnJvdisrY3hUelhzanVaRHBuSThDbGNVdHBmU05JdjBqNm1RZU45?=
 =?utf-8?B?SnBCTEl0b0EwWkVJR213d0FZckVCZithUFZhdFJkTzcwUENXNHk2TjhwVzdC?=
 =?utf-8?B?Y2REcncvbWd1S2w0VXcvejFpNlQ5VEpHZjVEQUpDYnM1Z09KQWkxQXVtYXZQ?=
 =?utf-8?B?S1dBSWQ5RmVqV2Q5MlUxOUpuK2hNYm83NzFuSW9Gdm4vVXU3amVSMVBMcXhX?=
 =?utf-8?B?S1MycktQQW16NUlkVzV1ODhUNmpKYW9zMjAwTHdrUEV4Uk90VDlIU09xSUxz?=
 =?utf-8?B?TWNmODFhQzBFWEg1V29kZlNZOE00OFNuVGtuNDJKNWR3VnBHeEtqcS8zUmVi?=
 =?utf-8?B?eXBWU05uNDUwdTJGREtheG5iL3lwb1pDSWwybUxpNDRKYnBBeUNGNHB1c1J1?=
 =?utf-8?B?RjBCYzVNR2wzdmQ2cXVyOXhHTyswTXhJY213aGt0UTZ5bHJmaFluR1NVV0Ez?=
 =?utf-8?B?RC83cGJmaS9CT3A5eGRtUE5uRHBvTGo5VWJCbGI0dDYrT0RIM3lkNTVZTnBp?=
 =?utf-8?B?UlZScnBwODRpYzh0em5WNWNkVlJiMkovK2NXSmJaQXdmVE9Oa1Z6MEFUbWdT?=
 =?utf-8?B?dEdGN2EwMS9wNkdDN0R0c1BHNDVuUkhyZGZuOFgzbitlSmxGMzV2QWpGemlE?=
 =?utf-8?B?REt3UUp2WTcvNnQyTEZEcjVtdnp6dlR4L3k2bUczaGxUaXF0MlFPajJFZUcy?=
 =?utf-8?B?aXd6TVlZNnJ0Q3lvSm9ITEpPR0xnekZvSGtwSlJYSlhBYUZ0U0JPQVZUNGtz?=
 =?utf-8?B?RlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GF8zsSjMHuYtqleddgAoa8QZzSUhs5hAE6gby9fKCZQml38/gUwDYXr4UZbu6+uJPg3nq3hVMRROmx8Kpy6dRy/Lp0NsdrfkWy20KJDjMJzZAnd+xhjlqlte7JBCeTimLErlbz+ybx2Iu+JWP65mZoKOdSp91FON+2+rFgOHzc2qABVESw60pTQayTyVKaSmwyLlWXV2R/OzyuWKAYLy3g5y1wWkSqG9tqyIpSuFHc/8QtPgSMYdjjrSfEcywfKh2a2mVaOpE7fCa6/z02llUES6stEj8/KbFifOFT22IFLNBu8QeiGQILZZAumwUP4TbM05kMW31eLkTo+T4H/JBPnCKT8xuqfStuVdaVFIuI805xpW5u7jPDpa8lXVgA75pnGiicQcjGs22rLuKW0z6yxGu4oP2QjPn1PTQe1xbVPO0RiFsH94l+xQzcRMo6WAn3Lx9H3KN15eXrOq02HPxH1WmBKoDJQA8M0sWEA5qJE1pUyib/gukjl0hz5ojC476adIkqMshL6H7kgHcm2q0hNvRtq8UaWTKoSChTv3PhMrXC3abf3DyaZ9YByJtu0yfqPOwILi/DOaNqguoUL9hKQMVD655Nggy6k62t69IgI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8fe2ba6-37ed-45f3-e973-08de2204e94b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 16:02:42.3941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ktQI+WEq3TowR1ktqyTKn3qw8HWfeOMH7m6KRuAPYti5ytQ5gMXPEAuTYpQrrcHJRvG/Dkp3EiGXh8pq3USAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6085
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_05,2025-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511120129
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDEyNiBTYWx0ZWRfXzRYsX9Pmd2QS
 ENnlVsdD94OS7aDUN8ON/7PRhQ7MAP3Jb+HYDnGrCFerbsYf7ouWo3QmW+uUXogR13QBJ87ct3U
 uqmZqA5hhb6yyRfmZYVJPZU97wYe9S8aoiJr9DkQIgbEexxhZ70BdT49300lOgRCymvR0r+raj9
 LlHoVmudIo1cduLyWA4fqGrSYVHxqwPtqaht9oAH5XAe3rYfWMgApGjc2XhYGM+8j3qan4wH1Wh
 Ad2D8X7zZAMDkb59uvyG3DblgE06RKqOkXWZCt2ho1Ku8mBugcVdNRcY1K5PCHXeLbPTltcC9u4
 8WzQZDEFo+F2pT81A340DIJfh0afBQ59tW2N55X0Ds9Exa4JMKqpeeOjLExEC0p0IA9PxZFuXG9
 QeY4ttK+sAMLBKI9Q3w2nMqrz20kmImSlF2hmCpvYQbBHG6rboQ=
X-Proofpoint-GUID: 6l67vcQUVkzvVDcGR0laUnopDuTkm32i
X-Proofpoint-ORIG-GUID: 6l67vcQUVkzvVDcGR0laUnopDuTkm32i
X-Authority-Analysis: v=2.4 cv=Ju38bc4C c=1 sm=1 tr=0 ts=6914afb8 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=awrH-12IlWaLVWITMc8A:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12100

On 12/11/2025 13:38, JiangJianJun wrote:
>> uh, I never thought that this thing actually was accepted
> 
> Have you reviewed this commit before?
> 
> You seem to think that this feature is not good.
> 

The concern which I mentioned before was that we would have competing 
and potentially conflicting methods to trigger and handle errors.

> 
> 
>> Again I will ask - which of my changes are you referring to? Provide
> 
>> commit ids, please.
> 
> The email I am replying to now is the change.
> 
> And the commit id: ac0fb4a55bde561c46fc7445642a722803176b33.

This specifically is a change from Bart to fix my code. However I added 
the change to check the abort result.

I think previously scsi_debug_abort() would just always report success, 
even if scsi_debug_abort_cmnd() possibly fails, right?

Now for a fake timeout, there seems to be a problem in 
scsi_debug_stop_cmnd() that we abort depending on the deferred type, but 
this is not set for any fake timeout. Or - more specifically - it is not 
reset for when the scmd is recycled. I think that we should just allow 
the abort to be successful for that case.

