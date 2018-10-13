From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 5/6] esp_scsi: De-duplicate PIO routines
Date: Sat, 13 Oct 2018 18:22:18 +1100 (AEDT)
Message-ID: <alpine.LNX.2.21.1810131817540.375@nippy.intranet>
References: <cover.1539391876.git.fthain@telegraphics.com.au> <09d3a141dc16af63921f5414263069e9b4f97222.1539391876.git.fthain@telegraphics.com.au> <20181013070508.GA15008@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181013070508.GA15008@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 13 Oct 2018, Christoph Hellwig wrote:

> > +#if IS_ENABLED(CONFIG_SCSI_MAC_ESP) || IS_ENABLED(CONFIG_SCSI_ZORRO_ESP)
> 
> Please add a new CONFIG_SCSI_ESP_PIO symbol that is selected by
> the mac and zorro drivers instead.
> 

OK.

> > +	pr_err("FIFO is empty (sreg %02x)\n", esp_read8(ESP_STATUS));
> 
> This should probably use dev_err (at least with my series).
> 

How about shost_printk()? That would be consistent with the rest of 
esp_scsi.c. It also means my series need not depend on yours which would 
complicate things.

-- 
