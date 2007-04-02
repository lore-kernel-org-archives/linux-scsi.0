From: Douglas Gilbert <dougg@torque.net>
Subject: Re: SMP pass through interface via bsg
Date: Mon, 02 Apr 2007 11:47:45 -0400
Message-ID: <461125A1.8080904@torque.net>
References: <20070402110125U.fujita.tomonori@lab.ntt.co.jp> <1175486263.27675.11.camel@mulgrave.il.steeleye.com> <461108E1.9070405@emulex.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:45344 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932787AbXDBPu0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2007 11:50:26 -0400
In-Reply-To: <461108E1.9070405@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, hch@infradead.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

James Smart wrote:
> 
> 
> James Bottomley wrote:
>>> -- each SAS object (host, device, expander, etc) has the own bsg
>>> device
>>
>> I think so; probably attached via the transport class.
> 
> FYI - I understand the idea of a bsg device per object, but really, for
> something that is used rarely, it's a bunch of overhead. Objects, data
> structures, etc - more udev/kobject mgmt....  I believe I prefer the
> approach of a shared distribution point - e.g. one bsg device at the
> transport globally, or perhaps one at the host (actually the outbound
> port aka host/channel) supporting the transport - followed by headers
> in the messages that direct flow after that. This kinda follows the
> model we have today for I/O - w/ queuecommand for the host, and
> addressing in the SCSI command.

James,
I fully agree.

> Additionally, I've always had some concern that we had to create an
> object for everything in the SAN (every phy!), and have that view
> replicated
> per host (for multi-initiator/multi-path SANs). I always believed there
> was some sets of things that you would want to talk to that just doesn't
> justify a new object (for example - do we start talking to process
> associators
> in FC ?).  Another reason to move toward a transport-specific addressing
> header.

Yes, seldom used things like well known logical units
and virtual SMP targets (there is one on every MPT Fusion
SAS LBA) that don't make the cut in the "devices for everything"
model become invisible to Linux users. It is exactly these
type of things that specialized user space programs use
a pass-through interface for.

So if the kernel can't find a use for it, then you, the
owner of the hardware, won't be able to use it either.
Hard to describe that approach as open software.

> My other concern with using bsg and the i/o path for transport management
> functions is they compete with i/o for things like the can_queue values.
> Should they ? Should they have higher priority ?

sg v4 adds priority control mechanisms but there still
remains possibilities for conflict, some of which may
cause problems.

I can see that a state based driver like st may want
to stop a pass-through getting to a logical unit most
of the time (and mechanisms could be added). However
even st may want to use a pass through to the transport
to reset the target ("hard reset") if it can't get the
LU RESET task management function to work.

>> I'd really rather not go this route unless the one device per object
>> approach becomes untenable.
> 
> Understood, but building things until they topple is not a great idea
> as there will be back-ward compatibility issues w/ user-space/sysfs and
> the tools built around it. If you start with the shared distribution
> point, you can always support both (eventually) if its a good idea.
> Harder to do that in the reverse if it's toppling.

We are talking about the SAS Management Protocol (SMP)
in this thread and in SAS-1 and SAS-1.1 discovery is done
by every SAS initiator, for every ripple in the topology.
In large topologies this approach can cause a "SMP storm"
that can temporarily drop SAS bandwidth to SCSI-1 figures.
Today discovery is done in the LLD or firmware (Adaptec and
LSI respectively) so they can magically make devices appear.
The approach in SAS-2 is to devolve SAS discovery to
expanders and use more efficient SMP functions. Current
generation SAS HBAs (and some LLDs) will need to alter
or stop their current SAS discovery techniques. The
user space may need to get involved, for zoning and
associated security.

Only allowing the SMP pass-through to talk to devices
that the kernel thinks are SAS expanders has some
shortcomings:
  - how can user space SAS topology discovery be done?
  - what about SMP targets that are not on expanders
  - disabling the phy that connects an expander
    to the SAS domain is problematic when the
    file descriptor you are using notionally represents
    that expander.


Note: discovery of a SAS topology is a different process from
finding logical units within SCSI targets. In the context of
SAS, the latter process can stay in the kernel and can be
done for each SSP target found, preferably after the SAS
topology has been fully discovered.

>>> The patch adds a hook into sas transport class. sas_host_setup calls
>>> bsg_register_queue. Then, the request_fn calls smp_execute_task to
>>> send a smp request and get the response. It doesn't look good to link
>>> the sas transport class with libsas. In addition, the mpt driver
>>> handles smp request/response in a very different way.
>>>
>>> Any suggestion to bind SMP pass through via bsg to aic94xx and mpt
>>> cleanly?
>>
>> bind in the transport class, not the driver ...
> 
> Agree - the trick for libsas is to get an interface into the driver that
> both drivers can support.

For LSI MPT Fusion it should be almost trivial to
map the <host,phy_id,sas_address> (Tomo's "hacky" approach")
through to LSI's ioc_num and SMP pass-through structures.

The aic94xx must have a similar structure. How else could
it implement a SMP pass-through for its own use :-)

Doug Gilbert


