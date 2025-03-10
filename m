Received: from fgw23-4.mail.saunalahti.fi (fgw23-4.mail.saunalahti.fi [62.142.5.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4387B22A4F6
	for <linux-scsi@vger.kernel.org>; Mon, 10 Mar 2025 15:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741622243; cv=none; b=J1uvHVSRYeTMmz6gv1QHczy0PcvhfJygnRlB2GMtdnsWeYj/m3Rq/tP5Kaxd2SFUG07ToQpq2gmrXqQo4r1oWEwdDGCDWTSVgY9Kb+xCnxEGY88d5fKdtCJ8b0/K71GgUG4u8ETWLbeKDFvhHBmPwMWNgWFjvoYkqV7wJsFA3Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741622243; c=relaxed/simple;
	bh=NVLGZeTYDQdv96YTacJQOF6tnwTCdS4h1xuYjAhuydo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RLWwG9tYHxA+XM3cDmf51ncSXuEMgdiwK3xW4pnPiB4ActkwoBxiqkKPoZoutclDp3y7rhXvMGduNAfUrwMf8uMDSLMPUijy6Ck+/RfW7k9+oc1DW7VNw5tO/C7vG5zXrGmiDi2tQ8H3Wyqa9Cyw7beiEuUKNsqz1AhfwK0TQOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=LUe8+FEw; arc=none smtp.client-ip=62.142.5.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="LUe8+FEw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:message-id:date:subject:
	 cc:to:from:from:to:cc:reply-to:subject:date:in-reply-to:references:
	 list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=UKigfTM+gaQ/Qw7tm/GBMcnMSnpJAjB4qFB5+bnhHZ0=;
	b=LUe8+FEw9pbH+JoYHngMgxjy/OvsGCmsmOslMKmXo+IyGT1NjT/pYuGwVOfDn/DqqLoGxgWO63PZK
	 1KCW8AaojNVLqSAUwyq6FOcyQBCuaxzhL32XozwaSW2O4fZGn2COL8N1cWh5nf++6ge0q3h2+p7pVI
	 WWpEa3+MJujHNemGVPoIzQ3VUasiSVvPsJzlN2WLsfmnfE6DkHxQLnBxYnDEUwc2SdfyHojmKB6eaK
	 LLS2L0ruJFbi5co7HHX9brnq+GdiMaHyHP6GHNKGH0ooeNkh7waOyYLY6OLANQaMkSSomGHv0wJ/6k
	 iuQDz6/ZFlt0awS/y9vdir1TAxP8ljQ==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw21.mail.saunalahti.fi (Halon) with ESMTPSA
	id 2ca48ff6-fdc8-11ef-839f-005056bdd08f;
	Mon, 10 Mar 2025 17:56:06 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	dgilbert@interlog.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH v2 0/5] scsi: scsi_debug: Changes to improve support for device types
Date: Mon, 10 Mar 2025 17:55:52 +0200
Message-ID: <20250310155557.2872-1-Kai.Makisara@kolumbus.fi>
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

v2:
- fixed devsel type in Patch 2, problem reported by the Kernel Test Robot
- added patch 5: Add ERASE for tapes

Kai Mäkisara (5):
  scsi: scsi_debug: Fix two typos in command definitions
  scsi: scsi_debug: Enable different command definitions for different
    device types
  scsi: scsi_debug: Move some tape-specific commands to separate
    definitions
  scsi: scsi_debug: Use scsi_device->type instead os sdebug_ptype where
    possible
  scsi_scsi_debug: Add ERASE for tapes

 drivers/scsi/scsi_debug.c | 359 ++++++++++++++++++++++----------------
 1 file changed, 205 insertions(+), 154 deletions(-)

-- 
2.43.0

