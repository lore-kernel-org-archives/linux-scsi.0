From: Andrew Morton <akpm@osdl.org>
Subject: Re: 2.6.10-rc2-mm2 usb storage still oopses
Date: Mon, 29 Nov 2004 16:32:31 -0800
Message-ID: <20041129163231.33affbde.akpm@osdl.org>
References: <200411182203.02176.cova@ferrara.linux.it>
	<20041118133557.72f3b369.akpm@osdl.org>
	<20041118135809.3314ce41@lembas.zaitcev.lan>
	<200411190042.41199.cova@ferrara.linux.it>
	<20041118155542.324f56c7@lembas.zaitcev.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <20041118155542.324f56c7@lembas.zaitcev.lan>
Sender: linux-usb-devel-admin@lists.sourceforge.net
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
Cc: cova@ferrara.linux.it, linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, zaitcev@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Pete Zaitcev <zaitcev@redhat.com> wrote:
>
> On Fri, 19 Nov 2004 00:42:40 +0100, Fabio Coatti <cova@ferrara.linux.it> wrote:
> 
> > Nov 18 20:33:05 kefk kernel: sdb: assuming drive cache: write through
> > Nov 18 20:33:05 kefk kernel:  sdb: sdb1
> > Nov 18 20:33:05 kefk kernel:  sdb: sdb1
> > Nov 18 20:33:05 kefk kernel: kobject_register failed for sdb1 (-17)
> 
> This looks as if SCSI falls victim of the general problem which ub addresses
> with the following fragment:

Guys, is this problem still present in Linus's tree?  If so, is a fix for
2.6.10 looking feasible?

Thanks.

> --- linux-2.6.10-rc1/drivers/block/ub.c	2004-10-28 09:46:38.000000000 -0700
> +++ linux-2.6.10-rc1-ub/drivers/block/ub.c	2004-11-06 23:59:20.000000000 -0800
> @@ -267,6 +263,7 @@ struct ub_dev {
>  	int changed;			/* Media was changed */
>  	int removable;
>  	int readonly;
> +	int first_open;			/* Kludge. See ub_bd_open. */
>  	char name[8];
>  	struct usb_device *dev;
>  	struct usb_interface *intf;
> @@ -1428,6 +1420,26 @@ static int ub_bd_open(struct inode *inod
>  	sc->openc++;
>  	spin_unlock_irqrestore(&ub_lock, flags);
>  
> +	/*
> +	 * This is a workaround for a specific problem in our block layer.
> +	 * In 2.6.9, register_disk duplicates the code from rescan_partitions.
> +	 * However, if we do add_disk with a device which persistently reports
> +	 * a changed media, add_disk calls register_disk, which does do_open,
> +	 * which will call rescan_paritions for changed media. After that,
> +	 * register_disk attempts to do it all again and causes double kobject
> +	 * registration and a eventually an oops on module removal.
> +	 *
> +	 * The bottom line is, Al Viro says that we should not allow
> +	 * bdev->bd_invalidated to be set when doing add_disk no matter what.
> +	 */
> +	if (sc->first_open) {
> +		if (sc->changed) {
> +			sc->first_open = 0;
> +			rc = -ENOMEDIUM;
> +			goto err_open;
> +		}
> +	}
> +
>  	if (sc->removable || sc->readonly)
>  		check_disk_change(inode->i_bdev);
>  
> @@ -1467,6 +1479,8 @@ static int ub_bd_release(struct inode *i
>  
>  	spin_lock_irqsave(&ub_lock, flags);
>  	--sc->openc;
> +	if (sc->openc == 0)
> +		sc->first_open = 0;
>  	if (sc->openc == 0 && atomic_read(&sc->poison))
>  		ub_cleanup(sc);
>  	spin_unlock_irqrestore(&ub_lock, flags);
> @@ -1919,6 +1932,8 @@ static int ub_probe(struct usb_interface
>  	}
>  
>  	sc->removable = 1;		/* XXX Query this from the device */
> +	sc->changed = 1;		/* ub_revalidate clears only */
> +	sc->first_open = 1;
>  
>  	ub_revalidate(sc);
>  	/* This is pretty much a long term P3 */
> 
> This feels kludgy, but my excuse is "James and Viro made me do it".
> I have an IRC log to prove it laying somewhere...
> 
> I'm adding the linux-scsi to cc: in case any comments are forthcoming.
> 
> -- Pete


-------------------------------------------------------
SF email is sponsored by - The IT Product Guide
Read honest & candid reviews on hundreds of IT Products from real users.
Discover which products truly live up to the hype. Start reading now. 
http://productguide.itmanagersjournal.com/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
