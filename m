Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963323BBA0D;
	Fri, 29 May 2026 21:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780091157; cv=none; b=J36RwMcP/wNYd9c7+UpGI7yhzkDiefL1eCu0j/Ng2WCzdbP/Rc1affrG5Wdbdbkq7ED4V/CEE6lKtkZcZp0d96LKy1iEms0nbUMdgkUPdAiDFivO32TNajzbBg221MFdopvPWeaZvso7QBWieO2rNytBTASYgswqdTHolU/9/lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780091157; c=relaxed/simple;
	bh=b+ylvnV2AZksWGxs6BZxrvQWaho9cjp9FsDTvLFrm04=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Oi9NhBySxQm63DA/KlzBYX9IPkQJEZrsNn7PSP53DcsqP2CFhwMDhkxme4OB6AyFpCaD9Qc2xCnfdbo7ZC3geeMe4WYACzZJjULoZ1pyvDXCvxN+RSXdb3d0cR3NFI86IcUrI3o30LpyfwMNShnV5DyKpG+EWJ3A2820kfO3Eh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lsRqM3Zm; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lsRqM3Zm"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gRxk96znhzlfdfN;
	Fri, 29 May 2026 21:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1780091148; x=1782683149; bh=i2cpIihipygdlTd6JqWt54eo
	uOk1vGAfwOcx5gZOB0U=; b=lsRqM3ZmiWIpoOqomQjSOaSZ+E40OioittatL23K
	pWXjFM50F4twDQRMbEmG+sXhwlC5Foc0xjsLf5A7qcZKA+XxCFGuy1FFwkSN/u3n
	TiYd4xGLNybDic5EyeVTTTMfNo0muCi5nU2jN7iYMuZHhC+myMYZWPtvXC2auDQD
	yRFWQWDVFeaer5ItBd9KFdCJoCCV6ZAgX3dSOOmRxOXo2jDY5Lu7qz0ehHDPzcIT
	mIbjtWYgT9J/8wu3TRn3bgsYyqgioykgx7P93jWyifMBn08p6ERUJfjySh2qKD2N
	zqyZjc1WJQDgSZ+e084jVPVVqhPKYcxeEQtKXRTBr5XoSQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 62HCN71QWU4c; Fri, 29 May 2026 21:45:48 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gRxk12q39zlfddm;
	Fri, 29 May 2026 21:45:45 +0000 (UTC)
Message-ID: <88ffd4c6-798c-4e0a-ba72-a3b3a027c39d@acm.org>
Date: Fri, 29 May 2026 14:45:44 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: core: handle PM SSU timeout before SCSI EH
To: Hongjie Fang <hongjiefang@asrmicro.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, peter.wang@mediatek.com, beanhuo@micron.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260528113433.367083-1-hongjiefang@asrmicro.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260528113433.367083-1-hongjiefang@asrmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/26 4:34 AM, Hongjie Fang wrote:
> @@ -9465,23 +9498,30 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
>   static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
>   {
>   	struct ufs_hba *hba = shost_priv(scmd->device->host);
> +	int ret;
>   
> -	if (!hba->system_suspending) {
> +	if (!hba->pm_op_in_progress || scmd->device != hba->ufs_device_wlun ||
> +	    scmd->cmnd[0] != START_STOP) {
>   		/* Activate the error handler in the SCSI core. */
>   		return SCSI_EH_NOT_HANDLED;
>   	}

Please don't make the code any more complex than necessary. If a power 
management operation is in progress it is guaranteed that no other SCSI
commands are in progress. See also blk_pre_runtime_suspend() and
blk_try_enter_queue(). Hence, for the above if-condition, testing
hba->pm_op_in_progress is sufficient.

>   	/*
> -	 * If we get here we know that no TMFs are outstanding and also that
> -	 * the only pending command is a START STOP UNIT command. Handle the
> -	 * timeout of that command directly to prevent a deadlock between
> -	 * ufshcd_set_dev_pwr_mode() and ufshcd_err_handler().
> +	 * PM START STOP UNIT commands are issued while a PM operation is in
> +	 * progress. Handle such timeouts directly to avoid entering regular
> +	 * SCSI EH, which may deadlock with the PM operation and may also make
> +	 * scsi_execute_cmd() retries fail while the host is still in recovery.
>   	 */

The original comment is fine, isn't it?

> -	return scsi_host_busy(hba->host) ? SCSI_EH_RESET_TIMER : SCSI_EH_DONE;
> +	if (ret)
> +		return SCSI_EH_NOT_HANDLED;

This is wrong because it may activate the SCSI error handler for a START
STOP UNIT command. We don't want this - we want the error to be
propagated to the scsi_execute_cmd() caller.

> +	WARN_ON_ONCE(!test_bit(SCMD_STATE_COMPLETE, &scmd->state));

This is also wrong. According to Documentation/process/coding-style.rst,
WARN*() should only be used for this-should-never-happen situations. If
the above statement is reached it is almost a certainty that
SCMD_STATE_COMPLETE is not set.

The rest of this patch looks good to me.

Thanks,

Bart.
