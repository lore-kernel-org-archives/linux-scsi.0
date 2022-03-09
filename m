Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D637CC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 01:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbiCIBeb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 20:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbiCIBe2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 20:34:28 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD04B2E38
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 17:33:23 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KCvjF0M33z1GC1f;
        Wed,  9 Mar 2022 09:28:33 +0800 (CST)
Received: from dggpeml500019.china.huawei.com (7.185.36.137) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Mar 2022 09:33:21 +0800
Received: from [10.174.179.189] (10.174.179.189) by
 dggpeml500019.china.huawei.com (7.185.36.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Mar 2022 09:33:20 +0800
Subject: Re: [PATCH 08/12] scsi: iscsi: remove unneeded task state check
To:     Mike Christie <michael.christie@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <jejb@linux.ibm.com>
References: <20220308002747.122682-1-michael.christie@oracle.com>
 <20220308002747.122682-9-michael.christie@oracle.com>
From:   Wu Bo <wubo40@huawei.com>
Message-ID: <69c2ba50-ddb1-4fee-bfb0-005917d2f075@huawei.com>
Date:   Wed, 9 Mar 2022 09:33:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20220308002747.122682-9-michael.christie@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.189]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500019.china.huawei.com (7.185.36.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/3/8 8:27, Mike Christie wrote:
> The patch:
> 
> commit 5923d64b7ab6 ("scsi: libiscsi: Drop taskqueuelock")
> 
> added an extra task->state because for
> 
> commit 6f8830f5bbab ("scsi: libiscsi: add lock around task lists to fix
> list corruption regression")
> 
> we didn't know why we ended up with cmds on the list and thought it
> might have been a bad target sending a response while we were still
> sending the cmd. We were never able to get a target to send us a response
> early, because it turns out the bug was just a race in libiscsi/
> libiscsi_tcp where
> 
> 1. iscsi_tcp_r2t_rsp queues a r2t to tcp_task->r2tqueue.
> 2. iscsi_tcp_task_xmit runs iscsi_tcp_get_curr_r2t and sees we have a r2t.
> It dequeues it and iscsi_tcp_task_xmit starts to process it.
> 3. iscsi_tcp_r2t_rsp runs iscsi_requeue_task and puts the task on the
> requeue list.
> 4. iscsi_tcp_task_xmit sends the data for r2t. This is the final chunk of
> data, so the cmd is done.
> 5. target sends the response.
> 6. On a different CPU from #3, iscsi_complete_task processes the response.
> Since there was no common lock for the list, the lists/tasks pointers are
> not fully in sync, so could end up with list corruption.
> 
> Since it was just a race on our side, this patch removes the extra check
> and fixes up the comments.
> 
> Reviewed-by: Lee Duncan <lduncan@suse.com>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/libiscsi.c | 13 ++++++++-----
>   1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 0a0076144874..5c74ab92725f 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -567,16 +567,19 @@ static bool cleanup_queued_task(struct iscsi_task *task)
>   	struct iscsi_conn *conn = task->conn;
>   	bool early_complete = false;
>   
> -	/* Bad target might have completed task while it was still running */
> +	/*
> +	 * We might have raced where we handled a R2T early and got a response
> +	 * but have not yet taken the task off the requeue list, then a TMF or
> +	 * recovery happened and so we can still see it here.
> +	 */
>   	if (task->state == ISCSI_TASK_COMPLETED)
>   		early_complete = true;
>   
>   	if (!list_empty(&task->running)) {
>   		list_del_init(&task->running);
>   		/*
> -		 * If it's on a list but still running, this could be from
> -		 * a bad target sending a rsp early, cleanup from a TMF, or
> -		 * session recovery.
> +		 * If it's on a list but still running this could be cleanup
> +		 * from a TMF or session recovery.
>   		 */
>   		if (task->state == ISCSI_TASK_RUNNING ||
>   		    task->state == ISCSI_TASK_COMPLETED)
> @@ -1484,7 +1487,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
>   	}
>   	/* regular RX path uses back_lock */
>   	spin_lock(&conn->session->back_lock);
> -	if (rc && task->state == ISCSI_TASK_RUNNING) {
> +	if (rc) {
>   		/*
>   		 * get an extra ref that is released next time we access it
>   		 * as conn->task above.
> 
Reviewed-by: Wu Bo <wubo40@huawei.com>

