From: Christoph Hellwig <hch@lst.de>
Subject: Re: unify SCSI_IOCTL_SEND_COMMAND implementations
Date: Thu, 23 Mar 2006 15:48:00 +0100
Message-ID: <20060323144800.GA27044@lst.de>
References: <20060322165204.GA32287@lst.de> <20060323101819.GV4285@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:30687 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932413AbWCWOsD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Mar 2006 09:48:03 -0500
Content-Disposition: inline
In-Reply-To: <20060323101819.GV4285@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Thu, Mar 23, 2006 at 11:18:19AM +0100, Jens Axboe wrote:
> > the non-S/G I/O path.  Jens, what do you think about adding a check
> > for non-S/G I/O in the midlayer?
> 
> Looks good to me. Are cdrom/sr sg clean as well?

there's just one place in cdrom.c that sends a request directly:
cdrom_read_cdda_bpc, which sends a S/G BLOCK_PC one. Everything else
goes through ->packet_command which is implemented as oldstyle-PC
requests in IDE and S/G BLOCK_PC in scsi.  all scsi-internal requests
including those from sr are S/G of BLOCK_PC type.
