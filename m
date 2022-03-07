Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BDD1C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Mar 2022 23:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343955AbiCGXub (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 18:50:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344034AbiCGXuF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 18:50:05 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87AE322BD9
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 15:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646696945; x=1678232945;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=T9c8DJXOuUN22JlL9AnlBVb7CGOVIV328Z5IduR5G7M=;
  b=KJ51+MBgxuBV74xI1/l7RHT+eiSi++syjcmgh6QffIaQr3Vm7HkwATb0
   27FRroCG2WJQjuWUKev3ZU0wD6ubN8jhRsCBSQ3/k5VJc+aq+ekmy6H3A
   ME2OPL7KPQjHdfiHgywlHts4e1AXD2tgGG7CchOhwbpUg9kuLcUXNKGM5
   efvlZ5Fd57a0bAUYRTL2zVm2rqI14Fpimeks31+2bdlneb4QfWBZ9RRlU
   HJ6P0W6aqe27142GWqE+NE5mGD8zXATOmNKNPaSWv7BIYN3+4LSycQIpQ
   IPMpxwVtUZu5DghndZyl3Glh9qQE4jX8h7B4q2UtuYjvp3zyOFZe82DCR
   A==;
X-IronPort-AV: E=Sophos;i="5.90,163,1643644800"; 
   d="scan'208";a="195659158"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 08 Mar 2022 07:49:05 +0800
IronPort-SDR: HHO8aXWNjZYxGXBPOAq3kSVfMIGmP3/FsbgtOesnGV5rfYXE8uTf4tUYw+qrsxmM9v/aFyEnVz
 7+yfpiUsT7DDq2Fng38NH4vH9m3OdrIDv2F7lXQFy529QPX8OTGOFWTkfCTRkFLOprE1M59eKE
 OzJ8mRgZgmGs5l+4bId2IpHUe4Oa+EN/1uGZcbTWeteTPWOPbfsumH1Z2ezwkNlPDtjSSAIOfF
 XWItfP8co395wvhDjOVWbxSsaOlDZd57FFD5lm1dXHtSwRQGPMjA/EOQmTA8KFD+bP018IVxw/
 5Cq+5P/AtXTUe71Mr3IDvL5Q
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 15:21:23 -0800
IronPort-SDR: NGjhklNF7v2QjCjoB2EuLjd63dsWw6csE+3vZGZVTi3Pglmj2xE38RdSJDSWltVbomd8BmdjBb
 EuAWdJW0KGCfOLKuA0rDe+/Ub6ZuajBnzXG+vy0F1Ux80nzx68qb53w03EwCroCI7W2tV5o9+k
 DK3k0Y7UYOvvBIy8y4jR9Se265sOqWLSq6AS2YaolmHbjBO95Qcj91I5nF20Enp8QylAUfi/t7
 uM23bSLH9gttNN3+P/Z82cx+GWGhVOXxzzWD6evweRql5Vn5oRYCRopdKLedaP03DAR/9r1Rjc
 u7Q=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 15:49:06 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KCFXw5881z1SVny
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 15:49:04 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1646696944; x=1649288945; bh=T9c8DJXOuUN22JlL9A
        nlBVb7CGOVIV328Z5IduR5G7M=; b=QVgG2f/46HXk/anpUP0fw75iQPJPEkXOWd
        LXy50TLK0Yho8edGxKR6DuD55wELgY16Q00u6ACwbBFJs3+0wmlH+YJdMmseBRra
        kbDGEepS+PJKYwIxpdwjT35rlKC4B4LiHesyrXvhmslrkVBwi3DEl4Qa+Aanmo0y
        SlRBag0pYXkvaagRexoR7PtnJP3ITIYUt8Vfj9oVLi0Mou2W9HWfzTBtuENADFmP
        px8O3FipOy4I1XJW7JXuwfNarTi6nefdubQN/4M2WkWRnH5bZEWUssynthXC3049
        B9X8N+IzJGSobW8av/sT4hTpv1jj9vBjKiu85cWllX0KdTZg34LA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id UPZipwywYkm7 for <linux-scsi@vger.kernel.org>;
        Mon,  7 Mar 2022 15:49:04 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KCFXv1pHJz1Rwrw;
        Mon,  7 Mar 2022 15:49:03 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v3 5/5] scsi: mpt3sas: fix adapter replyPostRegisterIndex declaration
Date:   Tue,  8 Mar 2022 08:48:54 +0900
Message-Id: <20220307234854.148145-6-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307234854.148145-1-damien.lemoal@opensource.wdc.com>
References: <20220307234854.148145-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The replyPostRegisterIndex array of struct MPT3SAS_ADAPTER stores iomem
resource addresses. Fix its declaration to annotate it with __iomem to
avoid sparse warnings for writel() calls using the stored addresses.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 9 +++++----
 drivers/scsi/mpt3sas/mpt3sas_base.h | 2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
index 5efe4bd186db..fa47f56c046f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3703,10 +3703,11 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER=
 *ioc)
 		}
=20
 		for (i =3D 0; i < ioc->combined_reply_index_count; i++) {
-			ioc->replyPostRegisterIndex[i] =3D (resource_size_t *)
-			     ((u8 __force *)&ioc->chip->Doorbell +
-			     MPI25_SUP_REPLY_POST_HOST_INDEX_OFFSET +
-			     (i * MPT3_SUP_REPLY_POST_HOST_INDEX_REG_OFFSET));
+			ioc->replyPostRegisterIndex[i] =3D
+				(resource_size_t __iomem *)
+				((u8 __force *)&ioc->chip->Doorbell +
+				 MPI25_SUP_REPLY_POST_HOST_INDEX_OFFSET +
+				 (i * MPT3_SUP_REPLY_POST_HOST_INDEX_REG_OFFSET));
 		}
 	}
=20
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/m=
pt3sas_base.h
index 949e98d523e2..209f8680c01d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1588,7 +1588,7 @@ struct MPT3SAS_ADAPTER {
 	u8		combined_reply_index_count;
 	u8		smp_affinity_enable;
 	/* reply post register index */
-	resource_size_t	**replyPostRegisterIndex;
+	resource_size_t	__iomem **replyPostRegisterIndex;
=20
 	struct list_head delayed_tr_list;
 	struct list_head delayed_tr_volume_list;
--=20
2.35.1

