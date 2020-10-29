Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE1E1C2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 15:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B33221548
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 15:11:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tWqW+P04"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgJ2PK7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 11:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727842AbgJ2PK7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 11:10:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFBBC0613CF;
        Thu, 29 Oct 2020 08:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=5UpmUUK4HkD04BYNwcucPUw7TY2FGi/Q9CTm0VHziQI=; b=tWqW+P040RkCrD1rrAjfY9sgJz
        KO8cA88SpwWBoN64XQ280vwozNesIh3dcpQJpE35kJ2w27SzFJsAB+oKGDucHwW1mlIL/KXQN4E8t
        Wf4aEjeT7KdmYarQE0o9bu7BXPVKL8zVZWtaPVcQ7G6uxaw20SPZ7ih8McI6uCnkTg0n6Yx6BMd04
        3UFRG/Fvp0JKgNdAOIPMhF6wJNoX+XzLM46OYLJTx8S1oOIJnNepiGSXqfNUdJgXcOPFylGAlXQnH
        TLDhpV+f/EiqEYkmK6i4VQ/atrEf0ndvU7ptSXv1mJXKZQQGHFflGrHFzE6vO2drxVUStwdqcWpRQ
        FJKpifxA==;
Received: from 089144193201.atnat0002.highway.a1.net ([89.144.193.201] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY9Q6-0005M0-BQ; Thu, 29 Oct 2020 15:00:55 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org
Subject: simplify gendisk lookup and remove struct block_device aliases v4
Date:   Thu, 29 Oct 2020 15:58:23 +0100
Message-Id: <20201029145841.144173-1-hch@lst.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

this series removes the annoying struct block_device aliases, which can
happen for a bunch of old floppy drivers (and z2ram).  In that case
multiple struct block device instances for different dev_t's can point
to the same gendisk, without being partitions.  The cause for that
is the probe/get callback registered through blk_register_regions.

This series removes blk_register_region entirely, splitting it it into
a simple xarray lookup of registered gendisks, and a probe callback
stored in the major_names array that can be used for modprobe overrides
or creating devices on demands when no gendisk is found.  The old
remapping is gone entirely, and instead the 4 remaining drivers just
register a gendisk for each operating mode.  In case of the two drivers
that have lots of aliases that is done on-demand using the new probe
callback, while for the other two I simply register all at probe time
to keep things simple.

Note that the m68k drivers are compile tested only.

Changes since v3:
 - keep kobj_map for char dev lookup for now, as the testbot found
   some very strange and unexplained regressions, so I'll get back to
   this later separately
 - fix a commit message typo

Changes since v2:
 - fix a wrong variable passed to ERR_PTR in the floppy driver
 - slightly adjust the del_gendisk cleanups to prepare for the next
   series touching this area

Changes since v1:
 - add back a missing kobject_put in the cdev code
 - improve the xarray delete loops

