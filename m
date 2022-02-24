Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9723C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Feb 2022 23:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234201AbiBXXbl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 18:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234071AbiBXXbh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 18:31:37 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E942763C8
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 15:31:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645745466; x=1677281466;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=cEltjDqj/9pJQTo/KSSustfkwvntQF26zL2bd9bpM3I=;
  b=ThAaqbWyp1ykNmfhBZ0vLPGXLRPHMj/p3gsowazTp/8J5o1Hei8C+ZAu
   d7O1y6njAVLh7jqqz7mhQ6+D/2inv0JEuKPZBKNJjY791H5ergakzmz7E
   JoKnf5XJc9aL95sU5Mp0dXyD7a1p6EKjV9sgJfm3lBzX+naknqtLF6GtB
   3+424dlQbYIl4sWNru5kO4ASGypc/BQ6++qgePoZ/5U8EC/R2t/aURA9B
   gj4MSLESCCraDe2I4/6LNRrx66c9Aih5pNUioJx3/lpdNRSZiIOueZbAm
   02HV9MjI4wR/rLSRagTSF991Q/2XrUE922w24uTFP1VN/ORYM0Sdkt7i0
   g==;
X-IronPort-AV: E=Sophos;i="5.90,134,1643644800"; 
   d="scan'208";a="192821990"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Feb 2022 07:31:05 +0800
IronPort-SDR: /QUTrohL+l9Z2wNrVRodujgRF3mS9TRYABRfc2FA9UPE+a+dgmnf37k2mn1LEU2ESGKHR/4OZb
 aM0UNznCYjCAFVCzPVKiV4t6lu3T0YX9RbB4Y10zeZ0vl6j3pYHeSBlbR7X+yuS/Zth+lCetQs
 qjopZhfGtOeuhrzILHTVBiACzwY56Y7W4QY3kY/hOEPmB7BD9wrN4BYsv87j62pUCatlizN8pN
 TmTiBXZ/wl/mi2n+jHemihVs9WEqyDc+lSI4ehwbd2vuCVndfbh0OYvksG4cFY2iHRhRnhLUhr
 KKckUfWnsaFa8mIPYucRFlAr
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 15:02:35 -0800
IronPort-SDR: 0EHKnhj+XqhtK57rTZ5L7Ue8DOc1q0b5hcGSE+lNe21uCDIDHl00QA4+MqzeRMVmcd7aMD8EDE
 X+MSliuAo8MVvAMtkJuXTSot+4yMTaSRl7gMyr/FgZob6KlmIkxsZpt+b7T+TDawLU9Ai3kKFZ
 QOO/ku4hk01OOn4FaCaFKTEWRjRENcRCNi7eZuDCjpey8geTmnzsUDEb5Dss7e0PNRpYivm893
 Ww6LOkLifQbgAaqRAPeGDJ7ajsKGBq+leIppBrbtu1Lv0WiR/O334lAZPyDj+4sbxwLnfWUC0z
 rHg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 15:31:06 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K4TgF3Q3fz1SHwl
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 15:31:05 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645745465; x=1648337466; bh=cEltjDqj/9pJQTo/KS
        SustfkwvntQF26zL2bd9bpM3I=; b=fn7w/uRImdG6Jb83+MqiPQzZCmlUGKGBLu
        aYc3wEe5SKHnmdC/soFI043GWfGJ/XYA2o3WKBc7l0RczLFe7sgvwxAoTvTd2uV4
        6/J3u0/Gy6apOvGdZJ3ymb0dm0Wbk3idh+uEr8KpCD0CtIYriIwHH6ZNdAb8mqXW
        w30jpRaERDMUtHpDsCaj171nFhIl5bk/b4KE4DokZrvTwG75HRRzm+WC9HavUj2P
        P/B1YlbtRU0v8jNfySFiyAOPbnW7C0iIdRDmR3SXezeCTUuplMBplQTbVfSlAdVg
        osdf7Jty7PvuzuZu6W6xqCSgadpEkbhkvccVVUbNErkvlxOpD0Zw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id oBDDzc712Tf1 for <linux-scsi@vger.kernel.org>;
        Thu, 24 Feb 2022 15:31:05 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K4TgD0rHxz1Rwrw;
        Thu, 24 Feb 2022 15:31:03 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v2 5/5] scsi: mpt3sas: fix adapter replyPostRegisterIndex handling
