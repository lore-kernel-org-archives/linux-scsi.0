From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi_host sysfs updates scsi-misc-2.5 [2/2]
Date: Fri, 9 May 2003 07:59:46 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030509075946.A10204@infradead.org>
References: <20030509063321.GA3259@beaverton.ibm.com> <20030509063453.GB3259@beaverton.ibm.com> <20030509063545.GC3259@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([195.224.96.167]:30219 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262320AbTEIGrJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 May 2003 02:47:09 -0400
Received: from hch by phoenix.infradead.org with local (Exim 4.10)
	id 19E1r8-0002fs-00
	for linux-scsi@vger.kernel.org; Fri, 09 May 2003 07:59:46 +0100
Content-Disposition: inline
In-Reply-To: <20030509063545.GC3259@beaverton.ibm.com>; from andmike@us.ibm.com on Thu, May 08, 2003 at 11:35:45PM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Thu, May 08, 2003 at 11:35:45PM -0700, Mike Anderson wrote:
> --- sysfs-scsi-misc-2.5/drivers/scsi/hosts.h~scsi_shost_sysfs-misc-fix	Thu May  8 22:46:53 2003
> +++ sysfs-scsi-misc-2.5-andmike/drivers/scsi/hosts.h	Thu May  8 22:46:53 2003
> @@ -556,6 +556,7 @@ extern int scsi_unregister_device(struct
>   */
>  extern struct Scsi_Host * scsi_register(Scsi_Host_Template *, int);
>  extern void scsi_unregister(struct Scsi_Host *);
> +extern void scsi_free_shost(struct Scsi_Host *);

This should go into scsi_priv.h

>  
>  /*
>   * HBA registration/unregistration.
> @@ -570,6 +571,7 @@ extern int scsi_register_host(Scsi_Host_
>  extern int scsi_unregister_host(Scsi_Host_Template *);
>  
>  extern struct Scsi_Host *scsi_host_hn_get(unsigned short);
> +extern void scsi_host_get(struct Scsi_Host *);
>  extern void scsi_host_put(struct Scsi_Host *);

This should go either into scsi_priv.h or exported if we see
a use for it in driver (I'd rather avoid drivers messing with
reference counts, though)

Patch looks fine otherwise.
