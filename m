From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: Re: [Jfs-discussion] [PATCH 25/42] jfs: simplify procfs code
Date: Wed, 16 May 2018 08:15:52 -0500
Message-ID: <6e2593f4-6456-7a43-4af5-f3fdd9e78ab7@oracle.com>
References: <20180516094346.20506-1-hch@lst.de>
 <20180516094346.20506-26-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180516094346.20506-26-hch@lst.de>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-rtc@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, linux-ide@vger.kernel.org, netfilter-devel@vger.kernel.org, megaraidlinux.pdl@broadcom.com, netdev@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, jfs-discussion@lists.sourceforge.net, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

On 05/16/2018 04:43 AM, Christoph Hellwig wrote:
> Use remove_proc_subtree to remove the whole subtree on cleanup, and
> unwind the registration loop into individual calls.  Switch to use
> proc_create_seq where applicable.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by:  Dave Kleikamp <dave.kleikamp@oracle.com>

> ---
>  fs/jfs/jfs_debug.c    | 43 ++++++++++++++-----------------------------
>  fs/jfs/jfs_debug.h    | 10 +++++-----
>  fs/jfs/jfs_logmgr.c   | 14 +-------------
>  fs/jfs/jfs_metapage.c | 14 +-------------
>  fs/jfs/jfs_txnmgr.c   | 28 ++--------------------------
>  fs/jfs/jfs_xtree.c    | 14 +-------------
>  6 files changed, 24 insertions(+), 99 deletions(-)
> 
> diff --git a/fs/jfs/jfs_debug.c b/fs/jfs/jfs_debug.c
> index a70907606025..35a5b2a81ae0 100644
> --- a/fs/jfs/jfs_debug.c
> +++ b/fs/jfs/jfs_debug.c
> @@ -29,7 +29,6 @@
>  
>  #ifdef PROC_FS_JFS /* see jfs_debug.h */
>  
> -static struct proc_dir_entry *base;
>  #ifdef CONFIG_JFS_DEBUG
>  static int jfs_loglevel_proc_show(struct seq_file *m, void *v)
>  {
> @@ -66,43 +65,29 @@ static const struct file_operations jfs_loglevel_proc_fops = {
>  };
>  #endif
>  
> -static struct {
> -	const char	*name;
> -	const struct file_operations *proc_fops;
> -} Entries[] = {
> -#ifdef CONFIG_JFS_STATISTICS
> -	{ "lmstats",	&jfs_lmstats_proc_fops, },
> -	{ "txstats",	&jfs_txstats_proc_fops, },
> -	{ "xtstat",	&jfs_xtstat_proc_fops, },
> -	{ "mpstat",	&jfs_mpstat_proc_fops, },
> -#endif
> -#ifdef CONFIG_JFS_DEBUG
> -	{ "TxAnchor",	&jfs_txanchor_proc_fops, },
> -	{ "loglevel",	&jfs_loglevel_proc_fops }
> -#endif
> -};
> -#define NPROCENT	ARRAY_SIZE(Entries)
> -
>  void jfs_proc_init(void)
>  {
> -	int i;
> +	struct proc_dir_entry *base;
>  
> -	if (!(base = proc_mkdir("fs/jfs", NULL)))
> +	base = proc_mkdir("fs/jfs", NULL);
> +	if (!base)
>  		return;
>  
> -	for (i = 0; i < NPROCENT; i++)
> -		proc_create(Entries[i].name, 0, base, Entries[i].proc_fops);
> +#ifdef CONFIG_JFS_STATISTICS
> +	proc_create_single("lmstats", 0, base, jfs_lmstats_proc_show);
> +	proc_create_single("txstats", 0, base, jfs_txstats_proc_show);
> +	proc_create_single("xtstat", 0, base, jfs_xtstat_proc_show);
> +	proc_create_single("mpstat", 0, base, jfs_mpstat_proc_show);
> +#endif
> +#ifdef CONFIG_JFS_DEBUG
> +	proc_create_single("TxAnchor", 0, base, jfs_txanchor_proc_show);
> +	proc_create("loglevel", 0, base, &jfs_loglevel_proc_fops);
> +#endif
>  }
>  
>  void jfs_proc_clean(void)
>  {
> -	int i;
> -
> -	if (base) {
> -		for (i = 0; i < NPROCENT; i++)
> -			remove_proc_entry(Entries[i].name, base);
> -		remove_proc_entry("fs/jfs", NULL);
> -	}
> +	remove_proc_subtree("fs/jfs", NULL);
>  }
>  
>  #endif /* PROC_FS_JFS */
> diff --git a/fs/jfs/jfs_debug.h b/fs/jfs/jfs_debug.h
> index eafd1300a00b..0d9e35da8462 100644
> --- a/fs/jfs/jfs_debug.h
> +++ b/fs/jfs/jfs_debug.h
> @@ -62,7 +62,7 @@ extern void jfs_proc_clean(void);
>  
>  extern int jfsloglevel;
>  
> -extern const struct file_operations jfs_txanchor_proc_fops;
> +int jfs_txanchor_proc_show(struct seq_file *m, void *v);
>  
>  /* information message: e.g., configuration, major event */
>  #define jfs_info(fmt, arg...) do {			\
> @@ -105,10 +105,10 @@ extern const struct file_operations jfs_txanchor_proc_fops;
>   *	----------
>   */
>  #ifdef	CONFIG_JFS_STATISTICS
> -extern const struct file_operations jfs_lmstats_proc_fops;
> -extern const struct file_operations jfs_txstats_proc_fops;
> -extern const struct file_operations jfs_mpstat_proc_fops;
> -extern const struct file_operations jfs_xtstat_proc_fops;
> +int jfs_lmstats_proc_show(struct seq_file *m, void *v);
> +int jfs_txstats_proc_show(struct seq_file *m, void *v);
> +int jfs_mpstat_proc_show(struct seq_file *m, void *v);
> +int jfs_xtstat_proc_show(struct seq_file *m, void *v);
>  
>  #define	INCREMENT(x)		((x)++)
>  #define	DECREMENT(x)		((x)--)
> diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
> index 0e5d412c0b01..6b68df395892 100644
> --- a/fs/jfs/jfs_logmgr.c
> +++ b/fs/jfs/jfs_logmgr.c
> @@ -2493,7 +2493,7 @@ int lmLogFormat(struct jfs_log *log, s64 logAddress, int logSize)
>  }
>  
>  #ifdef CONFIG_JFS_STATISTICS
> -static int jfs_lmstats_proc_show(struct seq_file *m, void *v)
> +int jfs_lmstats_proc_show(struct seq_file *m, void *v)
>  {
>  	seq_printf(m,
>  		       "JFS Logmgr stats\n"
> @@ -2510,16 +2510,4 @@ static int jfs_lmstats_proc_show(struct seq_file *m, void *v)
>  		       lmStat.partial_page);
>  	return 0;
>  }
> -
> -static int jfs_lmstats_proc_open(struct inode *inode, struct file *file)
> -{
> -	return single_open(file, jfs_lmstats_proc_show, NULL);
> -}
> -
> -const struct file_operations jfs_lmstats_proc_fops = {
> -	.open		= jfs_lmstats_proc_open,
> -	.read		= seq_read,
> -	.llseek		= seq_lseek,
> -	.release	= single_release,
> -};
>  #endif /* CONFIG_JFS_STATISTICS */
> diff --git a/fs/jfs/jfs_metapage.c b/fs/jfs/jfs_metapage.c
> index 1a3b0cc22ad3..fa2c6824c7f2 100644
> --- a/fs/jfs/jfs_metapage.c
> +++ b/fs/jfs/jfs_metapage.c
> @@ -815,7 +815,7 @@ void __invalidate_metapages(struct inode *ip, s64 addr, int len)
>  }
>  
>  #ifdef CONFIG_JFS_STATISTICS
> -static int jfs_mpstat_proc_show(struct seq_file *m, void *v)
> +int jfs_mpstat_proc_show(struct seq_file *m, void *v)
>  {
>  	seq_printf(m,
>  		       "JFS Metapage statistics\n"
> @@ -828,16 +828,4 @@ static int jfs_mpstat_proc_show(struct seq_file *m, void *v)
>  		       mpStat.lockwait);
>  	return 0;
>  }
> -
> -static int jfs_mpstat_proc_open(struct inode *inode, struct file *file)
> -{
> -	return single_open(file, jfs_mpstat_proc_show, NULL);
> -}
> -
> -const struct file_operations jfs_mpstat_proc_fops = {
> -	.open		= jfs_mpstat_proc_open,
> -	.read		= seq_read,
> -	.llseek		= seq_lseek,
> -	.release	= single_release,
> -};
>  #endif
> diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
> index 4d973524c887..a5663cb621d8 100644
> --- a/fs/jfs/jfs_txnmgr.c
> +++ b/fs/jfs/jfs_txnmgr.c
> @@ -2998,7 +2998,7 @@ int jfs_sync(void *arg)
>  }
>  
>  #if defined(CONFIG_PROC_FS) && defined(CONFIG_JFS_DEBUG)
> -static int jfs_txanchor_proc_show(struct seq_file *m, void *v)
> +int jfs_txanchor_proc_show(struct seq_file *m, void *v)
>  {
>  	char *freewait;
>  	char *freelockwait;
> @@ -3032,22 +3032,10 @@ static int jfs_txanchor_proc_show(struct seq_file *m, void *v)
>  		       list_empty(&TxAnchor.unlock_queue) ? "" : "not ");
>  	return 0;
>  }
> -
> -static int jfs_txanchor_proc_open(struct inode *inode, struct file *file)
> -{
> -	return single_open(file, jfs_txanchor_proc_show, NULL);
> -}
> -
> -const struct file_operations jfs_txanchor_proc_fops = {
> -	.open		= jfs_txanchor_proc_open,
> -	.read		= seq_read,
> -	.llseek		= seq_lseek,
> -	.release	= single_release,
> -};
>  #endif
>  
>  #if defined(CONFIG_PROC_FS) && defined(CONFIG_JFS_STATISTICS)
> -static int jfs_txstats_proc_show(struct seq_file *m, void *v)
> +int jfs_txstats_proc_show(struct seq_file *m, void *v)
>  {
>  	seq_printf(m,
>  		       "JFS TxStats\n"
> @@ -3072,16 +3060,4 @@ static int jfs_txstats_proc_show(struct seq_file *m, void *v)
>  		       TxStat.txLockAlloc_freelock);
>  	return 0;
>  }
> -
> -static int jfs_txstats_proc_open(struct inode *inode, struct file *file)
> -{
> -	return single_open(file, jfs_txstats_proc_show, NULL);
> -}
> -
> -const struct file_operations jfs_txstats_proc_fops = {
> -	.open		= jfs_txstats_proc_open,
> -	.read		= seq_read,
> -	.llseek		= seq_lseek,
> -	.release	= single_release,
> -};
>  #endif
> diff --git a/fs/jfs/jfs_xtree.c b/fs/jfs/jfs_xtree.c
> index 5cde6d2fcfca..2c200b5256a6 100644
> --- a/fs/jfs/jfs_xtree.c
> +++ b/fs/jfs/jfs_xtree.c
> @@ -3874,7 +3874,7 @@ s64 xtTruncate_pmap(tid_t tid, struct inode *ip, s64 committed_size)
>  }
>  
>  #ifdef CONFIG_JFS_STATISTICS
> -static int jfs_xtstat_proc_show(struct seq_file *m, void *v)
> +int jfs_xtstat_proc_show(struct seq_file *m, void *v)
>  {
>  	seq_printf(m,
>  		       "JFS Xtree statistics\n"
> @@ -3887,16 +3887,4 @@ static int jfs_xtstat_proc_show(struct seq_file *m, void *v)
>  		       xtStat.split);
>  	return 0;
>  }
> -
> -static int jfs_xtstat_proc_open(struct inode *inode, struct file *file)
> -{
> -	return single_open(file, jfs_xtstat_proc_show, NULL);
> -}
> -
> -const struct file_operations jfs_xtstat_proc_fops = {
> -	.open		= jfs_xtstat_proc_open,
> -	.read		= seq_read,
> -	.llseek		= seq_lseek,
> -	.release	= single_release,
> -};
>  #endif
> 
