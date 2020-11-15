Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F658C6379F
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEABF223C7
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="C+bZxa65"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgKOT1I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Nov 2020 14:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727861AbgKOT1F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Nov 2020 14:27:05 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D382BC0613CF
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:27:05 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id a18so11348036pfl.3
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=gqZlVEbVNSBZRqbcxyKX9YCI1715XhxSCPftVUufgy4=;
        b=C+bZxa65r48qLYLcRcMG2YP0vUEqbf3CysIz3WtLrGnrWGG65dGLBnwKeibOpbKVpR
         oAcnBTek6G/d6VJ0D1DnBFZrNTzKCAjd+Q84bJVPtMS0kSCaQeR+3xBPPepurY34pXbk
         xk2F8dI/zF4NiG/GX4hAauRgd22s6ksOHEjwQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=gqZlVEbVNSBZRqbcxyKX9YCI1715XhxSCPftVUufgy4=;
        b=P44lxKub57fBFY7eESUN/jiL2kwlhZaLqdxKYtn4L0UGyG6Kqx0Nq8DrIyE4sydoo0
         g48gDQiERZKAyEGdJdfGcgP7dev990h6ER60SiTMO2iePzyjg7c3Zu4Kw4dEDNe7Bmxr
         EhHHae9iMIimvYIoR8LSyhrauYaqL0INujoeq201hY6TObFDkY9V53kwNtCmwT/zaB2j
         h4YrAJtNz08+302NZN8QRjktzwDYX5vAw8sTiDHgIOzVjGax3Mo/kEWtmApfP+WhfcEn
         pLklSaKeGZLr7vQMADL65lz05/kwJiPvagF5A3TLmfr5vRQbpntXNonT5l3GMr5J1L3b
         xfJg==
X-Gm-Message-State: AOAM5305giLa0ijHfy3y1TMO5rnS9nKMTJG2x4eCj39rlBVEQ9Lbm0FF
        5UiAhDvGB41Ci8SpOYAk5LGU9bGTjOZu4NWh3Ku6uYGxSCgtOj8opVvjUC9K95ulsPAY+Sr2vqu
        N73qRqgMuBNRs4ldbdA9lwTBsfX6ZqYI2tosiEJIJ8KBXSLWUicuDesGDLzPQhVvp86958G8t6+
        +p5mc=
X-Google-Smtp-Source: ABdhPJzFtA6jffGRPydsxBdPk1kZsh/rDOHQt61wXzoE8+CJP8E6pAPHccCXgTUKunjCXTQgL1QOTA==
X-Received: by 2002:a62:17c8:0:b029:18b:5a97:a8d1 with SMTP id 191-20020a6217c80000b029018b5a97a8d1mr10887092pfx.15.1605468424825;
        Sun, 15 Nov 2020 11:27:04 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v126sm15864604pfb.137.2020.11.15.11.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 11:27:03 -0800 (PST)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 08/17] lpfc: Fix NPIV discovery and Fabric Node detection
Date:   Sun, 15 Nov 2020 11:26:37 -0800
Message-Id: <20201115192646.12977-9-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201115192646.12977-1-james.smart@broadcom.com>
References: <20201115192646.12977-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000003094f305b42a3fe4"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000003094f305b42a3fe4
Content-Transfer-Encoding: 8bit

While testing NPIV and link bounces, the vport would not show a fabric
node for the F_Port, would not transition into NPR state during a link
fault, or leave the FDMI node untouched during error injection. Cause
for this was determined to be an inconsistent manner in which F_Port,
Nameserver, and FDMI controller nodes were created and linked. In some
cases, the nodes would never be unregistered from the transport, leaving
references active. In other cases, the fabric nodes may register with
the transport multiple times while still registered.

The following changes were made:
- Fix the FDISC issue routine, which starts vport (re)creation, to mark
  the F_Port as a fabric node (NLP_FABRIC) and allow the F_Port node to
  fully be created and show up in the node list.
- When remote ports are cleaned up on vport termination, cleanup the
  nameserver and FDMI controller nodes on the vport so they unregister
  from the transport.
- On link bounces, don't exclude the NPIV Fabric remote ports from
  transitioning to the NPR state, allowing them to avoid re-registration
  if already registered.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c     |  4 ++++
 drivers/scsi/lpfc/lpfc_hbadisc.c | 11 +++++------
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 45a8ebbf60bc..6fc42c978730 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1508,6 +1508,10 @@ lpfc_initial_fdisc(struct lpfc_vport *vport)
 		ndlp = lpfc_nlp_init(vport, Fabric_DID);
 		if (!ndlp)
 			return 0;
+
+		/* NPIV is only supported in Fabrics. */
+		ndlp->nlp_type |= NLP_FABRIC;
+
 		/* Put ndlp onto node list */
 		lpfc_enqueue_node(vport, ndlp);
 	}
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index ac05d188f816..f3cf988733c2 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -818,12 +818,13 @@ lpfc_cleanup_rpis(struct lpfc_vport *vport, int remove)
 	struct lpfc_nodelist *ndlp, *next_ndlp;
 
 	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
-
 		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
 			continue;
+
 		if ((phba->sli3_options & LPFC_SLI3_VPORT_TEARDOWN) ||
-			((vport->port_type == LPFC_NPIV_PORT) &&
-			(ndlp->nlp_DID == NameServer_DID)))
+		    ((vport->port_type == LPFC_NPIV_PORT) &&
+		     ((ndlp->nlp_DID == NameServer_DID) ||
+		      (ndlp->nlp_DID == FDMI_DID))))
 			lpfc_unreg_rpi(vport, ndlp);
 
 		/* Leave Fabric nodes alone on link down */
@@ -1037,9 +1038,7 @@ lpfc_linkup_port(struct lpfc_vport *vport)
 	vport->fc_ns_retry = 0;
 	spin_unlock_irq(shost->host_lock);
 
-	if (vport->fc_flag & FC_LBIT)
-		lpfc_linkup_cleanup_nodes(vport);
-
+	lpfc_linkup_cleanup_nodes(vport);
 }
 
 static int
-- 
2.26.2


--0000000000003094f305b42a3fe4
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
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
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg3egHBwrDd06jEooE
14BahImqL2z+qSVc1bY59OORI6wwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMTE1MTkyNzA1WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBACvoTGkqGIzvJRMQn5yzVeiundPPAfvLXtnE
wD+9CSZruzN/g0MM0IPYjfcRTPm4/TTG378qtDvK7sRvlyC8ec9IYONlfylhnx5hdJcMX3XzZ3FI
0voxZv9zyB0rvHn4UM8Et0NnQd4pyTYcbKqPpeguPI9vUANLMb3M5Wtr6t/VDcdUjKsB9iFsmfHB
Z0eUk0Gvzfvuy7iPIIBDMzt3Fcs8fdVJdH4Rdsy251g6Rm7f4ge8oPyKZumaf7FY4XKUufpYvJCN
cVcCbiXo5KFibRG9kvtnCbQ3dRVqjTp+MZ1kjHVQyXpWw6gCYuXauhw49zKrZW3jiCAdjh6H7k6N
bFo=
--0000000000003094f305b42a3fe4--
