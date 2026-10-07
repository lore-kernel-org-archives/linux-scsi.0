Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1737B3BB9FC
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 05:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791349687; cv=none; b=racXqoOJyL2RCFFC1/Rh8tWRwj8VPemBnUDqB2T1WaIsRRHItqKEXmEAuln/G/WwHNV44tUo8Bmtc/lGJUC/GJ3P+TXtwsvUbmWaWUbxYWOJB6xE6nzonRsshcoGasStnEBfcZXwpTFaH08AWaXHzRl+sd2kPwBjX7+5GM81s78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791349687; c=relaxed/simple;
	bh=ApV9JYZ3hUJduc/EyfXQ9M+Ywgu5TsN7gc+VMWNi79o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=genHA7FAPe91o/BMS3LCAO7ByxS6fUHQeu4qUcFmVHk6Lvvk9udcl4J+UIbZTiA4l4iNGLiM5IlYRj/im5sBDscfJCKv8CQTyT4AayW3m3S+3ig5DC+y0MtQhPqUmRBkmCKJNY4s2Z3+9ye0/buwtfY9BFL1F3pZ2HytZ5GmK6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=faUeTPOE; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="faUeTPOE"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j01NP5vJZzlfvpH;
	Wed,  7 Oct 2026 05:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1791349681; x=1793941682; bh=Le6fR
	fVRyKHIF63KJCSXTOGr/vKC7UKqJU+8pJSph5M=; b=faUeTPOE4pwiD4+3jFc8E
	WvbdFHIp4ZKxRkM9ai6DQ4SfLCw8s5AJkZwY8FGIEV5u4cKFHrZOGd+5oZeMpgN2
	u1CUEC1xsewgeoHgzoizzeAL/OXzfNrRcMjl+dWwF3sFXMVKiqnbZl33+k4oDHNp
	2T0aaLp7I+27qYnxTtBhce2lTgnnMzIFK29dHX4E7ERgwZmlywU/Nr+RJz9XGtjI
	WApHC2cebp8A5HJhl6ZY7Cd71EJr8tdrNptJOxvCT+WybnADK7ruVFqlO8yDxHlV
	2IhX1XIPUuJ+n1nRMr4X3jMVW9Fkch28avuzmn9/XNQzIsbx4QEjIzrUx7Qa28GA
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 5UsP-y87A5AP; Wed,  7 Oct 2026 05:08:01 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j01NH5kXQzlfl5T;
	Wed,  7 Oct 2026 05:07:59 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 7/8] scsi: scsi_debug: Improve lock context annotations
Date: Tue,  6 Oct 2026 22:07:29 -0700
Message-ID: <765bf3683555f3d7fbe8510cde1eb50d5f6d0c6f.1791349129.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1791349129.git.bvanassche@acm.org>
References: <cover.1791349129.git.bvanassche@acm.org>
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
index 244250ba460b..2edb70013cbc 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4052,42 +4052,43 @@ static inline struct sdeb_store_info *devip2sip(s=
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
@@ -4096,6 +4097,7 @@ sdeb_data_read_lock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_read_unlock(struct sdeb_store_info *sip)
+	__releases_shared(&sip->macc_data_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4104,6 +4106,7 @@ sdeb_data_read_unlock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_write_lock(struct sdeb_store_info *sip)
+	__acquires(&sip->macc_data_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4112,6 +4115,7 @@ sdeb_data_write_lock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_write_unlock(struct sdeb_store_info *sip)
+	__releases(&sip->macc_data_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4120,6 +4124,7 @@ sdeb_data_write_unlock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_sector_read_lock(struct sdeb_store_info *sip)
+	__acquires_shared(&sip->macc_sector_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4128,6 +4133,7 @@ sdeb_data_sector_read_lock(struct sdeb_store_info *=
sip)
=20
 static inline void
 sdeb_data_sector_read_unlock(struct sdeb_store_info *sip)
+	__releases_shared(&sip->macc_sector_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4136,6 +4142,7 @@ sdeb_data_sector_read_unlock(struct sdeb_store_info=
 *sip)
=20
 static inline void
 sdeb_data_sector_write_lock(struct sdeb_store_info *sip)
+	__acquires(&sip->macc_sector_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4144,6 +4151,7 @@ sdeb_data_sector_write_lock(struct sdeb_store_info =
*sip)
=20
 static inline void
 sdeb_data_sector_write_unlock(struct sdeb_store_info *sip)
+	__releases(&sip->macc_sector_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4165,6 +4173,8 @@ sdeb_data_sector_write_unlock(struct sdeb_store_inf=
o *sip)
=20
 static inline void
 sdeb_data_lock(struct sdeb_store_info *sip, bool atomic)
+	__acquires(&sip->macc_data_lck)
+	__context_unsafe(/*conditional locking*/)
 {
 	if (atomic)
 		sdeb_data_write_lock(sip);
@@ -4174,6 +4184,8 @@ sdeb_data_lock(struct sdeb_store_info *sip, bool at=
omic)
=20
 static inline void
 sdeb_data_unlock(struct sdeb_store_info *sip, bool atomic)
+	__releases(&sip->macc_data_lck)
+	__context_unsafe(/*conditional locking*/)
 {
 	if (atomic)
 		sdeb_data_write_unlock(sip);
@@ -4184,6 +4196,8 @@ sdeb_data_unlock(struct sdeb_store_info *sip, bool =
atomic)
 /* Allow many reads but only 1x write per sector */
 static inline void
 sdeb_data_sector_lock(struct sdeb_store_info *sip, bool do_write)
+	__acquires(&sip->macc_sector_lck)
+	__context_unsafe(/*conditional locking*/)
 {
 	if (do_write)
 		sdeb_data_sector_write_lock(sip);
@@ -4193,6 +4207,8 @@ sdeb_data_sector_lock(struct sdeb_store_info *sip, =
bool do_write)
=20
 static inline void
 sdeb_data_sector_unlock(struct sdeb_store_info *sip, bool do_write)
+	__releases(&sip->macc_sector_lck)
+	__context_unsafe(/*conditional locking*/)
 {
 	if (do_write)
 		sdeb_data_sector_write_unlock(sip);
@@ -4202,13 +4218,10 @@ sdeb_data_sector_unlock(struct sdeb_store_info *s=
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
@@ -4218,13 +4231,10 @@ sdeb_meta_read_lock(struct sdeb_store_info *sip)
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
@@ -4234,13 +4244,10 @@ sdeb_meta_read_unlock(struct sdeb_store_info *sip=
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
@@ -4250,13 +4257,10 @@ sdeb_meta_write_lock(struct sdeb_store_info *sip)
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
