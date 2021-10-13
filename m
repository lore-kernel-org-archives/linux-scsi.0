Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90A06C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 15:09:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7545B610E6
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 15:09:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbhJMPLO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 11:11:14 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:14862 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230057AbhJMPLN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Oct 2021 11:11:13 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19DEUAur023790;
        Wed, 13 Oct 2021 15:09:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=fkaml0W/viOW0BtebkwPhSB1qzoLXiQ7kjGYKVwOmKA=;
 b=bpmVCvlVVN8CRuhUyO+nWPR4LGTeQSPC3qNpIkpRRTKz0FLXynVKL+UpATOfwM8EkYqk
 hk+rjY7+G7PMsuOnb9EFwk/hY9gdyRPa/wE8tnqcdDhMB2jNFTJdSYTVTk+T45CVEPwJ
 5VBJEuA4QAnY1h4V+SMzeWv4oWYJxfFA2cI6rlvRCvhk7qgzPV9ZK4PYXFCSyCYPfCT3
 bgA/dqbHHrLS+xtudSYi6fWUC1rDROPfbNzFrJ4jyvk/+KGRUdq9cvTMlTtFQCrrla//
 MaPx5TyA2yeelbOpHkh/f5kLE8t82HoMptnv1OvOMWJ5xX1495SdkTjjuYBM26Ddyhhp Tg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bnkbmvph9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 15:09:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19DF5ApG007678;
        Wed, 13 Oct 2021 15:09:05 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by userp3030.oracle.com with ESMTP id 3bkyvaxpqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 15:09:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G4LcvbbiV8R+pwaqYoXgP5lZbkaf+16J1ufR4y7HoQTlGsCBND7qNh1vQW7UyKw/Rme5t8ghPofqaDjv/wZJDx7TDrBoq6AfemwfCuR6398HP0sab05dQy24L3itmlGiTj441Ot8Unt5ISzUk62qvd/CStcdV8XPBZawGaXlUtzpCvmyqYst0PZ9pe3aAcs690pvkhX9SQIdfVVJM2bxAhJIi4CwQEGJpdWeOqAx1r/rSFDwtUpMdzcek8GPEbm9+xxYQCvFVxG+qw4WHtmUE+Xe9fCY5yUg39q8mvDtcWr2DRAp5R8Txxj0QAn3P8l6PgGOUoeHy0+H3Itf/1vM7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fkaml0W/viOW0BtebkwPhSB1qzoLXiQ7kjGYKVwOmKA=;
 b=UZcgyYQwx+WvMZF2VyFRhNmV0GhFyKm7BEn6O+dmVUkMX0VrAnv39zMi6UMay4AreT9A9q0NxRkdGHtLN4n1DSi5M0r29WIyi7Y+G42kkIg30qb2sI0IvyhdGBloHDLvIqvDcO+PhY9ngAl+eiotc2PpB3DM4TgtpWxFu+4wBn3jM8Pss3b1y/vwklFryimn3QGT3PojfoP1IhNV6ftcRUN9znq6CZpspfXmfgd3+VNCuIJO8kncYruaZOyIFSPVnjt9eXXFYgUIANmx6q5/PfUxHAl7hmwzLUS9oq8+YJ2Ka8HdYPKwHNRMrGf8OXwumi9SF7Ripr7KAh1nPzrT3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fkaml0W/viOW0BtebkwPhSB1qzoLXiQ7kjGYKVwOmKA=;
 b=DHWBgJz7+QWXXiMnBSHqyy2H2icykusZ1qFxrE8dqzkXb/MwPq6UaStXS+Ba7D30V7b8Z7Jg2AyL664oiqKkyK7xBATPfV50vrwv6jNqFgbeDAuclzmRp6+CIaRqCpGIf/qk50IO6YzPTyPK82ScdB0ndyD+1rE4CZ8rLy7hI7E=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2934.namprd10.prod.outlook.com (2603:10b6:a03:85::22)
 by BYAPR10MB2631.namprd10.prod.outlook.com (2603:10b6:a02:ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.24; Wed, 13 Oct
 2021 15:09:03 +0000
Received: from BYAPR10MB2934.namprd10.prod.outlook.com
 ([fe80::a835:7e9d:bf65:47d7]) by BYAPR10MB2934.namprd10.prod.outlook.com
 ([fe80::a835:7e9d:bf65:47d7%5]) with mapi id 15.20.4566.027; Wed, 13 Oct 2021
 15:09:03 +0000
Message-ID: <8985bae0-805e-dac9-2fe7-cb465596f08a@oracle.com>
Date:   Wed, 13 Oct 2021 10:09:00 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [PATCH 00/13] qla2xxx - misc driver and EDIF bug fixes
Content-Language: en-US
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20211013124422.17151-1-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
In-Reply-To: <20211013124422.17151-1-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR01CA0017.prod.exchangelabs.com (2603:10b6:805:b6::30)
 To BYAPR10MB2934.namprd10.prod.outlook.com (2603:10b6:a03:85::22)
MIME-Version: 1.0
Received: from [192.168.1.5] (70.114.128.235) by SN6PR01CA0017.prod.exchangelabs.com (2603:10b6:805:b6::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Wed, 13 Oct 2021 15:09:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 365c35bf-aa17-414d-daaa-08d98e5b6485
X-MS-TrafficTypeDiagnostic: BYAPR10MB2631:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB26313613AA30740EB4F157DFE6B79@BYAPR10MB2631.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:348;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R99qt3ekfBgijqC6kboofWRTlC4kBGdbKRX3TwNAO0q2ARz6Fhs6OIPHUcUhxzGBQQas1RDmReZmfFqY8KQO7vYdt0UvWb+1jr7JN9+7QV7MeZ91qSGbT40s0qjw7Zi57B7E0j5ATmVaGWkjWQ40E9e8Tsp+ADMxXV7y0guUDGitWQHQ1YWYqXYYfTSz7NqKj1EWda9w9ElEcw7Zyg+93xW0zGqXv8tUmJYTReyw/5vfttiB+BqXi6p1Vr83HC77Qdx2Z6IMtQetZhGaMY6otgcHNROtbLxvPcrtv3UL+1tzyMdszygU/BuIFHUefapT3onNZ0/fZmEBLlDPN69cnAdkuv0C/c/F+RZZZcdlmUDfx5pThlv+0XwGD5/4hItV7caP0wyCUSfO5ghDzlwcvNzA/WFSYyTylOgUobHHTNhPFs2/v+VNBOINp1ma0TY9I8C+Cv9UmIC+nLxilOc1czZMT2JWrvB1nOzQz6HiJjIFNZTczwGoFVAcmOFYP6ROV8nGHsdKE4HnscUO4puq2YBzhUQnFqC9XscHIlnM26vDaugwPc5G/qhGyZNXUXN2iT4HKVKD818wH5QTubs++DYTWzTrUJTf0qzqAYstOcXTMi0MWL8Qal19yXMabLrEHQAf9ij2ea73bfWZG2U5BWViStmXChHT6Qw24yYkopQ4Cqz9AkA2JxaGwsRzpoBzYLorIO7NviUj07Ii7Ng8rg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2934.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(44832011)(66556008)(2616005)(66476007)(66946007)(6636002)(38100700002)(36916002)(31686004)(508600001)(6486002)(2906002)(5660300002)(16576012)(4326008)(316002)(36756003)(8676002)(186003)(956004)(86362001)(26005)(8936002)(53546011)(31696002)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a3RnVk0zRFQ4R0UwYUNFR0U5Ny9nU24wcGtBNmRPZVF6RHdhVktKQUdiMWhE?=
 =?utf-8?B?WTRNRzRjaWE5Rk50QXBWUnB0c0h3NzlLSjVUR0lwQXZnSHRvTktBVlRHRmtl?=
 =?utf-8?B?Uy9yS0lsZlFUclAzUWR0VFg2TlB2ZzJya0dZeXJGemdxYzZlaGsyRGxjbVl2?=
 =?utf-8?B?NGppeTYvNWZYRm9zWkxDK09EUTZtZUFpbjhCcW4relFNQm9TRXVyOEhnSXV6?=
 =?utf-8?B?N2xFbEJoeCt4NWh1dldNWVh1MGV1cnlzUlAwOXEvay9SNnlURmwyR3hWNkwy?=
 =?utf-8?B?cU00RHRHSjJqQ1dqdTBKSStKaHNGYVFhSnBodGFnek52MVJUNExCT0ZZdnF5?=
 =?utf-8?B?cVdRL0hLOUh0a0k3Ym54eitiSDBEaElXMUxXeitwbE0rbnhWemlFRGVtVE80?=
 =?utf-8?B?Z3h6RnNuZUlLem1YcXdmV3lmVXZ6ak80ZjVINXd0VXlySTVqbUg5Lzhmb21U?=
 =?utf-8?B?WFI4YmRoSUMrem5KTXJyYmlrS1pVOHR3N0FDMi83Q1BYMWtueDlWNE5pekFZ?=
 =?utf-8?B?WllIRDVtdWw2NGQvOVdxcGxiVXhOZ1J3ait6Q1ZUTFVEMXJMTGpHTFN0TmFV?=
 =?utf-8?B?a01BNFhLa0Z5T3lTWGVyOTRtaEF6VTdrcmR3VmFMZXBkS1M1b0VVSkYrZ3E5?=
 =?utf-8?B?RkNLVkdyRFhMMGJ2YjEvV3FydERLVVVLNU9UNnllSEMxUG1BNExvUzJQeUFx?=
 =?utf-8?B?UkhxMXRKckw1akZsL1Z4Vll5MVZSWGxIdC9rUHVHK0FOWkNNOTJkTGxCNFU5?=
 =?utf-8?B?U2NPckRvS01sZUpCVDd4N3BtQkw0bFJqS1RKTFBVczBNRmpudUdwS1pZZVMz?=
 =?utf-8?B?bzZqbHpkLzdTbUhoQldrU1BuSUdhUHF0ekxMU0lQdU42eXhoTEl4Q2hJTklZ?=
 =?utf-8?B?SGxBZmc4RzNRRUtNT0hTcEVTR0pVMm05bHlvc2kzWkR5RVhhQk02UkRvb0NK?=
 =?utf-8?B?MjFHUktvVEl0S3FQSkhTNFlpMFk3Ujdab2ZWNXpEYUZraUQwc3NpTFhUNWtC?=
 =?utf-8?B?TUlwNGZPUGp3K3pMWituT2hvSld5WGNuSHVQTlcyNGlXTzRhRWpYOXBPSHMx?=
 =?utf-8?B?NklpZWhIZFJUbno1TE1RT2llRVJTRURPYzZ1RTg5NGZsNW1sU2hZRUp6VDRx?=
 =?utf-8?B?WE9URkZlaDVuMnozZFpJd3UwSU1kSkxuYUk5SktLZHI4WHRaR1VtK05wdDR6?=
 =?utf-8?B?UE1WNDJwVjJUWHFWZEZyNzdCbzNCRkoyWTh3N2kzVEN2VStIdmp5YjEwYUUz?=
 =?utf-8?B?cmhPcWFxMWJzakNDeVI1ZTNNaVJGRm9NUXVxN2VyZUtNMmdzcmhKOEdEWU5i?=
 =?utf-8?B?YTR6Y1JOWEhUZTZLejhtbnNWT29KaUUxYUlMWkkvT0VsRlNTRjV4NlpPRzM0?=
 =?utf-8?B?YmI1QUEvU2F2SGN2VHNKenRmNTNpajJ0bjdTMzBJdSttK25PK2EzTmtPYnZF?=
 =?utf-8?B?aUM1WmhNUkNoeHl5Q25xRVpwYVhpNitOS1FSR09KNmVUeU4xSEdMbGN2Rkdj?=
 =?utf-8?B?dUpxTVhacitQTTh5MVVUNHRzZEVTKzI0MzFzUkNTU2txanprUkFiaXlmdWNG?=
 =?utf-8?B?QnZodEtRY2VyclpMak0ycWRwcUdhYlZsa2ZFRWNZZXE2N0FxdUZsdGQvVlcv?=
 =?utf-8?B?N0JTTWliTkJaTDd5ZCtWRnhxUjJ1cXRpeWlZRFhqMFprVkFLMFNNUHQyUzNJ?=
 =?utf-8?B?Si9WdFVnVkVQVm5Da1BkZ0p0eWdVejlDM09CSmxMRldqSW9mR0srMUhRM3Fh?=
 =?utf-8?Q?4T2Mp96F7vdMOtUuO5m1D+Vogg6Jr1T44Ja/kIr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 365c35bf-aa17-414d-daaa-08d98e5b6485
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2934.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 15:09:03.1666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sCZkJ+zato+qwDtoOpOlyvc9WPbdxQ+8KaCxEsuKd1D2MuXxXn+NGoStRF+rY0T1HIfamLRvyrMK5BoK9bdk73ccwfuZZyBjPfFjz5fIqJ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2631
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10136 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110130100
X-Proofpoint-ORIG-GUID: Qm6dwk3OS5FB3gV0CO4keQ73SVpW8DgQ
X-Proofpoint-GUID: Qm6dwk3OS5FB3gV0CO4keQ73SVpW8DgQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Nilesh,

On 10/13/21 7:44 AM, Nilesh Javali wrote:
> Martin,
> 
> Please apply the miscellaneous qla2xxx driver and EDIF bug fixes to the
> scsi tree at your earliest convenience.
> 
> Thanks,
> Nilesh
> 
> 
> Nilesh Javali (1):
>    qla2xxx: Update version to 10.02.07.200-k
> 
> Quinn Tran (12):
>    qla2xxx: relogin during fabric disturbance
>    qla2xxx: fix gnl list corruption
>    qla2xxx: turn off target reset during issue_lip
>    qla2xxx: edif: fix app start fail
>    qla2xxx: edif: fix app start delay
>    qla2xxx: edif: flush stale events and msgs on session down
>    qla2xxx: edif: replace list_for_each_safe with
>      list_for_each_entry_safe
>    qla2xxx: edif: tweak trace message
>    qla2xxx: edif: reduce connection thrash
>    qla2xxx: edif: increase ELS payload
>    qla2xxx: edif: fix inconsistent check of db_flags
>    qla2xxx: edif: fix edif bsg
> 
>   drivers/scsi/qla2xxx/qla_attr.c     |   7 +-
>   drivers/scsi/qla2xxx/qla_def.h      |   4 +-
>   drivers/scsi/qla2xxx/qla_edif.c     | 333 +++++++++++++++-------------
>   drivers/scsi/qla2xxx/qla_edif.h     |  13 +-
>   drivers/scsi/qla2xxx/qla_edif_bsg.h |   2 +-
>   drivers/scsi/qla2xxx/qla_gbl.h      |   4 +-
>   drivers/scsi/qla2xxx/qla_init.c     | 108 +++++++--
>   drivers/scsi/qla2xxx/qla_iocb.c     |   3 +-
>   drivers/scsi/qla2xxx/qla_isr.c      |   4 +
>   drivers/scsi/qla2xxx/qla_mr.c       |  23 --
>   drivers/scsi/qla2xxx/qla_os.c       |  37 +---
>   drivers/scsi/qla2xxx/qla_target.c   |   3 +-
>   drivers/scsi/qla2xxx/qla_version.h  |   4 +-
>   13 files changed, 298 insertions(+), 247 deletions(-)
> 
> 
> base-commit: efe1dc571a5b808baa26682eef16561be2e356fd
> prerequisite-patch-id: 505841911eadc4a52bd4b72393ab50f095664f55
> 

I looked at the patches and they are okay. However, This whole series is 
missing Fixes tag for the bug fix series. Please use appropriate "Fixes" 
tag for applicable patches and resubmit.

-- 
Himanshu Madhani                               Oracle Linux Engineering
