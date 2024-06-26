Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7C0175AA
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 10:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719396837; cv=none; b=hBXPskfdmuAyzQkdWIX5Hmml2zf/dfVZzvsPNgBeEcWfYb1iTJzSSGNHSByCl/UErOAvpi+ESG9fqe4H10562ETYTj6N4AUErOdMRbBg21lHCIee81aheFZhLfNLa7t9WGNytGLx0HHx3A36Yy4opdOULayK0z96TemIszbyojY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719396837; c=relaxed/simple;
	bh=dKwETv0AQAUsZYx2I7NIOTMUtTFWmuofk3XF97qY10U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=to9XB2N8DbRPk5Y5FOfesN1ttrUHRo5sM3zSbtIRHjM2xvfxg4iUcijMLqH7/DZgmQioGxlFCGxQSQgduzmAgGlGhv9gBxw18kj26YKJBnvE7gbTiuMsdTTwH3XksQ2OBek2NEzh64H8gtGloqsJ1aTp9ui9my07cWcTqaQ0F2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gt6JFEIi; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gt6JFEIi"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1f4a5344ec7so3026095ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 03:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719396835; x=1720001635; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BI/VLjUcghqV/rIzJOuhBc3ZDV2Xd+nN8aCOv+303y0=;
        b=gt6JFEIiUCHV3jXZ+yyXBIhfDEaLBHZ2pf1cgnjp3jiCT0aBeEs2O5E6wekCaJC3Qj
         KeSaqzlacYiyQcjzQGJW2o6JpL/x2IttWOteWpuPrl7lySqTOSmfd1ogQk55UriWd6/6
         OMa52IdBo0JwKAGyDqWwHZEsxHEB8Vz5nFeJFfsnYa6UCr6YcUyrPlVLk5F9YIPB+Wel
         6nOq+FFT+k9UD795Nu6uVzsz6k4TROo4dy6zi5I/ZQ40fkzsAJUO8O4xTl1EJ8VbUADz
         sGyy20DL4kbpseBq9xh1kzC0cWc/7ZqlNHqgdin55UxpEfIbKrvzzt2fYIc/yEKhqctl
         +2mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719396835; x=1720001635;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BI/VLjUcghqV/rIzJOuhBc3ZDV2Xd+nN8aCOv+303y0=;
        b=QKjj+1hOHoKl12JpyjX6K4IbCk/LPRYuwIdgVIC3i9FUzUpfMZzcp6o2BjuHiA80Rq
         28Blt1giEy+wUjuXwbQdM8Yu3zYAo2fMNfvK/R4Ocfc/2tKAHNhTPgKMOUkbqGnl+RcR
         abDLFAVuL0xcSPqgbi67j7ro3P/4cdxS23RIM+tGg194FL6B4b14a2wUG3+8by04ZLX8
         Q0jkOpqCcZCivod1DMbiEEi10W6LLPLgpXnh+Fjoxgdmnu3vu6wmqaY8KSDBYUOpfuoF
         QG6ie7/qMss/BH0pIyiexWfRMaZE2qCHi45dCdr0VqnnWuxm4OOnfENT5hAaU1p13Pfs
         e1eQ==
X-Gm-Message-State: AOJu0YxsGT7oLMCXbHkZ9BRX1wwMIJO5TAqmoFKEI4CK1Ayn3erEGMQd
	2h3IuXwKsUKvhSvtW5Mfwq1l/sEdDTVXbOn+jmS05eFQl68TZTXTgnscMw==
X-Google-Smtp-Source: AGHT+IE8kbGdbp+TPNvmvajjlm1c5CKJnR38NUqO7YQCef684UwxKZAKsSqq1YMzq9aFASUwju2SRw==
X-Received: by 2002:a17:902:e5ca:b0:1f6:87f:1156 with SMTP id d9443c01a7336-1fa5e4f60d2mr109110685ad.0.1719396835243;
        Wed, 26 Jun 2024 03:13:55 -0700 (PDT)
Received: from localhost.localdomain.oslab.amer.dell.com ([139.167.223.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fa360317ccsm57063865ad.279.2024.06.26.03.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 03:13:54 -0700 (PDT)
From: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
Subject: [PATCH 00/14] [PATCH] SCSI: Replace ternary operations with min()/max() macros
Date: Wed, 26 Jun 2024 06:13:28 -0400
Message-ID: <20240626101342.1440049-1-prabhakar.pujeri@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi All,

This patch series, generated using Coccinelle, aims to improve code readability and maintainability by replacing ternary operations with the min() and max() macros where applicable in the SCSI subsystem.

I acknowledge that some of these drivers are old and may not require modifications unless addressing critical issues. However, I intend to include these patches for those older drivers alongside any future critical fixes.

The patches have been compiled and tested on an x86_64 system. Physical device testing was conducted for the megaraid_sas and mpi3mr drivers.


Prabhakar Pujeri (14):
  scsi: advansys: Simplified memcpy length calculation in adv_build_req
  scsi: bfa: Used min() in fc_rftid_build_sol for bitmap size
  scsi: bfa:Simplified logic in bfa_fcs_rport_update and bfa_sgpg_mfree
  scsi: cxlflash: Replaced ternary operation in write_same16 with min()
  scsi: hpsa: Used min() for sense data size and buffer size in
    complete_scsi_command and hpsa_vpd_page_supported
  scsi: megaraid_sas: Simplified transfer length calculation using max()
    in mega_m_to_n
  scsi: megaraid_sas: Replaced ternary operation with max() in
    megasas_alloc_irq_vectors
  scsi: mpi3mr: Used min() in mpi3mr_map_data_buffer_dma for buffer size
  scsi: ncr53c8xx: Simplified tag number calculation with max() in
    ncr_sir_to_redo
  scsi: qla2xxx: Used max() for queue count in qla25xx_copy_mq
  scsi: qla2xxx: Simplified outstanding commands calculation in
    qla2x00_alloc_outstanding_cmds and qla24xx_read_fcp_prio_cfg
  scsi: scsi_debug: Replaced ternary operation with min() in
    resp_get_lba_status
  scsi: scsi_transport_spi: Simplified period calculation with max() in
    spi_dv_retrain
  scsi: st: Used max() for buffer size in setup_buffering and Simplified
    transfer calculations in st_read, append_to_buffer, and from_buffer

 drivers/scsi/advansys.c                   |  2 +-
 drivers/scsi/bfa/bfa_fcbuild.c            |  2 +-
 drivers/scsi/bfa/bfa_fcs_rport.c          |  6 ++----
 drivers/scsi/bfa/bfa_svc.c                |  5 +----
 drivers/scsi/cxlflash/vlun.c              |  2 +-
 drivers/scsi/hpsa.c                       | 11 +++--------
 drivers/scsi/megaraid.c                   |  3 +--
 drivers/scsi/megaraid/megaraid_sas_base.c |  5 +----
 drivers/scsi/mpi3mr/mpi3mr_app.c          |  7 ++-----
 drivers/scsi/ncr53c8xx.c                  |  2 +-
 drivers/scsi/qla2xxx/qla_dbg.c            |  3 +--
 drivers/scsi/qla2xxx/qla_init.c           |  6 ++----
 drivers/scsi/qla2xxx/qla_sup.c            |  2 +-
 drivers/scsi/scsi_debug.c                 |  5 +----
 drivers/scsi/scsi_transport_spi.c         |  2 +-
 drivers/scsi/st.c                         | 10 ++++------
 16 files changed, 24 insertions(+), 49 deletions(-)

--
2.45.1

