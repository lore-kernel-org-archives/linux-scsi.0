From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] fc transport: Add support for events
Date: Wed, 22 Feb 2006 12:43:43 -0500
Message-ID: <43FCA2CF.6080903@emulex.com>
References: <43FC8CB4.2000507@emulex.com> <20060222172127.GA20137@infradead.org>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:2012 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S1422644AbWBVRnz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 12:43:55 -0500
In-Reply-To: <20060222172127.GA20137@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

It would have been nice to have had this response on the RFC.

I'm actually looking into netlink for the CT pass thru, ELS and rnid
functions.

Does it make sense to move forward with some event support - namely
the events attributes minus the kobject_uevent() stuff ?

-- james

Christoph Hellwig wrote:
> On Wed, Feb 22, 2006 at 11:09:24AM -0500, James Smart wrote:
>> The following patch adds support for hbaapi events within the FC transport.
>> It adds the following attributes to the fc_host:
>>   max_events  : sizes the internal array for the number of events that are
>>                 buffered in the transport. This value can be tuned by a
>>                 module parameter.
>>   event_cnt   : number of events pending in the buffer
>>   event       : reads an event from the buffer
>>
>> It adds the following routine for LLDD's to post events:
>>    void fc_host_event_post(struct Scsi_Host *shost,
>> 		enum fc_host_event_code event_code, u32 event_data);
>>
>> Not all hbaapi events are contained within the transport. Many events
>> correspond to elements outside the fc_host, and can be serviced by normal
>> hot-plug events, either on the fc_host, or rport. I believe I've included
>> those events that could be posted. I've also punted on anything that has 
>> more
>> than 1 32-bit word of data - which should only affect RLIR payloads, and
>> vendor-unique payloads. We will address these items once we figure out how
>> to deal with large payloads in the transport.
>>
>> In conjunction with the event infrastructure, the module uses hot plug 
>> events
>> to notify user entities about changes. For the fc_host, the only event 
>> posted
>> is a KOBJ_CHANGE event. For the rport, ONLINE/OFFLINE is posted whenever 
>> the
>> rport goes through a block, then unblock. To get to the class_device for 
>> the
>> rport, a new attribute_container function is added locate the class_device 
>> for
>> the device.
>>
>> This implementation expects the user-space hbaapi provider to deal with
>> multiple user-space readers.
>>
>> I've coordinated with Andrew Vasquez, who has sent his approval.
>>
>> The lpfc driver will be posted shortly to utilize this infrastructure.
> 
> I must admit I don't like this too much.  The natural way to send events
> to userspace would be a netlink socket, but integrating this with the
> transport class might be a bit hard.  Having named netlink sockets
> similar to named unix sockets would be nice for this..

