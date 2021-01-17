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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B53EAC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Jan 2021 20:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 714F7224B8
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Jan 2021 20:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729800AbhAQUPA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Jan 2021 15:15:00 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:60676 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728732AbhAQUO6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 17 Jan 2021 15:14:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1610914428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GwXk91TEqMhlpT41GZF3spOab7uvyB3yl5bmhKtyepw=;
        b=iLDOrjUC7VvulMrc3vI7TYibf2DEQ5/e4yRCfltze/5ojZzQ0NAXSHMLyzeaDq7+WcTrNO
        Upte9+093r6/qTq1nRxM4XY03pbHWOslW72lhE4bfqC4wDlZhCj+pS2HO19ylI32ScwoF/
        kCVMB0K+QcVmGyBkNBnHV9ypx4fFZwc=
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2055.outbound.protection.outlook.com [104.47.4.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-12-gVQ85FPTNJuXH8KNXV8u1w-1; Sun, 17 Jan 2021 21:13:47 +0100
X-MC-Unique: gVQ85FPTNJuXH8KNXV8u1w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KT/ahLUcertfrHjkitHoMpzWB+F3DeKIkOUrkBoc2KvisBYcY9ubEcQskbLX2TcTvXD1guHNyAwop9nfJmnCJZt8GZX0oKKaJkayEwXvkTf/6k7cY+F+bvcpZo1YKJ7rSUulx/QkIUvMg4wPQjmC0u0CrMlwTXNX+Fpd2ZNdMibQDq68wOF7JaOf/2ux4H+SlHAxZ9vjAxd07wVn7kWQYdjV7zupBgxJfuP7MEiKSaWULnQJsZNEld6KuUmdAmZ0OqpF/PXbqS75xoPVVqluYs/zgt5NPseFR3NwAbEsE6gAuVhwf9o/iPVGRJ0Mr5/1F03iLaA/OcaJiyACQUTR3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GwXk91TEqMhlpT41GZF3spOab7uvyB3yl5bmhKtyepw=;
 b=IMxFB4DnLBqHhsC1WvtULb8jvf6zPUeuvG3ZSC0cYKhwCzGIm41hvfoaa7LHctUe72qrUld+W6XtxkEPemcfMf6l9K10al5zgwzZx1Z6vt8OsdsNETX2hTM8/Kpve3hlYBr519qhoN6wZrZrGWHR32q42dBfubRZQytkwHynfSuAhXKCVZVXDztfljhB58I2VvNH57qZfwiIR6eQn1qvpeQXjucoDeZ9gW7kHflMU26VqNnqy6FXuHbJc4svwmHO9/YK+fxWc4YWJuqz0zWd7fNctgUKJpDL3Lc49C/gfiyYJpfPZDJ8aFsMA6j7E1b5bC4fUp+bWDL7yID8XGSIeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM5PR0402MB2769.eurprd04.prod.outlook.com (2603:10a6:203:a2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Sun, 17 Jan
 2021 20:13:45 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::f447:4cff:66d8:efac]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::f447:4cff:66d8:efac%6]) with mapi id 15.20.3763.014; Sun, 17 Jan 2021
 20:13:45 +0000
Subject: Re: [PATCH 2/6 V3] libiscsi: drop taskqueuelock
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
References: <1608518226-30376-1-git-send-email-michael.christie@oracle.com>
 <1608518226-30376-3-git-send-email-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <86b9f0b8-e508-03b2-ed26-d46f809a4730@suse.com>
