From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 34/40] atm: simplify procfs code
Date: Sat, 05 May 2018 07:51:18 -0500
Message-ID: <87r2mq2rll.fsf@xmission.com>
References: <20180425154827.32251-1-hch@lst.de>
 <20180425154827.32251-35-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180425154827.32251-35-hch@lst.de> (Christoph Hellwig's message
 of "Wed, 25 Apr 2018 17:48:21 +0200")
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
Cc: linux-rtc@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jfs-discussion@lists.sourceforge.net, linux-afs@lists.infradead.org, linux-acpi@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Jiri Slaby <jslaby@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, megaraidlinux.pdl@broadcom.com, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> Use remove_proc_subtree to remove the whole subtree on cleanup, and
> unwind the registration loop into individual calls.  Switch to use
> proc_create_seq where applicable.

Can you please explain why you are removing the error handling when
you are unwinding the registration loop?

>  int __init atm_proc_init(void)
>  {
> -	static struct atm_proc_entry *e;
> -	int ret;
> -
>  	atm_proc_root = proc_net_mkdir(&init_net, "atm", init_net.proc_net);
>  	if (!atm_proc_root)
> -		goto err_out;
> -	for (e = atm_proc_ents; e->name; e++) {
> -		struct proc_dir_entry *dirent;
> -
> -		dirent = proc_create(e->name, 0444,
> -				     atm_proc_root, e->proc_fops);
> -		if (!dirent)
> -			goto err_out_remove;
> -		e->dirent = dirent;
> -	}
> -	ret = 0;
> -out:
> -	return ret;
> -
> -err_out_remove:
> -	atm_proc_dirs_remove();
> -err_out:
> -	ret = -ENOMEM;
> -	goto out;
> +		return -ENOMEM;
> +	proc_create_seq("devices", 0444, atm_proc_root, &atm_dev_seq_ops);
> +	proc_create("pvc", 0444, atm_proc_root, &pvc_seq_fops);
> +	proc_create("svc", 0444, atm_proc_root, &svc_seq_fops);
> +	proc_create("vc", 0444, atm_proc_root, &vcc_seq_fops);
> +	return 0;
>  }

These proc entries could fail to register with -ENOMEM if for no other
reason.  Can you justify the removal of the error handling?

Can you please at least mention that removal in your change description
and explain why it is reasonable.

As it sits this is not a semantics preserving transformation, and the
difference is not documented.  Which raises red flags for me.

Eric
