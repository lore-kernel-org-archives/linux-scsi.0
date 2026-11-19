Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.210
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050165;
	b=jANymiRTh0V+sBMEfSlF2A04eXzCbmwwEmFNE/jiaSPywa6Z0PpD2qe4t5riuU1Tdf9S
	 o78T6hYZWj+Kog43uX2PgICCJ1XyxlipmNz7sG9ObN9Uwdepr9l49PCyU+VxqxRcIErWI
	 wQlRaXrCjdsSbTdy4nc7B97Aa+HJgh8j1L6jTzN34hjmDgWHUzJy/rwsM2+IJr9DKqbPn
	 rFltmbcohwUxdhQ2NKMTWwJwCL1eayt9/w7Z/tnQGhpBixZ5eodwwaQ/evgM+5uVfGAky
	 RojuG7LOSCPaw3+bUlxJyZLBC90tIlx/KgACefyHNE6zxqmeTVCLipcbuCfAsaleVbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050165;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=BlL4W75h1MApHqdiv3CTVmX4B2zbrj1hbYs9giA+q5g=;
	b=wOYsQAHYkTxj83gUpTfBF9ihMIZei2yrEpCHmudFdJCdCE83ucNt3lJ2Bp1dqUlgS5wl
	 Bx/gUeNQXIlB9Y8Ruq0140hW8QkrAGven09erJW3ZqATVZf6jAgxru+KWqmRgRG+SpxrK
	 R1Y1GCAS08RcNs+sBgQUIn8HNEM2qbGkkkY6Vp9O3upoQXtrx38BkNJ4Dx1+6kICDDR8J
	 A10XoH9T6ItuLVd+JOMFsc1zaabpkZa0rD+Ban/1dhvcO+Wh0tql2YzBNri8KWv9xjBZB
	 wzKYULMmOn58Y3m6ipNUyG4omN9NPVi+El/diM4lx7YWF+rRyT0VLkFD3BUl+CKwYeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fpFl4L4R;
	arc=none smtp.remote-ip=95.215.58.210
Received: from mta1.migadu.com (out-210.mta1.migadu.com [95.215.58.210])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A77606A332
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 01:02:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1A77606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fpFl4L4R
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ux0kfY5j7nM7oh8a7BfUtbSzQISJcSgoiHsY5y3C7fo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795050162; v=1; x=1795654962;
 b=fpFl4L4RdOYRvsiHM+GOdTXfY0EaUgQcWvxjZu5E3Iv9+BQZa/n8b9XA4f9Z5qDlBLG+tUXI
 lzbf8E45R6pbwSlF/bLPvWn8nZdmKdusdtPneU0j6QT68TFJKw7pUq/iGap/n11nC8WuHFZhFq1
 iOkoa/h2KlJBvxgUm+WIY/0U=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5966f3fd4a58c3d7;
	Thu, 19 Nov 2026 01:02:42 +0000
X-Mizu-Trace-ID: 5966f3fd4a58c3d7
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Qiliang Yuan <qiliang.yuan@linux.dev>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Mike Christie <michael.christie@oracle.com>,
	Bodo Stroesser <bostroesser@gmail.com>
Subject: Re: [PATCH RFC 00/18] scsi: target: Add target_core_uring, an io_uring based user backstore
Date: Wed, 18 Nov 2026 20:02:33 -0500
Message-ID: <20261119010233.2917434-1-qiliang.yuan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <av0CAptnbIZP-53U@fedora-laptop>
References: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev> <avprIhtn1TuYLX1b@fedora-laptop> <20261117024640.3184554-1-qiliang.yuan@linux.dev> <av0CAptnbIZP-53U@fedora-laptop>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, Nov 17, 2026 at 07:40:18PM -0600, Ming Lei wrote:
> Can you share your setup? It is supposed that you run fio from VM,
> otherwise you can just compare ublk with scsi backed with tcmu.
>
> But if you run fio from VM, I believe you can setup virtio-scsi backed by
> ublk block device directly, which should cover your requirement, or maybe
> I miss something?

