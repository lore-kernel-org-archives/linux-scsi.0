Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793400182;
	b=UTDQ417jAXXkv8FnMOU/0Af5drpD9jNih1JiEjn66rOo/+5HW4ZSi3iEAc4WEXV4QUNA
	 7WXLcE2ZQQ32F9LCJs+EhNDQciN+ILcltRHJCyBs83UaBxA+7BqHtW24FPx0m6p93sSRv
	 8JkAvmzCoYvA4B8/bgUM9w73R66e90eqxOURr29FtD5PSAcx9xoQBax8y5fL2O0buPQTi
	 F4SuOgOUKSOFIQ4RqdZZRI+qf5Xq3G1cMw2plxUCE4Eqgl5eNo4Z/GtEj9Gxfu1GGlsdN
	 V2c3+rAKtJFJ+18aBJLTHI/qXyhgRNOTf5QDYeVhBIS8mKbnNKjFVX6uxq7w8u0F6kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793400182;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=vQDEtAVipw8kujlXhWOb09Z7+OoCD9uVBzD1aYH+ln0=;
	b=XfNNWKce3rU/HDcyzPx3i6FDXhcY7y7hWLRNgmrLbHFnhY8hkMhKJoaunGYLzXyuZ+1O
	 1WejexLhh5StMzs/Qqywqr/WVq/QFs5uhHFNzlO9IP8qSmIsE6OfRO97P+PSSGDmyRmMc
	 iUFLx/uZDdeV0Nu7d9/gPcVBBjyuii4cWUaIUd5VKPqDtHw3cYui+xIT6Gk2Nitq0vS7B
	 y9v027mQ7eLr614jLqQTJEjgKZL9MeSh2dkVoMrFo5lGsuAA9N/R1aqd6pk9chZE/SQNG
	 UcOqcwp7lPX+SEtFMl++TXmRFtw+PKsRy8nFmjbH9OyeAKgHQsb7YKqzD2/K7Ipqf4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=UdzzMqlu;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E52606A31C
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 22:43:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51E52606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=UdzzMqlu
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jGbj16SVCzlfvqD;
	Fri, 30 Oct 2026 22:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1793400175; x=1795992176; bh=vQDEt
	AVipw8kujlXhWOb09Z7+OoCD9uVBzD1aYH+ln0=; b=UdzzMqluzjt+l4j2X8sVO
	QjaTl7e8R3O9vAb/JbG7SmTBPwxca5mcehKuW1plc74+E6Dr8yn6PuYPRIxUUTnL
	vjB3O1Pl55yh5BymJ2XhwmzJVc3LXF2aWEcQEYDlfOCaMz3cCuX3P6XTsG/H/seM
	8G89ork0Dov49FfZJ1bxQnVoCyK4dvRwV0WptEoRd8BNQnJD8hmGEQVcY5PHbotI
	TsA+FTUgiKbX7Jhpv9aaoRV81qxZZYuzi9ILhrraWcE2Bt0mZqMdVyxkyYjqI8SO
	bf2Toc0gy2/Y0/3yLB62buFyIzDmvD5za9GULf54CoYaJlwmlr3tinMYVhmWB2aK
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WP4947Z90P_l; Fri, 30 Oct 2026 22:42:55 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (57.237.82.34.bc.googleusercontent.com [34.82.237.57])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jGbhv3dZ9zlfvq2;
	Fri, 30 Oct 2026 22:42:55 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Alexey Charkov <alchark@flipper.net>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH 3/5] scsi: core: Clear UNIT ATTENTION conditions with TEST UNIT READY
Date: Fri, 30 Oct 2026 15:42:37 -0700
Message-ID: <444e78b0fa892e8854bee89f341824d67000d968.1793400000.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
In-Reply-To: <cover.1793400000.git.bvanassche@acm.org>
References: <cover.1793400000.git.bvanassche@acm.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Some targets, e.g. BIWIN BWU2A05* UFS devices, fail to clear power-on or
reset UNIT ATTENTION conditions on WRITE commands while clearing these
on commands like TEST UNIT READY, READ, and SYNCHRONIZE CACHE.

