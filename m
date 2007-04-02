From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH]: Fix scsi_send_eh_cmnd scatterlist handling
Date: Mon, 2 Apr 2007 21:29:40 +0200
Message-ID: <20070402192940.GA6644@lst.de>
References: <20070402.122439.71098419.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:57593 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965730AbXDBT3m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Apr 2007 15:29:42 -0400
Content-Disposition: inline
In-Reply-To: <20070402.122439.71098419.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de, tcallawa@redhat.com

On Mon, Apr 02, 2007 at 12:24:39PM -0700, David Miller wrote:
> 
> This fixes a regression caused by commit:
> 
> 2dc611de5a3fd955cd0298c50691d4c05046db97
> 
> The sense buffer code in scsi_send_eh_cmnd was changed to use
> alloc_page() and a scatter list, but the sense data copy was not
> updated to match so what we actually get in the sense buffer is total
> grabage starting with the kernel address of the struct page we got.
> Basically the stack frame of scsi_send_eh_cmd() is what ends up
> in the sense buffer.
> 
> Depending upon how pointers look on a given platform, you can
> end up getting sr_ioctl.c errors when you mount a cdrom.  If
> the CDROM gives a check condition for GPCMD_GET_CONFIGURATION issued
> by drivers/cdrom/cdrom.c:cdrom_mmc_profile(), sr_ioctl will
> spit out this error message in sr_do_ioctl() with the way pointers
> are on sparc64:
> 
> 		default:
> 			printk(KERN_ERR "%s: CDROM (ioctl) error, command: ", cd->cdi.name);
> 			__scsi_print_command(cgc->cmd);
> 			scsi_print_sense_hdr("sr", &sshdr);
> 			err = -EIO;
> 
> This is the error Tom Callaway reported in:
> 
> http://marc.info/?l=linux-sparc&m=117407453208101&w=2
> 
> Anyways, fix this by using page_address(sgl.page) which is OK
> because we know this is low-mem due to GFP_ATOMIC.

The patch looks correct to me and thanks for spotting this stupid
bug!
