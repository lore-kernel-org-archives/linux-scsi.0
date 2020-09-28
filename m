Return-Path: <SRS0=JIM3=DF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_HEADER_CTYPE_ONLY,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45F8EC2D0A8
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 11:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D170221D95
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 11:44:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="da6z3gnC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgI1Loo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 07:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbgI1Loo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2020 07:44:44 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE9EC061755
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2020 04:44:44 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id l126so762722pfd.5
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2020 04:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=W+8t/wFNwhBkBbVsyEDmQ227b7g8+rNL8kbsStypFEg=;
        b=da6z3gnC/H2ozMdd3Ri58LpjKlz5X4ohVlxne6if68PKybnerEQyd4D/mKgZcGwwXZ
         Lz262nBy2j9ogfyFnrQhVnAQG4ESf5oF72q5XKlFYzQ9JxFUXcqT2G3YUJlj0qfQ/cXb
         nQ5jNoxAOHuNkRWYZKJYs262slujj+Z1omCcA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=W+8t/wFNwhBkBbVsyEDmQ227b7g8+rNL8kbsStypFEg=;
        b=QeYfV2/poS8yBw6m6CmKfwZGGN+y08MzNK44VJZ4lUs8710PPH/UK8FTf/bhEHf82s
         hTKEY5U9J+8BEnb1RJKL9IoQtY6GhoWLoDAtW5Nk4DcXz2fkOFRseNB/L6gSfWYvpxdg
         iRCQwXK12Gw7e8YWfvnJo/gB1e9sFNr24z1vKMSXAE9RhhILqAM75qGPDWveR8GkLlbw
         Ug/G03A6PxGOLBsZGCvaZoj/FUMF5/eBrseCiwPCadQ0J1W+EDT71OUqf1oXlUEtT7Q7
         PwgNknPcGENl6ao08dLbXK1nia7GWYlmJ0C63zVqkuN8yYdJhNNp874j8j1clixCc60t
         vcew==
X-Gm-Message-State: AOAM531iUzbkDzFxFt6uQZyCZiAXiaSXjxcJbKegAIt4U02Mj+CGV+O8
        iTIpv+Ke9oq1wv43ngRt/LgaVfapoCa1J+iFR35h6+nj8EHzvbk8/D/jIIMOfd0hJ+IVMX5bU4d
        wTK3RtSR/HpcpmZlCfNtjq0uM0jmxWXBFyWp5NyU+CA2WddK/yEGtnaIeJdKaPfS2zgANuljBnJ
        86rHaxP3X0
X-Google-Smtp-Source: ABdhPJxGxuoXq3UJyI4dntalbHM6ZlRvEv6wAfQlHvY/X8Sa+wZpX4GWi9zSIIE7wUjxin6y5xzXyw==
X-Received: by 2002:a17:902:c281:b029:d2:2988:4906 with SMTP id i1-20020a170902c281b02900d229884906mr1238338pld.82.1601293483275;
        Mon, 28 Sep 2020 04:44:43 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id w19sm1468866pfq.60.2020.09.28.04.44.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2020 04:44:42 -0700 (PDT)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [PATCH v2 5/8] scsi: Added routine to set/clear SCMD_NORETRIES_ABORT bit for outstanding io on scsi_dev
Date:   Mon, 28 Sep 2020 10:20:54 +0530
Message-Id: <1601268657-940-6-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601268657-940-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1601268657-940-1-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000047589c05b05e31e6"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000047589c05b05e31e6

Added a new routine scsi_chg_noretries_abort_io_device().
This functions accepts two arguments Scsi_device and an integer(set).

When set is passed as 1
this routine will set SCMD_NORETRIES_ABORT bit in
scmd->state for all the pending io's on the scsi device associated
with target port.

When set is passed as 0
This routine  will clear SCMD_NORETRIES_ABORT bit in
scmd->state for all the pending io's on the scsi device associated
with target port.

Export the symbol so the routine can be called by scsi_transport_fc.c

Added new function declaration scsi_chg_noretries_abort_io_device in
scsi_priv.h

Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>

---
v2:
Renamed the below functions as
scsi_set_noretries_abort_io_device ->scsi_chg_noretries_abort_io_device
__scsi_set_noretries_abort_io_device->__scsi_set_noretries_abort_io_device
which accepts the value as an arg to set/clear the SCMD_NORETRIES_ABORT bit
---
 drivers/scsi/scsi_error.c | 76 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_priv.h  |  2 ++
 2 files changed, 78 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 3f14ea10d5da..c0943f08b469 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -271,6 +271,82 @@ void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
 	call_rcu(&scmd->rcu, scsi_eh_inc_host_failed);
 }
 
