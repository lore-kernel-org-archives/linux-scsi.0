Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6673E3B9DA4
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 15:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773327941; cv=none; b=aTJJxhakYXn27DACgwv1WKmOiwKjjlh2tKHaEoChxUwc2dIJjyFmiH53wgWJKNHbziFipKYZBrnZg7143z6mrLdIljlDaPfJ+BlvNJfL2dOZ9ITYsDH1CbJVDtiZWWihIbT3DZgnR8mCuyh3FH0Cx3RAf6nKUEyTPamy1bjBnTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773327941; c=relaxed/simple;
	bh=10NVZYZNHh8UNRWWgIond7aYsxXBLnPZEqS+81FpWlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lknd+h+JS7FCnyk/X3TFj+h9flfJ8Elmfv7iFd5XV2drOqR/8kzd9q8j9OC8nCbtGx/5XMLPuZZ2ZctlbQeeG0WcnHC0b2XCqz2JisdBJyVFDp78v9qPqOp/PKp0BTc/lXACOcxePFm0L7dq1/+v5cV/wQ+2pb3v/Kc1wiEkwgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=ZLuEADjS; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="ZLuEADjS"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7d7653db148so821248a34.2
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 08:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1773327938; x=1773932738; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cNc1V3lTb2QUW0xjd0W9BOVRtnhujjy4WaV1yGr6BKQ=;
        b=ZLuEADjS5Wujf+hyGJOkQpr/wIKGuXs9OOEVT4XriJwtaGHICDf/fK7wgqCLEVshea
         ZPDoxRigGndBOJZknOWOvmoIvA5p5AflGvpUg/lYA1HOMVjGphlSfEEp2YUKFkCpsUjq
         iY7dYM6BX9/OyYunBFKZ1LEEd+dgcchthClyw8FTO8bR13lJBq1OLNQ6XV+bQEoEw0nW
         hc0H26Q0dFwWj47erVfvxfR6mSo6cPUE9ccQuUXIqrq+LZpon6yRikG/EMTJ4kvhBZ6x
         p+knU1eLD3OrfrwQaFIiU9k98YYy4T5TDHuUp8m0AMRLXmoPg+ykG9oMleXMnBAqpVBq
         0UAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773327938; x=1773932738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cNc1V3lTb2QUW0xjd0W9BOVRtnhujjy4WaV1yGr6BKQ=;
        b=GTM4IFAc5uDtbVRMXph2B6N3xDZ6T3xifXmI22jYWwNluXtxV6wukUGPrCtmB7CViV
         NwSA0l9bG4icCuApgNm3GpsDGqiWQcdeLQdFS91YpHCTGb0PpLCxRAnFVtvvPhZRT3hy
         lZHTKg8IZWXpLSgfRj/d5N/RjdO1YIjXBmKtciOdhOprpi/33fnULbZBlJLQNGCW6YlM
         A2rXEHsPS5qAzt1SemmMd0OBc4qI4bfV9Qzsq1IAkMglrEtskQatXg/4S95E6zIYBoMd
         Iea7lY55knIrQ8MPrdPassFMeBRn9ZbM7UNQXvm32/jf+fciNef1XDb9dUSFd/mBJquu
         /aFw==
X-Forwarded-Encrypted: i=1; AJvYcCVPTuYI7PwTspILHxjEK4lRIAFW8Jzj7p/5r4zEsWgEM0jGGqgsVh3C9+q9uHFbUWTrnbuoGaFBVKbW@vger.kernel.org
X-Gm-Message-State: AOJu0YzLXBMSteNRdwWXHRZhN24sGW1j9a4vCxFRqirU6dRWEmVxMzTv
	BJZzkTp03nhpnAlKUObzJhbNxuYDXCFBAq9LedTfRFlUs9DB2VVBhGeI+Q+7xYeD9PKS+q8Bc99
	K3HdTe77+qQ==
X-Gm-Gg: ATEYQzzX68Mdi06hpX9EDUYgWeZHAHj7ywAtfIY2WYPOeutdproyOJacUE+Uc7TsNlP
	cgxFlp7i8gHkJP98A1rLe52cgwW0PnQf/bi8PkXuMUAMfU2FLriJjwgiUHAkg3/X8zmWEgVir0b
	/Ji9JAnt0iM8azTN7EKlLv5lvOBr4uMiKrRK01q1EAlTegYbxmduRRBLx+iO+/xSEMZUDHzIYrx
	2Rhm0VgBvDTllowF7IzW3Ciw8n0jPp3KC7HJc/wqWcRK8X28mNWZxRHfw4M6pDjDLtXNXdzO+kA
	KWyvQJHt9J1vqeRaH+2qkKsIhcwAw2gXdgxMGgE9lMrysLyd5rJ11GY9jRJqg+veoSSj80T8AZj
	+S70qjAKp4s74D9H8q0ZHsN7Z2zxJ0vSQAchTiN7nR+C221d/lQiL1hqOEHJJQNyB/9fQtiH3F2
	IOnmcvD7ufGBqvzdVfl2qTTPEgctg9CfRlDIcSEcEgiyj2vPnRhv5EB7oGWyPlum9kA1HdRwmLv
	vXE
