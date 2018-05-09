From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: simplify procfs code for seq_file instances V2
Date: Wed, 9 May 2018 19:53:31 +0300
Message-ID: <20180509165331.GC16034@avx2>
References: <20180425154827.32251-1-hch@lst.de> <20180506171948.GA769@avx2>
 <20180506174531.GK30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20180506174531.GK30522@ZenIV.linux.org.uk>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-rtc@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jfs-discussion@lists.sourceforge.net, linux-afs@lists.infradead.org, linux-acpi@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, Jiri Slaby <jslaby@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>, megaraidlinux.pdl@broadcom.com, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

On Sun, May 06, 2018 at 06:45:31PM +0100, Al Viro wrote:
> On Sun, May 06, 2018 at 08:19:49PM +0300, Alexey Dobriyan wrote:

> > @@ -62,9 +62,9 @@ struct proc_dir_entry {
> >  	umode_t mode;
> >  	u8 namelen;
> >  #ifdef CONFIG_64BIT
> > -#define SIZEOF_PDE_INLINE_NAME	(192-139)
> > +#define SIZEOF_PDE_INLINE_NAME	(192-155)
> >  #else
> > -#define SIZEOF_PDE_INLINE_NAME	(128-87)
> > +#define SIZEOF_PDE_INLINE_NAME	(128-95)
> 
> >  #endif
> >  	char inline_name[SIZEOF_PDE_INLINE_NAME];
> >  } __randomize_layout;
> 
> *UGH*

I agree. Maintaining these numbers is a pain point.
Who knew people were going to start adding fields right away.

> Both to the original state and that kind of "adjustments".
> Incidentally, with __bugger_layout in there these expressions
> are simply wrong.

Struct randomization is exempt from maintaining sizeof as they are already
screwing cachelines and everything. But if patch works with lockdep and
randomization -- even better.

> If nothing else, I would suggest turning the last one into
> 	char inline_name[];
> in hope that layout won't get... randomized that much and
> used
> 
> #ifdef CONFIG_64BIT
> #define PDE_SIZE 192
> #else
> #define PDE_SIZE 128
> #endif
> 
> union __proc_dir_entry {
> 	char pad[PDE_SIZE];
> 	struct proc_dir_entry real;
> };
> 
> #define SIZEOF_PDE_INLINE_NAME (PDE_SIZE - offsetof(struct proc_dir_entry, inline_name))
> 
> for constants, adjusted sizeof and sizeof_field when creating
> proc_dir_entry_cache and turned proc_root into
> 
> union __proc_dir_entry __proc_root = { .real = {
>         .low_ino        = PROC_ROOT_INO,
>         .namelen        = 5,
>         .mode           = S_IFDIR | S_IRUGO | S_IXUGO,
>         .nlink          = 2,
>         .refcnt         = REFCOUNT_INIT(1),
>         .proc_iops      = &proc_root_inode_operations,
>         .proc_fops      = &proc_root_operations,
>         .parent         = &__proc_root.real,
>         .subdir         = RB_ROOT,
>         .name           = __proc_root.real.inline_name,
>         .inline_name    = "/proc",
> }};
> 
> #define proc_root __proc_root.real
> (or actually used __proc_root.real in all of a 6 places where it remains).
> 
> > -	size_t state_size = PDE(inode)->state_size;
> > +	unsigned int state_size = PDE(inode)->state_size;
> 
> <shakes head>
> You and your "size_t is evil" crusade...

[nods]

        unsigned long           flags;          /* error bits */
        unsigned long           i_state;
        unsigned long           s_blocksize;
        unsigned long           s_flags;
        unsigned long           s_iflags;       /* internal SB_I_* flags */
