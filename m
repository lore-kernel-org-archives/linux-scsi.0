Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793051582;
	b=3cfXgEDQugmgQRXa9rZqlpzLHY8ae/GeJxvuIL0ZQC+FWlM27J47QWovzjnlXKmgYFzP
	 wm+UywVczMwR8hgir3daCJ649EGqONctLDGKExb2So1G1XAX2CEXrA6i3lKg7mHQrACZg
	 tGq1jpUvEXx/o8Ct3YMVq11f7QF+0HsUSmLxnYfaLcHmzXa8ssuwxnTtBMAD3TokeEwG4
	 5v+D6t1H0YkbQ3yCGrf9kqo8By5vOgqEFUv8JvINb23UAmrKFjVlCD9/9OClWgrwSJpDv
	 NeiIHt2JdBghVVCKwev/ZfYh/hm6EN9MVltNszUSGopnQ4pbDWWvhBy0c0EnEx06FjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793051582;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=HQqGCLRyEFq1Qmw7LfzuGpexsFHiUvTKIyODgPSn6eE=;
	b=WvrbOOzdT4bM2ow+IWFwn1mLy5+e0REvxipE9GzEerYqtLx8qzwS9EM6mPJAAYd+XH6W
	 iNxPIvy9lPpG2mjOeQiWGmkAg2oft8wgsodAwoEqZFiIgG2GxdhOa5ZGUmh4h2pUe27Jp
	 cee8Mg8bjWbXWqNFsb9YGhy/oJWhv6E7y58/1UbQKOUe+KiL5mCBSnmIx784wMGK2rnvd
	 KzPQ79aa1JgoymaQ7nvH0T0UNxUCGJZGKhOyJqGd6F9nCO2h/W0zaodATUmsVk/O6xBv9
	 KVvqZLt6PURhB65t8Sg+LHHyZMta7gfv3yfbvLxRli+Y4rMu2dTIi6KjGNYn2xZ8OeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=ZslLM7db;
	arc=none smtp.remote-ip=209.85.216.72
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335B6606C17D
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 21:53:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 335B6606C17D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=ZslLM7db
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3abfcf726dcso5159072a91.2
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 14:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793051576; x=1793656376; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HQqGCLRyEFq1Qmw7LfzuGpexsFHiUvTKIyODgPSn6eE=;
        b=ZslLM7dbmVgAFSoPUZOqKRrOoyj122fasUGdKYfOjOXbcRPiRB7feP6J+Octqg8Oa7
         CYkNSyaJ5iygpnvzIZzKMr56CyR1UQjGhD0SeSiR+jnjKI891alYSFsfCdQyY1fP7lfK
         jjHyo984JGh2+H77mvNAAdFd04oUnBl94P2xuFqBjmjJW2DRxyJuLJmIcvB/faohDtvh
         cqjWch4Zsyk+B3JEvHSIHxZJLF7Wuqc+8XgYW91lxZJfWyN17H1WnMId3q2wh0N/6TLC
         csdE1br/thP+JMpWf4qCqC7rGrBz4jRcA0dSFFpspmprnoJ9hiOa+NbLKfXhqIJIfOQ1
         +hfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793051576; x=1793656376;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HQqGCLRyEFq1Qmw7LfzuGpexsFHiUvTKIyODgPSn6eE=;
        b=YZPIc7XkImz46ytSIfi4L+a5JW7wBzgNOS/1ov4gcpn5ewQGkoNsqfC9i+hucQlnji
         nnYV/zKnL2koJJs5zL6gULFXwlCdGsnjdq04vKfqohREXUx+OoyFjSNaHq5I1TN0CH0a
         N2sHcbsh9p3Jq8JwhPEOn2tkOb+SOpo/CQIYuDDo+vcOzkNj4qq4YhCqY59h1WEcyrAF
         mkHs2BPASGFVGX7iiEC1Q8l1uiaNIe01GQiLVZEHbeiuwWXBWV5vlEn1sHPEe+LUlcUR
         5pDWcvhsCXhzq2AxoIe2owSMrmNtG/VJs/34BhCaGTjoBuED+r3SjVfH0hzT1q4S5Ekz
         DucA==
