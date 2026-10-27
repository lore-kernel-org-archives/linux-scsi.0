Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793115855;
	b=YJZGGqc2Ty866RubH8lOrBGrxxpj/qdNycKZehIHTZsPWKgbgMgswexr2sa7eVxw/1V8
	 uGFjlPaLYi1c28S8w4S5lFtLzQqfePA6U3Mc6j1MfuHnx1dcSsbp+5leLYhZoKfDptij4
	 b0K8ZkNYrPGiLhFnJRHiTxtaOLm6Tu0nTiFdvbaKFyP5xC0UlKtHzHqFCQRUcTS/W6zhe
	 RCDLVkEsGlfnWrL0D059L2Y/jjqDWBYj3zQtQXQDC4mIMSMd4aPweciaaYlmgDSb+FP2Q
	 0KzkjYYky8bXuaSp3PRh6tw4HhApi5NFfhZnuy3+jiB7EVpvqDWrr1d1syM96fYk+vQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793115855;
	h=Received:DKIM-Signature:Received:Message-ID:User-Agent:Date:From:To:
	 Cc:Subject:References:MIME-Version:Content-Type;
	bh=EnDqdoBlLXNNsQWF1PTAQfygtIq8DiYIDOwKN0S5TYo=;
	b=xbtJo5024VQYK1zULUca5HdA5IM6E8fsgnvb8t8qpBhR/zkLHTPAAfFaGuo44j6pSy/t
	 s9AYzd6V7UINHSdhTZHUPGRaEaWxYgsJwd11YYI2BBWD2bOXQhQaPZtySQuKKu0ZyYZUy
	 Ra3VkynqVr8KaThDcfGuuUVeU5eM53Ma0xo+MI880EG0VBUrcjh85uxMGBWxWpHkNstJ2
	 KNYUBT/sIc/SVK8bfufh5TUeHkbKe/AwSoHnPEnxfyvWCtNWDajGwxeGtikb0VLRStzaH
	 JhbrPENV8Uv2DyYTy3fKwt0ferhjim5J9kzrDfvz6+6d7jgjSyPRSNDkgdo7//9iIwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JRTNu4g7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1B9606A33F;
	Tue, 27 Oct 2026 15:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JRTNu4g7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718051F031E3;
	Tue, 27 Oct 2026 15:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793115854;
	bh=EnDqdoBlLXNNsQWF1PTAQfygtIq8DiYIDOwKN0S5TYo=;
	h=Date:From:To:Cc:Subject:References;
	b=JRTNu4g77Y9W+naHrADfdMOHHQ9syVNyuM9xuMSXf3IuDIeWHdAFsn5XSf+e4kBfC
	 a5hguQUVEWlTVw0jOJOcIAbOSLJw7XAY7O7x1NyvbIVcFZuf1iKx9xxR9haMcpnMQQ
	 Dz22lwb0JIesfTJczu36lzaG8VJgEtG/H2KHPfJd5I7cEQcvF/DeTc2cm5LNOX5J6r
	 vG+5VARedfxaW466FILJdpYspMDYinA+T/0PE3+gsmkoOYK53dL6lNixOTUKparNzU
	 qBkZvBEN34T6qIx9SOwEasvcNuhC2ZH94OsnAE2mLKvDHnj+0gFDUd0U5dTRt76BYp
	 Gjd2BmjfO8DFA==
Received: from rostedt by gandalf with local (Exim 4.100.1)
	(envelope-from <rostedt@kernel.org>)
	id 1xLjLR-000000078iW-3Joy;
	Tue, 27 Oct 2026 11:44:13 -0400
Message-ID: <20261027154413.617192888@kernel.org>
User-Agent: quilt/0.69
Date: Tue, 27 Oct 2026 11:37:04 -0400
From: Steven Rostedt <rostedt@kernel.org>
To: linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vineeth Pillai <vineeth@bitbyteword.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Aaron Conole <aconole@redhat.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 Alexei Starovoitov <ast@kernel.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Borislav Petkov <bp@alien8.de>,
 Chanwoo Choi <cw00.choi@samsung.com>,
 =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Danilo Krummrich <dakr@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Airlie <airlied@gmail.com>,
 "David S. Miller" <davem@davemloft.net>,
 Eelco Chaudron <echaudro@redhat.com>,
 Eric Dumazet <edumazet@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Ilya Maximets <i.maximets@ovn.org>,
 Ingo Molnar <mingo@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Jiri Pirko <jiri@resnulli.us>,
 John Fastabend <john.fastabend@gmail.com>,
 Jon Maloy <jmaloy@redhat.com>,
 Koby Elbaz <koby.elbaz@intel.com>,
 Konstantin Sinyuk <konstantin.sinyuk@intel.com>,
 Kyungmin Park <kyungmin.park@samsung.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Maxime Ripard <mripard@kernel.org>,
 MyungJoo Ham <myungjoo.ham@samsung.com>,
 Oded Gabbay <ogabbay@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 Philipp Stanner <phasta@kernel.org>,
 Simona Vetter <simona@ffwll.ch>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 Thomas Gleixner <tglx@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>,
 tipc-discussion@lists.sourceforge.net,
 Tung Quang Nguyen <tung.quang.nguyen@est.tech>,
 Xin Long <lucien.xin@gmail.com>,
 x86@kernel.org,
 amd-gfx@lists.freedesktop.org,
 bpf@vger.kernel.org,
 dev@openvswitch.org,
 dri-devel@lists.freedesktop.org,
 linux-media@vger.kernel.org,
 linux-pm@vger.kernel.org,
 linux-scsi@vger.kernel.org,
 linux-sctp@vger.kernel.org,
 netdev@vger.kernel.org
