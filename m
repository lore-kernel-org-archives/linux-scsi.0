Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35E24DD3D7
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 12:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789649748; cv=none; b=FNkwKZid+KHkc0qc8WKwogyyeN7F2ZEkxyfjHD9veCTFbRLebINJdZm2pvsunOUAQLbhS24y4nXYXBphKVfGLGg7rvMJKAxTx7mTEMyJAD1xBYavaBJ6QeLaevp3f2OK5YPKoenshIY2KrDqRSELzFHJh8rVjnW4zUHqX05Gx2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789649748; c=relaxed/simple;
	bh=JStOVV72gwAWPMsgqW8w3ukIH/rrvhmORnk3QcNTYps=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IZY7mFNOQH3+Evt5oosEx7xEY+tqJoz7Us/HTeBAT+hzZUw5ylzRvCUrr99kHwwLTsfvQuQc2Vuxq6FFGc+TA/RcJbFYhT8p+cSoQztUzsdH0P+r3u/ltUDWXmADjW/NsYPY95aer0g5Pp4TJ3zbeS7eFnMnh+GgxHX9wLfDphY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dUDe8MqA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dUDe8MqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF1A1F00893;
	Thu, 17 Sep 2026 12:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789649743;
	bh=tCU4DKnynve/gZTg+19POBmZSkp2WWEg8KJKX/NGKlQ=;
	h=From:To:Cc:Subject:Date;
	b=dUDe8MqAsTOD5MdhHcbgw/Z+i1Au0RBwpB8Z1nSg1rjMLhYrcwEoSimo0jdZ0p8hV
	 FidplE5VX8+WuIhBnTp9GPEdSDgLC6Q/7CL5OkAAz6FcaC/jJ2hUMD+Hd7hpLR1Boi
	 naltw3uSOfRLZODsscSlctHmjDqV7Rp0vhyfh53Uhyc+N4e1hmzNABInZlBwRb5EyI
	 P9N3+SKmnHSoMCSJKhDHQvumz2YUvjZ4b2b3XyuRXllHb55n4e1ZBEVkCF1OrMYx5N
	 vUWboQzLNLtxbhf8UNHA6UcWX3hFI/auggxX/VE/HBMxWYfRkUX9fwR+en+ysfWxcp
	 4JnsUPnecCd5Q==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v3 0/6] scsi: scsi_debug: fix zoned write validation
Date: Thu, 17 Sep 2026 14:54:46 +0200
Message-ID: <20260917125445.1376493-8-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1485; i=cassel@kernel.org; h=from:subject; bh=JStOVV72gwAWPMsgqW8w3ukIH/rrvhmORnk3QcNTYps=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJWPxb1OpOUKGnhMGlaQnbwRKaWWS+2HCtKfZup6rCYs XN1/9UPHaUsDGJcDLJiiiy+P1z2F3e7TzmueMcGZg4rE8gQBi5OAZhIlgTDf/cio/ULPY6+apLy 6/DZ71qy/S/ng0XSzqodhW2NS3xNqhgZ9ljP5U5b+DGlJ4uv3XTLvz/R4qcSluw4c4x3vcXKusm 5PAA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

This series fixes scsi_debug with regards to writes to a ZBC drive.

The series is based on 7.4/scsi-staging rather than 7.3/scsi-fixes (as
Damien suggested on v1) to avoid a build warning that would have happened
if this series was simply merged with linux-next (7.4/scsi-staging):

  error: too many arguments to function 'mk_sense_buffer'

Tested on a zoned scsi_debug device with 512 byte logical blocks and a
4096 byte physical block.

Changes since v2:
- Added patch 1, to that write paths correctly report the residual.
- Added patch 2, so that do_device_access() will always write a
  multiple of physical block size. (Reads are unchanged.)
- Patch 3 changed to advance the WP by how much that was actually written
  (rather than leaving the WP alone when not all blocks were written).
- Patch 5 changed to take the meta write lock if scsi_debug_lbp() is set.

Niklas Cassel (6):
  scsi: scsi_debug: Report the residual of a write
  scsi: scsi_debug: Do not write a partial physical block
  scsi: scsi_debug: Advance the write pointer over the data written
  scsi: scsi_debug: Enforce physical block alignment of zoned writes
  scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)
  scsi: scsi_debug: Validate zone access for WRITE ATOMIC (16)

 drivers/scsi/scsi_debug.c | 66 +++++++++++++++++++++++++++++++++++----
 1 file changed, 60 insertions(+), 6 deletions(-)


base-commit: c3cff7fac01638ab58e85fe7df41a04fa25c5bae
-- 
2.55.0

