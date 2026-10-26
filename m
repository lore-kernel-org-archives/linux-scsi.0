Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793051571;
	b=LdE5raDY6Jtzkfiqr/eKBycwXsjzSa+Ci3uu/S+f9qTe44BCtCSHQ2ewigW24gHO+22L
	 Y3eFd5Nx7d52erw4cgrOR9kUFsXiVwkniAsqP3+i47KwgaYzGEd6F4DKcpHfXB5FpZQJi
	 IY/jueLBpQYyejnWnDMy4DCv7tSUW6v/vVYINVNxmw057yYYx8cMKSY4kWtHnBN/9ZTnS
	 IMEQ8Tqq8EBhagzNMrvEwgbyzThVjwbjE6xk+2elGj7opEGsSdcokfxvD36tNffMKp9v2
	 PNdPkk5eJSMhzZB8tfJzmFIhlEQTWUeYLWujEy2+J56LNz+D4jsBmDHWPXCdjk8bUjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793051571;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=oogWXdI71uSApWoisQtM4clnwhLv0Vs2bmtqChsuYec=;
	b=IrywxDzai1E8lsTLiAxpldJiO1jFlNISXRvIoT6CoWvpJ2LKK//q3E05TO57m37aUQ1m
	 GWNmj1zCGtvtFDf1izzu9lHNaq/tAOYVPcXSkt9biKmccYJAzZdhrmOcl2ZXHOA+yPKAB
	 XsDkfHF94N8iYmQhCmHwyno9vUK6VlowQtFk45trmyxuiBVWTjMc0pOw+/3knAk4aFTX2
	 xRGpNWjJAkhO9YMRDKO7RVI1CvZFTEpWssz61hjCRq9XNRBlpa9QzJgjMlBXXFrinm6rf
	 AuITOqWn554+OaDnPIPRIT4srrCdbrET1ozj1FxTNsYJBwmYGoYV2PrgVHhh+4x1B9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=sJPCAyGd;
	arc=none smtp.remote-ip=209.85.216.72
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCA460A380B
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 21:52:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1FCA460A380B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=sJPCAyGd
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ad98380ccfso5288475a91.1
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 14:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793051570; x=1793656370; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oogWXdI71uSApWoisQtM4clnwhLv0Vs2bmtqChsuYec=;
        b=sJPCAyGdVEm2VhcvIBWqxKdB1ov+NEHAo0t+uGAM/0+qDIoJvuHm7nefnhKXLbxfZu
         kkzdd/4AnoA114yH/wBhWFkj4bhnTFD/5geQjiLBoAkwcMG8cTAN5yffgV7X8VZkSD6k
         UqJP6p4PAxwVl8yTZ/Y+9JixBhYbVYFxenEyF+y0YO2Y9TO0Q2mOae4aV4jUlpGMmFIH
         Y+Azcs1izJVTuxuoeh6BKO/iK8Vap0RGSadypMKvAjvOIsUEPKwpqHb793AvWJQkjEjp
         +fWxRFzb1QlgIgm+QlrlfCdAQHISYeGneT49/PFezT8s3UQeSh2Ep1POwSjeCezfL9SA
         lQ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793051570; x=1793656370;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oogWXdI71uSApWoisQtM4clnwhLv0Vs2bmtqChsuYec=;
        b=vsDx6CHicK2t8T81Iigct8N5DysqXhhjIbNfO2cEFxcq0yJYKLz9MMxbzNX369TSaJ
         2qaW7IAfRdcL3IS6LaLoDpzbtkmqfLV3D1syW9ASXPh0gwX06G6w3sleUwrb+eH5UIOr
         orWlo2FdbFqq9+o41z7culwWTa3j+Av7y5AhLJJZtmc6b542lr+2Rp8RCqDE2pNUfHG1
         d6BELzTAipkbXKXU1BYhW/E+7WimJpf9YxXV/MQMZ1z+uEKQk3mm77ZjRwdDP7G67rfx
         TvnKs/Qnbpfp2B+KzJTjFwB60xTyuJUZE/m6YT+IvaenfHEoiiz3X6Rd8sDDxnZy7lRj
         UGWQ==
X-Forwarded-Encrypted: i=1; AKwUvBxO51i07KjFu1EL2ubOqxtUYvLncLnA3Gm1RIRG9R05eoNCoVfYmsMzk1m5isHnvEqk6pH7NNIP/1Aj@vger.kernel.org
X-Gm-Message-State: AFq9FYIK6zHLsyVgytBivTHcD7a/NInQw/mw3gCfRJzkwl2pGKur+blR
	YwOCJ7mrEPXT4QC+aFiwLvj6JIJPTTE4aSj/tSc5eQWQu9Ip60isQQ9oI3rixUAL8jmvIY0ht6q
	mV+twVJ4yYffQespz6yM4aA==
