From: Doug Ledford <dledford@redhat.com>
Subject: Re: Problem with aacraid driver in 2.5.63-bk-latest
Date: Thu, 13 Mar 2003 18:27:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E7113E5.2090200@redhat.com>
References: <20030228133037.GB7473@jiffies.dk>	 <1047510381.12193.28.camel@markh1.pdx.osdl.net>	 <1047514681.23725.35.camel@irongate.swansea.linux.org.uk>	 <3E6FC8D6.7090005@torque.net> <1047517604.23902.39.camel@irongate.swansea.linux.org.uk> <3E6FDF61.8060708@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E6FDF61.8060708@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Mark Haverkamp <markh@osdl.org>, Christoffer Hall-Frederiksen <hall@jiffies.dk>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux aacraid devel <linux-aacraid-devel@dell.com>

Douglas Gilbert wrote:
> Alan Cox wrote:
> 
>> On Wed, 2003-03-12 at 23:55, Douglas Gilbert wrote:
>>
>>>         /*
>>>          * Limit max queue depth on a single lun to 256 for now.  
>>> Remember,
>>>          * we allocate a struct scsi_command for each of these and 
>>> keep it
>>>          * around forever.  Too deep of a depth just wastes memory.
>>>          */
>>>         if(tags > 256)
>>>                 return;
>>> ....
>>
>>
>>
>> I can see the memory consideration. However the thing can really 
>> handle big
>> queues well. Possibly we should be setting the queue to 512 / 
>> somefunction(volumes)
>> though to avoid the worst case overcommit here
> 
> 
> The situation is different between 2.4 and 2.5 ...
> 
> In 2.4 the per device queue_depth is an unsigned char
> and that number of scsi_cmnd instances are pre-allocated
> in the scsi_build_commandblocks() function. So the worst
> case number of scsi_cmnd instances for all scsi devices
> is always available (at the expense of [wasted] ram).

Correct.

> In 2.5 queue_depth is an unsigned short and a slab
> allocator called "scsi_cmd_cache" is used as required.
> There is some throttle logic (or at least it has been
> talked about) to make sure one scsi_cmnd instance per
> scsi device will always be available.

Not throttle logic, we simply have a struct list_head that we stick one 
command (per host) onto and should it ever need to be used, then in 
scsi_done() when we would normally free a command we are done with we 
instead stick it back on that list head.  That way, memory pressure 
can't kill us, just slow us down.

> I think that comment (probably by Doug Ledford) refers
> to the 2.5 series before the slab allocator was
> introduced.

Yep.


-- 
   Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
          Red Hat, Inc.
          1801 Varsity Dr.
          Raleigh, NC 27606


