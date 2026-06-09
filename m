Received: from mail-vk1-f227.google.com (mail-vk1-f227.google.com [209.85.221.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBB740245F
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jun 2026 11:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781005811; cv=none; b=EcnCpJXctwNhsxoQEMDo0o3P2PXmYCMggO9pNxs2GoCUeHbem9jEJOcnx7jSAPNAT/Z/r5eFsbGK66vk0QyKEDLOlf0dLl8mWjWpRhPtXUKqejqwl2a+9yPPneNO+tR1uG12n1KUstGMjq9nCZzdZiSrOx0A785qu3CmcsvA3VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781005811; c=relaxed/simple;
	bh=3Kv41lKgpOl5wee6Wmx4e4vTLz9/OZ6j/+o4p0XS7OM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cF6fef4/bJ7U2YVLalSZQFSTEwFeuQ43ijetndOD/3tx1h3eaUuljwDhHbSLOT6zEQv1ik8xhkmXFM2ucfXqmhO1o2Z6LZ9ZEdlZkhH//yy0B2kSHjaXQZNcLIQXZ9DrA121JGiiI+0Hm40A/63VzWdOCbIATMujwNu3cCkMQGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Cm51PGc2; arc=none smtp.client-ip=209.85.221.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Cm51PGc2"
Received: by mail-vk1-f227.google.com with SMTP id 71dfb90a1353d-59ebf30a91dso1806505e0c.1
        for <linux-scsi@vger.kernel.org>; Tue, 09 Jun 2026 04:50:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781005808; x=1781610608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fLAZlEa/gpJjIgpIJ2e9Ooy6MTW++uhKEEc/j768mlo=;
        b=BJyInPVtsso45gJkIa8487bm8oILJtNO0NoF5FBsd4gpABrvhnPNQsUQupdKnX1p4r
         LMfXjJwihZ5IECdA4x+YnubW+OZLva1F4UEG37c/dsbGHCAm3dz/X3X/vI3vM2ENefdQ
         GrwjccefBKmEzkDrtEcRj/FMlo8f72HIaakbZAsux7tU6Hy46SE6QtrnBLu6pdpNxvtd
         n/Ib/4/wGTwbbQ86T7H5rQCYaJNVHMLEXQ5lp/cNXcgN9fiJshfzDjXvJIkXAjL7EBt+
         tNBZ2yTbOyc/PlwozuOKacSiDaDjrVQqIaRR9EX3WFHQPJG5GjqaBL9yPVOPgIUU8fqr
         m72Q==
X-Forwarded-Encrypted: i=1; AFNElJ+m4tfANECKnGVKgNIWuBDIl93XeGjwrTPUNsvulQ1XEyOM92kwGj0gLHWHrwsY3g6XQn8xGGR9b5Zx@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9OsiC77CNQcKT1vmCQA6sC7bzoDeMkAhA+UFykG9ei6264AO0
	2f+KDiO7GxvNt4vPC4xLiW/hUoPq/swkf4LPcxIwdJN5oFodT7UdqxCAeKk+ys3CSGMtvzIPuO0
	LjTaBWfB5fU8X0APV3IXjpdfEbmRn0Oan0RI8uv9oG6+oQ2W54PaRDKXRx4hkeopavBctXeL4J+
	JYo4B6wn33cFhvJPChv02ZTDYjSQLCnOwpYO5U/P8nTciv/Ap1OhxJz9UnkVllylQkmaWy8WXu4
	LRs+/lyPs/K/tDy
X-Gm-Gg: Acq92OGRu15Ihr6eRaissbaSBzqXD2xXOfMlvvCiR9jtLMTS4ChWnl0tZJ46CPpcj/g
	jTbhZdR5eHYipcrPflmyqgTxf9LLFHFQPWvUcoJXsArJHPrghNrEXZX7RQh00xgsDJQY/2liTJU
	J+ItIOk14v4s5A7+L4msC+6wqS6D/p0kPe1KdsQgY6aOEMwf8ayyI2Dt6IBRdirJ9qBXPEgfYtq
	J4ojEuZ7D27qegMZOZpL5QusJyCOC82Nvdq0L9fdiUAjOYwIWK5k/G6xeJCQj8H5Vp5S+UE2gK3
	OkfD0fAPZwRYXNzC74ljiR7F4BO+VAFf39G7d02gpvTqOIXXm3MOVc8+CeOHfYvCJegA4sNmDVE
	bkelzS7A/eqYEKCrgXkosOFV5NCPY8KBuySYVuFT42IJG/aMN0CUkyH+OlqaujakRoyJTt+194V
	kHZfUIdjUnlNx7tQCqEy4UmRdFs9/tv7+VzNtRobrzIPBD9oqSLGj3lMzad86DUIs0KJeglw==
X-Received: by 2002:a05:6122:8b16:b0:575:29ef:7df8 with SMTP id 71dfb90a1353d-5ac4dcf256dmr9630058e0c.2.1781005808094;
        Tue, 09 Jun 2026 04:50:08 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-117.dlp.protect.broadcom.com. [144.49.247.117])
        by smtp-relay.gmail.com with ESMTPS id 71dfb90a1353d-5a6db1d4376sm1419355e0c.3.2026.06.09.04.50.06
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jun 2026 04:50:08 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-36b808bedfaso6244007a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 09 Jun 2026 04:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1781005806; x=1781610606; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fLAZlEa/gpJjIgpIJ2e9Ooy6MTW++uhKEEc/j768mlo=;
        b=Cm51PGc2QdV8g1RHRzxw8t/lDGzGZYGexsMd7UFYDiUfAukSeTvOvSYr2syyiSs51w
         BYOA7NvlwQYGDJPgr1RGpRd5zHqNNA82aDlR6HOKlvfdIIke3BboxXGU+ODnps5xgIg7
         zR8uBfo2lrgdPJKeQEslVawVI8gyMzZFO/Kwc=
X-Forwarded-Encrypted: i=1; AFNElJ89aCudVV6Uw/QQ/pTtjV9CuIe7mqIDOkmhFevtU6tc8wZqC4MT1N4Y/Yl8i7SPzfrsZmEHEJ4ILxeu@vger.kernel.org
X-Received: by 2002:a17:90b:57c4:b0:36b:75:6387 with SMTP id 98e67ed59e1d1-370eea202f0mr20609542a91.8.1781005805589;
        Tue, 09 Jun 2026 04:50:05 -0700 (PDT)
X-Received: by 2002:a17:90b:57c4:b0:36b:75:6387 with SMTP id 98e67ed59e1d1-370eea202f0mr20609495a91.8.1781005805070;
        Tue, 09 Jun 2026 04:50:05 -0700 (PDT)
Received: from sumit_ws.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6bf903fasm18898075a91.2.2026.06.09.04.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 04:50:03 -0700 (PDT)
From: Sumit Saxena <sumit.saxena@broadcom.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	Adam Radford <aradford@gmail.com>,
	Khalid Aziz <khalid@gonehiking.org>,
	Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	Matthew Wilcox <willy@infradead.org>,
	Hannes Reinecke <hare@suse.com>,
	"Juergen E . Fischer" <fischer@norbit.de>,
	Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org,
	Finn Thain <fthain@linux-m68k.org>,
	Michael Schmitz <schmitzmic@gmail.com>,
	Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
	Oliver Neukum <oliver@neukum.org>,
	Ali Akcaagac <aliakc@web.de>,
	Jamie Lenehan <lenehan@twibble.org>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	target-devel@vger.kernel.org,
	Bradley Grove <linuxdrivers@attotech.com>,
	Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Yihang Li <liyihang9@h-partners.com>,
	Don Brace <don.brace@microchip.com>,
	storagedev@microchip.com,
	HighPoint Linux Team <linux@highpoint-tech.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	Brian King <brking@us.ibm.com>,
	Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	open-iscsi@googlegroups.com,
	Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	megaraidlinux.pdl@broadcom.com,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	MPT-FusionLinux.pdl@broadcom.com,
	Daniel Palmer <daniel@thingy.jp>,
	GOTO Masanori <gotom@debian.or.jp>,
	YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Geoff Levand <geoff@infradead.org>,
	Michael Reed <mdr@sgi.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Narsimhulu Musini <nmusini@cisco.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	linux-hyperv@vger.kernel.org,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eugenio Perez <eperezma@redhat.com>,
	virtualization@lists.linux.dev,
	Vishal Bhakta <vishal.bhakta@broadcom.com>,
	bcm-kernel-feedback-list@broadcom.com,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	xen-devel@lists.xenproject.org,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 4/4] scsi: use percpu counters for iostat counters in struct scsi_device
