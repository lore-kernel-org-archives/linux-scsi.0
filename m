Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1006C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Feb 2022 10:11:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbiBXKMY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 05:12:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbiBXKMK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 05:12:10 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0DAF36B4C
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 02:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645697500; x=1677233500;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=cEltjDqj/9pJQTo/KSSustfkwvntQF26zL2bd9bpM3I=;
  b=DW5hZBmapXxLIuNA0Yas4CpNPrSfyXgvZewuMRaoYMCwTTLuHydw4JOU
   Q6OjuYH5HJidFR2YX+ZWCVNrbfIXXp+fA2JEm49hmZYMMaOPsx3G5A8VM
   GBih6pCPUf+QiRPZUPd1CPqYtR2kMnXT26XDDpc62zY3kK0rx3Ok5bmPQ
   EK4nWXzWvITBHYH6nT0o8BCNhM5KOfr2nZCFcDY0OBUUaxrSMeWPnZcpS
   VqfpODz17KlPg/uw+JDBHoCxMcxa6OMPh3doDQIRnrysqIu9/arKXLn4/
   buWCxPKpjRhPKpSCAm41csf+c+GzqFa7zv/AJghqa+pAogHG0b9BWm00l
   g==;
X-IronPort-AV: E=Sophos;i="5.88,393,1635177600"; 
   d="scan'208";a="297965123"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 24 Feb 2022 18:11:40 +0800
IronPort-SDR: 8CTrHXBeb5aS+BTipEmh4XgbtxLBxBDjJa9yVHb+6kOUGNTGaMeQ4faHcplRcTP4GTIZUTfUH/
 Tfbc4Jli2Vk2XedoOrfFSOydp2Y59ZjDkmc6/3EWSWv9n5OSoGN5jI/sNOu9p7pUGk2RdZ7LCo
 Pq/KuxT2/mU1m/klTbWhz+6B0iYfq9fWdBmmVaNJGOwmIbVmyJHA/Hvzy5N+ZtqIz26vaY0kQD
 Sls2DKlin9Qs57R1RkU5b4P3vcecmiabZF01oH1xhUnjKanfO3kfXOhuqzkchURXjw+a8EHNe1
 NoLsrgAONnVJYGD5H8OfS3W1
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 01:43:11 -0800
IronPort-SDR: e/763P9R5xp+bvgy2zG/Xbh/F8lxTu3a0YOJRRdrlBEUgE80wSwyTfHLnXUSncneCW1wdKyMu5
 7fwj/aaP485JD2qndYmFknhJJuCyq3ARkHau6oIrUceH9GaRXoA9rWGYNQlw+ECckXDPkJW5Jx
 VaRvBWSGS5PQNVjPlF8Rxiw4aMq0Nl2TfUcsb6aRQanWvLmIG1qP/aOMToOhIUV850mSbXJg5U
 J71ZTRMT1Rv/71COzBnSrI4iBxqVmXly05AqRzypd40mTl5FVIBR3gSC1WgMGeiXWxfoHpJ6gP
 nw4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 02:11:40 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K47wr3phcz1Rvlx
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 02:11:40 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645697500; x=1648289501; bh=cEltjDqj/9pJQTo/KS
        SustfkwvntQF26zL2bd9bpM3I=; b=nPQa/PkM7OxfszdB0HOiXetS78FbiEgM/J
        +EmaNteGGMVWpSLKZz4uQgzGWe+yAOuGDh1zhuOl/vPr9cAqWa4yiaMNZx0NoeTy
        zn3NsyziDGenR4FWBFC6qakyyKWtSuBGIBUoQm1w05skey9RD3YQhhkWZBAa74RJ
        PtWilDr6SY8eCabwhgE6twlCHy06avYWj3fZcslQ1rLkci5RiWOouuPAvaqvBI1x
        dmiR9Pnr4j8GtASJZMfTITL/LkmrFjAUzlBL1gcXdyVVQL1MfYOtrL9QYuKQ059V
        MC+soRJEyjHBOhTjK7MyXj4jkBsAtmZ3KHFWAmV4hEDTqPmGQfPw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ZMyYguilikon for <linux-scsi@vger.kernel.org>;
        Thu, 24 Feb 2022 02:11:40 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K47wq0wjlz1Rwrw;
        Thu, 24 Feb 2022 02:11:39 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH 5/5] scsi: mpt3sas: fix adapter replyPostRegisterIndex handling
Date:   Thu, 24 Feb 2022 19:11:29 +0900
Message-Id: <20220224101129.371905-6-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220224101129.371905-1-damien.lemoal@opensource.wdc.com>
References: <20220224101129.371905-1-damien.lemoal@opensource.wdc.com>
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

