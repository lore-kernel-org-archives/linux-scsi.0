Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793051575;
	b=2+m7DS8c7M2uGKKn6ONAglEm+rCX86uV/VRL/HPld4MplqwT/nKcWE0to0m8qKYRcCIK
	 nqLK2VOcwp51d+Tgihs2Zlvaj0wTvINgrlT2OkHlq2Y+JKhtJWJoJoos0QS3iKulhpBpk
	 kjW7WL3//Tj1ttwBlloE7XwPb8fFBUh+y+8uds6k7OlXaTjUekZeZY6Q7tbZkt2NiGOEa
	 rbAQXmdGbZAvSdCgAObU8NwFjkPl8j4IS0cCFMdrGQsCi2n+NfGrRI/dCUfse1+5SSASe
	 o9ImdNe9MZ6Tg4ue8YkHaD8d6O5KlA+6NMba1Y44UnLqYH00MVEd1hL+vge/1LVl6Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793051575;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=bFIgocNkSNISRV4CHBI3t0UD1tr56XsmI6e/PuL6mFQ=;
	b=bx6g4ZciRDIhtdVwfuBmEHk9FaI/QV/enDEQ/6R873AJPaKg8SQwwGRppqM9cK1Si8CN
	 lYApDGRHPQRNdrtkzi+qMEYdAhJFiCl4JwDSDI2t62Pv8cCZw1j1yoEAaHLf4I2jrrvq9
	 gW75W62yns7l4yRjkj5FEQDzpldHV8A6hEDSzSTTAIHZieGx9y1ZnE3FjHKPqTFgqR/z2
	 VWAB5bKMS46jkJjmhXxc0FfvZSulG9Z4r30ugA+Kp6jGjxGTXXr3NLyYh5j6BOmcHL6Nl
	 AWu968rQN0Co/aIS+blF+YUmowTOxxStbGZqavkwUjZHuiZI1J93vsWylaEmO4p5Z3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b="HZDE5/h8";
	arc=none smtp.remote-ip=209.85.214.197
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73626606AB0B
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 21:52:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73626606AB0B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=HZDE5/h8
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2df8484f12cso33290675ad.3
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 14:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793051575; x=1793656375; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bFIgocNkSNISRV4CHBI3t0UD1tr56XsmI6e/PuL6mFQ=;
        b=HZDE5/h8w3OLnXIxK6aJgBJe5iwYfPAwmjEpbW/4ftuyFH9ujuIrSw0dznV9OUyE6F
         vLLrtdw5C1f/2X+KE5a5AjTR0OVlTErAcMYLlhQ5t2W88/kgSbZ50jbWTAgaZjq8AYcS
         4LLCa+on0oJ7TLoL82cJ6x9U3nUI29G0f4PX+yu671qzXzwpuN6+UwWx7JShwc/LkLfM
         GRw34cZFEGEcFhzeutRJqBfkALCNUgi6P0+zbacA4vpG0KwtbVgvsMdzT9Ez5Kd0LgzS
         r7YDxe2JSHaiPCcL0fARduZEtNb5N686qJeDu/bTRdIxd0MlXDFjjdccfXbzfnsu4WZc
         oRRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793051575; x=1793656375;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bFIgocNkSNISRV4CHBI3t0UD1tr56XsmI6e/PuL6mFQ=;
        b=PkrnYCG6jVNSlwO/VXqfhXQhTiDWD3cBQ1czcahcy42OmirREt/FPx6YJsYORXhS/c
         OV2tWzve3pZHDMknPex/sXKKjs7im+o21jEZ/roXLbve4y6mhpAZyT5fxtOEYT513KmM
         qOG2SS8nD/0pKnckgxnEX55xzCwxnGXJzVu8VYeaClTzzJpJwEwpRs3H3hPHMZDtiT21
         G4jTVkKrItxgt8x/MB9/1wS30B7vC2BNQDi8OfqzQ11Wy/N4iFcrssev+bbqXCAOEyyF
         toLZvcpQLkXaiWIc5+EsTkSrcWhy1c6M8ruGvhOjjfvCofOpWloOPVelioQM2sR35Ji4
         +l4A==
