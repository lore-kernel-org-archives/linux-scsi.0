From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] current scsi-misc-2.5 scsi_lib.c needs init.h
Date: Thu, 5 Dec 2002 14:54:41 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021205145441.A10578@beaverton.ibm.com>
References: <patmans@us.ibm.com> <200212052226.gB5MQjf05474@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200212052226.gB5MQjf05474@localhost.localdomain>; from James.Bottomley@SteelEye.com on Thu, Dec 05, 2002 at 04:26:45PM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Thu, Dec 05, 2002 at 04:26:45PM -0600, James Bottomley wrote:
> patmans@us.ibm.com said:
> > he current scsi-misc-2.5 scsi_lib.c needs to include init.h to get the
> > __init and __exit defined. 
> 
> not for me here.  init.h seems to be pulled in via a long chain:
> 
>                  from include/linux/profile.h:8,
>                  from include/asm/hw_irq.h:16,
>                  from include/linux/irq.h:69,
>                  from include/asm/hardirq.h:6,
>                  from include/linux/interrupt.h:9,
>                  from include/asm/highmem.h:24,
>                  from include/linux/highmem.h:12,
>                  from include/linux/bio.h:24,
>                  from drivers/scsi/scsi_lib.c:10:
> 
> James

James -

It looks like CONFIG_HIGHEM changes that behaviour, my .config has:

CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set

highmem.h does not include asm/highmem.h unless #ifdef CONFIG_HIGHMEM.

I changed my config to use highmem 4g, and it compiled OK.

-- Patrick Mansfield
