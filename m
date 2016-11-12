From: "Guilherme G. Piccoli" <gpiccoli-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 1/1] iscsi: fix regression caused by session lock patch
Date: Fri, 11 Nov 2016 23:51:13 -0200
Message-ID: <58267591.2080803@linux.vnet.ibm.com>
References: <1447304741-6594-1-git-send-email-mchristi@redhat.com>
 <56447FF7.40600@dev.mellanox.co.il> <5644FD6C.9070805@cs.wisc.edu>
 <CAJ3xEMjiuCQ_ep1uF-8veM1C8TBvt2HWqgZMLsVmrApGHapT4Q@mail.gmail.com>
 <56461502.70306@cs.wisc.edu>
 <CAJ3xEMhQiywXo0=kRO7f=fW--1kc6mbNs_X7wLoYtXmRWeqBkg@mail.gmail.com>
 <20161107181556.cnhwst4nu63xtrqk@straylight.hirudinean.org>
 <5820C68E.6050206@linux.vnet.ibm.com>
 <20161109052142.j4psips7yvx7uohx@straylight.hirudinean.org>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBD235QUNTYKBBG7LTHAQKGQECYLZ5WI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <20161109052142.j4psips7yvx7uohx-r8IHplWLGbA5tHQWs+pTeqPFFGjUI2lm2LY78lusg7I@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, lduncan-IBi9RG/b67k@public.gmane.org, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shlomo Pongratz <shlomopongratz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 11/09/2016 03:21 AM, Chris Leech wrote:
> On Mon, Nov 07, 2016 at 04:23:10PM -0200, Guilherme G. Piccoli wrote:
>>
>> Sure! Count on us to test any patches. I guess the first step is to
>> reproduce on upstream right? We haven't tested specifically this
>> scenario for long time. Will try to reproduce on 4.9-rc4 and update here.
> 
> Great, I'm looking forward to hearing the result.
> 
> Assuming it reproduces, I don't think this level of fine grained locking
> is necessarily the best solution, but it may help confirm the problem.
> Especially if the WARN_ONCE I slipped in here triggers.
> 
> - Chris

Chris, I'm not able to reproduce right now - environment was
misconfigured, and now I'm leaving the office for 20 days.

Will test as soon as I'm back!
Thanks,


Guilherme


