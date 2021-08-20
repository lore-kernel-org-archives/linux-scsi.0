Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E58CC432BE
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 04:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C157610E6
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 04:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhHTEGo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Aug 2021 00:06:44 -0400
Received: from verein.lst.de ([213.95.11.211]:39544 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhHTEGo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Aug 2021 00:06:44 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0EC686736F; Fri, 20 Aug 2021 06:06:05 +0200 (CEST)
Date:   Fri, 20 Aug 2021 06:06:04 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/9] nvme: use blk_mq_alloc_disk
Message-ID: <20210820040604.GB26305@lst.de>
References: <20210816131910.615153-1-hch@lst.de> <20210816131910.615153-2-hch@lst.de> <YR7h0w6rJc9GYpaf@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YR7h0w6rJc9GYpaf@bombadil.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 19, 2021 at 03:57:23PM -0700, Luis Chamberlain wrote:
> >  		if (nvme_nvm_register(ns, disk->disk_name, node)) {
> >  			dev_warn(ctrl->device, "LightNVM init failure\n");
> > -			goto out_put_disk;
> > +			goto out_unlink_ns;
> >  		}
> >  	}
> 
> This hunk will fail because of the now removed NVME_QUIRK_LIGHTNVM. The
> last part of the patch  then can be removed to apply to linux-next.

So this is not in the for-5.15/block tree, just the drivers one.

Jens, do you want to start a -late branch ontop of the block and drivers
branches so that we can pre-resolve these mergeѕ?
