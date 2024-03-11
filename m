Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6036029A9
	for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2024 17:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710177703; cv=fail; b=GoD9lcxrMoy5CDhBjgbeC3N3hP2Sn/eVm7Gakriyz1yx+8UJfZuHG5O0Lt07yb1mvIs2uDp8oGdfelb5ps2SmItBBagCfTPbNnaFC0mTP40RGMULIipbZN78a0XupxrTYMl8tvAo0oxkhDaCx4DWnAewIB1x6CHR+TA+mTol52E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710177703; c=relaxed/simple;
	bh=fS4pJMnTRulAhgb9uv0X78dGp/RXhTalAqOLk7Z7W8g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AmFscb2C3duZA1eg8TKRMpm+qiglaXT1BTPm4A4/wpflUVvoNRk92bu7axnQp/WK+6m2h6GHWQYW7raAW6eRp72RQLgCJPU8D8ZlNi0w5XrIH4Vk8UPKZZ/LlfNPlSQv05CfZi5R6cBWlYQdIpuDgAUi4foHSvknzyA7USeyQYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QaPgXz/l; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zKqkYiN9; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QaPgXz/l";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zKqkYiN9"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42BG43sH008556;
	Mon, 11 Mar 2024 17:21:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=yJaOFvswqf9TYjAkKIvadV8X34qfCkdAbloCZ8WTR+c=;
 b=QaPgXz/lmcpMZJCQohIPhY1RURjSGjvwJFvnpRHBEaJgYwrkHy7GnBsjsmIcf7arKT7j
 krTAB83CwPJl7Ry9+tfCCJmZT8mhG8C71dfintc1yQLDey2M2mn0RaaUzrv2GUg6MTRC
 2KXTXjBI+oEUQlgcUtRTXpE6ihaq0Z3sep/X5Jd86oPwL2udRGvMY8+GYq0ywXzP0iMO
 3lO8CrRI9y3jh3/wZJRbSRFxD8kABjG0b9Lu2S5ZeNdi/ztoFpCkblI9ZklVPhG4XcsP
 1ikgfe1UfDYDSjr2qWbSPVvZsuUquarlYjnX6ItYnTYNpHteAjbqycTnkSUWgLq+qYv9 2w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wrftdbyw7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Mar 2024 17:21:26 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42BG2LeB033810;
	Mon, 11 Mar 2024 17:21:25 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wre75tfku-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Mar 2024 17:21:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KgNWpu6S9Z0KlvWkL304LDLbeoK4dZeNOFoQlCz5kqAURYVUXh/TvOcKAeCi1sJFta7quT/iy3p+ThuID/C68UgheutVRdrmr2M2AGkGtZKZkDIN8keU9Wq2CJbLfk/UUrhF4wTdb69ILLEoMHPqvWt7M5NPrT0jJiu5ttuWHmuCAdmLcCx8PmZHB0+f8M2vE7C+lJZqcYbRc9tBx+3qYv3ppW589Rq9ZQDsgdUarCJLlLsE6UakjMpa05HybWmWCoOcrTZ2GmTotB7f/oUuC0rHnwWdRol3jGJmFCxDaoeJMqFY4VLh7vm6DPUdDs0cipXpfqNv848qzTakIQj4cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yJaOFvswqf9TYjAkKIvadV8X34qfCkdAbloCZ8WTR+c=;
 b=a73Xy/Oz1jlvuZFXRnmglZwzB2ZRpaYd2DpQASHgE/JbQ8GiuB9LzSWYi++Q3TawS0/0d3kTGMVohUd+10R4G7TmFk7eYPNsaMNJmYbEjOY1DuLJ1zhET3vXvuqBgR8UtRW23yZ2TJMRJrv/h6JN4rrQOB5a2ptjOpvp7SIQZMnzCYHqSsciUB6RipXaZzGGdbx3vq9mlii4i74EGIYsQIO0vclpJtkULrVfNqv0//nNTJj2uYp6g8ABBwmh1beiJkK7XOB3e6aCKAqMuLdA9+X27cY/Xma4QXpTvp6n8+BRYzf6+py/9uXrzWfLXXmTxXmEf3Tkb4holz6uoIVzbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJaOFvswqf9TYjAkKIvadV8X34qfCkdAbloCZ8WTR+c=;
 b=zKqkYiN91BQs3N/EEAr1b+c6hjmqOFJfbQZ0yZcRgJ1Xl+X/fdzR0/TmIZhHNlkgaYxkVQhpfb29a/SF+pCTvYK3qJM/jZMOWNosEGnvX2d+37neZo2CfSEzJn4jyTaKoRU8exbA0O74AIk/C5yLmuT2TfNO0USgPeMK8zwNOCM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ2PR10MB7811.namprd10.prod.outlook.com (2603:10b6:a03:56e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.35; Mon, 11 Mar
 2024 17:21:23 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7362.035; Mon, 11 Mar 2024
 17:21:23 +0000
Message-ID: <8ee83f24-9adf-4bb5-bfe1-21c24b40963d@oracle.com>
Date: Mon, 11 Mar 2024 17:21:19 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 03/11] scsi: sd: Translate data lifetime information
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>, Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <dlemoal@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20240222214508.1630719-1-bvanassche@acm.org>
 <20240222214508.1630719-4-bvanassche@acm.org>
 <abef4b9f-a53d-45ba-a97c-ec2ff5885240@oracle.com>
 <5fd6552e-3127-4388-a45f-c2214a601d00@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <5fd6552e-3127-4388-a45f-c2214a601d00@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0217.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::14) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ2PR10MB7811:EE_
