From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v2 0/2] Fix regression and performance issue in cxlflash
Date: Fri, 25 Mar 2016 14:25:20 -0500
Message-ID: <1458933920-28788-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:50165 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbcCYT2F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Mar 2016 15:28:05 -0400
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Fri, 25 Mar 2016 15:28:04 -0400
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 2B9AB6E803F
	for <linux-scsi@vger.kernel.org>; Fri, 25 Mar 2016 15:14:52 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u2PJS2hC33751188
	for <linux-scsi@vger.kernel.org>; Fri, 25 Mar 2016 19:28:02 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u2PJS0ov012087
	for <linux-scsi@vger.kernel.org>; Fri, 25 Mar 2016 15:28:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

This series has a couple of patches in cxlflash.

The first patch is critical as it fixes a regression that was introduced
by Commit 6ded8b3cbd9a ("cxlflash: Unmap problem state area before
detaching master context") as part of the first SCSI push for v4.6.

The second patch addresses a performance issue.

This series is intended for v4.6 and is bisectable. We would like to see
these included in the second merge window push for v4.6 (if there is one).
Otherwise these can be a candidate for v4.6-rc2.

v2 Changes:
- Added the ack/review tags including one which was sent privately.

Manoj N. Kumar (2):
  cxlflash: Fix regression issue with re-ordering patch
  cxlflash: Move to exponential back-off when cmd_room is not available

 drivers/scsi/cxlflash/main.c | 138 +++++++++++++++++++++++++++++--------------
 drivers/scsi/cxlflash/main.h |   5 +-
 2 files changed, 97 insertions(+), 46 deletions(-)

-- 
2.1.0

