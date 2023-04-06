Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A12A8C77B70
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Apr 2023 11:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbjDFLzE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Apr 2023 07:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236814AbjDFLym (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2023 07:54:42 -0400
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1847E3AF;
        Thu,  6 Apr 2023 04:51:22 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id s20so20108055ljp.7;
        Thu, 06 Apr 2023 04:51:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680781562;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jSxhZ/HdAzehwTgE/T8mjdk0t8X1zWnlluo39/CKDrU=;
        b=h0G3sV7nb6TIqQ+09dVHWrVV6cvoFCiCpv7QnS5Yj+WiqG1qApm7ldu0xZOiVtkpG6
         FQmmaAIy+9ARWcOQmef7IvxwE9Cq2TawRtjp+mFK1CVHMoqm2ZiLckhPbkYAXJxNso5E
         mh+0LPB7lvaiDkcod5pZ4aifJ2dlKLE1yrzhPl5e05SjM0zmho3g4AfUWf/2cIrDhp3l
         1vC9AC/3vLrdgSitp728//OtIjPTTj8nHC6ADfztNqVubxHcL2FL5zmDKIj/s1xrgX3N
         P6lxF3VXuq/uLwe3DWXEtbEYQCyzzoVkeU+R05ex9/afrj4PMnD7T6L7TkQcMSChxdkQ
         vuBw==
X-Gm-Message-State: AAQBX9eEPB0UgEPSxSXZnI1FK03+JALcwrqvDdmDjHx0MUujs1o+tlhW
        tQZqj85fcOPrb/9mJyVyPkkztsbkduvv3g==
X-Google-Smtp-Source: AKy350aDpKeQZYCz98aJ6iZGZYUZ2q53DQmtr9WysI0TQLkDGfFGYYnLSAvK0kqezrjWo4mMEAa3Fg==
X-Received: by 2002:a2e:b0ce:0:b0:293:5164:4f2b with SMTP id g14-20020a2eb0ce000000b0029351644f2bmr2678664ljl.8.1680781561673;
        Thu, 06 Apr 2023 04:46:01 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id x25-20020a2e9c99000000b0029bd1e3f9easm253964lji.32.2023.04.06.04.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 04:46:01 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 6C04369A; Thu,  6 Apr 2023 13:46:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680781560; bh=1rCYlLuSLfr9P5cuQ0ZoGYtYynJ1G0MGLAZ4aFy98fI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MffQSVGdCRjPQ612/jTMNwFlT0cLCv/Wv4JvmBlcJn3QFoPb3zZUw6TNiQPu8Mic8
         GoW8eHx0TXQs7XHQlshDlx4UvfH8OsqVyU5NP5ar/z23/XrizwZL/SjzBLEIZ/06xg
         U/okM46Pi6CYQ2xTKeEo7F6Y6LYr3lMWTL7AwoJQ=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id C4D1F11C6;
        Thu,  6 Apr 2023 13:33:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680780811; bh=1rCYlLuSLfr9P5cuQ0ZoGYtYynJ1G0MGLAZ4aFy98fI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fuq11AMK0TVLFe2g5kAwVqvgYz6YyRlYxSd891vFrImzn7H3E2qY6rANdI2d1wCxF
         7+Oeq5TfaWwYFlbHpdS1p7fs85bMGLlN+oWH80zdKOJ/oA2zVSroA4d3yRKWxFmv6z
         SBPAFBsspy50mYkHYc9UG3IfueC+55fEJfs5c4RE=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <dlemoal@fastmail.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v6 19/19] ata: libata: handle completion of CDL commands using policy 0xD
Date:   Thu,  6 Apr 2023 13:32:48 +0200
Message-Id: <20230406113252.41211-20-nks@flawful.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113252.41211-1-nks@flawful.org>
References: <20230406113252.41211-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

A CDL timeout for policy 0xF is defined as a NCQ error, just with a CDL
specific sk/asc/ascq in the sense data. Therefore, the existing code in
libata does not need to be modified to handle a policy 0xF CDL timeout.

For Command Duration Limits policy 0xD:
The device shall complete the command without error with the additional
sense code set to DATA CURRENTLY UNAVAILABLE.

