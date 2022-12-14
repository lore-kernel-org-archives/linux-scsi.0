Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F36EC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 10:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237512AbiLNKCC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 05:02:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiLNKCA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 05:02:00 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5671742E
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 02:01:59 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BE7IhEF014098;
        Wed, 14 Dec 2022 10:01:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ovYGqSxbdH4K835gsh5Xa8y16SLh3G+1TGq/9VpTV8k=;
 b=uzlTcsAdBcCL685wL3WGY99AICXzBKTpyDIrPfTmWKVrIpPGQ2Cs65Rd4L2/nwQOAADj
 J9p3qf694ibnh5eUj5Io7XeJMzTU1JqUeSjIaiGkxFvVBam2KefojuXcGY9S+RrWengX
 0eka7kjy6xrnoNa583LTavNcTBmna81SeBwxwY6f8nAxbXsko1T5hGqMkBSvn5qhgcNO
 zRvMHJLxy77/TlSgjfyjclK0mr8sophGNgdSSUWn2YC1nbJVImqBL5QIwPcYbTHU9qhh
 ja8f4pQz5lzz8MzEawKbMUheeLF1UlS8VM4AsIhZoNQXi4O6oYGh8FGzhtlpwU0ecM5A tQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyeu9p4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 10:01:36 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BE8Fiqv037224;
        Wed, 14 Dec 2022 10:01:35 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyeky7us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 10:01:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OLD8cNSFAaBGHtbf0Hjk3f4u9P3Q1UT5TZJCk4QyfOkwJ7X9E0qWSqDK1YHSL3oYoVFIcxB6q4Oo5OSbvmKyQHjctx4260U67jr986wtALXB5guvUzT8ayXvn0AD7b5oFcokNWBPS8Vj2rr7MJaugjs8vYqdVWHnKDrQK+tOnhM/BNIL6J6POFvhsmpu2b/JYGVD502XsjJFs6GaY4rXwaJvJL+4P5Fr0lAZBbowI6QG32nfudmqFBSGRnWhsGCTqsGI3enwacG2lUy2SEz/Z6QG9dhq7Z06gbKgm4SNos4r8s1D+qpOSrIikTef7Q6S/vbmQbseJSUyTiau0bkEFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ovYGqSxbdH4K835gsh5Xa8y16SLh3G+1TGq/9VpTV8k=;
 b=dqpEBW1tGQf+aIDwqMbq/iWNwqWU7OlzU5GJqzBu35xseYwPyOfbUaviiQUqRUK/H51HFmrOTVpqZgOscZQNY0WN+4+sDxJ9x9f3nZoC57xrQYcG3QQ2JQuC3l67VcKctUKrSJURccgPxX+Kt+zISGAMrrpod2Z2rNIGbQBNx8nhop9hRz7eq7MgmmoZqVsN7ZkBBwP7f1WAw0UE1Lx3Lfx/18VnRx3Tz40ma+y8L7rmh4Wp68ZLpGl/K/ow4Qsw86rSiA+DDd+uTxbKbXYREAf0DsV40vuCxdWl8IVOIynbTrFmGSet71wdiOQp1fgjH1KCPowmWFQMtojeo/tQvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovYGqSxbdH4K835gsh5Xa8y16SLh3G+1TGq/9VpTV8k=;
 b=uPIZnvL2BvBtFs4X5adxcoSq4bXkq+b8JZTfuZAUp8oYMXIB+tu7ExPEtPwDxVZCDS06Jps6PNXA6Xs5kv69Y/g0PMlbwcpQjhiRUU9jp0a9QXSEjipPjGMqDoL2B5nFN/fTcn6kA1j1AhNS8uTzUn2MF2VuOsZt/avr1peG3TA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BL3PR10MB6114.namprd10.prod.outlook.com (2603:10b6:208:3b9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 10:01:33 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5880.019; Wed, 14 Dec 2022
 10:01:33 +0000
Message-ID: <2e646acc-d117-7514-590c-f2836fafe0bd@oracle.com>
Date:   Wed, 14 Dec 2022 10:01:28 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3 2/5] scsi: libsas: change the coding style of
 sas_discover_sata()
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, hare@suse.com, hch@lst.de,
        bvanassche@acm.org, jinpu.wang@cloud.ionos.com,
        damien.lemoal@opensource.wdc.com
