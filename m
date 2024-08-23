Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE3A8F6B
	for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2024 20:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724444766; cv=none; b=nYBNeS8AP3EUWcrpYdmPO9pu3ITHmU0bcqUjjwVtUtJE6sJYt4uvEpXFZVjyXzTvU+n69BQhO0/BCYO+jF5cXRqSWOwzmDL2OGd986E9SiWi+0YO/MaFA3uH3w5+e5l8x9l7IbEReGd9C/NemV6TLdr737RDgLOo+7qeMcqpkg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724444766; c=relaxed/simple;
	bh=oJNzc57a94qiN24MX5qSdM5nJB7cIyjY3L+BZ1Erzy4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tpQ5lCxctrNoO/eQa5r/lnQFxBHUr3oac9PMbLUTPls2o2uh5h1K45tRQOXZQkJT4YZmB/jtvPywKsJTpRpa/wpzSty7JuP27H5k/0AscSMoxM+nMVxejH7ID9QAi5NtUlrlnUC3BOl/oPGJh3+0evT0S6+39uepTg3OiZ/z6Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=dKXllRWK; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="dKXllRWK"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WrBRH5KRVzlgVnK;
	Fri, 23 Aug 2024 20:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724444757; x=1727036758; bh=BPYKWtxa76cYbZgktoMNO0r3
	xUIJcl9U0RFCdkEgiFo=; b=dKXllRWKv1tvzKReQhvsYrbH3W6l3frwiisYGxRa
	iL9/rzEs2nbmdRQv49HmJLd9LLktEc0JksETOrBhcACmSg7dNFO8ZU+C2yN89R8C
	6DZEfQFBVn6pl0p+5XKfzr0Wk6WfTfjgGu6SbAQ8qu52A3bupKMSemC8icT+lshH
	9mZmnRh0hLJCQq0QU+hgAJAnjQUxXjNHJxrqh6oPiOFnt8f4DdujMM4RHHvtRy0V
	bqcwAzCV+cLdM+Xl/HOEGWCB3bDn9GovqdJhttLV5Et88tltjchE4ZSbJd9a3O0r
	W/xm92QMBIWdW47Ha1pLrgAfPkios0+OfNIdzh8lRxBSZw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id d_gxZOY2V0UW; Fri, 23 Aug 2024 20:25:57 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WrBR80KdSzlgVnF;
	Fri, 23 Aug 2024 20:25:55 +0000 (UTC)
Message-ID: <e974b034-62e8-4795-aa78-ee142fd14441@acm.org>
Date: Fri, 23 Aug 2024 13:25:55 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Avri Altman <avri.altman@wdc.com>, Andrew Halaney <ahalaney@redhat.com>,
 Bean Huo <beanhuo@micron.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Eric Biggers <ebiggers@google.com>, Minwoo Im <minwoo.im@samsung.com>,
 Maramaina Naresh <quic_mnaresh@quicinc.com>
References: <20240821182923.145631-1-bvanassche@acm.org>
 <20240821182923.145631-3-bvanassche@acm.org>
 <ba9ae5a8-6021-f906-9ce1-d637534ac9cf@quicinc.com>
 <20c1866f-9bb2-406f-a819-74ad936d92d5@acm.org>
 <1bc51b34-0d2f-59ec-f025-bcc68da74718@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1bc51b34-0d2f-59ec-f025-bcc68da74718@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/22/24 8:43 PM, Bao D. Nguyen wrote:
> However, the UIC_COMMAND_COMPL extra interrupt 
> belonging to the previous PMC/hibern8_enter/exit() command can come late 
> and causes the ufshcd_uic_cmd_compl() to complete the current uic 
> command incorrectly.

Hi Bao,

If the UIC command completion interrupt could come late we would
already have observed unhandled interrupt errors in device logs, isn't
it?

Anyway, isn't this something that is easy to fix with something like the
(untested) patch below?

Thanks,

Bart.

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d0ae6e50becc..e3a487ea83f9 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2543,13 +2543,11 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, 
struct uic_command *uic_cmd)
   * __ufshcd_send_uic_cmd - Send UIC commands and retrieve the result
   * @hba: per adapter instance
   * @uic_cmd: UIC command
- * @completion: initialize the completion only if this is set to true
   *
   * Return: 0 only if success.
   */
  static int
-__ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd,
-		      bool completion)
+__ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
  {
  	lockdep_assert_held(&hba->uic_cmd_mutex);

@@ -2559,8 +2557,7 @@ __ufshcd_send_uic_cmd(struct ufs_hba *hba, struct 
uic_command *uic_cmd,
  		return -EIO;
  	}

-	if (completion)
-		init_completion(&uic_cmd->done);
+	init_completion(&uic_cmd->done);

  	uic_cmd->cmd_active = 1;
  	ufshcd_dispatch_uic_cmd(hba, uic_cmd);
@@ -2586,7 +2583,7 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba, 
struct uic_command *uic_cmd)
  	mutex_lock(&hba->uic_cmd_mutex);
  	ufshcd_add_delay_before_dme_cmd(hba);

-	ret = __ufshcd_send_uic_cmd(hba, uic_cmd, true);
+	ret = __ufshcd_send_uic_cmd(hba, uic_cmd);
  	if (!ret)
  		ret = ufshcd_wait_for_uic_cmd(hba, uic_cmd);

@@ -4255,7 +4252,6 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba 
*hba, struct uic_command *cmd)
  	unsigned long flags;
  	u8 status;
  	int ret;
-	bool reenable_intr = false;

  	mutex_lock(&hba->uic_cmd_mutex);
  	ufshcd_add_delay_before_dme_cmd(hba);
@@ -4266,17 +4262,8 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba 
*hba, struct uic_command *cmd)
  		goto out_unlock;
  	}
  	hba->uic_async_done = &uic_async_done;
-	if (ufshcd_readl(hba, REG_INTERRUPT_ENABLE) & UIC_COMMAND_COMPL) {
-		ufshcd_disable_intr(hba, UIC_COMMAND_COMPL);
-		/*
-		 * Make sure UIC command completion interrupt is disabled before
-		 * issuing UIC command.
-		 */
-		ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
-		reenable_intr = true;
-	}
  	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	ret = __ufshcd_send_uic_cmd(hba, cmd, false);
+	ret = __ufshcd_send_uic_cmd(hba, cmd);
  	if (ret) {
  		dev_err(hba->dev,
  			"pwr ctrl cmd 0x%x with mode 0x%x uic error %d\n",
@@ -4300,6 +4287,13 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba 
*hba, struct uic_command *cmd)
  		goto out;
  	}

+	ret = wait_for_completion_timeout(&cmd->done,
+					  msecs_to_jiffies(uic_cmd_timeout));
+	WARN_ON_ONCE(ret < 0);
+	if (ret == 0)
+		dev_err(hba->dev, "UIC command %#x timed out\n", cmd->command);
+	ret = 0;
+
  check_upmcrs:
  	status = ufshcd_get_upmcrs(hba);
  	if (status != PWR_LOCAL) {
@@ -4318,8 +4312,6 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba 
*hba, struct uic_command *cmd)
  	spin_lock_irqsave(hba->host->host_lock, flags);
  	hba->active_uic_cmd = NULL;
  	hba->uic_async_done = NULL;
-	if (reenable_intr)
-		ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
  	if (ret) {
  		ufshcd_set_link_broken(hba);
  		ufshcd_schedule_eh_work(hba);

