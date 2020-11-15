Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FE6BC6369E
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B95B223C7
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Godntm84"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgKOT1B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Nov 2020 14:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727860AbgKOT07 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Nov 2020 14:26:59 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E19EC0613D1
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:26:59 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id k7so7044471plk.3
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=e/u2ZoJQbj2IzJl8PjjpVEk1NV/fO64VdkAnbytPHv4=;
        b=Godntm84UUb3O4bomj6gIVAfx5AAYfiSBNUg3JRux2QxCD9RIAA7q7uRIRyGiX2i7b
         4efz/zpgj3DdD06ltHNsajckKSqI0mNLXjI731Xfc5kcDkJ58EgjL4+/XTKk3n+HHsOs
         ydjKVVmyhGJJyR3BdLLHmZxlHUGLKElWMeVHU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=e/u2ZoJQbj2IzJl8PjjpVEk1NV/fO64VdkAnbytPHv4=;
        b=VymLij6xBWHKNLLKW0vqkbuAk9g4kVh/9Pg5m0VLSQB4GmbsrkWYxoUUrIYLuPFX1J
         W5XID49mBtcL9zEPvH7tRzfObhbMrc+unyTQvm9+QACRNiQrie4S8dBqblXKRyVbqIqq
         rfvRvkJIW4889cwhEY7p5SPq+nP2PkdlkgZ+IYM8m0nB6Pp6hi8dOzgUy+z5CdTZIv2l
         XiprHTGAbVCFNU5y7YA9aU3k1aLPFGIKsVWWzBAUqQrqdDodIx2O8OeH+IMkPrZqdzEb
         hAbwOX4Nu9LVFbvClTYA92kdigpVarNQJ1UgDJ0syXDg+4207Jv4Y4wwALbb7yVfoEeb
         ABZw==
X-Gm-Message-State: AOAM532QLA5DQTTIZEKoNfGfHUj0XvEJMmKB6EnxTERv8sL3RZNXNg/u
        212fD9clwzj7LkJ4FxlOniaG5G4aAK61i3BT8Wg/Tm1mGup8NUlyPpfX0u/mSqg7GfUxKP4eFEs
        kpzDiSC0m0sKgO0YXsDzvc/x2Bp5J8uCETYFv46vQdhuMknf8pJrsa+obUz1s6TUSjBx4SGdytX
        /rzc4=
X-Google-Smtp-Source: ABdhPJwWAH3H1JHO7YQsX+k+Lx9eb1/LfG3BiAhF8pZs7O9HQCOVb2ZrKB4DraMe2541FrfitdOvhw==
X-Received: by 2002:a17:902:aa8a:b029:d3:c9dd:77d1 with SMTP id d10-20020a170902aa8ab02900d3c9dd77d1mr10221065plr.0.1605468417748;
        Sun, 15 Nov 2020 11:26:57 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v126sm15864604pfb.137.2020.11.15.11.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 11:26:56 -0800 (PST)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 03/17] lpfc: Fix removal of scsi transport device get and put on dev structure
Date:   Sun, 15 Nov 2020 11:26:32 -0800
Message-Id: <20201115192646.12977-4-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201115192646.12977-1-james.smart@broadcom.com>
References: <20201115192646.12977-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000c8534c05b42a3e4f"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000c8534c05b42a3e4f
Content-Transfer-Encoding: 8bit

The lpfc driver is calling get_device and put_device on scsi_fc_transport
device structure. When this code was removed, the driver triggered an
Oops in "scsi_is_host_dev" when the first scsi target was unregistered
from the transport.

The reason the calls were necessary is that the driver is calling
scsi_remove_host too early, before the target rports are unregistered
and the scsi devices disconnected from the scsi_host.  The fc_host was
torn down during fc_remove_host.

Fix by moving the lpfc_pci_remove_one_s3/s4 calls to scsi_remove_host to
after the nodes are cleaned up.  Remove the get_device and put_device
calls and the supporting code.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c     |  4 ----
 drivers/scsi/lpfc/lpfc_hbadisc.c | 12 ++----------
 drivers/scsi/lpfc/lpfc_init.c    | 14 +++++++++-----
 drivers/scsi/lpfc/lpfc_vport.c   |  6 ++++--
 4 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 2d7a4a920ba4..b56dc69ff2b2 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1601,7 +1601,6 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 	u32 keep_nlp_fc4_type = 0;
 	struct lpfc_nvme_rport *keep_nrport = NULL;
 	int  put_node;
-	int  put_rport;
 	unsigned long *active_rrqs_xri_bitmap = NULL;
 
 	/* Fabric nodes can have the same WWPN so we don't bother searching
@@ -1804,13 +1803,10 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 		if (rport) {
 			rdata = rport->dd_data;
 			put_node = rdata->pnode != NULL;
-			put_rport = ndlp->rport != NULL;
 			rdata->pnode = NULL;
 			ndlp->rport = NULL;
 			if (put_node)
 				lpfc_nlp_put(ndlp);
-			if (put_rport)
-				put_device(&rport->dev);
 		}
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 9d387fbf65a3..71ef50c65dcf 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -117,7 +117,6 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	struct lpfc_hba   *phba;
 	struct lpfc_work_evt *evtp;
 	int  put_node;
-	int  put_rport;
 	unsigned long iflags;
 
 	rdata = rport->dd_data;
@@ -142,13 +141,10 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	 */
 	if (vport->load_flag & FC_UNLOADING) {
 		put_node = rdata->pnode != NULL;
-		put_rport = ndlp->rport != NULL;
 		rdata->pnode = NULL;
 		ndlp->rport = NULL;
 		if (put_node)
 			lpfc_nlp_put(ndlp);
-		if (put_rport)
-			put_device(&rport->dev);
 		return;
 	}
 
