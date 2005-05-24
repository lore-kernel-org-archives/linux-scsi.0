From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Tue, 24 May 2005 13:29:27 -0400
Message-ID: <42936477.6020307@pobox.com>
References: <20050523201535.GA24298@havoc.gtf.org> <1116880875.5021.34.camel@mulgrave> <20050523204516.GA28058@havoc.gtf.org> <1116886206.5021.42.camel@mulgrave> <20050524062128.GT9855@suse.de> <4292CF5D.90809@pobox.com> <429330A4.6080005@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <429330A4.6080005@adaptec.com>
Sender: linux-ide-owner@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Luben Tuikov wrote:
> On 05/24/05 02:53, Jeff Garzik wrote:
> 
>>You are right about issuing the standby command after flush.  I don't 
>>think an LLD hook is the proper way to accomplish it, however.
>>
>>The SCSI layer needs to issue the START STOP UNIT command in response to 
>>a suspend event, and libata-scsi will (per SAT spec) translate that into 
>>the ATA standby command.  Merely following the relevant SCSI+SAT+ATA 
>>standards gets us there.
> 
> 
> An SSU command may not be viable as the device may be shared
> on the domain (i.e. accessed by another initiator).

Yes.  Don't worry, both James and I are quite aware of this.


>>* Bus PM.  This is best handled by the transport class driver (need to 
>>write for SATA and SAS).
> 
> 
> This is tricky.  Kudos to Doug's answer.  One thing to remember is that
> this is intricately entangled with host PM.  That is, if a device
> is unplugged from the domain -- would one want to computer to come
> out of its current power saving mode?  Probably not.

In general, in a class-based system, one can easily see a situation 
where a host driver would provide "adaptec_sas_transport" class, which 
does a few host-specific things, then falls back to a generic 
"sas_transport" class.

That is how to do host-specific stuff, with transport classes.

However, with regards to your specific example:  to come out of 
power-saving mode based on a certain event, the motherboard needs 
special circuitry.  Example of this is wake-on-LAN or wake-on-serial.


>>* Host PM.  This is handled in the obvious manner, using existing PM 
>>driver hooks.  PCI D0/D3, etc.
> 
> 
> Then D3->D0 would be equivalent to reinintialization of the PCI device,

yes


> doing domain discovery as usual, etc.

Eventually, yes.  At the moment, suspend is rather dumb, and things 
mostly assume that the devices present at suspend will be present at resume.


>>I can describe how this will look when libata is divorced from SCSI, if 
>>you would like, too...
> 
> 
> Please Jeff.
> 
> A concern is SATA devices behind SAS HAs (host adapters).  A straightforward
> translation provided by libata would be a goal.

No need for translation.  The LLD driver would either use the high level 
libata interface (for SATA devices), or use the high level SCSI 
interface (for SAS devices).

Even though libata doesn't have an explicit notion of transport classes 
(it _is_ a transport class, really), this is doable today.

	Jeff


