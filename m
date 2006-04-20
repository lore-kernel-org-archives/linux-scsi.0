From: "erich" <erich@areca.com.tw>
Subject: Re: areca RAID driver
Date: Thu, 20 Apr 2006 12:39:16 +0800
Message-ID: <009b01c66434$632f0260$b100a8c0@erich2003>
References: <20060419155300.321c352e.akpm@osdl.org> <20060420030425.GN24104@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 220-130-178-142.HINET-IP.hinet.net ([220.130.178.142]:63412
	"EHLO areca.com.tw") by vger.kernel.org with ESMTP id S1751265AbWDTEjQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Apr 2006 00:39:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "\"James Bottomley\"" <James.Bottomley@steeleye.com>, "\"Christoph Hellwig\"" <hch@lst.de>, "\"Jens Axboe\"" <axboe@suse.de>, billion.wu@areca.com.tw, linux-scsi@vger.kernel.org

Dear Matthew Wilcox,

I will follow your instruction to do another patch for Linux kernel tree.
At 2006/4/3 my mother unexpectedly got paralysis and dead.
I need to deal with my mother's funeral ceremony.
And I will back to my Lab. at 2006/4/25.
I will do it as soon as possible when I enter my Lab. again.

Best Regards
Erich Chen
----- Original Message ----- 
From: "Matthew Wilcox" <matthew@wil.cx>
To: "Andrew Morton" <akpm@osdl.org>
Cc: "James Bottomley" <James.Bottomley@steeleye.com>; "Christoph Hellwig" 
<hch@lst.de>; "Jens Axboe" <axboe@suse.de>; "erich" <erich@areca.com.tw>; 
<billion.wu@areca.com.tw>; <linux-scsi@vger.kernel.org>
Sent: Thursday, April 20, 2006 11:04 AM
Subject: Re: areca RAID driver


> On Wed, Apr 19, 2006 at 03:53:00PM -0700, Andrew Morton wrote:
>>
>> Gents, Erich thinks that the Areca driver is pretty much ready to go.
>>
>> We still have the weird read-past-EOF problem if MAX_XFER_SECTORS=4096, 
>> but
>> this version of the driver has it set to 512, which makes the problem go
>> away.  I've suggested that we can set that problem aside for now.
>>
>> I've put a copy of the latest diff at
>> http://www.zip.com.au/~akpm/linux/patches/stuff/areca-raid-linux-scsi-driver.patch.
>>  Could you please take a look sometime, decide how we should proceed?
>
> 1.
>
> +static int arcmsr_initialize(struct AdapterControlBlock *pACB, struct 
> pci_dev *pdev)
> [...]
> +       pci_read_config_byte(pdev, PCI_COMMAND, &pcicmd);
> +       pci_write_config_byte(pdev, PCI_COMMAND,
> +               pcicmd | PCI_COMMAND_INVALIDATE | PCI_COMMAND_MASTER | 
> PCI_COMMAND_MEMORY);
>
> It's already calling pci_enable_device() and pci_set_master().  To set
> PCI_COMMAND_INVALIDATE, it should also be calling pci_set_mwi().
>
> 2. arcmsr_attr_host_pci_info() is just weird.  I can't imagine why
> anyone would need that information -- you can get it all from sysfs
> already.
>
> 3. arcmsr_transport_functions are declared extern ... and never used.
>
> 4. There's a *lot* of unnecessarily long lines.  Often in documentation,
> even!
> +**             on the internal bus. Some time later, a PCI master 
> attempts a Memory Read with the same address
>
> 5. The other sysfs files don't exactly conform to 'one value per file'
> either.
>
> 6. It seems weird to split the driver into three files -- one with the
> sysfs attributes in it, one with everything else, and a header file.
> I don't see why it shouldn't *all* be in drivers/scsi/arcmsr.c
>
> 7. The 'linux bug' workaround in queue_command looks decidedly dodgy to
> me, but I'd like someone more experienced to comment on it. 

