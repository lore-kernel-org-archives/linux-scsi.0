Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F13AC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 19:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239200AbiDHTOL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 15:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiDHTOK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 15:14:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564731229B0
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 12:12:04 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 238IZFRX012570;
        Fri, 8 Apr 2022 19:11:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=RvbS6uJohD5FZlC2VqdsCEpF/IkitEHyU4sHTHPzzxE=;
 b=c8BoNWnqDMujFu0NhuViAdU8ztMR5UjSxHj9R6LybJYqGvTuwx5PCpnslsncZy6FNxAf
 3XosgtbwKl037Ww9HFvDyZMTCmxFKVwMbJlXxIrNaxEHyzSw3I+lT2bYdRx0/opWk9SL
 3EqnVtaZKFE1R6MzFKOlPixSm5Ecp56wscwgDuz8QU37H/ZG7neWkDktoh0dEnh+16XJ
 yF8alXHxOCOgK71K5Wq7nxM1NSEdlhUKy0a6Xmoi2Ig3/+nUjStWMmoJ6DVYOrE4mC9Y
 MfYeEn0eOER988g8dPxG0yStHAoLVhqOvU4Flv8fMkrTgSwq+8QV1ZOVGB0kQknq8Tby bQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6cwcqfwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 19:11:59 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 238JAsoi015155;
        Fri, 8 Apr 2022 19:11:58 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97y97fd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 19:11:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NCRJPcdUnjPGW6Sd32j++eebz6EVVEiwsFY8ULI3G1le9KIK2ryd/vo1xzvHfjAiPzQsDuk9a8P1QDNoTtJn4MNAl/PKZ8dfEWb0y7bbk/h0SuBsjnRgKF9xNXXBUNC8IePSbjy0rsrM8zO2H7vRNRdLNivnffc+7m8HB6Uk8SbDRJnVGcYLvQ5kzwHPB3U+McSeJ9hbrn4VD8rt2PessL6tXokZw65inC6u8M7BcDLIJPT78KtGVpjjm1figTiIRRDk6pBL6ZyyCZ3db5igopzCsO+57oaIltwIes2bsT6PgzI9yKPKi7k3/Hu+K/YODhBUtavNS/AuejM/fa3uGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RvbS6uJohD5FZlC2VqdsCEpF/IkitEHyU4sHTHPzzxE=;
 b=f6ruX23TG8O1WBd7+aq5nQr1yw6LGv8JcieEoHu9iaaWn4gO/sHtMlhCn8jMR37MZAXKQ8weTI9/0sjP2QViZv9CTy5j1WTH4v0jPtIsZh8TGDB0CPXk6hgpVa/9IOZjeJoq7d3PAyJMrm2s36RtcO0a+W9VRLnxfIJd7ii3bthgfz0GzUhzsKc1n3/GuylwEPUhvBLaBZiU2NQFYwDOTTHfDzIURJ+KjUyNjCnOQo0obJpxkFfrLiDLIMIbAFXVMI+uovLDEBx5SYB4QXtZmmluzd5dqBlcxu4h5e0LqT3wif1juya7igG8jbqj1MASpV+H1zp+JlFkMefd0T+Nnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RvbS6uJohD5FZlC2VqdsCEpF/IkitEHyU4sHTHPzzxE=;
 b=ucni6yOHYUEej22/Umm2/1Y9BbAL7a9lQPx0I50aCgK0DGnCoWj+RXWQjbtfGvSfmbINRQHHouObVqDZZ6pzChg8pviTaXNJMK1uwijA5QEvqAQSz4NRpZZ3gbhkebRerRP05oaZC0ZiBQ3KvWDHKAWxTFriSI//1TtS3TAaCxg=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM5PR10MB2027.namprd10.prod.outlook.com (2603:10b6:3:108::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Fri, 8 Apr
 2022 19:11:55 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::59ee:c799:39cb:c54b]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::59ee:c799:39cb:c54b%6]) with mapi id 15.20.5144.022; Fri, 8 Apr 2022
 19:11:55 +0000
Message-ID: <5c75258b-9b7c-109f-fab8-755239d4189e@oracle.com>
Date:   Fri, 8 Apr 2022 12:11:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3 2/8] mpi3mr: add support for driver commands
Content-Language: en-US
To:     Sumit Saxena <sumit.saxena@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, bvanassche@acm.org, hch@lst.de,
        sathya.prakash@broadcom.com, kashyap.desai@broadcom.com,
        chandrakanth.patil@broadcom.com, sreekanth.reddy@broadcom.com,
        prayas.patel@broadcom.com
References: <20220407192913.345411-1-sumit.saxena@broadcom.com>
 <20220407192913.345411-3-sumit.saxena@broadcom.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
In-Reply-To: <20220407192913.345411-3-sumit.saxena@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0208.namprd05.prod.outlook.com
 (2603:10b6:a03:330::33) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 073c5787-d50d-45b5-4d7f-08da1993a563
