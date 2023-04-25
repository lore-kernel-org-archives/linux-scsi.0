Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4558C77B61
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Apr 2023 11:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbjDYLsT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Apr 2023 07:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233539AbjDYLsS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2023 07:48:18 -0400
Received: from wnew1-smtp.messagingengine.com (wnew1-smtp.messagingengine.com [64.147.123.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC28413C2C;
        Tue, 25 Apr 2023 04:48:03 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id 2C8F52B066F9;
        Tue, 25 Apr 2023 07:48:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 25 Apr 2023 07:48:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1682423282; x=
        1682423882; bh=8g6EvhdGCq2wC/q3XFsQYHoYVIEBXGvDsLbPrkyIUkQ=; b=k
        XBn7XL/In3YgAEuibI+1IYbwkaJULRx+diZaeSf4vVNwkGl8ZJB5fE0B9jaU52fV
        f7eIDWnClKRcvCqOQsxOn0UUTN8AY4qurqKHUVXbYece0xjpZydf+e/rm6Aq9TaQ
        ov1/MmzbhlwSJG7ez906KC3GrtdwcwLMakwqzJgnEiWH+pAF+9g55iC/ZjpRpBwx
        2NqanMLYcecsfs0MHDOubUgSzEvV9lhWFNgMqme/ab+okOVuzKpQmxfkd9cLIi12
        +qy0cpln7yCTYN15FHu9kAOJ5X2aaJsv8L61IWTcZ/BIjrFVqw397KPzQQUAm27l
        ymMHn9faqZumvRXuj7RtQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=ie1e949a3.fm3; t=
        1682423282; x=1682423882; bh=8g6EvhdGCq2wC/q3XFsQYHoYVIEBXGvDsLb
        PrkyIUkQ=; b=a4siOPpH/tpxgIo5/8DUQ2XEznd2FpbRksvChb9Uz15o7SC9sRq
        QzBR/Clv/amqutN96drOrloiRhAa7Au9LIdUR4utsRcpeHlRxq0O2spCNsrO1Z9m
        i+jz+CvhU4wkr5qQFIwIzVuBwleio6avHJ1Qgr4DuKS00k9jSJU5w8j6NjnPEEot
        aNyPhQzsM4xmdgClpsRXcmYlgffS6HJSedpPv0E2Ul9fIzsOI7pDRR6LvF6nlWBp
        rrIE5lDzGjboDGdiZpfEQBtfr7NAZgO+5wy7cwXaHYdzfWNlxCPIw3A3M2zDFV89
        XulN92g1Rw5NHb9ZbHtx/GL/bPIliY49y2A==
X-ME-Sender: <xms:8r1HZHZZhVV14PqxwKp8A1a1wrvm2W0sl-j1fIzOJILAWqxzVgu22Q>
    <xme:8r1HZGY35Uyx4mhR48qFX2MHyk4ENNcdJwG5uSdCREu2-H17D0B_tEN0Shfsv_M3T
    LNDHr0pz1NeHXFPZqk>
X-ME-Received: <xmr:8r1HZJ-Sxir3xv_S6ZlRCJKFu55bZKMyhKXQuf9QzaEXVCwfZC3kSYUD13fYSTIs2kZ2QXK21BxASVJhqBwk2sgv5dZxq-3mzjynTJHV>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeduvddggeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufhhihhn
    kdhitghhihhrohcumfgrfigrshgrkhhiuceoshhhihhnihgthhhirhhosehfrghsthhmrg
    hilhdrtghomheqnecuggftrfgrthhtvghrnhepgffggeffjeegfeeuteegueekvdfhledu
    hfehffdtiedthfetleeifeeihfeukeegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepshhhihhnihgthhhirhhosehfrghsthhmrghilhdrtgho
    mh
X-ME-Proxy: <xmx:8r1HZNqzvu-agKDZKjQXvkhEBpZFWTcE5s-rEsSUyOZHkwYoaQ6FQA>
    <xmx:8r1HZCo0BH_V1KxXiRvT26MBAQLZv_9qUsm5PpwBfbGZmOi3HS7J4Q>
    <xmx:8r1HZDSORt_WOqbtGNB9iMhEsdnwn3tpHQDGJrQXSiSDkfKnDitagQ>
    <xmx:8r1HZFUGl1lp4maia1rY8U1OVUQ-QUd6Bs3xqXK-XeHb7vSZB_xEH5DfJ-Tbji2s>
Feedback-ID: ie1e949a3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 25 Apr 2023 07:48:00 -0400 (EDT)
From:   Shin'ichiro Kawasaki <shinichiro@fastmail.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Chaitanya Kulkarni <kch@nvidia.com>,
        Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH blktests v2 1/6] common/rc: skip module file check if modules path does not exist
Date:   Tue, 25 Apr 2023 20:47:40 +0900
Message-Id: <20230425114745.376322-2-shinichiro@fastmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230425114745.376322-1-shinichiro@fastmail.com>
References: <20230425114745.376322-1-shinichiro@fastmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

When all of the kernel modules are built-in, /lib/modules/*/kernel path
may not exist. In this case, check for the path results in failure. Skip
the check when the path does not exist.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 common/rc | 1 +
 1 file changed, 1 insertion(+)

diff --git a/common/rc b/common/rc
index af4c0b1..f67b434 100644
--- a/common/rc
+++ b/common/rc
@@ -36,6 +36,7 @@ _module_file_exists()
 	local -i count
 
 	libpath="/lib/modules/$(uname -r)/kernel"
+	[[ ! -d $libpath ]] && return 1
 	count=$(find "$libpath" -name "$ko_underscore*" -o \
 		     -name "$ko_hyphen*" | wc -l)
 	((count)) && return 0
-- 
2.40.0

