Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF1A5326AD
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 23:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790119659; cv=none; b=cGfi33QmksXp9XAQ5CjFEQbzc/R+XN83WZcyHS0+2zOqVhAySFbv5N26k/XYI91ljvcl8pA30mptcMuQalyEKZycLD3opdEDfLVu8Ob4aMtzIQLTilqk0mvO9+yFUcvmLEVEq0aKSR3dKVl75jCG7KMg1ouViLkDCvxmWYWCC6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790119659; c=relaxed/simple;
	bh=0xthHKlDayMlXq5HzaadhOeETMTUHM4yZiL/mZ5k5WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Affl0vVT1z1ZifocWkaAVZBpsmv593jkK3BDfD84LHRl2efMxtcIhuy1FTXBqTtWmVYYUrqbI1EzJqNLzwOEstFxNkHPTv9T1xoWXjAaxU5KVR1MyP4iuA2Jsf18SdCjXRfoUatOZF4tBJdWfvtYSmYQcp+Hnp8OtADBzcCfZXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=a78GAxGn; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="a78GAxGn"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hqGTG6YZkzlfvpH;
	Tue, 22 Sep 2026 23:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790119613; x=1792711614; bh=7DnGP
	2TmNCLrYy9WHm0Pa/13pVTzAqLPa93T8sZnUKw=; b=a78GAxGnrJlznysImaGIZ
	vjE/1oLqHNo6SC6G0BnbdbfRlByzfhkR+2PNaAihmQKxBfZCXMtEK6zOH5rL349v
	Fkn0OFwd8wedaWOksuVqPHy64r5qWXQ2JCRLs6hUquLXbm1UKgKDA/yAE+9E1IFi
	OTOx+HlervTrXq606z+YhjSNlcn69qqltL0a+HDWKKmncMvQWPqKTmzKyCDctbEj
	50Mu8TbUughT/dFipo/rMo9iBnf84wPnDBKwPEm0AXL3FJxPkTOJI1Cz1+1WonaS
	UjF74VbcWAGUGIcdr0ZSO1toyjZrMGOtHIoD8AprrHkbgAIDLiBryLur8+7tkRT9
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id c6Pd7p6ucj5R; Tue, 22 Sep 2026 23:26:53 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hqGT733MVzlfvpG;
	Tue, 22 Sep 2026 23:26:51 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 6/7] scsi: scsi_debug: Improve lock context annotations
Date: Tue, 22 Sep 2026 16:26:26 -0700
Message-ID: <06a3167ff74552c2d6877908039cc5023adeb49f.1790119506.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <cover.1790119506.git.bvanassche@acm.org>
References: <cover.1790119506.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare the scsi_debug driver for enabling compiler-based lock context
analysis:

- Define context lock structures __ctx_lock_data, __ctx_lock_sector, and
  __ctx_lock_meta, and embed them in struct sdeb_store_info so that data,
  sector, and metadata locking operations can be tracked as context locks=
.

- Annotate the lock and unlock helper functions with __acquires,
  __releases, __acquires_shared, and __releases_shared.

- Mark helper functions that perform conditional locking based on
  parameters (such as atomic or do_write) or configuration
  (sdebug_no_rwlock) with __context_unsafe(conditional locking).

- Remove sparse __acquire() and __release() calls from the helper
  functions when sdebug_no_rwlock is true since these mislead the lock
  context analyzer.

- Wrap the conditional metadata locking sections in resp_read_dt0() and
  resp_write_dt0() with context_unsafe().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 84 ++++++++++++++++++++++-----------------
 1 file changed, 48 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index ed30b3950c4e..ccaaf13cc243 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -382,11 +382,18 @@ struct sdebug_host_info {
 	struct list_head dev_info_list;
 };
