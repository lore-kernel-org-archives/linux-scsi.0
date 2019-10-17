Return-Path: <SRS0=lSD6=YK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 272B4ECE58D
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Oct 2019 19:37:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E97E320640
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Oct 2019 19:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392579AbfJQThB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Oct 2019 15:37:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44990 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728856AbfJQThA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Oct 2019 15:37:00 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iLBZz-0006VG-Aq; Thu, 17 Oct 2019 19:36:59 +0000
Date:   Thu, 17 Oct 2019 20:36:59 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCHES] drivers/scsi/sg.c uaccess cleanups/fixes
Message-ID: <20191017193659.GA18702@ZenIV.linux.org.uk>
References: <CAHk-=wgOWxqwqCFuP_Bw=Hxxf9njeHJs0OLNGNc63peNd=kRqw@mail.gmail.com>
 <20191010195504.GI26530@ZenIV.linux.org.uk>
 <CAHk-=wgWRQo0m7TUCK4T_J-3Vqte+p-FWzvT3CB1jJHgX-KctA@mail.gmail.com>
 <20191011001104.GJ26530@ZenIV.linux.org.uk>
 <CAHk-=wgg3jzkk-jObm1FLVYGS8JCTiKppEnA00_QX7Wsm5ieLQ@mail.gmail.com>
 <20191013181333.GK26530@ZenIV.linux.org.uk>
 <CAHk-=wgrWGyACBM8N8KP7Pu_2VopuzM4A12yQz6Eo=X2Jpwzcw@mail.gmail.com>
 <20191013191050.GL26530@ZenIV.linux.org.uk>
 <CAHk-=wjJNE9hOKuatqh6SFf4nd65LG4ZR3gQSgg+rjSpVxe89w@mail.gmail.com>
 <20191016202540.GQ26530@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016202540.GQ26530@ZenIV.linux.org.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 16, 2019 at 09:25:40PM +0100, Al Viro wrote:

> FWIW, callers of __copy_from_user() remaining in the generic code:

> 6) drivers/scsi/sg.c nest: sg_read() ones are memdup_user() in disguise
> (i.e. fold with immediately preceding kmalloc()s).  sg_new_write() -
> fold with access_ok() into copy_from_user() (for both call sites).
> sg_write() - lose access_ok(), use copy_from_user() (both call sites)
> and get_user() (instead of the solitary __get_user() there).

Turns out that there'd been outright redundant access_ok() calls (not
even warranted by __copy_...) *and* several __put_user()/__get_user()
with no checking of return value (access_ok() was there, handling of
unmapped addresses wasn't).  The latter go back at least to 2.1.early...

I've got a series that presumably fixes and cleans the things up
in that area; it didn't get any serious testing (the kernel builds
and boots, smartctl works as well as it used to, but that's not
worth much - all it says is that SG_IO doesn't fail terribly;
I don't have any test setup for really working with /dev/sg*).

IOW, it needs more review and testing - this is _not_ a pull request.
It's in vfs.git#work.sg; individual patches are in followups.
Shortlog/diffstat:
Al Viro (8):
      sg_ioctl(): fix copyout handling
      sg_new_write(): replace access_ok() + __copy_from_user() with copy_from_user()
      sg_write(): __get_user() can fail...
      sg_read(): simplify reading ->pack_id of userland sg_io_hdr_t
      sg_new_write(): don't bother with access_ok
      sg_read(): get rid of access_ok()/__copy_..._user()
      sg_write(): get rid of access_ok()/__copy_from_user()/__get_user()
      SG_IO: get rid of access_ok()

 drivers/scsi/sg.c | 98 ++++++++++++++++++++++++++++++++----------------------------------------------------------------
 1 file changed, 32 insertions(+), 66 deletions(-)