Date: Tue,  9 Jun 2026 17:48:03 +0530
Message-ID: <20260609121806.2121755-5-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260609121806.2121755-1-sumit.saxena@broadcom.com>
References: <20260609121806.2121755-1-sumit.saxena@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

iorequest_cnt and iodone_cnt are updated on every command dispatch and
completion, often from different CPUs on high queue depth workloads.
Using adjacent atomic_t fields causes cache line contention between the
submission and completion paths.

Extend the same treatment to ioerr_cnt and iotmo_cnt so all four iostat
counters in struct scsi_device use struct percpu_counter.

Suggested-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/scsi_error.c  |  4 ++--
 drivers/scsi/scsi_lib.c    | 10 +++++-----
 drivers/scsi/scsi_scan.c   |  8 ++++++++
 drivers/scsi/scsi_sysfs.c  | 23 ++++++++++++++---------
 drivers/scsi/sd.c          |  2 +-
 include/scsi/scsi_device.h |  9 +++++----
 6 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 147127fb4db9..b1aa7da2ba7c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -349,7 +349,7 @@ enum blk_eh_timer_return scsi_timeout(struct request *req)
 	trace_scsi_dispatch_cmd_timeout(scmd);
 	scsi_log_completion(scmd, TIMEOUT_ERROR);
 
