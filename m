Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814C61C860B;
	Sun, 25 Jan 2026 04:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769314487; cv=none; b=G7wIrw9AslT4cyamZny0JBO2ZzT9on3v1C/jERbzoBrslzddBjNcqBxuufYfmrjIQCit+EWAQ/tJj8XSSFNt3in4HZslUJqOseXBkHN2D+1WzCeinV+6/9/zohxQ9Ahp804MNjzCVMacoXT+Ys9+/iKkjmltEC8WbEi4ah1Tstk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769314487; c=relaxed/simple;
	bh=biG6CdtUnOgE0iMuuVJYlsKffQ2fGfER1ReUudm0QxA=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=aotIDcjvv9KeDJc1i7TgB3dmQVoWGpKQ8Ic3iQ/QPr7QhqD1PxcvbdYv3ei1HfU+fEziQcEnrZE8JfuQTqdrCcXw18zQAAWmj91Qx6Nf+uwCqVH4Xt1GUXIXGYoP7UcDKjnmK5s1BDwTESKmk+p0cqMsb8zkDdrOTlMeP6AV4M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=aVZCLj/Z; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="aVZCLj/Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1769314484;
	bh=biG6CdtUnOgE0iMuuVJYlsKffQ2fGfER1ReUudm0QxA=;
	h=Message-ID:Subject:From:To:Date:From;
	b=aVZCLj/ZqibgMny6Zy0muiwx0IQdvxI8Rd1jbKgml6OCFE/J66xjDUUGKXYAAyBne
	 CP144f5EdxFF1gy6GLFTAGxOVK8kwUqio2ephGM2X2Inj4AM6yGNtrTvbHv3hF0CfR
	 DB6D7+A8Ux8Jhrwp69VmyQ2NbOnIpud0leUG58yY=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id E28261C0230;
	Sat, 24 Jan 2026 23:14:43 -0500 (EST)
Message-ID: <1a20127d291b660d4f85bb85c1dacc67c228c368.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.19-rc6
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Sat, 24 Jan 2026 23:14:43 -0500
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

only one core change, the rest are drivers.=C2=A0The core change reorders
some state operations in the error handler to try to prevent missed
wake ups of the error handler (which can halt error processing and
effectively freeze the entire system).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Abdun Nihaal (1):
      scsi: xen: scsiback: Fix potential memory leak in scsiback_remove()

David Jeffery (1):
      scsi: core: Wake up the error handler when final completions race aga=
inst each other

Jiasheng Jiang (1):
      scsi: qla2xxx: Sanitize payload size to prevent member overflow

Long Li (1):
      scsi: storvsc: Process unsupported MODE_SENSE_10

Maurizio Lombardi (2):
      scsi: target: iscsi: Fix use-after-free in iscsit_dec_session_usage_c=
ount()
      scsi: target: iscsi: Fix use-after-free in iscsit_dec_conn_usage_coun=
t()


And the diffstat:

 drivers/scsi/qla2xxx/qla_isr.c           |  7 +++++++
 drivers/scsi/scsi_error.c                | 11 ++++++++++-
 drivers/scsi/scsi_lib.c                  |  8 ++++++++
 drivers/scsi/storvsc_drv.c               |  3 ++-
 drivers/target/iscsi/iscsi_target_util.c | 10 ++++++++--
 drivers/xen/xen-scsiback.c               |  1 +
 6 files changed, 36 insertions(+), 4 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.=
c
index a3971afc2dd1..a04a5aa0d005 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -878,6 +878,9 @@ qla27xx_copy_multiple_pkt(struct scsi_qla_host *vha, vo=
id **pkt,
 		payload_size =3D sizeof(purex->els_frame_payload);
 	}
=20
+	if (total_bytes > sizeof(item->iocb.iocb))
+		total_bytes =3D sizeof(item->iocb.iocb);
+
 	pending_bytes =3D total_bytes;
 	no_bytes =3D (pending_bytes > payload_size) ? payload_size :
 		   pending_bytes;
@@ -1163,6 +1166,10 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, voi=
d **pkt,
=20
 	total_bytes =3D (le16_to_cpu(purex->frame_size) & 0x0FFF)
 	    - PURX_ELS_HEADER_SIZE;
