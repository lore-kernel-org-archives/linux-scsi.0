Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793115855;
	b=AZQdHTgd/iFGntHZuUVYl1Kf1HgfP1rDkEP/6+Cc+mkiF5R3ijtvouuBBgoHmQYvggyt
	 ufdoFriPh03h+UbAlBUNGw9rkm7Tn8FMF8YZtOkKFIqtbS7JaqWv9stkNOwz/GCissxXH
	 /4XCYrO+eMFqtbxqom4fj4JutAc0suJZnHlnaRyKXHx9nY692ZH44h1CTon7ilp3gEaDq
	 deb5pPr3lauE1Uy55QSEZV9MQU47qemwRsMtpNeXcaNp+nroS9QrJng90Z3RfIO8YIJCV
	 4nn2ZvvZH7jOlfJgGArOVOEN4JeaflzsEntWUJNwRTk1MVyFeWWe3u50JH7dZf6uO1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793115855;
	h=Received:DKIM-Signature:Received:Message-ID:User-Agent:Date:From:To:
	 Cc:Subject:References:MIME-Version:Content-Type;
	bh=65ibzMdITZGSAinHNOg+LTDdIfpABOn2+CpyYHzaFRs=;
	b=w2vjufNOoKuwPYCE4+EYmWTkJUPUaMsd4wCvIMBRJ3atOuyZFqiXNnRN58D/2PSCUm2x
	 cZvXCAUXahjLWKoYtw+dAXVgJvCq/xEvXaWLgREEYfmKIGSZV9iid/Oh3iyS1oZ4gQAH5
	 vv/GCRwC925Z6NfPBywF1Uj1CT4mlZSrOYQL/bqjS/js6YgnGX14eMD83XUsmiLwjKN8m
	 kQJ9a1AV5+q5ajbbFzVA6R04mLAouMflj+H1kO8WFMzaRiK//ZaWxLGJTE/2w4Xn553jg
	 ypRGAgUrwROHK5gY6AGtEXt9uVoHHtmy7EEHWOa+W5pKMsEDE/4MhHkiYyKiyjzQL7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ILrstzel;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480EF60A262A;
	Tue, 27 Oct 2026 15:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ILrstzel
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EB01F031EC;
	Tue, 27 Oct 2026 15:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793115855;
	bh=65ibzMdITZGSAinHNOg+LTDdIfpABOn2+CpyYHzaFRs=;
	h=Date:From:To:Cc:Subject:References;
	b=ILrstzel9sh37XBGgpdGLVoMZZPwgFmzqTPYiJYdvHBD2VW/wP7qteo/K2QbcrcgN
	 hHTd29eWnKhMWjnGR6ag5JLvmd0f+VAVAcMjHbxUFv7v6i6p8LO3QgMbHcuOBAyA6r
	 PRwNWLLNmG/DdOwJpG4XAz1QoP+ANfM0NLFCjQ1xSYxSU3sr1nI7FYlBg4cpLsHYvP
	 b8ykWLq92n2UhVg1XBzUtlktg7Zvf/Tpzl3/2WFxAW7/cWK0juK5sz6qDJFK8o3rn8
	 imb0TrnpC8AATsUq8uc4J8Is1et9nN/XgP/s1eRBRG5fRWoiOyTW16S16Aw/4zFPXk
	 BdM2I95nC1z/w==
Received: from rostedt by gandalf with local (Exim 4.100.1)
	(envelope-from <rostedt@kernel.org>)
	id 1xLjLS-000000078kD-1Ukd;
	Tue, 27 Oct 2026 11:44:14 -0400
Message-ID: <20261027154414.184324075@kernel.org>
User-Agent: quilt/0.69
Date: Tue, 27 Oct 2026 11:37:07 -0400
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
Subject: [PATCH 9/9] x86: msr: Use trace_call__##name() at guarded tracepoint call sites
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

Link: https://patch.msgid.link/20260515140004.2238951-1-vineeth@bitbyteword.org
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/lib/msr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index dfdd1da89f36..14785fe5e07b 100644
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
@@ -125,21 +125,21 @@ EXPORT_SYMBOL_FOR_KVM(msr_clear_bit);
 #ifdef CONFIG_TRACEPOINTS
 void do_trace_write_msr(u32 msr, u64 val, int failed)
 {
-	trace_write_msr(msr, val, failed);
+	trace_call__write_msr(msr, val, failed);
 }
 EXPORT_SYMBOL(do_trace_write_msr);
 EXPORT_TRACEPOINT_SYMBOL(write_msr);
 
 void do_trace_read_msr(u32 msr, u64 val, int failed)
 {
-	trace_read_msr(msr, val, failed);
+	trace_call__read_msr(msr, val, failed);
 }
 EXPORT_SYMBOL(do_trace_read_msr);
 EXPORT_TRACEPOINT_SYMBOL(read_msr);
 
 void do_trace_rdpmc(u32 msr, u64 val, int failed)
 {
-	trace_rdpmc(msr, val, failed);
+	trace_call__rdpmc(msr, val, failed);
 }
 EXPORT_SYMBOL(do_trace_rdpmc);
 EXPORT_TRACEPOINT_SYMBOL(rdpmc);
-- 
2.53.0
