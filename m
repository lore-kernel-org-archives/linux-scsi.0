Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2D13C554A
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 21:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350237; cv=none; b=IHDPzOaqTStutebpppD+Oa3P6eCHbExUOq6SRglgriiQocgmG5rS4qd6VE9RHgSra0BeuR3DoguUsU6WbrAfBnYGg5Si/b2d3N77s0R6b+ewBUms5QqPElVYwHiS0gZ61caSApnh4GqZsn8JSJsCqSEuYgC2SGKuhgW7WttvgJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350237; c=relaxed/simple;
	bh=/HNMT+XaQWjs58/l/fA2ncetkNi/ja3HZ3UNSYqxvZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/71wt0bs+CToag6j16uF1Aw6y+i2gYcn+CjDBpGidq1BMibaJENzTxJs/15rW/xGsh3mDtHqSyoVB0IBg61VsjpcFOStymooRB2I4l14jxPNo4K1KFQMprVeldQOEIlvotqLe8Rk08/j8wyV2UNDV5vlC1NE4y8joxBPxwk6pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=InVEH3hu; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="InVEH3hu"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fX0n73zpVzlfl7l;
	Thu, 12 Mar 2026 21:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1773350231; x=1775942232; bh=DSacz
	+4XT25BCwkCqXJR6DRQNPYD3kN8f+iDqS6vQJ0=; b=InVEH3huLwXiAkMjzoQBq
	aK4baVYNPVvtYXIKaIKCX8Kk2/oGFqbVpFKVxSQOXmdeOEMF8UO/3tATlJ0A039k
	NFZTpCfEUiXVlLffIaCh+veJEprNmooX2pkLe3Zflu1q+1pgu/OJnzkw0a0u6+ny
	+kxo0mYEpFvOZJp/M/Athk1NxfDluPX6nfv05Tcm/cq0DnoxbrZJY1CHFeIi+O8t
	hfmOdhthp6hB1zW47AYKlGCqPiiZWSBMRo0fkfVJqUYSBv9l+3xdIPD9HPdLf3pT
	gUfcmuOuxf/laonwWZnC4tj8/wynH2vlbZrSNFKo3rlzdziTMhuKEJycBtmZ/y1/
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Im7FSE4a-8LZ; Thu, 12 Mar 2026 21:17:11 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fX0n21B8Mzlfl5V;
	Thu, 12 Mar 2026 21:17:09 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 02/36] scsi: scsi_debug: Prepare for enabling lock context analysis
Date: Thu, 12 Mar 2026 14:15:13 -0700
Message-ID: <20260312211636.3245119-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260312211636.3245119-1-bvanassche@acm.org>
References: <20260312211636.3245119-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Annotate the functions that perform conditional locking with
__no_context_analysis to prevent that the Clang thread-safety analyzer
complains about these functions.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1515495fd9ea..bec09a67a915 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4014,6 +4014,7 @@ static inline struct sdeb_store_info *devip2sip(str=
uct sdebug_dev_info *devip,
=20
 static inline void
 sdeb_read_lock(rwlock_t *lock)
+	__no_context_analysis /* conditional locking */
 {
 	if (sdebug_no_rwlock)
 		__acquire(lock);
@@ -4023,6 +4024,7 @@ sdeb_read_lock(rwlock_t *lock)
=20
 static inline void
 sdeb_read_unlock(rwlock_t *lock)
+	__no_context_analysis /* conditional locking */
 {
 	if (sdebug_no_rwlock)
 		__release(lock);
@@ -4032,6 +4034,7 @@ sdeb_read_unlock(rwlock_t *lock)
=20
 static inline void
 sdeb_write_lock(rwlock_t *lock)
+	__no_context_analysis /* conditional locking */
 {
 	if (sdebug_no_rwlock)
 		__acquire(lock);
@@ -4041,6 +4044,7 @@ sdeb_write_lock(rwlock_t *lock)
=20
 static inline void
 sdeb_write_unlock(rwlock_t *lock)
+	__no_context_analysis /* conditional locking */
 {
 	if (sdebug_no_rwlock)
 		__release(lock);
@@ -4050,6 +4054,7 @@ sdeb_write_unlock(rwlock_t *lock)
=20
 static inline void
 sdeb_data_read_lock(struct sdeb_store_info *sip)
+	__no_context_analysis /* conditional locking */
 {
 	BUG_ON(!sip);
=20
@@ -4058,6 +4063,7 @@ sdeb_data_read_lock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_read_unlock(struct sdeb_store_info *sip)
+	__no_context_analysis /* conditional locking */
 {
 	BUG_ON(!sip);
=20
@@ -4066,6 +4072,7 @@ sdeb_data_read_unlock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_write_lock(struct sdeb_store_info *sip)
+	__no_context_analysis /* conditional locking */
 {
 	BUG_ON(!sip);
=20
@@ -4074,6 +4081,7 @@ sdeb_data_write_lock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_write_unlock(struct sdeb_store_info *sip)
+	__no_context_analysis /* conditional locking */
 {
 	BUG_ON(!sip);
=20
@@ -4082,6 +4090,7 @@ sdeb_data_write_unlock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_data_sector_read_lock(struct sdeb_store_info *sip)
+	__no_context_analysis /* conditional locking */
 {
 	BUG_ON(!sip);
=20
@@ -4090,6 +4099,7 @@ sdeb_data_sector_read_lock(struct sdeb_store_info *=
sip)
=20
 static inline void
 sdeb_data_sector_read_unlock(struct sdeb_store_info *sip)
+	__no_context_analysis /* conditional locking */
 {
 	BUG_ON(!sip);
=20
@@ -4098,6 +4108,7 @@ sdeb_data_sector_read_unlock(struct sdeb_store_info=
 *sip)
=20
 static inline void
 sdeb_data_sector_write_lock(struct sdeb_store_info *sip)
+	__no_context_analysis /* conditional locking */
 {
 	BUG_ON(!sip);
=20
@@ -4106,6 +4117,7 @@ sdeb_data_sector_write_lock(struct sdeb_store_info =
*sip)
=20
 static inline void
 sdeb_data_sector_write_unlock(struct sdeb_store_info *sip)
+	__no_context_analysis /* conditional locking */
 {
 	BUG_ON(!sip);
=20
@@ -4164,6 +4176,7 @@ sdeb_data_sector_unlock(struct sdeb_store_info *sip=
, bool do_write)
=20
 static inline void
 sdeb_meta_read_lock(struct sdeb_store_info *sip)
+	__no_context_analysis /* conditional locking */
 {
 	if (sdebug_no_rwlock) {
 		if (sip)
@@ -4180,6 +4193,7 @@ sdeb_meta_read_lock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_meta_read_unlock(struct sdeb_store_info *sip)
+	__no_context_analysis /* conditional locking */
 {
 	if (sdebug_no_rwlock) {
 		if (sip)
@@ -4196,6 +4210,7 @@ sdeb_meta_read_unlock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_meta_write_lock(struct sdeb_store_info *sip)
+	__no_context_analysis /* conditional locking */
 {
 	if (sdebug_no_rwlock) {
 		if (sip)
@@ -4212,6 +4227,7 @@ sdeb_meta_write_lock(struct sdeb_store_info *sip)
=20
 static inline void
 sdeb_meta_write_unlock(struct sdeb_store_info *sip)
+	__no_context_analysis /* conditional locking */
 {
 	if (sdebug_no_rwlock) {
 		if (sip)
