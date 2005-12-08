From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [ACPI] Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Thu, 08 Dec 2005 09:14:30 -0500
Message-ID: <43983FC6.6050108@pobox.com>
References: <20051208030242.GA19923@srcf.ucam.org>	 <20051208091542.GA9538@infradead.org>	 <20051208132657.GA21529@srcf.ucam.org>	 <20051208133308.GA13267@infradead.org>	 <20051208133945.GA21633@srcf.ucam.org>	 <20051208135225.GA13122@havoc.gtf.org> <1134050863.17102.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1134050863.17102.5.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Christoph Hellwig <hch@infradead.org>, randy_d_dunlap@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

Alan Cox wrote:
> On Iau, 2005-12-08 at 08:52 -0500, Jeff Garzik wrote:
> 
>>On Thu, Dec 08, 2005 at 01:39:45PM +0000, Matthew Garrett wrote:
>>
>>>On Thu, Dec 08, 2005 at 01:33:08PM +0000, Christoph Hellwig wrote:
>>>
>>>
>>>>Don't do it at all.  We don't need to fuck up every layer and driver for
>>>>intels braindamage.
>>>
>>>Doing SATA suspend/resume properly on x86 depends on knowing the ACPI 
>>>object that corresponds to a host or target.
>>
>>Not true.
> 
> 
> 
> Actually he is right. You have to know the ACPI object in order to run
> the _GTM/_STM etc functions. If you don't run those your suspend/resume

These are only for PATA.  We don't care about _GTM/_STM on SATA.

Further, SATA completely resets and re-initializes the device as if from 
a hardware reset (except on ata_piix, which doesn't support COMRESET, 
and PATA).  This makes _GTF uninteresting, as well.


> may not work, may corrupt and so on. The only safe alternative is to
> disable acpi which, while it would have been a good idea before the spec
> ever got out, is a bit late now.

suspend/resume works just fine with Jens' out-of-tree patch.


> If you don't run the resume methods your disk subsystem status after a
> resume is simply undefined and unsafe.

I initialize the hardware to a defined state.

	Jeff


