Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01C62C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 16:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234639AbiI2Qjz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 12:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235729AbiI2Qjv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 12:39:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D229A140C9
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 09:39:49 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28TGOFBc007835;
        Thu, 29 Sep 2022 16:39:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=5LVLA0miA30pKOiVJOACDHbGRiKGLEG2zA1FkkP2C3E=;
 b=dSyKxDFK3pdJCJ0wjnra+7GO8ImvFEqFcgRpSId1I/jtokZvUq1ftvDq8gFlyIFgzs3E
 9umLzRaX0Sd3jWionXIk1hn+1I+XrXP2m9qfQHSjDoMer/l+TSHS0LMlbOJb6aKFyF1P
 JBCkshYObZ68W+oTBjQUhzsgwsrI6gAFlHavOVeQzjAc34G+xQUfwh8wUXYT4MICBO6w
 YMMJ/ZFxurAOkuSndiSoE1DA5H6c9xwnZmObMZAMNtEeeZ9AhcNzFoYtSzpB/fZ0BCZi
 MVejWVwgoKMUJc+9/OtJFFMhYGTwaqAT1Rk7EhFinJqGvb/YnEdQKQ80Ty1wFb1E/EMp nQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jsstpvths-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 16:39:38 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28TFKGpW039473;
        Thu, 29 Sep 2022 16:39:37 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtprwma3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 16:39:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I5/XN8cBoV+2QXddo9sxg1v16o0BrjWvJ0XfniFJ+dKY9B0S0KKXQJxrayBJfJ+jJrMwRRClppHRCO0fB2masdmopJM+QpUM0M2nP9XfbS49cn7lbVIVqsPwW389Az1NEajFost3T7UpWJpPSPHc27rq97bXA9nJtGWYFfwOHva9xMexciPmhegA5se543Zu1IP8q2FKsG58DEVbLHKdqR7iYMgjMCq62GUy0PC9CEsM87W1sNqbFNf/Z3eYTH4Sy7SKDlgsC/OaD5UDg1CStr3zE680fzsERkqDdRZziKTkHiJ29XeN7jKkb+SYuLfazioQmC76jCh1Av/lq2i/Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5LVLA0miA30pKOiVJOACDHbGRiKGLEG2zA1FkkP2C3E=;
 b=EkQIJdwTudOj09S0HxR78DEJ687e0lOUgzFxHnaYJ/4Trd2OvnrOP7yz6RO7kRTIUbF9XZoraj1vAgs0+oh0/17cDey6V0mzGyE5WuF2H/r7eLLe8jpkMOhkQlXAVs3WTV4i9LZvWSlQ1mXPWsJJFrctD9LHFjSDwgd9P+vUkVSbpZIk83d8bT5pmzr3tV/uNUgkFUKw7fjAIL82LGp2RcLuwIUel8Bs7jd6AQVXGwXPYWxBxjPdVZSwHrRdrfb1xHk5BTRpjtPjnsRQXCgc5ZeOJUw465l1nVXCPIzH45J2Vincnzd05vadx2z2ZSYBHE5UWxKPWAvCZA3NaSa47A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5LVLA0miA30pKOiVJOACDHbGRiKGLEG2zA1FkkP2C3E=;
 b=ueDZhQbQA10M0PO9Qa53EuVrgNcwkSgCLRpSr10TtJ2xdDEGjGDRnYw4ZA4X8HRdctXCPqzFpz4oOAFkiGqSW0YsZO4xwqcPfC2sUAVm64DkU9XZG4G60OVUCmkUnaBu9nd/O5hZnU2dFSKzl7t+fDQcy5nh6DAlyeMjlmAWkq8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5024.namprd10.prod.outlook.com (2603:10b6:5:3a4::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.20; Thu, 29 Sep 2022 16:39:35 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 16:39:35 +0000
Message-ID: <ea3b3495-f5af-c19e-063c-c58d0a7d9b06@oracle.com>
Date:   Thu, 29 Sep 2022 11:39:33 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v2 02/35] scsi: Allow passthrough to override what errors
 to retry
Content-Language: en-US
To:     Martin Wilck <mwilck@suse.com>, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220929025407.119804-1-michael.christie@oracle.com>
 <20220929025407.119804-3-michael.christie@oracle.com>
 <8ea448f35480725ce982ba63b8ecb9baafa1edba.camel@suse.com>
From:   michael.christie@oracle.com
In-Reply-To: <8ea448f35480725ce982ba63b8ecb9baafa1edba.camel@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR07CA0013.namprd07.prod.outlook.com
 (2603:10b6:610:32::18) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5024:EE_