Date:   Sun, 17 Jan 2021 12:13:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <1608518226-30376-3-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM4PR05CA0018.eurprd05.prod.outlook.com (2603:10a6:205::31)
 To AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM4PR05CA0018.eurprd05.prod.outlook.com (2603:10a6:205::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Sun, 17 Jan 2021 20:13:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a24f9d9-f6f4-4634-2d37-08d8bb246425
X-MS-TrafficTypeDiagnostic: AM5PR0402MB2769:
X-Microsoft-Antispam-PRVS: <AM5PR0402MB2769B23596FE97BD996A3999DAA50@AM5PR0402MB2769.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +yZlRzE05X3ETlVZaOh73clMJc+DF8M+CUs3Ywk/gZpKgN1My+DIvBOOcq7pQn1SgVoVr3W+18ghaAmxqx/E3/Xxn7T6nQ0EhTJpVig7yYXjdHAmyp+Zx0baqv5GyIW6UbNZuIQhAG2DQlKae9Z/obXMWea+FjrnDR8IJwckPXTHKuMREkVjiMQmEi4mT3D8FCKObkT64LKm83GRxDK0wwQRs3Ezzs5w0LjF0M+J6I0FWSZwhkbqfxCxhmCP9TYTvKOz+Hmz+LlMABxC6NAp9W9b10iYz57qL4GKMz4X6Es8NvC4wWuOkCO5jJ6yDB0bYgi9/zVsKW0jo08J49WHwTryNBo/7vueI937LyDduQ6V2BsXXBftFcB7pFcGQowqo5ZuDHJMk4v0MWumqMnU5puy5uNaxIdrdooBL6zBa8gI3E86l7cfPxzMQ+a88HGnbhSAiL5N7UQ2NBHxXxG/YQY8WeuHuuOqXkeEyTWRve8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39850400004)(136003)(376002)(346002)(366004)(31686004)(316002)(16576012)(16526019)(31696002)(83380400001)(2616005)(956004)(5660300002)(30864003)(66946007)(66476007)(66556008)(186003)(52116002)(478600001)(4326008)(6666004)(6486002)(8676002)(36756003)(26005)(86362001)(2906002)(53546011)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bDdGYVp5Nm56c2RreWMza2NDTDA3Uk0zOCtGZzJibHZOOG5CRzhhSXRsWDE1?=
 =?utf-8?B?NFpNcWtNZTRxS1NieHRuZDYzTE9LeTYrdk9yVWJqSm4wRE1QaUhYNWQxbDNa?=
 =?utf-8?B?bFV6VDluMlVna2pUTXRjcFJLUFdlRkljcDJrVXRZR0lEbGxmU3UxUVdyMGg0?=
 =?utf-8?B?WFMvSTcyRjZrMkN1bm0wSkUvY1FHUXc4YXhTVHU4d1o2eHU5ekVvdGRuZ2Rv?=
 =?utf-8?B?Q0dQaWo0ajNzY2ZTc0lTMXUzVE9tZFdjSEdyMXlNaHNxdGZid3YrM1U1cUd0?=
 =?utf-8?B?RjhIclpCQ0EreFBFMUdIZXFCZFRjZ1JUNWs4NmpBN2ZuWjJicGFibDlPVTBS?=
 =?utf-8?B?V09xbjY5d1NOVzdhVWJVUVA2RElzekllbk0wVkt1N3RmWlJqNHJablpDY1g4?=
 =?utf-8?B?RnZ3eVljRFczOHVDaGZWN1lVOHFReGJXenVuM1RhVUtramE3YzFyaFJ2bnI5?=
 =?utf-8?B?eDJBem5ubjNZanJyTXhnM0tNQUpUSXhHK2J0Y3NXbkQ3dXJPSWxINy9xcURG?=
 =?utf-8?B?T2RHQ0RWbk83YnllUU9Wa2E5eXQ3TjN4S3gxZkM4NkpLaDIzeFUxRTB3a1RC?=
 =?utf-8?B?QVZtTlBTUy9LNjgydEg2QWVEdE5UZUtjdUd2eTR5bE5aU2w5Z1FCMkpya2Rz?=
 =?utf-8?B?VTlMaFZFc2ZxSTJUNEl2bkZDRjU1Wmx0ajZoN01WQStlRWxkNWUvaXE4cmJS?=
 =?utf-8?B?RS8wT2txMm96NUVXTHNndUNvN3VUWlFtQ3lXZVNHbmV2YjZMVXRPclVBQloy?=
 =?utf-8?B?K3JRUTlocS9YeXV6bGNhOHhHNGhEdjg1UU9BWVVWdDErQXFwZ1RFQmZCR2lX?=
 =?utf-8?B?WjR0RFVEZEhGMUczb2poR3RkMlVFZ1VqWkJCQ0w0SXVVQ2xVOTJuL2QvOTVE?=
 =?utf-8?B?aGZUaXRqNk93Q2RETVZGNGdvMVF2TXEvK3QwMXppS2RDQk1yczdmYldGc3hj?=
 =?utf-8?B?MWMzM1NQRFFCeHdKSzNTS0RCU2NJcWEyOFNQa0xpVk41RWxHYmpwejF1QmdM?=
 =?utf-8?B?VFllZ0tUbXM1d0llTkw1RlR2WHlLR1hlMU1iM1gvRDZmdmVMM3YxRGM2bERi?=
 =?utf-8?B?VWJZT254N0VhTmQ3Q281TnJZR1kzN0YzR0FJT1JweFYwNERlYWFhSXVUZVZZ?=
 =?utf-8?B?anlYYng5c3dlcXRXYVJ2Vk54RVI4ZGlGUHFOQTkzRVJqOTk1QzVaR0twWThl?=
 =?utf-8?B?RkFXek1PRlBLVXNtZDB6dGQ5MnhDVHhCQ1JMZGFXdzhhdnljTGVnZ3oySGVp?=
 =?utf-8?B?M1k5WXY2V0Ewd20xNjBvRW9lR0htN3QrTW14NW5pdWZNdm1NV3p6N1VCbnl5?=
 =?utf-8?Q?/KalRVNvhdq2o=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a24f9d9-f6f4-4634-2d37-08d8bb246425
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2021 20:13:44.9558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gvcFwSCU64HModlqpZAQHvAtT20OwrH6Z9TEVc/Vu5CLDqjERtGcRjM1L85/zlOQITmXYBVlY/uMzszdoxbrFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0402MB2769
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Mike:

