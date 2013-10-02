From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/26] get_user_pages() cleanup
Date: Wed,  2 Oct 2013 16:27:41 +0200
Message-ID: <1380724087-13927-1-git-send-email-jack@suse.cz>
Return-path: <owner-linux-aio@kvack.org>
Sender: owner-linux-aio@kvack.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <andreas.dilger@intel.com>, Andy Walls <awalls@md.metrocast.net>, Arnd Bergmann <arnd@arndb.de>, Benjamin LaHaise <bcrl@kvack.org>, ceph-devel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, Gleb Natapov <gleb@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, hpdd-discuss@lists.01.org, Jarod Wilson <jarod@wilsonet.com>, Jayant Mangalampalli <jayant.mangalampalli@intel.com>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Jesper Nilsson <jesper.nilsson@axis.com>, Kai Makisara <Kai.Makisara@kolumbus.fi>, kvm@vger.kernel.org, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-aio@kvack.org, linux-cris-kernel@axis.com, linux-fbdev@vger.kernel.org, linux-fsdevel@vger.
List-Id: linux-scsi@vger.kernel.org

  Hello,

  In my quest for changing locking around page faults to make things easier for
filesystems I found out get_user_pages() users could use a cleanup.  The
knowledge about necessary locking for get_user_pages() is in tons of places in
drivers and quite a few of them actually get it wrong (don't have mmap_sem when
calling get_user_pages() or hold mmap_sem when calling copy_from_user() in the
surrounding code). Rather often this actually doesn't seem necessary. This
patch series converts lots of places to use either get_user_pages_fast()
or a new simple wrapper get_user_pages_unlocked() to remove the knowledge
of mmap_sem from the drivers. I'm still looking into converting a few remaining
drivers (most notably v4l2) which are more complex.

As I already wrote, in some cases I actually think drivers were buggy (and I
note that in corresponding changelogs). I would really like to ask respective
maintainers to have a look at the patches in their area. Also any other
comments are welcome. Thanks.

								Honza

PS: Sorry for the huge recipient list but I don't really know how to trim it
    down...

CC: Alexander Viro <viro@zeniv.linux.org.uk>
CC: Andreas Dilger <andreas.dilger@intel.com>
CC: Andy Walls <awalls@md.metrocast.net>
CC: Arnd Bergmann <arnd@arndb.de>
CC: Benjamin LaHaise <bcrl@kvack.org>
CC: ceph-devel@vger.kernel.org
CC: Dan Williams <dan.j.williams@intel.com>
CC: David Airlie <airlied@linux.ie>
CC: dri-devel@lists.freedesktop.org
CC: Gleb Natapov <gleb@redhat.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: hpdd-discuss@lists.01.org
CC: Jarod Wilson <jarod@wilsonet.com>
CC: Jayant Mangalampalli <jayant.mangalampalli@intel.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: Jesper Nilsson <jesper.nilsson@axis.com>
CC: Kai Makisara <Kai.Makisara@kolumbus.fi>
CC: kvm@vger.kernel.org
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-aio@kvack.org
CC: linux-cris-kernel@axis.com
CC: linux-fbdev@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
CC: linux-ia64@vger.kernel.org
CC: linux-media@vger.kernel.org
CC: linux-nfs@vger.kernel.org
CC: linux-rdma@vger.kernel.org
CC: linux-scsi@vger.kernel.org
CC: Manu Abraham <abraham.manu@gmail.com>
CC: Mark Allyn <mark.a.allyn@intel.com>
CC: Mikael Starvik <starvik@axis.com>
CC: Mike Marciniszyn <infinipath@intel.com>
CC: Naren Sankar <nsankar@broadcom.com>
CC: Paolo Bonzini <pbonzini@redhat.com>
CC: Peng Tao <tao.peng@emc.com>
CC: Roland Dreier <roland@kernel.org>
CC: Sage Weil <sage@inktank.com>
CC: Scott Davilla <davilla@4pi.com>
CC: Timur Tabi <timur@freescale.com>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Tony Luck <tony.luck@intel.com>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
