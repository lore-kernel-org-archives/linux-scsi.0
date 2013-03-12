From: Aaron Lu <aaron.lwe@gmail.com>
Subject: Re: STANDBY IMMEDIATE failed on NVIDIA MCP5x controllers when system
 suspend
Date: Tue, 12 Mar 2013 21:46:47 +0800
Message-ID: <513F31C7.7080201@gmail.com>
References: <Pine.LNX.4.44L0.1303111053060.2246-100000@iolanthe.rowland.org>  <513E98A7.3040307@intel.com> <1363090248.2401.42.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1363090248.2401.42.camel@dabdike.int.hansenpartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lu@intel.com>, bladud@gmail.com, Joe Sapp <nixphoeni+kernel@gmail.com>, Alberto Mattea <support.intranet@libero.it>, Peter Dons Tychsen <donpedro@tdcadsl.dk>, Robert Hancock <hancockrwd@gmail.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 03/12/2013 08:10 PM, James Bottomley wrote:
> On Tue, 2013-03-12 at 10:53 +0800, Aaron Lu wrote:
>> Hi James and Alan,
>>
>> On 03/11/2013 11:00 PM, Alan Stern wrote:
>>> On Mon, 11 Mar 2013, James Bottomley wrote:
>>>
>>>> Oh, that seems to be the suspend order isn't careful enough.
>>>> __device_suspend() waits for its children, but the host disk are too far
>>>> separated in the device tree.  If the immediate children of the host are
>>>> all sync, that wait never actually waits for anything.
>>>
>>> I was going to make exactly this same point.  During async suspend, the
>>> PM core is careful to make sure that no device is suspended before its
>>> children.  But there aren't any other checks, so if device A isn't an
>>> ancestor of device B then it's possible for async suspend to power down
>>> A before B.  This can cause problems if B needs A to be active while B
>>> is suspending.
>>
>> Thanks for the suggestions.
>>
>>>
>>> Does the ATA system have any non-ancestor dependencies like this?  If
>>> it does, the appropriate driver can be fixed to take them into account.
>>
>> I don't think there is, and the relationship is like this:
>>
>>      ata_host_controller* (named sata_nv xxx)
>> 	    |
>> 	ata_port* (named atax, while "ata_port atax" is another device)
>> 	/	\
>> scsi_host	ata_link
>>      |		   |
>> scsi_target	ata_device
>>      |
>> scsi_device* (named sd x:x:x:x)
>>
>> With the devices that have actual PM operation functions defined have
>> the asterisk next to it.
>>
>> So ata_host_controller waits for all of the ata_ports, and the ata_port
>> waits for both scsi_host and ata_link. scsi_host waits for scsi_target,
>> and scsi_target waits for scsi_device. So if scsi_device is not done,
>> ata_port will not start. Doesn't look like a problem to me.
>>
>> And from the log:
>> https://bugzilla.kernel.org/attachment.cgi?id=95101
>> It also looks like the order is correct.
>
> That's not what that log appears to say.  Here are the relevant bits
>
> [ 7377.813634] sd 2:0:0:0: async_suspend: scheduled
> [ 7377.813636] sd 2:0:0:0: __device_suspend: starts
> [ 7377.813639] sd 2:0:0:0: [sdb] Synchronizing SCSI cache
> ... so now we've begun suspend]
> [ 7377.813750] sd 2:0:0:0: [sdb] Stopping disk
> [... here we send STANDBY IMMEDIATE ]
> [ 7378.237627] sata_nv 0000:00:05.2: async_suspend: scheduled
> [ 7378.237631] sata_nv 0000:00:05.2: __device_suspend: starts
> [... we begin to shut down the host ]
> [ 7378.249333] sata_nv 0000:00:05.2: __device_suspend: done
> [... host shutdown complete ]

I think sata_nv 0000:00:05.0 is the host controller for sd 2:0:0:0, and
sata_nv 0000:00:05.1 is the host controller for sd 4:0:0:0. I've asked
bladud@gmail.com to attach the full dmesg, which can make it easier for
us to decide which port belongs to which host controller. Note that this
system has multiple ata host controllers.

Thanks,
Aaron

> [ 7408.372642] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> [ 7408.372647] ata3.00: failed command: STANDBY IMMEDIATE
> [ ... command times out ]
> [ 7408.870675] dpm_run_callback(): scsi_bus_suspend+0x0/0x20 [scsi_mod] returns 134217730
> [ 7408.870681] sd 2:0:0:0: __device_suspend: done
>
> We shut down the host controller before the command completed.  This
> appears to cause the timeout
>
> James
>
>

