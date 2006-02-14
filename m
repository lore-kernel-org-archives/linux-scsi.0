From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] megaraid_sas : block physical disk access
Date: Tue, 14 Feb 2006 12:52:56 -0600
Message-ID: <1139943176.14115.22.camel@mulgrave.il.steeleye.com>
References: <1139528847.4628.26.camel@dhcp80-31.lsil.com>
	 <20060210131021.GA9733@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:60805 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030517AbWBNSxY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Feb 2006 13:53:24 -0500
In-Reply-To: <20060210131021.GA9733@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Sumant Patro <sumantp@lsil.com>, mark_salyzyn@adaptec.com, sreenib@lsil.com, Neela.kolli@lsil.com, Bo.Yang@lsil.com, linux-scsi@vger.kernel.org, Chandra_Nelogal@Dell.com

On Fri, 2006-02-10 at 14:10 +0100, Christoph Hellwig wrote:
> > Here is the patch for review that implements slave_alloc to block direct 
> > access to the Physical Disks.
> > By using no_uld_attach and clearing the scsi device writeable flag the disks will be 
> > still accessible even if it belongs to a RAID volume.
> > I would prefer to hide the Physical Disks to block any kind of access.
> > 
> > I will send a separate patch to monitor drive insertion/removal to update internally 
> > the physical disk list.
> 
> Far too much bloat for what you're trying to do.  If you want the same
> behaviour as the initial megaraid_sas patch just take my patch and
> replace the setting of no_uld_attach with return -ENXIO in
> megasas_slave_alloc or move all that to slave_alloc if you you really
> care.
> 
> But I'm strongly against even that, physical disks should be available
> through /dev/sg.

I'd prefer to expose the underlying disks but refuse ULD binding so they
only show up in /dev/sg.  I have to say that this is extremely useful
for external applications (like clustered ones) who want to be able to
identify shared resources.  Since only root has access to /dev/sg, using
it wrongly is strongly caveat emptor.

James


