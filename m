Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AE930E82B
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 08:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788249916; cv=fail; b=g8/DLcK+xsWjuwjNVhsa7GGnhId3RVBGMIzg2fEMKD5lgLb6NxnvkBtEV6Scvg0/evI0XrDa3Qi2uvDjBcNGOZ/i+zd0sFBR05z0xtS5R9n/P4ZuUAXuarpzpjIsDX16U9pd7rfbj/zH2bT/x7xN0gEIOtHHD9JPT54bI2vhhXo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788249916; c=relaxed/simple;
	bh=k7fUW+hNIwkRBgO6YSW17i9bd3JJbwZekmsZCT6C0V4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HYMIZeSQuZSTYZ0PmrTg8/l3trYEZF2r17IwvYskvXrCtpphvuHxEXB8JSW3ZedfRAm5glWcRdhWClFuGCpUMPYnx40ijtjs0SPQN6YJ1CyNx+vNPUxM+bfjuPnXrB2PEgAVtx/5lfoCcHiUiqgD+ZynzUGlUjs+r/fy5jalMKU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=p1iQxG6W; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=U7KRa+Xe; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="p1iQxG6W";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="U7KRa+Xe"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLBsnV2287033;
	Tue, 1 Sep 2026 08:05:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=QVK3Z3mVperNpN5A+Xll9skRowsiPvipQmmqQHXvZUw=; b=
	p1iQxG6Wd8hVB7ILVbjazwDJybD/m+i4HO1pCFPjAENE/M0Z0cjjNiNzp+qvuX/b
	F2J6W7bvtabMruMw9TnR2mXI4gluS5YhmE2IGclz8OMemmt/VTToqu0GWuZdiADA
	gnwhXVZ/q+g+4g4EpMTz7xkPfzeSEKnTftgU7spmxBcyLxMoQ7qb4HZ/YggSUkgR
	ABqjTid8Q//fNFHKdFPVbtLoFKB/Eh+Ngwyt9npHFeV6xuetXJBvWfXGOH4YL8FF
	Tuz3+PfGqh1cboC9f15J5rRj+xIgIN7g6UGLf5OxmQWNkGzNkKbs6bXewlRBAHUr
	VsJEQinZUruzuyYbKFsFiw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbp72c4vw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 08:05:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68184xMn014207;
	Tue, 1 Sep 2026 08:05:00 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012071.outbound.protection.outlook.com [52.101.53.71])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnve3ruw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 08:05:00 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GzzpnKyxJm6b+l7hO3KdiSWQu/MQUC+zs+1YQoKcwuv0yM5dulZg80Ji8uuJRjNxehdtiYkL4SIikfSr4ojrQSWPwGjqToGRm0OCFudhwMUIi8SrF9bgwmvsONbgE3w2H5rsSc51q603jseCyqdcUQasUx4oFzZoh27HLPdIqCsQrc00a4e4ycgKD4zwBpdTTEedo8JFvIHWgNTw3J01Typ8AESREMtx3mQyqW+P1YTgk2vh8T2HB8SWbxwrLlQaPoYfjANucxItQWjgqqk/kK2O6bYC7QYg2X8eNUHXq/2T66zLJELzUnHHE7gspIymPLdlJGLOi1l+i/9OJA3GYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QVK3Z3mVperNpN5A+Xll9skRowsiPvipQmmqQHXvZUw=;
 b=acdahMcOHgwtmdbsKdhKEedZL8QFgAmEPIaei+yoiPwJKjhRtJ0oLr5k897PiiID74mdoAZNDgAxP9CJwJREAM5ZX+4H2Qkleu4Ne2J7k16DEf7rcTMp4TVJnbNVJczmDjz7sVfqtb3XFU6JIHP02MfZsRI0NdnAuAULlNCl/5v67BVaRvIczDpZ9xJjs3sXVnExVl+vYdztJJFCdEpqhGx29hRm6MJoibmzXUlb+lhRXtHVhGT07lT5wmnoXM6toooBJmP5GPCTNmoTQ1zVNgzFTE5UExr9mo4k/8kRknV8JLAVjAWPP2sMy1pt5cKNLzZSerJj8KqkSmsX1kyGGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QVK3Z3mVperNpN5A+Xll9skRowsiPvipQmmqQHXvZUw=;
 b=U7KRa+XeodW0vyHO/IwYMN6LG4OhJC8BNTziQkmwoVKwSyIFJF1Uv8mJSrraVp4Ms8jUCePa3mVynstyIpOdgtwoQXMGcmBVzGS110QJLbasQxgj6tbQllOS79I+hbB6dAVXIWt3LoHmFtTbklyH3WlckC+XsQjMRwJrGBpHiWw=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA1PR10MB5757.namprd10.prod.outlook.com (2603:10b6:806:23e::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 08:04:52 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 08:04:51 +0000
Message-ID: <b003c0c1-ba99-403d-b3c9-3670dd7d027c@oracle.com>
Date: Tue, 1 Sep 2026 09:04:47 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: core: Rework the DEF_SCSI_QCMD() implementation
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>
References: <7d904551041c58fd2cda31f82cf3e7b246e6550a.1788214709.git.bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <7d904551041c58fd2cda31f82cf3e7b246e6550a.1788214709.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0021.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::12) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA1PR10MB5757:EE_
X-MS-Office365-Filtering-Correlation-Id: 2745e668-af47-45d6-f923-08df07ffb31f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	z8UABT9DQvVHoqfhxH4d92ybmX+JkkET0+KbdbaUlwbgWwmZlApWxLX7RHGat5phhONORWIZuSZ2Pz0wSDg0ndtEiPJ9wRceta+Zk6Ai1TzK/yeZhb3Y7ttyyDFz+sHm8zd4H06rjTEkrO5OZYP70BoxqOXlrwV5q7xRc7bYLZ3gsA6gvqkXN8KfzJ+ntZ8eImOV49wb0okrHhKRttpcVAL3EeaegagG2Mga2pNCf8ZDDjAvOEJyTFj27YBamwMIb1UxlOgtgE6fblhFDTz4MqMzfmL9dCY8ZnrK67UmbxyV8j4YZLKv2cpgR0qWYZaatVot0YRgivvWhiMERf8C/x48jN+pUuQ45MiJbeATdEr7bOBP1EBEzkOcmjPL1nb7az9Ch9GJ7PwW1UjyUYuR2nQ1l7vk7G3KWKF4F9xU2CurEKCUIdwK22Qna76HUED/+I60WOE1XUtqMVaMxGvVouQ2P+gZMxRFfa89mwRb8+hw+x9toCeuMN7+NmUGIFv4SoioCl5gdfi2eQiZty1zLg9lGxOFdaOHsyV0nqhWrL8citdxhGP1QC/Sws+l57pbOwm3hw67IuZMWlrCZmXXn1KOLrUKZFllT6B8ArgS28f5fTfQbZwVJ8EUTjzzeq6JEY25bTufutrjqIw8Ms3Em3bVA2/4n3f4P8ZhdD5AFDs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dFRzN2lRVEdYVEpoM1ZLalY5Z0dkZ2c4MGxsaE9xOTJ1Tk5CT0hqa055cWU5?=
 =?utf-8?B?N0NDSzA5R3JSQVNvekdNc3hodXo1dFR3QklVU0M2Z2hjbUFvMlFnZ2ZWS3Nt?=
 =?utf-8?B?b0FBU1ZGYkFxakhqUDZWOWJzYXQvV09FTUorUkZTWm5zUE00Zzh5ekdpS2Mr?=
 =?utf-8?B?VXA3NnRQaDVSTlEzam5pRFpjcnoyZ1BaTFB1Yjhqckk1L1U2VkxwN2NDZkl5?=
 =?utf-8?B?S1RSRnBldVZFNlpQZ0lBN1U1RElhSGw1cGswOWRhTDg0SVpvYS9DVWJ6em0z?=
 =?utf-8?B?cDBLNGhRbTBpWFJGT3pPSzlUbDJGYk1Vb1gzMVZjdEFCTmRFK2p0YTdMQkoy?=
 =?utf-8?B?SDdKQnZXWnR2SmhJNkxFVG90ZHhUZjd0d2tKMFliZ3NHSng1RWk3V3poOHFh?=
 =?utf-8?B?SlhFQkVaTlY2S292ZThjQXkzVmZkQUNOeTZ5N05wSXZ1SnV3bDhuenRtMS84?=
 =?utf-8?B?MkhlZVFVSC9vcnBOVTlxNGFzL0dLcHpPSnFMWG4yWFBNWVFOSXFRdnFGejM0?=
 =?utf-8?B?QUR0TmdScXMwL01zOVd0Q2NtUE4rZzhkTWtpRSsyekQ2SDE5MXJjN2FzakFR?=
 =?utf-8?B?WHNjY0dNZHZ5WjRlaWlkTHQzcncrU1p0TkpLVjE2cmlESXlKV2FUcDI1L29V?=
 =?utf-8?B?Z1p2TEoydFk0R0pyR0Y4N0NadTgybDBYZHNwTHJNUjBHWUd0ZTNMNWR0TFJq?=
 =?utf-8?B?L0J4QldlZFhyT0R4bHNHL2VWTitadTVrM1hScE5NdGtXMUkyZGMyKzlxcXdi?=
 =?utf-8?B?dXJHNCtaTjViREVWbnZITGxEaWpKRHFNSTR6YzA3dmJHYWl2ZFJ2SW5qYmlo?=
 =?utf-8?B?VldYNVVXQlBRelQ1U1JvaFRyWFgxazgzdVhDUUpNbjI3aVhqZXdLZmR4eTU3?=
 =?utf-8?B?V2RsdytBSHF6RnZBNUp1T2RvR1RjNXBDTDRIeWF3dElYZ2xBQ08zaDFubm5u?=
 =?utf-8?B?bU9od09ZSC8wMlNqbU1tYzVJL3pFbUhxc3pDdWNUK2x6Yk9HQnhWUFNhWUZK?=
 =?utf-8?B?b243em5HV1F0eEJTNmY4emtrL2ZudUh0ZVNzOVB1UVJpY0JQR3VhazI0VGg4?=
 =?utf-8?B?cXFRTkVDRy9LZDhYOWQyWVpXN0JrYUpRYjBRZThUNHEyY0pQUDR0ek8raWIw?=
 =?utf-8?B?K1F1MXVuR0U4TWpRZkduZVZrY1Rkd25La1REOWJNeXlyU3BRZldOUVlUYndH?=
 =?utf-8?B?UUl6SXVQYnpJSmZQbDBkSTlGVlJKSmY5SUFiTmxZaHB0WWw3NHRVcmNGUVZO?=
 =?utf-8?B?ZmtlbmVWUHY3RG9EcDV3MXZNU2U0SVFJNStlRnd5K3E3L0NzQjYrQ2tFNGdQ?=
 =?utf-8?B?TWdkYmZHWmVvOThvZ3N6ekNDR0J4VGFpZzJvQ0F5QW5CU0NDcXN3aGZMTWQ4?=
 =?utf-8?B?NG5oVDNhMnh6a2d4L20yTHozOUJBcThiYjBlTWQrMVhLYTR0Q1h0SFMxeDNS?=
 =?utf-8?B?ZDFwWmFpa0hSbHNGTmNjdysvajFjMEE5N1FEOWxjR29FRUZHdlBwclBMZHlz?=
 =?utf-8?B?VFpPbmljTlhCNWdiRVU1Z3NJSUh6eFVxZVVSeC92WWlaOHc2OEhFVWo1R245?=
 =?utf-8?B?T3U0TFl2MDhIYzFSRHlWWTIrMGc5N3Uxa0NrZE1FQlpKK2FKTFI2WFYxV2Fh?=
 =?utf-8?B?bG9jSWV3eEFRL1hLMy82NlRpcXZBaTJQTG5oRHM2QUJyemNBVUl3Zk91YVpy?=
 =?utf-8?B?SXhBU2hGY3pTQXlMQUQ0V0ZKQVNKTXJIZmtEU0ZlWXdMWkNSMWpGNHd6RUV5?=
 =?utf-8?B?Wk14aUw3N1RpcWhJMXVoblc1SWxBS3lFSlNQVEJkV0daTjlEd2psRDJDL3p4?=
 =?utf-8?B?NFB3U0ZqRUc4a3dJOGt6K2l6SW5mbk00QTRCN0VJL1dTYnBWR2t2ditSdnVT?=
 =?utf-8?B?elZJZTNQOEtodk1uZTZkUnBFa0hVdXdHbllUZ3hySzJVUU1KNVRpSk5qdG1t?=
 =?utf-8?B?OHVVTWRxejRTSVJIeTg4RktkL0RNOS80SEpiYTN5RmlQN1lOdDdQVEowVTZl?=
 =?utf-8?B?NWQ1eEJGOWNzQklwR1ppalk2d0lUY1BjWnlsSmFDRHo1d3BtUjc3dklMTVlq?=
 =?utf-8?B?MEtRQnhTUXZXN0llSXA0bkNtUDRnenlSSVpaY0tlOXJiTFRrcmZmeTlYdnph?=
 =?utf-8?B?aWhid3N4dGpZU09Wck1WZ0xSTXA2RDgrOFpaN3dGV1BOM1JqR3BPcFVCKzh6?=
 =?utf-8?B?MEY2bnJ5UVlnbnJvTUwzUThtRjhSY3pOSkMzWndCbGViTFlHNUJRUWVHNXRr?=
 =?utf-8?B?SUxmTW0xTktJRjdlRTdiYnRtL2FvQWVuUENnR2t4K1hBazNQdDh0QW1GaDF2?=
 =?utf-8?B?ZFhDa2RXeHV6bldJbEpTcTRLYWlSZW1mWllpa0dXYWNnN3FISkJ1dz09?=
