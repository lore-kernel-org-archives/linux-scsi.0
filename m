From: Jan Kara <jack@suse.cz>
Subject: Re: [LFS/VM TOPIC] Stable pages while IO (was Wrong DIF guard tag
 on ext2 write)
Date: Fri, 4 Jun 2010 18:23:32 +0200
Message-ID: <20100604162332.GF3414@quack.suse.cz>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
 <4C07D3D0.8010500@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab0FDQXx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jun 2010 12:23:53 -0400
Content-Disposition: inline
In-Reply-To: <4C07D3D0.8010500@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, lsf10-pc@lists.linuxfoundation.org, Nick Piggin <npiggin@suse.de>, Al Viro <viro@ZenIV.linux.org.uk>, Chris Mason <chris.mason@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ric Wheeler <rwheeler@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Vladislav Bolkhovitin <vst@vlnb.net>, Christoph Hellwig <hch@lst.de>

On Thu 03-06-10 19:09:52, Boaz Harrosh wrote:
> [Topic]
> How to not let pages change while in IO
> 
> [Abstract]
> As seen in a long thread on the fsdvel scsi mailing lists. Lots of
> people have headaches and sleep less nights because individual pages
> can change while in IO and/or DMA. Though each one as slightly different
> needs, the mechanics look to be the same.
  Hmm, I don't think it's really about "how to not let pages change" - that
is doable by using wait_on_page_writeback() in ->page_mkwrite and
->write_begin. I think the discussion is more about whether we should do it
or whether we should rechecksum and resubmit IO in case of checksum failure
as Nick proposed...

								Honza
> People that care:
> - Mirror and RAID people that need on disk consistency.
> - Network storage that wants data checksum.
> - DIF/DIX people
> - ...
> 
> I for one know nothing of the subject but am a RAID person and would
> like a solution that does not force me to copy the complete data load.
> 
> Please lets get all the VM VFS and drivers people in one room and see
> if we can have a Linux solution to this problem
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
