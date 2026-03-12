Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0783F3BD638
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 15:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773327934; cv=none; b=JSJm9DpsdQDfC1Mn+n1X8hTTRKYgeAzo0aXDRKPkgqOfkTkvJXLDJ9zXss4P8/M2RMy5d732lN73I+Rdt128MkKFN5HdUdk6tTYLX6nu4Z5mjJ+aKR/5Cfy/aS3dwer0DRkchafCYxnTe/CpgBMyJTDsj4zwjhXyhILGf3gmdHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773327934; c=relaxed/simple;
	bh=wFrH16wRP/ZRrLPrdvN9J5kV/62KiVf8oPQZXnkjAN4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JnzeMTRu25UJplEOcNVwjAdsb6/jB+oLFm4g1R/An135a2WuY8I/sqjOKIrcLhHPA4P2BhSiM4c0ul5Gy4OUJrEPKiIk7IOZhNyv7yCrbU9//5W21ea1ZlrSHlHGcrwRg2nqd4+iUbdgmu1fERDRSwbQEOaeLRysfve+xGRckww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=OW/DV1AC; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="OW/DV1AC"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7d4c383f2fcso932283a34.0
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 08:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1773327931; x=1773932731; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=p/UukkhQcW1lhFqWI/Fw5V3bxdryulukbz8WWfM9zNY=;
        b=OW/DV1ACXgC1meD5kqUaAm+FZL1lWnMvkS4yVJbykbP7K5vclRgwIJ0xyKjX7imhp/
         JxxjkcYDPIFgCcRsHpsq5835/4tOiZXx4U2LrD/Jieum8wVn2Z6Z5nqk/9SiB45nd/qy
         /BuK9l4E6H6ktN13lZ0Hr7tfv7gU2Q/gQrPyh80u+hQmfQJHWoBipgWsTEkUGem3Rz81
         JNQzSDmb8/zc02tAEL+0aWPXdIdNl9rSHS9aSNKbrZ7DJXEXNUQ5AdKmtdWCkC9j1FJ2
         ratzAuFfZH/Mj07Ii9/24wDft/5/id9dHt4PadP+Rpp8ksPWtVWSLG+Lvf0x5+CB9K5Z
         62Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773327931; x=1773932731;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p/UukkhQcW1lhFqWI/Fw5V3bxdryulukbz8WWfM9zNY=;
        b=wi2z8W2bJUIdcgHGTXm87sRJy2ND+zgKBH7ixpZZx9KguhqrTm+Q5chBRHkseWfGNN
         yYNkaul1fZkI36GOLmhHDguZ/X+q6/4hSOvILrrIiBuhNeKqO5fugmYI3DTDri7k49CV
         OVX6N+UDtl8uGqtKQTzMPUayoArv2s3S5pjGP2c5QtQ1iStE8+M/D67p/mK2d/q+CXvr
         xVUJLU1sjUlfBaW4bEXwQZrQlGTVWvG3hMTykRqZ5NSls5xpOaVA5GaqJzWvvaY8QACu
         t2revAnbFB0eMu2Df8dd3BWDcfk9/vqtCbruBqRFDT1etVgPw0Twy7QTke/qIyi6SIIh
         YpCA==
X-Forwarded-Encrypted: i=1; AJvYcCWo6G7RS9YSRPyZ+Uk3iN3LqMhLpwyHLm7PIZtxLeEVNfSMD1zH9rRykZ+ZujHyAO9Q1AAnInI9Udx5@vger.kernel.org
X-Gm-Message-State: AOJu0YytRqVN6k8vUKgsx3V++5WqlXeXRrXwcjRCqQrV8upQ25JkPzzr
	4gnmN/IDlKhBnjmhDiDCDTmymTNIDoUY6mRSogeYaxIY6brVKTAHfa2qImLWB1FxdIw=
X-Gm-Gg: ATEYQzwESxOjeW8lXyFtu0EE4rUE5bn+k0JhDBlrI50rXFDNSCXOiS/10yrV67hE5aX
	EF020SpSNmqYbqk8UwFYqpek6IAcxNERNWdbvYDix+pswsbyJaj6/Emorn/e0OOaRJhce/97f5J
	jwWJx189T+F0t27kJ/lG5ugyEWimzx7W7R7fe5fx9uXWiyMMWtzUlZYSFpBpawNAQHGl1EUotN1
	XSKEM783P8JnjCK2BNHRbr29saB5sGUg5sO0AInbuS2ZYZx6y2X6mTaXdjgQln4xmedPx8MJLzc
	l6lDrwgxGlWAf4fGXQs91XSzA/bCBQEV7xNFfKaaZUxhyhC5MoBU8LrrVZrOj4Z3E1lm8ghOz4z
	EMyPuFCUQcGzIE37miSigNOLBvpYV0cMpNltKXusK6hrbFdIkv4Qs38b/JgplLU49YEAuKV/w7h
	LHrtvRv+WgD4ersObBRMdVdX4RKg8PnDOcgJPLKv6ZLEW8kaMqI/zSa5paX/y3SbfvNA==
X-Received: by 2002:a05:6830:488d:b0:7d5:1101:9196 with SMTP id 46e09a7af769-7d76a6bdefamr3754389a34.6.1773327930614;
        Thu, 12 Mar 2026 08:05:30 -0700 (PDT)
