From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] [SCSI] aacraid: prevent ZERO_SIZE_PTR dereference
Date: Tue, 29 Oct 2013 12:59:40 -0700
Message-ID: <CA+55aFzTJpx+J3hH+FjsxCmajTjD_nLzHSzbvX02JwDQ1e2U4g@mail.gmail.com>
References: <20131025144452.GA28451@ngolde.de>
	<20131029191007.GD21820@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52809 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab3J2T7l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Oct 2013 15:59:41 -0400
Received: by mail-vb0-f46.google.com with SMTP id 10so253696vbe.19
        for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2013 12:59:40 -0700 (PDT)
In-Reply-To: <20131029191007.GD21820@longonot.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, "security@kernel.org" <security@kernel.org>

On Tue, Oct 29, 2013 at 12:10 PM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> If "fibsize" is zero then it leads to a ZERO_SIZE_PTR dereference when
> we dereference user_srbcmd.

Btw, these "ZERO_SIZE_PTR dereference" issues aren't about
ZERO_SIZE_PTR, they are about overrunning the allocations. The
ZERO_SIZE_PTR pointer is a perfectly valid pointer and can be
dereferenced just fine, as long as you stay within the allocation
size.

Think about it.

So I really get the feeling that checking for a zero size is very
wrong. If we can access the ZERO_SIZE_PTR, that means that we at some
point don't check the size limits, and if that's true for the zero
size, I don't see why that wouldn't be true for *other* sizes too..

I didn't check this particular case, and maybe zero really is special.
But it's not clear at all why it should be. Can you explain why zero
is special here, and why the buffer overrun cannot happen with size 1,
for example?

Because quite frankly, from what I can tell, testing against zero is
absolutely *WRONG*. Any size less than the size of "struct
user_aac_srb" would seem to be bogus.

This has nothing to do with zero, or with ZERO_SIZE_PTR.

Tell me why I'm wrong.

                Linus
