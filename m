From: Luben Tuikov <luben@splentec.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Thu, 23 Jan 2003 12:46:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E302A89.8070703@splentec.com>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org> <3E2F1213.8090400@splentec.com> <200301222346.30329.oliver@neukum.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Oliver Neukum wrote:
> 
> Not all the world is a SAN. USB has no possibility to even try an interaction
> after the device is gone. We have to handle this flexibly.

Thus the example in the original post.  I.e. for simple transports whose
portals get notified when a device is plugged off (USB), the LLDD
can notify SCSI Core, by setting a state variable in scsi_device.
In which case SCSI Core can answer with the proper TARGET error code.
(This was outlined before, scsi_command->online:1 ...)

> In fact, if a device
> can vanish without a LLDD knowing about it, this is purely a problem of the
> SCSI layer.

No, of course not.  (Think of IP.)  When a device vanishes and LLDD doesn't
know about it (more complicated transports), the CDB will return with
the proper Service Response, since the transport(s) won't be able to deliver
it. This will bubble up through SCSI Core and the error returned will have
to be the same as that of the simpler transports, as outlined above.

>>>For something simple, like a USB serial port, it might turn out that the
>>>low-level device driver gets all these requests and then fails them. 
>>>That means the driver has to keep track of the fact that the device is no
>>>longer connected until some reference count goes to 0.
>>
>>A LLDD doesn't have to keep reference counts.  In the simple case
>>you mention above, it will check that the device is no longer reachable
>>and will return TARGET error, which will bubble up the layers, or the
> 
> 
> That is something that is impossible to some LLDDs. We have to keep
> a record about devices and busses we can reach and can delete these
> records only after we positively know that no more commands will come
> down to the LLDD.

But USB does keep such a record, doesn't it?   *Even if it doesn't*, as outlined
above, it can set a state variable in scsi_device and SCSI Core can take over
for error return values.

> The alternative would be to check a table of available devices for every
> command.

A command is destined to a device, at SCSI Core queuing logic a check
can be made... No need to go through tables of devices.

> That means that we have to have a way to ensure that no more commands
> will reach the LLDD which can be triggered without any commands to be
> executed at all. This functionality has to come from the scsi mid layer.

For simple transports yes; for more complicated ones, the CDB will
not be able to be delivered, and will return with error.

>>Newer drivers will make use of Service Response code, and be able to
>>address only by (target, lun) rather than (bus, target, lun), and
>>target may not be an int anymore.  But this is 2.7 stuff, or maybe
>>a separately distributed SCSI Core and LLDDs subsystem...
> 
> 
> Yes, but we need a solution for 2.6.
> And it has to be reasonably simple.

I think we have enough ideas to implement a reasonable one.

-- 
Luben



