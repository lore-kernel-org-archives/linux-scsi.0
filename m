Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F546288503;
	Wed, 23 Jul 2025 11:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753270090; cv=fail; b=YqzOqRkv3ZKTTZtXBgF7yeQCK+v/lmdNASeg6g7xmTe/CS37U9tg3lK1nv183RfMYqjnjSqkDR5y/aXLjqDl9YxLWfmzCY4a7cH6unxwguUQkKcAP3rwBc8QXYqrrUO5pfL7zqcoKUeokhNNNEk9MZwx3Vgn9MSMLEYSmuzr37I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753270090; c=relaxed/simple;
	bh=AjvOnJLefouwoKoFJ/CTq2O9sPm11npQfktWIptU/8U=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lnERBTnqUIsPlUfkcit5FJs8FqODeZZ+Le5tpH+LcS6wH72AccaI8suCduEaoWcTopX9p+pQR5LaFm6DI7lthz7Y/jJ1ZHv6635Z00IXOQzP2u4/Pq0VIMQXk5l3PbuiIDaD/6MkkPb3W287DN3sJZZ4s/6NjRJZOHKhhXJfjbo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nSO/TTwm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EZ+AQ3LU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nSO/TTwm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EZ+AQ3LU"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56N8Mu8J015284;
	Wed, 23 Jul 2025 11:28:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ElemoOmLt66pgdcRr2mqhXclncbIoMB+PXoT00xaCmA=; b=
	nSO/TTwmm84GGJumx/ZsEDoq2JJtwVT8rCBuCqhr73uk6L8qnXoO/2oDeG04tBna
	JIFefvriDqRT5LK+2SSceMq8r343BBD68E8sEwG32VWM7PCJMA2S5QGH4qPhryeY
	uRfSjPF7Dc7YiKKjOETJcl7ObVRIwzCpmCeb83aj1M7R/PkOxTw8ATZP5Ilz0Rhi
	gu7Q+j8SIfljkWwTDTXTm8d7VW7qVRrMtFN7XO0m42i3Bw8CP2ImYxvT8hMz4gzk
	U1UVyrRgf7L1kBMQRJZB6YT7Uzox1m0qji5baY2Iiohs4zQUEYOqGikpHnZxGrSZ
	hmedS2I0mdW7ngN4doMOpw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 482cwhsu9q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 11:28:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56NBJpZX005724;
	Wed, 23 Jul 2025 11:28:06 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tafrsu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 11:28:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sHJuCYMnAqKoluWGHD0FX0Mn5I2ohP3wB1+4RhhHRsujURvGT4djOh9vbMukgRLaynMo0PX3ggYZy+WqQ7uSYtXh8MFzJbHUZk6cWAYSIxE5DAHIPwR949h5c0LWj5hXz8zUS7OZ/jMQ/O7iasSaNv1rHrAKO/pQaap2Lyli5r8iv+hurKZ7NAapSDkht6b3EWzgijOyfOJo1Akk4NiqSHFDeEOpm662XHKU40F8DCdD4m+z00bFf7aIYu8UPRM4/nx7DBM32w7LfnOGSCDZm6DBcnPzezdZDaPwtOiVxX1S1u8VLJ80ooS+WL7bNUv5cmEJ+LZPV2QAx/8HHSyziQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ElemoOmLt66pgdcRr2mqhXclncbIoMB+PXoT00xaCmA=;
 b=u4cWg6TD01fWgazT41g3Kc4etJBLMSyZODkVZiUzk2e2o8+UvGXdf/CNmT+fLhGczRyDouig9Fi/GIQ/Zci+AuNpeUh1xg61t91pBz1fFM2aBNmg6Nj32FcB/xEhEEDZnLI+bq69HNAVctS4uk41x6GXS2eWoUxocXCRS4lyiQQ3LqvWxYFpLE813sV3cbIwmkyFLgNWwgDYwARph07+wP/r39OkiqFy0WMcJNkdDSajjpgwDk2TBH+g9t4Y+hYyt4axziTU+wKikVn6icZ+PFlrm5W/azR8LLYD4yD0QFl+o0rAtqsZQ3A0rxnhT14zma+6EvJwRc/dExuoVppRVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ElemoOmLt66pgdcRr2mqhXclncbIoMB+PXoT00xaCmA=;
 b=EZ+AQ3LUSgGT+6GnmIuVMPuTF1c+sKZK55NCC7BamBYCk3gL+Xl3WjrWxlnElICT02NFxSRk+v+RjSDXWQ/AHiaNPundNozE9+Nfq5X/dbUIhgsb1A/ltZwzh4KlsW9f0LGNGINHZvLPqEF/Yn5hY9G/C98+IzEmyY2E15pCRTs=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by IA3PR10MB8300.namprd10.prod.outlook.com (2603:10b6:208:582::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Wed, 23 Jul
 2025 11:28:03 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.8964.019; Wed, 23 Jul 2025
 11:28:03 +0000
Message-ID: <951f5d23-19a8-4f6a-abcd-204aec160e74@oracle.com>
Date: Wed, 23 Jul 2025 12:28:00 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] scsi: target: Add atomic se_device fields
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20241008020437.78788-1-michael.christie@oracle.com>
 <20241008020437.78788-3-michael.christie@oracle.com>
 <9e789a42-2522-4df0-8c33-db44b790a7ab@oracle.com>
 <2eae4fbf-66ef-4602-91e0-d92838dcabe6@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <2eae4fbf-66ef-4602-91e0-d92838dcabe6@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0286.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:38f::13) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|IA3PR10MB8300:EE_
