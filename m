Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026CD2566E2
	for <linux-scsi@vger.kernel.org>; Wed, 15 Oct 2025 22:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760567099; cv=none; b=Qb8Znmg/hsPzCbWkqR2FVApcN2Z2cM7OXbS9IlqC1MK12AwJwLTPS5uPLVNaqs4Cpx+wrGT/cQoPWiI0AxhvErwoUswpQnpAQ3KbI3oBATS4EEIF4pkZ1ahNic+n3n1b8Xosh+iCIMOS7Win2R1XZVz1ph8eXwKKPOAcIHXIMlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760567099; c=relaxed/simple;
	bh=0OvYinrJnAxfbsWgE/EM2tbTbqApeaAM9BrVSgeZH+U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ihtVwqRTpoK9FrxgpAQCYI6T/h0RNGRdYGpsROBhRriZxsGrUfaxBihoLK1iCuBTARJFW8eFp8cum8NbBfWwhv3uaHCotUdz0G+eGP2sOuKkj04b6n+NclmT7IbT8x77h0oTkSobavYrPgQtNPOgc2dkvSkpS5lpv9S2wd4eqcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3XttHGWR; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3XttHGWR"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cn5HW5Typzm16kq;
	Wed, 15 Oct 2025 22:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1760567093; x=1763159094; bh=+av6Yx7XTk4/1wxTDRwIEbbh
	jLoip2I88MbquGroLFo=; b=3XttHGWRuXNRHA2K+tV4pf/ffpMjpCV7Z5nn1n9c
	KkmpN7IrMcHR0S5LHFWzonk9084t1QbUEbeCV+WzEhAiF4RxWpAYerqXrzJOO/7r
	59vWjXJ3tZAfiowdCTiFe/koY7BjbWhVbTguPcEwhR0plfEYg7Tk3ROzSj9rnHZ1
	Mg1IT2Qch/pPGwzcJ6QfBBioB6MOCHINiDMycPjHYVfZzaKVfGG+e6YmN8W9cUmR
	0qHvUHBiUiTYNwcbIuwwAB6E3gh8Wh0ECJZ8XcPbLO2+w0yXwqUNUpxberjttIQ0
	Dsi52DBVTr5WJNcMxy9UkUmSdroTRBOgNMoI14ZYEHEhAQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fr-X_VqD7MFk; Wed, 15 Oct 2025 22:24:53 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cn5HM4bT8zm16kk;
	Wed, 15 Oct 2025 22:24:46 +0000 (UTC)
Message-ID: <baaf9d5b-06e7-4683-a88c-c9f303f5270e@acm.org>
Date: Wed, 15 Oct 2025 15:24:45 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] ufs: core: Fix a race condition related to the "hid"
 attribute group
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Daniel Lee <chullee@google.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@sandisk.com>,
 Bean Huo <beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Adrian Hunter <adrian.hunter@intel.com>
References: <20251014200118.3390839-1-bvanassche@acm.org>
 <20251014200118.3390839-2-bvanassche@acm.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251014200118.3390839-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/14/25 1:00 PM, Bart Van Assche wrote:
> ufs_sysfs_add_nodes() is called concurrently with ufs_get_device_desc().
> This may cause the following code to be called before
> ufs_sysfs_add_nodes():
(replying to my own email)

I'm considering to replace this patch with the patch below:

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 875aab4a9cce..05f700f9cfa7 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -2086,18 +2086,23 @@ const struct attribute_group 
ufs_sysfs_lun_attributes_group = {
  	.attrs = ufs_sysfs_lun_attributes,
  };

-void ufs_sysfs_add_nodes(struct device *dev)
+void ufs_sysfs_add_nodes(struct ufs_hba *hba)
  {
+	struct device *dev = hba->dev;
  	int ret;

  	ret = sysfs_create_groups(&dev->kobj, ufs_sysfs_groups);
-	if (ret)
+	if (ret) {
  		dev_err(dev,
  			"%s: sysfs groups creation failed (err = %d)\n",
  			__func__, ret);
+	} else {
+		WRITE_ONCE(hba->sysfs_attrs_added, true);
+	}
  }

-void ufs_sysfs_remove_nodes(struct device *dev)
+void ufs_sysfs_remove_nodes(struct ufs_hba *hba)
  {
-	sysfs_remove_groups(&dev->kobj, ufs_sysfs_groups);
+	WRITE_ONCE(hba->sysfs_attrs_added, false);
+	sysfs_remove_groups(&hba->dev->kobj, ufs_sysfs_groups);
  }
diff --git a/drivers/ufs/core/ufs-sysfs.h b/drivers/ufs/core/ufs-sysfs.h
index 6efb82a082fd..c9e3751c6793 100644
--- a/drivers/ufs/core/ufs-sysfs.h
+++ b/drivers/ufs/core/ufs-sysfs.h
@@ -8,9 +8,10 @@
  #include <linux/sysfs.h>

  struct device;
+struct ufs_hba;

-void ufs_sysfs_add_nodes(struct device *dev);
-void ufs_sysfs_remove_nodes(struct device *dev);
+void ufs_sysfs_add_nodes(struct ufs_hba *hba);
+void ufs_sysfs_remove_nodes(struct ufs_hba *hba);

  extern const struct attribute_group ufs_sysfs_unit_descriptor_group;
  extern const struct attribute_group ufs_sysfs_lun_attributes_group;
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0013d21e2169..2887c5623992 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8604,7 +8604,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
  				DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP) &
  				UFS_DEV_HID_SUPPORT;

-	sysfs_update_group(&hba->dev->kobj, &ufs_sysfs_hid_group);
+	if (READ_ONCE(hba->sysfs_attrs_added))
+		sysfs_update_group(&hba->dev->kobj, &ufs_sysfs_hid_group);

  	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];

@@ -10539,7 +10540,7 @@ void ufshcd_remove(struct ufs_hba *hba)
  		ufshcd_rpm_get_sync(hba);
  	ufs_hwmon_remove(hba);
  	ufs_bsg_remove(hba);
-	ufs_sysfs_remove_nodes(hba->dev);
+	ufs_sysfs_remove_nodes(hba);
  	cancel_delayed_work_sync(&hba->ufs_rtc_update_work);
  	blk_mq_destroy_queue(hba->tmf_queue);
  	blk_put_queue(hba->tmf_queue);
@@ -11003,8 +11004,8 @@ int ufshcd_init(struct ufs_hba *hba, void 
__iomem *mmio_base, unsigned int irq)
  	if (err)
  		goto out_disable;

+	ufs_sysfs_add_nodes(hba);
  	async_schedule(ufshcd_async_scan, hba);
-	ufs_sysfs_add_nodes(dev);
  	trace_android_vh_ufs_update_sysfs(hba);

  	device_enable_async_suspend(dev);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index fba73d28ad87..9d7a88e73ba5 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -905,6 +905,8 @@ enum ufshcd_mcq_opr {
   * @ee_ctrl_mutex: Used to serialize exception event information.
   * @is_powered: flag to check if HBA is powered
   * @shutting_down: flag to check if shutdown has been invoked
+ * @sysfs_attrs_added: Whether or not the sysfs attributes have been 
added to
+ *	hba->dev.
   * @host_sem: semaphore used to serialize concurrent contexts
   * @eh_wq: Workqueue that eh_work works on
   * @eh_work: Worker to handle UFS errors that require s/w attention
@@ -1054,6 +1056,7 @@ struct ufs_hba {
  	struct mutex ee_ctrl_mutex;
  	bool is_powered;
  	bool shutting_down;
+	bool sysfs_attrs_added;
  	struct semaphore host_sem;

  	/* Work Queues */

