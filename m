From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 5/6] esp_scsi: De-duplicate PIO routines
Date: Wed, 17 Oct 2018 01:08:54 -0700
Message-ID: <20181017080854.GB24540@infradead.org>
References: <cover.1539497520.git.fthain@telegraphics.com.au>
 <d5fe773ea8c922631836dad2ef2dbb952672c7c7.1539497520.git.fthain@telegraphics.com.au>
 <35ac9f31-7068-ab93-4629-363ee0bb4c70@suse.de>
 <alpine.LNX.2.21.1810151717520.10@nippy.intranet>
 <2b48c925-73f0-0ca0-2f3c-3c35d90010ba@suse.de>
 <alpine.LNX.2.21.1810161014080.10@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.21.1810161014080.10@nippy.intranet>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 16, 2018 at 10:52:26AM +1100, Finn Thain wrote:
> True enough. We agree that this #ifdef is undesirable. And yet when I 
> tried it, I found an unexpected readability benefit to your suggestion:
> 
> #ifdef CONFIG_SCSI_ESP_PIO
>         u8 __iomem              *fifo_reg;
>         int                     send_cmd_error;
>         u32                     send_cmd_residual;
> #endif
> 
> This grouping does help convey the purpose of these struct members, even 
> though the #ifdef is meant for the compiler not for the human reader.
> 
> So maybe it makes sense to group these definitions (they are all the same 
> size):
> 
>         /* These are used by esp_scsi_send_pio_cmd() */
>         u8 __iomem              *fifo_reg;
>         int                     send_cmd_error;
>         u32                     send_cmd_residual;

I like the grouping, and in fact the ifdef sounds fine to me as well.

> Do static checkers really complain about this? I think the validity of an 
> extern can't be known until the final linkage is done.

None that I know of does, and as said before this patterns is very
common all over the kernel.