Since a CDL timeout for policy 0xD is not an error, we cannot use the
NCQ Command Error log (10h).

Instead, we need to read the Sense Data for Successful NCQ Commands
log (0Fh).

In the success case, just like in the error case, we cannot simply read
a log page from the interrupt handler itself, since reading a log page
involves sending a READ LOG DMA EXT or READ LOG EXT command.

Therefore, we add a new EH action ATA_EH_GET_SUCCESS_SENSE.
When a command completes without error, and when the ATA_SENSE bit
is set, this new action is set as pending, and EH is scheduled.

This way, similar to the NCQ error case, the log page will be read
from EH context.

An alternative would have been to add a new kthread or workqueue to
handle this. However, extending EH can be done with minimal changes
and avoids the need to synchronize a new kthread/workqueue with EH.

Co-developed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-core.c |  88 +++++++++++++++++++++++++++++++-
 drivers/ata/libata-eh.c   | 105 +++++++++++++++++++++++++++++++++++++-
 drivers/ata/libata-sata.c |  92 +++++++++++++++++++++++++++++++++
 include/linux/ata.h       |   3 ++
 include/linux/libata.h    |  11 +++-
 5 files changed, 295 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c68e7b684a87..634b987c6518 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -677,8 +677,12 @@ static inline void ata_set_tf_cdl(struct ata_queued_cmd *qc, int cdl)
 	else
 		tf->feature |= cdl;
 
-	/* Mark this command as having a CDL */
-	qc->flags |= ATA_QCFLAG_HAS_CDL;
+	/*
+	 * Mark this command as having a CDL and request the result
+	 * task file so that we can inspect the sense data available
+	 * bit on completion.
+	 */
+	qc->flags |= ATA_QCFLAG_HAS_CDL | ATA_QCFLAG_RESULT_TF;
 }
 
 /**
@@ -2424,6 +2428,24 @@ static void ata_dev_config_cdl(struct ata_device *dev)
 		ata_dev_warn(dev,
 			"Command duration guideline is not supported\n");
 
+	/*
+	 * We must have support for the sense data for successful NCQ commands
+	 * log indicated by the successful NCQ command sense data supported bit.
+	 */
+	val = get_unaligned_le64(&ap->sector_buf[8]);
+	if (!(val & BIT_ULL(63)) || !(val & BIT_ULL(47))) {
+		ata_dev_warn(dev,
+			"CDL supported but Successful NCQ Command Sense Data is not supported\n");
+		goto not_supported;
+	}
+
+	/* Without NCQ autosense, the successful NCQ commands log is useless. */
+	if (!ata_id_has_ncq_autosense(dev->id)) {
+		ata_dev_warn(dev,
+			"CDL supported but NCQ autosense is not supported\n");
+		goto not_supported;
+	}
+
 	/*
 	 * If CDL is marked as enabled, make sure the feature is enabled too.
 	 * Conversely, if CDL is disabled, make sure the feature is turned off.
@@ -2458,6 +2480,35 @@ static void ata_dev_config_cdl(struct ata_device *dev)
 		}
 	}
 
+	/*
+	 * While CDL itself has to be enabled using sysfs, CDL requires that
+	 * sense data for successful NCQ commands is enabled to work properly.
+	 * Just like ata_dev_config_sense_reporting(), enable it unconditionally
+	 * if supported.
+	 */
+	if (!(val & BIT_ULL(63)) || !(val & BIT_ULL(18))) {
+		err_mask = ata_dev_set_feature(dev,
+					SETFEATURE_SENSE_DATA_SUCC_NCQ, 0x1);
+		if (err_mask) {
+			ata_dev_warn(dev,
+				     "failed to enable Sense Data for successful NCQ commands, Emask 0x%x\n",
+				     err_mask);
+			goto not_supported;
+		}
+	}
+
+	/*
+	 * Allocate a buffer to handle reading the sense data for successful
+	 * NCQ Commands log page for commands using a CDL with one of the limit
+	 * policy set to 0xD (successful completion with sense data available
+	 * bit set).
+	 */
+	if (!ap->ncq_sense_buf) {
+		ap->ncq_sense_buf = kmalloc(ATA_LOG_SENSE_NCQ_SIZE, GFP_KERNEL);
+		if (!ap->ncq_sense_buf)
+			goto not_supported;
+	}
+
 	/*
 	 * Command duration limits is supported: cache the CDL log page 18h
 	 * (command duration descriptors).
@@ -2475,6 +2526,8 @@ static void ata_dev_config_cdl(struct ata_device *dev)
 
 not_supported:
 	dev->flags &= ~(ATA_DFLAG_CDL | ATA_DFLAG_CDL_ENABLED);
+	kfree(ap->ncq_sense_buf);
+	ap->ncq_sense_buf = NULL;
 }
 
 static int ata_dev_config_lba(struct ata_device *dev)
@@ -4878,6 +4931,36 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
 			fill_result_tf(qc);
 
 		trace_ata_qc_complete_done(qc);
+
+		/*
+		 * For CDL commands that completed without an error, check if
+		 * we have sense data (ATA_SENSE is set). If we do, then the
+		 * command may have been aborted by the device due to a limit
+		 * timeout using the policy 0xD. For these commands, invoke EH
+		 * to get the command sense data.
+		 */
+		if (qc->result_tf.status & ATA_SENSE &&
+		    ((ata_is_ncq(qc->tf.protocol) &&
+		      dev->flags & ATA_DFLAG_CDL_ENABLED) ||
+		     (!(ata_is_ncq(qc->tf.protocol) &&
+			ata_id_sense_reporting_enabled(dev->id))))) {
+			/*
+			 * Tell SCSI EH to not overwrite scmd->result even if
+			 * this command is finished with result SAM_STAT_GOOD.
+			 */
+			qc->scsicmd->flags |= SCMD_FORCE_EH_SUCCESS;
+			qc->flags |= ATA_QCFLAG_EH_SUCCESS_CMD;
+			ehi->dev_action[dev->devno] |= ATA_EH_GET_SUCCESS_SENSE;
+
+			/*
+			 * set pending so that ata_qc_schedule_eh() does not
+			 * trigger fast drain, and freeze the port.
+			 */
+			ap->pflags |= ATA_PFLAG_EH_PENDING;
+			ata_qc_schedule_eh(qc);
+			return;
+		}
+
 		/* Some commands need post-processing after successful
 		 * completion.
 		 */
