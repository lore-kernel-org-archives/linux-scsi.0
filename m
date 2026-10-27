Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793115854;
	b=WUWj5kq3Pk6eViPkn/kCmA5TiRLuBpAC39mZX252UIRKIIhRipKWYDtVuI6kcXobfrIH
	 CcRhqubKRqci9qSqTZzmHYjNoYS8l5WyJdz61wQputj1IK7ZaFdwExM9j67MYYuOAcuh9
	 WVgDFNSh8c2LjPc7T8O3+6H00qfIkcHTW65CKRvVoKpHCBC9AsX28NQOI3UkF1qOa9Wfs
	 X/wK74Xscu4o9CRGXT1xTmPpYP5nFF/IJiynTdmySa6won4pgfTgZaqCMUoLXWnYsvjpx
	 JaQ/qZ5r8H4v+Rzl9Ly93OGNXkrHR2weeB/NxG2B2jGGFbfZuMVcnle1OBDmVh78w4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793115854;
	h=Received:DKIM-Signature:Received:Message-ID:User-Agent:Date:From:To:
	 Cc:Subject:References:MIME-Version:Content-Type;
	bh=fpo83JJokXYjEujj6r4TMCvSFPUafgC/gibglk3KIJo=;
	b=BR16/TxzabRcLWOiDor9flTWd3yTiZLE2YPs+FFCMIcJX+tWybwWewVfcG4cU5zU+8lz
	 EnutPpRb08cUk3775hu1LNplJi/EFs6M0Uofdy5eNdd3NtkhxblitHRIdORIxMs5Ls4fH
	 GTuxSHbAJdjlCPuZJRv1eByCvkmFXPlnFsqqmXg4tog3JtkoqZJ2J75Z6JQPNi6XR+u9C
	 +F7rSDfc/aFEbr40uSJqu8EACcAUjDlDFmUOE3U0IsRVXtSB7BsufE8MZA1S7CY8XkVmA
	 LUrnFWOduGzpEGDjy/luOp9Yv2R1nhysI0i4YgCuMGvEJUQXj3wu5PYUtSl8eFIXKDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dRCE5OfD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DF5606A32D;
	Tue, 27 Oct 2026 15:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dRCE5OfD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C031F031F4;
	Tue, 27 Oct 2026 15:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793115854;
	bh=fpo83JJokXYjEujj6r4TMCvSFPUafgC/gibglk3KIJo=;
	h=Date:From:To:Cc:Subject:References;
	b=dRCE5OfDYXBgtk7dnfD1xuKrA7mtXKGbWDZc2l5bgSltXOnLKtL5O94PrcC1+w2nX
	 mrfpPSfkYE5jIaO0gEX2OfLARGnOE7JoPLNa8tK7YDbCvx5NX24LiQHtjHb2CdNmTL
	 WyyDzMMJKgjtdgVcmCIkBLVWuiS/oaldsrvG+V710MKSt8wtxll4vys7tH9SOL2zsD
	 E9FyKgeWCnJd0NxfgfSVeo7Uf/+nYxMJqYhpLGAgq+T8kFi9Kk/sVJjPpIJYxVU+De
	 VCIcMdrlzZmaP16CqcZ4AMUqRTmDxoOkkk6SvY7bdjEA85piOfEnjkP2ng4Vc3YAAl
	 lAq5Kv48fwh/Q==
Received: from rostedt by gandalf with local (Exim 4.100.1)
	(envelope-from <rostedt@kernel.org>)
	id 1xLjLR-000000078hw-2W0c;
	Tue, 27 Oct 2026 11:44:13 -0400
Message-ID: <20261027154413.428706632@kernel.org>
User-Agent: quilt/0.69
Date: Tue, 27 Oct 2026 11:37:03 -0400
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
Subject: [PATCH 5/9] drm: Use trace_call__##name() at guarded tracepoint call sites
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

Link: https://patch.msgid.link/20260515135932.2238842-1-vineeth@bitbyteword.org
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c   | 2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c   | 4 ++--
 drivers/gpu/drm/scheduler/sched_entity.c | 5 +++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 5558e7330cf4..8873e28f526f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1025,7 +1025,7 @@ static void trace_amdgpu_cs_ibs(struct amdgpu_cs_parser *p)
 		struct amdgpu_job *job = p->jobs[i];
 
 		for (j = 0; j < job->num_ibs; ++j)
-			trace_amdgpu_cs(p, job, &job->ibs[j]);
+			trace_call__amdgpu_cs(p, job, &job->ibs[j]);
 	}
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index 2bd07007def4..f10e443e1ebe 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -1425,7 +1425,7 @@ int amdgpu_vm_bo_update(struct amdgpu_device *adev, struct amdgpu_bo_va *bo_va,
 
 	if (trace_amdgpu_vm_bo_mapping_enabled()) {
 		list_for_each_entry(mapping, &bo_va->valids, list)
-			trace_amdgpu_vm_bo_mapping(mapping);
+			trace_call__amdgpu_vm_bo_mapping(mapping);
 	}
 
 error_free:
@@ -2189,7 +2189,7 @@ void amdgpu_vm_bo_trace_cs(struct amdgpu_vm *vm, struct ww_acquire_ctx *ticket)
 				continue;
 		}
 
-		trace_amdgpu_vm_bo_cs(mapping);
+		trace_call__amdgpu_vm_bo_cs(mapping);
 	}
 }
 
diff --git a/drivers/gpu/drm/scheduler/sched_entity.c b/drivers/gpu/drm/scheduler/sched_entity.c
index 7be0387bac3c..ddf161a47742 100644
--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -500,7 +500,8 @@ static bool drm_sched_entity_add_dependency_cb(struct drm_sched_entity *entity,
 
 	if (trace_drm_sched_job_unschedulable_enabled() &&
 	    !test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &entity->dependency->flags))
-		trace_drm_sched_job_unschedulable(sched_job, entity->dependency);
+		trace_call__drm_sched_job_unschedulable(sched_job,
+							entity->dependency);
 
 	if (!dma_fence_add_callback(entity->dependency, &entity->cb,
 				    drm_sched_entity_wakeup))
@@ -630,7 +631,7 @@ void drm_sched_entity_push_job(struct drm_sched_job *sched_job)
 		unsigned long index;
 
 		xa_for_each(&sched_job->dependencies, index, entry)
-			trace_drm_sched_job_add_dep(sched_job, entry);
+			trace_call__drm_sched_job_add_dep(sched_job, entry);
 	}
 	atomic_inc(entity->rq->sched->score);
 	WRITE_ONCE(entity->last_user, current->group_leader);
-- 
2.53.0
