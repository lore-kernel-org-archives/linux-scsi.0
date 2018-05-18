From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH 38/42] isdn: replace ->proc_fops with ->proc_show
Date: Fri, 18 May 2018 10:43:46 +0200
Message-ID: <4e7091873e8a220c454a7ce5a3f52edc5b5c3e3a.camel@tiscali.nl>
References: <20180516094346.20506-1-hch@lst.de>
         <20180516094346.20506-39-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180516094346.20506-39-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, linux-acpi@vger.kernel.org, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, netdev@vger.kernel.org, linux-rtc@vger.kernel.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org, linux-afs@lists.infradead.org, linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Christoph,

(I don't think the patches of this series ever hit the ISDN related addresses
still found in MAINTAINERS. And now I might be a bit late.) 

Christoph Hellwig schreef op wo 16-05-2018 om 11:43 [+0200]:
> diff --git a/drivers/isdn/gigaset/capi.c b/drivers/isdn/gigaset/capi.c
> index ccec7778cad2..dac5cd35e901 100644
> --- a/drivers/isdn/gigaset/capi.c
> +++ b/drivers/isdn/gigaset/capi.c
> @@ -2437,19 +2437,6 @@ static int gigaset_proc_show(struct seq_file *m, void *v)
>  	return 0;
>  }
>  
> -static int gigaset_proc_open(struct inode *inode, struct file *file)
> -{
> -	return single_open(file, gigaset_proc_show, PDE_DATA(inode));
> -}
> -
> -static const struct file_operations gigaset_proc_fops = {
> -	.owner		= THIS_MODULE,
> -	.open		= gigaset_proc_open,
> -	.read		= seq_read,
> -	.llseek		= seq_lseek,
> -	.release	= single_release,
> -};
> -
>  /**
>   * gigaset_isdn_regdev() - register device to LL
>   * @cs:		device descriptor structure.
> @@ -2478,8 +2465,7 @@ int gigaset_isdn_regdev(struct cardstate *cs, const char *isdnid)
>  	iif->ctr.register_appl = gigaset_register_appl;
>  	iif->ctr.release_appl  = gigaset_release_appl;
>  	iif->ctr.send_message  = gigaset_send_message;
> -	iif->ctr.procinfo      = gigaset_procinfo;

Is this intentional? You didn't touch the procinfo method in the other ISDN
drivers, as far as I can see.

(If it was intentional, gigaset_procinfo() can of course be removed.)

> -	iif->ctr.proc_fops = &gigaset_proc_fops;
> +	iif->ctr.proc_show     = gigaset_proc_show,
>  	INIT_LIST_HEAD(&iif->appls);
>  	skb_queue_head_init(&iif->sendqueue);
>  	atomic_set(&iif->sendqlen, 0);

Thanks,


Paul Bolle
