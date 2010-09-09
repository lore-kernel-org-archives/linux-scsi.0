From: Anil kumar <anils_r@yahoo.com>
Subject: Re: scsi_cmnd data_buffer checksum
Date: Thu, 9 Sep 2010 02:09:28 -0700 (PDT)
Message-ID: <215508.92384.qm@web32402.mail.mud.yahoo.com>
References: <20100909085142.GA15327@schmichrtp.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web32402.mail.mud.yahoo.com ([68.142.207.195]:46433 "HELO
	web32402.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751037Ab0IIJJa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Sep 2010 05:09:30 -0400
In-Reply-To: <20100909085142.GA15327@schmichrtp.mainz.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

I quickly tried copying the data buffer to local buffers as follows:

In Queuecommand:

cmd->local_write_buf = pci_alloc_consistent(...);
cmd->write_buf = (u8 *)(kmap_atomic(sg->page, KM_IRQ0) + sg->offset);

memcpy(cmd->local_write_buf, cmd->write_buf, scsibufflen(scsi_cmnd));

Now I calculate checksums of cmd->write_buf and my local cmd->local_write_buf

and the checksum fails. Am I doing something wrong here?

--- On Thu, 9/9/10, Christof Schmitt <christof.schmitt@de.ibm.com> wrote:

> From: Christof Schmitt <christof.schmitt@de.ibm.com>
> Subject: Re: scsi_cmnd data_buffer checksum
> To: "Anil kumar" <anils_r@yahoo.com>
> Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
> Date: Thursday, September 9, 2010, 4:51 AM
> On Thu, Sep 09, 2010 at 01:35:02AM
> -0700, Anil kumar wrote:
> > Hi Christof,
> > 
> > Thanks for the response.
> > 
> > I am running mkfs.ext3 command.
> > 
> > I am doing the following in the driver for write(10):
> > 
> > Queuecommand:
> > 
> > sg = scsi_sglist(cmd->scsi_cmd);
> > cmd->write_buf = (u8 *)(kmap_atomic(sg->page,
> KM_IRQ0) + sg->offset);
> > Calculate checksum for write_buf
> > 
> > Write Done:
> > Calculate checksum for cmd->write_buf
> > 
> > and checksums don't match. I am wondering how come OS
> changed the cmd->write_buf when I have not even unmapped
> the buffer. Is filesystem changing this cmd->write_buf
> pages when driver/HW is working on it?
> 
> Yes, the driver has direct access to the data. Usually, the
> data is
> not copied for I/O requests. The driver gets one sg list
> that points
> to the data pages of file system (or whatever the data
> source is).
> When the filesystem decides to change the data, this single
> data
> buffer is changed.
> 
> > Is there anyway I can avoid this. How about if we
> allocate a local buffer(kmalloc/pci_alloc_consistent) and
> memcpy kmap_atomic to that local buffer and then calculate
> checksum on that local buffer. Will this help?
> 
> Sure, you can create copies of data buffers in the driver,
> calculate
> the checksum of the copy and submit the data copy with the
> checksum to
> the hardware controller. This is usually not done for
> performance
> reasons, and you probably should keep a mempool to be able
> to issue
> I/Os when memory is low.
> 
> Christof
> 


      
