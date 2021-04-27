Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C08D2C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 23:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ED1E613A9
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 23:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237104AbhD1AAD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 20:00:03 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:57323 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230368AbhD1AAD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 20:00:03 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 96598FBC;
        Tue, 27 Apr 2021 19:59:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 27 Apr 2021 19:59:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm2; bh=7PlEZIPtWb8lX8kqZl8nkTHj6R
        v/c5CDk9SJykONV3o=; b=VfYCtGvkbmsX3y1ZzaEmBj/hWm5LeDnUDTj5CeFVDk
        jFEkxc3SJ/vzZdH0iMKIVcRAnfeEs3CuovHWFNZur0UF0v1VCq3ssHldkmpTsS1J
        XC/XnYCJJZEi0aoub7HtIpJvAMTL/hweBof22mRUfzVt+gdo06LD8nIPaXJUd/ro
        AMAeTKYY7PyvPVTW3jRHz0ZfI59MsBNK++coob06i2WE8CUeeR/TjEZmOTOxeJFR
        wn23F1JMK0hbqZ/mrXD/M423pnzx6Zf8+zI2Gvi1frGwVwv/Y7x/vSn3+ScuWmc4
        HgPm/ZZYoLB2iJ7tqsb5lDmi/r2MPXlhvcC36XjsWarg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=7PlEZIPtWb8lX8kqZ
        l8nkTHj6Rv/c5CDk9SJykONV3o=; b=qqvtMh6nsj50nzdXGfqD3fVx+Htv9u46k
        GwNMbWpaaCiyBhDVucpwBZmitdUYh/oz4IgqjaAuKEyhzOnJMQUtMZojnAq5L8i8
        gfFNJKc9thZuYN9iSJmEKn/3+tZTCYMdm3GB+5bpXf0WCEf6Us88+UQg2VdUnWda
        8b19+7JcH2/4xXbxYPUbQ1zcniPbtGNnpVw2KRliNoiGLrRRBFTzvsooRyd5oZFN
        RKG39xF9nRP2OTOsmsOdc1oaZBIbMoyjnPWzz/e2VzZhMVj/bnLb98AmVD/sy6Nb
        pw61S5c7GS14/f5cyDxgupTn7FXVy3IQetmov0qnssB8ygFK/QlGQ==
X-ME-Sender: <xms:VaWIYHH1-jeruQ5GXuSdAuGxMl3xHnvAvMGtV21_WhOdeFaLBfUg7w>
    <xme:VaWIYEUjgNhEsNfcT1phDrNKmOb8tUyNXa3ioBhUvnlyE6QQPj5jC0sPabqNJXKhk
    OD-l971P-cgpCbsEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddvuddgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgvlhcu
    jfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtffrrg
    htthgvrhhnpeeiteekhfehuddugfeltddufeejjeefgeevheekueffhffhjeekheeiffdt
    vedtveenucfkphepjedtrddufeehrddugeekrdduhedunecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhlrghnugdr
    ohhrgh
X-ME-Proxy: <xmx:VaWIYJJaO58Aze0aM263LgZsomfJwYC9CjUpQbJmEmjzk15kEqsQXA>
    <xmx:VaWIYFEoIH_ikPZzcwa_tZ1u2VjZk0DySzTjvJPWb-McrFcwGkqbfg>
    <xmx:VaWIYNW02amKquTY7_pa3l9SPSlmOyRxzuVtb7q4UfJs05hXHk95Ag>
    <xmx:VqWIYLf4OPlCizNYcB1LnvW-1Ac9RoLTp7z9MU8FVVGyP2AX4j5U6g>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Tue, 27 Apr 2021 19:59:16 -0400 (EDT)
From:   Samuel Holland <samuel@sholland.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Adam Radford <aradford@gmail.com>, linux-scsi@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org, Samuel Holland <samuel@sholland.org>
Subject: [PATCH v5 0/3] 3w-9xxx: Endianness fixes
Date:   Tue, 27 Apr 2021 18:59:12 -0500
Message-Id: <20210427235915.39211-1-samuel@sholland.org>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series fixes the 3w-9xxx driver in a big-endian configuration.

I received no comments on v4, but it no longer applies cleanly.

Changes from v4 to v5:
  - Rebased on v5.12
Changes from v3 to v4:
  - Changed order of parameters to dma_alloc_coherent()
Changes from v2 to v3:
  - Add additional patches reducing the use of structure packing
Changes from v1 to v2:
  - Include missed header changes
  - Use local variable instead of byte swapping multiple times

Samuel Holland (3):
  scsi: 3w-9xxx: Use flexible array members to avoid struct padding
  scsi: 3w-9xxx: Reduce scope of structure packing
  scsi: 3w-9xxx: Fix endianness issues in command packets

 drivers/scsi/3w-9xxx.c |  72 ++++++++++++-------------
 drivers/scsi/3w-9xxx.h | 119 +++++++++++++++++++++--------------------
 2 files changed, 96 insertions(+), 95 deletions(-)

-- 
2.26.3

