From: Doug Ledford <dledford@redhat.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Fri, 24 Jan 2003 20:07:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030125010729.GG28812@redhat.com>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org> <200301232159.28656.oliver@neukum.name> <20030123213423.GA26415@redhat.com> <200301232339.40892.oliver@neukum.name> <20030123152554.F12788@one-eyed-alien.net> <20030124214831.GA28812@redhat.com> <20030124152540.B27859@one-eyed-alien.net> <20030125000529.GE28812@redhat.com> <20030124164553.C27859@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030124164553.C27859@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

On Fri, Jan 24, 2003 at 04:45:53PM -0800, Matthew Dharm wrote:
> Ah... the sweet feeling of progress.

Indeed ;-)

> Driver limit.  I added support for queueing, but the queue is fixed at size
> 1.  It's an improvement for the future.

OK.  Just curious.

> > No!  Remember, command completion is delayed!  We have a tasklet that 
> > processes your now complete command, and with that processing comes 
> > marking the device unbusy, which is also required for 4 to work.  That's 
> > why I was suggesting waking up the error handler thread and letting it 
> > finish this process off.  The error handler thread has the luxury of being 
> > able to wait for the command completion to happen, and in my opinion it's 
> > a slightly better place to do the work of cleaning out the request queue.
> 
> Okay... so what do I do if it fails?  Sleep for a while and try again
> later?  Wait on a flag somewhere?

Well, the better option is what I think we are working on.  Instead of
trying to remove the host completely, just unhook it from the USB stuff,
then call the set_scsi_device_offline(), then send back any outstanding
commands via scsi_done(), then possibly call the
scsi_schedule_host_removal() if Mike adds that function.  Then return.  
Don't to anything else.  Take all the remaining code you would normally
run at this point and put it into a function in your source called
usb_release() and in your Scsi_Host_Template struct that you pass to the
scsi layer, init the release pointer with the address of your
usb_release() routine.  That way, the scsi layer can do what it's best at,
taking care of the clean up details we've been talking about, and when
it's all done, it will call your usb_release() routine with a single
argument of the host struct you are wanting released.  At that point, you
can do all the freeing you would have done in that khubd loop (at least I
think that's the context you are doing the freeing from now) and know for
a fact that not only are you freeing everything, but so is the scsi mid
layer.  I think this will solve all the issues you've had, because this
*won't* leak, it won't block your other actions, and it lets the scsi
subsystem clean up properly.

> > > Async is fine with me, but up until this e-mail,
> > > all I've seen is people arguing over what the sequence is, and theoretical
> > > issues of what users should and should not do.  And I also think that a
> > > large number of hotplugable hosts are going to replicate a whole bunch of
> > > code to do (2)+(3)+(4) in one, synchronous burst.
> > 
> > Which would be wrong BTW.  If you can support multiple devices behind a 
> > bridge then you can't put (2)+(3)+(4) together in one burst.  That's why 
> > they aren't that way now.
> 
> Hrm... I can see your point if we're talking about hotplugging an
> individual device, but I don't see how (2)+(3)+(4) isn't what we want for
> hotplugging an entire host.

The numbers are gone from the email now so it's hard to reference, but I 
think I was commenting on the fact that if you have a true host device, 
then you might well be doing (2)+(3)*(number of devices behind 
bridge)+(4) or something like that.


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
