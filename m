Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A77C4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Nov 2022 09:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbiKGJkQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbiKGJkH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2022 04:40:07 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C2613D65
        for <linux-scsi@vger.kernel.org>; Mon,  7 Nov 2022 01:40:07 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A791ugA013598;
        Mon, 7 Nov 2022 09:39:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=h5qns7uY7uxTTmOIjWp/3Vx7UuLDXxfsi1KYPhUhHEE=;
 b=mDaRt+Q6JKjfhnVA3KNteFhcJ9V9b/2P0XHWhfuS7597LvDYVAcZ1kocwQC73bvC1002
 bn1TJRJti32YJOgaKpo2QMB7cFBFbqOIYPWAkNEEVC4ApuNpq1dADT5n/wrjVbYCNvwc
 9Zsm/7FzH18ZehP/Ere3MrZonrY2HgVGKoYjzrmcc9/GpbLpc8scAVHy466d5PG5KV8A
 kcOlSx5VCqI8af4ZnUUf5JkOtnr8Kbll9gHtZ//AuxTiJxMBZXxX1ztypE+0ye11m9Sb
 JuIFd6PXaxTf13XIMPvCIg3WygHZ1HnzUlUEmpuzwSZC+FQo7OeJsyfmoztx/ppoJinJ bw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngkfubbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Nov 2022 09:39:55 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77sC1k014373;
        Mon, 7 Nov 2022 09:39:54 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctaumsu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Nov 2022 09:39:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YXHFtE/qJhH/ALS/OJrfm0RsIM3q/fI2ylMcZZ3CFtbGAHt2jvFEA+poXjFpL5YBtJYCuD4Kdi3P1bB7HDZqE07g0MGhBPr4fQrQBbMo66IJK3lCUWAZnVqiQIp6Dx5juikjGydvlkdZYpJ0gBSsaPlV0UCnQC6QuPRfphhSkf3MXjWzATBhtZyi8bv1cyVaQZqTFwCXm+AE5Cxe8pvVxRnq/AUB3ubSfGmHpGqIH9W+ZOIMrWkLrFEqNLCYNIlfPvGt3Kvz48g/sbnnUFw1MRKsJwpDAWr926WRPC3VEtDbNUoZEVIeBi6UlWmrBtCHG4EsIsB7hVrpZ1Sh8iifsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h5qns7uY7uxTTmOIjWp/3Vx7UuLDXxfsi1KYPhUhHEE=;
 b=fXDUJzecOCfgpB7DDbiXH3L1uCHmq2vUnsH6IjLupO2202zclPzWTGXEBi2EcZRTLDUyfsw6xMmQcudysX+DAt6R8kzidLR9gxj93lLMQ2EQgm6Z/nSqtUntIiEV1iWQh0erpDoXVqF5YC64ZjnZxyk7nNfxbC1ydxWAIVL/wewvnxzW2GLyCMFMPS6QvEeMh3yxZE63GUrMsxZk18Uo+TKI406zbV79YP6FlSIbxzTLlJGe5myBXs9xz45HRdF2GJdzJR+NN8K7eEDD9j7zzqE+rtfTY1h1xq3Nb9CUiWC/OHmnypWXzuWn+7U5joymyvjWxzI5SMoON9T7xaafig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h5qns7uY7uxTTmOIjWp/3Vx7UuLDXxfsi1KYPhUhHEE=;
 b=ic7+KxHqE+5R15n6rdS0pzDW8es3hL4x40gC/kgRIT/02mxCADnjQMpeuzKk8KzzaFLV7xPxL+QTfZ2mV+R0RN7HDeG2iM/3uyuNK/bzxqRMtx37lFDg9QJifj6mN76usut9frbs2LFgCLdtYWCVgVc8L34LC09RkNllGpEz9Ps=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH8PR10MB6340.namprd10.prod.outlook.com (2603:10b6:510:1cf::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Mon, 7 Nov
 2022 09:39:52 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::d0c4:8da4:2702:8b3b]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::d0c4:8da4:2702:8b3b%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 09:39:52 +0000
Message-ID: <1ea3837b-cb41-b0f8-6108-d515b1c4fecf@oracle.com>
Date:   Mon, 7 Nov 2022 09:39:49 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH] scsi: libsas: fix error handing in
 sas_ex_discover_expander()