Add scsi_eh_clear_ua() to scsi_eh_ready_devs() ahead of device reset
so that the error handler sends TEST UNIT READY to consume a stuck
UNIT ATTENTION and verifies with a follow-up TEST UNIT READY that the
condition cleared before requeueing affected commands. Allow a few
additional TEST UNIT READY attempts for queued UNIT ATTENTION
conditions and busy devices, delay retries, and honor the error
handler deadline. Save and restore scmd->sense_buffer across
scsi_send_eh_cmnd() so that the original sense data remains intact
while filtering work_q and if retries are later exhausted. Log a
rate-limited message when a persistent UNIT ATTENTION is cleared to
make it possible to identify misbehaving devices.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 131 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 131 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index ee80af923a4a..321806cbcf2e 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -27,6 +27,7 @@
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/jiffies.h>
+#include <linux/ratelimit.h>
=20
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -57,6 +58,11 @@
 #define BUS_RESET_SETTLE_TIME   (10)
 #define HOST_RESET_SETTLE_TIME  (10)
=20
+/* Maximum number of TEST UNIT READY commands sent to clear a UNIT ATTEN=
TION. */
+#define SCSI_EH_CLEAR_UA_TURS	4
+/* Delay in milliseconds before a TEST UNIT READY command is retried. */
+#define SCSI_EH_CLEAR_UA_RETRY_DELAY_MS	100
+
 static int scsi_eh_try_stu(struct scsi_cmnd *scmd);
 static enum scsi_disposition scsi_try_to_abort_cmd(const struct scsi_hos=
t_template *,
 						   struct scsi_cmnd *);
@@ -1671,6 +1677,130 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 	return list_empty(work_q);
 }
