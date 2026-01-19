Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FB137418B;
	Mon, 19 Jan 2026 14:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768832624; cv=none; b=D31rkbz4pY/G5omxe7G8QfIewvFRmPEjavspoaeZ4020fUWelnquskteKuxehzslcScqdzUdH7z5/uH2GeqvR/BbsCMiC0KBcnP3wSKudXuKTCvkFoM9cdvTe9W11HORedT/3dYeF5FDxTWTdOjq+OlA4YxRVLlzL6/UpMJ/Ino=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768832624; c=relaxed/simple;
	bh=dXfQL494/dbnQPycNGjgs1u/V0zIWVam8A0eP+0YM2k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bIRQDUmXMNQL0ESd32gKdn2AX7XLmaEPrjrPPqoD+V8V0tN+SXeMjBCtvVUoD3hsLMEsR4vCOSnQSU2iHNyBlOcAA5qjav0ln9GcQs55jopwcDpMf0hx3H6sd0Wy9rJxrBk952cqCj4cyodwZaIaqOAxtLa9rpve/+y6vrWBmgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tsh7yMqr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tsh7yMqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C02EC116C6;
	Mon, 19 Jan 2026 14:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768832623;
	bh=dXfQL494/dbnQPycNGjgs1u/V0zIWVam8A0eP+0YM2k=;
	h=From:To:Cc:Subject:Date:From;
	b=tsh7yMqrpoyp1Bc8xpfh9ifzjxWtFbzyMVL8cK3KeBWjFq0eS+HLR1PSAHLoGpo8Q
	 977Po1io4kDKXMNs8Ld1Uby8rwES7jIeHwrfZqn10KYpqGK+1flqeTCUoK79Q+01wd
	 eXOt1XK+tzTK6CTE4/6jUXdJULqM7AjBS9i3LGCE3t7DHosSTO5eJIbezMI16iJud0
	 jQ/ytzvFlifYkHZ2sqlCkfEDLgFxUnmdHp9n19CYOrcjwYTSqpAZQ/Vcl3UD4pOZyM
	 8CrwrUihX1cuKaRwK4BnydgrzEYI5majnaGB0FbUqAtFqa/+FYaAhBc0UQtCbD9TXW
	 lgjuGjgi7twNQ==
From: Tzung-Bi Shih <tzungbi@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Greg KH <gregkh@linuxfoundation.org>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tzungbi@kernel.org
Subject: [PATCH v2] scsi: core: Don't free dev_name() and hold refcount for parent manually
Date: Mon, 19 Jan 2026 22:23:06 +0800
Message-ID: <20260119142306.33676-1-tzungbi@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drivers shouldn't need to free the device name as the driver core
handles that automatically.  All it needs to do is dropping the
reference count of the device.

An intuitive fix is:
>  @@ -373,7 +373,7 @@ static void scsi_host_dev_release(struct device *dev)
>   		 * name as well as the proc dir structure are leaked.
>   		 */
>   		scsi_proc_hostdir_rm(shost->hostt);
>  -		kfree(dev_name(&shost->shost_dev));
>  +		put_device(&shost->shost_dev);
>   	}
>
>   	kfree(shost->shost_data);

However, it doesn't work well.  It generates an underflow on the
refcount of `&shost->shost_gendev` on errors.  This is what happens:
- The refcount of `shost_gendev` and `shost_dev` are both 1 after
  device_initialize().
- On the error handling path (i.e., "fail" label), it drops refcount of
  `shost_gendev` to 0.
- The .release() callback of `shost_gendev` (i.e.,
  scsi_host_dev_release()) is called, and it drops refcount of
  `shost_dev` to 0 due to the above change.
- The .release() callback of `shost_dev` (i.e., scsi_host_cls_release())
  is called, and it drops refcount of `shost_gendev` again.  The
  underflow happens.

A subsequent fix is:
>  @@ -55,7 +55,6 @@ static DEFINE_IDA(host_index_ida);
>
>   static void scsi_host_cls_release(struct device *dev)
>   {
>  -	put_device(&class_to_shost(dev)->shost_gendev);
>   }
>
>   static struct class shost_class = {

However, it introduces unbalance refcount of `shost_gendev` as
scsi_add_host_with_dma() increases it but scsi_host_cls_release()
doesn't drop it with the above change.

Drivers shouldn't need to hold a reference count to its parent device as
the driver core automatically holds one in device_add().  Eliminate the
case for holding refcount of `shost_gendev` to fix the unbalance
refcount.  Eliminate yet another case for `shost_gendev.parent` as well.

Fixes: b49493f99690 ("Fix a memory leak in scsi_host_dev_release()")
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
---
v2:
- Provide more context in the commit message.
- Leave a comment in the empty .release() function.

v1: https://lore.kernel.org/r/20260117193221.152540-1-tzungbi@kernel.org

 drivers/scsi/hosts.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 1b3fbd328277..7c39e228d72b 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -55,7 +55,10 @@ static DEFINE_IDA(host_index_ida);
 
 static void scsi_host_cls_release(struct device *dev)
 {
-	put_device(&class_to_shost(dev)->shost_gendev);
+	/*
+	 * Keep an empty release() to prevent device_release() from emitting a
+	 * warning.
+	 */
 }
 
 static struct class shost_class = {
@@ -279,11 +282,9 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 		goto out_disable_runtime_pm;
 
 	scsi_host_set_state(shost, SHOST_RUNNING);
-	get_device(shost->shost_gendev.parent);
 
 	device_enable_async_suspend(&shost->shost_dev);
 
-	get_device(&shost->shost_gendev);
 	error = device_add(&shost->shost_dev);
 	if (error)
 		goto out_del_gendev;
@@ -352,7 +353,6 @@ EXPORT_SYMBOL(scsi_add_host_with_dma);
 static void scsi_host_dev_release(struct device *dev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
-	struct device *parent = dev->parent;
 
 	/* Wait for functions invoked through call_rcu(&scmd->rcu, ...) */
 	rcu_barrier();
@@ -366,22 +366,20 @@ static void scsi_host_dev_release(struct device *dev)
 
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
 
@@ -550,8 +548,8 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
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
2.51.0

