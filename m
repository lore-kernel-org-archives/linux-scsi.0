From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Warning: about not setting max_sectors
Date: Tue, 10 Dec 2002 13:23:48 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021210132348.A31628@infradead.org>
References: <200212091455.gB9Etg601956@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200212091455.gB9Etg601956@localhost.localdomain>; from James.Bottomley@steeleye.com on Mon, Dec 09, 2002 at 08:55:41AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Dec 09, 2002 at 08:55:41AM -0600, James Bottomley wrote:
> For some reason, the SCSI core is now warning about drivers which don't set 
> max_sectors.
> 
> Just for the record, we have two parameters in the template:
> 
> sg_tablesize which determines the maximum number of scatter gather entries the 
> host can have (corresponds to max_phys_segments in the block layer), and
> 
> max_sectors, which imposes a maximum overall transfer length (corresponds to 
> max_sectors in the block queue).
> 
> The comments over max_sectors list it as optional (if unset, we set it to the 
> scsi equivalent of machine infinity---well, actually 1024, or 512Mb for usual 
> blocks).
> 
> The reason it's unset on so many drivers is that usually, they have no 
> absolute transfer limit, so they're just bounded by the number of entries in 
> the scatter-gather list.
> 
> I can't see a reason to force every driver suddenly to have an arbitrary 
> max_sectors, so if no-one objects, I'll pull out the warning.

I added this intentionally.  The default is set in scsi_register_host
which is an obsolete interface.  This warning reminds driver writers to set
the value explicitly, with scsi_add_host & friends they won't get a default
anymore.

