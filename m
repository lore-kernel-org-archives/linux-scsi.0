From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/26] get_user_pages() cleanup
Date: Wed, 2 Oct 2013 09:20:09 -0700
Message-ID: <20131002162009.GA5778@infradead.org>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1380724087-13927-1-git-send-email-jack@suse.cz>
Sender: owner-linux-mm@kvack.org
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <andreas.dilger@intel.com>, Andy Walls <awalls@md.metrocast.net>, Arnd Bergmann <arnd@arndb.de>, Benjamin LaHaise <bcrl@kvack.org>, ceph-devel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, Gleb Natapov <gleb@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, hpdd-discuss@ml01.01.org, Jarod Wilson <jarod@wilsonet.com>, Jayant Mangalampalli <jayant.mangalampalli@intel.com>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Jesper Nilsson <jesper.nilsson@axis.com>, Kai Makisara <Kai.Makisara@kolumbus.fi>, kvm@vger.kernel.org, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-aio@kvack.org, linux-cris-kernel@axis.com, linux-fbdev@vger.kernel.org, linux-fs
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 02, 2013 at 04:27:41PM +0200, Jan Kara wrote:
>   Hello,
> 
>   In my quest for changing locking around page faults to make things easier for
> filesystems I found out get_user_pages() users could use a cleanup.  The
> knowledge about necessary locking for get_user_pages() is in tons of places in
> drivers and quite a few of them actually get it wrong (don't have mmap_sem when
> calling get_user_pages() or hold mmap_sem when calling copy_from_user() in the
> surrounding code). Rather often this actually doesn't seem necessary. This
> patch series converts lots of places to use either get_user_pages_fast()
> or a new simple wrapper get_user_pages_unlocked() to remove the knowledge
> of mmap_sem from the drivers. I'm still looking into converting a few remaining
> drivers (most notably v4l2) which are more complex.

Even looking over the kerneldoc comment next to it I still fail to
understand when you'd want to use get_user_pages_fast and when not.

This isn't meant as an argument against your series, but maybe a hint
that we'd need further work in this direction.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