X-Exchange-RoutingPolicyChecked:
	oudxe0nAiVUpywvlFfvKxj2t2xyILK2tpSyG/Je/fF9LcQqu+32ZbnqJkgUpGLcElaIwiUUzxtKn4Wm0IqiYtpO5wHbsrdga/0uhlMezAAlIpZ/LLRqD+/UiqiWr5jQ0LD264WhmYMBXGzypeLouaDzhdesMjG3PpeMsDQLbJBZNcwfGldhTpoIhciH8+e7KFk3XwmpqTfMLf7EDAIR30Bi74ewygXm0JaXhuRvk/cpqBvHeYzHZFSzEPh111H8z8XnvtNqHdg7HNBVl87RupLbpxRum77ulvX6xkWYpLISpmpNXPPmUSSNUpfHey05+p4c+fOLXRQjHqrRS8bZe2Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/r0n1fWG09au+ErnrR8k6cONpGHrS+LrSECqAx3h8gS2VvRhwR57cgiLb2GF3y+/5byf/KyCtigbawWIGT/6TZvhAZITiUmPM1Ug+UNC596pPXGMSQbownQKbflEXLipAhjm6zT8ZpFfK5p6ICGhFYKlA3hwdbN9f0whz5tVwgsycilWaDbHMh42t2s8S1u3hht2um9QepscS6LRfJoJbv0jntTsNJjphZQtRgTeAv7plkKZGLzGjHus4hSfL8gnQNddTq8rwmWbp4lohlUCRPTcgBQJpXH/XC3H4UMFB5Hm52TRUlGF60957VygDGoaWPZbdI8Bpeb9zxDwBIJEjtLGA11k+G6QWk6pY1H0dcyMkrtc8P+EbLe5PYOD6Dv/pny7w2B1JkhbLQIrUhZdkieBXiR6CaGy98L9EFVPkb+xS1M7d9tpKX3sCaXp0bmxOiv1s0aOvLIDPL9vigYY1PGj92vLw/RpIJuiAzMjW/JUDEfmetk/eHt6zkEzR0Gw3C9VHYmPrdwuwWBKw4dtLDZ1f1HMo1jDSBvmwLjzAKQJNnkFKxCAWrlVZDYmnev2FcYm69vXwSuFdQN5b+lNTP2D6b2IIc3Z8q5mXGAKAis=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2745e668-af47-45d6-f923-08df07ffb31f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 08:04:51.5460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gllv2V07foA2wI31WNA37YkdJhQ3tLb2WmzhW3wiT+Jiu73WfUaqaglwUpd9XGar3edBWedLIdtmNTcN/WYL7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5757
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_02,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609010071
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA3MSBTYWx0ZWRfX0g5TdkP+B+go
 Uz6xTkszOeZujCgCnKfJ/10ZvCk0nAYMi7pnZLBBYoe3PaGZhTx4UArulwXzF6SEP+Wk8LV7AWC
 3v1ZdZ9H16QkMOoERTWdazJ0tfxLh/vzbue8yH3CBBtvVALDn+bT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA3MSBTYWx0ZWRfX3scW3R7qwCGm
 S8Lq+APxmH/0Lh5FRA/NU3k0F4/hYD+gyLRUSdXPz7z+oqYkqkW0qsZpZdDiu4/6zrSJ8Lko4vE
 XASanlEn8f1PIG9kn47cMsfqBqWjU3xfY1kQ9jua2EjkKaDSlcxApxO+51p2nm5bqHtSGcXt3RB
 ECG4Jt25UVcCw+dtlNFKD0mOMlWkmimmH8bkYRcM8Sfg99bUiLubkmUVEbLzZ1Y2fpMZIX/Xs1B
 0V9s7EXPAGqeabfYmgyajHDiZpxwGTMqU72M85s39pKmj49Oz+CTYCIxjbkdb9YeIN/W9Kd6YJR
 ngYiSdedBc7x+yqwpc2aYcoovSjK5jWOLLHZRIIEGjUZyQkHbJRKaIR5J7jBkOQqOzVf5Zvwb5L
 Nl2nzT3DvAIpQZxbP7+73oMWkV35aRvUG7esbNporXw5G97hQYvnvV84l4NmEOvN0PTkL0Ngory
 6nncQZAjYnQI/Ux59SA==
