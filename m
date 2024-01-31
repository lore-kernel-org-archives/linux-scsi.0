Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F47D292
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 02:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706668442; cv=fail; b=jgfx7oIt/xTiep6yMhPYcnqrxs8KziocSR6+h/at/J3rzCMWpc9gm27n2wvMJBlJlFuZvTw2Q2mapNX3GT+DbYuL3EWFfISQ8VZkZ6SjL7KwHE0wGyIgh9NEWubsEKY5fMVmU8DbrNvhDfGzQnawN8S2fH5Gx2vLh8IrJv5QWv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706668442; c=relaxed/simple;
	bh=uBAlUs3FQeb7V96I03f8CVNhbHtNrTWtPFjgsJALE38=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fCIuOFsMMTcrxbb8oHL0YFxwGOL8fCMqtTvT/y0GsAif/ctRDjtr7UmZlp/ncwbugwiG0DSUWBSsfnh1WmOh9yPIcxp/BZtMRDVxsdISSmETQ0wXyvOb2uwMwlLkR/Mlh4ZdEj7CFmN14z0OzablS2S7eideVaz6UJoE5vNAWzE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KGjsNXyF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zng3F2Mk; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KGjsNXyF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zng3F2Mk"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxkch030570;
	Wed, 31 Jan 2024 02:33:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=RybHsAbMeTfhtg9qlH1puJhlEzk5FcYSDc08pxtfJlc=;
 b=KGjsNXyFESkWXpAOqQd/elMqP5rjk/DZlOXwUHXTc5WkLn9rgekMZfwt/RuBovkxomMj
 img8flsDWEqWxfR/TTLUrMl2DG2WSxQ99UStdyp7z/lodboUr1wFm/O6VXIoeuQGm3ma
 PsOuOBw76LUsj7AgWaQZNv7UbtcypWiesN7JmAVyumw/PKH/7lJgRHN+IvSVDzgiJ06K
 7nmgBNIqLbyHjylqC1nyWyxnbH39SIBLOs3NDoYmDvgvEgng+/mfBWDvpaekOwTScJai
 yejI/UqmBtigWism3BcB0RaiXff3m2gvM0QiUsWjeKAsMW1b7waf3hZ6j/0MeiOOss4j gQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvsqb0khv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:33:57 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40V0HP5P007770;
	Wed, 31 Jan 2024 02:33:56 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9enakb-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:33:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qs7JFaD3ATUXaAqe3c+JVyysVHh+fY8U9kJ59CWT64cNFNuJdJp0ViJX+9jLpbF1xD9+y8xoawjfOvFui5JWTqnxbYcLizwgnzkaEed1rYUlkitXsT4GFtsmr2Pn58DboxRNoA41kCplpg7xURgMNNpsdXvRKmxjV4Mo+yVpQm2oCzdQg4rMnnljfRu4mzSis4wcqberj9Pfr/SBXoXXDTVXxDZc9jeJ5YWZu2LUxVcP6VAhN6yeJvcygUHPk1roJdExkpJuQHFggM174z0OCwvyIfiZP7sMPxRACSeTsHk0zdCAQebZcRoYCdK8pzbUafHwNpxIYznStTEXaymhrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RybHsAbMeTfhtg9qlH1puJhlEzk5FcYSDc08pxtfJlc=;
 b=ATow/8InX7EhwU19SDwvH6ywPX6M2SK/MykxQlrgZEpQpKWxGFwSZ2IXLZp7nNKA+M+NDZIckqaelvpUCT1VkRAUyFSWuHE6GvHR5XmFQeKmxXVyuy7pxnoaJ2SpLaSgUCvzX54mUI721GbJ4uU11l+KyBHiuOtpdggrCDZfXPRe0iOKmp1VMnEn3J6d0I3sofbQwKTHSw8EaR3++AYuRUEq0Byk5I+cW5f6kv6d8OfiEegrWkxju7NkqIcm7bE+HN5VUge37hHMLV6Jq9mYhSz6IBPoomjAgFxbNU0UXaKM6pkUEZuxQTUcfTmNtAcfJ4z4DU3BUf+OYoi9ck4M1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RybHsAbMeTfhtg9qlH1puJhlEzk5FcYSDc08pxtfJlc=;
 b=zng3F2Mkg37A/vERbAAOxlW5/ASFZFTsNLweaChYzP0Z7zjhxk+UjOP5g9gDiyI2PaKNpb85vhXrdSI2ubTRC7H5uFcmndh7nW7gEXHK7ormtyBHucAKNzQ/KqGIZ2BrNnEX1yJcvtaN6wgQflJ3ts9rTfZMrTyoP32vVl+qOP0=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by MN2PR10MB4159.namprd10.prod.outlook.com (2603:10b6:208:1d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Wed, 31 Jan
 2024 02:33:34 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b%4]) with mapi id 15.20.7228.029; Wed, 31 Jan 2024
 02:33:33 +0000
