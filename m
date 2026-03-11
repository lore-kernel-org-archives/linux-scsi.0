Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16952FDC3C;
	Wed, 11 Mar 2026 17:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773250296; cv=none; b=TcX4IOSF49tPlrNG9omozMdlxnzKFFsGyCBs8LoR6AuPj/AywVeQEZMp8Vh/mWYnuZyJqvJF6m0BwyGW4jkFjLwvWYKbYHQ5EVNVRWeeveu1UrRcmx65bEER1Umb2QvxT4mdmMHjlgGnqyPMoZoGp1uU4LUVVWnDK35xSIW9kOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773250296; c=relaxed/simple;
	bh=0/p6tsqmd5yIzKIGhZca7+aS5v5d+arWVCVYCkP3EWs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FWDMKpSKVP7HMzOjwUfkdnClqqQJ0x2xx/Korowl5nl01u6CZUWRvDix4iqQECbcVq+sZgAG65a3BMzysK/rnR+L4c6QLGrs8hjEwtGGll7S0du7jeTpao17SzKLXcCVXbtKSgJuTIDyAmo4IyLEQqoc7nvXk9dZEbQWNhq32Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=EqxtotAJ; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="EqxtotAJ"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fWHq76LyYz1XM0ns;
	Wed, 11 Mar 2026 17:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773250284; x=1775842285; bh=tyS3PIz7dyxXyJKUlwIwyejE
	SIFa7vwTtpWP18dYc18=; b=EqxtotAJyY9Sw5VB1wrj3jYao2M1JkYkPK6+y0pW
	syJa4ki7W69iYt3bzGmYqzALnpQaud0mIOPaJnZa0N/ay/AbboHk3klP8Oi3gz5m
	gC8kP9Tzb4Ddt4rxB2LrSlR/u5ykTYQEOPHo9qbetyHxtYyKidjICs6jNiVrRWXr
	9EAoSBavyYX2F0KEpQDYw2+/f7M9XIgAZZPcJjpWKkQunyOWCcfrSQxiAigUTsL+
	+7iZ640f6sUkmwr4vBaAFguBadgUMpyiF4cVnwRWlDHDQtwZF9Gn7CZ4qsWoWJ9V
	uwXTV29Fry1MmJxKI3zSjiGH7nlgVeZcvS4ZHnYjqV0oIg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Ah3Xyeetc3Pv; Wed, 11 Mar 2026 17:31:24 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fWHpz3wcVz1XM0p7;
	Wed, 11 Mar 2026 17:31:22 +0000 (UTC)
Message-ID: <5f64591a-0c24-4f72-8473-18733779a225@acm.org>
Date: Wed, 11 Mar 2026 10:31:20 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: KCSAN: data-race in scsi_block_when_processing_errors /
 scsi_host_set_state
To: Jianzhou Zhao <luckd0g@163.com>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <36d59d0e.6db0.19cdbeee01b.Coremail.luckd0g@163.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <36d59d0e.6db0.19cdbeee01b.Coremail.luckd0g@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 3/11/26 1:06 AM, Jianzhou Zhao wrote:
> Proposed Fix
> We propose implementing `WRITE_ONCE` and `READ_ONCE` within the
> transition path and wait queue evaluator specifically for `shost_state`
> updates to respect proper concurrency protocols.

Is the proposed fix complete? If I annotate the "shost_state" member
variable with __guarded_by(&host_lock) and if I enable lock context
analysis in all SCSI core and SCSI driver Makefiles, something like
this is probably needed to suppress all compiler warnings reported by
Clang:


diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index e047747d4ecf..3d9d183b4e84 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -278,7 +278,8 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, 
struct device *dev,
  	if (error)
  		goto out_disable_runtime_pm;

-	scsi_host_set_state(shost, SHOST_RUNNING);
+	scoped_guard(spinlock_irq, shost->host_lock)
+		scsi_host_set_state(shost, SHOST_RUNNING);
  	get_device(shost->shost_gendev.parent);

  	device_enable_async_suspend(&shost->shost_dev);
@@ -364,7 +365,7 @@ static void scsi_host_dev_release(struct device *dev)
  	if (shost->work_q)
  		destroy_workqueue(shost->work_q);

