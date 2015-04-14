From: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 1/3] vfs: add copy_file_range syscall and vfs helper
Date: Tue, 14 Apr 2015 13:04:18 -0700
Message-ID: <20150414200418.GA24660@lenny.home.zabbo.net>
References: <20150411000208.GA20949@lenny.home.zabbo.net>
 <CAHQdGtSaaPHbvtBM3yVGtAFpEAP8ZquYvErknq_rCoCCK+W2bA@mail.gmail.com>
 <20150411090402.67d22d02@tlielax.poochiereds.net>
 <20150414165344.GA21421@infradead.org>
 <552D4B5D.3090904@Netapp.com>
 <20150414181911.GA2080@fieldses.org>
 <20150414182241.GB23129@lenny.home.zabbo.net>
 <20150414182906.GB2080@fieldses.org>
 <20150414185408.GC23129@lenny.home.zabbo.net>
 <20150414192325.GB20599@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150414192325.GB20599-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 14, 2015 at 12:23:25PM -0700, Christoph Hellwig wrote:
> On Tue, Apr 14, 2015 at 11:54:08AM -0700, Zach Brown wrote:
> > Is this relying on btrfs range cloning being atomic?  It certainly
> > doesn't look atomic.  It can modify items across an arbitrarily large
> > number of leaf blocks.  It can make the changes across multiple
> > transactions which could introduce partial modification on reboot after
> > crashes.  It can fail (the dynamic duo: enomem, eio) and leave the
> > desintation partially modified.
> 
> I didn't mean atomic in the failure atomic sense, but in the sense of
> being atomic vs other writes, similar to how Posix specifies it for
> writes vs other writes.  Guess I need to express this intent better.

Ah, right, OK.

- z
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
