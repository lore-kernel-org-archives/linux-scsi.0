Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 220B3EE4993
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Aug 2023 09:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbjHVJFo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 05:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbjHVJFo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 05:05:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D31113
        for <linux-scsi@vger.kernel.org>; Tue, 22 Aug 2023 02:05:42 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37M0j3OG003611;
        Tue, 22 Aug 2023 09:04:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=C0Ufl7esDNCYvmWvYdnltuMggnFh+XydqcluM/YKMsM=;
 b=D8x6+Nq43GUlpkc1J9DRbTM8jU2ua7z+dkaBq6BqfKDLc07FSrm7JdxJ6J9meQlw0uYX
 270y7QJvbPgw7lSRMwFqwRYONWQU0OmPHhfBbXbBQltYEdZ/4aawIeSU58GbcqYsCTdh
 l8nruIzPqwPisH+la050diMDoq4C7d9/S1tnzZ6CljTtGJxHASg8HhpQnjLsYzzsnMQH
 5Qi6t3wAU1yyrGJQbieEYMiu5Wf+LgWcHg0Ib/1aZ4dlPuCxgZ8cYwEjmTn92mXfsYVi
 ZCAy5yErJb33H6Ldkb8zKHNxFxvGc+1pZvhJCM4iKYx965QIl9mAuRA4iGBB2rh8VE6n Ew== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sjmnc4u4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Aug 2023 09:04:47 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37M8YKnh029930;
        Tue, 22 Aug 2023 09:04:45 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sjm6b3dn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Aug 2023 09:04:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UIhIzkU6bGrxRrCoxLRFKu25CfXpt+v0pKxWBbVgFGFfk7pEogpH/AEaeEr1YpsLNPi43u5shTEdbM8JWngLT6cGy6KkwXCUf3K42jSOnotPIlWgRYNx1bqlJKQt6et0Jho+zDBGtSkgiaLenAqC+aIQoh+8S8Y+iRYghcUZ/xogfkzZ8UjByC88YROSQxYlxvmNpG0AjvAYJqBeLYa9MD+mydU+KycdnuhLJYEGxp+bCCNPTZ3mI7SL0ecpxVU4CamU0GEB36XSQZBPASuXcr6BQMRKBN/bLs24UylK0Ic2lfOjGUCkUyzOwoYYlDp+pkZwfnocFDEcqjL/zI/WCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C0Ufl7esDNCYvmWvYdnltuMggnFh+XydqcluM/YKMsM=;
 b=CTinu29QQHQcj0R+l0fkNkplF0ejHOc3vLECqHDb0zpFHkzKA9u+DWqYXORVpVskjuL4gqq8N5NEIvzvkRWCcUue4ejj7pgkEBzwoawRVc16fTaYA3QS+7ISqtsrAjuCUvQOmVqQNq3DfteUuAKF9+SROlASMduGa3XNuTopyfbPCy6XZVxREH+xHYcpna+71Dju/iwxcHAAH/TVDeVa+awhF2pUx+J7Ng1q1eSXx/yHbscevat7IxlF0aTsOGto/WKYoYoou+9meduA6ITJsw/oqnY3AN9nnZKJOKcnAc4MZ4gaMdn2xpJleZvsX6kJ+ct6XQLgkKdfUsGUJ8/AlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C0Ufl7esDNCYvmWvYdnltuMggnFh+XydqcluM/YKMsM=;
 b=sUVCVtFJzbgrXvAz1eGxJceZw2fZudJWNNc+EM7WAoVosa25TDNfAEAm3uxctccRNjDtClr2F/8bwOZVvXPxsQfNBXYExorKuV7ySLA+rzCLrAU0+QfciO4ZpP9cuMTOFlnnyGZ5+GwkB1cEdIiU0tGR7B9NV6W+DOZ/aWqtCDQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB5017.namprd10.prod.outlook.com (2603:10b6:610:c3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Tue, 22 Aug
 2023 09:04:43 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6699.022; Tue, 22 Aug 2023
 09:04:43 +0000
Message-ID: <36f46807-2cc0-1efd-b900-54bcaa0cba15@oracle.com>
Date:   Tue, 22 Aug 2023 10:04:37 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH] scsi: core: Report error list information in debugfs
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Mike Christie <michael.christie@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230821204101.3601799-1-bvanassche@acm.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230821204101.3601799-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR04CA0091.eurprd04.prod.outlook.com
 (2603:10a6:208:be::32) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB5017:EE_
