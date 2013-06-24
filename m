From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 07/14] scsi_transport_srp: Add transport layer error handling
Date: Mon, 24 Jun 2013 09:37:16 +0200
Message-ID: <51C7F72C.2050004@acm.org>
References: <51B87501.4070005@acm.org> <51B8777B.5050201@acm.org> <51C764FB.6070207@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51C764FB.6070207-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 06/23/13 23:13, Mike Christie wrote:
> On 06/12/2013 08:28 AM, Bart Van Assche wrote:
>> +		/*
>> +		 * It can occur that after fast_io_fail_tmo expired and before
>> +		 * dev_loss_tmo expired that the SCSI error handler has
>> +		 * offlined one or more devices. scsi_target_unblock() doesn't
>> +		 * change the state of these devices into running, so do that
>> +		 * explicitly.
>> +		 */
>> +		spin_lock_irq(shost->host_lock);
>> +		__shost_for_each_device(sdev, shost)
>> +			if (sdev->sdev_state == SDEV_OFFLINE)
>> +				sdev->sdev_state = SDEV_RUNNING;
>> +		spin_unlock_irq(shost->host_lock);
> 
> Is it possible for this to race with scsi_eh_offline_sdevs? Can it be
> looping over cmds offlining devices while this is looping over devices
> onlining them?
> 
> It seems this can also happen for all transports/drivers. Maybe a a scsi
> eh/lib helper function that syncrhonizes with the scsi eh completion
> would be better.

I'm not sure it's possible to avoid such a race without introducing
a new mutex. How about something like the (untested) SCSI core patch
below, and invoking scsi_block_eh() and scsi_unblock_eh() around any
reconnect activity not initiated from the SCSI EH thread ?

[PATCH] Add scsi_block_eh() and scsi_unblock_eh()

---
 drivers/scsi/hosts.c      |    1 +
 drivers/scsi/scsi_error.c |   10 ++++++++++
 include/scsi/scsi_host.h  |    1 +
 3 files changed, 12 insertions(+)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 17e2ccb..0df3ec8 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -360,6 +360,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	init_waitqueue_head(&shost->host_wait);
 
 	mutex_init(&shost->scan_mutex);
+	mutex_init(&shost->block_eh_mutex);
 
 	/*
 	 * subtract one because we increment first then return, but we need to
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index ab16930..566daaa 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -551,6 +551,10 @@ static int scsi_begin_eh(struct Scsi_Host *host)
 {
 	int res;
 
+	res = mutex_lock_interruptible(&host->block_eh_mutex);
+	if (res)
+		goto out;
+
 	spin_lock_irq(host->host_lock);
 	switch (host->shost_state) {
 	case SHOST_DEL:
@@ -565,6 +569,10 @@ static int scsi_begin_eh(struct Scsi_Host *host)
 	}
 	spin_unlock_irq(host->host_lock);
 
+	if (res)
+		mutex_unlock(&host->block_eh_mutex);
+
+out:
 	return res;
 }
 
@@ -579,6 +587,8 @@ static void scsi_end_eh(struct Scsi_Host *host)
 	if (host->eh_active == 0)
 		wake_up(&host->host_wait);
 	spin_unlock_irq(host->host_lock);
+
+	mutex_unlock(&host->block_eh_mutex);
 }
 
 /**
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 9785e51..d7ce065 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -573,6 +573,7 @@ struct Scsi_Host {
 	spinlock_t		*host_lock;
 
 	struct mutex		scan_mutex;/* serialize scanning activity */
+	struct mutex		block_eh_mutex; /* block ML LLD EH calls */
 
 	struct list_head	eh_cmd_q;
 	struct task_struct    * ehandler;  /* Error recovery thread. */
-- 
1.7.10.4


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
