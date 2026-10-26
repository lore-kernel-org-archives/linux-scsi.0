Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793051575;
	b=grTu761sbZw9CCNLTqRazFpNnq9QJT46isawmJdjCbrmXv3ULWTuWyE9Uzdk2Ler2ZUq
	 +rSjmHlqoLQuuGXPi9TgKd3HpTZT4gb1Bbhce87RXm7my2W1DWsWeO56FfMCGZyn+NJR4
	 BHVYvNCOioAGzdXnBB7KkWSWMuxjLpApPsciUxiOOHUZZEoH0qZyDEkyJCuPEGKsy5Mnn
	 zStQIlfVOxZ+3WgMS7lwPgtU7rEQn26/KGkPAvB2xwMkhv1gjY6yADE0ViKK4oe+2aEyV
	 BQyxl1/D1ljrZVk4qbspnoeL/ET/0J38YX0/CXLSURNDNr40qkurkbgyOHX33blo9Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793051575;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=UPD1DyegWTB9pcC/MXMtMDXG2VZzMQeq5nacp4T1bXw=;
	b=sO2/LqxqsAe9a3bGv6woIFtb/NEs7NUMId0W2gjuWGdOSq8v9cbCl9bPQthB76x5ssnu
	 IUhedaq48iISxV7DCTtw3SDjpatvYLMgD1tE/nnwS+96wwwP0K74ick0dUv2MlCWZJVQq
	 v93Y6SdUQfCBN6f7HE35jkU4Iqm1Q7Sz6vNXFvr+pRrU3pt+MYU6FGV+Qg9pR9Pn3x+Pk
	 vJ7Qb+SH9DGbqdf4X5rM7fQNuAXk3SCIsQc5G47tsKfeqKNIgjq+iAIlm7/UtCBRBL32y
	 EIJAHaUjohXmA3cGpaLefSpQ9Y/N/QUzjp5t5dht40aV9XtHIXEYLWtkRxY8FnR1S7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b="rIaWZp/G";
	arc=none smtp.remote-ip=209.85.216.72
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A101360A5BC9
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 21:52:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A101360A5BC9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=rIaWZp/G
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3adc5b185bfso3741975a91.3
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 14:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793051574; x=1793656374; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UPD1DyegWTB9pcC/MXMtMDXG2VZzMQeq5nacp4T1bXw=;
        b=rIaWZp/GdR9oaew/m3Hzd8eSd5saoP8GWO0K4K0joO8XQTv842j2gsBeHsxwEdM/8M
         MFM6vhduv3Y3n3hCqiAUqsnfRPKP9yOwLSHx/clGiyqH9Rxk0fMKXZZ7stPFt1zjCupR
         xRNu/7MegW08r0ydYWSIUj+FAUa3Ae6wfRzfeoO5pFfoBcMeRGz13T6mBB5UdlXqWjMq
         KF0ceJ1w9rr7iREcUm2HrRNiOXTB+r76yUWxKyQJbGshWQiGe6+nr3XF10eZqmjVMTie
         XjqLxoc2jQjq3WGmj9HfzvPA3b7EhbSB0eKWlpooXrtzhqxcQ9G3H1+HZnwFZsc4Q9d0
         dwdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793051574; x=1793656374;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UPD1DyegWTB9pcC/MXMtMDXG2VZzMQeq5nacp4T1bXw=;
        b=cw07quWNCXa2u02OtVdnXYYFBd6nsI8TDPdCn9KbRNlZJKu4dg3ex4BJQYc9Qfu0md
         50gP2rvkDVKV2QQcGZZU6V4C2DTbbaEGHfa+aOYtXyfIkzBGQ8F3lG+0m7YAp3P4wKKZ
         hMbkjQItUzbVK1FAd7AhPAq3Wy32ugWSuKjGiqUcfq4/4/X7qu7w7GE3V2neJsvD4Nbf
         pfjO6YZzTnseqozyTQ/Pja4XUg9nNcOdb3Ps9sZvPA8rsZQ/I9LrTXRPosZdFTPZ/jbX
         fNz/8Kvlfh7B7hYStQD7B3cOjTXdcr0gNYH/p3cwRwt/vysfoj5KYBkPmOUWuc4V4Y9J
         Ov1w==
