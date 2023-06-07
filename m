Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F952C83005
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 08:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239040AbjFGIdN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 04:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239314AbjFGIdI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 04:33:08 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1A610F9;
        Wed,  7 Jun 2023 01:33:01 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id E15E86732D; Wed,  7 Jun 2023 10:32:53 +0200 (CEST)
Date:   Wed, 7 Jun 2023 10:32:53 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Richard Weinberger <richard@nod.at>,
        Josef Bacik <josef@toxicpanda.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Coly Li <colyli@suse.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-um@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org,
        linux-btrfs@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 01/31] block: also call ->open for incremental
 partition opens
Message-ID: <20230607083253.GA29653@lst.de>
References: <20230606073950.225178-1-hch@lst.de> <20230606073950.225178-2-hch@lst.de> <20230607-behelfen-abnormal-8ccf8e1e99c9@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607-behelfen-abnormal-8ccf8e1e99c9@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 07, 2023 at 10:14:22AM +0200, Christian Brauner wrote:
> This assumes that all drivers deal with additional ->open() calls for
> each partition correctly which I assumed you checked so,

They have to, because they already get the additional open for
extra opens of the whole device.  The current behavior is:

open("/dev/vdb", ...)
  ->open called

open("/dev/vdb", ...)
  ->open called

----

open("/dev/vdb", ...)
  ->open called

open("/dev/vdb1", ...)
  ->open called

----

open("/dev/vdb1", ...)
  ->open called

open("/dev/vdb1", ...)
  ->open NOT called

which is very inconsistent.
