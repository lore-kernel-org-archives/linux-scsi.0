From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Canonical SCSI messages
Date: Fri, 1 Oct 2004 10:30:54 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041001173054.GA1363@us.ibm.com>
References: <20041001165324.GE16153@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:5852 "EHLO e35.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S265207AbUJARa5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Oct 2004 13:30:57 -0400
Content-Disposition: inline
In-Reply-To: <20041001165324.GE16153@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox [matthew@wil.cx] wrote:
> 
> The difference between scsi(4:0:6:0) and sym4:6:0 annoyed me sufficiently
> that I remembered a patch from Mike Anderson and Patrick Mansfield a few
> months ago.  Their patch makes the output look like:
> 
> PCI: Enabling device: (0000:00:0c.0), cmd 143
> sym53c8xx 0000:00:0c.0: chip <875> rev 0x4 at pci 0000:00:0c.0 irq 17
> sym53c8xx 0000:00:0c.0: No NVRAM, ID 7, Fast-20, SE, parity checking 
> sym53c8xx 0000:00:0c.0: SCSI BUS has been reset.
> scsi0 : sym-2.1.18f
> sym53c8xx 0000:00:0c.0: 0: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 16)
>   Vendor: IBM       Model: IC35L036UWD210-0  Rev: S5BS
>   Type:   Direct-Access                      ANSI SCSI revision: 03
> 
> I have to say, I'm not keen on using the PCI address, partly because it's
> so long, partly because we'd still have a discrepancy between the scsi
> layer's reports and the driver's reports, and partly because I'd like
> to see all scsi drivers report in the same format (and not everything
> is pci).
> 
> I quite like the scsi(H:C:I:L) format that scsi_transport_spi.c uses.
> It means that people still have to look up what scsiN maps to, but I
> don't think that's a huge problem.  It certainly beats having to look
> up that scsi3 is sym1 is pci0000:00:0c.1
> 

There has been a lot of debate on consistent message formats in the
past. I have not tracked this in a while. The previous patch was based
on what I thought was a common API all where trying to use (i.e.,
dev_printk)

In 2.6 with the host numbers being mutable, some users may have to do
some groking through the logs to re-establish linkage between the log
message and the adapter in represents.

If a user is not insmoding there driver or changing there system config
this is probably not an issue.

It does not seem that hard to run lsscsi --hosts.

-andmike
--
Michael Anderson
andmike@us.ibm.com

