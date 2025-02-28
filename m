Received: from fgw20-4.mail.saunalahti.fi (fgw20-4.mail.saunalahti.fi [62.142.5.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58FB4C79
	for <linux-scsi@vger.kernel.org>; Fri, 28 Feb 2025 12:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740746811; cv=none; b=e3jGjb8jXFFcS7WAH/3b3q3c2eKIpndOb5Sa8yljC5/ed7fz/NE1ZwNaZg1Sy8+9J5UHwsPAevva6x62f10JX6BqHiHDq3m+8jHtao72MoQwm654d6WMqRmiyRsgGNxK79gou1plh1wZ7HjZwn8M61ZnD7aUpbxJJ7YQidregvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740746811; c=relaxed/simple;
	bh=a845YfJ39bOuKl4deN7tFGJ4Zer/8Dh2wiyMxv2jdR0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VJzWFFa+JbLfx3zhBbtphHiLHeBO9koJ1X3P7n9+VuDaelkZ1dxD+uUHO+DjQ9+ygjL3zUbaejNah2u0u5O8kujdoSLHvn1829sa38BDqCHUxpdASv4T8xU40mb+L6dMKtgBosm36qaqwooyrzN8RNNDAqnljmo/EyjVd+I/cS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=w5KTY1Hj; arc=none smtp.client-ip=62.142.5.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="w5KTY1Hj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:message-id:date:subject:
	 cc:to:from:from:to:cc:reply-to:subject:date:in-reply-to:references:
	 list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=QV/j6JYikyUIfYNrSDPeCXYNXEQqIwLdPq6BpFlwhLM=;
	b=w5KTY1HjpQus6ObzY/vZngmN5PA2V2R+U+LSDFUbWrc2DdIM0M2DQQkEZ4SNNe1vwlqf1PdsbQsg4
	 hwobyMu2DJZk578g1b+2LqBQrjC6VSC0yxUS+91tdJw4b8iTZYVwTkLOc9GFTND++TRkIPZZhY4p3o
	 92N/aW/abqK15qGNLlB0jOrXIjZveOBL6dHXhPN8BR9RYJ/tD/w1jPrtQU5J5qQNqbBPQkNgkl9kID
	 lapEZlg3ze5nGSs0iK9N08aN4Shaou/v9WL+FyS2AFLM5lj8s9HaloqwUuV0hSuttremvLlnvikmjE
	 gSs3ayiDMtSja3qsTo9GG085E0t8hBA==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw23.mail.saunalahti.fi (Halon) with ESMTPSA
	id 0bfb94af-f5d2-11ef-a2a5-005056bdfda7;
	Fri, 28 Feb 2025 14:46:38 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	dgilbert@interlog.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH 0/4] scsi: scsi_debug: Changes to improve support for device types
Date: Fri, 28 Feb 2025 14:46:22 +0200
Message-ID: <20250228124627.177873-1-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The patch set includes changes to better support different device types.

The first patch fixes two obvious typos in the existing definitions.

The second patch adds a device type mask to the command definitions (struct
opcode_info_t). This makes possible for different command definitions for
different device types and makes easy to add opcodes specific to certain
device types. The mask is 32 bits wide and the bit positions are derived
from the Peripheral Device Type field returned from INQUIRY and used in
the struct scsi_device.

In addition to the mask, the second patch adds command filtering based on
device type to command queuing and building of the response in Report
Supported Opcodes.

The third patch splits definitions of READ(6), WRITE(6) and PRE-FETCH/READ
POSITION to versions for tapes and for other devices.

The fourth patch changes obtaining device type from sdebug_ptype to
struct scsi_device->type whenever it is set correctly. This improves
support for using different device types in the same debug host.

The patch set applies to 6.15/scsi-staging

Kai Mäkisara (4):
  scsi: scsi_debug: Fix two typos in command definitions
  scsi: scsi_debug: Enable different command definitions for different
    device types
  scsi: scsi_debug: Move some tape-specific commands to separate
    definitions
  scsi: scsi_debug: Use scsi_device->type instead os sdebug_ptype where
    possible

 drivers/scsi/scsi_debug.c | 338 +++++++++++++++++++++-----------------
 1 file changed, 186 insertions(+), 152 deletions(-)

-- 
2.43.0

