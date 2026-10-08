Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EE33BFE4C
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 22:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791499372; cv=none; b=PP0MJsduF8/Q/cVmCi6ASFaOgG3Oj+/n/zrZE9MRTOnAG1h1+cM5o2HxYHYi68hbIk/GS1AD45zQDHTOtz9wiKQOj9w/zn0hQ287D9fGpRRRYDQdvDD9XQg4n+idlE/Ywr5TUT/4tBoSAihtnrGO16pa5uyOmA0duP8ZMDScT4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791499372; c=relaxed/simple;
	bh=a+80bmAFHhF1A7dej3O2pC3IJMCGdhRplJVAfEMUrqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMF5vRV0c0OknCtH5xA1uxXubypKPnCwQL2e9jd53VKE7i+DJ2t1p8D5isN5FnxCr2kSkP4eL2kSgay2r5xJpSigfLTxRygVQlEmRQCBODFUGhcNhUskamNQa8AtQptW23UiByrnlA9PbrlbTGLaTWpCLJMPkcuBWGI+CG/Rb64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NOAuNGes; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NOAuNGes"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j14ky5vZhz1XM30g;
	Thu,  8 Oct 2026 22:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1791499365; x=1794091366; bh=5xTDz
	srkqxl/RwmOWwh9YsoMqEfgaMqeql42khqs+oM=; b=NOAuNGes5Pvwh/onT091C
	rZdoF48YaEvHd6MxqFQNWozrsk+TrJbjWPD06WbYHrvBDu7yOmrdITwa5gfsHOwT
	6zBO8N4m0o5SmzKo0CpPH5xYHMOEMFGSbQVzbw6z7V2jrd37MIGtv5QkVp9xAvKy
	HNgczDtAV/gxph8ZozkkI1sXvMin2Cq1Hsx+rTWG5+tMQoM9G/kAlImOMaobHmaH
	qBjpnaHZNQvjzjL7sCx5Y1S37mzj+tEbceRerGclE1AzXn/0mh8zDWdjCzC1OkZ2
	NtBFgaVMHZpwru7C1AQyghKlzAzTVww8KiztIQGc7qfwkrqH5fZ5k81dubd5aql4
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1b6YNNvNewBZ; Thu,  8 Oct 2026 22:42:45 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j14kq5jCvz1XM5kD;
	Thu,  8 Oct 2026 22:42:43 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.garry@linux.dev>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v5 7/8] scsi: scsi_debug: Improve lock context annotations
Date: Thu,  8 Oct 2026 15:42:18 -0700
Message-ID: <e2ddd0bc90e0b5eb0b7eb72c0013d7e2e10be8fe.1791499174.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.170.g584c36229d-goog
In-Reply-To: <cover.1791499174.git.bvanassche@acm.org>
References: <cover.1791499174.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare the scsi_debug driver for enabling compiler-based lock context
analysis:
- Annotate the lock and unlock helper functions with __acquires,
  __releases, __acquires_shared, and __releases_shared.
- Add __acquire() and __release() calls in the paths that do not match
  the __acquires() / __releases() annotations.
