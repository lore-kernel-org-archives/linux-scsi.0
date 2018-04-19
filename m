From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 03/39] proc: introduce proc_create_seq_private
Date: Thu, 19 Apr 2018 17:18:18 +0300
Message-ID: <20180419141818.pjys7at4xmz2h6ho@mwanda>
References: <20180419124140.9309-1-hch@lst.de>
 <20180419124140.9309-4-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20180419124140.9309-4-hch@lst.de>
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
Cc: linux-rtc@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, devel@driverdev.osuosl.org, Corey Minyard <minyard@acm.org>, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, megaraidlinux.pdl@broadcom.com, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, linux-ide@vger.kernel.org, netfilter-devel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, jfs-discussion@lists.sourceforge.net, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 19, 2018 at 02:41:04PM +0200, Christoph Hellwig wrote:
> diff --git a/drivers/s390/cio/blacklist.c b/drivers/s390/cio/blacklist.c
> index 2a3f874a21d5..ad35cddcf6af 100644
> --- a/drivers/s390/cio/blacklist.c
> +++ b/drivers/s390/cio/blacklist.c
> @@ -391,28 +391,15 @@ static const struct seq_operations cio_ignore_proc_seq_ops = {
>  	.show  = cio_ignore_proc_seq_show,
>  };
>  
> -static int
> -cio_ignore_proc_open(struct inode *inode, struct file *file)
> -{
> -	return seq_open_private(file, &cio_ignore_proc_seq_ops,
> -				sizeof(struct ccwdev_iter));
> -}
> -
> -static const struct file_operations cio_ignore_proc_fops = {
> -	.open    = cio_ignore_proc_open,
> -	.read    = seq_read,
> -	.llseek  = seq_lseek,
> -	.release = seq_release_private,
> -	.write   = cio_ignore_write,
                   ^^^^^^^^^^^^^^^^
The cio_ignore_write() function isn't used any more so compilers will
complain.

> -};
> -
>  static int
>  cio_ignore_proc_init (void)
>  {
>  	struct proc_dir_entry *entry;
>  
> -	entry = proc_create("cio_ignore", S_IFREG | S_IRUGO | S_IWUSR, NULL,
> -			    &cio_ignore_proc_fops);
> +	entry = proc_create_seq_private("cio_ignore",
> +			S_IFREG | S_IRUGO | S_IWUSR, NULL,
> +			&cio_ignore_proc_seq_ops, sizeof(struct ccwdev_iter),
> +			NULL);
>  	if (!entry)
>  		return -ENOENT;
>  	return 0;

regards,
dan carpenter
