Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DBC946C;
	Tue, 17 Mar 2026 07:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773732243; cv=none; b=lx25msCghs4nOvBz1qCPn8lOyOVxTtyEHPYcPdFLv4Lp471kNkPrKSyMIIWxOlph+TkxhBmEk6pmzOgS4sWrmeu6ui9jE3gV67vTRbTO22gUiYGero1hQ8yMeCtU80F8QWy19K6yhFrQmNfTMEpn8X85NJ0aZr1WhvsBQLqdTlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773732243; c=relaxed/simple;
	bh=2aQL3h4vAZqhe8FLytscr8ZspWkcLAwcnVrlKO6R1g8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZVArC48UV3sUxax1nHBTlNS3l4X8YNU3apFOkv1nSNcSRj3nojTjP5u9oRsCi6dBMzMStM6q9vu8ZcVRMXW+tUiAhdw//EbP6O/hjlg/aAg6+rdr+VSKUhMww3DyvNuNMDfyLk8jZmkV5waE9uEb+B+G5jqNKn8bpX7EEqzjFpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=aNVnjBOk; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="aNVnjBOk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=iS
	pE/xcjVj3VAtaQdAmaqk6iLKGTZA1Yrm3dTSt/P64=; b=aNVnjBOkB48sedJcCF
	fGRLNQqj3Qeh19pX/AfKgCxj0yMxqu6GIopFjEth+W2usC6A3iUSeg5YArb1AVdu
	MPT73tji6Dwu0sYjiz3/SrIsPfQnHkVqBRUd5ggTJxGxFZrRWFA4TB4/NDK9J20i
	No4i/r3Y/Ve+z4hJDeyf1wnZA=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgCnhdw1AblpkrBDWA--.58229S2;
	Tue, 17 Mar 2026 15:22:30 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: axboe@kernel.dk,
	fujita.tomonori@lab.ntt.co.jp,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	bvanassche@acm.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v8 0/3] bsg: add io_uring command support for SCSI passthrough
Date: Tue, 17 Mar 2026 15:22:23 +0800
Message-Id: <20260317072226.2598233-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgCnhdw1AblpkrBDWA--.58229S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxWF13Ar13Xw4kJrW3JF1kKrg_yoWrGFW3pF
	WjgFs8Kr4UCF1xtFyfAr4DZFyYqwn3GayxG3y7X3y0yF1UZFnrXr4DKF43JFsrury7CFyj
	qrnFqr4DC3WkA37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jOGYdUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6hgXp2m5ATjchAAA3z

This series adds io_uring command support to the BSG SCSI passthrough path.

The goal is to allow userspace to submit SCSI passthrough commands via
IORING_OP_URING_CMD, in addition to the existing sg_io interface.
The io_uring path mirrors the existing BSG behaviour: it currently only
supports BSG_PROTOCOL_SCSI + BSG_SUB_PROTOCOL_SCSI_CMD and does not
support BIDI transfers.

Patch 1 defines struct bsg_uring_cmd in the UAPI and documents the CQE
res2 layout with extraction/assembly macros for userspace.

Patch 2 extends the generic BSG layer with an .uring_cmd file operation
and a bsg_uring_cmd_fn callback, allowing transport-specific handlers to
be registered.

Patch 3 implements the SCSI BSG io_uring handler. It builds a SCSI
request from struct bsg_uring_cmd, maps user buffers (including fixed
buffers), and completes asynchronously via a request end_io callback and
task_work. Completion returns SCSI device/host/driver status, residual
length and sense length packed into CQE res2; status is read from
scmd->result in task_work.

Changes since v7 [3]:

  [1/3] bsg_uring_cmd UAPI
  - Add a static_assert() to document and verify the size of struct bsg_uring_cmd (Bart).
  - Convert BSG_SCSI_RES2_* macros into static inline helpers in the UAPI header (Bart).

  [2/3] generic BSG layer
  - Combine variable declarations with their initializations in bsg_uring_cmd() (Bart).

  [3/3] SCSI BSG io_uring handler
  - Add a static_assert() to validate that the per-command PDU fits into io_uring_cmd.pdu (Bart).
  - Combine several variable declarations with their initializations in the task_work callback (Bart).

No behavioural or functional changes are intended in v8 compared to v7.

Changes since v6 [2]:

  [1/3] bsg_uring_cmd UAPI
  - Removed the flags field (Bart).
  - Documented CQE res2 layout and added BSG_SCSI_RES2_* macros for userspace (me).
  - Added BSG_SCSI_RES2_BUILD() in UAPI (me).

  [2/3] generic BSG layer
  - Reordered variable declarations (longest to shortest) (Bart).
  - Use early return when uring_cmd_fn is not set (Bart).

  [3/3] SCSI BSG io_uring handler
  - Read device/host/driver status from scmd->result in task_work (Bart).
  - Use status_byte() and host_byte() instead of open-coding (Bart).
  - Removed superfluous " & 0xff" from u8 expressions (Bart).

Compared to the earlier RFC v4 series [1], this version only includes
minor code cleanups (mainly comments and wording), without changing the
behaviour or logic of the implementation.

[1] https://lore.kernel.org/linux-block/20260122015653.703188-1-yangxiuwei@kylinos.cn/
[2] https://lore.kernel.org/linux-block/20260305012857.2136525-1-yangxiuwei@kylinos.cn/
[3] https://lore.kernel.org/linux-block/20260312092237.2464560-1-yangxiuwei@kylinos.cn/

Testing
-------
Testing was done inside a VM on a disk with:
  /sys/block/sdd/mq/0/nr_tags      = 1024
  /sys/block/sdd/queue/nr_requests = 256

The following SCSI INQUIRY micro-benchmark was run with N=100000:

  sg+SG_IO (v3), /dev/sg4:
    avg = 139.0 us, p50 = 128.9 us, p90 = 149.7 us, p99 = 301.0 us

  bsg+SG_IO (v4), /dev/bsg/2:0:0:0:
    avg = 97.2 us,  p50 = 92.7 us,  p90 = 111.5 us, p99 = 150.9 us

  bsg+io_uring, /dev/bsg/2:0:0:0:
    avg = 105.9 us, p50 = 95.4 us,  p90 = 116.2 us, p99 = 175.0 us

  bsg+io_uring (batch=64), /dev/bsg/2:0:0:0:
    avg = 61.9 us,  p50 = 60.9 us,  p90 = 63.9 us,  p99 = 94.6 us

Yang Xiuwei (3):
  bsg: add bsg_uring_cmd uapi structure
  bsg: add io_uring command support to generic layer
  scsi: bsg: add io_uring passthrough handler

 block/bsg-lib.c          |   2 +-
 block/bsg.c              |  33 +++++++-
 drivers/scsi/scsi_bsg.c  | 176 ++++++++++++++++++++++++++++++++++++++-
 include/linux/bsg.h      |   6 +-
 include/uapi/linux/bsg.h |  75 +++++++++++++++++
 5 files changed, 288 insertions(+), 4 deletions(-)

-- 
2.25.1