=20
+context_lock_struct(__ctx_lock_data) {};
+context_lock_struct(__ctx_lock_sector) {};
+context_lock_struct(__ctx_lock_meta) {};
+
 /* There is an xarray of pointers to this struct's objects, one per host=
 */
 struct sdeb_store_info {
 	rwlock_t macc_data_lck;	/* for media data access on this store */
 	rwlock_t macc_meta_lck;	/* for atomic media meta access on this store *=
/
 	rwlock_t macc_sector_lck;	/* per-sector media data access on this store=
 */
+	struct __ctx_lock_data data_lck;
+	struct __ctx_lock_sector sector_lck;
+	struct __ctx_lock_meta meta_lck;
 	u8 *storep;		/* user data storage (ram) */
 	struct t10_pi_tuple *dif_storep; /* protection info */
 	void *map_storep;	/* provisioning map */
@@ -4042,42 +4049,44 @@ static inline struct sdeb_store_info *devip2sip(s=
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
+	__context_unsafe(/*conditional locking*/)
 {
 	BUG_ON(!sip);
=20
@@ -4086,6 +4095,7 @@ sdeb_data_read_lock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_read_unlock(struct sdeb_store_info *sip)
+	__releases_shared(&sip->macc_data_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4094,6 +4104,7 @@ sdeb_data_read_unlock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_write_lock(struct sdeb_store_info *sip)
+	__acquires(&sip->macc_data_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4102,6 +4113,7 @@ sdeb_data_write_lock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_write_unlock(struct sdeb_store_info *sip)
+	__releases(&sip->macc_data_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4110,6 +4122,7 @@ sdeb_data_write_unlock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_sector_read_lock(struct sdeb_store_info *sip)
+	__acquires_shared(&sip->macc_sector_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4118,6 +4131,7 @@ sdeb_data_sector_read_lock(struct sdeb_store_info *=
sip)
=20
 static inline void
 sdeb_data_sector_read_unlock(struct sdeb_store_info *sip)
+	__releases_shared(&sip->macc_sector_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4126,6 +4140,7 @@ sdeb_data_sector_read_unlock(struct sdeb_store_info=
 *sip)
=20
 static inline void
 sdeb_data_sector_write_lock(struct sdeb_store_info *sip)
+	__acquires(&sip->macc_sector_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4134,6 +4149,7 @@ sdeb_data_sector_write_lock(struct sdeb_store_info =
*sip)
=20
 static inline void
 sdeb_data_sector_write_unlock(struct sdeb_store_info *sip)
+	__releases(&sip->macc_sector_lck)
 {
 	BUG_ON(!sip);
=20
@@ -4155,6 +4171,8 @@ sdeb_data_sector_write_unlock(struct sdeb_store_inf=
o *sip)
=20
 static inline void
 sdeb_data_lock(struct sdeb_store_info *sip, bool atomic)
+	__acquires(&sip->data_lck)
+	__context_unsafe(/*conditional locking*/)
 {
 	if (atomic)
 		sdeb_data_write_lock(sip);
@@ -4164,6 +4182,8 @@ sdeb_data_lock(struct sdeb_store_info *sip, bool at=
omic)
=20
 static inline void
 sdeb_data_unlock(struct sdeb_store_info *sip, bool atomic)
+	__releases(&sip->data_lck)
+	__context_unsafe(/*conditional locking*/)
 {
 	if (atomic)
 		sdeb_data_write_unlock(sip);
@@ -4174,6 +4194,8 @@ sdeb_data_unlock(struct sdeb_store_info *sip, bool =
atomic)
 /* Allow many reads but only 1x write per sector */
 static inline void
 sdeb_data_sector_lock(struct sdeb_store_info *sip, bool do_write)
+	__acquires(&sip->sector_lck)
+	__context_unsafe(/*conditional locking*/)
 {
 	if (do_write)
 		sdeb_data_sector_write_lock(sip);
@@ -4183,6 +4205,8 @@ sdeb_data_sector_lock(struct sdeb_store_info *sip, =
bool do_write)
=20
 static inline void
 sdeb_data_sector_unlock(struct sdeb_store_info *sip, bool do_write)
+	__releases(&sip->sector_lck)
+	__context_unsafe(/*conditional locking*/)
 {
 	if (do_write)
 		sdeb_data_sector_write_unlock(sip);
@@ -4192,13 +4216,10 @@ sdeb_data_sector_unlock(struct sdeb_store_info *s=
ip, bool do_write)
=20
 static inline void
 sdeb_meta_read_lock(struct sdeb_store_info *sip)
+	__acquires_shared(&sip->meta_lck)
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
@@ -4208,13 +4229,10 @@ sdeb_meta_read_lock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_meta_read_unlock(struct sdeb_store_info *sip)
+	__releases_shared(&sip->meta_lck)
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
@@ -4224,13 +4242,10 @@ sdeb_meta_read_unlock(struct sdeb_store_info *sip=
)
=20
 static inline void
 sdeb_meta_write_lock(struct sdeb_store_info *sip)
+	__acquires(&sip->meta_lck)
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
@@ -4240,13 +4255,10 @@ sdeb_meta_write_lock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_meta_write_unlock(struct sdeb_store_info *sip)
+	__releases(&sip->meta_lck)
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
