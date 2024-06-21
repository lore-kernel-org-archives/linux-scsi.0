Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C5212C54B;
	Fri, 21 Jun 2024 21:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719004565; cv=none; b=Oy6QVzuQMPqBPG/oj0AaVkiRZy1I46MOyqtHaAZjkA3EzIJJQHZfHOfTtyUTfO1rfd3yM4jS6Hc5yG8khmjqhm7ONSdcOvHUFn4ndefXET1y4kVu6Wp+akIMwYxFUg2hxLCZQYkjTQ82YavJH3fxBeK3KbtqJDalE4HA8ImsGSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719004565; c=relaxed/simple;
	bh=nlhhoDL+rqMuVo+AQ/Y9fc6ZUUX3QAXxkvgmbqr0iPU=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=Mtl+Zc8WzsxIphjPWZ7LvJxKO2LXWrvQokdUITgufDEeCkQhX/PZ8OOUCCRTk+anH0/JziJob3zBcLUaJNPyqKewjmT96sB45uBTI6ddxgssrepoU3ZD+p7EfzfDekL1sic9jy8ds/ZRicSiMD55tQEQUxl4bz7sY9IHDn8GHD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=bmB6KSRx; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=W44u7wBG; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="bmB6KSRx";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="W44u7wBG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1719004560;
	bh=nlhhoDL+rqMuVo+AQ/Y9fc6ZUUX3QAXxkvgmbqr0iPU=;
	h=Message-ID:Subject:From:To:Date:From;
	b=bmB6KSRxFK+p8uog5dHiLhaeu6UFv7m6/tiH2MjYj2dQ7hMFvN/3p/m59bvcfA8sz
	 O4rT71E/CDoafmsB1nKesE/ipRSnwCiPrj6Wm6FFjntf5opwhe0t01sN9N9cF6Nne9
	 dZtlZ2jI9ubL7R+if/TrSCAe30v5GDhdGSAuzO94=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 1CD4C1286A09;
	Fri, 21 Jun 2024 17:16:00 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id SBWYXv19uyzC; Fri, 21 Jun 2024 17:16:00 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1719004559;
	bh=nlhhoDL+rqMuVo+AQ/Y9fc6ZUUX3QAXxkvgmbqr0iPU=;
	h=Message-ID:Subject:From:To:Date:From;
	b=W44u7wBG8+04C5WFoyNM15JOl7z0nP2nMDynRwuNBSBaIzgMbhxzBpVAzfZSWKIYu
	 n0Y6/2G0se3oCJxZDwjk4V2GFEL/aSa2UpmwmHjUU3BqaE52PlyHjEJg6mTDL6TwlP
	 xw6XBUWOYB4vJPUDEvu7QUbQ64B9FuogIIzAQH+8=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 7F3DA12869EC;
	Fri, 21 Jun 2024 17:15:59 -0400 (EDT)
Message-ID: <317d2de5fdb5e27f8f493e0e0ad23640a41b6acf.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.10-rc4
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Fri, 21 Jun 2024 17:15:57 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Two fixes: one in the ufs driver fixing an obvious memory leak and the
other (with a core flag based update) trying to prevent USB crashes by
stopping the core from issuing a request for the I/O Hints mode page.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bart Van Assche (2):
      scsi: usb: uas: Do not query the IO Advice Hints Grouping mode page for USB/UAS devices
      scsi: core: Introduce the BLIST_SKIP_IO_HINTS flag

Joel Slebodnick (1):
      scsi: ufs: core: Free memory allocated for model before reinit

And the diffstat:

 drivers/scsi/sd.c              | 4 ++++
 drivers/ufs/core/ufshcd.c      | 1 +
 drivers/usb/storage/scsiglue.c | 6 ++++++
 drivers/usb/storage/uas.c      | 7 +++++++
 include/scsi/scsi_devinfo.h    | 4 +++-
 5 files changed, 21 insertions(+), 1 deletion(-)

With full diff below.

James

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fbc11046bbf6..fe82baa924f8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -63,6 +63,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_devinfo.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
@@ -3118,6 +3119,9 @@ static void sd_read_io_hints(struct scsi_disk *sdkp, unsigned char *buffer)
 	struct scsi_mode_data data;
 	int res;
 
+	if (sdp->sdev_bflags & BLIST_SKIP_IO_HINTS)
+		return;
+
 	res = scsi_mode_sense(sdp, /*dbd=*/0x8, /*modepage=*/0x0a,
 			      /*subpage=*/0x05, buffer, SD_BUF_SIZE, SD_TIMEOUT,
 			      sdkp->max_retries, &data, &sshdr);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e5e9da61f15d..1b65e6ae4137 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8787,6 +8787,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 	    (hba->quirks & UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH)) {
 		/* Reset the device and controller before doing reinit */
 		ufshcd_device_reset(hba);
+		ufs_put_device_desc(hba);
 		ufshcd_hba_stop(hba);
 		ufshcd_vops_reinit_notify(hba);
 		ret = ufshcd_hba_enable(hba);
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index b31464740f6c..8c8b5e6041cc 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -79,6 +79,12 @@ static int slave_alloc (struct scsi_device *sdev)
 	if (us->protocol == USB_PR_BULK && us->max_lun > 0)
 		sdev->sdev_bflags |= BLIST_FORCELUN;
 
+	/*
+	 * Some USB storage devices reset if the IO advice hints grouping mode
+	 * page is queried. Hence skip that mode page.
+	 */
+	sdev->sdev_bflags |= BLIST_SKIP_IO_HINTS;
+
 	return 0;
 }
 
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index a48870a87a29..b610a2de4ae5 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -21,6 +21,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_devinfo.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
@@ -820,6 +821,12 @@ static int uas_slave_alloc(struct scsi_device *sdev)
 	struct uas_dev_info *devinfo =
 		(struct uas_dev_info *)sdev->host->hostdata;
 
+	/*
+	 * Some USB storage devices reset if the IO advice hints grouping mode
+	 * page is queried. Hence skip that mode page.
+	 */
+	sdev->sdev_bflags |= BLIST_SKIP_IO_HINTS;
+
 	sdev->hostdata = devinfo;
 	return 0;
 }
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 6b548dc2c496..1d79a3b536ce 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -69,8 +69,10 @@
 #define BLIST_RETRY_ITF		((__force blist_flags_t)(1ULL << 32))
 /* Always retry ABORTED_COMMAND with ASC 0xc1 */
 #define BLIST_RETRY_ASC_C1	((__force blist_flags_t)(1ULL << 33))
+/* Do not query the IO Advice Hints Grouping mode page */
+#define BLIST_SKIP_IO_HINTS	((__force blist_flags_t)(1ULL << 34))
 
-#define __BLIST_LAST_USED BLIST_RETRY_ASC_C1
+#define __BLIST_LAST_USED BLIST_SKIP_IO_HINTS
 
 #define __BLIST_HIGH_UNUSED (~(__BLIST_LAST_USED | \
 			       (__force blist_flags_t) \

