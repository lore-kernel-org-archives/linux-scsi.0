Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837FC37FF5A
	for <linux-scsi@vger.kernel.org>; Fri, 31 Jul 2026 21:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785534808; cv=none; b=iBy5kIPEzuV0CnAhZ3kaVrUCJ+OvIdXprEx98VrUBrW6OqtYdG4/eqHsJ8FnRGy5/aVMOvsavw37eh7W4M/5qirHqHYO2JmPg9kWFlG2PMZLVFVhA0i2J5IJK4WorUvCZXsjCd0fz3wM0vWfRHBOeUrcQZhyWrn9JYXmk+q6kIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785534808; c=relaxed/simple;
	bh=8iqJXrwy5QKHKXpwZ0An417cbWT+b/O5G+GUgev4qTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HwvMt2H/bEhFnuQ6V4x2IiVYgux9cgml8h2rJ8qg/87iM2dewofsonMW+KPTtZk8/+mXuEPu7hMUine/gHDfASzkOk8pnAUXvxOj1qwoB7ZfkdgKwGz8IzCmLVvxo9mhTvKUHb/IbSogeS545MSWsNoKARNLZ0/VlcbYgZQtdEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3uaYC0HD; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3uaYC0HD"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hBfvn614tzlfvq2;
	Fri, 31 Jul 2026 21:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785534784; x=1788126785; bh=fcOoO
	ZNF21heA11bi6jRhp86L4jJb2b+jp6zRTAamlI=; b=3uaYC0HDLUmLckUEzMSe0
	W2HkRkoWCGldUdCAGf8TrMeCgNavo/wa1v+cC9O+FX7/qnk55tmrqDXkSLp6rHcL
	H/PsiVkFrAlIfxJJ9UIMn/wnG7Nf1lFzWhQkD3ItNvDSwOqh5AglqN9Kuk6wPcyS
	b8C6DXhVjI1c3mKo+QNsu4Fbv8aeVwzU3/60Fezh6LndFsP4mLzJEFzL7zFXrw19
	13y962JGc0fVMc/YU743LjiWP1xOpVal+neDQO2JjIQRbyRBkOqj35Nqgxc4ridl
	Erpj3Wy1X/ZK9OwqYlEX6CbiK+Uf/j30bWdJvOf5kSlWUy7Clp5zk248sdalCWzK
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id E2f93xPyrx7o; Fri, 31 Jul 2026 21:53:04 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hBfvH5Fk5zlfpMQ;
	Fri, 31 Jul 2026 21:52:59 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Jianzhou Zhao <luckd0g@163.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com
Subject: [PATCH v4 5/6] scsi: core: Protect host state changes with the host lock
Date: Fri, 31 Jul 2026 14:52:10 -0700
Message-ID: <970cc36fb627fae64b4957954483c74cf8e59c87.1785534721.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <68f3346cab2be570839350831f82b6c9233832ed.1785534721.git.bvanassche@acm.org>
References: <68f3346cab2be570839350831f82b6c9233832ed.1785534721.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Some but not all SCSI host state changes are protected with the SCSI
host lock. Annotate the SCSI host state with __guarded_by(host_lock),
protect all SCSI host state changes with the SCSI host lock and use
READ_ONCE() for all SCSI host state reads. This patch prevents that
KCSAN complains about data races when accessing the SCSI host state.

Reported-by: Jianzhou Zhao <luckd0g@163.com>
Closes: https://lore.kernel.org/all/36d59d0e.6db0.19cdbeee01b.Coremail.lu=
ckd0g@163.com/
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c                      | 16 +++++++++-------
 drivers/scsi/megaraid/megaraid_sas_base.c |  2 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c           |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      |  2 +-
 drivers/scsi/qla4xxx/ql4_os.c             |  6 ++----
 drivers/scsi/scsi_lib.c                   |  3 +--
 drivers/scsi/scsi_sysfs.c                 |  7 ++++---
 include/scsi/scsi_host.h                  | 23 ++++++++++++++++-------
 8 files changed, 35 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index d512080268af..190b1932416b 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -145,7 +145,7 @@ int scsi_host_set_state(struct Scsi_Host *shost, enum=
 scsi_host_state state)
 		}
 		break;
 	}
-	shost->shost_state =3D state;
+	WRITE_ONCE(shost->shost_state, state);
 	return 0;
=20
  illegal:
@@ -276,7 +276,8 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, s=
truct device *dev,
 	if (error)
 		goto out_disable_runtime_pm;
=20
-	scsi_host_set_state(shost, SHOST_RUNNING);
+	scoped_guard(spinlock_irq, shost->host_lock)
+		scsi_host_set_state(shost, SHOST_RUNNING);
 	get_device(shost->shost_gendev.parent);