Message-ID: <51a345c0-2c86-4379-850a-2a5c44411cae@oracle.com>
Date: Tue, 30 Jan 2024 18:33:33 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/17] lpfc: Update lpfc version to 14.4.0.0
Content-Language: en-US
To: Justin Tee <justintee8345@gmail.com>, linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, justin.tee@broadcom.com
References: <20240131003549.147784-1-justintee8345@gmail.com>
 <20240131003549.147784-17-justintee8345@gmail.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240131003549.147784-17-justintee8345@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0195.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::20) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|MN2PR10MB4159:EE_
X-MS-Office365-Filtering-Correlation-Id: 20ef285b-e915-43d5-7b85-08dc2205053c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	83gusWZDu72MQaHS2/S8WsAzA2RUQElibyXOfwgEm2DhAGkFx/BomkbHs0y2P+vOJwHiS3frXWyRKL5biAjBljH6OMCR5gU48TSbDJ5kbhXgDSVJqF/ncfbckr+i30SMY5xmnSvjRODSe8Ztt9oHEpLAdcfLIQw4NPzTXYvquZHJ6vSn71CbNlRxla54umOs0VMll6ceJUuKNyxKZMB1r1/W5fELyd3AbAS7ppKCprgMON5W7zICmkg9m82imIdKjQhho3KRJkLocRzf8gl8TE60YeXkJHmz1mm4pu6wjZhZmmEB1vA+7A0Uke4Bk+vKVzwlImTKjtkGogsh4ds09OOM6wsEXI2GKAfeZQPDTceckssZnuSqniQ9CIPnqeI3lLG1aSm+Ky+qqEpgkiD5I/UBT01kXmocmWTTQUWJMx3oUlJv9sh/B8mkkPvfA2D07ZFgBXLAUK4A9KNbeKdev6lEkr7AlnqDSWF/wJ9HOxnbOCd64H426pgGKt76a0nsl/kFZtbyyd9HulumaEOAwpy1xvScfDziDsYftNJQv5mTYn2Y1LDS4Sq1gRcjijh0s01vKt0ABC/TvAVljhABATTGWU26Zqzi5tBxQUkDErUWjtbrXNqdmZEdbFHAzzuJ74A9hrseUrQwD5ZIBQ/D7w==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(396003)(136003)(346002)(366004)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(31686004)(5660300002)(66946007)(26005)(6486002)(66556008)(66476007)(2906002)(83380400001)(15650500001)(53546011)(6512007)(36916002)(6506007)(8676002)(478600001)(8936002)(316002)(44832011)(2616005)(4326008)(36756003)(4744005)(38100700002)(41300700001)(86362001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZHRDbVZKUTJtbW81aWtQcGFyNFBJT2tyNGI0aWtsVzBubjFxTG02eDFlWko5?=
 =?utf-8?B?ckVLbG90bXZMU0gyTHVoUEk1ZEdPNVZUYkoxQnRTbFRjMUN5T05PdlJMZThj?=
 =?utf-8?B?eTk5UUx5T1hqNVNLNlkwVlhkaC9Nd1g3U01hWkVFMEp1NmZRN2ZudW9EVks5?=
 =?utf-8?B?cnJ5bk5odjVHMnFPa1ZXdUFJZ1BxNyt0SFdCMEpteWtNY2wvZHJ2d3VMQ0U1?=
 =?utf-8?B?K0twZXRXSTlqUkVEMjQwajdzeVZJV1NzWDdyRWJheS9XUXVCUzBFMFVmcTdr?=
 =?utf-8?B?S2N4MVg2NkdHczBwVnVZMldwNmdHYVF1TTZ5aXRsZ1FIZ0FtVnozT0I5US90?=
 =?utf-8?B?cDBoUWFzY3ZzRFJOMmgzUzU4dGJvZFZsaS9hM0o0eEt4dHMzMjdOTlAxODMx?=
 =?utf-8?B?NWpIM2I2VUVSMXpHWm02M3lvdVNSV2FURGRBN1dFTnFXQWJGQ3phcjBTQXBD?=
 =?utf-8?B?aG95dzhGeTVwSjhiSkthbDdaYStJUm16ZHV0NzdaWS8xWG1TU053YXlXYVFB?=
 =?utf-8?B?UkM1RXB4cHlqeVBGR29nVHBuTm5MZnBua0hMRnV2eGhKU0FQbDZPL20yWWpn?=
 =?utf-8?B?R0RKRXN4MVNDa3MrMWwycGk2Slp1UzJia3JjSXp5UHc5bnd3VGZ0ejFKd0xm?=
 =?utf-8?B?T2hVS1NqUDFpbmFBcnJZMmhYMUphTzlMaTVFNWo5dmVNdlVWS0c5YnBWM2Mw?=
 =?utf-8?B?VjIyS1ZMZlR0UENCREc0cTJhaGtYNnVQSVJMcUNsME9PMm1JaUhaK3RNeG54?=
 =?utf-8?B?bXMyaTlyNUNNdDJqSnp3Q1B5b3o0Z3VlTm8vbU14ZWtVdkpIVFFMZ21nTm9r?=
 =?utf-8?B?SFFka3JhRi9ydWVzU1YwT0pZbzU2ZFUzZThLaUs0dXdoOFVJdWZ1ZE1JT2k4?=
 =?utf-8?B?YzZucUZpaGJUdC9KNlhhV3o2c2VaLy8rdXRxWVgxNWVBUVAreTI5UVhLWTRU?=
 =?utf-8?B?aWl4SU9DS21ITmxVdThmY1dSRjk4a2w4anliVGp6U2MraVJPYm9CMjkrQnpz?=
 =?utf-8?B?eEV6QllyaklBYXFnZ25WZEtnUzg2S0Eyb0JubWxudHFsVExZdTNsUlllR3pE?=
 =?utf-8?B?Z1VWNEZnZnNNWU1vOGcwTlRLRE4yQm5TS3RwNVlYYzdtdEY2dDE3VzlycDlo?=
 =?utf-8?B?bzkzS2dtOForWWlxWjBabW9QVFlvbFdudGZBeHNtalZBb1ZVQ2l0d1lzUnpB?=
 =?utf-8?B?Myt0TDBEbC9QMjd0NVBZWi8vZEV2aGdWOExhd0p1K0QxRUl4RkpoMkpRQzVJ?=
 =?utf-8?B?ZjBMb0ZET1F4ais2RTRpRThsaTdHeEtXQ0hPbVp1MGE5bjRZejg0UFN3QTla?=
 =?utf-8?B?TldxVEVmYkd0a01JZjJ2ZHZBRnlqaE9GTnVSNUtZTWxIVHBZdGgxNnF5Z3VZ?=
 =?utf-8?B?Y2tzc2JJMWZFM1Y4bXZDbHZkZk5PK1RhdDFhd0ZsVTFtYVJ6SDkyTHZBMS9x?=
 =?utf-8?B?UlBQRGREcWh2L2dxMUhRd0dWMngxS2pNWW13a0RaUytXYUpUb240eXpOM0k2?=
 =?utf-8?B?SStQQ2VhWTlGcGVuOGdUVC9EVXB3czVRUVVkdW9OeUNFM1J5STBhRjVLSHlJ?=
 =?utf-8?B?ZVFHeXEvdVdSdnc0dUgxV1YveTI0djN6WU5UR1hlUjA1WkcwWUk2NmtnaEk2?=
 =?utf-8?B?QXhua2dIMHdWNU9LSnFlTlFYd0lpbGkvOGdJQ1FJVDdOK3RsMXgzZi9yTFNr?=
 =?utf-8?B?dFI3TFcxT2RMaDFRMUQ2OURIV3puYjJPMlgyUi9tQzQvbW8wc0RudlpyMkhY?=
 =?utf-8?B?VXdidkJ2YWpURFhja3VnYWIwZllHUXhsZXhabzJrTjVnZmx5Qnp5bnk5SmJy?=
 =?utf-8?B?bklKUkd0dTc3ZWtUQXR3TkoySENYMnYzOWRxdC9nU00vQWEySU9BRm41OGtG?=
 =?utf-8?B?S1cvNG13SG5oTU5IU2xpR1pXVGF3bFhlT2dMalB4TkpZbWIrQ3ArdVBPQ0Yz?=
 =?utf-8?B?djZpaTdibWpUYlhSV0JzaFovNm0rQXlOLzZOUTBheS8ybVVkYjFhSDN0YnB5?=
 =?utf-8?B?YWNIVW1LelppV3R0QTNsQi9DZVowQU9MVkdzYzRnRzUvUzRaYyt1YlZWRVR1?=
 =?utf-8?B?ZmRVOHpxR1p5QVJKL0FuTkIwRTE2VkVKb1ZpS0hKYkdXNnRqVVlDSmxESVk4?=
 =?utf-8?B?dXBGbEFhU05DV2FJRkZkb0pFVnhWMk1yYitqVmtrdVdiNlNibHhZaXNMREh0?=
 =?utf-8?B?dlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	jBy0q/HoPmN0dGKKHsTLNAeS+y/+qAPKRCu+Qzw/NC7T5MY9xkRYzZK8xcgUO6O46Pr0u0SPdX1mMxc+vemjzKIUeToMjKRn8mTbFBrCwFZVvK04lfh33CFGzt2yMUIUhq33/42TlGIFDzEtoIUjJt1P9ztB0ZzQyoim2y8AQMlL1iOwv1kqlePj/md56FU8/qpgBQcFbntvSL1owhszyNJHqlwSJYz2ZQrZHfxnDD+MVihTs4WquCtGQFLTDmTU1vgUvELqCRnOyDhtpyYCbpy4E1ofZB6A3EAOQFxc3TO3yPIRLzy3a2f1vFn6B2oBeZ1O3flvW/P/d2SduHGXZqPiCpeA8iuT3GKsVts9j1q3Bz4yL4QV/JPKSAyCfSR2tIjUSzvj9vp2nOch6bSbFCfNv26cK6yq9UJTkMZqQj5ar8ZSteGs3nkGW2UjPPTMWOTt3ImGDfZ55KjaNvGWhTaoCivlJa3/wdECZC8+QSh+pYi7ZPDDO46Fm5Q8vFi8ae7WNh5OS7ks9sTxDciTjMy7KwWnDgmh7B5nL8hox04YE8rI8gEEP7Z5TEzuQeHNWT2IzlxVX6gf6p0MQluGWsLJd1R0hotlRXS1ZC4iuHc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20ef285b-e915-43d5-7b85-08dc2205053c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2024 02:33:33.9107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8JBRKGkKIccctdNlBlkK5U77o1TRdWkh4qphFw5BVlp2I6BZI4sTuhZrSOgCvc+USCiTnhx4T95Fhtc+xXho5DG0oFKfz3gOtrnLe0aSDQ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4159
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_14,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401310020
X-Proofpoint-GUID: U4QX2SeqlP1DKSzpTtrh8O9d5soHkPY1
X-Proofpoint-ORIG-GUID: U4QX2SeqlP1DKSzpTtrh8O9d5soHkPY1



On 1/30/24 16:35, Justin Tee wrote:
> Update lpfc version to 14.4.0.0
> 
> Signed-off-by: Justin Tee <justin.tee@broadcom.com>
> ---
>   drivers/scsi/lpfc/lpfc_version.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
> index aba1c1cee8c4..573c9721ea0a 100644
> --- a/drivers/scsi/lpfc/lpfc_version.h
> +++ b/drivers/scsi/lpfc/lpfc_version.h
> @@ -20,7 +20,7 @@
>    * included with this package.                                     *
>    *******************************************************************/
>   
> -#define LPFC_DRIVER_VERSION "14.2.0.17"
> +#define LPFC_DRIVER_VERSION "14.4.0.0"
>   #define LPFC_DRIVER_NAME		"lpfc"
>   
>   /* Used for SLI 2/3 */

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
