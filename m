Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4818B12DDAE
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 23:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709683112; cv=none; b=S01S5HTPTXnrEcqUXoCeZzztRblQBJCHq4XVaErhW5ii2kJ3ca2RjWT4MMKAPLmwku5vr+P+OUHPChj8dUnLSBH/h5q5r4oszUsLrRH/0ouJDkcTzKAVQUNaOLHD/v759YHoi4eJNGnfOzFMfsKCvwY4MoV1a5yWvIt9v1YgkBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709683112; c=relaxed/simple;
	bh=HNBr2lVWfOniLa07F4xju15S6im6pmjpzbjfSiuiLxM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=GP6Iz4O0tr6FqXzjZx/2Gh1m0DJw3hvseuMqmm+rpKArJvhv8ooBZfFM2jjcdOAh+Gvw6I32u9zMCV/ovMyasZj2875Hn0ZzlK8Dd/tslbfSD/z5ocg8YRILF+l8WgsG5U+oFCH4bSMZASg9YuvaFTT+q7jMnfzdiv5Dq3vURjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vbfEIaU/; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vbfEIaU/"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b26ce0bbso2494975276.1
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2024 15:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709683109; x=1710287909; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vaoaHDy7a7OkGzMHEan2gyrn0Ck8RYkLN+1+72FVuoU=;
        b=vbfEIaU/GQVAHdBKN6UNsstKLgAolKfhI1NvRbgMEtcj7OFZsWtkihd+Jl4LnN4gUV
         rqhRB983jTvb1NF5yoFQwPjDsduIQmK1DS7qSVcudTwHhM/RM7FYFf4guiR5KnUD/23N
         shw7xQ8ilmUYdshaZCNJllwF5iTkZ3FKohWFjmqkNxPS+fdFkHZwkEs4EwMs39QSd/tp
         Q+dWbaZz/bnt6aJO4eEpEOt9LTY/m7P7ns+hfMoKO5PURXq7mVPQ9zCP/Olv93b1A+IX
         52WwZ6tv5XNqo5UegW5kWLqWHMy+f8oKeaOe6cRQO7oDwKUqGvZjsUJE/yn32T7y+L7S
         A+Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709683109; x=1710287909;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vaoaHDy7a7OkGzMHEan2gyrn0Ck8RYkLN+1+72FVuoU=;
        b=uEQsmdIxjdUmCVMSkPLXnG1GWK3FSZQPWwr6uCoS4WSe+yT2gBZCd7SFNgTK09rmxz
         aUQYHEEDK0/jgX/Jc7TGjz7gZCXQN8AERFf50SJMhMUSL2sQVz7saPrLX79ncii9v3Ja
         Pq/g7YHH4h+/xi/QzMO4xiMgMIXEjPJxUWgBc0EQCIdfroL4t0dOvjZ4O8qT2mkNH+qv
         oEGoQl8/grglwBjeaAPxEV/Sp1lxKKFtphA49BhMPay/cS7mksgLtB3/0YCDjNodbpKl
         J1vhbnXDIEsLDrZeyW9hVejZgL4osdtYaX0S9f+3a/gKDg7WH+Q2SZisMx15+sKjj833
         LmhA==
X-Forwarded-Encrypted: i=1; AJvYcCXYl81d2jDSxQElTuiYZdYlWh33Z8dN6ge42N5MmlamNEaFJhWVLHbEs8lHKSad3LfiSQlFQ+yU4JcIlbte500ageHzhA4kXLU7Mg==
X-Gm-Message-State: AOJu0Yx6plDBzviaOTRV0hrhotejylrP/nZdvunyZQBmXZ3cAWCenuVt
	MtSC7kUzIhXxSn9XQ0cQxcC695+uWHhDyE29mzVK4ly2X5+fG0C+ago5grDsxRmMXCZLKGBz4Vi
	ibKXAlK1HEA==
X-Google-Smtp-Source: AGHT+IHaAsBNeJX0yVFcy8Chbu5Ij7ZTQ0MYkEN1yB3LYTalIENqKOsqZZ1eDTmSOj0JdndxnR9QGkJRb8Db7Q==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:69ff:df2c:aa81:7b74])
 (user=ipylypiv job=sendgmr) by 2002:a05:6902:120a:b0:dc6:dfd9:d431 with SMTP
 id s10-20020a056902120a00b00dc6dfd9d431mr3677876ybu.1.1709683109302; Tue, 05
 Mar 2024 15:58:29 -0800 (PST)
Date: Tue,  5 Mar 2024 15:58:15 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240305235823.3308225-1-ipylypiv@google.com>
Subject: [PATCH v6 0/7] NCQ Priority sysfs sttributes for libsas
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

Changes since v5:
- Added __maybe_unused attribute to sas_ata_sdev_attr_group to prevent
  an unused-const-variable warning when CONFIG_SCSI_SAS_ATA is not set.

Changes since v4:
- Updated sas_ncq_prio_* sysfs functions to use WARN_ON_ONCE() instead
  of WARN_ON().

Changes since v3:
- Changed ata_ncq_prio_supported() and ata_ncq_prio_enabled() to store
  the result into a boolean variable passed by address.
- Removed the "usable with both libsas and libata" wording from
  ata_ncq_prio_* helper's function comments.
- Removed the unlikely() in ata_ncq_prio_enable() because the function
  is not in a fastpath.
- Dropped hisi_sas v1 HW driver changes because it doesn't support SATA.

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

 drivers/ata/libata-sata.c              | 140 ++++++++++++++++++-------
 drivers/scsi/aic94xx/aic94xx_init.c    |   8 ++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |   6 ++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |   6 ++
 drivers/scsi/isci/init.c               |   6 ++
 drivers/scsi/libsas/sas_ata.c          |  94 +++++++++++++++++
 drivers/scsi/mvsas/mv_init.c           |   7 ++
 drivers/scsi/pm8001/pm8001_ctl.c       |   5 +
 drivers/scsi/pm8001/pm8001_init.c      |   1 +
 drivers/scsi/pm8001/pm8001_sas.h       |   1 +
 include/linux/libata.h                 |   6 ++
 include/scsi/sas_ata.h                 |   6 ++
 12 files changed, 247 insertions(+), 39 deletions(-)

-- 
2.44.0.278.ge034bb2e1d-goog

