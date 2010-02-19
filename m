From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH resend for-2.6.34] libosd: Fix unchecked err return found
 by smatch
Date: Fri, 19 Feb 2010 11:46:24 -0800
Message-ID: <4B7EEA90.3090105@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34251 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab0BSTq3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Feb 2010 14:46:29 -0500
Received: by bwz1 with SMTP id 1so381956bwz.21
        for <linux-scsi@vger.kernel.org>; Fri, 19 Feb 2010 11:46:27 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>


Doing CHECK="smatch --two-passes gives:
drivers/scsi/osd/osd_initiator.c +1435 osd_finalize_request warning: assignment to 'ret' was never used

Which is an unchecked possible allocation failure, Fixed.

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 2422347..60de850 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -1433,6 +1433,10 @@ int osd_finalize_request(struct osd_request *or,
 	cdbh->command_specific_options |= or->attributes_mode;
 	if (or->attributes_mode == OSD_CDB_GET_ATTR_PAGE_SET_ONE) {
 		ret = _osd_req_finalize_attr_page(or);
+		if (ret) {
+			OSD_DEBUG("_osd_req_finalize_attr_page failed\n");
+			return ret;
+		}
 	} else {
 		/* TODO: I think that for the GET_ATTR command these 2 should
 		 * be reversed to keep them in execution order (for embeded
-- 
1.6.6