X-MS-TrafficTypeDiagnostic: DM5PR10MB2027:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB2027243CC1DE9B0563BA2BB9E6E99@DM5PR10MB2027.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UEq6A6k3Q7EnmwvfLH5C5F/4rchIWOkGhuEQNmmPC40u1E/H0GrVdZ3n1A4j+BSpvdhpgqdCHkUzd6LMlkefBxn4Wezi8XXv48h92hmZO1LcyLp7BB54HaLPR6lY9ZEh0Tba8jpWwEaRRJZqmf11uGw9FA+FI4WG8lzdymOQdHBMpBdeepRhDkVApFOwRhe/Yqh5FVlmu+XFXR/Kwi6CyegwRtA/Aq8vT8R4RAGS/kbDQNf8nlB2W/43TAFy05ML99Khl4vjw/oa+7ioGH5jwLirkUf4zoILtEHpV3Ts8UVAv4zbP7vKa9G2El89Y0p4ZMXSqqu6XVVHon0qLXyBTmWLDEmwCgUzmstIHqJwt3jibYXzFb7wdPgbXgmVldMQjX2SagHD5AsH9BEyckZ1cqJECD/21S5g5FSPEq45mROr6sA5YvYbNQOVHSl//vvOjOIGUcLALcOxIo0hRBPfeuyp51k0P4LIbsRA5ZDQ2mj3GtSAjsMQwIUmdg3TQPYEk1zzwKATxTCeCLNugRofinZ26t0oVCGxYMsjDwqWSodaBT4ahrSmuPYuy2grQY7riubBeorMFqqHPJ9Mvz73VvGRXRNmjdmbu5Rb++3abS/CFCt6DBr59FJzNeRcN+jIT1mg+G073nCIiu8+1M2erEBmtBYa0xys5LDE9e9YQZ8bV4n4OoD5XQiPMgsQtT8P9DF0bG++l/IipCPhaUKrmxFRtBKnrgjEtPACIFMwdqfAmh3N+QTe7d2kF/j3sjVcC6Hjr/AJNxaQ7Hsj65h/Cw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(66476007)(66556008)(6512007)(86362001)(2616005)(31696002)(186003)(83380400001)(8676002)(4326008)(66946007)(31686004)(36756003)(53546011)(316002)(44832011)(30864003)(2906002)(508600001)(6506007)(6486002)(8936002)(36916002)(6666004)(5660300002)(32563001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXNGdWZYMTFmSTBMUDVwaTJtMFkzaE9Cci8rcThvQ1o2RVRreTVSTG9OTTln?=
 =?utf-8?B?WUdqcHVPSW1JOE96azV5OCtYWVdab3dXajdIM2ZKNmYvcTlQcEg1N29malMv?=
 =?utf-8?B?YTdQQnh3WXdTSjBaZTE3YlY4eTdQV0ROYVYvUU02WHdOYy9qTGZTcUdqTEM4?=
 =?utf-8?B?ZUVBeEx6aVFUdHVNZWh6b24xemR6bUNzckx3Z0hEQnY0VEc1ZzRYbGdXTEhI?=
 =?utf-8?B?K1loejZIb2lKRjFZd29pVFdYa1piSnhXQmk5a3pRWUh4MDk3U3NHdWJFWHc3?=
 =?utf-8?B?QnIrTXZVOFd5SlJNVldZQmx6aHkwT3BOT1lmOEFrR1VEbXlqeDQ0VlZNUTFI?=
 =?utf-8?B?LzJYQ0hTUTBHbW1MS0hrVzA1Zy95eUVWMDRrTXFxcGk2MnA4aFJqdi82UU5E?=
 =?utf-8?B?eWNkK1hDVkN6QVBsdnFOb0hBZGhlMjVIcnJrdm1PSnVRUWZ1c28zclMvZndO?=
 =?utf-8?B?bUFlYUFzZEFONmpCVzVqbDBGN1h3d1U5U3E0OW83YlYvemNucWptODhEMW5B?=
 =?utf-8?B?bllJQ2plZmxZRGZ3cC9BeWNDRDZ5UVViNUp6T2kzemsrcmxzTkFkSVN0Rkh1?=
 =?utf-8?B?UXZOaXZJZ3JyNEduWWI2R1Y1K0U4SXVDT1dvWmM0ZDlCRG1MS0VzdDREeXVI?=
 =?utf-8?B?OWJaZmxVZVAvVW1FNlV2djQwWDBSNGEwUEFNdE95dm5IdDFzY3AyMExEeVNx?=
 =?utf-8?B?UG81N0xqNmpRV2xadTQrUDNySnRURW5SbnpDK2QzWUZKcURGQ0s2aENrNW54?=
 =?utf-8?B?eDU4RmtXQUpzQW1QWmhGeHYraXhJLzM4amEyTUljT0JLV2FJbG94M1FJa09B?=
 =?utf-8?B?OS9sNERjTk9IVjZEMldHUWtyc0Ewd3dzYkVCZ2NmcUcycWFLWXcvT3RobHF0?=
 =?utf-8?B?UmQrbmhMMFpRVm1RanJURW5Kd01YZEs1NVFQL05WT3RrdXRyT3lQR3RDbC9C?=
 =?utf-8?B?eFRXcHIyS0xiNGVBVVNjUWx6NkxuUDFMWUorTU1QdzV0aTdVUlp0RG1XVFU0?=
 =?utf-8?B?M0hHT3l4UEFESENwbEdpV2k4YjRwTmNLVzlNZHlQcFNBOFBOK201MjMyQ2sw?=
 =?utf-8?B?eFZOV2pBTk5Wa1phWWM3V0E4QTRVS0hQTVpSME1SOHhPVDNaU1o1RWlZb1Vx?=
 =?utf-8?B?Zzh2WHYxS0VPWVFEdWFuRFZXcjRQRDhKU0V2c0k1ZXovWVJwaEFreUpCQytJ?=
 =?utf-8?B?TzU3blBmYkNsd2xzbjBtd0M4dkIrVFNudENpdmFkOVJDTHFQL3hWakFQbnhK?=
 =?utf-8?B?U0xEczZUbmw2UWFnSmRBajgvaFpsaEp4aFVVekVrU0VkTlVva3hBWWZ0K0Vn?=
 =?utf-8?B?anNMTVI0bGFJRUIrV256U0VCTEk2OGRsM1cxZ2FmSXJSZ0ladHhnaHRiSnhP?=
 =?utf-8?B?TEZVMWwzZWtPY0lGdVZnSmdkNDZWbCt6NDRiNHJCelVuZmhyZy93TkJuRmpa?=
 =?utf-8?B?MXF5N3BMK3MzZVZFenlZQ0ZkVlVoWjZZN1dtdmwvTzZOSElsdmlNVWJQZ2xK?=
 =?utf-8?B?ZTJIZ3I0NzlhOStpOXA1RnVTOE10dWh1QjdNSDBHdUFrTzIrS2lGNlNScTYv?=
 =?utf-8?B?ajFMZVdzbnpNdnVSVWRWckJEZng1N2dvY0x3K1lWRlhrYlM3QWxOVnRtUEJx?=
 =?utf-8?B?bC9UTWkxZFBZVmhwcUVRTHowZjJCZmptVlpyc2FtTW4zem9jQlpJUXViVWFp?=
 =?utf-8?B?eEw5djF6NmNyTVRrQmJSYng4cHVCcHJGdk9hWGhQeEZuQ3VWSEtWcld2UjVK?=
 =?utf-8?B?WVZrU1k2TE9JclNObXJlRlRaTlkrdDZxTDhudElDa0s2L1BvYmg5VkR1eUxI?=
 =?utf-8?B?ekkwNmFpem1FYjNOR0VOSFdPeEZLYTQvcEZmVmJVTXhVbktrd2owQk9wdnV3?=
 =?utf-8?B?am1oNjRBVGJGSkRMaFRZWkRHTENGYVd4ZFlGYjdTZk1DSjd1UXdtWVduZVVQ?=
 =?utf-8?B?UzVPNlcvaFNZNlZYWVE0R1JPNnB2ZHlGZWMwQzc1Zk5RdEFlZG1wZEM4KzNZ?=
 =?utf-8?B?aGt4dXZ5clRaalYxTXk5aHE5ZjRCT3ZVWHhzR2JEUmNsRG5oYnRmWEpCNTUx?=
 =?utf-8?B?dktKbUQwelE3dDVoVC8vKzdhUEpSV0dYUXAwY0J1WEVFem8wcFhBTldMTHJM?=
 =?utf-8?B?R2xid2dYU2pYbVFJUXJMSEl4TnZwSS9zSWZVdytwYndIaHNKd1ZTekI5QVIv?=
 =?utf-8?B?cmx1N3Z3YmpncVpQdTNRS3pqZjBFTHI0anczSXZVQXlFTk94NlJidzFGdVhj?=
 =?utf-8?B?aGhIZ1FyaEN3bnllWVZ6cDM1d25zM1JjS2NPR0h4ekhjanprRndxYmdBS3ZH?=
 =?utf-8?B?VGEyUStmRHhVTXFkbVg1WkJqNTlsWU9wbCtpcVp6TUhZNTN4Wm01dXRoTHE4?=
 =?utf-8?Q?kQLBEmx95U0ocYTvC1DeRYjhHw3PZfhIdHQxW8mTEARHq?=
