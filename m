Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C0BC433DB
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 06:01:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6780364E51
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 06:01:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhB1GA6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 01:00:58 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:6288 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbhB1GAw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 01:00:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614492051; x=1646028051;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8uB//Kn2n+THYymqLSeHI1vUIKf7/S2S7TxLp17BUvk=;
  b=qpjPCktad55M1erVe0BC7S1hTYVUk8UTAUtljLJD6eZbfsUxGffdDgQJ
   ks3kt23CZuTmV8TskwfSgjK00OIXTnS3c6z1hgZ+R3YcW9ImGMPxtqSGH
   p8Z0qVEeMLt/3ASdSAICHVE6yZqZ6JTrn648BBneylg+sCMQaSIjBXAiM
   QJtyyPerlWpi84thN0uikuDwuM9BqotHxXwQnO6sb9hpuX7iECCu/5MRM
   GXWJMY2YoQjtA3+FC+jZoDP8npMsjsThjygQAOz+V5UDC9zwutuh0MzEx
   Run11/4WsjcHRMwd9y+6hm92avWL+cpA0yNw5ZN6QYAe41tZImZx+bbnJ
   g==;
IronPort-SDR: 6s/GT+EFR0Uermz3L7u3wM03RFGHJQ6hsOsbNOglKwPbu/Iyl35RedzBYh6jgF9aRDfLgNNrMG
 kJdg18v0oOHCwo+AmDDgDLOxu0gBkp7jmTZMceZTicZZkCrf6XMf1iszk0hf71u6kH0XZNhFLW
 gCSRc8wvhO/1lu+US+5Kzzh784iWFDg8jI9wO8w/IqJHoAjYu1IRycOb/cSiKRrlbDJ/b+FNMc
 5snFEuCGVoTn6B5vIb+Q4pYemotBnsRewo9MXBQd6A8mIji3yhN1jp2MW6bEbe2VJSpowsbJf1
 YtQ=
X-IronPort-AV: E=Sophos;i="5.81,211,1610380800"; 
   d="scan'208";a="165466212"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2021 14:00:04 +0800
IronPort-SDR: Zw7xtLchFkOKT7a5slKcemJqn+0UdxOPiPLPbdnCk04hiQcSi9ivO1WbVfYqv9atHO9KzYq/3f
 YgEMsFcA7WyB3Ek/UaCbEbeT206n0mJzGSlJULFJEkdb+fvaVgFmChE6y6rAL60SRTJASEhqo1
 rd6duQ+1MIntmWGKywOmXGQwzjGcC2WlcfOTONqQ3nJoMy3+NZjGbRB2J4gpGGYk4ihDi3Qi8Q
 myOOmzLd+Vt4quYi/nrvL0ONtncsBjwwC/lN2KwRP6qGW0L56zUUg61iexj3D/f1lceEKpnPph
 Bq8EO7T2ryXWChRlcgRVb4O9
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2021 21:43:14 -0800
IronPort-SDR: BYpPm5xe0UNSKGBamMTRvAZ4BX2ix+q/W3TJ+sQFkm0uYp6aoG2KHL24p0Ql5nf2Z+z+nwrNCE
 +rS00+pGeBTBQ0BAgD7+EjJAAMfuKM9+W1Il8LwNgZrBXPjcgrqV92KBKoLQ3dL8a+avgsDbNJ
 WRUgHBirrzjH6Of87A2XJwZfcVP3s4//6bVk/AAc1GQhHXQJvCXiZJiLDPGZSaQGMgX/Bk0Okd
 1AROBTNiV3PRinsdFOrMmIA6BgYCZ2zq6ol9ew9UH0LJ7VIIlOH04hXZWi8yAMi1zVPbT/JfWy
 J+E=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Feb 2021 22:00:04 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        bvanassche@acm.org, houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 20/23] target/pr: remove the memset with declare-init
Date:   Sat, 27 Feb 2021 21:56:42 -0800
Message-Id: <20210228055645.22253-21-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
In-Reply-To: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of initializing the array with memset, use declare init pattern
that is present under the kernel tree in other drivers so we can remove
the memset call.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_pr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 14db5e568f22..942b93d12295 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -928,12 +928,10 @@ static int __core_scsi3_check_aptpl_registration(
 {
 	struct t10_pr_registration *pr_reg, *pr_reg_tmp;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
-	unsigned char i_port[PR_APTPL_MAX_IPORT_LEN];
-	unsigned char t_port[PR_APTPL_MAX_TPORT_LEN];
+	unsigned char i_port[PR_APTPL_MAX_IPORT_LEN] = { };
+	unsigned char t_port[PR_APTPL_MAX_TPORT_LEN] = { };
 	u16 tpgt;
 
-	memset(i_port, 0, PR_APTPL_MAX_IPORT_LEN);
-	memset(t_port, 0, PR_APTPL_MAX_TPORT_LEN);
 	/*
 	 * Copy Initiator Port information from struct se_node_acl
 	 */
-- 
2.22.1

