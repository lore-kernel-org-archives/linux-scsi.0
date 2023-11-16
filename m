Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FBD6C54FB9
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Nov 2023 10:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345072AbjKPKyN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Nov 2023 05:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345088AbjKPKyK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Nov 2023 05:54:10 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EAAA1988
        for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2023 02:53:58 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AGAfX1k019602;
        Thu, 16 Nov 2023 10:53:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=cD4ibjOiiqelX+/VJFf0cjOYW/3JlAOwQI4HiWSdvdY=;
 b=lDePuFE0MvRsxWUQqy1c4QcZQRSvAVpsZJtuQjYDcwLvR3m+xzwu5YkftLP64BQzH23V
 JZS1PZejRukOLJDjP1XMRVwiD0WXBufvHRSmEc+AY7eoFbJUTkcISmmqKPIx1QSN4zsc
 MlCUkusDcur6qNJGPxqEwvupuf0YOEwrBDvT+N3uQTiU78YW94mNkCtI4EJ9UIMbBETK
 jPhGG9OCyXGfDPQzAgRotOJCPYuRIKpMZGKa8t0+V591XMz8KUGuxasDNv3DdDqki1+I
 TP7hUKpX23Hy6f/uC8QcrY+eUntbdnA7xHw8W1TTlTWxMQ6a/pdPEV3qUlf5R33KPVP8 pg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2m2js1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Nov 2023 10:53:47 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AG9baXx035442;
        Thu, 16 Nov 2023 10:53:47 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxq2n287-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Nov 2023 10:53:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mAf19LxwJPscqMXgwQM+cwXmt2umgrwF6hdjpYhr0GbEgjmaqkxv/wJmJiIO9DsrbpLqoUblTwLy+KY6fRsPGWZdoKx8IpqvQDzA+ONRTL10TAzR8q7lfzn3DysuOmLGBUn81neJVEeu9jHrRyvosEE8LQatE6u6esqxHLMxdLPWRVhyCZ73S75kpqbA4ijuRNq4a7W4IrnciMbZdkIaEeJ1QdK6lzH1d11D6/Hv3g5jV3YfMA/oOfPPGYPEAbrEI3u5uNZwQW+Loa3oBJDJmSqMZPuMseEtsa+L3KQ4MlSqERiRdAtVHUlf3FEfhnd4CoWIS4PPgoVjEKKSwcXKeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cD4ibjOiiqelX+/VJFf0cjOYW/3JlAOwQI4HiWSdvdY=;
 b=OsENXBmPepKblxrsEzHZe0IKL3GEH3OBWgjXsXGIguvl1hFhkT90d6PCwJjYIRCey76OhuYUk3oqoFETWdqvf7VKdIzY2AL1A+15JHFDL4G2sO1s7QJ2y3xE3lZ4U6rD7KGzH+xdEf7FUHssaGb9K6xOS0qa+lJU9Fhgm/qspJv5bO98K4hPXwZI9bMXEJm42SO9q7z+ICHdLgj8nP1jkO0HnLN9HExHX1UFWcnLvaW8bUDicqd6uheBYxoOkvldmqdl6mVzU9HmZvICN6OStjPcnNIQSYfEStcyzWT3acARHrPaWSxU1xFxhkTNSeLLYJRwGFCu3JoiO1BxJIki1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cD4ibjOiiqelX+/VJFf0cjOYW/3JlAOwQI4HiWSdvdY=;
 b=F49+7CXAWTl1hlicA5ESPMt2J/zJO0VBhQPdYB3GMD8lmHYdqqsfthjHv07Fe5O8HQneD/3Wn2JG1AdVwuJYHPxwiD+PXrfm0MFLZeaoDTp8OwYIVYtNPDJQHx60dJalIaRtAWkyY1qSZ9d3gAoT1OoQmVgpLeLI1PpZNmlloi0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH2PR10MB4152.namprd10.prod.outlook.com (2603:10b6:610:79::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.18; Thu, 16 Nov
 2023 10:53:44 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::102a:f31:30c6:3187]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::102a:f31:30c6:3187%4]) with mapi id 15.20.7002.021; Thu, 16 Nov 2023
 10:53:44 +0000
