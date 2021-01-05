Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A521AC433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 22:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61D1722EBE
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 22:54:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbhAEWyt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 17:54:49 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:50044 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725838AbhAEWyt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 17:54:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1609887220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mvo9kip5QFMxbCOFXRYLAga3eGpx+WF7/cWeofl/hMc=;
        b=QQbrSn4DDzctklOtaIPpl3pvx2XdVxPOvxPUwacE/ti4qHGRliLbxyZCkPSvv+UMTQFbzy
        sT3d1q9WkJT9u+x/08/NQ941alGF1caiKWmXw/rDvQMU94DxujwqJYnHVFCOenqRSISSDg
        J+68YuzqT+6YJqLriVBy1lnbL7W2xeg=
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur03lp2053.outbound.protection.outlook.com [104.47.10.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-9-LHVzNY06Nla9bO-KL6YYcA-1;
 Tue, 05 Jan 2021 23:53:39 +0100
X-MC-Unique: LHVzNY06Nla9bO-KL6YYcA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kk+XMLbjyPU4IFr9QdzKqlM1Wb2eziqrGzgU/RHZTCZrul7tycPLaVYTmNoDiSa7Jh8xLfsQ+5EePFnS8uvb7B/Ibaf0Neb5s74XvGc8SL0FgL0qC9pMCIb4WDVzpgStjnE4jyHqh0vIPw+9ub9wNpJl8eyaiAtxnNvArkrO6C2337sgY5MIFH/JtyADrTsqUm3oiO6/VM06QXAKRWT9bIBiqcRzlGD+N+bsi2WGMRQFFQN9YGd47oAEqKbzjYvR2Dd+/mApmNonCAc7oQ3BkphOkHr2JhhRuwZglSMV40HmMn3lORgpLMeHtDfDZR3CN7NXBfLBbF5ZlOAYLZzQvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mvo9kip5QFMxbCOFXRYLAga3eGpx+WF7/cWeofl/hMc=;
 b=Hbyub3SeWUKfkiu4Dft2RjJ0GmzVI4gFSNdnd0ogRL/YhbUQb2SVt8+zFZ4/Hl0qBPCLq6X1r4zNFpwwUZf7zDcVG4q3gvATrRfhpoYYT3vBSSkbGPTm1ForVPPF5dEaqZFpMsW4svjpsumkR8+KqOqKsetDK1p6wrMJC1xt1jN/J2a7auDbHFm7gd1Emvr3Modif28mrbDM+q22j691+Po+MJgA5vkFmFBLh+1zP6y+wunyRZMDqAAQNp0rnai9OxwW7b5i3COK9sUIfLJE9KV3C2AIpXP9num7Lw5KAU15FRkUlPiE2iP3bGecZflG3IziP3hADCxYIQI4EUzrMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB4072.eurprd04.prod.outlook.com (2603:10a6:209:4d::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Tue, 5 Jan
 2021 22:53:37 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::f447:4cff:66d8:efac]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::f447:4cff:66d8:efac%6]) with mapi id 15.20.3742.006; Tue, 5 Jan 2021
 22:53:37 +0000
Subject: Re: [PATCH 4/6 V3] libiscsi: add helper to calc max scsi cmds per
 session
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
References: <1608518226-30376-1-git-send-email-michael.christie@oracle.com>
 <1608518226-30376-5-git-send-email-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <f1d5b6b3-d8a8-c584-9081-c58302d580ea@suse.com>
