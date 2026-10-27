Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793115854;
	b=jfyT8vuG+IbfycS8XmlaIwgDOd7aVUGCdwuke2nlqa+OAGLjKMi8ryop9gzrpJwEmTFe
	 vGV2I/Zz12tcm59r77amRphbn5ovUgYjtliruTmCvkIf/2P+aUWJ/4+Rt8poarQXPC/5j
	 8vvEv4YCg8m7bSWRGMBBIE8Uv34LpHMo8ijXkfCpiPNJjYfMpsdsvmcBiEl743z2wRb6i
	 oQRNLpl8v1OOqCo5w6Tx0mEe95OssmZI8VBlV5NsdwJV+zSQdenPCvio8mj/sjBL/13EZ
	 8tJ+/hQUi8PdbEY6yAsZLPKut7qXgqoALIh5LB9jtwzUlwoh0VbOvYLxUjPr7ut/BQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793115854;
	h=Received:DKIM-Signature:Received:Message-ID:User-Agent:Date:From:To:
	 Cc:Subject:References:MIME-Version:Content-Type;
	bh=azcg7d1eP1GSCwwf6vHG33FdrWswOi+yIuOTdqpdfFI=;
	b=wSSaJ9RlKEaj0PJkC/u3VSh3ki13fxZH5vUwagjwnshA0ftSl2885g+Bt5No7LI/bR56
	 TPeBQmjYWO61HuvbYbFal/b+1HSnFQdN5TeqJsE23XEOjwNdK1VzDuL7kUeYy3zqywj3O
	 X+owgdg2MuljzTpGK+fbtMuAwDP/S0dk4yPmudZPupQclahxk6FcmeesT6POKGd6//H4m
	 S1IfUtn0JXjzwa3TCVN1jBwkJWbxgR+rafTiX0Ix386FRiiLFvomYJRYZ1oB1KweaX3E/
	 d9hWIEZWr2MNHc+fkcINgkKtXW8GaTEKCdTXMNMvfrGjIr8SuqLP1J+JBem+d6bfcOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RmZhbbU0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52998606A329;
	Tue, 27 Oct 2026 15:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RmZhbbU0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141061F031E0;
	Tue, 27 Oct 2026 15:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793115854;
	bh=azcg7d1eP1GSCwwf6vHG33FdrWswOi+yIuOTdqpdfFI=;
	h=Date:From:To:Cc:Subject:References;
	b=RmZhbbU0xMF39dlPMHj471aI1Pzkp+I32nSh24gjv327qpWzU7s7VV9ehmUe4iQNj
	 UyApf1ngkRQLCUDqn0fw07Mviig7WH6AJdutP3yhV8awViS6ysm7mtyniI91Rk2xPl
	 0lzYKQbWBN0lE6nIS5+RvElHZ8zvVI44Vc//K8/mmdtwOhU0r+MWw4nN+rwNGZvp98
	 PsY2m+t5ouiWlVRQkOvjcZXRNE0JpbNWr/PGTCvsGbcdmRXg90j4Yn7k8UDdiHosAG
	 3PB6HbGSniV5mzbDmZTWQpHNOCwrnukDl1Q84p5R3++bYR/RpkW4kjy6S/xZCaa1hu
	 7G/yhwSD7Ec1A==
Received: from rostedt by gandalf with local (Exim 4.100.1)
	(envelope-from <rostedt@kernel.org>)
	id 1xLjLR-000000078hO-1ium;
	Tue, 27 Oct 2026 11:44:13 -0400
Message-ID: <20261027154413.231874596@kernel.org>
User-Agent: quilt/0.69
Date: Tue, 27 Oct 2026 11:37:02 -0400
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
Subject: [PATCH 4/9] dma-buf: Use trace_call__##name() at guarded tracepoint call sites
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

Link: https://patch.msgid.link/20260515135927.2238823-1-vineeth@bitbyteword.org
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/dma-buf/dma-fence.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
index bd58688b81a7..f7dee2f7c0de 100644
--- a/drivers/dma-buf/dma-fence.c
+++ b/drivers/dma-buf/dma-fence.c
@@ -554,7 +554,7 @@ dma_fence_wait_timeout(struct dma_fence *fence, bool intr, signed long timeout)
 	}
 	if (trace_dma_fence_wait_end_enabled()) {
 		rcu_read_lock();
-		trace_dma_fence_wait_end(fence);
+		trace_call__dma_fence_wait_end(fence);
 		rcu_read_unlock();
 	}
 	return ret;
-- 
2.53.0
