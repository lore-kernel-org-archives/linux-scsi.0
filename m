Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DBDAC77B76
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Apr 2023 12:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbjDQMsS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Apr 2023 08:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjDQMsQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Apr 2023 08:48:16 -0400
Received: from wnew3-smtp.messagingengine.com (wnew3-smtp.messagingengine.com [64.147.123.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27D765B2;
        Mon, 17 Apr 2023 05:47:53 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id ED8442B0679B;
        Mon, 17 Apr 2023 08:47:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 17 Apr 2023 08:47:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1681735672; x=
        1681736272; bh=OOw1AAJkLQjLU0GAGlJCBYEb4ecro8RwuRFm5lMByG8=; b=g
        TY7FMyipiJ6yPibgy86TIbkcp5p1cPtoymiYIXMptI1jVVGhIdiuL0fSu6Lgponl
        kpmdB8V6rMSxmo3BG3QLOST0PUWNO/GvwwM0R5OuZeK03NRVtVq0FGRePdhOjIOV
        mfJAgJ2/1oWgr+dovgmU7lJmVCi1c7VklWAeugmuNc0kcL5rA8AM7oq1X68/S2SK
        qasEXPxS2q+su6fUTYchpATk2VQh8yA3aFTjxX1ewZjTEcoAHYzueNVEqDcQzR+5
        RxT68rZgb27Wit4kAmiBqUxaS6IbRsOlUplQp/I9nXEICCB9oOjZX8EzO/uSH20h
        7W7WYl/QwfamuyfGSVNXQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=ie1e949a3.fm3; t=
        1681735672; x=1681736272; bh=OOw1AAJkLQjLU0GAGlJCBYEb4ecro8RwuRF
        m5lMByG8=; b=HtWMwnCHWRwP3skZfJW9c1eUfKecH/8XF8MMPos+eL22b+CF/fM
        w2J8ABrX6z5fOXxGFlAeAgbmexk7PNKcnKOASZlY2WQN8wOkyg+bspeI+75DutDd
        S9YkQcoLKuYe1nPo6fHM7ft0COMvZdj/G7lmhwjLkl+kPskSNIYD4tkdrRfjCZ41
        8hQZYyqQ/JRvuQxbTPl/9+rLmhDNPW6XvX/0Y/CSvrdMoexO+GldIqV50a04lVdz
        TWCRe03plfJuSN1Vy58BA3eGmqaudVtMfLkOPyYChN/+uDe2gBeeIVxSNcDaCBcC
        Q2jidOnju/ik6PY17wtxvZgGpahiipB/ofg==
X-ME-Sender: <xms:-D89ZCZt7FK75AFyG60ijkm4y6CCOWivHT9Jv8gpH18ECRMmSkIPuQ>
    <xme:-D89ZFa5uJPZoaWw3YYuQB4Cle3am1XxGpKl4ZvwnvUQfa5TPYnY3j6EKJ2oyS9wN
    FtvCynF0PY8M8SDGcc>
X-ME-Received: <xmr:-D89ZM-F0kIaU_18MxI8mYSTRCNh7kADxhroEcXlK3wIw_Iorktqj3DVSeEJKNjd0p1crJw8014-tlZmWBwfa2-qJCdEh0njocpTOLpY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeliedgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefuhhhinhdkihgthhhirhhoucfmrgifrghsrghkihcuoehs
    hhhinhhitghhihhrohesfhgrshhtmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpe
    fggfegffejgeefueetgeeukedvhfeludfhhefftdeitdfhteelieefiefhueekgeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehshhhinhhitg
    hhihhrohesfhgrshhtmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:-D89ZEpfkrmg6sEwFuPRaqXbi7GbIKW6qTaSeIKr7Pc82cpIG1kV4w>
    <xmx:-D89ZNrSasVj57uRFntBueXd2UUk8VlaX9lMmDfsqrOrwkr1HgJYmQ>
    <xmx:-D89ZCQ_yvXG5QTsYtr1AlezkCT_6-prvDwsqq9JGGv2qWdJvKoCSA>
    <xmx:-D89ZE2hB2j4qjg88XKb6tpXuDfsEyxLsdMGLPG4F4aYRbOQzwmyxjrdDa2L7w-c>
Feedback-ID: ie1e949a3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 17 Apr 2023 08:47:50 -0400 (EDT)
From:   Shin'ichiro Kawasaki <shinichiro@fastmail.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH blktests 1/9] common/rc: skip module file check if modules path does not exist
Date:   Mon, 17 Apr 2023 21:47:20 +0900
Message-Id: <20230417124728.458630-2-shinichiro@fastmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230417124728.458630-1-shinichiro@fastmail.com>
References: <20230417124728.458630-1-shinichiro@fastmail.com>
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
2.39.2

