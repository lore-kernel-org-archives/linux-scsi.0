From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bugme-new] [Bug 5244] New: HW RAID1 detected as zero size dr
 ive
Date: Wed, 14 Sep 2005 12:35:48 -0700
Message-ID: <20050914123548.38b6b56a.akpm@osdl.org>
References: <0E3FA95632D6D047BA649F95DAB60E5703662B32@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:58345 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932300AbVINTgb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Sep 2005 15:36:31 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5703662B32@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <sju@lsil.com>
Cc: linux-scsi@vger.kernel.org, sreenib@lsil.com, bugme-daemon@kernel-bugs.osdl.org

"Ju, Seokmann" <sju@lsil.com> wrote:
>
> > On Tuesday, September 13, 2005 7:55 PM, Andrew Morton wrote:
> > > Could whoever maintains the megaraid driver(s) please submit 
> > > a MANTAINERS
> > > patch?
> > > 
> > > It broke in 2.6.14-rc1.
> > I'm checking out 2.6.14-rc1, right now. The patch will be 
> > submitted soon.
> I've compiled the kernel and created bzImage and initrd.
> When I reboot the system with 2.6.14-rc1, I'm getting panic without any
> meaningful messages.

It's unusual to get a panic with no messages which explain the reason for
the panic.  We'd need to get additional info about that panic to proceed
any further.

You may need to double-check the .config - sometimes `make oldconfig'
doesn't quite do the right thing, especially if the old config file isn't
very recent.

If you're on x86_64 you may need this:

--- devel/mm/slab.c~fix-slab-bug-due-to-change-in-array-cache-size	2005-09-14 11:54:18.000000000 -0700
+++ devel-akpm/mm/slab.c	2005-09-14 11:54:18.000000000 -0700
@@ -659,7 +659,7 @@ static inline kmem_cache_t *__find_gener
  	* kmem_cache_create(), or __kmalloc(), before
  	* the generic caches are initialized.
  	*/
-	BUG_ON(csizep->cs_cachep == NULL);
+	BUG_ON(malloc_sizes[INDEX_AC].cs_cachep == NULL);
 #endif
 	while (size > csizep->cs_size)
 		csizep++;
_

