Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC9DC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 22:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiI2W0S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 18:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiI2W0Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 18:26:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B937414328C;
        Thu, 29 Sep 2022 15:26:15 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28TLxShK008296;
        Thu, 29 Sep 2022 22:26:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=n3dFIYZwdQyBQQqcPQHdS8XUYueHl+ctKA7VZS8VSGA=;
 b=Brevcj9WqJJjtgh/fj9R4CIhS46tAw2z2yigIi8FFjDZEaWePJWfl1kZbjVh1qLygED4
 1rvCMI4DSgQnALwk7Yum2u6gWdC7Pbj7zKUR7whwNw9rMvoO8HeHVAxHmCj593iWw22J
 ULVQ4SPdREls+aWZiMj0Zpu0dqgMcR+nLaTlJs+8gtvqmMbXVkCEorvJ6fJvR0KToiV6
 WwpnprYFcr1A83UwSKIa7s4ZbeS94Afv4Q/0zVEW3dcVOfnTDpU0OT4WavHSi50su94s
 O/evx29YzcR3LXoOT1786FysraqgCNffqMOZVLCQ4ZT3y3VkFB1Xt9C77Y4bu4f9HS7u xw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst0kwyq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 22:26:15 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28TL8mvV039507;
        Thu, 29 Sep 2022 22:26:14 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtprx1sra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 22:26:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T/UMV1A/tgyKZxdgfZ98oDYVMXxVC2Ne1V7FrrTiSnd/eee++n4+ymZHkmKRvuDQQK9GRqwnPEs7Az8IRa8MLgtkhplYMiR0x+gu17zT4h5WteXIJ7WqNWarA8Y1Z3gATMuccY9AxCtVOgq1BqcbzD8/K7mqG/1Siy0VZve2zLlP/FZydhUJhPmfSclYKIBnHOcRG87onvQjaRKLNVJnmSysnQlKuiNinBSYGiAfkeyOyzJYzLI4/kH7YkrSbvCMln4SM6tpkzX8m7I9+tm1o/0vFUxNWomizl2+ak8djaibUPvHWg7jAJ0uJtFE+SMTwjFK636iXY94QWn35vy22Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n3dFIYZwdQyBQQqcPQHdS8XUYueHl+ctKA7VZS8VSGA=;
 b=iXFMPp8dLgTs7ntid+CWXWSPbVmsiMyUrSZ9Rg1MDkDXishpASVnZGSL2xutz8HhlY1ZebLdRWCX3+TSmXyfwOSAI7T75OBzZsz3jjwYyU01Z5scHf9uVqHzOciKLo0LiU6/p+NMHNpNTBzCEA5KYhAFFIopAQEkZMeYfuYBUR4kp3NyXc/2u33vkiMdi0qJxOGrawEEYpCPpOR/L3Bb4hlSO7Sch2d3d0sJwf2TNgziVg+jX6XhZHTBlq91EtGKevmIjMrAzxV20l8zpHv/laI//5mxTR8RouyGWO0j6EVo5r6ToNhGePsMJsCSSAqGu+uBMfqbGhDUVEmhzdXX8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n3dFIYZwdQyBQQqcPQHdS8XUYueHl+ctKA7VZS8VSGA=;
 b=f7ZmRPnCFddMvyyM/xVnyrOWY0iSzmOHN/1rH7TuDkdbCFn5QYarInhxVkTE1NsHySyFl8THeTbeAVseiDTma/5gef8jPxJgCbpO0Zs1dqIsas3R8YOSIO8QL7FCtKYeRalOGKC+b88rGHSO98EqonBwI5/FU/WtSJ2EwQN3T48=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CY5PR10MB6165.namprd10.prod.outlook.com (2603:10b6:930:33::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.18; Thu, 29 Sep
 2022 22:26:13 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::4461:1868:14a:fb2d]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::4461:1868:14a:fb2d%12]) with mapi id 15.20.5676.018; Thu, 29 Sep 2022
 22:26:13 +0000
Message-ID: <6f4dba25-33af-b268-bf6f-541febf3c939@oracle.com>
Date:   Thu, 29 Sep 2022 17:26:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 2/7] scsi: target: core: Add RTPI field to target port
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20220906154519.27487-1-d.bogdanov@yadro.com>
 <20220906154519.27487-3-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220906154519.27487-3-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0281.namprd03.prod.outlook.com
 (2603:10b6:610:e6::16) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR10MB1463:EE_|CY5PR10MB6165:EE_
