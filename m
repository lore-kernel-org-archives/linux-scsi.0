Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0928AC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  4 May 2022 15:01:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351705AbiEDPE7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 May 2022 11:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351672AbiEDPE5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2022 11:04:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE582D1C3;
        Wed,  4 May 2022 08:01:20 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 244EXaN2029440;
        Wed, 4 May 2022 15:01:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=OHWcOtW86uVb11ZYus/te07w9zqDTQjC+DhEzsXlAsI=;
 b=IYdgkTqWxedVnKyY2xvyGeQ7jva+kOaxgO5z1gLtGeL0CSyfUs6TLqTg0lkRUgRYv30r
 BXY3CZiDXrZh8bbi8q5RI1afvcdjWHHl1vYYAVpYKC1NaE/3rZx/xGAhiQh1HE6rBoyY
 pdXCK56rknKrYD0AFvrcy6rgLiOECt/Y9fqX22q0HX91FdVHftvDim/x6Z8Ko5DESvMs
 0cwgMrOqZLK1dL+kiM1zQ4h48UeTBAJ9ICSBk/udOz4ko82EEKIACFCzHGNSeLGmH5Cb
 4NLoJKra9orKbkM40hvaA9A52A95etE6zROIIcy6av+GoKt4wwIXhNV4V84d43KCjMpf GA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruq0grmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 May 2022 15:01:13 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 244EtSvZ038948;
        Wed, 4 May 2022 15:01:08 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fusafmgtn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 May 2022 15:01:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QXVyLPGZhZ4TkM6/cAdO77PSavKsEdsZHD+orvSvuT3LuwNLRXuLmveYRHlBHuZHWIVLdhYP2kXMGfCwH9jYUMHMn82GXs4kMTAEJRXjoAweZMVisXa2cHKob0t3SI3ZDEGA2/YJ9wyj52gpiAISqQlKkxHSX6yplzNTihoqcATDSgRBsoH4bAxdh8aQaRLX8yqpmnUXwk5cFOOsyDMAQpJRtzshfgttWNTYIwXuqzSbl0xYgF3Is4HfX3Wi+q0XvJyiTvPB4yIgECOBpHjVkmLd0yauXKlb19mXGN9snBfrxhTzHCwgD8Ovsc0Fey4S3dcb7N+Np1ddSO0v2lrReQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OHWcOtW86uVb11ZYus/te07w9zqDTQjC+DhEzsXlAsI=;
 b=gxP9lqv75pIYtqwoaBfB36WJayUwHwZdlmCzy3KuJnaL1w1IwxRdl5g0nkKnCZdtgGfuhqbqK4nh74mXzGlwY41TdB1dZ1bofmi3YgdG1gzl+iJTyuY9pp9t1Wj5PirLK7JwD5SbqeaW7rdVZNqQ1EeQOtO/hS+IW5LcSSKCh1Nwb1tl/Oqm059Rf3sWz2lsd9lSNahUkDRaCknzv27kLw0fXTCbE2ouaonTc0lqhrIgBrn54jiF3LEhwOLMt/H7acMKsb5SerXOIn9BYpINnEMJXXfztP2KkeXBDLhLJsa3eAcGkdDTazjpIGtAQ2HckkxEEoB89xV6AsM+f9IPEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHWcOtW86uVb11ZYus/te07w9zqDTQjC+DhEzsXlAsI=;
 b=zGhRG6QmeyN/wGgzOhnkyqRApBMpwhX7LvXJqlAiJ1zwLzS9pNh2UFvg9Azo0kQ6YzYOYMiHUTxOvBFivsMx2yA82u0O2tKCmKlKcxr4zlhQrlhm08Amca0F/xXkP1/OyxAeq18TrKuaV1BNgblk0phWb5GVMZDgzZO7+ejJjX0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM5PR10MB1692.namprd10.prod.outlook.com (2603:10b6:4:8::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.20; Wed, 4 May 2022 15:01:06 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586%2]) with mapi id 15.20.5186.028; Wed, 4 May 2022
 15:01:06 +0000
