Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28136749C
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2025 20:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761682927; cv=none; b=mT6AgaHcJuqMkhE9JzkKoWaytT8lVb7CUTzfTe2vjsmg/0go0YsmwabhvIdS/LNeHZ5StrwVhCXpHHoKwIaj5GYXEaV2OaXUWxhFIO3UhDltyU1PFV3AJcjc5jwzes6Zkq8wVBpyUBcWSa17BALnHS8a5+aCHqFJ0QOxCheW/iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761682927; c=relaxed/simple;
	bh=VO2/h08n7EtlrL5bqaJO5zDlHbtN58APxa8ThunWJRk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bYY1gGrRN6WZXMBvngbeyRV1gaupVBCCEnn3tbpFYCvJ4ppb+x+kNxKbf14Cw5A0M9Gh9up0JB9E8QEUQrGik+HlBOTytnErzQ0JtruZyl5cphzaw0I6+Ir//xj7OY/dM8R3WUJq7vIU27GagQBQvnd+9DHGdPVQNxrINXdkpKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=LliWneui; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="LliWneui"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cx1xf48RWzlv621;
	Tue, 28 Oct 2025 20:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1761682915; x=1764274916; bh=kdKeSGFUaTMhT7OukDjlLj9U
	2R3B+XpvYmYVnhPh2xg=; b=LliWneui9+/Y9tNRRUAjC+SMVpuTW02qP6VgV/Ht
	ZxgkJapCoECb7qjwEjS0ew5MH7ZeN/JHtUvJE2Ham1dj3n72beN4M9ypsobLfMmf
	T/dOXtAxYwP3BaXF6W2CUn6qEGi7nyjmeXNI35skHIG7ub4jdVmO+CxJN61icWAP
	q/SPGU4ne0lKNh1BfPykMfr+QJFhzSoR9nXuSAUizbJ2tm1Cy+cv5rPPCgdypN28
	4l4WDQaAak0U58//Hud2d4hYbn8BAbPGdbkR8ucV0tYK8o7FUB8w+8PjYfZWtWf9
	XhoN9VI+bnzVJq4UT7w8UTc8nJfuZe9IsKYecN5RgdL3BA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id OQfRxPpYZ2jv; Tue, 28 Oct 2025 20:21:55 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cx1x56byFzlgqV7;
	Tue, 28 Oct 2025 20:21:28 +0000 (UTC)
Message-ID: <4d076706-4a39-4604-aef1-3690d80c2c74@acm.org>
Date: Tue, 28 Oct 2025 13:21:27 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ufs: core: Really fix the code for updating the "hid"
 attribute group
To: Bjorn Andersson <andersson@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Daniel Lee <chullee@google.com>,
 Peter Wang <peter.wang@mediatek.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Huan Tang <tanghuan@vivo.com>, Avri Altman <avri.altman@wdc.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Gwendal Grignou <gwendal@chromium.org>, Liu Song <liu.song13@zte.com.cn>,
 Bean Huo <huobean@gmail.com>, Manivannan Sadhasivam <mani@kernel.org>,
 Adrian Hunter <adrian.hunter@intel.com>, Can Guo <quic_cang@quicinc.com>,
 Eric Biggers <ebiggers@kernel.org>, Nitin Rawat <quic_nitirawa@quicinc.com>,
 Neil Armstrong <neil.armstrong@linaro.org>
References: <20251027170950.2919594-1-bvanassche@acm.org>
 <20251027170950.2919594-3-bvanassche@acm.org>
 <fysnm3cpnz6ipqw4tbw2jh3rvxqjzgabmz2oppccjus3gv2sab@oi6dz4o4zkw2>
 <6acc1879-ebb9-4e51-bbe9-3824f8f1711f@acm.org>
 <oyiecngk4n3em5m4or7ev27w2f7qcveqwhidh6bay46gbgjvds@qs2uyfmwv76h>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <oyiecngk4n3em5m4or7ev27w2f7qcveqwhidh6bay46gbgjvds@qs2uyfmwv76h>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/25 7:50 AM, Bjorn Andersson wrote:
> Yes, to me that looks like it would solve the issue at hand in a clean
> fashion. But you'd need cleanup in out_disable as well.
I have started testing the patch below:

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index d0a2c963a27d..aba27d60b53d 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -8,7 +8,7 @@

  static inline bool ufshcd_is_user_access_allowed(struct ufs_hba *hba)
  {
-	return !hba->shutting_down;
+	return hba->sysfs_allowed && !hba->shutting_down;
  }

  void ufshcd_schedule_eh_work(struct ufs_hba *hba);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 5d6297aa5c28..38fb75a89724 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10786,6 +10786,9 @@ int ufshcd_init(struct ufs_hba *hba, void 
__iomem *mmio_base, unsigned int irq)

  	ufshcd_init_clk_scaling(hba);

+	/* Add the sysfs nodes before the UFS error handler can be activated. */
+	ufs_sysfs_add_nodes(hba->dev);
+
  	/*
  	 * In order to avoid any spurious interrupt immediately after
  	 * registering UFS controller interrupt handler, clear any pending UFS
@@ -10883,11 +10886,15 @@ int ufshcd_init(struct ufs_hba *hba, void 
__iomem *mmio_base, unsigned int irq)
  	if (err)
  		goto out_disable;

+	/* Allow access through sysfs. */
+	down(&hba->host_sem);
+	hba->sysfs_allowed = true;
+	up(&hba->host_sem);
+
  	err = ufshcd_add_scsi_host(hba);
  	if (err)
  		goto out_disable;

-	ufs_sysfs_add_nodes(hba->dev);
  	async_schedule(ufshcd_async_scan, hba);

  	device_enable_async_suspend(dev);
@@ -10895,6 +10902,7 @@ int ufshcd_init(struct ufs_hba *hba, void 
__iomem *mmio_base, unsigned int irq)
  	return 0;

  out_disable:
+	ufs_sysfs_remove_nodes(hba->dev);
  	hba->is_irq_enabled = false;
  	ufshcd_hba_exit(hba);
  out_error:
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 9425cfd9d00e..01c2db4473ee 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -868,6 +868,7 @@ enum ufshcd_mcq_opr {
   * @ee_usr_mask: Exception event mask for user (set via debugfs)
   * @ee_ctrl_mutex: Used to serialize exception event information.
   * @is_powered: flag to check if HBA is powered
+ * @sysfs_allowed: whether or not access from sysfs is allowed
   * @shutting_down: flag to check if shutdown has been invoked
   * @host_sem: semaphore used to serialize concurrent contexts
   * @eh_wq: Workqueue that eh_work works on
@@ -1020,6 +1021,7 @@ struct ufs_hba {
  	u16 ee_usr_mask;
  	struct mutex ee_ctrl_mutex;
  	bool is_powered;
+	bool sysfs_allowed;
  	bool shutting_down;
  	struct semaphore host_sem;