Received: from vinmini.lan (c-73-143-21-186.hsd1.vt.comcast.net. [73.143.21.186])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d76aedae57sm4321776a34.28.2026.03.12.08.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 08:05:29 -0700 (PDT)
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
Subject: [PATCH 00/15] tracepoint: Avoid double static_branch evaluation at guarded call sites
Date: Thu, 12 Mar 2026 11:04:55 -0400
Message-ID: <20260312150523.2054552-1-vineeth@bitbyteword.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a caller already guards a tracepoint with an explicit enabled check:

  if (trace_foo_enabled() && cond)
      trace_foo(args);

trace_foo() internally re-evaluates the static_branch_unlikely() key.
Since static branches are patched binary instructions the compiler cannot
fold the two evaluations, so every such site pays the cost twice.

This series introduces trace_invoke_##name() as a companion to
trace_##name().  It calls __do_trace_##name() directly, bypassing the
redundant static-branch re-check, while preserving all other correctness
properties of the normal path (RCU-watching assertion, might_fault() for
syscall tracepoints).  The internal __do_trace_##name() symbol is not
leaked to call sites; trace_invoke_##name() is the only new public API.

  if (trace_foo_enabled() && cond)
      trace_invoke_foo(args);   /* calls __do_trace_foo() directly */

The first patch adds the three-location change to
include/linux/tracepoint.h (__DECLARE_TRACE, __DECLARE_TRACE_SYSCALL,
and the !TRACEPOINTS_ENABLED stub).  The remaining 14 patches
mechanically convert all guarded call sites found in the tree:
kernel/, io_uring/, net/, accel/habanalabs, cpufreq/, devfreq/,
dma-buf/, fsi/, drm/, HID, i2c/, spi/, scsi/ufs/, and btrfs/.

This series is motivated by Peter Zijlstra's observation in the discussion
around Dmitry Ilvokhin's locking tracepoint instrumentation series, where
he noted that compilers cannot optimize static branches and that guarded
call sites end up evaluating the static branch twice for no reason, and
by Steven Rostedt's suggestion to add a proper API instead of exposing
internal implementation details like __do_trace_##name() directly to
call sites:

  https://lore.kernel.org/linux-trace-kernel/8298e098d3418cb446ef396f119edac58a3414e9.1772642407.git.d@ilvokhin.com

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>

Vineeth Pillai (Google) (15):
  tracepoint: Add trace_invoke_##name() API
  kernel: Use trace_invoke_##name() at guarded tracepoint call sites
  io_uring: Use trace_invoke_##name() at guarded tracepoint call sites
  net: Use trace_invoke_##name() at guarded tracepoint call sites
  accel/habanalabs: Use trace_invoke_##name() at guarded tracepoint call
    sites
  cpufreq: Use trace_invoke_##name() at guarded tracepoint call sites
  devfreq: Use trace_invoke_##name() at guarded tracepoint call sites
  dma-buf: Use trace_invoke_##name() at guarded tracepoint call sites
  fsi: Use trace_invoke_##name() at guarded tracepoint call sites
  drm: Use trace_invoke_##name() at guarded tracepoint call sites
  HID: Use trace_invoke_##name() at guarded tracepoint call sites
  i2c: Use trace_invoke_##name() at guarded tracepoint call sites
  spi: Use trace_invoke_##name() at guarded tracepoint call sites
  scsi: ufs: Use trace_invoke_##name() at guarded tracepoint call sites
  btrfs: Use trace_invoke_##name() at guarded tracepoint call sites

 drivers/accel/habanalabs/common/device.c          | 12 ++++++------
 drivers/accel/habanalabs/common/mmu/mmu.c         |  3 ++-
 drivers/accel/habanalabs/common/pci/pci.c         |  4 ++--
 drivers/cpufreq/amd-pstate.c                      | 10 +++++-----
 drivers/cpufreq/cpufreq.c                         |  2 +-
 drivers/cpufreq/intel_pstate.c                    |  2 +-
 drivers/devfreq/devfreq.c                         |  2 +-
 drivers/dma-buf/dma-fence.c                       |  4 ++--
 drivers/fsi/fsi-master-aspeed.c                   |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c            |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c            |  4 ++--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  2 +-
 drivers/gpu/drm/scheduler/sched_entity.c          |  4 ++--
 drivers/hid/intel-ish-hid/ipc/pci-ish.c           |  2 +-
 drivers/i2c/i2c-core-slave.c                      |  2 +-
 drivers/spi/spi-axi-spi-engine.c                  |  4 ++--
 drivers/ufs/core/ufshcd.c                         | 12 ++++++------
 fs/btrfs/extent_map.c                             |  4 ++--
 fs/btrfs/raid56.c                                 |  4 ++--
 include/linux/tracepoint.h                        | 11 +++++++++++
 io_uring/io_uring.h                               |  2 +-
 kernel/irq_work.c                                 |  2 +-
 kernel/sched/ext.c                                |  2 +-
 kernel/smp.c                                      |  2 +-
 net/core/dev.c                                    |  2 +-
 net/core/xdp.c                                    |  2 +-
 net/openvswitch/actions.c                         |  2 +-
 net/openvswitch/datapath.c                        |  2 +-
 net/sctp/outqueue.c                               |  2 +-
 net/tipc/node.c                                   |  2 +-
 30 files changed, 62 insertions(+), 50 deletions(-)

-- 
2.53.0

