From: Doug Ledford <dledford@redhat.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Fri, 24 Jan 2003 16:48:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030124214831.GA28812@redhat.com>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org> <200301232159.28656.oliver@neukum.name> <20030123213423.GA26415@redhat.com> <200301232339.40892.oliver@neukum.name> <20030123152554.F12788@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030123152554.F12788@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

On Thu, Jan 23, 2003 at 03:25:54PM -0800, Matthew Dharm wrote:
> Well, I've been watching this go on for days.  I hate to weigh in now, but
> I think someone needs to understand what the guy writing the code that is
> facing this problem really wants.
> 
> First, let me say that a USB storage device shows up as a HBA.  That's
> because some devices are actually USB/SCSI bridges.  But, since I work at
> the 'emulated host' level, that's where I'm focused.
> 
> What I want:
> 
> I want to be able to free resources associated with a device within a
> finite (and well bounded) amount of time after I am notified that the
> device is gone.

This is doable.  Partly.  You need to do it within the framework of what 
the scsi subsys needs, but it can be done.  Basically, the scsi core has 
an object allocation oriented paridigm where the lldd is expected to act 
as a driver that handles creation, use, and destruction of objects at the 
mid layer's direction.  Changing that paridigm would be very difficult.  
However, we don't need the usb subsys to maintain full state on the device 
once it has gone away, just enough state to be able to talk to the mid 
layer and tell it where the outstanding commands are.  Once the mid layer 
is finally done with it, the mid layer will tell your subsys to do a final 
free of the device by calling your release routine (for hosts) or your 
slave_destroy routine (for devices).  So, what you should be doing in 
order to be both a nice scsi host that plays well with the generic 
mechanism we have in place is when you get this removal event, you should 
be free'ing all the state you needed about the usb bus and such and taking 
this usb device off line or whatever you do.  Then let the scsi mid layer 
clean up at it's leisure.  You don't need to worry about it because the 
only thing you will have left is to wait for the scsi subsys to call you 
when it's time to delete things.  You don't even have to keep device 
references around because we pass those in to your deletion routines 
anyway.

> I want to be able to inform the SCSI mid-layer, which will then inform
> higher layers, that the device is gone.

scsi_set_device_offline() as we've been discussing.

>  This is so that all may deal with
> this however they want.  I really don't care who does what, as long as we
> don't crash.  This implies that all block-type drivers will need to become
> hotplug aware, or the SCSI mid-layer will have to fake command failures.

As I stated in my proposed design email, this will already be taken care 
of.  As long as you call scsi_set_device_offline() while holding the host 
lock for this host, then there will be no races between this call and the 
queuecommand() call which should be *all* that you care about.  You will 
no longer get commands for this device.  Now let me inform you of what the 
scsi subsys cares about.  You need to return *all* outstanding commands 
that this device has in your lldd before you go off and play "my device is 
gone so I'm free'ing everything".  That hasn't been the case from what 
I've seen, and that's what the scsi subsys needs.  If you don't return 
absolutely *all* outstanding commands before you go around free'ing stuff, 
then what happens is the scsi subsys needs those commands back in order to 
free up the scsi structs and it calls into the usb stack to get a reset or 
abort on the command and you guys have already free'd up your stuff and 
you don't claim to know what we are talking about.  At that point, we have 
a permanently stuck device.  This is the part where I said yesterday that 
you could handle this at the time you set the device offline by adding the 
code to return all the commands or you could just let your already present 
error handler code get called by the error handler thread and return the 
outstanding commands that way.  But, one way or the other, it has to be 
done.

> I want to be able to do as little command-trickery as possible.  If I have
> to do it, then that means the next hotplug-capable LLDD must do it also.
> Duplication of code is bad -- it should all be handled in the mid-layer.

No one has to do anything of the sort if you follow what I wrote.  Once 
the device is marked offline, any further commands already present in the 
request queue but not yet sent to the device plus any commands that come 
in to the request queue will all be sent back as I/O errors immediately 
before ever coming to you.

> As yet, the interface I have to the SCSI mid-layer fails on all three
> points here.

SCSI <-> USB interaction is wrong right now.  We know that.

> And now, some of my opinions on how this should all work:
> 
> It would be nice if the user informed us about removing the device before
> they did it.  But we shouldn't crash if they don't.

Correct.

