Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D0CC47089
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Dec 2022 08:46:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbiLEIqY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Dec 2022 03:46:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbiLEIpt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2022 03:45:49 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B624163C6
        for <linux-scsi@vger.kernel.org>; Mon,  5 Dec 2022 00:45:47 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B57QgVD002274;
        Mon, 5 Dec 2022 08:45:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=8eZOK2U0futIF8E8+vfi30OWXA523Iib/pAjmMl02Z0=;
 b=SiNK/HfJ9mwmJ813bVlGQVfmr/18+//aYPU5BpcUWoS/XNClonz0LAZ8gr2BBhLI4SXV
 oHeVmN10LAhL42fhn8Ky8tp6TRn4lkLki1aEpbF6S3tnFArZ6joj4fyGI+NNK5IdSeFG
 YzmBCjFgl+xPSEzmRyiAst21Ue8elTm4AT1ezScT9h5/csMSdxjZs4A2KxUZPLOyZrgS
 hdlo0lS3qsh5UzmAbXHKOXKxAiMM3ynb587AbMumaDVhCY6URNRFLRLq6AJdz43houCX
 1OyNbIlpBICivoI0B4O4IosXFZtTC7VBvB/pxeufwUGducJjxFwAQpbF3nDX5pYR/Rll yQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7yeqjwh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Dec 2022 08:45:28 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B56XJ0P005189;
        Mon, 5 Dec 2022 08:45:28 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m8ucd2qv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Dec 2022 08:45:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hfhzYYitFosfTMM3GIOahf9HOVVIKHC8ziLVuJIc697ddUyGpW//LNH6o/qbsqW6LK9k+oa4kJcdwgsjeDlSmUxXZbAuU9fiavblGUl0DMfh58KBANpYLy/1cWBiCbK5H5MKrEPG5unRjjZmGFU+0XX3stzIMNUgoGsm84F4C8oLXswAwzKGuveXvbXHhpHVg88ZLNoxrS9pXiCR4+ryj485bfwY55ZGgLTOD/gjaYu9zZto4ZH+Ov26O1MnRHAx3e1WbKW+XxzObz9drXzAQVT+WhOnd4Gh68qbVp/d7xHHCbbuILUQXDMwzKHtP/HHadIn+6xVdUWxNOzA44xFMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8eZOK2U0futIF8E8+vfi30OWXA523Iib/pAjmMl02Z0=;
 b=IhSC+v+vDXVwPfYu4DfFfZo0qNQgXm28/zdiJEElPxj8BCauIstrKBePT+4bExSatof81O60Hh+1lpOCA1Zo1OH0fEpR3TmNaED+M5hT44MK9jjzEH3WDSLuTu9R6hjWmdqUMgkyAqzHGHBEYve8OFtLbnaoMY7Acp7PjdMyidWwRCCJ4qhaI9dG5kUcgmD4gU78yAfMULvJISkmo5oQVg5t2ok4FjC1OvCTWZrJbORi0qOs/dTvS9L/clCNksp8+z18hblU2IpBEJRQT1vwoFEQzv6Swdg9TQE8mP5eqlghpBPgtTW6Rxicntr+8YeBTKgP9F/tPjpvdK1fogsodg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8eZOK2U0futIF8E8+vfi30OWXA523Iib/pAjmMl02Z0=;
 b=d8yraqRaX2kKDTegAwdj3gxGRgR0n0/0mEnALqyRf++m0nETfeJoKYRl6vLBGJ7aI/s+CCZgDUrkNb6FBY6wiQ8tG+Rki/t35hirhqXZNctt3rMsBRQxF5FlWB1hKERbeTyoHIHKiHBGX4/qVqqqe3ivKVnRj7ptkJDCSzp5x3Q=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA1PR10MB7168.namprd10.prod.outlook.com (2603:10b6:208:3f0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 08:45:25 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%8]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 08:45:25 +0000
Message-ID: <37743f09-8d30-a41b-10c1-caf34f919f3e@oracle.com>
Date:   Mon, 5 Dec 2022 08:45:19 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 1/6] scsi: libsas: move sas_get_ata_command_set() up to
 save the declaration
