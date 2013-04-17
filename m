From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] libosd: remover duplicate __bitwise annotation
Date: Wed, 17 Apr 2013 10:19:05 +0300
Message-ID: <20130417071905.GE7923@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44765 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887Ab3DQHTi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Apr 2013 03:19:38 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Benny Halevy <bhalevy@tonian.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

__be32 is already a __bitwise type so we don't need the second __bitwise
here.  It causes a Sparse error:
include/scsi/osd_protocol.h:110:26: error: invalid modifier

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/include/scsi/osd_protocol.h b/include/scsi/osd_protocol.h
index a6026da..25ac628 100644
--- a/include/scsi/osd_protocol.h
+++ b/include/scsi/osd_protocol.h
@@ -107,7 +107,7 @@ enum osd_attributes_mode {
  *		int exponent: 04;
  *	}
  */
-typedef __be32 __bitwise osd_cdb_offset;
+typedef __be32 osd_cdb_offset;
 
 enum {
 	OSD_OFFSET_UNUSED = 0xFFFFFFFF,
