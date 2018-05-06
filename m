From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: simplify procfs code for seq_file instances V2
Date: Sun, 6 May 2018 18:45:31 +0100
Message-ID: <20180506174531.GK30522@ZenIV.linux.org.uk>
References: <20180425154827.32251-1-hch@lst.de>
 <20180506171948.GA769@avx2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180506171948.GA769@avx2>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, linux-acpi@vger.kernel.org, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, netdev@vger.kernel.org, linux-rtc@vger.kernel.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org, linux-afs@lists.infradead.org, linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, May 06, 2018 at 08:19:49PM +0300, Alexey Dobriyan wrote:
> +++ b/fs/proc/internal.h
> @@ -48,8 +48,8 @@ struct proc_dir_entry {
>  		const struct seq_operations *seq_ops;
>  		int (*single_show)(struct seq_file *, void *);
>  	};
> -	unsigned int state_size;
>  	void *data;
> +	unsigned int state_size;
>  	unsigned int low_ino;
>  	nlink_t nlink;
>  	kuid_t uid;

Makes sense

> @@ -62,9 +62,9 @@ struct proc_dir_entry {
>  	umode_t mode;
>  	u8 namelen;
>  #ifdef CONFIG_64BIT
> -#define SIZEOF_PDE_INLINE_NAME	(192-139)
> +#define SIZEOF_PDE_INLINE_NAME	(192-155)
>  #else
> -#define SIZEOF_PDE_INLINE_NAME	(128-87)
> +#define SIZEOF_PDE_INLINE_NAME	(128-95)

>  #endif
>  	char inline_name[SIZEOF_PDE_INLINE_NAME];
>  } __randomize_layout;

*UGH*

Both to the original state and that kind of "adjustments".
Incidentally, with __bugger_layout in there these expressions
are simply wrong.

If nothing else, I would suggest turning the last one into
	char inline_name[];
in hope that layout won't get... randomized that much and
used

#ifdef CONFIG_64BIT
#define PDE_SIZE 192
#else
#define PDE_SIZE 128
#endif

union __proc_dir_entry {
	char pad[PDE_SIZE];
	struct proc_dir_entry real;
};

#define SIZEOF_PDE_INLINE_NAME (PDE_SIZE - offsetof(struct proc_dir_entry, inline_name))

for constants, adjusted sizeof and sizeof_field when creating
proc_dir_entry_cache and turned proc_root into

union __proc_dir_entry __proc_root = { .real = {
        .low_ino        = PROC_ROOT_INO,
        .namelen        = 5,
        .mode           = S_IFDIR | S_IRUGO | S_IXUGO,
        .nlink          = 2,
        .refcnt         = REFCOUNT_INIT(1),
        .proc_iops      = &proc_root_inode_operations,
        .proc_fops      = &proc_root_operations,
        .parent         = &__proc_root.real,
        .subdir         = RB_ROOT,
        .name           = __proc_root.real.inline_name,
        .inline_name    = "/proc",
}};

#define proc_root __proc_root.real
(or actually used __proc_root.real in all of a 6 places where it remains).

> diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
> index baf1994289ce..7d94fa005b0d 100644
> --- a/fs/proc/proc_net.c
> +++ b/fs/proc/proc_net.c
> @@ -40,7 +40,7 @@ static struct net *get_proc_net(const struct inode *inode)
>  
>  static int seq_open_net(struct inode *inode, struct file *file)
>  {
> -	size_t state_size = PDE(inode)->state_size;
> +	unsigned int state_size = PDE(inode)->state_size;
>  	struct seq_net_private *p;
>  	struct net *net;

<shakes head>
You and your "size_t is evil" crusade...
