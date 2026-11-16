Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788426;
	b=vqk6URmo+tohyHt6fAhaD2bvzwxE3KH76Q8YlluHWu+YgJ8/UxbC13pitRyfEBzWu9Zx
	 asC5Bjx+9SgWUbspHMK175cKIa4qmBgFDKlQE+v0Jc52cDHJa2uSk/znUS4AuzzBwEzlF
	 HKEqWpVuiltFA8RrYfDwA9GkgwqPMreA8fUdVNHmvBQhg4YswOIF62wfstrenSAtA1e2D
	 4a8f0gms5FSyAD25Pj24661lKYC7pYhYpEqBKwu7ZJsLD9sk9PaDQucRLj+SqZSug+bM3
	 IXvbVrQvWhKgbhWi4bLyTvdL18LXWhrD2DR7MGNNEmTy4Zu/q7ACqu5v81o3JXe1S5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788426;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=4eG5CVxVnNeWp3KUkHiU/UFqeHQnVoeyxI1ZUaXIdH8=;
	b=KtCEEaDfaFUCr5GeimWSv2d0d6NaG86qonKZa1hJJeqBZbC87GoyKNADC0w1kvRCWxcD
	 g5im312GbuVIi0A71p4pJnFiW7Bk37kaq3Zinwx42BtlYj7GTVBX9ZiUoVN7tXYNAB4Nb
	 +FcpZjR/IEwbM7lw4MTIdnd26bbTAhe+AyKZ5VAlZoeJI4Ix9omNWUoGwBbTwIM10WWJY
	 GKcRl+uilgnljbFA0DtWM7sdQfROJdhJetJlhh7/rAeYwsgdoM8l4hNYehZdsgugBKYGi
	 BIy4yiCmMgsmSDZ47dYi8HsTcj4sQCax1MPtxaxnWWMXafHySt6CmcthOUwekO7SF+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ud9VT9cy;
	arc=none smtp.remote-ip=95.215.58.228
Received: from mta1.migadu.com (out-228.mta1.migadu.com [95.215.58.228])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55FC606A323
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 00:20:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E55FC606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ud9VT9cy
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=KWOMiOdqLTUcS7AFYWTNaPVfHdHsr6JQcL0b0AXvC5o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794788424; v=1; x=1795393224;
 b=ud9VT9cyYHo+Pv+wHlKsQYj3Bjh6MwjV/AhsjBSJaa0+aap/OjlKuksZvr/n5vY/OfgjrphL
 A1VODyO75aThf3kv8uHyy0bAf/ox6+NvKxJPaGXsinDYG0GNC4AWBtZ1ZhuqUm23a7+wGnztYP7
 S9P2m3d3hMhdaTgXly8gWCiQ=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 67c85e73c015bfed;
	Mon, 16 Nov 2026 00:20:23 +0000
X-Mizu-Trace-ID: 67c85e73c015bfed
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Sun, 15 Nov 2026 19:18:11 -0500
Subject: [PATCH RFC 18/18] Documentation: target: Describe the uring
 backstore
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
Message-Id: <20261115-feat-target-core-uring-v1-18-28cdc137eac6@linux.dev>
References: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
In-Reply-To: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
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

target_core_uring is a new LIO backstore served by a userspace process.

Its configfs parameters and the protocol between the kernel and the
server are only described by the uAPI header and the code.

Add tcm-uring.rst, which explains how the backstore differs from
TCM/USER, how to create a device and what a server has to do.

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 Documentation/target/index.rst     |  1 +
 Documentation/target/tcm-uring.rst | 84 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+)

diff --git a/Documentation/target/index.rst b/Documentation/target/index.rst
index 51fa8ebc652ef..253b5fe422732 100644
--- a/Documentation/target/index.rst
+++ b/Documentation/target/index.rst
@@ -8,5 +8,6 @@ TCM Virtual Device
     :maxdepth: 1
 
     tcmu-design
+    tcm-uring
     tcm_mod_builder
     scripts
diff --git a/Documentation/target/tcm-uring.rst b/Documentation/target/tcm-uring.rst
new file mode 100644
index 0000000000000..2911d80721f75
--- /dev/null
+++ b/Documentation/target/tcm-uring.rst
@@ -0,0 +1,84 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+======================
+TCM io_uring backstore
+======================
+
+target_core_uring is a LIO backstore whose block commands are served by a
+userspace process, like TCM/USER (see tcmu-design.rst). It differs from
+TCM/USER in three ways:
+
+- The kernel emulates the SCSI commands. The server only reads, writes,
+  flushes and unmaps blocks and never parses a CDB.
+- A device has several queues. Each queue is served through its own
+  io_uring, so that queues do not contend with each other.
+- Data is copied once, with pread() and pwrite(), or not at all when the
+  server registers the data pages of a command as a fixed buffer.
+
+Creating a device
+=================
+
+A device is created through configfs like any other backstore::
+
+    mkdir -p /sys/kernel/config/target/core/uring_0/disk0
+    cd /sys/kernel/config/target/core/uring_0/disk0
+    echo "dev_size=1073741824,nr_queues=4,queue_depth=128" > control
+    echo 1 > enable
+
+The ``control`` file takes these parameters:
+
+``dev_size``
+    Size of the device in bytes. It must be a multiple of the block size.
+
+``block_size``
+    Logical block size in bytes, 512 by default.
+
+``nr_queues``
+    Number of queues, 1 by default. A command goes to the queue selected by
+    the CPU it was submitted on.
+
+``queue_depth``
+    Number of commands the server can work on per queue, 128 by default.
+
+``cmd_time_out``
+    Seconds after which a command the server has not completed fails. 30 by
+    default; 0 waits forever.
+
+Once the device is enabled, the ``info`` file shows the character device
+the server has to open, for instance ``/dev/tcmur0``.
+
+Serving a device
+================
+
+The interface is defined in ``include/uapi/linux/target_core_uring.h``.
+Only one process can open the character device at a time. The server:
+
+1. Reads the geometry with the ``TCMUR_GET_DEV_INFO`` ioctl.
+2. Maps the descriptors of each queue read-only, at offset
+   ``q_id * TCMUR_DESC_AREA_SIZE``. The area holds one
+   ``struct tcmur_io_desc`` per tag.
+3. Issues one ``TCMUR_IO_FETCH`` io_uring command (``IORING_OP_URING_CMD``)
+   per tag. A fetch command completes with 0 once the descriptor of its tag
+   holds a command.
+4. Handles the command and issues ``TCMUR_IO_COMMIT_AND_FETCH`` with the
+   result, which also waits for the next command of the tag.
+
+The server owns a tag from the completion of the fetch command until it
+commits the result. Meanwhile it accesses the data of the command in one of
+two ways:
+
+- pread() and pwrite() on the character device at the position returned by
+  ``tcmur_buf_pos()``. Reading returns the data of a write command; writing
+  fills the data of a read command.
+- ``TCMUR_IO_REGISTER_BUF`` registers the data pages as a fixed buffer of
+  the io_uring, which the server then passes to ``IORING_OP_READ_FIXED`` or
+  ``IORING_OP_WRITE_FIXED`` on its backing store. The buffer has to be
+  removed with ``TCMUR_IO_UNREGISTER_BUF``; the command only completes once
+  it is gone.
+
+Commands that arrive while no tag is waiting stay queued in the kernel.
+When the server exits, the commands it was working on fail and the queued
+ones wait for the next server, until they time out.
+
+``tools/testing/selftests/target_core_uring/tcmur_server.c`` is a small
+server that implements all of the above.

-- 
2.43.0

