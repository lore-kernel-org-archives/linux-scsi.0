Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1787230BD9
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 18:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755196161; cv=none; b=BtKubjgPIT5EMRBpA/RiUs3WfYxsptl2U1xWskZB7ll/bHM0blwzuyngZQ0QVexhmpU3xcdeTySWq73h/xChwSF6DS3Et9O9BtvAbuvHLuTSwBH0rfjhdx4ZXWRqTS863awvNwtOiLo7Jj3+96bK4ePrrTqTv8MwhqtOXUksc0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755196161; c=relaxed/simple;
	bh=bJbyx5WEmL5zKgNcHwa7KRUxFsjRWw6AUjdDbYrRj+k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EOyEtjbQbJj66HFik2dLvfLdWvKqBO0+Qob6JccZVIzA4doJgsb5aofd2lUIKvCAHG5XE25+zFA+2koYfdKH8X8VHWy8Ih+2QZB5KztqnTYZPGJHgI60pcm3/l9i9SappyVYPyfjTMNMJsBfNrXBkUGmrHbBjQPBgdL1rFz02D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ShWFQnAP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ShWFQnAP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755196157;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bWZK7C0PCRQ+a+HVHFe6JiA8q3vauaqizUPAhp7PddA=;
	b=ShWFQnAPUOQJ2NRQwiQ9sQzpO2YX3hbunqQzkA+uWY3mvQ84AkjQhTEM1uwPc1FHL/1S03
	VUwquREeojOq0P6A/67stf+jYyhzQjn5IsK3lPiC7TCSBiaP1RDiAseICb6E6r1Y9MKPuG
	rQNl+cz1aTuOMLlwU4f0Ufo5S1wTySs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-6-R_bZ8u-RP46WqSIMeeReOA-1; Thu,
 14 Aug 2025 14:29:11 -0400
X-MC-Unique: R_bZ8u-RP46WqSIMeeReOA-1
X-Mimecast-MFC-AGG-ID: R_bZ8u-RP46WqSIMeeReOA_1755196150
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 28E461800446;
	Thu, 14 Aug 2025 18:29:10 +0000 (UTC)
Received: from emilne-na.westford.csb (unknown [10.22.65.61])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 072CA1800280;
	Thu, 14 Aug 2025 18:29:08 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com,
	bvanassche@acm.org
Subject: [PATCH v2 0/9] Retry READ CAPACITY(10)/(16) with good status but no data
Date: Thu, 14 Aug 2025 14:28:58 -0400
Message-ID: <20250814182907.1501213-1-emilne@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

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
  scsi: sd: Explicitly specify .ascq = SCMD_FAILURE_ASCQ_ANY for ASC
    0x3a
  scsi: sd: Pass buffer length as argument to sd_read_capacity() et al.
  scsi: sd: Have scsi-ml retry read_capacity_16 errors
  scsi: sd: Avoid passing potentially uninitialized "sense_valid" to
    read_capacity_error()
  scsi: sd: Remove checks for -EOVERFLOW in sd_read_capacity()
  scsi: sd: Check for and retry in case of READ_CAPCITY(10)/(16)
    returning no data
  scsi: Simplify nested if conditional in scsi_probe_lun()
  scsi: scsi_debug: Add option to suppress returned data but return good
    status

 drivers/scsi/scsi_debug.c |  47 +++++++---
 drivers/scsi/scsi_scan.c  |   7 +-
 drivers/scsi/sd.c         | 188 +++++++++++++++++++++++++++-----------
 3 files changed, 174 insertions(+), 68 deletions(-)

-- 
2.47.1

