Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9790C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 18:16:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BADED61216
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 18:16:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234117AbhKDSTG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 14:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234102AbhKDSTB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 14:19:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55EDAC061714;
        Thu,  4 Nov 2021 11:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
        bh=jMahL7SwbYkHfS6SGguOr7KGl9dPM47/ttUCLw3AGB0=; b=twe5CLzmwVOGo8TkN/z/9o+80Y
        GWAmZlPbyVYluDGb/E9lEZuV4aaUVD9E6s203thJy7xe5pLdHs7DfAws8vKcPLetTeGmQn2npwGLV
        JQ3yu8u/1joIMLWlGeTgP3JABrqhf+xdBGDXFw5lSvzI0uDzarZ9ZNRMuVA0NQeIXCJPpUnVp0cc3
        OQi/mwPPosC35SosglzJuos9FkMJ3vnBqlWcblkjmOkThFnCQQqll0lg8a7I9AD6UvUVlkugzZhpO
        YxIDhKyaROdAZljC4D8ZaTkiJEI+C/TD9AY6f98a6pivgpmL81yM/wZ541BSfeVmM3iDBRNPaaSAY
        rvmj8B8A==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mihHW-009lko-Ax; Thu, 04 Nov 2021 18:16:10 +0000
Date:   Thu, 4 Nov 2021 11:16:10 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     martin.petersen@oracle.com, miquel.raynal@bootlin.com,
        hare@suse.de, jack@suse.cz, hch@lst.de, song@kernel.org,
        dave.jiang@intel.com, richard@nod.at, vishal.l.verma@intel.com,
        penguin-kernel@i-love.sakura.ne.jp, tj@kernel.org,
        ira.weiny@intel.com, vigneshr@ti.com, dan.j.williams@intel.com,
        ming.lei@redhat.com, efremov@linux.com, linux-raid@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v5 00/14] last set for add_disk() error handling
Message-ID: <YYQjamPUtrq402Cr@bombadil.infradead.org>
References: <20211103230437.1639990-1-mcgrof@kernel.org>
 <163602655191.22491.10844091970007142957.b4-ty@kernel.dk>
 <4764286a-99b4-39f7-ce5c-9e88cee1a538@kernel.dk>
 <YYQTYctDjaxU2tkQ@bombadil.infradead.org>
 <377b472e-b788-df12-f9cd-7fc7b0887dc0@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <377b472e-b788-df12-f9cd-7fc7b0887dc0@kernel.dk>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 04, 2021 at 11:10:48AM -0600, Jens Axboe wrote:
> On 11/4/21 11:07 AM, Luis Chamberlain wrote:
> > On Thu, Nov 04, 2021 at 06:53:34AM -0600, Jens Axboe wrote:
> >> On 11/4/21 5:49 AM, Jens Axboe wrote:
> >>> On Wed, 3 Nov 2021 16:04:23 -0700, Luis Chamberlain wrote:
> >>>> Jens,
> >>>>
> >>>> as requested, I've folded all pending changes into this series. This
> >>>> v5 pegs on Christoph's reviewed-by tags and since I was respinning I
> >>>> modified the ataprobe and floppy driver changes as he suggested.
> >>>>
> >>>> I think this is it. The world of floppy has been exciting for v5.16.
> >>>>
> >>>> [...]
> >>>
> >>> Applied, thanks!
> >>>
> >>> [01/14] nvdimm/btt: use goto error labels on btt_blk_init()
> >>>         commit: 2762ff06aa49e3a13fb4b779120f4f8c12c39fd1
> >>> [02/14] nvdimm/btt: add error handling support for add_disk()
> >>>         commit: 16be7974ff5d0a5cd9f345571c3eac1c3f6ba6de
> >>> [03/14] nvdimm/blk: avoid calling del_gendisk() on early failures
> >>>         commit: b7421afcec0c77ab58633587ddc29d53e6eb95af
> >>> [04/14] nvdimm/blk: add error handling support for add_disk()
> >>>         commit: dc104f4bb2d0a652dee010e47bc89c1ad2ab37c9
> >>> [05/14] nvdimm/pmem: cleanup the disk if pmem_release_disk() is yet assigned
> >>>         commit: accf58afb689f81daadde24080ea1164ad2db75f
> >>> [06/14] nvdimm/pmem: use add_disk() error handling
> >>>         commit: 5a192ccc32e2981f721343c750b8cfb4c3f41007
> >>> [07/14] z2ram: add error handling support for add_disk()
> >>>         commit: 15733754ccf35c49d2f36a7ac51adc8b975c1c78
> >>> [08/14] block/sunvdc: add error handling support for add_disk()
> >>>         commit: f583eaef0af39b792d74e39721b5ba4b6948a270
> >>> [09/14] mtd/ubi/block: add error handling support for add_disk()
> >>>         commit: ed73919124b2e48490adbbe48ffe885a2a4c6fee
> >>> [10/14] ataflop: remove ataflop_probe_lock mutex
> >>>         commit: 4ddb85d36613c45bde00d368bf9f357bd0708a0c
> >>> [11/14] block: update __register_blkdev() probe documentation
> >>>         commit: 26e06f5b13671d194d67ae8e2b66f524ab174153
> >>> [12/14] ataflop: address add_disk() error handling on probe
> >>>         commit: 46a7db492e7a27408bc164cbe6424683e79529b0
> >>> [13/14] floppy: address add_disk() error handling on probe
> >>>         commit: ec28fcc6cfcd418d20038ad2c492e87bf3a9f026
> >>> [14/14] block: add __must_check for *add_disk*() callers
> >>>         commit: 1698712d85ec2f128fc7e7c5dc2018b5ed2b7cf6
> >>
> >> rivers/scsi/sd.c: In function ‘sd_probe’:
> >> drivers/scsi/sd.c:3573:9: warning: ignoring return value of ‘device_add_disk’ declared with attribute ‘warn_unused_result’ [-Wunused-result]
> >>  3573 |         device_add_disk(dev, gd, NULL);
> >>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >> drivers/scsi/sr.c: In function ‘sr_probe’:
> >> drivers/scsi/sr.c:731:9: warning: ignoring return value of ‘device_add_disk’ declared with attribute ‘warn_unused_result’ [-Wunused-result]
> >>   731 |         device_add_disk(&sdev->sdev_gendev, disk, NULL);
> >>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >>
> >>
> >> Dropping the last two patches...
> > 
> > Martin K Peterson has the respective patches needed queued up on his tree
> > for v5.16:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=5.16/scsi-staging&id=e9d658c2175b95a8f091b12ddefb271683aeacd9
> > https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=5.16/scsi-staging&id=2a7a891f4c406822801ecd676b076c64de072c9e
> > 
> > Would the last patch be sent once that gets to Linus?
> 
> But that dependency wasn't clear in the patches posted,

Sorry my mistake.

> and it leaves me
> wondering if there are others?

There should not be, becauase at least my patches on top of linux-next
compiles fine as per 0-day builds on tons of configs.

> I obviously can't queue up a patch that
> adds a must_check to a function, when we still have callers that don't
> properly check it.

Absolutely.

> That should have been made clear, and that last patch never should've
> been part of the series. Please send it once Linus's tree has all
> callers checking the result.

Indeed. Will track and will do.

> > Also curious why drop the last two patches instead just the last one for
> > now?
> 
> Sorry, meant just the last one.

Ah ok!

  Luis
