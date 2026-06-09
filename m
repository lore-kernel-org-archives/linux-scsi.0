Received: from mail-oo1-f98.google.com (mail-oo1-f98.google.com [209.85.161.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734373F5BD9
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jun 2026 11:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781005722; cv=none; b=S9uXAPauELe1wvA0GmCO+dIEgPahPmLcgubAePoubxmRlkSrR7MhIgbJJTTRNenEMYe1pGpTl6rp9VyodzgQvlQ2MZEVoOOGHMM2JyEZWSbdgCY1QzFmiylmb+gsUBNSWwJaO/o1RGcbXnTOiiXFV1bbBNtJpfSGQMfqcXLGO0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781005722; c=relaxed/simple;
	bh=uwnsk7uP8WIJoO8ttbzpXJmdi0aUvgvTHnMPSDHcaKw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JUCu73G/+f6sdz/YUhFYWkUAnLHlEvuLCXEQjRr0dXJwE7lewXSZAg4yze/ap9hBahrjTCeGAGOwuQcg2t29faAyjsMOa7ZlG4BSMq2vV6xYI9TCKecHFuuM3DPwSzQntqURhtmkUwIIYFqPuYlpm2A3kQRby7eFXLA9TlKdIEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=e2uIwMV8; arc=none smtp.client-ip=209.85.161.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="e2uIwMV8"
Received: by mail-oo1-f98.google.com with SMTP id 006d021491bc7-69e402b625fso3618296eaf.1
        for <linux-scsi@vger.kernel.org>; Tue, 09 Jun 2026 04:48:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781005719; x=1781610519;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2GtwyftxDgDxHf00TNmN+7bsJSzsnvSjUZVIyovfOvI=;
        b=BgBG0AKTdEV7BJPDdPfsQwK7q8L8lfkGTf+HgjZUvwIfJeGMr+P73M5T1MjsG0vwki
         c/FhWE4bdAigFOPnx0ssiDHT9QhHgFXbxYMxNEPlzXJ1CmRXTrrt7+imTE915dnZIjf0
         bBbLLtpp6hvRJ234+i1QQ2sFXbTas61d72sHhJpvAKPcHRe9kTt2oqaOLkxOeD/+Q/8H
         UoUZywUzwX1YWSeukvDKOHv1KyZlBn+lQo122bUzTMKNLQFQzLiQBtu+foxy7aAj96us
         tdxcEK78lp0hpzR6ScWZct4AV5w6FmZPXLeYjg3tZwKmnxNSY+w+VHwrYMRGQmYIzf+Q
         wtOg==
X-Forwarded-Encrypted: i=1; AFNElJ92oGciBlAyK8IbEVGWO7ZFfAOf9VSD9IsdmeDV53IYW5BZ1Itm7RCj4MRMEGtQvjebj8Y3RE2iYSyy@vger.kernel.org
X-Gm-Message-State: AOJu0YyO7ie2ZmiZ22Imj+xvIIV6lg3OW2ObZTOVq1RSTgMj2BSrOER/
	DxIYGJ0D8U5uUHuvSd/3B5eZvWHNaGZsfm8YDfx4ypfSrTKS4fsoEBPFDVFzR9q0qJM2Nt1CEa/
	smIq+2Uauk8dElKUlgPg4qaRUHMXxAubhOCa+oagR4Ba0qyIJhj6OqxypGR8VLTeFA+4NuW9sDa
	VNj9zZC+LXDQNP/0jK6Tjs1RWjJdqnuwetkHAUcvw8DJRgBWlBJdpeBN6jR2PWjwnRM1V3zX2eW
	NI4EkB6C2JEzEsg
X-Gm-Gg: Acq92OGXnzK/jpUf/IA/mvuh/138Wwbu91jFhXI0VJyDhdT5VwrUcdSqjROd60cqg4M
	ghGkDB7jHICfnZG13RayWceVOxtAqHTBMhjMfb+6YHan92Dpmgw44i6N+cJeztg7nGWYrjhrKrX
	qDWJQpiFq0D8n2dimZNsUedn3LEXw83jdU+bU8PmaCNdvhuHMjEsGlY8vyV6eDICx7DdiGBgzm9
	TzWhXQtH1cN/bG2m8w175+2mnear1S7PJdQ5nWDlhFPs/ZrrDm+QW7kQfsJM2rcaDBiwaDXnuXf
	5WM4q+WJVloygOYSpvlyViNdTVCah7aFFwPG3Zjm0eM+v8ZM14gysj9LPsY2boQ4XDRm49pfn+p
	i+8rBDa+flGw/NW4YavYkfLTn8PjZtsrygPIB7TQniBI/QeqKdwqGx2HhFwJCrvUKwxXYGV39N+
	pulgHkd+7ldMLIxtgSmaIsNhkoNZ6RG/Z1rCbsFMXJsFCvSkusDevZQgLLDx1zxHh3VkRDDw==
X-Received: by 2002:a05:6820:342:b0:69d:fcab:c640 with SMTP id 006d021491bc7-69e68c59187mr8009771eaf.42.1781005719227;
        Tue, 09 Jun 2026 04:48:39 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-118.dlp.protect.broadcom.com. [144.49.247.118])
        by smtp-relay.gmail.com with ESMTPS id 006d021491bc7-69e88077ca5sm344409eaf.26.2026.06.09.04.48.38
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jun 2026 04:48:39 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-36d98b74447so4270686a91.2
        for <linux-scsi@vger.kernel.org>; Tue, 09 Jun 2026 04:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1781005718; x=1781610518; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2GtwyftxDgDxHf00TNmN+7bsJSzsnvSjUZVIyovfOvI=;
        b=e2uIwMV898uSiIGBFwRmwkHCS2tymQ6pmRRxIcDZzGObmm9Z76jjduPKTt86NTUa6X
         Q3sgiAT4XML/RSl9EVEL5STDpek+Vs9kvLFQ8qqmeO8taDtrBQehtJvXD3ZxMFL0T5dF
         Vquzng4pDKrXKas1cg4uNKfLimmruPZCgKEZ0=
X-Forwarded-Encrypted: i=1; AFNElJ/7RcXX63q2mduNH+L/UZ9QnXyu25nNjGlYhC4tzrk19kFxlPy7maXIMLjyEGR+H2Au9QoNh89hxhK3@vger.kernel.org
X-Received: by 2002:a17:90b:5783:b0:36a:4074:9aa6 with SMTP id 98e67ed59e1d1-370ee82fcb9mr19842178a91.6.1781005717462;
        Tue, 09 Jun 2026 04:48:37 -0700 (PDT)
X-Received: by 2002:a17:90b:5783:b0:36a:4074:9aa6 with SMTP id 98e67ed59e1d1-370ee82fcb9mr19842127a91.6.1781005716916;
        Tue, 09 Jun 2026 04:48:36 -0700 (PDT)
Received: from sumit_ws.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6bf903fasm18898075a91.2.2026.06.09.04.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 04:48:36 -0700 (PDT)
From: Sumit Saxena <sumit.saxena@broadcom.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	Adam Radford <aradford@gmail.com>,
	Khalid Aziz <khalid@gonehiking.org>,
	Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	Matthew Wilcox <willy@infradead.org>,
	Hannes Reinecke <hare@suse.com>,
	"Juergen E . Fischer" <fischer@norbit.de>,
	Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org,
	Finn Thain <fthain@linux-m68k.org>,
	Michael Schmitz <schmitzmic@gmail.com>,
	Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
	Oliver Neukum <oliver@neukum.org>,
	Ali Akcaagac <aliakc@web.de>,
	Jamie Lenehan <lenehan@twibble.org>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	target-devel@vger.kernel.org,
	Bradley Grove <linuxdrivers@attotech.com>,
	Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Yihang Li <liyihang9@h-partners.com>,
	Don Brace <don.brace@microchip.com>,
	storagedev@microchip.com,
	HighPoint Linux Team <linux@highpoint-tech.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	Brian King <brking@us.ibm.com>,
	Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	open-iscsi@googlegroups.com,
	Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	megaraidlinux.pdl@broadcom.com,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	MPT-FusionLinux.pdl@broadcom.com,
	Daniel Palmer <daniel@thingy.jp>,
	GOTO Masanori <gotom@debian.or.jp>,
	YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Geoff Levand <geoff@infradead.org>,
	Michael Reed <mdr@sgi.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Narsimhulu Musini <nmusini@cisco.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	linux-hyperv@vger.kernel.org,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eugenio Perez <eperezma@redhat.com>,
	virtualization@lists.linux.dev,
	Vishal Bhakta <vishal.bhakta@broadcom.com>,
	bcm-kernel-feedback-list@broadcom.com,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	xen-devel@lists.xenproject.org,
	Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH v3 0/4] scsi/block: NUMA-local scan allocations, shared-tag path cleanup, and SCSI I/O counters