-	atomic_inc(&scmd->device->iotmo_cnt);
+	percpu_counter_inc(&scmd->device->iotmo_cnt);
 	if (host->eh_deadline != -1 && !host->last_reset)
 		host->last_reset = jiffies;
 
@@ -370,7 +370,7 @@ enum blk_eh_timer_return scsi_timeout(struct request *req)
 	 */
 	if (test_and_set_bit(SCMD_STATE_COMPLETE, &scmd->state))
 		return BLK_EH_DONE;
-	atomic_inc(&scmd->device->iodone_cnt);
+	percpu_counter_inc(&scmd->device->iodone_cnt);
 	if (scsi_abort_command(scmd) != SUCCESS) {
 		set_host_byte(scmd, DID_TIME_OUT);
 		scsi_eh_scmd_add(scmd);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6e8c7a42603e..979fdace33ac 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1554,9 +1554,9 @@ static void scsi_complete(struct request *rq)
 
 	INIT_LIST_HEAD(&cmd->eh_entry);
 
-	atomic_inc(&cmd->device->iodone_cnt);
+	percpu_counter_inc(&cmd->device->iodone_cnt);
 	if (cmd->result)
-		atomic_inc(&cmd->device->ioerr_cnt);
+		percpu_counter_inc(&cmd->device->ioerr_cnt);
 
 	disposition = scsi_decide_disposition(cmd);
 	if (disposition != SUCCESS && scsi_cmd_runtime_exceeced(cmd))
@@ -1592,7 +1592,7 @@ static enum scsi_qc_status scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 	struct Scsi_Host *host = cmd->device->host;
 	int rtn = 0;
 
-	atomic_inc(&cmd->device->iorequest_cnt);
+	percpu_counter_inc(&cmd->device->iorequest_cnt);
 
 	/* check if the device is still usable */
 	if (unlikely(cmd->device->sdev_state == SDEV_DEL)) {
@@ -1614,7 +1614,7 @@ static enum scsi_qc_status scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		 */
 		SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
 			"queuecommand : device blocked\n"));
-		atomic_dec(&cmd->device->iorequest_cnt);
+		percpu_counter_dec(&cmd->device->iorequest_cnt);
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
 
@@ -1647,7 +1647,7 @@ static enum scsi_qc_status scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 	trace_scsi_dispatch_cmd_start(cmd);
 	rtn = host->hostt->queuecommand(host, cmd);
 	if (rtn) {
-		atomic_dec(&cmd->device->iorequest_cnt);
+		percpu_counter_dec(&cmd->device->iorequest_cnt);
 		trace_scsi_dispatch_cmd_error(cmd, rtn);
 		if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
 		    rtn != SCSI_MLQUEUE_TARGET_BUSY)
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 121a14d5fdb8..bc885c72f01e 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -350,6 +350,14 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 
 	scsi_sysfs_device_initialize(sdev);
 
