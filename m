Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEA7214818
	for <linux-scsi@vger.kernel.org>; Wed, 16 Jul 2025 18:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752691721; cv=none; b=qOiTSnxD4qs9f4hdc36vxNy/OVhzdOkVllZDQHnKdMKUbxSv7Pmoni+JudZoO3b6NuMQGq2rzRdqQXoGp9Pc6uTPdNmg2tCDbEotyDS8r0PKqSUxGvI5arzTl0hTTFYu7T4QSlFPv4ECKtcKItsCtGBF2xCTyXwAv5FR+sahHjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752691721; c=relaxed/simple;
	bh=/CX7qi6Gve4+EvpjZEQqAx1sElg/ysNZJMVqY5sdqro=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AtwTzN6tiAdVlap+hwlCrjCmJNl66N4QGSmyHz98ModjcG1bopCQoRlVyLYD84vlI3Qe9ANw6dwJhN6hK3bc7aKDq79FLDhJke6qFjNHXtr72fsDou6/n6+Lii0kj/j04l6MCRWI88+EN3eol/NIMMlW1X0fugI5SRsKqqKRBKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JGUT+IVq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JGUT+IVq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752691717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HgyouK/1dodaDscXtYlkkME16ZsXbVaMJlyfK2bYVlU=;
	b=JGUT+IVqayW8dacluG3o/kPOX+jAv8PbHbq4N3PkA+tsN3BO0YLyGB+0KBlQuF7MtKbgEz
	MXSMTJKdTKaBfWABUOdx529Nb4TNk1V97bxyk/mg+daUGgbCbkfTkvey35WXHI2+nrTZxW
	VmREmvyGgg0wA0lOH8QH6EMDEXlyYQQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-5-XaQCDUB5OiCdYJ-tyShxIg-1; Wed,
 16 Jul 2025 14:48:36 -0400
X-MC-Unique: XaQCDUB5OiCdYJ-tyShxIg-1
X-Mimecast-MFC-AGG-ID: XaQCDUB5OiCdYJ-tyShxIg_1752691715
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C9B319560B2;
	Wed, 16 Jul 2025 18:48:35 +0000 (UTC)
Received: from emilne-na.westford.csb (unknown [10.22.88.244])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 33CD418002AF;
	Wed, 16 Jul 2025 18:48:33 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com
Subject: [PATCH 0/5] Retry READ CAPACITY(10)/(16) with good status but no data
Date: Wed, 16 Jul 2025 14:48:28 -0400
Message-ID: <20250716184833.67055-1-emilne@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

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
("block: remove CONFIG_LBDAF").

The final patch to scsi_debug is allow insertion of the fault to test this change.

Ewan D. Milne (4):
  scsi: sd: Avoid passing potentially uninitialized "sense_valid" to
    read_capacity_error()
  scsi: sd: Remove checks for -EOVERFLOW in sd_read_capacity()
  scsi: sd: Check for and retry in case of READ_CAPCITY(10)/(16)
    returning no data
  scsi: scsi_debug: Add option to suppress returned data but return good
    status

Mike Christie (1):
  scsi: sd: Have scsi-ml retry read_capacity_16 errors

 drivers/scsi/scsi_debug.c |  38 ++++++---
 drivers/scsi/sd.c         | 173 +++++++++++++++++++++++++++-----------
 2 files changed, 151 insertions(+), 60 deletions(-)

-- 
2.47.1

