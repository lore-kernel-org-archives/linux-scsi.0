From: Paul Wagland <paul@kungfoocoder.org>
Subject: Re: megaraid /proc under kernel 2.6.2
Date: Mon, 16 Feb 2004 22:03:03 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076965383.2263.5.camel@morsel.kungfoocoder.org>
References: <1076884890.2943.265.camel@morsel.kungfoocoder.org>
	 <20040216095901.A13715@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out5.xs4all.nl ([194.109.24.6]:33288 "EHLO
	smtp-out5.xs4all.nl") by vger.kernel.org with ESMTP id S265825AbUBPVDI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Feb 2004 16:03:08 -0500
In-Reply-To: <20040216095901.A13715@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux SCSI mailing list <linux-scsi@vger.kernel.org>

On Mon, 2004-02-16 at 10:59, Christoph Hellwig wrote:
> On Sun, Feb 15, 2004 at 11:41:31PM +0100, Paul Wagland wrote:
> > partitions in use, one which is used for swap, one for /boot and one for
> > a device mapper PV, even though my system is running, and using all
> > three devices, the usage count on the megaraid driver is still 0, and I
> > can rmmod the module, although doing so brings up:

> megaraid doesn't set the moduler owner for the host_template.  Fix is below.

This patch does indeed fix the problem, thank you!

> ===== drivers/scsi/megaraid.c 1.59 vs edited =====
> --- 1.59/drivers/scsi/megaraid.c	Fri Jan 23 06:37:03 2004
> +++ edited/drivers/scsi/megaraid.c	Sun Feb 15 00:52:51 2004
> @@ -4614,6 +4614,7 @@
>  }
>  
>  static struct scsi_host_template megaraid_template = {
> +	.module				= THIS_MODULE,
>  	.name				= "MegaRAID",
>  	.proc_name			= "megaraid",
>  	.info				= megaraid_info,
> -


> I don't have the lsightest idea about the procfs issue, though (and no
> megaraid card neraby to test)

I still have no idea what is happening here, but it is tax time so I
don't really have the time to look tonight ;-) I will try to look
further at it tomorrow...

Cheers,
Paul

