Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.222
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788289;
	b=AWDLx6cyfcRTerY30Z+achg6AGHzN8fc9BGC926uEDhVtDBi5fOa6j0bD2ttlCEsZu6i
	 khw739UmFSL0e3r4IvFqyaeMy3sre/Uuv4FI1LYrq+6h4nZxApIEiIjsK0dWNQj45nngE
	 A0WbVY0LamyW/+IKEgY5ZOHzaRZ/CdObg361wxa71HmNNN3kHrfUFCGXWJuXLPH9M6qnl
	 yLbLaqfQI/nuHNQ6IitpIYn6GcGokG4pgejf9nHQdFLrfileLE7tynPcPg4YQt+jeBn+4
	 gYSX3yiNi0yVDZ0OMvX6bYyGLqH+y+kDNYM3sOGLXc6Eq3ZfHjPd0s1q4TO+Q7gHB/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788289;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:To:
	 Cc:X-Mailer;
	bh=bEVsen0Z4XKtG98sBbUiY6hiqLLLzzqtV9NIpCrXVCY=;
	b=UUfMNItrWTA3gwim4VvRfhoSnB6P30rUt00o2OQcOuDiZSJ9et/l9jS4NQS/uWT1TS/S
	 S2929JXWdZkevKs0qg0s54cgGeL73VPDgqINhbeX0QV8WN8Cd5Lbefbig7fsOBA5vJAj/
	 wCTIlL84KBjKCta7UEBVVP7gNEWb/K+Z3TJ1Fprzk8zA+Hr+ymToGH45zPRHx7cnSI5KX
	 Q3QfUwxfwHXhoBy6qFjdcXQ4APskIQRIxypmuWRNL+vuGmqkAL7vC6A964qkyTZwHm4IJ
	 7ECfO0AxnrXZZIrdPDgCMgoMEa5rUJBPhlTD+8ovui1Pkm7AVCTgRXumplVsJ+4e1JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Outz9IDc;
	arc=none smtp.remote-ip=91.218.175.222
Received: from mta0.migadu.com (out-222.mta0.migadu.com [91.218.175.222])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1B0606A330
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 00:18:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE1B0606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Outz9IDc
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=LUmjHTjauelHCTImcnlLJ9hln9wqDY9gHPAu5bGOtwM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794788284; v=1; x=1795393084;
 b=Outz9IDcDuGE5hqx4zXYEqSTTzJQ34NOd8UC6hLRnWRc5baxtWGGR45Z6gFfympS42DOTh4M
 7vbj8p7UQyoA9K+6YMmegC0RcR/ZHyJtI+nP5bwJ6aRxi3nhouMEI9Z1314JnAugnxTSJ1ALhB+
 VKoKTrgm93zxma0UbxchG/+E=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 413efdc466c6c190;
	Mon, 16 Nov 2026 00:18:04 +0000
X-Mizu-Trace-ID: 413efdc466c6c190
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Subject: [PATCH RFC 00/18] scsi: target: Add target_core_uring, an io_uring
 based user backstore
Date: Sun, 15 Nov 2026 19:17:53 -0500
Message-Id: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALJL+moC/x3MsQqDMBCH8VeRmz3wLHHoKvQBukqHYP5Jb4nlk
 oogvntDx9/wfScVmKLQvTvJsGvRLTdI39H69jmBNTTTOIyTiDiO8JWrt4TK62bgr2lOHOTmJES
 4CKEWfwxRj/94oedjptd1/QCN/mLTbQAAAA==
To: "Martin K. Petersen" <mkp@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
 io-uring@vger.kernel.org, Mike Christie <michael.christie@oracle.com>, 
 Bodo Stroesser <bostroesser@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 Qiliang Yuan <qiliang.yuan@linux.dev>
X-Mailer: b4 0.13.0

TCM/USER is how a userspace process serves a LIO device, for instance
to export distributed storage over iSCSI or vhost-scsi. All commands of
a device go through one command ring under one mutex, the data of each
command is copied into and out of a shared data area, and the server
has to parse every SCSI CDB itself.

This series adds target_core_uring, a second user backstore next to
TCM/USER, built the way ublk is:

