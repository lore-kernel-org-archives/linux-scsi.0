Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC5E18B0F;
	Tue, 26 May 2026 20:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779828455; cv=none; b=hrfiP6Ab64RjiYGpiFs5haFD/3Cbn9D/ESslfiAVV0ANpanljvrRGZ5n4yfyMXTrvekzhDnPG9neNsWoh8Bzi5HmRPbUWlwmqN6AYuW9FCCK1oNQww4tmOfTKqffNtCM0MMUbs77QAtI4DF5kq3FZVs7YkpBtpzNqAC2IFAksCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779828455; c=relaxed/simple;
	bh=V3nVQZ2t5GVtNzAvMuQe1FHXdHfWOr7ofHnHwrgYSXI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EpdqV59F10ZqzaaF/7I+bcap1KZFo9FSJ3w4REakbzKVmaeUOH0C0oYIhhKb4kVpfZHEP9ub8D/q7DKPbcDjozVM0bR5XS2kiCGjORLPxg7vQvqMSBJ8UGWIWfhamAyCUk2WoYXKcoflPTkIOnLj9M081guJW5lYyyx/oVfWDdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=J3jzr4NP; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="J3jzr4NP"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gQ4ZF4gq5zlgwNJ;
	Tue, 26 May 2026 20:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1779828446; x=1782420447; bh=vc1oZv5+zxvQpc0hN8JP6p8L
	HtRtfmhvCfzwxF17UkA=; b=J3jzr4NPdec7hYayHjtCqKh418tok6npyzIW3MFe
	Gam3B3nC9KDRmaKJ1n+N+RbEJJb7lXhqS+XIV2tE0Lxss9ipK4jTF3PG98KjJr2S
	B/w76g7/YEjOHlHu8tYX5oFHuUUerST/HCfbNyC2MfJszNxE/dtiPA/TVZyDcd6r
	ytrAXPTB9aPKF7VCf8+3WqwGSXXxme2cL1O9dVYf12cUHWF2rjQz2lqmdX6nT86G
	5BCo6JRxG+//PV5xG+pDz4z+l8+KodvWLzc6t3Mmy62h0vPr7TQ5ymeE1HpcLEE4
	V2bZH5VsWILlf66Hx9DViq5yx2U4wher4I1hCKDC5xXcxg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VJc3zhq7buPj; Tue, 26 May 2026 20:47:26 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gQ4Z448Fxzlgy4t;
	Tue, 26 May 2026 20:47:23 +0000 (UTC)
Message-ID: <606c4c21-bcf2-4ed5-9434-e7c70f541d7a@acm.org>
Date: Tue, 26 May 2026 13:47:23 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: complete wl runtime resume after SCSI EH
To: Hongjie Fang <hongjiefang@asrmicro.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, peter.wang@mediatek.com, beanhuo@micron.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260526114941.667477-1-hongjiefang@asrmicro.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260526114941.667477-1-hongjiefang@asrmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/26/26 4:49 AM, Hongjie Fang wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index c3f08957d179..e7517cf23f06 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -10368,6 +10368,22 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   }
>   
>   #ifdef CONFIG_PM
> +static int ufshcd_wl_resume_pm_recovered(struct ufs_hba *hba)
> +{
> +	int ret = 0;
> +	struct scsi_device *sdp = hba->ufs_device_wlun;
> +
> +	if (!sdp || !scsi_block_when_processing_errors(sdp))
> +		return 0;
> +
> +	if (hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL &&
> +	    ufshcd_is_link_active(hba) &&
> +	    ufshcd_is_ufs_dev_active(hba))
> +		ret = 1;
> +
> +	return ret;
> +}
> +
>   static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   {
>   	int ret;
> @@ -10422,6 +10438,9 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   
>   	if (!ufshcd_is_ufs_dev_active(hba)) {
>   		ret = ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE);
> +		if (pm_op == UFS_RUNTIME_PM && ret == -EIO &&
> +		    ufshcd_wl_resume_pm_recovered(hba))
> +			ret = 0;
>   		if (ret)
>   			goto set_old_link_state;
>   		ufshcd_set_timestamp_attr(hba);

This change increases the complexity of the UFS driver too much. Please 
consider building a solution for this issue on top of the (untested)
patch below. The patch below prevents that the SCSI EH is activated if a
START STOP UNIT command times out:

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9e0336098e26..4be5453efb34 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9491,7 +9491,7 @@ static enum scsi_timeout_action 
ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
  {
  	struct ufs_hba *hba = shost_priv(scmd->device->host);

-	if (!hba->system_suspending) {
+	if (!hba->pm_op_in_progress) {
  		/* Activate the error handler in the SCSI core. */
  		return SCSI_EH_NOT_HANDLED;
  	}
@@ -10543,7 +10543,6 @@ static int ufshcd_wl_suspend(struct device *dev)

  	hba = shost_priv(sdev->host);
  	down(&hba->host_sem);
-	hba->system_suspending = true;

  	if (pm_runtime_suspended(dev))
  		goto out;
@@ -10585,7 +10584,6 @@ static int ufshcd_wl_resume(struct device *dev)
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

Thanks,

Bart.
