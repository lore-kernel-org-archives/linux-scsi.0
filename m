From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] megaraid_sas : block physical disk access
Date: Fri, 10 Feb 2006 14:10:21 +0100
Message-ID: <20060210131021.GA9733@lst.de>
References: <1139528847.4628.26.camel@dhcp80-31.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:34536 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932079AbWBJNKf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2006 08:10:35 -0500
Content-Disposition: inline
In-Reply-To: <1139528847.4628.26.camel@dhcp80-31.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumant Patro <sumantp@lsil.com>
Cc: hch@lst.de, mark_salyzyn@adaptec.com, sreenib@lsil.com, Neela.kolli@lsil.com, Bo.Yang@lsil.com, linux-scsi@vger.kernel.org, Chandra_Nelogal@Dell.com

On Thu, Feb 09, 2006 at 03:47:27PM -0800, Sumant Patro wrote:
> 
> Here is the patch for review that implements slave_alloc to block direct 
> access to the Physical Disks.
> By using no_uld_attach and clearing the scsi device writeable flag the disks will be 
> still accessible even if it belongs to a RAID volume.
> I would prefer to hide the Physical Disks to block any kind of access.
> 
> I will send a separate patch to monitor drive insertion/removal to update internally 
> the physical disk list.

Far too much bloat for what you're trying to do.  If you want the same
behaviour as the initial megaraid_sas patch just take my patch and
replace the setting of no_uld_attach with return -ENXIO in
megasas_slave_alloc or move all that to slave_alloc if you you really
care.

But I'm strongly against even that, physical disks should be available
through /dev/sg.

