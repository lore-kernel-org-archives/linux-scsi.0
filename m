Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F30C9C43381
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1AB964F40
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbhCSDqQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 23:46:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49232 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233695AbhCSDqH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 23:46:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3UDXH090747;
        Fri, 19 Mar 2021 03:46:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=SnaKlmtPWucHonPCtkWdH4OwXaM8u8qroPe/pgx3wss=;
 b=ClT8mGuDqCG3rcoCVgLAztP+talnI7gw9tZopF8NXyhUx7KiB7AzYwiexfXwIQ3tUmEq
 VKSs030fnt6g54a+wHZq/zGfd8gFH5n+YIb/CWi2rKdXbcqJNI+970eaehrw35HGiUkc
 rL5hxwK9gGfgO+9d1rsB9gtBMUQ2UoaxwfGmB8KcW6K8qQDvRpqnERM7QUPbFGsyn7Uj
 4cV4PESHO6Mch3X8RCfGFUkjr8g1WmP8zCcFZqyt5ZJyvToiJQjoya/oXc+OEiTiGueK
 JAuKwD8K8eVwxPGuxqt+QBetRM0dxlndXW1RKRxG+N6qdtNzPcD2OiOLFPEnnbrROup9 rQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 378p1p1fxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:46:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3Vc6C007675;
        Fri, 19 Mar 2021 03:46:04 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by userp3020.oracle.com with ESMTP id 37cf2b928m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:46:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oIpWc8woa6npmuhQ6tsHdVk9A5NnWc4N5TT0pF6DByNiC2iQH7DcrIu+4fC+DStSFsvr6sJENiJ6+yq4mTD9j+tm+Inx3prWGKpCvdtu+2O3AEWKip0a5piaDzuMC+FasWa8uYIF67ymuckTqU72Yx86zNmr9Prq74nljEElGEwKd7qeIadlsjI+wZIalN+fLNhYuF7LfKHvyaObGnc/VfdXfEmMv3Ek0XXQaihrXIRhAdQe1W/IqvkpqW1pf9w1cOEm43Y3BaOX937j4AMPyey5FUIlh9rGRh/VpCYrUQVR/5lzoAeNnG2opyuukxT9vR/hEnhTRPwpu4/jTI0gTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SnaKlmtPWucHonPCtkWdH4OwXaM8u8qroPe/pgx3wss=;
 b=lCpIjbM0Ciyj+4e6GgtPsYtwn0CcuC3O3clpYq/P8M5lmtpFN1kXjaUDeRlSLI3Dirca0uEHi0Yh/qQv6DRXISR6DfrGUH46ayYdigtCFSI0adiS/rGjCzxVMXtZnWyQE18Vqt3hvb1DOQG8+iT3a7oYNu67szd/IQtwMpqu4d9ZeZnr4KFEU61DDQPMQmoxqeJUm9AAADrP8wTqTZGqwfi0qmPld1Yf+tB+ZV6YJIJJsoEkLZn3OkwLBKzTkKm5IDNX+jxmRSXReLEptql8ttmjdU2bX5Vnb2ZuacrBB/3eF8eZ1cqpAIZjURqRQ8HtelzyVeTiab5dszSFxkmanQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SnaKlmtPWucHonPCtkWdH4OwXaM8u8qroPe/pgx3wss=;
 b=BNbPTufCCyX0efccA8UQfuAAsxD0aVSXo98ACh8dhIZdn79+9ZeE9x0Cx9yBoPW3EEmGw4Eo/kLyx0yuWUxg4Y21EODcIHfTsc+nN6Y5hffXl493dZoC2e8njLA3+d6kWp/zpYn/qrPYxa2exoGDc0L/O7ic2Ft/8Dtmcm5wA5A=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 03:46:01 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 03:46:01 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        sathya.prakash@broadcom.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        suganath-prabu.subramani@broadcom.com, sreekanth.reddy@broadcom.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH] scsi: mpt3sas: Do not use GFP_KERNEL in atomic context
