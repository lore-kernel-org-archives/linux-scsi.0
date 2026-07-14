Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E5B5CDF1
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 00:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783989458; cv=none; b=Qqf5IWibchENTA9tNbktyrycVxC9mcrPobDCeW4RBiqHua3nwFREVxMkrd50Iqbe2OBsupBZ53TjsGEKvtB5tD/LBZNfl3GEhAEQC6zxknk4E9bmD+0DTudPdRCBJpqrfVq4Wqu9pI2HhoSWIIC8S6xzPirCm22FB8m4AtxWWto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783989458; c=relaxed/simple;
	bh=gL26ypMnCp5VAvNpHSgGG/Tq61PupH19CC8JGdI9p1Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DORo+2geCOFKyLvHsMec87xz57bdqCUMVb9SJqIAwNxHDSyLJSr+Uf0HxqlZKBKdjjUdNRGLKV6xTTvybD/ePBsn7eIirbsG+rlAmZYeBKJz8xCS3lye3L9/QTS92RrQ5WoVYn0ioSWAI7lqzXBUPS5zlTeU9J+4JEOttm3350k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZDQ8DzvW; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZDQ8DzvW"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8efb708b1a0so32741866d6.3
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 17:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783989456; x=1784594256; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9xFOnU32GAqB1xS8MMbFM4u+DhEfa1EjML4o7aYcIHs=;
        b=ZDQ8DzvW4gDjYkqrETblSfIm6YjIM790PVERnI++KrdfuRb09OFAEIBb0bVMOzQon9
         ZmoGbhbs+AouWGkdu+SwVzjTWuUDbEB1GTJKOtvZJvwOQQ8rtsaHHbPj5yVRwxwhV/w4
         qs9c8ZBYT3NYwmGNzRRHifPYAGd4pHyh6SifPyiRyIMVNCpNJxfWLuZBiXYilCcNlbPh
         YYScqT6hl2wSB2F4kiBLRvlCl4kaeY4h/tfdQI1yc2hSyrnWSAecWrT5KKI+PWlQ0byA
         KcfVmHT9GEeJmri77yo4ALQcSZ8A+vmKVglLpnrsKvDc3xpFuTE0pv/pNsibntVPYaSO
         4vfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783989456; x=1784594256;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9xFOnU32GAqB1xS8MMbFM4u+DhEfa1EjML4o7aYcIHs=;
        b=DgjT51dz6SW7SN8M7L1Iug/L7LwrDkbnf4PtWx7t/Jv3NffXepaNyS56jFg/KX+3bm
         oqW/pL0zPy1E4UbCjn5ENtM8V0UqMA2eJW4DAR5Mr6BjOQbCeFp4lT+gAt5eSfmos5+Q
         WUoP8wO1U9Kc6HyqslEEvbu7TmdOSr7jcJ5710pq0ZK50sYoynqp8LIzEoeaWzrH+djz
         okY7bR1uQ199pRJ96y7bppmkmxTNYlweeGpAqS+piWvh9TBExCsB09rqWuDCXl1ifmMo
         f1yobQucvy2lQQS/LUdATwBRa1ZgKQLRIWyYwOKY4Q7yjWlkBNMWysIokx8/fqOeRSi+
         itLQ==
X-Gm-Message-State: AOJu0Yyx972s0DGcJ22sFAUSzhJRQifTxYaBBcx0GUji02YhpkpAWMHx
	ExDBBz+RndYcm+I0wvnlooI/VskMNkA8cJIyOnutpopCCvVDpChq5zojq1F+0EkY63M=
