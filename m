Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793115854;
	b=4lglhReqNazRjjhHSdm1lzTHJpjkH3uHZKUvP7623tBxqEdo7uV84MQlsWBjQgttnIH4
	 S6QUkQh8dXv8NmjiOwspeMdpFaV758pI4NoqZPdG1oRbau44L26PavJsFYhihyUt3lgXE
	 pvvgmsESxAD34ZEVysKK+zxHMPO6xHSkRNyMOkdmrDqIEyoyrPPy2STbT3WErmULeie6x
	 /7wiu2EJpT1SBBFMADblA95kjog95DD42rmwg+9iHD2uZE6Eq1VS8VLHH8QFRb93Q7gof
	 h6XcD4XunP4m/gjah4n9QRYKloMqzX37fZriVZb+3xPTqsHtoI/99p1MvExRezlHWkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793115854;
	h=Received:DKIM-Signature:Received:Message-ID:User-Agent:Date:From:To:
	 Cc:Subject:References:MIME-Version:Content-Type;
	bh=JM8xIfdgR8N97X1b3lbIpuPAQb06bQ+UjBVoY3gvbrQ=;
	b=e7JxThDZ833kY/m+03Rxhyli4gDE5ERQPMfNxmDbRceZVQdzo8vFTArDLUbNwyvX8hRa
	 qzGJCXycV+6yc0htgbo/wr/JzEGmuIy3oiXfzxEwJHdg1evlkepaSShMVDavb8+UjJwrB
	 IozvZyXR8hFZc9v0qNdpq7N2CxcjF9SjfFjvoADNJSL1Rgx/ayaF/QRWes0OJfzblpcIa
	 x1Y6zBIy+txlq08TF3CBRpnMp/OKpdjorvOXP1HO1zDlnzMPeEPBNbJVFAblX9UbqkYYK
	 3jMZauW9pJ8oF+Y1AAYOgSbFZMupfFLKYnvi7wyHZSY97knwrV0Ut+IeNv0SFxtCwtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7A5606A31B;
	Tue, 27 Oct 2026 15:44:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774F21F01828;
	Tue, 27 Oct 2026 15:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793115853;
	bh=JM8xIfdgR8N97X1b3lbIpuPAQb06bQ+UjBVoY3gvbrQ=;
	h=Date:From:To:Cc:Subject:References;
	b=kORGCCK5ceCR9W1JSe8erJ5KVSujbKUR6xlP36EcnI1w/pi9sfO8Dv9mOkHB3XHQy
	 kmjOS8Mdq2flJuSlUp6bUHmz0888PX+f9NOJbey3BbM/Jzkf0r1aSnqGj+TnSmk3VL
	 HMyiIMOaMpD414IHg/LprZN30QWTV20w9awBG/q6DGVFwKw1ufgsOTYhlhm6/1v3JC
	 7I5SOyCuPo9S2BtKrP0w4Pt+rjcmDZRpXa0joOXTOXweQdSHhuJm2dwVCpCY58HBOO
	 7RZXHFFCQvzAu3v7MVZ4vG1pCWNm/YeF/etjrnoQMS+hTVZx7OTk17B/37mXDZ18/e
	 8Dj3WQ78oIVOw==
Received: from rostedt by gandalf with local (Exim 4.100.1)
	(envelope-from <rostedt@kernel.org>)
	id 1xLjLQ-000000078fQ-3QXz;
	Tue, 27 Oct 2026 11:44:12 -0400
Message-ID: <20261027154412.637514479@kernel.org>
User-Agent: quilt/0.69
Date: Tue, 27 Oct 2026 11:36:59 -0400
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
Subject: [PATCH 1/9] net: Use trace_call__##name() at guarded tracepoint call sites
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

Link: https://patch.msgid.link/20260515135909.2238774-1-vineeth@bitbyteword.org
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/core/dev.c             | 2 +-
 net/core/xdp.c             | 2 +-
 net/openvswitch/actions.c  | 2 +-
 net/openvswitch/datapath.c | 2 +-
 net/sctp/outqueue.c        | 2 +-
 net/tipc/node.c            | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1a09e7869118..447894e09239 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6685,7 +6685,7 @@ void netif_receive_skb_list(struct list_head *head)
 		return;
 	if (trace_netif_receive_skb_list_entry_enabled()) {
 		list_for_each_entry(skb, head, list)
-			trace_netif_receive_skb_list_entry(skb);
+			trace_call__netif_receive_skb_list_entry(skb);
 	}
 	netif_receive_skb_list_internal(head);
 	trace_netif_receive_skb_list_exit(0);
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 1d679e8fd649..d6296d59f8e3 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -362,7 +362,7 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 		xsk_pool_set_rxq_info(allocator, xdp_rxq);
 
 	if (trace_mem_connect_enabled() && xdp_alloc)
-		trace_mem_connect(xdp_alloc, xdp_rxq);
+		trace_call__mem_connect(xdp_alloc, xdp_rxq);
 	return 0;
 }
 
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 12e339cbf791..044feae58e6f 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -1278,7 +1278,7 @@ static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
 		int err = 0;
 
 		if (trace_ovs_do_execute_action_enabled())
-			trace_ovs_do_execute_action(dp, skb, key, a, rem);
+			trace_call__ovs_do_execute_action(dp, skb, key, a, rem);
 
 		/* Actions that rightfully have to consume the skb should do it
 		 * and return directly.
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index b2a0b09fd4a5..11b438c7e039 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -336,7 +336,7 @@ int ovs_dp_upcall(struct datapath *dp, struct sk_buff *skb,
 	int err;
 
 	if (trace_ovs_dp_upcall_enabled())
-		trace_ovs_dp_upcall(dp, skb, key, upcall_info);
+		trace_call__ovs_dp_upcall(dp, skb, key, upcall_info);
 
 	if (upcall_info->portid == 0) {
 		err = -ENOTCONN;
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index e92fb9da4647..e3d7be7009e3 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -1268,7 +1268,7 @@ int sctp_outq_sack(struct sctp_outq *q, struct sctp_chunk *chunk)
 	/* SCTP path tracepoint for congestion control debugging. */
 	if (trace_sctp_probe_path_enabled()) {
 		list_for_each_entry(transport, transport_list, transports)
-			trace_sctp_probe_path(transport, asoc);
+			trace_call__sctp_probe_path(transport, asoc);
 	}
 
 	sack_ctsn = ntohl(sack->cum_tsn_ack);
diff --git a/net/tipc/node.c b/net/tipc/node.c
index 53b0993c2c23..6c32618cc625 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1953,7 +1953,7 @@ static bool tipc_node_check_state(struct tipc_node *n, struct sk_buff *skb,
 
 	if (trace_tipc_node_check_state_enabled()) {
 		trace_tipc_skb_dump(skb, false, "skb for node state check");
-		trace_tipc_node_check_state(n, true, " ");
+		trace_call__tipc_node_check_state(n, true, " ");
 	}
 	l = n->links[bearer_id].link;
 	if (!l)
-- 
2.53.0
