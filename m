From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 6/9] lpfc: Fix cq_id masking problem.
Date: Fri, 22 May 2015 10:42:40 -0400
Message-ID: <555f4060.Uu2ZGqqAXkqDGUog%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:36578 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757176AbbEVOmw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2015 10:42:52 -0400
Received: by qget53 with SMTP id t53so9036299qge.3
        for <linux-scsi@vger.kernel.org>; Fri, 22 May 2015 07:42:51 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by mx.google.com with ESMTPSA id r31sm1405382qkr.42.2015.05.22.07.42.51
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Fri, 22 May 2015 07:42:51 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix cq_id masking problem.

The driver inadvertainly constrained the id space to 8 bits, when its
a full 16 bits from hw. This resulted in bad id's being written to the
hardware. Resulted in symptoms such as incomplete initialization, no
detection of link events, etc.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index b94fa46..33ec4fa 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -291,7 +291,7 @@ struct sli4_bls_rsp {
 struct lpfc_eqe {
 	uint32_t word0;
 #define lpfc_eqe_resource_id_SHIFT	16
-#define lpfc_eqe_resource_id_MASK	0x000000FF
+#define lpfc_eqe_resource_id_MASK	0x0000FFFF
 #define lpfc_eqe_resource_id_WORD	word0
 #define lpfc_eqe_minor_code_SHIFT	4
 #define lpfc_eqe_minor_code_MASK	0x00000FFF
-- 
1.7.11.7

