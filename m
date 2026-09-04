Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC322D0C62;
	Fri,  4 Sep 2026 00:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788481659; cv=none; b=YjMsQmVQggzDGntKI22uYwrnS7/f2ENar2eDs3CNBuvV7JFyh+BCWgfxKudHNPsBOirCF6Vq4btj0sKsiwBePFR30uGuxhdW9AQLRwpXm07KZ4VBAjwA3VsnvNJiaddVIK/5SS9XQbZ1aEyd90r+BkOgsQf/1s8sEMW5MzUcDvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788481659; c=relaxed/simple;
	bh=NTKEZIJWPLPWoIQ0QSJ5AVkd02EfznGvCXmP4ER42uU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=je2HLHgWKZwnc/BZPyaxVaWLjSGgCpfffJPMMAInA0F9o2TZxMPSgHkpAqK31FsbPdWkFE/8JYlfsT1kEuQGxoUfwu+UYOgmjgeupKsDHZL5k80sVxJOwFamLH0TKFKsa3N6vw5t0O73Rv8Mc0SYNfelSKrHExumu1p9Ej5AlE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jtyXF8gu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jtyXF8gu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729181F000E9;
	Fri,  4 Sep 2026 00:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788481657;
	bh=g2xxdO03kqVG4q6+qdwC955GVUQYqVcHMezZs3jk1UA=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=jtyXF8gu7XVKCzFgGpQi28g5/Ol6slLb2m10urGguPJPRGbvijIkts146SLHmTGkJ
	 MaOYCcGWC35wJN2QM4IPJjob0vt6vPpgpUeGGj3G/vP/AFgf9TacAFyLjfor9Moe6q
	 sJ12diDC8koorA7Tkcynac9+cjoww5BViCX0gvIfn2qQRm3jH7W1MGuX/5l5VcxASP
	 e6eWElDuqisLvLkBENjPxSdHIvN1Ae60L3JncBmDjHgviRGhVdB3mC4J8xujxzn1eU
	 KfL3NnmDkgkPjNSjf2I9Wyc77YyplUzIW81FjLF0kRcVSpxcMFM7xzt+lcEUthUlEU
	 u/JbGn4UkLFdA==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-s390@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH v3 23/40] scsi: smartpqi: use 16-bits defined sense codes
Date: Fri,  4 Sep 2026 09:26:27 +0900
Message-ID: <20260904002644.157668-24-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904002644.157668-1-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the smartpqi driver to use the 16-bits sense_code field of
struct scsi_sense_hdr and replace all hard-coded additional sense codes
and additional sense code qualifiers with the enum values defined in
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
being processed are easier to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 31 ++++++++++++++++-----------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 140e8a6addbe..d8d0fe915805 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -3249,15 +3249,15 @@ static void pqi_process_raid_io_error(struct pqi_io_request *io_request)
 			sense_data_length = sizeof(error_info->data);
 
 		if (scsi_status == SAM_STAT_CHECK_CONDITION &&
-			scsi_normalize_sense(error_info->data,
-				sense_data_length, &sshdr) &&
-				sshdr.sense_key == HARDWARE_ERROR &&
-				sshdr.asc == 0x3e) {
+		    scsi_normalize_sense(error_info->data,
+					 sense_data_length, &sshdr) &&
+		    sshdr.sense_key == HARDWARE_ERROR &&
+		    scsi_sense_asc(&sshdr) == ASC_LU_HAS_NOT_SELF_CONFIGURED_YET) {
 			struct pqi_ctrl_info *ctrl_info = shost_to_hba(scmd->device->host);
 			struct pqi_scsi_dev *device = scmd->device->hostdata;
 
-			switch (sshdr.ascq) {
-			case 0x1: /* LOGICAL UNIT FAILURE */
+			switch (sshdr.sense_code) {
+			case LU_FAILURE:
 				if (printk_ratelimit())
 					scmd_printk(KERN_ERR, scmd, "received 'logical unit failure' from controller for scsi %d:%d:%d:%d\n",
 						ctrl_info->scsi_host->host_no, device->bus, device->target, device->lun);
@@ -3265,10 +3265,15 @@ static void pqi_process_raid_io_error(struct pqi_io_request *io_request)
 				host_byte = DID_NO_CONNECT;
 				break;
 
-			default: /* See http://www.t10.org/lists/asc-num.htm#ASC_3E */
+			default:
+				/* include/scsi/scsi_sense.h */
 				if (printk_ratelimit())
-					scmd_printk(KERN_ERR, scmd, "received unhandled error %d from controller for scsi %d:%d:%d:%d\n",
-						sshdr.ascq, ctrl_info->scsi_host->host_no, device->bus, device->target, device->lun);
+					scmd_printk(KERN_ERR, scmd,
+						"received unhandled error %d from controller for scsi %d:%d:%d:%d\n",
+						scsi_sense_ascq(&sshdr),
+						ctrl_info->scsi_host->host_no,
+						device->bus, device->target,
+						device->lun);
 				break;
 			}
 		}
@@ -3286,11 +3291,11 @@ static void pqi_process_raid_io_error(struct pqi_io_request *io_request)
 	    sense_data_length &&
 	    scsi_normalize_sense(error_info->data, sense_data_length, &sshdr) &&
 	    sshdr.sense_key == ILLEGAL_REQUEST &&
-	    sshdr.asc == 0x26 &&
-	    sshdr.ascq == 0x0) {
+	    sshdr.sense_code == INVALID_FIELD_IN_PARAMETER_LIST) {
 		host_byte = DID_NO_CONNECT;
 		pqi_take_device_offline(scmd->device, "AIO");
-		scsi_build_sense_buffer(0, scmd->sense_buffer, HARDWARE_ERROR, 0x3e, 0x1);
+		scsi_set_sense_buffer(0, scmd->sense_buffer, HARDWARE_ERROR,
+				      LU_FAILURE);
 	}
 
 	scmd->result = scsi_status;
@@ -3380,7 +3385,7 @@ static void pqi_process_aio_io_error(struct pqi_io_request *io_request)
 	}
 
 	if (device_offline && sense_data_length == 0)
-		scsi_build_sense(scmd, 0, HARDWARE_ERROR, 0x3e, 0x1);
+		scsi_set_sense(scmd, 0, HARDWARE_ERROR, LU_FAILURE);
 
 	scmd->result = scsi_status;
 	set_host_byte(scmd, host_byte);
-- 
2.55.0

