Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5761AC388F9
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 20:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF07D208B8
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 20:29:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jeAWaqsm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgKKU3E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Nov 2020 15:29:04 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:42828 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbgKKU3E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2020 15:29:04 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ABKOIDw136527;
        Wed, 11 Nov 2020 20:28:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=z0m64spdF50MULsGSMo+f8qtAM2sugLVg+9TtDk1V7c=;
 b=jeAWaqsmtRqxQJ396r6e98bW6Cm9sq6ZleUovwpCLjfT5Rh7USqNUI+FbKYzDsTdXJ9K
 Ui50okW0jv/5VHjV7stK0uPSTlVg49Qak5aPbaawFKs7bWV+k+PHxQEzWYqfPmvT83d/
 xARWskO9p/uAaGXadKtwu94jiRdMAlb3KBJmFuI4BFn827bwICwFnn2Q5kc7wMcexXPN
 IAAGFj+p+suUQvxZswLMrJEX1IbVOhGM2I6G+lIGLq0Bql1tBlnYlaqOMT/yiAH2ZUxY
 RN+uEMWFjaNgKhBaqZajzWYR8ZWBXdgNgKNHCdpbW2QtDqfZy8g5XsHu5PyoB+nDJS3h 3A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34nh3b2pcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 20:28:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ABKPGgK070617;
        Wed, 11 Nov 2020 20:28:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34p55qccm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 20:28:57 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0ABKStTD015897;
        Wed, 11 Nov 2020 20:28:55 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Nov 2020 12:28:55 -0800
Subject: Re: [PATCH v2] SCSI: libiscsi: fix NOP race condition
To:     Lee Duncan <leeman.duncan@gmail.com>, linux-scsi@vger.kernel.org
Cc:     open-iscsi@googlegroups.com, Lee Duncan <lduncan@suse.com>
References: <20201106193317.16993-1-leeman.duncan@gmail.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <e82c27ad-35f0-a9c8-f857-513e0b4aa0ca@oracle.com>
Date:   Wed, 11 Nov 2020 14:28:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201106193317.16993-1-leeman.duncan@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9802 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9802 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=2
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110118
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/6/20 1:33 PM, Lee Duncan wrote:
> From: Lee Duncan <lduncan@suse.com>
> 
> iSCSI NOPs are sometimes "lost", mistakenly sent to the
> user-land iscsid daemon instead of handled in the kernel,
> as they should be, resulting in a message from the daemon like:
> 
>> iscsid: Got nop in, but kernel supports nop handling.
> 
> This can occur because of the new forward- and back-locks,
> and the fact that an iSCSI NOP response can occur before
> processing of the NOP send is complete. This can result
> in "conn->ping_task" being NULL in iscsi_nop_out_rsp(),
> when the pointer is actually in the process of being set.
> 
> To work around this, we add a new state to the "ping_task"
> pointer. In addition to NULL (not assigned) and a pointer
> (assigned), we add the state "being set", which is signaled
> with an INVALID pointer (using "-1").
> 
> Changes since V1:
>   - expanded using READ_ONCE()/WRITE_ONCE() to the whole path
> 
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
>   drivers/scsi/libiscsi.c | 23 +++++++++++++++--------
>   include/scsi/libiscsi.h |  3 +++
>   2 files changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 1e9c3171fa9f..f9314f1393fb 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -533,8 +533,8 @@ static void iscsi_complete_task(struct iscsi_task *task, int state)
>   	if (conn->task == task)
>   		conn->task = NULL;
>   
> -	if (conn->ping_task == task)
> -		conn->ping_task = NULL;
> +	if (READ_ONCE(conn->ping_task) == task)
> +		WRITE_ONCE(conn->ping_task, NULL);
>   
>   	/* release get from queueing */
>   	__iscsi_put_task(task);
> @@ -738,6 +738,9 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>   						   task->conn->session->age);
>   	}
>   
> +	if (unlikely(READ_ONCE(conn->ping_task) == INVALID_SCSI_TASK))
> +		WRITE_ONCE(conn->ping_task, task);
> +
>   	if (!ihost->workq) {
>   		if (iscsi_prep_mgmt_task(conn, task))
>   			goto free_task;
> @@ -941,8 +944,11 @@ static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
>           struct iscsi_nopout hdr;
>   	struct iscsi_task *task;
>   
> -	if (!rhdr && conn->ping_task)
> -		return -EINVAL;
> +	if (!rhdr) {
> +		if (READ_ONCE(conn->ping_task))
> +			return -EINVAL;
> +		WRITE_ONCE(conn->ping_task, INVALID_SCSI_TASK);
> +	}
>   
>   	memset(&hdr, 0, sizeof(struct iscsi_nopout));
>   	hdr.opcode = ISCSI_OP_NOOP_OUT | ISCSI_OP_IMMEDIATE;
> @@ -957,11 +963,12 @@ static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
>   
>   	task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
>   	if (!task) {
> +		if (!rhdr)
> +			WRITE_ONCE(conn->ping_task, NULL);
>   		iscsi_conn_printk(KERN_ERR, conn, "Could not send nopout\n");
>   		return -EIO;
>   	} else if (!rhdr) {
>   		/* only track our nops */
> -		conn->ping_task = task;
>   		conn->last_ping = jiffies;
>   	}
>   
> @@ -984,7 +991,7 @@ static int iscsi_nop_out_rsp(struct iscsi_task *task,
>   	struct iscsi_conn *conn = task->conn;
>   	int rc = 0;
>   
> -	if (conn->ping_task != task) {
> +	if (READ_ONCE(conn->ping_task) != task) {
>   		/*
>   		 * If this is not in response to one of our
>   		 * nops then it must be from userspace.
> @@ -1923,7 +1930,7 @@ static void iscsi_start_tx(struct iscsi_conn *conn)
>    */
>   static int iscsi_has_ping_timed_out(struct iscsi_conn *conn)
>   {
> -	if (conn->ping_task &&
> +	if (READ_ONCE(conn->ping_task) &&
>   	    time_before_eq(conn->last_recv + (conn->recv_timeout * HZ) +
>   			   (conn->ping_timeout * HZ), jiffies))
>   		return 1;
> @@ -2058,7 +2065,7 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
>   	 * Checking the transport already or nop from a cmd timeout still
>   	 * running
>   	 */
> -	if (conn->ping_task) {
> +	if (READ_ONCE(conn->ping_task)) {
>   		task->have_checked_conn = true;
>   		rc = BLK_EH_RESET_TIMER;
>   		goto done;
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index c25fb86ffae9..b3bbd10eb3f0 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -132,6 +132,9 @@ struct iscsi_task {
>   	void			*dd_data;	/* driver/transport data */
>   };
>   
> +/* invalid scsi_task pointer */
> +#define	INVALID_SCSI_TASK	(struct iscsi_task *)-1l
> +
>   static inline int iscsi_task_has_unsol_data(struct iscsi_task *task)
>   {
>   	return task->unsol_r2t.data_length > task->unsol_r2t.sent;
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>
