From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: scsi_cmnd data_buffer checksum
Date: Thu, 9 Sep 2010 11:29:06 +0200
Message-ID: <20100909092906.GA21760@schmichrtp.mainz.de.ibm.com>
References: <20100909085142.GA15327@schmichrtp.mainz.de.ibm.com>
 <215508.92384.qm@web32402.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <215508.92384.qm@web32402.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil kumar <anils_r@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 09, 2010 at 02:09:28AM -0700, Anil kumar wrote:
> I quickly tried copying the data buffer to local buffers as follows:
> 
> In Queuecommand:
> 
> cmd->local_write_buf = pci_alloc_consistent(...);
> cmd->write_buf = (u8 *)(kmap_atomic(sg->page, KM_IRQ0) + sg->offset);
> 
> memcpy(cmd->local_write_buf, cmd->write_buf, scsibufflen(scsi_cmnd));
> 
> Now I calculate checksums of cmd->write_buf and my local cmd->local_write_buf
> 
> and the checksum fails. Am I doing something wrong here?

Are you only copying one element of the sg list? Are you sure that
there is only one element? If not, you have to use something like
scsi_kmap_atomic_sg and create a copy of each element (maybe use
scsi_for_each_sg).

Or maybe there is another problem... hard to guess from the distance.

Christof
