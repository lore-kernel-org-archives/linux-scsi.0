Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63919C4361B
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 18:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 074DD20578
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 18:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408778AbgLNS0u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 13:26:50 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36908 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502301AbgLNRiE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2020 12:38:04 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEHUCtl074973;
        Mon, 14 Dec 2020 17:36:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=HRHsAcy8BkeA7VXzdenFOGTOJJwlYgOlUYUvjlYTFPw=;
 b=kSX0q27JTpquQE9ZgolumOOSf+2OfPdpVfp+r3FT2884WL6UshO+tqm4lmro2oxYkc5E
 YSp9ceZZq/chn8PF5P7KA8DMx5mJmQ/0YLa7eJ5rk1C4QCRChLMy+EBrv2X243jodluP
 NgwDOx2FS9MrB4opA3h70EtmO6CHKLaSlfPklnhU490byXXZCr1bugSliUQWCKXvx4CL
 HXifwLsy34DvSbE+hg/OKPwmWO811k89BxFU8gJtGt5FzECEvavmiMXPz5l7fV6/9cLd
 Es+Kgsbj6qk33U+XwR2Y1S/IWGOzo/E5+3NctqgCbNzPXWzg1JTKpAETk1yXaCtnXnXc gg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 35cn9r6haj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Dec 2020 17:36:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEHV5RL136122;
        Mon, 14 Dec 2020 17:36:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 35e6jpt7y0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 17:36:53 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BEHapqM003074;
        Mon, 14 Dec 2020 17:36:51 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Dec 2020 09:36:50 -0800
Subject: Re: [RFC PATCH] scsi:libiscsi:Fix possible NULL dereference in
 iscsi_eh_cmd_timed_out
To:     Wu Bo <wubo40@huawei.com>, lduncan@suse.com, cleech@redhat.com,
        michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
References: <1607935317-263599-1-git-send-email-wubo40@huawei.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <d545b4b0-2c85-8e81-4f78-1d4c6a08c7dd@oracle.com>
Date:   Mon, 14 Dec 2020 11:36:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <1607935317-263599-1-git-send-email-wubo40@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012140119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 clxscore=1011 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140119
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/14/20 2:41 AM, Wu Bo wrote:
> When testing kernel 4.18 version, NULL pointer dereference problem occurs
> in iscsi_eh_cmd_timed_out function.
> 
> I think this bug in the upstream is still exists.
> 
> The analysis reasons are as follows:
> 1)  For some reason, I/O command did not complete within 
>     the timeout period. The block layer timer works, 
>     call scsi_times_out() to handle I/O timeout logic. 
>     At the same time the command just completes.
> 
> 2)  scsi_times_out() call iscsi_eh_cmd_timed_out() 
>     to processing timeout logic.  although there is an NULL judgment 
> 	for the task, the task has not been released yet now.    
> 
> 3)  iscsi_complete_task() call __iscsi_put_task(), 
>     The task reference count reaches zero, the conditions for free task 
>     is met, then iscsi_free_task () free the task, 
>     and let sc->SCp.ptr = NULL. After iscsi_eh_cmd_timed_out passes 
>     the task judgment check, there may be NULL dereference scenarios
>     later.
> 	

I have a patch for this I think. This is broken out of patchset I was
trying to fixup the back lock usage for offload drivers, so I have only
compile tested it.

There is another issue where the for lun reset cleanup we could race. The
comments mention suspending the rx side, but we only do that for session level
cleaup.

The basic idea is we don't want to add more frwd lock uses in the completion
patch like in your patch. In these non perf paths, like the tmf/timeout case
we can just take a ref to the cmd so it's not freed from under us.



diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index f9314f1..f07f8c1 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -573,18 +573,9 @@ void iscsi_complete_scsi_task(struct iscsi_task *task,
 static void fail_scsi_task(struct iscsi_task *task, int err)
 {
 	struct iscsi_conn *conn = task->conn;
-	struct scsi_cmnd *sc;
+	struct scsi_cmnd *sc = task->sc;
 	int state;
 
-	/*
-	 * if a command completes and we get a successful tmf response
-	 * we will hit this because the scsi eh abort code does not take
-	 * a ref to the task.
-	 */
-	sc = task->sc;
-	if (!sc)
-		return;
-
 	if (task->state == ISCSI_TASK_PENDING) {
 		/*
 		 * cmd never made it to the xmit thread, so we should not count
@@ -1855,26 +1846,34 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 }
 
 /*
- * Fail commands. session lock held and recv side suspended and xmit
- * thread flushed
+ * Fail commands. session frwd lock held and and xmit thread flushed.
  */
 static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
 {
+	struct iscsi_session *session = conn->session;
 	struct iscsi_task *task;
 	int i;
 
-	for (i = 0; i < conn->session->cmds_max; i++) {
-		task = conn->session->cmds[i];
-		if (!task->sc || task->state == ISCSI_TASK_FREE)
+	for (i = 0; i < session->cmds_max; i++) {
+		spin_lock_bh(&session->back_lock);
+		task = session->cmds[i];
+		if (!task->sc || task->state == ISCSI_TASK_FREE) {
+			spin_unlock_bh(&session->back_lock);
 			continue;
+		}
 
-		if (lun != -1 && lun != task->sc->device->lun)
+		if (lun != -1 && lun != task->sc->device->lun) {
+			spin_unlock_bh(&session->back_lock);
 			continue;
+		}
+		__iscsi_get_task(task);
+		spin_unlock_bh(&session->back_lock);
 
-		ISCSI_DBG_SESSION(conn->session,
+		ISCSI_DBG_SESSION(session,
 				  "failing sc %p itt 0x%x state %d\n",
 				  task->sc, task->itt, task->state);
 		fail_scsi_task(task, error);
+		iscsi_put_task(task);
 	}
 }
 
@@ -1953,6 +1952,7 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 	ISCSI_DBG_EH(session, "scsi cmd %p timedout\n", sc);
 
 	spin_lock_bh(&session->frwd_lock);
+	spin_lock(&session->back_lock);
 	task = (struct iscsi_task *)sc->SCp.ptr;
 	if (!task) {
 		/*
@@ -1960,8 +1960,11 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 		 * so let timeout code complete it now.
 		 */
 		rc = BLK_EH_DONE;
+		spin_unlock(&session->back_lock);
 		goto done;
 	}
+	__iscsi_get_task(task);
+	spin_unlock(&session->back_lock);
 
 	if (session->state != ISCSI_STATE_LOGGED_IN) {
 		/*
@@ -2077,9 +2080,12 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 	rc = BLK_EH_RESET_TIMER;
 
 done:
-	if (task)
-		task->last_timeout = jiffies;
 	spin_unlock_bh(&session->frwd_lock);
+
+	if (task) {
+		task->last_timeout = jiffies;
+		iscsi_put_task(task);
+	}
 	ISCSI_DBG_EH(session, "return %s\n", rc == BLK_EH_RESET_TIMER ?
 		     "timer reset" : "shutdown or nh");
 	return rc;
@@ -2187,15 +2193,20 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	conn->eh_abort_cnt++;
 	age = session->age;
 
-	task = (struct iscsi_task *)sc->SCp.ptr;
-	ISCSI_DBG_EH(session, "aborting [sc %p itt 0x%x]\n",
-		     sc, task->itt);
-
-	/* task completed before time out */
-	if (!task->sc) {
+	spin_lock(&session->back_lock);
+	task = (struct iscsi_task *)sc->SCp.ptr;	
+	if (!task || !task->sc) {
+		/* task completed before time out */
 		ISCSI_DBG_EH(session, "sc completed while abort in progress\n");
-		goto success;
+
+		spin_unlock(&session->back_lock);
+		spin_unlock_bh(&session->frwd_lock);
+		mutex_unlock(&session->eh_mutex);
+		return SUCCESS;
 	}
+	ISCSI_DBG_EH(session, "aborting [sc %p itt 0x%x]\n", sc, task->itt);
+	__iscsi_get_task(task);
+	spin_unlock(&session->back_lock);
 
 	if (task->state == ISCSI_TASK_PENDING) {
 		fail_scsi_task(task, DID_ABORT);
@@ -2258,6 +2269,8 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	ISCSI_DBG_EH(session, "abort success [sc %p itt 0x%x]\n",
 		     sc, task->itt);
 	mutex_unlock(&session->eh_mutex);
+
+	iscsi_put_task(task);
 	return SUCCESS;
 
 failed:
@@ -2266,6 +2279,8 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	ISCSI_DBG_EH(session, "abort failed [sc %p itt 0x%x]\n", sc,
 		     task ? task->itt : 0);
 	mutex_unlock(&session->eh_mutex);
+
+	iscsi_put_task(task);
 	return FAILED;
 }
 EXPORT_SYMBOL_GPL(iscsi_eh_abort);
