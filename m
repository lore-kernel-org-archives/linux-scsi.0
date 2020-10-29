Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD6BC2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 19:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CC5520838
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 19:59:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g6r15mVJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725931AbgJ2T5X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 15:57:23 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:50024 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgJ2Tzj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 15:55:39 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TJtPiH116974;
        Thu, 29 Oct 2020 19:55:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=zLfM9JelyklKMMcUVCwsiVTs/CekDjk3+gu0J8V46Js=;
 b=g6r15mVJ6CRVkX5RoSzF5KLsX1sLphup1FdDFOYShF611AGTGyM5vIbElavGILusrdm3
 suqy+Hf2MQNeDM0z2yWfaZrqnYbCVg03qEsDkyHonsUJWdGFDE4/J7JrAAOWrQLQb6jE
 NqzlnoNGi5cpWzlU7tol3o/ncVu5h7WpZFPPQaAqJ9F2cwTJW1Yo+oj1mTScdSCaf+aD
 5PWVdvSlsOfOBSz/SlWhV+KjHHcluJLdM1N4JxoORer1PVnv0UQZEX8rzPydU3lbajVe
 iepo29/OaHdRSS6jajRsOw+w4H9ueOaVKIQ2Mqu9WzbxmjuNjMVP4KKITWSp2R8h1KvY jQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34c9sb6wh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 19:55:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TJoPXw175693;
        Thu, 29 Oct 2020 19:55:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34cx1tmah4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 19:55:29 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09TJtRrA023548;
        Thu, 29 Oct 2020 19:55:27 GMT
Received: from mybox.in.oracle.com (/10.191.215.198)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 12:55:27 -0700
Date:   Fri, 30 Oct 2020 01:25:19 +0530
From:   Jitendra Khasdev <jitendra.khasdev@oracle.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Ewan D. Milne" <emilne@redhat.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com, hare@suse.com, loberman@redhat.com,
        joe.jin@oracle.com, junxiao.bi@oracle.com,
        gulam.mohamed@oracle.com, RITIKA.SRIVASTAVA@oracle.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: alua: fix the race between alua_bus_detach and
 alua_rtpg