X-Forwarded-Encrypted: i=1; AKwUvBxq8XnBo7T1+TJ90E2gvrqeskk3QoCrEgZB75DpBn5Fa1e+Ub6Ut2erOOkShsE6c3FUXfRWVX594Hmq@vger.kernel.org
X-Gm-Message-State: AFq9FYLPZhgK/AueHev9EnQg8m/8Q9lTjkKswVA3YaZMkEVfHVT/WrXK
	PK+21wEsXLgrISLBnBnzsPYBvYITka7aALSuILKiRzfE9chhD0sfZAstuNfWUF5jcL76Gc9403B
	0RiWbTigrwkPRdJzK1YT1hg==
X-Received: from pjyp7.prod.google.com ([2002:a17:90a:e707:b0:3ab:c373:bf62])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3e4d:b0:3ac:403d:6232 with SMTP id 98e67ed59e1d1-3adeb120167mr6870324a91.55.1793051573802;
 Mon, 26 Oct 2026 14:52:53 -0700 (PDT)
Date: Mon, 26 Oct 2026 21:52:23 +0000
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
Message-ID: <20261026215226.3713941-8-jthoughton@google.com>
Subject: [RFC PATCH 07/10] uaccess: Fail user nofault helpers quietly when
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

The user nofault helpers (copy_{from,to}_user_nofault(),
strncpy_from_user_nofault() and strnlen_user_nofault()) are meant to be
callable from any context, e.g. from BPF programs, kprobes or perf, which
may run on behalf of a kernel thread or of a task that has already gone
through exit_mm(). In such a context, there is no user memory to access,
and the right answer is simply to fail.

Since the previous commit, the uaccess helpers they use warn when
current->mm is NULL, e.g. bpf_probe_read_user_str() from a BPF program
attached to a function called by a kernel thread would now trip the
WARN_ON_ONCE() in strncpy_from_user().

Check for a NULL current->mm up front in these helpers, and fail without
warning and without attempting the access.

On x86, copy_from_user_nofault() was already refusing such accesses, as
nmi_uaccess_okay() returns false when current->mm is not the loaded mm.

For the same reason, make copy_to_user_iter_nofault() use
should_fail_usercopy() directly, leaving the NULL mm check to
copy_to_user_nofault().

Signed-off-by: James Houghton <jthoughton@google.com>
---
 lib/iov_iter.c |  2 +-
 mm/maccess.c   | 17 +++++++++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 3d6ecb50d778..21e2ccf1e8f2 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -33,7 +33,7 @@ size_t copy_to_user_iter_nofault(void __user *iter_to, size_t progress,
 {
 	ssize_t res;
 
-	if (uaccess_should_fail())
+	if (should_fail_usercopy())
 		return len;
 
 	from += progress;
diff --git a/mm/maccess.c b/mm/maccess.c
index 486559d68858..678bb6165b39 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -121,6 +121,14 @@ long copy_from_user_nofault(void *dst, const void __user *src, size_t size)
 {
 	long ret = -EFAULT;
 
+	/*
+	 * The user nofault helpers may be called from any context, including
+	 * from tasks that have no user memory to access (e.g. kernel threads).
+	 * Fail quietly instead of tripping the warning in the uaccess helpers.
+	 */
+	if (!current->mm)
+		return ret;
+
 	if (!__access_ok(src, size))
 		return ret;
 
@@ -150,6 +158,9 @@ long copy_to_user_nofault(void __user *dst, const void *src, size_t size)
 {
 	long ret = -EFAULT;
 
+	if (!current->mm)
+		return ret;
+
 	if (access_ok(dst, size)) {
 		pagefault_disable();
 		ret = __copy_to_user_inatomic(dst, src, size);
@@ -188,6 +199,9 @@ long strncpy_from_user_nofault(char *dst, const void __user *unsafe_addr,
 	if (unlikely(count <= 0))
 		return 0;
 
+	if (!current->mm)
+		return -EFAULT;
+
 	pagefault_disable();
 	ret = strncpy_from_user(dst, unsafe_addr, count);
 	pagefault_enable();
@@ -222,6 +236,9 @@ long strnlen_user_nofault(const void __user *unsafe_addr, long count)
 {
 	int ret;
 
+	if (!current->mm)
+		return 0;
+
 	pagefault_disable();
 	ret = strnlen_user(unsafe_addr, count);
 	pagefault_enable();
-- 
2.56.0.307.g5fe7bd680c-goog

