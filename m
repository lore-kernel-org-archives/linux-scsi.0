Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_NO_TEXT,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1734C56201
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 20:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 731EE2078E
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 20:33:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="KS6fWOUE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbgKSUdx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 15:33:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbgKSUdx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2020 15:33:53 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF73C0613CF
        for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2020 12:33:52 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id 131so5596605pfb.9
        for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2020 12:33:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=/gVskXPc6Hqs1xKEiPyWBINzaglSHF5lzQd1bmx+O7c=;
        b=KS6fWOUEyPjsFcW7Z6C0EzsLsOjV8jqlfJmwugiuzlCOAuvhvUenBy2I6QBtEY/m3l
         +2OnJTeh9BgGUmRa4oEakyirwOKrrfWxQrG4eha1EdzCgc2F516b+XaTvIxE388t9AyV
         H/z95zL1QPyoHGGuZ6CZkmB/N9D0AfyT+YtrQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=/gVskXPc6Hqs1xKEiPyWBINzaglSHF5lzQd1bmx+O7c=;
        b=Tx0FIuED/UFxbN+XCvygtTx+iw5yWYH9WJHX9eIYy1n9CTBNKw13o6HgKcNuHwoQ6k
         T8FJRgzRzfnpx+g/rX0QPD4qlnlawaFiax+M9I9xSCziHTHrm2+VKqadWpfH8nnxySnp
         F0BsQGENloCefIFBG7XM+MJ3K3C0Y/RG5vBFa5aj+izKqiqVi8EVX0F4z1RAbvzWb3ia
         P91kVEmYJ1yd0rgdgAx/nohKRiKSHQMVZxxCQs27R3ZLidbfFccR42hmQmXjH5MQQd6s
         F0nQW0vOKe+tkLlfdn7II2q5p9RwmkRPZC1s/FIJbl8+qESk4ytTb0koC0CeZqkRenTi
         WgTQ==
X-Gm-Message-State: AOAM532KTlmX09QUoDac8Fog6hYmxIJgaJgyWA1Mc3m+OO2qyfMZfLRg
        9Dc9jZw6q6uDRKlsdy0ZIYT/KZtYQC6jTuA9jYdkl0aJr6r6XqPk6zrws73qHyOnluh95kMbaFG
        gvgxCCqe7o//Xq4/YAxZtL4lYqDUmHp71XSD1RWvisMrzik5s0EbdJ/NZkUm154F8FbmZBK0cqi
        4sYCY=
X-Google-Smtp-Source: ABdhPJy0E94L/7sTkhndQSYw0yJbED/L2ujFE/KaXQIs6cezwQaREUODIEmWTGlfVLPhYniz2I8UvQ==
X-Received: by 2002:a63:fe0c:: with SMTP id p12mr13735307pgh.31.1605818031813;
        Thu, 19 Nov 2020 12:33:51 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i19sm570575pgk.44.2020.11.19.12.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 12:33:50 -0800 (PST)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] lpfc: Fix set but not used warnings from Rework remote port lock handling
Date:   Thu, 19 Nov 2020 12:33:40 -0800
Message-Id: <20201119203340.121819-1-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000006437a005b47ba587"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000006437a005b47ba587
Content-Transfer-Encoding: 8bit

Remove local variables that are set but not used.

