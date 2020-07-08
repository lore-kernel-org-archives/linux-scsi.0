Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCF57C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9327620739
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:04:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Z3S73qsa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729086AbgGHMCp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729064AbgGHMCm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:02:42 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1AE3C08E6DC
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 05:02:40 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id w3so2727773wmi.4
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 05:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Uxo2DH0sWgHFikhlDzsPIQecz45jNH2LIUT7ZFPJRdc=;
        b=Z3S73qsah5B8+M25GHxcQW+vj3SVCTqzm1ZlGRZ0+H8kgseFbUABdfEfgOjC57ppOK
         Q97RVVqZ637x9jvt5B2zLnHqSjfhVMYGCu1bls1xTQ3YttGwRZGOZfAa7PBYMTI2ClVg
         SmMBa+L1gVMEbt8QpDFbITW3gGVAhE4favEtUYlxg5OuzdFwhtOwoYqhXRkLSdDi/DDe
         fao1vr/hLdJ69C2pQdevkwSQz4cST/FiGxoBI9rzcw72I4tfvpnVIa4HcJ5oWMTDRLEi
         geLBR44wwsUeYQbwIi+/mky8bLBcjUfK1HtyoqvSLiBmpEeGxzTLGSg7/8+OApchBLhj
         PaYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Uxo2DH0sWgHFikhlDzsPIQecz45jNH2LIUT7ZFPJRdc=;
        b=B/FIWxrNH5xN4c34ntazqIxF1wy95OQFT5PXBU7rv+VSZqeipJLkisiII1jCZ723j6
         tz+QfSbBkmfZqTRh9bnlPTBkPt2hbYp1wtUmr4wBS05LFaQhdMWzieh0ehZTxLx2kt/V
         tvNsZSz0ab22E7OsqYTqFGqYNh5VN1VI4+9Nt9mz2QwwrwXndoOCQO3LBjs0PQikJeh5
         IxupC/4G4q0rLXq9IWR8ya8Nsf8rc/qiqzYyGVfPhU0Kur3yifyB8K4qGSRIy6QshezC
         MrviUbmmmg2eG07LgihC978bZPIlIlhzBjIzUwtpuOQv8q/kZ427Y+Z1728BoAoApWkH
         ZqSQ==
X-Gm-Message-State: AOAM533YJ8y9ij9dpMeDjl8R7d/yfnu0DJa3INdJoNS+ZoInW/9lYJLD
        GxHwSj1rAYqUZAjd+8ig62i7EVccMGE=
X-Google-Smtp-Source: ABdhPJxFIlIFPqh41Y8DKlp3BF/310Wa9qNRIhGkrdPXnp1+GeFiGn2wK8WWSc2XAV6/+rhh3J8i6g==
X-Received: by 2002:a1c:2485:: with SMTP id k127mr8790621wmk.138.1594209759339;
        Wed, 08 Jul 2020 05:02:39 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id m62sm3964997wmm.42.2020.07.08.05.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:02:38 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/30] scsi: libfc: fc_lport: Repair function parameter documentation
Date:   Wed,  8 Jul 2020 13:02:01 +0100
Message-Id: <20200708120221.3386672-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708120221.3386672-1-lee.jones@linaro.org>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
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