X-MS-Office365-Filtering-Correlation-Id: 30676726-8bfb-4d61-253f-08ddc9dbfc75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZUNLR0dMSlVQOC91ZVNEQld4ejQxdmk4aFpTdVAva0MyS01jdlFWekxWOWdH?=
 =?utf-8?B?WG1aNXphMjB5TE9sWkF4SmYrdm1SOFJVRkRDRFZ2dm1lQVNEL2dIQXhweDBK?=
 =?utf-8?B?N3JCNEhIb0I1OTFpOU9WUU5Oem8vRU1JMkNNUm53MDV3WDRVZE9oc1JxR3lE?=
 =?utf-8?B?UlRKWkNsdm9EMll4R3JJRFhZc1FWamJzMGFSbUIrNDZ0VUhGcURPdHMrRlZX?=
 =?utf-8?B?eWZSZitPUmNhU21zM3Bvcm1YWi83ODgvb1I5RFVadUt3VHNuUzVZZUxGTk9j?=
 =?utf-8?B?RnQwNkk3bXh6bVVPbmt4aFMxR01wcS9YVVlGZ0JlSVhOWGcyRU1sc3gwM0Ns?=
 =?utf-8?B?VVlZSGd5d3FWbVZlcDhSbCt3dmJYbEpMVHNHK2RCanNjUzhBcXNWeE82YmFr?=
 =?utf-8?B?ZHpQazRSUDdHZ2UwcUdkNWJscEFtK0o0eXlTM09odnZmQWhoOFY0TExBRzla?=
 =?utf-8?B?YmFLQTNhdmhIL01hN2YzR0JudzM1ZnIyQzl2TThDR04wVjJQTGZEc0pkTXZM?=
 =?utf-8?B?cXFDcktFb1VyTEJ3SUdOdWpBeFFuZnZsOHVjNWkyc296Wmo0UWNreHpCMmx5?=
 =?utf-8?B?ZzViaTRGZnQxUm5ncmZNUDN6dEV1L24wZVhaR2ZqdTg5RDBLUWF4Vk0rWndZ?=
 =?utf-8?B?bXNkeHZ4WGFOTTI0NEQ0Nk1WV0xGdTZwUWcxS2Q5Vkh4anIzYk1zb2JTYVEw?=
 =?utf-8?B?NmpURGR6Z1lGaDJPc0pFbVQ0VTh6cEw3c3ZkM1hsU0ovemFKbEV0bWVQU3dj?=
 =?utf-8?B?Q201amxHTXpsWjFTRGlGZlhIYUVkTmhjWkljTjE0MFhZYk9ZRXBDMGJVZWtD?=
 =?utf-8?B?czArVXAxbGxwWlFuekIyN1dwV1I3TlRCY1VudnhLYnNFLzJuQkRsSW1XcjI1?=
 =?utf-8?B?WEtZSWZaeTY1dnJmZWxxYnFUZ0lUYlMvdzdqOW1LR2pJV25TY0xFYUlPYmky?=
 =?utf-8?B?ZC9iZGdHejhIRDhEczA0a1Y3ZzBlOHhPYVhiQUM2SW9PWnpPbnkvZUNwYWl0?=
 =?utf-8?B?WDR5WnBNbGUwY2V4UGJZUGlwMXdpSmhQMk9oaUoxZVpNNGlxZ0xRZk5tOHpu?=
 =?utf-8?B?UFEvNTZ5M2lEczBDSHJKdEsvWDFHZG1ocXlvcFpLeE9DQTFVcWt1MjVLQWdh?=
 =?utf-8?B?bUx4SzNPTTJiTnh5SWZwb1dPUVYxcDhJM1J0UzZmU2RhcEc0T3pFMFFVTEZj?=
 =?utf-8?B?ZUdFUFV1VFoyczcyMWh1bmZ4MGUyZGtmYWtNRlBJYmhPY0JjZTlxYmF6OFkz?=
 =?utf-8?B?ZDRhS3g0K2RoVHJzU2RmK1lTaFlQckpkZnhGQUg5WmdIaVp6b04vSmdteXlh?=
 =?utf-8?B?azBQU0xXK25DVnc5NWpkcXZRN0d1YTlZMTBqeHliWG9tQVRXNWJVMEJFcGM1?=
 =?utf-8?B?ZGF1d1JOUlpybXFleDV2MWpHbUlVM09UUmQ0NnRqTkZ4cjlHSDJZQTV0b3ky?=
 =?utf-8?B?aklVeUFwNjJrTERDQkJTeGJHTDFpdUlIRk1HS2hIcHNjYTNpdmEwRmxrSXo3?=
 =?utf-8?B?bmZaSW56Smc3RVpxak0yZlExUEh6VkZBSCtCaHUvblFmaWpoenN1MHJscDlZ?=
 =?utf-8?B?UG0vMWI3cVllTmNxL1k4V3RZUUVJdnVkUXNFZWdzdEhBek4wVXpIdjBNQlNX?=
 =?utf-8?B?QWtCYVBPeHZScGJ6UmdFRG5aVFJPQUc3UFFJWnJRZldCUlFoeXBXRnB2OTI4?=
 =?utf-8?B?Mi9jTjE4SXU0cjhtVUNRdVdSWndFV3NJcXBodkh0ckQ2MlFnOTQ1d1ZiTHpa?=
 =?utf-8?B?UTVCR3FFWkdBZnlDNXZvSlpvN1F0ZjlDS25Ea2hBaTRLUFdRN1Z3SWJyZ1g4?=
 =?utf-8?B?bVpaZ0dURGhSWnU0RVFFUzh1WnZBT2gycmNPdjI5MFdOUXcwRDFkbU8wOVZ3?=
 =?utf-8?B?MjRBWU9xdHJQbHZyR2M2R3p0RG5VWXRObUc3Z2tYVWlLcGpKLzJGV1dkbkFT?=
 =?utf-8?Q?TVGnpbG+4nE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c2dqSlZqYlllNXVVck9pM2FKL1lCYndhOWlSQ1BTc1VzSmIxMzJmWTlnVkg2?=
 =?utf-8?B?alF3T2tSV1ozSFBBeExEVmdyMitzdjd5Uy9MQWNBK3loM0pENC9LU3d5NVcz?=
 =?utf-8?B?U2JPd1l1TFNiWjJCTXRCNUNQZDZCRkZTdEJKU3JwTitsRDZlSEcxMEI3ZzJQ?=
 =?utf-8?B?QjFnOWlFV1c0YXE3ZkZMTitMYXRSdVNIM3NxL09FQXZOY0tDU3hzZEZrQjZH?=
 =?utf-8?B?eVpySmxLT0wzWGFpWHM3S29peDdrTFlpWHEva3k0NUFZLzExQks4SFB3U0to?=
 =?utf-8?B?Y1RrUkFJNGg5RGVBUGpjQXJqcXhoWVlmakZzYm5tSjZVNkdyREQ4V09JRGZT?=
 =?utf-8?B?dGwrNm4zTkdvR29jUWt4YXFUSnc3ZWZmRWpkVXErckNGOFhjaXJBR2tuWWlL?=
 =?utf-8?B?bEgvVWoxb0pERE5TNWEwSHNGblZyV3hEVjFRenBkY0Y1bGRDa01rS3g5OHVV?=
 =?utf-8?B?djRXODJVdEpMOFBUZGJ6cFFYNkhqRklyM2ZaVXJXakFzTlJvUFh6TkJ1QTVm?=
 =?utf-8?B?YzNaVHNLcFVqT0RXNWFPaWs0bms1NWFMbzZrY0lkWWFWZ3ZlVkx6eXlJcmJp?=
 =?utf-8?B?RTAram5ySnl0TEVjcDgxRy9vYktuZlJ0Nno4TklpaVY1dS9PRXVPdzlQVTJD?=
 =?utf-8?B?eFlGQUFPR0dqL0ZyMEdsTjVWcm9wRVExN3lzNXdVYkRGakFVK2NOZk1MT0hj?=
 =?utf-8?B?aGowVTVCdE9QMERHR1E5RVcvYmZwU0dnUHB4V3VmZENKd29COVdQR3I1amdI?=
 =?utf-8?B?cWxFRmI5M2ZidGlYTjJaQnZ6UklJWFBURytwam9mSzdxeERKQ01PYUtWaTFZ?=
 =?utf-8?B?U1dNblE0ekFnbmx0TjhOUXErblUwTmhnVThHMnRGbitod0s0VVZCZGRJUTFw?=
 =?utf-8?B?K3ZJUFRVU0JmMWVqcS9xRGRlTk5ldm1nWDlJRWluSkdZUFliSy9QL0VTVzJF?=
 =?utf-8?B?QXFvK3JpOVliOTlGTGt4TS9iRnRERjA3ZjlLUzdvY1hxZmk3RGhadUxONVJh?=
 =?utf-8?B?MnlQZkxlMEJEZTh2UTFabWJIZE1NSXg5ZDhmcGtPQUZBQWJwek1iTHlVbFdx?=
 =?utf-8?B?VnpPMWpNc2RpcTNmcDVXVEdicjI0WUdRT3F3ek9vQVRtNGZKK2VnaXg4N2hZ?=
 =?utf-8?B?NUMxSE54RE1RVC9VUjhMbkdMTnRCVHpDSkFHWlVHZWQ1bUFBWmZrY2NWa1ln?=
 =?utf-8?B?UTdRTEdLNktJcWZTc2ZDZVZyellQNGx3UndwVGJLQnorT1BveVUxYVZzd1Jo?=
 =?utf-8?B?azcxTGxaVDIwQjVoWFlWcmVzUG5zbmZhdTNyMmo2ekdzMU1LVmtkUWJIcTk2?=
 =?utf-8?B?R0Q2eG9NQVoyemlOSnAxTEhIalhvdUg2M0kzZTlQZGFDY0NlZERRNm5Sd0Er?=
 =?utf-8?B?ZEpwdXZ5OW1QcmdMMkNtYnJHY3VGSWlSN0dGYVdoZ1ArdFpaRkFUQ0lzM21B?=
 =?utf-8?B?aUh2U3RlVTFWQUFiNWp3OFZKUmhoZGpHckQ4OG94RU1xVjh6TVZERWMzVDgv?=
 =?utf-8?B?NWk2YWU2RXlrb0Z3TXZXMGgrZVFPUmlhaUk5TWxUNzlxL08xN0F2RkxQRGlR?=
 =?utf-8?B?OTc4S0FLM3RRdXlZY3hjWWMvOTAvZ1FaaGZiNHhhMmFpV1p3ZTFDMEgydE11?=
 =?utf-8?B?L3NyYjZ1L2poODVTc0s2TW40cTRzWFdkVCtJUHVTYXczSEo1bHZUbkhqRFJ5?=
 =?utf-8?B?UlIrb3MvZ3pReWEwUUNxNzdQRHd0elpwS09DV2d0a0wwNU8wczBaZzRwRFhT?=
 =?utf-8?B?Q0VLSkhyRFJqWFpTVXliMzFxRWszM3grRW5hZEdrcEJaVnVJazFwb1JEV1BX?=
 =?utf-8?B?SVk4empoWW1OOTArQ1pQN2NkVHBveStEK0g3Q1IxbXZ4NFlkTzJkRmpRL1ht?=
 =?utf-8?B?emRBUFNJNWdMeVB1d214RkZ2YktCRkI1KzBoNDFCZUtPd3F0R1FpREl0T1Fj?=
 =?utf-8?B?MlhCMHRtU0wyK1NYQ1RQL3UvS3Myei9rNVJUUkFwZy9FK2RRWTJkRCtrWnZY?=
 =?utf-8?B?NFMxOFA4NnRxV2Y5Wm13V1o2NXNkblk2RTA0Y2ZTUEhlcDNQVGxPOUs1NG1s?=
 =?utf-8?B?YUhSZStrcW5mYUFLWnBieGZWTjdDR0VZOWxRMW5Dc0o5ZHI3a2NCbm5qUDBQ?=
 =?utf-8?B?SlFvZVhVdzFEeGRKdXhET1J0MEpRelFZaWd6MGlvZktObmpJaHU2QzAzN1Yy?=
 =?utf-8?B?NGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6j7fY0hx+UI7kccCC7UxpS3JN21Kpg186Fv6LA0zaz+rrtTRc/neLOBtmIZy+gfaZB5ZRwYnKp7SMNblH9Z1oHT2IHICzajKjjp1O4zXFIiNvhiK3W3dqtFV7SVz59krngK7l9jUcW4p7zCbgK/u9Sm+CaZqRap64jZyOMjTWj3jGhpJ4LiRNN0MTBr9qV8xMaTGz67VwM2iY6C1gNMdoyhL6S+WblZ3pdf2/MjCm9Pho9dcFdHOzvq1fzZTdpRimqui+8fSFHGaTgk8hTO9VUlvPm+N5qya7GbLRDwYv/Id62U9dIipKr36MOHks0xEQhFzfwqErq4BucgoH4dm5jEf1citUkZpueeT4jxlacS3zLs3hd4Tcnl3VDFgqDacN2JFFxrExAHViDYIBMlOm3eSk7Toxwtg9EYeor3hViWlRH+3a7+tLcelgiyt8jqK1eXeIK38UbML7POjSNg96EvrTad0fPAZuLoS/133Xke7bf39DmayXjNWmK69+5F88piPWH//4aSdjan4n287aGBjQBP4YRFNVfHnkl3rGJVwdNhzn3pIl3i9wQ9akefr8GnNigWAmKtdjXZE1N5bGdAPmE7FvLEM0IV6D2vzZh4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30676726-8bfb-4d61-253f-08ddc9dbfc75
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 11:28:03.0681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l1LcuvlTGordBo0kIvYFDosP2LYa1km1TuJwA5piMIqIOxDhNx0Doh1JGG3t7JiM0Gq6V9pKaftJnTK3EB8i7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8300
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_02,2025-07-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507230097
X-Proofpoint-GUID: Ngp-gyjfguFI13_QzlENJo8uLmMHfFpJ
X-Proofpoint-ORIG-GUID: Ngp-gyjfguFI13_QzlENJo8uLmMHfFpJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDA5NyBTYWx0ZWRfX3H98UZqNqsT3
 ON+CHGye70m9qGDHCzaO9nTVDDes3KyuvwbJo/GO+AWMd4zyQsq02ecpS1TMuRRsKd1dQFsyMAN
 AhSf3NW1TJdzDP3Bl816hD1OkQcmoN6BClwENbpeJs9D0Gsq4x2VrBZ2vPHTAInm1yHINXi64q9
 ubfIiRZuxi9m3A8ggIONHs7IrKfF+NTf0JD1TiKFFHdATseHIjORtwsaAjWau+x5+Eno5g7ZnE6
 oAtAaAVmb8O0+YQJ69uuZzj+PapHGbCsQXhJbuAfVJ+xLs/IGqToSJciM8zeUabPSCyyxkk0Mdb
 kbAwDRItv4C8HooJ2Bcy2KeoGkosHDRsjFLXk6Pp0VXNY7dEgbiPhTz67d5bnZ+woS2jeCs95ap
 BPSYoQIXBHgVm58rvdcy/1HgfIk0ezgWGzif2J4EttbKbwGTwMqPd9qLhbaWl5OQKdRHw7u8
