Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDCA35C19B
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 23:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790724221; cv=none; b=kaJACyCsP+u8Fwd/TuOFfj8woXPTc/4tWKCin6axVDiuiwQ7g0+iErDH+a5Wy9ShiUpmMl8BVtZyHBTspExvmzlbkTu39rdVX9q8/DTNmlCB1GIATNnD9KRbSKcRnVzzHjUIA7kUDkwyKLTShPHRfPZSj5IA0l75EMJhNeRsa+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790724221; c=relaxed/simple;
	bh=EJNOyrk8aJGBYu0YVOfXbhN9AC0S4UfqpRGXfU7zhJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iOtBEb5SS6UQi75VUxlnNyvLE0V66bxaNrgVpi8HKvCL9AbbMvAEuIryFhyr9P9Eha3j6JcDrLNn5TdnFObHZp4bL+r6UhNjVLOJCNe+ER5xGEAxU8c5nZNQj1jL05Fn2F1EQVA1pgL90vHfMN+qkwTqUV7x+rYSc+Gc3ibC5yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=T4ezZtaH; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="T4ezZtaH"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hvZ4C6BRmz1XM4Sx;
	Tue, 29 Sep 2026 23:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790724213; x=1793316214; bh=g/lca
	JYdGi9R1NDVpBzEUCghHh44SZ8bvEVDY8TgLZ0=; b=T4ezZtaHMAdsTl/QCchXl
	/vDMAIC3qBxst5851CAqDaiUphpxNmHcdxspPpRBDCk9gGkil9tToi5seHWnRbqA
	23cboKhsSQtZ6XzHiL2ac2wpqDD4tJZF7PFMA6NJlU6alv0PMn5Wh04oNb80jv6e
	penPfU7ANz6X7NOic4YYHBvQcpjp4SEeNEeNkNE+2ez2ZOVbd3sA0ptWqK/JtqS7
	FkZdUub8FtRiCBL+8/cIEHSKQrf3lWs76UAHjK/M0d174xWxPWmV3ex8UQYvJ3Gj
	I6P461qCivnCxY87z5bgxqnX9PCVvorszGJxW5SogpOr89i8N6Hbj8f9YUiFcDVf
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9RF31xETV7ns; Tue, 29 Sep 2026 23:23:33 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hvZ442wG6z1XM30g;
	Tue, 29 Sep 2026 23:23:32 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v3 6/7] scsi: scsi_debug: Improve lock context annotations
Date: Tue, 29 Sep 2026 16:23:02 -0700
Message-ID: <c0546935640ceffd1b0513753dd469833e767c5e.1790723966.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790723966.git.bvanassche@acm.org>
References: <cover.1790723966.git.bvanassche@acm.org>
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