X-Forwarded-Encrypted: i=1; AKwUvBz45Wd5UoMtDT3TEaB7zMnxwqTg6f51InGqjQzNOPle7LSn9t0zGnczuPgytsKQyi4mw+jYj2fi6xRX@vger.kernel.org
X-Gm-Message-State: AFq9FYJ0VwiAQ5VUNsPRKvV83HnkWhX0yEpFaTdzgJAI5S/k31bn29eS
	AU/+imdPmnnGf+QVJrMqdUXGWBjicMRACIccwmORFnuVe4EVka5eHcE+Jy2LyayErMvJQ/GRKQ0
	hC8FjkEGI7BRLiXunAs09Bg==
X-Received: from pjbst6.prod.google.com ([2002:a17:90b:1fc6:b0:3ac:989f:b65f])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1a92:b0:3a8:211b:6c8c with SMTP id 98e67ed59e1d1-3adeaae6e15mr7057279a91.22.1793051576336;
 Mon, 26 Oct 2026 14:52:56 -0700 (PDT)
Date: Mon, 26 Oct 2026 21:52:26 +0000
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
Message-ID: <20261026215226.3713941-11-jthoughton@google.com>
Subject: [RFC PATCH 10/10] uaccess: Move the NULL mm warning out of line
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

uaccess_without_mm() is inlined into every user copy, including every
copy_{to,from}_user() call site on architectures that define
INLINE_COPY_USER, such as arm64. Each inlined WARN_ON_ONCE() adds its
own __bug_table entry.

Keep the NULL current->mm check inline, but move the warning into a
single out-of-line, __cold function, uaccess_warn_without_mm().

The trade-off is that only the first offending access in the system
warns, rather than the first one from each call site. The stack trace
still identifies the caller, and the access is refused either way.

Compared to the base of this series, with defconfig + KVM:

                     inline WARN_ON_ONCE()    out-of-line warning
  x86_64 total       +5,884 B (+0.014%)       +9,714 B (+0.023%)
  arm64  total      +40,948 B (+0.10%)       +24,609 B (+0.06%)

On arm64, this removes the ~16 KB of __bug_table growth, while text
size is unchanged, as a call is the same size as the inline brk. On
x86_64, the call is larger than the inline ud2 and causes more .cold
splitting, so this is a slight regression.

Signed-off-by: James Houghton <jthoughton@google.com>
---
NOTE: This patch is included for reference only, to show the cost of the
      inline warning.
---
 include/linux/uaccess.h | 8 +++++++-
 lib/usercopy.c          | 6 ++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 7d26d2de9599..6a5b6c2b3388 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -66,9 +66,15 @@
  * that keeps user addresses belonging to a specific mm must check
  * current->mm against that mm itself (see e.g. KVM's kvm->mm checks).
  */
+void __cold uaccess_warn_without_mm(void);
+
 static __always_inline bool uaccess_without_mm(void)
 {
-	return WARN_ON_ONCE(!current->mm);
+	if (likely(current->mm))
+		return false;
+	/* Warn out of line to keep inlined user copies small. */
+	uaccess_warn_without_mm();
+	return true;
 }
 
 /*
diff --git a/lib/usercopy.c b/lib/usercopy.c
index 9146c729c47a..3d547ecb74df 100644
--- a/lib/usercopy.c
+++ b/lib/usercopy.c
@@ -26,6 +26,12 @@ unsigned long _copy_to_user(void __user *to, const void *from, unsigned long n)
 EXPORT_SYMBOL(_copy_to_user);
 #endif
 
+void __cold uaccess_warn_without_mm(void)
+{
+	WARN_ON_ONCE(1);
+}
+EXPORT_SYMBOL(uaccess_warn_without_mm);
+
 /**
  * check_zeroed_user: check if a userspace buffer only contains zero bytes
  * @from: Source address, in userspace.
-- 
2.56.0.307.g5fe7bd680c-goog

