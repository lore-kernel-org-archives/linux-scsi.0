From: Paul Mackerras <paulus@samba.org>
Subject: Re: oops when removing sbp2 module
Date: Mon, 6 Oct 2003 13:08:27 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <16256.56491.671416.205944@cargo.ozlabs.ibm.com>
References: <16256.6322.388402.857084@cargo.ozlabs.ibm.com>
	<20031005074902.A26284@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:44486 "EHLO ozlabs.org")
	by vger.kernel.org with ESMTP id S263960AbTJFDI5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Oct 2003 23:08:57 -0400
In-Reply-To: <20031005074902.A26284@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

Patrick Mansfield writes:

> There is a typo on a change to the access_count check. 
> 
> Try this patch:
> 
> --- bleed-2.5/drivers/scsi/scsi_sysfs.c-orig	Mon Sep 29 12:21:09 2003
> +++ bleed-2.5/drivers/scsi/scsi_sysfs.c	Mon Sep 29 16:19:22 2003
> @@ -412,7 +412,7 @@
>  		set_bit(SDEV_DEL, &sdev->sdev_state);
>  		if (sdev->host->hostt->slave_destroy)
>  			sdev->host->hostt->slave_destroy(sdev);
> -		if (atomic_read(&sdev->access_count))
> +		if (!atomic_read(&sdev->access_count))
>  			device_del(&sdev->sdev_gendev);
>  		up_write(&class->subsys.rwsem);
>  	}

That fixes it, it no longer oopses on removing sbp2.  As before I get
a message saying "Device 'fw-host0' does not have a release()
function, it is broken and must be fixed."  I assume that is a problem
with the sbp2 module.

The code in the patch looks a little worrying to me, though.  Is there
some lock we have taken to ensure that no other process could be
modifying sdev->access_count at the same time?  Also, what is to stop
some other process from noticing that sdev->access_count is 0 and
calling device_del(&sdev->sdev_gendev) ?

Regards,
Paul.
