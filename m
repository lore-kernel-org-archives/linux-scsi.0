Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8755B3CCFD4
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451631; cv=none; b=RdeG2YjuaD6fYrr5HuYcVgRkqhcE2t5JmByBu9abvik2y+uGZNUg/bGe/hiHYzpKLatVOk64rOWUxo0YvTHRhFCgWsFV6Z+xY3RhaLG5x5fpt+j1hTK7UPs+ytdAdD+CecSCKf5s7+jQ8uqRbRxNUlVja5kiNLTDETb/YEM6hpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451631; c=relaxed/simple;
	bh=FJ7DG90H/sT8bQocvwssxouw5krKvabVDW7XOQiYqrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ul6+JPOYpRxmyywSe3VhgYuvFWI0L4Hzh7EKbHfDeIY0rioxCiTGzcbcUBXc2Fupk1jYpnd+yKJdtRXVmt6HUIiKAaiOePR7+jKyhQzI1GIbFf2kQCUkk65N4Mgkl2FzuxvMgucYNRFZ9qAWINKTN8dPk+zGdHZQz0Ne9u8+aSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=YDLJxhYt; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="YDLJxhYt"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB48G0MR0z1XM30k;
	Thu, 30 Jul 2026 22:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451623; x=1788043624; bh=R6GK/
	xJVDneFGaFRWGOuXUIsnVPUSc8YdyYpfBuXhmc=; b=YDLJxhYt6SYorZNul2h2+
	n3fchEVSk2Ede6EH/+7msFZzW+wRtkWLS5Gac1kDpLxiu8yUSnQfMrF/dwoXwszt
	Zv1WdyOCpcmmJ9KtG8rnR8PsmVZ7X0USJh+y1m/TTrcGElAUW2gvG+u+zceBL7fJ
	DPIscTvvwgyLSkZQhHEVYhEVsr/gEJz87HE7v12uUSUF8sGAdAMW3RgfBW56eaeq
	L712PR7SmTG2D+S11LbVWjbQVMqra51ck3RqQJw0md5E9cEAIiAm11j8QlfiydKF
	BKmEwQQZtK3WQ5Kgjb+ptSxr2ScvIdSuC+UbxeTtnL5OkM+JY5bXYnsn2i2u8bRm
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9p-5yTiJjSP9; Thu, 30 Jul 2026 22:47:03 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB4840lmnz1XM30r;
	Thu, 30 Jul 2026 22:46:59 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH v3 02/57] scsi: scsi_debug: Prepare for enabling lock context analysis
