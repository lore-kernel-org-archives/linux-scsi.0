From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] libosd: check for kzalloc() failure
Date: Wed, 30 Jan 2013 10:06:02 +0300
Message-ID: <20130130070602.GB12396@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32907 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab3A3HGR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jan 2013 02:06:17 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Benny Halevy <bhalevy@tonian.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

There wasn't any error handling for this kzalloc().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index c06b8e5..d8293f2 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -144,6 +144,10 @@ static int _osd_get_print_system_info(struct osd_dev *od,
 	odi->osdname_len = get_attrs[a].len;
 	/* Avoid NULL for memcmp optimization 0-length is good enough */
 	odi->osdname = kzalloc(odi->osdname_len + 1, GFP_KERNEL);
+	if (!odi->osdname) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	if (odi->osdname_len)
 		memcpy(odi->osdname, get_attrs[a].val_ptr, odi->osdname_len);
 	OSD_INFO("OSD_NAME               [%s]\n", odi->osdname);