=20
+static bool scsi_cmd_has_ua(const struct scsi_cmnd *scmd)
+{
+	struct scsi_sense_hdr sshdr;
+
+	return scsi_cmd_current_sense(scmd, &sshdr) &&
+		sshdr.sense_key =3D=3D UNIT_ATTENTION;
+}
+
+static bool scsi_eh_send_tur_clear_ua(struct scsi_cmnd *scmd)
+{
+	static unsigned char tur_command[6] =3D { TEST_UNIT_READY };
+	struct Scsi_Host *shost =3D scmd->device->host;
+	u8 sense_buf[SCSI_SENSE_BUFFERSIZE];
+	struct scsi_sense_hdr sshdr;
+	enum scsi_disposition rtn;
+	bool cleared =3D false;
+	int i;
+
+	memcpy(sense_buf, scmd->sense_buffer, sizeof(sense_buf));
+
+	/*
+	 * The first TEST UNIT READY command consumes the pending UNIT
+	 * ATTENTION and the second TEST UNIT READY command verifies that the
+	 * condition has been cleared. Allow additional attempts in case
+	 * multiple UNIT ATTENTION conditions have been queued or in case the
+	 * device is temporarily busy or becoming ready.
+	 */
+	for (i =3D 0; i < SCSI_EH_CLEAR_UA_TURS; i++) {
+		if (scsi_host_eh_past_deadline(shost))
+			break;
+		rtn =3D scsi_send_eh_cmnd(scmd, tur_command, sizeof(tur_command),
+					scmd->device->eh_timeout, 0);
+		if (rtn =3D=3D NEEDS_RETRY) {
+			if (i + 1 < SCSI_EH_CLEAR_UA_TURS)
+				msleep(SCSI_EH_CLEAR_UA_RETRY_DELAY_MS);
+			continue;
+		}
+		if (rtn !=3D SUCCESS)
+			break;
+		if (!scsi_command_normalize_sense(scmd, &sshdr) ||
+		    sshdr.sense_key =3D=3D NO_SENSE ||
+		    sshdr.sense_key =3D=3D RECOVERED_ERROR) {
+			cleared =3D true;
+			break;
+		}
+		if (sshdr.sense_key !=3D UNIT_ATTENTION)
+			break;
+	}
+
+	memcpy(scmd->sense_buffer, sense_buf, sizeof(sense_buf));
+	return cleared;
+}
+
+/**
+ * scsi_eh_clear_ua - clear pending UNIT ATTENTION conditions if needed
+ * @shost:	SCSI host being recovered.
+ * @work_q:	&list_head for pending commands.
+ * @done_q:	&list_head for processed commands.
+ *
+ * If commands fail repeatedly with UNIT ATTENTION because a target does=
 not
+ * clear the condition for those commands (for example, WRITE), send
+ * TEST UNIT READY to clear the UNIT ATTENTION before escalating to a re=
set.
+ *
+ * Return: 1 if @work_q is empty, 0 otherwise.
+ */
+static int scsi_eh_clear_ua(struct Scsi_Host *shost,
+			    struct list_head *work_q,
+			    struct list_head *done_q)
+{
+	static DEFINE_RATELIMIT_STATE(rs, DEFAULT_RATELIMIT_INTERVAL,
+				      DEFAULT_RATELIMIT_BURST);
+	struct scsi_cmnd *scmd, *ua_scmd, *next;
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, shost) {
+		if (scsi_host_eh_past_deadline(shost)) {
+			SCSI_LOG_ERROR_RECOVERY(3,
+				sdev_printk(KERN_INFO, sdev,
+					    "%s: skip clear UA, past eh deadline\n",
+					    current->comm));
+			scsi_device_put(sdev);
+			break;
+		}
+
+		ua_scmd =3D NULL;
+		list_for_each_entry(scmd, work_q, eh_entry) {
+			if (scmd->device =3D=3D sdev && scsi_cmd_has_ua(scmd)) {
+				ua_scmd =3D scmd;
+				break;
+			}
+		}
+
+		if (!ua_scmd)
+			continue;
+
+		SCSI_LOG_ERROR_RECOVERY(3,
+			sdev_printk(KERN_INFO, sdev,
+				    "%s: Sending TEST_UNIT_READY to clear UA\n",
+				    current->comm));
+
+		if (scsi_device_online(sdev)) {
+			if (!scsi_eh_send_tur_clear_ua(ua_scmd)) {
+				SCSI_LOG_ERROR_RECOVERY(3,
+					sdev_printk(KERN_INFO, sdev,
+						    "%s: Failed to clear UA\n",
+						    current->comm));
+				continue;
+			}
+			if (__ratelimit(&rs))
+				sdev_printk(KERN_INFO, sdev,
+					    "Cleared persistent UNIT ATTENTION\n");
+		}
+
+		sdev->expecting_cc_ua =3D 0;
+		list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
+			if (scmd->device =3D=3D sdev &&
+			    scsi_cmd_has_ua(scmd) &&
+			    scsi_eh_action(scmd, SUCCESS) =3D=3D SUCCESS)
+				scsi_eh_finish_cmd(scmd, done_q);
+		}
+	}
+
+	return list_empty(work_q);
+}
=20
 /**
  * scsi_eh_bus_device_reset - send bdr if needed
@@ -2302,6 +2432,7 @@ void scsi_eh_ready_devs(struct Scsi_Host *shost,
 			struct list_head *done_q)
 {
 	if (!scsi_eh_stu(shost, work_q, done_q) &&
+	    !scsi_eh_clear_ua(shost, work_q, done_q) &&
 	    !scsi_eh_bus_device_reset(shost, work_q, done_q) &&
 	    !scsi_eh_target_reset(shost, work_q, done_q) &&
 	    !scsi_eh_bus_reset(shost, work_q, done_q) &&
