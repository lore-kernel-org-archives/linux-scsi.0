Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B7FC4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 18:05:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbiKISFI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 13:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiKISEl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 13:04:41 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D924A109D;
        Wed,  9 Nov 2022 10:04:39 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9HsjCa031178;
        Wed, 9 Nov 2022 18:04:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=XbFcMA+ob/e/mMyM1EUOh/W4GDtX2IGQ3xwej4S/+8o=;
 b=FL4JLPhLk0XXFYIL2ctseU5EdQ2xcWOxpyt1SKbR/4sVIhg+sqk0IQr5xf7+alYwbTOZ
 ESWM9GmCZ7YGw4HkkRbkqrFhTofZ+B24W4iTsSSFGDKVCubt2G9bzTCpC3838qy3teHP
 aPutnCFSsg9hOhvHyf6yN1MbmmMJuJQCb/DGHRsHOdYfUzpvyBkEQtLRbc9ULhGfRUSp
 CxK7l3CXAblTC+7XhSAR1eQgYFye26gnUjPZ/rgB3ss3Ur0uC7jmPjHxQktpIJ08TltM
 5xU+3c6OICaTPRACjsfRISnJ3C2w5DNXmEfHeQozn0Roy3Hk5elV96YR3Vzxbg6W28Fh 6A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3krh16r0dq-68
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 18:04:13 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9G69HA039974;
        Wed, 9 Nov 2022 17:35:23 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqhsuaw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 17:35:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ibDbuZNOzWCkFpVEzBAUwZMxiywTyQDdfNCWqZWU1W1A98DSQHXnJHJjrGD4FO8T2ioGHG8mFJ49LwYwJS6tPCKYgWkpU696UaSp7HROFdXY2v7UfqSGcRvX6x9t66NS2zHd4IQ7pSo42SlbbfoNK3qV8dsLCECFDZx0LgZdQsS+uagvQqoXGAFBOvnVewuDSxbyWKYc4r/Mtg/8wH2W1j+MqzcvU+a+JSDQo063xo7E2zS/jhqrHStqSKt4dD9X530vKmGYDbmrsbbVkNc0Jcf8uiPEd3xDTxTow862Q1EqaIBtfhlUzM75rlB/dM/N8kazKQJo6+UQPL62YyQq7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XbFcMA+ob/e/mMyM1EUOh/W4GDtX2IGQ3xwej4S/+8o=;
 b=eLfHLAdQ4FWimARrEEpB7RUO+cihcRJCVaMiK8wjKXunGMcd1VXPNirvKtC0jpxrv8UY/QrXXSvBz52LahsTE2eXdPPJEDyNGsD8fKJ7QmTmsTh+78vP8FcV9+HMFo3yRs7TwDPo6LPExEVpolHRgQqEguVnXfZ5+n+r9uMCkR9oN+joVXCOTWixBPk6KFGd7Pbia+B68HQbAiOsVMQ3mbaM2MAslAI1JYBavfnMZXFsbLGFgQegA2IjElcM2+SJQd35/cxLdlezzc1gE1qB0DJVV4rsnrN+DkEBxlDvKaCH0/uNDWy1ONPzm5tz+tDy2BMvwOJQl/+HBtUoIvu0Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XbFcMA+ob/e/mMyM1EUOh/W4GDtX2IGQ3xwej4S/+8o=;
 b=UrY0weomVr3zuTyD48Wnk3KMVJC0lus3zI5Rnev0SObZ/cAr345MrR6rlVhhkxwnS4iVoDYrAC8XHdiwxdk0wuKw8yA23ElCwMGyGl7SZ5VY6XWPZTP4PkunWF7Z30hSPPEB1G2bx8aNF8kkg62qzWNDkgguUzsLoROERek/6Is=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB5157.namprd10.prod.outlook.com (2603:10b6:408:121::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Wed, 9 Nov
 2022 17:35:22 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 17:35:22 +0000
Message-ID: <cd524e32-d154-cd67-39b0-5f153a84125a@oracle.com>
Date:   Wed, 9 Nov 2022 11:35:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 3/3] nvme: Convert NVMe errors to PT_STS errors
To:     Chao Leng <lengchao@huawei.com>, kbusch@kernel.org, axboe@fb.com,
        hch@lst.de, sagi@grimberg.me, martin.petersen@oracle.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org