+static bool
+scsi_clear_noretries_abort_io(struct request *rq, void *priv, bool reserved)
+{
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
+	struct scsi_device *sdev = scmd->device;
+
+	/* only clear SCMD_NORETRIES_ABORT on ios on a specific sdev */
+	if (sdev != priv)
+		return true;
+
+	/*Clear the SCMD_NORETRIES_ABORT bit*/
+	if (READ_ONCE(rq->state) == MQ_RQ_IN_FLIGHT)
+		clear_bit(SCMD_NORETRIES_ABORT, &scmd->state);
+	return true;
+}
+
+static bool
+scsi_set_noretries_abort_io(struct request *rq, void *priv, bool reserved)
+{
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
+	struct scsi_device *sdev = scmd->device;
+
+	/* only set SCMD_NORETRIES_ABORT on ios on a specific sdev */
+	if (sdev != priv)
+		return true;
+	/* we don't want this command reissued on abort success
+	 * so set SCMD_NORETRIES_ABORT bit to ensure it
+	 * won't get reissued
+	 */
+	if (READ_ONCE(rq->state) == MQ_RQ_IN_FLIGHT)
+		set_bit(SCMD_NORETRIES_ABORT, &scmd->state);
+	return true;
+}
+
+static int
+__scsi_chg_noretries_abort_io_device(struct scsi_device *sdev, int set)
+{
+
+	if (sdev->sdev_state != SDEV_RUNNING)
+		return -EINVAL;
+
+	if (blk_queue_init_done(sdev->request_queue)) {
+
+		blk_mq_quiesce_queue(sdev->request_queue);
+
+		if (set)
+			blk_mq_tagset_busy_iter(&sdev->host->tag_set,
+					scsi_set_noretries_abort_io, sdev);
+		else
+			blk_mq_tagset_busy_iter(&sdev->host->tag_set,
+				scsi_clear_noretries_abort_io, sdev);
+
+		blk_mq_unquiesce_queue(sdev->request_queue);
+	}
+	return 0;
+}
+
+/*
+ * scsi_chg_noretries_abort_io_device - set/clear the SCMD_NORETRIES_ABORT
+ * bit for all the pending io's on a device
+ * @sdev:	scsi_device
+ * @set: indicates to clear (0) or set (1) the SCMD_NORETRIES_ABORT flag
+ */
+int
+scsi_chg_noretries_abort_io_device(struct scsi_device *sdev, int set)
+{
+	struct Scsi_Host *shost = sdev->host;
+	int ret  = -EINVAL;
+
+	mutex_lock(&shost->scan_mutex);
+	ret = __scsi_chg_noretries_abort_io_device(sdev, set);
+	mutex_unlock(&shost->scan_mutex);
+	return ret;
+}
+EXPORT_SYMBOL(scsi_chg_noretries_abort_io_device);
+
 /**
  * scsi_times_out - Timeout function for normal scsi commands.
  * @req:	request that is timing out.
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index d12ada035961..aba98a3294ce 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -81,6 +81,8 @@ void scsi_eh_ready_devs(struct Scsi_Host *shost,
 int scsi_eh_get_sense(struct list_head *work_q,
 		      struct list_head *done_q);
 int scsi_noretry_cmd(struct scsi_cmnd *scmd);
+extern int scsi_chg_noretries_abort_io_device(struct scsi_device *sdev,
+			int set);
 
 /* scsi_lib.c */
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
-- 
2.26.2


--00000000000047589c05b05e31e6
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
J/4V6ms/nIUi+/4vPYjckYUbRzkXm1/X0IyUfpp5cgdrFn9jBIk69fQGAUEhnVvwcXnHWotYxZFd
Xew5Fz0CAwEAAaOCAdMwggHPMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYI
KwYBBQUHMAKGQWh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxz
aWduMnNoYTJnM29jc3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5j
b20vZ3NwZXJzb25hbHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsG
AQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAA
MEQGA1UdHwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNp
Z24yc2hhMmczLmNybDAnBgNVHREEIDAegRxtdW5lZW5kcmEua3VtYXJAYnJvYWRjb20uY29tMBMG
A1UdJQQMMAoGCCsGAQUFBwMEMB8GA1UdIwQYMBaAFGlygmIxZ5VEhXeRgMQENkmdewthMB0GA1Ud
DgQWBBR6On9cEmlB2VsuST951zNMSKtFBzANBgkqhkiG9w0BAQsFAAOCAQEAOGDBLQ17Ge8BVULh
hsKhgh5eDx0mNmRRdhvTJnxOTRX5QsOKvsJGOUbyrKjD3BTTcGmIUti9HmbqDe/3gRTbhu8LA508
LbMkW5lUoTb8ycBNOKLYhNE8UEOY8jRTUtMEhzT6NJDEE+1hb3kSGfArrrF3Z8pRYiUUhcpC5GKL
9KsxA+DECRfSGfXJJQSq6nEZUGKhz+dz5CV1s8UIZLe9HEEfyJO4eRP+Fw9X16cthAbY0kpVnAvT
/j45FAauY/h87uphdvSb5wC9v5w4VO0JKs0yNUjyWXg/RG+6JCvcViLFLAlRCLrcRcVaQwWZQ3YB
EpmWnHflnrBcah5Ozy137DGCAm8wggJrAgEBMG0wXTELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEds
b2JhbFNpZ24gbnYtc2ExMzAxBgNVBAMTKkdsb2JhbFNpZ24gUGVyc29uYWxTaWduIDIgQ0EgLSBT
SEEyNTYgLSBHMwIMX/krgFDQUQNyOf+1MA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEi
BCBCr15v605UQv2SD+/p61sMQ69YTCZK/t66eklwNGiFnDAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
AQcBMBwGCSqGSIb3DQEJBTEPFw0yMDA5MjgxMTQ0NDNaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEK
MAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEANxVX6W1NAbVv4Fwc
39pU+OsMELFGowskY+JHKhWMPuX573pZZ6PwlS90dSs8mJyHCPTpA8Mr1R5nbApsem/nkcnw3hRn
INBtXtF/Vj6nd6fMjljzLxwSR8DD1LQaAdDZ7Zjej5x0sFmmCD3QHVzUIyefNmbbQBUPPjG2V6Z7
DhIovxmkZHaa3sSX3CzjCkx0igowprCNhnNCQDoFVDKILrGvJx9aUgPLsDuwH0cw7uCk6KcyYVyB
DZqx2cwWlLSMLBFecaWdQriyGG3hsNlluAjar1S2UIps7csEmBABFMNMW9Vw0L3ahZtSyXvY8g+F
UIK2+1r6+5sLCUQ5Aa47KQ==
--00000000000047589c05b05e31e6--
