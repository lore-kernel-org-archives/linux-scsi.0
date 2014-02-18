From: Dave Jones <davej@redhat.com>
Subject: suspicious self-assignment in lpfc
Date: Tue, 18 Feb 2014 12:42:11 -0500
Message-ID: <20140218174211.GA17778@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571AbaBRRmV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Feb 2014 12:42:21 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.smart@emulex.com

Looking through coverity reports, and it flagged lpfc_read_fcf_conn_tbl()
due to the following patch..

commit df0d085fdd2e7c39d1249c2d4ad6b3e176efb60c
Author: James Smart <james.smart@emulex.com>
Date:   Fri May 31 17:05:08 2013 -0400

    [SCSI] lpfc 8.3.40: Fixed FCoE connection list vlan identifier and add FCF list debug
    
    Signed-off-by: James Smart <james.smart@emulex.com>
    Signed-off-by: James Bottomley <JBottomley@Parallels.com>

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 0f6e2548f35d..0309cc15aad6 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -6158,12 +6158,44 @@ lpfc_read_fcf_conn_tbl(struct lpfc_hba *phba,
                memcpy(&conn_entry->conn_rec, &conn_rec[i],
                        sizeof(struct lpfc_fcf_conn_rec));
                conn_entry->conn_rec.vlan_tag =
-                       le16_to_cpu(conn_entry->conn_rec.vlan_tag) & 0xFFF;
+                       conn_entry->conn_rec.vlan_tag;
                conn_entry->conn_rec.flags =
-                       le16_to_cpu(conn_entry->conn_rec.flags);
+                       conn_entry->conn_rec.flags;
                list_add_tail(&conn_entry->list,
                        &phba->fcf_conn_rec_list);


Now that we're not caring about endianness, those two assignments are redundant.
I gather this has passed testing, because surely someone would have complained by now,
but can they be removed, or should they be doing something else entirely ?

	Dave

