From: Steven Dake <sdake@mvista.com>
Subject: A different look at block device hotswap in the Linux kernel
Date: Thu, 23 Jan 2003 13:41:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E30538F.4080507@mvista.com>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org> <200301222346.30329.oliver@neukum.name> <3E302A89.8070703@splentec.com> <200301231919.40422.oliver@neukum.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200301231919.40422.oliver@neukum.name>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Oliver and others,

In regards to hotswap, any real operating system should be _told_ that a 
block device is going to be removed from the top.  There are several 
reasons.

1) File mounts should be removed from the filesystem layer
2) files accessing block devices directly should be terminated
3) raid members using that block device should be hot removed
4) I'm sure you can think of others :)

The key is that the removal request should come from the top, not the 
bottom.  If someone is stupid enough to surprise remove a device (ie: 
unplug their USB SCSI device while the device is in use by the OS), they 
get what they deserve (I/O errors, dirty OS data, queued up requests 
which never shut down).  If they tell the OS that the device is going to 
be removed, so it may flush the device and shut down I/O to the device, 
the request should be granted on all accounts (expected removal).

The device driver should not be responsible for managing hotswap in any 
regard.  Its only purpose should be to tell the block device removal 
layer that a surprise extraction was initiated such that the block 
device removal code can ask the mid layer drivers to shut down error 
correction routines to the device and dump its pending I/O queue and 
clean up after the device.  The main advantage of this technique is 
simplicity (the LLDD's don't have to have repetative logic for each 
device driver), genericity (the block device removal code can be 
maintained in one place and be guaranteed to ensure the OS is in a 
stable state after a device is removed either surprise or expected and 
finally it solves the in-flight I/O problem by stopping new I/O to the 
device, shutting down I/O to the device, flushing the pending I/O 
queues, and killing all references in the OS of the device.

If you think about what your suggesting, your suggesting that the LLDD 
tells the scsi layer that the device is gone, that then times out errors 
and leaves the filesystem and sys_open/close file tables, and RAID 
layers in a state of disarray.  We don't want the LLDD knowing about the 
RAID system and whether it should tell the RAID layer to hot remove, do we?

I've developed code to do exactly what I have described here (surprise 
and expected extractions genericized into one file with one simple call 
from userland and a method for lower layers to indicate a surprise 
extraction if they have detected one.  I'll post as soon as I have time 
to make a patch against 2.5 .

Thanks
-steve


Oliver Neukum wrote:

>Am Donnerstag, 23. Januar 2003 18:46 schrieb Luben Tuikov:
>  
>
>>Oliver Neukum wrote:
>>    
>>
>>>Not all the world is a SAN. USB has no possibility to even try an
>>>interaction after the device is gone. We have to handle this flexibly.
>>>      
>>>
>>Thus the example in the original post.  I.e. for simple transports whose
>>portals get notified when a device is plugged off (USB), the LLDD
>>can notify SCSI Core, by setting a state variable in scsi_device.
>>In which case SCSI Core can answer with the proper TARGET error code.
>>(This was outlined before, scsi_command->online:1 ...)
>>    
>>
>
>Very well, so you agree that the SCSI layer should export to the LLDD
>a function to set devices offline?
>
>  
>
>>>In fact, if a device
>>>can vanish without a LLDD knowing about it, this is purely a problem of
>>>the SCSI layer.
>>>      
>>>
>>No, of course not.  (Think of IP.)  When a device vanishes and LLDD doesn't
>>know about it (more complicated transports), the CDB will return with
>>the proper Service Response, since the transport(s) won't be able to
>>deliver it. This will bubble up through SCSI Core and the error returned
>>will have to be the same as that of the simpler transports, as outlined
>>above.
>>    
>>
>
>Yes, sorry. To be precise, this means that the LLDD has to do nothing
>special, as it has to implement checking for a failing command anyway.
>But it's not entirely the same. If a command cannot be delivered it may or may
>not be appropriate to start error recovery. After the LLDD has told
>the SCSI layer that it has noticed a device going away, there must be no
>error recovery.
>
>  
>
>>>That means that we have to have a way to ensure that no more commands
>>>will reach the LLDD which can be triggered without any commands to be
>>>executed at all. This functionality has to come from the scsi mid layer.
>>>      
>>>
>>For simple transports yes; for more complicated ones, the CDB will
>>not be able to be delivered, and will return with error.
>>    
>>
>
>Good.
>So the first thing a LLDD has to do after it has learned about a device
>being removed is to have the device block.
>1. set device offline
>But commands may still be in flight.IMHO it is not right to assume that
>all commands now in flight to a device have failed, as some may have
>completed successfully in time, or failed for other reasons than unplugging.
>So it should be the LLDD's responsibility to finish the outstanding commands.
>Furthermore, there's a window for commands already having passed the check
>for offline but not yet being noticed by the LLDD. The simplest solution is to
>use a waiting primitive from RCU. So we are at:
>
>1. set device offline
>2. synchronize the kernel
>3. finish all pending commands
>
>So far with me?
>The LLDD could now forget about the device and be done with it.
>However there's a problem left. The device may come back.
>What happens if a device with the same ID is reconnected?
>
>	Regards
>		Oliver
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
>  
>