+
+	if (total_bytes > sizeof(item->iocb.iocb))
+		total_bytes =3D sizeof(item->iocb.iocb);
+
 	pending_bytes =3D total_bytes;
 	entry_count =3D entry_count_remaining =3D purex->entry_count;
 	no_bytes =3D (pending_bytes > sizeof(purex->els_frame_payload))  ?
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index eebca96c1fc1..b6e8730e049e 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -282,11 +282,20 @@ static void scsi_eh_inc_host_failed(struct rcu_head *=
head)
 {
 	struct scsi_cmnd *scmd =3D container_of(head, typeof(*scmd), rcu);
 	struct Scsi_Host *shost =3D scmd->device->host;
-	unsigned int busy =3D scsi_host_busy(shost);
+	unsigned int busy;
 	unsigned long flags;
=20
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->host_failed++;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	/*
+	 * The counting of busy requests needs to occur after adding to
+	 * host_failed or after the lock acquire for adding to host_failed
+	 * to prevent a race with host unbusy and missing an eh wakeup.
+	 */
+	busy =3D scsi_host_busy(shost);
+
+	spin_lock_irqsave(shost->host_lock, flags);
 	scsi_eh_wakeup(shost, busy);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c7d6b76c86d2..4a902c9dfd8b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -376,6 +376,14 @@ static void scsi_dec_host_busy(struct Scsi_Host *shost=
, struct scsi_cmnd *cmd)
 	rcu_read_lock();
 	__clear_bit(SCMD_STATE_INFLIGHT, &cmd->state);
 	if (unlikely(scsi_host_in_recovery(shost))) {
+		/*
+		 * Ensure the clear of SCMD_STATE_INFLIGHT is visible to
+		 * other CPUs before counting busy requests. Otherwise,
+		 * reordering can cause CPUs to race and miss an eh wakeup
+		 * when no CPU sees all busy requests as done or timed out.
+		 */
+		smp_mb();
+
 		unsigned int busy =3D scsi_host_busy(shost);
=20
 		spin_lock_irqsave(shost->host_lock, flags);
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 6e4112143c76..b43d876747b7 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1144,7 +1144,7 @@ static void storvsc_on_io_completion(struct storvsc_d=
evice *stor_device,
 	 * The current SCSI handling on the host side does
 	 * not correctly handle:
 	 * INQUIRY command with page code parameter set to 0x80
-	 * MODE_SENSE command with cmd[2] =3D=3D 0x1c
+	 * MODE_SENSE and MODE_SENSE_10 command with cmd[2] =3D=3D 0x1c
 	 * MAINTENANCE_IN is not supported by HyperV FC passthrough
 	 *
 	 * Setup srb and scsi status so this won't be fatal.
@@ -1154,6 +1154,7 @@ static void storvsc_on_io_completion(struct storvsc_d=
evice *stor_device,
=20
 	if ((stor_pkt->vm_srb.cdb[0] =3D=3D INQUIRY) ||
 	   (stor_pkt->vm_srb.cdb[0] =3D=3D MODE_SENSE) ||
+	   (stor_pkt->vm_srb.cdb[0] =3D=3D MODE_SENSE_10) ||
 	   (stor_pkt->vm_srb.cdb[0] =3D=3D MAINTENANCE_IN &&
 	   hv_dev_is_fc(device))) {
 		vstor_packet->vm_srb.scsi_status =3D 0;
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscs=
i/iscsi_target_util.c
index 5e6cf34929b5..c1888c42afdd 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -741,8 +741,11 @@ void iscsit_dec_session_usage_count(struct iscsit_sess=
ion *sess)
 	spin_lock_bh(&sess->session_usage_lock);
 	sess->session_usage_count--;
=20
-	if (!sess->session_usage_count && sess->session_waiting_on_uc)
+	if (!sess->session_usage_count && sess->session_waiting_on_uc) {
+		spin_unlock_bh(&sess->session_usage_lock);
 		complete(&sess->session_waiting_on_uc_comp);
+		return;
+	}
=20
 	spin_unlock_bh(&sess->session_usage_lock);
 }
@@ -810,8 +813,11 @@ void iscsit_dec_conn_usage_count(struct iscsit_conn *c=
onn)
 	spin_lock_bh(&conn->conn_usage_lock);
 	conn->conn_usage_count--;
=20
-	if (!conn->conn_usage_count && conn->conn_waiting_on_uc)
+	if (!conn->conn_usage_count && conn->conn_waiting_on_uc) {
+		spin_unlock_bh(&conn->conn_usage_lock);
 		complete(&conn->conn_waiting_on_uc_comp);
+		return;
+	}
=20
 	spin_unlock_bh(&conn->conn_usage_lock);
 }
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 0c51edfd13dc..7d5117e5efe0 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1262,6 +1262,7 @@ static void scsiback_remove(struct xenbus_device *dev=
)
 	gnttab_page_cache_shrink(&info->free_pages, 0);
=20
 	dev_set_drvdata(&dev->dev, NULL);
+	kfree(info);
 }
=20
 static int scsiback_probe(struct xenbus_device *dev,

