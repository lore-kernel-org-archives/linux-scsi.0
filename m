From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: Re: [PATCH 0/3] BusLogic: Message logging neatening
Date: Fri, 17 May 2013 14:59:25 -0600
Message-ID: <51969A2D.8080902@oracle.com>
References: <cover.1368754556.git.khalid.aziz@oracle.com>  <cover.1368765873.git.joe@perches.com> <1368821880.24376.0.camel@concerto> <1368822923.2194.95.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1368822923.2194.95.camel@joe-AO722>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/17/2013 02:35 PM, Joe Perches wrote:
> On Fri, 2013-05-17 at 14:18 -0600, Khalid Aziz wrote:
>> On Thu, 2013-05-16 at 21:58 -0700, Joe Perches wrote:
>>> If you're going through the trouble to fix this CamelCase stuff
>>> and make it work on 64 bit, how about a little more cleanup?
>>
>> Sounds good to me.
>
> btw, for the BusLogic code:
>
> There seem to be places where addresses are cast to u32.
>
> I don't know the code at all, but that could likely
> cause problems with 64 bit addresses.
>
> $ git grep "(u32)" drivers/scsi/BusLogic.c
> drivers/scsi/BusLogic.c:                ccb->dma_handle = (u32) blkp + offset;
> drivers/scsi/BusLogic.c:                fpinfo->base_addr = (u32) adapter->io_addr;
> drivers/scsi/BusLogic.c:        extmbox_req.base_mbox_addr = (u32) adapter->mbox_space_handle;
>

All of those fields indeed hold only a 32-bit address since the driver 
calls pci_set_dma_mask() with DMA mask of 32-bit and then allocates 
memory pointed to by these fields with pci_alloc_consistent(). So I 
think we are ok here.

Manipulation of all these pointers in this code is something that could 
use a cleaner rewrite at some point. The way it is done in the original 
code does not make me comfortable. I cleaned up what could be done 
without a rewrite.

--
Khalid
