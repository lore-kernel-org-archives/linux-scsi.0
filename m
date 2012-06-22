From: Dan Williams <dan.j.williams@intel.com>
Subject: [set2 PATCH 0/4] libsas: eh routines vs eh context
Date: Thu, 21 Jun 2012 23:30:43 -0700
Message-ID: <20120622063043.21248.12701.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47853 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761316Ab2FVGOF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jun 2012 02:14:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Set2 of 5 patchsets to update scsi, libsas, and libata in
support of the isci driver.

The generic libsas eh handlers are called in many contexts, however lldd
implementations (isci in particular, but mvsas and pm8001 as well)
assume that they are only in eh context.  Make it safe for lldds to use
the generic helpers in all cases.

"libsas: add sas_eh_abort_handler" could be squashed with "isci: use sas
eh strategy handlers", but I left it separate since it needs enabling
(optional) per-lldd.

These have been in -next for the past couple kernel cycles.

---

Dan Williams (4):
      libsas: enforce eh strategy handlers only in eh context
      libsas: add sas_eh_abort_handler
      libsas: use ->lldd_I_T_nexus_reset for ->eh_bus_reset_handler
      isci: use sas eh strategy handlers


 drivers/scsi/isci/init.c            |    3 +
 drivers/scsi/libsas/sas_discover.c  |   11 ++
 drivers/scsi/libsas/sas_init.c      |    2 
 drivers/scsi/libsas/sas_scsi_host.c |  159 ++++++++++++++++++++++++++++++++---
 drivers/scsi/pm8001/pm8001_sas.c    |    3 -
 include/scsi/libsas.h               |   11 ++
 6 files changed, 174 insertions(+), 15 deletions(-)
