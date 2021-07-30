Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B16AC4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Jul 2021 07:27:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5957C61050
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Jul 2021 07:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237630AbhG3H1P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Jul 2021 03:27:15 -0400
Received: from verein.lst.de ([213.95.11.211]:59853 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237370AbhG3H1P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jul 2021 03:27:15 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 243F467373; Fri, 30 Jul 2021 09:27:08 +0200 (CEST)
Date:   Fri, 30 Jul 2021 09:27:07 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] bsg: Fix build error with CONFIG_BLK_DEV_BSG_COMMON=m
Message-ID: <20210730072707.GA23847@lst.de>
References: <20210730012108.3385990-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730012108.3385990-1-nathan@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 29, 2021 at 06:21:08PM -0700, Nathan Chancellor wrote:
> When CONFIG_BLK_DEV_BSG_COMMON is enabled as a module, which can happen
> when CONFIG_SCSI=m and CONFIG_BLK_DEV_BSGLIB=n, the following error
> occurs:
> 
> In file included from arch/x86/kernel/asm-offsets.c:13:
> In file included from include/linux/suspend.h:5:
> In file included from include/linux/swap.h:9:
> In file included from include/linux/memcontrol.h:22:
> In file included from include/linux/writeback.h:14:
> In file included from include/linux/blk-cgroup.h:23:
> include/linux/blkdev.h:539:26: error: field has incomplete type 'struct
> bsg_class_device'
>         struct bsg_class_device bsg_dev;
>                                 ^
> include/linux/blkdev.h:539:9: note: forward declaration of 'struct
> bsg_class_device'
>         struct bsg_class_device bsg_dev;
>                ^
> 1 error generated.
> 
> The definition of struct bsg_class_device is kept under an #ifdef
> directive, which does not work when CONFIG_BLK_DEV_BSG_COMMON is a
> module, as the define is CONFIG_BLK_DEV_BSG_COMMON_MODULE.
> 
> Use IS_ENABLED instead, which evaluates to 1 when
> CONFIG_BLK_DEV_BSG_COMMON is y or m.
> 
> Fixes: 78011042684d ("scsi: bsg: Move bsg_scsi_ops to drivers/scsi/")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Looks fine.  Although I have a larger series pending here:

https://lore.kernel.org/linux-scsi/20210729064845.1044147-1-hch@lst.de/T/#t

that should also fix this issue as a byproduct.