Date:   Fri, 25 Feb 2022 08:30:56 +0900
Message-Id: <20220224233056.398054-6-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220224233056.398054-1-damien.lemoal@opensource.wdc.com>
References: <20220224233056.398054-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The replyPostRegisterIndex array of struct MPT3SAS_ADAPTER is regular
memory allocated from RAM, and not an IO mem resource. writel() should
thus not be used to assign values to the array entries. Replace the
writel() call modifying the array with direct assignements. This change
suppresses sparse warnings.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 37 ++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
index 5efe4bd186db..4caa719b4ef4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1771,10 +1771,13 @@ _base_process_reply_queue(struct adapter_reply_qu=
eue *reply_q)
 		 */
 		if (completed_cmds >=3D ioc->thresh_hold) {
 			if (ioc->combined_reply_queue) {
-				writel(reply_q->reply_post_host_index |
-						((msix_index  & 7) <<
-						 MPI2_RPHI_MSIX_INDEX_SHIFT),
-				    ioc->replyPostRegisterIndex[msix_index/8]);
+				unsigned long idx =3D
+					reply_q->reply_post_host_index |
+					((msix_index  & 7) <<
+					 MPI2_RPHI_MSIX_INDEX_SHIFT);
+
+				ioc->replyPostRegisterIndex[msix_index/8] =3D
+					(resource_size_t *) idx;
 			} else {
 				writel(reply_q->reply_post_host_index |
 						(msix_index <<
@@ -1826,14 +1829,17 @@ _base_process_reply_queue(struct adapter_reply_qu=
eue *reply_q)
 	 * new reply host index value in ReplyPostIndex Field and msix_index
 	 * value in MSIxIndex field.
 	 */
-	if (ioc->combined_reply_queue)
-		writel(reply_q->reply_post_host_index | ((msix_index  & 7) <<
-			MPI2_RPHI_MSIX_INDEX_SHIFT),
-			ioc->replyPostRegisterIndex[msix_index/8]);
-	else
+	if (ioc->combined_reply_queue) {
+		unsigned long idx =3D reply_q->reply_post_host_index |
+			((msix_index  & 7) << MPI2_RPHI_MSIX_INDEX_SHIFT);
+
+		ioc->replyPostRegisterIndex[msix_index/8] =3D
+			(resource_size_t *) idx;
+	} else {
 		writel(reply_q->reply_post_host_index | (msix_index <<
 			MPI2_RPHI_MSIX_INDEX_SHIFT),
 			&ioc->chip->ReplyPostHostIndex);
+	}
 	atomic_dec(&reply_q->busy);
 	return completed_cmds;
 }
@@ -8095,14 +8101,17 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER=
 *ioc)
=20
 	/* initialize reply post host index */
 	list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
-		if (ioc->combined_reply_queue)
-			writel((reply_q->msix_index & 7)<<
-			   MPI2_RPHI_MSIX_INDEX_SHIFT,
-			   ioc->replyPostRegisterIndex[reply_q->msix_index/8]);
-		else
+		if (ioc->combined_reply_queue) {
+			unsigned long idx =3D(reply_q->msix_index & 7) <<
+				MPI2_RPHI_MSIX_INDEX_SHIFT;
+
+			ioc->replyPostRegisterIndex[reply_q->msix_index/8] =3D
+				(resource_size_t *) idx;
+		} else {
 			writel(reply_q->msix_index <<
 				MPI2_RPHI_MSIX_INDEX_SHIFT,
 				&ioc->chip->ReplyPostHostIndex);
+		}
=20
 		if (!_base_is_controller_msix_enabled(ioc))
 			goto skip_init_reply_post_host_index;
--=20
2.35.1