-	if (shost->shost_state == SHOST_CREATED) {
+	if (context_unsafe(shost->shost_state == SHOST_CREATED)) {
  		/*
  		 * Free the shost_dev device name and remove the proc host dir
  		 * here if scsi_host_{alloc,put}() have been called but neither
@@ -380,7 +381,7 @@ static void scsi_host_dev_release(struct device *dev)

  	ida_free(&host_index_ida, shost->host_no);

-	if (shost->shost_state != SHOST_CREATED)
+	if (context_unsafe(shost->shost_state != SHOST_CREATED))
  		put_device(parent);
  	kfree(shost);
  }
@@ -414,7 +415,7 @@ struct Scsi_Host *scsi_host_alloc(const struct 
scsi_host_template *sht, int priv

  	shost->host_lock = &shost->default_lock;
  	spin_lock_init(shost->host_lock);
-	shost->shost_state = SHOST_CREATED;
+	context_unsafe(shost->shost_state = SHOST_CREATED);
  	INIT_LIST_HEAD(&shost->__devices);
  	INIT_LIST_HEAD(&shost->__targets);
  	INIT_LIST_HEAD(&shost->eh_abort_list);
@@ -600,7 +601,7 @@ EXPORT_SYMBOL(scsi_host_lookup);
   **/
  struct Scsi_Host *scsi_host_get(struct Scsi_Host *shost)
  {
-	if ((shost->shost_state == SHOST_DEL) ||
+	if (context_unsafe(shost->shost_state == SHOST_DEL) ||
  		!get_device(&shost->shost_gendev))
  		return NULL;
  	return shost;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c 
b/drivers/scsi/megaraid/megaraid_sas_base.c
index ccefe5841a17..a234b18bc01e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3075,7 +3075,7 @@ static int megasas_reset_bus_host(struct scsi_cmnd 
*scmd)

  	scmd_printk(KERN_INFO, scmd,
  		"SCSI host state: %d  SCSI host busy: %d  FW outstanding: %d\n",
-		scmd->device->host->shost_state,
+		context_unsafe(scmd->device->host->shost_state),
  		scsi_host_busy(scmd->device->host),
  		atomic_read(&instance->fw_outstanding));
  	/*
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c 
b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 6ff788557294..0737a07afdf4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -5460,7 +5460,7 @@ static enum scsi_qc_status scsih_qcmd(struct 
Scsi_Host *shost,
  	 * Avoid error handling escallation when device is disconnected
  	 */
  	if (handle == MPT3SAS_INVALID_DEVICE_HANDLE || 
sas_device_priv_data->block) {
-		if (scmd->device->host->shost_state == SHOST_RECOVERY &&
+		if (context_unsafe(scmd->device->host->shost_state == SHOST_RECOVERY) &&
  		    scmd->cmnd[0] == TEST_UNIT_READY) {
  			scsi_build_sense(scmd, 0, UNIT_ATTENTION, 0x29, 0x07);
  			scsi_done(scmd);
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index d598ab4126f8..3bd55887a655 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -9413,9 +9413,7 @@ static int qla4xxx_eh_target_reset(struct 
scsi_cmnd *cmd)
   **/
  static int qla4xxx_is_eh_active(struct Scsi_Host *shost)
  {
-	if (shost->shost_state == SHOST_RECOVERY)
-		return 1;
-	return 0;
+	return context_unsafe(shost->shost_state == SHOST_RECOVERY);
  }

  /**
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6e8c7a42603e..5d35007bf9f1 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1638,7 +1638,7 @@ static enum scsi_qc_status 
scsi_dispatch_cmd(struct scsi_cmnd *cmd)
  		goto done;
  	}

-	if (unlikely(host->shost_state == SHOST_DEL)) {
+	if (unlikely(context_unsafe(host->shost_state == SHOST_DEL))) {
  		cmd->result = (DID_NO_CONNECT << 16);
  		goto done;

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index dfc3559e7e04..8e939e21ea18 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -214,8 +214,9 @@ store_shost_state(struct device *dev, struct 
device_attribute *attr,
  	if (!state)
  		return -EINVAL;

-	if (scsi_host_set_state(shost, state))
-		return -EINVAL;
+	scoped_guard(spinlock_irq, shost->host_lock)
+		if (scsi_host_set_state(shost, state))
+			return -EINVAL;
  	return count;
  }

@@ -223,7 +224,7 @@ static ssize_t
  show_shost_state(struct device *dev, struct device_attribute *attr, 
char *buf)
  {
  	struct Scsi_Host *shost = class_to_shost(dev);
-	const char *name = scsi_host_state_name(shost->shost_state);
+	const char *name = 
scsi_host_state_name(context_unsafe(shost->shost_state));

  	if (!name)
  		return -EINVAL;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 7e2011830ba4..a16d115c389b 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -727,7 +727,7 @@ struct Scsi_Host {
  	unsigned int  irq;
  	

-	enum scsi_host_state shost_state;
+	enum scsi_host_state shost_state __guarded_by(&host_lock);

  	/* ldm bits */
  	struct device		shost_gendev, shost_dev;
@@ -787,9 +787,11 @@ static inline struct Scsi_Host *dev_to_shost(struct 
device *dev)

  static inline int scsi_host_in_recovery(struct Scsi_Host *shost)
  {
-	return shost->shost_state == SHOST_RECOVERY ||
-		shost->shost_state == SHOST_CANCEL_RECOVERY ||
-		shost->shost_state == SHOST_DEL_RECOVERY ||
+	enum scsi_host_state state = 
context_unsafe(READ_ONCE(shost->shost_state));
+
+	return state == SHOST_RECOVERY ||
+		state == SHOST_CANCEL_RECOVERY ||
+		state == SHOST_DEL_RECOVERY ||
  		shost->tmf_in_progress;
  }

@@ -835,8 +837,9 @@ static inline struct device *scsi_get_device(struct 
Scsi_Host *shost)
   **/
  static inline int scsi_host_scan_allowed(struct Scsi_Host *shost)
  {
-	return shost->shost_state == SHOST_RUNNING ||
-	       shost->shost_state == SHOST_RECOVERY;
+	enum scsi_host_state state = 
context_unsafe(READ_ONCE(shost->shost_state));
+
+	return state == SHOST_RUNNING || state == SHOST_RECOVERY;
  }

  extern void scsi_unblock_requests(struct Scsi_Host *);
@@ -940,6 +943,7 @@ static inline unsigned char 
scsi_host_get_guard(struct Scsi_Host *shost)
  	return shost->prot_guard_type;
  }

-extern int scsi_host_set_state(struct Scsi_Host *, enum scsi_host_state);
+int scsi_host_set_state(struct Scsi_Host *shost, enum scsi_host_state 
state)
+	__must_hold(&shost->host_lock);

  #endif /* _SCSI_SCSI_HOST_H */

