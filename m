From: James.Smart@Emulex.Com
Subject: RE: [PATCH] scsi_mid_low_api doesn't mention scsi_scan_host
Date: Mon, 21 Mar 2005 09:50:07 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AB43@xbl3.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Received: from emulex.emulex.com ([138.239.112.1]:61159 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261468AbVCUOuZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2005 09:50:25 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx, dgilbert@interlog.com, linux-scsi@vger.kernel.org

A nit on the use of "must"....

In the following:

>  /**
> - * scsi_add_host - perform sysfs registration and SCSI bus scan.
> + * scsi_add_host - perform sysfs registration and set up 
> transport class
>   * @shost:   pointer to scsi host instance
>   * @dev:     pointer to struct device of type scsi class
>   *
> @@ -453,7 +455,10 @@ struct scsi_device * scsi_add_device(str
>   *      Might block: no
>   *
>   *      Notes: Only required in "hotplug initialization 
> model" after a
> - *      successful call to scsi_host_alloc().
> + *      successful call to scsi_host_alloc().  The LLD must call
> + *	scsi_scan_host() in order to scan the bus.  The LLD must set up
> + *	the transport template before calling this function and may only
> + *	access the transport class data after this function has 
> been called.
>   *
>   *      Defined in: drivers/scsi/hosts.c
>

It is not mandatory that the LLD call scsi_scan_host(). Although this used
to be the case, a few changes have been made in the midlayer recently as we
attempted to have the transports perform scanning on behalf of the LLD's.
The scsi_scan_target() function can now be used instead of scsi_scan_host().
(note: the symbol scsi_scan_single_target() was added briefly, then removed
as scsi_scan_target was exported).  In the case of the LLD's using the FC
transport, the need not call any scan function. The FC transport calls
scsi_scan_target() for them.

-- james
