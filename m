Received: from fgw22-4.mail.saunalahti.fi (fgw22-4.mail.saunalahti.fi [62.142.5.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B104E1AE850
	for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2024 14:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.109
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732543400; cv=none; b=LaLn+ytSdAAU3/MjaqUMny2SnZRBhdQOHTJDVxos3x00c1GJ4PX0s8cI27seqb8PfO/ocK7JQvoaY8k+3UpkvOxmtUmSymQvH50Hkm9k6EPYauYrw/COJZGpGXwyZT8cyzZ0mALbr9tflb0w3MVEqDT8YDia7sTTfuR8bwURu7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732543400; c=relaxed/simple;
	bh=U7Y26hb6ecxYkE3GeZrQ318guBsx3IZ9bsUhqcOzDko=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BNehHmKDCOTG0CkoWqCJmQe9UNweezgRrs3gqyYJ5pVmguG/Rmsq+5aQaDBkRYlvZu53MxJoyDPYvvdIP1s+PAaTGb6H9qIVaNoMpG/ULIe759h3qwV7ANuRKStGTzLHH0XPV4KaYTKQdK3zW9O+hj/gb3OCbYhuRTZrp6b4w+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=DKajw8a0; arc=none smtp.client-ip=62.142.5.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="DKajw8a0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:message-id:date:subject:
	 cc:to:from:from:to:cc:reply-to:subject:date:in-reply-to:references:
	 list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=kuUvlER2IgUnIiOI1N6ppl+nybzXaOBY8NAdl/VeljM=;
	b=DKajw8a00Uw/zVz+WQn3mlD4rKIQ99drSsS+tR8UD7IxKJdOzEGmOCzpmPn+J8+Kc+iZ5ECWK+r4x
	 erB1f1ryKmKTKQbaYERNctKy7a5Y7foG8jeXFzcoTf415fQfiiKomNWb/43S3k5Z5VCnPH4Vd33qMX
	 JiDSQdbNxa3RqXWr/LK7e61ZcS1ECC1IIJOX4TwpR0CJM8rR9leRNZuP++KTBrBGBHKvxMq4wnrY1X
	 5O797Sf79GV0FMbEwuhyr9ND+KQ6jGUEIUaFNMOXZNxXZMpcfE1xxbH8udZ+s6M8xF9h6ttF1T/dC2
	 hhD9rJgWkQpU2VQjVK1l7zp6P/yASeQ==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw21.mail.saunalahti.fi (Halon) with ESMTPSA
	id fe9c35bb-ab35-11ef-8882-005056bdd08f;
	Mon, 25 Nov 2024 16:03:07 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	loberman@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH v2 0/4] scsi: st: scsi_error: More reset patches
Date: Mon, 25 Nov 2024 16:02:57 +0200
Message-ID: <20241125140301.3912-1-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This set applies to 6.12 + the three patches accepted earlier (and in
linux-next).

The first patch re-applies after device reset some settings changed
by the user (partition, density, block size). This is the same as in v1.

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
to a tape have been blocked following a device reset.
---
Changes since V1:
- replace the patch removing was_reset handling with patches two and three
- add sysfs file reset_blocked

Kai Mäkisara (4):
  scsi: st: Restore some drive settings after reset
  scsi: scsi_error: Add counters for New Media and Power On/Reset UNIT
    ATTENTIONs
  scsi: st: Modify st.c to use the new scsi_error counters
  scsi: st: Add sysfs file reset_blocked

 Documentation/scsi/st.rst  |  5 +++
 drivers/scsi/scsi_error.c  | 12 +++++++
 drivers/scsi/st.c          | 73 +++++++++++++++++++++++++++++++++-----
 drivers/scsi/st.h          |  6 ++++
 include/scsi/scsi_device.h |  9 +++++
 5 files changed, 97 insertions(+), 8 deletions(-)

-- 
2.43.0