@@ -5510,6 +5593,7 @@ static void ata_host_release(struct kref *kref)
 
 		kfree(ap->pmp_link);
 		kfree(ap->slave_link);
+		kfree(ap->ncq_sense_buf);
 		kfree(ap);
 		host->ports[i] = NULL;
 	}
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 598ae07195b6..05af292eb8ce 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1917,6 +1917,99 @@ static inline bool ata_eh_quiet(struct ata_queued_cmd *qc)
 	return qc->flags & ATA_QCFLAG_QUIET;
 }
 
+static int ata_eh_read_sense_success_non_ncq(struct ata_link *link)
+{
+	struct ata_port *ap = link->ap;
+	struct ata_queued_cmd *qc;
+
+	qc = __ata_qc_from_tag(ap, link->active_tag);
+	if (!qc)
+		return -EIO;
+
+	if (!(qc->flags & ATA_QCFLAG_EH) ||
+	    !(qc->flags & ATA_QCFLAG_EH_SUCCESS_CMD) ||
+	    qc->err_mask)
+		return -EIO;
+
+	if (!ata_eh_request_sense(qc))
+		return -EIO;
+
+	/*
+	 * If we have sense data, call scsi_check_sense() in order to set the
+	 * correct SCSI ML byte (if any). No point in checking the return value,
+	 * since the command has already completed successfully.
+	 */
+	scsi_check_sense(qc->scsicmd);
+
+	return 0;
+}
+
+static void ata_eh_get_success_sense(struct ata_link *link)
+{
+	struct ata_eh_context *ehc = &link->eh_context;
+	struct ata_device *dev = link->device;
+	struct ata_port *ap = link->ap;
+	struct ata_queued_cmd *qc;
+	int tag, ret = 0;
+
+	if (!(ehc->i.dev_action[dev->devno] & ATA_EH_GET_SUCCESS_SENSE))
+		return;
+
+	/* if frozen, we can't do much */
+	if (ata_port_is_frozen(ap)) {
+		ata_dev_warn(dev,
+			"successful sense data available but port frozen\n");
+		goto out;
+	}
+
+	/*
+	 * If the link has sactive set, then we have outstanding NCQ commands
+	 * and have to read the Successful NCQ Commands log to get the sense
+	 * data. Otherwise, we are dealing with a non-NCQ command and use
+	 * request sense ext command to retrieve the sense data.
+	 */
+	if (link->sactive)
+		ret = ata_eh_read_sense_success_ncq_log(link);
+	else
+		ret = ata_eh_read_sense_success_non_ncq(link);
+	if (ret)
+		goto out;
+
+	ata_eh_done(link, dev, ATA_EH_GET_SUCCESS_SENSE);
+	return;
+
+out:
+	/*
+	 * If we failed to get sense data for a successful command that ought to
+	 * have sense data, we cannot simply return BLK_STS_OK to user space.
+	 * This is because we can't know if the sense data that we couldn't get
+	 * was actually "DATA CURRENTLY UNAVAILABLE". Reporting such a command
+	 * as success to user space would result in a silent data corruption.
+	 * Thus, add a bogus ABORTED_COMMAND sense data to such commands, such
+	 * that SCSI will report these commands as BLK_STS_IOERR to user space.
+	 */
+	ata_qc_for_each_raw(ap, qc, tag) {
+		if (!(qc->flags & ATA_QCFLAG_EH) ||
+		    !(qc->flags & ATA_QCFLAG_EH_SUCCESS_CMD) ||
+		    qc->err_mask ||
+		    ata_dev_phys_link(qc->dev) != link)
+			continue;
+
+		/* We managed to get sense for this success command, skip. */
+		if (qc->flags & ATA_QCFLAG_SENSE_VALID)
+			continue;
+
+		/* This success command did not have any sense data, skip. */
+		if (!(qc->result_tf.status & ATA_SENSE))
+			continue;
+
+		/* This success command had sense data, but we failed to get. */
+		ata_scsi_set_sense(dev, qc->scsicmd, ABORTED_COMMAND, 0, 0);
+		qc->flags |= ATA_QCFLAG_SENSE_VALID;
+	}
+	ata_eh_done(link, dev, ATA_EH_GET_SUCCESS_SENSE);
+}
+
 /**
  *	ata_eh_link_autopsy - analyze error and determine recovery action
  *	@link: host link to perform autopsy on
@@ -1957,6 +2050,14 @@ static void ata_eh_link_autopsy(struct ata_link *link)
 	/* analyze NCQ failure */
 	ata_eh_analyze_ncq_error(link);
 
