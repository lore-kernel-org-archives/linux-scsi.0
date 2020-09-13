Return-Path: <SRS0=npVx=CW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B09F9C43461
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Sep 2020 06:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46FA621655
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Sep 2020 06:51:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tgRT2y9f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbgIMGvG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Sep 2020 02:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgIMGvE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Sep 2020 02:51:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250EEC061573;
        Sat, 12 Sep 2020 23:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=G8Jt3Cj5p4UQTWwyjETj0ogW7uLgq2Y1WhT3SbsNF4s=; b=tgRT2y9fguKfz5VbcjSOhPITkq
        XdvrFfdNFdltuBvbH2bz8qzU2AXmFOimgVRKvjIw8Up3QJi0hWH+ktd6oEZRrum63ySvBzlfmyxBV
        AV5itW1NWovlXeNYAWMyOhf4Yd4zyLZ7zvQHkdJMBViPbzER3wszh+qx7rzYE1IRCuFJMzstoPgbw
        xb4yXHht0mPCZW6rPsNpRb2o3SG/hoTDqoV6DEvsYBnei/6bjOV/j6xLUgW5sCXvBxlPqIRfstle0
        ua1x7p//Aq/EO52Uw0KHEZ9i4e4GFivANzfGms+LbgkG+Eq0FUaAEnykggHnC18wYN8ZussrPsuR8
        6WBDft9Q==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kHLqd-0005bX-TL; Sun, 13 Sep 2020 06:50:51 +0000
Date:   Sun, 13 Sep 2020 07:50:51 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, megaraidlinux.pdl@broadcom.com,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        viro@zeniv.linux.org.uk
Subject: compat_alloc_user_space removal, was Re: [PATCH 3/3] scsi:
 megaraid_sas: simplify compat_ioctl handling
Message-ID: <20200913065051.GA17932@infradead.org>
References: <20200908213715.3553098-1-arnd@arndb.de>
 <20200908213715.3553098-3-arnd@arndb.de>
 <20200912074757.GA6688@infradead.org>
 <CAK8P3a363DxgZnN9x4oNL7W4__kyG1U_34=7Hpqhpc-obAvjWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a363DxgZnN9x4oNL7W4__kyG1U_34=7Hpqhpc-obAvjWw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Sep 12, 2020 at 02:49:05PM +0200, Arnd Bergmann wrote:
> fs/quota/compat.c: dqblk = compat_alloc_user_space(sizeof(struct if_dqblk));
> fs/quota/compat.c: dqblk = compat_alloc_user_space(sizeof(struct if_dqblk));
> fs/quota/compat.c: fsqstat = compat_alloc_user_space(sizeof(struct
> fs_quota_stat));

I sent this out a while ago, an Al has it in a branch, but not in
linux-next:

https://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git/log/?h=work.quota-compat

> drivers/staging/media/atomisp/pci/atomisp_compat_ioctl32.c: karg =
> compat_alloc_user_space(
> 
> Had a brief look but did not investigate further, it's complicated.
> 
> drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c: args =
> compat_alloc_user_space(sizeof(*args));
> drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c: args =
> compat_alloc_user_space(sizeof(*args) +
> drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c: args =
> compat_alloc_user_space(sizeof(*args));
> drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c: args =
> compat_alloc_user_space(sizeof(*args) +
> drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c: args =
> compat_alloc_user_space(sizeof(*args));
> drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c: args =
> compat_alloc_user_space(sizeof(*args));
> 
> Should not be too hard, but I have not looked in detail.

We do not have to care about staging drivers when removing interfaces.
But to be nice you probably ping the maintainers to see what they can
do.

I also have the mount side handles in this branch which I need to rebase
and submit:

http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/mount-cleanups

> I think you got the wrong one there, the code above is where the
> dma address gets stored in the in-kernel copy of the sense data
> based on the user space offset. Conceptually it does make sense
> though and would end up looking something like
> 
>         if (ioc->sense_len) {
>                 /*
>                  * sense_ptr points to the location that has the user
>                  * sense buffer address
>                  */
>                 sense_ptr = (void *)ioc->frame.raw + ioc->sense_off;
>                 if (in_compat_syscall())
>                         uptr = compat_ptr(get_unaligned(u32 *)sense_ptr);
>                 else
>                         uptr = get_unaligned((void __user **)sense_ptr);
> 
>                 if (copy_to_user(uptr, sense, ioc->sense_len)) {

Indeed.  As said, I had started on the change and gave up pretty quickly
:)

> I tried that, but there is still one difference because one of them uses
> MEGASAS_IOC_FIRMWARE while the other one uses
> MEGASAS_IOC_FIRMWARE32. It would be possible to have
> a common handler that always handles both command codes.
> I tried to avoid changing the behavior that way though.

Ok.
