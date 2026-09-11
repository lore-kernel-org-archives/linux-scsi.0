Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9709759B66F
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 20:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789157485; cv=none; b=fnhlC1wcKHSDKHqvi68Sx7Yll2q3ugI2RjThR/BceVEhLkxvhLnxjgd+tbWHf4WqD3DZnZHvrjvNw0PUriJP3QWR516w/3ctLp5bqTVmpBQwyl54JZwkYFVdhA53A3jziMScwU8D2g+3IcJ7bRmFrzf/r6shNVJsCgQ+BVOoezY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789157485; c=relaxed/simple;
	bh=otub/RTcRli6N9pdOaZtULnS62I5z4+cerU/SaeIFEo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QPtgghAk8Ys9u2Tc/BFE/5clLcWSZij+GeugVcaZ0saI5ZFH67TUkSmDfNpppVr7l40ji2RC/1lPqDnQmfh6OF/BClKRFX5eWTAWlIQMThusxnpUjycLJ7Q2RU7xp6uULk8SD3fB2mIdgReLEazuMaU8XooQqmlsDXx7lkAVHDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WT1yJTU3; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WT1yJTU3"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hhQfg02yFzlfwHS;
	Fri, 11 Sep 2026 20:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1789157476; x=1791749477; bh=CYmr2OxH4RPebCGDQWDlcLhQNqPyiQjFzBR
	+/ptAQoA=; b=WT1yJTU3xUDichILo5QxvS1j8L36MSqjiH/agnAGpqvw1yH0Phr
	PAXHYSeZqdAWlS7gT57mto5ea6+CIIM9mtDTuuF7bGIekP4oSLvYt34xdkq9tV+U
	q1X/9CA/WlBqx6bwXUTR2kTPfPbNZjYGITZ9QItJaXB8nnyIPeENq33kyxo2J7TF
	SZJnm4fQlKuLSJBjeIVJqNnEPVsjdBS7SDI0r14BWAdYqjpQpthJQMN6JcNkb8Yl
	4/b7qqEFXODJkafyS1wrzAZWmXTnz9g5KmwcfAMsiarLs/M2EM5VX6Q9pIa9JBlO
	JJEhpvEFFkhiZPPbXfSC7vo4QgYnaonPfag==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id sI2OfPnYELMU; Fri, 11 Sep 2026 20:11:16 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hhQfV1BQnzlfvqM;
	Fri, 11 Sep 2026 20:11:13 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	syzbot+1f678bd2872aefb11d8a@syzkaller.appspotmail.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH] scsi: core: Make SCSI host scan interruptible
Date: Fri, 11 Sep 2026 13:11:04 -0700
Message-ID: <74786683eadc0a32ab335373ead8dd76a9d5a342.1789157339.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Writing to the sysfs "scan" attribute serializes SCSI host scans via
shost->scan_mutex. In virtualized environments such as virtio-scsi with
256 target IDs, scanning non-existent targets repeatedly allocates and
destroys temporary scsi_devices. Each iteration transitions the shared ta=
g
queue state and freezes request queues, causing a full bus scan to take
tens of seconds.

When multiple processes initiate host scans concurrently, waiter tasks
sleep in TASK_UNINTERRUPTIBLE on shost->scan_mutex. If the waiting tasks
receive signals such as SIGKILL, they cannot wake up until the mutex is
acquired, easily exceeding the hung task timeout and triggering
khungtaskd warnings ("INFO: task hung in scsi_scan_host_selected").
Furthermore, once a task finally acquires the mutex, it continues to
perform the full scan even if a fatal signal is already pending.

Fix this by:
1. Use mutex_lock_interruptible() instead of mutex_lock() in
   scsi_scan_host_selected(), allowing waiting tasks to sleep in
   TASK_INTERRUPTIBLE and immediately wake up with -EINTR on signals.
2. Check signal_pending(current) in scsi_scan_host_selected(),
   scsi_scan_channel(), __scsi_scan_target(), scsi_report_lun_scan(),
   and scsi_sequential_lun_scan() to abort scanning early when a signal
   is delivered.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+1f678bd2872aefb11d8a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3D1f678bd2872aefb11d8a
Assisted-by: Gemini
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_scan.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 96e4065ae8b5..ebe190f7e1c1 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -32,6 +32,7 @@
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
+#include <linux/sched/signal.h>
 #include <linux/spinlock.h>
 #include <linux/async.h>
 #include <linux/slab.h>
