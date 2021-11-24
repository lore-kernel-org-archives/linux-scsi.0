Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71391C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 00:52:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbhKXAze (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:55:34 -0500
Received: from mail-pj1-f51.google.com ([209.85.216.51]:52103 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhKXAzd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2021 19:55:33 -0500
Received: by mail-pj1-f51.google.com with SMTP id gt5so982918pjb.1
        for <linux-scsi@vger.kernel.org>; Tue, 23 Nov 2021 16:52:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rq7L8De9OlVYKfqKnWTDnz6oL9ougHy8bbWTNZUIWf8=;
        b=Ju/smnPhEcP7AUusg5/vs/Wsf2OkIJpa8CaxOUoofl+YhPJwM5Bt7BixdJaIWJ/5fn
         AgwlQFGPANdC6NnRyfUQzqVhZd27wELKK7alkv6BE3wkZn70S38xmQefYkZhB3qbQvys
         phI1EocgKU/oGXSqouzw326HucJl4bHLBWpDCGrK/uF4x2wyT53bAjmsUha5Y9OdKE3G
         MZGzvKJ2og6aN4GFQOZBO7P66Xo3WNqwIG2fvpna9rmC8NbWDG4fSfj4AcZ9Am+zYfz7
         YYdwfARy4399gOls7kG0APuClkM1W4Oe2bch291eDuxKFVmVLWdud+fEQS/ryEVm/nkf
         Q2Iw==
X-Gm-Message-State: AOAM530mZHh2Wgg+baM+M3bPH5UgztCcLtDVY+IcMY4g0DNZdG/MdOzc
        v6B6AlIjITnRAqJp5OIQF1xRzbG48MDiVQ==
X-Google-Smtp-Source: ABdhPJxRnBz6aRY1hqlJHX8zAXcNE4eKNB56zupl2LuEjHrW+YqFKFYgauSpCE1K3zejyPZ3eT1jPQ==
X-Received: by 2002:a17:90a:9907:: with SMTP id b7mr9313649pjp.137.1637715144998;
        Tue, 23 Nov 2021 16:52:24 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:58e8:6593:938:2bea])
        by smtp.gmail.com with ESMTPSA id x33sm14210387pfh.133.2021.11.23.16.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 16:52:24 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 00/13] A series of small SCSI patches
Date:   Tue, 23 Nov 2021 16:52:04 -0800
Message-Id: <20211124005217.2300458-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series fixes a number of static checker warnings. Most of these
patches fix warnings introduced during the merge window.

Please consider these patches for kernel v5.17.

Thanks,

Bart.

Bart Van Assche (13):
  scsi: core: Suppress a kernel-doc warning
  scsi: core: Declare 'scsi_scan_type' static
  scsi: core: Show SCMD_LAST in text form
  scsi: a100u2w: Fix a kernel-doc warning
  scsi: ata: Declare 'ata_ncq_sdev_attrs' static
  scsi: atp870u: Fix a kernel-doc warning
  scsi: bfa: Declare 'bfad_im_vport_attrs' static
  scsi: dc395x: Fix a kernel-doc warning
  scsi: initio: Fix a kernel-doc warning
  scsi: megaraid: Fix a kernel-doc warning
  scsi: pm8001: Fix kernel-doc warnings
  scsi: pmcraid: Fix a kernel-doc warning
  scsi: Remove superfluous #include <linux/async.h> directives

 drivers/ata/libata-sata.c             |  2 +-
 drivers/scsi/a100u2w.c                |  2 --
 drivers/scsi/atp870u.c                |  1 -
 drivers/scsi/bfa/bfad_attr.c          |  2 +-
 drivers/scsi/dc395x.c                 |  3 +--
 drivers/scsi/hisi_sas/hisi_sas.h      |  1 -
 drivers/scsi/initio.c                 |  2 --
 drivers/scsi/libsas/sas_discover.c    |  1 -
 drivers/scsi/megaraid/megaraid_mbox.c |  1 -
 drivers/scsi/pm8001/pm8001_ctl.c      | 24 ++++++++++++------------
 drivers/scsi/pmcraid.c                |  1 -
 drivers/scsi/scsi.c                   |  1 -
 drivers/scsi/scsi_debugfs.c           |  1 +
 drivers/scsi/scsi_pm.c                |  1 -
 drivers/scsi/scsi_priv.h              |  1 -
 drivers/scsi/scsi_scan.c              |  4 ++--
 drivers/scsi/sd.c                     |  1 -
 drivers/scsi/ufs/ufshpb.c             |  1 -
 18 files changed, 18 insertions(+), 32 deletions(-)

