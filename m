From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: DMA mapping on SCSI device?
Date: Tue, 29 Jan 2008 20:00:50 -0600
Message-ID: <479FDA52.8050204@shaw.ca>
References: <896139.88121.qm@web31812.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:63255 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbYA3CBb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jan 2008 21:01:31 -0500
In-reply-to: <896139.88121.qm@web31812.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: linux-arch@vger.kernel.org, ide <linux-ide@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Luben Tuikov wrote:
> --- On Mon, 1/28/08, Robert Hancock <hancockr@shaw.ca> wrote:
>> The trick is that if an ATAPI device is connected, we (as
>> far as I'm 
>> aware) can't use ADMA mode, so we have to switch that
>> port into legacy 
>> mode.
> 
> Can you double check this with the HW architect of the
> HW DMA engine of the ASIC?

Will do so. However, previous statements from NVIDIA fairly clearly 
indicate that this is the case.

> 
>> This means it's only capable of 32-bit DMA.
>> However the other port 
>> on the controller may be connected to a hard drive and
>> therefore still 
>> capable of 64-bit DMA.
> 
> If this is indeed the case as you've presented it here,
> it sounds like a HW shortcoming.  I cannot see how the device
> type (or protocol) dictate how the DMA engine operates.
> They live in two different domains.

Well, there is an indirect link. The ADMA interface (which supports 
64-bit DMA) cannot be used to issue ATAPI commands, so if an ATAPI 
device is connected we have to go to legacy mode, which supports only 
32-bit DMA.

I'm not sure why ADMA mode doesn't support ATAPI. The only reason I can 
think of is that there's issues since ATAPI commands can potentially be 
of unpredictable transfer size. The "real" ADMA spec that the NVIDIA 
implementation is loosely based on does have some special "ignore 
excess" controls that don't seem to be in the NVIDIA version (or at 
least not to the knowledge I have on this hardware).

And yes, it is a rather unfortunate hardware shortcoming (presuming that 
it is entirely true).

> 
>> The ideal solution would be to do mapping against a
>> different struct 
>> device for each port, so that we could maintain the proper
>> DMA mask for 
>> each of them at all times. However I'm not sure if
>> that's possible. The 
>> thought of using the SCSI struct device for DMA mapping was
>> brought up 
>> at one point.. any thoughts on that?
> 
> The reason for this is that the object that a struct scsi_dev
> represents has nothing to do with HW DMA engines.
> 
> It looks like your current solution is correct and
> x86_64's blk_queue_bounce_limit needs work.
> 
>     Luben
> 
> 