X-Forwarded-Encrypted: i=1; AKwUvBy/t5Pd0nxgSClpoOhVxdnDqVcz5ZEua89UqeMq3R7ftj86+JOVGVQTdWro4kBo+BXHiaHnWCPN9HyA@vger.kernel.org
X-Gm-Message-State: AFq9FYLpyRXq5ZYiepVr2AVy1ECNK+9ruk6SYRpdnpkewaBz5vN44HuK
	OFHqv3a2Twz4XEtdSmYEo3UCjhAnWdcei5i7JNJUbrBvW1z7AFrpQciWB0CJEbM/fMm/16rlAR7
	G/ylTjJ0GiS26ye8gEnPqag==
X-Received: from plblg15.prod.google.com ([2002:a17:902:fb8f:b0:2e5:712c:5c7])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ebc8:b0:2e2:e0f8:e57c with SMTP id d9443c01a7336-2ea9c95ba58mr63848015ad.70.1793051574627;
 Mon, 26 Oct 2026 14:52:54 -0700 (PDT)
Date: Mon, 26 Oct 2026 21:52:24 +0000
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
Message-ID: <20261026215226.3713941-9-jthoughton@google.com>
Subject: [RFC PATCH 08/10] uaccess: Refuse and warn on __copy_from_user_inatomic()
 without an mm
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

__copy_from_user_inatomic() never called should_fail_usercopy(), so the
NULL current->mm check added to uaccess_should_fail() does not cover it.
It is used e.g. by KVM's kvm_read_guest_atomic(), by several
architectures' perf callchain and stack trace code, and by the generic
copy_from_user_inatomic_nontemporal().

Split the NULL mm check out of uaccess_should_fail() into
uaccess_without_mm(), and use it in __copy_from_user_inatomic() to warn
and refuse the copy.

Don't use uaccess_should_fail() there, as that would also start injecting
failures into __copy_from_user_inatomic(), which some callers don't
expect to fail in practice, e.g. __wp_page_copy_user() warns if the copy
fails twice.

copy_from_user_nofault() already fails quietly when current->mm is NULL,
and the generic user stack unwinding entry points (perf_callchain(),
get_perf_callchain() and stack_trace_save_user()) only unwind the user
stack of a user task with an mm, so neither is affected.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/uaccess.h | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 8ab24e706a22..eae204f7261b 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -51,20 +51,33 @@
 #endif
 
 /*
- * Return true if a user copy must not be attempted, either because a failure
- * is being injected, or because the current task has no mm.
+ * Return true, and warn, if the current task has no mm, in which case user
+ * memory must not be accessed.
  *
  * Accessing user memory without an mm (e.g. from a kernel thread that is not
  * using kthread_use_mm(), or from a task that has already gone through
  * exit_mm()) is always a bug: the user portion of the address space belongs to
  * whatever mm happens to be lazily loaded, if any, so the access could
  * silently hit another task's memory.
+ *
+ * Note that this only catches a missing mm. It cannot catch a valid mm that
+ * isn't the one the caller expects, e.g. when a file's release or ioctl
+ * handlers run in a different process than the one that created it. Code
+ * that keeps user addresses belonging to a specific mm must check
+ * current->mm against that mm itself (see e.g. KVM's kvm->mm checks).
+ */
+static __always_inline bool uaccess_without_mm(void)
+{
+	return WARN_ON_ONCE(!current->mm);
+}
+
+/*
+ * Return true if a user copy must not be attempted, either because the
+ * current task has no mm, or because a failure is being injected.
  */
 static __always_inline bool uaccess_should_fail(void)
 {
-	if (WARN_ON_ONCE(!current->mm))
-		return true;
-	return should_fail_usercopy();
+	return uaccess_without_mm() || should_fail_usercopy();
 }
 
 /*
@@ -117,6 +130,8 @@ __copy_from_user_inatomic(void *to, const void __user *from, unsigned long n)
 {
 	unsigned long res;
 
+	if (uaccess_without_mm())
+		return n;
 	instrument_copy_from_user_before(to, from, n);
 	check_object_size(to, n, false);
 	res = raw_copy_from_user(to, from, n);
-- 
2.56.0.307.g5fe7bd680c-goog

