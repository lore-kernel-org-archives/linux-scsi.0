Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9B42367B5
	for <linux-scsi@vger.kernel.org>; Thu,  2 Oct 2025 19:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759433122; cv=none; b=MLjK+kMv61RHY+V2zz19avshqVFEJt1NrkjLpVuZCAuUklExOdU357Yk1pgA8QWMi4VN702PtHTVV1iiyBo/y9AAp8nbiu2WWSkxXpAkUEV/Chpj1dpaHqGd38rPcNXAv7s8CD4mQptvsXeQCOnoLsIbjeT98PnTb1SWqibDIdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759433122; c=relaxed/simple;
	bh=d/BwqPdUfFbHa8+l3SL7NzinlelkFnViqx2ysUcSI6U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hysp19Pr0+Go7WlktIHlkTfIvMgi+P+uhHa/RhjLBaUzAqHzT6XdZL0K2aEC0wXfpTINYznUltWUOb1MiiGiis3GXrW01hC8R9Zi9Qy4kxSJGZIbuJg0IL65/CL64w4k463mrGYym9ownWqy6ZfeR9cwsK8Ybqob5/GVE1+P2EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Inu3gerv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Inu3gerv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759433119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4E32gFZI1jBNxuR+iUGyvI/BNLM2aHcVOBoIXgUEkHo=;
	b=Inu3gervrDZ41WbEfGqQglUlCKhOF7YLDRS3Dw0Js8jni8lKrYSKfUbLwRWd+XfPJ534pw
	ZOAsq6lw59w5sG2A3Aaz5A9LWtY3lTmcWYaUo/NZSwsk32fPbZAOZbg4LCTol25c4/AfXB
	bIFgNzyBDWRb/QFNzRggLHn5OWoWiCE=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-14-qeXbJA6wNYigJBPl7pK_CQ-1; Thu,
 02 Oct 2025 15:25:14 -0400
X-MC-Unique: qeXbJA6wNYigJBPl7pK_CQ-1
X-Mimecast-MFC-AGG-ID: qeXbJA6wNYigJBPl7pK_CQ_1759433113
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D76121956087;
	Thu,  2 Oct 2025 19:25:12 +0000 (UTC)
Received: from emilne-na.ibmlowe.csb (unknown [10.17.17.93])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7CA9D1955F19;
	Thu,  2 Oct 2025 19:25:11 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com,
	bvanassche@acm.org,
	dlemoal@kernel.org,
	hare@suse.de
Subject: [PATCH v4 0/9] Retry READ CAPACITY(10)/(16) with good status but no data
Date: Thu,  2 Oct 2025 15:25:01 -0400
Message-ID: <20251002192510.1922731-1-emilne@redhat.com>
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

The final patches to scsi_debug allow insertion of the fault to test this change.

Changes in v4:
  - Add "only_once" module option to scsi_debug to allow testing of retry logic
  - Reset sdeb_inject_pending after OPT_NO_DATA fault is injected
  - Changed one patch subject message to be less verbose
  - Clarlified one commit message
  - Simplified a conditional in 2 places in one patch, and 1 in another

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

Ewan D. Milne (9):
  scsi: Explicitly specify .ascq = 0x00 for ASC 0x28/0x29 scsi_failures
  scsi: sd: Do not retry ASC 0x3a in read_capacity_10() with any ASCQ
  scsi: sd: Have scsi-ml retry read_capacity_16 errors
  scsi: sd: Avoid passing potentially uninitialized "sense_valid" to
    read_capacity_error()
  scsi: sd: Remove checks for -EOVERFLOW in sd_read_capacity()
  scsi: sd: Check for and retry in case of READ_CAPCITY(10)/(16)
    returning no data
  scsi: Simplify nested if conditional in scsi_probe_lun()
  scsi: scsi_debug: Add option to suppress returned data but return good
    status
  scsi: scsi_debug: Add "only_once" module option to inject an error one
    time

 drivers/scsi/scsi_debug.c |  99 +++++++++++++++++-----
 drivers/scsi/scsi_scan.c  |  20 ++---
 drivers/scsi/sd.c         | 167 ++++++++++++++++++++++++++++----------
 3 files changed, 212 insertions(+), 74 deletions(-)

-- 
2.47.1

