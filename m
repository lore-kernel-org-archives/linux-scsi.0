From: Doug Ledford <dledford@redhat.com>
Subject: Re: Q: relationship between can_queue and cmd_per_lun?
Date: Fri, 21 Jun 2002 15:55:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020621155505.A9642@redhat.com>
References: <3D138128.C25C70D5@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3D138128.C25C70D5@splentec.com>; from luben@splentec.com on Fri, Jun 21, 2002 at 03:40:24PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Jun 21, 2002 at 03:40:24PM -0400, Luben Tuikov wrote:
> Is there any relationship between Scsi_Host::can_queue
> and Scsi_Host::cmd_per_lun?

Not really.  The can_queue variable is the hard limit for the number of 
commands a host can have outstanding.  It is not related to the per drive 
limits in any way.  The purpose of it is for cases like my driver where I 
have a host wide limit of 255 commands.  However, I could theoretically 
allow up to 255 commands per device as well.  So, even if I am allowing a 
much more sane 32 commands per drive, it only takes 8 drives before the 
total number of commands that *could* be queued to all the drives 
simultaneously would exceed my cards total command limit.  So, the 
can_queue variable is just there to keep us from exceeding the cards upper 
limit on total outstanding commands across all devices.  The cmd_per_lun 
variable actually only plays a part for untagged devices.  It specifies 
the number of untagged commands that can be held in the low level driver 
for a specific device.  Since untagged commands may only have one command 
active on the bus at any given point in time, setting this to anything 
higher than 1 actually requires that the low level driver be ready to 
queue up the additional commands and hold them in some backlog queue until 
the active command completes.  The reason we even bother with this is for 
tape drives or cd burners that need to stream data and can't tolerate any 
delays in the data processing.  If you don't enable this, then when the 
current command completes and your card gets an interrupt, then you have 
to complete that command all the way up to the scsi mid layer and then the 
mid layer will queue you the next command for the device.  That introduces 
a certain amount of latency.  On the other hand, by getting a second and 
third command while the first is still operating, my driver is able to do 
all the setup work for those two commands ahead of time and them simply 
put them on a queue.  When I get an interrupt telling me the first command 
is complete, I can immediately start the next command from the interrupt 
handler.  Latency is damn near 0 in that situation and it helps to make 
sure that tape drives and cd burners get their streaming data well before 
their buffers run empty.  For tagged queue devices, the SDpnt->queue_depth 
is how we actually track how many commands are allowed on that device.  
So, basically it boils down to this:

can_queue -> host wide number of commands limit
cmd_per_lun -> number of commands to queue on untagged devices
queue_depth -> number of commands to queue on tagged devices

> Given that there is only one device (one target
> with a signle LUN) on a Scsi_Host, then what would
> be the sense of can_queue=255 and cmd_per_lun=1?
> (other than calling queuecommand() vs the older if.)

They represent two different limits, so they don't need to make sense in 
regards to each other.

> If there's a relationship, according to my understanding,
> can_queue = LUN present * targets present * cmd_per_lun,
> or the more general:
> can_queue = \sum_Targets{\sum_Target_LUNS{cmd_per_This_LUN}}.

Nope, but explained above.

> Also is there any way of finding the tagged queue depth,
> other than tracking TASK SET FULL status code?

Not really.  Just flood a device with commands until it returns QUEUE_FULL 
then see how many commands it took before returning that status.  Do it a 
bunch of times and if it always comes back at the same depth, then you 
have a hard limit.  There are a lot of drives out there that don't have a 
hard limit and will return QUEUE_FULL status at varying queue depths based 
upon resource allocations on the drive's controller.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
