From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] qla2xxx: Fix possible race that could hang
 kthread_stop()
Date: Thu, 27 Jan 2011 16:12:37 -0500
Message-ID: <1296162757.3050.69.camel@mulgrave.site>
References: <20110127205922.GF31955@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48383 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab1A0VMn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Jan 2011 16:12:43 -0500
In-Reply-To: <20110127205922.GF31955@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bandan Das <bandan.das@stratus.com>
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2011-01-27 at 15:59 -0500, Bandan Das wrote:
> There is a small race window in qla2x00_do_dpc() between
> checking for kthread_should_stop() and going to sleep after
> setting TASK_INTERRUPTIBLE. If qla2x00_free_device() is called
> in this window, kthread_stop will wait forever because there 
> will be no one to wake up the process.
> 
> 
> Signed-off-by: Bandan Das <bandan.das@stratus.com>
> Signed-off-by: Nate Dailey <nate.dailey@stratus.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index c194c23..8d14d77 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3286,6 +3286,8 @@ qla2x00_do_dpc(void *data)
>  		DEBUG3(printk("qla2x00: DPC handler sleeping\n"));
>  
>  		set_current_state(TASK_INTERRUPTIBLE);
> +		if (kthread_should_stop())
> +			break;
>  		schedule();
>  		__set_current_state(TASK_RUNNING);

That's not really the accepted way to fix these race conditions because
of the double check of kthread_should_stop(); this is

James

---
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c194c23..15ce69e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3282,10 +3282,10 @@ qla2x00_do_dpc(void *data)
 
 	set_user_nice(current, -20);
 
+	set_current_state(TASK_INTERRUPTIBLE);
 	while (!kthread_should_stop()) {
 		DEBUG3(printk("qla2x00: DPC handler sleeping\n"));
 
-		set_current_state(TASK_INTERRUPTIBLE);
 		schedule();
 		__set_current_state(TASK_RUNNING);
 
@@ -3454,7 +3454,9 @@ qla2x00_do_dpc(void *data)
 		qla2x00_do_dpc_all_vps(base_vha);
 
 		ha->dpc_active = 0;
+		set_current_state(TASK_INTERRUPTIBLE);
 	} /* End of while(1) */
+	__set_current_state(TASK_RUNNING);
 
 	DEBUG(printk("scsi(%ld): DPC handler exiting\n", base_vha->host_no));
 