X-Authority-Analysis: v=2.4 cv=IPoCChvG c=1 sm=1 tr=0 ts=6880c747 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=yPCof4ZbAAAA:8 a=0CSj7cUIJSNNMibfuigA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10

On 20/07/2025 23:15, Mike Christie wrote:
> On 5/14/25 5:26 AM, John Garry wrote:
>> On 08/10/2024 03:03, Mike Christie wrote:
>>> This adds atomic fields to the se_device and exports them in configfs.
>>>
>>> Initially only target_core_iblock will be supported and we will inherit
>>> all the settings from the block layer except the alignment which userspace
>>> will set.
>>>
>>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>> ---
>>>    drivers/target/target_core_configfs.c | 42 +++++++++++++++++++++++++++
>>>    include/target/target_core_base.h     |  6 ++++
>>>    2 files changed, 48 insertions(+)
>>>
>>> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
>>> index c40217f44b1b..f3c7da650f65 100644
>>> --- a/drivers/target/target_core_configfs.c
>>> +++ b/drivers/target/target_core_configfs.c
>>> @@ -578,6 +578,12 @@ DEF_CONFIGFS_ATTRIB_SHOW(unmap_zeroes_data);
>>>    DEF_CONFIGFS_ATTRIB_SHOW(max_write_same_len);
>>>    DEF_CONFIGFS_ATTRIB_SHOW(emulate_rsoc);
>>>    DEF_CONFIGFS_ATTRIB_SHOW(submit_type);
>>> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_supported);
>>> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_alignment);
>>> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_max_len);
>>> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_granularity);
>>> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_max_with_boundary);
>>> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_max_boundary);
>>>      #define DEF_CONFIGFS_ATTRIB_STORE_U32(_name)                \
>>>    static ssize_t _name##_store(struct config_item *item, const char *page,\
>>> @@ -1266,6 +1272,30 @@ static ssize_t submit_type_store(struct config_item *item, const char *page,
>>>        return count;
>>>    }
>>>    +static ssize_t atomic_alignment_store(struct config_item *item,
>>> +                      const char *page, size_t count)
>>
>> What is special about alignment that we need to be able to configure this?
>>
>> Won't that be derived from the block device queue_limits (like granularity)?
> 
> What if you are not using a physical block device like using LIO's ramdisk mode
> to perform testing?

But would this non-physical device still need to support atomics? I 
would assume so.


