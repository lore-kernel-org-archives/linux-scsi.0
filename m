Return-Path: <SRS0=1R64=74=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24DB3C433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 06:46:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 044182067B
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 06:46:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YX9wAK9E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgFOGql (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 02:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728163AbgFOGqk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2020 02:46:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C2CC05BD43;
        Sun, 14 Jun 2020 23:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=uKa77b8twRfAptF8+KeX0q2xmlubg6fRTOrYh3bzSV4=; b=YX9wAK9EprTykUtMY8AWX6Id+N
        z6bsjEweDssQXiwOyQX4ADOJX06k3FrXJNttctATyhSpfwfgrB956Uh9HEXw1eo0NPmlPQW5CemUE
        LljhFdW/5MoSWmkLMj3MaAPTPkogVMu4gcpgmpFxJrhDhUGO4wfTqxpRYn9fJIzIZSxwg0uw5OmIV
        cwS2aCqvRIbnEVhgi7sOgvMOMJe+JZnTwG5J/71yd3R5EF9O9cW2v4WRRmcwl6ELb0rAi7It/oJmn
        9mWiNjpCxuOzcieZVLUKkUHb3S3jlxeGxMF9vCBRhchl0jrnbvtoBcSkbeoJLwace0XEPAU71+rR3
        u29KCObg==;
Received: from 195-192-102-148.dyn.cablelink.at ([195.192.102.148] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jkit1-0001Vt-E6; Mon, 15 Jun 2020 06:46:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     martin.petersen@oracle.com
Cc:     brking@us.ibm.com, jinpu.wang@cloud.ionos.com,
        John Garry <john.garry@huawei.com>, mpe@ellerman.id.au,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: fix ATAPI support for libsas drivers
Date:   Mon, 15 Jun 2020 08:46:22 +0200
Message-Id: <20200615064624.37317-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

this series fixes the ATAPI DMA drain refactoring for SAS HBAs that
use libsas.