+	/*
+	 * Check if this was a successful command that simply needs sense data.
+	 * Since the sense data is not part of the completion, we need to fetch
+	 * it using an additional command. Since this can't be done from irq
+	 * context, the sense data for successful commands are fetched by EH.
+	 */
+	ata_eh_get_success_sense(link);
+
 	/* any real error trumps AC_ERR_OTHER */
 	if (ehc->i.err_mask & ~AC_ERR_OTHER)
 		ehc->i.err_mask &= ~AC_ERR_OTHER;
@@ -1966,6 +2067,7 @@ static void ata_eh_link_autopsy(struct ata_link *link)
 	ata_qc_for_each_raw(ap, qc, tag) {
 		if (!(qc->flags & ATA_QCFLAG_EH) ||
 		    qc->flags & ATA_QCFLAG_RETRY ||
+		    qc->flags & ATA_QCFLAG_EH_SUCCESS_CMD ||
 		    ata_dev_phys_link(qc->dev) != link)
 			continue;
 
@@ -3825,7 +3927,8 @@ void ata_eh_finish(struct ata_port *ap)
 			else
 				ata_eh_qc_complete(qc);
 		} else {
-			if (qc->flags & ATA_QCFLAG_SENSE_VALID) {
+			if (qc->flags & ATA_QCFLAG_SENSE_VALID ||
+			    qc->flags & ATA_QCFLAG_EH_SUCCESS_CMD) {
 				ata_eh_qc_complete(qc);
 			} else {
 				/* feed zero TF to sense generation */
diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index 57cb33060c9d..7de4d8901fac 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -11,7 +11,9 @@
 #include <linux/module.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
 #include <linux/libata.h>
+#include <asm/unaligned.h>
 
 #include "libata.h"
 #include "libata-transport.h"
@@ -1408,6 +1410,95 @@ static int ata_eh_read_log_10h(struct ata_device *dev,
 	return 0;
 }
 
+/**
+ *	ata_eh_read_sense_success_ncq_log - Read the sense data for successful
+ *					    NCQ commands log
+ *	@link: ATA link to get sense data for
+ *
+ *	Read the sense data for successful NCQ commands log page to obtain
+ *	sense data for all NCQ commands that completed successfully with
+ *	the sense data available bit set.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep).
+ *
+ *	RETURNS:
+ *	0 on success, -errno otherwise.
+ */
+int ata_eh_read_sense_success_ncq_log(struct ata_link *link)
+{
+	struct ata_device *dev = link->device;
+	struct ata_port *ap = dev->link->ap;
+	u8 *buf = ap->ncq_sense_buf;
+	struct ata_queued_cmd *qc;
+	unsigned int err_mask, tag;
+	u8 *sense, sk = 0, asc = 0, ascq = 0;
+	u64 sense_valid, val;
+	int ret = 0;
+
+	err_mask = ata_read_log_page(dev, ATA_LOG_SENSE_NCQ, 0, buf, 2);
+	if (err_mask) {
+		ata_dev_err(dev,
+			"Failed to read Sense Data for Successful NCQ Commands log\n");
+		return -EIO;
+	}
+
+	/* Check the log header */
+	val = get_unaligned_le64(&buf[0]);
+	if ((val & 0xffff) != 1 || ((val >> 16) & 0xff) != 0x0f) {
+		ata_dev_err(dev,
+			"Invalid Sense Data for Successful NCQ Commands log\n");
+		return -EIO;
+	}
+
+	sense_valid = (u64)buf[8] | ((u64)buf[9] << 8) |
+		((u64)buf[10] << 16) | ((u64)buf[11] << 24);
+
+	ata_qc_for_each_raw(ap, qc, tag) {
+		if (!(qc->flags & ATA_QCFLAG_EH) ||
+		    !(qc->flags & ATA_QCFLAG_EH_SUCCESS_CMD) ||
+		    qc->err_mask ||
+		    ata_dev_phys_link(qc->dev) != link)
+			continue;
+
+		/*
+		 * If the command does not have any sense data, clear ATA_SENSE.
+		 * Keep ATA_QCFLAG_EH_SUCCESS_CMD so that command is finished.
+		 */
+		if (!(sense_valid & (1ULL << tag))) {
+			qc->result_tf.status &= ~ATA_SENSE;
+			continue;
+		}
+
+		sense = &buf[32 + 24 * tag];
+		sk = sense[0];
+		asc = sense[1];
+		ascq = sense[2];
+
+		if (!ata_scsi_sense_is_valid(sk, asc, ascq)) {
+			ret = -EIO;
+			continue;
+		}
+
+		/* Set sense without also setting scsicmd->result */
+		scsi_build_sense_buffer(dev->flags & ATA_DFLAG_D_SENSE,
+					qc->scsicmd->sense_buffer, sk,
+					asc, ascq);
+		qc->flags |= ATA_QCFLAG_SENSE_VALID;
+
+		/*
+		 * If we have sense data, call scsi_check_sense() in order to
+		 * set the correct SCSI ML byte (if any). No point in checking
+		 * the return value, since the command has already completed
+		 * successfully.
+		 */
+		scsi_check_sense(qc->scsicmd);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ata_eh_read_sense_success_ncq_log);
+
 /**
  *	ata_eh_analyze_ncq_error - analyze NCQ error
  *	@link: ATA link to analyze NCQ error for
@@ -1488,6 +1579,7 @@ void ata_eh_analyze_ncq_error(struct ata_link *link)
 
 	ata_qc_for_each_raw(ap, qc, tag) {
 		if (!(qc->flags & ATA_QCFLAG_EH) ||
+		    qc->flags & ATA_QCFLAG_EH_SUCCESS_CMD ||
 		    ata_dev_phys_link(qc->dev) != link)
 			continue;
 
diff --git a/include/linux/ata.h b/include/linux/ata.h
index a59b17d6ad11..2e2e22362096 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -326,6 +326,8 @@ enum {
 	ATA_LOG_CDL		= 0x18,
 	ATA_LOG_CDL_SIZE	= ATA_SECT_SIZE,
 	ATA_LOG_IDENTIFY_DEVICE	= 0x30,
+	ATA_LOG_SENSE_NCQ	= 0x0F,
+	ATA_LOG_SENSE_NCQ_SIZE	= ATA_SECT_SIZE * 2,
 	ATA_LOG_CONCURRENT_POSITIONING_RANGES = 0x47,
 
 	/* Identify device log pages: */
@@ -432,6 +434,7 @@ enum {
 	SATA_DEVSLP		= 0x09,	/* Device Sleep */
 
 	SETFEATURE_SENSE_DATA	= 0xC3, /* Sense Data Reporting feature */
+	SETFEATURE_SENSE_DATA_SUCC_NCQ = 0xC4, /* Sense Data for successful NCQ commands */
 
 	/* feature values for SET_MAX */
 	ATA_SET_MAX_ADDR	= 0x00,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index ab8b62036c12..70ac635fe5d7 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -214,6 +214,7 @@ enum {
 	ATA_QCFLAG_EH		= (1 << 16), /* cmd aborted and owned by EH */
 	ATA_QCFLAG_SENSE_VALID	= (1 << 17), /* sense data valid */
 	ATA_QCFLAG_EH_SCHEDULED = (1 << 18), /* EH scheduled (obsolete) */
+	ATA_QCFLAG_EH_SUCCESS_CMD = (1 << 19), /* EH should fetch sense for this successful cmd */
 
 	/* host set flags */
 	ATA_HOST_SIMPLEX	= (1 << 0),	/* Host is simplex, one DMA channel per host only */
@@ -312,8 +313,10 @@ enum {
 	ATA_EH_RESET		= ATA_EH_SOFTRESET | ATA_EH_HARDRESET,
 	ATA_EH_ENABLE_LINK	= (1 << 3),
 	ATA_EH_PARK		= (1 << 5), /* unload heads and stop I/O */
+	ATA_EH_GET_SUCCESS_SENSE = (1 << 6), /* Get sense data for successful cmd */
 
-	ATA_EH_PERDEV_MASK	= ATA_EH_REVALIDATE | ATA_EH_PARK,
+	ATA_EH_PERDEV_MASK	= ATA_EH_REVALIDATE | ATA_EH_PARK |
+				  ATA_EH_GET_SUCCESS_SENSE,
 	ATA_EH_ALL_ACTIONS	= ATA_EH_REVALIDATE | ATA_EH_RESET |
 				  ATA_EH_ENABLE_LINK,
 
@@ -867,6 +870,7 @@ struct ata_port {
 	struct ata_acpi_gtm	__acpi_init_gtm; /* use ata_acpi_init_gtm() */
 #endif
 	/* owned by EH */
+	u8			*ncq_sense_buf;
 	u8			sector_buf[ATA_SECT_SIZE] ____cacheline_aligned;
 };
 
@@ -1185,6 +1189,7 @@ extern int sata_link_hardreset(struct ata_link *link,
 			bool *online, int (*check_ready)(struct ata_link *));
 extern int sata_link_resume(struct ata_link *link, const unsigned long *params,
 			    unsigned long deadline);
+extern int ata_eh_read_sense_success_ncq_log(struct ata_link *link);
 extern void ata_eh_analyze_ncq_error(struct ata_link *link);
 #else
 static inline const unsigned long *
@@ -1222,6 +1227,10 @@ static inline int sata_link_resume(struct ata_link *link,
 {
 	return -EOPNOTSUPP;
 }
+static inline int ata_eh_read_sense_success_ncq_log(struct ata_link *link)
+{
+	return -EOPNOTSUPP;
+}
 static inline void ata_eh_analyze_ncq_error(struct ata_link *link) { }
 #endif
 extern int sata_link_debounce(struct ata_link *link,
-- 
2.39.2

