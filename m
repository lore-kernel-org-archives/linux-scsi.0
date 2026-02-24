Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6054236D4E0
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2026 12:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771935933; cv=none; b=QSyGaTMo7Kn3fMFYQ5alvwsjuUzFF4jnhQjrLwpnO5Qh+Yj+yzvlNzwLSrEmAHAADNs2i+SZvWSqFWHITWpkPv+bDMglDoQkDHXZzFfiTHonrWGDg2X0LVpBP1aBW6A1Lq+GbOVl77CBG1yVAJ1r6PMgB6Cm9uUmDzl8nDnnFYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771935933; c=relaxed/simple;
	bh=ur+DA7Gr+Oc3VoUM4ZQiVl7zCL/OlaLz0HclU1f1aaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8XZCYSU8tj9mHTumNPuEsu1+mbyv6I2FdTiw9PYi4B7r1x1JRp/oj1Jk9mZp+eZo0ym7k7PWfXrusLZ1r+d75WpcEzCmor/qzb251FhqDso4T1JInrbeQfEv9274D9jVcNXkittP8s++e0p8uayhTZ2nj9k36lPDKCv/XPCSqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LaKDFqjx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LaKDFqjx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771935931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/NUg1QZtT8F/ZksJtPliXutyXR+IqDXeQnE0gwd+ISE=;
	b=LaKDFqjxz8H+StsEBSy0bym3C+gH9mP5qWKbwJdclRcYc/P1g75saeqxUFb1rxcB7sNBaZ
	nTmJoGN9V3tqXvWKLCHuf1M179u3wqdzRABbaOtvebl6vZtzMtZZgQYPLwMdHKFyeScm9n
	enZ7a/kByfy2oAUW79zf9N0HeFKHqyU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-404-NIVEieRPNkakrHuZo5wjyA-1; Tue,
 24 Feb 2026 07:25:27 -0500
X-MC-Unique: NIVEieRPNkakrHuZo5wjyA-1
X-Mimecast-MFC-AGG-ID: NIVEieRPNkakrHuZo5wjyA_1771935925
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C2BBB195608F;
	Tue, 24 Feb 2026 12:25:24 +0000 (UTC)
Received: from mlombard-thinkpadt14gen4.rmtit.csb (unknown [10.44.32.204])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3862019560AD;
	Tue, 24 Feb 2026 12:25:20 +0000 (UTC)
From: Maurizio Lombardi <mlombard@redhat.com>
To: kbusch@kernel.org
Cc: hch@lst.de,
	hare@suse.de,
	chaitanyak@nvidia.com,
	bvanassche@acm.org,
	linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	James.Bottomley@HansenPartnership.com,
	mlombard@arkamax.eu,
	jmeneghi@redhat.com,
	emilne@redhat.com,
	bgurney@redhat.com
Subject: [PATCH V2 3/3] scsi: Convert async scanning to use the completion chain helper
Date: Tue, 24 Feb 2026 13:25:05 +0100
Message-ID: <20260224122505.52401-4-mlombard@redhat.com>
In-Reply-To: <20260224122505.52401-1-mlombard@redhat.com>
References: <20260224122505.52401-1-mlombard@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

The asynchronous host scanning logic in scsi_scan.c uses a custom,
open-coded implementation to serialize scans. This involves a manually
managed list of tasks, each with its own completion, to ensure that hosts
are scanned and added to the system in a deterministic order.

Refactors the SCSI async scanning implementation to use the new
compl_async_chain helper. This simplifies the scsi_scan.c code and makes
the serialization logic more readable.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/scsi_priv.h |  2 +-
 drivers/scsi/scsi_scan.c | 68 +++++-----------------------------------
 2 files changed, 9 insertions(+), 61 deletions(-)

diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 7a193cc04e5b..d8a157bc9078 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -132,7 +132,7 @@ extern void scsi_exit_procfs(void);
 
 /* scsi_scan.c */
 void scsi_enable_async_suspend(struct device *dev);
