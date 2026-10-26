Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793053846;
	b=G+3sSeobXOBBW8+8ZhgtA1zGCxDGoQl2jCYZY/Jltb8U9hDfN2CvwycxZJuwvn0z4qqG
	 uiuil6Drz0zt4I1Jl8WCplzBYd3bJBFLc8kbINr7DB9i/9vu4EyCkPH/lBAV/2zHTy+VF
	 YwvcuRCW3uQr2CAeXzY6kXg+dtVoNedDywS3bB6mdyHUUs5+cVEFkB1KaPd1srSwhTbhs
	 bQjI4/jP4Y+gFgPtnnNnyaSdPhwPjXz1W4fFyLMKEuMMwQHX+lA/yFqb02VoyE77B6FWR
	 l2PA8yPqShFTx2CH0Il37sbNERaGThzxqFn4wiufAiWDoXvhmug+hJK/Xyato1CokPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793053846;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=hDtNVLezgn7PdnL8lxuAMKA3HktkOtqQ7BOccgZ24og=;
	b=pxXrQR3Dl6Wt8VQcBnML9YgMyx4QEGRrSE0GGnYf33pn8l4uaxu71Hr2q0AP30vja+De
	 2B6xnQ5GK/4dH4KCfPNyCm3tfMEeYCTR570U4S47DWfM0Sw2dsp4USy/cwPnQHGjtiui6
	 SAUtAY0nzNjRgyulb536i3ghJWCJqylBgksWQXyR+LpNBiaQxLt/tT9ZDB4TF5OdYN3t3
	 kHCKLH9g0qUtpjZHFM3FIjtwFssCboawddl+Hk6banDKKvp0xmnu2CTScff6WiVVTBhcG
	 lRCHBOy75nnq8bn35wo1RsoD5Cg3Q0LnN0hh66FP6naPBq4PMJeRMf5LloCAoUFZ8kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WFbyZTea;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B554606A331;
	Mon, 26 Oct 2026 22:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WFbyZTea
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2237D1F01829;
	Mon, 26 Oct 2026 22:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793053845;
	bh=hDtNVLezgn7PdnL8lxuAMKA3HktkOtqQ7BOccgZ24og=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=WFbyZTeaLbCY7ikuEs02jXbJsHCKJuFY/nfKSONWHoJU/2S/39wsTuAQ8g+/Md79e
	 DB4TvvDXjasmcGt144E8xgtFsxUljyQhx2sGVcmNSUlwQK8UT6v1M2yr3CugiNXCkX
	 m6MweNqwjERuBLkScl1t31HP2jc07sHYYSpdSJ68gbrdL/+ctrs3iVv9aC7CSLkAjN
	 6sfOzrtVhHenVSn7PIuB9pFdtoetDWKLPpn/MlWVg4bOXaxKC0xsmnyNj/ErH2Bc6b
	 sj8C/3hyI7le0llJhynkd5e0XA9841gGOYgDuz95tXwTXvafMEg0Jn8hmj5vP/quKy
	 U4OyEGKm4+pCg==
Content-Type: multipart/mixed; boundary="===============9203731180031934646=="
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <10ab2f3b005f0df2c0a88e93e6917826d928bb1f82c6a645f942c099e48f8b6e@mail.kernel.org>
In-Reply-To: <20261026215226.3713941-4-jthoughton@google.com>
References: <20261026215226.3713941-4-jthoughton@google.com>
Subject: Re: [RFC PATCH 03/10] bpf: Fail sleepable user copy helpers when current->mm is NULL
From: bot+bpf-ci@kernel.org
To: jthoughton@google.com,akpm@linux-foundation.org,viro@zeniv.linux.org.uk
Cc: tglx@kernel.org,peterz@infradead.org,kees@kernel.org,arnd@arndb.de,david@kernel.org,ljs@kernel.org,liam@infradead.org,vbabka@kernel.org,rppt@kernel.org,surenb@google.com,mhocko@suse.com,seanjc@google.com,pbonzini@redhat.com,jmattson@google.com,axboe@kernel.dk,asml.silence@gmail.com,James.Bottomley@HansenPartnership.com,mkp@kernel.org,dsterba@suse.com,mason@kernel.org,ast@kernel.org,daniel@iogearbox.net,john.fastabend@gmail.com,jpoimboe@kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,mingo@redhat.com,acme@kernel.org,namhyung@kernel.org,linux-mm@kvack.org,linux-fsdevel@vger.kernel.org,kvm@vger.kernel.org,io-uring@vger.kernel.org,linux-scsi@vger.kernel.org,linux-btrfs@vger.kernel.org,bpf@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-perf-users@vger.kernel.org,linux-kernel@vger.kernel.org,jthoughton@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.
 org,ihor.solodrai@linux.dev