- Remove sparse __acquire() and __release() calls from the helper
  functions since these mislead the lock context analyzer.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 76 ++++++++++++++++++++-------------------
 1 file changed, 40 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 44840ba0c5b5..a6cd95885541 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4042,42 +4042,43 @@ static inline struct sdeb_store_info *devip2sip(s=
truct sdebug_dev_info *devip,
=20
 static inline void
 sdeb_read_lock(rwlock_t *lock)
+	__acquires_shared(lock)
+	__context_unsafe(/*conditional locking*/)
 {
-	if (sdebug_no_rwlock)
-		__acquire(lock);
-	else
+	if (!sdebug_no_rwlock)
 		read_lock(lock);
 }
=20
 static inline void
 sdeb_read_unlock(rwlock_t *lock)
+	__releases_shared(lock)
+	__context_unsafe(/*conditional locking*/)
 {
-	if (sdebug_no_rwlock)
-		__release(lock);
-	else
+	if (!sdebug_no_rwlock)
 		read_unlock(lock);
 }
=20
 static inline void
 sdeb_write_lock(rwlock_t *lock)
+	__acquires(lock)
+	__context_unsafe(/*conditional locking*/)
 {
-	if (sdebug_no_rwlock)
-		__acquire(lock);
-	else
+	if (!sdebug_no_rwlock)
 		write_lock(lock);
 }
=20
 static inline void
 sdeb_write_unlock(rwlock_t *lock)
+	__releases(lock)
+	__context_unsafe(/*conditional locking*/)
 {
-	if (sdebug_no_rwlock)
-		__release(lock);
-	else
+	if (!sdebug_no_rwlock)
 		write_unlock(lock);
 }
=20
 static inline void
 sdeb_data_read_lock(struct sdeb_store_info *sip)
+	__acquires_shared(&sip->macc_data_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4086,6 +4087,7 @@ sdeb_data_read_lock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_read_unlock(struct sdeb_store_info *sip)
+	__releases_shared(&sip->macc_data_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4094,6 +4096,7 @@ sdeb_data_read_unlock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_write_lock(struct sdeb_store_info *sip)
+	__acquires(&sip->macc_data_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4102,6 +4105,7 @@ sdeb_data_write_lock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_write_unlock(struct sdeb_store_info *sip)
+	__releases(&sip->macc_data_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4110,6 +4114,7 @@ sdeb_data_write_unlock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_sector_read_lock(struct sdeb_store_info *sip)
+	__acquires_shared(&sip->macc_sector_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4118,6 +4123,7 @@ sdeb_data_sector_read_lock(struct sdeb_store_info *=
sip)
=20
 static inline void
 sdeb_data_sector_read_unlock(struct sdeb_store_info *sip)
+	__releases_shared(&sip->macc_sector_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4126,6 +4132,7 @@ sdeb_data_sector_read_unlock(struct sdeb_store_info=
 *sip)
=20
 static inline void
 sdeb_data_sector_write_lock(struct sdeb_store_info *sip)
+	__acquires(&sip->macc_sector_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4134,6 +4141,7 @@ sdeb_data_sector_write_lock(struct sdeb_store_info =
*sip)
=20
 static inline void
 sdeb_data_sector_write_unlock(struct sdeb_store_info *sip)
+	__releases(&sip->macc_sector_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4155,6 +4163,8 @@ sdeb_data_sector_write_unlock(struct sdeb_store_inf=
o *sip)
=20
 static inline void
 sdeb_data_lock(struct sdeb_store_info *sip, bool atomic)
+	__acquires(&sip->macc_data_lck)
+	__context_unsafe(/*conditional locking*/)
 {
 	if (atomic)
 		sdeb_data_write_lock(sip);
@@ -4164,6 +4174,8 @@ sdeb_data_lock(struct sdeb_store_info *sip, bool at=
omic)
=20
 static inline void
 sdeb_data_unlock(struct sdeb_store_info *sip, bool atomic)
+	__releases(&sip->macc_data_lck)
+	__context_unsafe(/*conditional locking*/)
 {
 	if (atomic)
 		sdeb_data_write_unlock(sip);
@@ -4174,6 +4186,8 @@ sdeb_data_unlock(struct sdeb_store_info *sip, bool =
atomic)
 /* Allow many reads but only 1x write per sector */
 static inline void
 sdeb_data_sector_lock(struct sdeb_store_info *sip, bool do_write)
+	__acquires(&sip->macc_sector_lck)
+	__context_unsafe(/*conditional locking*/)
 {
 	if (do_write)
 		sdeb_data_sector_write_lock(sip);
@@ -4183,6 +4197,8 @@ sdeb_data_sector_lock(struct sdeb_store_info *sip, =
bool do_write)
=20
 static inline void
 sdeb_data_sector_unlock(struct sdeb_store_info *sip, bool do_write)
+	__releases(&sip->macc_sector_lck)
+	__context_unsafe(/*conditional locking*/)
 {
 	if (do_write)
 		sdeb_data_sector_write_unlock(sip);
@@ -4192,13 +4208,10 @@ sdeb_data_sector_unlock(struct sdeb_store_info *s=
ip, bool do_write)
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
@@ -4208,13 +4221,10 @@ sdeb_meta_read_lock(struct sdeb_store_info *sip)
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
@@ -4224,13 +4234,10 @@ sdeb_meta_read_unlock(struct sdeb_store_info *sip=
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
@@ -4240,13 +4247,10 @@ sdeb_meta_write_lock(struct sdeb_store_info *sip)
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
