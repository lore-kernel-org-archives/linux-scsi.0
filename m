Received: from fgw23-4.mail.saunalahti.fi (fgw23-4.mail.saunalahti.fi [62.142.5.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC61112EBEA
	for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 16:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731687637; cv=none; b=TNWyLjuclcqqJFNEEPSX4qTfdDpbzp9BpbFJAeIi47KnCXMs1CIqTfE0ptFF77qxijWuOttrm3S58X754wVVs9Geu3fO5rp7rBA2V32J4HaU6h9M1eenTITN064UsLIDu2R+fGOLxHmU46BYd1AiJqzS48u6KpE7M/kbH4H9FLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731687637; c=relaxed/simple;
	bh=HXr2iHYsWW4UD9CsgAKoT479Gns0ATsrD2RKEsEfF+A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hMqdsy6u1P/q3CTzTTMwFsXbRQOACHdCQ35SR0T7z67pkDTR2c6tbQmULVEnyxTdmcvyoAMC/y2jnlep9tNeu40qYh6UT2Xpufl9gx7lDCyFu0Hd8bJVsVz4XprgAs4HWh1sWjgDioJsrFRF2PmhmxKriBYRJ4AeOT1Vy9ptzcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=co5PGIXG; arc=none smtp.client-ip=62.142.5.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="co5PGIXG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:message-id:date:subject:
	 cc:to:from:from:to:cc:reply-to:subject:date:in-reply-to:references:
	 list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=pS0rNjULCy1vEKGYAO0akJwmy3OVK7njoJTIF7n16FQ=;
	b=co5PGIXGXxo83C1FiYaG74H/xzeFWkuq89vfKHAyexlqHw/+S+uD3VGgXVSZIxK1MKQ23IaRUSGcG
	 1DJXEs/rCGs/S4T3/DQSz+RmwuT/OriUiob5GdZDDMA/tKJ59MeY4CCwv5WqKTy4DhGTy1Vo/BHQBZ
	 8PLBBFgc/v4df9DrRVpK9xepDy2ksfggwt+8ektK04kThAQ3DF+7gbmryrIeUXAqQ6wYEPv/yAv6n8
	 Z+ZWewSjQvqORN8OXL7PHgu2pnRevT2sQUNUmZ6xGrFz1NMbJjon0OEmBrAzjJRqPsJ0/4nT0FWJFh
	 1GxMZukJ5T25TA0Zebcev8NpQr9V8CA==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw20.mail.saunalahti.fi (Halon) with ESMTPSA
	id 87c54540-a36d-11ef-9b34-005056bd6ce9;
	Fri, 15 Nov 2024 18:20:30 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	loberman@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH 0/2] scsi: st: More reset patches
Date: Fri, 15 Nov 2024 18:20:01 +0200
Message-ID: <20241115162003.3908-1-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Use of the flag device->was_reset set by error handling is not necessary
any more. It is enough to use the UNIT ATTENTION sense data to recognize
that the device has been reset. The first patch removes the code using
was_reset.

Device reset sets drive paraneters to default values. If the parameters
have been changed by the driver, they must be restored after reset. The
second patch does this for those MTIOCTOP operations that re-position
the tape in the drive. The parameters are not reset for those operations
that start a new tape session (e.g., MTLOAD).

The patches apply over 6.12.0-rcx + the three reset patches sent on
November 6.

Kai Mäkisara (2):
  Remove use of device->was_reset
  Restore some drive settings after reset

 drivers/scsi/st.c | 35 +++++++++++++++++++++++++++--------
 drivers/scsi/st.h |  2 ++
 2 files changed, 29 insertions(+), 8 deletions(-)

-- 
2.43.0

