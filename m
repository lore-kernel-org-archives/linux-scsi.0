Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF46C4CECD
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 19:41:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E2782078C
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 19:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgD0Tlv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 15:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726384AbgD0Tlt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Apr 2020 15:41:49 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876E3C0610D5
        for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2020 12:41:49 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jT9dO-00D0FX-92; Mon, 27 Apr 2020 19:41:42 +0000
Date:   Mon, 27 Apr 2020 20:41:42 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Don Brace <don.brace@microsemi.com>
Cc:     linux-scsi@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [RFC][PATCHES] compat ioctl cleanup on hpsa
Message-ID: <20200427194142.GX23230@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

	Do you have any problems with the stuff in
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #uaccess.hpsa ?

	Background: I would rather get rid of compat_alloc_user_space() -
it's almost always easier to do without it these days.  The only reason
it used to be useful had been doing compat ioctl handling far away
from where the native ones are dealt with (i.e. in late unlamented
fs/compat_ioctl.c).
	In case of hpsa, it's definitely less headache to just lift the
copyin/copyout of {BIG_,}IOCTL_Command_struct into the callers and
have compat passthru handlers call the same functions.  Without
going through "build a native struct on kernel stack, allocate on
user stack, copy there, only to have hpsa_ioctl() copy it back into
another instance on kernel stack" song and dance.

It's v5.7-rc1-based, with 4 commits in it:
      hpsa passthrough: lift {BIG_,}IOCTL_Command_struct copy{in,out} into hpsa_ioctl()
      hpsa: don't bother with vmalloc for BIG_IOCTL_Command_struct
      hpsa: get rid of compat_alloc_user_space()
      hpsa_ioctl(): tidy up a bit

 drivers/scsi/hpsa.c | 199 ++++++++++++++++++++++++----------------------------
 1 file changed, 90 insertions(+), 109 deletions(-)

	Could you give a look to what's in that branch and comment on it?
