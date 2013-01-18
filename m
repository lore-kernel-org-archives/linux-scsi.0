From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH RFC 9/9] [SCSI] Streamline detection of FM/EOM/ILI status
Date: Fri, 18 Jan 2013 11:27:14 -0500
Message-ID: <1358526434-1173-10-git-send-email-emilne@redhat.com>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab3ARQ1U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jan 2013 11:27:20 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0IGRJdK014950
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jan 2013 11:27:20 -0500
Received: from emilne.csb (dhcp-186-175.bos.redhat.com [10.16.186.175])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r0IGRFnM026564
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jan 2013 11:27:19 -0500
In-Reply-To: <1358526434-1173-1-git-send-email-emilne@redhat.com>
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
 drivers/scsi/scsi_error.c | 13 +++++++++++++
 include/scsi/scsi_eh.h    |  3 +++
 2 files changed, 16 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 3aa8706..c6344ef 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -332,6 +332,10 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
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
@@ -347,6 +351,7 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		    (scmd->sense_buffer[11] & 0xe0))
 			return SUCCESS;
 	}
+#endif
 
 	switch (sshdr.sense_key) {
 	case NO_SENSE:
@@ -2192,6 +2197,11 @@ int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 				    ((sense_buffer[desc_pos + 4] & 0x01) != 0))
 					sshdr->ua_queue_overflow = 1;
 
+				if ((desc_type == 0x04) && (desc_len >= 4) &&
+				    (addl_len >= 2) &&
+				    ((sense_buffer[desc_pos + 3] & 0xe0) != 0))
+					sshdr->fm_eom_ili = 1;
+
 				if (addl_len > (desc_len - 2))
 					addl_len = desc_len - 2;
 
@@ -2205,6 +2215,9 @@ int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 		 * fixed format
 		 */
 		if (sb_len > 2) {
+#ifdef CONFIG_SCSI_ENHANCED_UA
+			sshdr->fm_eom_ili = ((sense_buffer[2] & 0xe0) != 0);
+#endif
 			sshdr->overflow = ((sense_buffer[2] & 0x10) != 0);
 			sshdr->sense_key = (sense_buffer[2] & 0xf);
 		}
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index dc6dcfe..136dc71 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -28,6 +28,9 @@ struct scsi_sense_hdr {		/* See SPC-3 section 4.5 */
 	unsigned int overflow:1;	/* sense data overflow */
 #ifdef CONFIG_SCSI_ENHANCED_UA
 	unsigned int ua_queue_overflow:1;	/* UA info lost by device */
+
+	unsigned int fm_eom_ili:1;	/* filemark, end of medium, or
+					   incorrect length indicator set */
 #endif
 };
 
-- 
1.7.11.7