Everything runs in one 32 CPU guest. For tcm_loop and iSCSI (16
sessions over 127.0.0.1), fio runs in that guest on the initiator
disks. For vhost-scsi, fio runs in a nested 16 vCPU KVM guest on the
vhost-scsi disk, with the target and the backstore server in the outer
guest. In the ublk runs, kublk serves the file as /dev/ublkbN and
target_core_iblock exports that through the same fabric.

You are not missing anything. This backstore has block semantics: the
kernel emulates the SCSI commands, PR and ALUA included, exactly as for
iblock, so ublk behind target_core_iblock offers the same function on
every fabric, and for a VM a virtio-scsi or vhost-scsi disk on top of
the ublk device covers it as well. What the series adds over that is
only performance, and outside tcm_loop the numbers I sent do not show a
consistent gain.

[...]

> My question is actually why there is regression wrt. 4k randread:
>
>  workload               TCM/USER (MB/s)   uring (MB/s)          change
>   4k randread, 1 job      426 (409-463)      369 (366-384)         -13%
>
> Maybe you can focus on single job perf only, which is easy to compare and
> investigate.

It comes from the scheduler moving fio between CPUs. The pwrite() I
pointed to in my last mail is not it: doing that copy inside
io_uring_enter() instead makes no difference.

tcm_loop queues the LIO submission and completion work on the CPU that
submitted the command, so with one job, fio's CPU always has bound
kworkers and ksoftirqd runnable next to fio. The load balancer cannot
move those and moves fio instead. This backstore gives it more chances:
the completion work on fio's CPU handles 14 commands per run here
against 24 with TCM/USER, so per 1000 I/Os the completion kworker and
ksoftirqd run about 57 times against 35, fio is preempted as often, and
it is moved two to three times as often. With balancing on, fio's own
CPU time per I/O doubles here, from 3.1 to 6.3 us, against 3.4 to 4.9 us
with TCM/USER, spread over the whole submission path rather than in one
function.

Turning load balancing off for fio's CPUs and nothing else reverses the
result. Single job, 4k randread at iodepth 32 over tcm_loop, 6 s per run,
five alternating runs, median (min-max). fio runs in a cpuset of CPUs
4-31 and the server threads are pinned to CPUs 0-3; the cpuset is either
a normal member (balanced) or an isolated partition (not balanced):

  fio CPUs 4-31, backstore      bandwidth (MB/s)   change
  balanced, TCM/USER               439 (398-462)
  balanced, uring                  379 (371-388)   -13.7%
  not balanced, TCM/USER           662 (544-710)
  not balanced, uring              760 (575-798)   +14.8%

Booting the guest with idle=poll removes the gap as well: with fio free
to move, five runs give a median of 612 MB/s with TCM/USER and 627 MB/s
here.

That points at what each switch costs in a guest. An idle vCPU executes
HLT, which exits to the host and puts the vCPU thread to sleep; waking
it for a kworker, ksoftirqd or a migrated fio takes an IPI, a host
wakeup and a VM entry, and the host may run the thread on another
physical CPU, so the guest code then runs with cold caches. With
idle=poll the vCPUs spin instead, stay on their physical CPUs and take
the IPI without an exit. This backstore makes more of those switches
per I/O, so it pays more of that cost, and fio's slowdown spread over
the whole submission path looks like cold caches.

What is measured is that idle=poll removes the gap and that the gap
follows the switches and migrations. Which part of the cost is the exit
and wakeup latency and which part is the vCPU thread landing on another
physical CPU is inferred: I cannot trace the host side here. Waking an
idle CPU is much cheaper on bare metal, so I expect the gap to be
smaller there, but I have not measured it. idle=poll is only a
diagnostic, it burns a host CPU per idle vCPU.

[...]

> When userspace target becomes more efficient, I'd suggest you to think
> about why these applications can't be improved or refactored for the
> potential (bigger)perf requirement.

Agreed. Since this backstore only takes block commands, an application
that can move to it can just as well move to ublk, and one that needs
SCSI semantics in userspace is not served by it either.

Thanks,
Qiliang
