Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B55538CFEF
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 17:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785866041; cv=none; b=qCW+1/bcP6NFB0WucIRlxZl6DpvhodKIys9QmtfrCUm7zJayljcKLnikWq7X+rhS8j5JvcRiEHBQYnBLMHBTqJpPDuFX9ueaahXFEI93C2aONQfxM5jKakztjU1tlVjmd7jXuEyEvSXOY2WVNBNrPtOTk6xBN46IhcML7zM8R24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785866041; c=relaxed/simple;
	bh=Nu4RTBqNFzOGcPBUg3olOy6p9/hJtxWTMjZPKAYiHdQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aTR0qR0FZpvbPqLc3zAE9w0Ac2sWwINR/H5iI5vCkOz2EXs+GHwD77dXqtbgYrYLrE/8VUfK6helMAPEK8EsEgmrvJqffEeff9qgp7LvwGnRUySv1dH5TRR0WrwRZuK9U5G17OgEepYLs2NEpfgcMVgyr5Sk2Zqb6S/GxIOhTk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=fmWph82L; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="fmWph82L"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hF1PX3Z2fz1XM30j;
	Tue,  4 Aug 2026 17:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1785866017; x=1788458018; bh=pFjmJ8uGOZfPBAB53izu2+9U
	imApfRigs4gjEacYnrM=; b=fmWph82LaR8Pj8ZPzm84JD6Bo0bF6dAJIGTWuz9x
	b5M0AvIJ+Ngsf5qT3auHE5IZpnEXHzo2S6FtUf0MRCEcd/Zk91+Os11IQv6tnkku
	PRNTiDxXuP1DPlljPmulD1AGLtXaxFFeusWs61Ib9yCBJDkOv/2Qe09eU8Y8qhwJ
	pn1jzfZMmkTkXRuTOAgMlTQWjT+v32XPAcTFmviJaKK7Sltq2rYGVKTL2sqv07RU
	N6DR3bJ1D+QCVMCDozHGy9+8CnPbiAl6UsrDkfZaYBmiUXgvx8IA89/h7JSRfHwq
	wVmmAgjbp3HlKP0CYC63CAXBf0FQ+B6F9CfwYpx9fms3Xg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id zqdrLKkMRzca; Tue,  4 Aug 2026 17:53:37 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hF1PD1xX8z1XM4Tl;
	Tue,  4 Aug 2026 17:53:35 +0000 (UTC)
Message-ID: <efff8e1d-0eb9-47eb-ba20-6bdbeeea15e1@acm.org>
Date: Tue, 4 Aug 2026 10:53:35 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] scsi: core: Drop Scsi_Host.default_lock
To: John Garry <john.g.garry@oracle.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, hch@lst.de, John Garry <john.garry@linux.dev>
References: <20260804113436.2373404-1-john.g.garry@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260804113436.2373404-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/4/26 4:34 AM, John Garry wrote:
> Getting the address of embedded host_lock structure just requires adding
> a fixed offset value to the shost pointer. However, getting the value of
> the host_lock pointer requires loading from a fixed offset to the shost
> pointer. The latter should be very slightly slower, which is relevant as
> this lock is used a lot throughout the core code and drivers.

I like the idea behind this patch. However, I think this patch is
incomplete. The changes shown below are needed to make all SCSI drivers
build again with the script available at
https://github.com/bvanassche/build-scsi-drivers:

diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index 4f23d585d062..b1ed0cb30a72 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -270,7 +270,7 @@ static bool zfcp_sysfs_port_in_use(struct zfcp_port 
*const port)
  	if (atomic_read(&port->units) > 0)
  		goto unlock_port_units_mutex; /* zfcp_unit(s) under port */