Date: Mon, 26 Oct 2026 22:30:45 +0000 (UTC)

--===============9203731180031934646==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> bpf: Fail sleepable user copy helpers when current->mm is NULL

TL;DR: Commit message only: the security_file_release() example of a sleepable
program running from a kworker looks inaccurate, since such a program appears
not to be attachable there. The fix itself looks justified.

> bpf: Fail sleepable user copy helpers when current->mm is NULL
>
> Sleepable BPF programs can run on behalf of a kernel thread, or of a
> task that has already gone through exit_mm(). For example, bpf_wq
> callbacks always run from a kworker, bpf_task_work callbacks queued
> late enough run from exit_task_work(), and lsm.s or fentry.s programs
> may be attached to functions called during exit_files(),
> exit_task_work() or from kernel threads (e.g. security_file_release()
> from a kworker running delayed_fput()).
> In such contexts, bpf_copy_from_user(), bpf_copy_from_user_str() and
> bpf_copy_from_user{,_str}_dynptr() (when reading from the current task)
> call copy_from_user() or strncpy_from_user() without an mm. That access
> does not reliably fail: the user half of the address space belongs to
> whatever mm happens to be lazily loaded, if any, so the program may read
> another task's memory.
> As there is no user memory to read from in this case, fail with -EFAULT
> without attempting the access.
> Fixes: 07be4c4a3e7a ("bpf: Add bpf_copy_from_user() helper.")
> Fixes: 65ab5ac4df01 ("bpf: Add bpf_copy_from_user_str kfunc")
> Fixes: a498ee7576de ("bpf: Implement dynptr copy kfuncs")
> Signed-off-by: James Houghton <jthoughton@google.com>

The commit message gives security_file_release() as an example of a place
where an lsm.s or fentry.s program can run from a kworker:

> (e.g. security_file_release() from a kworker running delayed_fput())

Is this example accurate for the tree being patched?

bpf_lsm_file_release is not in the sleepable_lsm_hooks set in
kernel/bpf/bpf_lsm.c, so btf_id_allow_sleepable() rejects a sleepable
BPF_PROG_TYPE_LSM program there.  bpf_lsm_file_free_security, the other hook
reached from __fput() through file_free(), is in untrusted_lsm_hooks rather
than the sleepable set.

For a BPF_PROG_TYPE_TRACING program, check_attach_sleepable() requires
within_error_injection_list(addr) (or a syscall prefix when
CONFIG_FUNCTION_ERROR_INJECTION is off), or an fmodret set with
KF_SLEEPABLE.  Neither security_file_release() nor bpf_lsm_file_release()
has ALLOW_ERROR_INJECTION, and the only fmodret sets are in
net/bpf/test_run.c, net/mptcp/bpf.c and bpf_testmod.

That suggests a program attached to security_file_release() is never
sleepable and cannot call bpf_copy_from_user() or the KF_SLEEPABLE copy
kfuncs.

The fix itself still looks justified, since bpf_wq callbacks run from a
kworker and is_async_cb_sleepable() is true for them.  Only the example
appears to be off.

Would an example that is actually reachable keep the changelog accurate?
For instance, bpf_lsm_task_alloc() when kthreadd forks a kernel thread
(current is kthreadd), or bpf_lsm_kernel_read_file() and bpf_lsm_file_open()
when a kworker loads firmware with kernel_read_file().  All three hooks are
in sleepable_lsm_hooks.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/40410166379
--===============9203731180031934646==--
