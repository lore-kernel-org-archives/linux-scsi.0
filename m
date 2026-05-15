Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F3E30C150
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2026 19:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778874549; cv=none; b=UK77aPyq3vHUD9/xNofpibO8hcD+Fdk0IeHt9ja7YT3wIes6fcXV7jku/cFWsO250rsQ/CXwIGD5JVLaNBedvufWYh3wRD1MQYD1gpPEerqB40BwrAczQRW0TjGd+VKnnKnlRy53a/IcxIdfTb5m78ZQ2/s7nCwjxS3CiiDiPbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778874549; c=relaxed/simple;
	bh=JRbvaVYpYQuzLHyq4WVQ2SzUW48LP4W18T8QXHvKrFM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Y4G/xb9rP7vE0AH1VLUvBuOY5k7V/03VCkPpUX3Sf8awkf0iW+sMVK1NiVf/MSCovUi91FZRDYXA24Jt3K9L+SiKc8ehinI9nnnfy29hwfaRxb9c/VXICpCiaFSGN/THJstfeViEJDUHDRCecCvbewHKHFVcCv3K+uGELh7Wfik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pST0/P27; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pST0/P27"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gHHnt6NvSzlgyGm;
	Fri, 15 May 2026 19:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1778874543; x=1781466544; bh=Wb9R9bJ8tsGxrw/5zz0z8nML
	WnzfXG6Q5AEcJKenagU=; b=pST0/P27q5s/OrDC6Wrz11URiAjnItofqj0GtDRB
	KZKwF2gDXNzUDjlmuPUH6vauQrrnT3mGNROjmlm9PF7ZvsWmyjb+dKS67RT4ixu7
	kFAWxd9m4+mmVFAXxecO/PGvXtwNLpljyHjO+nQvr9uiAl97kCkx9NMwwhvyEdIx
	pwEu4NeW4ukrusS5sG/umUXnoZtXFtAAedoJtjAodK8kQVVKCj4KRiF6dEZsu5ga
	gCpJb539Vwv4k2MCDIkLK6g7l51xda8DonTfKhMujZ1dH4e/TR5+mddtCZgzAQrb
	6MozW51Dg0Ef9kHTqfttASrIuqGnF0O4cVudMi8uxMRsBg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8rgZuG9w9RJO; Fri, 15 May 2026 19:49:03 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gHHnn30yxzlfftf;
	Fri, 15 May 2026 19:49:01 +0000 (UTC)
Message-ID: <b020a37b-ded6-4fd7-af4a-f4553a72717b@acm.org>
Date: Fri, 15 May 2026 12:49:00 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: wake eh reliably when using scsi_schedule_eh
To: David Jeffery <djeffery@redhat.com>, linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20260515181112.9758-1-djeffery@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260515181112.9758-1-djeffery@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/15/26 11:11 AM, David Jeffery wrote:
> Drivers which use the scsi_schedule_eh function to run the error handler
> currently risk the error handler thread never waking once all commands are
> timed out or inactive. There is no enforced memory order between setting
> the host into error recovery state and counting busy commands. This can
> result in a race with scsi_dec_host_busy where neither CPU sees both
> conditions of all commands inactive and the host error state to request
> waking the error handler.
> 
> To fix this, run the scsi_schedule_eh's scsi_eh_wakeup from a new work item
> which will use rcu to ensure scsi_schedule_eh's call to scsi_host_busy will
> occur after the error state is globally visible and will be seen by any
> current scsi_dec_host_busy callers.
The comment above scsi_dec_host_busy() is not correct. I don't think 
that call_rcu() guarantees what the comment above that function claims 
that it guarantees. Maybe something like the patch below needs to be 
folded in into this patch (entirely untested)?

Thanks,

Bart.

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index e047747d4ecf..d991b0fa0421 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -354,9 +354,6 @@ static void scsi_host_dev_release(struct device *dev)
  	struct Scsi_Host *shost = dev_to_shost(dev);
  	struct device *parent = dev->parent;

