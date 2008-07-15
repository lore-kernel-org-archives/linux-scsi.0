From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: bidi support: FC transport layer...
Date: Tue, 15 Jul 2008 11:54:33 -0700
Message-ID: <C9F1A1B1-136B-4EE0-8F64-8EE5DF04E5B6@qlogic.com>
References: <E11DE615-512A-45C0-9308-036BDA225E9D@qlogic.com> <D1D4C3FF75F9354393DB8314DF43DEF2E7EE27@xbl3.ma.emulex.com> <77DD6D0A-346F-4797-B05D-C3C24EAD290E@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v924)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:55138 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972AbYGOSyg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jul 2008 14:54:36 -0400
In-Reply-To: <77DD6D0A-346F-4797-B05D-C3C24EAD290E@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>


On Jul 10, 2008, at 1:28 PM, Seokmann Ju wrote:

>
> On Jul 10, 2008, at 9:10 AM, James.Smart@Emulex.Com wrote:
>> ...
>> We have a few hurdles to cross to get there though:
>> - We're going to create an sgio object - is the object 1:1 with
>> sysfs/device objects ?
>> or do we allow the adapter/port to be the base object and we then  
>> pass
>> addressing
>> information in the request control area.  I lean toward the latter,  
>> as
>> there may
>> be things on the fabric the adapter/port does not want or does not
>> know about, to
>> present to the OS. However, I know James is in the other camp -  
>> always
>> have a node
>> so that the addressing is implicit in the node being talked to. But,
>> in order to
>> do this for things that may not already be enumerated, we have to
>> build in a
>> funky "temporarily create object X" interface so you can then talk to
>> it, then
>> tear it down.
> I see...
> I'm also more toward latter from my gut feeling.
> And, it should also be great to know further details about the  
> alternative
> approach, too.
 From the code walk-through, for the SAS SMP case, the transport layer  
create
a file under sysfs per each device detection, which is former case.
Could you elaborate why we have to "temporarily create object X and  
destroy"?

In general, I've been walking through the code to figure out overall  
design
and implementation details about SAS SMP handling.
1. when each of target device detected, a request_queue for the device
  allocated/associated to it.
2. each of device gets device file under sysfs and the device file is
  used to send SMP via bsg and the packets get serviced in the nature of
  bidi.

I also think it should be safe to implement FC-CT/ELS support in the
manner similar to the SAS SMP.
Please let me know for any other missing pieces.


>>
>> - We have to figure out a way to address asynchronous reception. It's
>> easy to do
>> the request side via BIDI, but how about an ELS/CT request to the  
>> port
>> ? where
>> do we get the buffers ? is it DMA-based ? is there multiple buffer
>> pools and
>> a traffic classification policy ? how do we associate traffic to the
>> right
>> user entity ? and so on.
> I see...
> Regarding the traffic association, a similar approach that I only  
> know of is: AEN (Asynchronous Event Notification) on the Solaris.
> It is kind of registration being done by each of the application  
> upon loading so that the AEN queue, later on, could identify the one  
> among the registered when actual AEN happens.
>
>>
>>
>> - Will the ideas of "abusing" the SGIO SCSI request work for  
>> generic FC
>> traffic.
>> I believe we've got the primitives right when we could actually
>> support FCP
>> traffic through this raw interface.
>>
>> - This will all need to be clean integrated into the transport, and  
>> we
>> have
>> to consider the open-FCOE stack as well.
> OK. Thanks.
>
>
> In general, I haven't got clear picture of what to do and trying to  
> grab as much as possible.
> I will get back to you with some more questions.
>
> Seokmann
>>
>>
>> -- james s
>>
>>
>>> -----Original Message-----
>>> From: linux-scsi-owner@vger.kernel.org
>>> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Seokmann Ju
>>> Sent: Thursday, July 10, 2008 8:56 AM
>>> To: linux-scsi@vger.kernel.org
>>> Cc: Andrew Vasquez
>>> Subject: bidi support: FC transport layer...
>>>
>>> Hi,
>>>
>>> With starting to implement FC-CT/ELS support on the qla2xxx
>>> module, I
>>> would like to get some idea about the bidi-bidirectional.
>>> As I understand that the bidi is packet transporting
>>> infra-structure,
>>> I think it could be good candidate for the FC specific FC-CT/ELS
>>> packet delivery in between the application and the individual
>>> devices
>>> given topology.
>>>
>>> As I have limited understanding about the bid, here are my  
>>> questions,
>>> 0. would the bidi be a right choice for the FC-CT/ELS packet  
>>> delivery?
>>> 1. where should I get any kind of documents/briefs about the bidi?
>>> 2. which part of code that I have to walk-through for further
>>> understanding about the bidi mechanism?
>>> 3. with the bidi, what's the application interface should look like?
>>>
>>> I expect to have some changes/additions in the FC transport layer in
>>> regards to the support and in general.
>>>
>>> Any comment/guidance would be greatly helpful.
>>>
>>> Thank you,
>>> Seokmann
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-scsi" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>