X-Received: from pjbml16.prod.google.com ([2002:a17:90b:3610:b0:3ab:54fb:2a3d])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:56ce:b0:3a8:9d0d:ca50 with SMTP id 98e67ed59e1d1-3adeaae618emr6704272a91.10.1793051570356;
 Mon, 26 Oct 2026 14:52:50 -0700 (PDT)
Date: Mon, 26 Oct 2026 21:52:19 +0000
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
Message-ID: <20261026215226.3713941-4-jthoughton@google.com>
Subject: [RFC PATCH 03/10] bpf: Fail sleepable user copy helpers when
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

Sleepable BPF programs can run on behalf of a kernel thread, or of a
task that has already gone through exit_mm(). For example, bpf_wq
callbacks always run from a kworker, bpf_task_work callbacks queued
late enough run from exit_task_work(), and lsm.s or fentry.s programs
may be attached to functions called during exit_files(),
exit_task_work() or from kernel threads (e.g. security_file_release()
from a kworker running delayed_fput()).

In such contexts, bpf_copy_from_user(), bpf_copy_from_user_str() and
bpf_copy_from_user{,_str}_dynptr() (when reading from the current task)
call copy_from_user() or strncpy_from_user() without an mm. That access
does not reliably fail: the user half of the address space belongs to
whatever mm happens to be lazily loaded, if any, so the program may read
another task's memory.

As there is no user memory to read from in this case, fail with -EFAULT
without attempting the access.

Fixes: 07be4c4a3e7a ("bpf: Add bpf_copy_from_user() helper.")
Fixes: 65ab5ac4df01 ("bpf: Add bpf_copy_from_user_str kfunc")
Fixes: a498ee7576de ("bpf: Implement dynptr copy kfuncs")
Signed-off-by: James Houghton <jthoughton@google.com>
---
Tested with a small bpf_wq reproducer: a SEC("syscall") program arms a
bpf_wq whose callback (which runs in a kworker) calls
bpf_copy_from_user() on an address in the loader. With the uaccess check
from later in this series but without this patch, that triggers the new
WARN from bpf_copy_from_user(); with this patch, the helper returns
-EFAULT without warning. I can turn this into a selftest under
tools/testing/selftests/bpf if that's useful.
---
 kernel/bpf/helpers.c     | 11 +++++++++--
 kernel/trace/bpf_trace.c |  4 ++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 712dca5a2c5b..c4aa8bcaf2bd 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -659,7 +659,11 @@ const struct bpf_func_proto bpf_event_output_data_proto =  {
 BPF_CALL_3(bpf_copy_from_user, void *, dst, u32, size,
 	   const void __user *, user_ptr)
 {
-	int ret = copy_from_user(dst, user_ptr, size);
+	int ret = -EFAULT;
+
+	/* Sleepable programs may run without an mm, e.g. on kernel threads. */
+	if (likely(current->mm))
+		ret = copy_from_user(dst, user_ptr, size);
 
 	if (unlikely(ret)) {
 		memset(dst, 0, size);
@@ -3642,7 +3646,10 @@ __bpf_kfunc int bpf_copy_from_user_str(void *dst, u32 dst__sz, const void __user
 	if (unlikely(!dst__sz))
 		return 0;
 
-	ret = strncpy_from_user(dst, unsafe_ptr__ign, dst__sz - 1);
+	if (unlikely(!current->mm))
+		ret = -EFAULT;
+	else
+		ret = strncpy_from_user(dst, unsafe_ptr__ign, dst__sz - 1);
 	if (ret < 0) {
 		if (flags & BPF_F_PAD_ZEROS)
 			memset((char *)dst, 0, dst__sz);
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 88c3b5b513ab..793fb3dce5f1 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -3556,6 +3556,8 @@ static __always_inline int copy_user_data_sleepable(void *dst, const void *unsaf
 	int ret;
 
 	if (!tsk) { /* Read from the current task */
+		if (unlikely(!current->mm))
+			return -EFAULT;
 		ret = copy_from_user(dst, (const void __user *)unsafe_src, size);
 		if (ret)
 			return -EFAULT;
@@ -3590,6 +3592,8 @@ static __always_inline int copy_user_str_sleepable(void *dst, const void *unsafe
 
 	if (tsk) {
 		ret = copy_remote_vm_str(tsk, (unsigned long)unsafe_src, dst, size, 0);
+	} else if (unlikely(!current->mm)) {
+		ret = -EFAULT;
 	} else {
 		ret = strncpy_from_user(dst, (const void __user *)unsafe_src, size - 1);
 		/* strncpy_from_user does not guarantee NUL termination */
-- 
2.56.0.307.g5fe7bd680c-goog

