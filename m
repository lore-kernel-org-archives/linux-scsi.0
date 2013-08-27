From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: [RFC][PATCH] Add a flight data recorder for scsi commands
Date: Tue, 27 Aug 2013 18:17:14 -0400
Message-ID: <20130827221714.GC7293@logfs.org>
References: <20130827220325.GB7293@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:60119 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab3H0XvB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Aug 2013 19:51:01 -0400
Content-Disposition: inline
In-Reply-To: <20130827220325.GB7293@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-scsi@vger.kernel.org

Here is a fun patch in an early state.  Essentially I want to trace
scsi commands, which has already been done long ago.  The problem I
have is that I care about all the scsi commands for one particular
device - without knowing in advance which device it will be.  Once I
know the device in question, I want to dump the last X commands.

The existing tracing is covering all commands to all devices.  So
either I have to oversize my trace buffer and dump way too much, or I
will miss the stuff I am interested in most of the time.  Hence my
per-device trace buffer (called fdr to avoid namespace collisions).

Steven, is there some magic 2-line patch that would also give me what
I want without having to reinvent all your infrastructure and doing
such a bad job?

J=C3=B6rn

--
It is better to die of hunger having lived without grief and fear,
than to live with a troubled spirit amid abundance.
-- Epictetus


And dump the fdr whenever we run into a timeout.  If the timeout is
caused by a crashed target and the target crash is triggered by a weird
command sent by us, we might want to know which commands we send out.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/scsi/scsi.c        |   31 +++++++++++++++++++++++++++++++
 drivers/scsi/scsi_error.c  |   38 ++++++++++++++++++++++++++++++++++++=
++
 drivers/scsi/scsi_scan.c   |    1 +
 include/scsi/scsi_device.h |   13 +++++++++++++
 4 files changed, 83 insertions(+)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index a884f13..54168bb 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -647,6 +647,36 @@ void scsi_cmd_get_serial(struct Scsi_Host *host, s=
truct scsi_cmnd *cmd)
 }
 EXPORT_SYMBOL(scsi_cmd_get_serial);
=20
+static void fdr_add(struct fdr_ring *ring, struct fdr_entry *entry)
+{
+	struct fdr_entry *old;
+	unsigned long flags;
+	int index;
+
+	spin_lock_irqsave(&ring->fdr_lock, flags);
+	index =3D ring->last_entry + 1;
+	if (index >=3D ARRAY_SIZE(ring->entry))
+		index =3D 0;
+	old =3D ring->entry[index];
+	ring->entry[index] =3D entry;
+	ring->last_entry =3D index;
+	spin_unlock_irqrestore(&ring->fdr_lock, flags);
+	kfree(old);
+}
+
+static void fdr_scsi_cmd(struct scsi_cmnd *cmd)
+{
+	struct fdr_entry *new;
+
+	new =3D kmalloc(sizeof(*new) + cmd->cmd_len, GFP_KERNEL);
+	if (!new)
+		return;
+	new->ts_nsec =3D local_clock();
+	new->size =3D cmd->cmd_len;
+	memcpy(new->data, cmd->cmnd, new->size);
+	fdr_add(&cmd->device->fdr, new);
+}
+
 /**
  * scsi_dispatch_command - Dispatch a command to the low-level driver.
  * @cmd: command block we are dispatching.
@@ -747,6 +777,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		scsi_done(cmd);
 	} else {
 		trace_scsi_dispatch_cmd_start(cmd);
+		fdr_scsi_cmd(cmd);
 		cmd->scsi_done =3D scsi_done;
 		rtn =3D host->hostt->queuecommand(host, cmd);
 	}
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 0dfae50..829cb74 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -132,6 +132,41 @@ static void queue_for_eh(struct Scsi_Host *shost, =
struct scsi_cmnd *scmd)
 	schedule_work(&scmd->abort_work);
 }
=20
+static void scsi_fdr_dump(struct fdr_entry *entry)
+{
+	char buf[64 + 8 + 2];
+	unsigned long ts =3D entry->ts_nsec;
+	unsigned long rem_nsec;
+
+	rem_nsec =3D do_div(ts, 1000000000);
+	hex_dump_to_buffer(entry->data, entry->size, 32, 8, buf, sizeof(buf),=
 0);
+	pr_info("%6lu.%06lu: %s\n", ts, rem_nsec, buf);
+}
+
+static void fdr_dump(struct fdr_ring *ring, void (*dump) (struct fdr_e=
ntry * entry))
+{
+	struct fdr_entry *entry;
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&ring->fdr_lock, flags);
+	for (i =3D ring->last_entry + 1; i < ARRAY_SIZE(ring->entry); i++) {
+		entry =3D ring->entry[i];
+		ring->entry[i] =3D NULL;
+		if (entry)
+			dump(entry);
+		kfree(entry);
+	}
+	for (i =3D 0; i < ring->last_entry; i++) {
+		entry =3D ring->entry[i];
+		ring->entry[i] =3D NULL;
+		if (entry)
+			dump(entry);
+		kfree(entry);
+	}
+	spin_unlock_irqrestore(&ring->fdr_lock, flags);
+}
+
 /**
  * scsi_times_out - Timeout function for normal scsi commands.
  * @req:	request that is timing out.
@@ -148,6 +183,9 @@ enum blk_eh_timer_return scsi_times_out(struct requ=
est *req)
 	enum blk_eh_timer_return rtn =3D BLK_EH_NOT_HANDLED;
 	struct Scsi_Host *host =3D scmd->device->host;
=20
+	sdev_printk(KERN_INFO, scmd->device, "dumping cdb recorder\n");
+	fdr_dump(&scmd->device->fdr, scsi_fdr_dump);
+
 	trace_scsi_dispatch_cmd_timeout(scmd);
 	scsi_log_completion(scmd, TIMEOUT_ERROR);
=20
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index db89445..85dbae4 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -252,6 +252,7 @@ static struct scsi_device *scsi_alloc_sdev(struct s=
csi_target *starget,
 	INIT_LIST_HEAD(&sdev->starved_entry);
 	INIT_LIST_HEAD(&sdev->event_list);
 	spin_lock_init(&sdev->list_lock);
+	spin_lock_init(&sdev->fdr.fdr_lock);
 	INIT_WORK(&sdev->event_work, scsi_evt_thread);
 	INIT_WORK(&sdev->requeue_work, scsi_requeue_run_queue);
 	/* Limit scsi messages per device */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index bafc41c..00b7e9b 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -97,6 +97,18 @@ enum scsi_err_inj_duration {
 };
 #endif /* CONFIG_SCSI_ERROR_INJECTOR */
=20
+struct fdr_entry {
+	unsigned long ts_nsec;
+	u32 size;
+	u8 data[0];
+};
+
+struct fdr_ring {
+	spinlock_t fdr_lock;
+	int last_entry;
+	struct fdr_entry *entry[1000];
+};
+
 struct scsi_device {
 	struct Scsi_Host *host;
 	struct request_queue *request_queue;
@@ -222,6 +234,7 @@ struct scsi_device {
 	struct scsi_dh_data	*scsi_dh_data;
 	enum scsi_device_state sdev_state;
 	struct ratelimit_state	sdev_ratelimit;
+	struct fdr_ring		fdr;
 	unsigned long		sdev_data[0];
 } __attribute__((aligned(sizeof(unsigned long))));
=20
--=20
1.7.10.4
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
