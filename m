From: james.smart@avagotech.com (James Smart)
Subject: [PATCH v2 08/15] lpfc: Fix discovery issue when changing from
 Pt2Pt to Fabric.
Date: Thu, 21 May 2015 13:55:23 -0400
Message-ID: <555e1c0b.ZFQTl9Hca03wl1vc%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:33366 "EHLO
	mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964791AbbEURz3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2015 13:55:29 -0400
Received: by qkgv12 with SMTP id v12so61625189qkg.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 May 2015 10:55:28 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by mx.google.com with ESMTPSA id q11sm7595014qgd.49.2015.05.21.10.55.27
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Thu, 21 May 2015 10:55:27 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix discovery issue when changing from Pt2Pt to Fabric.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index e93705d..0dfa566 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4834,9 +4834,19 @@ lpfc_matchdid(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	if (matchdid.un.b.id == ndlpdid.un.b.id) {
 		if ((mydid.un.b.domain == matchdid.un.b.domain) &&
 		    (mydid.un.b.area == matchdid.un.b.area)) {
+			/* This code is supposed to match the ID
+			 * for a private loop device that is
+			 * connect to fl_port. But we need to
+			 * check that the port did not just go
+			 * from pt2pt to fabric or we could end
+			 * up matching ndlp->nlp_DID 000001 to
+			 * fabric DID 0x20101
+			 */
 			if ((ndlpdid.un.b.domain == 0) &&
 			    (ndlpdid.un.b.area == 0)) {
-				if (ndlpdid.un.b.id)
+				if (ndlpdid.un.b.id &&
+				    vport->phba->fc_topology ==
+				    LPFC_TOPOLOGY_LOOP)
 					return 1;
 			}
 			return 0;
-- 
1.7.11.7

