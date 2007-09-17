From: David Howells <dhowells@redhat.com>
Subject: Re: CONFIG_BLK_DEV_BSG=n
Date: Mon, 17 Sep 2007 15:46:30 +0100
Message-ID: <19650.1190040390@redhat.com>
References: <1189800008.3343.21.camel@localhost.localdomain> <598D5675D34BE349929AF5EDE9B03E27015558EA@az33exm24.fsl.freescale.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683AbXIQOr1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Sep 2007 10:47:27 -0400
In-Reply-To: <1189800008.3343.21.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, akpm@osdl.org, jens.axboe@oracle.com
Cc: dhowells@redhat.com, Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>, fujita.tomonori@lab.ntt.co.jp, linuxppc-dev@ozlabs.org, Gala Kumar-B11780 <kumar.gala@freescale.com>, paulus@samba.org, linux-scsi@vger.kernel.org


James Bottomley <James.Bottomley@SteelEye.com> wrote:

> > Which solution would you be more comfortable with?
> 
> The one which is currently in -mm is this one:
> 
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=49892223f7d3a2333ef9e6cbdd526676e1fc517a

In my opinion, this is the wrong fix.  There shouldn't be anything in the
kernel using stuff from bsg.h if CONFIG_BLOCK=n, so there should be an error if
anything tries to.  The correct fix is to exclude the non-userspace-visible
contents of bsg.h with #ifdef CONFIG_BLOCK, not to declare things that we've
tried to make sure specifically aren't declared.

David
---

[PATCH] VFS: Make BSG declarations dependent on CONFIG_BLOCK

From: David Howells <dhowells@redhat.com>

Make BSG function declarations dependent on CONFIG_BLOCK as they are not
compilable if the block layer is compiled out.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/bsg.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index 60e377b..28f5d44 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -52,6 +52,7 @@ struct sg_io_v4 {
 };
 
 #ifdef __KERNEL__
+#ifdef CONFIG_BLOCK
 
 #if defined(CONFIG_BLK_DEV_BSG)
 struct bsg_class_device {
@@ -73,6 +74,7 @@ static inline void bsg_unregister_queue(struct request_queue *rq)
 }
 #endif
 
+#endif /* CONFIG_BLOCK */
 #endif /* __KERNEL__ */
 
 #endif