References: <20221214070608.4128546-1-yanaijie@huawei.com>
 <20221214070608.4128546-3-yanaijie@huawei.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221214070608.4128546-3-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0010.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ad::21) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BL3PR10MB6114:EE_
X-MS-Office365-Filtering-Correlation-Id: ea57c8fb-dd15-42e5-6470-08daddba2e44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8xInTwRsJoIMO6D0SsXd96UdjwYbQMElyL3R20t0O0+KuzFDEBiqdfG43hhg1NL0bvIjl3e03Z6mzf6cLzwx/bqRQgqfL1XLxqLHo6wuhR9kIXtXzTwje2V+j81avN3mxzgK/J7eW66hUFcWvj3saPV4+aIdBOXc+/koogepLv0QjSEKdcTWVAoNZtOdaMm6WR/ZifgFG6jRy9wWMoWGcm6pfpyghXCBNYrgStbSnRp17K7yeb5n+JneY6NsvZyrsmRy6bLICNPIj4/Jl7J0J1MP9/hULQC2WQxoSp1hruZfRqRDTM+5TUdpbfipeXeasRDy55OnGrAeelhzQgcGTPYOboxWHP0cKszJQgxsHnv5FZa4yx7iVeKyNCbU2BCyJm8TzRI7GGeysJ5Bub0zrxLZToiDGA78fCUKfaASS8BfJN71o6cZXjfi29n7rQ4s8NKkpqbgNXx8zSH2OJRGfbBB39ddWOv0Yt8coAMTGN4LBbXAAoUmAloheutjIjMWI7f9iG9tWenOcQoev/sqJEsrINbNlIyrI0LUbDUpC3AjFbV8tnu0vfBBCaGxhpPNhkb5shFqLphPztYMejYD1ZupKVcNlHIlrIwvMPWUNEAga8/AZ/Gw37WDpdBWsxInZdKxrxZ3yCkIogRTM3fuMrL+d5l+vBR4N0QNHG76mgQ8Ar9lM+S+YHX0yMMwCjNhzWiP8rGd04Mw0uWWkN6iYLxs9tNH3SUtlQ+8oeThRVE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(366004)(376002)(396003)(136003)(451199015)(478600001)(6486002)(31686004)(186003)(6666004)(36916002)(6506007)(6512007)(2616005)(26005)(38100700002)(83380400001)(53546011)(36756003)(41300700001)(4326008)(8676002)(66556008)(86362001)(66946007)(316002)(66476007)(31696002)(8936002)(2906002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MU9KMmdVemlsck12RkhsMjBlcSt1d3Q4VWJPam9oR3gvbWRZRnFQV2t4S2N6?=
 =?utf-8?B?RWg1RWk0ekJRZHVNUFFVcjNsUkNOY0c5aHRsdUV0S2JscVovckhaMFpVSkRx?=
 =?utf-8?B?SEIveHlTdjA1d0VrUTNVUnU1czZMUlQwT0cwWmI0Y2RGSkVXUmhqRnh1UTRu?=
 =?utf-8?B?bnZtN2txeCtmQ2NkSVF5K1VGWTUrV2I5Z0ZrTDdXdFZCQ0J2K1hhVWZVSk95?=
 =?utf-8?B?RU1GSXRYTnJiNS8rZHVsNmhKejRpMW9kVzNBM3h2WGdXei8yTGllRExzeFBz?=
 =?utf-8?B?dTI1c1ZEQzkwblFTeTJuZldCQS9OeVU5Vm9tVHh1bUNRbkc5OWtwcllaRUdI?=
 =?utf-8?B?cFR0MHlkWnA0Ym02VlBtSlIxbjRHT2hsODI5YTF2UmJhMXhYN0h4bC9SVW9P?=
 =?utf-8?B?T21RSFBKSjE4QzhHcDlSd2pzeHQ2dHpXVjRCMDBuR0RYRktzV09iT0U0N1lC?=
 =?utf-8?B?TjFRZWNuTFdJU0xNU2JTU3Q2TlY3U0k5L3ZaWHRlbktRdG50TzlhQVRjNm9K?=
 =?utf-8?B?N245bEJaMVo2ZDB1ZUMzVXdqTGFDWFNCaUR3cHpnekZnVlluUDVJNWhKNFFZ?=
 =?utf-8?B?S0p5YkorYkFGNmJVeWNLR3pKcTNqYzRVK2NEa0NWNi83bTAvaWJINnp0U1Fs?=
 =?utf-8?B?NFl2aS9yb1lkMkNkTzJTY05EYVRaSkhrMHZGNHlaSElvUDVIZElUSGdLNmFH?=
 =?utf-8?B?ak1SRmpmWll6MkkrZlg5ZkJqQ3pPMllKazNhVHpWMURXbGVCYTBlYmxja21T?=
 =?utf-8?B?OWhGejdjbTNlV2VjdXlPRTZXUXpXZFBRQjhLcG15d1Q0dG0xZ1pMaE1NSmJt?=
 =?utf-8?B?dG9vV2xFMDFKKzh4RFpFTzJhbnZTbmg3VEg0bjdLUUFseFFVeGFjblFDVjZL?=
 =?utf-8?B?d3ZYNlJDQkhqc3duZ1FGVWtaR0FwbDRXc3phRThjcEZQc0h2UHErQjNpNlg3?=
 =?utf-8?B?YUthSmpwY2JwZVVJbUdNWU1hZzJ2RUlNZHJraVAyL3FYeU9yT04vWmszZ1Zj?=
 =?utf-8?B?bnVkaG55ZWtvMDR2RVk1L3BCNExqN1pFeWhVdENEUzRkeldnVHhTVGJZejA4?=
 =?utf-8?B?cm1ENkxYZmphVkF3Sy90aVh4RmF1aUZTNkVpT1pFYWtRNkxKWjRKNlF0OXo3?=
 =?utf-8?B?VVlOSVZRUnhYdkVrT2RpOXNIM0xhMVpCenptZ2FtUGo5WjArSytXQ0xEcUpE?=
 =?utf-8?B?UndQSWVLVHVka0hhbkI4RGZuSWY3alpydi9OVG1XNDFSSTIzeWtRMlJzUUp5?=
 =?utf-8?B?dlovVGRXN1NaNDBaeTRtc3ZGbEJvQWovVG1YM0NTQjBDSEx0NkxxU2ZFU3lm?=
 =?utf-8?B?MWgrSmw5UXI0b0Vub2xXZGJmZXlDbGthWXFYTDRzTFpwMHBKMjFOTVplZkJk?=
 =?utf-8?B?QVg5L3drb2JscW9yaFR1WkZVK0UwZEc4djMwS1NJSUVKeXJhZlMvbkRGa1dU?=
 =?utf-8?B?Y00rMTMyZ2FoNnlJWW1ZcHFYT3BSbGx0QVBoVlI5bFZUbjcxMnJyTFVKYmJM?=
 =?utf-8?B?YWlienRXM3hqSnB6SHFNT2tFQlkyL29TWkUwUGx0cGwwMXU4RGxEVmFQK1Q1?=
 =?utf-8?B?aEtaVStMMjR2cmdKWkhHUnoraE0wM25XalhVSEtRNkltSU5DUEhZQlo0cWk1?=
 =?utf-8?B?U0FJcWZqM1VoZGJCTXpTdlhpOUxTY2dIMWo2anpVUElTUlBUUHBNQm0wZlcv?=
 =?utf-8?B?QkpkUmV6bnNyUkFpTkxlOXIwWGF1b2NUeUdEelk0bms0ZnBIeXIxU2g5S3VB?=
 =?utf-8?B?OUFjV3ZlTTI4YW9NM1FmOVArRHVtREtLdWsvcll2d0hTbkpmOExZanFzMmFT?=
 =?utf-8?B?aktwRS9FU3ZBblRaMGk2c3VUb0lJMlhEK25OeWY1dHVVMTRiYktLd3NvVWRt?=
 =?utf-8?B?TUJpSXlYK0wrbHRwZERqZy8zRkFLQ0hneVNTQnRxOC9mQmU5NHdzZnBvWTJv?=
 =?utf-8?B?U0ZoUGJaNWU1dHRIQ2hiMkFmVFplUGw0SGRuY2Q5alJHTmJKelJrMWhUcWRO?=
 =?utf-8?B?ZlJ4UWJzVFdjZFpSSHlkL1I3YWV6TFFQalhLL25ZZlZoSFp4cUN6VE9CNlBa?=
 =?utf-8?B?V3M3bFFmYmRuSi9JMlAvNjJieDVqVjJGUm91QUJTMVJMWHZKQzYxVDNDYW4z?=
 =?utf-8?B?YURkUTZVVEdaU0dqWHFCNXpFa21KeGE2NUd0WXRNZ2g0YkFqaUQ3c3hZcjFn?=
 =?utf-8?B?akE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea57c8fb-dd15-42e5-6470-08daddba2e44
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 10:01:33.8267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TW9Ojz8ImNHPbk3fB9R39LGwQa82RJaBzAlerAg744Ek5WC/vDV2G4dqpeE8U9efbI3F78ynR/9LlDv/zOJWOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6114
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_04,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140079
X-Proofpoint-ORIG-GUID: AweMkIAeU-7lZqDp--VOejcWy9F4laOb
X-Proofpoint-GUID: AweMkIAeU-7lZqDp--VOejcWy9F4laOb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/12/2022 07:06, Jason Yan wrote:
> The coding style where calling this interface is inconsistent with other
> interfaces for SATA devices. The standard style for other SATA interfaces
> is like:
> 
>      #ifdefine CONFIG_SCSI_SAS_ATA
>      void sas_ata_task_abort(struct sas_task *task);
>      #else
>      static inline void sas_ata_task_abort(struct sas_task *task)
>      {
>      }
>      #endif
> 
> And the callers does not have to do things like "#ifdefine CONFIG_SCSI_SAS_ATA"
> and may call the interface directly. So follow the standard style here.
> 
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Regardless of comment on the new macro, below:
Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/scsi/libsas/sas_discover.c | 6 ------
>   include/scsi/libsas.h              | 1 -
>   include/scsi/sas_ata.h             | 9 +++++++++
>   3 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
> index d5bc1314c341..72fdb2e5d047 100644
> --- a/drivers/scsi/libsas/sas_discover.c
> +++ b/drivers/scsi/libsas/sas_discover.c
> @@ -455,14 +455,8 @@ static void sas_discover_domain(struct work_struct *work)
>   		break;
>   	case SAS_SATA_DEV:
>   	case SAS_SATA_PM:
> -#ifdef CONFIG_SCSI_SAS_ATA
>   		error = sas_discover_sata(dev);
>   		break;
> -#else
> -		pr_notice("ATA device seen but CONFIG_SCSI_SAS_ATA=N so cannot attach\n");
> -		fallthrough;
> -#endif
> -		/* Fall through - only for the #else condition above. */
>   	default:
>   		error = -ENXIO;
>   		pr_err("unhandled device %d\n", dev->dev_type);
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index 1aee3d0ebbb2..159823e0afbf 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -735,7 +735,6 @@ void sas_unregister_domain_devices(struct asd_sas_port *port, int gone);
>   void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *);
>   void sas_discover_event(struct asd_sas_port *, enum discover_event ev);
>   
> -int  sas_discover_sata(struct domain_device *);
>   int  sas_discover_end_dev(struct domain_device *);
>   
>   void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *);
> diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
> index 9c927d46f136..7cdba456b746 100644
> --- a/include/scsi/sas_ata.h
> +++ b/include/scsi/sas_ata.h
> @@ -36,8 +36,11 @@ void sas_ata_device_link_abort(struct domain_device *dev, bool force_reset);
>   int sas_execute_ata_cmd(struct domain_device *device, u8 *fis,
>   			int force_phy_id);
>   int smp_ata_check_ready_type(struct ata_link *link);
> +int sas_discover_sata(struct domain_device *dev);
>   #else
>   
> +#define SAS_ATA_DISABLED_NOTICE \
> +	pr_notice_once("ATA device seen but CONFIG_SCSI_SAS_ATA=N\n")

Personally I would prefer a function and not a macro, like:

void sas_ata_disabled_notice(void)
{
	pr_notice_once("ATA device seen but CONFIG_SCSI_SAS_ATA=N\n");
}

And even if you stick with the macro, I think that we normally would 
include the ',' in the macro

>   
>   static inline int dev_is_sata(struct domain_device *dev)
>   {
> @@ -103,6 +106,12 @@ static inline int smp_ata_check_ready_type(struct ata_link *link)
>   {
>   	return 0;
>   }
> +
> +static inline int sas_discover_sata(struct domain_device *dev)
> +{
> +	SAS_ATA_DISABLED_NOTICE;
> +	return -ENXIO;
> +}
>   #endif
>   
>   #endif /* _SAS_ATA_H_ */

