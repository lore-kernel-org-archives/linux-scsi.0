Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793053844;
	b=GpDNJ4gGZyfLWJ5cV1hGblC8sRyf8zajUKyGXcnI6oDZUzdbWUlplz7OCd3kgcT+d2Yw
	 ka4FXNAkp+a9VKSmToACWw3HKkvwnw8MVxoT9EIYNVHjvL4YmKH4SH+TrSLKguX+Dojf3
	 Ae/rF1ooXGLI2Xj7/CEl7ApSUCL2NmDD97Djm2Kzm3IM3H4x5f7k291wbc21ZzCxZ7Gqi
	 fnmMWnTD0u/3b/gIqnXql0IdCJYdmBHvwN4EwHuZeuBNMIWQQvHKliKx2e7qDB69bxffI
	 cweerDNk93OYb1DZogS21AL3NF3eMmw/hYXj4kMFUXH7k0X0LoRHp/5iTRGDFfgMDwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793053844;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=dmscNNXpR9Tlb5LZlm76LmXvzMKP1GvB98Aa5akaxVg=;
	b=roF2vcylbXjHHmBtey48wbiwzWjbnbqr0abKVkOtfsUyG+f3rKp48NBZ99BOz8h7zs/5
	 b4ds34yZhn3us/Rc03vRvPeQBw6XLmj8qKcJOYKBAB7hqRtqjcxTP+D9gRFC/KK7BnteV
	 0nAB+HZErlusxAydn5MHf/I+Yx6nboD37jxhNbZVktg+0+ewNofQDJ2tBeK53yNO1Axd2
	 lLZb0U4XNJ/BYrN9++oJT7Y8sT+FFNyPGJMuhIflRuRe9GsTxevz34Cdxj0b60xtM4MrS
	 zjWaWl2YAVVbYzN5jOBbaLfD8EBdiw0BsRVzzcw3jgOy6ZYBm/GrKNpBOGb5+xve0Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dr+bFo+7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A93606A31A;
	Mon, 26 Oct 2026 22:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dr+bFo+7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46EC1F01825;
	Mon, 26 Oct 2026 22:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793053843;
	bh=dmscNNXpR9Tlb5LZlm76LmXvzMKP1GvB98Aa5akaxVg=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=dr+bFo+7z5+CTwiGHeYIy9H24IjvPgf4TRxSimSjSs3n/yAhL9aRSZINo/x5mroHe
	 IomSvINKTXigvFZ4T2r4pQS6DcTQna3EE9nzEaCD82hejA4AZ3C7UlSxPbJbhFSHxy
	 Di/MXuc0u3/DB8dqNapb7z2siMBwUqQB6nYCMuq4/0PMPiMdvRGNrUrJkXSpvs0w3z
	 2AT3Q8x/a6nwJyggelSWmXb4qTG5Z6QAbLhvcEzt6dxwgv3iYRFYhWUqc9QXSKF1rA
	 6AS+VQieQSX/Ma92ZXhyBaeeXWlR1S0w7QnMoMkQeDXfNXkfAbaABsGjNgcpENxttB
	 vTydLvfW/5xGw==
Content-Type: multipart/mixed; boundary="===============5289104665204023220=="
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <bce97570ea9665a2f83216d4dfd7ab7ce17d54aa777f761c3d12db430ba21bb9@mail.kernel.org>
In-Reply-To: <20261026215226.3713941-5-jthoughton@google.com>
References: <20261026215226.3713941-5-jthoughton@google.com>
Subject: Re: [RFC PATCH 04/10] stacktrace: Don't unwind the user stack without an mm
From: bot+bpf-ci@kernel.org
To: jthoughton@google.com,akpm@linux-foundation.org,viro@zeniv.linux.org.uk
Cc: tglx@kernel.org,peterz@infradead.org,kees@kernel.org,arnd@arndb.de,david@kernel.org,ljs@kernel.org,liam@infradead.org,vbabka@kernel.org,rppt@kernel.org,surenb@google.com,mhocko@suse.com,seanjc@google.com,pbonzini@redhat.com,jmattson@google.com,axboe@kernel.dk,asml.silence@gmail.com,James.Bottomley@HansenPartnership.com,mkp@kernel.org,dsterba@suse.com,mason@kernel.org,ast@kernel.org,daniel@iogearbox.net,john.fastabend@gmail.com,jpoimboe@kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,mingo@redhat.com,acme@kernel.org,namhyung@kernel.org,linux-mm@kvack.org,linux-fsdevel@vger.kernel.org,kvm@vger.kernel.org,io-uring@vger.kernel.org,linux-scsi@vger.kernel.org,linux-btrfs@vger.kernel.org,bpf@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-perf-users@vger.kernel.org,linux-kernel@vger.kernel.org,jthoughton@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.
 org,ihor.solodrai@linux.dev
Date: Mon, 26 Oct 2026 22:30:42 +0000 (UTC)

--===============5289104665204023220==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> stacktrace: Don't unwind the user stack without an mm

TL;DR: Commit message only: the Fixes: tag may point at the wrong commit;
7e8e6816c649, which dropped the !current->mm check, looks like the real
culprit rather than 214d8ca6ee85.

> stacktrace: Don't unwind the user stack without an mm
>
> stack_trace_save_user() only refuses to unwind the user stack of tasks
> with PF_KTHREAD set. That doesn't cover all tasks without an mm:
>  - A user task that has already gone through exit_mm(), e.g. when an
>    event fires from exit_files(), exit_task_work() or the final context
>    switch in do_exit().
>  - PID 1 before it execs init, and usermode helper children before they
>    exec, which are created with user_mode_thread() and don't have
>    PF_KTHREAD set. E.g. booting with trace_options=userstacktrace and
>    an event enabled with trace_event= unwinds PID 1's "user stack"
>    during initcalls.
> With the ftrace userstacktrace option enabled, the architecture
> unwinders then read the user stack without an mm. That access does not
> reliably fail: the user half of the address space belongs to whatever
> mm happens to be lazily loaded, if any, so the unwinder may read
> another task's memory.
> Use is_user_task() instead, which also checks current->mm, as perf
> already does for the same reason since commit 76ed27608f7d ("perf:
> sched: Fix perf crash with new is_user_task() helper"). This also stops
> unwinding the user stack of PF_USER_WORKER threads, which never run in
> user space, matching perf.
> Fixes: 214d8ca6ee85 ("stacktrace: Provide common infrastructure")
> Signed-off-by: James Houghton <jthoughton@google.com>

Is the Fixes: tag pointing at the right commit?

When 214d8ca6ee85 added the ARCH_STACKWALK version of
stack_trace_save_user(), it guarded the unwind with:

	/* Trace user stack if not a kernel thread */
	if (!current->mm)
		return 0;

That check already covers both cases described above (a task past exit_mm(),
and PID 1 or usermode helpers before exec, which have mm == NULL).

The check was replaced by commit 7e8e6816c649 ("stacktrace: Use PF_KTHREAD to
check for kernel threads"), which switched it to:

	if (current->flags & PF_KTHREAD)
		return 0;

That dropped the no-mm protection, which looks like what this patch restores
via is_user_task().

Should this be:

  Fixes: 7e8e6816c649 ("stacktrace: Use PF_KTHREAD to check for kernel threads")


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/40410166379
--===============5289104665204023220==--
