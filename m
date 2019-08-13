Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 451CCC32750
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D2A020663
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:27:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SJPNBPJM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbfHMHZW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 03:25:22 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50024 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfHMHZW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 03:25:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rpLZk77wYd+19lLl2WqyfSlNdZZpStM5OxSeXpJwPP8=; b=SJPNBPJMs7N2cZWW6pFtDl1pG
        /ON+8Dm2FPqFskavNg/QqV+zFAJBJdpPx8JmCyJPpwN2MVw6jY24vjR5aN4KkIY9R0uR+TCJqFh0d
        /FuNjsE2bNIybXxB2MAUOoeLEWVec68xLRLyU8AG0cSgn6pVxiawshVz1fy+clcuE35BNIWG6SOIp
        mAOWn7f6oFE+5y3TeqM9i551UDXaAwpMejMg4e4u+mumh/VeZgcPWVM+pMusM8AgGhYxYHx6UvQgw
        nx4ReupifeHe8wvm9ZCREYZ7vUOZZ+uTbh1O3ZmE6Q8XyBRimXVKYBze9x0TG3PGO7Lnh+BljV6E9
        bs2DyOv2A==;
Received: from [2001:4bb8:180:1ec3:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hxRBE-00064c-Ef; Tue, 13 Aug 2019 07:25:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Mike Travis <mike.travis@hpe.com>,
        Dimitri Sivanich <sivanich@hpe.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ia64@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: RFC: remove sn2, hpsim and ia64 machvecs v2
Date:   Tue, 13 Aug 2019 09:24:46 +0200
Message-Id: <20190813072514.23299-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

[adding some ex-SGI folks to comment as well]

Hi Tony,

let me know what you think of this series.  This drops the pretty much
dead sn2 and hpsim support, which then allows us to build a single ia64
kernel image that supports all remaining systems without extra indirections
in the fast path.

A git tree is also available at:

    git://git.infradead.org/users/hch/misc.git ia64-remove-machvecs

Gitweb:

    http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/ia64-remove-machvecs

Changes since v1:
 - restore !NUMA support
 - fix compile for configs
