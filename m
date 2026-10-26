Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793051574;
	b=WtontpDFyqd0SFkFaXfEIdsVbSPK9RmR8mqVVZKE0t1eT63/9mlu4LK5HQffv3FBwnJz
	 ECtoj0D0tBBi1NKMDRXZhzMPJlIQ8U/KS4H6SIssKVtpokq5+RVl9LHVABNwE8rUOB7RB
	 agL2Qfa4uVdBRzZN30VxdRUK1ZXzAbhiZKaBeUNh84saUj5VvYKFfIxgMxedDhYAVGu9e
	 s9bkK8L93MEQ01+Jl86XD3mD8+vM0VfhRwwvObwV7Dv6Uj3UDu9Zg3wIDfE8UmtoOhC0E
	 TZJkVrRwcuv/DY/Tijso8ey38yx8yqvdCcSjZryz0w7TOL0Um0Y8tKD84u+6c8HNv6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793051574;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=cYBRYm53aIgyLidEi/RI31/ngJcANLPfjWm3HzPNi4M=;
	b=BLjXWl3Lb+brn7/R9Tk2Vih1jOvBP/lVQKRsfEjyZRUCfCj5/yfH+EXL4S27XNUdQ0QN
	 djaHAC112kjmoOYTk3iUaFikiBGVH500SEFg2BY7JFnzaYw4/gG3rF3Fng2XM5isAgWqH
	 EqvTe7GHj0sWA+Ix9O8h6A6HpcLMAJOllDvSBHRtF8U1ZmAj0CgAU+WyeCcsC28dpdBxD
	 b4uql0tgEYt/ENm4onsSY9O506YSGpMJ+oQMt1iZpMJsq3MBS5HGKJRK34m/r1yhPnfRN
	 WJGUdKkZAz2u4pA6tXk3ei2f6LWRvLzEBlsvTCAVAtwO++EV6pDJG1wggwNg5pcjp2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=CvG0Fy7g;
	arc=none smtp.remote-ip=209.85.216.71
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C742460A5BCF
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 21:52:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C742460A5BCF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=CvG0Fy7g
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ac0ae43900so3398682a91.0
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 14:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793051573; x=1793656373; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cYBRYm53aIgyLidEi/RI31/ngJcANLPfjWm3HzPNi4M=;
        b=CvG0Fy7gZIv2FTt2FLi/I4EtmhrrdDUp0LMHK2e4OFiGbeZTP3anWci5lM/QVrw/H/
         vjprgqeI7Qf9DFSiI1EjYmA+NS+U8yLIMnl0OtrbcRYf5Yx2EdFq4bQctlNGf9haYRxk
         zNOY3needT5Dpogs2gFazhUPqrGCvlqBMur+MB6IXA8lRBX5MJRSdMIgYwVgDWxC+xVD
         /gOzfwe4ZxDGF2x8WsA3INU3jvJi5tteYqQn27Fg8BipvdjcomyZJXXlXk3f8l341y6c
         eOkADpgnRFASfGK7dklKQl3bIpeDuRbf+lJ1Y+nNaXwWEPiWKf9RujwO8Uw/gehBi/kO
         jo5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793051573; x=1793656373;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cYBRYm53aIgyLidEi/RI31/ngJcANLPfjWm3HzPNi4M=;
        b=BPHRWeAjdxN7N+cmMNQasvw1SV3U18p/o+ZCfFQQ4GkEFNMGLUnN5IhBtI0PrKkbrT
         hzO83CgvXa6DjVN32AYSoA60Hi+bBpVNcbnCroHdLaAQcqVeWS7VRVqW5bwKcGeG/J3S
         l12qpxj15wJueCUZd/IN9wIRmVqeIypoRXiW2yA9Nhcxk4pMCz2Kx2mugKgP9+lqEVuw
         OKeZam8vl32sUISYm7PIJqcVhOxyKyYeKEi5UwOli87+gBXAk9slxf1HcsTfMCrf+wok
         Sw2edKveunaHnICDpfw3B51G1iPswK26CvIR9CM41SmgsizdffXpMLXSS9btsHrE+OMG
         gckg==
X-Forwarded-Encrypted: i=1; AKwUvBw43grr63EddkIVXx9pG3nll9RtImrRTuZrbubnZXU6NDRoh1YlcRJ0nMTIHo1bWl7Y/5zlO39HS/G5@vger.kernel.org
X-Gm-Message-State: AFq9FYI5sq83d5mguzyahfwZILTi/h/f/Cbp6MNqNHymKCmBwxhj0wxr
	QADzJ2wA8DxQBpQoST58wbxizp1mC7tJsOS6aN3vKYMvywQBzIPR8yIfb05RIUtJEu0xQ7k4UOg
	Ab81U+TmuCIdtxtpu49t31w==
X-Received: from pjst21.prod.google.com ([2002:a17:90b:195:b0:3ab:3d7f:6c0c])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3ec7:b0:3ad:3715:d21 with SMTP id 98e67ed59e1d1-3adeafb0481mr6464242a91.49.1793051572848;
 Mon, 26 Oct 2026 14:52:52 -0700 (PDT)
Date: Mon, 26 Oct 2026 21:52:22 +0000
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
Message-ID: <20261026215226.3713941-7-jthoughton@google.com>
Subject: [RFC PATCH 06/10] uaccess: Refuse and warn on user copies when
 current->mm is NULL
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

Accessing user memory from a task that has no mm is always a bug. This
can happen from a kernel thread that is not using kthread_use_mm(), or
from a task that has already gone through exit_mm() (e.g. when the last
reference to a file is dropped from task_work at exit). KVM has had
bugs of exactly this kind, and other drivers may have them too.

