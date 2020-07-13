Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1419CC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E72EC20674
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GOrvNZyG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725969AbgGMHrC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 03:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729130AbgGMHrA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 03:47:00 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50D1C061755
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:46:59 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f2so14621292wrp.7
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Uxo2DH0sWgHFikhlDzsPIQecz45jNH2LIUT7ZFPJRdc=;
        b=GOrvNZyGD/PoyYcKlVxeUmDl6NKujK+VozGRKnT3zzrkL/K+gDrsH3ctdT5eT7xjON
         CI8WLL8IO54NfYHE3fA1PKqWCzxHUOPO0kEoBGt8xKczCtNVVVQWmakkIWJoHWG/RI81
         AzEj8CAToo56PyuMUBzcNY4aBlYAOHp8uetE7mrx0DR4P1ITJB0buL05HPW9DzzNCXeR
         M4icB1yrctRI8HC+zYv+RejU7jRJOCWso8hGU7uORogO5uHkiqcV8JwXa9ZJWYvzIZtC
         ZxgXj5QEtmpzu94HC2QYmQzKef5UbIVr9AIRZfNorDYl7Vb0AcO+sfwYwZdrBaUmUXzT
         BxDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Uxo2DH0sWgHFikhlDzsPIQecz45jNH2LIUT7ZFPJRdc=;
        b=Zc7T8tIHGxBDqiO5JnIGP7K9pb7jSE4GhklPa3RrIKcquckXXuBRfaZhT6LxcyhRHw
         7eUUSC+PgHkNtVPk5AzrgZR51F4INhvc3C9TOOb+/oKb5SpSfnpQOKxYM9014QH7oP4R
         6ApW74NfIvKG903PrBZVETSz/v7azc+0XO6HxT4CkLw1xl0x+MB1zqsBCZbEiN+YARXd
         Mxh/1I3VRtHSTXUD+VfQxJhPdTud7EO6ne5LFgzuSvU77u4rUkILi5cGvJ3+26ykMba8
         dNpWWc+9Vt9Hyzljq1Rx8T7/7G4M07K+zIP0lUMUDE+f4Msi9qz9i6FjFZtSRiwUdERW
         Qvhw==
X-Gm-Message-State: AOAM530k51yUJXpe4xUkQkZbQ8YckJ6+q4WSt8/ofRVFPzq6lTq7A1d4
        0WIRTLp3XF/eICcrVxy7H8zwEA==
X-Google-Smtp-Source: ABdhPJyLQGOD11n3K0Dn7RXnp5axnbqb5mW/JmFabQxC/B3pAqylPcRRFM9rhr2eMJG2NFlgSsbaQQ==
X-Received: by 2002:adf:f20a:: with SMTP id p10mr83082724wro.41.1594626418436;
        Mon, 13 Jul 2020 00:46:58 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id k11sm25142488wrd.23.2020.07.13.00.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 00:46:57 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v2 10/29] scsi: libfc: fc_lport: Repair function parameter documentation
Date:   Mon, 13 Jul 2020 08:46:26 +0100
Message-Id: <20200713074645.126138-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713074645.126138-1-lee.jones@linaro.org>
References: <20200713074645.126138-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Either misdocumentation and/or bitrot.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/libfc/fc_lport.c:412: warning: Function parameter or member 'in_fp' not described in 'fc_lport_recv_echo_req'
 drivers/scsi/libfc/fc_lport.c:412: warning: Excess function parameter 'fp' description in 'fc_lport_recv_echo_req'
 drivers/scsi/libfc/fc_lport.c:447: warning: Function parameter or member 'in_fp' not described in 'fc_lport_recv_rnid_req'
 drivers/scsi/libfc/fc_lport.c:447: warning: Excess function parameter 'fp' description in 'fc_lport_recv_rnid_req'
 drivers/scsi/libfc/fc_lport.c:1330: warning: Function parameter or member 'state' not described in 'fc_lport_enter_ns'
 drivers/scsi/libfc/fc_lport.c:1428: warning: Function parameter or member 'state' not described in 'fc_lport_enter_ms'
 drivers/scsi/libfc/fc_lport.c:1939: warning: Function parameter or member 'tov' not described in 'fc_lport_els_request'

Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/libfc/fc_lport.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 684c5e361a286..b84dbc316df15 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -405,7 +405,7 @@ static void fc_lport_recv_rlir_req(struct fc_lport *lport, struct fc_frame *fp)
 /**
  * fc_lport_recv_echo_req() - Handle received ECHO request
  * @lport: The local port receiving the ECHO
- * @fp:	   ECHO request frame
+ * @in_fp: ECHO request frame
  */
 static void fc_lport_recv_echo_req(struct fc_lport *lport,
 				   struct fc_frame *in_fp)
@@ -440,7 +440,7 @@ static void fc_lport_recv_echo_req(struct fc_lport *lport,
 /**
  * fc_lport_recv_rnid_req() - Handle received Request Node ID data request
  * @lport: The local port receiving the RNID
- * @fp:	   The RNID request frame
+ * @in_fp: The RNID request frame
  */
 static void fc_lport_recv_rnid_req(struct fc_lport *lport,
 				   struct fc_frame *in_fp)
@@ -1325,6 +1325,7 @@ static void fc_lport_enter_scr(struct fc_lport *lport)
 /**
  * fc_lport_enter_ns() - register some object with the name server
  * @lport: Fibre Channel local port to register
+ * @state: Local port state
  */
 static void fc_lport_enter_ns(struct fc_lport *lport, enum fc_lport_state state)
 {
@@ -1423,6 +1424,7 @@ static void fc_lport_enter_dns(struct fc_lport *lport)
 /**
  * fc_lport_enter_ms() - management server commands
  * @lport: Fibre Channel local port to register
+ * @state: Local port state
  */
 static void fc_lport_enter_ms(struct fc_lport *lport, enum fc_lport_state state)
 {
@@ -1932,6 +1934,7 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
  * @job:   The BSG Passthrough job
  * @lport: The local port sending the request
  * @did:   The destination port id
+ * @tov:   The timeout period (in ms)
  */
 static int fc_lport_els_request(struct bsg_job *job,
 				struct fc_lport *lport,
-- 
2.25.1