-	/* Wait for functions invoked through call_rcu(&scmd->rcu, ...) */
-	rcu_barrier();
-
  	if (shost->tmf_work_q)
  		destroy_workqueue(shost->tmf_work_q);
  	if (shost->ehandler)
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 147127fb4db9..c021932504a6 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -278,28 +278,6 @@ static void scsi_eh_reset(struct scsi_cmnd *scmd)
  	}
  }

-static void scsi_eh_inc_host_failed(struct rcu_head *head)
-{
-	struct scsi_cmnd *scmd = container_of(head, typeof(*scmd), rcu);
-	struct Scsi_Host *shost = scmd->device->host;
-	unsigned int busy;
-	unsigned long flags;
-
-	spin_lock_irqsave(shost->host_lock, flags);
-	shost->host_failed++;
-	spin_unlock_irqrestore(shost->host_lock, flags);
-	/*
-	 * The counting of busy requests needs to occur after adding to
-	 * host_failed or after the lock acquire for adding to host_failed
-	 * to prevent a race with host unbusy and missing an eh wakeup.
-	 */
-	busy = scsi_host_busy(shost);
-
-	spin_lock_irqsave(shost->host_lock, flags);
-	scsi_eh_wakeup(shost, busy);
-	spin_unlock_irqrestore(shost->host_lock, flags);
-}
-
  /**
   * scsi_eh_scmd_add - add scsi cmd to error handling.
   * @scmd:	scmd to run eh on.
@@ -308,6 +286,7 @@ void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
  {
  	struct Scsi_Host *shost = scmd->device->host;
  	unsigned long flags;
+	unsigned int busy;
  	int ret;

  	WARN_ON_ONCE(!shost->ehandler);
@@ -324,11 +303,27 @@ void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
  	scsi_eh_reset(scmd);
  	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
  	spin_unlock_irqrestore(shost->host_lock, flags);
+
  	/*
  	 * Ensure that all tasks observe the host state change before the
-	 * host_failed change.
+	 * host_failed change. scsi_dec_host_busy() depends on this order.
  	 */
-	call_rcu_hurry(&scmd->rcu, scsi_eh_inc_host_failed);
+	smp_mb();
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	shost->host_failed++;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	/*
+	 * The counting of busy requests needs to occur after adding to
+	 * host_failed or after the lock acquire for adding to host_failed
+	 * to prevent a race with scsi_dec_host_busy() and missing an eh wakeup.
+	 */
+	busy = scsi_host_busy(shost);
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	scsi_eh_wakeup(shost, busy);
+	spin_unlock_irqrestore(shost->host_lock, flags);
  }

  /**
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6e8c7a42603e..7a636d771c13 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -362,20 +362,11 @@ int scsi_execute_cmd(struct scsi_device *sdev, 
const unsigned char *cmd,
  }
  EXPORT_SYMBOL(scsi_execute_cmd);

-/*
- * Wake up the error handler if necessary. Avoid as follows that the error
- * handler is not woken up if host in-flight requests number ==
- * shost->host_failed: use call_rcu() in scsi_eh_scmd_add() in combination
- * with an RCU read lock in this function to ensure that this function in
- * its entirety either finishes before scsi_eh_scmd_add() increases the
- * host_failed counter or that it notices the shost state change made by
- * scsi_eh_scmd_add().
- */
+/* Wake up the error handler if necessary. */
  static void scsi_dec_host_busy(struct Scsi_Host *shost, struct 
scsi_cmnd *cmd)
  {
  	unsigned long flags;

-	rcu_read_lock();
  	__clear_bit(SCMD_STATE_INFLIGHT, &cmd->state);
  	if (unlikely(scsi_host_in_recovery(shost))) {
  		/*
@@ -393,7 +384,6 @@ static void scsi_dec_host_busy(struct Scsi_Host 
*shost, struct scsi_cmnd *cmd)
  			scsi_eh_wakeup(shost, busy);
  		spin_unlock_irqrestore(shost->host_lock, flags);
  	}
-	rcu_read_unlock();
  }

  void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)

