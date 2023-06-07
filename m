Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3896EC77B7A
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 11:39:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240352AbjFGLjL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 07:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240361AbjFGLjH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 07:39:07 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F821BC2
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jun 2023 04:39:05 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3577A1m1024709
        for <linux-scsi@vger.kernel.org>; Wed, 7 Jun 2023 04:39:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=7hGjshKoALcK0hxFivvXqkrl2g5lZHLyAee4e+ZjdJU=;
 b=a1SiPPHMQvy2776upwcyW1CoOUNGnqMrjhU5FmkmwWAgbTVYi8Cf4nEhUH6r0/jbU7Hj
 YI1CTMPriCkb1VR5bA0Y3YTkTqicMlwxeCqQVQvkhhAWc4Licqp4W5u5xpQ7oqd4VzhN
 Gr49ZqevNEPcW21HFPM3COkf+LAUusibJmToOQqiHZxCqiJILXLriUDhH/jn/mJMbmYj
 Bnzr2vVV3W+vhMIJRh2N8aed7Uh/Z+ynvmCLSI5W9qcKIe6G2heJF7TfQjhqdwQsPO6h
 JibDMt5O3DXd+kac/FmJN7ZrdLRoReoxZftf+QKcrYB4Z7gDGV9/+oyGOBTktow0pphD nA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3r2a7bu9cq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jun 2023 04:39:05 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 7 Jun
 2023 04:39:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 7 Jun 2023 04:39:03 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 9CEF23F7076;
        Wed,  7 Jun 2023 04:39:01 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v2 7/8] qla2xxx: klocwork - correct the index of array
Date:   Wed, 7 Jun 2023 17:08:42 +0530
Message-ID: <20230607113843.37185-8-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230607113843.37185-1-njavali@marvell.com>
References: <20230607113843.37185-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 1qQ7UFJRmeoaDWf60VBGbZ8XtjzUpSMj
X-Proofpoint-GUID: 1qQ7UFJRmeoaDWf60VBGbZ8XtjzUpSMj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_06,2023-06-07_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bikash Hazarika <bhazarika@marvell.com>

Klocwork reported array 'port_dstate_str' of size
10 may use index value(s) 10..15.

Add a fix to correct the index of array.

Cc: stable@vger.kernel.org
Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
v2:
- Remove the outer parenthesis.

 drivers/scsi/qla2xxx/qla_inline.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index cce6e425c121..946a39504a35 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -109,11 +109,13 @@ qla2x00_set_fcport_disc_state(fc_port_t *fcport, int state)
 {
 	int old_val;
 	uint8_t shiftbits, mask;
+	uint8_t port_dstate_str_sz;
 
 	/* This will have to change when the max no. of states > 16 */
 	shiftbits = 4;
 	mask = (1 << shiftbits) - 1;
 
+	port_dstate_str_sz = sizeof(port_dstate_str) / sizeof(char *);
 	fcport->disc_state = state;
 	while (1) {
 		old_val = atomic_read(&fcport->shadow_disc_state);
@@ -121,7 +123,8 @@ qla2x00_set_fcport_disc_state(fc_port_t *fcport, int state)
 		    old_val, (old_val << shiftbits) | state)) {
 			ql_dbg(ql_dbg_disc, fcport->vha, 0x2134,
 			    "FCPort %8phC disc_state transition: %s to %s - portid=%06x.\n",
-			    fcport->port_name, port_dstate_str[old_val & mask],
+			    fcport->port_name, (old_val & mask) < port_dstate_str_sz ?
+				    port_dstate_str[old_val & mask] : "Unknown",
 			    port_dstate_str[state], fcport->d_id.b24);
 			return;
 		}
-- 
2.23.1