Message-ID: <87fc30a1-be89-1a9a-a088-1b3b7d7778e3@oracle.com>
Date:   Wed, 4 May 2022 08:01:04 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH 3/3] target/iscsi: rename iscsi_session to iscsit_session
Content-Language: en-US
To:     Max Gurtovoy <mgurtovoy@nvidia.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, martin.petersen@oracle.com
Cc:     hch@lst.de, sagi@grimberg.me
References: <20220428092939.36768-1-mgurtovoy@nvidia.com>
 <20220428092939.36768-3-mgurtovoy@nvidia.com>
From:   michael.christie@oracle.com
In-Reply-To: <20220428092939.36768-3-mgurtovoy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0014.namprd08.prod.outlook.com
 (2603:10b6:a03:100::27) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f065cdc9-5dea-445b-2c13-08da2ddeea80
X-MS-TrafficTypeDiagnostic: DM5PR10MB1692:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB1692AD9DAA5378BBE30041E9F1C39@DM5PR10MB1692.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h7cpT4Fqa+D1mgbRgsjwJzgnDzhdKIiyCkOzhiduZk/94YZxUTNAQVvkLYXM5+/VblEx0RlWz9nQTLt0UabMIJ/Quu0yudV83dYbDvwc8Z6UoZCb6u7vpR8EklZmLHvjc8v/VjQhK+AfG7LoKfbtoc3S2sF05ioYzKF7wtuZE6ErHTnsIh2hhxKt4l/mD1WgvepdkJkXxxhRcWqQ9kSA9P53atjN2yV9eO69zd8ymsXXggrAMJ2dz+otNCeIATvSYAxc0GgyDxRHnB0hijEVuexEQza2MqxtCYARcAsbNKOSPe8rm1PjlZKymP33LrMj6x9VqqfWDDtExtjQHpikl7q7hAk7AC+2JHNlRGtbDvZQUW/Y4BVFkTDqS+TunTbC8xUwBg33b2DxQSHipIFX5dOKEUnW7B1el2GjJxO73Vv5jX0+wFAYPJ98ONbf2xtsNd6RtoZ1NSLmN6EoGMRkGnR+hpmaXBpNx2w87dPbKCpDvMYSjvFxdDolP2kGzNRU0Ii/QiADN/2pJtxfo3upUJZ77TeqQpM3Q5umlSsVkF5c4A48WjBEBD7oncnw2YhxEfkPj325EK+EkjnT1lVZQ5W2mF1A60KCTuxOavxQrysAqV7M3je8GEdnyvIMDlRySnFN22y4KfwVb/7OFEIEMtIUJNIOjJUDIDY3FXJzDXkRkhFTZrWD6y16c+pN47nEbspM00VbxvOriFN7A2pjxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(9686003)(26005)(36756003)(53546011)(6506007)(31696002)(2906002)(316002)(31686004)(86362001)(508600001)(6486002)(186003)(2616005)(66476007)(4326008)(83380400001)(66946007)(8676002)(8936002)(5660300002)(38100700002)(66556008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S2IySVV0M0ZTVlFBeEgzMHQyS1YvNitLMFpxYjJmeEl2WjFTQlBpbHgzRUdT?=
 =?utf-8?B?WDl1YklReEVNT05XVmw0d08xMGRZa08wSkFIMUZEbHBYbFRmRXN5cjVLUlVK?=
 =?utf-8?B?UjZ3MmVDZlIyeC92anFqQWhFSUtnQThMWCtEcTV1c2hUdlM4YmpHOG1LZ1k4?=
 =?utf-8?B?azVsSEtYcHg2d2djRk9Ec1V2c0E3V001U3BqdWRQRDhHQXFnalRUUUMrL09F?=
 =?utf-8?B?aWZXVnVYZkhHZFJZZFQrdjVUOWJXRVk1eHkrQVZmZmdIWE1ZRERqRmRIM3g4?=
 =?utf-8?B?QnlkVUlkUk1tTXV2cDNjVEtLcUpaVWIvZjBCbUtIa1UyYlYxQnZ5aXU1QWtm?=
 =?utf-8?B?R1VWeGNsT1ptSmx5aE9rVWNpSnVIS1ZHUmFJeTdiOUtGZTNEb0M4VU8zbWxK?=
 =?utf-8?B?dE85ZW1pMmVRYlFGRjI5VDRpL1FWMmRPbDlnWDJFMHkrUDFlcGtlWDVsVzYy?=
 =?utf-8?B?a3FURXdvcXJuWHZpUmtUeEN0UjVTYW5aMmxLQktSL3BUcldOQnFFTDVvYStm?=
 =?utf-8?B?T0NiZW5oQlRUNEtTY3BTU2thNmNkL090VkRmOWh0d0JLbnNaTWtteXVxK2Vq?=
 =?utf-8?B?R1dySFdNY09vdHA4WFBlb1crTmpGS3ZxajAxNC8yY1RqK0YxQjUwekcxTm1B?=
 =?utf-8?B?S2RtbStQWUhHRWM5eC8xV0dLUklta2cyQXdvMklBTDEwRTYxeGRYTVpHeHU3?=
 =?utf-8?B?NUlON3hiRXR2RjluZWNtOW1CSFY4SU45RnZJVkkwTnBHYUMrbTh4cmZ4TkxU?=
 =?utf-8?B?Wi96NFBNYVpMaGFBTXoxeERCdEtsT09rNFlrcEhxTkM0anprNng4UUJGMy9W?=
 =?utf-8?B?V0k0SHFsWTNOTjMxL1o2REIrbGlRMlhJZFZENmRLcTNPd3Z2ZnJOdDEwMDZX?=
 =?utf-8?B?MTliL1N1NkRzMTFGNnBvN3RQUHpuZXgzVlIyak1vd1dJMEx6WWdoUzJ0cDN6?=
 =?utf-8?B?SnhVdDE3dGIyc3YxMWhyTGRiekkzRXJJODJhL2V5S0g5RGh2ZG41NUNabUho?=
 =?utf-8?B?MUdqU0oxOWNRekxTTnFpM3liSFIweXpjUmtlTDM1dVdld3FZVUREY3pOcVpH?=
 =?utf-8?B?TnpqTjZCd09RM0kvUmp6WXhLTXViQ1cxK2VzYTBFWU9SOXpFVjVqZmtlT2Ra?=
 =?utf-8?B?RTJSSCtzTFIzaUFPRGg4SGpwQU04UGlVYk9qdE1mOWEwYzVuNElDZGFNc3pZ?=
 =?utf-8?B?bUlyaWRTWlRRYW1rdVhGSUxZZG43ZjlNN0JpdmRySFdoam80MERMNUplaFMy?=
 =?utf-8?B?KzNseVFoK0R2d0NDMk5QVWF1WE9EQUJyTGo0MUIzanltdDAvY3ZRbnpFbmUw?=
 =?utf-8?B?MSt1dmpraFR3TmtwcjRNYStQN05UbXZscmRLbzRId1JLd3BCb1BjQ0d6cmNI?=
 =?utf-8?B?MzFyM3RSRW8xakhUOTlTVmo3aXJObmtIcWtZUWtTRnB3VzdTQTBHdjljalRI?=
 =?utf-8?B?UWpORGxRaHdybG1vK3hMdlBzNGRoeDJvcmcwZHU2ZkxDdVVnWWJFNzA0WGlq?=
 =?utf-8?B?WXNUOTJ2TzA3QU84S0p1QTFxRW1Hc0xZNEJRaG1nZWh5M1VlN05pK0RBSkwy?=
 =?utf-8?B?M094bk9GWmw4UVoxQTRGUTZhV256RVRUaTBiQVBnUUtINHZ3OXpJenQ5OEcw?=
 =?utf-8?B?KzJkUGFaVEZDa0FXNngzYzdZbDVXNU1XYzJVRDFmcGlhSFVVS0VlZ204emVF?=
 =?utf-8?B?VUdFRnQzRDVSNllyYUVHZk1tVUg0S0VzRzdCRDJzN1pIQTdORWZ6bGdCWTU4?=
 =?utf-8?B?YXlUcDMvWVU4dFVBMkdWMlo0MFVkL1I5bXNTYjhNUXMzN1Mvbk1zQVhuQW9Y?=
 =?utf-8?B?WGRSRm9FUlExZE1HWUpnSFdhaVVDVkFYa1YrY2Z4TUlWWFc4ZFgwd3hyNHRR?=
 =?utf-8?B?M252cFdpbEF3RjFBa2ZBU292KzhMY0k3QUFrQ0VtYUVNQ3BHS3ltWkt5SURF?=
 =?utf-8?B?ODFZdFh2L280NkdJV0dmZUtlM2krYVFRSm1QUlNsbUxOc1hLUzlIZ1hhTFRq?=
 =?utf-8?B?UVhjZUxuak5wazhYN1JiZExkRTJGRzcwczFBeGNDOG4vU3FZZGRWbDNVUjF4?=
 =?utf-8?B?dmpPUUFibmJWNys0MnBvZWdtVVN1c2g0N3k0ZGFyV1FyZmtJOGJhRzl6MThP?=
 =?utf-8?B?WG9yRWpmOHYvK2VrM2pOZmZldXF2b0dKSmlDR1hlb1E4a0FzMS9wSjNXM1Qr?=
 =?utf-8?B?a1NZQVNLaWtSV040TmNseUlBaURmL0tqOUEwanNxMTVEV0V4cXV5RXJBZmdB?=
 =?utf-8?B?YWtuRDdkZkh0RFJXalJOOTd4aVFHbnFCc09PRmxwL2N1VzdqeVVnVkNZc2M2?=
 =?utf-8?B?emY0UkFSZnR3QzhJMUx4cm9jWkJPZVRscFZnaDJhUGp2c1lOZlRMZEZoT1pl?=
 =?utf-8?Q?VV9/KYQI8Iv2DB3Q=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f065cdc9-5dea-445b-2c13-08da2ddeea80
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 15:01:06.8010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +WHQboqRDTkFOTsqdg70t2lEbq46KkqnmPfwrW7m4aOz7HjU+Ay0m1wPKcKxUVCDI57lks6cx7YaNHKzAD1W5TeZmq1rELZBOtiBQsYAAKg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1692
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-04_04:2022-05-04,2022-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205040095
X-Proofpoint-ORIG-GUID: wiSsXBnP9mYLV0vlL0akXO9nbCg9Z3AZ
X-Proofpoint-GUID: wiSsXBnP9mYLV0vlL0akXO9nbCg9Z3AZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/28/22 2:29 AM, Max Gurtovoy wrote:
> The structure iscsi_session naming is used by the iscsi initiator
> driver. Rename the target session to iscsit_session to have more
> readable code.
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> ---
>  drivers/target/iscsi/iscsi_target.c           | 28 +++++++++----------
>  drivers/target/iscsi/iscsi_target.h           |  8 +++---
>  drivers/target/iscsi/iscsi_target_configfs.c  | 12 ++++----
>  drivers/target/iscsi/iscsi_target_device.c    |  4 +--
>  drivers/target/iscsi/iscsi_target_device.h    |  6 ++--
>  drivers/target/iscsi/iscsi_target_erl0.c      | 10 +++----
>  drivers/target/iscsi/iscsi_target_erl0.h      |  8 +++---
>  drivers/target/iscsi/iscsi_target_erl1.c      | 20 ++++++-------
>  drivers/target/iscsi/iscsi_target_erl1.h      | 10 +++----
>  drivers/target/iscsi/iscsi_target_erl2.c      | 18 ++++++------
>  drivers/target/iscsi/iscsi_target_erl2.h      | 10 +++----
>  drivers/target/iscsi/iscsi_target_login.c     | 20 ++++++-------
>  drivers/target/iscsi/iscsi_target_nego.c      |  6 ++--
>  .../target/iscsi/iscsi_target_nodeattrib.c    |  2 +-
>  .../target/iscsi/iscsi_target_seq_pdu_list.c  |  2 +-
>  drivers/target/iscsi/iscsi_target_stat.c      | 16 +++++------
>  drivers/target/iscsi/iscsi_target_tmr.c       |  6 ++--
>  drivers/target/iscsi/iscsi_target_tpg.c       |  2 +-
>  drivers/target/iscsi/iscsi_target_tpg.h       |  4 +--
>  drivers/target/iscsi/iscsi_target_util.c      | 28 +++++++++----------
>  drivers/target/iscsi/iscsi_target_util.h      | 18 ++++++------
>  include/target/iscsi/iscsi_target_core.h      | 10 +++----
>  include/target/iscsi/iscsi_transport.h        |  2 +-
>  23 files changed, 125 insertions(+), 125 deletions(-)

Reviewed-by: Mike Christie <michael.christie@oracle.com>
