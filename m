Received: from fgw21-4.mail.saunalahti.fi (fgw21-4.mail.saunalahti.fi [62.142.5.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6131EF0A0
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jan 2025 19:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737402658; cv=none; b=Su79ECzC7lteGBSgEIo5VylD159909VdgRR8S9L2T9oAspxpDqLYj4YLx+JaP2sWOjlewlbqjpOXcpS6tgy23u8Q25sW48Kea1BNzI2dna4TG+ur9Qn7kGdxH0ok1NEU+Pk/9lrr3Z16RU3BcWasBgD2JaTl8p8jJQZHo6Y07Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737402658; c=relaxed/simple;
	bh=cyGs/2ZcCERbAyyR7oSkTZY05qjRIdS5EWOt3BtJseE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=n+aKoCaEaRuiiA5Ycrf64zTohKl6Fdm3zVQDYOi7cC1jVxIVHEbGINq6J65iD/u92S7mmHaSkPDoL/k47NoN+nvVEcgGZwnYyKYninHoSHOzc35dZjubPBXDNS/nh2i6ocVuQ5Rjq3GQqCOwJEIpG7tGz8OFPRif1XA5/5L/EVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=etHnLMVG; arc=none smtp.client-ip=62.142.5.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="etHnLMVG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:message-id:date:subject:
	 cc:to:from:from:to:cc:reply-to:subject:date:in-reply-to:references:
	 list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=/2oQiI3PqkzRcSqq/5WDC3iBXLmmRAdiva9R8EGQEHM=;
	b=etHnLMVG7NVlUOuoONzZVKoaZ7g0MiDa6R65yxDth5YFRM4QQiFyMb613PFia6MUQiuLZ3sQucrMq
	 yLBQjYneF/JTDAOu1BwvaYOhFrZsLKhzyfrIK2rkHWWkJTY0hchXKNLK9NRoUACnJFNBgdCPFVj/zV
	 a23CDuq46GPJB8CVPNx7HwbsPYInmnVZjutLrv+DqNNL5w1xJ5tDdBvT/dXnLDaXI7sgAEqlhE3U9l
	 NMHUKRPfz322II2NKOAHl+eMDaXlyHQQGg7/ONoek286kw1ky5RsOSlbXVoR/ia2fcKQz9Vj8XzcjF
	 sfkHAlQVeaC7FRe1DLzQF0G5oWfcDmg==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw21.mail.saunalahti.fi (Halon) with ESMTPSA
	id b2692a85-d767-11ef-88a3-005056bdd08f;
	Mon, 20 Jan 2025 21:49:45 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	loberman@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH v3 0/4] scsi: st: scsi_error: More reset patches
Date: Mon, 20 Jan 2025 21:49:21 +0200
Message-ID: <20250120194925.44432-1-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The first patch re-applies after device reset some settings changed
by the user (partition, density, block size).

The second and third patch address the case where more than one ULD
access the same device. The Unit Attention (UA) sense data is sent only
to one ULD and the others miss it. The st driver needs to find out
if device reset or media change has happened.

The second patch adds counters for New Media and Power On/Reset (POR)
Unit Attentions to the scsi_device struct. The third one changes st
so that these are used: if the value in the scsi_device struct does
not match the one stored locally, the corresponding UA has happened.
Use of the was_reset flag has been removed.

The fourth patch adds a file to sysfs to tell the user if reads/writes
to a tape are blocked following a device reset.
---
Changes since V2:
- applies to 6.13 + patch "scsi: st: Regression fix: Don't set
  pos_unknown just after device recognition"
- the UA counters changed to u16 (suggested by Bart van Assche)
- the macros to use the counters moved from patch 2 to patch 3
  (suggested by Bart Van Assche)
- remove clearing was_reset in patch 3 and not in patch 1

Changes since V1:
- replace the patch removing was_reset handling with patches two and three
- add sysfs file reset_blocked

Kai Mäkisara (4):
  scsi: st: Restore some drive settings after reset
  scsi: scsi_error: Add counters for New Media and Power On/Reset UNIT
    ATTENTIONs
  scsi: st: scsi_device: Modify st.c to use the new scsi_error counters
  scsi: st: Add sysfs file reset_blocked

 Documentation/scsi/st.rst  |  5 +++
 drivers/scsi/scsi_error.c  | 12 +++++++
 drivers/scsi/st.c          | 73 +++++++++++++++++++++++++++++++++-----
 drivers/scsi/st.h          |  6 ++++
 include/scsi/scsi_device.h |  9 +++++
 5 files changed, 97 insertions(+), 8 deletions(-)

-- 
2.43.0

