Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5DB2F3C37
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361113; cv=none; b=CdiyZ3m7a64oKdz+e9Lu4aqemow+iGAEs6e3ObUFMPJ3ZLoHASX1rpzEqmmQCK4myk2Q38EFSjuXZncwNUT4fV45oOxZdkzrjRLDPuQwtX/PcbXR5IhzGV8MGSF4GnHHSNREq42J6y6IIoparPGw0R9G0OeOQ2jGLJePjJmb2JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361113; c=relaxed/simple;
	bh=8Fib8CpDDqtBhaKkWQWqsr12Uu1oAZeM+8Q/MvMbevk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0mFdNIzYnadhpLSAxMLTMX6769Y6A53j5jkO+IetT9Ru+DhE2Gbqk2YfrOV6sjnEmfNgfDy4kQDrq9MuqXXN+Ff2IDWVpfZB4nZ9fVLtyGo9YZEbzMCQoR1DjOBz+NOFsk0xcqW9eGI6Li5epEdpDNXXlx+1pUaRDl7a/Hf0qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=eKFh1+Rj; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="eKFh1+Rj"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrznM5Xkzz1XM30h;
	Fri, 25 Sep 2026 18:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361101; x=1792953102; bh=WGLQL
	CeNMKZmVZFV7rrTf1wArc2mzs6GaLim6YYmgAg=; b=eKFh1+RjIe5LroKYD5mXu
	OjRAWlo/s1MZugWWXFl3PSKw0YexsAvAH3wc6DmQv1wwFJ/JGYxcTFQycG3WHKVx
	a8yjktYwsC22tKcVxKOfg15VYO8X+QcA7v4fKkn4/dg9JEWxXj/pRpKacQjeL9jQ
	7MRYURE8LC/RR/YgCk9kWuc82Xm5lYPQRbX1V+2J8vsevswKMYa54IagdXXfc3Wn
	bN5afOjxaBvKz8gtrBnudtdEYQVzq/JmNALlU/YFKQbJdMpTmrCkQdBa05bfftyP
	7BsH4ccTZXFF9S0eR6ekz2pkhsi87Y8e2uGtsQUu9KSHYyR2tq7HqvgVJS2JYB4e
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gHCMRR4dI007; Fri, 25 Sep 2026 18:31:41 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzn445wWz1XM4Sx;
	Fri, 25 Sep 2026 18:31:35 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 30/54] scsi: ibmvscsi_tgt: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:26:08 -0700
Message-ID: <c39eb31704284bf0f902b96a4307b43b076b0b0d.1790360262.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790360262.git.bvanassche@acm.org>
References: <cover.1790360262.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Document locking requirements with __must_hold() and enable lock context
analysis.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ibmvscsi_tgt/Makefile       |  3 +++
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 34 +++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/Makefile b/drivers/scsi/ibmvscsi_t=
gt/Makefile
index cc7a8256dcf8..7ae12ee9a347 100644
--- a/drivers/scsi/ibmvscsi_tgt/Makefile
+++ b/drivers/scsi/ibmvscsi_tgt/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_SCSI_IBMVSCSIS)	+=3D ibmvscsis.o
=20
 ibmvscsis-y :=3D libsrp.o ibmvscsi_tgt.o
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmv=
scsi_tgt/ibmvscsi_tgt.c
index e2af90b6da39..92b26f7fec50 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -219,6 +219,7 @@ static long ibmvscsis_unregister_command_q(struct scs=
i_info *vscsi)
  */
 static void ibmvscsis_delete_client_info(struct scsi_info *vscsi,
 					 bool client_closed)
