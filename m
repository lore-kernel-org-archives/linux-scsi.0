Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F33C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 17:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351531AbiDLRzB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 13:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350027AbiDLRzA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 13:55:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5BA457B3B
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 10:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IARc/n7lNBIqKdd08vLtV2klg96ovXoWrNhSZsd3CqQ=; b=ZdcBcOGpNLrNzQrjMcKU3qmRII
        5ESR2gp17SmDfttgvoqFzRWsUzh/3dwDqTY++lhTSxO4zr1c3nG+Uv0lFmOZXMa4H92le+libtGSn
        0RkuQWxldkY40gLiXZ50f/kFwKZurOXGD+vQ1YXuQsA5p/P78TQKdVABfpS0/b1kOEwbW4UoRR8SY
        Zbfi/1ruIEwczxO3WSqfdYaTdrXMKz2OvtJvZspwumuo3PXb5US3u4KZdF5ddZv4ItvRv9YgaOPxq
        vqmJqfl+6DVeU8mgQQumecGBFfaAWSpFLf3wMIjiZz1PDSQx+wKtcc4KUot50XlnFAW1msD6uSMHF
        tnMvTWBg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1neKgx-00FOGO-0D; Tue, 12 Apr 2022 17:52:39 +0000
Date:   Tue, 12 Apr 2022 10:52:38 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Yi Zhang <yi.zhang@redhat.com>,
        Bob Pearson <rpearsonhpe@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH] Revert "scsi: scsi_debug: Address races following module
 load"
Message-ID: <YlW8ZrL65ZKpQZ+j@bombadil.infradead.org>
References: <20220409043704.28573-1-bvanassche@acm.org>
 <5fb68dbd-ae0e-6230-8f9f-dd6df5593584@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5fb68dbd-ae0e-6230-8f9f-dd6df5593584@interlog.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Apr 09, 2022 at 03:10:14PM -0400, Douglas Gilbert wrote:
> On 2022-04-09 00:37, Bart Van Assche wrote:
> > Revert the patch mentioned in the subject since it blocks I/O after
> > module unload has started while this is a legitimate use case. For e.g.
> > blktests test case srp/001 that patch causes a command timeout to be
> > triggered for the following call stack:
> > 
> > __schedule+0x4c3/0xd20
> > schedule+0x82/0x110
> > schedule_timeout+0x122/0x200
> > io_schedule_timeout+0x7b/0xc0
> > __wait_for_common+0x2bc/0x380
> > wait_for_completion_io_timeout+0x1d/0x20
> > blk_execute_rq+0x1db/0x200
> > __scsi_execute+0x1fb/0x310
> > sd_sync_cache+0x155/0x2c0 [sd_mod]
> > sd_shutdown+0xbb/0x190 [sd_mod]
> > sd_remove+0x5b/0x80 [sd_mod]
> > device_remove+0x9a/0xb0
> > device_release_driver_internal+0x2c5/0x360
> > device_release_driver+0x12/0x20
> > bus_remove_device+0x1aa/0x270
> > device_del+0x2d4/0x640
> > __scsi_remove_device+0x168/0x1a0
> > scsi_forget_host+0xa8/0xb0
> > scsi_remove_host+0x9b/0x150
> > sdebug_driver_remove+0x3d/0x140 [scsi_debug]
> > device_remove+0x6f/0xb0
> > device_release_driver_internal+0x2c5/0x360
> > device_release_driver+0x12/0x20
> > bus_remove_device+0x1aa/0x270
> > device_del+0x2d4/0x640
> > device_unregister+0x18/0x70
> > sdebug_do_remove_host+0x138/0x180 [scsi_debug]
> > scsi_debug_exit+0x45/0xd5 [scsi_debug]
> > __do_sys_delete_module.constprop.0+0x210/0x320
> > __x64_sys_delete_module+0x1f/0x30
> > do_syscall_64+0x35/0x80
> > entry_SYSCALL_64_after_hwframe+0x44/0xae
> > 
> > Reported-by: Yi Zhang <yi.zhang@redhat.com>
> > Cc: Douglas Gilbert <dgilbert@interlog.com>
> > Cc: Yi Zhang <yi.zhang@redhat.com>
> > Cc: Bob Pearson <rpearsonhpe@gmail.com>
> > Fixes: 2aad3cd85370 ("scsi: scsi_debug: Address races following module load"; )
> > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 
> Acked-by: Douglas Gilbert <dgilbert@interlog.com>
> 
> This was a relatively old patch developed in conjunction with Luis Chamberlain
> <mcgrof@kernel.org>. So it may have been overtaken by other developments.
> I forwarded the "[bug report][bisected] modprob -r scsi-debug take more than
> 3mins during blktests srp/ tests" email to Luis but haven't heard back. So I'm
> happy to remove it.

Upstream patient module removal inside kmod will help and is the right
thing to do all around. However modules can also strive to make the
removal painless too. How much work a module does to make it painless is
up to its authors. In lieu of kmod patient module removal, users of the
module should be aware of these issue though and open code it as I have
in fstests [0] as an example.

Note that kmod patient module removal is not yet merged but soon will
be.

[0] https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/commit/?id=d405c21d40aa1f0ca846dd144a1a7731e55679b2

  Luis