Date: Tue,  9 Jun 2026 17:47:59 +0530
Message-ID: <20260609121806.2121755-1-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

This series contains three performance improvements targeting the SCSI
and block layers on multi-socket NUMA and heavily loaded SMP systems.

On multi-socket NUMA systems we observed extreme I/O throughput variance
of 50-60% between runs.  This series identifies and fixes two root causes:
cross-node memory accesses due to NUMA-unaware allocations in the scan
path, and false sharing between hot atomic counters in struct request_queue
and struct scsi_device.

Performance notes:

Tested on a dual-socket NUMA system (2x 32-core, 256 GB/socket) with
an mpi3mr HBA, running fio (random read, 4K, QD 64, 16 jobs, 60 s,
direct I/O).  IOPS figures are in KIOPS (thousands of IOPS):

  Configuration                    Avg KIOPS   Range (KIOPS)   Spread
  Baseline                         6,255       4,200 - 6,700   ~37%
  Baseline + all patches           7,350       7,000 - 7,700    ~10%

Key findings:

These patches combinedly reduces the observed 50-60% run-to-run variance
to under 10%, significantly improving workload predictability and
improves IOPs by 16-18%.

No functional regressions observed.

Changes in v3
-------------
-Handled feedback from Bart Van Assche and John Garry.
-Added a patch for shost local NUMA allocation.
-Converted ioerr_cnt and iotmo_cnt atomic counters into per-cpu counters. 

