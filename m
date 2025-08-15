Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8A818B12
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 21:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755292536; cv=none; b=jqe0LIIYCj4sY0FJBtGw/MEu5915GbCpQLSLT29GzgRF1fSujsZtmj/Q2OW1MW+BxpChoWa+O0SPlSoYZn5oOMcEcEX1XfNjJyfKsM2KQjJ2wnXeqzM+XkyfczjVFAxFoETxs+D2K3ccf45QdI6eXVW+CUqWNVN1+z4pIYhX2Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755292536; c=relaxed/simple;
	bh=yM77+y7bExQYww9w5/7DMYJrRphzeFK9YqMugFsodoM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o87mFyJVcOc09RYFtbBMl7NU+sDvm6pp7D/SF17ubnE20rGUnevo5+uuSoXa1gdjU+E1UNwdFS+y57v3+8luQv84hF5VjH7SX3VopxN1WFGuRZYZ6ho1ul6f5K2ifimHySabjJRM6uW34KqE5d47tuwPPSvDOdAcw6c28SrcPVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fcyb9koX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fcyb9koX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755292532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=j8MJx2l1ooHmotx1RPmsZQV93WPtcLtQ3jJlVuttYwM=;
	b=Fcyb9koX5P4pMrLyIQY4XYcKmeQ0Fx69kr1cMNx973kw27s3k+Nm8WshbWGrttymmHOhLt
	tW+bolyzr8DyDZjCTLD7rKu6yQ3LT2DhGF0CPBoLvxDba9sD0dWDIu0/+w+C6ttn2792jF
	IF+SqHZ1rnf16BhaLlC2UHpyoSDm3/U=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-260-c2xCA8nEPJqoTP92Bm6HYA-1; Fri,
 15 Aug 2025 17:15:31 -0400
X-MC-Unique: c2xCA8nEPJqoTP92Bm6HYA-1
X-Mimecast-MFC-AGG-ID: c2xCA8nEPJqoTP92Bm6HYA_1755292529
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E6C21954236;
	Fri, 15 Aug 2025 21:15:28 +0000 (UTC)
Received: from emilne-na.westford.csb (unknown [10.22.65.61])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D18ED19A4CAB;
	Fri, 15 Aug 2025 21:15:26 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com,
	bvanassche@acm.org,
	dlemoal@kernel.org
Subject: [PATCH v3 0/8] Retry READ CAPACITY(10)/(16) with good status but no data
Date: Fri, 15 Aug 2025 17:15:17 -0400
Message-ID: <20250815211525.1524254-1-emilne@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

We encountered a SCSI device that responded to the initial READ CAPACITY command
with a good status, but no data was transferred.  This caused a sudden change of
the device capacity to zero when the device was rescanned, for no obvious reason.

This patch series changes read_capacity_10() and read_capacity_16() in sd.c
to retry the command up to 3 times in an attempt to get valid capacity information.
A message is logged if this is ultimately unsuccessful.

There are some predecessor patches, one from a patch in a series by Mike Christie
which changes read_capacity_16() to use the scsi_failures mechanism (which did
not eventually get merged), this makes the changes here much more similar for
both the read_capacity_10 and read_capacity_16() case.  Another patch corrects
a potential use of an uninitialized variable, and a third one removes a check
for -EOVERFLOW that hasn't been needed since commit 72deb455b5ec
("block: remove CONFIG_LBDAF").  Other patches fill in missing .ascq entries
in the scsi_failures array and address other review comments.

The final patch to scsi_debug is allow insertion of the fault to test this change.

Changes in v3:
  - Removed patch to pass the length of the buffer through the sd_read_capacity()
    call chain and adjusted other patches accordingly.  Use RC10/16_LEN for memset()
  - Removed supurfluous parenthesis in conditionals

Changes in v2:
  - Added patches to explicitly specify .ascq in scsi_features usage
  - Pass the length of the buffer used through the sd_read_capacity() call chain
  - Simplify a conditional in scsi_probe_lun() that was requested in similar
    code in read_capacity_16()/read_capacity_10()
  - Changed code in scsi_debug() to make only one call to scsi_set_resid()
  - Moved some declarations around in read_capacity_16()/read_capacity_10()
    and memset() the whole buffer instead of the expected data size
  - Add the newly added flag SDEBUG_NO_DATA to SDEBUG_OPT_ALL_INJECTING

Ewan D. Milne (8):
  scsi: Explicitly specify .ascq = 0x00 for ASC 0x28/0x29 scsi_failures
  scsi: sd: Explicitly specify .ascq = SCMD_FAILURE_ASCQ_ANY for ASC
    0x3a
  scsi: sd: Have scsi-ml retry read_capacity_16 errors
  scsi: sd: Avoid passing potentially uninitialized "sense_valid" to
    read_capacity_error()
  scsi: sd: Remove checks for -EOVERFLOW in sd_read_capacity()
  scsi: sd: Check for and retry in case of READ_CAPCITY(10)/(16)
    returning no data
  scsi: Simplify nested if conditional in scsi_probe_lun()
  scsi: scsi_debug: Add option to suppress returned data but return good
    status

 drivers/scsi/scsi_debug.c |  47 ++++++++---
 drivers/scsi/scsi_scan.c  |   7 +-
 drivers/scsi/sd.c         | 167 ++++++++++++++++++++++++++++----------
 3 files changed, 162 insertions(+), 59 deletions(-)

-- 
2.47.1

