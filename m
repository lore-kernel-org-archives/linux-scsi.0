From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: libata & scsi rescan.
Date: Thu, 7 Oct 2004 18:21:11 -0400
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <20041007222111.GA20023@havoc.gtf.org>
References: <20041001141244.B23006@florence.linkmargin.com> <415DB03E.5090005@pobox.com> <20041004155647.A9589@florence.linkmargin.com> <4161BB01.5080607@pobox.com> <20041006173656.A18221@florence.linkmargin.com> <416496CC.4090105@pobox.com> <20041006214746.A18793@florence.linkmargin.com> <4164B548.7030700@pobox.com> <4164BDD6.6000404@pobox.com> <20041007171457.B21662@florence.linkmargin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20041007171457.B21662@florence.linkmargin.com>
To: Andy Warner <andyw@pobox.com>
Cc: linux-ide@vger.kernel.org, Doug Ledford <dledford@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 07, 2004 at 05:14:57PM -0500, Andy Warner wrote:
> Jeff Garzik wrote:
> > BTW, the SiI folks recommend a debounce timer.
> 
> OK, got that. No problem, queue_delayed_work() and some
> state handles that. Now I've got the following issue,
> calling scsi_remove_device() seems to try and flush
> the disk - not a very productive operation:
> 
> <drive removed>
> ata1: drive not present
> Synchronizing SCSI cache for disk sdb: 
> ATA: abnormal status 0x7F on port 0xF8A3EC87
> ATA: abnormal status 0x7F on port 0xF8A3EC87
> ATA: abnormal status 0x7F on port 0xF8A3EC87
> ata1: command 0xea timeout, stat 0x50 host_stat 0x0
> 
> <drive re-added>
> ata1: drive present
>   Vendor: ATA       Model: ST3160023AS       Rev: 3.17
>   Type:   Direct-Access                      ANSI SCSI revision: 05
> SCSI device sdb: 312581808 512-byte hdwr sectors (160042 MB)
> SCSI device sdb: drive cache: write back
> ATA: abnormal status 0xFF on port 0xF8A3EC87
> ATA: abnormal status 0xFF on port 0xF8A3EC87
> ata1: command 0x25 timeout, stat 0x50 host_stat 0x1
>  unknown partition table
> Attached scsi disk sdb at scsi14, channel 0, id 0, lun 0
> Attached scsi generic sg2 at scsi14, channel 0, id 0, lun 0,  type 0
> 
> 
> I'm not too concerned about the errors when the drive
> appears yet, but trying to access the disk that just
> vanished is never going to work well. Am I missing
> something ?

(you should probably CC linux-scsi@vger.kernel.org as well, when
mentioning SCSI-related stuff)

I've seen this behavior before.  It's weird, but we must deal with it
anyway because

Since scsi_remove_device() must be called in process context, there will
ALWAYS be a window where a command could get issued.  Therefore, we must
create and set a "device is gone" flag in our local structures, and
check that in the queuecommand handler.

You must also make sure to clean up any currently-executing commands
properly, when a device is removed.

	Jeff