X-Authority-Analysis: v=2.4 cv=G7os1dk5 c=1 sm=1 tr=0 ts=6a96872d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=N54-gffFAAAA:8
 a=lyX7G_B5WJKasl9EDPEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: uvSqnokasN3zNq1IrnC6TAdg7ysZPkHf
X-Proofpoint-ORIG-GUID: uvSqnokasN3zNq1IrnC6TAdg7ysZPkHf

On 31/08/2026 23:19, Bart Van Assche wrote:
> In DEF_SCSI_QCMD(), make the following changes:
>    - Assign cmd->device->host to shost because func_name##_lck()
>      implementations will be annotated with
>      __must_hold(&cmd->device->host->host_lock). This change prepares for

Why not annotate with __must_hold(&host->host_lock)? That is what we do 
in scsi_host_set_state().

>      enabling lock context annotations for SCSI drivers.
>    - Do not save and restore the IRQ flags. Since support for the legacy
>      block layer has been removed, .queue_rq() implementations are always
>      called from thread context and with interrupts enabled. Hence, saving
>      and restoring the interrupt state is not necessary.

That is really a separate change.

> 
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>

It would help the maintainer to mention that this conflicts with my 
host_lock patch

> ---
> 
> Changes compared to v1:
>    - Fixed a use-after-free bug.
>    - Added __maybe_unused to the shost argument.
> 
>    include/scsi/scsi_host.h | 15 +++++++++++----
>    1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 16243ec376cd..d62f1e1fbd0c 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -528,15 +528,22 @@ struct scsi_host_template {
>     *
>     */
>    #define DEF_SCSI_QCMD(func_name) \
> -	enum scsi_qc_status func_name(struct Scsi_Host *shost,		\
> +	enum scsi_qc_status func_name(struct Scsi_Host *shost		\
> +				      __maybe_unused,			\
>    				      struct scsi_cmnd *cmd)		\
>    	{								\
> -		unsigned long irq_flags;				\
>    		enum scsi_qc_status rc;					\
>    									\
> -		spin_lock_irqsave(shost->host_lock, irq_flags);		\
> +		/*							\
> +		 * Help compiler context analysis by using		\
> +		 * cmd->device->host instead of the shost argument	\
> +		 * for the func_name##_lck() implementations annotated	\
> +		 * with __must_hold(cmd->device->host->host_lock).	\
> +		 */							\
> +		shost = cmd->device->host;				\
> +		spin_lock_irq(shost->host_lock);			\
>    		rc = func_name##_lck(cmd);				\
> -		spin_unlock_irqrestore(shost->host_lock, irq_flags);	\
> +		spin_unlock_irq(shost->host_lock);			\
>    		return rc;						\
>    	}
>    

