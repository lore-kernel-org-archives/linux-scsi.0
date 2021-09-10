Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49812C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 16:47:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24803611AD
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 16:47:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhIJQsS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 12:48:18 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:56184 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229448AbhIJQsR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Sep 2021 12:48:17 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18AE3OqX023692;
        Fri, 10 Sep 2021 16:46:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=EDo73wPqUxx+/Ae576NdMUoHle/LLbuPOlHzbBAJF1g=;
 b=OSVSg6G0440SQfLE2OBZwqh9qYt2c02qR36LG4oEdlKCxIF1u+WbddUCu9/K0Wg7LcSb
 xf/Qf3akN68H0bO86YRdND6OpiZhgi815wxFHpPa9EMjnE7u2ntOkpNGkEFqyj7OS/fn
 LInJ57UCR6UXiXIfuSWvUnMrQlAZSo6MrurhOPA8WKAHdg4L6f3bpv1VpggqJfF6LRtb
 uCz7LRIQa/hMQQt5RSfXTKmFg0NXPDOH9PUb/QvsbSvsLgDdor2zqH6glCha50qo7gcT
 3LhxwB1ZUSwnZCknoUcfAe96/uwSZBIyeSel3ou+sD3te4/xurW3ZxvQF7eLH1VMiq2+ jg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=EDo73wPqUxx+/Ae576NdMUoHle/LLbuPOlHzbBAJF1g=;
 b=dk7aBKh3kCefoHeFnCRZ7gazSss7LN2P1B52LI5XWjzkZL0HDsGF9xQRC7tHbdYUR3/m
 6K/1xKvuhIPApr6i7zhODlinRdlN0E8pwh/mrWeLGGP2kEE5+LxV2oC3NEDcdYNeG2Ib
 u8JElcfBU/NUI/0/N//mIMwHFXlIlEsDOW8URn6G0gRif4zs1YLfSSq5SdrbxRRh34PI
 t125AtsBsUAq63zmqHL/cterNWYeE/OzThJ+tflNqNJ7bNLkH3D9xNgpiRmTs1LiByKn
 8sFHHS0xCdeKbzVnY734lu6/9ZN8L17Wv+8ohxLhdHQMgQWb4NGQROxJpvUI0qplMLXn ng== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aytfkaemt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 16:46:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18AGiwMi073830;
        Fri, 10 Sep 2021 16:46:53 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2040.outbound.protection.outlook.com [104.47.73.40])
        by userp3020.oracle.com with ESMTP id 3aytfdmqke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 16:46:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=laaIIU8OhdRzMTRjezPrrOCS2eUmF2x406mH7vDrKT9PBsCyO98/QGWy206+ZMvdYWhNLoPPcJ31mWLNpq3sbCwSCOllut52TGcfEHV+ymturlAtUHSQRqrq/8dBJFa/nWUhXNkBITSKXWo7Mu3ktHUp/WhT26HrPzNgD6p5hDB/Ryh8rDjFXaA8aZJWMIvlvhNpej2oQK47BBgv25NK3a7D+lj+POyUYuviQTNiAQ75h8gGF7sfQiMpk1Z4t+Vp/XRgV4zlA4h2RWXgg0L5KlI+HnpXPdZZdNrd4PxbeSNnR2Offj9/9OEanFmeMSMa3IETSUmg04fXn6mBYPWGFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=EDo73wPqUxx+/Ae576NdMUoHle/LLbuPOlHzbBAJF1g=;
 b=gCdhJ/SyE1S+G4rnM+p09fILGfL/a4VaVNoHq9G4iCwAdwRaavWEGs5qbCt0Osycu8eoTBeyXDxb6syHJDelDbOTsr9s4gDKpU/c15yTQxdH3uvB74CL9J2+F2DvgVUtLCIBsV0lW/hcqc3kIUmVDNKVMe9QGY4+Bh2FBL22YhjKBKfwl/F2J13JSZW4JSvKD3TR2jGdFjk2bawhtJ3lEeW0wdBv6F2lkoVhQE80j70CGQ1QkxxIXdnDssvT4VM6owiQROz4iamzf0O92YwuPeCCxYSqLYuEZcz6ET7uJllX/mqyPIYH01bIdcTpIAXjR5U5e2KmI5nvMYXSmGHgjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EDo73wPqUxx+/Ae576NdMUoHle/LLbuPOlHzbBAJF1g=;
 b=p3XqLqfe+ixj1tYNug42GnijwZdnIAZyBh1QJuHhjV5xFipAcwy7t1nM7k9VVObkYKovndrO6nuRh+Dt4zLtZ9b5Nw8edAHp3+SKIYI21GQW5Psy9ZDy8HrRBXQCoEvfMirNsWCzUbpwZIMqPa3tjDMsBhfh6XrPlouIVd7GI0Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB5487.namprd10.prod.outlook.com (2603:10b6:a03:3b9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Fri, 10 Sep
 2021 16:46:51 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::5881:380c:7098:5701]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::5881:380c:7098:5701%6]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:46:51 +0000
