Return-Path: <SRS0=rjNM=DW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_HEADER_CTYPE_ONLY,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	T_TVD_MIME_NO_HEADERS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80DF5C433E7
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Oct 2020 10:21:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10C9622249
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Oct 2020 10:21:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="KRJVGlNa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731061AbgJOKVU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Oct 2020 06:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbgJOKVT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2020 06:21:19 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A322C061755
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2020 03:21:19 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a1so1738371pjd.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2020 03:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=z1FC3pUFkwS9yzzl3wibbLMwFNi6rUktgCaXt92PeRA=;
        b=KRJVGlNaCznBBMx6cZNUCH1fui1SQhSBi+T3CPCYBfbPONRyntJc45PkAuOJbZ2Fx1
         gBqViUKuc+jPH999YkGoQGy+BpWdPjaaVtBvmBPR/qoM1eYtDyYh4PslsTqxIXhhW+hY
         0c4UlsHxzO7Lna3K/z59Uxf39TFUPJOfY3o3w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=z1FC3pUFkwS9yzzl3wibbLMwFNi6rUktgCaXt92PeRA=;
        b=eAOAJtHfLOIks7XHwckMHpxcC0XpP6QMEQMrPTQSRVKJ38QMK8uASSRM+8gYBoMSUD
         tDRB0Y+YZnPLdqgewTUWeyWUyr7VmGSf2qqmukC5RZ/6eAMGA8rIbz4QHyOgAawNsNWq
         KduIFH3JieuInYdBkSuDPu7vDgB9pZeEeBQXKWP4TVsgvpUj/Bgfydt8Q578ElBNDAMe
         Qn1pL3+VAmIKo9iV5Wv2S7w2HCmxAz0PTB6nHAHd6KsTkBBcvtIBN66BPajvnNbNwQ2W
         9ZDLjKZmNVO4qXYA+AxXG4DPKwLs3KSm+jw7nqp1/GDnml4PEIqHymd1c9q9ckyPyNXw
         Sutw==
X-Gm-Message-State: AOAM532zj9nKnRkkY7GHhvZSrVN0b7N5iLOm3gLR8JuAM6LWvCTAg3yZ
        igPNfPVAcWviIiR3IsXh4wWfTP6VQu7u+4hl7eGckV0/CCcHbljqjFtid/ziz2RWEdEaSONrzcc
        +BKtWE4ffAXzRgl6yWaaEYYKqTWH/yqdvSOC7ZQ91326isBPueeFhVxFtQZsW+SeV0PZpsAMNlz
        fpE8NgPFtH8rQ=
X-Google-Smtp-Source: ABdhPJwFnbUL5A8euW9x20KOuKqWZLBb4ddsRrgPFUuol7GM4wP6OJdzDbaZqJNDNlD67/zHBvFEtw==
X-Received: by 2002:a17:902:ff14:b029:d3:f1e5:c992 with SMTP id f20-20020a170902ff14b02900d3f1e5c992mr3493743plj.72.1602757278043;
        Thu, 15 Oct 2020 03:21:18 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 194sm2802258pfz.182.2020.10.15.03.21.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Oct 2020 03:21:17 -0700 (PDT)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [PATCH v3 04/17] scsi: Added routine to set/clear SCMD_NORETRIES_ABORT bit for outstanding io on scsi_dev
Date:   Thu, 15 Oct 2020 08:57:29 +0530
Message-Id: <1602732462-10443-5-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602732462-10443-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1602732462-10443-1-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000003f5c7305b1b30270"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000003f5c7305b1b30270

Added a new routine scsi_chg_noretries_abort_io_device().
This functions accepts two arguments Scsi_device and a bool(set).

When set is passed as 1
this routine will set SCMD_NORETRIES_ABORT bit in
scmd->state for all the io's on the scsi device associated
with remote port.

When set is passed as 0
This routine  will clear SCMD_NORETRIES_ABORT bit in
scmd->state for all the io's on the scsi device associated
with remote port.