Content-Language: en-US
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, hare@suse.com, hch@lst.de,
        bvanassche@acm.org, jinpu.wang@cloud.ionos.com,
        damien.lemoal@opensource.wdc.com
References: <20221204081643.3835966-1-yanaijie@huawei.com>
 <20221204081643.3835966-2-yanaijie@huawei.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221204081643.3835966-2-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0416.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::7) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA1PR10MB7168:EE_
X-MS-Office365-Filtering-Correlation-Id: 52bd7993-49a9-47c7-7c77-08dad69d0d4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aJ9GoSqW6Nr2rr/QRWG0x6kp+iBO48q+j4PqqjzD2h48rUsUYc4av1TLmmhyBdmV2IoXCBgtqzBwB96q24N144vBD9DnjJwxFuCHnQY+INQIUVLyN9IJaegpl2mz6QJz73ieUd9KshQNqooDjTZaW4LynFvFbXND6r9R2vKUSQTWId1SwgJu4IwPE8PFWvKVo3/8qtC323ua3UFryLZwFQm2+BMPQ1qwUCJa1GT+BSoZ2YliaKCpz+D/soTAnGf08EurG5Xg+F3hrwiQqE4ys0MkPsqm4E8r2gPtIiiCSx0UtaGCVX1eYj6zRZVQa3at4s3O9+htkSqlYpxpaAIoVmfLwkTsZUPigL7+TWAFh9AeTl2hHYtmibyhGIP5n5eml3Q4g5+cIetIKDdjNfqM2mfkFY5P3elQstTPFUajKUtn1GaZxCq/QiWDhxjXGKLF5MA5reo478sZgDOwlfZw+4/Dsuhzi28h4B6LtDnIIWayOfbh2sleLNi4iLqy5si7H2LXqQMnzvZZnOsqDmdsyvOZ4AojbcrXIB7AWSb2lthkXQz5f7KjhTOXCmruGPIB6yVlj/7lkg0Q7PqlpzhWv06PgndNBrQ6gjKoGjXf7j2K/WXLrDID/lXbKIztGfydpdUits77ZKm2DDmdC9ishwF3nyZc1KWeny92nb8vt0WmZScBPDimT5Yh8ebbwZNtSA2ecKEgJaIdQSucenZyu2ZiZg1+R+4zcQNyMIQqGIY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(39860400002)(136003)(366004)(346002)(451199015)(2906002)(6666004)(6486002)(4326008)(478600001)(316002)(53546011)(6506007)(36756003)(86362001)(31696002)(66946007)(36916002)(8676002)(66476007)(66556008)(31686004)(83380400001)(6512007)(186003)(2616005)(38100700002)(26005)(5660300002)(41300700001)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3FacDArK1QrQlVDZVdNZG1ncHBlbHlhUlNXTEtUUWt4TTNkSVhRV0Z2VTZF?=
 =?utf-8?B?M2ZpSHdwWmV1YkZ2OEtPbE84WTViWDFZd3hGc1ZnanRidUZpRFR0bHhoRGlD?=
 =?utf-8?B?RlZvSWNUZS9RRGM4bURhVHg4VzcyRDZRWXExaUVpN3VVczRoNTAzL3ZCQU1n?=
 =?utf-8?B?Y3I4SndEajNiaU1zWDNiMkQ5SXpHc1NpQ09VYjVRUHBEL1U3V2ppNW85VjVj?=
 =?utf-8?B?UEpmN1Vqayt5ZGZDb2txazY1YysrV21MYlJYaXhTNnVzZmFNNko0Q0Q2SS9s?=
 =?utf-8?B?YUxuZS9ad3kybjQ4dDU1TFRLejQ1L3VFQXVud1ZMNGpnOWFtb1FVTVpobFF6?=
 =?utf-8?B?L2t3SGE1UjcweDVWMGlGdkR2Q1dGOEdEYVluRWtQdlhuZVEvdk43MnpmMCt6?=
 =?utf-8?B?YUlwUFRaeldoZXFnNjB0ZzZSbk1ZT1hNVWQ5MkxreTU4d0xCTVU2YnNDYk45?=
 =?utf-8?B?VytTcFBVMHZBVmRoSkhQSng3THFXSmw3ZGRQOWdaNHdkZ1EyeDlHOGVmdGN6?=
 =?utf-8?B?dmV5WjVBTWxHSGFVYVI1a3hYS2owQ2hmcEE3K29hRmExNWRmOFFVaTV4OHYr?=
 =?utf-8?B?MGFjeVBQYUEvSENQVVVLYUhnNVRmZ2xaMXFQTmZWcWRocUhDekJkVHEzNmhh?=
 =?utf-8?B?TWJCNjE1eE1VRGFodkFYM2dDdm1OVy9HZk4rS29GYi9RN2NtaEFyczZYcnB0?=
 =?utf-8?B?ZjZqWmlXc09QVlkvZzJMK1JnU1AzS09ZUTkwVUNrRHBUTVU1Tmc2aU5pdUpq?=
 =?utf-8?B?NUpBaTdnbVBhemZURGdOV0I4Yy9seWlwamNHcW9IbHZNQVdSajAzY0ZjWHF5?=
 =?utf-8?B?Mys4bkxpNFpxNEV2ckxtZ21IazFCRVhVYVY4VVJuNnljbFduVUp0N2pOR2dv?=
 =?utf-8?B?eThkdkk2NUlvaFJpa3k5cnpsUDJBODUwWStGMUNnd1FmaC9VNGc2MnpaSzFQ?=
 =?utf-8?B?eHc1K0oza2xLZkcxeFhqTEsrdjV5dUJLQlFkR0o1MW0vSTF5dVRTSkZ5bkZD?=
 =?utf-8?B?ZE1OK2JoMnUrZm5Wak01Y2h2enhJYko4RlhOWE5VYnNGNXAyb0N3SE5pMmdE?=
 =?utf-8?B?dy8vVVZ5TWNBZlRqV2d4cEM3ZENYY1kzWm5KSFBrcHBiWWZCN0tRaW5RSVFP?=
 =?utf-8?B?NjFyTlZCREh6eUZPVGRIekpwYWtFNFp1NEFhamdYaHlpc0pJNmVuQUJkT1NP?=
 =?utf-8?B?anlqc3FHazFFRDBqRHZmck9RWXJSZ2NEZ1JaZ2xGY2ZsOEJQSG9YNC9kbEZ3?=
 =?utf-8?B?cHBJbEs0T1kxMVBERVFqUW51OEdKZWdxTm4xa2xDTHZlQS91TFZXc1pCS1Qy?=
 =?utf-8?B?cllpc29zUkMxbDA3blF1UkpFcWxnbUt3NzhtazUzWFNTakc5SjhYTVFOWDBy?=
 =?utf-8?B?TUdIRVI5R1JqZXhnN0Exb2tEZzB4SzNYUzhZdFJPYlp1dkcxVFJ2TFRHdWdP?=
 =?utf-8?B?WnhIQ3NvTSt6UW12emJYOUUrVzV3TkJpUXA2QzNSZHpLRzZKY0c0ZERnZnpJ?=
 =?utf-8?B?akl5ZGIvWjFkUTBVYmpCUTRiU0t0REZwcVgwQ2pKaWtuUWs0d09wdExLOXBh?=
 =?utf-8?B?aWdyOHZPOEYveDFaUkNKd0M1MytuU2dSTlhkeTE3cDhMN0xXT2hkamVzMmJt?=
 =?utf-8?B?a2pWQ2xnSCtHcnpwK1ZUanZ1cVRZa2tpR3RDYTJISTd2SVFHdW54eFlZaEYw?=
 =?utf-8?B?WGkxbC83YkxadDk0MGkzbkRWWWNSZndFTEVONW1EUFZCN2ZrQVNMME56VWlC?=
 =?utf-8?B?WWk5RHhpL1N3UnJ6cDF0dkpTT1BrcS84TlFvNkhRS1gxUngzOEQwTnlsZ2R2?=
 =?utf-8?B?WHBXdkVrVSt2U0pVNGdnbWR5Wm9HZ0tDczVOa2VCamUwOVhIRlRWUUEzWFI3?=
 =?utf-8?B?ZWl0K3FYUlh3NFNvcURsTmgwSTI1YlAreFZCVFJEd01nS09qQkVGYUcraEk0?=
 =?utf-8?B?TVlUS2RPNUNuRVVselFsY2JaV0xoQ21hOWNQcGNHU2drczNDUG9PTUR3dUJO?=
 =?utf-8?B?MFFpdUo5SWNXK2pROVBFL2xYR20xZ1FHYnNjWElCRnpIRDgrMFBZSWs1M2g1?=
 =?utf-8?B?QzkybGtpdm4xWER4L1BVL3BSMTJaNmxHVEo1YitIRmtmKzJXSzh5c2VKeUhi?=
 =?utf-8?B?VWErUFV6SFJNMzkyazY2d2oyZ1phWmpqNjN0eTBPWnBKMzVoZVpxaFptZG9s?=
 =?utf-8?B?Q1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?VmZVQklncUJDWkg2RlRLZnBMNmhyT09LOElyWTdQcGZucWFGVnlPOElLQXlm?=
 =?utf-8?B?QXhyN21odlNmc2NyMW5yNUI4U2JDYW9uSzVqd3NPQllscVgwdW5CN1dJYitz?=
 =?utf-8?B?ZlB1L0NQMjYrdVdZM0FHWjhDYzZqUW9TbUV1TDNSL0hDNkliM0l1bC8wQm54?=
 =?utf-8?B?YVNhNldzKzF3cDZqbXRnc3RkS0dHbHVXenZvSVJwbVJ5MGw0SmFXa2pTSlgv?=
 =?utf-8?B?eTYwUHQ0TDMrY3lYaUJ4WFd0cGo0YlJKbEFpR3M0SEw0cExlMWN3bk5Ya2dw?=
 =?utf-8?B?bVFJUlZ0dG4zeXR0dXFRQmluWlRBZjdwNHc2bGhNNzRlSVhaT20rTVBPUVA0?=
 =?utf-8?B?WXFWUUFDd05kMWlUV213WW9KTzVWaVFMUkRYYWtrelZmTVpScnBjd0lSQkht?=
 =?utf-8?B?U2FxTGhNbGg0TzhvUDg0aU9zRkNwUUNFM2NQSGFNVjBoZ2dqOHF3cEVyZFNn?=
 =?utf-8?B?OFBNWVkrU0lDeVBkQVM3WjJESXplVnpxaVMwYi9UQTVtdTY3U2hzVHlROUJk?=
 =?utf-8?B?VHEzTFVKWjVNbHhtcDlZMjN3NEZPTTdxRk03bDlpTTBiUVFCS2EyaHkzbFQ3?=
 =?utf-8?B?ZzVZZ09idFF5NkozS0lTRGx5K3o4eitHRG1XZjNONHNaQWJLYzgyZXlRZVQ4?=
 =?utf-8?B?NU16aVRiSEgrVVpIdVdxUlFFM3NhNmNSaXprZ3JJUlNmSXZZSEtKcmpiMThy?=
 =?utf-8?B?TDNmYzUvT2RFc2FKUFRaVUdYR2FzN1lFZzN6UisrVmdQYjhtQVB3MUJ4eGlX?=
 =?utf-8?B?SmNnTjN5a0RtbnhXOEg3VEtXQ3ZRZE5lVzZhM1AzamJPTVNpZDFnZ2J3T3lV?=
 =?utf-8?B?V3J0TFB4S0srWGtPVDZpby9rblh1VGRMVVR0c3ZBRHNPRUdXa2JCM3JkRm1U?=
 =?utf-8?B?VzMxR1N1VEdhUGxOMXpnNmw3Q05RenA2ZWJoejZ2Z2NscUxUQmJMNjYvOWRY?=
 =?utf-8?B?M3pUYkR3SlJKN2JVWVVEVEx4ZjNKK1d5MnhaUTAybVZjL1BLZ1cyTFVKV1dI?=
 =?utf-8?B?bkpBWlVhSWM5OS9Bdldpa0picGFTSjIzUXdMZjJtWHVzZHNPNGh0ZFVpbVRH?=
 =?utf-8?B?SVg1RWlJU1Exb0JiU2V6ZVpydXdwNHgyRmRlZzU2T0ZUVm5POVRLa09JUmQw?=
 =?utf-8?B?eWgrK3E4UFlmN0FGSGdQZHAzVWlkYnN4dVRyY3ZXV25DOUJXcXgwZUFmSFVu?=
 =?utf-8?B?angyajEzcDZZc0dMS2xJWmtvNElDZVRDNDhzM3NEWTQyOWI1YzFnOEgreERR?=
 =?utf-8?B?L1pKTEQ4UDdZMTVwN3RlZmRiWmxOelVtdzh0dlBFUUJCc0J1UkVXTHdFNytt?=
 =?utf-8?Q?MpNhQR4aY2YAs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52bd7993-49a9-47c7-7c77-08dad69d0d4f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 08:45:25.0056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: caEMQC7cx2DOjucU+OP/PbcCoQlBFNfC06E22dsPcx3JztsKuN48/U7aN2Yzn5pmL2OrIBg9KSchJ6pzjBo5gQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7168
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-05_01,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212050068
X-Proofpoint-GUID: vb4s0EKEbTZeSYs67lk5g7WAHdPsJWVk
X-Proofpoint-ORIG-GUID: vb4s0EKEbTZeSYs67lk5g7WAHdPsJWVk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/12/2022 08:16, Jason Yan wrote:
> There is a sas_get_ata_command_set() declaration above sas_get_ata_info()
> to make it compile ok. However this function is defined in the same file
> below. So move it up to save the declaration.
> 
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Apart from comments, below:
Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/scsi/libsas/sas_ata.c | 28 +++++++++++++---------------
>   1 file changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index f7439bf9cdc6..34009c330eb2 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -239,7 +239,19 @@ static struct sas_internal *dev_to_sas_internal(struct domain_device *dev)
>   	return to_sas_internal(dev->port->ha->core.shost->transportt);
>   }
>   
> -static int sas_get_ata_command_set(struct domain_device *dev);
> +static int sas_get_ata_command_set(struct domain_device *dev)
> +{
> +	struct dev_to_host_fis *fis =
> +		(struct dev_to_host_fis *) dev->frame_rcvd;

nit: I did not think that we add a whitespace before casting. And I 
think that it would be neater if fis was assigned separately, avoiding 
overflowing the line in this way.

Having said that, it does seem odd to cast from u8 [] to struct 
dev_to_host_fis * and then back to (u8 *) in the ata_tf_from_fis() call, 
below.


> +	struct ata_taskfile tf;
> +
> +	if (dev->dev_type == SAS_SATA_PENDING)
> +		return ATA_DEV_UNKNOWN;
> +
> +	ata_tf_from_fis((const u8 *)fis, &tf);
> +
> +	return ata_dev_classify(&tf);
> +}
>   
>   int sas_get_ata_info(struct domain_device *dev, struct ex_phy *phy)
>   {
> @@ -637,20 +649,6 @@ void sas_ata_task_abort(struct sas_task *task)
>   	complete(waiting);
>   }
>   
> -static int sas_get_ata_command_set(struct domain_device *dev)
> -{
> -	struct dev_to_host_fis *fis =
> -		(struct dev_to_host_fis *) dev->frame_rcvd;
> -	struct ata_taskfile tf;
> -
> -	if (dev->dev_type == SAS_SATA_PENDING)
> -		return ATA_DEV_UNKNOWN;
> -
> -	ata_tf_from_fis((const u8 *)fis, &tf);
> -
> -	return ata_dev_classify(&tf);
> -}
> -
>   void sas_probe_sata(struct asd_sas_port *port)
>   {
>   	struct domain_device *dev, *n;

