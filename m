Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDE22FCC1E
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 09:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763110944; cv=fail; b=OZ7Kbxut06Vner586cLH7W31WAzUw0a+nPh/mPcgocVJeEjEIJ5jWzuItbBrqikKkPpzBOTAs2kxvX3wtl6eiANh+YKvhrwsbqpEAZaFsm5NVKBIrbJryV9zaXoVHOqEInwLlzT9AIy9qhaNVCFu5nfaLvC6HCaB5hx1yOHZCpY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763110944; c=relaxed/simple;
	bh=bK1S9vB+7DolJB/MZzP+wkv+bEktptJQRwdkpRgyukc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JYb5X8bN4pOWRDDm0L6Zt7+/ib409LIxbPH0XeNxqlWIW6fUL2w4Jv9f36asLgdKsG3TVHHP40Ujo+91U1xLlL1nUZrzCRkTKEWEvKcU0ud3OWMWe96uZdSw/nm9CihfjwGjad/jseoP9k8/CK6BW5VPTc44IG8WyXQBbU+puOI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=p+Vm6F9c; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hK+ZHLYI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="p+Vm6F9c";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hK+ZHLYI"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AE1gere000841;
	Fri, 14 Nov 2025 09:02:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=MKAaTkPVKoHGl5Ttgq307gokj43QOrtA7cgg5Mqbdo0=; b=
	p+Vm6F9c01ho6DRWGchEfbtdjINTs15ZCuBXuVBCUV1/iiHNjkaKYxdXGCJohP55
	J8COoqW5hmYQPShIdw7r/VuTO6Na/3xQxxWse2x/Kf6YFPPQ7BEyftXYTZUhRLT3
	3fxdfnJO6RVxvpUFdOvXP4BtQHk4Knjc4HmC1hc65blbDz253EVINi1nxryNqiXc
	qNLzc+2fq1VT64Fv4y1zN1XizbTfP0FRnLjPehXSWLfy6dEv2I6OduDHddTf782s
	pO9EElcUY60sngeCU8ESdK+tXIJXxxrgwHzRQDnFzdO6X513Knp5i95QLZB1rPJt
	kX3CWxEslpl6Cp3vPAPvSg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4adr8ugq11-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Nov 2025 09:02:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AE7VBJ8003108;
	Fri, 14 Nov 2025 09:02:10 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011049.outbound.protection.outlook.com [52.101.62.49])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vadsuh9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Nov 2025 09:02:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dL0XtIuIafokNZM81a0FVPTTFDVwwPJ0oYisuF7EMoPB8AwxuIPwVCfGAf2ghJwlR3MpNAuP49eg+nGlE45ToFd2vFvXz78FtsWaxEIex21DV975vP9kpwB3I5m8+k/5rr64RSh37iFyjLqtsjZE65xManWcVGuoBIe7FMcUg5M1BNUcsmtEgBEtkMzRHe9e/WjdSZ6VpKSEu2/OWlIP23nm2eJ4P+lMVRFKEZelWIzGlOXXT0h+ij+AZq0y90BCgp7JQsOa8+FFTpicwpRewGL58U0zsmqJ2zABIbtK23rnaAvr0rCdGIv7wZBTHjtrmKazafOIDsXXlo0PPLeI3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MKAaTkPVKoHGl5Ttgq307gokj43QOrtA7cgg5Mqbdo0=;
 b=DzkBB9eTw2EmfVldvfeGK7KgF4FiZyc4lMwBwOja0ZIi3sknuxyT4O4PAUtXLmqcE+dcazUGDLkM79OkL9UIG/ZOn/KMFGfPHUHzUvahK2xwKulZ7NlrC4ZRkVAH5Epmn+/jFiKBx3H+kT4WJItoXPcSlx5pxJNxEvzODgvV0MRcxomap9CPhBz4kM2UeStG4llxksQ4ux7To7YnedLjNUxXEm5jsM2qqWsOk33a+2URVxHtpS/h/meVqgElnUHLywPsL5RH4Sp4RUpdghrrBYq7f8ceTKORfCi8CkQAKjTuAeoy+HKgkKfafXIu7u03l78/1QKVfRTptR2wyiuwaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MKAaTkPVKoHGl5Ttgq307gokj43QOrtA7cgg5Mqbdo0=;
 b=hK+ZHLYIw1jOnnX38PRuIWJElPTGjrbceFQb3Ml2lZfDq43Jh+8nf+FzKMp7gguCulqcpWMB/lLjSl/d26LiRQF1PfzK7WjVoLqpCUjUdZFGclQF8sbeDAHRUzfXRS3BSokrKx0DvbU3vQFk+rRHH2ioChuq2jd5HmJr9MxOu7Q=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SJ0PR10MB4511.namprd10.prod.outlook.com (2603:10b6:a03:2de::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.13; Fri, 14 Nov
 2025 09:02:07 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.015; Fri, 14 Nov 2025
 09:02:07 +0000
Message-ID: <a0e4fdd2-3dce-46c8-94ad-cdddbf90676a@oracle.com>
Date: Fri, 14 Nov 2025 09:02:05 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] scsi: scsi_debug: Stop using READ/WRITE_ONCE() when
 accessing sdebug_defer.defer_t
