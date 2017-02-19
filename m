From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: scsi: BUG in scsi_init_io
Date: Sun, 19 Feb 2017 07:15:27 +0000
Message-ID: <20170219071522.GI29622@ZenIV.linux.org.uk>
References: <CACT4Y+YAX_SmwzsHenzkswM0kp=om5NivmLW8d9Js6EN3zKmGQ@mail.gmail.com>
 <20170131092048.GB3687@linux-x5ow.site>
 <CACT4Y+Y0Yi43kN+sAOd=pu4FTnW4wPeGwiDHEU45s6DTXs_JmQ@mail.gmail.com>
 <1485877311.3199.4.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:58426 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750978AbdBSHQL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Feb 2017 02:16:11 -0500
Content-Disposition: inline
In-Reply-To: <1485877311.3199.4.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, syzkaller <syzkaller@googlegroups.com>, Hannes Reinecke <hare@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>

On Tue, Jan 31, 2017 at 07:41:51AM -0800, James Bottomley wrote:

> > Please-please-please, let's not use WARN for something that is not a
> > kernel bug and is user-triggerable.
> 
> It is a kernel bug and it should not be user triggerable, so it should
> have a warn_on or bug_on.  It means something called a data setup
> function with no data.  There's actually a root cause that patches like
> this won't fix, can we find it?

The root cause is unfixable without access to TARDIS and dose of
antipsychotics sufficient to prevent /dev/sg API creation.

What happens is that write to /dev/sg is given a request with non-zero
->iovec_count combined with zero ->dxfer_len.  Or with ->dxferp pointing
to an array full of empty iovecs.

AFAICS, the minimal fix would be something like this:

YAMissingSanityCheck in /dev/sg

write permission to /dev/sg shouldn't be equivalent to the ability to trigger
BUG_ON() while holding spinlocks...

Cc: stable@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index dbe5b4b95df0..121de0aaa6ad 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1753,6 +1753,10 @@ sg_start_req(Sg_request *srp, unsigned char *cmd)
 			return res;
 
 		iov_iter_truncate(&i, hp->dxfer_len);
+		if (!iov_iter_count(&i)) {
+			kfree(iov);
+			return -EINVAL;
+		}
 
 		res = blk_rq_map_user_iov(q, rq, md, &i, GFP_ATOMIC);
 		kfree(iov);
