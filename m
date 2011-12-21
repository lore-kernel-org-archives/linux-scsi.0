From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 8/8] pmcraid: Pass pointers to access_ok(), not integers
Date: Wed, 21 Dec 2011 01:37:26 +0000
Message-ID: <1324431446.2844.155.camel@deadeye>
References: <1324430940.2844.144.camel@deadeye>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45587 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752956Ab1LUBhb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Dec 2011 20:37:31 -0500
In-Reply-To: <1324430940.2844.144.camel@deadeye>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>

Most architectures define access_ok() as a macro that casts its
argument such that an argument of type unsigned long will be accepted
without complaint.  However, the proper type is void *, and passing
unsigned long results in a warning on sparc64.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/pmcraid.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 5163edb..01b29a6 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3807,7 +3807,8 @@ static long pmcraid_ioctl_passthrough(
 	}
 
 	if (request_size > 0) {
-		rc = access_ok(access, arg, request_offset + request_size);
+		rc = access_ok(access, (void *)arg,
+			       request_offset + request_size);
 
 		if (!rc) {
 			rc = -EFAULT;
-- 
1.7.7.3