X-MS-Office365-Filtering-Correlation-Id: a299967c-e0b4-49e0-e19c-08dba2eed2e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kR/SvKZ1ULSESP9l0kvMXXmeePV+TqJqE4EsrMV2+Ws2RgTFjK9patTmnGYo3p0PHxsAeuSvyrHOranwKNQRUdgUVXXapFzloJU2rVKer8G+7naR/N2dX78B+j/CFlRilc5uIVuCBk9Us8Ny0Iv1D/OS3eOQsJui81Vy1QweTvKnxSWXBLyw7XVDdyNNTu4XCWda3gGoGLl8agahab8tscWBQwgmkKgtJq1YxS1/w1o1mKh2Q68b0DiHZQHpe1KPNMzXDx80lBY2JlpTo+ft66KkqGwqoZ+Ngbhgv5uQpyW8O8JYFF3hhvuKyjVJF7GvmCZg06qI1STvH9P2HUFvauP5+GJTHb23uPZbteaOzYgMBiqpo3fjBN2bYpkcZdhLkwkLjFj45/s5biisIKpWHadfwIrTxLJ2VUKIRdXL+E5xWKuZjQ4Vwn/62Pf6KfE5glPXip9BI9iBJ+WZAYB2lo+Y3w20L/KKonntAfiWVAIkXXAnhZsxo4B4O2j0Yj6aQWaBEHlf07Cw4SWfj6Kar41jv8lyxm+9xFamU32fa7Oh+5Xo/FDl5XmNLHS2KNMnEMGKSyOQSAN2jgp4i2b/giA53VtFW1qSvhiE82M+CUUqd31bcqsPJOH1Z0bZMnH9R6scZd2oz/FNDb87bAQ8EQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(39860400002)(346002)(376002)(366004)(1800799009)(186009)(451199024)(54906003)(6636002)(66476007)(66556008)(316002)(66946007)(6512007)(110136005)(8676002)(8936002)(2616005)(4326008)(36756003)(41300700001)(478600001)(6666004)(36916002)(38100700002)(53546011)(6506007)(6486002)(83380400001)(2906002)(86362001)(31686004)(31696002)(5660300002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MW9aMmJwcGVQRXpmVzJRRE1ENlFPNkluYUNGa1QrTTcxay9nSkREU3RIRExp?=
 =?utf-8?B?bnM3YjBUeXlVOGlZZ0cwak1DczA1RWJhQTVtcFZsS3d1TzNuc1lEb09aMDIy?=
 =?utf-8?B?d1hHYVp0SUdlVCswNjcvU1hqOVVmb2tHRHRHU0JNWHd3d1JRbURaNWFQM3BK?=
 =?utf-8?B?UkNFREpZLzkrQzBrbHlUTmN4cy9tN2ZUMHAxdnRQYjQ3OGYrMkl5N2x5UGdN?=
 =?utf-8?B?OG9EeWNSamdTZUpRZU94T21iWUw3QThWNFJTRTBVU2M3SlNSRmYxWGIyYjk3?=
 =?utf-8?B?d2xpdG5FUlNhakpvTWZQMVVmeU9xYm9GaEFQeFUxcHFjT3JnT2FhT1FDZlhB?=
 =?utf-8?B?eUtqVVpNN3dwbXErb25iM2dmMUlJRDU4dkhtQjAzRFcyYml4Y2tRSGxoVlZF?=
 =?utf-8?B?UmtVMzRXVTZNamgrbURHUkRSZHJDLzM5V3RBQThJUUR5TEdSMHE3b0JmUmln?=
 =?utf-8?B?YmN3TitOZWZDYi8wS2M3akpwdmVQeTZiY1NLZlFUN1V6a0ZYSmhCVExsd2lK?=
 =?utf-8?B?enAvQXBNZDNiY3ltVUZaR0ZJZkI4ME1BdUVieU1nVGJlc3JwTm1yRWxWT2xl?=
 =?utf-8?B?aW1ud1cyQytuaUNBc2h3RTlSUVorUGM1QVJJbG00eVV4OW82dkhKc0QvdWY3?=
 =?utf-8?B?Rm01cDJDdFg3ZkFJNnFJdEw0SG9EM3g4MTRzYTNaOHg4SUx2TUFiK1JGMzl1?=
 =?utf-8?B?c1NRTjVmNjU2OVdoV3Q2blkxeEpxUUV5cEp2L3JOR01UdjY5bGdxYkxsanRY?=
 =?utf-8?B?bUZpUEMyTk9KTS82MTg4d29SSFZCbmhQVG5OYXZoUVJ5VndxSzlCemZtNTND?=
 =?utf-8?B?Sm41bzgvbG9tUlErT3hwTTFUdVMrMEI2L1F1eU5hemVHL083RVc4QXpveGR1?=
 =?utf-8?B?WEdxaTlnMVg4MkdORmxBc0gvQkVwZUJHcWFPcjVsL1kxd0xLTWE2UG9aU2Ni?=
 =?utf-8?B?aU1KZUR6Vk1YL1k0NFltSXdsR0l4QXJYNWlvWDVlK2crWkc3ZGp6aUFUM1dX?=
 =?utf-8?B?UEtrVW5aeGNiWXYxdGVFaXVrNS9sMWhzOWE4cGErSkpNRWxnMDRLNnhTMTl6?=
 =?utf-8?B?UjQyYldPOGJnc2xIc0FyRDBYZlczdU5FNGRiOU1pclRjSFMzZis4SSt3UCtN?=
 =?utf-8?B?Q2hXMkc0WkVOSmZSZXMvRnhqTVNneU9oQWk3NU85V2g1dUh1bzIzYVFUTEMx?=
 =?utf-8?B?QXhUMEJib29Xek14N1BoSjFqSVY4R2RBVXRDQ1hISzJxSU1USkVhenBJa0R1?=
 =?utf-8?B?YlBHNFJTUDRWdEcvYkRsMnNsY29oelcrMm5tU2tLUFE2ZnRyOHVLaDQvRVkw?=
 =?utf-8?B?aWZFR0RQUHY0bk4wR2ZTVzRBU3RlbmYxaHRTV003Z2NIY3pXcmwyTnErb1VX?=
 =?utf-8?B?K2RvM0RLUjFNcnQzWnBVblRFc0lpaUIzTHFMU01sMGtkZDh2UzhWOHRvd01u?=
 =?utf-8?B?bUJJZE95WWpEbVhDanpLekIwV2JHVUZnRk1UOStWSXNycyt0R25MdWpFMUNQ?=
 =?utf-8?B?eGRqb3NmUWJmUmxqZWMxbXUyU2s4QWI5RDRKWWhvYzV6U2s0NS8zWHpLM1Zp?=
 =?utf-8?B?Mmoyb3hVRmtscWhsZ0ZDVU9mK2FFWGNjTldhUkNMZEVKaU1KQWdtUWZYRytw?=
 =?utf-8?B?Z0lNWXg3Lzg1K09wRnhnOVpaYnNVUWZnN1VBa0QvdzJ0ek91SngwbE9nSi92?=
 =?utf-8?B?bnJoaE1ObzVMaVFsMm8xanVHZ3E2S3d4R2ZJcWtGRGNVM1pHOHl4bVJ5VURn?=
 =?utf-8?B?d2liNnBjY20vZE5CanlCN3ZtaThMaWZmYkRWMFRrY2hMZ1MzTjZTUlVaVXVN?=
 =?utf-8?B?RkFTWC9HNEV0TC92RmdDNjgxdWMvSURYRzdORkoxM0h6dnJzY0Z1R2hxMHFq?=
 =?utf-8?B?VXJSaDhKdnptNmlXSXJpQlovVC9pcVNsbUZQczU2S04vUUkwODNGOXZLRmMy?=
 =?utf-8?B?RjVac2lTTWZnYmhyRUw4Q0xEbVhKVDZwMTlPS09NM3VKR1lJam8venJONGUx?=
 =?utf-8?B?WnVsU3BVdExVMFB6SEt2Y1I5OThtTUgxbU43dnd2VWZ5TzZFZnlTbjliaWNr?=
 =?utf-8?B?SkdGbWJMcFdhQVhJN0xodzF6dEJ0Smg0M2NKUWRBd1BaTVZNbjJVd2o4R0NQ?=
 =?utf-8?B?VFo2MVB6alFzM0VHV3p4TWkxWlhONFJxazJWL0lLejFRTFVtWjlMMDF3NW5p?=
 =?utf-8?B?dUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: xlgzHXVL/YrO+sfI/W9MF+vp5Y7fv56NTTiFk+cQgnMGlJu3gyOW3DEahbpOJ7uonFWG+mlWn6UlTq+7HkAK0U1Crh/tRaVM4ExfYS6mftB3EOTwaeMHm2PrRZKcAW3TLMNqvBRhO2sWmS/X9MomIAB+vWKXGMbNPtqrcHlVGe9GD1JGwokRwB7/M/pV877cMG0+8nr0TlZ5cYZpxKKx3mTxMZev+TC+ltAMXRdojoGztHepCgyyBKT5NGQh+WgnACj0JtaXEG4FSCszAn41FAXjZVLgfjoTZPfE13PvRKIeHB/8jXh9jsRjl8Kg3OvVaaR4E0bijPY7It5LzaNkXI42kOH7IY1l8aTAvRrohyYHntpPi1lgiHCWXLN5iy7M7MzZf9gQFZ8UEwkZ7y+Q5R3+53ZyWESHkj60i3KUVAYSEl2DXsmA/rgcEk2/Y4y0UOuCoIMBd02bsSH+8xgVYCfauYEUhEu+U9jfb9EHzgQdgZnvT9DnUfteyjlwyaUw5pWwMv8MSt8xhEfJGsf/WhUM3Lj8Mr+pKOaEypklTPoOujeTBSRNsZvXzQNVgQGdhDirwtlu1PqSCsyVIqsVuH+A0ZaRqgxR2BoLqxJ7OPISg/YBGxd6GfU8+NZbO8rj5JScqrb8B6HtwO2fH3tCXilSq7wDZDFXTuHwm5l/bRbi6HEvkc0ZaqPmr/rbFB3xPBSmhhYMFbgrUCD3xb7D7Fk0CqlU08hU/OuBdcnhR5j//BYEJW5tISRrGs+USl2sSl0kuG4rkw2x3CekrMF3HtIv0uNcAwpua1IkH+4xpZ26kMHQtKV+rycN/gXAUyAd9Y0HvuL4jv/3s4MB78lWQzTbuoFDBXxmdGrqD1+U/ei+2egGLTWxeL0wmaRjxCC4r493GtFtzlAAcLt4pOiZiJdqcrHITJhNd+leCZiNQkw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a299967c-e0b4-49e0-e19c-08dba2eed2e7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2023 09:04:42.9701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QCbd6TflVzIUZ/ruJlcNsA+fu9oMRlpD+Zm51ZrJG6uRTAvwMcRlWMr/mgS1/517LzJxkx9Tupw+IB8kI6oPZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5017
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-22_08,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308220069
X-Proofpoint-GUID: BGF401_VD9UujW_Wk0iDAuGhcRtesCtO
X-Proofpoint-ORIG-GUID: BGF401_VD9UujW_Wk0iDAuGhcRtesCtO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 21/08/2023 21:41, Bart Van Assche wrote:
> Provide information in debugfs about SCSI error handling to make it
> easier to debug the SCSI error handler. Additionally, report the maximum
> number of retries in debugfs (.allowed).
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_debugfs.c | 25 ++++++++++++++++++++++---
>   1 file changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debugfs.c b/drivers/scsi/scsi_debugfs.c
> index 217b70c678c3..a9bc5f7ce745 100644
> --- a/drivers/scsi/scsi_debugfs.c
> +++ b/drivers/scsi/scsi_debugfs.c
> @@ -3,6 +3,7 @@
>   #include <linux/seq_file.h>
>   #include <scsi/scsi_cmnd.h>
>   #include <scsi/scsi_dbg.h>
> +#include <scsi/scsi_host.h>
>   #include "scsi_debugfs.h"
>   
>   #define SCSI_CMD_FLAG_NAME(name)[const_ilog2(SCMD_##name)] = #name
> @@ -33,14 +34,32 @@ static int scsi_flags_show(struct seq_file *m, const unsigned long flags,
>   
>   void scsi_show_rq(struct seq_file *m, struct request *rq)
>   {
> -	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
> +	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq), *cmd2;
> +	struct Scsi_Host *shost = cmd->device->host;
>   	int alloc_ms = jiffies_to_msecs(jiffies - cmd->jiffies_at_alloc);
>   	int timeout_ms = jiffies_to_msecs(rq->timeout);
> +	const char *list_info = NULL;
>   	char buf[80] = "(?)";
>   
> +	spin_lock_irq(shost->host_lock);
> +	list_for_each_entry(cmd2, &shost->eh_abort_list, eh_entry) {
> +		if (cmd == cmd2) {
> +			list_info = "on eh_abort_list";
> +			break;
> +		}
> +	}
> +	list_for_each_entry(cmd2, &shost->eh_cmd_q, eh_entry) {

If it's on the first list, then there is not much point in checking this 
list. It might be even worth checking list_empty(&cmd->eh_entry) 
initially also to save the bother.

Having said all this, adding those checks will add lots of unpleasant 
indentation...

> +		if (cmd == cmd2) {
> +			list_info = "on eh_cmd_q";
> +			break;
> +		}
> +	}
> +	spin_unlock_irq(shost->host_lock);
> +
>   	__scsi_format_command(buf, sizeof(buf), cmd->cmnd, cmd->cmd_len);
> -	seq_printf(m, ", .cmd=%s, .retries=%d, .result = %#x, .flags=", buf,
> -		   cmd->retries, cmd->result);
> +	seq_printf(m, ", .cmd=%s, .retries=%d, .allowed=%d, .result = %#x, %s%s.flags=",
> +		   buf, cmd->retries, cmd->allowed, cmd->result,
> +		   list_info ? : "", list_info ? ", " : "");
>   	scsi_flags_show(m, cmd->flags, scsi_cmd_flags,
>   			ARRAY_SIZE(scsi_cmd_flags));
>   	seq_printf(m, ", .timeout=%d.%03d, allocated %d.%03d s ago",

