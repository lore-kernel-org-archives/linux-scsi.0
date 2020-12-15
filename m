Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68DD5C2BB48
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 16:11:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3464E221EA
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 16:11:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730843AbgLOQKs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 11:10:48 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33738 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729486AbgLOPpf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Dec 2020 10:45:35 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BFFVneG001077
        for <linux-scsi@vger.kernel.org>; Tue, 15 Dec 2020 07:44:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pfpt0220;
 bh=OxPTJiQ4qBxkP6NZ8LAnlscdqEVYAnWrZ4T6JQ6w6iM=;
 b=IdrMvtLQuv/TfFMTD4X3HlRGM6i/MRgS4I0J/iL0lo2cfpC5Tbqe1pVqrgEkRIjO1Ssn
 5KCFT+Rrzr7TV2UC/VnfSPpsdsd/S5Qx7t0olAU2ycUmWZieOCYdmVZpkCb/nwTrV0nB
 ENJ4I0GUatdrZ1cetror/4Ht5lsbh2wzLjnMSOT0HvyQOFVn+4AmFoJ68O0uxwLysFaS
 hKOgCEO8Bfjms10r42Nu+IJ/AM+QNRRCKZT6DQpjdktMhEXRcTwz7nqfrBeeXaV6cYVg
 XtJrJxg0W2AnaV4cvgr/feM4riZ1ZPa36Nl8mpYrYCu+bvgP7XyVHR5H0Gfw6ThILDSx ZQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 35cv3t0e2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 15 Dec 2020 07:44:50 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 15 Dec
 2020 07:44:49 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 15 Dec 2020 07:44:49 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C06283F703F;
        Tue, 15 Dec 2020 07:44:49 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0BFFinJ1030593;
        Tue, 15 Dec 2020 07:44:49 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0BFFinwJ030584;
        Tue, 15 Dec 2020 07:44:49 -0800
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH] scsi: qedf: Avoid invoking response handler twice if ep is already completed.
Date:   Tue, 15 Dec 2020 07:44:25 -0800
Message-ID: <20201215154425.30550-1-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-15_12:2020-12-15,2020-12-15 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

  Issue :- race condition getting hit between the response handler
  get called because of the exchange_mgr_reset() which clear out all
  the active XID and the response we get via interrupt as the same time

  Below are the sequence of events occurring in case of
  "issue/race condition" :-
  rport ba0200: Port timeout, state PLOGI
  rport ba0200: Port entered PLOGI state from PLOGI state
  xid 1052: Exchange timer armed : 20000 msecs      xid timer armed here
  rport ba0200: Received LOGO request while in state PLOGI
  rport ba0200: Delete port
  rport ba0200: work event 3
  rport ba0200: lld callback ev 3
  bnx2fc: rport_event_hdlr: event = 3, port_id = 0xba0200
  bnx2fc: ba0200 - rport not created Yet!!
  /* Here we reset any outstanding exchanges before
   freeing rport using the exch_mgr_reset() */
  xid 1052: Exchange timer canceled
  /*Here we got two response for one xid*/
  xid 1052: invoking resp(), esb 20000000 state 3 
  xid 1052: invoking resp(), esb 20000000 state 3
  xid 1052: fc_rport_plogi_resp() : ep->resp_active 2
  xid 1052: fc_rport_plogi_resp() : ep->resp_active 2

Signed-off-by: Javed Hasan <jhasan@marvell.com>

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 16eb3b60ed58..5a1491afcac6 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1624,8 +1624,13 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 		rc = fc_exch_done_locked(ep);
 		WARN_ON(fc_seq_exch(sp) != ep);
 		spin_unlock_bh(&ep->ex_lock);
-		if (!rc)
+		if (!rc) {
 			fc_exch_delete(ep);
+		} else {
+			FC_EXCH_DBG(ep, " ep is completed already,
+					hence skip calling the resp\n");
+			goto skip_resp;
+		}
 	}
 
 	/*
@@ -1644,6 +1649,7 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 	if (!fc_invoke_resp(ep, sp, fp))
 		fc_frame_free(fp);
 
+skip_resp:
 	fc_exch_release(ep);
 	return;
 rel:
@@ -1900,10 +1906,16 @@ static void fc_exch_reset(struct fc_exch *ep)
 
 	fc_exch_hold(ep);
 
-	if (!rc)
+	if (!rc) {
 		fc_exch_delete(ep);
+	} else {
+		FC_EXCH_DBG(ep, " ep is completed already,
+				hence skip calling the resp\n");
+		goto skip_resp;
+	}
 
 	fc_invoke_resp(ep, sp, ERR_PTR(-FC_EX_CLOSED));
+skip_resp:
 	fc_seq_set_resp(sp, NULL, ep->arg);
 	fc_exch_release(ep);
 }
-- 
2.18.2