Changes in v2
--------------

  Patch 1 — Same functional goal as v1 patch 1: NUMA-local scsi_device /
  scsi_target allocations in the scan path so steady-state I/O does not
  habitually touch remote memory when the host has a fixed DMA/NUMA
  affinity.

  Patch 2 — Replaces v1’s ____cacheline_aligned_in_smp on
  nr_active_requests_shared_tags with removal of the shared-tag fairness
  throttling machinery (including hctx_may_queue(), blk_mq_hw_ctx.nr_active,
  and request_queue.nr_active_requests_shared_tags and their updates).
  This follows the earlier standalone proposal by Bart Van Assche [1],
  rebased for the current tree; it removes the high-frequency atomic
  accounting that motivated the v1 false-sharing workaround and, in our
  testing, improves IOPS on the order of roughly 16–18% for the shared-tag
  workload exercised.

  Patch 3 — Replaces v1’s cache-line padding of iodone_cnt with
  percpu_counter for both iorequest_cnt and iodone_cnt, so submission and
  completion paths mostly update CPU-local state instead of bouncing a
  single cache line, without inflating struct scsi_device for SMP
  alignment.

Merge / review hints
--------------------

Patch 3 touches the block layer and should have block maintainer review;
rest of patches are SCSI-oriented.  Please route or Ack as your subsystem
workflow requires.

Bart Van Assche (1):
  block: drop shared-tag fairness throttling

James Rizzo (1):
  scsi: scan: allocate sdev and starget on the NUMA node of the host
    adapter