Just one "nit" comment about a comment.

On 12/20/20 6:37 PM, Mike Christie wrote:
> The purpose of the taskqueuelock was to handle the issue where a bad
> target decides to send a R2T and before it's data has been sent
> decides to send a cmd response to complete the cmd. The following
> patches fix up the frwd/back locks so they are taken from the
> queue/xmit (frwd) and completion (back) paths again. To get there
> this patch removes the taskqueuelock which for iscsi xmit wq based
> drivers was taken in the queue, xmit and completion paths.
> 
> Instead of the lock, we just make sure we have a ref to the task
> when we queue a R2T, and then we always remove the task from the
> requeue list in the xmit path or the forced cleanup paths.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/libiscsi.c     | 178 ++++++++++++++++++++++++++++----------------
>  drivers/scsi/libiscsi_tcp.c |  84 ++++++++++++++-------
>  include/scsi/libiscsi.h     |   4 +-
>  3 files changed, 171 insertions(+), 95 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index ee0786b..5582e4f 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -523,16 +523,6 @@ static void iscsi_complete_task(struct iscsi_task *task, int state)
>  	WARN_ON_ONCE(task->state == ISCSI_TASK_FREE);
>  	task->state = state;
>  
> -	spin_lock_bh(&conn->taskqueuelock);
> -	if (!list_empty(&task->running)) {
> -		pr_debug_once("%s while task on list", __func__);
> -		list_del_init(&task->running);
> -	}
> -	spin_unlock_bh(&conn->taskqueuelock);
> -
> -	if (conn->task == task)
> -		conn->task = NULL;
> -
>  	if (READ_ONCE(conn->ping_task) == task)
>  		WRITE_ONCE(conn->ping_task, NULL);
>  
> @@ -564,9 +554,40 @@ void iscsi_complete_scsi_task(struct iscsi_task *task,
>  }
>  EXPORT_SYMBOL_GPL(iscsi_complete_scsi_task);
>  
> +/*
> + * Must be called with back and frwd lock
> + */
> +static bool cleanup_queued_task(struct iscsi_task *task)
> +{
> +	struct iscsi_conn *conn = task->conn;
> +	bool early_complete = false;
> +
> +	/* Bad target might have completed task while it was still running */
> +	if (task->state == ISCSI_TASK_COMPLETED)
> +		early_complete = true;
> +
> +	if (!list_empty(&task->running)) {
> +		list_del_init(&task->running);
> +		/*
> +		 * If it's on a list but still running, this could be from
> +		 * a bad target sending a rsp early, cleanup from a TMF, or
> +		 * session recovery.
> +		 */
> +		if (task->state == ISCSI_TASK_RUNNING ||
> +		    task->state == ISCSI_TASK_COMPLETED)
> +			__iscsi_put_task(task);
> +	}
> +
> +	if (conn->task == task) {
> +		conn->task = NULL;
> +		__iscsi_put_task(task);
> +	}
> +
> +	return early_complete;
> +}
>  
>  /*
> - * session back_lock must be held and if not called for a task that is
> + * session frwd_lock must be held and if not called for a task that is
>   * still pending or from the xmit thread, then xmit thread must
>   * be suspended.
>   */
> @@ -585,6 +606,13 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
>  	if (!sc)
>  		return;
>  
> +	/* regular RX path uses back_lock */
> +	spin_lock_bh(&conn->session->back_lock);
> +	if (cleanup_queued_task(task)) {
> +		spin_unlock_bh(&conn->session->back_lock);
> +		return;
> +	}
> +
>  	if (task->state == ISCSI_TASK_PENDING) {
>  		/*
>  		 * cmd never made it to the xmit thread, so we should not count
> @@ -600,9 +628,6 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
>  
>  	sc->result = err << 16;
>  	scsi_set_resid(sc, scsi_bufflen(sc));
> -
> -	/* regular RX path uses back_lock */
> -	spin_lock_bh(&conn->session->back_lock);
>  	iscsi_complete_task(task, state);
>  	spin_unlock_bh(&conn->session->back_lock);
>  }
> @@ -748,9 +773,7 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
>  		if (session->tt->xmit_task(task))
>  			goto free_task;
>  	} else {
> -		spin_lock_bh(&conn->taskqueuelock);
>  		list_add_tail(&task->running, &conn->mgmtqueue);
> -		spin_unlock_bh(&conn->taskqueuelock);
>  		iscsi_conn_queue_work(conn);
>  	}
>  
> @@ -1411,31 +1434,61 @@ static int iscsi_check_cmdsn_window_closed(struct iscsi_conn *conn)
>  	return 0;
>  }
>  
> -static int iscsi_xmit_task(struct iscsi_conn *conn)
> +static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
> +			   bool was_requeue)
>  {
> -	struct iscsi_task *task = conn->task;
>  	int rc;
>  
> -	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx))
> -		return -ENODATA;
> -
>  	spin_lock_bh(&conn->session->back_lock);
> -	if (conn->task == NULL) {
> +
> +	if (!conn->task) {
> +		/* Take a ref so we can access it after xmit_task() */
> +		__iscsi_get_task(task);
> +	} else {
> +		/* Already have a ref from when we failed to send it last call */
> +		conn->task = NULL;
> +	}
> +
> +	/*
> +	 * If this was a requeue for a R2T we have an extra ref on the task in
> +	 * case a bad target sends a cmd rsp before we have handled the task.
> +	 */
> +	if (was_requeue)
> +		__iscsi_put_task(task);
> +
> +	/*
> +	 * Do this after dropping the extra ref because if this was a requeue
> +	 * it's removed from that list and cleanup_queued_task would miss it.
> +	 */
> +	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
> +		/*
> +		 * Save the task and ref in case we weren't cleaning up this
> +		 * task and get woken up again.
> +		 */
> +		conn->task = task;
>  		spin_unlock_bh(&conn->session->back_lock);
>  		return -ENODATA;
>  	}
> -	__iscsi_get_task(task);
>  	spin_unlock_bh(&conn->session->back_lock);
> +
>  	spin_unlock_bh(&conn->session->frwd_lock);
>  	rc = conn->session->tt->xmit_task(task);
>  	spin_lock_bh(&conn->session->frwd_lock);
>  	if (!rc) {
>  		/* done with this task */
>  		task->last_xfer = jiffies;
> -		conn->task = NULL;
>  	}
>  	/* regular RX path uses back_lock */
>  	spin_lock(&conn->session->back_lock);
> +	if (rc && task->state == ISCSI_TASK_RUNNING) {
> +		/*
> +		 * get an extra ref that is released next time we access it
> +		 * as conn->task above.
> +		 */
> +		__iscsi_get_task(task);
> +		conn->task = task;
> +	}
> +
>  	__iscsi_put_task(task);
>  	spin_unlock(&conn->session->back_lock);
>  	return rc;
> @@ -1445,9 +1498,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn)
>   * iscsi_requeue_task - requeue task to run from session workqueue
>   * @task: task to requeue
>   *
> - * LLDs that need to run a task from the session workqueue should call
> - * this. The session frwd_lock must be held. This should only be called
> - * by software drivers.
> + * Callers must have taken a ref to the task that is going to be requeued.
>   */
>  void iscsi_requeue_task(struct iscsi_task *task)
>  {
> @@ -1457,11 +1508,18 @@ void iscsi_requeue_task(struct iscsi_task *task)
>  	 * this may be on the requeue list already if the xmit_task callout
>  	 * is handling the r2ts while we are adding new ones
>  	 */
> -	spin_lock_bh(&conn->taskqueuelock);
> -	if (list_empty(&task->running))
> +	spin_lock_bh(&conn->session->frwd_lock);
> +	if (list_empty(&task->running)) {
>  		list_add_tail(&task->running, &conn->requeue);
> -	spin_unlock_bh(&conn->taskqueuelock);
> +	} else {
> +		/*
> +		 * Don't need the extra ref since it's already requeued and
> +		 * has a ref.
> +		 */
> +		iscsi_put_task(task);
> +	}
>  	iscsi_conn_queue_work(conn);
> +	spin_unlock_bh(&conn->session->frwd_lock);
>  }
>  EXPORT_SYMBOL_GPL(iscsi_requeue_task);
>  
> @@ -1487,7 +1545,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>  	}
>  
>  	if (conn->task) {
> -		rc = iscsi_xmit_task(conn);
> +		rc = iscsi_xmit_task(conn, conn->task, false);
>  	        if (rc)
>  		        goto done;
>  	}
> @@ -1497,49 +1555,41 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>  	 * only have one nop-out as a ping from us and targets should not
>  	 * overflow us with nop-ins
>  	 */
> -	spin_lock_bh(&conn->taskqueuelock);
>  check_mgmt:
>  	while (!list_empty(&conn->mgmtqueue)) {
> -		conn->task = list_entry(conn->mgmtqueue.next,
> -					 struct iscsi_task, running);
> -		list_del_init(&conn->task->running);
> -		spin_unlock_bh(&conn->taskqueuelock);
> -		if (iscsi_prep_mgmt_task(conn, conn->task)) {
> +		task = list_entry(conn->mgmtqueue.next, struct iscsi_task,
> +				  running);
> +		list_del_init(&task->running);
> +		if (iscsi_prep_mgmt_task(conn, task)) {
>  			/* regular RX path uses back_lock */
>  			spin_lock_bh(&conn->session->back_lock);
> -			__iscsi_put_task(conn->task);
> +			__iscsi_put_task(task);
>  			spin_unlock_bh(&conn->session->back_lock);
> -			conn->task = NULL;
> -			spin_lock_bh(&conn->taskqueuelock);
>  			continue;
>  		}
> -		rc = iscsi_xmit_task(conn);
> +		rc = iscsi_xmit_task(conn, task, false);
>  		if (rc)
>  			goto done;
> -		spin_lock_bh(&conn->taskqueuelock);
>  	}
>  
>  	/* process pending command queue */
>  	while (!list_empty(&conn->cmdqueue)) {
> -		conn->task = list_entry(conn->cmdqueue.next, struct iscsi_task,
> -					running);
> -		list_del_init(&conn->task->running);
> -		spin_unlock_bh(&conn->taskqueuelock);
> +		task = list_entry(conn->cmdqueue.next, struct iscsi_task,
> +				  running);
> +		list_del_init(&task->running);
>  		if (conn->session->state == ISCSI_STATE_LOGGING_OUT) {
> -			fail_scsi_task(conn->task, DID_IMM_RETRY);
> -			spin_lock_bh(&conn->taskqueuelock);
> +			fail_scsi_task(task, DID_IMM_RETRY);
>  			continue;
>  		}
> -		rc = iscsi_prep_scsi_cmd_pdu(conn->task);
> +		rc = iscsi_prep_scsi_cmd_pdu(task);
>  		if (rc) {
>  			if (rc == -ENOMEM || rc == -EACCES)
> -				fail_scsi_task(conn->task, DID_IMM_RETRY);
> +				fail_scsi_task(task, DID_IMM_RETRY);
>  			else
> -				fail_scsi_task(conn->task, DID_ABORT);
> -			spin_lock_bh(&conn->taskqueuelock);
> +				fail_scsi_task(task, DID_ABORT);
>  			continue;
>  		}
> -		rc = iscsi_xmit_task(conn);
> +		rc = iscsi_xmit_task(conn, task, false);
>  		if (rc)
>  			goto done;
>  		/*
> @@ -1547,7 +1597,6 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>  		 * we need to check the mgmt queue for nops that need to
>  		 * be sent to aviod starvation
>  		 */
> -		spin_lock_bh(&conn->taskqueuelock);
>  		if (!list_empty(&conn->mgmtqueue))
>  			goto check_mgmt;
>  	}
> @@ -1561,21 +1610,17 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>  
>  		task = list_entry(conn->requeue.next, struct iscsi_task,
>  				  running);
> +
>  		if (iscsi_check_tmf_restrictions(task, ISCSI_OP_SCSI_DATA_OUT))
>  			break;
>  
> -		conn->task = task;
> -		list_del_init(&conn->task->running);
> -		conn->task->state = ISCSI_TASK_RUNNING;
> -		spin_unlock_bh(&conn->taskqueuelock);
> -		rc = iscsi_xmit_task(conn);
> +		list_del_init(&task->running);
> +		rc = iscsi_xmit_task(conn, task, true);
>  		if (rc)
>  			goto done;
> -		spin_lock_bh(&conn->taskqueuelock);
>  		if (!list_empty(&conn->mgmtqueue))
>  			goto check_mgmt;
>  	}
> -	spin_unlock_bh(&conn->taskqueuelock);
>  	spin_unlock_bh(&conn->session->frwd_lock);
>  	return -ENODATA;
>  
> @@ -1741,9 +1786,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
>  			goto prepd_reject;
>  		}
>  	} else {
> -		spin_lock_bh(&conn->taskqueuelock);
>  		list_add_tail(&task->running, &conn->cmdqueue);
> -		spin_unlock_bh(&conn->taskqueuelock);
>  		iscsi_conn_queue_work(conn);
>  	}
>  
> @@ -2914,7 +2957,6 @@ struct iscsi_cls_conn *
>  	INIT_LIST_HEAD(&conn->mgmtqueue);
>  	INIT_LIST_HEAD(&conn->cmdqueue);
>  	INIT_LIST_HEAD(&conn->requeue);
> -	spin_lock_init(&conn->taskqueuelock);
>  	INIT_WORK(&conn->xmitwork, iscsi_xmitworker);
>  
>  	/* allocate login_task used for the login/text sequences */
> @@ -3080,10 +3122,16 @@ int iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
>  		ISCSI_DBG_SESSION(conn->session,
>  				  "failing mgmt itt 0x%x state %d\n",
>  				  task->itt, task->state);
> +
> +		spin_lock_bh(&session->back_lock);
> +		if (cleanup_queued_task(task)) {
> +			spin_unlock_bh(&session->back_lock);
> +			continue;
> +		}
> +
>  		state = ISCSI_TASK_ABRT_SESS_RECOV;
>  		if (task->state == ISCSI_TASK_PENDING)
>  			state = ISCSI_TASK_COMPLETED;
> -		spin_lock_bh(&session->back_lock);
>  		iscsi_complete_task(task, state);
>  		spin_unlock_bh(&session->back_lock);
>  	}
> diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
> index 83f14b2..14c9169 100644
> --- a/drivers/scsi/libiscsi_tcp.c
> +++ b/drivers/scsi/libiscsi_tcp.c
> @@ -524,48 +524,79 @@ static int iscsi_tcp_data_in(struct iscsi_conn *conn, struct iscsi_task *task)
>  /**
>   * iscsi_tcp_r2t_rsp - iSCSI R2T Response processing
>   * @conn: iscsi connection
> - * @task: scsi command task
> + * @hdr: PDU header
>   */
> -static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
> +static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
>  {
>  	struct iscsi_session *session = conn->session;
> -	struct iscsi_tcp_task *tcp_task = task->dd_data;
> -	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
> -	struct iscsi_r2t_rsp *rhdr = (struct iscsi_r2t_rsp *)tcp_conn->in.hdr;
> +	struct iscsi_tcp_task *tcp_task;
> +	struct iscsi_tcp_conn *tcp_conn;
> +	struct iscsi_r2t_rsp *rhdr;
>  	struct iscsi_r2t_info *r2t;
> -	int r2tsn = be32_to_cpu(rhdr->r2tsn);
> +	struct iscsi_task *task;
>  	u32 data_length;
>  	u32 data_offset;
> +	int r2tsn;
>  	int rc;
>  
> +	spin_lock(&session->back_lock);
> +	task = iscsi_itt_to_ctask(conn, hdr->itt);
> +	if (!task) {
> +		spin_unlock(&session->back_lock);
> +		return ISCSI_ERR_BAD_ITT;
> +	} else if (task->sc->sc_data_direction != DMA_TO_DEVICE) {
> +		spin_unlock(&session->back_lock);
> +		return ISCSI_ERR_PROTO;
> +	}
> +	/*
> +	 * A bad target might complete the cmd before we have handled R2Ts
> +	 * so get a ref to the task that will be dropped in the xmit path.
> +	 */

Nit: For me, this comment seems to go with the __iscsi_get_task() a few
lines below, and doesn't mention the state check. But certainly no
functional objection here.

> +	if (task->state != ISCSI_TASK_RUNNING) {
> +		spin_unlock(&session->back_lock);
> +		/* Let the path that got the early rsp complete it */
> +		return 0;
> +	}
> +	task->last_xfer = jiffies;
> +	__iscsi_get_task(task);
> +
> +	tcp_conn = conn->dd_data;
> +	rhdr = (struct iscsi_r2t_rsp *)tcp_conn->in.hdr;
> +	/* fill-in new R2T associated with the task */
> +	iscsi_update_cmdsn(session, (struct iscsi_nopin *)rhdr);
> +	spin_unlock(&session->back_lock);
> +
>  	if (tcp_conn->in.datalen) {
>  		iscsi_conn_printk(KERN_ERR, conn,
>  				  "invalid R2t with datalen %d\n",
>  				  tcp_conn->in.datalen);
> -		return ISCSI_ERR_DATALEN;
> +		rc = ISCSI_ERR_DATALEN;
> +		goto put_task;
>  	}
>  
> +	tcp_task = task->dd_data;
> +	r2tsn = be32_to_cpu(rhdr->r2tsn);
>  	if (tcp_task->exp_datasn != r2tsn){
>  		ISCSI_DBG_TCP(conn, "task->exp_datasn(%d) != rhdr->r2tsn(%d)\n",
>  			      tcp_task->exp_datasn, r2tsn);
> -		return ISCSI_ERR_R2TSN;
> +		rc = ISCSI_ERR_R2TSN;
> +		goto put_task;
>  	}
>  
> -	/* fill-in new R2T associated with the task */
> -	iscsi_update_cmdsn(session, (struct iscsi_nopin*)rhdr);
> -
>  	if (!task->sc || session->state != ISCSI_STATE_LOGGED_IN) {
>  		iscsi_conn_printk(KERN_INFO, conn,
>  				  "dropping R2T itt %d in recovery.\n",
>  				  task->itt);
> -		return 0;
> +		rc = 0;
> +		goto put_task;
>  	}
>  
>  	data_length = be32_to_cpu(rhdr->data_length);
>  	if (data_length == 0) {
>  		iscsi_conn_printk(KERN_ERR, conn,
>  				  "invalid R2T with zero data len\n");
> -		return ISCSI_ERR_DATALEN;
> +		rc = ISCSI_ERR_DATALEN;
> +		goto put_task;
>  	}
>  
>  	if (data_length > session->max_burst)
> @@ -579,7 +610,8 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
>  				  "invalid R2T with data len %u at offset %u "
>  				  "and total length %d\n", data_length,
>  				  data_offset, task->sc->sdb.length);
> -		return ISCSI_ERR_DATALEN;
> +		rc = ISCSI_ERR_DATALEN;
> +		goto put_task;
>  	}
>  
>  	spin_lock(&tcp_task->pool2queue);
> @@ -589,7 +621,8 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
>  				  "Target has sent more R2Ts than it "
>  				  "negotiated for or driver has leaked.\n");
>  		spin_unlock(&tcp_task->pool2queue);
> -		return ISCSI_ERR_PROTO;
> +		rc = ISCSI_ERR_PROTO;
> +		goto put_task;
>  	}
>  
>  	r2t->exp_statsn = rhdr->statsn;
> @@ -607,6 +640,10 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
>  
>  	iscsi_requeue_task(task);
>  	return 0;
> +
> +put_task:
> +	iscsi_put_task(task);
> +	return rc;
>  }
>  
>  /*
> @@ -730,20 +767,11 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
>  		rc = iscsi_complete_pdu(conn, hdr, NULL, 0);
>  		break;
>  	case ISCSI_OP_R2T:
> -		spin_lock(&conn->session->back_lock);
> -		task = iscsi_itt_to_ctask(conn, hdr->itt);
> -		spin_unlock(&conn->session->back_lock);
> -		if (!task)
> -			rc = ISCSI_ERR_BAD_ITT;
> -		else if (ahslen)
> +		if (ahslen) {
>  			rc = ISCSI_ERR_AHSLEN;
> -		else if (task->sc->sc_data_direction == DMA_TO_DEVICE) {
> -			task->last_xfer = jiffies;
> -			spin_lock(&conn->session->frwd_lock);
> -			rc = iscsi_tcp_r2t_rsp(conn, task);
> -			spin_unlock(&conn->session->frwd_lock);
> -		} else
> -			rc = ISCSI_ERR_PROTO;
> +			break;
> +		}
> +		rc = iscsi_tcp_r2t_rsp(conn, hdr);
>  		break;
>  	case ISCSI_OP_LOGIN_RSP:
>  	case ISCSI_OP_TEXT_RSP:
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index b3bbd10..44a9554 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -187,7 +187,7 @@ struct iscsi_conn {
>  	struct iscsi_task	*task;		/* xmit task in progress */
>  
>  	/* xmit */
> -	spinlock_t		taskqueuelock;  /* protects the next three lists */
> +	/* items must be added/deleted under frwd lock */
>  	struct list_head	mgmtqueue;	/* mgmt (control) xmit queue */
>  	struct list_head	cmdqueue;	/* data-path cmd queue */
>  	struct list_head	requeue;	/* tasks needing another run */
> @@ -332,7 +332,7 @@ struct iscsi_session {
>  						 * cmdsn, queued_cmdsn     *
>  						 * session resources:      *
>  						 * - cmdpool kfifo_out ,   *
> -						 * - mgmtpool,		   */
> +						 * - mgmtpool, queues	   */
>  	spinlock_t		back_lock;	/* protects cmdsn_exp      *
>  						 * cmdsn_max,              *
>  						 * cmdpool kfifo_in        */
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

