From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: USB HD: No Sense / Info fld=0x0 and read corruption
Date: Wed, 24 Dec 2008 18:02:27 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0812241756020.917-100000@netrider.rowland.org>
References: <495296DF.4090900@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <495296DF.4090900-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ludovico Cavedon <ludovico.cavedon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 24 Dec 2008, Ludovico Cavedon wrote:

> Alan Stern wrote:
> > On Wed, 24 Dec 2008, Ludovico Cavedon wrote:
> >> -it is happening also with 2.6.28-rc8 (which should have the patch, right?)
> > 
> > What patch?  Do you mean the patch at the end of that email thread?  It 
> > affects only Argosy USB drives, not your Western Digital.
> 
> I thought also patches
> http://marc.info/?l=linux-scsi&m=122443015406309&w=2
> were included, but later I realized I was wrong.

A revised version of the first patch in that message is queued for 
2.6.29.  The second patch has not yet been merged in any form.

> I have patched my kernel with them, and now I/O errors get reported!
> 
> >> I am not able to understand if this is HD problem or a kernel problem. I
> > 
> > Partly both.  The HD (or more likely, its USB interface) is responsible 
> > for sending those unnecessary empty sense records.  The kernel is 
> > responsible for not reporting an I/O error (assuming an error actually 
> > did take place).
> 
> I think I found out what is happening on the HD side. The SMART self
> test fails with a read error. The SMART log reports uncorrectable read
> errors. However Reallocated_Event_Count is 0. Searching on the web,
> looks like that these sectors have bad ECC, so the cause a read error,
> however they are not bad sectors. Is this correct?

I don't know.  It sounds reasonable.  The real issue is: Why doesn't
the drive send back appropriate sense information to let the host know
about the bad ECC?

> My question is: how can this happen? and not just one sector, but at
> least a dozen!
> Bad HD? (it's new! 93 hrs of activity so far!)

Maybe you can exchange it...

> > 2.6.27 doesn't go into an endless loop?  This may indicate that 
> > eventually the drive stops sending the Check Condition status.
> 
> You are right. Most of the read attempts succeed after a a while.
> However I found one sector that is causing an endless loop on 2.6.27 and
> unpatched 2.6.28-rc8
> 
> > It would help to see the dmesg log for when one of these errors occurs.
> 
> There are no additional messages. However here it is:
> http://pastebin.com/mcfd54a3

Yeah, that's not very useful.

> > It would also help to know what happens under Windows.  Do the same 
> > "empty sense" errors occur?  If they do, how does Windows handle them?
> 
> I can try to use usb snoopy to log usb traffic under windows.
> Do you know how I can ask Windows "read sector X"?

I wish I knew!  Perhaps Microsoft's KnowledgeBase site can tell you 
how.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
