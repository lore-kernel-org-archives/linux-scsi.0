Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8753439DBFD
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573319; cv=none; b=buEEi6uja8K0cvpFe1YmNgzwQVbtI+jTjeh7We+RdjSdg2rno45j5/VpZOYRApbc7aeR9ddScvvk8vd+WyVTb0cIFYmjEMf9zLvGAMOaspXWPMKvwvqFnZr/IXUC2VfxrKyVMOQX6GIrqMpEJBi758SATPsPb+nxNBB12zHXzuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573319; c=relaxed/simple;
	bh=BEFUE0wd/WCxzB9FTZXAjc7Dl2hHt3xBN5fuTCl02tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzQeZvllD/+jHXpX+uZ9lxQ/+ijrNKd2K7cSArv5AB3gB/91zPBrd/PmYlQq3kgJIkrE/JWBx1nT84YnyJEP7xvYUH4W8uuTavldWcVSkyDDZufeeI8YLgkldv5xR64AlL9tRUMKPaRWHICeww7Wup9zaMh1aIHVHQ+SMU3KorY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=poh61nGP; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="poh61nGP"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62ZG2GR8zm1W1H;
	Thu, 30 Apr 2026 18:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573313; x=1780165314; bh=nDJRf
	aKA54k8d0M4ZfC/0SXueKHEa03dY0m/vRSkOXg=; b=poh61nGPktYtHfF3UTtRw
	QwFtH1Ww00T+hll/L9DUNt4kpA5q8r6Wd7vC4GCkdey2ki97utpjW/uIUxfbpzEh
	jdgvY9LBfdezWAJMLApSwfNXaEK20P8K3sPrEOMM0R4GN28uITOuot9KxyFQ26na
	PEIPfO2IWkoZM/DDl7vhQBsu4yv23bDV25LqdOMwLKOWl2qYwkUvOr2LecJItJt9
	rFX8NmB0rurue3nFvWyCDHA5tzf/niASxwz2+LDPjcF+O1U4uLyPyBzw0hf+VsD1
	Mykr9OsEARkYyK1QxHGuM/72OZPcCX7GtvnpKcOCsgRgTT3GOIO/Mc6P0oKeJ4rV
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id tJNFhJ3fKHI0; Thu, 30 Apr 2026 18:21:53 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62Z74KNJzm1W1f;
	Thu, 30 Apr 2026 18:21:51 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH v2 02/56] scsi: scsi_debug: Prepare for enabling lock context analysis
Date: Thu, 30 Apr 2026 11:19:32 -0700
Message-ID: <20260430182130.1978347-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260430182130.1978347-1-bvanassche@acm.org>
References: <20260430182130.1978347-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Suppress lock context analysis for the functions that perform conditional
locking to prevent that the Clang thread-safety analyzer complains about
these functions.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1515495fd9ea..c4a1582ab1fa 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4014,6 +4014,7 @@ static inline struct sdeb_store_info *devip2sip(str=
uct sdebug_dev_info *devip,
=20
 static inline void
 sdeb_read_lock(rwlock_t *lock)
+	__context_unsafe(conditional locking)
 {
 	if (sdebug_no_rwlock)
 		__acquire(lock);
@@ -4023,6 +4024,7 @@ sdeb_read_lock(rwlock_t *lock)
=20
 static inline void
 sdeb_read_unlock(rwlock_t *lock)
+	__context_unsafe(conditional locking)
 {
 	if (sdebug_no_rwlock)
 		__release(lock);
@@ -4032,6 +4034,7 @@ sdeb_read_unlock(rwlock_t *lock)
=20
 static inline void
 sdeb_write_lock(rwlock_t *lock)
+	__context_unsafe(conditional locking)
 {
 	if (sdebug_no_rwlock)
 		__acquire(lock);
@@ -4041,6 +4044,7 @@ sdeb_write_lock(rwlock_t *lock)
=20
 static inline void
 sdeb_write_unlock(rwlock_t *lock)
+	__context_unsafe(conditional locking)
 {
 	if (sdebug_no_rwlock)
 		__release(lock);
@@ -4050,6 +4054,7 @@ sdeb_write_unlock(rwlock_t *lock)
=20
 static inline void
 sdeb_data_read_lock(struct sdeb_store_info *sip)
+	__context_unsafe(conditional locking)
 {
 	BUG_ON(!sip);
=20
@@ -4058,6 +4063,7 @@ sdeb_data_read_lock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_read_unlock(struct sdeb_store_info *sip)
+	__context_unsafe(conditional locking)
 {
 	BUG_ON(!sip);
=20
@@ -4066,6 +4072,7 @@ sdeb_data_read_unlock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_write_lock(struct sdeb_store_info *sip)
+	__context_unsafe(conditional locking)
 {
 	BUG_ON(!sip);
=20
@@ -4074,6 +4081,7 @@ sdeb_data_write_lock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_write_unlock(struct sdeb_store_info *sip)
+	__context_unsafe(conditional locking)
 {
 	BUG_ON(!sip);
=20
@@ -4082,6 +4090,7 @@ sdeb_data_write_unlock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_sector_read_lock(struct sdeb_store_info *sip)
+	__context_unsafe(conditional locking)
 {
 	BUG_ON(!sip);
=20
@@ -4090,6 +4099,7 @@ sdeb_data_sector_read_lock(struct sdeb_store_info *=
sip)
=20
 static inline void
 sdeb_data_sector_read_unlock(struct sdeb_store_info *sip)
+	__context_unsafe(conditional locking)
 {
 	BUG_ON(!sip);
=20
@@ -4098,6 +4108,7 @@ sdeb_data_sector_read_unlock(struct sdeb_store_info=
 *sip)
=20
 static inline void
 sdeb_data_sector_write_lock(struct sdeb_store_info *sip)
+	__context_unsafe(conditional locking)
 {
 	BUG_ON(!sip);
=20
@@ -4106,6 +4117,7 @@ sdeb_data_sector_write_lock(struct sdeb_store_info =
*sip)
=20
 static inline void
 sdeb_data_sector_write_unlock(struct sdeb_store_info *sip)
+	__context_unsafe(conditional locking)
 {
 	BUG_ON(!sip);
=20
@@ -4164,6 +4176,7 @@ sdeb_data_sector_unlock(struct sdeb_store_info *sip=
, bool do_write)
=20
 static inline void
 sdeb_meta_read_lock(struct sdeb_store_info *sip)
+	__context_unsafe(conditional locking)
 {
 	if (sdebug_no_rwlock) {
 		if (sip)
@@ -4180,6 +4193,7 @@ sdeb_meta_read_lock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_meta_read_unlock(struct sdeb_store_info *sip)
+	__context_unsafe(conditional locking)
 {
 	if (sdebug_no_rwlock) {
 		if (sip)
@@ -4196,6 +4210,7 @@ sdeb_meta_read_unlock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_meta_write_lock(struct sdeb_store_info *sip)
+	__context_unsafe(conditional locking)
 {
 	if (sdebug_no_rwlock) {
 		if (sip)
@@ -4212,6 +4227,7 @@ sdeb_meta_write_lock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_meta_write_unlock(struct sdeb_store_info *sip)
+	__context_unsafe(conditional locking)
 {
 	if (sdebug_no_rwlock) {
 		if (sip)