+	__must_hold(&vscsi->intr_lock)
 {
 	vscsi->client_cap =3D 0;
=20
@@ -251,6 +252,7 @@ static void ibmvscsis_delete_client_info(struct scsi_=
info *vscsi,
  *	Process level, interrupt lock is held
  */
 static long ibmvscsis_free_command_q(struct scsi_info *vscsi)
+	__must_hold(&vscsi->intr_lock)
 {
 	int bytes;
 	u32 flags_under_lock;
@@ -329,6 +331,7 @@ static struct viosrp_crq *ibmvscsis_cmd_q_dequeue(uin=
t mask,
  *	Interrupt environment interrupt lock held
  */
 static long ibmvscsis_send_init_message(struct scsi_info *vscsi, u8 form=
at)
+	__must_hold(&vscsi->intr_lock)
 {
 	struct viosrp_crq *crq;
 	u64 buffer[2] =3D { 0, 0 };
@@ -356,6 +359,7 @@ static long ibmvscsis_send_init_message(struct scsi_i=
nfo *vscsi, u8 format)
  *	Process level only, interrupt lock held
  */
 static long ibmvscsis_check_init_msg(struct scsi_info *vscsi, uint *form=
at)
+	__must_hold(&vscsi->intr_lock)
 {
 	struct viosrp_crq *crq;
 	long rc =3D ADAPT_SUCCESS;
@@ -571,6 +575,7 @@ static void ibmvscsis_disconnect(struct work_struct *=
work)
  */
 static void ibmvscsis_post_disconnect(struct scsi_info *vscsi, uint new_=
state,
 				      uint flag_bits)
+	__must_hold(&vscsi->intr_lock)
 {
 	uint state;
=20
@@ -652,6 +657,7 @@ static void ibmvscsis_post_disconnect(struct scsi_inf=
o *vscsi, uint new_state,
  * Must be called with interrupt lock held.
  */
 static long ibmvscsis_handle_init_compl_msg(struct scsi_info *vscsi)
+	__must_hold(&vscsi->intr_lock)
 {
 	long rc =3D ADAPT_SUCCESS;
=20
@@ -691,6 +697,7 @@ static long ibmvscsis_handle_init_compl_msg(struct sc=
si_info *vscsi)
  * Must be called with interrupt lock held.
  */
 static long ibmvscsis_handle_init_msg(struct scsi_info *vscsi)
+	__must_hold(&vscsi->intr_lock)
 {
 	long rc =3D ADAPT_SUCCESS;
=20
@@ -759,6 +766,7 @@ static long ibmvscsis_handle_init_msg(struct scsi_inf=
o *vscsi)
  *	Interrupt, interrupt lock held
  */
 static long ibmvscsis_init_msg(struct scsi_info *vscsi, struct viosrp_cr=
q *crq)
+	__must_hold(&vscsi->intr_lock)
 {
 	long rc =3D ADAPT_SUCCESS;
=20
@@ -798,6 +806,7 @@ static long ibmvscsis_init_msg(struct scsi_info *vscs=
i, struct viosrp_crq *crq)
  * Must be called with interrupt lock held.
  */
 static long ibmvscsis_establish_new_q(struct scsi_info *vscsi)
+	__must_hold(&vscsi->intr_lock)
 {
 	long rc =3D ADAPT_SUCCESS;
 	uint format;
@@ -874,6 +883,7 @@ static long ibmvscsis_establish_new_q(struct scsi_inf=
o *vscsi)
  *	Process environment, called with interrupt lock held
  */
 static void ibmvscsis_reset_queue(struct scsi_info *vscsi)
+	__must_hold(&vscsi->intr_lock)
 {
 	int bytes;
 	long rc =3D ADAPT_SUCCESS;
@@ -924,6 +934,7 @@ static void ibmvscsis_reset_queue(struct scsi_info *v=
scsi)
  */
 static void ibmvscsis_free_cmd_resources(struct scsi_info *vscsi,
 					 struct ibmvscsis_cmd *cmd)
+	__must_hold(&vscsi->intr_lock)
 {
 	struct iu_entry *iue =3D cmd->iue;
=20
@@ -974,6 +985,7 @@ static void ibmvscsis_free_cmd_resources(struct scsi_=
info *vscsi,
  *	Process or interrupt environment called with interrupt lock held
  */
 static long ibmvscsis_ready_for_suspend(struct scsi_info *vscsi, bool id=
le)
+	__must_hold(&vscsi->intr_lock)
 {
 	long rc =3D 0;
 	struct viosrp_crq *crq;
@@ -1030,6 +1042,7 @@ static long ibmvscsis_ready_for_suspend(struct scsi=
_info *vscsi, bool idle)
  */
 static long ibmvscsis_trans_event(struct scsi_info *vscsi,
 				  struct viosrp_crq *crq)
+	__must_hold(&vscsi->intr_lock)
 {
 	long rc =3D ADAPT_SUCCESS;
=20
@@ -1166,6 +1179,7 @@ static long ibmvscsis_trans_event(struct scsi_info =
*vscsi,
  *	intr_lock must be held
  */
 static void ibmvscsis_poll_cmd_q(struct scsi_info *vscsi)
+	__must_hold(&vscsi->intr_lock)
 {
 	struct viosrp_crq *crq;
 	long rc;
@@ -1252,6 +1266,7 @@ static void ibmvscsis_poll_cmd_q(struct scsi_info *=
vscsi)
  *	Called with interrupt lock held
  */
 static void ibmvscsis_free_cmd_qs(struct scsi_info *vscsi)
+	__must_hold(&vscsi->intr_lock)
 {
 	struct ibmvscsis_cmd *cmd, *nxt;
=20
@@ -1272,6 +1287,7 @@ static void ibmvscsis_free_cmd_qs(struct scsi_info =
*vscsi)
  * Must be called with interrupt lock held.
  */
 static struct ibmvscsis_cmd *ibmvscsis_get_free_cmd(struct scsi_info *vs=
csi)
+	__must_hold(&vscsi->intr_lock)
 {
 	struct ibmvscsis_cmd *cmd =3D NULL;
 	struct iu_entry *iue;
@@ -1310,6 +1326,7 @@ static struct ibmvscsis_cmd *ibmvscsis_get_free_cmd=
(struct scsi_info *vscsi)
  *	Process environment called with interrupt lock held
  */
 static void ibmvscsis_adapter_idle(struct scsi_info *vscsi)
+	__must_hold(&vscsi->intr_lock)
 {
 	int free_qs =3D false;
 	long rc =3D 0;
@@ -1441,6 +1458,7 @@ static void ibmvscsis_adapter_idle(struct scsi_info=
 *vscsi)
 static long ibmvscsis_copy_crq_packet(struct scsi_info *vscsi,
 				      struct ibmvscsis_cmd *cmd,
 				      struct viosrp_crq *crq)
+	__must_hold(&vscsi->intr_lock)
 {
 	struct iu_entry *iue =3D cmd->iue;
 	long rc =3D 0;
@@ -1500,6 +1518,7 @@ static long ibmvscsis_copy_crq_packet(struct scsi_i=
nfo *vscsi,
  */
 static long ibmvscsis_adapter_info(struct scsi_info *vscsi,
 				   struct iu_entry *iue)
+	__must_hold(&vscsi->intr_lock)
 {
 	struct viosrp_adapter_info *mad =3D &vio_iu(iue)->mad.adapter_info;
 	struct mad_adapter_info_data *info;
@@ -1611,6 +1630,7 @@ static long ibmvscsis_adapter_info(struct scsi_info=
 *vscsi,
  *	Interrupt called with adapter lock held
  */
 static int ibmvscsis_cap_mad(struct scsi_info *vscsi, struct iu_entry *i=
ue)
+	__must_hold(&vscsi->intr_lock)
 {
 	struct viosrp_capabilities *mad =3D &vio_iu(iue)->mad.capabilities;
 	struct capabilities *cap;
@@ -1725,6 +1745,7 @@ static int ibmvscsis_cap_mad(struct scsi_info *vscs=
i, struct iu_entry *iue)
  * Must be called with interrupt lock held.
  */
 static long ibmvscsis_process_mad(struct scsi_info *vscsi, struct iu_ent=
ry *iue)
+	__must_hold(&vscsi->intr_lock)
 {
 	struct mad_common *mad =3D (struct mad_common *)&vio_iu(iue)->mad;
 	struct viosrp_empty_iu *empty;
@@ -1768,6 +1789,7 @@ static long ibmvscsis_process_mad(struct scsi_info =
*vscsi, struct iu_entry *iue)
  * Must be called with interrupt lock held.
  */
 static void srp_snd_msg_failed(struct scsi_info *vscsi, long rc)
+	__must_hold(&vscsi->intr_lock)
 {
 	ktime_t kt;
=20
@@ -1871,6 +1893,7 @@ static void srp_snd_msg_failed(struct scsi_info *vs=
csi, long rc)
  *	Called with interrupt lock held
  */
 static void ibmvscsis_send_messages(struct scsi_info *vscsi)
+	__must_hold(&vscsi->intr_lock)
 {
 	struct viosrp_crq empty_crq =3D { };
 	struct viosrp_crq *crq =3D &empty_crq;
@@ -1979,6 +2002,7 @@ static void ibmvscsis_send_messages(struct scsi_inf=
o *vscsi)
 static void ibmvscsis_send_mad_resp(struct scsi_info *vscsi,
 				    struct ibmvscsis_cmd *cmd,
 				    struct viosrp_crq *crq)
+	__must_hold(&vscsi->intr_lock)
 {
 	struct iu_entry *iue =3D cmd->iue;
 	struct mad_common *mad =3D (struct mad_common *)&vio_iu(iue)->mad;
@@ -2021,6 +2045,7 @@ static void ibmvscsis_send_mad_resp(struct scsi_inf=
o *vscsi,
  *	Interrupt, called with adapter lock held
  */
 static long ibmvscsis_mad(struct scsi_info *vscsi, struct viosrp_crq *cr=
q)
+	__must_hold(&vscsi->intr_lock)
 {
 	struct iu_entry *iue;
 	struct ibmvscsis_cmd *cmd;
@@ -2097,6 +2122,7 @@ static long ibmvscsis_mad(struct scsi_info *vscsi, =
struct viosrp_crq *crq)
  */
 static long ibmvscsis_login_rsp(struct scsi_info *vscsi,
 				struct ibmvscsis_cmd *cmd)
+	__must_hold(&vscsi->intr_lock)
 {
 	struct iu_entry *iue =3D cmd->iue;
 	struct srp_login_rsp *rsp =3D &vio_iu(iue)->srp.login_rsp;
@@ -2157,6 +2183,7 @@ static long ibmvscsis_login_rsp(struct scsi_info *v=
scsi,
  */
 static long ibmvscsis_srp_login_rej(struct scsi_info *vscsi,
 				    struct ibmvscsis_cmd *cmd, u32 reason)
+	__must_hold(&vscsi->intr_lock)
 {
 	struct iu_entry *iue =3D cmd->iue;
 	struct srp_login_rej *rej =3D &vio_iu(iue)->srp.login_rej;
@@ -2272,6 +2299,7 @@ static int ibmvscsis_drop_nexus(struct ibmvscsis_tp=
ort *tport)
 static long ibmvscsis_srp_login(struct scsi_info *vscsi,
 				struct ibmvscsis_cmd *cmd,
 				struct viosrp_crq *crq)
+	__must_hold(&vscsi->intr_lock)
 {
 	struct iu_entry *iue =3D cmd->iue;
 	struct srp_login_req *req =3D &vio_iu(iue)->srp.login_req;
@@ -2346,6 +2374,7 @@ static long ibmvscsis_srp_login(struct scsi_info *v=
scsi,
 static long ibmvscsis_srp_i_logout(struct scsi_info *vscsi,
 				   struct ibmvscsis_cmd *cmd,
 				   struct viosrp_crq *crq)
+	__must_hold(&vscsi->intr_lock)
 {
 	struct iu_entry *iue =3D cmd->iue;
 	struct srp_i_logout *log_out =3D &vio_iu(iue)->srp.i_logout;
@@ -2367,8 +2396,8 @@ static long ibmvscsis_srp_i_logout(struct scsi_info=
 *vscsi,
 	return ADAPT_SUCCESS;
 }
=20
-/* Called with intr lock held */
 static void ibmvscsis_srp_cmd(struct scsi_info *vscsi, struct viosrp_crq=
 *crq)
+	__must_hold(&vscsi->intr_lock)
 {
 	struct ibmvscsis_cmd *cmd;
 	struct iu_entry *iue;
@@ -2469,6 +2498,7 @@ static void ibmvscsis_srp_cmd(struct scsi_info *vsc=
si, struct viosrp_crq *crq)
  *	Interrupt, interrupt lock held
  */
 static long ibmvscsis_ping_response(struct scsi_info *vscsi)
+	__must_hold(&vscsi->intr_lock)
 {
 	struct viosrp_crq *crq;
 	u64 buffer[2] =3D { 0, 0 };
@@ -2520,6 +2550,7 @@ static long ibmvscsis_ping_response(struct scsi_inf=
o *vscsi)
  */
 static long ibmvscsis_parse_command(struct scsi_info *vscsi,
 				    struct viosrp_crq *crq)
+	__must_hold(&vscsi->intr_lock)
 {
 	long rc =3D ADAPT_SUCCESS;
=20
@@ -2961,6 +2992,7 @@ static irqreturn_t ibmvscsis_interrupt(int dummy, v=
oid *data)
  * Must be called with interrupt lock held.
  */
 static long ibmvscsis_enable_change_state(struct scsi_info *vscsi)
+	__must_hold(&vscsi->intr_lock)
 {
 	int bytes;
 	long rc =3D ADAPT_SUCCESS;