Sumit Saxena (2):
  scsi: host: allocate struct Scsi_Host on the NUMA node of the host
    adapter
  scsi: use percpu counters for iostat counters in struct scsi_device

 block/blk-core.c                          |   2 -
 block/blk-mq-debugfs.c                    |  22 ++++-
 block/blk-mq-tag.c                        |   4 -
 block/blk-mq.c                            |  17 +---
 block/blk-mq.h                            | 100 ----------------------
 drivers/scsi/3w-9xxx.c                    |   2 +-
 drivers/scsi/3w-sas.c                     |   2 +-
 drivers/scsi/3w-xxxx.c                    |   2 +-
 drivers/scsi/53c700.c                     |   2 +-
 drivers/scsi/BusLogic.c                   |   2 +-
 drivers/scsi/a100u2w.c                    |   2 +-
 drivers/scsi/a2091.c                      |   2 +-
 drivers/scsi/a3000.c                      |   2 +-
 drivers/scsi/aacraid/linit.c              |   2 +-
 drivers/scsi/advansys.c                   |   6 +-
 drivers/scsi/aha152x.c                    |   2 +-
 drivers/scsi/aha1542.c                    |   2 +-
 drivers/scsi/aha1740.c                    |   2 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c        |   2 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c        |   2 +-
 drivers/scsi/aic94xx/aic94xx_init.c       |   2 +-
 drivers/scsi/am53c974.c                   |   2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c          |   3 +-
 drivers/scsi/arm/acornscsi.c              |   2 +-
 drivers/scsi/arm/arxescsi.c               |   2 +-
 drivers/scsi/arm/cumana_1.c               |   2 +-
 drivers/scsi/arm/cumana_2.c               |   2 +-
 drivers/scsi/arm/eesox.c                  |   2 +-
 drivers/scsi/arm/oak.c                    |   2 +-
 drivers/scsi/arm/powertec.c               |   2 +-
 drivers/scsi/atari_scsi.c                 |   2 +-
 drivers/scsi/atp870u.c                    |   2 +-
 drivers/scsi/bfa/bfad_im.c                |   2 +-
 drivers/scsi/csiostor/csio_init.c         |   4 +-
 drivers/scsi/dc395x.c                     |   2 +-
 drivers/scsi/dmx3191d.c                   |   2 +-
 drivers/scsi/elx/efct/efct_xport.c        |   4 +-
 drivers/scsi/esas2r/esas2r_main.c         |   2 +-
 drivers/scsi/fdomain.c                    |   2 +-
 drivers/scsi/fnic/fnic_main.c             |   2 +-
 drivers/scsi/g_NCR5380.c                  |   2 +-
 drivers/scsi/gvp11.c                      |   2 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c     |   2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    |   2 +-
 drivers/scsi/hosts.c                      |   6 +-
 drivers/scsi/hpsa.c                       |   2 +-
 drivers/scsi/hptiop.c                     |   2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c            |   2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c          |   2 +-
 drivers/scsi/imm.c                        |   2 +-
 drivers/scsi/initio.c                     |   2 +-
 drivers/scsi/ipr.c                        |   2 +-
 drivers/scsi/ips.c                        |   2 +-
 drivers/scsi/isci/init.c                  |   2 +-
 drivers/scsi/jazz_esp.c                   |   2 +-
 drivers/scsi/libiscsi.c                   |   2 +-
 drivers/scsi/lpfc/lpfc_init.c             |   2 +-
 drivers/scsi/mac53c94.c                   |   2 +-
 drivers/scsi/mac_esp.c                    |   2 +-
 drivers/scsi/mac_scsi.c                   |   2 +-
 drivers/scsi/megaraid.c                   |   2 +-
 drivers/scsi/megaraid/megaraid_mbox.c     |   2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c |   2 +-
 drivers/scsi/mesh.c                       |   2 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c           |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      |   4 +-
 drivers/scsi/mvme147.c                    |   2 +-
 drivers/scsi/mvsas/mv_init.c              |   2 +-
 drivers/scsi/mvumi.c                      |   2 +-
 drivers/scsi/myrb.c                       |   2 +-
 drivers/scsi/myrs.c                       |   2 +-
 drivers/scsi/ncr53c8xx.c                  |   2 +-
 drivers/scsi/nsp32.c                      |   2 +-
 drivers/scsi/pcmcia/nsp_cs.c              |   2 +-
 drivers/scsi/pcmcia/qlogic_stub.c         |   2 +-
 drivers/scsi/pcmcia/sym53c500_cs.c        |   2 +-
 drivers/scsi/pm8001/pm8001_init.c         |   2 +-
 drivers/scsi/pmcraid.c                    |   2 +-
 drivers/scsi/ppa.c                        |   2 +-
 drivers/scsi/ps3rom.c                     |   2 +-
 drivers/scsi/qla1280.c                    |   2 +-
 drivers/scsi/qla2xxx/qla_mid.c            |   2 +-
 drivers/scsi/qla2xxx/qla_os.c             |   2 +-
 drivers/scsi/qlogicfas.c                  |   2 +-
 drivers/scsi/qlogicpti.c                  |   2 +-
 drivers/scsi/scsi_debug.c                 |   2 +-
 drivers/scsi/scsi_error.c                 |   4 +-
 drivers/scsi/scsi_lib.c                   |  10 +--
 drivers/scsi/scsi_scan.c                  |  15 +++-
 drivers/scsi/scsi_sysfs.c                 |  23 +++--
 drivers/scsi/sd.c                         |   2 +-
 drivers/scsi/sgiwd93.c                    |   2 +-
 drivers/scsi/smartpqi/smartpqi_init.c     |   2 +-
 drivers/scsi/snic/snic_main.c             |   2 +-
 drivers/scsi/stex.c                       |   2 +-
 drivers/scsi/storvsc_drv.c                |   2 +-
 drivers/scsi/sun3_scsi.c                  |   2 +-
 drivers/scsi/sun3x_esp.c                  |   2 +-
 drivers/scsi/sun_esp.c                    |   2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c       |   2 +-
 drivers/scsi/virtio_scsi.c                |   2 +-
 drivers/scsi/vmw_pvscsi.c                 |   2 +-
 drivers/scsi/wd719x.c                     |   2 +-
 drivers/scsi/xen-scsifront.c              |   2 +-
 drivers/scsi/zorro_esp.c                  |   2 +-
 include/linux/blk-mq.h                    |   6 --
 include/linux/blkdev.h                    |   2 -
 include/scsi/libfc.h                      |   2 +-
 include/scsi/scsi_device.h                |   9 +-
 include/scsi/scsi_host.h                  |   3 +-
 110 files changed, 168 insertions(+), 258 deletions(-)

-- 
2.43.7