Such an access does not reliably fail. The user portion of the address
space belongs to whatever mm happens to be lazily loaded, if any. If
the access faults, the fault handler refuses to handle it and the copy
fails, but if the page is already mapped, the copy silently reads or
writes another task's memory.

Add uaccess_should_fail(), which combines the existing
should_fail_usercopy() fault injection check with a
WARN_ON_ONCE(!current->mm), and use it in place of every
should_fail_usercopy() call. The user copy is then refused as if it had
failed, so no access to user memory takes place.

This covers copy_{to,from}_user() on all architectures, including the
masked user access paths that never call access_ok(), and the
__copy_{to,from}_user() variants used by KVM's guest memory accessors.
It also covers __copy_to_user_inatomic() (and so copy_to_user_nofault()),
the user-backed iov_iter copy routines and strncpy_from_user().

Paths that never called should_fail_usercopy() are not covered, e.g.
__copy_from_user_inatomic(), copy_from_user_nofault(), strnlen_user(),
get_user()/put_user(), clear_user() and unsafe_*() accesses within
user_access_begin() sections.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/uaccess.h | 27 ++++++++++++++++++++++-----
 lib/iov_iter.c          |  6 +++---
 lib/strncpy_from_user.c |  2 +-
 3 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index eddbbb65ccc4..8ab24e706a22 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -50,6 +50,23 @@
  #define mask_user_address(src) (src)
 #endif
 
+/*
+ * Return true if a user copy must not be attempted, either because a failure
+ * is being injected, or because the current task has no mm.
+ *
+ * Accessing user memory without an mm (e.g. from a kernel thread that is not
+ * using kthread_use_mm(), or from a task that has already gone through
+ * exit_mm()) is always a bug: the user portion of the address space belongs to
+ * whatever mm happens to be lazily loaded, if any, so the access could
+ * silently hit another task's memory.
+ */
+static __always_inline bool uaccess_should_fail(void)
+{
+	if (WARN_ON_ONCE(!current->mm))
+		return true;
+	return should_fail_usercopy();
+}
+
 /*
  * Architectures should provide two primitives (raw_copy_{to,from}_user())
  * and get rid of their private instances of copy_{to,from}_user() and
@@ -114,7 +131,7 @@ __copy_from_user(void *to, const void __user *from, unsigned long n)
 
 	might_fault();
 	instrument_copy_from_user_before(to, from, n);
-	if (should_fail_usercopy())
+	if (uaccess_should_fail())
 		return n;
 	check_object_size(to, n, false);
 	res = raw_copy_from_user(to, from, n);
@@ -138,7 +155,7 @@ __copy_from_user(void *to, const void __user *from, unsigned long n)
 static __always_inline __must_check unsigned long
 __copy_to_user_inatomic(void __user *to, const void *from, unsigned long n)
 {
-	if (should_fail_usercopy())
+	if (uaccess_should_fail())
 		return n;
 	instrument_copy_to_user(to, from, n);
 	check_object_size(from, n, true);
@@ -149,7 +166,7 @@ static __always_inline __must_check unsigned long
 __copy_to_user(void __user *to, const void *from, unsigned long n)
 {
 	might_fault();
-	if (should_fail_usercopy())
+	if (uaccess_should_fail())
 		return n;
 	instrument_copy_to_user(to, from, n);
 	check_object_size(from, n, true);
@@ -167,7 +184,7 @@ _inline_copy_from_user(void *to, const void __user *from, unsigned long n)
 {
 	unsigned long res = n;
 	might_fault();
-	if (should_fail_usercopy())
+	if (uaccess_should_fail())
 		goto fail;
 	if (can_do_masked_user_access())
 		from = mask_user_address(from);
@@ -195,7 +212,7 @@ static inline __must_check unsigned long
 _inline_copy_to_user(void __user *to, const void *from, unsigned long n)
 {
 	might_fault();
-	if (should_fail_usercopy())
+	if (uaccess_should_fail())
 		return n;
 	if (access_ok(to, n)) {
 		instrument_copy_to_user(to, from, n);
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 2072c04e99d0..3d6ecb50d778 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -17,7 +17,7 @@ static __always_inline
 size_t copy_to_user_iter(void __user *iter_to, size_t progress,
 			 size_t len, void *from, void *priv2)
 {
-	if (should_fail_usercopy())
+	if (uaccess_should_fail())
 		return len;
 	if (access_ok(iter_to, len)) {
 		from += progress;
@@ -33,7 +33,7 @@ size_t copy_to_user_iter_nofault(void __user *iter_to, size_t progress,
 {
 	ssize_t res;
 
-	if (should_fail_usercopy())
+	if (uaccess_should_fail())
 		return len;
 
 	from += progress;
@@ -47,7 +47,7 @@ size_t copy_from_user_iter(void __user *iter_from, size_t progress,
 {
 	size_t res = len;
 
-	if (should_fail_usercopy())
+	if (uaccess_should_fail())
 		return len;
 	if (can_do_masked_user_access()) {
 		iter_from = mask_user_address(iter_from);
diff --git a/lib/strncpy_from_user.c b/lib/strncpy_from_user.c
index 5bb752ff7c61..565b3125e752 100644
--- a/lib/strncpy_from_user.c
+++ b/lib/strncpy_from_user.c
@@ -115,7 +115,7 @@ long strncpy_from_user(char *dst, const char __user *src, long count)
 	unsigned long max_addr, src_addr;
 
 	might_fault();
-	if (should_fail_usercopy())
+	if (uaccess_should_fail())
 		return -EFAULT;
 	if (unlikely(count <= 0))
 		return 0;
-- 
2.56.0.307.g5fe7bd680c-goog