To: Bart Van Assche <bvanassche@acm.org>, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, jiangjianjun3@huawei.com
References: <20251113133645.2898748-1-john.g.garry@oracle.com>
 <20251113133645.2898748-3-john.g.garry@oracle.com>
 <0108b7fd-77c5-4aa5-a761-2a7640d2a024@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <0108b7fd-77c5-4aa5-a761-2a7640d2a024@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0111.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::11) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SJ0PR10MB4511:EE_
X-MS-Office365-Filtering-Correlation-Id: 390d58a8-aebd-4f0d-4340-08de235c7cbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WXRwMzJWUVJROURNdHJ5Ukh1eVlpKzlPZ1dWbUt3emRoMTFLdTRadjFGYmNL?=
 =?utf-8?B?QUdBQko1eXpJQnFJT2pPSlNxcGU3R0swTjgySU1kQzZwQlhTaWlMbEFtSHZl?=
 =?utf-8?B?aEtFL3FiSGNmN1cxU0hPTW5jV3FYeERySDFaWjNjTlhzWm5LR3RMZjVvNzBB?=
 =?utf-8?B?c2RjbXRWVGo1U0VQU09GaklveTduMmZzWHNBZGtkY2lndUdDeFVhTmtiazMz?=
 =?utf-8?B?b0RuUWR0anI2eUxGSHNpalg4V3pDd2JNaHdjTzVPeEtqWW9CWnVuWHdqalE1?=
 =?utf-8?B?RHZLSVRsR1llaHVESU1ncVoweC9wbVkvS2krcmg5NS9FaGlCd2p6QXM4anBn?=
 =?utf-8?B?ZGNkTGw5Tk1GK3dqejVkclovVDBiUzYzUlBsNkFyVDNudkJyZjc3SGo2ZXNH?=
 =?utf-8?B?QURaOG1PT1FDQWdWME8xVGUwemNOOGhxZllZMDJhNjJ6WU84NTladDR4Mloz?=
 =?utf-8?B?L3RlOUI4QmpGWENSV1NVSEFQU3hMdUtSUDZuSk14WnJ3bFZZOG8wQXVlNXFs?=
 =?utf-8?B?Y1h6YStuTGxHWXVZbEJ4SUE1aVhUZmlxOFVrcjk4T3FHL0o5eElUdjZMOVVY?=
 =?utf-8?B?V3dQZXVFRk00MDd3d21iSDNyVzJtMm5xcGdTTEJGSXVGcHUxSGFwc0JFcmVh?=
 =?utf-8?B?NmJtODBMRW8zQW9YTVFQZ0hKVmZXNlp2R1Urc055M1BtTVl4TWZyQStKWUg5?=
 =?utf-8?B?Z3dHNFBaQUQwSHcwcEhYRzVTRWxqWkJDWUF4UHpmeXJ3UFVpK3ZPZkk0blI1?=
 =?utf-8?B?MlVGdUhzaFhNdHJpdFBHTnZ5bmttcWdwQ290TkRXMFV1WitOdGpoeUVxbkxu?=
 =?utf-8?B?NHczTXJkaGtKRzVPbFBVSFowcVhZSDEvVmpIN2ZJZUV0bVlxeEQrbGE2cWlv?=
 =?utf-8?B?TWtwdnI0bmxvV2ZFYmsvSGJJMk1VWkhWV2xjdzZHWmtzT1dkSk1IWXJKY0hZ?=
 =?utf-8?B?WlVIckcybHZGVVp0eGJqakY1cG5ibUFxTlRsdDZXb2pJbXlzeTM0aXZWd0Ni?=
 =?utf-8?B?b1NwemVWd2pMWTBzN1BFQmEwZlNUaVlxL1RPd2xEL2x0aVB4VUVsK2NRVmI0?=
 =?utf-8?B?Y2ZJa3Z6bjFnY0RNNlFOS1JhbngrYzAyeFhLSFpEQlpQR2RrUlJQYVNGK2ZS?=
 =?utf-8?B?VGR2NGJVQ1pnbTVETXJGUUJ4R0xmQm15UFlNS1V0aEJEVFhlbFRoa2E4Mnlk?=
 =?utf-8?B?RDZBcDE4SkZFZndydWV6cnlXMjlENkYwT2tGRkYwUHpBbVRURkdkRVBuSUJO?=
 =?utf-8?B?cmpqdnJzOWx3QlhrSStxc3lDUUx2ZXpZcXAwNzZOaW8zalVDNnZzMm9abzNP?=
 =?utf-8?B?SkRObjFXdzYyYzVFMFU4V01TL0F0YjdOY2dMa1F5VmRkRzh1cCtSTWh2N2Y2?=
 =?utf-8?B?ZjFyYUxXSFg5WEFDZ3lQbURNd1dncFkvSmRMYmZYZFNSaFg1S1VmRHZ0TGs2?=
 =?utf-8?B?ZGJQbU1FK01vd0EwaGxESHlUa1JnRVlQVUkxbDgwNWdqeEc4RVIwSzNXaVRC?=
 =?utf-8?B?Y0dzRFhJQ09kRVFQd1ppc3pDVkp0bDRyMjZRdXlHZWZNVk1EU2RIY2ZkVCtn?=
 =?utf-8?B?UHR2a3RFZ0hDRjAvSDhGTlpkdDRjV3JPejU1eG15b0xGRitoUWJOSmJyOTJ2?=
 =?utf-8?B?My9YenJ4YjRyd1EyMjVndkJubzJCSVE5UWhxSWVacFVZeXd1dHoxSjF0K29G?=
 =?utf-8?B?aWM2Qm9tTHNPMm9RZEgxY3lRUjRFR09xQVhmRE1ySGc3S09zRUNJQ3RqWEZy?=
 =?utf-8?B?WkdXMjlOUHJSNE9OMEZVd09UdElnZGRVdmd3S1lYMWJmMU42eGhwWWVOOUdW?=
 =?utf-8?B?ZEdDY1pvalpSaE9vak8xNkY5RWQ1OXFmZVlGNGxSN01kNk9PWEVjZ2tQOE5u?=
 =?utf-8?B?a3JOdHlwMDVMYXJlSGVmWm5COE5aSldGbWp2RnpVTzJQYzgyMTcvNEppcFJP?=
 =?utf-8?Q?e3Y/RAvFG9ePu4ayzynfaHRYf+NBg1mq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?LzdxUHJSQjMrTnNlRFVqcVAySnZ2czhKaU9VQW1LUStXTFVpY0pzb3BMRmx5?=
 =?utf-8?B?dkxCZThpQWo5ZHVzN3BGRmVXLzVKd2NGUzdWYkFRYWhaRlBhTTlSdU40cUVC?=
 =?utf-8?B?L0s3NWd3dFh1c0pwZnhDemp1Q0FqN0RJN1hpM1FoYVkrSDBLQi9xNHBwWVJJ?=
 =?utf-8?B?UmhrM0VleEQ4Q2h3L29HbVJuUG03enNvelBCdG9yV1FMNFZuK2M5YXcxR0xW?=
 =?utf-8?B?UWE5dU1pRGlOZjJ2RDVqOUkrdWtyZG5NRW1jREE5TGkvTlhwQzNFYjJlcTZ2?=
 =?utf-8?B?MENpUWt6QWFvT01janp4SE12b3d0OGdoTVdXZG5GcGlPeUxKeWpPaEJkNWNh?=
 =?utf-8?B?UUZ1KzByRnduM3AxVStsYm5sUWs0U1FuVXlQRzVhU2R4eHJHaVhIeE8rT3lE?=
 =?utf-8?B?a01DTmxrakNnOWY3T0hBTHhmN09pdHRRNG5PY3lJd1F4RllyR1dUSC9xQzFO?=
 =?utf-8?B?YU1zSlBNc2g2R2JCa25DZlNVL25qRHpydGdrK3B1R1kwUW1KekF6ZzNySXZG?=
 =?utf-8?B?RkxvZUtnV0kxdzFlQkdsWUM4OWU4TjJFZGx4ZG93VDhwU0Q5VitWTllCSnBX?=
 =?utf-8?B?SXNzOEdMbEM4YStYcnNDTWsxNm5tQWJUTG5YM05XUC9qY282WktnMnFzTnRY?=
 =?utf-8?B?dXdwNGM0cmdOaEF4R3NLS2xEblpVTUxUbDJUSEJYVVJIaHY2SmtncHpRdExW?=
 =?utf-8?B?YWozS1FMV2d5RXdZdENySWR2YUxxRXlqQXBNY3p6S2p5RzV4cU5HdVplTWJm?=
 =?utf-8?B?NHduNU84aXFKdG1BcGp6MlhKWlZMa2lHL2FPd3psVlVoMkJHMmZOYkZ0bFph?=
 =?utf-8?B?T05IYm43ZXNmRXcwZkFUUENmeGZYOXp0K3o0VUdPSU95aEsxK3ZadzFzUW01?=
 =?utf-8?B?RURPN0RwdDRXUCtxYndsV1FzaEZwL3g1TjlDblh4dVZnV0daU2Ywd2F1OU8x?=
 =?utf-8?B?aEVEbFZZT2VaTm1GUjB0K090NzJaOURuekhPVWduQi9ZbTdCN2ZzZVdrdDBG?=
 =?utf-8?B?d0s3dE96T2dyUXNsSnZXa1dWSkhrUzRzVU9LZ0dLTTVLaTJqK2F5cHNhd1Ux?=
 =?utf-8?B?VHlaeEJNYlBmSS94SGdGYnFMSGdjdU53YldISldxc1NkcHBDUEZwQ3pQd1VR?=
 =?utf-8?B?bDVPUVdHcDgyNktBVVlObjd2cDFVZ0t1TXVCZnQvQlY5ZkNCUTd1eTJSS1I4?=
 =?utf-8?B?NlFRVDRzWE41WnNqeTcxaUFBTlZPUWMyVWgvdHpWZ1M0dkhVdGJjT2pjUU9K?=
 =?utf-8?B?NFBDdTIzd2ZyQWJyai9kMDFOTEF5dzQ0MU50ZU5OZmVMQjBiaHNJdHZZb2pE?=
 =?utf-8?B?S3pNcTBEV0g4enFMaHFSVXh0Qkg5VXZJVW1iKzFwbWg2NXprS1ZYQmZNa3l3?=
 =?utf-8?B?VEorNlJmTnF4UElZVVZFanRmU1FWWUxFTitxRkYyeWw4QjdYMTRSTmdDaG42?=
 =?utf-8?B?MzJ5TUYwNTJ6dS9uUTQwenlXZnVoOGZieWcvZXlaZnEycE9Ic1BtT2ZTNDdW?=
 =?utf-8?B?ZjlJNTRGMWJsQWIyeFFFUjhMLzRlRWRqYjE4S01CSUluTFlkVS92L01wU09I?=
 =?utf-8?B?Q1NNMzlVTXA1dlFpeXFERjNVWjFEOVUvQ2JNWVBUclRvRTNERnptZGJWTzRF?=
 =?utf-8?B?Z0JxVm9IYU9qNytkRDNIZDdMQk1PYndHR1AyL0E2NzYyVFZoWDBsVUo2TEtu?=
 =?utf-8?B?WnBpNjVwQnJzWHNLZXZLSmVNT2xLWitvb3ZsL1V4SGFiTDdoTVJ5ZC9pYytz?=
 =?utf-8?B?S3IxNEdreG03NFhGQ2d1NDJQUXZ0dFQvSWNBWEoveFVlWVcyS2MrYnRQUHlY?=
 =?utf-8?B?bWJITXdaUU4zY1ZTNUVzeGpVT0NGUytoR0tiMEF1UlhFOGpTQ29EZytzd2hm?=
 =?utf-8?B?TllsSlFXTWorTlhLSWovL0YwUkhXeS8xUGhFQzJySTZ2bkxxZlJITzBVb0h3?=
 =?utf-8?B?dUljVmtsK2N6RG00Zklqd29CRks1aWRDb0o1ZXA5K1lGcVdSeDZiMVI4cHlw?=
 =?utf-8?B?b0J6T0VtN2Rmdm5yN1JvOXZpMmo3d1poZUFQV3paR0NvbUd5eXE2cnBGR0dV?=
 =?utf-8?B?cFp4blVNOXg2Z2pKSTRiOVRJL29WVEVsTjg2ZTVFemYya3NkR1Fva0VFNnZu?=
 =?utf-8?Q?k9RZMB6wcPnS2MaLkDBPuy1Kv?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	p2KKdRkOrKjBGqkDB0FBn/DI0K9hr+HWVOFI6F5VuGYZy6bd/YhEIEB+OPBmfPPIW2+36DE4g7d+uVBxiFuMYtEe4UWdbmuGCd5JBq55WY+247/46qGvwvpijY1ggSm0ugJvvjUL2xHkIlS9WLQ1kbRaN9mr50rX1/QHVueVpgXbIr1tSN1vp5sdusDsonXOwH5DCvJaMqi4dg5YAEsORqvKCx29304+HwpVSLWjDgi3icoIeNYxTtccW+4D0UJyjOTZFpfyHW9CmGAeorDDlhsge9zkGOYR0QCbOO50F672n8euXw4Ot6tTdvMQtSWukyBU58ReIUUho5e0TpDlBh4SbhYX2LcDDIv1xRqHdGtqIgUxmxmCdsgvVe/KXxZIq4WldNSAPid1NywC8i33tYgQbCZhbaiL40/Z/63XWxtt8G9SvCEaJ/kn40c1NrfMQO70gJ8Y/cP6HxGcSUy3Bpzm8doX+9PWwEl6GvpnnWf2jxOSol2xlTSD+Ga7aHTxx6nDTwwAwKj5yJXMEW9H3axDUaNp4wxAjLswVca3G0Nt5Vv+gqRNFvtxO3eTfrL+5DBaR01to0PisDU6ERJHKPkurdqy6E0ugreZI/Q3CP0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 390d58a8-aebd-4f0d-4340-08de235c7cbc
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 09:02:07.1962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pgCuGM04PTDFh4d21qE6O+bjTWDu1FVXNjwYy0pZJ4GfjLF7mHMXsNDrKlGBkOGIiP9GoeZAXtdJCmFPYr8pdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4511
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-14_02,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511140070
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEzMDE3OCBTYWx0ZWRfX6ghTqPfjhuDG
 0ygk20ZYXr0RXklBCECngIRft3swOWdrN55HieN5hxYi16AqX82tO5iSpt8gHipIDbUJx4iTYki
 WypwKF1H1UgRm1qkRQWab/AfYocgjfULxmkNGmVHV8AdqfHMI2OoUZ8nayPJFedlKeDMBdFvOKs
 1qTDzshssmXVt7u8rnkffNe3f/6+tGkS+rk90zqXtNqOHV1/FQ4bc2omnkbvjV8XrlbFXxP4u8j
 ii4o/ZHAbQgPmE+Dq6QyuRFlrIWMLIlkLtzDSwo1kEzp3uiw6zH1hbyiJUqdwxoyiMYFr0d0cix
 IUkOip/pupcNK2LaVtR+MIE9BWD2y+HoXya9YpZ9YVjRMeNWWvFIJrnpNDoLkR+3B3tVcOC2bYK
 OeNfoIiYabL91r+3xM91v5AKz6elBQ==
