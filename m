From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v3 07/13] scsi_transport_srp: Add transport layer error
 handling
Date: Mon, 08 Jul 2013 20:42:59 +0200
Message-ID: <51DB0833.3030908@acm.org>
References: <51D41C03.4020607@acm.org> <51D41F13.6060203@acm.org>	 <1372864458.24238.32.camel@frustration.ornl.gov> <51D44A86.5050000@acm.org> <1372872474.24238.43.camel@frustration.ornl.gov> <51DAF63D.9010906@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51DAF63D.9010906-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 07/08/13 19:26, Vu Pham wrote:
> After running cable pull test on two local IB links for several hrs, 
> I/Os got stuck.
> Further commands "multipath -ll" or "fdisk -l" got stuck and never return
> Here are the stack dump for srp-x kernel threads.
> I'll run with #DEBUG to get more debug info on scsi host & rport

Hello Vu,

I had a quick look at the stack dump that was attached to your e-mail.
It shows that scsi_execute_req() hangs in blk_execute_rq(). It would be
appreciated if you could continue your tests with the kernel patch below
applied on top of v3 of this patch series. This patch should avoid that
a transport layer error that occurs after device removal has started can
cause the SCSI device state to change into "blocked". This patch also
causes such TL errors to fail I/O quickly (scsi_host_alloc() zero-
initializes the memory it allocates so no explicit initialization of the
"deleted" variable is necessary).

Thanks,

Bart.

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 1b9ebd5..1bb7c63 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -522,6 +522,12 @@ void srp_start_tl_fail_timers(struct srp_rport *rport)
 	int fast_io_fail_tmo, dev_loss_tmo, delay;
 
 	mutex_lock(&rport->mutex);
+	if (rport->deleted) {
+		srp_rport_set_state(rport, SRP_RPORT_FAIL_FAST);
+		scsi_target_unblock(&shost->shost_gendev,
+				    SDEV_TRANSPORT_OFFLINE);
+		goto unlock;
+	}
 	delay = rport->reconnect_delay;
 	fast_io_fail_tmo = rport->fast_io_fail_tmo;
 	dev_loss_tmo = rport->dev_loss_tmo;
@@ -542,6 +548,7 @@ void srp_start_tl_fail_timers(struct srp_rport *rport)
 	if (dev_loss_tmo >= 0)
 		queue_delayed_work(system_long_wq, &rport->dev_loss_work,
 				   1UL * dev_loss_tmo * HZ);
+unlock:
 	mutex_unlock(&rport->mutex);
 }
 EXPORT_SYMBOL(srp_start_tl_fail_timers);
@@ -730,6 +737,7 @@ void srp_rport_del(struct srp_rport *rport)
 	mutex_lock(&rport->mutex);
 	if (rport->state == SRP_RPORT_BLOCKED)
 		__rport_fast_io_fail_timedout(rport);
+	rport->deleted = true;
 	mutex_unlock(&rport->mutex);
 
 	put_device(dev);
diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
index fbcc985..a4addcf 100644
--- a/include/scsi/scsi_transport_srp.h
+++ b/include/scsi/scsi_transport_srp.h
@@ -54,6 +54,7 @@ struct srp_rport {
 	int			dev_loss_tmo;
 	struct delayed_work	fast_io_fail_work;
 	struct delayed_work	dev_loss_work;
+	bool			deleted;
 };
 
 struct srp_function_template {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