Date:   Tue, 5 Jan 2021 14:53:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <1608518226-30376-5-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM0PR01CA0085.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::26) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM0PR01CA0085.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 5 Jan 2021 22:53:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f3a3afa-3a4a-48e4-a00e-08d8b1ccbcc2
X-MS-TrafficTypeDiagnostic: AM6PR04MB4072:
X-Microsoft-Antispam-PRVS: <AM6PR04MB4072F613CA3379871A90A36EDAD10@AM6PR04MB4072.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Umms0z4kUtHdcdBDvqukcGvwsCe3VjDHKMcdtsGRpLCDfYPX5EBdOtLBzd28PFVMc1tWgPlyGVEYI7WECXeQE2l/8juqYHTMomBhKkgE726mwq+d0J1OC7FPDdoKScnJNcv6RRwhUvl6Ow4M+spUyfEdQ9kmNb3y/kXRmmSyIR2lr1ugONo8v3FXGg64DIA+slIJdKLrr8+5y0c3OyKrkjYPZjwHOrDihr94izHPdx6915e9AWIJbejm8qQXY8PDuWyss8opw28v33afDReVz5bWCboPhBiaFCZxwGQYVcCla06dSCavaCdP0lSXDBqAihMmI2oBNAxl5v7QpLJsVU+/03uhvFu3hPekAKXeBAYSzotPxDqgD49vlSb05BtnBEnukGgTP2HzH/fDrPtSe7BEaWC0we5quXJYMjbaRaRkJrjtn5sMiU0eSQVmOrX1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(498600001)(83380400001)(5660300002)(2906002)(16526019)(4326008)(66946007)(86362001)(186003)(8676002)(36756003)(16576012)(6486002)(52116002)(53546011)(8936002)(6666004)(956004)(31686004)(2616005)(26005)(66476007)(31696002)(66556008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VElVTjhlL21RQTZZcTZCem5rOHdzNjRsRUlBMXlPMEpqUEZHMUFYeXIvL1Nu?=
 =?utf-8?B?K0JHSjdaeEk0QWJjUWF3MUN4VEhYN0lBU0NPUlljZ0xEenVaeVdsWkswZWxH?=
 =?utf-8?B?RGF0R3VmcDZ2L255ei85bUtpM3U0cUFySW1TTk84OXRQWHluV2NUUU10eEpG?=
 =?utf-8?B?MGxYdERWZXpZOW5yQ2V2L1lZQ2ZnZmlxdTk2MFQzTjJKU1JqMWlrMllpY3NM?=
 =?utf-8?B?UU96c2JGM3RuU1NqZVFGUVVwcElPZ1I0VXJma1IrcHBBREJSeU9oalRTR0tu?=
 =?utf-8?B?bkFvUjB6c1laeXdMd3E5NzFmRmFkbkJLaXYwVGlHb1hwQ3hPM0U1cUVkcmZ5?=
 =?utf-8?B?UzlTTzY3VTFvRVhGVTVDL3JTd0JMQlBSVEhaS3MzN3htVzVjVml6MGZkMzJI?=
 =?utf-8?B?bUhHNjByQU5CYWI5YjBxSjZQQnluMHhpSDRVTGNZSDl4R0dySmI2cXNrNnZl?=
 =?utf-8?B?MjRCTWFzZzhnRWZpMlJJMGdhbWNMWFR1ZVFYeDVQaktRTDM5MDRlb2g1SHh3?=
 =?utf-8?B?U2twcmd0VVVtUmZWYVdUTkU2dis5dXlxL2M1czVWM3pyc083emxsOXZuWTls?=
 =?utf-8?B?cEo0OG9QOXZ3R1lKNENSc2pPS0wvYTlxRHBjUmhzU1oxZXJmUktLUGdyYVNT?=
 =?utf-8?B?bmM0ekwvQnJsTkRlWCtEV05MeVNkYUxQQjVhS3ZHWXVXK3VuT1E3YXFzTTA0?=
 =?utf-8?B?U0FvcXpVRVpRRmVnUkxJMnNySjVNSmRnMkYxbEJET0RoSVMzUmhDUVlPeTdv?=
 =?utf-8?B?UlQrVGQxZXk2QlYxT0wzNUEvSC9wQWFHN2xLRUxDenl4M1FFZnFtenpoTkhP?=
 =?utf-8?B?Wk15YjBZQnZDQ2JKWWtXbE1EVDBvZ2l4QTViUmNFVXBTZWZ3L1p4RDlncjVY?=
 =?utf-8?B?eDdiWmYwNUU2NWx4VnU0TG5OYXg2M1JkcXU2NW1hckdaSjNuMzR6MzlrNFZZ?=
 =?utf-8?B?ZURrS0U0NnEvamtGUFd6eUJ5ZHowRWtWS1VWY2JXSEtrRHFVM3dGYlFTQlhU?=
 =?utf-8?B?cGl1SjY2QlIxakVUZWFSM2hxK294cnBpaEdDYndVSVZyU3QzeU9paDVlVGlw?=
 =?utf-8?B?TjNDSEczMFdMQ2twMC8xRWpCUkVGaTRsUWdPRWl2SkRXZ0J3elg0NnJ0RWVn?=
 =?utf-8?B?ODlnTFRyU1QzWDFPNnQzSmwwWnNXYWluU24yU1U0ajBSeHZkK0ZDa3lycGpl?=
 =?utf-8?B?Z0t2RkxYSkl1azVBVXYrd1cyYk9HQzlhaFgvRGtSRG0xbHdqSGI1VVNOYXJC?=
 =?utf-8?B?Qno4Mk0yZW1VaFNYZjVLZnk1TFgzVFlkT1RCaTI5T0VRRmhGbmFJb0o4YTNN?=
 =?utf-8?Q?pWIjjgU3QsFqU=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2021 22:53:37.0122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f3a3afa-3a4a-48e4-a00e-08d8b1ccbcc2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: azJWsz/F8BZKER3WYb5ZAiCE7kWrc1WGRdao0XDux0H6dgHntAuJy6exXNTlJeyawBUJVWVcgvfIifd2jJ+jeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4072
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/20/20 6:37 PM, Mike Christie wrote:
> This patch just breaks out the code that calculates the number
> of scsi cmds that will be used for a scsi session. It also adds
> a check that we don't go over the host's can_queue value.

I'm curious. It's a "good thing" to check the command count in a better
way now, but was there any known instance of the count miscalculation in
the current code causing issues?

> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/libiscsi.c | 81 ++++++++++++++++++++++++++++++-------------------
>  include/scsi/libiscsi.h |  2 ++
>  2 files changed, 51 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 796465e..f1ade91 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -2648,6 +2648,51 @@ void iscsi_pool_free(struct iscsi_pool *q)
>  }
>  EXPORT_SYMBOL_GPL(iscsi_pool_free);
>  
> +int iscsi_host_get_max_scsi_cmds(struct Scsi_Host *shost,
> +				 uint16_t requested_cmds_max)
> +{
> +	int scsi_cmds, total_cmds = requested_cmds_max;
> +
> +	if (!total_cmds)
> +		total_cmds = ISCSI_DEF_XMIT_CMDS_MAX;
> +	/*
> +	 * The iscsi layer needs some tasks for nop handling and tmfs,
> +	 * so the cmds_max must at least be greater than ISCSI_MGMT_CMDS_MAX
> +	 * + 1 command for scsi IO.
> +	 */
> +	if (total_cmds < ISCSI_TOTAL_CMDS_MIN) {
> +		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue must be a power of two that is at least %d.\n",
> +		       total_cmds, ISCSI_TOTAL_CMDS_MIN);
> +		return -EINVAL;
> +	}
> +
> +	if (total_cmds > ISCSI_TOTAL_CMDS_MAX) {
> +		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue must be a power of 2 less than or equal to %d.\n",
> +		       requested_cmds_max, ISCSI_TOTAL_CMDS_MAX);
> +		total_cmds = ISCSI_TOTAL_CMDS_MAX;
> +	}
> +
> +	if (!is_power_of_2(total_cmds)) {
> +		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue must be a power of 2.\n",
> +		       total_cmds);
> +		total_cmds = rounddown_pow_of_two(total_cmds);
> +		if (total_cmds < ISCSI_TOTAL_CMDS_MIN)
> +			return -EINVAL;
> +		printk(KERN_INFO "iscsi: Rounding can_queue to %d.\n",
> +		       total_cmds);
> +	}
> +
> +	scsi_cmds = total_cmds - ISCSI_MGMT_CMDS_MAX;
> +	if (shost->can_queue && scsi_cmds > shost->can_queue) {
> +		scsi_cmds = shost->can_queue - ISCSI_MGMT_CMDS_MAX;
> +		printk(KERN_INFO "iscsi: requested cmds_max %u higher than driver limit. Using driver max %u\n",
> +		       requested_cmds_max, shost->can_queue);
> +	}