-	spin_lock_irqsave(adapter->scsi_host->host_lock, flags);
+	spin_lock_irqsave(&adapter->scsi_host->host_lock, flags);
  	__shost_for_each_device(sdev, adapter->scsi_host) {
  		const struct zfcp_scsi_dev *zsdev = sdev_to_zfcp(sdev);

@@ -288,7 +288,7 @@ static bool zfcp_sysfs_port_in_use(struct zfcp_port 
*const port)
  	in_use = false;

  unlock_host_lock:
-	spin_unlock_irqrestore(adapter->scsi_host->host_lock, flags);
+	spin_unlock_irqrestore(&adapter->scsi_host->host_lock, flags);
  unlock_port_units_mutex:
  	mutex_unlock(&zfcp_sysfs_port_units_mutex);
  	return in_use;
diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index f81e53b53e20..223065529654 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -39,9 +39,9 @@ static irqreturn_t a2091_intr(int irq, void *data)
  	if (!(status & (ISTR_INT_F | ISTR_INT_P)) || !(status & ISTR_INTS))
  		return IRQ_NONE;

-	spin_lock_irqsave(instance->host_lock, flags);
+	spin_lock_irqsave(&instance->host_lock, flags);
  	wd33c93_intr(instance);
-	spin_unlock_irqrestore(instance->host_lock, flags);
+	spin_unlock_irqrestore(&instance->host_lock, flags);
  	return IRQ_HANDLED;
  }

diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index bf054dd7682b..dd0924572c0e 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -41,9 +41,9 @@ static irqreturn_t a3000_intr(int irq, void *data)
  	if (!(status & ISTR_INT_P))
  		return IRQ_NONE;
  	if (status & ISTR_INTS) {
-		spin_lock_irqsave(instance->host_lock, flags);
+		spin_lock_irqsave(&instance->host_lock, flags);
  		wd33c93_intr(instance);
-		spin_unlock_irqrestore(instance->host_lock, flags);
+		spin_unlock_irqrestore(&instance->host_lock, flags);
  		return IRQ_HANDLED;
  	}
  	pr_warn("Non-serviced A3000 SCSI-interrupt? ISTR = %02x\n", status);
diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 79bd64e12adc..a29457f5adfb 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -42,9 +42,9 @@ static irqreturn_t gvp11_intr(int irq, void *data)
  	if (!(status & GVP11_DMAC_INT_PENDING))
  		return IRQ_NONE;

-	spin_lock_irqsave(instance->host_lock, flags);
+	spin_lock_irqsave(&instance->host_lock, flags);
  	wd33c93_intr(instance);
-	spin_unlock_irqrestore(instance->host_lock, flags);
+	spin_unlock_irqrestore(&instance->host_lock, flags);
  	return IRQ_HANDLED;
  }

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c 
b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 4ea5d93ab1a8..594108269dec 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -1642,9 +1642,9 @@ static void ibmvfc_locked_done(struct ibmvfc_event 
*evt)
  {
  	unsigned long flags;

-	spin_lock_irqsave(evt->vhost->host->host_lock, flags);
+	spin_lock_irqsave(&evt->vhost->host->host_lock, flags);
  	evt->_done(evt);
-	spin_unlock_irqrestore(evt->vhost->host->host_lock, flags);
+	spin_unlock_irqrestore(&evt->vhost->host->host_lock, flags);
  }

  /**
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c 
b/drivers/scsi/ibmvscsi/ibmvscsi.c
index eeaba31b18c3..4ecd3db08875 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -785,13 +785,13 @@ static void purge_requests(struct 
ibmvscsi_host_data *hostdata, int error_code)
  	struct srp_event_struct *evt;
  	unsigned long flags;

-	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	spin_lock_irqsave(&hostdata->host->host_lock, flags);
  	while (!list_empty(&hostdata->sent)) {
  		evt = list_first_entry(&hostdata->sent, struct srp_event_struct, list);
  		list_del(&evt->list);
  		timer_delete(&evt->timer);

-		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+		spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
  		if (evt->cmnd) {
  			evt->cmnd->result = (error_code << 16);
  			unmap_cmd_data(&evt->iu.srp.cmd, evt,
@@ -802,9 +802,9 @@ static void purge_requests(struct ibmvscsi_host_data 
*hostdata, int error_code)
  			   evt->iu.srp.login_req.opcode != SRP_LOGIN_REQ)
  			evt->done(evt);
  		free_event_struct(&evt->hostdata->pool, evt);
-		spin_lock_irqsave(hostdata->host->host_lock, flags);
+		spin_lock_irqsave(&hostdata->host->host_lock, flags);
  	}
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
  }

  /**
@@ -818,9 +818,9 @@ static void ibmvscsi_set_request_limit(struct 
ibmvscsi_host_data *hostdata, int
  {
  	unsigned long flags;

-	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	spin_lock_irqsave(&hostdata->host->host_lock, flags);
  	atomic_set(&hostdata->request_limit, limit);
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
  }

  /**
@@ -1221,9 +1221,9 @@ static int send_srp_login(struct 
ibmvscsi_host_data *hostdata)
  	 */
  	ibmvscsi_set_request_limit(hostdata, 0);

