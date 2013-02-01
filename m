From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH v2 8/8] [SCSI] Streamline detection of FM/EOM/ILI status
Date: Fri,  1 Feb 2013 12:53:15 -0500
Message-ID: <1359741195-2641-9-git-send-email-emilne@redhat.com>
References: <1359741195-2641-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757278Ab3BARxU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Feb 2013 12:53:20 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r11HrKPD000905
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 1 Feb 2013 12:53:20 -0500
Received: from emilne.csb (dhcp-186-175.bos.redhat.com [10.16.186.175])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r11HrGRl011917
	for <linux-scsi@vger.kernel.org>; Fri, 1 Feb 2013 12:53:20 -0500
In-Reply-To: <1359741195-2641-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

Avoid duplicate tests when examining sense data for FM/EOM/ILI
bits.  Moved extraction of status to scsi_normalize_sense() if
the config option CONFIG_SCSI_ENHANCED_UA is used, because
descriptor format sense data is already being parsed there.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_error.c | 16 +++++++++++++++-
 include/scsi/scsi_eh.h    |  3 +++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d0b5a26..3ad001e 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -340,6 +340,10 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 	 * Previous logic looked for FILEMARK, EOM or ILI which are
 	 * mainly associated with tapes and returned SUCCESS.
 	 */
+#ifdef CONFIG_SCSI_ENHANCED_UA
+	if (sshdr.fm_eom_ili)
+		return SUCCESS;
+#else
 	if (sshdr.response_code == 0x70) {
 		/* fixed format */
 		if (scmd->sense_buffer[2] & 0xe0)
@@ -355,6 +359,7 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		    (scmd->sense_buffer[11] & 0xe0))
 			return SUCCESS;
 	}
+#endif
 
 	switch (sshdr.sense_key) {
 	case NO_SENSE:
@@ -2198,6 +2203,11 @@ int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 				    ((sense_buffer[desc_pos + 4] & 0x01) != 0))
 					sshdr->ua_queue_overflow = 1;
 
+				if ((desc_type == 0x04) && (desc_len >= 4) &&
+				    (addl_len >= 2) &&
+				    ((sense_buffer[desc_pos + 3] & 0xe0) != 0))
+					sshdr->fm_eom_ili = 1;
+
 				if (addl_len > (desc_len - 2))
 					addl_len = desc_len - 2;
 
@@ -2210,8 +2220,12 @@ int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 		/*
 		 * fixed format
 		 */
-		if (sb_len > 2)
+		if (sb_len > 2) {
+#ifdef CONFIG_SCSI_ENHANCED_UA
+			sshdr->fm_eom_ili = ((sense_buffer[2] & 0xe0) != 0);
+#endif
 			sshdr->sense_key = (sense_buffer[2] & 0xf);
+		}
 		if (sb_len > 7) {
 			sb_len = (sb_len < (sense_buffer[7] + 8)) ?
 					 sb_len : (sense_buffer[7] + 8);
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index b6c4d3d..d53a1d2 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -27,6 +27,9 @@ struct scsi_sense_hdr {		/* See SPC-3 section 4.5 */
 	u8 additional_length;	/* always 0 for fixed sense format */
 #ifdef CONFIG_SCSI_ENHANCED_UA
 	unsigned int ua_queue_overflow:1;	/* UA info lost by device */
+
+	unsigned int fm_eom_ili:1;	/* filemark, end of medium, or
+					   incorrect length indicator set */
 #endif
 };
 
-- 
1.7.11.7

