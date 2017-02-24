From: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Subject: Re: [PATCH] libiscsi: add lock around task lists to fix list
 corruption regression
Date: Fri, 24 Feb 2017 12:09:16 -0300
Message-ID: <4304a9c0-6427-c0a2-e18a-51292d62022b@linux.vnet.ibm.com>
References: <20170221173536.32024-1-cleech@redhat.com>
 <250619225.63072551.1487888748696.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56711 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751253AbdBXPJ4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Feb 2017 10:09:56 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v1OF6ZZX064001
        for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2017 10:09:55 -0500
Received: from e24smtp05.br.ibm.com (e24smtp05.br.ibm.com [32.104.18.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 28tq6eg536-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2017 10:09:55 -0500
Received: from localhost
        by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <gpiccoli@linux.vnet.ibm.com>;
        Fri, 24 Feb 2017 12:09:53 -0300
Received: from d24relay04.br.ibm.com (d24relay04.br.ibm.com [9.18.232.146])
        by d24dlp02.br.ibm.com (Postfix) with ESMTP id 394ED1DC006F
        for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2017 10:09:53 -0500 (EST)
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.8.31.93])
        by d24relay04.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v1OF9lGu31654068
        for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2017 12:09:52 -0300
Received: from d24av02.br.ibm.com (localhost [127.0.0.1])
        by d24av02.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v1OF9VIF003281
        for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2017 12:09:31 -0300
In-Reply-To: <250619225.63072551.1487888748696.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Leech <cleech@redhat.com>, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com
Cc: lduncan@suse.com, martin petersen <martin.petersen@oracle.com>, jejb@linux.vnet.ibm.com, ilkka@kapsi.fi, Brian King <brking@linux.vnet.ibm.com>

On 02/23/2017 07:25 PM, Chris Leech wrote:
> Yikes, my git-send-email settings suppressed the important CCs.  Sorry!
> 
> Guilherme and Ilkka, can you comment about your testing results or review please?

Hi Chris, thanks for looping me. Patch seems nice, I do have some points
below, most nitpicks heheh
Feel free to accept or not the suggestions!

Also, you can add my:

Reviewed-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>


> 
> - Chris Leech
> 
> ----- Original Message -----
>> There's a rather long standing regression from commit
>> 659743b [SCSI] libiscsi: Reduce locking contention in fast path
>>

Perhaps worth to follow the checkpatch "rule" of citing commits here?
659743b02c41 ("[SCSI] libiscsi: Reduce locking contention in fast path")


>> Depending on iSCSI target behavior, it's possible to hit the case in
>> iscsi_complete_task where the task is still on a pending list
>> (!list_empty(&task->running)).  When that happens the task is removed
>> from the list while holding the session back_lock, but other task list
>> modification occur under the frwd_lock.  That leads to linked list
>> corruption and eventually a panicked system.
>>
>> Rather than back out the session lock split entirely, in order to try
>> and keep some of the performance gains this patch adds another lock to
>> maintain the task lists integrity.
>>
>> Major enterprise supported kernels have been backing out the lock split
>> for while now, thanks to the efforts at IBM where a lab setup has the
>> most reliable reproducer I've seen on this issue.  This patch has been
>> tested there successfully.
>>
>> Signed-off-by: Chris Leech <cleech@redhat.com>

Guess we're missing here:

