Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484483242B8;
	Thu, 22 Jan 2026 01:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769047062; cv=none; b=aa1b2y9HR91btVdlCDhfAQiq++T9Oakdy24iKC++OZ9Y+wQSAZRk6Nt3mcCX6JB9qejBrAsgLqf7CoZyY55cF9TBxfIQaWN27hKpJX2xhdS4YKVBIcAAxUYvKibjGNz6kwDcg15ObhQTx268LVfexX0E/8eHTZiks51KTDrytzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769047062; c=relaxed/simple;
	bh=P2Uv1Q3VuWXwSz+y0wB+XHnFHuSfz8k3ip0WFcxjugs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=c/sK92Ft8ZbLVX1tF7jhEU1aFHtbjdXesDVk1020zPv4q/FOK6e2Lseu7NIC7DbH0JtH41+bI4J746oYenAeKrfIX5zvDkXd4jsgaFDZjoomGv7jJ95je77mNjGNKtf+ohyfm2QK2MSdnUCAU0DUUDV9SVWkRfNd2k0FaK41Bv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=SafkkrPM; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="SafkkrPM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=N9
	rjxOL/Tkk8FKgypSTYcYZWzwbPodMr6gRIyaNOkv4=; b=SafkkrPMWGxEgKGccy
	Lin2yffn0/F8/V7FTGlpbvVqhHfSrakmZlzO9ep4o0dThOz/u7HIQogDXa8xd/x4
	vwFWCPjOdXaXMqufPW2siNTf+7FXyytA7zZwfslllLHgLg7yxn0V/g/YYC3Fhq3N
	bDp/pAK9yzSlj4od55AEuZkZ0=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgBHTZvng3Fp059XOA--.28408S2;
	Thu, 22 Jan 2026 09:56:55 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp,
	axboe@kernel.dk,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	bvanassche@acm.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [RFC PATCH v4 0/3] bsg: add io_uring command support for SCSI passthrough
Date: Thu, 22 Jan 2026 09:56:50 +0800
Message-Id: <20260122015653.703188-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgBHTZvng3Fp059XOA--.28408S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ArWUJw45Ar45XrW7KrW3Wrg_yoW5JF4fpF
	WSgr43Kr4UCw1xCF4fJFsrZa45Xws5GayxG343Gw10yFn8uF1ktrn0gr1FvFZrAry7K34j
	qw4jqrn8uw1UAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j1_M3UUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6QjRYmlxg+hl5wAA3j

Hi all,

This RFC series adds io_uring command support to the BSG (Block layer
SCSI Generic) driver, enabling asynchronous SCSI passthrough operations
with zero-copy support via fixed buffers.

The implementation follows the io_uring uring_cmd pattern used by other
drivers (e.g., nvme). A new bsg_uring_cmd structure fits within the 80-byte
cmd field of a 128-byte SQE, with 8 bytes reserved for future extensions.
The structure uses protocol-agnostic field names and follows the sg_io_v4
design with separate din_xferp/dout_xferp fields. SCSI status information
is returned in the CQE res2 field using a compact 64-bit encoding.

Currently only BSG_SUB_PROTOCOL_SCSI_CMD is implemented. Scatter/gather
I/O and bidirectional transfers are not yet supported.

The implementation has been tested with a user-space test program covering
basic SCSI commands (INQUIRY, READ CAPACITY, READ, WRITE), zero-copy mode,
and error handling.

The v4 implementation uses a callback function pointer pattern to maintain
independence of the generic BSG layer from specific protocol implementations,
avoiding build-time dependencies on SCSI-specific code.

Previous versions:
- v1: https://lore.kernel.org/all/20260112084606.570887-1-yangxiuwei@kylinos.cn/
- v3: https://lore.kernel.org/r/cover.1768536312.git.yangxiuwei@kylinos.cn

Changes since v1:
-----------------
- Protocol-agnostic field names (request/request_len instead of cdb_addr/cdb_len)
- Removed __packed attribute for better code generation

Why v2 was superseded:
----------------------
v2 unified din_xferp/dout_xferp into a single xfer_addr field, which
diverged from the established sg_io_v4 interface. v3 reverts to separate
din_xferp/dout_xferp fields to maintain consistency with the existing
BSG interface.

Changes since v3:
- Fixed undefined symbol error by using callback function pointer pattern
  instead of direct function calls
- Removed protocol-specific validation from generic layer (moved to
  scsi_bsg_uring_cmd)


Yang Xiuwei (3):
  bsg: add bsg_uring_cmd uapi structure
  bsg: add uring_cmd support to BSG generic layer
  bsg: implement SCSI BSG uring_cmd handler

 block/bsg-lib.c          |   2 +-
 block/bsg.c              |  35 ++++++-
 drivers/scsi/scsi_bsg.c  | 210 ++++++++++++++++++++++++++++++++++++++-
 include/linux/bsg.h      |   6 +-
 include/uapi/linux/bsg.h |  21 ++++
 5 files changed, 270 insertions(+), 4 deletions(-)

-- 
2.25.1