> I don't want to be hanging around after a device is gone, spinning my
> wheels because some other part of the kernel can't handle the fact that the
> device is gone.  My driver is a passthru between the a SCSI emualted host
> and a physical USB device -- if my device is gone, I want to be out of
> there.  (Oddly enough, I'm starting to think there may be a DoS attack here
> if you force the LLDD to stay -- after all, it consumes memory....)

The device will go away.  But, because we clean up multiple things on a 
host, like an error handler thread that needs to be woke up and we have to 
wait for it to run and acknowledge the death, instantaneous removal of all 
the structs is simply unrealistic.  Unplugging your internal structs from 
the actual bus and then letting the scsi subsys clean them up at it's 
leisure is possible though, and that's what I'm asking for.

> Remember, the physical plug doesn't ask me if it's okay, and I don't get to
> ask the SCSI mid-layer if it's okay.  Yes, starting with the user clicking
> to tell us would be nice, but I don't get to see that.  All I get to see is
> an indication that the plug is pulled.

I don't disagree.  But because a plug is pulled has nothing to do with 
objects that might hold a reference to your object.  Just because you 
*want* it that way doesn't mean it's realistic to actually try and make it 
that way.  We can delete an object only after the last reference is 
released.

> I don't really give a rat's a** about 'how SCSI works' or how it's
> specified or CAM models or any of that.  I try to live in the real world as
> much as possible.  In that world, I'm not asking to remove an HBA -- I'm
> telling you it's been removed.  I can't call it back.  I can't even fake a
> command (other than perhaps INQUIRY) in any meaningful way.  THERE IS
> NOTHING I CAN DO BUT KEEP INSISTING THAT THE DEVICE IS GONE!

I wouldn't suggest otherwise.  I'm saying that in the real world of 
software design, it doesn't matter if your device is gone or not, if there 
are still references outstanding to the object then a free of that object 
is a software bug.  Come on now, quit being a prick about all this because 
you know I'm right on that point.  I'm not asking you to leave shit around 
forever, I'm asking you guys to work within the generic framework of 
object allocation and freeing that already exists in the scsi subsys to 
get things done.  The real problem is that you guys want this clean up 
process to be syncronous and I'm telling you that it's ever so slightly 
async because we have a couple schedules that have to take place and 
possibly a request queue to clean out.  No one seems willing to accept 
that a slightly async process is going to be OK.  Whatever.

> It would be nice if the user could inform various parts of the kernel that
> this device was going away, and then all sorts of cleanup could happen.
> But I really don't care -- all I'm trying to do is exit without a resource
> leak under all circumstances.

And so you shall if you follow the guidelines I set forth.

> It would be nice if the SCSI mid-layer kept track of what commands were in
> what stages in who's queues.  After all, if I hot-unplug a PCI SCSI
> controller, the controller really isn't going to be able to complete those
> commands for us -- we have to assume that commands queued by a LLDD are
> really just being sent to the hardware for queuing.  If that wasn't the
> case, then having LLDD queue capability doesn't make sense.

See, now you're just being a prick again.  You know the reason that the 
scsi mid layer *makes* the lldd tell us it is done with the commands is 
because if we go around saying "oh, this command was outstanding, let's 
free it" without getting clearance from the lldd then the lldd might still 
yet have state associated with the command.  We can't *ASSUME* jack crap 
in the mid layer.  You have to *TELL* us that you are done with a command.  
It is the only way to avoid races, resource leaks, and all sorts of other 
crap.  It amazes me that you think you should be excused from the job of 
cleaning up your queues after something happens like that.  Maybe the USB 
code doesn't allocate any internal command structs to go along with each 
scsi command, but pretty much every real scsi driver does and it's 
imperative that the driver go through all those commands and clean up 
after an event such as a removal, so what's the big deal about calling 
scsi_done() to *tell* us that you've cleaned up?

> Now, here's the kicker -- this is what I think Linus wants:
> 
> Linus said to me, with a degree of annoyance, that he doesn't want
> usb-storage to keep any associations of departed devices with SCSI emulated
> hosts.  That means that I need to be able to add and remove hosts at the
> will of the end-user.  In the end, what drives the entire process is what
> Linus' hand does when it's placed on his USB flashcard reader.

Well, the few milliseconds it might take to properly clean this stuff out
is well within the specifications of how fast a human can go around
plugging and unplugging a flashcard reader, so I'm not concerned that my
proposal doesn't meet these requirements.



-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