Message-ID: <d4df4479-497a-45f5-8a39-3ea1998e767b@oracle.com>
Date:   Thu, 16 Nov 2023 10:53:40 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 01/20] scsi: Allow passthrough to request scsi-ml
 retries
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20231114013750.76609-1-michael.christie@oracle.com>
 <20231114013750.76609-2-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20231114013750.76609-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0204.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::24) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH2PR10MB4152:EE_
X-MS-Office365-Filtering-Correlation-Id: 72e9aa54-3de2-4fe1-05ad-08dbe6924cfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UTkejHu2fscQZ1PzJDdgEOwCwQyGygsxfkM2sF63Ky3WNN+voc2ToAIUCWqW6WjdD6wyDIFgZTOx4eWm2lH6PHN/tuySEty0krYxAOdmda2ZkgE0NmItFInHRUsKHO7P99TGggjNDFf0mAw8wcwe/QyyiVeAY8eMmDcGuGK0jMsAJib/zkFqDt9mC+NQRniR4yQjaiv1EZREr9SnfWXUUj9DcO0KUQxXT9qNp3P/E67PQceJF/K5MT0YqPn4vLz0bEM7WiXUCE0C4G+Zzix6ZY2VGRPSNpWKCXnGjmkn4+/nybzkR0lgp+X3NTb7pc54snE5BGnA5OILyl+Zyk7FsD8JqJvBYJyiXNadi7DpsoFioKHljmBW2N8yKjYs2RYxxjcskkA8KnwwMatI7utE0KvXKOVyRmWeH1sOG942qesu0Iyj3W+lUvc76ynHHDDF5AwtCv418n9ZX2beghMu6SaXYBRUmAeVauLsWNgNq5v4u65Vor+h7EaJna7LWYsSlPhypYeiNTkQ6wey8qw58NeTjEdiK37bNNLkYQSr+jJliasXjpxtOcTiPk3pvrtDND8l5LnEANVJeaxbK5xixGk8thdKrdg90YJIvsceOpJEPynDvjyZDKYk1/Ksoon4EXlByrI5jn2lJnA7XbphCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(376002)(136003)(396003)(346002)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(31696002)(6666004)(86362001)(316002)(8936002)(6506007)(53546011)(36916002)(8676002)(2616005)(66476007)(66556008)(31686004)(26005)(66946007)(6512007)(6486002)(83380400001)(478600001)(5660300002)(2906002)(36756003)(41300700001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dHVpRTRlSHhuVGhyM2h0TFNVOXRoY3p0M3NGLzJ4WDkxSUFXSjYyQkRoV3RK?=
 =?utf-8?B?TDVVamRHNEV6bmhxQ2RDR2ZuTXpIZmJmTU50UWQ1R05TUVdIQWdBOEhZdm82?=
 =?utf-8?B?aTZwdDdTVnk4TVpoMlJuZjdDZEEwOCs4WXA2d1BicC9SenBzV3R3THVHQXY1?=
 =?utf-8?B?VU5aSTZDMmU4QmhqWmFpeEd4M2JZTVB5cEkzWnZoYzlmbTJ1UUc3aldiOWJM?=
 =?utf-8?B?UkV1eVVKbnJQa1FFcWx5YThNa1E3cTFST0x0eEpjaXhMNmxYR2hobzY1bW9q?=
 =?utf-8?B?Tnp0dyt1WDlRcnRSVEgyK1pFRTVaTE81N3ptZ0h5clM1ejA0eG9Wd0ZLOGh0?=
 =?utf-8?B?YzlKUlRQMGl0MFJSR09OMmNnay9la3U0bGIyQTJRdjMvd1JxUGtnMnVhVTlV?=
 =?utf-8?B?MmFEYlFuOTVKdVZDeVJ1OWhDMGFiZTFSSy9ZazZIVkhNVDFKT2FFcTF6aVEy?=
 =?utf-8?B?Tmh2WHVOTG1vY3A1TkdodC9HTkpkeWorTFUreXVwT2R5dG81bWJQdDU3c2dl?=
 =?utf-8?B?WTl6QisrOUhnWXNTZnR0YjRNSVFmcS9yblYrREs0d004aU5jdTN1NEZKMkla?=
 =?utf-8?B?cTRTT3NRYlBDVFluamFhSEhCM0pOWjhxWEJqV3E1bkFlcXFiTlQ3MU5CamF2?=
 =?utf-8?B?djNJV1NURG5JZmpuaTF0MWZLRUlvTlU1TlgyZTFac1VVYytUVnU0ZGFwOTRT?=
 =?utf-8?B?d3FjbksvTGxiUWJyTlRkOGRITnZrczBrZEhVeWE1RGRCczUyMU1UNWVWdWR1?=
 =?utf-8?B?S2J4c1Y4MWdBNUs3Vm5hTEx0UzJmKzNBN3VhQnM3M0NVUlo2eVkxMnZRNzd1?=
 =?utf-8?B?S0taUFYyWllscEtvUzdoNTBobS9FVWE4NDRsVUIzTEVERHY1Y2dURjFRQlhm?=
 =?utf-8?B?MW9LVjZnRGIxYjBPS2NhSWpiQlYydjFCUk1sWUdmODBWbW9mRUhsRFFIQlVh?=
 =?utf-8?B?OGlhenFsZVpVbFoycVlUUHRZQVJWTXlxWHo1YWZkbVBkMFRSVzNBclN1dHQ0?=
 =?utf-8?B?cEZzemN5MFY0aUd2LzFMNlBSQzh0bStEd3ZnUnNidy9MZmJJK1ZrTnM5RDAw?=
 =?utf-8?B?aEFFTmRJVGlPMDlma2JLYklNSzBPam0vNFVkNFU4NndUV1Y0Rnh4cTBhWlc4?=
 =?utf-8?B?ODR0aUFIUzZRL0JpMWlxbTUwTkhXak1YRFA3Z2M1YkhPRHFBc2hxWjZlQUhY?=
 =?utf-8?B?aitOVU1KUGFEVXlyeDc4WnAwS1FlNm4xOXVuejdzeTdTelVFM1lFaWc4Vjg3?=
 =?utf-8?B?a3NCMTVldEZSSFRsazlMdm5VbFFaUU5DbWs4aFJxQ3NLSE9vQzNEMVI5Y3E0?=
 =?utf-8?B?bHVtdDRsTXlqWEtWVVNzQnR4Q2ozNlFpSzJyNXdvY1lZRWlsczZkMHQ3dWVz?=
 =?utf-8?B?U25kNDcycDJYdUVQUytEemFCaEtOVGsvVGxsbGQwb3d1QVQ4YzdoM0ZUb2s2?=
 =?utf-8?B?aGJHOGppSmp0ZGpHRzJxOUdjUFBWekF6clRNeDJnTnB6REd6M0lzYjlrYy9X?=
 =?utf-8?B?Q3JhdW5MZlBWMnlIMWNTRzREc3I3UG5naGk0SlZ3WHFObGtFcGZrZEU2b3JL?=
 =?utf-8?B?OWZxL3ZSdUI4ZXMxOFA3a3hHcmJRRjdnZG5samp4cUV6QTQzK0t6WXhHbjFn?=
 =?utf-8?B?eHhldU9PS2FlRlNNbkYwVCsyVCtSN2ZDeHlGZXBXV1dRdnNHNlg3cXNKVjR2?=
 =?utf-8?B?TXl1Y1B6VXlIMnRxR2R4emRidTdtYmhqOVZ1V0xqK0F5T0Q3WkxERzY4VDBu?=
 =?utf-8?B?QWd4SWdSTzRzcTJKTENyMk12NXdqUjBBNXlrY0lJY0lHbGZ6TXdUanN0TUtF?=
 =?utf-8?B?bThKV1hzbHp1N0FiTWdQYnJFL3lEZmNldUsraXhYbklXNDlIWnlxT2UvOHhH?=
 =?utf-8?B?N1hBRWpBTWNlQlM1UGRLdmZ3cTAyUGtmUXdGNXY5V0ZIakQva1h2eWg4THNX?=
 =?utf-8?B?eEs0TFpGSjFqa0Y3NHNTcElwTzlVWWl2b2VnQXppN2wvVmZCLzRuVC84ckhl?=
 =?utf-8?B?aW5vUGsxV3BBTG5PajRPWEdkQmJUUXdaRlNqSjQ4Z3pzNGM1Q3lXRmw0MXZa?=
 =?utf-8?B?ank1a1FPZGlrUzRMYWxEVDRhOGpUdDkxdDBaeEZBNTMreVJYazhBd2MyNEtw?=
 =?utf-8?Q?NzAauOdpVGKoUl+wzkRb6f9Kv?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: VkSDeRZMrx3JPcW55dvqoHWr+k87Sdc0k6HwEKg36TJrIGcPxf4V9G/1xhS77lo7S8eT22kGjEZjEr5GSN4eEuCjTPObzJY1UsqG1B31l5zmzG/oZPX/mcQx3BYlw+vJNVEteV6NmZ7sripXM1BqxPSVGnMOeSaM6MBG76FC7US7RaoK7Yfe2mMS2V9/bPAd97qy4/UGdaN8nJw9rC1qGQ0X/kV5xz+t2mhq6Rge+E5TQGg4kMV9TbCrGOORpykwAMgJpwMk8Bqc0vRbp4gndO8WNTqtWmfbzJBmlv4e6UETFsVRjhDtSjdexTc+HN+AFrnzH4B+UX1PWm1S1naSWspIoSQRx+iWNNx3ONzK+/TNYAy5oKgHuUaOykAilKXaohA/HpBHKVlggSp73JCd/2ps2eNbvN/comvoZfaLKYKQwYjJ7UdROm3YAoQ9gAx8bxhdRYeL7Pha/bH21FgO7EotcPrUPEa3eHdvEjF2MKfL2Gy3nT2xJlwUl0KuB7HhvMKjuv5jLpkECiGztmdjEY6OHBh0AycGM9LZpaMcMwjWuXgjb3R9j8o1oUevam87HQfPG1sGxKMviq9bHO846qD30MozH4Dogc3Z9oUxt52OUb9Z8goft1vEZEd97rnwM3UQlF7IzhncisGKViw8cj6KzBTI8uPLPcbEd4YL2ALKf6ZQ4mqZuKUL1vx3W+X4WSku5eB25J2heEfreEOjQx9oD9pLhZsoU33WSZT8i69ApCLD60ssv+WmtsPN9YDbJkGEF//EYC93P67z9aJHb/2KeP+7oGDDMZtEUo8c4JnhxQ7ART0HGToKJKmpmv0eg7tz6wnr4LLwEFKXbsP4M7KHPWoZq/9vYUchpZ6orZGdG3enV0lcMdRBo0sL65K1j9J0w43L4ZNcP6GgzbjSBA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72e9aa54-3de2-4fe1-05ad-08dbe6924cfe
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2023 10:53:43.6361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fD0KBoGt/S4xrkthFsgQsJgQdnSwmFROLy31PEsEhKWjus/9e+rn/aoYL/8MSe1GMwwiWyaUW76yz0CzrnlaLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4152
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_09,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311160087
X-Proofpoint-GUID: 3OmNEy6GtLYlfxrIqlPQ__W0kfn6dgry
X-Proofpoint-ORIG-GUID: 3OmNEy6GtLYlfxrIqlPQ__W0kfn6dgry
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/11/2023 01:37, Mike Christie wrote:
> For passthrough we don't retry any error we get a check condition for.

nit: For passthrough we don't retry any error which we get a check 
condition for.

> This results in a lot of callers driving their own retries for all UAs,
> specific UAs, NOT_READY, specific sense values or any type of failure.
> 
> This adds the core code to allow passthrough users to specify what errors
> they want scsi-ml to retry for them. We can then convert users to drop
> a lot of their sense parsing and retry handling.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>

Looks ok to me, so feel free to pick up:
Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/scsi/scsi_lib.c    | 92 ++++++++++++++++++++++++++++++++++++++
>   include/scsi/scsi_device.h | 48 ++++++++++++++++++++
>   2 files changed, 140 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index cf3864f72093..dee43c6f7ad0 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -184,6 +184,92 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
>   	__scsi_queue_insert(cmd, reason, true);
>   }
>   
> +void scsi_reset_failures(struct scsi_failures *failures)

