Return-Path: <SRS0=0MZD=6J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C82C55196
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Apr 2020 07:57:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5F3C20767
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Apr 2020 07:57:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pqwaL8Ep"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgDYH5z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Apr 2020 03:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726132AbgDYH5Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 25 Apr 2020 03:57:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10164C09B04B;
        Sat, 25 Apr 2020 00:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=m05S9ckcfqH+AsAeGfxl4bDUEgO09heXqe8WR8G0tyI=; b=pqwaL8EpVLFjH3rNRBkUNo0a9b
        PvakZp1T7jgMNPzEcMO1UdOlXGeznQ57/53/W+yvbLT7aKOQvf8z8XfaT7W5glWXhYbZfmOsvCH0A
        7P+iMSCurR1mZ6aSed1Z4yrqoKPzGO+5o0MID26a3fBVb6DpR0y5K9utEIZJ/NfnGZjIH4rVLrSWH
        G6sRDFa66M93X7Sehbqm/ce09XmKHR2CTAMPNvcOH535RsBJPLjgv0Ni9SvD7iXMMnfFXLlVHWaKz
        OaNxZTuEr+BGUW/AkSI3b9bd3CuRf1fTpqIfLal/TnBJ/sFVruQKI8GVIeQT4UjICpP0Xc3oGAuqF
        S846XK5Q==;
Received: from [2001:4bb8:193:f203:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSFgS-00021F-KA; Sat, 25 Apr 2020 07:57:08 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tim Waugh <tim@cyberelk.net>, Borislav Petkov <bp@alien8.de>,
        Jan Kara <jack@suse.com>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: stop using ioctl_by_bdev for file system access to CDROMs v2
Date:   Sat, 25 Apr 2020 09:56:59 +0200
Message-Id: <20200425075706.721917-1-hch@lst.de>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Jens,

except for the DASD case under discussion the last users of ioctl_by_bdev
are the file system drivers that want to query CDROM information using
ioctls.  This series switches them to use function calls directly into
the CDROM midlayer instead, which implies:

 - adding a cdrom_device_info pointer to the gendisk, so that file systems
   can find it without going to the low-level driver first
 - ensuring that the CDROM midlayer (which isn't a lot of code) is built
   in if the file systems are built in so that they can actually call the
   exported functions

Changes since v1:
 - fix up the no-CDROM error case in isofs_get_last_session to return 0
   instead of -EINVAL.