X-MS-Exchange-AntiSpam-MessageData-1: 7mlDJ4OzYNe0AA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 073c5787-d50d-45b5-4d7f-08da1993a563
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 19:11:55.3231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: btwYn5EOfsKaSAfxqNITYf7dEPriuHLyT29XCodhRFf0hDEmjDi10eh9eMMdE7txTweBdgAkDJJSyWi3kG2OZb5ZHxiT/Gq3+0Ad5KijG1s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB2027
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-08_07:2022-04-08,2022-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204080097
X-Proofpoint-ORIG-GUID: Dp5PojZrO0Sp17gmFL5UaBhRfKt75iBU
X-Proofpoint-GUID: Dp5PojZrO0Sp17gmFL5UaBhRfKt75iBU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 4/7/22 12:29, Sumit Saxena wrote:
> There are certain BSG commands which is to be completed
> by driver without involving firmware. These requests are termed
> as driver commands. This patch adds support for the same.
> 
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
>   drivers/scsi/mpi3mr/mpi3mr.h          |  16 +-
>   drivers/scsi/mpi3mr/mpi3mr_app.c      | 397 +++++++++++++++++++++++
>   drivers/scsi/mpi3mr/mpi3mr_debug.h    |  12 +-
>   drivers/scsi/mpi3mr/mpi3mr_fw.c       |  21 +-
>   drivers/scsi/mpi3mr/mpi3mr_os.c       |   3 +
>   include/uapi/scsi/mpi3mr/mpi3mr_bsg.h | 434 ++++++++++++++++++++++++++
>   6 files changed, 871 insertions(+), 12 deletions(-)
>   create mode 100644 include/uapi/scsi/mpi3mr/mpi3mr_bsg.h
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index f0515f929110..877b0925dbc5 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -89,7 +89,7 @@ extern int prot_mask;
>   /* Reserved Host Tag definitions */
>   #define MPI3MR_HOSTTAG_INVALID		0xFFFF
>   #define MPI3MR_HOSTTAG_INITCMDS		1
> -#define MPI3MR_HOSTTAG_IOCTLCMDS	2
> +#define MPI3MR_HOSTTAG_BSG_CMDS		2
>   #define MPI3MR_HOSTTAG_BLK_TMS		5
>   
>   #define MPI3MR_NUM_DEVRMCMD		16
> @@ -202,10 +202,10 @@ enum mpi3mr_iocstate {
>   enum mpi3mr_reset_reason {
>   	MPI3MR_RESET_FROM_BRINGUP = 1,
>   	MPI3MR_RESET_FROM_FAULT_WATCH = 2,
> -	MPI3MR_RESET_FROM_IOCTL = 3,
> +	MPI3MR_RESET_FROM_APP = 3,
>   	MPI3MR_RESET_FROM_EH_HOS = 4,
>   	MPI3MR_RESET_FROM_TM_TIMEOUT = 5,
> -	MPI3MR_RESET_FROM_IOCTL_TIMEOUT = 6,
> +	MPI3MR_RESET_FROM_APP_TIMEOUT = 6,
>   	MPI3MR_RESET_FROM_MUR_FAILURE = 7,
>   	MPI3MR_RESET_FROM_CTLR_CLEANUP = 8,
>   	MPI3MR_RESET_FROM_CIACTIV_FAULT = 9,
> @@ -698,6 +698,7 @@ struct scmd_priv {
>    * @chain_bitmap_sz: Chain buffer allocator bitmap size
>    * @chain_bitmap: Chain buffer allocator bitmap
>    * @chain_buf_lock: Chain buffer list lock
> + * @bsg_cmds: Command tracker for BSG command
>    * @host_tm_cmds: Command tracker for task management commands
>    * @dev_rmhs_cmds: Command tracker for device removal commands
>    * @evtack_cmds: Command tracker for event ack commands
> @@ -729,6 +730,10 @@ struct scmd_priv {
>    * @requested_poll_qcount: User requested poll queue count
>    * @bsg_dev: BSG device structure
>    * @bsg_queue: Request queue for BSG device
> + * @stop_bsgs: Stop BSG request flag
> + * @logdata_buf: Circular buffer to store log data entries
> + * @logdata_buf_idx: Index of entry in buffer to store
> + * @logdata_entry_sz: log data entry size
>    */
>   struct mpi3mr_ioc {
>   	struct list_head list;
> @@ -835,6 +840,7 @@ struct mpi3mr_ioc {
>   	void *chain_bitmap;
>   	spinlock_t chain_buf_lock;
>   
> +	struct mpi3mr_drv_cmd bsg_cmds;
>   	struct mpi3mr_drv_cmd host_tm_cmds;
>   	struct mpi3mr_drv_cmd dev_rmhs_cmds[MPI3MR_NUM_DEVRMCMD];
>   	struct mpi3mr_drv_cmd evtack_cmds[MPI3MR_NUM_EVTACKCMD];
> @@ -872,6 +878,10 @@ struct mpi3mr_ioc {
>   
>   	struct device *bsg_dev;
>   	struct request_queue *bsg_queue;
> +	u8 stop_bsgs;
> +	u8 *logdata_buf;
> +	u16 logdata_buf_idx;
> +	u16 logdata_entry_sz;
>   };
>   
>   /**
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
> index 9b6698525990..3136f5c5d164 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -9,6 +9,386 @@
>   
>   #include "mpi3mr.h"
>   #include <linux/bsg-lib.h>
> +#include <uapi/scsi/mpi3mr/mpi3mr_bsg.h>
> +
> +/**
> + * mpi3mr_bsg_verify_adapter - verify adapter number is valid
> + * @ioc_number: Adapter number
> + * @mriocpp: Pointer to hold per adapter instance
> + *
> + * This function checks whether given adapter number matches
> + * with an adapter id in the driver's list and if so fills
> + * pointer to the per adapter instance in mriocpp else set that
> + * to NULL.
> + *
> + * Return: Nothing.
> + */
> +static void mpi3mr_bsg_verify_adapter(int ioc_number,
> +	struct mpi3mr_ioc **mriocpp)
> +{
> +	struct mpi3mr_ioc *mrioc;
> +
> +	spin_lock(&mrioc_list_lock);
> +	list_for_each_entry(mrioc, &mrioc_list, list) {
> +		if (mrioc->id != ioc_number)
> +			continue;
> +		spin_unlock(&mrioc_list_lock);
> +		*mriocpp = mrioc;
> +		return;
> +	}
> +	spin_unlock(&mrioc_list_lock);
> +	*mriocpp = NULL;
> +}

Agree here with Hannes's comment. return struct mpi3mr_ioc * here.

> +
> +/**
> + * mpi3mr_enable_logdata - Handler for log data enable
> + * @mrioc: Adapter instance reference
> + * @job: BSG job reference
> + *
> + * This function enables log data caching in the driver if not
> + * already enabled and return the maximum number of log data
> + * entries that can be cached in the driver.
> + *
> + * Return: 0 on success and proper error codes on failure
> + */
> +static long mpi3mr_enable_logdata(struct mpi3mr_ioc *mrioc,
> +	struct bsg_job *job)
> +{
> +	long rval = -EINVAL;
> +	struct mpi3mr_logdata_enable logdata_enable;
> +
> +	if (mrioc->logdata_buf)
> +		goto copy_user_data;
> +
> +	mrioc->logdata_entry_sz =
> +	    (mrioc->reply_sz - (sizeof(struct mpi3_event_notification_reply) - 4))
> +	    + MPI3MR_BSG_LOGDATA_ENTRY_HEADER_SZ;
> +	mrioc->logdata_buf_idx = 0;
> +
> +	mrioc->logdata_buf = kcalloc(MPI3MR_BSG_LOGDATA_MAX_ENTRIES,
> +	    mrioc->logdata_entry_sz, GFP_KERNEL);
> +	if (!mrioc->logdata_buf)
> +		return -ENOMEM;
> +
> +copy_user_data:
> +	memset(&logdata_enable, 0, sizeof(logdata_enable));
> +	logdata_enable.max_entries =
> +	    MPI3MR_BSG_LOGDATA_MAX_ENTRIES;
> +	if (job->request_payload.payload_len >= sizeof(logdata_enable)) {
> +		sg_copy_from_buffer(job->request_payload.sg_list,
> +				    job->request_payload.sg_cnt,
> +				    &logdata_enable, sizeof(logdata_enable));
> +		rval = 0;
> +	}
> +	return rval;
> +}

Again, agree with Hannes on this code. very unusual coding style.

Please follow norm as described by Hannes already.

> +/**
> + * mpi3mr_get_logdata - Handler for get log data
> + * @mrioc: Adapter instance reference
> + * @job: BSG job pointer
> + * This function copies the log data entries to the user buffer
> + * when log caching is enabled in the driver.
> + *
> + * Return: 0 on success and proper error codes on failure
> + */
> +static long mpi3mr_get_logdata(struct mpi3mr_ioc *mrioc,
> +	struct bsg_job *job)
> +{
> +	u16 num_entries, sz, entry_sz = mrioc->logdata_entry_sz;
> +
> +	if ((!mrioc->logdata_buf) || (job->request_payload.payload_len < entry_sz))
> +		return -EINVAL;
> +
> +	num_entries = job->request_payload.payload_len / entry_sz;
> +	if (num_entries > MPI3MR_BSG_LOGDATA_MAX_ENTRIES)
> +		num_entries = MPI3MR_BSG_LOGDATA_MAX_ENTRIES;
> +	sz = num_entries * entry_sz;
> +
> +	if (job->request_payload.payload_len >= sz) {
> +		sg_copy_from_buffer(job->request_payload.sg_list,
> +				    job->request_payload.sg_cnt,
> +				    mrioc->logdata_buf, sz);
> +		return 0;
> +	}
> +	return -EINVAL;
> +}
> +
> +/**
> + * mpi3mr_get_all_tgt_info - Get all target information
> + * @mrioc: Adapter instance reference
> + * @job: BSG job reference
> + *
> + * This function copies the driver managed target devices device
> + * handle, persistent ID, bus ID and taret ID to the user
> + * provided buffer for the specific controller. This function
> + * also provides the number of devices managed by the driver for
> + * the specific controller.
> + *
> + * Return: 0 on success and proper error codes on failure
> + */
> +static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
> +	struct bsg_job *job)
> +{
> +	long rval = -EINVAL;
> +	u16 num_devices = 0, i = 0, size;
> +	unsigned long flags;
> +	struct mpi3mr_tgt_dev *tgtdev;
> +	struct mpi3mr_device_map_info *devmap_info = NULL;
> +	struct mpi3mr_all_tgt_info *alltgt_info = NULL;
> +	uint32_t min_entrylen = 0, kern_entrylen = 0, usr_entrylen = 0;
> +
> +	if (job->request_payload.payload_len < sizeof(u32)) {
> +		dprint_bsg_err(mrioc, "%s: invalid size argument\n",
> +		    __func__);
> +		return rval;
> +	}
> +
> +	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> +	list_for_each_entry(tgtdev, &mrioc->tgtdev_list, list)
> +		num_devices++;
> +	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
> +
> +	if ((job->request_payload.payload_len == sizeof(u32)) ||
> +		list_empty(&mrioc->tgtdev_list)) {
> +		sg_copy_from_buffer(job->request_payload.sg_list,
> +				    job->request_payload.sg_cnt,
> +				    &num_devices, sizeof(num_devices));
> +		return 0;
> +	}
> +
> +	kern_entrylen = (num_devices - 1) * sizeof(*devmap_info);
> +	size = sizeof(*alltgt_info) + kern_entrylen;
> +	alltgt_info = kzalloc(size, GFP_KERNEL);
> +	if (!alltgt_info)
> +		return -ENOMEM;
> +
> +	devmap_info = alltgt_info->dmi;
> +	memset((u8 *)devmap_info, 0xFF, (kern_entrylen + sizeof(*devmap_info)));
> +	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> +	list_for_each_entry(tgtdev, &mrioc->tgtdev_list, list) {
> +		if (i < num_devices) {
> +			devmap_info[i].handle = tgtdev->dev_handle;
> +			devmap_info[i].perst_id = tgtdev->perst_id;
> +			if (tgtdev->host_exposed && tgtdev->starget) {
> +				devmap_info[i].target_id = tgtdev->starget->id;
> +				devmap_info[i].bus_id =
> +				    tgtdev->starget->channel;
> +			}
> +			i++;
> +		}
> +	}
> +	num_devices = i;
> +	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
> +
> +	memcpy(&alltgt_info->num_devices, &num_devices, sizeof(num_devices));
> +
> +	usr_entrylen = (job->request_payload.payload_len - sizeof(u32)) / sizeof(*devmap_info);
> +	usr_entrylen *= sizeof(*devmap_info);
> +	min_entrylen = min(usr_entrylen, kern_entrylen);
> +	if (min_entrylen && (!memcpy(&alltgt_info->dmi, devmap_info, min_entrylen))) {
> +		dprint_bsg_err(mrioc, "%s:%d: device map info copy failed\n",
> +		    __func__, __LINE__);
> +		rval = -EFAULT;
> +		goto out;
> +	}
> +
> +	sg_copy_from_buffer(job->request_payload.sg_list,
> +			    job->request_payload.sg_cnt,
> +			    alltgt_info, job->request_payload.payload_len);
> +	rval = 0;
> +out:
> +	kfree(alltgt_info);
> +	return rval;
> +}
> +
> +/**
> + * mpi3mr_get_change_count - Get topology change count
> + * @mrioc: Adapter instance reference
> + * @job: BSG job reference
> + *
> + * This function copies the toplogy change count provided by the
> + * driver in events and cached in the driver to the user
> + * provided buffer for the specific controller.
> + *
> + * Return: 0 on success and proper error codes on failure
> + */
> +static long mpi3mr_get_change_count(struct mpi3mr_ioc *mrioc,
> +	struct bsg_job *job)
> +{
> +	long rval = -EINVAL;
> +	struct mpi3mr_change_count chgcnt;
> +
> +	memset(&chgcnt, 0, sizeof(chgcnt));
> +	chgcnt.change_count = mrioc->change_count;
> +	if (job->request_payload.payload_len >= sizeof(chgcnt)) {
> +		sg_copy_from_buffer(job->request_payload.sg_list,
> +				    job->request_payload.sg_cnt,
> +				    &chgcnt, sizeof(chgcnt));
> +		rval = 0;
> +	}
> +	return rval;
> +}
> +
> +/**
> + * mpi3mr_bsg_adp_reset - Issue controller reset
> + * @mrioc: Adapter instance reference
> + * @job: BSG job reference
> + *
> + * This function identifies the user provided reset type and
> + * issues approporiate reset to the controller and wait for that
> + * to complete and reinitialize the controller and then returns
> + *
> + * Return: 0 on success and proper error codes on failure
> + */
> +static long mpi3mr_bsg_adp_reset(struct mpi3mr_ioc *mrioc,
> +	struct bsg_job *job)
> +{
> +	long rval = -EINVAL;
> +	u8 save_snapdump;
> +	struct mpi3mr_bsg_adp_reset adpreset;
> +
> +	if (job->request_payload.payload_len !=
> +			sizeof(adpreset)) {
> +		dprint_bsg_err(mrioc, "%s: invalid size argument\n",
> +		    __func__);
> +		goto out;
> +	}
> +
> +	sg_copy_to_buffer(job->request_payload.sg_list,
> +			  job->request_payload.sg_cnt,
> +			  &adpreset, sizeof(adpreset));
> +
> +	switch (adpreset.reset_type) {
> +	case MPI3MR_BSG_ADPRESET_SOFT:
> +		save_snapdump = 0;
> +		break;
> +	case MPI3MR_BSG_ADPRESET_DIAG_FAULT:
> +		save_snapdump = 1;
> +		break;
> +	default:
> +		dprint_bsg_err(mrioc, "%s: unknown reset_type(%d)\n",
> +		    __func__, adpreset.reset_type);
> +		goto out;
> +	}
> +
> +	rval = mpi3mr_soft_reset_handler(mrioc, MPI3MR_RESET_FROM_APP,
> +	    save_snapdump);
> +
> +	if (rval)
> +		dprint_bsg_err(mrioc,
> +		    "%s: reset handler returned error(%ld) for reset type %d\n",
> +		    __func__, rval, adpreset.reset_type);
> +out:
> +	return rval;
> +}
> +
> +/**
> + * mpi3mr_bsg_populate_adpinfo - Get adapter info command handler
> + * @mrioc: Adapter instance reference
> + * @job: BSG job reference
> + *
> + * This function provides adapter information for the given
> + * controller
> + *
> + * Return: 0 on success and proper error codes on failure
> + */
> +static long mpi3mr_bsg_populate_adpinfo(struct mpi3mr_ioc *mrioc,
> +	struct bsg_job *job)
> +{
> +	enum mpi3mr_iocstate ioc_state;
> +	struct mpi3mr_bsg_in_adpinfo adpinfo;
> +
> +	memset(&adpinfo, 0, sizeof(adpinfo));
> +	adpinfo.adp_type = MPI3MR_BSG_ADPTYPE_AVGFAMILY;
> +	adpinfo.pci_dev_id = mrioc->pdev->device;
> +	adpinfo.pci_dev_hw_rev = mrioc->pdev->revision;
> +	adpinfo.pci_subsys_dev_id = mrioc->pdev->subsystem_device;
> +	adpinfo.pci_subsys_ven_id = mrioc->pdev->subsystem_vendor;
> +	adpinfo.pci_bus = mrioc->pdev->bus->number;
> +	adpinfo.pci_dev = PCI_SLOT(mrioc->pdev->devfn);
> +	adpinfo.pci_func = PCI_FUNC(mrioc->pdev->devfn);
> +	adpinfo.pci_seg_id = pci_domain_nr(mrioc->pdev->bus);
> +	adpinfo.app_intfc_ver = MPI3MR_IOCTL_VERSION;
> +
> +	ioc_state = mpi3mr_get_iocstate(mrioc);
> +	if (ioc_state == MRIOC_STATE_UNRECOVERABLE)
> +		adpinfo.adp_state = MPI3MR_BSG_ADPSTATE_UNRECOVERABLE;
> +	else if ((mrioc->reset_in_progress) || (mrioc->stop_bsgs))
> +		adpinfo.adp_state = MPI3MR_BSG_ADPSTATE_IN_RESET;
> +	else if (ioc_state == MRIOC_STATE_FAULT)
> +		adpinfo.adp_state = MPI3MR_BSG_ADPSTATE_FAULT;
> +	else
> +		adpinfo.adp_state = MPI3MR_BSG_ADPSTATE_OPERATIONAL;
> +
> +	memcpy((u8 *)&adpinfo.driver_info, (u8 *)&mrioc->driver_info,
> +	    sizeof(adpinfo.driver_info));
> +
> +	if (job->request_payload.payload_len >= sizeof(adpinfo)) {
> +		sg_copy_from_buffer(job->request_payload.sg_list,
> +				    job->request_payload.sg_cnt,
> +				    &adpinfo, sizeof(adpinfo));
> +		return 0;
> +	}
> +	return -EINVAL;
> +}
> +
> +/**
> + * mpi3mr_bsg_process_drv_cmds - Driver Command handler
> + * @job: BSG job reference
> + *
> + * This function is the top level handler for driver commands,
> + * this does basic validation of the buffer and identifies the
> + * opcode and switches to correct sub handler.
> + *
> + * Return: 0 on success and proper error codes on failure
> + */
> +static long mpi3mr_bsg_process_drv_cmds(struct bsg_job *job)
> +{
> +	long rval = -EINVAL;
> +	struct mpi3mr_ioc *mrioc = NULL;
> +	struct mpi3mr_bsg_packet *bsg_req = NULL;
> +	struct mpi3mr_bsg_drv_cmd *drvrcmd = NULL;
> +
> +	bsg_req = job->request;
> +	drvrcmd = &bsg_req->cmd.drvrcmd;
> +
> +	mpi3mr_bsg_verify_adapter(drvrcmd->mrioc_id, &mrioc);
> +	if (!mrioc)
> +		return -ENODEV;
> +
> +	if (drvrcmd->opcode == MPI3MR_DRVBSG_OPCODE_ADPINFO) {
> +		rval = mpi3mr_bsg_populate_adpinfo(mrioc, job);
> +		return rval;
> +	}
> +
> +	if (mutex_lock_interruptible(&mrioc->bsg_cmds.mutex))
> +		return -ERESTARTSYS;
> +
> +	switch (drvrcmd->opcode) {
> +	case MPI3MR_DRVBSG_OPCODE_ADPRESET:
> +		rval = mpi3mr_bsg_adp_reset(mrioc, job);
> +		break;
> +	case MPI3MR_DRVBSG_OPCODE_ALLTGTDEVINFO:
> +		rval = mpi3mr_get_all_tgt_info(mrioc, job);
> +		break;
> +	case MPI3MR_DRVBSG_OPCODE_GETCHGCNT:
> +		rval = mpi3mr_get_change_count(mrioc, job);
> +		break;
> +	case MPI3MR_DRVBSG_OPCODE_LOGDATAENABLE:
> +		rval = mpi3mr_enable_logdata(mrioc, job);
> +		break;
> +	case MPI3MR_DRVBSG_OPCODE_GETLOGDATA:
> +		rval = mpi3mr_get_logdata(mrioc, job);
> +		break;
> +	case MPI3MR_DRVBSG_OPCODE_UNKNOWN:
> +	default:
> +		pr_err("%s: unsupported driver command opcode %d\n",
> +		    MPI3MR_DRIVER_NAME, drvrcmd->opcode);
> +		break;
> +	}
> +	mutex_unlock(&mrioc->bsg_cmds.mutex);
> +	return rval;
> +}
>   
>   /**
>    * mpi3mr_bsg_request - bsg request entry point
> @@ -20,6 +400,23 @@
>    */
>   int mpi3mr_bsg_request(struct bsg_job *job)
>   {
> +	long rval = -EINVAL;
> +	unsigned int reply_payload_rcv_len = 0;
> +
> +	struct mpi3mr_bsg_packet *bsg_req = job->request;
> +
> +	switch (bsg_req->cmd_type) {
> +	case MPI3MR_DRV_CMD:
> +		rval = mpi3mr_bsg_process_drv_cmds(job);
> +		break;
> +	default:
> +		pr_err("%s: unsupported BSG command(0x%08x)\n",
> +		    MPI3MR_DRIVER_NAME, bsg_req->cmd_type);
> +		break;
> +	}
> +
> +	bsg_job_done(job, rval, reply_payload_rcv_len);
> +
>   	return 0;
>   }
>   
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_debug.h b/drivers/scsi/mpi3mr/mpi3mr_debug.h
> index c7982443f45a..65bfac72948c 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_debug.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr_debug.h
> @@ -23,8 +23,8 @@
>   #define MPI3_DEBUG_RESET		0x00000020
>   #define MPI3_DEBUG_SCSI_ERROR		0x00000040
>   #define MPI3_DEBUG_REPLY		0x00000080
> -#define MPI3_DEBUG_IOCTL_ERROR		0x00008000
> -#define MPI3_DEBUG_IOCTL_INFO		0x00010000
> +#define MPI3_DEBUG_BSG_ERROR		0x00008000
> +#define MPI3_DEBUG_BSG_INFO		0x00010000
>   #define MPI3_DEBUG_SCSI_INFO		0x00020000
>   #define MPI3_DEBUG			0x01000000
>   #define MPI3_DEBUG_SG			0x02000000
> @@ -110,15 +110,15 @@
>   	} while (0)
>   
>   
> -#define dprint_ioctl_info(ioc, fmt, ...) \
> +#define dprint_bsg_info(ioc, fmt, ...) \
>   	do { \
> -		if (ioc->logging_level & MPI3_DEBUG_IOCTL_INFO) \
> +		if (ioc->logging_level & MPI3_DEBUG_BSG_INFO) \
>   			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
>   	} while (0)
>   
> -#define dprint_ioctl_err(ioc, fmt, ...) \
> +#define dprint_bsg_err(ioc, fmt, ...) \
>   	do { \
> -		if (ioc->logging_level & MPI3_DEBUG_IOCTL_ERROR) \
> +		if (ioc->logging_level & MPI3_DEBUG_BSG_ERROR) \
>   			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
>   	} while (0)
>   
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> index e25c02466043..480730721f50 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -297,6 +297,8 @@ mpi3mr_get_drv_cmd(struct mpi3mr_ioc *mrioc, u16 host_tag,
>   	switch (host_tag) {
>   	case MPI3MR_HOSTTAG_INITCMDS:
>   		return &mrioc->init_cmds;
> +	case MPI3MR_HOSTTAG_BSG_CMDS:
> +		return &mrioc->bsg_cmds;
>   	case MPI3MR_HOSTTAG_BLK_TMS:
>   		return &mrioc->host_tm_cmds;
>   	case MPI3MR_HOSTTAG_INVALID:
> @@ -865,10 +867,10 @@ static const struct {
>   } mpi3mr_reset_reason_codes[] = {
>   	{ MPI3MR_RESET_FROM_BRINGUP, "timeout in bringup" },
>   	{ MPI3MR_RESET_FROM_FAULT_WATCH, "fault" },
> -	{ MPI3MR_RESET_FROM_IOCTL, "application invocation" },
> +	{ MPI3MR_RESET_FROM_APP, "application invocation" },
>   	{ MPI3MR_RESET_FROM_EH_HOS, "error handling" },
>   	{ MPI3MR_RESET_FROM_TM_TIMEOUT, "TM timeout" },
> -	{ MPI3MR_RESET_FROM_IOCTL_TIMEOUT, "IOCTL timeout" },
> +	{ MPI3MR_RESET_FROM_APP_TIMEOUT, "application command timeout" },
>   	{ MPI3MR_RESET_FROM_MUR_FAILURE, "MUR failure" },
>   	{ MPI3MR_RESET_FROM_CTLR_CLEANUP, "timeout in controller cleanup" },
>   	{ MPI3MR_RESET_FROM_CIACTIV_FAULT, "component image activation fault" },
> @@ -2813,6 +2815,10 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
>   	if (!mrioc->init_cmds.reply)
>   		goto out_failed;
>   
> +	mrioc->bsg_cmds.reply = kzalloc(mrioc->reply_sz, GFP_KERNEL);
> +	if (!mrioc->bsg_cmds.reply)
> +		goto out_failed;
> +
>   	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++) {
>   		mrioc->dev_rmhs_cmds[i].reply = kzalloc(mrioc->reply_sz,
>   		    GFP_KERNEL);
> @@ -3948,6 +3954,8 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
>   
>   	if (mrioc->init_cmds.reply) {
>   		memset(mrioc->init_cmds.reply, 0, sizeof(*mrioc->init_cmds.reply));
> +		memset(mrioc->bsg_cmds.reply, 0,
> +		    sizeof(*mrioc->bsg_cmds.reply));
>   		memset(mrioc->host_tm_cmds.reply, 0,
>   		    sizeof(*mrioc->host_tm_cmds.reply));
>   		for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++)
> @@ -4050,6 +4058,9 @@ void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
>   	kfree(mrioc->init_cmds.reply);
>   	mrioc->init_cmds.reply = NULL;
>   
> +	kfree(mrioc->bsg_cmds.reply);
> +	mrioc->bsg_cmds.reply = NULL;
> +
>   	kfree(mrioc->host_tm_cmds.reply);
>   	mrioc->host_tm_cmds.reply = NULL;
>   
> @@ -4235,6 +4246,8 @@ static void mpi3mr_flush_drv_cmds(struct mpi3mr_ioc *mrioc)
>   
>   	cmdptr = &mrioc->init_cmds;
>   	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
> +	cmdptr = &mrioc->bsg_cmds;
> +	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
>   	cmdptr = &mrioc->host_tm_cmds;
>   	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
>   
> @@ -4258,7 +4271,7 @@ static void mpi3mr_flush_drv_cmds(struct mpi3mr_ioc *mrioc)
>    * This is an handler for recovering controller by issuing soft
>    * reset are diag fault reset.  This is a blocking function and
>    * when one reset is executed if any other resets they will be
> - * blocked. All IOCTLs/IO will be blocked during the reset. If
> + * blocked. All BSG requests will be blocked during the reset. If
>    * controller reset is successful then the controller will be
>    * reinitalized, otherwise the controller will be marked as not
>    * recoverable
> @@ -4305,6 +4318,7 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
>   	    mpi3mr_reset_rc_name(reset_reason));
>   
>   	mrioc->reset_in_progress = 1;
> +	mrioc->stop_bsgs = 1;
>   	mrioc->prev_reset_result = -1;
>   
>   	if ((!snapdump) && (reset_reason != MPI3MR_RESET_FROM_FAULT_WATCH) &&
> @@ -4377,6 +4391,7 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
>   			    &mrioc->watchdog_work,
>   			    msecs_to_jiffies(MPI3MR_WATCHDOG_INTERVAL));
>   		spin_unlock_irqrestore(&mrioc->watchdog_lock, flags);
> +		mrioc->stop_bsgs = 0;
>   	} else {
>   		mpi3mr_issue_reset(mrioc,
>   		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT, reset_reason);
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index faf14a5f9123..a03e39083a42 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -3589,6 +3589,7 @@ static int mpi3mr_scan_finished(struct Scsi_Host *shost,
>   
>   	mpi3mr_start_watchdog(mrioc);
>   	mrioc->is_driver_loading = 0;
> +	mrioc->stop_bsgs = 0;
>   	return 1;
>   }
>   
> @@ -4259,6 +4260,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   	mutex_init(&mrioc->reset_mutex);
>   	mpi3mr_init_drv_cmd(&mrioc->init_cmds, MPI3MR_HOSTTAG_INITCMDS);
>   	mpi3mr_init_drv_cmd(&mrioc->host_tm_cmds, MPI3MR_HOSTTAG_BLK_TMS);
> +	mpi3mr_init_drv_cmd(&mrioc->bsg_cmds, MPI3MR_HOSTTAG_BSG_CMDS);
>   
>   	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++)
>   		mpi3mr_init_drv_cmd(&mrioc->dev_rmhs_cmds[i],
> @@ -4271,6 +4273,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   	mrioc->logging_level = logging_level;
>   	mrioc->shost = shost;
>   	mrioc->pdev = pdev;
> +	mrioc->stop_bsgs = 1;
>   
>   	/* init shost parameters */
>   	shost->max_cmd_len = MPI3MR_MAX_CDB_LENGTH;
> diff --git a/include/uapi/scsi/mpi3mr/mpi3mr_bsg.h b/include/uapi/scsi/mpi3mr/mpi3mr_bsg.h
> new file mode 100644
> index 000000000000..7535a9353807
> --- /dev/null
> +++ b/include/uapi/scsi/mpi3mr/mpi3mr_bsg.h
> @@ -0,0 +1,434 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Driver for Broadcom MPI3 Storage Controllers
> + *
> + * Copyright (C) 2017-2022 Broadcom Inc.
> + *  (mailto: mpi3mr-linuxdrv.pdl@broadcom.com)
> + *
> + */
> +
> +#ifndef MPI3MR_BSG_H_INCLUDED
> +#define MPI3MR_BSG_H_INCLUDED
> +
> +
> +/* Definitions for BSG commands */
> +#define MPI3MR_IOCTL_VERSION			0x06
> +
> +#define MPI3MR_APP_DEFAULT_TIMEOUT		(60) /*seconds*/
> +
> +#define MPI3MR_BSG_ADPTYPE_UNKNOWN		0
> +#define MPI3MR_BSG_ADPTYPE_AVGFAMILY		1
> +
> +#define MPI3MR_BSG_ADPSTATE_UNKNOWN		0
> +#define MPI3MR_BSG_ADPSTATE_OPERATIONAL		1
> +#define MPI3MR_BSG_ADPSTATE_FAULT		2
> +#define MPI3MR_BSG_ADPSTATE_IN_RESET		3
> +#define MPI3MR_BSG_ADPSTATE_UNRECOVERABLE	4
> +
> +#define MPI3MR_BSG_ADPRESET_UNKNOWN		0
> +#define MPI3MR_BSG_ADPRESET_SOFT		1
> +#define MPI3MR_BSG_ADPRESET_DIAG_FAULT		2
> +
> +#define MPI3MR_BSG_LOGDATA_MAX_ENTRIES		400
> +#define MPI3MR_BSG_LOGDATA_ENTRY_HEADER_SZ	4
> +
> +#define MPI3MR_DRVBSG_OPCODE_UNKNOWN		0
> +#define MPI3MR_DRVBSG_OPCODE_ADPINFO		1
> +#define MPI3MR_DRVBSG_OPCODE_ADPRESET		2
> +#define MPI3MR_DRVBSG_OPCODE_ALLTGTDEVINFO	4
> +#define MPI3MR_DRVBSG_OPCODE_GETCHGCNT		5
> +#define MPI3MR_DRVBSG_OPCODE_LOGDATAENABLE	6
> +#define MPI3MR_DRVBSG_OPCODE_PELENABLE		7
> +#define MPI3MR_DRVBSG_OPCODE_GETLOGDATA		8
> +#define MPI3MR_DRVBSG_OPCODE_QUERY_HDB		9
> +#define MPI3MR_DRVBSG_OPCODE_REPOST_HDB		10
> +#define MPI3MR_DRVBSG_OPCODE_UPLOAD_HDB		11
> +#define MPI3MR_DRVBSG_OPCODE_REFRESH_HDB_TRIGGERS	12
> +
> +
> +#define MPI3MR_BSG_BUFTYPE_UNKNOWN		0
> +#define MPI3MR_BSG_BUFTYPE_RAIDMGMT_CMD		1
> +#define MPI3MR_BSG_BUFTYPE_RAIDMGMT_RESP	2
> +#define MPI3MR_BSG_BUFTYPE_DATA_IN		3
> +#define MPI3MR_BSG_BUFTYPE_DATA_OUT		4
> +#define MPI3MR_BSG_BUFTYPE_MPI_REPLY		5
> +#define MPI3MR_BSG_BUFTYPE_ERR_RESPONSE		6
> +#define MPI3MR_BSG_BUFTYPE_MPI_REQUEST		0xFE
> +
> +#define MPI3MR_BSG_MPI_REPLY_BUFTYPE_UNKNOWN	0
> +#define MPI3MR_BSG_MPI_REPLY_BUFTYPE_STATUS	1
> +#define MPI3MR_BSG_MPI_REPLY_BUFTYPE_ADDRESS	2
> +
> +#define MPI3MR_HDB_BUFTYPE_UNKNOWN		0
> +#define MPI3MR_HDB_BUFTYPE_TRACE		1
> +#define MPI3MR_HDB_BUFTYPE_FIRMWARE		2
> +#define MPI3MR_HDB_BUFTYPE_RESERVED		3
> +
> +#define MPI3MR_HDB_BUFSTATUS_UNKNOWN		0
> +#define MPI3MR_HDB_BUFSTATUS_NOT_ALLOCATED	1
> +#define MPI3MR_HDB_BUFSTATUS_POSTED_UNPAUSED	2
> +#define MPI3MR_HDB_BUFSTATUS_POSTED_PAUSED	3
> +#define MPI3MR_HDB_BUFSTATUS_RELEASED		4
> +
> +#define MPI3MR_HDB_TRIGGER_TYPE_UNKNOWN		0
> +#define MPI3MR_HDB_TRIGGER_TYPE_DIAGFAULT	1
> +#define MPI3MR_HDB_TRIGGER_TYPE_ELEMENT		2
> +#define MPI3MR_HDB_TRIGGER_TYPE_MASTER		3
> +
> +
> +/* Supported BSG commands */
> +enum command {
> +	MPI3MR_DRV_CMD = 1,
> +	MPI3MR_MPT_CMD = 2,
> +};
> +
> +/**
> + * struct mpi3mr_bsg_in_adpinfo - Adapter information request
> + * data returned by the driver.
> + *
> + * @adp_type: Adapter type
> + * @rsvd1: Reserved
> + * @pci_dev_id: PCI device ID of the adapter
> + * @pci_dev_hw_rev: PCI revision of the adapter
> + * @pci_subsys_dev_id: PCI subsystem device ID of the adapter
> + * @pci_subsys_ven_id: PCI subsystem vendor ID of the adapter
> + * @pci_dev: PCI device
> + * @pci_func: PCI function
> + * @pci_bus: PCI bus
> + * @rsvd2: Reserved
> + * @pci_seg_id: PCI segment ID
> + * @app_intfc_ver: version of the application interface definition
> + * @rsvd3: Reserved
> + * @rsvd4: Reserved
> + * @rsvd5: Reserved
> + * @driver_info: Driver Information (Version/Name)
> + */
> +struct mpi3mr_bsg_in_adpinfo {
> +	uint32_t adp_type;
> +	uint32_t rsvd1;
> +	uint32_t pci_dev_id;
> +	uint32_t pci_dev_hw_rev;
> +	uint32_t pci_subsys_dev_id;
> +	uint32_t pci_subsys_ven_id;
> +	uint32_t pci_dev:5;
> +	uint32_t pci_func:3;
> +	uint32_t pci_bus:8;
> +	uint16_t rsvd2;
> +	uint32_t pci_seg_id;
> +	uint32_t app_intfc_ver;
> +	uint8_t adp_state;
> +	uint8_t rsvd3;
> +	uint16_t rsvd4;
> +	uint32_t rsvd5[2];
> +	struct mpi3_driver_info_layout driver_info;
> +};
> +
> +/**
> + * struct mpi3mr_bsg_adp_reset - Adapter reset request
> + * payload data to the driver.
> + *
> + * @reset_type: Reset type
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + */
> +struct mpi3mr_bsg_adp_reset {
> +	uint8_t reset_type;
> +	uint8_t rsvd1;
> +	uint16_t rsvd2;
> +};
> +
> +/**
> + * struct mpi3mr_change_count - Topology change count
> + * returned by the driver.
> + *
> + * @change_count: Topology change count
> + * @rsvd: Reserved
> + */
> +struct mpi3mr_change_count {
> +	uint16_t change_count;
> +	uint16_t rsvd;
> +};
> +
> +/**
> + * struct mpi3mr_device_map_info - Target device mapping
> + * information
> + *
> + * @handle: Firmware device handle
> + * @perst_id: Persistent ID assigned by the firmware
> + * @target_id: Target ID assigned by the driver
> + * @bus_id: Bus ID assigned by the driver
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + */
> +struct mpi3mr_device_map_info {
> +	uint16_t handle;
> +	uint16_t perst_id;
> +	uint32_t target_id;
> +	uint8_t bus_id;
> +	uint8_t rsvd1;
> +	uint16_t rsvd2;
> +};
> +
> +/**
> + * struct mpi3mr_all_tgt_info - Target device mapping
> + * information returned by the driver
> + *
> + * @num_devices: The number of devices in driver's inventory
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + * @dmi: Variable length array of mapping information of targets
> + */
> +struct mpi3mr_all_tgt_info {
> +	uint16_t num_devices;
> +	uint16_t rsvd1;
> +	uint32_t rsvd2;
> +	struct mpi3mr_device_map_info dmi[1];
> +};
> +
> +/**
> + * struct mpi3mr_logdata_enable - Number of log data
> + * entries saved by the driver returned as payload data for
> + * enable logdata BSG request by the driver.
> + *
> + * @max_entries: Number of log data entries cached by the driver
> + * @rsvd: Reserved
> + */
> +struct mpi3mr_logdata_enable {
> +	uint16_t max_entries;
> +	uint16_t rsvd;
> +};
> +
> +/**
> + * struct mpi3mr_bsg_out_pel_enable - PEL enable request payload
> + * data to the driver.
> + *
> + * @pel_locale: PEL locale to the firmware
> + * @pel_class: PEL class to the firmware
> + * @rsvd: Reserved
> + */
> +struct mpi3mr_bsg_out_pel_enable {
> +	uint16_t pel_locale;
> +	uint8_t pel_class;
> +	uint8_t rsvd;
> +};
> +
> +/**
> + * struct mpi3mr_logdata_entry - Log data entry cached by the
> + * driver.
> + *
> + * @valid_entry: Is the entry valid
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + * @data: Variable length Log entry data
> + */
> +struct mpi3mr_logdata_entry {
> +	uint8_t valid_entry;
> +	uint8_t rsvd1;
> +	uint16_t rsvd2;
> +	uint8_t data[1]; /* Variable length Array */
> +};
> +
> +/**
> + * struct mpi3mr_bsg_in_log_data - Log data entries saved by
> + * the driver returned as payload data for Get logdata request
> + * by the driver.
> + *
> + * @entry: Variable length Log data entry array
> + */
> +struct mpi3mr_bsg_in_log_data {
> +	struct mpi3mr_logdata_entry entry[1];
> +};
> +
> +/**
> + * struct mpi3mr_hdb_entry - host diag buffer entry.
> + *
> + * @buf_type: Buffer type
> + * @status: Buffer status
> + * @trigger_type: Trigger type
> + * @rsvd1: Reserved
> + * @size: Buffer size
> + * @rsvd2: Reserved
> + * @trigger_data: Trigger specific data
> + * @rsvd3: Reserved
> + * @rsvd4: Reserved
> + */
> +struct mpi3mr_hdb_entry {
> +	uint8_t buf_type;
> +	uint8_t status;
> +	uint8_t trigger_type;
> +	uint8_t rsvd1;
> +	uint16_t size;
> +	uint16_t rsvd2;
> +	uint64_t trigger_data;
> +	uint32_t rsvd3;
> +	uint32_t rsvd4;
> +};
> +
> +
> +/**
> + * struct mpi3mr_bsg_in_hdb_status - This structure contains
> + * return data for the BSG request to retrieve the number of host
> + * diagnostic buffers supported by the driver and their current
> + * status and additional status specific data if any in forms of
> + * multiple hdb entries.
> + *
> + * @num_hdb_types: Number of host diag buffer types supported
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + * @rsvd3: Reserved
> + * @entry: Variable length Diag buffer status entry array
> + */
> +struct mpi3mr_bsg_in_hdb_status {
> +	uint8_t num_hdb_types;
> +	uint8_t rsvd1;
> +	uint16_t rsvd2;
> +	uint32_t rsvd3;
> +	struct mpi3mr_hdb_entry entry[1];
> +};
> +
> +/**
> + * struct mpi3mr_bsg_out_repost_hdb - Repost host diagnostic
> + * buffer request payload data to the driver.
> + *
> + * @buf_type: Buffer type
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + */
> +struct mpi3mr_bsg_out_repost_hdb {
> +	uint8_t buf_type;
> +	uint8_t rsvd1;
> +	uint16_t rsvd2;
> +};
> +
> +/**
> + * struct mpi3mr_bsg_out_upload_hdb - Upload host diagnostic
> + * buffer request payload data to the driver.
> + *
> + * @buf_type: Buffer type
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + * @start_offset: Start offset of the buffer from where to copy
> + * @length: Length of the buffer to copy
> + */
> +struct mpi3mr_bsg_out_upload_hdb {
> +	uint8_t buf_type;
> +	uint8_t rsvd1;
> +	uint16_t rsvd2;
> +	uint32_t start_offset;
> +	uint32_t length;
> +};
> +
> +/**
> + * struct mpi3mr_bsg_out_refresh_hdb_triggers - Refresh host
> + * diagnostic buffer triggers request payload data to the driver.
> + *
> + * @page_type: Page type
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + */
> +struct mpi3mr_bsg_out_refresh_hdb_triggers {
> +	uint8_t page_type;
> +	uint8_t rsvd1;
> +	uint16_t rsvd2;
> +};
> +/**
> + * struct mpi3mr_bsg_drv_cmd -  Generic bsg data
> + * structure for all driver specific requests.
> + *
> + * @mrioc_id: Controller ID
> + * @opcode: Driver specific opcode
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + */
> +struct mpi3mr_bsg_drv_cmd {
> +	uint8_t mrioc_id;
> +	uint8_t opcode;
> +	uint16_t rsvd1;
> +	uint32_t rsvd2[4];
> +};
> +/**
> + * struct mpi3mr_bsg_in_reply_buf - MPI reply buffer returned
> + * for MPI Passthrough request .
> + *
> + * @mpi_reply_type: Type of MPI reply
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + * @reply_buf: Variable Length buffer based on mpirep type
> + */
> +struct mpi3mr_bsg_in_reply_buf {
> +	uint8_t mpi_reply_type;
> +	uint8_t rsvd1;
> +	uint16_t rsvd2;
> +	uint8_t reply_buf[1];
> +};
> +
> +/**
> + * struct mpi3mr_buf_entry - User buffer descriptor for MPI
> + * Passthrough requests.
> + *
> + * @buf_type: Buffer type
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + * @buf_len: Buffer length
> + */
> +struct mpi3mr_buf_entry {
> +	uint8_t buf_type;
> +	uint8_t rsvd1;
> +	uint16_t rsvd2;
> +	uint32_t buf_len;
> +};
> +/**
> + * struct mpi3mr_bsg_buf_entry_list - list of user buffer
> + * descriptor for MPI Passthrough requests.
> + *
> + * @num_of_entries: Number of buffer descriptors
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + * @rsvd3: Reserved
> + * @buf_entry: Variable length array of buffer descriptors
> + */
> +struct mpi3mr_buf_entry_list {
> +	uint8_t num_of_entries;
> +	uint8_t rsvd1;
> +	uint16_t rsvd2;
> +	uint32_t rsvd3;
> +	struct mpi3mr_buf_entry buf_entry[1];
> +};
> +/**
> + * struct mpi3mr_bsg_mptcmd -  Generic bsg data
> + * structure for all MPI Passthrough requests .
> + *
> + * @mrioc_id: Controller ID
> + * @rsvd1: Reserved
> + * @timeout: MPI request timeout
> + * @buf_entry_list: Buffer descriptor list
> + */
> +struct mpi3mr_bsg_mptcmd {
> +	uint8_t mrioc_id;
> +	uint8_t rsvd1;
> +	uint16_t timeout;
> +	uint32_t rsvd2;
> +	struct mpi3mr_buf_entry_list buf_entry_list;
> +};
> +
> +/**
> + * struct mpi3mr_bsg_packet -  Generic bsg data
> + * structure for all supported requests .
> + *
> + * @cmd_type: represents drvrcmd or mptcmd
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + * @drvrcmd: driver request structure
> + * @mptcmd: mpt request structure
> + */
> +struct mpi3mr_bsg_packet {
> +	uint8_t cmd_type;
> +	uint8_t rsvd1;
> +	uint16_t rsvd2;
> +	uint32_t rsvd3;
> +	union {
> +		struct mpi3mr_bsg_drv_cmd drvrcmd;
> +		struct mpi3mr_bsg_mptcmd mptcmd;
> +	} cmd;
> +};
> +#endif
> 

-- 
Himanshu Madhani                                Oracle Linux Engineering