Message-ID: <20201029195518.GA18513@mybox.in.oracle.com>
References: <1600167537-12509-1-git-send-email-jitendra.khasdev@oracle.com>
 <c5e0700bb192a422541d1328db7ca0146edf7a81.camel@redhat.com>
 <c58d1877-1d30-e81d-f10f-3571e3a248b9@oracle.com>
 <d21e4a7c-9668-23db-c470-596a8e1e3af6@suse.de>
 <a62fc767-6489-0093-d4ed-72e25f89782c@oracle.com>
 <6d4115ba-bd69-75d9-e209-a4ef4aaa9a68@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6d4115ba-bd69-75d9-e209-a4ef4aaa9a68@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290137
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 24, 2020 at 12:39:48PM +0200, Hannes Reinecke wrote:
> On 9/23/20 7:50 PM, jitendra.khasdev@oracle.com wrote:
> >
> >
> >On 9/23/20 1:47 PM, Hannes Reinecke wrote:
> >>On 9/18/20 5:49 AM, jitendra.khasdev@oracle.com wrote:
> >>>
> >>>
> >>>On 9/17/20 11:00 PM, Ewan D. Milne wrote:
> >>>>On Tue, 2020-09-15 at 16:28 +0530, Jitendra Khasdev wrote:
> >>>>>This is patch to fix the race occurs between bus detach and alua_rtpg.
> >>>>>
> >>>>>It fluses the all pending workqueue in bus detach handler, so it can avoid
> >>>>>race between alua_bus_detach and alua_rtpg.
> >>>>>
> >>>>>Here is call trace where race got detected.
> >>>>>
> >>>>>multipathd call stack:
> >>>>>[exception RIP: native_queued_spin_lock_slowpath+100]
> >>>>>--- <NMI exception stack> ---
> >>>>>native_queued_spin_lock_slowpath at ffffffff89307f54
> >>>>>queued_spin_lock_slowpath at ffffffff89307c18
> >>>>>_raw_spin_lock_irq at ffffffff89bd797b
> >>>>>alua_bus_detach at ffffffff8984dcc8
> >>>>>scsi_dh_release_device at ffffffff8984b6f2
> >>>>>scsi_device_dev_release_usercontext at ffffffff89846edf
> >>>>>execute_in_process_context at ffffffff892c3e60
> >>>>>scsi_device_dev_release at ffffffff8984637c
> >>>>>device_release at ffffffff89800fbc
> >>>>>kobject_cleanup at ffffffff89bb1196
> >>>>>kobject_put at ffffffff89bb12ea
> >>>>>put_device at ffffffff89801283
> >>>>>scsi_device_put at ffffffff89838d5b
> >>>>>scsi_disk_put at ffffffffc051f650 [sd_mod]
> >>>>>sd_release at ffffffffc051f8a2 [sd_mod]
> >>>>>__blkdev_put at ffffffff8952c79e
> >>>>>blkdev_put at ffffffff8952c80c
> >>>>>blkdev_close at ffffffff8952c8b5
> >>>>>__fput at ffffffff894e55e6
> >>>>>____fput at ffffffff894e57ee
> >>>>>task_work_run at ffffffff892c94dc
> >>>>>exit_to_usermode_loop at ffffffff89204b12
> >>>>>do_syscall_64 at ffffffff892044da
> >>>>>entry_SYSCALL_64_after_hwframe at ffffffff89c001b8
> >>>>>
> >>>>>kworker:
> >>>>>[exception RIP: alua_rtpg+2003]
> >>>>>account_entity_dequeue at ffffffff892e42c1
> >>>>>alua_rtpg_work at ffffffff8984f097
> >>>>>process_one_work at ffffffff892c4c29
> >>>>>worker_thread at ffffffff892c5a4f
> >>>>>kthread at ffffffff892cb135
> >>>>>ret_from_fork at ffffffff89c00354
> >>>>>
> >>>>>Signed-off-by: Jitendra Khasdev <jitendra.khasdev@oracle.com>
> >>>>>---
> >>>>>   drivers/scsi/device_handler/scsi_dh_alua.c | 3 +++
> >>>>>   1 file changed, 3 insertions(+)
> >>>>>
> >>>>>diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> >>>>>index f32da0c..024a752 100644
> >>>>>--- a/drivers/scsi/device_handler/scsi_dh_alua.c
> >>>>>+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> >>>>>@@ -1144,6 +1144,9 @@ static void alua_bus_detach(struct scsi_device *sdev)
> >>>>>       struct alua_dh_data *h = sdev->handler_data;
> >>>>>       struct alua_port_group *pg;
> >>>>>   +    sdev_printk(KERN_INFO, sdev, "%s: flushing workqueues\n", ALUA_DH_NAME);
> >>>>>+    flush_workqueue(kaluad_wq);
> >>>>>+
> >>>>>       spin_lock(&h->pg_lock);
> >>>>>       pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h->pg_lock));
> >>>>>       rcu_assign_pointer(h->pg, NULL);
> >>>>
> >>>>I'm not sure this is the best solution.  The current code
> >>>>references h->sdev when the dh_list is traversed.  So it needs
> >>>>to remain valid.  Fixing it by flushing the workqueue to avoid
> >>>>the list traversal code running leaves open the possibility that
> >>>>future code alterations may expose this problem again.
> >>>>
> >>>>-Ewan
> >>>>
> >>>>
> >>>
> >>>I see your point, but as we are in detach handler and this code path
> >>>only execute when device is being detached. So, before detaching, flush
> >>>work-queue will take care of any current code references h->sdev where
> >>>dh_list is being traversed.
> >>>
> >>Flushing the workqueue is a bit of an overkill, seeing that we know exactly which workqueue element we're waiting for.
> >>
> >>>IMO, I do not think it would create any problem for future code
> >>>alterations. Or may be I am missing something over here, what could
> >>>be possible scenario for that?
> >>>
> >>Problem is more that I'd like to understand where exactly the race condition is. Can you figure out which spinlock is triggering in your stack trace?
> >>
> >>Cheers,
> >>
> >>Hannes
> >
> >Hannes,
> >
> >Race is between "alua_bus_detach" and "alua_rtpg_work".
> >
> >Whenever we perform fail-over or turn off the switch, the path goes down, which eventually triggers
> >blkdev_put -> .. -> scsi_device_dev_release -> .. ->  alua_bus_detach meanwhile another thread of alua_rtpg_work also running in parallel. Both threads are using sdev.
> >
> >In alua_bus_detach, we are setting null to sdev. From above call trace (multipathd) we can see alua_bus_deatch ran first and set sdev to null. It keeps its execution continue and it does not have any problem.
> >
> >1138 /*
> >1139  * alua_bus_detach - Detach device handler
> >1140  * @sdev: device to be detached from
> >1141  */
> >1142 static void alua_bus_detach(struct scsi_device *sdev)
> >1143 {
> >1144         struct alua_dh_data *h = sdev->handler_data;
> >1145         struct alua_port_group *pg;
> >1146
> >1147         spin_lock(&h->pg_lock);
> >1148         pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h->pg_lock));
> >1149         rcu_assign_pointer(h->pg, NULL);
> >*1150*         h->sdev = NULL;  << Looks detach handler won the race and set sdev to null
> >1151         spin_unlock(&h->pg_lock);
> >1152         if (pg) {
> >1153                 spin_lock_irq(&pg->lock); <<< from the call trace we can see that we just acquired the lock and got NMI
> >exception because we encountered a BUG_ON from different thread.
> >1154                 list_del_rcu(&h->node);
> >
> >
> >Meanwhile alua_rtpg try to check for BUG_ON(!h->sdev);
> >
> >alua_rtpg_work -> alua_rtpg
> >----
> >  505 static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
> >  506 {
> >  .
> >  .
> >  .
> >  659                                         list_for_each_entry_rcu(h,
> >  660                                                 &tmp_pg->dh_list, node) {
> >  661                                                 /* h->sdev should always be valid */
> >  *662*                                                 BUG_ON(!h->sdev); <<<< 2nd call trace caused the panic due to this bug on.
> >  663                                                 h->sdev->access_state = desc[0];
> >  664                                         }
> >  665                                         rcu_read_unlock();
> >  666                                 }
> >----
> >
> Ah, yes.
> 
> We would need to take 'h->lock' here before checking 'h->sdev'.
> Alternatively, we should be able to fix it by not setting h->sdev to
> NULL, and issuing rcu_synchronize() before issuing kfree(h):
> 
> @@ -1147,7 +1148,6 @@ static void alua_bus_detach(struct scsi_device *sdev)
>         spin_lock(&h->pg_lock);
>         pg = rcu_dereference_protected(h->pg,
> lockdep_is_held(&h->pg_lock));
>         rcu_assign_pointer(h->pg, NULL);
> -       h->sdev = NULL;
>         spin_unlock(&h->pg_lock);
>         if (pg) {
>                 spin_lock_irq(&pg->lock);
> @@ -1156,6 +1156,7 @@ static void alua_bus_detach(struct scsi_device *sdev)
>                 kref_put(&pg->kref, release_port_group);
>         }
>         sdev->handler_data = NULL;
> +       rcu_synchronize();
>         kfree(h);
>  }
> 
> The 'rcu_synchronize()' will ensure that any concurrent thread has
> left the rcu-critical section (ie the loop mentioned above), and the
> issue will be avoided.
> Additionally, we could replace the BUG_ON() with
> 
> if (!h->sdev)
>     continue;
> 
> and the problem should be solved.
> 
> Cheers,
> 
> Hannes
> -- 
> Dr. Hannes Reinecke		           Kernel Storage Architect
> hare@suse.de			                  +49 911 74053 688
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
> HRB 36809 (AG Nürnberg), GF: Felix Imendörffer

