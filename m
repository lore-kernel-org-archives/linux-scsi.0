From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 0/7] Miscellaneous patches to support cxlflash in PowerVM
Date: Fri,  4 Mar 2016 15:53:44 -0600
Message-ID: <1457128424-53017-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:52111 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760201AbcCDVzr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2016 16:55:47 -0500
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Fri, 4 Mar 2016 16:55:46 -0500
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 5EE0B6E8041
	for <linux-scsi@vger.kernel.org>; Fri,  4 Mar 2016 16:42:33 -0500 (EST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u24Ltg0935913858
	for <linux-scsi@vger.kernel.org>; Fri, 4 Mar 2016 21:55:42 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u24Ltf7x030482
	for <linux-scsi@vger.kernel.org>; Fri, 4 Mar 2016 16:55:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

The first 5 patches of this series contain fixes to support
the cxlflash driver in a PowerVM guest. For the cxlflash driver
to be functional in a PowerVM guest, a corresponding set of cxl
patches (currently being upstreamed) is required. Note that this
cxlflash patch series does not have any build dependencies on
the new cxl code.

The sixth patch in the series is a fix to dynamically swap between
the AFU's internal LUN and an actual LUN detected on the fabric.

The last patch in the series is a performance enhancement to
improve throughput with cxlflash driver.

This series is intended for 4.6 and is bisectable.

Manoj N. Kumar (3):
  cxlflash: Simplify PCI registration
  cxlflash: Fix to avoid unnecessary scan with internal LUNs
  cxlflash: Increase cmd_per_lun for better throughput

Matthew R. Ochs (2):
  cxlflash: Split out context initialization
  cxlflash: Simplify attach path error cleanup

Uma Krishnan (2):
  cxlflash: Unmap problem state area before detaching master context
  cxlflash: Reorder user context initialization

 drivers/scsi/cxlflash/common.h    |   8 +-
 drivers/scsi/cxlflash/main.c      |  72 +++-----------
 drivers/scsi/cxlflash/superpipe.c | 195 +++++++++++++++++++++-----------------
 drivers/scsi/cxlflash/superpipe.h |   1 +
 4 files changed, 131 insertions(+), 145 deletions(-)

-- 
2.1.0

