Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E20C4332D
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17D2864E2F
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhBTVmZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 16:42:25 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:27052 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbhBTVmU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 16:42:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613857540; x=1645393540;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CvMOpSgoYytlC6qwwSYq5xzOl3ZXzVL0I3PPdQ/+aGM=;
  b=MKtclAtBrETtmMYkb8WtRwLzhYrbbCE0ljF1fw9tSwEBEzdBUElzPDb5
   LAVRWj1cPKkYCPf1dSBg+2otFq/2p6ksQhncHNjN2RgYUx/M/Lr3xiwhS
   MxeKlrMuA2xGrdJlHWwak+7ca6B+RnkOqQaDs7mXpDUEWSRFQ6Xng3uRi
   QGZXZC7LTBTMh9be/p+Sl5FK81eSchDt2w7OppuRAuG5MmrSib4jZcFKT
   zXr22dzhxK3mffRy6yRUKrjxK+h/8n9WT7a+aQaaAyTApJnAejQLtmoUf
   0FmImBi7cKbyJDJrbsGbttLusX10OM++wbhdzlE6echduA2spHiYAh0D5
   w==;
IronPort-SDR: KxRjWZNGZCUG/MI3VcbLG0B99yugeMl3MNvRtSFZ0F9smwF/SsmUY7Y5zMRB//wr3k5pfwPzEA
 eB/RB3nDn7iq0iDTPYQzJSfNG0xwG+8nRyJncXy21z9gUWKfYdQ4zjsoNB0NQt+AP+326MCtsj
 iVjsdF8SXFaCrewBy3RJm+DLwmD/w6ccOhnQef4rzVJCQm8FMWhtySDJBa9sGM7GaJ16TpItLT
 bs7QxzxJGcao1RfmawydNX5dpV4/5iEA/RjQaamwvOsaCx9vUmo+1h89BEH17LCHDsBHBgeGHY
 W0M=
X-IronPort-AV: E=Sophos;i="5.81,193,1610380800"; 
   d="scan'208";a="264605693"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 05:44:01 +0800
IronPort-SDR: MrtJcFsefka4juUgNVQNWjMwLfW5KQbYptDwDaiKZK0V3pyt9izumA20YuBcybM4s7/AMhQF8X
 MdV29u/ra0eQXcklxSkp34/lSoyx8gefU09ZQ5YHu+8ZIC12fTMTCMqg76h9cREixnzx7jTNZ8
 FYWLm0BSEPo9knFKfDs4Pwf6ZtEi4qmDbvHLoAO8hyyPNhIqADuyLuaTFC9EskITev9XwMb3Zk
 A0Wy6giY7Zf4P9ypRcjvKBpcKZ/WRjrQTLI9qwxRj8Pa6ZhUuF5yYcZ/BrQyPdBpUL/jyy4RGU
 tQmzFYOJFtiNQ1EkWqiUpRpi
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2021 13:24:36 -0800
IronPort-SDR: mWPvCoPDxxt1+6tkL4srfghJL9yRuxw9QWAErNNz4h5NoJhuppXaHQiD8HnBhtfd9V4opwTaMB
 e4putINBRUWOvXw6iYuC5MvZOlumq6hFNRgFMIAdTRV95MjO/YgjxPN7n9/+NkNZyd6if9IiwS
 tvWNDr57t10UwrxknfNpIAi6qj8ag5kHEx0ddblHDB2oLaNPAlq+H3t+SkRLBjzY3HUJlnu9M2
 Om8ejVjLNipEQhUklOCpa2mtAVRVdaGmI1mp/AdudvEbchXhTksjLYQh5ZQxvkusj1XA+XEj+7
 4fo=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Feb 2021 13:41:14 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 24/24] target: mark __rcu to avoid warning
Date:   Sat, 20 Feb 2021 13:41:12 -0800
Message-Id: <20210220214112.7469-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Mark struct fc_lport member prov with __rcu that fixes following
warning :-

drivers/target/tcm_fc/tfc_sess.c:47:17: error: incompatible types in comparison expression (different address spaces):
drivers/target/tcm_fc/tfc_sess.c:47:17:    void [noderef] __rcu *
drivers/target/tcm_fc/tfc_sess.c:47:17:    void *
drivers/target/tcm_fc/tfc_sess.c:72:9: error: incompatible types in comparison expression (different address spaces):
drivers/target/tcm_fc/tfc_sess.c:72:9:    void [noderef] __rcu *
drivers/target/tcm_fc/tfc_sess.c:72:9:    void *

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 include/scsi/libfc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 9b87e1a1c646..0446513e46d8 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -746,7 +746,7 @@ struct fc_lport {
 	struct mutex		       lp_mutex;
 	struct list_head	       list;
 	struct delayed_work	       retry_work;
-	void			       *prov[FC_FC4_PROV_SIZE];
+	void			       __rcu *prov[FC_FC4_PROV_SIZE];
 	struct list_head	       lport_list;
 };
 
-- 
2.22.1

