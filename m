Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC9B3C3F6B0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 16:23:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242610AbiHIQXF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 12:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244991AbiHIQXD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 12:23:03 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BB65FAF;
        Tue,  9 Aug 2022 09:23:02 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 279EfbhX005385;
        Tue, 9 Aug 2022 16:22:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=iMWYOkJI+oT7YeRrxS+vu11+QlAX06MUK6W5VnphsAM=;
 b=w5PgweobvlCY9Bdj4xsaA7nXvHZrAnCoNlNSdZS77yr+tPQHy82j/pnuS/VbW+PAtBeH
 +OCwCL+FCv90HuCuxgdtJyh74MLm0bYOgGpevUtQ7hy6nKLG7ppSsq0g5nnGkiiuojXU
 v5ol3YYM9GN1rcLZVcm/kq+gWToM9l4S/i9bqzaGEWeGbvIzlhQzsUvyU+9IhVxWCVFX
 CFgr5GneqwDxvxCE4a0XE+41WKbSm6EYBPxZkMuBCQWZ5mHRt6JK7UX1ae81HRsbZoxb
 CbhfJZOU6D+TkADlgr83UcIcHTv9OOXc7tECcK2eDBwd3uGjq2QdMQF66LVyegviClLR aQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsf32f2j9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 16:22:28 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 279Ev7Ua014015;
        Tue, 9 Aug 2022 16:22:28 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hser92y3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 16:22:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEwjAQrKygROUW1MaV5trkviar9+jWuQB3mbaZ6k0Lzf/HjQDaeFtfDVi2iIXBssuhstE+ItnS96froblF4eNgTdVJvnk6n7l5Fw6u4evlpPYoIkePIKMbsQ/rflCVlPolzwWKKI3phiVIj2LsLcRd/2LopCbtehA0yKaRyA6Mp3EH2VmO1OwTgzMOy+SsaYS1lQnco50ohaPqBrF2SnpItbD+nI/1ZtiuEAnNRpzIG06wYYbF2Hnhe6EwggB6242hlOkT8qKrDErrihLtbip7NjJUP5Ijb+h27JRNHfsgAEePl4jblV0Tg/3q6F0D5gjLKmmScHDYQo8KmUqj9e7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iMWYOkJI+oT7YeRrxS+vu11+QlAX06MUK6W5VnphsAM=;
 b=Pzzi2IHGJW/EeSGCVSUSTioEVXHwTTxhZB4HEcGXIWg15wMjlvvUayZao2ExIrVKrbbsB/Qfg1jWT0kgUvDEkpnIz+NSihOWfa2HzTswMc9NJVZRF23rnt1SUBp+6hCTlACNISkqE/BQMmNt6EojQB9FXlLkdRBi1L17DW5twNhPLAjv4rrjnvFrxQ2rRqWszD15LJyQTO28BGau1y8RxO0fWyZLFfVUgdftcWZsCUKc9zrFuHLpehCphdHdekBjqSSSln8y6FWBe4R1LXWX2KxBvHivV+vvE0UcmKL2G+f56fbF2hlHnG+zWGc/VnKQzy1UgFP3X4Cc/inTLslpSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iMWYOkJI+oT7YeRrxS+vu11+QlAX06MUK6W5VnphsAM=;
 b=Oh5klGLBd/0d7LhKUhNcKyp6dc5Jnty3SQ78ZZD7y9npBD9pgaYVKvBpx3U8Rq72MwLJvMXZDVrmYOVnAH+EaqfsNkxWgIlHq0NagkK5PVg81FmjMSADaoCkycqe+t+Zxr3KYAKFi0piECkhZQXGyo6aBMxtSbtVmh2xRYKJYv0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH2PR10MB4296.namprd10.prod.outlook.com (2603:10b6:610:7a::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.16; Tue, 9 Aug 2022 16:22:26 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 16:22:26 +0000
Message-ID: <cab5ae04-4ae6-6027-190b-11e76431aa13@oracle.com>
Date:   Tue, 9 Aug 2022 11:22:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH v2 16/20] scsi: Have sd pr_ops return a blk_status_t
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     bvanassche@acm.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-17-michael.christie@oracle.com>
 <20220809071803.GB11161@lst.de>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220809071803.GB11161@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:610:b0::13) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81a42f7c-e3b7-4ccb-c457-08da7a235938
