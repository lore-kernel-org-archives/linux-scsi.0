Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF659C4743C
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 18:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D433461185
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 18:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhFWStm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 14:49:42 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:22516 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229523AbhFWStm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Jun 2021 14:49:42 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15NIkJGR011017;
        Wed, 23 Jun 2021 18:47:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=FKnPBh6So8kGBC0xk1LfzG/WmKaynhaDCtQTL9oPrpg=;
 b=Rb1ynvhYeXm4R7QV5frJtjQkWO2UBkNBZ8/nwkaR1x4Z/j4rG0uJw2NbcgwpKj57ztZm
 GvnhtfLjmv+ue3ydlwaxg9gpIGaJGPlXnaMAgomK1KA9Z8i2nOYB+lixWuacFbGJtEZy
 6SHO6BEy3iaa2vaef1dfnbzDc6ByC3CHO6wGoFtivzlT2SiwPUNDIkMKL2ZVbIxWR9QO
 hPkOGcjhZ1LHYxmV85sMlJjkkZQba/2tvWS8uUpW3XpdD3yK2rNUro7OCt5E4g9HfprU
 l+fVT+JvQ/nMrTiYlw496BZO70PjxXftj/2GxK3pSYtcEFQz2sw70BBYeJv3oWXkA7gw KQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39b98vck27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 18:47:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15NIjUkI187769;
        Wed, 23 Jun 2021 18:47:22 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by aserp3020.oracle.com with ESMTP id 3998d9gag3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 18:47:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XWHqH3ixzCtLbZEzoYYci/9nCbd4SEnlrZj6I1bpeTm1qNKqSayqAK0JWw7sLpZEZpnyNEZz5FLq0myAdjCvNTgBckFFUs/nHcRWInfxy7T27igJVpGSMSaTr5IqslEscVFiFG6xkJuU4iOlq/sFw7WnfdI6KuaWw7gfmXP+rbTR8MpvLHZe16AzEDoV+t+kqxrXgwJLVDu9fQnURcGwufn4X1gVYaJ8fM7DWR7H9l3Vo1vxdIy3gqhyODLHySyuqiJd11R2D+zX+pnQoKynIrbZb2fBu/VaJiCy+lj+n+hLViYm4vuXP2gYRnhrMndCgv+BSFFjLLByUZ6hRHbLpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FKnPBh6So8kGBC0xk1LfzG/WmKaynhaDCtQTL9oPrpg=;
 b=fwA3kXsRwbZ39Idlm21HknY2imeC7tMsBo9MvRHRCZEW7JW3iZ006E/7o+IbMmWY437Q+1pwSTobKi8ow+B73dxoCltZmbL1+XROiI62CYfpMShfGJs8Y6aVwbF4wyDN7+Wo8SIcSTpowtDI0/5FsLXk06cUvtBCHIUJy2riXQE6q9JqPgXrKTZrk4UAsskGYncdRsvRrwd3neOmrmB1xHigI8MJhcsyoMjyOBP7e17a/HYE7jXtUlyc6tNhUh2/ZUx2l3hAvSdlICo9K8w77UCK2LqNr7t1FegCi/o2gaPhtugbGlZI7UstziF/dAVuj8QxohNKBRcIo6qZAq30rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FKnPBh6So8kGBC0xk1LfzG/WmKaynhaDCtQTL9oPrpg=;
 b=Q21hBMEnv1jb6VbRbT2Rf83PjFWSCgDAaL7BN/gbIuMvL9ZnX8DjZq3uU8tQruRzTISLP0HGu9szL86Qaaqb1vokHOk+qBPdIrvpqJ1TH3huQyU8GuC3GS12ZTMQcKtvqM1hmWMn3Ip6YKLeC7TzH/TIxeRatI2k7c25oj57LS8=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2512.namprd10.prod.outlook.com (2603:10b6:805:47::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Wed, 23 Jun
 2021 18:47:20 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4264.019; Wed, 23 Jun 2021
 18:47:20 +0000
Subject: Re: [PATCH v3 10/11] qla2xxx: enable heartbeat validation for edif
 command
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20210623102611.3637-1-njavali@marvell.com>
 <20210623102611.3637-11-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <9862c087-71b1-92e2-677a-a74330212de4@oracle.com>
Date:   Wed, 23 Jun 2021 13:47:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210623102611.3637-11-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2606:b400:8004:44::23]
X-ClientProxiedBy: BY5PR17CA0038.namprd17.prod.outlook.com
 (2603:10b6:a03:167::15) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:2001:92:8000::f7] (2606:b400:8004:44::23) by BY5PR17CA0038.namprd17.prod.outlook.com (2603:10b6:a03:167::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Wed, 23 Jun 2021 18:47:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf679f23-2899-4ee3-c66f-08d9367754b8
X-MS-TrafficTypeDiagnostic: SN6PR10MB2512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB2512A8411D6ACD46213674F8E6089@SN6PR10MB2512.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UaIqsDpdKxNnS79HCRA27JbgMxgEYZlQarv/LSv43AV3wuA93r3cYCZsOVSf+Qf8mN9gnDHndlTFlcf4TKffkRt3rIVv8f/T8up0j8r3GfXbjXfNDyFZ9QDX0j/w3LS0wTgMWUfwUaUV7mRWmWoMRug+FLchLOvDFu+khfvgLLDLLxi3CQ8Q9nPKoRhgfCzIXuXW24cIHkTayg5ri7SnW1nlVdNly6I25jIH6/53fD4tuhK054LLHcwDaPsVbL+cmiQiyOpVJSbnNdTSEpF7MmVtx4Ijt3VR6wOfmCOvnGLjgBDutRAKmFRsKrAP4S7yP/26vgt23vg6b4hTKp/lR1Ecx2fD0CQ7EswG1olDKMEWyTGui9LLTkRLEWq543Wjy4arTwMqDi06H6c96hLxFzLvcJLY3KSHvsz+MrKW9x/8+7VRKZeOlRqYLKbb33mFvZD5QuUNhGHeAMLYNUYJhZ0VJYK59ZRMkAOWLcMxmKHO2Jr0a+IG/+9+b77kimGRRq0/MwcaifqPPIelQIc2c0dUICN7GfCvef+Sa9sd2OYC/RazmPiqEcfjt3X9VxquGzltqzQxTsIMMnNcK28OEC/hjwK+iXao64Vh5yOhtv4tyI1lH7s1obDzp6b6oqzRV1Dizt3HU6PSpY+cziqeOiTOYj8zcoB6UgJj8sMe4pghTdVLSeTMcxWO9VYzvxcZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(396003)(39860400002)(346002)(53546011)(186003)(16526019)(38100700002)(31686004)(316002)(2906002)(4326008)(6636002)(31696002)(8936002)(5660300002)(66946007)(66556008)(66476007)(8676002)(44832011)(2616005)(6486002)(83380400001)(36916002)(86362001)(478600001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGg2SjVYZmZzY3dxbzhXbkw1OUIwakpnT0dNU3B3L0xFenJkbmQrdE8wY0tl?=
 =?utf-8?B?RzZhVzZHdXFGKzVHOHFwaXpUQ3VkNFJWbi94eitkUUhXbDg2azZBaVRkOU5h?=
 =?utf-8?B?V042TWJxa09GOGFidVhSY0t6czB3amtsMWFMcnB2R1JDZHZsVVhLb1h0MUcw?=
 =?utf-8?B?RkRJZjVqaGlrOVA3eDZPUVZDeXBuREpNclBFM3oxd0pERTVOWENjQlNCd1VC?=
 =?utf-8?B?U1lmVDR3YlhoSmplWWZGU2FVYktjdklTbXBwTmI4WFkrRU4vc0d3L1dndDd0?=
 =?utf-8?B?T2d2TUJkSHVnTFQzRXBvMzFyUlpjdWR1UUM0OXkzK3JleEVLSFVHMUlXK2sy?=
 =?utf-8?B?aWoxRUVUWWZNQnJudno1bXhITlNyTHNHZGY3YXNzaXA2Y2hCQXJYWS9qR2hp?=
 =?utf-8?B?VlY4RE1LYjA4RmljanFQVXllS0VnRDhpM242OE1Ud0g1N3hRWWRrSytOa3Nx?=
 =?utf-8?B?OVE3YUV4OUVtK1poakVXeUdSRkhlUUNKWVVhZWhCdzNmR0Y0OFh5UjY4TnVI?=
 =?utf-8?B?ZHlFMUZYYnZiQ0ZXbit5M3B6cFlTbnNUdytOdGFWMnBSMVpwSWV3STZKaWh6?=
 =?utf-8?B?NFVNOE03bXcwVlM1WXJYTHNrN1pyMkNmaUlaMGRQdk1JT3JpbktJaTBkcFNR?=
 =?utf-8?B?OGpiQzR1N3VMdTRxallBRDdZY3d0MVhMSFY2eUh5OEIyZGxPSmxpV0FxbXlJ?=
 =?utf-8?B?czFlc0djd0VpZVFxMTdiaTl5U2V5Um9VcnQzZmxSQkV3bjd1MjNsRVBhOUNh?=
 =?utf-8?B?ZVFpcFJEVzBkekR3RjJjeU5LWmxna2szWXI1aE9yUmlGWUNlaStqeTdKNjFW?=
 =?utf-8?B?bldWUmZ4M0R0LzJQSUVvTTlKWmQ2SlhuS2lqeTNsMVNRdlc4emYyVENQYlBq?=
 =?utf-8?B?R28wYXFWSkVZYVN1bzhWUytjTFlleG9qdENKY2NhZExUdkFlZU1ZVGNMTHlV?=
 =?utf-8?B?YUl5cjMwWVQybTNCdGNCb21DZDVyV3M5SWxTREh1Q1BENzAwUHAwUDJxdnBO?=
 =?utf-8?B?aTQ1ZHBjQmdZVnRvL1UwMFJidXVicWlMWFB4djFSMFVJWTNUSTlGc0JVWGxp?=
 =?utf-8?B?RXhMK0lhODM4d1Nncm01RStpL3FyWDBOaWl5QWNvUURNdmsyWTR4cFhQdzhz?=
 =?utf-8?B?dWwxQXQ2Ynh6d1R0V21XNkNubVBXZ3ZUTFVWWGNWZWNVNHdyWDFMT0pvSGNl?=
 =?utf-8?B?cEJEM3lwTXc5aTNGUXltUVdRMzZRR2pJcEY2S2o5SWNsOXhIeU5GU3M1RWxT?=
 =?utf-8?B?Q3FLS0pIVXRnZHFoaWp0M3RJaHhEb2czQjd3UmpWRkwvZENmTHBTUzYyckVG?=
 =?utf-8?B?OHUzMjRVU09sUUMrcXpPQ1hDejMvSkRZcGRINnFQa3Q2WWE1N213bC9CWlFS?=
 =?utf-8?B?Y09VeTJndmpjSEdkd1JXTGFKb3BOS3J3RE5NeVVtUUw0azJGSTNxYkRsMWt0?=
 =?utf-8?B?TFlxcHZCSThDS1VLWXloU2RKRGYyNysvUVlDeEozcFl0Y1dMNmVwMlhDZUhT?=
 =?utf-8?B?MHpiWkVITzZpckJDbzV6SVRCTTBhUVFydndOYXFNTTB6V3NOam5uVlJKMitm?=
 =?utf-8?B?Z0pDU1dtRk9yMnpiWFFkYk5yeGdJbU1aMWVDcWJGWVkwUHFGQVI4R3RLNlFV?=
 =?utf-8?B?V1lHWnlOY3dwaEo0d0UvYlpTdU5OSThubzBrT0pEYUVvb2htNmVYYkthaHFQ?=
 =?utf-8?B?Yjg0Szh6U29qWXo2Sy92NFZPNk9NVG9XOG80Z3JhSGNxL3dpOFVxbjIwZGRM?=
 =?utf-8?B?TGNxa3dYRXgzWWkzTG9PTWkvUmdjUUtZZ1NiMTJFMkhobWRuN2pmTWpINy81?=
 =?utf-8?B?Wm1HbXJ4QnNTZExqQStpQT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf679f23-2899-4ee3-c66f-08d9367754b8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2021 18:47:20.1398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6dwux6O74t7t7ZJck7e6HC43r6Rk3OyzOI1BinNU7Vq5TM2zRIyb01kfJ4NwOQWox1ocnVUYHkQncYyKTfjbl5iXIo1BGz5LOcql+VO71pM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2512
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10024 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106230109
X-Proofpoint-ORIG-GUID: szhuQ1b34IrWwmzDEvjTyyDH_UlM_-6r
X-Proofpoint-GUID: szhuQ1b34IrWwmzDEvjTyyDH_UlM_-6r
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 6/23/21 5:26 AM, Nilesh Javali wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> Increment the command and the completion counts.

I don't see enablement of heartbeat validation code in this patch.

Am i missing something?

> 
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_edif.c | 1 +
>   drivers/scsi/qla2xxx/qla_isr.c  | 3 +--
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
> index 8e730cc882e6..ccbe0e1bfcbc 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -2926,6 +2926,7 @@ qla28xx_start_scsi_edif(srb_t *sp)
>   		req->ring_ptr++;
>   	}
>   
> +	sp->qpair->cmd_cnt++;
>   	/* Set chip new ring index. */
>   	wrt_reg_dword(req->req_q_in, req->ring_index);
>   
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index ce4f93fb4d25..e8928fd83049 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -3192,10 +3192,9 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
>   		return;
>   	}
>   
> -	sp->qpair->cmd_completion_cnt++;
> -
>   	/* Fast path completion. */
>   	qla_chk_edif_rx_sa_delete_pending(vha, sp, sts24);
> +	sp->qpair->cmd_completion_cnt++;
>   
>   	if (comp_status == CS_COMPLETE && scsi_status == 0) {
>   		qla2x00_process_completed_request(vha, req, handle);
> 

-- 
Himanshu Madhani                                Oracle Linux Engineering
