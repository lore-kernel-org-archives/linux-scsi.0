From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v2 5/6] esp_scsi: De-duplicate PIO routines
Date: Tue, 16 Oct 2018 10:52:26 +1100 (AEDT)
Message-ID: <alpine.LNX.2.21.1810161014080.10@nippy.intranet>
References: <cover.1539497520.git.fthain@telegraphics.com.au> <d5fe773ea8c922631836dad2ef2dbb952672c7c7.1539497520.git.fthain@telegraphics.com.au> <35ac9f31-7068-ab93-4629-363ee0bb4c70@suse.de> <alpine.LNX.2.21.1810151717520.10@nippy.intranet>
 <2b48c925-73f0-0ca0-2f3c-3c35d90010ba@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2b48c925-73f0-0ca0-2f3c-3c35d90010ba@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 15 Oct 2018, Hannes Reinecke wrote:

> > 
> > In the case of send_cmd_residual, that would mean a second #ifdef 
> > added to esp_data_bytes_sent() where it gets used. I'm happy to comply 
> > but I fear that all these #ifdefs may harm readability...
> > 
> > There are already other variables in struct esp that may go unused, 
> > such as dma_regs, that don't have #ifdefs to elide them. Are these 
> > also problematic in some way?
> > 
> The unused fields in the struct are not so much an issue; in fact, it 
> rather complicated things when having individual fields in the struct 
> surrounded by CONFIG_XXX, as then the order of the fields would change 
> depending on the configuration. Which makes it really hard to debug ..
> 

True enough. We agree that this #ifdef is undesirable. And yet when I 
tried it, I found an unexpected readability benefit to your suggestion:

#ifdef CONFIG_SCSI_ESP_PIO
        u8 __iomem              *fifo_reg;
        int                     send_cmd_error;
        u32                     send_cmd_residual;
#endif

This grouping does help convey the purpose of these struct members, even 
though the #ifdef is meant for the compiler not for the human reader.

So maybe it makes sense to group these definitions (they are all the same 
size):

        /* These are used by esp_scsi_send_pio_cmd() */
        u8 __iomem              *fifo_reg;
        int                     send_cmd_error;
        u32                     send_cmd_residual;

> However, the function declaration really is a worry, as the actual 
> function body only exists when the config option is enabled. So either 
> add a dummy function or surround the function declaration by 
> CONFIG_ESP_PIO.
> Otherwise I think Dan Carpenter and the likes are guaranteed to send you 
> a nice mail complaining about this ...
> 

Do static checkers really complain about this? I think the validity of an 
extern can't be known until the final linkage is done.

At that point the checker may complain that no compilation unit references 
a symbol in a header.

But this would lead to false positives where a header file is shared by 
separate programs which share library code but not macros.

-- 

> Cheers,
> 
> Hannes
> 
