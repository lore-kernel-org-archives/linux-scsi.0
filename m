Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F15A8C6379D
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA973222E8
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Es7+xPR5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgKOT1F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Nov 2020 14:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727861AbgKOT1E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Nov 2020 14:27:04 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76727C0613CF
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:27:04 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id q28so254347pgk.1
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=SgtQHDxfKrtxjDe1jRKmMHXrVw8y/QrZMtSTCgNnq0o=;
        b=Es7+xPR5qW0h6HN7yLmTxUTwmyctuccL1hR8zpuP0q5umAlv8ukXWsFy3ggB0AXsvu
         VHrR7FLxUUTmJmfq1O6HmqL4Ad4RymXzH6z2uJy8tiJwLhCG2ZOzNeXOCXOzjjZlYRu8
         Yd0EayunQXm8s16KWXCDc1dECx/VB0ER/j3Tw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=SgtQHDxfKrtxjDe1jRKmMHXrVw8y/QrZMtSTCgNnq0o=;
        b=oZWrT58CP15mFHohiXBZSZYOqYXVIL6zzRN8z0SDdsym/xRBvlk2fJIANBplvNI24H
         V/FOldPVXYmr4xzvPUtaQAZNF5vYop5tVKgomD+0MqQLP7w1ixkLSMl1f5I4y/LHwhOn
         ZIhI1d1ZG7gCuDp16C2PmtI0GqTHFYKtS+C7zGD0m3KZMTnYc8uBH/DhGuJfXZ6e8p7J
         RPjbHhyCwIPaMKlIjkANakZIWMJN4+rMKq1sCoStAIaNzn2PxXZ0l4s818b9cLC67qO1
         5QH/ytFrPwx7L2hyqRlFnxWJnTUDNHHrijAnrIbxpL92Itmhc3naZ0kXU7Le/9F6pHBK
         T1wQ==
X-Gm-Message-State: AOAM532bmkU27zHuqbVsviOl+rMmnG44h1etCE71BOd1JcU/3YG7DuBy
        WBpRotx7YF6Qx5z/wVisTR72XHnW+PhKv+xO2kykGht038GE3QNKHAKZw7hqO18eCcuF8jISBXc
        sUEW9VcPhLdG0Ojbqugh6JNCgOseH16IXdhvxTc1vSng22xcxNwpgwWiG8DN0egEqHLZDr52HZE
        rSGJA=
X-Google-Smtp-Source: ABdhPJyyihRi0XCn91um1NBBzsqm2vjXMPIiZo1GEtaTvOfj23ZNiuBd7K+tnd/jJLb4Otvozc4Zaw==
X-Received: by 2002:a05:6a00:13a4:b029:18b:cfc9:1ea1 with SMTP id t36-20020a056a0013a4b029018bcfc91ea1mr10873367pfg.25.1605468423335;
        Sun, 15 Nov 2020 11:27:03 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v126sm15864604pfb.137.2020.11.15.11.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 11:27:02 -0800 (PST)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 07/17] lpfc: Unsolicited ELS leaves node in incorrect state while dropping it
Date:   Sun, 15 Nov 2020 11:26:36 -0800
Message-Id: <20201115192646.12977-8-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201115192646.12977-1-james.smart@broadcom.com>
References: <20201115192646.12977-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000001b05bc05b42a3f9d"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000001b05bc05b42a3f9d
Content-Transfer-Encoding: 8bit

When a target swap happens, under certain conditions the node sends a
LOGO. The unsolicited ELS logic responds with a reject. The logic may
allocate a new node to handle this. Afterward, the new nodes are dropped
incorrectly leaving them in a mis-matched state and refcounting causes
a use-after-free situation leading to a crash.

It is also possible that the unsolicited els handling finds a node which
is in an UNUSED state. The handling moves these nodes to NPR state with a
refcount of 1. Although the end of the discovery logic assumes a final
put will free such a node, there are codes paths which could increment the
reference count, thus the node is in NPR state and not released.
Eventually this mismatch in state and refcount leads to premature release
of the node causing a crash.

Fix by always using the discovery engine DEVICE RM event to decrement and
release the nodes (rather than explicit code that tried to do it before).
This will take care of moving the node to the UNUSED state and then
removes the final ref count. If there is a trigger to reuse this node,
the transition from the UNUSED state clearly indicates that the initial
reference is then incremented and use can continue.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 225215a04313..45a8ebbf60bc 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -8728,7 +8728,8 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 		lpfc_els_rcv_flogi(vport, elsiocb, ndlp);
 		if (newnode)