X-MS-Office365-Filtering-Correlation-Id: 3882f732-e284-4cd9-237f-08daa2393162
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 86iKMKYY5br6g7sQyyMoXbrkjZMP7IA+f51F8WcsGlP1HNHFJdGTsxuPMqlXpjXHd66wUUct2f8+a/e4n/K+CG+e6efBW2YhwHX9det1Kuz2A/qZgWblHqLKenHA0DGpCxFlCfSarxisNFkINRL2x09fegNzbJ/1HYiJFgoboIVAl8q5odcR4hw2fztU4/fi/3obMEO/LitfcU1c5NEfP3WCQ+PxrL9+PBIcPR+pcR8bybIXPb3aL2ErZY9ddnQZfC2t7Ru0NZKjr6NTlltk+QsFAOb7WvweFAVcFKRDQvbFNF+wWTkkLR2M2E1MNvu8XYB8VG5xeOmdFP3XlmCpt0+JRloOUBJqtrAqMBQfP6TyEWvniHlRr8T7uRIMa1CE4HTQbk2qof48S96cYg9tW/JHTXPVHRyKnrr4nZCAmVJ+/3jmIMf2h/O/LIl+LbSS/uhnXyKdANwb02T4Los4v/cBHshaeAiPMs7e4xVbroK2gr32PDHW+572/RHFZp81nP/knEdXgehLp08+OrRkbYzQFG+4XKzi/ovbgTp2tjtS1U4amkVbsoNk6TPN8iTPQTCwN5YQfrA4Am03xXw/Itd1QLGGp0jvzMbuylpRowVIt3R9jwWO519pN8Op5miiAWT0jvAQIz7A1MbG/9BftT9tFWDhPM0VCtxXqHr2vmFL3r/7f6X1UFklxGfa1oN5tT6DW/Ea4gl1HGFxVq8NKGy82M1OGDWmN4BXs6yILK4mHIEhluFSBchBROEDIJXX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(376002)(136003)(366004)(451199015)(2616005)(186003)(83380400001)(38100700002)(86362001)(31696002)(8936002)(4744005)(5660300002)(66476007)(66556008)(66946007)(41300700001)(2906002)(53546011)(478600001)(26005)(6512007)(9686003)(316002)(8676002)(6506007)(6486002)(31686004)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WU5HSXVjVk5hK3dIN241VjRzSlJmeEFUam4yNG5uTEVOR0RKU0paV2M5dUxB?=
 =?utf-8?B?eXJheHIyeERwazB2RHN6R0ZrMjBrZXUyWExWdCt3eHpBdUxNSHdzOGVDRDRn?=
 =?utf-8?B?WmZQTjN6emNQMjZtTDVLcGYyakRmam9BZUl0VFpvakFMNGhJZmY3aWx5K241?=
 =?utf-8?B?Z1p3QlVGSkNiTVYzRkFLUzE2eEV4MzZNWTFwWnlOdVNoSlBoUmlvTm5rZzVh?=
 =?utf-8?B?a21OS2VEb3N3WjRWVHhxVENJbHlDakpPSG5ZSFZEbHY1WmVPWDUyblhtbkJY?=
 =?utf-8?B?a2FnQWkreUdUMkdBREYvUTFOSDF5TWtiZFYwYTByMW5PaTRJa2N6cW1NcVZY?=
 =?utf-8?B?L3UvQUUxb1gzdzdSTDZEbjdGN2RGZ1pxb1l0d1dwQWVJS29KNU1RN0JuTnFL?=
 =?utf-8?B?RjVrQWMrQmNuUUtzZTBZc1JiaGt0d3crbHVNSHBVRzgyMlEzcUVxQXFOSUJ4?=
 =?utf-8?B?WTNwYitIS29NSXdGdDZ3Sk85d1dlMzZVZ0R1Vnl5WlF0REZkc3kwQjdDYUli?=
 =?utf-8?B?Q2JaVWpRa3ZuU1NwRmRsTkFZV21LUzh2elpvQVVmb0tiRTZITzlMY2Y5cjZs?=
 =?utf-8?B?VmZXeFZqSlNoVXlJWjlDemluM0tDK1lheTB1cWRYVmZlYW5aR3gzVGpqZk90?=
 =?utf-8?B?OXpHc285OFJVWXEvbTV4M0NMb1E3VkkxNllPMHFxcmk5UnlvdjR4d3FWZFh3?=
 =?utf-8?B?NENoQlBkL2grcWREd0JYYkRsU2FuNGp4dG45bTA2cUlDa3cvc1I4YWsrSkk0?=
 =?utf-8?B?YTJuUW9hMnhGK3VQT2V0dW9OTTRWeWpUWjB4Rmd4T1JtK0MwSjJQUkovMGsr?=
 =?utf-8?B?bWpRK3J5TWQwRTVGeTdVWWJDV0JSUWJmbmoxajBhVG45Vk13L1FEQ0NJaGd1?=
 =?utf-8?B?SXRQdUJQaTFFbXIyRFBsOXRvSEp3TFJxekRpeExTanN5elg0Z3N1cmlKdjFV?=
 =?utf-8?B?aVJDUVlXWDk3dmFHRC9hV2tXMjRtSGE4Z1luQU5ZYWxTbUxsdzJieE9NeC9l?=
 =?utf-8?B?emd4Yi9DcEhuQ2VZcS9lUnZtLzdVNzdoRkxsdzV3Nmp6TUE2QVRyVjU0eFBl?=
 =?utf-8?B?OE1GRGFUSE9OK3UzSHU3T213aUk0Y3NCaTJ4bUVaT2g3Q0FEVHRickRxL1pW?=
 =?utf-8?B?SEwybWxjL3YrY2dWZGhHYit4ZmpqdU1iODkwQ0RxcmxCY3dDTW5iV3V1WDdp?=
 =?utf-8?B?VTQra0JYKzJwcDFyRllldkdXd2c1SlQ3V3lSb01lQmJ1Wnc0SlZPUkpWTkc5?=
 =?utf-8?B?aG51NUJkazAxQnQ4bkhpQVRpSlA4NHptK0pBVFBlWFRLQ3hHYWVNVHpFcU5G?=
 =?utf-8?B?TmlTcG1keDVpT0Z1cnJYUVZ5aHUxdHN2L0pRaFRiMUlEWmVkbTh3Mno1ZGdk?=
 =?utf-8?B?L1FyZ084N2E0YlhuNkJPcVdoaG1ZZ3ArUWpJY25zRFFCNVNVS1l0REVocFN5?=
 =?utf-8?B?Q0dPeUdWc3l5ZzkzTjBocEtpVXd1V3VKWHlnL2JjVGpXN0pRa0NCVVZkSjhD?=
 =?utf-8?B?S3NlVXZ2OVphOGRUVW5OOVBlQ0treXBiTG5jYnFoZTg4YzYzYUFoenZiTGlz?=
 =?utf-8?B?cmoxSlNtdEQrZnVTOWtUUnRTWHdPdlUxRklpelYzOWRjWGI5RGk0NUlVMDdV?=
 =?utf-8?B?U3I4bS9XRGs0QkRRaWJ4SVphUU41SlZHQ01hbXd2MkpmaTNlNjhQbXZqM1Rn?=
 =?utf-8?B?VlI2M1JGT3NmdTlyMDZ4aGQxQlFjV0gvdUxWcEhlNlZQZnRjT2xEMWNQSC83?=
 =?utf-8?B?ZEdSWVNrbyttT00xSmdabUtrQ2czWHZqQnhYZHd3cjlpTW1jZEErbDJvUitu?=
 =?utf-8?B?ZjJFNWpIeTkwSGl6RWVpeDBMeTlwQW44UXZ4M00zRGtkUExFOU4yREFQZnhh?=
 =?utf-8?B?RXpzSk1IZnAxZzVDQlJmZXA0TVJWbG5HZlFlQTFJYTgvUjZDcnAvNjVBemMz?=
 =?utf-8?B?UjEvSjkxbUJUTnlzL1BxS2ZwcDVHam9vSW16dHRoUGlYNWZSckJ4RmwvYUxT?=
 =?utf-8?B?bnBlQUpGRUtGT1hBMkE3NWNCbWlCSmhkTW9vZisrM29vSGRuazJMODhybG9S?=
 =?utf-8?B?cklJdTRRTFg4RTgvQzZjbTh6UjJEeFlUekRnaVRDMXNobW5IUk4zWktUeWdr?=
 =?utf-8?B?WmlVakxWWkxVWThmTWMvMjYwUlpvMGVTeGdydklSa3crNFNNRlJJczdTc245?=
 =?utf-8?B?aEE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3882f732-e284-4cd9-237f-08daa2393162
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 16:39:35.3103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hWic5+q3VQ9NEIFPZB7DxL+K88EcqSdpCGsQb3iN2KPhOWdv89mp4I7MnyN7yndGThTHMKPxQrK9+H6955RSJicvbCrehNj8E1DZPAYDZ6c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5024
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_09,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209290104
X-Proofpoint-ORIG-GUID: ezFBYGVqdlaIOko8rEOGl62Vt6F6q_sf
X-Proofpoint-GUID: ezFBYGVqdlaIOko8rEOGl62Vt6F6q_sf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/29/22 6:00 AM, Martin Wilck wrote:
>> +               if (!failure->result)
>> +                       break;
>> +
>> +               if (failure->result == SCMD_FAILURE_ANY)
>> +                       goto maybe_retry;
>> +
>> +               if (host_byte(scmd->result) & host_byte(failure-
>>> result)) {
>> +                       goto maybe_retry;
> 
> Using "&" here needs explanation. The host byte is not a bit mask.
> 
>> +               } else if (get_status_byte(scmd) &
>> +                          __get_status_byte(failure->result)) {
> 
> See above.
> 
I had a brain far for host/status bytes. Will fix throughout the set.
