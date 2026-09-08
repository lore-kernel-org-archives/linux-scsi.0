Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3AE4A3F28;
	Tue,  8 Sep 2026 09:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788858245; cv=none; b=eDqW0l6xVtiSdKO13bjSkbRqxzeMXn3w8SY7G8blfGEYxPguIdVLVntqZiXdCBY1vsUmhv9atI4CxMw1TwpmtXodBijnrxzQqESA8pqXWLdiR5NDSTTt0SJNVdhy35J3I+p/7+xG/1rLSk5jjS4vxVd8itHGJURc4yVIToyeRgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788858245; c=relaxed/simple;
	bh=joLCjzHn3ikz6HmNvhWW/dtIMHHwFaPNS6XZenq2WLA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmjbdIONUXcH2d3SHp168F50CkwgxPk+u7d/hylCS/rSvJkignqzkx2QjVw/GWqmJUfEJtEtpcvjr17FY+YR0a2E9IYUH2BfLjai3OdHaQA/2AfNOY8pCRLqtqwZmQa5CVHOXAB0zrAMMSY4cNDfQXsTxImnYB6TQ82ZpNvilcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ot7lskSe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ot7lskSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929701F00A3E;
	Tue,  8 Sep 2026 09:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788858241;
	bh=44k9DnIBiEpKvzs5dlZ/fhiUm2+JDQ3EXESivj4tZ6o=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=ot7lskSeTF4Yu+M9R1qmMKgsEgQw5pdr0H8nK8Y9yimZzirPH5LJpC436VgJ2uA9c
	 SSrsILK7fCqmy1cweIsphch2yBdmI9UT9Zt2cL5+qkZPwlBRdTi1Nr8+5UjQE0HFl2
	 ERsvBJzEyUXzYtCDKvqSsx2hnnfiWahux4WzKk4zY35I7lDTCA+dRepKg0LDu++SvQ
	 aWitmhWEDdw3aWiBAjHYkKztMRnOrD8H3PjjyQ/0kVIofjVAV01k5IaG/fGbmej1zb
	 GNz1lvHkVXZrBhg51aggaMvk9IAqG2PskiitA8CmIfdjKDFs/r9LuHImQD9hqUgnCz
	 qGrH8rE9rurMw==
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
Subject: [PATCH v6 23/40] scsi: smartpqi: use 16-bits defined sense codes
Date: Tue,  8 Sep 2026 18:02:51 +0900
Message-ID: <20260908090308.1085097-24-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908090308.1085097-1-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
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
Acked-by: Don Brace <don.brace@microchip.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
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

