From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 29 Oct 2003 13:45:57 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031029134557.A17523@infradead.org>
References: <20031027153932.A16679@infradead.org> <018b01c39e1f$e013bab0$a0074d0a@apac.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:33295 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262069AbTJ2Np6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 08:45:58 -0500
Content-Disposition: inline
In-Reply-To: <018b01c39e1f$e013bab0$a0074d0a@apac.cisco.com>; from surekhap@cisco.com on Wed, Oct 29, 2003 at 06:53:43PM +0530
List-Id: linux-scsi@vger.kernel.org
To: "Surekha.PC" <surekhap@cisco.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, linux-scsi@vger.kernel.org, davmyers@cisco.com

On Wed, Oct 29, 2003 at 06:53:43PM +0530, Surekha.PC wrote:
> 
> Hi,
> 
>  I have interspersed my answers below for 2 of your comments.
> 
> >	- kill the is_root_disk special casing.  drivers can't know
> >	what the root disks is, there might not even be a single one.
> 
> This flag is needed for our iSCSI network boot implementation to check
> if we are booted on iSCSI disk. This is used while trying to shutdown
> the iSCSI service.

What if the root device changes (pivot_root syscall, namespaces)?  You need
to find a way to do what you want without having knowledge about beeing
a root device in the LLDD - there might not be a single root device and it
could change all the time.

> This is again needed for network boot. The n/w driver and iSCSI driver
> are loaded during early boot. Since the n/w interface is not setup at
> that time, we need to bring up the interface through this call in iSCSI
> driver.

That's bogus.  Look at the ip autoconfig code used by rootnfs and reuse
that instead of creating such bogus hacks.  A driver has no business dealing
with the network configuration.

