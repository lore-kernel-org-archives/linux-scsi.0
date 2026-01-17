Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF25500941;
	Sat, 17 Jan 2026 19:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768678356; cv=none; b=na05YTecnnHavkNRWgzOos03+h2JR4OqYTxgqOcj4nbYMMJMH7tagD5SyQBPDWc71WmIyggKRCWQ6w9Ue1/KilJD0+qIEPJE9y109iKmh1/hV/kOjTFzxA9wh3rxKzLzFIkWS1OWqLqjGhchFQgiQQZuy1NnlTfGIFSbH0+xK1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768678356; c=relaxed/simple;
	bh=xYZ1QLXVBjYMCOd/kLFI3p25B4jljuN964Wp+AlR0jQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ABBS/Zsf1zkfbUngSHz2tqgz3KaWRN9E5/ESZPufzXzseiDIFsplwQRZ1uzbjYzP+itFAHPlX/PLWuUEhLrP7Bm8xKlIJpZscUCbsxlg3CdWK5SdvGY+0oFBoM0w2MJS1Kf9GoB5yEnbVO1DLZMTGKt21/v3qKL+ULnN8kRinmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DtJ3X2y0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DtJ3X2y0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B827C4CEF7;
	Sat, 17 Jan 2026 19:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768678355;
	bh=xYZ1QLXVBjYMCOd/kLFI3p25B4jljuN964Wp+AlR0jQ=;
	h=From:To:Cc:Subject:Date:From;
	b=DtJ3X2y0GAdHJOOEkTyVRf2fRASq4UlKof2BI14QvxFFzrXLyAZfRn9RNyuTtg9We
	 +88ydvy9VBhyYCD4+J2W21Go/3vmUnsPo/VAn7Z86C9eN6wA5vViucSNByoKmamIh0
	 1SFew0Q1b4QebDuOHbj0pEOar4WuIVFQymz9KS74qu9i5AHPyZNbnZ66PJItrv3T6s
	 VQMhNI+/ky/5VoZsa66U5DmWSJSYofUUo920W9YOpuLlmJ7AyHNHerqLAU600qrAaJ
	 1TAcn6/eKYz1GnjWeA/9YxDDFz+prI3Ujluwpy9hDxv6uOW14FT7uuWTnwZ9CjmCFX
	 tvbD5gwSgazfA==
From: Tzung-Bi Shih <tzungbi@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Greg KH <gregkh@linuxfoundation.org>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tzungbi@kernel.org
Subject: [PATCH] scsi: core: Don't free dev_name() manually
Date: Sun, 18 Jan 2026 03:32:21 +0800
Message-ID: <20260117193221.152540-1-tzungbi@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

scsi_host_alloc() is designed to hold initial reference count of
`&shost->shost_gendev` and `&shost->shost_dev`.  In the error handling
paths [1], only drop a reference count to `&shost->shost_gendev` is
sufficient as scsi_host_dev_release() will be called and the reference
count of `&shost->shost_dev` should be dropped at that time.

Drivers shouldn't need to free the device name and hold a reference
count to its parent device as the driver core automatically handles
that.  Remove them.

[1] Either at "fail" label in scsi_host_alloc() or in SCSI drivers that
    a subsequent scsi_add_host{,_with_dma}() fails.

Fixes: b49493f99690 ("Fix a memory leak in scsi_host_dev_release()")
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
---
 drivers/scsi/hosts.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 1b3fbd328277..b88d553cdde6 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -55,7 +55,6 @@ static DEFINE_IDA(host_index_ida);
 
 static void scsi_host_cls_release(struct device *dev)
 {
-	put_device(&class_to_shost(dev)->shost_gendev);
 }
 
 static struct class shost_class = {
@@ -279,11 +278,9 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 		goto out_disable_runtime_pm;
 
 	scsi_host_set_state(shost, SHOST_RUNNING);
-	get_device(shost->shost_gendev.parent);
 
 	device_enable_async_suspend(&shost->shost_dev);
 
-	get_device(&shost->shost_gendev);
 	error = device_add(&shost->shost_dev);
 	if (error)
 		goto out_del_gendev;
@@ -352,7 +349,6 @@ EXPORT_SYMBOL(scsi_add_host_with_dma);
 static void scsi_host_dev_release(struct device *dev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
-	struct device *parent = dev->parent;
 
 	/* Wait for functions invoked through call_rcu(&scmd->rcu, ...) */
 	rcu_barrier();
@@ -366,22 +362,20 @@ static void scsi_host_dev_release(struct device *dev)
 
 	if (shost->shost_state == SHOST_CREATED) {
 		/*
-		 * Free the shost_dev device name and remove the proc host dir
+		 * Drop the reference to shost_dev and remove the proc host dir
 		 * here if scsi_host_{alloc,put}() have been called but neither
-		 * scsi_host_add() nor scsi_remove_host() has been called.
+		 * scsi_add_host() nor scsi_remove_host() has been called.
 		 * This avoids that the memory allocated for the shost_dev
 		 * name as well as the proc dir structure are leaked.
 		 */
 		scsi_proc_hostdir_rm(shost->hostt);
-		kfree(dev_name(&shost->shost_dev));
+		put_device(&shost->shost_dev);
 	}
 
 	kfree(shost->shost_data);
 
 	ida_free(&host_index_ida, shost->host_no);
 
-	if (shost->shost_state != SHOST_CREATED)
-		put_device(parent);
 	kfree(shost);
 }
 
@@ -550,8 +544,8 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
  fail:
 	/*
 	 * Host state is still SHOST_CREATED and that is enough to release
-	 * ->shost_gendev. scsi_host_dev_release() will free
-	 * dev_name(&shost->shost_dev).
+	 * ->shost_gendev. scsi_host_dev_release() will
+	 * put_device(&shost->shost_dev).
 	 */
 	put_device(&shost->shost_gendev);
 
-- 
2.48.1