> From eb295823f4604a939d89cb21aad468fcd393484b Mon Sep 17 00:00:00 2001
> From: Hannes Reinecke <hare@suse.de>
> Date: Thu, 24 Sep 2020 12:33:22 +0200
> Subject: [PATCH] scsi_dh_alua: avoid crash during alua_bus_detach()
> 
> alua_bus_detach() might be running concurrently with alua_rtpg_work(),
> so we might trip over h->sdev == NULL and call BUG_ON().
> The correct way of handling it would be to not set h->sdev to NULL
> in alua_bus_detach(), and call rcu_synchronize() before the final
> delete to ensure that all concurrent threads have left the critical
> section.
> Then we can get rid of the BUG_ON(), and replace it with a simple
> if condition.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---

Reviewed-by: Jitendra Khasdev <jitendra.khasdev@oracle.com>
Tested-by: Jitendra Khasdev <jitendra.khasdev@oracle.com>

>  drivers/scsi/device_handler/scsi_dh_alua.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index f32da0ca529e..308bda2e9c00 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -658,8 +658,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  					rcu_read_lock();
>  					list_for_each_entry_rcu(h,
>  						&tmp_pg->dh_list, node) {
> -						/* h->sdev should always be valid */
> -						BUG_ON(!h->sdev);
> +						if (!h->sdev)
> +							continue;
>  						h->sdev->access_state = desc[0];
>  					}
>  					rcu_read_unlock();
> @@ -705,7 +705,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  			pg->expiry = 0;
>  			rcu_read_lock();
>  			list_for_each_entry_rcu(h, &pg->dh_list, node) {
> -				BUG_ON(!h->sdev);
> +				if (!h->sdev)
> +					continue;
>  				h->sdev->access_state =
>  					(pg->state & SCSI_ACCESS_STATE_MASK);
>  				if (pg->pref)
> @@ -1147,7 +1148,6 @@ static void alua_bus_detach(struct scsi_device *sdev)
>  	spin_lock(&h->pg_lock);
>  	pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h->pg_lock));
>  	rcu_assign_pointer(h->pg, NULL);
> -	h->sdev = NULL;
>  	spin_unlock(&h->pg_lock);
>  	if (pg) {
>  		spin_lock_irq(&pg->lock);
> @@ -1156,6 +1156,7 @@ static void alua_bus_detach(struct scsi_device *sdev)
>  		kref_put(&pg->kref, release_port_group);
>  	}
>  	sdev->handler_data = NULL;
> +	synchronize_rcu();
>  	kfree(h);
>  }
>  
> -- 
> 2.16.4
> 

