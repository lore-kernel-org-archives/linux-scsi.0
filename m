Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEB93FB32
	for <linux-scsi@vger.kernel.org>; Sat,  2 Mar 2024 20:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709410610; cv=none; b=ofjAGGCkufIq7PwP4kcxNkc/bJDU8Y9Dphy2FGNX8s5vYdMJ/oSpgHzyOD809lFL+cLOcm1xMlEkJfOd/5Fbife57kgmQk2CghDlRDxuH3TFOSx4rNHzYdLgBcvZfuiUuPUbMHMpmH/lk+gx+8IYFaPSoy/6zFX3HitfcyXuwi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709410610; c=relaxed/simple;
	bh=Cpedd2s8rLSpGhGQydXGS4Dwk+kTKGMFmoIMXPvIswg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=LLfweUa3lFo6kUVxA7LwdF6y2Iife/tCARofNbee4mENH9Xi/7Q5c1ReRqjfk4zsdHHZrfiZUCnH8lVYSa4qAF/dn9P1Z9Rk9RRcdkeSj/UYt+bFbOn7pcXrudME2UVp7ZbpOWwovqkj41+Xm3RzossmEk17HCc1bUUG51/AHwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WUu9s4GF; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WUu9s4GF"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbf216080f5so5442946276.1
        for <linux-scsi@vger.kernel.org>; Sat, 02 Mar 2024 12:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709410608; x=1710015408; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OfPnrRH4J5h8MVX8iNqJy9fStZJwj24UZx9cr338G4Q=;
        b=WUu9s4GFltsOelAdBH8YSGUoOIaKcQbD0GHXxHox+n59nvjH2H+4fVcJifvwFJ+iAD
         NkO58rN2G0I3QrsrOy5I/Mjamng2HT3WaCuaDqmhN0qK+6guA5VJOnk8Ao1xbvx0vbUp
         e2b/AqqcVz614WuEAlwFimgtNkpxfikwQJzWSmKlmzqVxaGZKJwW9RAK2w+FiLGz1keu
         BUdHCDJSX6Ue7323A9kmshlYKCUGSFSknz0hDPZfIQd7bngM4w8GRPKJ8CnRuhdUcKl4
         mb0BH5Z6IkHFmOyKVtVcqyBbKHRs4YfE0/YfRPqoO/JYmpwAle3XK8co4cylIHodZhMd
         Yulg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709410608; x=1710015408;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OfPnrRH4J5h8MVX8iNqJy9fStZJwj24UZx9cr338G4Q=;
        b=GJBgVsnoQiHfsVG8csNsPl47QTcC//B9oQfe2g92pDmO5Imwu0PZlOQCrPaLk02Iv9
         I3AHgOs7oN9+pdMo5fFDH5nc8jegfH5V+Og7pU6AM3n1Gi/0qJhgA1ttWWdSXpDY/fqT
         6P3b+hJvRq8RxS270Gr5BfmOfu8NKTizScqnG6gMwuTcZnTfqq18rebg6tSJu55c7MC1
         HmxIlOU7cXRcWicBcpnzEy52BviIP46NGUVdULha1RqhqheBoxWTY2jqH5BVDKr5YZuk
         66Uf57LPN2x+b8sXurwbCEcesknazIKkXnP94EtYM1mGCnO3NcqtyPNO9Cj6wmqX+iA8
         0YjQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2hYnTM0pkRZkgD/DVhok7CuiBqV9dWpARtqr2ANtsqlfFG/jlYsIUaWsb13cVVbr+mXDXxHSbVTA9kiB5xNDHYw3OVGcDMLGeOA==
X-Gm-Message-State: AOJu0Yx8quiIVQd1nK0J6YdWtefU9ZaVG5d09u5gXhcxiVW+CSkT9WyL
	Hdz16aI88yVl92o+qgY+uxzaBFGEEWhDm/s/NGdxqELB0IxuBHL2OHHbUzc415RXuIOnpRDJxO4
	GsphwAdQ1og==
X-Google-Smtp-Source: AGHT+IGeLsYYp+Bum4xDMw/O8ruLOFlHADU5bUPlL5Nmn8st1+tdzAV7qyUd0P4vKWtUFERohg1oCpXtFg/JvQ==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:41a7:9019:9a7:b404])
 (user=ipylypiv job=sendgmr) by 2002:a05:6902:1101:b0:dc6:c2e4:5126 with SMTP
 id o1-20020a056902110100b00dc6c2e45126mr1316939ybu.12.1709410608300; Sat, 02
 Mar 2024 12:16:48 -0800 (PST)
Date: Sat,  2 Mar 2024 12:16:29 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240302201636.1228331-1-ipylypiv@google.com>
Subject: [PATCH v3 0/7] NCQ Priority sysfs sttributes for libsas
From: Igor Pylypiv <ipylypiv@google.com>
To: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
	John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Jack Wang <jinpu.wang@cloud.ionos.com>, Hannes Reinecke <hare@suse.de>, 
	Xiang Chen <chenxiang66@hisilicon.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, 
	Bart Van Assche <bvanassche@acm.org>
Cc: TJ Adams <tadamsjr@google.com>, linux-ide@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch series adds sas_ncq_prio_supported and sas_ncq_prio_enable
sysfs sttributes for libsas managed SATA devices. Existing libata sysfs
attributes cannot be used directly because the ata_port location is
different for libsas.

Changes since v2:
- Added libsas SATA sysfs attributes to aic94xx and isci.

Changes since v1:
- Dropped the "sas_" prefix to align sysfs sttributes naming with AHCI.
- Dropped ternary operators to make the code more readable.
- Corrected the formatting %u -> %d in sysfs_emit().
- Changed kstrtol() to kstrtobool() in [ata|sas]_ncq_prio_enable_store().
- Changed comments to use the "/* */" style instead of "//".
- Added libsas SATA sysfs attributes to mvsas and hisi_sas.
- Dropped the 'Reviewed-by' tags because they were not sent in-reply
  to the patch emails.

Igor Pylypiv (7):
  ata: libata-sata: Factor out NCQ Priority configuration helpers
  scsi: libsas: Define NCQ Priority sysfs attributes for SATA devices
  scsi: pm80xx: Add libsas SATA sysfs attributes group
  scsi: mvsas: Add libsas SATA sysfs attributes group
  scsi: hisi_sas: Add libsas SATA sysfs attributes group
  scsi: aic94xx: Add libsas SATA sysfs attributes group
  scsi: isci: Add libsas SATA sysfs attributes group

 drivers/ata/libata-sata.c              | 139 ++++++++++++++++++-------
 drivers/scsi/aic94xx/aic94xx_init.c    |   8 ++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |   6 ++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |   6 ++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |   6 ++
 drivers/scsi/isci/init.c               |   6 ++
 drivers/scsi/libsas/sas_ata.c          |  92 ++++++++++++++++
 drivers/scsi/mvsas/mv_init.c           |   7 ++
 drivers/scsi/pm8001/pm8001_ctl.c       |   5 +
 drivers/scsi/pm8001/pm8001_init.c      |   1 +
 drivers/scsi/pm8001/pm8001_sas.h       |   1 +
 include/linux/libata.h                 |   4 +
 include/scsi/sas_ata.h                 |   6 ++
 13 files changed, 247 insertions(+), 40 deletions(-)

-- 
2.44.0.278.ge034bb2e1d-goog

