Return-Path: <SRS0=qm3h=WT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E340AC3A5A2
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 09:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4C4B20673
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 09:53:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ok6ou4IJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389882AbfHWJxQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Aug 2019 05:53:16 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37268 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389868AbfHWJxP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Aug 2019 05:53:15 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7N9nWgI002578
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2019 02:53:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=tpzxeCydy0I92aKZNBe7eUzDMeEN6SSBn9BuSoZ44/I=;
 b=ok6ou4IJoNYqT6GdiFdi1JUHa24JveLXezz0EeJKRBgCrnYRonSo12G1n/daKcydRsjy
 L1nka/CZ6G3dfzGSVrhuDnfcXtGGAMRelEq/S8UmjX2QoUkTQEZ7NNW6jac26H3ivRpx
 MXUx1dkw3u+wGc+1Iz42E8goEFHCFlQHt/nTtY2M4hPxx+Yw4ft4lw8dLFfVIRgAH35i
 JR7u0kmATDarmENINhFSDlgeqrcrgWYc/4dzHHdfCQ6oq7h9vgwguvcwiBH2XANTj0mP
 FITiREGt3sd4pa5c7+OE1UCH9yVr5joW7p1zJqg2BAKgonBLD6CHZn+Jllj5U2/DESBV JA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2uhad4074q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2019 02:53:14 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 23 Aug
 2019 02:53:13 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Fri, 23 Aug 2019 02:53:13 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 394EC3F703F;
        Fri, 23 Aug 2019 02:53:13 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x7N9rDnH007909;
        Fri, 23 Aug 2019 02:53:13 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x7N9rD5H007900;
        Fri, 23 Aug 2019 02:53:13 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <gbasrur@marvell.com>, <svernekar@marvell.com>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH 09/14] qedf: Initiator fails to re-login to switch after link down.
Date:   Fri, 23 Aug 2019 02:52:39 -0700
Message-ID: <20190823095244.7830-10-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190823095244.7830-1-skashyap@marvell.com>
References: <20190823095244.7830-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-23_03:2019-08-21,2019-08-23 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Problem Statement:
Driver has fc_id of 0xcc0200
Driver gets link down (due to test) and calls fcoe_ctlr_link_down().
At this point, the fc_id of the initiator port is zeroed out.
Driver gets a link up 14 seconds later.
Driver performs FIP VLAN request, gets a response from the switch.
No change in VLAN is detected.
Driver then notifies libfcoe via fcoe_ctlr_link_up().
Libfcoe then issues a multicast discovery solicitation as expected.
Cisco FCF responds to that correctly. Libfcoe at this point starts
a 3 sec count-down to allow any other FCFs to be discovered.
However, at this point, it has been 20 seconds since the last FKA
from the driver (which would have been sent prior to backlink toggle),
which causes the CVL to be issued from Cisco CVL from the switch is
dropped by the driver as the vx_port identification descriptor is
present and has value of 0xcc0200, which does not match the driver's
value of 0.  Libfcoe completes the 3 sec count down and proceeds to
issue FLOGI as per protocol.  Switch rejects FLogi request.
All subsequent FLOGI requests from libfc are rejected by the switch
(possibly because it is now expecting a new solicitation).
This situation will continue until the next link toggle.

Solution:
The Vx_port descriptor in the CVL has three fields:

MAC address
Fabric ID
Port Name

Today, the code checks for both #1 and #2 above. In the case where
we went through a link down, both these will be zero until FLOGI succeeds.

We should change our code to check if any one of these 3 is valid and
if so, handle the CVL (basically switching from AND to OR). The port
name field is definitely expected to be valid always.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/qedf/qedf_fip.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_fip.c b/drivers/scsi/qedf/qedf_fip.c
index 5143d93..bb82f08 100644
--- a/drivers/scsi/qedf/qedf_fip.c
+++ b/drivers/scsi/qedf/qedf_fip.c
@@ -253,18 +253,24 @@ void qedf_fip_recv(struct qedf_ctx *qedf, struct sk_buff *skb)
 					fc_wwpn_valid = true;
 				break;
 			case FIP_DT_VN_ID:
+				fabric_id_valid = false;
 				vp = (struct fip_vn_desc *)desc;
-				QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC,
-					  "vx_port fd_fc_id=%x fd_mac=%pM.\n",
-					  ntoh24(vp->fd_fc_id), vp->fd_mac);
-				/* Check vx_port fabric ID */
-				if (ntoh24(vp->fd_fc_id) !=
-				    qedf->lport->port_id)
-					fabric_id_valid = false;
-				/* Check vx_port MAC */
-				if (!ether_addr_equal(vp->fd_mac,
-						      qedf->data_src_addr))
-					fabric_id_valid = false;
+
+				QEDF_ERR(&qedf->dbg_ctx,
+					 "CVL vx_port fd_fc_id=0x%x fd_mac=%pM fd_wwpn=%016llx.\n",
+					 ntoh24(vp->fd_fc_id), vp->fd_mac,
+					 get_unaligned_be64(&vp->fd_wwpn));
+				/* Check for vx_port wwpn OR Check vx_port
+				 * fabric ID OR Check vx_port MAC
+				 */
+				if ((get_unaligned_be64(&vp->fd_wwpn) ==
+					qedf->wwpn) ||
+				   (ntoh24(vp->fd_fc_id) ==
+					qedf->lport->port_id) ||
+				   (ether_addr_equal(vp->fd_mac,
+					qedf->data_src_addr))) {
+					fabric_id_valid = true;
+				}
 				break;
 			default:
 				/* Ignore anything else */
-- 
1.8.3.1

