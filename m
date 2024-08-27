Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EBB1C6F4A
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2024 15:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724773378; cv=none; b=N0bbawGT7YXYziRoC+eHINRU6HueoAdCFSrkirlfk3I32kgzTQabq0uC2xT897E8SKTY/H3BHOgd2grFWZ5ZVvQhvNMdSwIBedRiNE8jqH7OI0ID4b8GFN0gr7oSdJSSD5vxjmttv3kdQ7PhfSQ7A058zDg7+IqEK2i9ooafP8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724773378; c=relaxed/simple;
	bh=eYO9yTmk1jloD8CwVOC2sY/7BrBhACnX/GqCCVliVXI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SF+Z8hmjFcNXpvpIpmclO0gjaz9CTQZHpP9FrEyAVVjm6jom4BddMEsaur1zR5vd+ViKC5/0BqcqoRRpvV18ATQ52+SWwZw31togrO1Vft80Pa89s8GBp8f/F7AjOkrgtjjPjg/GLMUFKJ0PrlyUFMQqK/XwbiKbF17KRabqEmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=mLton3TA; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="mLton3TA"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WtWyl1Ld8zlgVnW;
	Tue, 27 Aug 2024 15:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724773362; x=1727365363; bh=M2n2BBP0LkI95Dp259Qpk0Kv
	R61ynkfWlNxrWRoHn/U=; b=mLton3TAoHDg41bY31L4921bGdGG2tK/5EJYCtOe
	/4lh3QSVan7tKVnUlLxDd3KOMHbZ5mxQbJ2ueZP+F1x3HYj89Uk0lcsGj+I8lIGK
	xu1lZGJJQ6XIE8NiEeoHHSGAhoLdsOdJh86VIwWwZd+o6eS5G0Dsw0sBNn90aOaa
	sUJJRRj12TQPPHLbB69EPVNz/5Q6nzZVA3cOpe1JPqiPWPwAKgzImYdDJjEeG5oP
	hIizHWj8M1D8ZXImwEvdK9BawYG1EuZcsYcG6US85WVa6RsMzowzOLlRLWWlQHEW
	7j/OHqqXxF1ULq4MT5C6Boo/kzAyxhWTawxkNHWbAMNvDw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id bDP0KbEmkPCB; Tue, 27 Aug 2024 15:42:42 +0000 (UTC)
Received: from [172.16.58.82] (modemcable170.180-37-24.static.videotron.ca [24.37.180.170])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WtWyR1jgZzlgVnY;
	Tue, 27 Aug 2024 15:42:39 +0000 (UTC)
Message-ID: <f7f0ca00-a8ce-4841-8483-5ad886da82ad@acm.org>
Date: Tue, 27 Aug 2024 11:42:37 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "ebiggers@google.com" <ebiggers@google.com>,
 "ahalaney@redhat.com" <ahalaney@redhat.com>,
 "quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
 "beanhuo@micron.com" <beanhuo@micron.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
 "minwoo.im@samsung.com" <minwoo.im@samsung.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>
References: <20240821182923.145631-1-bvanassche@acm.org>
 <20240821182923.145631-3-bvanassche@acm.org>
 <ba9ae5a8-6021-f906-9ce1-d637534ac9cf@quicinc.com>
 <20c1866f-9bb2-406f-a819-74ad936d92d5@acm.org>
 <471e5a037f5fcc996e36b6112dc011731e75b66d.camel@mediatek.com>
 <63b82e64-e968-4704-85b8-fad919994432@acm.org>
 <b7b0395a59e275c5e43cb282b827b39416a5b4ad.camel@mediatek.com>
 <082b7053-e7f4-4dd9-9d84-c8d9c7d75faf@acm.org>
 <37fc6433d70483b7a889ff804e56023b1081b7b6.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <37fc6433d70483b7a889ff804e56023b1081b7b6.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 8/26/24 6:39 PM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> It is not a new vendor hook, ufshcd_vops_hibern8_notify is exist
> in current kernel.
Hi Peter,

Is something like the untested patch below perhaps what you have in
mind?

Thanks,

Bart.


diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
index ce36154ce963..69ee49a75c04 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -176,12 +176,14 @@ static inline void=20
ufshcd_vops_setup_task_mgmt(struct ufs_hba *hba,
  		return hba->vops->setup_task_mgmt(hba, tag, tm_function);
  }

