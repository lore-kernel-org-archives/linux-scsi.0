From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 02/39] proc: introduce proc_create_seq{,_data}
Date: Thu, 19 Apr 2018 21:41:06 +0300
Message-ID: <20180419184106.GA2066@avx2>
References: <20180419124140.9309-1-hch@lst.de>
 <20180419124140.9309-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20180419124140.9309-3-hch@lst.de>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-rtc@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, Corey Minyard <minyard@acm.org>, linux-ide@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Jiri Slaby <jslaby@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, megaraidlinux.pdl@broadcom.com, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 19, 2018 at 02:41:03PM +0200, Christoph Hellwig wrote:
> Variants of proc_create{,_data} that directly take a struct seq_operations
> argument and drastically reduces the boilerplate code in the callers.

> +static int proc_seq_open(struct inode *inode, struct file *file)
> +{
> +	struct proc_dir_entry *de = PDE(inode);
> +
> +	return seq_open(file, de->seq_ops);
> +}
> +
> +static const struct file_operations proc_seq_fops = {
> +	.open		= proc_seq_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= seq_release,
> +};
> +
> +struct proc_dir_entry *proc_create_seq_data(const char *name, umode_t mode,
> +		struct proc_dir_entry *parent, const struct seq_operations *ops,
> +		void *data)
> +{
> +	struct proc_dir_entry *p;
> +
> +	p = proc_create_data(name, mode, parent, &proc_seq_fops, data);
> +	if (p)
> +		p->seq_ops = ops;
> +	return p;
> +}

Should be oopsable.
Once proc_create_data() returns, entry is live, ->open can be called.

> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -44,6 +44,7 @@ struct proc_dir_entry {
>  	struct completion *pde_unload_completion;
>  	const struct inode_operations *proc_iops;
>  	const struct file_operations *proc_fops;
> +	const struct seq_operations *seq_ops;
>  	void *data;
>  	unsigned int low_ino;
>  	nlink_t nlink;

"struct proc_dir_entry is 192/128 bytes now.
If someone knows how to pad array to certain size without union
please tell.