X-MS-Office365-Filtering-Correlation-Id: 376437bd-0dfe-4788-2d82-08dc41efacf7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	51wlcuQJT9wX0XfN5S/TzzFqryBWg9ZGEjMtaiHbu31kAxjD0iasQiMcMVoFrXVbUY8v6ESiVSIuaG3CHn1q/SOmZ44EqvkjtfWzTxZUmIPhMdfjqjFWXaEvK5+ycEuZOIB+JZkVs6VsCy/gFKyRbRNsoSEItJ8CP/tGRpk49msxPESQpxF6pfphoMyuVYUajSl41LhBWsqJtLb+nmC42xaipinujDRelkHT2Oujq+jKgKfT5EvFNrZAnhv1vxaYQHXWuELjmKTzesioQbi3GEQbJJcrXxjmKJRvOewTy8OscYTg7T4axJ+4MuoNz1MVgN3s+I8pr9TBywxrRtubXIAzU3A2lVJnjy+IUeFYs2p5vGrQb5KFlEGJDi49tvAQuhZnIA+V9xlZTBUqEQ75GztGLy2Xx1+Wm49K/svM/sjsZzcm8d6bcpeEfde4Ujzr0POSsICx5UmVgbotfAwv5UTnnAoFL/JXIx6IKMB85E/2pUU4fhw18Bn5MSekgtrWNY6Vwu5kE8CWFu/y6nHS8unsx/uWlAW1iKfHIBW3gEFdzsBRdsem4XcWzpYded/QMysVCtk4DnhsuYnknprabIMH2uROOCEL70tw3fiw+jSv8z7dsVr5r5JwoJPLaq0VCeo+m4xsUDaRWCFntbcJMAmpzBd0IvPvic6U038pMwg=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Nk9zNEkwMjJuSkFwTnRpR0phM1ZQU1BqYUxxQWZ0UHRqQXhrOTZGVWxYZUhV?=
 =?utf-8?B?dWNtM0tZQm9SUGJLc2tBUlUrZFljeTZNeXZUSUNUblExT2dJWWVCRUVHaXJh?=
 =?utf-8?B?OHgwNnFRZHhpYTZoMENBSGM5S0UwV1E3cEJNaUlBc0hYUG9KTzhkalI2R2dE?=
 =?utf-8?B?bm16QWFENTNjS0tXUGIwd0cwTys0aTNXYTYwQWdMdXZGeDBNcW5WL2hYcGNP?=
 =?utf-8?B?Uk5UUGdSeEJoelpaVkM1STdWanJ3RUZGL2lIa29sNTF5SGRkVHYzbEVNT0d2?=
 =?utf-8?B?cjFYdVB1ckJWZ1kyN3RwVy9qYno4d1YxT2hCc0xTM3JyQkxOWE92ZVE5MDZX?=
 =?utf-8?B?aEZtK2JvbGpwY0ttZmQ0WE12cmlERlQzS2QxcEdOV0hYL3pkemNodE9xMkxK?=
 =?utf-8?B?SkxZNEFqUEltMEc4dzFaQXZOMHh5UFJDY0NNWnZxOU5oN2xHb2JOZm9mOFp3?=
 =?utf-8?B?a3dvL2MwbUIvWGtWaGdPbklxaEhNdUQzNFZiSVlZWVcxcXZpVFNrYU9uTDRR?=
 =?utf-8?B?ZUlwZ1hGREFwRHFRNXNTL2pUN01NR0FpSHowVnFYdXRzeFg3VU53b2hMeHNC?=
 =?utf-8?B?N2QzYlgydTk5QklTdDdIUExLS09RWUtRSHpBaFZILzk2YzAzNk96QUtTMTdz?=
 =?utf-8?B?VFVLcnp6V3ZnUmRSWUxHakZVUHZBcEdTRjJPVjlucWNJYjAxZ0RrN1BJTHFm?=
 =?utf-8?B?Nk9NN0hyOTJ1ZjVMdHlMQVRVcHZGVmlCZDBneFY3c3RNZEhFTmt6bU04bTdM?=
 =?utf-8?B?UVA3NlhUeXhiNEkyUkxSR3RsYjQ3WWNLdDAzZ2pGQTcrY0FCZTdHcmZnRVR5?=
 =?utf-8?B?VmpiOXI2REhtUHFWVlQ2WGx6YWtOTElBL0FWN2dXRVo5bm9QMThVZUpzRVEy?=
 =?utf-8?B?T1hvSDh0M0NEMldrYXRiVm9VMzVCNFQraUYrVGhrbGloT1BnU2ZIb0FoWmVS?=
 =?utf-8?B?azRIdlUxRS9vUndRZVdSTEZ4Z1JLU3NuMjVrRDNUcXNmekVzSWpxam1PUXUr?=
 =?utf-8?B?Ty9FWkpIRlRvYklodmFlSVhDWEFqWnNNaEt3ZWExNmhZN3dCRjI2YTdsbDRy?=
 =?utf-8?B?Qy9QODhNbk1EU2t6T3Z0cWptTVM5YlZNRFBlNFJyZ2ZsZVFnZXE4enp4Mnor?=
 =?utf-8?B?N2tmTEVoQ2ZJREJySzczNVd2UE9jMVRoa0luQ3JkeUh0WFN0dmlrSGZyUnp5?=
 =?utf-8?B?am5qOXhxWVNRWE9GbmNUYWdFcmlTUktpTnZpR2RoZDUyNVVjT0d3dVhOSzk0?=
 =?utf-8?B?ZER2OTE4OTl2Unp0TmRHODBCT3J4NmU4bXR0bHdlNjRJbEYvUkcwK2ZzOTN1?=
 =?utf-8?B?VXpWVzFGZ21QOEdSQTFHRHN2NU9mR0t3REtxMitNbkwrcmNYcTVyKzZIQVZE?=
 =?utf-8?B?Vm1OR2liTHZ0S2dDZTcrMjlVTEY3WC9jQi9oeEJxN1hjd1ZVSktYZU44MFNL?=
 =?utf-8?B?K1N6anFET1VyTVo5bmJNN2ZhK0JpQmNiczJLYWNPZDNCSWNpUWE3eFNXQWlV?=
 =?utf-8?B?RXptT082TzZueDU2S1Z1dm1jcy90ajUxV3d3TWZaMjlNMjF2MnNkdmZWNmx0?=
 =?utf-8?B?YzVxNnRpNHFNRTlVNElVay9lcGxFVE00RGlEUmIyMXNBUkxQZVFkUFBBNEI0?=
 =?utf-8?B?a1JvazhLUzJ6THdyRTJHOE1nMHNzTzRGdytjMWtLMTFYUlBYcWJ3ekorVW1O?=
 =?utf-8?B?aUZreERucEIxTXpXMENadGpRUUI4ODNjSjJiMzlWM0hzalNJcTFMWXBLMzFR?=
 =?utf-8?B?am9Wald5UkQvVldKTSs5Z0w5N0FjMmkvRm9CVEQxS25hUTNXNnRvR2pFMTlo?=
 =?utf-8?B?TXBvQUJPdjkzMTBvR2lxSnFjM0ZNMVByTWFxVlp5akgwUDcxaGpxVXVwSWRm?=
 =?utf-8?B?R3NsZEJkZEdKODQ1WnVYc0lYVVdlb0RXbnBSd0ZMWlpRdHNkWTc3d2d2dmhj?=
 =?utf-8?B?VE52U1Vsc3AvNS9neXhVM21IMGVSNHJ4MlFhbm8xbDBEMDZIWVprUHM1WmR3?=
 =?utf-8?B?cHYvZ0lDeHQ1d243RTNtNEhFUnJkNFA0VGtHeHMycE9rNEhGaGxGQ1p5S25z?=
 =?utf-8?B?OVlXRlViZUVqSndiOExqZUZwR0xFd0hvTUF0WU1DcExXUjdSN3JVNUZyUFpY?=
 =?utf-8?Q?4cRgq8Hcm3dFpV4Yqp87zvqD4?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	DS5FFwIqhFeq8BIOhYILSh8jYlQsTYsaltSX7q87ADYpxffcMVPipTQm/hdPf2cGaPawk5inA9h2up8rpZ+v5NJfw9NLO/gmLMcmffWKUiPKqhn3DZhuFX5iGGPu+jLe7y/eZPndcQeWlsCKJtIG2pSrmD5Ps7OlnplLwi0doiiTAF9MSWKO2BXCkhxN6H/R4f9Qq7FlxAV0zcyYUg+qQAokvQAbNdbgAWw8E9an05KxPfuw2YfSNdmybw0BvsU9EUG4l7euZxuloWpZOzWi3dGU19BauYRykN1HGD5+8kEZk4xw4qWj79ZCesucZEuKiT92t6QyYixRmyaE9SSCm8IPPf3l/lntJJ8LXKCgqcH0E3gEJmyVrt1l/BdLZphscmsy/0gBxvymBpSoudm04gnzZXLluhh+fsnUwGNsQ/eCrnAcnnkwtyIeZUpfJBln0P/2OWncZXf5Im+AOwTscWRPn2FE0QNmoMioQ9oZj2rln7IJl+E1m3ug8Hc8EALRMv0Yy8c4YVy6RYYPiMANmu864wYOeeO+HsFL1tOyy8ecJvMM3zB15uyPGpgtVvx0kkEMlVid4CeB7UOT4kaW8KyP7ecrp0PKLhq4LviSc8g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 376437bd-0dfe-4788-2d82-08dc41efacf7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2024 17:21:23.6969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zVyKbXIjVB6wZ22ZY8tqcoiyLmB1Qaef09rjwAqwnnWpSRn2kJ5weQ7c8YY5s3kAKZ+nHCT06xkRtbeiZ5i7LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7811
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-11_10,2024-03-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403110131
X-Proofpoint-ORIG-GUID: VgQMvxbMt-FonELz4UvtFTUWGnuc2Nuq
X-Proofpoint-GUID: VgQMvxbMt-FonELz4UvtFTUWGnuc2Nuq

On 11/03/2024 17:14, Bart Van Assche wrote:
>> I have been testing a recent linux-next (which includes this change), 
>> and I now see this following kernel log just for writing to the bdev 
>> file, like:
>>
>> # mnt/test-pwritev2 -d -l 512 -p 512 /dev/sda
>> wrote 512 bytes at pos 512 write_size=512
>> # [   22.339526] sd 0:0:0:0: [sda] permanent stream count = 5
>>
>> Is that log really required, especially at info level?
>>
>> That is a scsi_debug disk - I assume that the relevant io hint feature 
>> is now default enabled there.
> 
> Hi John,
> 
> How about removing the sd_printk() call mentioned above and adding a
> sysfs attribute instead that reports the number of permanent streams?

A sysfs entry sounds reasonable, but I don't know enough about this 
stream count to say whether that really is a good idea.

Thanks,
John