-			lpfc_nlp_put(ndlp);
+			lpfc_disc_state_machine(vport, ndlp, NULL,
+					NLP_EVT_DEVICE_RM);
 		break;
 	case ELS_CMD_LOGO:
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
@@ -8770,7 +8771,8 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		phba->fc_stat.elsRcvRSCN++;
 		lpfc_els_rcv_rscn(vport, elsiocb, ndlp);
 		if (newnode)
-			lpfc_nlp_put(ndlp);
+			lpfc_disc_state_machine(vport, ndlp, NULL,
+					NLP_EVT_DEVICE_RM);
 		break;
 	case ELS_CMD_ADISC:
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
@@ -8848,7 +8850,8 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		phba->fc_stat.elsRcvLIRR++;
 		lpfc_els_rcv_lirr(vport, elsiocb, ndlp);
 		if (newnode)
-			lpfc_nlp_put(ndlp);
+			lpfc_disc_state_machine(vport, ndlp, NULL,
+					NLP_EVT_DEVICE_RM);
 		break;
 	case ELS_CMD_RLS:
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
@@ -8858,7 +8861,8 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		phba->fc_stat.elsRcvRLS++;
 		lpfc_els_rcv_rls(vport, elsiocb, ndlp);
 		if (newnode)
-			lpfc_nlp_put(ndlp);
+			lpfc_disc_state_machine(vport, ndlp, NULL,
+					NLP_EVT_DEVICE_RM);
 		break;
 	case ELS_CMD_RPL:
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
@@ -8868,7 +8872,8 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		phba->fc_stat.elsRcvRPL++;
 		lpfc_els_rcv_rpl(vport, elsiocb, ndlp);
 		if (newnode)
-			lpfc_nlp_put(ndlp);
+			lpfc_disc_state_machine(vport, ndlp, NULL,
+					NLP_EVT_DEVICE_RM);
 		break;
 	case ELS_CMD_RNID:
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
@@ -8878,7 +8883,8 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		phba->fc_stat.elsRcvRNID++;
 		lpfc_els_rcv_rnid(vport, elsiocb, ndlp);
 		if (newnode)
-			lpfc_nlp_put(ndlp);
+			lpfc_disc_state_machine(vport, ndlp, NULL,
+					NLP_EVT_DEVICE_RM);
 		break;
 	case ELS_CMD_RTV:
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
@@ -8887,7 +8893,8 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		phba->fc_stat.elsRcvRTV++;
 		lpfc_els_rcv_rtv(vport, elsiocb, ndlp);
 		if (newnode)
-			lpfc_nlp_put(ndlp);
+			lpfc_disc_state_machine(vport, ndlp, NULL,
+					NLP_EVT_DEVICE_RM);
 		break;
 	case ELS_CMD_RRQ:
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
@@ -8897,7 +8904,8 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		phba->fc_stat.elsRcvRRQ++;
 		lpfc_els_rcv_rrq(vport, elsiocb, ndlp);
 		if (newnode)
-			lpfc_nlp_put(ndlp);
+			lpfc_disc_state_machine(vport, ndlp, NULL,
+					NLP_EVT_DEVICE_RM);
 		break;
 	case ELS_CMD_ECHO:
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
@@ -8907,7 +8915,8 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		phba->fc_stat.elsRcvECHO++;
 		lpfc_els_rcv_echo(vport, elsiocb, ndlp);
 		if (newnode)
-			lpfc_nlp_put(ndlp);
+			lpfc_disc_state_machine(vport, ndlp, NULL,
+					NLP_EVT_DEVICE_RM);
 		break;
 	case ELS_CMD_REC:
 		/* receive this due to exchange closed */
@@ -8938,7 +8947,8 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 				 "0115 Unknown ELS command x%x "
 				 "received from NPORT x%x\n", cmd, did);
 		if (newnode)
-			lpfc_nlp_put(ndlp);
+			lpfc_disc_state_machine(vport, ndlp, NULL,
+					NLP_EVT_DEVICE_RM);
 		break;
 	}
 
@@ -8952,7 +8962,8 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 				    NULL);
 		/* Remove the reference from above for new nodes. */
 		if (newnode)
-			lpfc_nlp_put(ndlp);
+			lpfc_disc_state_machine(vport, ndlp, NULL,
+					NLP_EVT_DEVICE_RM);
 	}
 
 	/* Release the reference on this elsiocb, not the ndlp. */