Content-Language: en-US
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com
References: <20221104092734.4110745-1-yangyingliang@huawei.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221104092734.4110745-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0210.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH8PR10MB6340:EE_
X-MS-Office365-Filtering-Correlation-Id: eea1adf3-2861-426f-421e-08dac0a4055c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DucRjNtJE1KdZT8C19u8kZHsFUF/95wOHoyFlQOE8zeQFQKT0Zl5t3lmV61jQtTyDIdDhoW9Z760YPy5tu4TqIrKAwjkJQZhNq8MJYygY6rmTQLprYgaOZgmrWxUhYefQLR1W++Amro6RZJGpA7zJXaOwu641CoF63Ws9XuGF0+6uxR0pBKxWl1QKlmIcUeTfctn7Gtg/KQLtJ1S2qQ7WW2KwvbzGBzbUNLlH0UK7QE60MzExmYHk2KmgChRBzxZJO0oC4oXwn3laLSSvN78Jtbdp+AM+tQ8oMQU+8uw8pcEPXvkazx/rcDl6sJoBbYJqiQYVF5RD03kwvZD/GcYDxroVRYUqQqLeGLb1b4ZaDUhSBeVxGLbXqv+agMHWaLLvsKx1L3fmtoDpxPtayhdEV91z3lawLlR9Zo9/DajNFBxJgJNIMHmrdj+MFt82mBo6kD2786+FRankL46KuoGD+N1/aCcYtGX53PR70FwkFEJtZN0+9OaaHenzpMZXMXzp5s0ZqrovAkcGvAQ9BuN/OkWGI6jDQxwDTwhKo1MiWGYRqJ7X1ZhGvF8Cjo5EDpwhbW8C2dQHoGPKVoUIMJ0SjzOvnsRtnYzHAZSKzGk1swrMHEZu+WuXWcgNFk1Q7vRtyfVmHFXCtQJw6uOtpneSiyjW0a285Pcycnm4hUg84daRszlIwVxHlu+8pUGDqAH2DaXNk6NxPyVTOja2GHmeU3Cs90S1jSMnr5SgL3vPjVDYd2G3/j5j37Ly9oEavNIMMd/Tbp/fAH0zD0ruUm1qGUzh9UGUUPidBy4k+dtksbTfQLL1uTxr+oX6V8XcCC7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(376002)(396003)(366004)(136003)(451199015)(83380400001)(31696002)(86362001)(38100700002)(6486002)(41300700001)(966005)(478600001)(8936002)(5660300002)(4326008)(66476007)(66946007)(66556008)(316002)(53546011)(8676002)(2616005)(26005)(186003)(6666004)(2906002)(107886003)(6512007)(6506007)(36916002)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUUvaGt0dWFSNG1wRVVhcDJzNmZDLzJxTWVPYWZNbS9VNXFqQ0sxbi9qbUtw?=
 =?utf-8?B?NEYzQWw1OUlSQmRiRlpBTzZKdjg2R1ovWml1Y0JQSlE4RGdrUjV1dnQ5Sys5?=
 =?utf-8?B?aFNWUERlMVJ5MXdQbnNxb1djQi9JMDdCMUI3clpnRDhYUTdZZ0E1QnVONjR2?=
 =?utf-8?B?a2Z2TC9Jbms2YS91NW1aSUh0NmpsRG5sRzlLUW5aU1JiUXg0NUlqWDByNHpz?=
 =?utf-8?B?cEpFOXBqdjMyVkgraEVRTU80UkpqL3JuT1d1MmRnL3drUHhEellZTm1XZ0R4?=
 =?utf-8?B?UjNieEpYVEcxMkwvdWpRSW1wUGFPaGFyTDgzcFRtZktIQ1h0Q3FGc1l6NW4y?=
 =?utf-8?B?ZE55TEcxWFVBcEpzVG5FcFUySktRMmh3WWp0SWtUR0Y3dDVSRGFId2RMYWhz?=
 =?utf-8?B?UW5ROU9id1dJSDk0QWpIZXFTaHNKWXV0UHd0MTVBYWtycHJ3WHpYdXBFKzQ2?=
 =?utf-8?B?aUtmd0V1SEc1SU1uZGdwc0YyMDI2cVZIWmlHaVFqck1UZFJlNnQ4UHFNV1hG?=
 =?utf-8?B?K3FNMDUxTGJqWVZzWEsrUjNoUmkyUnczcDd1U3FZSmtJTnZVRkdwVFV2L2hW?=
 =?utf-8?B?bVQxRVV2bHpwWXJzbUtrUWxvalhSUURxTDk3VFl5U2xSeXRyUXJYbFZKTWdK?=
 =?utf-8?B?YWREWVBTbktXUzFxK0w0RE1nNXZHb2V0OEJLa2NiRXV5bUVpSWNmSEc3L1E2?=
 =?utf-8?B?dklWZFNPSTV5U0M0MGh6VHNINTZJVm1IL2owbXBPWSsrSHlzVUJHRHlhYkM4?=
 =?utf-8?B?MzN5WTVPWXFRQTVSL2h4ejMxREdBUCt5bU9jUFdKbTFBajVRbVZIQlJuU3d1?=
 =?utf-8?B?YzVuaStrNWd0Ti8yY3VGWThEVyt6RnZzYXFHV2pPZUI2R3hmeUJJdW5ldXV0?=
 =?utf-8?B?Y0FRYi9IejRjUEY0emNSV2FLY0hQLzZiZnl5eGJwOC94T0J6QVI5RW1SQlZx?=
 =?utf-8?B?aW5WT3NpL1Q1cEN2eHVFRVBhL3p2Q2x4bDdTdUVSNXRCL01vanN1aU9pZUpi?=
 =?utf-8?B?dE9lN1o2NVFZWXV0UDNmd2JPbUdUUTExaFBFWFlkM2pSbUQ2bXhtdGRJTk9o?=
 =?utf-8?B?eG5DaDBNSE9leVIwMGFHWWlRdmZrZUU4czlFLzhYbHk3QVhGT1RHT2RkUEtw?=
 =?utf-8?B?NXBkdDZaRUxKR1hhdm5kRm0rcjlHanEzN2FGcC9NTU40b3VuYWZPd3FEcFk3?=
 =?utf-8?B?Qi92MjNKSzY5a1ovS2hZS3lWdGljS01kOXJUeHdLcGRmbVV4Qm5mamw3M0s3?=
 =?utf-8?B?UXY1aGp2MWlZUGYrMmVSa3ZrZjhOOTJoWXNBdHFDMnAwRDZqRzNYak5mZ2J6?=
 =?utf-8?B?OHhrUkFFU25WZ1JBaG1IRXpSYUIyb1BRd2JoaG52eGtLaXBzbFA0Yzc3MWhV?=
 =?utf-8?B?dHVOSDgrNHlwZGE1SC9kVFZMSDZsR2JReEUrMStEZzBZbytxbUhTeElpVkh3?=
 =?utf-8?B?R09mQmJpWTd6dVNBTml5MkpZT2c2bUlxVlpaQVpGdEc1dWhDdkdJby85WTBK?=
 =?utf-8?B?K0VRTmEwd3FLZnBpUUplWStUVmVZaFpTT3RJMmFyUm9nZDZ2VEFMV2txNVN1?=
 =?utf-8?B?T1FIWnF6bmlEWmo5ZzlnNXg5U2tkOVlDVG11clVQU2R6ZStJVkFoRTNvamgz?=
 =?utf-8?B?a2ZGL1BpbkhtK21sUWtBVkJIcjczaFJ3dlJGc3o2WEUyWDV5NWIyWGMzR3pk?=
 =?utf-8?B?cXFQYzNQT2dHbnRFSk5FNFIyUG5BR1VnR3V0QS9xeWlvK1F2ZmxwTjdJQ3NX?=
 =?utf-8?B?RW9yd05uTXlPbThDUjZudzl0cVlnMnFWWjkzZWFFQ1hjMUduSFRqTkZQYzFs?=
 =?utf-8?B?Nm1Fa3FtQ0FrTnkremJjK3lPeGhuUGg3azlDRWlxWi9yYzNhYUtsZ2tCRGlD?=
 =?utf-8?B?QldnQi9TNER3a0ZMcDNVeURpOXFIMi92c3pCRXN6dHVyTmlOOUlkNEMvVUdG?=
 =?utf-8?B?d0FLbjV1elQzNXFsdnh3UlgyanpBaXp1V05hWVo3U3RwNCtkNHowNU83RDR3?=
 =?utf-8?B?ZDlxcXFTU00yK095WVVxSDVpeWZobGJmNFpIODVKNXBTZS9WSUlhNWZDMGpD?=
 =?utf-8?B?QzArOU1ubTVKcVpjNitYMmZTazZLUVQ5SXY3Ykp4eWMrZWQ5WEFsSW5rNHgw?=
 =?utf-8?Q?FyQYeybXOUIZNPRu+N6vLt7AX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eea1adf3-2861-426f-421e-08dac0a4055c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 09:39:52.5323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S7VUXoyUxDx+HXXfc1IgIYS0Yn0RvoEZWUOolZjLOjC2nToMLKHEz/mS+Id68NW2QCM09lRQqMDGrHWBGFTzFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6340
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070081
X-Proofpoint-ORIG-GUID: ZrTqqbhDYWdnROxmU7BYBbxYCEVe7jCs
X-Proofpoint-GUID: ZrTqqbhDYWdnROxmU7BYBbxYCEVe7jCs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/11/2022 09:27, Yang Yingliang wrote:
> Check return value of sas_port_alloc() and sas_port_add() and handle
> the error. If they fail, free the device and port, then returns NULL
> instead of using BUG_ON().
> 
> Fixes: 2908d778ab3e ("[SCSI] aic94xx: new driver")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

I already sent a patch to handle all errors here:

https://lore.kernel.org/linux-scsi/1666693096-180008-7-git-send-email-john.garry@huawei.com/

Do you actually have a cascaded expander setup to test this?

> ---
>   drivers/scsi/libsas/sas_expander.c | 13 +++++++++++--
>   1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index 5ce251830104..88b8b955d533 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -935,8 +935,17 @@ static struct domain_device *sas_ex_discover_expander(
>   		return NULL;
>   
>   	phy->port = sas_port_alloc(&parent->rphy->dev, phy_id);
> -	/* FIXME: better error handling */
> -	BUG_ON(sas_port_add(phy->port) != 0);
> +	if (!phy->port) {
> +		sas_put_device(child);
> +		return NULL;
> +	}
> +
> +	if (sas_port_add(phy->port)) {
> +		sas_port_free(phy->port);
> +		phy->port = NULL;
> +		sas_put_device(child);
> +		return NULL; > +	}
>   
>   
>   	switch (phy->attached_dev_type) {