+	if (percpu_counter_init(&sdev->iorequest_cnt, 0, GFP_KERNEL) ||
+	    percpu_counter_init(&sdev->iodone_cnt, 0, GFP_KERNEL) ||
+	    percpu_counter_init(&sdev->ioerr_cnt, 0, GFP_KERNEL) ||
+	    percpu_counter_init(&sdev->iotmo_cnt, 0, GFP_KERNEL)) {
+		ret = -ENOMEM;
+		goto out_device_destroy;
+	}
+
 	if (scsi_device_is_pseudo_dev(sdev))
 		return sdev;
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index dfc3559e7e04..f652edd16497 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -516,6 +516,10 @@ static void scsi_device_dev_release(struct device *dev)
 	if (vpd_pgb7)
 		kfree_rcu(vpd_pgb7, rcu);
 	kfree(sdev->inquiry);
+	percpu_counter_destroy(&sdev->iotmo_cnt);
+	percpu_counter_destroy(&sdev->ioerr_cnt);
+	percpu_counter_destroy(&sdev->iodone_cnt);
+	percpu_counter_destroy(&sdev->iorequest_cnt);
 	kfree(sdev);
 
 	if (parent)
@@ -936,26 +940,27 @@ static ssize_t
 show_iostat_counterbits(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
-	return snprintf(buf, 20, "%d\n", (int)sizeof(atomic_t) * 8);
+	/* iostat counters are per-CPU sums (s64).  Report width for tools. */
+	return sysfs_emit(buf, "%zu\n", sizeof(s64) * 8);
 }
 
 static DEVICE_ATTR(iocounterbits, S_IRUGO, show_iostat_counterbits, NULL);
 
-#define show_sdev_iostat(field)						\
+#define show_sdev_iostat_percpu(field)					\
 static ssize_t								\
 show_iostat_##field(struct device *dev, struct device_attribute *attr,	\
 		    char *buf)						\
 {									\
 	struct scsi_device *sdev = to_scsi_device(dev);			\
-	unsigned long long count = atomic_read(&sdev->field);		\
-	return snprintf(buf, 20, "0x%llx\n", count);			\
+	unsigned long long count = percpu_counter_sum(&sdev->field);	\
+	return sysfs_emit(buf, "0x%llx\n", count);			\
 }									\
-static DEVICE_ATTR(field, S_IRUGO, show_iostat_##field, NULL)
+static DEVICE_ATTR(field, 0444, show_iostat_##field, NULL)
 
-show_sdev_iostat(iorequest_cnt);
-show_sdev_iostat(iodone_cnt);
-show_sdev_iostat(ioerr_cnt);
-show_sdev_iostat(iotmo_cnt);
+show_sdev_iostat_percpu(iorequest_cnt);
+show_sdev_iostat_percpu(iodone_cnt);
+show_sdev_iostat_percpu(ioerr_cnt);
+show_sdev_iostat_percpu(iotmo_cnt);
 
 static ssize_t
 sdev_show_modalias(struct device *dev, struct device_attribute *attr, char *buf)
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index adc3fa55ca2c..b7ce01de17b3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4043,7 +4043,7 @@ static int sd_probe(struct scsi_device *sdp)
 	sdkp->index = index;
 	sdkp->max_retries = SD_MAX_RETRIES;
 	atomic_set(&sdkp->openers, 0);
-	atomic_set(&sdkp->device->ioerr_cnt, 0);
+	percpu_counter_set(&sdkp->device->ioerr_cnt, 0);
 
 	if (!sdp->request_queue->rq_timeout) {
 		if (sdp->type != TYPE_MOD)
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 029f5115b2ea..4be36bf2a475 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -9,6 +9,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_common.h>
 #include <linux/atomic.h>
+#include <linux/percpu_counter.h>
 #include <linux/sbitmap.h>
 
 struct bsg_device;
@@ -272,10 +273,10 @@ struct scsi_device {
 	unsigned int max_device_blocked; /* what device_blocked counts down from  */
 #define SCSI_DEFAULT_DEVICE_BLOCKED	3
 
-	atomic_t iorequest_cnt;
-	atomic_t iodone_cnt;
-	atomic_t ioerr_cnt;
-	atomic_t iotmo_cnt;
+	struct percpu_counter iorequest_cnt;
+	struct percpu_counter iodone_cnt;
+	struct percpu_counter ioerr_cnt;
+	struct percpu_counter iotmo_cnt;
 
 	struct device		sdev_gendev,
 				sdev_dev;
-- 
2.43.7

