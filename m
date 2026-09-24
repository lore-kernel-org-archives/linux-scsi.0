Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3702E428475
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 22:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790290514; cv=none; b=LVxJ5DqChnfqQ4aN62bFRhgI+7HyJIYPhBIZCY/XgM5hAdwwHWFKRHDUasAmqW4K0yl0ciJRGmFlVtqBNsNZvNibwOyXIuRji2S4qmTohqpgLEgPdSlEScFIbnmyIe6CQcOva9DtsW2zTEsnOdAExZlEfR8ZkjI5vZeb+RmITAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790290514; c=relaxed/simple;
	bh=hbwVDdI6iDtkpowOkUZbMTrIM76Xx+JJFfXXrH9BRDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JF9EzfLliaRmXPmh5Vpvbeu2ejgSNf0d5BCyk2D3aBylwW0pe/CUZV6SltcpQEAcMYNRwjGbOk8JHAd5CRBVHkQ8ww/eXP8mxjnfKNRGmlFltAa3T1TUqfs4ke/gABXi/GknFUwc4OJJKFVOBVRL9u/MAg+jXGdXJ0SiDTuD9c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=f64uint5; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="f64uint5"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hrTgh5PfjzlfvpN;
	Thu, 24 Sep 2026 22:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790290506; x=1792882507; bh=2DiuO
	FQBMvIEYaZmRNWf6KrMB9/UO3gNLJIcOpA9cz8=; b=f64uint5lCg4wnaFq1Tkc
	AExPaN5pNSmPx0ROYvzJbGj8P0gZd45F2c1pF603lttIfqdkVsQVJrEG7S+GFWof
	fVfn2neM3rWrGUK4UbhLx3qCp6IFmtKvoPR5ZYSrFA6UzxtcABTfkLzhV8eKDgSa
	dM4ETnkCLwWPPHk6I4/o1QsfH6bGaAIWzti1lqLtQXMXeKKmKS0U44GwZl2bTF9R
	EkgKcdKdM8HQJgI/mJzegTtckSMQrxuJkdpaIawDJlNQa0V2VZ76s5x1qNpn0/zl
	U57TRfniftrSFD47G7oITLin0iFocIJIVCpvJNKg5/vanA329E1uxZOEMFEbx3oQ
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id yLM39gmCTgl0; Thu, 24 Sep 2026 22:55:06 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hrTgY1qbHzlfvpG;
	Thu, 24 Sep 2026 22:55:04 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 6/7] scsi: scsi_debug: Improve lock context annotations
Date: Thu, 24 Sep 2026 15:54:42 -0700
Message-ID: <68c72eed87c663b4b99f63af71971c718166d3c8.1790290090.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790290089.git.bvanassche@acm.org>
References: <cover.1790290089.git.bvanassche@acm.org>
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
index 229f35262382..4329a0c4e137 100644
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
