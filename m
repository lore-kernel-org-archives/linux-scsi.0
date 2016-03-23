From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 0/2] Fix regression and performance issue in cxlflash
Date: Wed, 23 Mar 2016 14:49:32 -0500
Message-ID: <1458762572-44316-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:59765 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbcCWTwE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2016 15:52:04 -0400
Received: from localhost
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Wed, 23 Mar 2016 13:52:03 -0600
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 518F33E4004F
	for <linux-scsi@vger.kernel.org>; Wed, 23 Mar 2016 13:52:01 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u2NJq1KA34996466
	for <linux-scsi@vger.kernel.org>; Wed, 23 Mar 2016 12:52:01 -0700
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u2NJpwQY032599
	for <linux-scsi@vger.kernel.org>; Wed, 23 Mar 2016 13:52:01 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@us.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

This series has a couple of patches in cxlflash.

The first patch is critical as it fixes a regression that was introduced
by Commit 6ded8b3cbd9a ("cxlflash: Unmap problem state area before
detaching master context") as part of the first SCSI push for v4.6.

The second patch addresses a performance issue.

This series is intended for v4.6 and is bisectable. We would like to see
these included in the second merge window push for v4.6 (if there is one).
Otherwise these can be a candidate for v4.6-rc2.

Manoj N. Kumar (2):
  cxlflash: Fix regression issue with re-ordering patch
  cxlflash: Move to exponential back-off when cmd_room is not available

 drivers/scsi/cxlflash/main.c | 138 +++++++++++++++++++++++++++++--------------
 drivers/scsi/cxlflash/main.h |   5 +-
 2 files changed, 97 insertions(+), 46 deletions(-)

-- 
2.1.0