Export the symbol so the routine can be called by scsi_transport_fc.c

Added new function declaration scsi_chg_noretries_abort_io_device in
scsi_priv.h

Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>

---
v3:
Used the existing scsi command iterators scsi_host_busy_iter.
Set the SCMD_NORETRIES_ABORT to every command instead of only the inflight ios.
Modified the scsi_chg_noretries_abort_io_device argument type from int to bool

v2:
Renamed the below functions as
scsi_set_noretries_abort_io_device ->scsi_chg_noretries_abort_io_device
__scsi_set_noretries_abort_io_device->__scsi_set_noretries_abort_io_device
which accepts the value as an arg to set/clear the SCMD_NORETRIES_ABORT bit
---
 drivers/scsi/scsi_error.c | 65 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_priv.h  |  2 ++
 2 files changed, 67 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index aa30c1c9e9db..70e70fdfb00c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -279,6 +279,71 @@ void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
 	call_rcu(&scmd->rcu, scsi_eh_inc_host_failed);
 }
 
+static bool
+scsi_clear_noretries_abort_io(struct scsi_cmnd *scmd, void *priv, bool reserved)
+{
+	struct scsi_device *sdev = scmd->device;
+
+	/* only clear SCMD_NORETRIES_ABORT on ios on a specific sdev */
+	if (sdev != priv)
+		return true;
+
+	/*Clear the SCMD_NORETRIES_ABORT bit*/
+	clear_bit(SCMD_NORETRIES_ABORT, &scmd->state);
+	return true;
+}
+
+static bool
+scsi_set_noretries_abort_io(struct scsi_cmnd *scmd, void *priv, bool reserved)
+{
+	struct scsi_device *sdev = scmd->device;
+
+	/* only set SCMD_NORETRIES_ABORT on ios on a specific sdev */
+	if (sdev != priv)
+		return true;
+	/* we don't want this command reissued on abort success
+	 * so set SCMD_NORETRIES_ABORT bit to ensure it
+	 * won't get reissued
+	 */
+	set_bit(SCMD_NORETRIES_ABORT, &scmd->state);
+	return true;
+}
+
+static int
+__scsi_chg_noretries_abort_io_device(struct scsi_device *sdev, bool set)
+{
+
+	if (sdev->sdev_state != SDEV_RUNNING)
+		return -EINVAL;
+
+	blk_mq_quiesce_queue(sdev->request_queue);
+	if (set)
+		scsi_host_busy_iter(sdev->host, scsi_set_noretries_abort_io, sdev);
+	else
+		scsi_host_busy_iter(sdev->host, scsi_clear_noretries_abort_io, sdev);
+
+	blk_mq_unquiesce_queue(sdev->request_queue);
+	return 0;
+}
+
+/*
+ * scsi_chg_noretries_abort_io_device - set/clear the SCMD_NORETRIES_ABORT
+ * bit for all the pending io's on a device
+ * @sdev:	scsi_device
+ */
+int
+scsi_chg_noretries_abort_io_device(struct scsi_device *sdev, bool set)
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
index 180636d54982..9ccd3b716cf9 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -82,6 +82,8 @@ void scsi_eh_ready_devs(struct Scsi_Host *shost,
 int scsi_eh_get_sense(struct list_head *work_q,
 		      struct list_head *done_q);
 int scsi_noretry_cmd(struct scsi_cmnd *scmd);
+extern int scsi_chg_noretries_abort_io_device(struct scsi_device *sdev,
+			bool set);
 
 /* scsi_lib.c */
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
-- 
2.26.2


--0000000000003f5c7305b1b30270
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQTQYJKoZIhvcNAQcCoIIQPjCCEDoCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg2iMIIE6DCCA9CgAwIBAgIOSBtqCRO9gCTKXSLwFPMwDQYJKoZIhvcNAQELBQAwTDEgMB4GA1UE
CxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMT
Ckdsb2JhbFNpZ24wHhcNMTYwNjE1MDAwMDAwWhcNMjQwNjE1MDAwMDAwWjBdMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEzMDEGA1UEAxMqR2xvYmFsU2lnbiBQZXJzb25h
bFNpZ24gMiBDQSAtIFNIQTI1NiAtIEczMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
tpZok2X9LAHsYqMNVL+Ly6RDkaKar7GD8rVtb9nw6tzPFnvXGeOEA4X5xh9wjx9sScVpGR5wkTg1
fgJIXTlrGESmaqXIdPRd9YQ+Yx9xRIIIPu3Jp/bpbiZBKYDJSbr/2Xago7sb9nnfSyjTSnucUcIP
ZVChn6hKneVGBI2DT9yyyD3PmCEJmEzA8Y96qT83JmVH2GaPSSbCw0C+Zj1s/zqtKUbwE5zh8uuZ
p4vC019QbaIOb8cGlzgvTqGORwK0gwDYpOO6QQdg5d03WvIHwTunnJdoLrfvqUg2vOlpqJmqR+nH
9lHS+bEstsVJtZieU1Pa+3LzfA/4cT7XA/pnwwIDAQABo4IBtTCCAbEwDgYDVR0PAQH/BAQDAgEG
MGoGA1UdJQRjMGEGCCsGAQUFBwMCBggrBgEFBQcDBAYIKwYBBQUHAwkGCisGAQQBgjcUAgIGCisG
AQQBgjcKAwQGCSsGAQQBgjcVBgYKKwYBBAGCNwoDDAYIKwYBBQUHAwcGCCsGAQUFBwMRMBIGA1Ud
EwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFGlygmIxZ5VEhXeRgMQENkmdewthMB8GA1UdIwQYMBaA
FI/wS3+oLkUkrk1Q+mOai97i3Ru8MD4GCCsGAQUFBwEBBDIwMDAuBggrBgEFBQcwAYYiaHR0cDov
L29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3RyMzA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3Js
Lmdsb2JhbHNpZ24uY29tL3Jvb3QtcjMuY3JsMGcGA1UdIARgMF4wCwYJKwYBBAGgMgEoMAwGCisG
AQQBoDIBKAowQQYJKwYBBAGgMgFfMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNp
Z24uY29tL3JlcG9zaXRvcnkvMA0GCSqGSIb3DQEBCwUAA4IBAQConc0yzHxn4gtQ16VccKNm4iXv
6rS2UzBuhxI3XDPiwihW45O9RZXzWNgVcUzz5IKJFL7+pcxHvesGVII+5r++9eqI9XnEKCILjHr2
DgvjKq5Jmg6bwifybLYbVUoBthnhaFB0WLwSRRhPrt5eGxMw51UmNICi/hSKBKsHhGFSEaJQALZy
4HL0EWduE6ILYAjX6BSXRDtHFeUPddb46f5Hf5rzITGLsn9BIpoOVrgS878O4JnfUWQi29yBfn75
HajifFvPC+uqn+rcVnvrpLgsLOYG/64kWX/FRH8+mhVe+mcSX3xsUpcxK9q9vLTVtroU/yJUmEC4
OcH5dQsbHBqjMIIDXzCCAkegAwIBAgILBAAAAAABIVhTCKIwDQYJKoZIhvcNAQELBQAwTDEgMB4G
A1UECxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNV
BAMTCkdsb2JhbFNpZ24wHhcNMDkwMzE4MTAwMDAwWhcNMjkwMzE4MTAwMDAwWjBMMSAwHgYDVQQL
ExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMK
R2xvYmFsU2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMwldpB5BngiFvXAg7aE
yiie/QV2EcWtiHL8RgJDx7KKnQRfJMsuS+FggkbhUqsMgUdwbN1k0ev1LKMPgj0MK66X17YUhhB5
uzsTgHeMCOFJ0mpiLx9e+pZo34knlTifBtc+ycsmWQ1z3rDI6SYOgxXG71uL0gRgykmmKPZpO/bL
yCiR5Z2KYVc3rHQU3HTgOu5yLy6c+9C7v/U9AOEGM+iCK65TpjoWc4zdQQ4gOsC0p6Hpsk+QLjJg
6VfLuQSSaGjlOCZgdbKfd/+RFO+uIEn8rUAVSNECMWEZXriX7613t2Saer9fwRPvm2L7DWzgVGkW
qQPabumDk3F2xmmFghcCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8w
HQYDVR0OBBYEFI/wS3+oLkUkrk1Q+mOai97i3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQBLQNvAUKr+
yAzv95ZURUm7lgAJQayzE4aGKAczymvmdLm6AC2upArT9fHxD4q/c2dKg8dEe3jgr25sbwMpjjM5
RcOO5LlXbKr8EpbsU8Yt5CRsuZRj+9xTaGdWPoO4zzUhw8lo/s7awlOqzJCK6fBdRoyV3XpYKBov
Hd7NADdBj+1EbddTKJd+82cEHhXXipa0095MJ6RMG3NzdvQXmcIfeg7jLQitChws/zyrVQ4PkX42
68NXSb7hLi18YIvDQVETI53O9zJrlAGomecsMx86OyXShkDOOyyGeMlhLxS67ttVb9+E7gUJTb0o
2HLO02JQZR7rkpeDMdmztcpHWD9fMIIFTzCCBDegAwIBAgIMX/krgFDQUQNyOf+1MA0GCSqGSIb3
DQEBCwUAMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMwMQYDVQQD
EypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMwHhcNMjAwOTA0MDgz
NTI5WhcNMjIwOTA1MDgzNTI5WjCBljELMAkGA1UEBhMCSU4xEjAQBgNVBAgTCUthcm5hdGFrYTES
MBAGA1UEBxMJQmFuZ2Fsb3JlMRYwFAYDVQQKEw1Ccm9hZGNvbSBJbmMuMRowGAYDVQQDExFNdW5l
ZW5kcmEgS3VtYXIgTTErMCkGCSqGSIb3DQEJARYcbXVuZWVuZHJhLmt1bWFyQGJyb2FkY29tLmNv
bTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMoadg8/B0JvnQVWQZyfiiEMmDhh0bSq
BIThkSCjIdy7yOV9fBOs6MdrPZgCDeX5rJvOw6PJiWjeQQ9RkTJH6WccvxwXugoyspkG/RfFdUKk
t0/bk1Ml9aUobcee2+cC79gyzwpHUjzEpcsx49FskGIxI+n9wybrDhpurtj8mmc1C1sVzKNoIEwC
/eHrCsDnag9JEGotxVVv0KcLXv7N0CXs03bP8uvocms3+gO1K8dasJkc7noMt/i0/xcZnaABWkgV
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
BCDWOo004+RHE0FnJxaMDhG2XghoKj8udwORmV3f1wlkvTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
AQcBMBwGCSqGSIb3DQEJBTEPFw0yMDEwMTUxMDIxMThaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEK
MAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAeHQRRuUVp4UgSwxM
bZRSapNsg0MUoz1mtQeWPCc4xXUY1oAMF1ntJ4l6mCgIeLx0XV/LitrOhsjBwynFYUoDycSrjVKn
GVA8t7u5q/7sBuPtvJMT8Ou6vkTD1iUe6wv+d88P6FmRNf1/nsN8zrsGPwMfFYqtaryL/9I+oJOi
lxTSaFHmUj+sfQHZZshZs+JnlB8edJoDkyEWVJTYBh5bf32UoUdpDiHiFAP3gZzGrps8+HsvDf2t
lwaJZks4W9U7y+rrrmXC9mh5wUGB1fKHhBHqYIJBRhU1BZBHVvtdShkhzej9IRd4FeAvdCIu12Yv
STJIURuLnbpVyUaB+MflkA==
--0000000000003f5c7305b1b30270--