-- 
2.26.2


--0000000000001b05bc05b42a3f9d
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQPwYJKoZIhvcNAQcCoIIQMDCCECwCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg2UMIIE6DCCA9CgAwIBAgIOSBtqCRO9gCTKXSLwFPMwDQYJKoZIhvcNAQELBQAwTDEgMB4GA1UE
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
2HLO02JQZR7rkpeDMdmztcpHWD9fMIIFQTCCBCmgAwIBAgIMfmKtsn6cI8G7HjzCMA0GCSqGSIb3
DQEBCwUAMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMwMQYDVQQD
EypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMwHhcNMjAwOTE3MDU0
NjI0WhcNMjIwOTE4MDU0NjI0WjCBjDELMAkGA1UEBhMCSU4xEjAQBgNVBAgTCUthcm5hdGFrYTES
MBAGA1UEBxMJQmFuZ2Fsb3JlMRYwFAYDVQQKEw1Ccm9hZGNvbSBJbmMuMRQwEgYDVQQDEwtKYW1l
cyBTbWFydDEnMCUGCSqGSIb3DQEJARYYamFtZXMuc21hcnRAYnJvYWRjb20uY29tMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0B4Ym0dby5rc/1eyTwvNzsepN0S9eBGyF45ltfEmEmoe
sY3NAmThxJaLBzoPYjCpfPWh65cxrVIOw9R3a9TrkDN+aISE1NPyyHOabU57I8bKvfS8WMpCQKSJ
pDWUbzanP3MMP4C2qbJgQW+xh9UDzBi8u69f40kP+cLEPNJWbz0KxNNp7H/4zWNyTouJRtO6QKVh
XqR+mg0QW4TJlH5sJ7NIbVGZKzs0PEbUJJJw0zJsp3m0iS6AzNFtTGHWVO1me58DIYR/VDSiY9Sh
AanDaJF6fE9TEzbfn5AWgVgHkbqS3VY3Gq05xkLhRugDQ60IGwT29K1B+wGfcujKSaalhQIDAQAB
o4IBzzCCAcswDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggrBgEFBQcwAoZB
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNpZ24yc2hhMmcz
b2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3BlcnNv
bmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwRAYDVR0fBD0w
OzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMu
Y3JsMCMGA1UdEQQcMBqBGGphbWVzLnNtYXJ0QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUUXCHNA1n5KXj
CXL1nHkJ8oKX5wYwDQYJKoZIhvcNAQELBQADggEBAGQDKmIdULu06w+bE15XZJOwlarihiP2PHos
/4bNU3NRgy/tCQbTpJJr3L7LU9ldcPam9qQsErGZKmb5ypUjVdmS5n5M7KN42mnfLs/p7+lOOY5q
ZwPZfsjYiUuaCWDGMvVpuBgJtdADOE1v24vgyyLZjtCbvSUzsgKKda3/Z/iwLFCRrIogixS1L6Vg
2JU2wwirL0Sy5S1DREQmTMAuHL+M9Qwbl+uh/AprkVqaSYuvUzWFwBVgafOl2XgGdn8r6ubxSZhX
9SybOi1fAXGcISX8GzOd85ygu/3dFqvMyCBpNke4vdweIll52KZIMyWji3y2PKJYfgqO+bxo7BAa
ROYxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDH5i
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgSZE8teLyg/rU7UuR
qmOKayJKju67tWfEj6TSN/V5wT0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMTE1MTkyNzAzWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAHPBhhNDwoPqbTNbW1uDbWbEvxRpGQvWOLbG
K5SrRRnbupxx1D5lDj36Lm4KcENvimr0EphoCq9VSJGUQ0X27euB9pVoBHflyObIJNs+6KVimWAd
gkhE4Ule3C5coTG2HBBltbLwtZEbAteUbh0h2767XWgZACO9Nbw8BUiWf8Nuaqksp9OP5t/3i4aj
XH/f9EInys1iMI2P8uIBU9DjWLONMWuMD/AduVOYh7DAb4S6ueqpoZo3zFGv1tBDlFfQvYgkuU/B
FtX+jRthkCLxlXfVTK12hh6uwQ3SRRJjaULqPntomgB2RTR0CutbSy7xZh+aPNm7XGDDWNN39kXa
WnE=
--0000000000001b05bc05b42a3f9d--
