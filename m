From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Adaptec SAS integration notes
Date: Sat, 15 Oct 2005 18:01:05 +0200
Message-ID: <435127C1.3060600@s5r6.in-berlin.de>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7AED@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:54435 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1750876AbVJOQC7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Oct 2005 12:02:59 -0400
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7AED@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Smart@Emulex.Com, ltuikov@yahoo.com, jgarzik@pobox.com, andmike@us.ibm.com, luben_tuikov@adaptec.com, James.Bottomley@steeleye.com, hch@infradead.org, linux-ide@vger.kernel.org

James.Smart@Emulex.Com wrote:
> Luben,
[Jeff Garzik wrote]
>>> * Adaptec SAS abuses Scsi_Host_Template.  The host template 
>>> is a set of ops for various layers, and it is fine as an
>>> interface.  No need to avoid it.

The scsi_host_template is a set of ops for (and interface between) 
exactly two layers. What is the abuse?

>>Neither the Host Adapter, nor the FW, implements anything which has
>>to do with the scsi host template.  What the Host Adapter 
>>(the hardware) and
>>the FW implement is access to the transport -- that' all.
>>
>>So in effect the LLDD is _access to the (SAS) transport_. Cf. 
>>the USB Storage code and SBP code.
>>
>>Putting the host template back into the LLDD is a step 
>>_backwards_, i.e. it's just a workaround, not a step forward.
> 
> This statement absolutely amazes me....
> 
> Your first comment "Host Adapter, nor the FW ..." is true of every
> adapter.
> 
> The job of a Device Driver is to map between the interface presented
> by the Host Adapter/FW and the interfaces of the host os. This is true
> of whatever the technology is - SCSI, Ethernet, rs232, whatever.
> 
> As the current design of the scsi subsystem has SCSI-hba's attaching
> via the host template - of course the LLDD will contain the host
> template.

The current SCSI subsystem has "low level drivers" attaching via the 
scsi_host_template ("low level" from the perspective of the SCSI 
subsystem). The SCSI low level drivers
     (1)  provide access to a transport
and either
     (2a) drive interconnect hardware
or
     (2b) rely on another driver or entire subsystem which provides
          access to the interconnect.
In addition, it may
     (3)  expose means to manage the transport and/or interconnect
          infrastructure.

The scsi_host_template only fulfills a role between the SCSI subsystem's 
core driver and function (1) of the SCSI low level driver. As far as I 
can tell, the scsi_host_template is irrelevant to any interface used for 
(2b).

In http://marc.theaimsgroup.com/?l=linux-scsi&m=112629423714248 , Luben 
used the following terms:
| The infrastructure is broken into
| 	* SAS LLDD,
| 	* SAS Layer.

The SAS LLDD is not the SCSI low level driver. The SAS Layer is the SCSI 
low level driver.

Similarly, usbcore and ieee1394 (together with [eou]hci_hcd, ohci1394, 
pcilynx) are not SCSI low level drivers. Usb-storage and sbp2 are SCSI 
low level drivers.

Whenever "LLDDs" are discussed, it should be clarified whether SCSI 
LLDDs (like the SAS Layer) or other LLDDs (like the SAS LLDD) are meant, 
if not apparent from context.

> - of course the LLDD will contain the host template.

Yes, a SCSI LLDD does contain it. A driver of interconnect hardware does 
not necessarily contain it.
-- 
Stefan Richter
-=====-=-=-= =-=- -====
http://arcgraph.de/sr/