@@ -263,7 +259,6 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 		ndlp->rport = NULL;
 		if (put_node)
 			lpfc_nlp_put(ndlp);
-		put_device(&rport->dev);
 
 		return fcf_inuse;
 	}
@@ -284,7 +279,6 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 	ndlp->rport = NULL;
 	if (put_node)
 		lpfc_nlp_put(ndlp);
-	put_device(&rport->dev);
 
 	if (ndlp->nlp_type & NLP_FABRIC)
 		return fcf_inuse;
@@ -4190,8 +4184,6 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 				lpfc_nlp_put(ndlp);
 			rdata->pnode = NULL;
 		}
-		/* drop reference for earlier registeration */
-		put_device(&rport->dev);
 	}
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_RPORT,
@@ -4203,7 +4195,7 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		return;
 
 	ndlp->rport = rport = fc_remote_port_add(shost, 0, &rport_ids);
-	if (!rport || !get_device(&rport->dev)) {
+	if (!rport) {
 		dev_printk(KERN_WARNING, &phba->pcidev->dev,
 			   "Warning: fc_remote_port_add failed\n");
 		return;
@@ -4244,6 +4236,7 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	    (rport->scsi_target_id < LPFC_MAX_TARGET)) {
 		ndlp->nlp_sid = rport->scsi_target_id;
 	}
+
 	return;
 }
 
@@ -5217,7 +5210,6 @@ lpfc_nlp_remove(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		rdata = rport->dd_data;
 		rdata->pnode = NULL;
 		ndlp->rport = NULL;
-		put_device(&rport->dev);
 	}
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index add2eb0d729b..72448287a3d1 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12499,12 +12499,15 @@ lpfc_pci_remove_one_s3(struct pci_dev *pdev)
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
 
-	/* Remove FC host and then SCSI host with the physical port */
+	/* Remove FC host with the physical port */
 	fc_remove_host(shost);
-	scsi_remove_host(shost);
 
+	/* Clean up all nodes, mailboxes and IOs. */
 	lpfc_cleanup(vport);
 
+	/* Remove the shost now that the devices connections are lost. */
+	scsi_remove_host(shost);
+
 	/*
 	 * Bring down the SLI Layer. This step disable all interrupts,
 	 * clears the rings, discards all mailbox commands, and resets
@@ -13342,7 +13345,6 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
 	vport->load_flag |= FC_UNLOADING;
 	spin_unlock_irq(&phba->hbalock);
 
-	/* Free the HBA sysfs attributes */
 	lpfc_free_sysfs_attr(vport);
 
 	/* Release all the vports against this physical port */
@@ -13355,9 +13357,8 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
 
-	/* Remove FC host and then SCSI host with the physical port */
+	/* Remove FC host with the physical port */
 	fc_remove_host(shost);
-	scsi_remove_host(shost);
 
 	/* Perform ndlp cleanup on the physical port.  The nvme and nvmet
 	 * localports are destroyed after to cleanup all transport memory.
@@ -13370,6 +13371,9 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
 	if (phba->cfg_xri_rebalancing)
 		lpfc_destroy_multixri_pools(phba);
 
+	/* Remove the shost now that the devices connections are lost. */
+	scsi_remove_host(shost);
+
 	/*
 	 * Bring down the SLI Layer. This step disables all interrupts,
 	 * clears the rings, discards all mailbox commands, and resets
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index 6ab78131b94d..0261495b44d3 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -664,9 +664,8 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 		ns_ndlp_referenced = true;
 	}
 
-	/* Remove FC host and then SCSI host with the vport */
+	/* Remove FC host to break driver binding. */
 	fc_remove_host(shost);
-	scsi_remove_host(shost);
 
 	ndlp = lpfc_findnode_did(phba->pport, Fabric_DID);
 
@@ -747,6 +746,9 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 	}
 
 	lpfc_cleanup(vport);
+
+	/* Remove scsi host now.  The nodes are cleaned up. */
+	scsi_remove_host(shost);
 	lpfc_sli_host_down(vport);
 
 	lpfc_stop_vport_timers(vport);
-- 
2.26.2


--000000000000c8534c05b42a3e4f
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
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgcWAcahPwRInJw8CE
EitIG5deoxDFBy8k2EwRBQuADnIwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMTE1MTkyNjU4WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAK6a5i3YsEiXvM50NthhZULMKMfjLcMOJ6sk
b1OuygNKz0hTcNGXgyksQyWbEjbknT8s0ZASGOpIIjtAQ3YdFBZh5MvUTlN3xQiNQebE3taxTSBb
V+I6EV8ST1OuM+jKfJtXEFJYXFR8fezc9VmY6AtSjmkeo2jUojCayxBsd0t+bAyFGTLJ5RdU6HiB
FfEswPggtCyB6BJimuphcAyBVv6Dn9X9yHWh07qL47a2tMutSZAQCzL9c8ygKww21ah+zVUhfc9x
eqJufFT3y0fash04V3lHjD45dU0Lla1DVTcTznj5z6HFK4kF4FrzFrxV4a1vh1l9DNKzPxhq3OmT
L0c=
--000000000000c8534c05b42a3e4f--
