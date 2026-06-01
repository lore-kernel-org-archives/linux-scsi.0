Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CE82D781B;
	Mon,  1 Jun 2026 17:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780335735; cv=none; b=UH9/wzewlZq0ELUnjR9UWH1UlGam1vnJSGqtISGhNHLof9/HkNvJx8lamxoppot+VAX0Np+bjwGEgG/MKjQ5953Y35OfRoa3Em3HYM7Hnb6xN9hsOFoKbzqcv7Diacl7Jtf7eOu7p0ElczJrFA2bSqSxsZ5s2Gq46ISrZAVeroA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780335735; c=relaxed/simple;
	bh=kkHomwwt7E+LrKrtnM4au8eKbmAw1IRzBXy4X6KKoOc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D8OTUxwTnGh3OA8WGf+xynkGVlt30YNQSrskYQ6syxQ2BlFi6I1IEkfeoD0rhdDH3cKqhpxe0BpQGwgTQ10EixHIVpJhBGARcOP/vo56HSH1J5O8XbIwd7WxfzlFtBkhES50kvEa5eLZUEGAY+aPpWJykZJHMFekRokQ3QY8ZcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=fjQICXbp; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="fjQICXbp"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gTh9d0XSXzlgyH3;
	Mon,  1 Jun 2026 17:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1780335726; x=1782927727; bh=KZkdQUUmyhapn6hW7TWcKceE
	5HSLHEwqOdQWCc01zyM=; b=fjQICXbp7WSjIfXXvoFA9/6kGDX/0IW98a/PVbQv
	Tn4j4OrL2cgV/9ciw+GxEyH4qQmKdUEm6ndn07tqlFskk0sh5tx8jHWoV86VwQu4
	oCMS4bUfetF0PA3ZALkTChEveVtiY5g8FN4UxLBTyTHLQeimPPHdNq2TFqtAA+eM
	4I8xJ7IiiN7NNtO1N9fqLpzUO3gfaDZGUAyCWRc8rVm1VzeHSe9o0UUtoVIIavZb
	MVkIWxf1UYoi23J26RuVZkZ4QGGUJ3zSMeIai8eKjuZqTPAkLcnD8nyQTFh/h2QB
	pLGninLtUXrQv0/BKU9xi0TFl/g7h89YX6Gou0a+o0JXRg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id XXJRpbiWXXfP; Mon,  1 Jun 2026 17:42:06 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gTh9S0QKkzlfvq8;
	Mon,  1 Jun 2026 17:42:03 +0000 (UTC)
Message-ID: <27613670-be13-4923-ae6a-f9a32f1a053b@acm.org>
Date: Mon, 1 Jun 2026 10:42:02 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: ufs: core: handle PM SSU timeout before SCSI EH
To: Hongjie Fang <hongjiefang@asrmicro.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, peter.wang@mediatek.com, beanhuo@micron.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260601045658.1232848-1-hongjiefang@asrmicro.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260601045658.1232848-1-hongjiefang@asrmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/31/26 9:56 PM, Hongjie Fang wrote:
> @@ -9466,7 +9499,7 @@ static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
>   {
>   	struct ufs_hba *hba = shost_priv(scmd->device->host);
>   
> -	if (!hba->system_suspending) {
> +	if (!hba->pm_op_in_progress || !ufshcd_is_scsi_cmd(scmd)) {
>   		/* Activate the error handler in the SCSI core. */
>   		return SCSI_EH_NOT_HANDLED;
>   	}

I think we want to avoid SCSI error handler activation for all commands
that time out while a power management operation is in progress,
including device management commands.

Please consider completing commands from inside the timeout handler
instead of adding force_compl support for the legacy single doorbell
mode. The very lightly tested patch below should realize this.

Thanks,

Bart.


diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9e0336098e26..63788b187eea 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9491,22 +9491,23 @@ static enum scsi_timeout_action 
ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
  {
  	struct ufs_hba *hba = shost_priv(scmd->device->host);

-	if (!hba->system_suspending) {
+	if (!hba->pm_op_in_progress) {
  		/* Activate the error handler in the SCSI core. */
  		return SCSI_EH_NOT_HANDLED;
  	}

  	/*
-	 * If we get here we know that no TMFs are outstanding and also that
-	 * the only pending command is a START STOP UNIT command. Handle the
-	 * timeout of that command directly to prevent a deadlock between
+	 * Handle the timeout directly to prevent a deadlock between
  	 * ufshcd_set_dev_pwr_mode() and ufshcd_err_handler().
  	 */
  	ufshcd_link_recovery(hba);
  	dev_info(hba->dev, "%s() finished; outstanding_tasks = %#lx.\n",
  		 __func__, hba->outstanding_tasks);

-	return scsi_host_busy(hba->host) ? SCSI_EH_RESET_TIMER : SCSI_EH_DONE;
+	set_host_byte(scmd, DID_TIME_OUT);
+	ufshcd_release_scsi_cmd(hba, scmd);
+	scsi_done(scmd);
+	return SCSI_EH_DONE;
  }

  static const struct attribute_group *ufshcd_driver_groups[] = {
@@ -10543,7 +10544,6 @@ static int ufshcd_wl_suspend(struct device *dev)

  	hba = shost_priv(sdev->host);
  	down(&hba->host_sem);
-	hba->system_suspending = true;

  	if (pm_runtime_suspended(dev))
  		goto out;
@@ -10585,7 +10585,6 @@ static int ufshcd_wl_resume(struct device *dev)
  		hba->curr_dev_pwr_mode, hba->uic_link_state);
  	if (!ret)
  		hba->is_sys_suspended = false;
-	hba->system_suspending = false;
  	up(&hba->host_sem);
  	return ret;
  }
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 3eaae082329c..248d0a5bef40 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1029,8 +1029,6 @@ enum ufshcd_mcq_opr {
   * @caps: bitmask with information about UFS controller capabilities
   * @devfreq: frequency scaling information owned by the devfreq core
   * @clk_scaling: frequency scaling information owned by the UFS driver
- * @system_suspending: system suspend has been started and system 
resume has
- *	not yet finished.
   * @is_sys_suspended: UFS device has been suspended because of system 
suspend
   * @urgent_bkops_lvl: keeps track of urgent bkops level for device
   * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level for
@@ -1206,7 +1204,6 @@ struct ufs_hba {

  	struct devfreq *devfreq;
  	struct ufs_clk_scaling clk_scaling;
-	bool system_suspending;
  	bool is_sys_suspended;

  	enum bkops_status urgent_bkops_lvl;