-extern int scsi_complete_async_scans(void);
+extern void scsi_complete_async_scans(void);
 extern int scsi_scan_host_selected(struct Scsi_Host *, unsigned int,
 				   unsigned int, u64, enum scsi_scan_mode);
 extern void scsi_forget_host(struct Scsi_Host *);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 60c06fa4ec32..4157d8fe4893 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -36,6 +36,7 @@
 #include <linux/async.h>
 #include <linux/slab.h>
 #include <linux/unaligned.h>
+#include <linux/compl_chain.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -112,14 +113,11 @@ MODULE_PARM_DESC(inq_timeout,
 		 "Timeout (in seconds) waiting for devices to answer INQUIRY."
 		 " Default is 20. Some devices may need more; most need less.");
 
-/* This lock protects only this list */
-static DEFINE_SPINLOCK(async_scan_lock);
-static LIST_HEAD(scanning_hosts);
+DEFINE_COMPL_CHAIN(scanning_hosts);
 
 struct async_scan_data {
-	struct list_head list;
+	struct compl_chain_entry chain_entry;
 	struct Scsi_Host *shost;
-	struct completion prev_finished;
 };
 
 /*
@@ -146,48 +144,10 @@ void scsi_enable_async_suspend(struct device *dev)
  * started scanning after this function was called may or may not have
  * finished.
  */
-int scsi_complete_async_scans(void)
+void scsi_complete_async_scans(void)
 {
-	struct async_scan_data *data;
-
-	do {
-		scoped_guard(spinlock, &async_scan_lock)
-			if (list_empty(&scanning_hosts))
-				return 0;
-		/* If we can't get memory immediately, that's OK.  Just
-		 * sleep a little.  Even if we never get memory, the async
-		 * scans will finish eventually.
-		 */
-		data = kmalloc(sizeof(*data), GFP_KERNEL);
-		if (!data)
-			msleep(1);
-	} while (!data);
-
-	data->shost = NULL;
-	init_completion(&data->prev_finished);
-
-	spin_lock(&async_scan_lock);
-	/* Check that there's still somebody else on the list */
-	if (list_empty(&scanning_hosts))
-		goto done;
-	list_add_tail(&data->list, &scanning_hosts);
-	spin_unlock(&async_scan_lock);
-
 	printk(KERN_INFO "scsi: waiting for bus probes to complete ...\n");
-	wait_for_completion(&data->prev_finished);
-
-	spin_lock(&async_scan_lock);
-	list_del(&data->list);
-	if (!list_empty(&scanning_hosts)) {
-		struct async_scan_data *next = list_entry(scanning_hosts.next,
-				struct async_scan_data, list);
-		complete(&next->prev_finished);
-	}
- done:
-	spin_unlock(&async_scan_lock);
-
-	kfree(data);
-	return 0;
+	compl_chain_flush(&scanning_hosts);
 }
 
 /**
@@ -1960,18 +1920,13 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 	data->shost = scsi_host_get(shost);
 	if (!data->shost)
 		goto err;
-	init_completion(&data->prev_finished);
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->async_scan = 1;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	mutex_unlock(&shost->scan_mutex);
 
-	spin_lock(&async_scan_lock);
-	if (list_empty(&scanning_hosts))
-		complete(&data->prev_finished);
-	list_add_tail(&data->list, &scanning_hosts);
-	spin_unlock(&async_scan_lock);
+	compl_chain_add(&scanning_hosts, &data->chain_entry);
 
 	return data;
 
@@ -2008,7 +1963,7 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
 		return;
 	}
 
-	wait_for_completion(&data->prev_finished);
+	compl_chain_wait(&data->chain_entry);
 
 	scsi_sysfs_add_devices(shost);
 
@@ -2018,14 +1973,7 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
 
 	mutex_unlock(&shost->scan_mutex);
 
-	spin_lock(&async_scan_lock);
-	list_del(&data->list);
-	if (!list_empty(&scanning_hosts)) {
-		struct async_scan_data *next = list_entry(scanning_hosts.next,
-				struct async_scan_data, list);
-		complete(&next->prev_finished);
-	}
-	spin_unlock(&async_scan_lock);
+	compl_chain_complete(&data->chain_entry);
 
 	scsi_autopm_put_host(shost);
 	scsi_host_put(shost);
-- 
2.53.0

