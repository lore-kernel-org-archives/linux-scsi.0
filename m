Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FEC7C2B9F4
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 00:31:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20CD1610CD
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 00:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbhFRAd7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Jun 2021 20:33:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232683AbhFRAd7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Jun 2021 20:33:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66BC5610A3;
        Fri, 18 Jun 2021 00:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623976311;
        bh=FxLkwb9cFBDgjQOVtCI9Rcf8qb+qBMrt2l6X95U3vv8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jPJkcvq6o/HD2OvJa6tmwxMq+v7LspnXkbJrlt0abBQO/3GXbHlC806OPJs8Q75Ro
         Tj3WQpt64NalorUP2LZ/xiVtNaVcRbsQBK2QO3ztjzlJtfMYboe2ssjrb4P0FMEkq9
         AeZlMsFSOjJ8Le0g1dAYUV1mXakGRwUxX1b9B32Pz4sjH9IhAdaivBb9tzTnyj+qqo
         NYUOBZq2xEQadZlvCH3EBRzbtnAYGgx/h5zec8yDvW5mDnWZVr6+UvnVejZc1clAz4
         ETHmIEPz+AOB2pq/Rtwe+/VAGf1bKNIg37/RO9UgOaxh/DN7vm2BmXQTzC2VH2evhn
         /s2koPoOB7jYg==
Date:   Thu, 17 Jun 2021 17:31:47 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH v9 21/31] elx: efct: Hardware IO and SGL initialization
Message-ID: <YMvpc5KsGYFSAjok@archlinux-ax161>
References: <20210601235512.20104-1-jsmart2021@gmail.com>
 <20210601235512.20104-22-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601235512.20104-22-jsmart2021@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,

On Tue, Jun 01, 2021 at 04:55:02PM -0700, James Smart wrote:
> This patch continues the efct driver population.
> 
> This patch adds driver definitions for:
> Routines to create IO interfaces (wqs, etc), SGL initialization,
> and configure hardware features.
> 
> Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> Reviewed-by: Daniel Wagner <dwagner@suse.de>

The

if (cmpxchg(&io_to_abort->abort_in_progress, false, true)) {

in this patch causes ARCH=arm allmodconfig to fail because
CONFIG_CPU_V6=y and older do not support running cmpxchg() on bool
(anything less than int from what I can tell) when instrumentation is
enabled:

ERROR: modpost: "__bad_cmpxchg" [drivers/scsi/elx/efct.ko] undefined!

https://elixir.bootlin.com/linux/v5.13-rc6/source/arch/arm/include/asm/cmpxchg.h#L164

I guess this could be turned into an int, although the structure grows
slightly in size of the cmpxchg could be unrolled, similar to
commit f5f4c615982d ("drm: Convert cmpxchg(bool) back to a two step
operation").

Cheers,
Nathan