If the device can queue, what if "can_queue" is equal to or less than
ISCSI_MGMT_CMDS_MAX?

> +
> +	return scsi_cmds;
> +}
> +EXPORT_SYMBOL_GPL(iscsi_host_get_max_scsi_cmds);
> +
>  /**
>   * iscsi_host_add - add host to system
>   * @shost: scsi host
> @@ -2800,7 +2845,7 @@ struct iscsi_cls_session *
>  	struct iscsi_host *ihost = shost_priv(shost);
>  	struct iscsi_session *session;
>  	struct iscsi_cls_session *cls_session;
> -	int cmd_i, scsi_cmds, total_cmds = cmds_max;
> +	int cmd_i, scsi_cmds;
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&ihost->lock, flags);
> @@ -2811,37 +2856,9 @@ struct iscsi_cls_session *
>  	ihost->num_sessions++;
>  	spin_unlock_irqrestore(&ihost->lock, flags);
>  
> -	if (!total_cmds)
> -		total_cmds = ISCSI_DEF_XMIT_CMDS_MAX;
> -	/*
> -	 * The iscsi layer needs some tasks for nop handling and tmfs,
> -	 * so the cmds_max must at least be greater than ISCSI_MGMT_CMDS_MAX
> -	 * + 1 command for scsi IO.
> -	 */
> -	if (total_cmds < ISCSI_TOTAL_CMDS_MIN) {
> -		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue "
> -		       "must be a power of two that is at least %d.\n",
> -		       total_cmds, ISCSI_TOTAL_CMDS_MIN);
> +	scsi_cmds = iscsi_host_get_max_scsi_cmds(shost, cmds_max);
> +	if (scsi_cmds < 0)
>  		goto dec_session_count;

