Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 931D6C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 04:26:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 690E66044F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 04:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbhHQE0k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 00:26:40 -0400
Received: from verein.lst.de ([213.95.11.211]:56977 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230073AbhHQE0k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 00:26:40 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 23CB46736F; Tue, 17 Aug 2021 06:26:05 +0200 (CEST)
Date:   Tue, 17 Aug 2021 06:26:04 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kevin Mitchell <kevmitch@arista.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lkdtm: move SCSI_DISPATCH_CMD to scsi_queue_rq
Message-ID: <20210817042604.GA3579@lst.de>
References: <20210817015719.518648-1-kevmitch@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817015719.518648-1-kevmitch@arista.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 16, 2021 at 06:57:18PM -0700, Kevin Mitchell wrote:
> When scsi_dispatch_cmd was moved to scsi_lib.c and made static, some
> compilers (i.e., at least gcc 8.4.0) decided to compile this
> inline. This is a problem for lkdtm.ko, which needs to insert a kprobe
> on this function for the SCSI_DISPATCH_CMD crashpoint.
> 
> Move this crashpoint one function up the call chain to
> scsi_queue_rq. Though this is also a static function, it should never be
> inlined because it is assigned as a structure entry. Therefore,
> kprobe_register should always be able to find it. Since there is already
> precedent for crashpoint names not exactly matching their probed
> functions, keep the name of the crashpoint the same for backwards
> compatibility.
> 
> Fixes: 82042a2cdb55 ("scsi: move scsi_dispatch_cmd to scsi_lib.c")
> Signed-off-by: Kevin Mitchell <kevmitch@arista.com>

This looks ok.  Does any userspace hardcode these names or can we
use a saner name?

Btw, generic_ide_ioctl is gone as well, together with the whole legacy ide
subsystem.
