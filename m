Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793051572;
	b=5TrU1EqTYiF57kcpdtyE00cH1eVLXHu6uq7VzVaf7mjiWGDPrBlqLzVX4zjT2vQ76B0q
	 EZw1Y0NKOT03Fm7nT4NPQOWOtsLA8esOCeoab1Bafp9PD4USUNtGD2Db/CvhYsL4rDODN
	 dsEtHlFWhamaEOePu6IT0CUeULeC+LLIWoJmPqVxsQyXjIZRM107mb7A9nG0AM21ulk0V
	 OKKovF/euPGCMGKTcNh5AaijM47nFrtudplDG9qCTZtu1upTcGJknRKnKJKQxKo3o6zkc
	 VuIq4AJHsGFwc5NFy8w3uVbyll+gjs2f7cqmVi10IMC//Ckk+OcpoAzEMW3OKapVELg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793051572;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=0zQfCS+xbNCI3ecGYMw9q9f4jA1EzYR8/pz81vPbgxA=;
	b=hUGmYkoOib8Cg79lP2Q52w75oEQHvEtB1P2oCTJNojR5S1Cb0jRPtXoljN+njFauaWGf
	 sxLQ3iKFKmubW9uBItwBMoyZP/rTSq+Ejz8cM+Ts747wu9J+YYP0STwKpJbLUg2qV3gi0
	 Uj81G5QCusUBqgCdM2hvioZJrqHJDy9v1SCMS0EH0fnpPzJYfLVt82ng5FhUGbLL8xQ6y
	 tUOGPwu6inBrI8pih4JCz8sxfEFQPQ6psyKyj0wXqQmnxnX68nTEoYOSlZzOLugWr6uUN
	 B7/enn0TVFiSqL1g8tWpDAdxoJRVXVwKhD83cNjdNpaMYElugaBotv+2GXapoDNbaIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Kqiy+Ob4;
	arc=none smtp.remote-ip=209.85.210.197
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2316560A3816
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 21:52:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2316560A3816
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Kqiy+Ob4
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8a59717b0c0so1041668b3a.3
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 14:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793051571; x=1793656371; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0zQfCS+xbNCI3ecGYMw9q9f4jA1EzYR8/pz81vPbgxA=;
        b=Kqiy+Ob4bSiepbdF/N+HCw9a9Ypov8HtKYAWKHLmMbdMoQ6/AQK8N+3/9GSPszOCs/
         1wDw9g6G84lPjg+5wnqK7GtKOgVXqBV6g60MSjrdYOR6qiIDrhmWrnkvTapXpk3t5+aT
         hq8wJ5b/uxQvjGqh0YiMIwILe8l+czxItEMT+zJ4ZtkENFNlAT9HnocU0M1kD6x4BmQb
         r6bsNPbldLhR8EOtCoFFvhafOcZ8Ol+iWaiupqeMir9Atbgnv2A2OMD0tKsJD9WbmYwb
         osWTHPRSBSi+yCRc08AKi5oB3BSbsJN6aXIdfxr7eCzW6nmLWMpzC3ngMIalK5Ey9Fgw
         7pHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793051571; x=1793656371;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0zQfCS+xbNCI3ecGYMw9q9f4jA1EzYR8/pz81vPbgxA=;
        b=p1n66oyrT+GKGx9/zGq8zx63JH25Z2JlkwTGUpbCrXZW6CteXElWv+2BMHGkGph2ME
         OloIS/zhK3gId6n2XzptiqjodngXSq1SrTEraA+72bTFKOOdL+o1nIifF6bXJjRcfn1o
         gz+KATQVUARx6DTQ3J6pziE3t4wk8FNl/Faar17LjOXQtCl2MVl2JTis5NcZk/FRcv1J
         CRK2GDEaYC/NtbieV+CtElsPNhdfyA/4yXXIFaa2AMlTATlD9KTQ/f8DCylgS380uq1h
         DZ7OhpYnKVCbpNcegTGF5BtMw0VoGUU0ylxGXC7g63FN0oOQsXdFd1g+PVIbDOdfQnbr
         YqPA==
X-Forwarded-Encrypted: i=1; AKwUvBw19DFYbj8mw+Nx7rW5aTENxtYIKr0C20HADlwMAfyFxJPrJmrXlVXye6h7TfCfJeDKyCU6dWKIZeyB@vger.kernel.org
X-Gm-Message-State: AFq9FYJTMyteYDXgNZM2SC8kTNLpqR+DKGxV2C4XbWuz9UQAH0xAf6j2
	Nucd7nUO/wDr6UmpAzbgzvRd//GoRYwKL8sL9/VQxYHLTCn/3WarIFjpgZpvGPB+WQhWPxghInv
	qhSRrAMObl86DgffNYsLrmg==
X-Received: from pfbho14.prod.google.com ([2002:a05:6a00:880e:b0:8a0:6a08:e927])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:bd81:b0:87c:e44e:5694 with SMTP id d2e1a72fcca58-8a366b88ce9mr5902881b3a.21.1793051571129;
 Mon, 26 Oct 2026 14:52:51 -0700 (PDT)
Date: Mon, 26 Oct 2026 21:52:20 +0000
In-Reply-To: <20261026215226.3713941-1-jthoughton@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261026215226.3713941-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261026215226.3713941-5-jthoughton@google.com>
Subject: [RFC PATCH 04/10] stacktrace: Don't unwind the user stack without an mm
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Kees Cook <kees@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jim Mattson <jmattson@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

stack_trace_save_user() only refuses to unwind the user stack of tasks
with PF_KTHREAD set. That doesn't cover all tasks without an mm:

 - A user task that has already gone through exit_mm(), e.g. when an
   event fires from exit_files(), exit_task_work() or the final context
   switch in do_exit().
 - PID 1 before it execs init, and usermode helper children before they
   exec, which are created with user_mode_thread() and don't have
   PF_KTHREAD set. E.g. booting with trace_options=userstacktrace and
   an event enabled with trace_event= unwinds PID 1's "user stack"
   during initcalls.

With the ftrace userstacktrace option enabled, the architecture
unwinders then read the user stack without an mm. That access does not
reliably fail: the user half of the address space belongs to whatever
mm happens to be lazily loaded, if any, so the unwinder may read
another task's memory.

Use is_user_task() instead, which also checks current->mm, as perf
already does for the same reason since commit 76ed27608f7d ("perf:
sched: Fix perf crash with new is_user_task() helper"). This also stops
unwinding the user stack of PF_USER_WORKER threads, which never run in
user space, matching perf.

Fixes: 214d8ca6ee85 ("stacktrace: Provide common infrastructure")
Signed-off-by: James Houghton <jthoughton@google.com>
---
 kernel/stacktrace.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
index afb3c116da91..f96a5ec12f6c 100644
--- a/kernel/stacktrace.c
+++ b/kernel/stacktrace.c
@@ -228,8 +228,12 @@ unsigned int stack_trace_save_user(unsigned long *store, unsigned int size)
 		.size	= size,
 	};
 
-	/* Trace user stack if not a kernel thread */
-	if (current->flags & PF_KTHREAD)
+	/*
+	 * Trace user stack only if this is a user task that still has an mm,
+	 * i.e. not a kernel thread or user worker, and not a task that has
+	 * already gone through exit_mm().
+	 */
+	if (!is_user_task(current))
 		return 0;
 
 	arch_stack_walk_user(consume_entry, &c, task_pt_regs(current));
-- 
2.56.0.307.g5fe7bd680c-goog