Date:   Thu, 18 Mar 2021 23:45:54 -0400
Message-Id: <161612550237.18396.1025206016482733392.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210220093951.905362-1-christophe.jaillet@wanadoo.fr>
References: <20210220093951.905362-1-christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SJ0PR03CA0078.namprd03.prod.outlook.com
 (2603:10b6:a03:331::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SJ0PR03CA0078.namprd03.prod.outlook.com (2603:10b6:a03:331::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Fri, 19 Mar 2021 03:46:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 407969d9-a4fb-4cf8-4fc7-08d8ea898382
X-MS-TrafficTypeDiagnostic: PH0PR10MB4616:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB461647C8AB3847D42FD7CD278E689@PH0PR10MB4616.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TY06zbEPQQID0guKX7yQT3rvnJeii4bm13+lrPgGHlpxGsEsmVAIJeruEnKBpmMUE8ShRDYYfaA7qg3wKRIqAQTX+xl3GEHS4uMAjYfZByy9FG+zX9XC3Y7EFbXguCE6sMYm2ATT6GZh69CTYZrT5hmY01Ny7UCS2Eci0Zzb3pe4arl98lC3zujRPM1x0Tv/RKPRR8nbASmk6S0IcOsybc7sofkXGBnUg64m4Ab3XaG1xSTpbE8h8BK64sxhGtJShMCy5IROscKmGj9vYKiytYo6C1Yka6RtdYZS8cD83os2ow1L8OtOAUgIZhyUQj0muBL6Y8MFhblR6+H1cqEUxPVocr/gbk7U7zMTTCatUx+ycNuXI3wL3ChDmBRk7JR2rcOeCJIRXJrj2hySRkNhsf1dv7xqlEtq2ZhFAkeTS7pvoyDdUzlEzo7mJuekS4xl/AUvT3/mjfrVQoO70KziCse6CGTbnjd3DlwET0TkFB7kod68mh/EYKp/fOsIh+iiT9DQptO4QVQabhfWfQri1SQWwBGCbqfSafWLhRRlBbZA1p9fWSTKmyI14UIwAlQz/+Bd8RogZlBytD9XJ5cqmsfIYuKLPT8i3oNkvfSmfl0mA9Thx3jfPqQ9XhMwqp7Q453grz2kDHvwTStu2H79ONHrq4HcpTqWUgUvH4UK4MmKEYmqEc/9x5ZK94jDltNdV1qT2w5VnPAYG6Zxvl8FSlduWjLCf7L4qFx9TbVhaMv7Xywbn10YS9ReZxvE9XB0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(136003)(376002)(956004)(86362001)(5660300002)(26005)(6486002)(16526019)(2906002)(66946007)(52116002)(66476007)(7696005)(2616005)(4326008)(8676002)(6666004)(66556008)(478600001)(316002)(966005)(36756003)(186003)(83380400001)(103116003)(38100700001)(8936002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cjU5eHEzbmFlV0dqTmkwc3FwbjZ3Q1RLcFpjNDVLWTJzTWNYVFBUWGJFT0Zj?=
 =?utf-8?B?eU51bUU1NlAvS1oraTBneGtiUzd1QllpK0RjSDFiTFAzN2dFL0NZTnY3NCs2?=
 =?utf-8?B?SlV2OGQ4SnlmUThvbUhTVUNSeHY5RUJzMXVQUFdOcHVoOWVaQWRKZCt5Q3Iv?=
 =?utf-8?B?SDdzcVhwR3EydzM5NDltczNoQjB6SDliZTFINHN3Q1ZNbTlhU2lxMG5COFZC?=
 =?utf-8?B?V3M2NTFEbmlLbGEvU2F0bkdUMWtYK1VzeU9PSzZYZVJQSEdVYXBSd0RIVUlq?=
 =?utf-8?B?eVhLWVFzbnRLZXhIclo3cnZOQ1BOZUQ0aE9rU2YzbUtQMW9ndDBldjAvTG45?=
 =?utf-8?B?Tlpxbk81R1dnd2RIbCtMbjZuK3FnZDVGN09KMS9kZU95VnpxTG9zeTV6Ynly?=
 =?utf-8?B?ZEhMMTNBRVlraWVMNTJTVWZvSUdFWGdlVjFCaVpza0RUa21yS25vem80c056?=
 =?utf-8?B?OWRpNGZydWRRNmVUbjNVaDUxZFhqZWgxZmlySnVrWTAySVlUUnR1eVhHS3Vn?=
 =?utf-8?B?aW1saCtmK0J5eUNxa0s3N1kya2tZRFNqbzQ2U3FkL2FPbW5Qd1JQZHlhZCtl?=
 =?utf-8?B?aDYrNy9vc2I0Q2Q0bGg3ZkVOeVBhNm82QkdKYVE2NDgrSm1oVlRmYWlnVWxD?=
 =?utf-8?B?SkJid28xa3h6SHB0eDg4N0hNMmlDNXc3czVFdUpxZlUvank1M0lwMytqQjR0?=
 =?utf-8?B?bXNLSG1VenExMFhCYmZ3SUpvdEZkQkNxSk5jdWxJNFZCdVRXMGtlSmxnR0VW?=
 =?utf-8?B?K1NOU3BBenpoTUV4WVNlRDM1YlJ0V04rZ1J6bDRKNTBVWkdhSDQveGpDN2tF?=
 =?utf-8?B?bDNMWkY5TmxZR0lLcXozazE5bkxERE9TbUtTcjRYaTNwcE9HYWo1QVdCNlRW?=
 =?utf-8?B?d2QxWE5xSjZVU1o1UU9kR1NjWi9JcnN1SUxKbmdESEdacEhSY3JpSnZkV0ti?=
 =?utf-8?B?UXV3V0hLc3U0U244VFJYZVRsbmZJTDFSMlYyb1o1REZiQ1QwV0dhRVNVMEF1?=
 =?utf-8?B?enYwUVlnaVJwZkFkMGVxQitQYWVXK3hpczd4U0xVcTJxNHFWbU9tcHBkRUc4?=
 =?utf-8?B?alJqOVdzWTJqSHd2NXJWWk42S1VtWkVmTHRvT2RpMk5hMFNkNDI5aWgzdDBl?=
 =?utf-8?B?VXFuWVVlT09ZVG5WZnE4RlUrZGpESUNMelVDNW05NENxdmkxTnM1MWUwbjg5?=
 =?utf-8?B?cHhyT0M2Y3lVUmdxNDIvTy9NS25aT29pS0RkcW0rRE15RkdWRmwxQ3VKcWhH?=
 =?utf-8?B?a0lNaVVFamFUOHd5aXJ2dzQ1VXNxLzVKWFRpeWVYK3FWT3R2ekVId0ljdlZU?=
 =?utf-8?B?YzlMNVRNdmQ0RE1pcytLOGlUZkFBQVZ3bWd3YmlaaXVHelpGdzVGampZdnB4?=
 =?utf-8?B?a0RORzUrTGpOaHIxL3JhelZmdnRpWE5kRDVHNGlqYnQxWVY3Sy9xS3lKV3hB?=
 =?utf-8?B?OVVvcXNSNm8yTEpDN0k0ZjR5Njd5aWttMnkzOFdrcnh4cTE3bFBmUyt0MVRC?=
 =?utf-8?B?N2F3T3dvS0czK21oWXdTRURySVBMRjQxYVI4c2ZENkRMUXRZVjVWSHJxUWRS?=
 =?utf-8?B?Y2JKR0ZVOXE5Z3F4MVlRUml6L1N5TVZsejlUbzdGLzhYaVlPL2lyeG1JNW4r?=
 =?utf-8?B?WFdEeUg5Yk1JSHg5QlRPSmx2ajE2WkZPaWlKQzhJNE11OWdoVFpXWnRidUxU?=
 =?utf-8?B?MDJHSFo0Qld3L0tlMzlPK3NmWGh2Y1k4UGdOL1V2NWhBSkQramlXOVkvZ1Ex?=
 =?utf-8?Q?sox4XdXTG3uTNOeKV6+ub+V+tUXZdDGjBHeL0er?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 407969d9-a4fb-4cf8-4fc7-08d8ea898382
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 03:46:01.2203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K6hrbN7Cq/7iPGePRj35Q+X8GAbykuRZ9OqzR3lA+YfE4IAebN0dF99iCbL7Pt8L+xrTSOrWH6gdxpuUFZzzncjNjQarHhHkH+E7ZIHpTEE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190023
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 spamscore=0 clxscore=1011 phishscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 20 Feb 2021 10:39:51 +0100, Christophe JAILLET wrote:

> 'mpt3sas_get_port_by_id()' can be called when a spinlock is hold. So use
> GFP_ATOMIC instead of GFP_KERNEL when allocating memory.
> 
> Issue spotted by call_kern.cocci:
> ./drivers/scsi/mpt3sas/mpt3sas_scsih.c:416:42-52: ERROR: function mpt3sas_get_port_by_id called on line 7125 inside lock on line 7123 but uses GFP_KERNEL
> ./drivers/scsi/mpt3sas/mpt3sas_scsih.c:416:42-52: ERROR: function mpt3sas_get_port_by_id called on line 6842 inside lock on line 6839 but uses GFP_KERNEL
> ./drivers/scsi/mpt3sas/mpt3sas_scsih.c:416:42-52: ERROR: function mpt3sas_get_port_by_id called on line 6854 inside lock on line 6851 but uses GFP_KERNEL
> ./drivers/scsi/mpt3sas/mpt3sas_scsih.c:416:42-52: ERROR: function mpt3sas_get_port_by_id called on line 7706 inside lock on line 7702 but uses GFP_KERNEL
> ./drivers/scsi/mpt3sas/mpt3sas_scsih.c:416:42-52: ERROR: function mpt3sas_get_port_by_id called on line 10260 inside lock on line 10256 but uses GFP_KERNEL

Applied to 5.12/scsi-fixes, thanks!

[1/1] scsi: mpt3sas: Do not use GFP_KERNEL in atomic context
      https://git.kernel.org/mkp/scsi/c/a50bd6461690

-- 
Martin K. Petersen	Oracle Linux Engineering
