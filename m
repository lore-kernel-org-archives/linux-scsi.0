From: Doug Ledford <dledford@redhat.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Fri, 24 Jan 2003 19:05:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030125000529.GE28812@redhat.com>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org> <200301232159.28656.oliver@neukum.name> <20030123213423.GA26415@redhat.com> <200301232339.40892.oliver@neukum.name> <20030123152554.F12788@one-eyed-alien.net> <20030124214831.GA28812@redhat.com> <20030124152540.B27859@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030124152540.B27859@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

On Fri, Jan 24, 2003 at 03:25:40PM -0800, Matthew Dharm wrote:
> So, if I read this correctly, you're saying that the correct sequence is:
> 
> (1) get disconnect notification from USB
> (2) Call scsi_set_device_offline() (must hold host lock for this)

Yes.

> (3) call scsi_done() for all command in queue (max: 1)

Hmmm...only 1?  USB limit or driver limit?

> (4) Call scsi_remove_host(), which should now work because no commands are
> outstanding

We may need to add code to scsi_remove_host() to allow it to clean out the 
request queue of the device when the device is offline and this call is 
made.  Just because we returned the 1 command you had outstanding doesn't 
mean that there weren't more in the request queue (especially true of hard 
disks like my mp3 player).  However, once the device is offline, cleaning 
out the queue is a known non-blocking operation, it just takes non-0 time 
as well.  Once the queue is cleaned out, we need to shut it down so that 
no more commands can come in to the block level.

> (5) Call scsi_unregister()
> 
> And we're done, all structures can be freed.  And, as I understand it, the
> following is true:
> 
> (a) once (2) is done, no more commands will be queued

To your driver, yes.  If Mike makes it clean out and disable the request 
queue at the same time, then we could answer this question as yes at the 
request queue level as well.

> (b) once (3) is done, (4) is guaranteed to work

No!  Remember, command completion is delayed!  We have a tasklet that 
processes your now complete command, and with that processing comes 
marking the device unbusy, which is also required for 4 to work.  That's 
why I was suggesting waking up the error handler thread and letting it 
finish this process off.  The error handler thread has the luxury of being 
able to wait for the command completion to happen, and in my opinion it's 
a slightly better place to do the work of cleaning out the request queue.

> (c) there is nothing the user can do to make this sequence take a long time

True.  We need time to do things in our very slightly async way, but the 
user isn't able to keep us from completing.

> Tho, this does leave me with a couple of questions:
> 
> (i) Doesn't scsi_set_device_offline() work on devices, not hosts?  How do I
> map from my host to my device list?

Well, in hosts.c::scsi_remove_host() we do it thusly:

        list_for_each_entry(sdev, &shost->my_devices, siblings)
                if (scsi_check_device_busy(sdev))
                        return 1;

> (ii) Do I need to call scsi_set_device_offline() for each device?  I
> presume 'yes'.

Yes.  As people pointed out to me the reason a USB device is done as a 
host is because it very well may *be* a host with several devices behind 
it, so it must handle the multiple device scenario correctly and set all 
devices offline and clean up after all of them that might be behind this 
bridge.

> (iii) What should I shove into the status field of the scsi command before
> I scsi_done() it?

Well, to force an error I always put DID_ERROR into the driver byte of 
the result dword, aka:

cmd->result = DID_ERROR << 16;

> Oh, and as for my being a 'prick'.... my big problem is that the documented
> interface is synchronous.  Async is fine with me, but up until this e-mail,
> all I've seen is people arguing over what the sequence is, and theoretical
> issues of what users should and should not do.  And I also think that a
> large number of hotplugable hosts are going to replicate a whole bunch of
> code to do (2)+(3)+(4) in one, synchronous burst.

Which would be wrong BTW.  If you can support multiple devices behind a 
bridge then you can't put (2)+(3)+(4) together in one burst.  That's why 
they aren't that way now.  As to the sync vs. async, the scsi mid layer 
quit being fully sync during the 2.4 timeframe.  When the old error 
handling code was dropped from 2.5+, all sync completion code was also 
dropped.

> If someone will step forward with a 'yes' or 'no' on this sequence, then
> I'll get it done.  If the answer is 'no', then what did I miss?

Just the tasklet completion issue.


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
