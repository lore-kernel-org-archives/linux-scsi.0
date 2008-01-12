From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] scsi_transport_spi: convert to attribute groups
Date: Fri, 11 Jan 2008 21:11:22 -0800
Message-ID: <20080112051122.GB19894@kroah.com>
References: <1199549907.3399.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:57812 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbYALFUz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Jan 2008 00:20:55 -0500
Content-Disposition: inline
In-Reply-To: <1199549907.3399.25.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>

On Sat, Jan 05, 2008 at 10:18:27AM -0600, James Bottomley wrote:
> This conversion makes full use of the is_visible() callback on attribute
> groups.  Now, each device appears only with its capability flags in the
> transport class directory.  Previously each device appeared with the
> capability of the host, so this is a functionality improvement.
> Converting to attribute groups allows us to sweep away most of the home
> grown #defines that were effectively doing the same thing.
> 
> James
> 
> ---
> 
> This depends on:
> 
> [PATCH] sysfs: add filter function to groups
> [PATCH] fix the sysfs_add_file_to_group interfaces
> [PATCH] attribute_container: update to use the group interface
> [PATCH] add missing transport configure points for target and host
> 
> Greg and Kay, there's a nasty point in the code where I'd like to use
> the -EEXIST return of sysfs_add_file_to_group() to indicate the file is
> already there, however, this also dumps a stack trace and would frighten
> users ... can we get rid of the printk and the WARN_ON(1)?

I really don't want to, as it has caught a lot of problems in the past.

What do you want to do that needs this error to happen "properly"?

thanks,

greg k-h