(a) Fixes: 659743b02c41 ("[SCSI] libiscsi: Reduce locking contention in
fast path")

(b) CC: <stable-email> #v3.15+

Also, would be nice to point the original reporter, if possible:

Reported-by: Prashantha Subbarao <psubbara@us.ibm.com>


>> ---
>>  drivers/scsi/libiscsi.c | 26 +++++++++++++++++++++++++-
>>  include/scsi/libiscsi.h |  1 +
>>  2 files changed, 26 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>> index 834d121..acb5ef3 100644
>> --- a/drivers/scsi/libiscsi.c
>> +++ b/drivers/scsi/libiscsi.c
>> @@ -560,8 +560,12 @@ static void iscsi_complete_task(struct iscsi_task *task,
>> int state)
>>  	WARN_ON_ONCE(task->state == ISCSI_TASK_FREE);
>>  	task->state = state;
>>  
>> -	if (!list_empty(&task->running))
>> +	spin_lock_bh(&conn->taskqueuelock);
>> +	if (!list_empty(&task->running)) {
>> +		WARN_ONCE(1, "iscsi_complete_task while task on list");

I'm retesting this patch right now, and again I saw this giant warning.
Perhaps worth to make it pr_debug()? So, it can be enabled as user
desire and don't alarm all users too much.

Thanks,


Guilherme


>>  		list_del_init(&task->running);
>> +	}
>> +	spin_unlock_bh(&conn->taskqueuelock);
>>  
>>  	if (conn->task == task)
>>  		conn->task = NULL;
>> @@ -783,7 +787,9 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct
>> iscsi_hdr *hdr,
>>  		if (session->tt->xmit_task(task))
>>  			goto free_task;
>>  	} else {
>> +		spin_lock_bh(&conn->taskqueuelock);
>>  		list_add_tail(&task->running, &conn->mgmtqueue);
>> +		spin_unlock_bh(&conn->taskqueuelock);
>>  		iscsi_conn_queue_work(conn);
>>  	}
>>  
>> @@ -1474,8 +1480,10 @@ void iscsi_requeue_task(struct iscsi_task *task)
>>  	 * this may be on the requeue list already if the xmit_task callout
>>  	 * is handling the r2ts while we are adding new ones
>>  	 */
>> +	spin_lock_bh(&conn->taskqueuelock);
>>  	if (list_empty(&task->running))
>>  		list_add_tail(&task->running, &conn->requeue);
>> +	spin_unlock_bh(&conn->taskqueuelock);
>>  	iscsi_conn_queue_work(conn);
>>  }
>>  EXPORT_SYMBOL_GPL(iscsi_requeue_task);
>> @@ -1512,22 +1520,26 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>>  	 * only have one nop-out as a ping from us and targets should not
>>  	 * overflow us with nop-ins
>>  	 */
>> +	spin_lock_bh(&conn->taskqueuelock);
>>  check_mgmt:
>>  	while (!list_empty(&conn->mgmtqueue)) {
>>  		conn->task = list_entry(conn->mgmtqueue.next,
>>  					 struct iscsi_task, running);
>>  		list_del_init(&conn->task->running);
>> +		spin_unlock_bh(&conn->taskqueuelock);
>>  		if (iscsi_prep_mgmt_task(conn, conn->task)) {
>>  			/* regular RX path uses back_lock */
>>  			spin_lock_bh(&conn->session->back_lock);
>>  			__iscsi_put_task(conn->task);
>>  			spin_unlock_bh(&conn->session->back_lock);
>>  			conn->task = NULL;
>> +			spin_lock_bh(&conn->taskqueuelock);
>>  			continue;
>>  		}
>>  		rc = iscsi_xmit_task(conn);
>>  		if (rc)
>>  			goto done;
>> +		spin_lock_bh(&conn->taskqueuelock);
>>  	}
>>  
>>  	/* process pending command queue */
>> @@ -1535,19 +1547,24 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>>  		conn->task = list_entry(conn->cmdqueue.next, struct iscsi_task,
>>  					running);
>>  		list_del_init(&conn->task->running);
>> +		spin_unlock_bh(&conn->taskqueuelock);
>>  		if (conn->session->state == ISCSI_STATE_LOGGING_OUT) {
>>  			fail_scsi_task(conn->task, DID_IMM_RETRY);
>> +			spin_lock_bh(&conn->taskqueuelock);
>>  			continue;
>>  		}
>>  		rc = iscsi_prep_scsi_cmd_pdu(conn->task);
>>  		if (rc) {
>>  			if (rc == -ENOMEM || rc == -EACCES) {
>> +				spin_lock_bh(&conn->taskqueuelock);
>>  				list_add_tail(&conn->task->running,
>>  					      &conn->cmdqueue);
>>  				conn->task = NULL;
>> +				spin_unlock_bh(&conn->taskqueuelock);
>>  				goto done;
>>  			} else
>>  				fail_scsi_task(conn->task, DID_ABORT);
>> +			spin_lock_bh(&conn->taskqueuelock);
>>  			continue;
>>  		}
>>  		rc = iscsi_xmit_task(conn);
>> @@ -1558,6 +1575,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>>  		 * we need to check the mgmt queue for nops that need to
>>  		 * be sent to aviod starvation
>>  		 */
>> +		spin_lock_bh(&conn->taskqueuelock);
>>  		if (!list_empty(&conn->mgmtqueue))
>>  			goto check_mgmt;
>>  	}
>> @@ -1577,12 +1595,15 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>>  		conn->task = task;
>>  		list_del_init(&conn->task->running);
>>  		conn->task->state = ISCSI_TASK_RUNNING;
>> +		spin_unlock_bh(&conn->taskqueuelock);
>>  		rc = iscsi_xmit_task(conn);
>>  		if (rc)
>>  			goto done;
>> +		spin_lock_bh(&conn->taskqueuelock);
>>  		if (!list_empty(&conn->mgmtqueue))
>>  			goto check_mgmt;
>>  	}
>> +	spin_unlock_bh(&conn->taskqueuelock);
>>  	spin_unlock_bh(&conn->session->frwd_lock);
>>  	return -ENODATA;
>>  
>> @@ -1738,7 +1759,9 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct
>> scsi_cmnd *sc)
>>  			goto prepd_reject;
>>  		}
>>  	} else {
>> +		spin_lock_bh(&conn->taskqueuelock);
>>  		list_add_tail(&task->running, &conn->cmdqueue);
>> +		spin_unlock_bh(&conn->taskqueuelock);
>>  		iscsi_conn_queue_work(conn);
>>  	}
>>  
>> @@ -2896,6 +2919,7 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session,
>> int dd_size,
>>  	INIT_LIST_HEAD(&conn->mgmtqueue);
>>  	INIT_LIST_HEAD(&conn->cmdqueue);
>>  	INIT_LIST_HEAD(&conn->requeue);
>> +	spin_lock_init(&conn->taskqueuelock);
>>  	INIT_WORK(&conn->xmitwork, iscsi_xmitworker);
>>  
>>  	/* allocate login_task used for the login/text sequences */
>> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
>> index b0e275d..583875e 100644
>> --- a/include/scsi/libiscsi.h
>> +++ b/include/scsi/libiscsi.h
>> @@ -196,6 +196,7 @@ struct iscsi_conn {
>>  	struct iscsi_task	*task;		/* xmit task in progress */
>>  
>>  	/* xmit */
>> +	spinlock_t		taskqueuelock;  /* protects the next three lists */
>>  	struct list_head	mgmtqueue;	/* mgmt (control) xmit queue */
>>  	struct list_head	cmdqueue;	/* data-path cmd queue */
>>  	struct list_head	requeue;	/* tasks needing another run */
>> --
>> 2.9.3
>>
>>
> 
