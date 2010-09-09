From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: scsi_cmnd data_buffer checksum
Date: Thu, 9 Sep 2010 10:51:43 +0200
Message-ID: <20100909085142.GA15327@schmichrtp.mainz.de.ibm.com>
References: <20100909080028.GA4880@schmichrtp.mainz.de.ibm.com>
 <534531.52796.qm@web32407.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:55916 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab0IIIvp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Sep 2010 04:51:45 -0400
Content-Disposition: inline
In-Reply-To: <534531.52796.qm@web32407.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil kumar <anils_r@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Sep 09, 2010 at 01:35:02AM -0700, Anil kumar wrote:
> Hi Christof,
> 
> Thanks for the response.
> 
> I am running mkfs.ext3 command.
> 
> I am doing the following in the driver for write(10):
> 
> Queuecommand:
> 
> sg = scsi_sglist(cmd->scsi_cmd);
> cmd->write_buf = (u8 *)(kmap_atomic(sg->page, KM_IRQ0) + sg->offset);
> Calculate checksum for write_buf
> 
> Write Done:
> Calculate checksum for cmd->write_buf
> 
> and checksums don't match. I am wondering how come OS changed the cmd->write_buf when I have not even unmapped the buffer. Is filesystem changing this cmd->write_buf pages when driver/HW is working on it?

Yes, the driver has direct access to the data. Usually, the data is
not copied for I/O requests. The driver gets one sg list that points
to the data pages of file system (or whatever the data source is).
When the filesystem decides to change the data, this single data
buffer is changed.

> Is there anyway I can avoid this. How about if we allocate a local buffer(kmalloc/pci_alloc_consistent) and memcpy kmap_atomic to that local buffer and then calculate checksum on that local buffer. Will this help?

Sure, you can create copies of data buffers in the driver, calculate
the checksum of the copy and submit the data copy with the checksum to
the hardware controller. This is usually not done for performance
reasons, and you probably should keep a mempool to be able to issue
I/Os when memory is low.

Christof