@@ -1415,11 +1416,14 @@ static void scsi_sequential_lun_scan(struct Scsi_=
Host *shost,
 	 * until we reach the max, or no LUN is found and we are not
 	 * sparse_lun.
 	 */
-	for (lun =3D 1; lun < max_dev_lun; ++lun)
+	for (lun =3D 1; lun < max_dev_lun; ++lun) {
+		if (signal_pending(current))
+			break;
 		if (scsi_probe_and_add_lun(shost, starget, lun, NULL, NULL,
 				rescan, NULL) !=3D SCSI_SCAN_LUN_PRESENT &&
 		    !sparse_lun)
 			return;
+	}
 }
=20
 /**
@@ -1591,6 +1595,9 @@ static int scsi_report_lun_scan(struct Scsi_Host *s=
host,
 	 * the header, so start at 1 and go up to and including num_luns.
 	 */
 	for (lunp =3D &lun_data[1]; lunp <=3D &lun_data[num_luns]; lunp++) {
+		if (signal_pending(current))
+			break;
+
 		lun =3D scsilun_to_int(lunp);
=20
 		if (lun > sdev->host->max_lun) {
@@ -1804,6 +1811,8 @@ static void __scsi_scan_target(struct Scsi_Host *sh=
ost, struct device *parent,
 	 */
 	res =3D scsi_probe_and_add_lun(shost, starget, 0, &bflags, NULL, rescan=
,
 				     NULL);
+	if (signal_pending(current))
+		goto out_reap;
 	if (res =3D=3D SCSI_SCAN_LUN_PRESENT || res =3D=3D SCSI_SCAN_TARGET_PRE=
SENT) {
 		if (scsi_report_lun_scan(shost, starget, bflags, rescan) !=3D 0)
 			/*
@@ -1876,6 +1885,8 @@ static void scsi_scan_channel(struct Scsi_Host *sho=
st, unsigned int channel,
=20
 	if (id =3D=3D SCAN_WILD_CARD)
 		for (id =3D 0; id < shost->max_id; ++id) {
+			if (signal_pending(current))
+				break;
 			/*
 			 * XXX adapter drivers when possible (FCP, iSCSI)
 			 * could modify max_id to match the current max,
@@ -1895,7 +1906,7 @@ static void scsi_scan_channel(struct Scsi_Host *sho=
st, unsigned int channel,
 			__scsi_scan_target(shost, &shost->shost_gendev, channel,
 					order_id, lun, rescan);
 		}
-	else
+	else if (!signal_pending(current))
 		__scsi_scan_target(shost, &shost->shost_gendev, channel,
 				id, lun, rescan);
 }
@@ -1904,6 +1915,8 @@ int scsi_scan_host_selected(struct Scsi_Host *shost=
, unsigned int channel,
 			    unsigned int id, u64 lun,
 			    enum scsi_scan_mode rescan)
 {
+	int ret;
+
 	SCSI_LOG_SCAN_BUS(3, shost_printk (KERN_INFO, shost,
 		"%s: <%u:%u:%llu>\n",
 		__func__, channel, id, lun));
@@ -1913,23 +1926,30 @@ int scsi_scan_host_selected(struct Scsi_Host *sho=
st, unsigned int channel,
 	    ((lun !=3D SCAN_WILD_CARD) && (lun >=3D shost->max_lun)))
 		return -EINVAL;
=20
-	mutex_lock(&shost->scan_mutex);
+	ret =3D mutex_lock_interruptible(&shost->scan_mutex);
+	if (ret)
+		return ret;
+
 	if (!shost->async_scan)
 		scsi_complete_async_scans();
=20
-	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) =3D=3D=
 0) {
+	if (!signal_pending(current) && scsi_host_scan_allowed(shost) &&
+	    scsi_autopm_get_host(shost) =3D=3D 0) {
 		if (channel =3D=3D SCAN_WILD_CARD)
 			for (channel =3D 0; channel <=3D shost->max_channel;
-			     channel++)
+			     channel++) {
+				if (signal_pending(current))
+					break;
 				scsi_scan_channel(shost, channel, id, lun,
 						  rescan);
+			}
 		else
 			scsi_scan_channel(shost, channel, id, lun, rescan);
 		scsi_autopm_put_host(shost);
 	}
 	mutex_unlock(&shost->scan_mutex);
=20
-	return 0;
+	return signal_pending(current) ? -EINTR : 0;
 }
=20
 static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
