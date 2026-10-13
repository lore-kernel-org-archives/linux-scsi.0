Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB23560AB3
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 22:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791929437; cv=none; b=M/WzPEc8xiQGbL1CfJXoumc8y5W0rFEzyDwWUx4Xjd67X2a3vOl7JIohKl4KX85voJwnejRidSRROQymks4XcIxwmjnJ8I2x1ERIVe2h+WNBMFV1D6TeEo7ScX/YGjcnm2fLQgdEdaqD4fog/7ETLU9baw+MegyDu14zZddMAJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791929437; c=relaxed/simple;
	bh=Qm27qbJdZflw7ppu2nZoqw2j3rVeqe+0ibEeLZpt1Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iO4q4+HemrHttWMUw04+JnSIQNrs/m74krVVxU87jYqEmfET8Ykl01bKZNEylEyUbbowGqhBtnnLrbkT//JlO4IumIhRivrUO+4hzxBy0sBm85OF/ZKaAUhaTutVX2NvpfqR1Fc2YIyxI/OZ5b1bbafOYS1pXVfNbtFt1RGGmgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Rm7+ps3E; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Rm7+ps3E"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j47nQ5p1qzlfvq1;
	Tue, 13 Oct 2026 22:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1791929429; x=1794521430; bh=GyVV8
	RGpaexBqnF9eCz7YIhuYw86ztQP0cHfE6MO0EI=; b=Rm7+ps3ESkKUAa/6F6ADY
	KphLNl0q+w9+oNJtj1kmJ0Q7uzKDcTbt3dx68JM9v2rZ2xoKdwslVid2tUDR/1wz
	Y9yPyx5OCP/teybmY+sLIMdTegfbI3INMJfeWfmmicj+9NN59gPg7MN0dwArJu70
	8wfhUeL0FUa/TbN9AU6zI+qOEACtuf8enxQS3zYy6fygszU5n5wpyVrF1D+MDZXC
	svEbkrx+oV8GvifvrvZw3qDDY9XqnjrwHhtdqCXhdFNIDjDoLkoMMup1vTvuEz15
	zNvDwwHq2vFccFC5Wnaw7tgbYdyjchXSwM085YGs4jxXS5TkCRIug02PVZAUyGSL
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id veoT84Z_Dh1r; Tue, 13 Oct 2026 22:10:29 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j47nG02rgzlfvq6;
	Tue, 13 Oct 2026 22:10:25 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.garry@linux.dev>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v6 7/8] scsi: scsi_debug: Improve lock context annotations
Date: Tue, 13 Oct 2026 15:10:08 -0700
Message-ID: <1775809e31b535cc42f3f79e75f28666e74a98f7.1791924924.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <cover.1791924924.git.bvanassche@acm.org>
References: <cover.1791924924.git.bvanassche@acm.org>
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
 drivers/scsi/scsi_debug.c | 108 ++++++++++++++++++++++++--------------
 1 file changed, 70 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index cfe6bd154e8d..a922c8318a2f 100644
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
@@ -4165,50 +4177,67 @@ sdeb_data_sector_write_unlock(struct sdeb_store_i=
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
-{
-	if (sdebug_no_rwlock) {
-		if (sip)
-			__acquire(&sip->macc_meta_lck);
-		else
-			__acquire(&sdeb_fake_rw_lck);
-	} else {
+	__acquires_shared(&sip->macc_meta_lck)
+	__context_unsafe(/*
+			  * Can't be annotated with
+			  * __{acquire,release}(,_shared}() without triggering
+			  * undefined behavior.
+			  */)
+{
+	if (!sdebug_no_rwlock) {
 		if (sip)
 			read_lock(&sip->macc_meta_lck);
 		else
@@ -4218,13 +4247,14 @@ sdeb_meta_read_lock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_meta_read_unlock(struct sdeb_store_info *sip)
-{
-	if (sdebug_no_rwlock) {
-		if (sip)
-			__release(&sip->macc_meta_lck);
-		else
-			__release(&sdeb_fake_rw_lck);
-	} else {
+	__releases_shared(&sip->macc_meta_lck)
+	__context_unsafe(/*
+			  * Can't be annotated with
+			  * __{acquire,release}(,_shared}() without triggering
+			  * undefined behavior.
+			  */)
+{
+	if (!sdebug_no_rwlock) {
 		if (sip)
 			read_unlock(&sip->macc_meta_lck);
 		else
@@ -4234,13 +4264,14 @@ sdeb_meta_read_unlock(struct sdeb_store_info *sip=
)
=20
 static inline void
 sdeb_meta_write_lock(struct sdeb_store_info *sip)
-{
-	if (sdebug_no_rwlock) {
-		if (sip)
-			__acquire(&sip->macc_meta_lck);
-		else
-			__acquire(&sdeb_fake_rw_lck);
-	} else {
+	__acquires(&sip->macc_meta_lck)
+	__context_unsafe(/*
+			  * Can't be annotated with
+			  * __{acquire,release}(,_shared}() without triggering
+			  * undefined behavior.
+			  */)
+{
+	if (!sdebug_no_rwlock) {
 		if (sip)
 			write_lock(&sip->macc_meta_lck);
 		else
@@ -4250,13 +4281,14 @@ sdeb_meta_write_lock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_meta_write_unlock(struct sdeb_store_info *sip)
-{
-	if (sdebug_no_rwlock) {
-		if (sip)
-			__release(&sip->macc_meta_lck);
-		else
-			__release(&sdeb_fake_rw_lck);
-	} else {
+	__releases(&sip->macc_meta_lck)
+	__context_unsafe(/*
+			  * Can't be annotated with
+			  * __{acquire,release}(,_shared}() without triggering
+			  * undefined behavior.
+			  */)
+{
+	if (!sdebug_no_rwlock) {
 		if (sip)
 			write_unlock(&sip->macc_meta_lck);
 		else