-static inline void ufshcd_vops_hibern8_notify(struct ufs_hba *hba,
-					enum uic_cmd_dme cmd,
-					enum ufs_notify_change_status status)
+static inline void
+ufshcd_vops_hibern8_notify(struct ufs_hba *hba, enum uic_cmd_dme cmd,
+			   enum ufs_notify_change_status status,
+			   bool *disable_uic_compl_intr)
  {
  	if (hba->vops && hba->vops->hibern8_notify)
-		return hba->vops->hibern8_notify(hba, cmd, status);
+		return hba->vops->hibern8_notify(hba, cmd, status,
+						 disable_uic_compl_intr);
  }

  static inline int ufshcd_vops_apply_dev_quirks(struct ufs_hba *hba)
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e13b9ac145f6..614b24f2eb7f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2541,9 +2541,8 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba,=20
struct uic_command *uic_cmd)
   *
   * Return: 0 only if success.
   */
-static int
-__ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd,
-		      bool completion)
+static int __ufshcd_send_uic_cmd(struct ufs_hba *hba,
+				 struct uic_command *uic_cmd)
  {
  	lockdep_assert_held(&hba->uic_cmd_mutex);

@@ -2553,8 +2552,7 @@ __ufshcd_send_uic_cmd(struct ufs_hba *hba, struct=20
uic_command *uic_cmd,
  		return -EIO;
  	}

-	if (completion)
-		init_completion(&uic_cmd->done);
+	init_completion(&uic_cmd->done);

  	uic_cmd->cmd_active =3D 1;
  	ufshcd_dispatch_uic_cmd(hba, uic_cmd);
@@ -2580,7 +2578,7 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba,=20
struct uic_command *uic_cmd)
  	mutex_lock(&hba->uic_cmd_mutex);
  	ufshcd_add_delay_before_dme_cmd(hba);

-	ret =3D __ufshcd_send_uic_cmd(hba, uic_cmd, true);
+	ret =3D __ufshcd_send_uic_cmd(hba, uic_cmd);
  	if (!ret)
  		ret =3D ufshcd_wait_for_uic_cmd(hba, uic_cmd);

@@ -4243,7 +4241,8 @@ EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
   *
   * Return: 0 on success, non-zero value on failure.
   */
-static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command=20
*cmd)
+static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command=20
*cmd,
+			       bool disable_uic_compl_intr)
  {
  	DECLARE_COMPLETION_ONSTACK(uic_async_done);
  	unsigned long flags;
@@ -4260,7 +4259,8 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba=20
*hba, struct uic_command *cmd)
  		goto out_unlock;
  	}
  	hba->uic_async_done =3D &uic_async_done;