Subject: Re: [PATCH 3/3] scsi: libiscsi: get ref to conn in
 iscsi_eh_device/target_reset()
To:     Ding Hui <dinghui@sangfor.com.cn>, lduncan@suse.com,
        cleech@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210910010220.24073-1-dinghui@sangfor.com.cn>
 <20210910010220.24073-4-dinghui@sangfor.com.cn>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <4bc7187d-0461-d42c-3a8a-33c0a0a8c1e0@oracle.com>
Date:   Fri, 10 Sep 2021 11:46:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210910010220.24073-4-dinghui@sangfor.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR06CA0020.namprd06.prod.outlook.com
 (2603:10b6:8:2a::21) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by DS7PR06CA0020.namprd06.prod.outlook.com (2603:10b6:8:2a::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Fri, 10 Sep 2021 16:46:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a343f22-d732-4c46-c48d-08d9747a9688
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5487:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5487062F6AB95A64DAE1B241F1D69@SJ0PR10MB5487.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:20;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y3dKhe2SGG3YVH71xNTCqKU3n8J5bCRhlX5zY0mp0nyB4c5ENs+rxLBtahZ25sLbLx515E9hlU0K3XfBBzYKZZ7Muw/HYLo26M82JAX3t5XEwGAAtEze7LCmoJnmbT8Xv0nBfaGSjVBP5KsBzgkHwMNUFUQGWGHeSSZYqZSeXM8Ds/+pXX/7+YrZ8T3q0YyxE95Y0hwCnTRVZSUEm5iRzQixYnnGcZJ4jLzd994LZFTUDcr2IdYy+l5h1fX2iY2kOxvzO97W/RiPOG65VTXTCgjmPmn4b5JJtZq5gRzjvvAfVHFxS+YPbGYABw4mM0QLYFmrdYrlZaBNrMQY+47+q+RFZt9a2SNSdpnZtUKNiXvlCdxk5snYMbGKqS6q8bJGWtcdhJzIV40Ny3UwTqfhlERCiLnMAnE/4nex3zIshTRZuZz3NN4tyw02duJDXamDitdnjkhm57lB4UD+dzyYSK0eUvgaj2gIAs2h+r2JWVYsUrafCoc+cS5ZkGbfXv5MCRZw85C3bvhi0I5bw5c0Hlale2lfwl+OojacvXaDAPEfmX3v6qKrc70Xw7d7wdaK+PFkOY+cKFrzWhNPNKX9Iw2iHniXpZ+cSx+9eImyrabf4Hc29dHCIFQ4l4glE5I9/MHqQcgwuycbPCAAxAjd13028ysu9dM1TL16xYQXP6C8Qle6Mw/vdzl4/KlSgo2wIdVUFOJjT+reulhGi3WqRNMRtSr5Lvo/RAOnHwuyS3uCXYON59H/UkAfg1ZrIDC5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(39860400002)(376002)(136003)(66946007)(53546011)(26005)(8676002)(8936002)(6706004)(478600001)(31686004)(5660300002)(2906002)(186003)(38100700002)(36756003)(16576012)(83380400001)(66556008)(316002)(31696002)(66476007)(2616005)(86362001)(956004)(6486002)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWpsc2lSa3NxSkNnTEJUZ2pGaGRldHF2OEdFZWN1WUROVVgrVkdGWWNyN2Zr?=
 =?utf-8?B?UTk2M3hLV0YrZVk3TG9ZNEx6c2hVZ1lCY29mazYwaHN0djdxeThvU1JzMWZ2?=
 =?utf-8?B?ZTQxUTA3YjJNUmNsWXAxcFMxcXI1WU40QnpZd25LK0JGSVRPenp3T1IxM3Q3?=
 =?utf-8?B?NGNPeFJRNW9JL0VaOVowVW5scXZJUEhtQ3B3N0U4L01HRWF0aHJhWGlLN1Bu?=
 =?utf-8?B?UW9adE1najJUS0tWUVNKQzgvS2ZTaXZ5WmxCTWVqVzVrT05WcHI2L1NtbnJD?=
 =?utf-8?B?ZjBxWFZtWVlhWVo2MzdjeVVOTVliRktsVzY0MUxYU2xzck1veGdUMWZPaDZE?=
 =?utf-8?B?K0NDMUtLdEF5Y2xDK2dnS2t1OHNSdTl4TkZZMWRJUEg5Q3RLNkk4Ukl3M0hH?=
 =?utf-8?B?S2Z3RysxRTJKZWh5NkVRZW5EQXphWk5STWNtTDZOQnkreFlWZEdkWDFETWZ4?=
 =?utf-8?B?MkFxWmxjbjkrVkdNbElFNzBncUp1NVJSNWt5RWg4VFlPdlNvT3RuSVhMSXJF?=
 =?utf-8?B?cllaampoSU1DdmlFcXYwT0RGZkxJdGtwQmw1bkNycUlJZUlNTzV3Y0h1c3Zv?=
 =?utf-8?B?UWQzR0JhTmE0OG95WXExSzhXdUJIOGtSdldFWmVBVGpoaGd2eXB6czc2SHpX?=
 =?utf-8?B?NDJnOEtMY01vbW1kTEw1TG8wSmN5Q0s5VzBrOEFWSW5SM3VpNEpOd3diYXVL?=
 =?utf-8?B?RHF5dUw5aEtyTWtoRkNtKzB6eGhWY0JFWXhmWEYvUkVEdnNWT1dmd3Jmb3ls?=
 =?utf-8?B?a0ZJNlFJc3psNnN0NnFacURVTk5Eamx4MEo1eVd2TDhxeEp0UmxTWkZUMVdt?=
 =?utf-8?B?QmdOUmt5TFpHelVVemVGcFg4VHV2akcvbkRtR3ZPQXlGUUVVSE4zaWxTQUVv?=
 =?utf-8?B?V0JsSWVZak5SNHRoMFZ4d0pSYTN4UisyQzlkNHV3SUFxQzlsdG12MEVTRnFE?=
 =?utf-8?B?NjJXODNqKzAvZmJ6UFY3TCtWVkJnN2tpc1F0eEVpQnZwcG54c0lXYTMrMzNz?=
 =?utf-8?B?Rk8wZTE1bENwMFlSbjQzcVlMcUNLL3RjdU5CYjN1Wm5ITnZkbStzYllxTmRK?=
 =?utf-8?B?Y2gxVjdHVytxNGpodkhxanUwUVB3R3NIWFBmVEFoSUdTZEV5TXZxZktRdDQz?=
 =?utf-8?B?Q2U0Rm5qWWV4bjdaenlvUVh2ckZaSzRLYzJxVk9GWEJ3K3A2T3JsTy91a01R?=
 =?utf-8?B?aWR4bWptMUs1aHp0bDlIYWt5YklxR3VibTRjMEwxODFCSndwYmpWMFpOdmpq?=
 =?utf-8?B?ZDg4enV5RGxobkxNTW9hNW9mbG9WZS9YV2tzOUcxVG91UUdOd1RmYmNGRzZ2?=
 =?utf-8?B?a25aTUt0eFJHUDFURzBKa0V5bks2T0lSVG0xSUNiUmNiQk1TVHdkaittZCt0?=
 =?utf-8?B?SXNMTXRMYXhuaS9MdVZIMnR2cjBaZkE4a2U3akR5SWY2R05GdUtiNUVDeER0?=
 =?utf-8?B?bzA4dlltS3FqRGdQVmhhRFZjRGFDcUd3TFQzSWs4dU5oL1hQUi9seERkRnpt?=
 =?utf-8?B?eVFmY29yZVI3TDRVbVhZQStnYllYRFdOTTRjcWVacjRTQlI1NlBqcmd0ei9z?=
 =?utf-8?B?VUdSUlJ2YnJIaXArTWptRjRCbzNua2VqRGd5dVlaVyt6eS9LMWZ3WE53bUNL?=
 =?utf-8?B?ZkZMUCthRW1iZzZoS3k1NGtxdXlkV1dCNUUyd29BMFNEVHRBbXhQWU5tZUl2?=
 =?utf-8?B?WlNGTis5d1NWKzZnVmdBS1g4OSt5TXRPcGpoVHVDeE1xTzFkTHJ0L2R4bGEy?=
 =?utf-8?Q?cYqWDRentazfpQNLv4vPK/dUBBCev/DsE1zNFBy?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a343f22-d732-4c46-c48d-08d9747a9688
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:46:51.0933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aeMb2zzLh87P4hbQ2npaYwI4NfenomUjuEBnwBvqXX/NXU+ZNWGg6hEB9BeaG66sJgE/gYQbRd4YOe7UnW1iooaS8B/ASRqVfOc7P8n0+D4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5487
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10103 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109100097
X-Proofpoint-GUID: GvuK2Qm6u7dlr-FtOLfTDclO2dEB5kKt
X-Proofpoint-ORIG-GUID: GvuK2Qm6u7dlr-FtOLfTDclO2dEB5kKt
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/9/21 8:02 PM, Ding Hui wrote:
> like commit fda290c5ae98 ("scsi: iscsi: Get ref to conn during reset
> handling"), because in iscsi_exec_task_mgmt_fn(), the eh_mutex and
> frwd_lock will be unlock, the conn also can be released if we not
> hold ref.
> 

This should not happen because we only access the conn if the session state
is ISCSI_STATE_LOGGED_IN. So on entry of the iscsi_eh_* functions we grab the
lock and mutex and check the session state. If logged in then we access the conn.
We then drop the lock/mutex to do the TMF/IO and do a wait. When we wake up, we
retake the lock/mutex and then check the state again.

But yeah, the code sucks (it's my fault) in that its half refcount half locks
and state checks like that. Ideally we should fully convert to the refcounts
and move the teardown/freeing to the release function. I was going to do this
in a patchset to fix up the EH/TMF code after I get my lock removal patches
merged.



> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
> ---
>  drivers/scsi/libiscsi.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 69b3b2148328..4d3b37c20f8a 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -2398,7 +2398,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
>  {
>  	struct iscsi_cls_session *cls_session;
>  	struct iscsi_session *session;
> -	struct iscsi_conn *conn;
> +	struct iscsi_conn *conn = NULL;
>  	struct iscsi_tm *hdr;
>  	int rc = FAILED;
>  
> @@ -2417,6 +2417,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
>  	if (!session->leadconn || session->state != ISCSI_STATE_LOGGED_IN)
>  		goto unlock;
>  	conn = session->leadconn;
> +	iscsi_get_conn(conn->cls_conn);
>  
>  	/* only have one tmf outstanding at a time */
>  	if (session->tmf_state != TMF_INITIAL)
> @@ -2463,6 +2464,8 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
>  done:
>  	ISCSI_DBG_EH(session, "dev reset result = %s\n",
>  		     rc == SUCCESS ? "SUCCESS" : "FAILED");
> +	if (conn)
> +		iscsi_put_conn(conn->cls_conn);
>  	mutex_unlock(&session->eh_mutex);
>  	return rc;
>  }
> @@ -2560,7 +2563,7 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
>  {
>  	struct iscsi_cls_session *cls_session;
>  	struct iscsi_session *session;
> -	struct iscsi_conn *conn;
> +	struct iscsi_conn *conn = NULL;
>  	struct iscsi_tm *hdr;
>  	int rc = FAILED;
>  
> @@ -2579,6 +2582,7 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
>  	if (!session->leadconn || session->state != ISCSI_STATE_LOGGED_IN)
>  		goto unlock;
>  	conn = session->leadconn;
> +	iscsi_get_conn(conn->cls_conn);
>  
>  	/* only have one tmf outstanding at a time */
>  	if (session->tmf_state != TMF_INITIAL)
> @@ -2625,6 +2629,8 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
>  done:
>  	ISCSI_DBG_EH(session, "tgt %s reset result = %s\n", session->targetname,
>  		     rc == SUCCESS ? "SUCCESS" : "FAILED");
> +	if (conn)
> +		iscsi_put_conn(conn->cls_conn);
>  	mutex_unlock(&session->eh_mutex);
>  	return rc;
>  }
> 