Subject: [PATCH 6/9] scsi: ufs: Use trace_call__##name() at guarded tracepoint call sites
References: <20261027153658.703730257@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

From: Vineeth Pillai <vineeth@bitbyteword.org>

Replace trace_foo() with the new trace_call__foo() at sites already
guarded by trace_foo_enabled(), avoiding a redundant
static_branch_unlikely() re-evaluation inside the tracepoint.
trace_call__foo() calls the tracepoint callbacks directly without
utilizing the static branch again.

Original v2 series:
https://lore.kernel.org/linux-trace-kernel/20260323160052.17528-1-vineeth@bitbyteword.org/

Parts of the original v2 series have already been merged in mainline.
This patch is being reposted as a follow-up cleanup for the remaining
unmerged pieces.

Link: https://patch.msgid.link/20260515135946.2238888-1-vineeth@bitbyteword.org
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/ufs/core/ufshcd.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index cc75384c6502..7a169cf0093b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -421,8 +421,8 @@ static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba,
 	else
 		header = &lrb->ucd_rsp_ptr->header;
 
-	trace_ufshcd_upiu(hba, str_t, header, &rq->sc.cdb,
-			  UFS_TSF_CDB);
+	trace_call__ufshcd_upiu(hba, str_t, header, &rq->sc.cdb,
+			       UFS_TSF_CDB);
 }
 
 static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba,
@@ -432,8 +432,8 @@ static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba,
 	if (!trace_ufshcd_upiu_enabled())
 		return;
 
-	trace_ufshcd_upiu(hba, str_t, &rq_rsp->header,
-			  &rq_rsp->qr, UFS_TSF_OSF);
+	trace_call__ufshcd_upiu(hba, str_t, &rq_rsp->header,
+			       &rq_rsp->qr, UFS_TSF_OSF);
 }
 
 static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
@@ -445,15 +445,15 @@ static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 		return;
 
 	if (str_t == UFS_TM_SEND)
-		trace_ufshcd_upiu(hba, str_t,
-				  &descp->upiu_req.req_header,
-				  &descp->upiu_req.input_param1,
-				  UFS_TSF_TM_INPUT);
+		trace_call__ufshcd_upiu(hba, str_t,
+					&descp->upiu_req.req_header,
+					&descp->upiu_req.input_param1,
+					UFS_TSF_TM_INPUT);
 	else
-		trace_ufshcd_upiu(hba, str_t,
-				  &descp->upiu_rsp.rsp_header,
-				  &descp->upiu_rsp.output_param1,
-				  UFS_TSF_TM_OUTPUT);
+		trace_call__ufshcd_upiu(hba, str_t,
+					&descp->upiu_rsp.rsp_header,
+					&descp->upiu_rsp.output_param1,
+					UFS_TSF_TM_OUTPUT);
 }
 
 static void ufshcd_add_uic_command_trace(struct ufs_hba *hba,
@@ -477,7 +477,7 @@ static void ufshcd_add_uic_command_trace(struct ufs_hba *hba,
 		arg3 = ufshcd_readl(hba, REG_UIC_COMMAND_ARG_3);
 	}
 
-	trace_ufshcd_uic_command(hba, str_t, cmd, arg1, arg2, arg3);
+	trace_call__ufshcd_uic_command(hba, str_t, cmd, arg1, arg2, arg3);
 }
 
 static void ufshcd_add_command_trace(struct ufs_hba *hba, struct scsi_cmnd *cmd,
@@ -526,8 +526,9 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, struct scsi_cmnd *cmd,
 	} else {
 		doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	}
-	trace_ufshcd_command(cmd->device, hba, str_t, tag, doorbell, hwq_id,
-			     transfer_len, intr, lba, opcode, group_id);
+	trace_call__ufshcd_command(cmd->device, hba, str_t, tag, doorbell,
+				   hwq_id, transfer_len, intr, lba, opcode,
+				   group_id);
 }
 
 static void ufshcd_print_clk_freqs(struct ufs_hba *hba)
-- 
2.53.0