X-MS-TrafficTypeDiagnostic: CH2PR10MB4296:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jtKs5NrFMcA0KaPz4oxgmiE/wXkAqoArMk1/Obn0H72vmKZOGRC3YRiaQKhLCayG+OcHod+qFgAfwqDXi6VdCwrDDpBsafYRjq4EM8gxM7ngDFB+yWgtww1PHPLcUGALguHkezQNIgoSZzJK29TmWpuNwpXzZLLI1SqiUL++SF7GGPdPHxBtBSRAf8m1gAeaF+TgGDR6WDAXbHmHn+QNBl7AXAGLk+aJL5QUuilvfQFkgZw2qciv6nHoGZmrLPu5rSVM5lnklvrwNWShwYNLlU8Ztrz8sGBto0ZFu/rqe4sXzC1cxdroav/G5xD8AYxmU0Xk3zyxBQj0xZBUeUSMK3MZRxiwDN08IvPFyfxVftP18Qdo+4PdDtD7VzBcflXS/L7Z8MYjmmBn3I9azF3Q8Awx8MvR6b1qjHABNHSI6/zaMWkGvz2MkNZTISbOngPEdFxKPZKC7JiQD92srerGXIfG+w28QtkM5V7rrRwCnRV0UlBHUjqW8S/TgtKH4kypyZu3qrtdiCDZSa18MNy1eU0B6ltb7lI5nvm9x7v+qAynTIMwoRpwNCZd/OvJ8qyws6UBSWLvQ7GV0NSKJYe+ghT0p+9pEVMzJJ4wycHpZ6scHs1YERmVCsDyEdxPpuFkmNZsgqUC5LNn4rQCnZJSX0gp9FBP6pynQ1gTpphUdOtV10LcJAVWpFfN2BvbVFng6S0iwrYNFAoKB2MQlU/WCZY8SvvZYDDtsSG1abYUnp20caEUdryMz7/IBtWL9Q+Sb5Sr7+cJDv189DYa5ZJobUA5n0QcXgtvU7UB6VFGeKtXWaYgbViwGwPLqgGAFordv3XtkxUb3QfPUPSHf65kww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(39860400002)(366004)(346002)(396003)(5660300002)(2906002)(6916009)(36756003)(478600001)(6486002)(316002)(558084003)(8936002)(31686004)(66946007)(53546011)(38100700002)(86362001)(26005)(31696002)(6506007)(2616005)(6512007)(8676002)(66476007)(4326008)(66556008)(41300700001)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnRTeGlZTVhZTkYwZ2JGZDI0aGNkMlhJOHRjM0RYb0w3SksxT3gvMk9hQUl3?=
 =?utf-8?B?QkowMmM0YXJCZng1aEdLcEtuUHE3WDVJbFg1Y1dzRCtISjdFcXR1enIwcGV3?=
 =?utf-8?B?R3ZCdWhxeE4ycURISUpSYndjY1RKVk1MeWNsSUtZZE5LeEpmMTRGOWl5MytB?=
 =?utf-8?B?c0JnSGdFcFBpQkpjZUtoTHJablpwVTlIeGpPK2c3V2trUDlzUHh1Y0daTXo1?=
 =?utf-8?B?cy9KLzVYVTV5eUJCZHRwTlIyVlA2WHA5SElsNHF2T2tYNWdYL0RoMms5aEFS?=
 =?utf-8?B?OWJjeXlwSjZIUjBEYXN3MTJxZlZ2RTFpNXl0d2pUdnVSTFNMbDcvK2RtdHdI?=
 =?utf-8?B?SU5leE9FTnZmb2t6QURMNEJBT2hHckpGY3g1Q01ncVgvbEdOeFRVZlBzOHI4?=
 =?utf-8?B?bjR4NEYrZXV5MVU5N3ZVdEp0RnFIT05vTkNSZEs1cThUV2JJcVFub2szUnUw?=
 =?utf-8?B?Y2NJY3ZkV0JuZXNFbGwzZlUyZmRGT2lVZzErSzJBOEpTNmZyZGR2akF5TWp0?=
 =?utf-8?B?b2t6Skdacnpqa2NQWUNzRkZ1N3Roa0lvV3hicXJ2WXUybXF6blFLZnNCeWxp?=
 =?utf-8?B?clUwZ04yRzdnUEtWZ0E4YlRVV0pRNGFULzl6SlBQVWoxNm45UHdaSCtHbU13?=
 =?utf-8?B?Q1NYRFRGcS9ZRlhWZlJoN1RpOENzenhkK0c4ZjNzZnpMdjVVYVYvOGxRVkhi?=
 =?utf-8?B?UUdPbTdSdXNFOGtyVWQxdTN4ckNlYVF3OTN2ZUNDbzNNREVFVmc2QndpMWh3?=
 =?utf-8?B?dXBUQXh3THpaWWgxWWlSMzJyYzliNkRSRmtVVnRsbGF6NGZ1WlBvWDRVQmVD?=
 =?utf-8?B?dk9BM3JxSVptMGpNeTdycmdLYU9kNjduM1lxUmhDcW8xY01RVGkrVG4xZDM0?=
 =?utf-8?B?M0JDeURGQmZQV0dTQ3V0RmFGc3VpRFlCUDVpMlIvNlZpOEN5V1loalg1Ri9a?=
 =?utf-8?B?SllOYXhYL0IxM3FKQzA0VitmRDdtU2hId2lPYktIcUJLeTRNVk9RUklMYURG?=
 =?utf-8?B?R0Fuc3ZVYk54UTZOVis1MWQ1bTcreDA4amtrUHdpRVNML0ZEaTFiVTRmY0pC?=
 =?utf-8?B?OVNaa3krdGVJZ3FyOHBVQkJKcEpMWElITmZzQkZtVjdSYk5GQ0ZCQWJVVnRa?=
 =?utf-8?B?Q3Z2emNhWVJQTWg0MWNoYXVmdTRkdXZBSHQ0Y2pvdU1NUFcrdDlZVmZVMVd6?=
 =?utf-8?B?YmtxTkxReU1xV0JTOFpVQUZYV00yb3E3UmtLZzJLMzBFckZsWlVaeFg2d2ZN?=
 =?utf-8?B?b1oySEtYZUhBQlBzbFMyUmd6RUVrVmY3SjBoSDh1ZVJZL3NCQmF1NFVxdkhz?=
 =?utf-8?B?RngvYzJBNlMweTYxUTJXZFBrYWFsaFpwd01HSmJIN0FObVBjdTd1OHJQaHJo?=
 =?utf-8?B?NEMyVHdXK3VBVTZ2NGdPYkgxUjhCUE9KWnRSRk5aVmcxL3J5Mkh3T0pyRUMr?=
 =?utf-8?B?ZGYydnEyVnA2YTBMUUlCOS9EYi9HZjFZLzlmZVRzUkxlQU1XODkxOGZiRGlp?=
 =?utf-8?B?UVp6ZXRud3MzdDdUTCtMZThFWE4vbmN3Z29KdkZLR3k2QkE0TTR4VTVvRFRB?=
 =?utf-8?B?ZHBIbC9KcHh6Nzg0ODJGTFFXeHlacU1DdisrUG1SbWk1K25BSmI3azJVSVJz?=
 =?utf-8?B?Z1lyODl4TlBhVWl0SktLUTV0d3crNUhBRUgzNWw2a2FRNWFCaERXa0hYQ3BZ?=
 =?utf-8?B?bzlEK1JXeVByQWRiei9zYklISnY5T2NnR2s0VE5kd2NMQmN4RDRQdnBKanlo?=
 =?utf-8?B?VEIyNnM5c3FDak02REU5eWxlOURBb25EQ1AzTU5lYzVONUNHU1lYMXozcTdB?=
 =?utf-8?B?QTE2SkV1ME9mdUZmYjBiL1VNZzJRaCsrdEJlWXp5K1hiRDkyL09FcUN5MzRu?=
 =?utf-8?B?SHJZdDl4YjIxWWZNbW56U1VGMjF2aW10bXZsVU9wVk5wNG5CNGNvaVM4OEZz?=
 =?utf-8?B?U2VmTnBvbkN4Z3g2M0xlMnFIQ0tZN1FJbnhvRTZqUjZkUVp6Qi9VazlEQ3hi?=
 =?utf-8?B?a3VMUlJ3czJOY2x6NmE1TWdRekYrQS9IQVA0cE5hVUdnTVBkaDZmemJXNzNo?=
 =?utf-8?B?cmk3WnMwS0FFQkVjV0NPQVU2Z0hycmRoazVpQU05N0k0c3A0aFN0OGtiaGhj?=
 =?utf-8?B?cE05TUVabWQ1Q2tjUGFKZkdzdTN3aGczazBJZDZvOWhNeTNUb09hY0g0YmVZ?=
 =?utf-8?B?eHc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81a42f7c-e3b7-4ccb-c457-08da7a235938
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 16:22:26.7089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BA2gsC2ooaOYoD22bJEFarypB7iopAsRObPkBgtrnw/NbSOE0vlDihcDDncBBTIgBC5dbxrvAZc8nZz5fnbQXlrWp+sQ3mzY+Z28T0h/fds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4296
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-09_05,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208090067
X-Proofpoint-GUID: MlOVPe7ZzdhyZYDiuO-bXEVIUHqEf_wA
X-Proofpoint-ORIG-GUID: MlOVPe7ZzdhyZYDiuO-bXEVIUHqEf_wA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/9/22 2:18 AM, Christoph Hellwig wrote:
> On Mon, Aug 08, 2022 at 07:04:15PM -0500, Mike Christie wrote:
>> This patch has the sd pr_ops convert from the low level SCSI errors to a
>> blk_status_t.
> 
> Can you document the why here?

Will do. Also will fix up the comments in the other patches.