Date: Thu, 30 Jul 2026 15:44:45 -0700
Message-ID: <02c833ea2e87c7fd3f2a8490f302cfa7383647a4.1785451174.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <cover.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Suppress lock context analysis for the functions that perform conditional
locking to prevent that the Clang thread-safety analyzer complains about
these functions. Remove incorrect __acquire() and __release() annotations=
.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 65 +++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 9d1c9c41d0f9..d88164d5f409 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4006,42 +4006,39 @@ static inline struct sdeb_store_info *devip2sip(s=
truct sdebug_dev_info *devip,
=20
 static inline void
 sdeb_read_lock(rwlock_t *lock)
+	__context_unsafe(conditional locking)
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
+	__context_unsafe(conditional locking)
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
+	__context_unsafe(conditional locking)
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
+	__context_unsafe(conditional locking)
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
+	__context_unsafe(conditional locking)
 {
 	BUG_ON(!sip);
=20
@@ -4050,6 +4047,7 @@ sdeb_data_read_lock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_read_unlock(struct sdeb_store_info *sip)
+	__context_unsafe(conditional locking)
 {
 	BUG_ON(!sip);
=20
@@ -4058,6 +4056,7 @@ sdeb_data_read_unlock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_write_lock(struct sdeb_store_info *sip)
+	__context_unsafe(conditional locking)
 {
 	BUG_ON(!sip);
=20
@@ -4066,6 +4065,7 @@ sdeb_data_write_lock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_write_unlock(struct sdeb_store_info *sip)
+	__context_unsafe(conditional locking)
 {
 	BUG_ON(!sip);
=20
@@ -4074,6 +4074,7 @@ sdeb_data_write_unlock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_sector_read_lock(struct sdeb_store_info *sip)
+	__context_unsafe(conditional locking)
 {
 	BUG_ON(!sip);
=20
@@ -4082,6 +4083,7 @@ sdeb_data_sector_read_lock(struct sdeb_store_info *=
sip)
=20
 static inline void
 sdeb_data_sector_read_unlock(struct sdeb_store_info *sip)
+	__context_unsafe(conditional locking)
 {
 	BUG_ON(!sip);
=20
@@ -4090,6 +4092,7 @@ sdeb_data_sector_read_unlock(struct sdeb_store_info=
 *sip)
=20
 static inline void
 sdeb_data_sector_write_lock(struct sdeb_store_info *sip)
+	__context_unsafe(conditional locking)
 {
 	BUG_ON(!sip);
=20
@@ -4098,6 +4101,7 @@ sdeb_data_sector_write_lock(struct sdeb_store_info =
*sip)
=20
 static inline void
 sdeb_data_sector_write_unlock(struct sdeb_store_info *sip)
+	__context_unsafe(conditional locking)
 {
 	BUG_ON(!sip);
=20
@@ -4119,6 +4123,7 @@ sdeb_data_sector_write_unlock(struct sdeb_store_inf=
o *sip)
=20
 static inline void
 sdeb_data_lock(struct sdeb_store_info *sip, bool atomic)
+	__context_unsafe(conditional locking)
 {
 	if (atomic)
 		sdeb_data_write_lock(sip);
@@ -4128,6 +4133,7 @@ sdeb_data_lock(struct sdeb_store_info *sip, bool at=
omic)
=20
 static inline void
 sdeb_data_unlock(struct sdeb_store_info *sip, bool atomic)
+	__context_unsafe(conditional locking)
 {
 	if (atomic)
 		sdeb_data_write_unlock(sip);
@@ -4138,6 +4144,7 @@ sdeb_data_unlock(struct sdeb_store_info *sip, bool =
atomic)
 /* Allow many reads but only 1x write per sector */
 static inline void
 sdeb_data_sector_lock(struct sdeb_store_info *sip, bool do_write)
+	__context_unsafe(conditional locking)
 {
 	if (do_write)
 		sdeb_data_sector_write_lock(sip);
@@ -4147,6 +4154,7 @@ sdeb_data_sector_lock(struct sdeb_store_info *sip, =
bool do_write)
=20
 static inline void
 sdeb_data_sector_unlock(struct sdeb_store_info *sip, bool do_write)
+	__context_unsafe(conditional locking)
 {
 	if (do_write)
 		sdeb_data_sector_write_unlock(sip);
@@ -4156,13 +4164,9 @@ sdeb_data_sector_unlock(struct sdeb_store_info *si=
p, bool do_write)
=20
 static inline void
 sdeb_meta_read_lock(struct sdeb_store_info *sip)
+	__context_unsafe(conditional locking)
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
@@ -4172,13 +4176,9 @@ sdeb_meta_read_lock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_meta_read_unlock(struct sdeb_store_info *sip)
+	__context_unsafe(conditional locking)
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
@@ -4188,13 +4188,9 @@ sdeb_meta_read_unlock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_meta_write_lock(struct sdeb_store_info *sip)
+	__context_unsafe(conditional locking)
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
@@ -4204,13 +4200,9 @@ sdeb_meta_write_lock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_meta_write_unlock(struct sdeb_store_info *sip)
+	__context_unsafe(conditional locking)
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
@@ -5239,6 +5231,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
=20
 static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 			   u32 ei_lba, bool unmap, bool ndob)
+	__context_unsafe(conditional locking)
 {
 	struct scsi_device *sdp =3D scp->device;
 	struct sdebug_dev_info *devip =3D (struct sdebug_dev_info *)sdp->hostda=
ta;
