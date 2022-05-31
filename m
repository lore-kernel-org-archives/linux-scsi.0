Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 469A8C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 31 May 2022 08:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242430AbiEaII6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 May 2022 04:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237948AbiEaII4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2022 04:08:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFD85EBD8
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 01:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xo5ccDJs2jJFIniJrzAYu8odIlDQQGdvUvfQSZkLzX0=; b=As0MbXwwACj24HIQbRa7l2iKbc
        2SZ12ul8+Ob4wr+Frw1VYj925LiTfRrPFAPIpOU9uwkCVUFIpMEnRfk/G1EKxq3OnlCBjdedadblx
        za/pRVJ2fNQ6s+7bniiyaDPHq3wfQtvKNkn737CJJE1DiOckd7BssJvvBJ/AR/NdBFh5UEPbSXhMh
        xtLY2KfdM7eU0K1lGnNscv6EWS7qAY4To9pqH5aOzTphuiQ7qkgTptnp+DQNF/bMqM8YYTD6frxdv
        68XArXvcSXHPhvW0hcoUAo8IxUfNjvzgSb4zO/WLFlom+KdLxe1YSXDPWr30BpDg8Cy9TgAQZiOWt
        eZjN2f9w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nvwvt-009n0l-5k; Tue, 31 May 2022 08:08:53 +0000
Date:   Tue, 31 May 2022 01:08:53 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>
Subject: Re: [PATCH v2 1/2] scsi: sd: Fix potential NULL pointer dereference
Message-ID: <YpXNFfwtPyGt5eVT@infradead.org>
References: <20220531002812.527368-1-damien.lemoal@opensource.wdc.com>
 <20220531002812.527368-2-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220531002812.527368-2-damien.lemoal@opensource.wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 31, 2022 at 09:28:11AM +0900, Damien Le Moal wrote:
> If sd_probe() sees an error before sdkp->device is initialized,
> sd_zbc_release_disk() is called, which causes a NULL pointer dereference
> when sd_is_zoned() is called. Avoid this by also testing if a scsi disk
> device pointer is set in sd_is_zoned().

Wouldn't a fix like the one below make more sense?  Until
sd_revalidate_disk and thus sd_zbc_revalidate_zones is called none of
the zone information is filled out, and thus we don't need to clear it.

But at that point we've already initialized the device and thus the
release will handler deal with all the real cleanup:

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 749316462075e..dabdc0eeb3dca 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3542,7 +3542,6 @@ static int sd_probe(struct device *dev)
  out_put:
 	put_disk(gd);
  out_free:
-	sd_zbc_release_disk(sdkp);
 	kfree(sdkp);
  out:
 	scsi_autopm_put_device(sdp);
