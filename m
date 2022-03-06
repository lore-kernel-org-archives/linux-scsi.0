Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1FA1C433FE
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Mar 2022 08:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbiCFIn7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Mar 2022 03:43:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbiCFIn6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2022 03:43:58 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5214C40A;
        Sun,  6 Mar 2022 00:43:06 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id DE6C567373; Sun,  6 Mar 2022 09:43:02 +0100 (CET)
Date:   Sun, 6 Mar 2022 09:43:02 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 04/14] sd: rename the scsi_disk.dev field
Message-ID: <20220306084302.GB22113@lst.de>
References: <20220304160331.399757-1-hch@lst.de> <20220304160331.399757-5-hch@lst.de> <YiQq6+ow5EEXpSCC@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiQq6+ow5EEXpSCC@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Mar 06, 2022 at 11:31:33AM +0800, Ming Lei wrote:
> The device looks partner of gendisk, I think it could just be a
> private data of gendisk, and the attributes can be added to gendisk.

Yes, that would be the normal way to do it.

> 
> But scsi has the tradition of adding class device of scsi_host,
> scsi_device, scsi_disk and scsi_generic.
> 
> Adding such device makes things complicated, such as refcounting
> in open/close disk. But looks scsi_disk isn't part of sysfs ABI, maybe it
> can be removed, anyway:

Unfortunatly it is in a major way:

root@testvm:~# ls /sys/class/scsi_disk/0\:0\:0\:0
FUA	       manage_start_stop	   protection_mode    uevent
allow_restart  max_medium_access_timeouts  protection_type    zeroing_mode
app_tag_own    max_retries		   provisioning_mode  zoned_cap
cache_type     max_write_same_blocks	   subsystem
device	       power			   thin_provisioning