X-Gm-Gg: AfdE7cmjPSPEZWzijqU/NXUxMzmZN5vrebfiPDJ25c1f1Vbyz/dpzziz9aPUUfmvo5I
	eUbNGShvV0uyxC3vxuFpKn7O3x2p83ejwXAdUnHvj0HAY9qoDJjL/ESr/k2m9oOfhvNAxIJdCal
	1JItuiiEdMT6H0AYrRJMDp8FDmjO4aJwaixBAzrxBRIKKuX6F4Yvcv8A88Z+Nb3ZlBOjrlx5Miu
	alIOHpemLcZ9gCe5ONAgvFm2ZSYYUiwScRdlgJ5UARFF6TUXrj9TMpT7jaSm8PSiAj30qsAwfqc
	VuXB+BCpShRYufJ4wfXVOMzj82zLgb0PW/egTlxExn5JRfrqBFO5sfgtNDqRi5LgyKIsT0xjcvh
	sO+6b0IfxTogyXTpDtySu+2c4QoAl1FzpNDNK2hQ0THQZvNSCF0q7pyCqWpNJTKGaLf9Fv58Jai
	/wPZYraoCPCjbdC+Cb6JHq8F2lxasCwmzrAdGpGpJGesNG1K7lEk0biDgbvtj2c9iXoG4ZNJbZX
	vjRg/sWkrxMhx51JgM9uRRHKpcw5NdP
X-Received: by 2002:a05:620a:7002:b0:92e:4a63:d7ef with SMTP id af79cd13be357-93086be1deemr32685985a.48.1783989456209;
        Mon, 13 Jul 2026 17:37:36 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d6c28bsm1289899185a.46.2026.07.13.17.37.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Jul 2026 17:37:35 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v3 00/14] Update lpfc to revision 15.0.0.1
Date: Mon, 13 Jul 2026 18:17:58 -0700
Message-Id: <20260714011812.106753-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc to revision 15.0.0.1

This patch set contains bug fixes related to cleanup handling in both
normal and error paths, discovery rework for large SAN configurations, and
refactoring of duplicate code.

The patches were cut against Martin's 7.3/scsi-queue tree.

Justin Tee (14):
  lpfc: Fix use-after-free in lpfc_cmpl_ct_cmd_vmid
  lpfc: Early return out of lpfc_els_abort when HBA_SETUP flag is not
    set
  lpfc: Fix kernel oops when unmapping scsi dma buffers for an aborted
    cmd
  lpfc: Check fc4_xpt_flags before decrementing ndlp kref on FDISC error
  lpfc: Add handling for when PLOGI or PRLI is dropped during link
    failure
  lpfc: Fix ndlp use-after-free during repeated RSCN and rediscovery
    sequence
  lpfc: Rework I/O flush ordering when unloading driver
  lpfc: Improve PLOGI retry handling for large SAN configurations
  lpfc: Send inhibited ABORT_WQE when PLOGI CQE SEQUENCE_TMO is received
  lpfc: Remove slowpath cqe process limiter in slow ring event handler
  lpfc: Put iocbq on phba->txq when ELS WQ is full or ELS SGL
    unavailable
  lpfc: Update ELS ACC logging for diagnostic troubleshooting
  lpfc: Refactor calls on fc_disctmo to lpfc_set_disctmo in RSCN handler
  lpfc: Update lpfc version to 15.0.0.1

 drivers/scsi/lpfc/lpfc_bsg.c       |   5 +-
 drivers/scsi/lpfc/lpfc_crtn.h      |  12 +-
 drivers/scsi/lpfc/lpfc_ct.c        |  19 +-
 drivers/scsi/lpfc/lpfc_disc.h      |   2 +-
 drivers/scsi/lpfc/lpfc_els.c       | 427 +++++++++++++++++++++++------
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 100 +++----
 drivers/scsi/lpfc/lpfc_init.c      |  16 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  86 +++++-
 drivers/scsi/lpfc/lpfc_nvme.c      |   2 +-
 drivers/scsi/lpfc/lpfc_scsi.c      |   2 +-
 drivers/scsi/lpfc/lpfc_sli.c       | 245 ++++++++++++-----
 drivers/scsi/lpfc/lpfc_sli.h       |   4 +-
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 13 files changed, 706 insertions(+), 216 deletions(-)

-- 
2.38.0