-	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	spin_lock_irqsave(&hostdata->host->host_lock, flags);
  	rc = ibmvscsi_send_srp_event(evt_struct, hostdata, login_timeout * 2);
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
  	dev_info(hostdata->dev, "sent SRP login\n");
  	return rc;
  };
@@ -1317,10 +1317,10 @@ static void send_mad_capabilities(struct 
ibmvscsi_host_data *hostdata)
  		req->common.length = cpu_to_be16(sizeof(hostdata->caps) -
  						sizeof(hostdata->caps.reserve));

-	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	spin_lock_irqsave(&hostdata->host->host_lock, flags);
  	if (ibmvscsi_send_srp_event(evt_struct, hostdata, info_timeout * 2))
  		dev_err(hostdata->dev, "couldn't send CAPABILITIES_REQ!\n");
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
  };

  /**
@@ -1373,9 +1373,9 @@ static int enable_fast_fail(struct 
ibmvscsi_host_data *hostdata)
  	fast_fail_mad->common.type = cpu_to_be32(VIOSRP_ENABLE_FAST_FAIL);
  	fast_fail_mad->common.length = cpu_to_be16(sizeof(*fast_fail_mad));

-	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	spin_lock_irqsave(&hostdata->host->host_lock, flags);
  	rc = ibmvscsi_send_srp_event(evt_struct, hostdata, info_timeout * 2);
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
  	return rc;
  }

@@ -1454,10 +1454,10 @@ static void send_mad_adapter_info(struct 
ibmvscsi_host_data *hostdata)
  	req->common.length = cpu_to_be16(sizeof(hostdata->madapter_info));
  	req->buffer = cpu_to_be64(hostdata->adapter_info_addr);

-	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	spin_lock_irqsave(&hostdata->host->host_lock, flags);
  	if (ibmvscsi_send_srp_event(evt_struct, hostdata, info_timeout * 2))
  		dev_err(hostdata->dev, "couldn't send ADAPTER_INFO_REQ!\n");
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
  };

  /*
@@ -1502,7 +1502,7 @@ static int ibmvscsi_eh_abort_handler(struct 
scsi_cmnd *cmd)
  	/* First, find this command in our sent list so we can figure
  	 * out the correct tag
  	 */
-	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	spin_lock_irqsave(&hostdata->host->host_lock, flags);
  	wait_switch = jiffies + (init_timeout * HZ);
  	do {
  		found_evt = NULL;
@@ -1514,13 +1514,13 @@ static int ibmvscsi_eh_abort_handler(struct 
scsi_cmnd *cmd)
  		}

  		if (!found_evt) {
-			spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+			spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
  			return SUCCESS;
  		}

  		evt = get_event_struct(&hostdata->pool);
  		if (evt == NULL) {
-			spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+			spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
  			sdev_printk(KERN_ERR, cmd->device,
  				"failed to allocate abort event\n");
  			return FAILED;
@@ -1548,12 +1548,12 @@ static int ibmvscsi_eh_abort_handler(struct 
scsi_cmnd *cmd)
  		if (rsp_rc != SCSI_MLQUEUE_HOST_BUSY)
  			break;

-		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+		spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
  		msleep(10);
-		spin_lock_irqsave(hostdata->host->host_lock, flags);
+		spin_lock_irqsave(&hostdata->host->host_lock, flags);
  	} while (time_before(jiffies, wait_switch));