X-MS-Office365-Filtering-Correlation-Id: 83a73e7c-4faa-4ee2-0e28-08daa2699d9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WA2+W2eOC/kX9uD8laIuiz75Mmyq9bALk1mahQ/u95vjYLug4mBqHi+E8SHh71OV1ucd2wzngIqkcTK8dCrV7/18Jx4sCUFlMugs4Df+GQlk/Zn29o25TNw8beEsOZzltQI7SLGDRDqKYA0P8nWvnjtOtUM0NIkcRTmFGQqRQNF53FU4/e8FoX9YZcE8r2wZf5wQo24zzlbpyb9opVq3xcEPqyiPhYD5fhfYSEZKXTNx+83xDPByh23r4UpROjUwF2I1+5WW7CWrQSnSVRTWjEj60CRvtMg46ngXgomo4Aip055YBUn3YGGChMzd2T1jHIwILe19SBEBo6t4b6WzXcLwU/3kvvVbfMJnqKxwpEa1rqvCW0KsFlLKRe2XfXknNnXJT9FSIyXoFLR7lvcPXXOn+UaFcQanClpzUgm1m40/lNCtjYEsARC4NIk3Ubf3JXI6fa1TI0Mu45nOMWGmBKnjXIVAznP/pVKhP5mAc5UTfC27P94ubzAqQtvo1OqdHGeHNEoLmKJWuSnWVWbC71If/8kYNyKOefFYxSnZMNTcVMawMdnJkhQIUVz+IF/Rm6bG/yVM86nnTY5c8iaRkYu7dBUKdcDFT/uPrTR6xwJlk6bRZHX8PLQ7No48BxmMu/jn5Oc4Ohb3ffljOGQ7v1D54CUZ07SLfU2fkVB2RDYoIkea7hCt35ZdEiMdoj+CezCBhRT7DxA7J2QnsuM+4Wdd3gxs/BzLLbDuUkgje5fPpYjcMuFz1ln513RrV3jKAuzDPnLz///SMuRqQP5eDSwryiE7fyRR5MTSmhp/W+o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(396003)(346002)(451199015)(2906002)(86362001)(36756003)(26005)(53546011)(6506007)(2616005)(6512007)(31686004)(31696002)(38100700002)(66556008)(66946007)(83380400001)(316002)(478600001)(186003)(8936002)(5660300002)(4326008)(66476007)(6486002)(110136005)(8676002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aVZtcjY4cy9jdXN4Y0VZUXBhU1Q0bnQyZ3EwZUJ1MVArNmk4VHYzejBXY0Ry?=
 =?utf-8?B?Mjc2elo2b2JrSnYvcEdQMzlpWEZaQlRJTi9FNXBKMFY4amIvbTlad20wM0l6?=
 =?utf-8?B?TjVHT21HSDMrcGdhZ0VFUGtiajFFQjNQK1RVYVdsaTErUEVSNUJqTi9IaGQ0?=
 =?utf-8?B?RmNDTTJKQzNJSDhlNmhEWGJ2WnU4YkhCWGZqWWxCd3kwZzE3VXNFdW5ubHVy?=
 =?utf-8?B?VHdtU0NJaXpmaVg1TWl6cWhQK3RQUGUyTGVQLy9Xd2R1ejFYUlYwank3dis1?=
 =?utf-8?B?WUF3L2F4OWNIVmpJYTYyQmppaXhYUnhkL29Zb3N0T1dVUllNQ2oyTlRDL0Jx?=
 =?utf-8?B?cU1qcUxPaFRDVFhSUnFkaTdEZlRjUUhIaDg5MlpZRDN2eEpGREw4VUNPLzdt?=
 =?utf-8?B?eUhBc2dlZ2xGRDZnOTVzTFBwbWZIRkt2NktOeDlRNlFCdGJ6M2sxWDdiTnJV?=
 =?utf-8?B?Y0ZFdjVUTUtOWEpLTFEzUVc0K1orWW9vd1R3T1ZxekpObmdiazJoVHlSa3BH?=
 =?utf-8?B?Vk1IY0JLWHN6YWlnaGRMMCtjL08wczBEdDNkRkptLy9kWXNCWU82NDlBcml6?=
 =?utf-8?B?cGMzVE9WZHFRZUJtazJ3WjlkOXQ3TjFqT0RrbHZqcFNCVEZ6cGdhd3Z0Wmha?=
 =?utf-8?B?aUUrR0FiVTJVZkdIL2VKc0hBVmNJZEwzTTFzdkZNRkhZdHpnNDI1bUtaaStE?=
 =?utf-8?B?R0NmRDMyMkJWdmJQK25ha2tPSGQ1VzIxQjdCWVFORms2UlpJQUdRMGt2YUtp?=
 =?utf-8?B?eitKOUNxMVEvaEF5MkN6bU45elV3M1ZUTE9XZFVTRmtGK1llemthQkJQbmw4?=
 =?utf-8?B?RDNOb2RiZ2ZHOWJ4cjlaNDIyVVpxWDZJVWFHTEljdnF1QWZidHZhMnFvRU01?=
 =?utf-8?B?VGxzOXk5SExNQVlybnFrY1d4VkM4YW9ETmZQSHNnUEdQOVFwQTVMR29ncy9M?=
 =?utf-8?B?UG5rclU4ZGVpQWpraWFRUjR1K0Rid3JVMjlXdzRmdmZQdFhWVjhLMHF4Qm5K?=
 =?utf-8?B?VW9iL3BGWlJpeHF0Vk1OMllyWHlvYjZlNzlEV3BnL1F2YUxvS3d6RWdTMS9H?=
 =?utf-8?B?VkpwTU9wRlI2TjJFelNCZE5Cc0FvVUNYSVVhOEZuYXdldFVVaFY2aVZSUFBE?=
 =?utf-8?B?TlV1dUh0T2djWDMrUzRKYnFZOWk0MEIwSTdQQ3ZLbzVBbEMwbFpQZ2xreHFY?=
 =?utf-8?B?d29OcmhWKy9odEUxdlV4dDJwWVl4bkFiMmJ4WTc4cVVTUmJYOWZLZllhMERL?=
 =?utf-8?B?ODkvekp0dnovRHB1bVZ1OVVQclY4d29hNmtQOWorS1RUOHk3NVVCdk1PMFFP?=
 =?utf-8?B?Sm5hQjhDekx5M3FUTlZ3YzJoMUtpLzFoZExHZ1dkalBIQ2hZazgvR1lIUzUr?=
 =?utf-8?B?SzJ2UzhDcjJBenFxVkV1QTcrOFZwRUI2Mml4YjJ4VDJPZnMzSERyMVlyNzdp?=
 =?utf-8?B?aEd6MVREcUxiOUlmdVNBQTl3V2pDL0Zoc2RPNkJRZlJWV2RqRks0QnNWaFI3?=
 =?utf-8?B?d3BlcGVvOTBwVDl1TmhoOWQ4TmdYL2ZvTXhaU3NUcyt1YUlzRWV4QStVU0sz?=
 =?utf-8?B?RWdLbHhhcUJsemFQMVE5Nmt1SWtud3dZUk5FcXl5VWZhUkRKNE9UaWRrYWRB?=
 =?utf-8?B?UmJyS0cxTmR3dUJyTURSbFFpZlk0WGJLZTl0TXEybGlTMEs0cHhhL3VOQjk3?=
 =?utf-8?B?U1llT3lTTW1RYlErUGhZdmVNcDNUeDFVWU1jN0Y1eWVpZ2w3YzdYTEVyTTZ2?=
 =?utf-8?B?aEc5RU9SU2pYcDkxaFQrODUwQ2xZbWM4REViT2JiVGxNVkdoRnNTSlFVaGlh?=
 =?utf-8?B?NG1LcXRrVlRpRjJSWFBjZU9vOFoyUmdPUUdhdTRKNmpXOUVFRE9oN2NtdWpR?=
 =?utf-8?B?NkpBamJ0WDF2cFBNVGV2U0pIdFh1Ry9GQ3U4RmZIaTA5L0x0MVZjMGk0c1Bt?=
 =?utf-8?B?TllDK0F1NzFsQjBISFVXMXUwR3ArRzRmaXdNdStMcHNzcUJwWjdGTitXQXha?=
 =?utf-8?B?VW9TbGFuM245RFVzQXRnSGkwZkFvQlFQSFdIaFRXZ0xKcGFzczMvV0dxTEVP?=
 =?utf-8?B?REd4U1hJdUxCRUxQYkxUK0kwOGh0WEdCbmRMc1NMK1FMTGRldytxMlUrT1No?=
 =?utf-8?B?S0RkZi9pVGl0SmM1UjdqSDgyajJ6d0g1MDQ5RXZ2ZXRXbEdOcXE1enpkMWVo?=
 =?utf-8?B?M2c9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83a73e7c-4faa-4ee2-0e28-08daa2699d9b
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 22:26:12.9859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bx0vpHIwA1ZO9VUhZAqWyDuxyNtBrm9SPTYQMU+xwtO+ck4ltDzwnbMoEoVZr83E5FBOQMx3pHBR8iR0ObOPh1lbc5hngOa1DXG+gU2FMtY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6165
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_13,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209290141
X-Proofpoint-GUID: qAZhk4l7B03EdrF4M4JtiTuBvIOk0zVA
X-Proofpoint-ORIG-GUID: qAZhk4l7B03EdrF4M4JtiTuBvIOk0zVA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/6/22 10:45 AM, Dmitry Bogdanov wrote:
> From: Roman Bolshakov <r.bolshakov@yadro.com>
> 
> SAM-5 4.6.5.2 (Relative Port Identifier attribute) defines the attribute
> as unique across SCSI target ports.
> 
> The change introduces RTPI attribute to se_portal group. The value is
> auto-incremented and unique across all SCSI target ports. It also limits
> number of SCSI target ports to 65535.
> 
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
>  drivers/target/target_core_tpg.c  | 78 +++++++++++++++++++++++++++++--
>  include/target/target_core_base.h |  4 ++
>  2 files changed, 77 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
> index f0d38d77edcc..325ef439fb42 100644
> --- a/drivers/target/target_core_tpg.c
> +++ b/drivers/target/target_core_tpg.c
> @@ -31,6 +31,10 @@
>  #include "target_core_ua.h"
>  
>  extern struct se_device *g_lun0_dev;
> +static u16 g_tpg_count;
> +static u16 g_tpg_rtpi_counter = 1;
> +static LIST_HEAD(g_tpg_list);
> +static DEFINE_SPINLOCK(g_tpg_lock);
>  
>  /*	__core_tpg_get_initiator_node_acl():
>   *
> @@ -439,6 +443,57 @@ static void core_tpg_lun_ref_release(struct percpu_ref *ref)
>  	complete(&lun->lun_shutdown_comp);
>  }
>  
> +static int core_tpg_register_rtpi(struct se_portal_group *se_tpg)
> +{
> +	struct se_portal_group *tpg;
> +
> +	/*
> +	 * Allocate the next RELATIVE TARGET PORT IDENTIFIER.
> +	 * Here is the table from SPC-4 4.3.4:
> +	 *
> +	 *    Table 34 -- Relative target port identifier values
> +	 *
> +	 * Value		Description
> +	 * 0h			Reserved
> +	 * 1h			Relative port 1, historically known as port A
> +	 * 2h			Relative port 2, historically known as port B
> +	 * 3h to FFFFh		Relative port 3 through 65 535
> +	 */
> +	spin_lock(&g_tpg_lock);
> +
> +	if (g_tpg_count == 0xffff) {
> +		spin_unlock(&g_tpg_lock);
> +		pr_warn("Reached g_tpg_count == 0xffff\n");
> +		return -ENOSPC;
> +	}
> +again:
> +	se_tpg->tpg_rtpi = g_tpg_rtpi_counter++;
> +	if (!se_tpg->tpg_rtpi)
> +		goto again;
> +
> +	list_for_each_entry(tpg, &g_tpg_list, tpg_list) {
> +		/*
> +		 * Make sure RELATIVE TARGET PORT IDENTIFIER is unique
> +		 * for 16-bit wrap..
> +		 */
> +		if (se_tpg->tpg_rtpi == tpg->tpg_rtpi)
> +			goto again;
> +	}
> +	list_add(&se_tpg->tpg_list, &g_tpg_list);
> +	g_tpg_count++;
> +	spin_unlock(&g_tpg_lock);
> +

I think you could just use an ida.


