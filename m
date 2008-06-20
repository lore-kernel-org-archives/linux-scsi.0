From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] Separating out libata out of SCSI (finally)
Date: Sat, 21 Jun 2008 08:50:38 +0900
Message-ID: <485C424E.1060208@kernel.org>
References: <485B2CC6.6070201@kernel.org> <1213993737.3443.35.camel@localhost.localdomain> <485C31FE.8050408@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <485C31FE.8050408@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, brking@linux.vnet.ibm.com, Mark Lord <liml@rtr.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> 1) Make SCSI block devices themselves an allocate-able resource (I think
> that's what you meant by "placed into it's own module so both sd and a
> ULD ata driver could use it"?)
> 
> 2) Ensure that any ata_disk ULD would support the same partition limits
> and ioctl set, enough to ensure binary compatibility.
> 
> Because that's the real need -- maintaining binary compatibility with
> SCSI block devices, so major/minor, ioctl supported set, partition
> limits, and other relevant details need to remain unchanged.
> 
> The underlying software we're of course free to change...

I'm taking this approach.  I think it's better than introducing a new
block device while keeping the old one as that causes numerous userland
problems including dup devices (if they're gonna exist side-by-side) and
eventual need for conversion && breakage of old userland on newer kernels.

Thanks.

-- 
tejun