-	if (ufshcd_readl(hba, REG_INTERRUPT_ENABLE) & UIC_COMMAND_COMPL) {
+	if (disable_uic_compl_intr &&
+	    ufshcd_readl(hba, REG_INTERRUPT_ENABLE) & UIC_COMMAND_COMPL) {
  		ufshcd_disable_intr(hba, UIC_COMMAND_COMPL);
  		/*
  		 * Make sure UIC command completion interrupt is disabled before
@@ -4270,7 +4270,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba=20
*hba, struct uic_command *cmd)
  		reenable_intr =3D true;
  	}
  	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	ret =3D __ufshcd_send_uic_cmd(hba, cmd, false);
+	ret =3D __ufshcd_send_uic_cmd(hba, cmd);
  	if (ret) {
  		dev_err(hba->dev,
  			"pwr ctrl cmd 0x%x with mode 0x%x uic error %d\n",
@@ -4294,6 +4294,16 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba=20
*hba, struct uic_command *cmd)
  		goto out;
  	}

+	if (!disable_uic_compl_intr &&
+	    ufshcd_readl(hba, REG_INTERRUPT_ENABLE) & UIC_COMMAND_COMPL) {
+		ret =3D wait_for_completion_timeout(
+			&cmd->done, msecs_to_jiffies(uic_cmd_timeout));
+		if (ret =3D=3D 0)
+			dev_err(hba->dev, "pwr ctrl cmd %#x timed out\n",
+				cmd->command);
+		ret =3D 0;
+	}
+
  check_upmcrs:
  	status =3D ufshcd_get_upmcrs(hba);
  	if (status !=3D PWR_LOCAL) {
@@ -4353,7 +4363,7 @@ int ufshcd_uic_change_pwr_mode(struct ufs_hba=20
*hba, u8 mode)
  	}

  	ufshcd_hold(hba);
-	ret =3D ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
+	ret =3D ufshcd_uic_pwr_ctrl(hba, &uic_cmd, true);
  	ufshcd_release(hba);

  out:
@@ -4396,11 +4406,13 @@ int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
  		.command =3D UIC_CMD_DME_HIBER_ENTER,
  	};
  	ktime_t start =3D ktime_get();
+	bool disable_uic_compl_intr =3D true;
  	int ret;

-	ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_ENTER, PRE_CHANGE);
+	ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_ENTER, PRE_CHANGE,
+				   &disable_uic_compl_intr);

-	ret =3D ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
+	ret =3D ufshcd_uic_pwr_ctrl(hba, &uic_cmd, disable_uic_compl_intr);
  	trace_ufshcd_profile_hibern8(dev_name(hba->dev), "enter",
  			     ktime_to_us(ktime_sub(ktime_get(), start)), ret);

@@ -4409,7 +4421,7 @@ int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
  			__func__, ret);
  	else
  		ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_ENTER,
-								POST_CHANGE);
+					   POST_CHANGE, NULL);

  	return ret;
  }
@@ -4423,9 +4435,10 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
  	int ret;
  	ktime_t start =3D ktime_get();

-	ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_EXIT, PRE_CHANGE);
+	ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_EXIT, PRE_CHANGE,
+				   NULL);

-	ret =3D ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
+	ret =3D ufshcd_uic_pwr_ctrl(hba, &uic_cmd, true);
  	trace_ufshcd_profile_hibern8(dev_name(hba->dev), "exit",
  			     ktime_to_us(ktime_sub(ktime_get(), start)), ret);

@@ -4434,7 +4447,7 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
  			__func__, ret);
  	} else {
  		ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_EXIT,
-								POST_CHANGE);
+					   POST_CHANGE, NULL);
  		hba->ufs_stats.last_hibern8_exit_tstamp =3D local_clock();
  		hba->ufs_stats.hibern8_exit_cnt++;
  	}
diff --git a/drivers/ufs/host/cdns-pltfrm.c b/drivers/ufs/host/cdns-pltfr=
m.c
index 66811d8d1929..24c05e5c455d 100644
--- a/drivers/ufs/host/cdns-pltfrm.c
+++ b/drivers/ufs/host/cdns-pltfrm.c
@@ -164,7 +164,8 @@ static int cdns_ufs_hce_enable_notify(struct ufs_hba=20
*hba,
   * @status: notify stage (pre, post change)
   */
  static void cdns_ufs_hibern8_notify(struct ufs_hba *hba, enum=20
uic_cmd_dme cmd,
-				    enum ufs_notify_change_status status)
+				    enum ufs_notify_change_status status,
+				    bool *disable_uic_compl_intr)
  {
  	if (status =3D=3D PRE_CHANGE && cmd =3D=3D UIC_CMD_DME_HIBER_ENTER)
  		cdns_ufs_get_l4_attr(hba);
diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.=
c
index 16ad3528d80b..e991d9e5e2e4 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1624,8 +1624,9 @@ static int exynos_ufs_pwr_change_notify(struct=20
ufs_hba *hba,
  }

  static void exynos_ufs_hibern8_notify(struct ufs_hba *hba,
-				     enum uic_cmd_dme enter,
-				     enum ufs_notify_change_status notify)
+				      enum uic_cmd_dme enter,
+				      enum ufs_notify_change_status notify,
+				      bool *disable_uic_compl_intr)
  {
  	switch ((u8)notify) {
  	case PRE_CHANGE:
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a43b14276bc3..59b901d67400 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -355,8 +355,9 @@ struct ufs_hba_variant_ops {
  	void	(*setup_xfer_req)(struct ufs_hba *hba, int tag,
  				  bool is_scsi_cmd);
  	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
-	void    (*hibern8_notify)(struct ufs_hba *, enum uic_cmd_dme,
-					enum ufs_notify_change_status);
+	void	(*hibern8_notify)(struct ufs_hba *, enum uic_cmd_dme,
+				  enum ufs_notify_change_status,
+				  bool *disable_uic_compl_intr);
  	int	(*apply_dev_quirks)(struct ufs_hba *hba);
  	void	(*fixup_dev_quirks)(struct ufs_hba *hba);
  	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op,