> 
> ---
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index f9b6fba..fbd18ab 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -560,8 +560,12 @@ static void iscsi_complete_task(struct iscsi_task *task, int state)
>  	WARN_ON_ONCE(task->state == ISCSI_TASK_FREE);
>  	task->state = state;
> 
> -	if (!list_empty(&task->running))
> +	spin_lock_bh(&conn->taskqueuelock);
> +	if (!list_empty(&task->running)) {
> +		WARN_ONCE(1, "iscsi_complete_task while task on list");
>  		list_del_init(&task->running);
> +	}
> +	spin_unlock_bh(&conn->taskqueuelock);
> 
>  	if (conn->task == task)
>  		conn->task = NULL;
> @@ -783,7 +787,9 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>  		if (session->tt->xmit_task(task))
>  			goto free_task;
>  	} else {
> +		spin_lock_bh(&conn->taskqueuelock);
>  		list_add_tail(&task->running, &conn->mgmtqueue);
> +		spin_unlock_bh(&conn->taskqueuelock);
>  		iscsi_conn_queue_work(conn);
>  	}
> 
> @@ -1474,8 +1480,10 @@ void iscsi_requeue_task(struct iscsi_task *task)
>  	 * this may be on the requeue list already if the xmit_task callout
>  	 * is handling the r2ts while we are adding new ones
>  	 */
> +	spin_lock_bh(&conn->taskqueuelock);
>  	if (list_empty(&task->running))
>  		list_add_tail(&task->running, &conn->requeue);
> +	spin_unlock_bh(&conn->taskqueuelock);
>  	iscsi_conn_queue_work(conn);
>  }
>  EXPORT_SYMBOL_GPL(iscsi_requeue_task);
> @@ -1512,22 +1520,26 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>  	 * only have one nop-out as a ping from us and targets should not
>  	 * overflow us with nop-ins
>  	 */
> +	spin_lock_bh(&conn->taskqueuelock);
>  check_mgmt:
>  	while (!list_empty(&conn->mgmtqueue)) {
>  		conn->task = list_entry(conn->mgmtqueue.next,
>  					 struct iscsi_task, running);
>  		list_del_init(&conn->task->running);
> +		spin_unlock_bh(&conn->taskqueuelock);
>  		if (iscsi_prep_mgmt_task(conn, conn->task)) {
>  			/* regular RX path uses back_lock */
>  			spin_lock_bh(&conn->session->back_lock);
>  			__iscsi_put_task(conn->task);
>  			spin_unlock_bh(&conn->session->back_lock);
>  			conn->task = NULL;
> +			spin_lock_bh(&conn->taskqueuelock);
>  			continue;
>  		}
>  		rc = iscsi_xmit_task(conn);
>  		if (rc)
>  			goto done;
> +		spin_lock_bh(&conn->taskqueuelock);
>  	}
> 
>  	/* process pending command queue */
> @@ -1535,19 +1547,24 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>  		conn->task = list_entry(conn->cmdqueue.next, struct iscsi_task,
>  					running);
>  		list_del_init(&conn->task->running);
> +		spin_unlock_bh(&conn->taskqueuelock);
>  		if (conn->session->state == ISCSI_STATE_LOGGING_OUT) {
>  			fail_scsi_task(conn->task, DID_IMM_RETRY);
> +			spin_lock_bh(&conn->taskqueuelock);
>  			continue;
>  		}
>  		rc = iscsi_prep_scsi_cmd_pdu(conn->task);
>  		if (rc) {
>  			if (rc == -ENOMEM || rc == -EACCES) {
> +				spin_lock_bh(&conn->taskqueuelock);
>  				list_add_tail(&conn->task->running,
>  					      &conn->cmdqueue);
>  				conn->task = NULL;
> +				spin_unlock_bh(&conn->taskqueuelock);
>  				goto done;
>  			} else
>  				fail_scsi_task(conn->task, DID_ABORT);
> +			spin_lock_bh(&conn->taskqueuelock);
>  			continue;
>  		}
>  		rc = iscsi_xmit_task(conn);
> @@ -1558,6 +1575,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>  		 * we need to check the mgmt queue for nops that need to
>  		 * be sent to aviod starvation
>  		 */
> +		spin_lock_bh(&conn->taskqueuelock);
>  		if (!list_empty(&conn->mgmtqueue))
>  			goto check_mgmt;
>  	}
> @@ -1577,12 +1595,15 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>  		conn->task = task;
>  		list_del_init(&conn->task->running);
>  		conn->task->state = ISCSI_TASK_RUNNING;
> +		spin_unlock_bh(&conn->taskqueuelock);
>  		rc = iscsi_xmit_task(conn);
>  		if (rc)
>  			goto done;
> +		spin_lock_bh(&conn->taskqueuelock);
>  		if (!list_empty(&conn->mgmtqueue))
>  			goto check_mgmt;
>  	}
> +	spin_unlock_bh(&conn->taskqueuelock);
>  	spin_unlock_bh(&conn->session->frwd_lock);
>  	return -ENODATA;
> 
> @@ -1738,7 +1759,9 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
>  			goto prepd_reject;
>  		}
>  	} else {
> +		spin_lock_bh(&conn->taskqueuelock);
>  		list_add_tail(&task->running, &conn->cmdqueue);
> +		spin_unlock_bh(&conn->taskqueuelock);
>  		iscsi_conn_queue_work(conn);
>  	}
> 
> @@ -2897,6 +2920,7 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
>  	INIT_LIST_HEAD(&conn->mgmtqueue);
>  	INIT_LIST_HEAD(&conn->cmdqueue);
>  	INIT_LIST_HEAD(&conn->requeue);
> +	spin_lock_init(&conn->taskqueuelock);
>  	INIT_WORK(&conn->xmitwork, iscsi_xmitworker);
> 
>  	/* allocate login_task used for the login/text sequences */
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index 4d1c46a..c7b1dc7 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -196,6 +196,7 @@ struct iscsi_conn {
>  	struct iscsi_task	*task;		/* xmit task in progress */
> 
>  	/* xmit */
> +	spinlock_t		taskqueuelock;  /* protects the next three lists */
>  	struct list_head	mgmtqueue;	/* mgmt (control) xmit queue */
>  	struct list_head	cmdqueue;	/* data-path cmd queue */
>  	struct list_head	requeue;	/* tasks needing another run */
> 

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
