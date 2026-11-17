Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.165
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794883611;
	b=APlm+tyA9iklVHgA2subqMiu7sul0tKfpcGeluazLItzmYvh2d+LVEkClkT8sNhsaAXd
	 mETsHZRnOioFrQiHmHNEQ2TZTgT0jEm6ZL2OpK88at2UVvbxcDDr3VU5dvQDr++ErKYc9
	 Kp4FzDf5y26eFg6xbvJuQRQKuMXD0ZVHGQNQiJsJtTR/EPn+IiaCpKHUYWfi/SNVs2HaJ
	 jrTiye9SxuQ8Gn2mdf28mMf3n12lpEJDVb+SYRk1adMycqRmdpS1zHLSDMOAWTgrkZphf
	 1+dYubxZoB9w/JNCW3zqxSKhxwOm0Ewl6xn7hh6diTmrE7DTlwoOFmkqnEWF/6iZnfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794883611;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7czWWVAT5JV9Hgu1J/we5C/Mmw86nPPn7DAH8Olg8dI=;
	b=LeX/csF42djoZXx7PDChXpWvPdtBQXQXZGXqlm/by5KMXhjdRfhp/U642oMC17aw6P2E
	 iNI7sGVw+xchYI2tzsZMG++y1S7j35PYpFkyV/GzcCG3UM+Mr02/al5Ns9x6UDcrSXBIk
	 QejvQPOgLxzsLsmVgOdXomZJWX2Ie4IlrTXDJnLJ/hGc93mWFd03Abuo28L3GSYGpfU1A
	 IGY3oddXyNbfr6X3VM5dAz/39w4yw5Q4j0eBhb9aEnReCdM1bdIqvEIv+gkrRRV+Zqbiq
	 OC+24388gD2R1cejPh1EAaD3hMthx8iDt0gJRuEJMY/7xeza5BIUB9/d3D1SmDwXS6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Eoe2YQDc;
	arc=none smtp.remote-ip=91.218.175.165
Received: from mta0.migadu.com (out-165.mta0.migadu.com [91.218.175.165])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB69606A338
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 02:46:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2DB69606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Eoe2YQDc
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=+lyCNsOGqBEwZGBZXNbbfgivTSkomZxjKHS28V8jHeM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794883609; v=1; x=1795488409;
 b=Eoe2YQDcrs37v0hCU297WOF3bnEyAH/TMkkjhWVpjtIfopIe2Rr5hf/Ol10oyukvWybRQB5q
 IAM4nErB/BWWJQM1DcJuIkn1eSFLL3Hug3L3ilQ6DC3bcNxW0O14Tf1pTtCeKzzpyEyE+FrtcC1
 Q66sxA48nc9HdXHl8OsKufw0=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id de5ce04a605127d5;
	Tue, 17 Nov 2026 02:46:48 +0000
X-Mizu-Trace-ID: de5ce04a605127d5
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
Date: Mon, 16 Nov 2026 21:46:40 -0500
Message-ID: <20261117024640.3184554-1-qiliang.yuan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <avprIhtn1TuYLX1b@fedora-laptop>
References: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev> <avprIhtn1TuYLX1b@fedora-laptop>
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

On Sun, Nov 15, 2026 at 08:32:02PM -0600, Ming Lei wrote:
> This is ublk's uapi re-implemented inside LIO: FETCH/COMMIT_AND_FETCH
> per tag, pread()/pwrite() with (qid, tag) in the offset, and buffer
> registration via io_buffer_register_bvec().

Yes, the interface is modelled on ublk on purpose.

> 1) If LIO is required (vhost-scsi, FC, SRP, iSER), serve the device
> with ublk and export it via target_core_iblock. Same per-queue
> io_uring, same user copy and zero copy path, no new uapi. Please
> benchmark that configuration, with UBLK_F_USER_COPY and with
> UBLK_F_AUTO_BUF_REG, same 32 queues and threads.

Done, with kublk from selftests/ublk (loop target, -q 32 -d 128, "-u"
and "--auto_zc") behind target_core_iblock, against this series with 32
queues. Both serve the same 2 GiB file on tmpfs. Same VM (32 CPUs) and
fio jobs as in the cover letter, three alternating runs, median.

Over tcm_loop:

  User copy (UBLK_F_USER_COPY against pread()/pwrite()):
  workload               ublk + iblock (MB/s) this series (MB/s)  change
  4k randread, 1 job                      201                358    +78%
  4k randread, 4 jobs                     614               1440   +135%
  4k randread, 16 jobs                   4456               5899    +32%
  4k randwrite, 16 jobs                  1206               2077    +72%
  1M read, 4 jobs                        6444              15465   +140%
  1M write, 4 jobs                       5638               6941    +23%

  Zero copy (UBLK_F_AUTO_BUF_REG against fixed buffers):
  workload               ublk + iblock (MB/s) this series (MB/s)  change
  4k randread, 1 job                      195                330    +69%
  4k randread, 4 jobs                     621               1674   +170%
  4k randread, 16 jobs                   4051               5773    +43%
  4k randwrite, 16 jobs                  1140               1952    +71%
  1M read, 4 jobs                       27568              49666    +80%
  1M write, 4 jobs                       5326               7262    +36%