=20
 	device_enable_async_suspend(&shost->shost_dev);
@@ -350,6 +351,7 @@ EXPORT_SYMBOL(scsi_add_host_with_dma);
 static void scsi_host_dev_release(struct device *dev)
 {
 	struct Scsi_Host *shost =3D dev_to_shost(dev);
+	enum scsi_host_state host_state =3D scsi_get_host_state(shost);
 	struct device *parent =3D dev->parent;
=20
 	/* Wait for functions invoked through call_rcu(&scmd->rcu, ...) */
@@ -362,7 +364,7 @@ static void scsi_host_dev_release(struct device *dev)
 	if (shost->work_q)
 		destroy_workqueue(shost->work_q);
=20
-	if (shost->shost_state =3D=3D SHOST_CREATED) {
+	if (host_state =3D=3D SHOST_CREATED) {
 		/*
 		 * Free the shost_dev device name and remove the proc host dir
 		 * here if scsi_host_{alloc,put}() have been called but neither
@@ -378,7 +380,7 @@ static void scsi_host_dev_release(struct device *dev)
=20
 	ida_free(&host_index_ida, shost->host_no);
=20
-	if (shost->shost_state !=3D SHOST_CREATED)
+	if (host_state !=3D SHOST_CREATED)
 		put_device(parent);
 	kfree(shost);
 }
@@ -411,8 +413,8 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_h=
ost_template *sht, int priv
 		return NULL;
=20
 	shost->host_lock =3D &shost->default_lock;
-	spin_lock_init(shost->host_lock);
-	shost->shost_state =3D SHOST_CREATED;
+	scoped_guard(spinlock_init, shost->host_lock)
+		shost->shost_state =3D SHOST_CREATED;
 	INIT_LIST_HEAD(&shost->__devices);
 	INIT_LIST_HEAD(&shost->__targets);
 	INIT_LIST_HEAD(&shost->eh_abort_list);
@@ -598,7 +600,7 @@ EXPORT_SYMBOL(scsi_host_lookup);
  **/
 struct Scsi_Host *scsi_host_get(struct Scsi_Host *shost)
 {
-	if ((shost->shost_state =3D=3D SHOST_DEL) ||
+	if (scsi_get_host_state(shost) =3D=3D SHOST_DEL ||
 		!get_device(&shost->shost_gendev))
 		return NULL;
 	return shost;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/meg=
araid/megaraid_sas_base.c
index ecd365d78ae3..f0152b043e18 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3072,7 +3072,7 @@ static int megasas_reset_bus_host(struct scsi_cmnd =
*scmd)
=20
 	scmd_printk(KERN_INFO, scmd,
 		"SCSI host state: %d  SCSI host busy: %d  FW outstanding: %d\n",
-		scmd->device->host->shost_state,
+		scsi_get_host_state(scmd->device->host),
 		scsi_host_busy(scmd->device->host),
 		atomic_read(&instance->fw_outstanding));
 	/*
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
index 402d1f35d214..f80a21ec161b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5172,7 +5172,7 @@ static enum scsi_qc_status mpi3mr_qcmd(struct Scsi_=
Host *shost,
=20
 	/* Avoid error handling escalation when device is removed or blocked */
=20
-	if (scmd->device->host->shost_state =3D=3D SHOST_RECOVERY &&
+	if (scsi_get_host_state(scmd->device->host) =3D=3D SHOST_RECOVERY &&
 		scmd->cmnd[0] =3D=3D TEST_UNIT_READY &&
 		(stgt_priv_data->dev_removed || (dev_handle =3D=3D MPI3MR_INVALID_DEV_=
HANDLE))) {
 		scsi_build_sense(scmd, 0, UNIT_ATTENTION, 0x29, 0x07);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
index dea78688cc9b..0e12009a87f6 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -5472,7 +5472,7 @@ static enum scsi_qc_status scsih_qcmd(struct Scsi_H=
ost *shost,
 	 * Avoid error handling escallation when device is disconnected
 	 */
 	if (handle =3D=3D MPT3SAS_INVALID_DEVICE_HANDLE || sas_device_priv_data=
->block) {
-		if (scmd->device->host->shost_state =3D=3D SHOST_RECOVERY &&
+		if (scsi_get_host_state(scmd->device->host) =3D=3D SHOST_RECOVERY &&
 		    scmd->cmnd[0] =3D=3D TEST_UNIT_READY) {
 			scsi_build_sense(scmd, 0, UNIT_ATTENTION, 0x29, 0x07);
 			scsi_done(scmd);
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.=
c
index d598ab4126f8..c9d9fc7c81fb 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -9411,11 +9411,9 @@ static int qla4xxx_eh_target_reset(struct scsi_cmn=
d *cmd)
  * This routine finds that if reset host is called in EH
  * scenario or from some application like sg_reset
  **/
-static int qla4xxx_is_eh_active(struct Scsi_Host *shost)
+static bool qla4xxx_is_eh_active(struct Scsi_Host *shost)
 {
-	if (shost->shost_state =3D=3D SHOST_RECOVERY)
-		return 1;
-	return 0;
+	return scsi_get_host_state(shost) =3D=3D SHOST_RECOVERY;
 }
=20
 /**
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 22e2e3223440..89d2e5a70e9b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1661,10 +1661,9 @@ static enum scsi_qc_status scsi_dispatch_cmd(struc=
t scsi_cmnd *cmd)
 		goto done;
 	}
=20
-	if (unlikely(host->shost_state =3D=3D SHOST_DEL)) {
+	if (unlikely(scsi_get_host_state(host) =3D=3D SHOST_DEL)) {
 		cmd->result =3D (DID_NO_CONNECT << 16);
 		goto done;
-
 	}
=20
 	trace_scsi_dispatch_cmd_start(cmd);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index dfc3559e7e04..9480432f650b 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -214,8 +214,9 @@ store_shost_state(struct device *dev, struct device_a=
ttribute *attr,
 	if (!state)
 		return -EINVAL;
=20
-	if (scsi_host_set_state(shost, state))
-		return -EINVAL;
+	scoped_guard(spinlock_irq, shost->host_lock)
+		if (scsi_host_set_state(shost, state))
+			return -EINVAL;
 	return count;
 }
=20
@@ -223,7 +224,7 @@ static ssize_t
 show_shost_state(struct device *dev, struct device_attribute *attr, char=
 *buf)
 {
 	struct Scsi_Host *shost =3D class_to_shost(dev);
-	const char *name =3D scsi_host_state_name(shost->shost_state);
+	const char *name =3D scsi_host_state_name(scsi_get_host_state(shost));
=20
 	if (!name)
 		return -EINVAL;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 7e2011830ba4..69d432fd8e32 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -727,7 +727,7 @@ struct Scsi_Host {
 	unsigned int  irq;
 =09
=20
-	enum scsi_host_state shost_state;
+	enum scsi_host_state shost_state __guarded_by(host_lock);
=20
 	/* ldm bits */
 	struct device		shost_gendev, shost_dev;
@@ -785,11 +785,18 @@ static inline struct Scsi_Host *dev_to_shost(struct=
 device *dev)
 	return container_of(dev, struct Scsi_Host, shost_gendev);
 }
=20
+static inline enum scsi_host_state scsi_get_host_state(struct Scsi_Host =
*shost)
+{
+	return context_unsafe(READ_ONCE(shost->shost_state));
+}
+
 static inline int scsi_host_in_recovery(struct Scsi_Host *shost)
 {
-	return shost->shost_state =3D=3D SHOST_RECOVERY ||
-		shost->shost_state =3D=3D SHOST_CANCEL_RECOVERY ||
-		shost->shost_state =3D=3D SHOST_DEL_RECOVERY ||
+	enum scsi_host_state state =3D scsi_get_host_state(shost);
+
+	return state =3D=3D SHOST_RECOVERY ||
+		state =3D=3D SHOST_CANCEL_RECOVERY ||
+		state =3D=3D SHOST_DEL_RECOVERY ||
 		shost->tmf_in_progress;
 }
=20
@@ -835,8 +842,9 @@ static inline struct device *scsi_get_device(struct S=
csi_Host *shost)
  **/
 static inline int scsi_host_scan_allowed(struct Scsi_Host *shost)
 {
-	return shost->shost_state =3D=3D SHOST_RUNNING ||
-	       shost->shost_state =3D=3D SHOST_RECOVERY;
+	enum scsi_host_state state =3D scsi_get_host_state(shost);
+
+	return state =3D=3D SHOST_RUNNING || state =3D=3D SHOST_RECOVERY;
 }
=20
 extern void scsi_unblock_requests(struct Scsi_Host *);
@@ -940,6 +948,7 @@ static inline unsigned char scsi_host_get_guard(struc=
t Scsi_Host *shost)
 	return shost->prot_guard_type;
 }
=20
-extern int scsi_host_set_state(struct Scsi_Host *, enum scsi_host_state)=
;
+int scsi_host_set_state(struct Scsi_Host *shost, enum scsi_host_state st=
ate)
+	__must_hold(shost->host_lock);
=20
 #endif /* _SCSI_SCSI_HOST_H */