-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->host->host_lock, flags);

  	if (rsp_rc != 0) {
  		sdev_printk(KERN_ERR, cmd->device,
@@ -1592,7 +1592,7 @@ static int ibmvscsi_eh_abort_handler(struct 
scsi_cmnd *cmd)
  	 * The event is no longer in our list.  Make sure it didn't
  	 * complete while we were aborting
  	 */
-	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	spin_lock_irqsave(&hostdata->host->host_lock, flags);
  	found_evt = NULL;
  	list_for_each_entry(tmp_evt, &hostdata->sent, list) {
  		if (tmp_evt->cmnd == cmd) {
@@ -1602,7 +1602,7 @@ static int ibmvscsi_eh_abort_handler(struct 
scsi_cmnd *cmd)
  	}

  	if (found_evt == NULL) {
-		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+		spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
  		sdev_printk(KERN_INFO, cmd->device, "aborted task tag 0x%llx 
completed\n",
  			    tsk_mgmt->task_tag);
  		return SUCCESS;
@@ -1616,7 +1616,7 @@ static int ibmvscsi_eh_abort_handler(struct 
scsi_cmnd *cmd)
  	unmap_cmd_data(&found_evt->iu.srp.cmd, found_evt,
  		       found_evt->hostdata->dev);
  	free_event_struct(&found_evt->hostdata->pool, found_evt);
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
  	atomic_inc(&hostdata->request_limit);
  	return SUCCESS;
  }
@@ -1638,12 +1638,12 @@ static int 
ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
  	u16 lun = lun_from_dev(cmd->device);
  	unsigned long wait_switch = 0;

-	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	spin_lock_irqsave(&hostdata->host->host_lock, flags);
  	wait_switch = jiffies + (init_timeout * HZ);
  	do {
  		evt = get_event_struct(&hostdata->pool);
  		if (evt == NULL) {
-			spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+			spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
  			sdev_printk(KERN_ERR, cmd->device,
  				"failed to allocate reset event\n");
  			return FAILED;
@@ -1670,12 +1670,12 @@ static int 
ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
  		if (rsp_rc != SCSI_MLQUEUE_HOST_BUSY)
  			break;

-		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+		spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
  		msleep(10);
-		spin_lock_irqsave(hostdata->host->host_lock, flags);
+		spin_lock_irqsave(&hostdata->host->host_lock, flags);
  	} while (time_before(jiffies, wait_switch));

-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->host->host_lock, flags);

  	if (rsp_rc != 0) {
  		sdev_printk(KERN_ERR, cmd->device,
@@ -1712,7 +1712,7 @@ static int ibmvscsi_eh_device_reset_handler(struct 
scsi_cmnd *cmd)
  	/* We need to find all commands for this LUN that have not yet been
  	 * responded to, and fail them with DID_RESET
  	 */
-	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	spin_lock_irqsave(&hostdata->host->host_lock, flags);
  	list_for_each_entry_safe(tmp_evt, pos, &hostdata->sent, list) {
  		if ((tmp_evt->cmnd) && (tmp_evt->cmnd->device == cmd->device)) {
  			if (tmp_evt->cmnd)
@@ -1729,7 +1729,7 @@ static int ibmvscsi_eh_device_reset_handler(struct 
scsi_cmnd *cmd)
  				tmp_evt->done(tmp_evt);
  		}
  	}
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
  	return SUCCESS;
  }

@@ -1855,10 +1855,10 @@ static void ibmvscsi_handle_crq(struct 
viosrp_crq *crq,
  	 * Lock the host_lock before messing with these structures, since we
  	 * are running in a task context
  	 */
-	spin_lock_irqsave(evt_struct->hostdata->host->host_lock, flags);
+	spin_lock_irqsave(&evt_struct->hostdata->host->host_lock, flags);
  	list_del(&evt_struct->list);
  	free_event_struct(&evt_struct->hostdata->pool, evt_struct);
-	spin_unlock_irqrestore(evt_struct->hostdata->host->host_lock, flags);
+	spin_unlock_irqrestore(&evt_struct->hostdata->host->host_lock, flags);
  }

  /**
@@ -2131,35 +2131,35 @@ static void ibmvscsi_do_work(struct 
ibmvscsi_host_data *hostdata)
  	int rc;
  	char *action = "reset";

-	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	spin_lock_irqsave(&hostdata->host->host_lock, flags);
  	switch (hostdata->action) {
  	case IBMVSCSI_HOST_ACTION_UNBLOCK:
  		rc = 0;
  		break;
  	case IBMVSCSI_HOST_ACTION_RESET:
-		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+		spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
  		rc = ibmvscsi_reset_crq_queue(&hostdata->queue, hostdata);
-		spin_lock_irqsave(hostdata->host->host_lock, flags);
+		spin_lock_irqsave(&hostdata->host->host_lock, flags);
  		if (!rc)
  			rc = ibmvscsi_send_crq(hostdata, 0xC001000000000000LL, 0);
  		vio_enable_interrupts(to_vio_dev(hostdata->dev));
  		break;
  	case IBMVSCSI_HOST_ACTION_REENABLE:
  		action = "enable";
-		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+		spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
  		rc = ibmvscsi_reenable_crq_queue(&hostdata->queue, hostdata);
-		spin_lock_irqsave(hostdata->host->host_lock, flags);
+		spin_lock_irqsave(&hostdata->host->host_lock, flags);
  		if (!rc)
  			rc = ibmvscsi_send_crq(hostdata, 0xC001000000000000LL, 0);
  		break;
  	case IBMVSCSI_HOST_ACTION_NONE:
  	default:
-		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+		spin_unlock_irqrestore(&hostdata->host->host_lock, flags);
  		return;
  	}

  	hostdata->action = IBMVSCSI_HOST_ACTION_NONE;
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->host->host_lock, flags);

  	if (rc) {
  		ibmvscsi_set_request_limit(hostdata, -1);
@@ -2191,9 +2191,9 @@ static int ibmvscsi_work_to_do(struct 
ibmvscsi_host_data *hostdata)
  	unsigned long flags;
  	int rc;

-	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	spin_lock_irqsave(&hostdata->host->host_lock, flags);
  	rc = __ibmvscsi_work_to_do(hostdata);
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->host->host_lock, flags);

  	return rc;
  }
diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index 80779aa000d5..8655e3e3d0ac 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -1708,7 +1708,7 @@ static int mesh_host_reset(struct scsi_cmnd *cmd)

  	printk(KERN_DEBUG "mesh_host_reset\n");

-	spin_lock_irqsave(ms->host->host_lock, flags);
+	spin_lock_irqsave(&ms->host->host_lock, flags);

  	if (ms->dma_started)
  		halt_dma(ms);
@@ -1734,7 +1734,7 @@ static int mesh_host_reset(struct scsi_cmnd *cmd)
  	/* Complete pending commands */
  	handle_reset(ms);
  	
-	spin_unlock_irqrestore(ms->host->host_lock, flags);
+	spin_unlock_irqrestore(&ms->host->host_lock, flags);
  	return SUCCESS;
  }

@@ -1818,7 +1818,7 @@ static int mesh_shutdown(struct macio_dev *mdev)
  	unsigned long flags;

         	printk(KERN_INFO "resetting MESH scsi bus(es)\n");
-	spin_lock_irqsave(ms->host->host_lock, flags);
+	spin_lock_irqsave(&ms->host->host_lock, flags);
         	mr = ms->mesh;
  	out_8(&mr->intr_mask, 0);
  	out_8(&mr->interrupt, INT_ERROR | INT_EXCEPTION | INT_CMDDONE);
@@ -1826,7 +1826,7 @@ static int mesh_shutdown(struct macio_dev *mdev)
  	mesh_flush_io(mr);
  	udelay(30);
  	out_8(&mr->bus_status1, 0);
-	spin_unlock_irqrestore(ms->host->host_lock, flags);
+	spin_unlock_irqrestore(&ms->host->host_lock, flags);

  	return 0;
  }
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 84cd369a5bcf..098916061835 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1207,7 +1207,7 @@ static irqreturn_t qpti_intr(int irq, void *dev_id)
  	unsigned long flags;
  	struct scsi_cmnd *dq;

-	spin_lock_irqsave(qpti->qhost->host_lock, flags);
+	spin_lock_irqsave(&qpti->qhost->host_lock, flags);
  	dq = qlogicpti_intr_handler(qpti);

  	if (dq != NULL) {
@@ -1219,7 +1219,7 @@ static irqreturn_t qpti_intr(int irq, void *dev_id)
  			dq = next;
  		} while (dq != NULL);
  	}
-	spin_unlock_irqrestore(qpti->qhost->host_lock, flags);
+	spin_unlock_irqrestore(&qpti->qhost->host_lock, flags);

  	return IRQ_HANDLED;
  }