Fixes: c6adba150191 ("scsi: lpfc: Rework remote port lock handling")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c     | 6 ------
 drivers/scsi/lpfc/lpfc_hbadisc.c | 4 ----
 drivers/scsi/lpfc/lpfc_init.c    | 2 --
 3 files changed, 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 03f47d1b21fe..10ae744a6ace 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2075,7 +2075,6 @@ int
 lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 {
 	struct lpfc_hba  *phba = vport->phba;
-	struct Scsi_Host *shost;
 	struct serv_parm *sp;
 	struct lpfc_nodelist *ndlp;
 	struct lpfc_iocbq *elsiocb;
@@ -2113,7 +2112,6 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 	if (!elsiocb)
 		return 1;
 
-	shost = lpfc_shost_from_vport(vport);
 	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~NLP_FCP_PRLI_RJT;
 	spin_unlock_irq(&ndlp->lock);
@@ -8572,7 +8570,6 @@ static void
 lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		      struct lpfc_vport *vport, struct lpfc_iocbq *elsiocb)
 {
-	struct Scsi_Host  *shost;
 	struct lpfc_nodelist *ndlp;
 	struct ls_rjt stat;
 	uint32_t *payload, payload_len;
@@ -8633,7 +8630,6 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	 * Do not process any unsolicited ELS commands
 	 * if the ndlp is in DEV_LOSS
 	 */
-	shost = lpfc_shost_from_vport(vport);
 	spin_lock_irq(&ndlp->lock);
 	if (ndlp->nlp_flag & NLP_IN_DEV_LOSS) {
 		spin_unlock_irq(&ndlp->lock);
@@ -9403,7 +9399,6 @@ void
 lpfc_retry_pport_discovery(struct lpfc_hba *phba)
 {
 	struct lpfc_nodelist *ndlp;
-	struct Scsi_Host  *shost;
 
 	/* Cancel the all vports retry delay retry timers */
 	lpfc_cancel_all_vport_retry_delay_timer(phba);
@@ -9413,7 +9408,6 @@ lpfc_retry_pport_discovery(struct lpfc_hba *phba)
 	if (!ndlp)
 		return;
 
-	shost = lpfc_shost_from_vport(phba->pport);
 	mod_timer(&ndlp->nlp_delayfunc, jiffies + msecs_to_jiffies(1000));
 	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag |= NLP_DELAY_TMO;
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index c8911a3d00ee..44eddddff0dc 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -84,7 +84,6 @@ lpfc_rport_invalid(struct fc_rport *rport)
 {
 	struct lpfc_rport_data *rdata;
 	struct lpfc_nodelist *ndlp;
-	struct lpfc_vport *vport;
 
 	if (!rport) {
 		pr_err("**** %s: NULL rport, exit.\n", __func__);
@@ -105,7 +104,6 @@ lpfc_rport_invalid(struct fc_rport *rport)
 		return -EINVAL;
 	}
 
-	vport = ndlp->vport;
 	if (!ndlp->vport) {
 		pr_err("**** %s: Null vport on ndlp %p, DID x%x rport %p "
 		       "SID x%x\n", __func__, ndlp, ndlp->nlp_DID, rport,
@@ -6195,7 +6193,6 @@ lpfc_nlp_release(struct kref *kref)
 struct lpfc_nodelist *
 lpfc_nlp_get(struct lpfc_nodelist *ndlp)
 {
-	struct lpfc_hba *phba;
 	unsigned long flags;
 
 	if (ndlp) {
@@ -6208,7 +6205,6 @@ lpfc_nlp_get(struct lpfc_nodelist *ndlp)
 		 * ndlp reference count that is in the process of being
 		 * released.
 		 */
-		phba = ndlp->phba;
 		spin_lock_irqsave(&ndlp->lock, flags);
 		if (!kref_get_unless_zero(&ndlp->kref)) {
 			spin_unlock_irqrestore(&ndlp->lock, flags);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index f4de75b2f64f..f4cf60f125f5 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5644,7 +5644,6 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba *phba,
 	int rc;
 	struct lpfc_vport *vport;
 	struct lpfc_nodelist *ndlp;
-	struct Scsi_Host  *shost;
 	int active_vlink_present;
 	struct lpfc_vport **vports;
 	int i;
@@ -5825,7 +5824,6 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba *phba,
 			 */
 			mod_timer(&ndlp->nlp_delayfunc,
 				  jiffies + msecs_to_jiffies(1000));
-			shost = lpfc_shost_from_vport(vport);
 			spin_lock_irq(&ndlp->lock);
 			ndlp->nlp_flag |= NLP_DELAY_TMO;
 			spin_unlock_irq(&ndlp->lock);
-- 
2.26.2


--0000000000006437a005b47ba587
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
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgwrl+Kl7xAtRwirjY
R9Z8df9hQ+0ntbLfaHq2dK8ijCYwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMTE5MjAzMzUyWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAH6W2qNqWp+NatyhH1Mp4bQgeWnNWAHgUbIv
0PxtfiC3va5DnM8dKbX7Nh0rzYidKGei4RGamdFEqaCnw2c2ybu/K7UE5nl94Rdk0QPd4jhOWeRC
aDG46DLvD+DJeIvO/H6oZzawHyufkWAI050VyWH+KGu5rRJDjQRU0BOU2yOlfft9bO6CflJ/BLdW
l5MwllbHLoQ+PUfIB2XPhGAwmwfnYkNzSqcE+s3GDMdsyP9ryXo0wb+BGztiVwSwD7ivhepHded4
mXwCSKAXRju5XY+q5k7MfdREbeYPa158ozdeVxuqLVZmuyYCgGCF2uBQXlD7YxAJ6lwpMMfCysqI
Bcc=
--0000000000006437a005b47ba587--