nit: maybe scsi_reset_failures_retries as the name, to be more specific

> +{
> +	struct scsi_failure *failure;
> +
> +	failures->total_retries = 0;
> +
> +	for (failure = failures->failure_definitions; failure->result;
> +	     failure++)
> +		failure->retries = 0;
> +}
> +EXPORT_SYMBOL_GPL(scsi_reset_failures);
> +
> +/**
> + * scsi_check_passthrough - Determine if passthrough scsi_cmnd needs a retry.
> + * @scmd: scsi_cmnd to check.
> + * @failures: scsi_failures struct that lists failures to check for.
> + *
> + * Returns -EAGAIN if the caller should retry else 0.
> + */
> +static int scsi_check_passthrough(struct scsi_cmnd *scmd,
> +				  struct scsi_failures *failures)
> +{
> +	struct scsi_failure *failure;
> +	struct scsi_sense_hdr sshdr;
> +	enum sam_status status;
> +
> +	if (!failures)
> +		return 0;
> +
> +	for (failure = failures->failure_definitions; failure->result;
> +	     failure++) {
> +		if (failure->result == SCMD_FAILURE_RESULT_ANY)
> +			goto maybe_retry;
> +
> +		if (host_byte(scmd->result) &&
> +		    host_byte(scmd->result) == host_byte(failure->result))
> +			goto maybe_retry;
> +
> +		status = status_byte(scmd->result);
> +		if (!status)
> +			continue;
> +
> +		if (failure->result == SCMD_FAILURE_STAT_ANY &&
> +		    !scsi_status_is_good(scmd->result))
> +			goto maybe_retry;
> +
> +		if (status != status_byte(failure->result))
> +			continue;
> +
> +		if (status_byte(failure->result) != SAM_STAT_CHECK_CONDITION ||
> +		    failure->sense == SCMD_FAILURE_SENSE_ANY)
> +			goto maybe_retry;
> +
> +		if (!scsi_command_normalize_sense(scmd, &sshdr))
> +			return 0;
> +
> +		if (failure->sense != sshdr.sense_key)
> +			continue;
> +
> +		if (failure->asc == SCMD_FAILURE_ASC_ANY)
> +			goto maybe_retry;
> +
> +		if (failure->asc != sshdr.asc)
> +			continue;
> +
> +		if (failure->ascq == SCMD_FAILURE_ASCQ_ANY ||
> +		    failure->ascq == sshdr.ascq)
> +			goto maybe_retry;
> +	}
> +
> +	return 0;
> +
> +maybe_retry:
> +	if (failure->allowed) {
> +		if (failure->allowed == SCMD_FAILURE_NO_LIMIT ||
> +		    ++failure->retries <= failure->allowed)
> +			return -EAGAIN;
> +	} else {
> +		if (failures->total_allowed == SCMD_FAILURE_NO_LIMIT ||
> +		    ++failures->total_retries <= failures->total_allowed)
> +			return -EAGAIN;
> +	}
> +
> +	return 0;
> +}
> +
>   /**
>    * scsi_execute_cmd - insert request and wait for the result
>    * @sdev:	scsi_device
> @@ -214,6 +300,7 @@ int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
>   			      args->sense_len != SCSI_SENSE_BUFFERSIZE))
>   		return -EINVAL;
>   
> +retry:
>   	req = scsi_alloc_request(sdev->request_queue, opf, args->req_flags);
>   	if (IS_ERR(req))
>   		return PTR_ERR(req);
> @@ -237,6 +324,11 @@ int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
>   	 */
>   	blk_execute_rq(req, true);
>   
> +	if (scsi_check_passthrough(scmd, args->failures) == -EAGAIN) {
> +		blk_mq_free_request(req);
> +		goto retry;
> +	}
> +
>   	/*
>   	 * Some devices (USB mass-storage in particular) may transfer
>   	 * garbage data together with a residue indicating that the data
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 10480eb582b2..c92d6d9e644e 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -483,6 +483,52 @@ extern int scsi_is_sdev_device(const struct device *);
>   extern int scsi_is_target_device(const struct device *);
>   extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
>   
> +/*
> + * scsi_execute_cmd users can set scsi_failure.result to have
> + * scsi_check_passthrough fail/retry a command. scsi_failure.result can be a
> + * specific host byte or message code, or SCMD_FAILURE_RESULT_ANY can be used
> + * to match any host or message code.
> + */
> +#define SCMD_FAILURE_RESULT_ANY	0x7fffffff
> +/*
> + * Set scsi_failure.result to SCMD_FAILURE_STAT_ANY to fail/retry any failure
> + * scsi_status_is_good returns false for.
> + */
> +#define SCMD_FAILURE_STAT_ANY	0xff
> +/*
> + * The following can be set to the scsi_failure sense, asc and ascq fields to
> + * match on any sense, ASC, or ASCQ value.
> + */
> +#define SCMD_FAILURE_SENSE_ANY	0xff
> +#define SCMD_FAILURE_ASC_ANY	0xff
> +#define SCMD_FAILURE_ASCQ_ANY	0xff
> +/* Always retry a matching failure. */
> +#define SCMD_FAILURE_NO_LIMIT	-1
> +
> +struct scsi_failure {
> +	int result;
> +	u8 sense;
> +	u8 asc;
> +	u8 ascq;
> +
> +	/*
> +	 * Number of attempts allowed for this failure. It does not count
> +	 * for the total_allowed.
> +	 */
> +	s8 allowed;
> +	s8 retries;
> +};
> +
> +struct scsi_failures {
> +	/*
> +	 * If the failure does not have a specific limit in the scsi_failure
> +	 * then this limit is followed.
> +	 */
> +	int total_allowed;
> +	int total_retries;
> +	struct scsi_failure *failure_definitions;
> +};
> +
>   /* Optional arguments to scsi_execute_cmd */
>   struct scsi_exec_args {
>   	unsigned char *sense;		/* sense buffer */
> @@ -491,12 +537,14 @@ struct scsi_exec_args {
>   	blk_mq_req_flags_t req_flags;	/* BLK_MQ_REQ flags */
>   	int scmd_flags;			/* SCMD flags */
>   	int *resid;			/* residual length */
> +	struct scsi_failures *failures;	/* failures to retry */
>   };
>   
>   int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
>   		     blk_opf_t opf, void *buffer, unsigned int bufflen,
>   		     int timeout, int retries,
>   		     const struct scsi_exec_args *args);
> +void scsi_reset_failures(struct scsi_failures *failures);
>   
>   extern void sdev_disable_disk_events(struct scsi_device *sdev);
>   extern void sdev_enable_disk_events(struct scsi_device *sdev);

