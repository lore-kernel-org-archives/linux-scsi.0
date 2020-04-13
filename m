Return-Path: <SRS0=9ymf=55=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D3C0C2BA2B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 17:05:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 498EB2073E
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 17:05:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=flameeyes.com header.i=@flameeyes.com header.b="lkYTilP2";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="YgcNKyjh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732416AbgDMRFM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 13:05:12 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:33097 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732410AbgDMRFH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Apr 2020 13:05:07 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 8CC8B823;
        Mon, 13 Apr 2020 13:05:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 13 Apr 2020 13:05:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flameeyes.com;
         h=from:to:cc:subject:date:message-id:mime-version:content-type
        :content-transfer-encoding; s=fm1; bh=Jgo1d+egA9EODXGCFs8jJuZfQZ
        KvHmWjrHh4ne0Xvuc=; b=lkYTilP2/aB7YOLCexQmX6LvvSmw+hSZjay4fMNayo
        qmF9eoUgBXzH2ZjrYH7xqgrg/eL5rOtUCDS0GhaV1Xji3J0pEWqGVNpBqd6v3btr
        eiDDbm8ZsgrQvOOoD0So8fl4BsinflyT6WPYgUlDBOPPKAoZ9ou16V5bmpfgfqWP
        6KRDdrmNYzKfM/uvOI7UAJEA6Jo0Hc6+Psq4pcl8U9da1uIbiCjdrD90kv4wAevi
        pT3Pgc68+Iza4cUb5t4WJbyF1UwhVbh6vuKAtDSbF+KJntUC5iF19QUtUDWaWU51
        hSmHgYA/uiYmFQlS2xxeGRQUdQoTe83BBeCSZc16I1Kg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Jgo1d+
        egA9EODXGCFs8jJuZfQZKvHmWjrHh4ne0Xvuc=; b=YgcNKyjhn9nFRupKFJMFOH
        GckflVrwqvZhJL02mRly6GJVCnLabwi/nJ9VPjQhm0U85sxbvmCNYcz7kbEfJ/oM
        mnJ7dTJKQvjIa+1W25cOprWnrgF8Zq7a8cGqa0mpU9bjG14+3uFjs2VeHiaou5N2
        cIOtv8H+uMMXzrSLtdYHhn46JMgvN5TrkBlxUlc+TF8mTufqbDLOrgRR6+c5sS6b
        ZrRu/eoEVYUpQXUJMRbxkEEp5WvkMHPTsLsAutyD00sbEVQ4Yf/GXOoUGK9IkMxf
        LMhaUVNKmd+0CteC5fvvIO9IeqSZlmX09G4XfKH1kWu9NjMMx4DNO9kdG2JHLBCA
        ==
X-ME-Sender: <xms:wZuUXvbyjGQwN9bApgF9sVmoHu2E9Oh8KFPJNWSbZ8m_W6ynOcMTGA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrvdelgdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    fgrghrlhihuchsphhrihhnghculdejtddmnecujfgurhephffvufffkffogggtgfesthek
    redtredtjeenucfhrhhomhepffhivghgohcugfhlihhoucfrvghtthgvnhpjuceofhhlrg
    hmvggvhigvshesfhhlrghmvggvhigvshdrtghomheqnecuffhomhgrihhnpehsrghnvgdq
    phhrohhjvggtthdrohhrghdpsggvrhhlihhoshdruggvpdhsohhurhgtvghfohhrghgvrd
    hnvghtpdigihhphhdrohhrghenucfkphepkeekrdelkedrvdefkedrudeftdenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehflhgrmhgvvgihvg
    hssehflhgrmhgvvgihvghsrdgtohhm
X-ME-Proxy: <xmx:wZuUXtdxfU90oN7nJTZWyUjJ03qA6PywSue0Wkde7WTYypbZWe10Nw>
    <xmx:wZuUXoJgcYQLDnn3aJ5pz7i4klDeYteRqUl40Zm35eCHne7MIlfHPg>
    <xmx:wZuUXiIBvGlPAelHjDAURNg2N1VbxX6HA3vHfdXY5YXAPmhsGnkAbw>
    <xmx:wpuUXttJ3U10HMKb0k2RwD1umXG6qs5lOpt-Z-_hQbgAX6GzWn_BdQ>
Received: from localhost.localdomain (unknown [88.98.238.130])
        by mail.messagingengine.com (Postfix) with ESMTPA id A743E3280065;
        Mon, 13 Apr 2020 13:05:04 -0400 (EDT)
From:   =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@flameeyes.com>
To:     Doug Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org,
        =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@flameeyes.com>
Subject: [PATCH 4/4] Update referenced link to cdrtools.
Date:   Mon, 13 Apr 2020 18:05:01 +0100
Message-Id: <20200413170501.13381-1-flameeyes@flameeyes.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Diego Elio Pettenò <flameeyes@flameeyes.com>
---
 drivers/scsi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index a7881f8eb05e..91c4cbc48fb9 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -136,7 +136,7 @@ config CHR_DEV_SG
 
 	  For scanners, look at SANE (<http://www.sane-project.org/>). For CD
 	  writer software look at Cdrtools
-	  (<http://cdrecord.berlios.de/private/cdrecord.html>)
+	  (<http://cdrtools.sourceforge.net/>)
 	  and for burning a "disk at once": CDRDAO
 	  (<http://cdrdao.sourceforge.net/>). Cdparanoia is a high
 	  quality digital reader of audio CDs (<http://www.xiph.org/paranoia/>).
-- 
2.26.0