Should this be "scsi_cmds <= 0" ? Having zero commands doesn't seem good.

> -	}
> -
> -	if (total_cmds > ISCSI_TOTAL_CMDS_MAX) {
> -		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue "
> -		       "must be a power of 2 less than or equal to %d.\n",
> -		       cmds_max, ISCSI_TOTAL_CMDS_MAX);
> -		total_cmds = ISCSI_TOTAL_CMDS_MAX;
> -	}
> -
> -	if (!is_power_of_2(total_cmds)) {
> -		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue "
> -		       "must be a power of 2.\n", total_cmds);
> -		total_cmds = rounddown_pow_of_two(total_cmds);
> -		if (total_cmds < ISCSI_TOTAL_CMDS_MIN)
> -			goto dec_session_count;
> -		printk(KERN_INFO "iscsi: Rounding can_queue to %d.\n",
> -		       total_cmds);
> -	}
> -	scsi_cmds = total_cmds - ISCSI_MGMT_CMDS_MAX;
>  
>  	cls_session = iscsi_alloc_session(shost, iscsit,
>  					  sizeof(struct iscsi_session) +
> @@ -2857,7 +2874,7 @@ struct iscsi_cls_session *
>  	session->lu_reset_timeout = 15;
>  	session->abort_timeout = 10;
>  	session->scsi_cmds_max = scsi_cmds;
> -	session->cmds_max = total_cmds;
> +	session->cmds_max = scsi_cmds + ISCSI_MGMT_CMDS_MAX;
>  	session->queued_cmdsn = session->cmdsn = initial_cmdsn;
>  	session->exp_cmdsn = initial_cmdsn + 1;
>  	session->max_cmdsn = initial_cmdsn + 1;
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index 44a9554..02f966e 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -395,6 +395,8 @@ extern struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
>  extern void iscsi_host_remove(struct Scsi_Host *shost);
>  extern void iscsi_host_free(struct Scsi_Host *shost);
>  extern int iscsi_target_alloc(struct scsi_target *starget);
> +extern int iscsi_host_get_max_scsi_cmds(struct Scsi_Host *shost,
> +					uint16_t requested_cmds_max);
>  
>  /*
>   * session management
> 

