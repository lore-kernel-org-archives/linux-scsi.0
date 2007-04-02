From: James Smart <James.Smart@Emulex.Com>
Subject: Re: SMP pass through interface via bsg
Date: Mon, 02 Apr 2007 09:45:05 -0400
Message-ID: <461108E1.9070405@emulex.com>
References: <20070402110125U.fujita.tomonori@lab.ntt.co.jp> <1175486263.27675.11.camel@mulgrave.il.steeleye.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:36571 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965451AbXDBNp2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2007 09:45:28 -0400
In-Reply-To: <1175486263.27675.11.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, hch@infradead.org, dougg@torque.net, jens.axboe@oracle.com, linux-scsi@vger.kernel.org



James Bottomley wrote:
>> -- each SAS object (host, device, expander, etc) has the own bsg
>> device
> 
> I think so; probably attached via the transport class.

FYI - I understand the idea of a bsg device per object, but really, for
something that is used rarely, it's a bunch of overhead. Objects, data
structures, etc - more udev/kobject mgmt....  I believe I prefer the
approach of a shared distribution point - e.g. one bsg device at the
transport globally, or perhaps one at the host (actually the outbound
port aka host/channel) supporting the transport - followed by headers
in the messages that direct flow after that. This kinda follows the
model we have today for I/O - w/ queuecommand for the host, and
addressing in the SCSI command.

Additionally, I've always had some concern that we had to create an
object for everything in the SAN (every phy!), and have that view replicated
per host (for multi-initiator/multi-path SANs). I always believed there
was some sets of things that you would want to talk to that just doesn't
justify a new object (for example - do we start talking to process associators
in FC ?).  Another reason to move toward a transport-specific addressing
header.

My other concern with using bsg and the i/o path for transport management
functions is they compete with i/o for things like the can_queue values.
Should they ? Should they have higher priority ?

> I'd really rather not go this route unless the one device per object
> approach becomes untenable.

Understood, but building things until they topple is not a great idea
as there will be back-ward compatibility issues w/ user-space/sysfs and
the tools built around it. If you start with the shared distribution
point, you can always support both (eventually) if its a good idea.
Harder to do that in the reverse if it's toppling.

>> The patch adds a hook into sas transport class. sas_host_setup calls
>> bsg_register_queue. Then, the request_fn calls smp_execute_task to
>> send a smp request and get the response. It doesn't look good to link
>> the sas transport class with libsas. In addition, the mpt driver
>> handles smp request/response in a very different way.
>>
>> Any suggestion to bind SMP pass through via bsg to aic94xx and mpt
>> cleanly?
> 
> bind in the transport class, not the driver ...

Agree - the trick for libsas is to get an interface into the driver that
both drivers can support.

-- james s
