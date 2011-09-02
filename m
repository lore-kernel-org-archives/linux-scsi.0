From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 0/3] basic sgpio write support
Date: Thu, 01 Sep 2011 21:18:15 -0700
Message-ID: <20110902041637.27608.29757.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:34240 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab1IBESQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Sep 2011 00:18:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, jacek.danecki@intel.com

Just enough infrastructure to get raw-bitstream writes operational.  With a
common decode implementation in libsas.  SAS-2 support is deferred as SFF-8485
remains at v0.7 [1].  Read support and the "non-raw" tx registers are deferred
until the general approach is accepted.

For future patches it might be useful to register a 'sgpio' interface in sysfs
for all local phys to accept IBPI commands like "identify" or "fail".  Although,
the driver has no way of verifying if phy0 is routed to sgpio-device0. 

Until then this interface just uses the sas_host bsg device as shown in patch1.

--
Dan

[1]: http://marc.info/?l=linux-scsi&m=130693695829154&w=2

---

Dan Williams (3):
      libsas: sgpio write support
      isci: fix sgpio register definitions
      isci: initial sgpio write support


 drivers/scsi/isci/host.c           |   69 ++++++++++++++++++++
 drivers/scsi/isci/host.h           |   15 ++++
 drivers/scsi/isci/init.c           |    3 +
 drivers/scsi/isci/registers.h      |  122 +-----------------------------------
 drivers/scsi/libsas/sas_host_smp.c |  103 ++++++++++++++++++++++++++++++
 include/scsi/libsas.h              |   11 +++
 include/scsi/sas.h                 |    8 ++
 7 files changed, 211 insertions(+), 120 deletions(-)
