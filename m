Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B75EC43381
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE5E064E33
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhCQI5T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 04:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhCQI5K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 04:57:10 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A101C061760
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:10 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id x16so959983wrn.4
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8874Mz34yg9EJ3yZWmxIP9iMB3o9NkD0mVwqsVKhHmY=;
        b=CKGmUYUpwZOzR8gWVNitbosI+8/vpSWLSEKNDwLKELUv3oIDgkyAcSWNJ1I5tm2Tm0
         fWChB1QAcqLYtX3s55tGvEnRd6Iv3yDx2McS/qNnBUQiQunGSgSjqeRBtIgw145CVnwy
         E8bUdNlN5G9AbMeMHeFDezFROeobMZ/nUT6VygBS95Z1itSTFrj+z75Rt66xA6zAKE4A
         BMrqd5ci1eeuTE+EtSQHNoaV7LAPi7MoZpS/Q5a1yuyySHlMwqHq31SB1bnFqe2KP5r2
         5g+B5Mf0WaUGL4ogMCQb3VJd65aO1QhZFG/WPap7I37mB9ezpbGlkv8svlW1drpd9hjb
         NEOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8874Mz34yg9EJ3yZWmxIP9iMB3o9NkD0mVwqsVKhHmY=;
        b=Gn78MnvTrZBx109kFD0nGTwOdipO+WYx87vro+nb5XDPMe1tuH841iLgHcApgVDAUX
         U2aJfJvZErGb17drf0dvtjs5f45JQ0Q03aP9WV10bgvk8L0XFDOFa6MWDSqfeFGyCAOh
         5ejAEvJc3lUfxeyZ0Lpsi5xViMEvETDMOHSCoG/WItOLe9ta+UP2dG0brQ3gv8GOqg53
         VVcJrpUPO/GPGtmgW9fZt6csSH0VN2X5Qz0RRtO1bMAQV/nLqD+/dG9CI2a+Fw3N+ZOY
         YKVDjgSjifYtAqPe44Fj0nKbFe/SdO14MNEBaST3sQkPYgahOVexkn3W3vasSN+oc40K
         8lUA==
X-Gm-Message-State: AOAM530WkB7hbp9PD5gmJCtLJ1rGfQifeuyPBX67W7CIpybw8bdXB3g8
        gRPaHbU+qdJbwyB04ljbonFaVA==
X-Google-Smtp-Source: ABdhPJwEaEN+lO1BXC85/Urtt4ByXSxTUMs35cKgWOXH1pfSrxv2rxSZ3Hld1wBvoRvtOu/5jLnYkA==
X-Received: by 2002:adf:8b4e:: with SMTP id v14mr2190343wra.103.1615971429053;
        Wed, 17 Mar 2021 01:57:09 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id j123sm1807243wmb.1.2021.03.17.01.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 01:57:08 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 03/18] scsi: bfa: bfa_fcs_lport: Move a large struct from the stack onto the heap
Date:   Wed, 17 Mar 2021 08:56:46 +0000
Message-Id: <20210317085701.2891231-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317085701.2891231-1-lee.jones@linaro.org>
References: <20210317085701.2891231-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/bfa/bfa_fcs_lport.c: In function ‘bfa_fcs_lport_fdmi_build_rhba_pyld’:
 drivers/scsi/bfa/bfa_fcs_lport.c:2152:1: warning: the frame size of 1200 bytes is larger than 1024 bytes [-Wframe-larger-than=]

Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/bfa/bfa_fcs_lport.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 49a14157f123c..b12afcc4b1894 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -1408,7 +1408,7 @@ static void     bfa_fcs_lport_fdmi_rpa_response(void *fcsarg,
 					       u32 resid_len,
 					       struct fchs_s *rsp_fchs);
 static void     bfa_fcs_lport_fdmi_timeout(void *arg);
-static u16 bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi,
+static int bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi,
 						  u8 *pyld);
 static u16 bfa_fcs_lport_fdmi_build_rprt_pyld(struct bfa_fcs_lport_fdmi_s *fdmi,
 						  u8 *pyld);
@@ -1887,6 +1887,8 @@ bfa_fcs_lport_fdmi_send_rhba(void *fdmi_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 		bfa_fcs_lport_fdmi_build_rhba_pyld(fdmi,
 					  (u8 *) ((struct ct_hdr_s *) pyld
 						       + 1));
+	if (attr_len < 0)
+		return;
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 			  FC_CLASS_3, (len + attr_len), &fchs,
@@ -1896,17 +1898,20 @@ bfa_fcs_lport_fdmi_send_rhba(void *fdmi_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	bfa_sm_send_event(fdmi, FDMISM_EVENT_RHBA_SENT);
 }
 
-static          u16
+static int
 bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 {
 	struct bfa_fcs_lport_s *port = fdmi->ms->port;
-	struct bfa_fcs_fdmi_hba_attr_s hba_attr;
-	struct bfa_fcs_fdmi_hba_attr_s *fcs_hba_attr = &hba_attr;
+	struct bfa_fcs_fdmi_hba_attr_s *fcs_hba_attr;
 	struct fdmi_rhba_s *rhba = (struct fdmi_rhba_s *) pyld;
 	struct fdmi_attr_s *attr;
+	int        len;
 	u8        *curr_ptr;
-	u16        len, count;
-	u16	templen;
+	u16	templen, count;
+
+	fcs_hba_attr = kzalloc(sizeof(*fcs_hba_attr), GFP_KERNEL);
+	if (!fcs_hba_attr)
+		return -ENOMEM;
 
 	/*
 	 * get hba attributes
@@ -2148,6 +2153,9 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	len += ((sizeof(attr->type) + sizeof(attr->len)) * count);
 
 	rhba->hba_attr_blk.attr_count = cpu_to_be32(count);
+
+	kfree(fcs_hba_attr);
+
 	return len;
 }
 
-- 
2.27.0