Over iSCSI on 127.0.0.1 (iscsi_target_mod and iscsi_tcp in the same
VM, 16 sessions, one fio job per session):

  User copy (UBLK_F_USER_COPY against pread()/pwrite()):
  workload               ublk + iblock (MB/s) this series (MB/s)  change
  4k randread, 1 job                      136                154    +13%
  4k randread, 4 jobs                     578                698    +21%
  4k randread, 16 jobs                   2516               2412     -4%
  4k randwrite, 16 jobs                  1512               1739    +15%
  1M read, 4 jobs                         613                716    +17%
  1M write, 4 jobs                       3747               5218    +39%

  Zero copy (UBLK_F_AUTO_BUF_REG against fixed buffers):
  workload               ublk + iblock (MB/s) this series (MB/s)  change
  4k randread, 1 job                      145                153     +6%
  4k randread, 4 jobs                     576                679    +18%
  4k randread, 16 jobs                   2740               2222    -19%
  4k randwrite, 16 jobs                  1716               1508    -12%
  1M read, 4 jobs                         778                805     +3%
  1M write, 4 jobs                       5235               5262     +1%

Through vhost-scsi to a nested KVM guest (16 vCPUs, 16 virtqueues,
worker_per_virtqueue=on), fio running in the guest:

  User copy (UBLK_F_USER_COPY against pread()/pwrite()):
  workload               ublk + iblock (MB/s) this series (MB/s)  change
  4k randread, 1 job                      335                213    -36%
  4k randread, 4 jobs                    1436                844    -41%
  4k randread, 16 jobs                   2341               2651    +13%
  4k randwrite, 16 jobs                  1467               1640    +12%
  1M read, 4 jobs                        8077              21991   +172%
  1M write, 4 jobs                       5006               6943    +39%

  Zero copy (UBLK_F_AUTO_BUF_REG against fixed buffers):
  workload               ublk + iblock (MB/s) this series (MB/s)  change
  4k randread, 1 job                      339                306    -10%
  4k randread, 4 jobs                    1521               1030    -32%
  4k randread, 16 jobs                   2589               1987    -23%
  4k randwrite, 16 jobs                  1518               1669    +10%
  1M read, 4 jobs                       37494              39978     +7%
  1M write, 4 jobs                       4519               8240    +82%

So this series is ahead over tcm_loop, about even over iSCSI, and
behind ublk + iblock for 4k with few jobs through vhost-scsi. I have
not found out yet where the time goes in the vhost-scsi case. With zero
copy and 16 jobs ublk is ahead on both fabrics, which I attribute to
auto buffer registration saving the two extra commands per I/O that
this series needs.

> 32 threads against one, over tcm_loop with data in memory, measures
> only the hand-off. Please run a real fabric and explain the -13%
> single job result.

Same fabrics, data in memory, TCM/USER against this series with one
queue (one server thread) and with 32. Over iSCSI:

  workload               TCM/USER  1 queue          32 queues
                           (MB/s)   (MB/s)  change     (MB/s)  change
  4k randread, 1 job          138      157    +14%        155    +12%
  4k randread, 4 jobs         538      679    +26%        685    +27%
  4k randread, 16 jobs        720     1101    +53%       2631   +265%
  4k randwrite, 16 jobs       859     1228    +43%       2161   +152%
  1M read, 4 jobs             756      799     +6%        765     +1%
  1M write, 4 jobs           2263     6075   +168%       5379   +138%

1M reads over iSCSI are limited by the loopback TCP connection for
every backend here (retransmits and zero window stalls), so that row
says nothing about the backstores.

And through vhost-scsi:

  workload               TCM/USER  1 queue          32 queues
                           (MB/s)   (MB/s)  change     (MB/s)  change
  4k randread, 1 job          201      237    +18%        238    +18%
  4k randread, 4 jobs        1095      902    -18%        843    -23%
  4k randread, 16 jobs        957     1119    +17%       2865   +199%
  4k randwrite, 16 jobs       749     1098    +47%       2599   +247%
  1M read, 4 jobs            5373    15317   +185%      56532   +952%
  1M write, 4 jobs           2064    10948   +430%      27074  +1212%

On the single job over tcm_loop: one fio job submits from one CPU, so
only one queue and one server thread are in use and it is one thread
against one. The TCM/USER handler finds the data area in its mmap and
takes a whole batch per wakeup, while the server here issues one
pwrite() per read on top of the io_uring_enter(). Counted over the
whole system during that job, that is 1.1 system calls and 0.27 context
switches per I/O for TCM/USER against 2.2 and 0.39 for this series.

> 2) If the goal is iSCSI for userspace storage, keep the kernel out of
> the data path entirely.

The goal is the fabrics LIO already has, vhost-scsi and tcm_loop as
much as iSCSI, for setups that run TCM/USER today.

Thanks,
Qiliang