- Annotate sdeb_meta_{read,write}_{,un}lock() with __context_unsafe()
  because adding __acquire() and __release() calls in these functions is
  not possible without triggering undefined behavior (taking the address
  of a member of a structure with a NULL pointer as base address).

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 84 +++++++++++++++++++++++----------------
 1 file changed, 50 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 244250ba460b..1ca3a2dc7358 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4052,24 +4052,27 @@ static inline struct sdeb_store_info *devip2sip(s=
truct sdebug_dev_info *devip,
=20
 static inline void
 sdeb_read_lock(rwlock_t *lock)
+	__acquires_shared(lock)
 {
 	if (sdebug_no_rwlock)
-		__acquire(lock);
+		__acquire_shared(lock);
 	else
 		read_lock(lock);
 }
=20
 static inline void
 sdeb_read_unlock(rwlock_t *lock)
+	__releases_shared(lock)
 {
 	if (sdebug_no_rwlock)
-		__release(lock);
+		__release_shared(lock);
 	else
 		read_unlock(lock);
 }
=20
 static inline void
 sdeb_write_lock(rwlock_t *lock)
+	__acquires(lock)
 {
 	if (sdebug_no_rwlock)
 		__acquire(lock);
@@ -4079,6 +4082,7 @@ sdeb_write_lock(rwlock_t *lock)
=20
 static inline void
 sdeb_write_unlock(rwlock_t *lock)
+	__releases(lock)
 {
 	if (sdebug_no_rwlock)
 		__release(lock);
@@ -4088,6 +4092,7 @@ sdeb_write_unlock(rwlock_t *lock)
=20
 static inline void
 sdeb_data_read_lock(struct sdeb_store_info *sip)
+	__acquires_shared(&sip->macc_data_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4096,6 +4101,7 @@ sdeb_data_read_lock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_read_unlock(struct sdeb_store_info *sip)
+	__releases_shared(&sip->macc_data_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4104,6 +4110,7 @@ sdeb_data_read_unlock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_write_lock(struct sdeb_store_info *sip)
+	__acquires(&sip->macc_data_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4112,6 +4119,7 @@ sdeb_data_write_lock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_write_unlock(struct sdeb_store_info *sip)
+	__releases(&sip->macc_data_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4120,6 +4128,7 @@ sdeb_data_write_unlock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_sector_read_lock(struct sdeb_store_info *sip)
+	__acquires_shared(&sip->macc_sector_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4128,6 +4137,7 @@ sdeb_data_sector_read_lock(struct sdeb_store_info *=
sip)
=20
 static inline void
 sdeb_data_sector_read_unlock(struct sdeb_store_info *sip)
+	__releases_shared(&sip->macc_sector_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4136,6 +4146,7 @@ sdeb_data_sector_read_unlock(struct sdeb_store_info=
 *sip)
=20
 static inline void
 sdeb_data_sector_write_lock(struct sdeb_store_info *sip)
+	__acquires(&sip->macc_sector_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4144,6 +4155,7 @@ sdeb_data_sector_write_lock(struct sdeb_store_info =
*sip)
=20
 static inline void
 sdeb_data_sector_write_unlock(struct sdeb_store_info *sip)
+	__releases(&sip->macc_sector_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4165,50 +4177,63 @@ sdeb_data_sector_write_unlock(struct sdeb_store_i=
nfo *sip)
=20
 static inline void
 sdeb_data_lock(struct sdeb_store_info *sip, bool atomic)
+	__acquires(&sip->macc_data_lck)
 {
-	if (atomic)
+	if (atomic) {
 		sdeb_data_write_lock(sip);
-	else
+	} else {
 		sdeb_data_read_lock(sip);
+		__release_shared(&sip->macc_data_lck);
+		__acquire(&sip->macc_data_lck);
+	}
 }
=20
 static inline void
 sdeb_data_unlock(struct sdeb_store_info *sip, bool atomic)
+	__releases(&sip->macc_data_lck)
 {
-	if (atomic)
+	if (atomic) {
 		sdeb_data_write_unlock(sip);
-	else
+	} else {
+		__release(&sip->macc_data_lck);
+		__acquire_shared(&sip->macc_data_lck);
 		sdeb_data_read_unlock(sip);
+	}
 }
=20
 /* Allow many reads but only 1x write per sector */
 static inline void
 sdeb_data_sector_lock(struct sdeb_store_info *sip, bool do_write)
+	__acquires(&sip->macc_sector_lck)
 {
-	if (do_write)
+	if (do_write) {
 		sdeb_data_sector_write_lock(sip);
-	else
+	} else {
 		sdeb_data_sector_read_lock(sip);
+		__release_shared(&sip->macc_sector_lck);
+		__acquire(&sip->macc_sector_lck);
+	}
 }
=20
 static inline void
 sdeb_data_sector_unlock(struct sdeb_store_info *sip, bool do_write)
+	__releases(&sip->macc_sector_lck)
 {
-	if (do_write)
+	if (do_write) {
 		sdeb_data_sector_write_unlock(sip);
-	else
+	} else {
+		__release(&sip->macc_sector_lck);
+		__acquire_shared(&sip->macc_sector_lck);
 		sdeb_data_sector_read_unlock(sip);
+	}
 }
=20
 static inline void
 sdeb_meta_read_lock(struct sdeb_store_info *sip)
+	__acquires_shared(&sip->macc_meta_lck)
+	__context_unsafe(/*conditional locking*/)
 {
-	if (sdebug_no_rwlock) {
-		if (sip)
-			__acquire(&sip->macc_meta_lck);
-		else
-			__acquire(&sdeb_fake_rw_lck);
-	} else {
+	if (!sdebug_no_rwlock) {
 		if (sip)
 			read_lock(&sip->macc_meta_lck);
 		else
@@ -4218,13 +4243,10 @@ sdeb_meta_read_lock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_meta_read_unlock(struct sdeb_store_info *sip)
+	__releases_shared(&sip->macc_meta_lck)
+	__context_unsafe(/*conditional locking*/)
 {
-	if (sdebug_no_rwlock) {
-		if (sip)
-			__release(&sip->macc_meta_lck);
-		else
-			__release(&sdeb_fake_rw_lck);
-	} else {
+	if (!sdebug_no_rwlock) {
 		if (sip)
 			read_unlock(&sip->macc_meta_lck);
 		else
@@ -4234,13 +4256,10 @@ sdeb_meta_read_unlock(struct sdeb_store_info *sip=
)
=20
 static inline void
 sdeb_meta_write_lock(struct sdeb_store_info *sip)
+	__acquires(&sip->macc_meta_lck)
+	__context_unsafe(/*conditional locking*/)
 {
-	if (sdebug_no_rwlock) {
-		if (sip)
-			__acquire(&sip->macc_meta_lck);
-		else
-			__acquire(&sdeb_fake_rw_lck);
-	} else {
+	if (!sdebug_no_rwlock) {
 		if (sip)
 			write_lock(&sip->macc_meta_lck);
 		else
@@ -4250,13 +4269,10 @@ sdeb_meta_write_lock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_meta_write_unlock(struct sdeb_store_info *sip)
+	__releases(&sip->macc_meta_lck)
+	__context_unsafe(/*conditional locking*/)
 {
-	if (sdebug_no_rwlock) {
-		if (sip)
-			__release(&sip->macc_meta_lck);
-		else
-			__release(&sdeb_fake_rw_lck);
-	} else {
+	if (!sdebug_no_rwlock) {
 		if (sip)
 			write_unlock(&sip->macc_meta_lck);
 		else