X-Proofpoint-ORIG-GUID: eK35qaGBx_h4UcR4-lxTJ6KpgKbQW6ZL
X-Authority-Analysis: v=2.4 cv=FKAWBuos c=1 sm=1 tr=0 ts=6916f012 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=taK5tux02lZLC2i0T7AA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-GUID: eK35qaGBx_h4UcR4-lxTJ6KpgKbQW6ZL

On 13/11/2025 17:45, Bart Van Assche wrote:
> 
> On 11/13/25 5:36 AM, John Garry wrote:
>> Using READ/WRITE_ONCE() means that the read or write is not torn by the
>> compiler.
>>
>> READ/WRITE_ONCE() is always used when accessing sdebug_defer.defer_t.
>>
>> However, we also guard the access in a spinlock when accessing that 
>> member,
>> and spinlock already guarantees no tearing, so stop using
>> READ/WRITE_ONCE().
> 
> According to the Linux kernel memory model, if a variable is accessed
> outside a critical section then READ_ONCE() and WRITE_ONCE() must be
> used when accessing that variable inside a critical section.

So do you see a problem with this patch? As mentioned, 
sdebug_defer.defer_t is already only accessed with a spinlock held 
(sdebug_scsi_cmd.lock) (which I consider being a critical section).

Thanks,
John