- The kernel emulates the SCSI commands. The server only sees reads,
  writes, flushes, UNMAP and WRITE SAME as an operation, an offset and a
  length.
- A device has several queues. Each queue is served through io_uring
  commands on its own ring, with no lock shared between queues.
- Data is copied once, with pread()/pwrite() on the character device, or
  not at all when the server registers the pages of a command as an
  io_uring fixed buffer.

Patches 1-4 create the device, its queues and the character device.
Patches 5-8 pass reads and writes to the server. Patches 9-11 handle a
server that exits or hangs, and aborts. Patches 12-14 add flush, UNMAP
and WRITE SAME, patch 15 adds fixed buffers. Patches 16-18 add a small
server, a selftest and the documentation.

Not covered yet: protection information, and a way for existing
tcmu-runner handlers to move over without changes, as they implement
SCSI rather than block commands.

Exporting a 2 GiB device through tcm_loop to fio (io_uring, direct I/O,
iodepth 32 for 4k and 8 for 1M, 6 seconds per job) on a 32 CPU VM, with
TCM/USER and a single-threaded handler, then with this series, 32 queues
and one server thread per queue. Both servers keep the data in memory.
A single job is slower; the gain comes with concurrency and with large
I/O. Three alternating runs (median, min-max in parentheses):

  workload               TCM/USER (MB/s)   uring (MB/s)          change
  4k randread, 1 job      426 (409-463)      369 (366-384)         -13%
  4k randread, 4 jobs    1165 (1072-1253)   1524 (1413-1541)       +31%
  4k randread, 16 jobs    920 (916-1162)    6193 (5845-6222)      +574%
  4k randwrite, 16 jobs   793 (711-886)     5701 (5257-5706)      +619%
  1M read, 4 jobs        6019 (5857-6047)  49460 (46706-57997)    +722%
  1M write, 4 jobs       2791 (2649-2907)  26692 (25958-27560)    +856%

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
Qiliang Yuan (18):
      scsi: target: uring: Introduce an io_uring based user backstore
      scsi: target: uring: Allocate per-queue command descriptors
      scsi: target: uring: Create a character device per backstore device
      scsi: target: uring: Map the command descriptors into the server
      scsi: target: uring: Queue commands until a server fetches them
      scsi: target: uring: Hand commands out through TCMUR_IO_FETCH
      scsi: target: uring: Complete commands with TCMUR_IO_COMMIT_AND_FETCH
      scsi: target: uring: Copy command data with pread() and pwrite()
      scsi: target: uring: Fail in-flight commands when the server exits
      scsi: target: uring: Time out commands the server does not complete
      scsi: target: uring: Drop aborted commands that are still queued
      scsi: target: uring: Support SYNCHRONIZE CACHE
      scsi: target: uring: Implement UNMAP
      scsi: target: uring: Handle WRITE SAME
      scsi: target: uring: Register command data as io_uring fixed buffers
      selftests: target_core_uring: Add a minimal server
      selftests: target_core_uring: Test a device exported through tcm_loop
      Documentation: target: Describe the uring backstore

 Documentation/target/index.rst                     |    1 +
 Documentation/target/tcm-uring.rst                 |   84 ++
 MAINTAINERS                                        |    2 +
 drivers/target/Kconfig                             |   10 +
 drivers/target/Makefile                            |    1 +
 drivers/target/target_core_uring.c                 | 1126 ++++++++++++++++++++
 include/uapi/linux/target_core_uring.h             |  126 +++
 tools/testing/selftests/Makefile                   |    1 +
 .../testing/selftests/target_core_uring/.gitignore |    1 +
 tools/testing/selftests/target_core_uring/Makefile |    8 +
 tools/testing/selftests/target_core_uring/config   |    5 +
 .../selftests/target_core_uring/tcmur_server.c     |  310 ++++++
 .../selftests/target_core_uring/tcmur_test.sh      |  137 +++
 13 files changed, 1812 insertions(+)
---
base-commit: 23c62304dde29abe92013d85910d03a77dada35d
change-id: 20261115-feat-target-core-uring-d1351dfe5fe1

Best regards,
-- 
Qiliang Yuan <qiliang.yuan@linux.dev>

