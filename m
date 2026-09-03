Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCBE39D3D0;
	Thu,  3 Sep 2026 03:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407003; cv=none; b=o/Sd8vERKwPogWdcQmoqFJq19IPBgMmqyILl2f18jzZhkjpjwg0os2WRHSVW9Cqv8CAp1G71XhtQ5Mk46kkza2wDXdxhTGRPgPqikjan590BNhfE0kB3a+pSHMLpoevZqYF6oz3o+uXTQYplnng2Cr25FiG+5RbxTsv6cjNv9zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407003; c=relaxed/simple;
	bh=UEkksSlxyFrOyMXmYUcci/0laVXNLurv0stVKLOhYPY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G6yD4XBrwHYtYairq3z6ybAi3uhdTltkboqghb3kgLkalv8VL06J056BuT5UJl85nvIY8jM2gUdX6b98PfBeC6WpwRlRgWA3z8qCmv5M7Q6quBj+uSHJvAg6h86L4MAtnglt5TfXFC9i2lJZ0jZEUje8RnI94qfI2UJLAEusA8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f9NbuV/x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f9NbuV/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A9F1F00A3E;
	Thu,  3 Sep 2026 03:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788406995;
	bh=7EDmrAkNKY6icF6hbFNSI+9lqeNwbzVCdBaXNPEH1Gc=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=f9NbuV/xwHtXW81q00SWx7UDLuaXDw+hD10vsPPSFF6k2o+WopSliuhnnlMkJGIg2
	 w4AMuCnF4zcpCJfnhKeyzgXAga2dQHQG2wfDpbUJIb8qKh8N4+Z5d/WM9wIKox657c
	 /mMfRvwmX31qTYXnqFJsOSmrLz2vmht+jFRMSWJ9qPVgxptxMM5iL4vlF+UdCrvK/R
	 bDDEAwGLJOQSEU2Z+pAKIS2hsbnmrVurVOX+hLjE9RFpall7rp46SzUrDQFJPGGnwg
	 6yTe8Lwxwkg2H4RDHLW/f7jy429fm0dmsRYCTK82dokZIyUqygGF34XLxzNZOF/V4g
	 HL2LCxToKEjbA==
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
Subject: [PATCH v2 33/40] scsi: storvsc: use 16-bits defined sense codes
Date: Thu,  3 Sep 2026 12:41:54 +0900
Message-ID: <20260903034201.112211-34-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903034201.112211-1-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the storvsc driver to use the 16-bits sense_code field of
struct scsi_sense_hdr and replace all hard-coded additional sense codes
and additional sense code qualifiers with the enum values defined in
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
being processed are easier to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/storvsc_drv.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index ef3cd3bc7390..625db97d1a03 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1016,7 +1016,7 @@ static int storvsc_channel_init(struct hv_device *device, bool is_fc)
 static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 				struct scsi_cmnd *scmnd,
 				struct Scsi_Host *host,
-				u8 asc, u8 ascq)
+				struct scsi_sense_hdr *sshdr)
 {
 	struct storvsc_scan_work *wrk;
 	void (*process_err_fn)(struct work_struct *work);
@@ -1033,7 +1033,7 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 	case SRB_STATUS_DATA_OVERRUN:
 		if (vm_srb->srb_status & SRB_STATUS_AUTOSENSE_VALID) {
 			/* Check for capacity change */
-			if ((asc == 0x2a) && (ascq == 0x9)) {
+			if (sshdr->sense_code == CAPACITY_DATA_HAS_CHANGED) {
 				process_err_fn = storvsc_device_scan;
 				/* Retry the I/O that triggered this. */
 				set_host_byte(scmnd, DID_REQUEUE);
@@ -1049,8 +1049,12 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 			 * want scsi_report_sense() to output a message
 			 * that a sysadmin wouldn't know what to do with.
 			 */
-			if ((asc == 0x3f) && (ascq != 0x03) &&
-					(ascq != 0x0e)) {
+			if (scsi_sense_asc(sshdr) ==
+			    ASC_TARGET_OPERATING_CONDITIONS_HAVE_CHANGED &&
+			    sshdr->sense_code !=
+			    INQUIRY_DATA_HAS_CHANGED &&
+			    sshdr->sense_code !=
+			    REPORTED_LUNS_DATA_HAS_CHANGED) {
 				process_err_fn = storvsc_device_scan;
 				set_host_byte(scmnd, DID_REQUEUE);
 				goto do_work;
@@ -1141,8 +1145,7 @@ static void storvsc_command_completion(struct storvsc_cmd_request *cmd_request,
 	}
 
 	if (vm_srb->srb_status != SRB_STATUS_SUCCESS) {
-		storvsc_handle_error(vm_srb, scmnd, host, sense_hdr.asc,
-					 sense_hdr.ascq);
+		storvsc_handle_error(vm_srb, scmnd, host, &sense_hdr);
 		/*
 		 * The Windows driver set data_transfer_length on
 		 * SRB_STATUS_DATA_OVERRUN. On other errors, this value
-- 
2.55.0

