Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B12CC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jan 2022 03:39:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbiALDjo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jan 2022 22:39:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350489AbiALDjk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jan 2022 22:39:40 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B63C06173F
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jan 2022 19:39:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pBnTP7X2DUB9o2j3BVpZPhTLXUAIKk3J69KQa6Or3Ks=; b=UnuDuZRIJ3aO6PfBDxGc6JVnoz
        nTs6JBE2zEwcykqQh4LuMzSXhPVTiMIH1LvF+bCt6mHl6oRo2S5U2FrSqAsatje8HrReaGp+/yJ+6
        vXBfuyjaoV1auyaMuA6Cl7ZPozsLTkIeJFIi0ViPp7OfPf4SqA9OKMIWAthYY7mynKjR0PMZoOjyP
        jA84oxswUivkTnfKmnJrgliBQ62aaFbKxGZaWb9V/hO63kd1ggLN2iPoLdaXGkC4tEU45fhd5OiLg
        xPsKUIP+5Ydsoz8nN4gfRymY7K/5o+dSVtMwmw+q4Q0T6UrmJ8WZAMGJi6pyRvTkiVxt2i5gmWmEc
        PHViQCpQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n7UU4-0012Fa-Dc; Wed, 12 Jan 2022 03:39:36 +0000
Date:   Tue, 11 Jan 2022 19:39:36 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com
Subject: Re: [PATCH 1/9] scsi_debug: address races following module load
Message-ID: <Yd5NeJKdKx32lemQ@bombadil.infradead.org>
References: <20211231020829.29147-1-dgilbert@interlog.com>
 <20211231020829.29147-2-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211231020829.29147-2-dgilbert@interlog.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Dec 30, 2021 at 09:08:21PM -0500, Douglas Gilbert wrote:
> This patch was developed several months ago after discussions with
> Luis Chamberlain. It may have been overtaken by more recent work
> by Luis.

Yeah well pretty much I ended up concluding that even though the driver
*can* be sloppy ultimately we expose tons of knobs through userspace to
easily bump module refcounts at userpace's whim's. For instance a
userspace loop issuing open() on any block driver will bump the module
refcnt. A simple reproducer is provided through korg#214015 [0], see
busy-open-block-device-sleep.c, you run that while running the test
script. In short userspace's simple open() triggers blkdev_open() and
that bumps the module refcnt. This means the module refcnt is finicky.

In so far as a fix is concerned, you have to consider that long ago this
race was considered theoretical, and we had in-kernel support to wait
to get the refcnt to 0 before unloading a module. That code proved
complex, and since the race was theoretical it was removed. The race is
clearly possible with any block driver, and therefore any type of driver
too, and so the fix really is to implement a proper patient module
remover in userspace.

I already implemented and posted patches for kmod for this, they are in
review. In the meantime we have needed to also open code solutions for
fstests and blktest while kmod is not released yet with the new changes.
I already posted patches for both, and fstests has this fix merged a
while ago. Blktests folks just need to finish testing things and merge
the changes.

All that said, drivers can certainly be enhanced to reduce these sorts
of races too. It is all driver specific and so outside of the scope of
generic drivers.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=214015

  Luis