X-Received: by 2002:a05:6830:3113:b0:7c6:d001:afb2 with SMTP id 46e09a7af769-7d76a85b34cmr3668805a34.35.1773327936791;
        Thu, 12 Mar 2026 08:05:36 -0700 (PDT)
Received: from vinmini.lan (c-73-143-21-186.hsd1.vt.comcast.net. [73.143.21.186])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d76aedae57sm4321776a34.28.2026.03.12.08.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 08:05:36 -0700 (PDT)
From: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
To: Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Dmitry Ilvokhin <d@ilvokhin.com>
Cc: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jon Maloy <jmaloy@redhat.com>,
	Aaron Conole <aconole@redhat.com>,
	Eelco Chaudron <echaudro@redhat.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-sctp@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net,
	dev@openvswitch.org,
	Oded Gabbay <ogabbay@kernel.org>,
	Koby Elbaz <koby.elbaz@intel.com>,
	dri-devel@lists.freedesktop.org,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Len Brown <lenb@kernel.org>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	linux-pm@vger.kernel.org,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	linaro-mm-sig@lists.linaro.org,
	Eddie James <eajames@linux.ibm.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Joel Stanley <joel@jms.id.au>,
	linux-fsi@lists.ozlabs.org,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Alex Deucher <alexander.deucher@amd.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Philipp Stanner <phasta@kernel.org>,
	Harry Wentland <harry.wentland@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	amd-gfx@lists.freedesktop.org,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	linux-input@vger.kernel.org,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	linux-i2c@vger.kernel.org,
	Mark Brown <broonie@kernel.org>,
	Michael Hennerich <michael.hennerich@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	linux-spi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 01/15] tracepoint: Add trace_invoke_##name() API
Date: Thu, 12 Mar 2026 11:04:56 -0400
Message-ID: <20260312150523.2054552-2-vineeth@bitbyteword.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312150523.2054552-1-vineeth@bitbyteword.org>
References: <20260312150523.2054552-1-vineeth@bitbyteword.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add trace_invoke_##name() as a companion to trace_##name().  When a
caller already guards a tracepoint with an explicit enabled check:

  if (trace_foo_enabled() && cond)
      trace_foo(args);

trace_foo() internally repeats the static_branch_unlikely() test, which
the compiler cannot fold since static branches are patched binary
instructions.  This results in two static-branch evaluations for every
guarded call site.

trace_invoke_##name() calls __do_trace_##name() directly, skipping the
redundant static-branch re-check.  This avoids leaking the internal
__do_trace_##name() symbol into call sites while still eliminating the
double evaluation:

  if (trace_foo_enabled() && cond)
      trace_invoke_foo(args);   /* calls __do_trace_foo() directly */

Three locations are updated:
- __DECLARE_TRACE: invoke form omits static_branch_unlikely, retains
  the LOCKDEP RCU-watching assertion.
- __DECLARE_TRACE_SYSCALL: same, plus retains might_fault().
- !TRACEPOINTS_ENABLED stub: empty no-op so callers compile cleanly
  when tracepoints are compiled out.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
Assisted-by: Claude:claude-sonnet-4-6
---
 include/linux/tracepoint.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 22ca1c8b54f32..07219316a8e14 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -294,6 +294,10 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
 			WARN_ONCE(!rcu_is_watching(),			\
 				  "RCU not watching for tracepoint");	\
 		}							\
+	}								\
+	static inline void trace_invoke_##name(proto)			\
+	{								\
+		__do_trace_##name(args);				\
 	}
 
 #define __DECLARE_TRACE_SYSCALL(name, proto, args, data_proto)		\
@@ -313,6 +317,11 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
 			WARN_ONCE(!rcu_is_watching(),			\
 				  "RCU not watching for tracepoint");	\
 		}							\
+	}								\
+	static inline void trace_invoke_##name(proto)			\
+	{								\
+		might_fault();						\
+		__do_trace_##name(args);				\
 	}
 
 /*
@@ -398,6 +407,8 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
 #define __DECLARE_TRACE_COMMON(name, proto, args, data_proto)		\
 	static inline void trace_##name(proto)				\
 	{ }								\
+	static inline void trace_invoke_##name(proto)			\
+	{ }								\
 	static inline int						\
 	register_trace_##name(void (*probe)(data_proto),		\
 			      void *data)				\
-- 
2.53.0

