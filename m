From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 1/4] libosd: Fix bug in attr_page handling
Date: Tue, 19 Oct 2010 14:20:31 +0200
Message-ID: <1287490831-23923-1-git-send-email-bharrosh@panasas.com>
References: <4CBD8CAB.2030207@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:43606 "HELO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758464Ab0JSMVg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Oct 2010 08:21:36 -0400
In-Reply-To: <4CBD8CAB.2030207@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, John Chandy <john.chandy@uconn.edu>, open-osd <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>

The _osd_req_finalize_attr_page was off by a mile, when trying to
append the enc_get_attr segment instead of the proper set_attr segment.

Also properly support when we don't have any attribute to set while
getting a full page. And when clearing an attribute by setting it's
size to zero.

Reported-by: John Chandy <john.chandy@uconn.edu>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index e88bbdd..771ab12 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -1218,17 +1218,18 @@ int osd_req_add_get_attr_page(struct osd_request *or,
 	or->get_attr.buff = attar_page;
 	or->get_attr.total_bytes = max_page_len;
 
-	or->set_attr.buff = set_one_attr->val_ptr;
-	or->set_attr.total_bytes = set_one_attr->len;
-
 	cdbh->attrs_page.get_attr_page = cpu_to_be32(page_id);
 	cdbh->attrs_page.get_attr_alloc_length = cpu_to_be32(max_page_len);
-	/* ocdb->attrs_page.get_attr_offset; */
+
+	if (!set_one_attr || !set_one_attr->attr_page)
+		return 0; /* The set is optional */
+
+	or->set_attr.buff = set_one_attr->val_ptr;
+	or->set_attr.total_bytes = set_one_attr->len;
 
 	cdbh->attrs_page.set_attr_page = cpu_to_be32(set_one_attr->attr_page);
 	cdbh->attrs_page.set_attr_id = cpu_to_be32(set_one_attr->attr_id);
 	cdbh->attrs_page.set_attr_length = cpu_to_be32(set_one_attr->len);
-	/* ocdb->attrs_page.set_attr_offset; */
 	return 0;
 }
 EXPORT_SYMBOL(osd_req_add_get_attr_page);
@@ -1248,11 +1249,14 @@ static int _osd_req_finalize_attr_page(struct osd_request *or)
 	if (ret)
 		return ret;
 
+	if (or->set_attr.total_bytes == 0)
+		return 0;
+
 	/* set one value */
 	cdbh->attrs_page.set_attr_offset =
 		osd_req_encode_offset(or, or->out.total_bytes, &out_padding);
 
-	ret = _req_append_segment(or, out_padding, &or->enc_get_attr, NULL,
+	ret = _req_append_segment(or, out_padding, &or->set_attr, NULL,
 				  &or->out);
 	return ret;
 }
-- 
1.7.2.3

