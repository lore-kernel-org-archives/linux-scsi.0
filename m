Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA30310E5
	for <linux-scsi@vger.kernel.org>; Sat,  2 Mar 2024 00:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709338616; cv=none; b=X79JVkNeS2LO38JaAp3z383ZiFA5rALbpmI+pOwlivCxktBYBBBa5/2X2GrmPxM36HnREpPAcBvH6VH6PzatC9cPxxDpx2EjvJSiZ4Hd2wCSVvWxS19rGpiVolglOxTmOlArxK/7abYhCu9xYj1je4J9yEDOtIiSf9SVni/VJeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709338616; c=relaxed/simple;
	bh=pgSiW+xTZmFhlX83o7Jy94TLdmZvLPZgS0gnfRjbOfE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=jl8SuPjPxLLXA9muT093AgbELlvSyvi2lwipabKNNYoSveYkQg6vNBUT4y0DTP3yfwumKDpyFrpon7VF6lJh5BEdtCuFr4hebYmnkc/w9BByY4P3/7o9kcivMF1EbsfyYOSyE8ARgdbW/N0lqyE9blCvh5v9hpnJzDwKaZfbupk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Uc0F4Ca6; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Uc0F4Ca6"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6098e22cb86so7228447b3.3
        for <linux-scsi@vger.kernel.org>; Fri, 01 Mar 2024 16:16:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709338614; x=1709943414; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XJVqfGzfplRxpO5E0p6+cO7VAdJkT8FDhuCSfsmbM5I=;
        b=Uc0F4Ca6r8FXVZSUSeciJODpxecUFJ/UH7kkvl3HBmmg/tnNFI76oedrrciyfRf6Y1
         E1jOXF4ihLc1zmwvOgWN3Kl0aOyJ0azxqpHreaSEc0Kj3upVwVp/bNvz/RZbgnC395Ij
         rDPZbS8QSTFTYfvOb0Oww8lruD1oaiyIeaJFTbosCz0/MNWm4qlH0ug/svU9uYhijzzg
         d8pugB0guCjYycedqAJ4bDhh8DzbBrJq0EkbDjnfKc/oFjFQNAjZwpz6NHfLbnOEY7EY
         c02pkEpj/IaNrWg2F4jabQYmXd1XzgD11FSLo/qjcUh3ZB+i2nWmIfqVtMpnPUeWLI9z
         JXhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709338614; x=1709943414;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XJVqfGzfplRxpO5E0p6+cO7VAdJkT8FDhuCSfsmbM5I=;
        b=K3U4B+jjAMGuTnzyn1NsU8hAc2aa2AIGzCNaSx4nKsF8itww3WU0T5bG/JkzvuveiO
         ThgircWRG1l3x90w5Xg3yXRI2bw0v3jlRYu/dTGY9BTX58mLIsUuj1JrCI19MA3vIToQ
         aFbVw1tM7bNiXhcLrBscaDiY8imYk3MUeONAR5cqXtAaJ3VCPgRZiylhZXvwXWhaX3vC
         P7VULEQYR35mK92cw+V5a9JXLzHannnlkmveSFZtgyRj60LLv3xr5ur2z3VW76YX7pU+
         VFFWUgx320fn9Trqcl7J+hWHVQJ6jhKCCPd6GAAyhJ24Hhbg4dYlDOLJPJ++87l1YEO/
         C5tQ==
X-Forwarded-Encrypted: i=1; AJvYcCUAjOkQzp2xi8c0BLrWYUCeSBFKB60NmM/Ca+L2B+v5di462I2ZsMXnwfykrNoIimvdBje8AuNk2i5C3Bg4tHFwhFESiNiJ/W42XA==
X-Gm-Message-State: AOJu0YyXIFeY0Z4JChQlIR0+k7M3aMg7c3UtOoFikRwHJJXHs1Tx8I6P
	B5if8P+VPKIBLfxfRK9UTR4aT0gZg40QZ4uAz3oBTWF+2h8qbslaJI4Dxiw3dPh4g8U5eb2yfRP
	qIqpzR6y0JA==
X-Google-Smtp-Source: AGHT+IF8MBkXR+4X6PdgrM7IJa8RzUArE+pN73OYsy0OYujkB856aRXm5tQ58UhSH5oUu5ad9tsySL5EyAhqGQ==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:2afe:1a8e:f846:999f])
 (user=ipylypiv job=sendgmr) by 2002:a05:6902:1209:b0:dc6:e20f:80cb with SMTP
 id s9-20020a056902120900b00dc6e20f80cbmr115663ybu.3.1709338613902; Fri, 01
 Mar 2024 16:16:53 -0800 (PST)
Date: Fri,  1 Mar 2024 16:15:57 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240302001603.1012084-1-ipylypiv@google.com>
Subject: [PATCH v2 0/5] NCQ Priority sysfs sttributes for libsas
From: Igor Pylypiv <ipylypiv@google.com>
To: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
	John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Jack Wang <jinpu.wang@cloud.ionos.com>, Hannes Reinecke <hare@suse.de>
Cc: TJ Adams <tadamsjr@google.com>, linux-ide@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch series adds sas_ncq_prio_supported and sas_ncq_prio_enable
sysfs sttributes for libsas managed SATA devices. Existing libata sysfs
attributes cannot be used directly because the ata_port location is
different for libsas.

Changes since v1:
- Dropped the "sas_" prefix to align sysfs sttributes naming with AHCI.
- Dropped ternary operators to make the code more readable.
- Corrected the formatting %u -> %d in sysfs_emit().
- Changed kstrtol() to kstrtobool() in [ata|sas]_ncq_prio_enable_store().
- Changed comments to use the "/* */" style instead of "//".
- Added libsas SATA sysfs attributes to mvsas and hisi_sas.
- Dropped the 'Reviewed-by' tags because they were not sent in-reply
  to the patch emails.

Igor Pylypiv (5):
  ata: libata-sata: Factor out NCQ Priority configuration helpers
  scsi: libsas: Define NCQ Priority sysfs attributes for SATA devices
  scsi: pm80xx: Add libsas SATA sysfs attributes group
  scsi: mvsas: Add libsas SATA sysfs attributes group
  scsi: hisi_sas: Add libsas SATA sysfs attributes group

 drivers/ata/libata-sata.c              | 139 ++++++++++++++++++-------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |   6 ++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |   6 ++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |   6 ++
 drivers/scsi/libsas/sas_ata.c          |  92 ++++++++++++++++
 drivers/scsi/mvsas/mv_init.c           |   7 ++
 drivers/scsi/pm8001/pm8001_ctl.c       |   5 +
 drivers/scsi/pm8001/pm8001_init.c      |   1 +
 drivers/scsi/pm8001/pm8001_sas.h       |   1 +
 include/linux/libata.h                 |   4 +
 include/scsi/sas_ata.h                 |   6 ++
 11 files changed, 233 insertions(+), 40 deletions(-)

-- 
2.44.0.278.ge034bb2e1d-goog

