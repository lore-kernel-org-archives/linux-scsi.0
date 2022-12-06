Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8914C47090
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Dec 2022 17:08:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234736AbiLFRIK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Dec 2022 12:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235227AbiLFRHq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2022 12:07:46 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE8DF0A
        for <linux-scsi@vger.kernel.org>; Tue,  6 Dec 2022 09:07:43 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6GxSOF016931;
        Tue, 6 Dec 2022 17:07:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=vroqj8YR9mImwHgtRAfH6CC6+fnIhQoCskoyHdMDIKs=;
 b=FV2cLj8RDdAy6Xa1rvxIHdKmR9ujQrNrgu6pRSp/7XCglWHGZZ7BBJasFIPbeu8F1Pj5
 rq6BzFdyUdX2zrGq8b3oZiA3J2yx1oDwlRAPXTH0Qxiswlj0o3kNtUaHz9WrOvFcNqcG
 J4/NfAASu2b7G02m2lfGkS7inc4RYw4YFE2ocFU0DIczfOlCcqcs8GIoZt7kGF2Mf4FQ
 /Q2Subk9M/BA0Xfo3k/DiJIcqTpCO+FcUggIs6/XtuQpeqmcUX6cR/vQqikMxP+z7Wkx
 jjSCZYrVzV51K7pMtzw5sQQoLFkVMR4snUrTgzqDo2ow4nOgSHQnUvV3U8mQ2J3a5fVZ JA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7ya488mr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 17:07:37 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B6H1WjV013740;
        Tue, 6 Dec 2022 17:07:35 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2175.outbound.protection.outlook.com [104.47.73.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m8ucfejtt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 17:07:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WHWIVk8a1T9IZ7ZJFOLKilpIRnppjmI2tX8Ke9Mgp3mcktxeoqijINj9Fx3Pha4ZIx4aLCO8a6mDhwHeiWzUotFRsixRLsN4k7qtx4ZrqJw2hWZqFRZmfYV5cxMDz+kFMkdMYfyKryglnAaL3xMRbgViQjY2RturNF0stmRg++OmpWSo8jivJzkLcd6LrkA36rHqGmYcHvAMebBXCDzJKxWehtdAhdIsOX5B1mM/8cYMXMox3j3LfDyT/TPoqQcYruzcs/rf6GnSRg8oG39l7aXs8mkiTnbMdp1usdpmGh8n2dvRDXhGewtmMpb90EWk6SPuP7b+dRyJW0eSj5eulA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vroqj8YR9mImwHgtRAfH6CC6+fnIhQoCskoyHdMDIKs=;
 b=l0lIzVsdff5NgmJghtnDivlTiA88D7GGFVIKLHlirSa8d3VkBaarE7jLuYmrHTwQO5QtjZcIuoLtbRzPN/wyuug8CGskE2Ym2zyWKiD10Tr0clCdpKw27bUcusT40Sr04rSVLLLEYw6rrlrlERTBriBI8SKBy0TrpLh6TemUhm/Ys17V9/tiwKjjpVOs26qHzJYn6YR4nT3CfHoWB3FKhuBP+o9/nj9Dm4lv69Kx6SWUQ+qWtc0kK6Qe3fZNuQt6MCDk1YXx1zcy/vbEh038V+Q7Eo+gRDFV/70zRp62OaTfNqeiH6+gES4Yfx7VeVON79OZ35TE0/gCFumCVYZ9qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vroqj8YR9mImwHgtRAfH6CC6+fnIhQoCskoyHdMDIKs=;
 b=QjM3RoMFUg7H0eHadGdC2ljdm//Bibosj6NNA99ZcPqowvBT3WyFRpzBaxI5ldyjxGd87VMMo6B5gFD/hCuOSHvoI1gQ97LD9cEPnx0kqMoBgshFdOq8kMv7z/0aSBlV/3xPbKZ+yr4s7DEh3rkRYLKsQtW5a9kqpXY1Znd1dtk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA1PR10MB6390.namprd10.prod.outlook.com (2603:10b6:806:256::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 17:07:33 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%8]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 17:07:33 +0000
Message-ID: <c9b257e0-7e5a-b1d0-5d17-b9526c6bddeb@oracle.com>
Date:   Tue, 6 Dec 2022 17:07:28 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2] scsi_error: do not queue pointless abort workqueue
 functions
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org
References: <20221206131346.2045375-1-niklas.cassel@wdc.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221206131346.2045375-1-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0228.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::16) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA1PR10MB6390:EE_
X-MS-Office365-Filtering-Correlation-Id: c81a3bb8-17d2-4c64-6bdf-08dad7ac5d8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ECJGPIE/tLG2mVKbMkCKpnWgkpIRamUJYV5n/W9cqpSYBMh3YdYPs7tWUEkevqNi/W+I26SLqyzmpiDJ4XKdmbRLWRjAPPpVxn2WVEr3eDzrJCB9eZCAqIhuTZe8QOHhemF0JsXInhKK5vCk+z81FJOFzuMKV02xk5qwPh0a9VpKPsS60z6//8grkABztJupFjMP7lZKuKKHD8jaFTMfboysRSPLAt9I3gvZK9O+dnO5W58tjM/uOW3P+EE8cOKNlP1ZJX7F4++E80PY1s/EdJcmsZr+eChP7gmgPAebX24LHDTSiJreM4AVuWEBItJjazVVDXn0GhDbft3odaBz/yUEkxgICidvA2IVJ/y012yqa0VAVNzPO2WjfC8nMWiMBgcmbu81U0ukgYuuY+xnhrWCVx87O7zDnQqoIfNEUHAFIRzkL4Ke25VUGgF27+Ky+QES8cjZ0T5BaJ3X6usPux4S0eIb2pMYj53eefdw5deOOW6YTlkuaa32q4BlfCv5Sxl/mgOLb9vUQmIKi0XSLMMoCRXpGKzrO/CKb9OCnkdeQ5BDPky1YAHGpSUtgJSUgwitI2pUtUJE1Tx3oGrDTrELfi9+C0RuvuWMSbHU1D4ut0Z+L6YdUl01DZodYhjrnUK5kuUoxnqNb1by0Fw7mT1+IftEzD9yrENcmPldjJLuODUZE/xSjxmjmiMufFkxxNVwBbsZo5Tk7D7DD+34hIfKESz77H7o5ERcgqVymMk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(346002)(136003)(396003)(366004)(451199015)(26005)(6666004)(6506007)(53546011)(6512007)(110136005)(54906003)(478600001)(36916002)(6636002)(36756003)(6486002)(38100700002)(31696002)(86362001)(2616005)(186003)(31686004)(2906002)(5660300002)(66476007)(4326008)(8676002)(66556008)(66946007)(8936002)(41300700001)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V0lxM3VhemRSbGpSM2V0bzZybGVpa1FyVGhRUFVoWC9MOStQQ3hPVlJzaHFj?=
 =?utf-8?B?Wk9xZjZKek9VcFo4MS94ZTNHQzZhY2FVTmFhVFM0Q2JscUdEdnRyUnVLV2ln?=
 =?utf-8?B?bFNsakNnOTdHRnJ1akhJZnMybHI1SUZRbjA5eFN2TFlDRWVXcjZhSVhDd0M1?=
 =?utf-8?B?U0ZiTnQ0OW9ZV2lKMHFrWGtwSENMMS9UV1hodGpFcE43VW5hQnJXanBRVW13?=
 =?utf-8?B?bkNKRXo5NEhSbFdvQjNobmtwcGNkTTVlajAzajlnSEhvUWZmR1RQZ0JxRGFU?=
 =?utf-8?B?bGRWZ3QxTTM3RkFIWmVxWnZaS2FrZUt3RVEzZWF0eC9ZVlRhZVVZcjBLYXVm?=
 =?utf-8?B?dnRWVXFLQlUrU0lVZTRubnBTdVQwOHVhMXROQmd1N04wRjRTOWFoZC9pUm5L?=
 =?utf-8?B?RThlNEs2M2dpTzJ6bnk2YmpISDNLdDZUM3RuWGVUUE1xQ0JoUi8zUUxJTW53?=
 =?utf-8?B?RC8vK0NVVTdJRnBiSXlMUEx5UjRzclBhUkN4ZlA5ODRKbjhkOFppWEk2Ry9Y?=
 =?utf-8?B?YjR2OStubHdSMnB5enV1UjA5UGZYTGVRem1kSyttSEczVXFzMnhEelNybWM4?=
 =?utf-8?B?ODkrNEVBajYxd05DTmlpcE9DQzczbCtSYngwTVdtT2pYVkV2bm9Xa25ITVFX?=
 =?utf-8?B?YVNWQjdIMWhROE9DVldacXFXMnFndXlGbGFhYi9QQVZJRldVRlNMRmtZb29l?=
 =?utf-8?B?RUh6UDVlWVJ4MjZoblREOTl4WWlJcjFhUEhZbXUyMnA5UVZCWXNkOW1NSWsr?=
 =?utf-8?B?eFNTMXBEMklpdm9oS01pZVF1UDBidkRCVU9GeG1rTUw5TkpVRHU5QTlDbDRw?=
 =?utf-8?B?K3Q1a3V3N3FPcEVzL1RvU3QwRmxrcjFHMlVlWTczQTRmaGRvRGtwMmZJWkhn?=
 =?utf-8?B?ZlJLUXl6OXZUT0tBdStKQ3pnZm94Z2FONUx2QVJ1QnBQZm15WjEyVjRybDYr?=
 =?utf-8?B?SmRmRlpGR3Y0NGFzYTAwNzhlSnRnQmo3a0g5RWtobVIvTk83UVV1cVA4OUY1?=
 =?utf-8?B?L0pwSm1RcFFJcmNLTUppTlZCcHpaV05qYzNPVml2eEZMQXdtRm93ZlZLZi9q?=
 =?utf-8?B?R1hWaU1DbHNlRzhac2ROWXMvRXFpMkp1UDB2TE5Fcm1ndGpoWWxUbDE5R0Mw?=
 =?utf-8?B?dFZ3OW1TejVGMTJjOURaTm1kTjQ1aUVnQituR2lnQ3VJRzE4TU9XWjBoRlB1?=
 =?utf-8?B?d3Btd0pla1NscDYxREJFMWRZTGZtRzV2WEtEdkw2WWQ4Rmd0QmZheW0yNXlp?=
 =?utf-8?B?NU1MeS9TSXNtYkJzcHhEVlFxa1NYeW02SXNQMm1KSDBKbGlNNDZmTlFoY2s5?=
 =?utf-8?B?b1lIeTF4WTJYdTd3NzFOK1pvMElaenlLY1g0dGdRN2YwVDBzZ3M1SGdyaTBJ?=
 =?utf-8?B?TUh1bWJ0aHNMTysrZGhhTWZ6alRYL2o1ei9kWDQ3NFZCYThiUC9MVlBYamZN?=
 =?utf-8?B?VnhlRjRVT1liVUNIdnJNdGdzUU9LN0djbFZkRkJpQWF1YW16Mktwc1o4T08z?=
 =?utf-8?B?YjU4Q2hSeUlYWmYyZzVrVmUvakp4SVBJVXpnUE55ZlhVUXRZaldLSkhqN0JM?=
 =?utf-8?B?QmRsUHBTVm1Md3FiZnprcVhnT3lWdmZBbEd3MCtYbnlGeWtDZGdUS2FBVmdI?=
 =?utf-8?B?c2trZVIyaW4ydDFkVTJCWi9kY1FQLzJJVVdST1FxdnFkTnczUUVsdzd6S3py?=
 =?utf-8?B?Ymtad3RxL2s1NXNPLzR5OHNlWVRpMXNhNE5EaGdOYWhGbGlLYzQrdHM4MFcz?=
 =?utf-8?B?TWhZRVQwaGJTRjBtemthNVBNVlVTTjBvUnBVUDMrOC9mVWUvQ2hqVkwzVzBi?=
 =?utf-8?B?K2R6OFE5ZmRSdlE2MmFydGl4aWFua2ZUczhWZks2N3VGMjdZa2tjWWUreGt3?=
 =?utf-8?B?NEhiYW10amVmbG1acjRaNWtWSlpBMEpZck1jL1dadW1vU2xZMTdkL3ZCS3hD?=
 =?utf-8?B?a1JRSzN3VHIwa0V5V1JWQytHVmkrZVlJMy9la2d2S25ocVF2OC82Q2Fiems0?=
 =?utf-8?B?azhENitTVi93aXlYK25xeVV6VHdhanhOMjcxejRvV2lkMmhwbElCTzhLSFZx?=
 =?utf-8?B?VWJWbkdFUUVpNE1waEFYZGFjUlhHQ3AzWVR3Qm1FNVB4RWhnU0F3K09xVE9v?=
 =?utf-8?Q?jJ/d4ukpbGGmplqA8VEjExpH+?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: waSU1DK6e7wRILGl8M2v+WbApmco9lTZqHugjkzouyWRAcdHMXtH06WAp5uG0F2IUI6hKfC5ZnOyNE8+RFsrDjTIqlVHomoioR2BDOOAG1tmISJ13L8h6EoSnTdWoPK9euHu3lHuYIkbR2s1lg6bBZXjoT4Ud5xkxHRTgXbAAkiYcEX6PeXaB+Dv1fJUOlm5EgqF+Gv/VMLKIqHFXqI5PwV0UzLwFKxoZutHbKbtYzeVJ/2IgKFeGbnSpM0fmPvvxd9n+UNLmQIJAjzGlkX9PlnAn2pzTAfIc6KDZ5f6qJty0cvSPjTHKEjEKuQMhXvVK4XeV0JuNn4Lnn45u9MyfGB9blglJTgJIEnCvy9hnIKEShLdjXXf49p4MvLjdRfyvJoKobvuEi/cXfjqSw2hrmWotJE33NndlwMUS2t/zY3o34CTbE2sPztj+BhwLazVyrJf2GiTruBRbMPslN1a8LfzSCo3gZkA5HIG8fEd1q3hoblUa233CsUaaBJJoTTv+Q0GDTjbFyA3NUMWK9Mn2IL2w9kUfwWZiWb4FmK39ae7UnNy4A9H+AZkqbTwkI7N4zlCO5RsINNKnIsbK9eejtwgMK5fQM/BQS0GqlPnEPq72Gx4zvQ3mExEKhjz8eeIOG7VQlofvMyQ0IbT2mUMRbngF2ViSPNRI0Akam1mvFTRICgKt0XNhrLygno/IKNz5+lxPLXExKaNoRIHLWAgZMHuYmRsjTJ+diSM48JTTvSsUcLdJrAMqsOLrt75cd2x5imJmWBFk0csSAXCBvelZZFuHjLO8kMudWC9MCEltWSljl5y+B7G/YWzYRKyDK/JmZ9uyAp4sU9KptWnOKylfVEXedI9V9s2StaqoNUtxzmjG/GmaziwDM9kK22Tlb2qjUQZ8RVvUUN3hN/qf6tlQA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c81a3bb8-17d2-4c64-6bdf-08dad7ac5d8f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 17:07:33.3810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9I4is4CO6Gx/7gRJuSUOr5qyRkXABrWndTMRoqYznB7dmxKkulNPFSIac3oSgx+uHU410VcZiFqP9f273K7Vlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6390
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_11,2022-12-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212060143
X-Proofpoint-GUID: p_B2zgRfojAB2gAIUvaiE_Ws7aT_Ho4B
X-Proofpoint-ORIG-GUID: p_B2zgRfojAB2gAIUvaiE_Ws7aT_Ho4B
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 06/12/2022 13:13, Niklas Cassel wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> If a host template doesn't implement the .eh_abort_handler()
> there is no point in queueing the abort workqueue function;
> all it does is invoking SCSI EH anyway.
> So return 'FAILED' from scsi_abort_command() if the .eh_abort_handler()
> is not implemented and save us from having to wait for the
> abort workqueue function to complete.
> 
> Cc: Niklas Cassel <niklas.cassel@wdc.com>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> [niklas: moved the check to the top of scsi_abort_command()]
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>

FWIW,

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
> Changes since v1:
> -moved the check to the top of scsi_abort_command(), as there is no need to
>   perform the SCSI_EH_ABORT_SCHEDULED check if there is no eh_abort_handler.
> 
> I know that John gave a review comment on V1 that it is possible to not
> allocate the shost->tmf_work_q in case there is no eh_abort_handler,
> however, that is more of a micro optimization. 

I'd say that would be a separate change.

> This patch significantly
> reduces the latency before SCSI EH is invoked for libata.
> 
> It would be nice if we could get this patched merged for 6.2, for which
> the merge window opens soon.
> 
>   drivers/scsi/scsi_error.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index a7960ad2d386..2aa2c2aee6e7 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -231,6 +231,11 @@ scsi_abort_command(struct scsi_cmnd *scmd)
>   	struct Scsi_Host *shost = sdev->host;
>   	unsigned long flags;
>   
> +	if (!shost->hostt->eh_abort_handler) {
> +		/* No abort handler, fail command directly */
> +		return FAILED;
> +	}
> +
>   	if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED) {
>   		/*
>   		 * Retry after abort failed, escalate to next level.