References: <20221109031106.201324-1-michael.christie@oracle.com>
 <20221109031106.201324-4-michael.christie@oracle.com>
 <9df9d0cf-5583-ccfd-ffd7-54432767fdfb@huawei.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <9df9d0cf-5583-ccfd-ffd7-54432767fdfb@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BN0PR04CA0116.namprd04.prod.outlook.com
 (2603:10b6:408:ec::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BN0PR10MB5157:EE_
X-MS-Office365-Filtering-Correlation-Id: d0763e6e-66f7-441a-1eac-08dac278c72c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 99DlVKTyCxEbDfLnfO3Q99K6/+OLLfg4jPEbU53UoP3QuBe+KwJWlfepqQFYN+rYCswnxBAJeQBw18UBPULsGaQmmHBKMGfP1SbiQDs3RPmgyRo8c/daHbRGe3OhEIWmz/4fYKNJuCF7t6gp9PELQiJEvF3vDhFqFyd5tm7Z5zRy7eahb5vWCHDbHF1WUA6d5iuVbqg9Q4vzOsMemSt18BfbxaUI8D8v2linSBE7FHA3N54/9Zwnjr+IdvKWjLyMp86qUk4p5Wmqmsg/QPI+TrkzbjhUSphm8NwPs9DQECktGHjRQUJJ54J68YTaDswixKv3TXP9AD1jjjXMFZTdmhpfJoJsbEPUnTOFRnq6/2RyKXWX3VJxrmeTQG+iBZFZ/J3vx8d6Di+tJuTYeVJ4T+LbXusuB1qltIxcsmeFPs+jgUv9sjmS6Vr2lCEx5m4OA+iTIoAEnejZfJB8TFUjZZLBMaWWTnzm7zxKmCYHvtuDnxjH4c4QRR0Zkf7SgJQbhZwbDMOJKtHh6yaH8ZSGjczGSsQ1lSbzddsk01XanCMEoOSM15zqop4+doOTX/bS9WNHRYdpz0zqbo80PBYNNxey+MX6iI/roSS/8+qJVRfP+Ui+XooSDvsZY0eG7dO0k0Aleloi6YKMbe/Qg6486HaKehrgGkWAcVd+WAr/bCxI5ES+7tOMW/lUUsRZUnlYbAjRs2tVefCsbOyslKj2UwS325D+S85CON9ILTz2X2VUVvDIyNx45X61cXwa3oDJFPS4av2TYUf0XaoVnv9lojSykCyQAgD6UyWNO2f4WO1wbzNFARQKSkhqfBZFab9j
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(396003)(366004)(346002)(136003)(451199015)(2906002)(478600001)(6486002)(2616005)(186003)(83380400001)(6666004)(6506007)(26005)(6512007)(921005)(53546011)(38100700002)(31686004)(36756003)(66946007)(66476007)(66556008)(31696002)(86362001)(316002)(8936002)(8676002)(5660300002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MWJRbHZkZFhsR21acUV1RXhPRDRvZ1RLM0ZHc1QzSmNJL1RDYit3UGRFWGdt?=
 =?utf-8?B?b2ZNc1dGK2Z5dHYzZDMyTzJkd0h4Uk9xN0tVOWRZWHdFaWJqME90RVBFSWVV?=
 =?utf-8?B?WGU5NVJ4NndsZ3ptTitEOGVMN1hGS2hUTkNMUDZ4YnRJV21IR2xudER2ckxW?=
 =?utf-8?B?MzdMSmg5Mit2cHBlNHBGazUzK1crZCtXWks5N3llcVRFSGhoL0RVTzhxV0xF?=
 =?utf-8?B?Vzd4d3oxeTh5UTZvWjRnMnJqNVJQWm1wWDE1YjcwSVZmS01oNHZ3SjE2WDRJ?=
 =?utf-8?B?N1BBZXRQU0RXdjRWc0dMeDNuWC90MjdEM0NvWEhIbFFoc2szRVBCci9XYUJl?=
 =?utf-8?B?RzR4Uk1ya2tyOUJVWCsxRzZORUcrS2ltNmFldlA0dEV5ejVlcm5Kb1V4MzFv?=
 =?utf-8?B?aUF6cGljWFdyUm83YTR0WkxDVjlhTW1uVi9DSVh0UXdOTVlZYlVmYXBQOUdm?=
 =?utf-8?B?Ky83ZEJYSlJPZnVLdXhObk9pV1VkV2M4MGwzL2VKZk5nMzRoMDY1Wm0vL01v?=
 =?utf-8?B?TkE2QjBUSEFtbnk3YjE0RDhtMU5VRVZsWEViTlRmZjdUOCtrN0tqdWcxUGU4?=
 =?utf-8?B?UFdIak1CS1NGb3ltSjNYM2Nsam9vNWN4RGtRbDhUMFZSbDMzYlIrUUl0dFVB?=
 =?utf-8?B?S2VCaXJUSXJ5cFUxcUdmcnJ6SGVYczg4bHIrWGNZYUhYeEZGYTR0bURqQzVt?=
 =?utf-8?B?M2RzaWxUSFFBZ29kRWZrcTZDZ0ZmRmRwMVR3K09lRFRGdGFvVnhwQmZ5UjZk?=
 =?utf-8?B?eGNHY3o1ZnNTNkI3RzlqSjFrekk1WUhTTkQ2M0RCYmRFN3Z0YWVkNXZwaVlR?=
 =?utf-8?B?N2NpbzlmYUZucmN2eUliOFhUc1d3Z0NOYmZEcDc4bENob1M0eXNqUk5QMXF5?=
 =?utf-8?B?SVN6YXowTllheCttRHp3NlM5bUk5ZjZMeWNvbkI4WDRPN3JwWitUV0NDYy9L?=
 =?utf-8?B?YURId3dRRldneE1tdzR3YnpQMWJuaWZuc243eFcxSWxQNWg2eHFDN3dsOWNi?=
 =?utf-8?B?QlNORjBPUk5vNC94QXB1cS9VbVRxK3MyY2ZjYk1YNkJOWjRpNm9vRnIxTUI2?=
 =?utf-8?B?b0ZCNU5oSVFKcXM5S2dhREZNcm9xMWgrN0FsQXcyRERpN0t2UW9UdVZmenZZ?=
 =?utf-8?B?L0FJc0J2QW9zWkxnUk1GanA5MHpLZ2xHTmdLSXAwSmduQTlZN2tGamRKUXhn?=
 =?utf-8?B?TFVWRi84aEpXMWZFdkR5L0RZVEgyR0psVUhOMFBNQlMza2g4Wk14YTZhN1dv?=
 =?utf-8?B?TEhMY2RjU1F0Ky9TYUQ1ZXh2U3FYZERqSXIvZGFmaHNxUXpLby9GbkJOdy9N?=
 =?utf-8?B?VXJCQzZUU2NtRVBQK25PU1NVdTU5MU5mTTNySGdsYjlrTGgxUXZIVjhPNFA1?=
 =?utf-8?B?MVB6bndnZkpUbHY1QTBDZm9sWE5jRElBaVZ6aElTS2toNDc1SlNoMDVqK2VX?=
 =?utf-8?B?bU1QWk4wSE9FMkhIeTFnNkVkbEQzMWR2VFlyeDhTR0FBRjlFbGRqeFpLTmZD?=
 =?utf-8?B?VCtDNlNOUGt4VVN2TWhhTWdNVmNOZlZrNlZFbWEvTmlyVWY4L3A5TnRFOHVh?=
 =?utf-8?B?LzdUNWNqN01qUXllYkJVQmJ4RmlBaVBtcldKM1E2eVdia2UrM0xEbUtaK2xx?=
 =?utf-8?B?VWYxdUZuSHh5anZPVmJ5NmkxQ0hIeFN0U3ZkbXF5YUFydlcyeU5nK3BtWEJ1?=
 =?utf-8?B?eVlhWitLQTgwTlJZVks4dkdwc3piakJtZHI3blYzY2gxSFBEdjZMWVdpUWt4?=
 =?utf-8?B?Y1ZpcSt5NXBDMUZRdFZaYytOMTJPTjNOd1haSzJPdlB6QWgxQmVmY3dFcTB6?=
 =?utf-8?B?eE1QMFlNSGNvdkt1aFVQUEtmQ00ydEVSQllhbVpzVlRMTGd0ZjB3RTNjWlRQ?=
 =?utf-8?B?Nzd1UEZBbE9OdGplZnU3YWtGRTRCRFhrWFE0RGpxMHlQUy9qZnN0d1RWNEdX?=
 =?utf-8?B?aVBxYWFFSTY5REt1QnROdlNBa3ZVRFBSS1VPZDVFNkJFZThrODRlc2QvaGpB?=
 =?utf-8?B?c2NsYlhsSk04RityeHlZdTdmOXJmMWdjdHNucWVMc2V6emdjdFFFakRSd1R2?=
 =?utf-8?B?cFFleWFobERUK2ZENC9GMFdOSytOeHJaWnZZMzRmUEdKSmd5UHp5U1Y2d0Zt?=
 =?utf-8?B?R2N6N2RVMThZYnNEeEY2eVN5Y2tzaGlIMjUvbkovNy9BbTlYc2xTejg2dkY1?=
 =?utf-8?B?MkE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0763e6e-66f7-441a-1eac-08dac278c72c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 17:35:22.1642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ihS4knVa74bXV4M9cGr8dtm3PkOufnSPkY7FU0Y/KNDkB9H1cwmkPmRjvoFuE1TG79otOAGS5kJZFbMNXPJUGoYCu+ui2SMWukP1Pnte2NI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5157
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211090133
X-Proofpoint-GUID: hlIv8JkmjNt6KjPtlX3Ahxriid82XE8P
X-Proofpoint-ORIG-GUID: hlIv8JkmjNt6KjPtlX3Ahxriid82XE8P
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/22 2:28 AM, Chao Leng wrote:
> 
> 
> On 2022/11/9 11:11, Mike Christie wrote:
>> This converts the NVMe errors we could see during PR handling to PT_STS
>> errors, so pr_ops callers can handle scsi and nvme errors without knowing
>> the device types.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>   drivers/nvme/host/core.c | 42 ++++++++++++++++++++++++++++++++++++++--
>>   1 file changed, 40 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
>> index dc4220600585..8f0177045a2f 100644
>> --- a/drivers/nvme/host/core.c
>> +++ b/drivers/nvme/host/core.c
>> @@ -2104,11 +2104,43 @@ static int nvme_send_ns_pr_command(struct nvme_ns *ns, struct nvme_command *c,
>>       return nvme_submit_sync_cmd(ns->queue, c, data, 16);
>>   }
>>   +static enum pr_status nvme_sc_to_pr_status(int nvme_sc)
>> +{
>> +    enum pr_status sts;
>> +
>> +    switch (nvme_sc) {
>> +    case NVME_SC_SUCCESS:
>> +        sts = PR_STS_SUCCESS;
>> +        break;
>> +    case NVME_SC_RESERVATION_CONFLICT:
>> +        sts = PR_STS_RESERVATION_CONFLICT;
>> +        break;
>> +    case NVME_SC_HOST_PATH_ERROR:
>> +        sts = PR_STS_PATH_FAILED;
> All path-related errors should be considered.

Will do. Just one question.

I didn't see NVME_SC_CTRL_PATH_ERROR and NVME_SC_INTERNAL_PATH_ERROR
being used. Are they retryable errors?
