From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Re: [PATCH] USB changes for 2.5.58
Date: Fri, 24 Jan 2003 14:59:10 -0800
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20030124225909.GB2775@beaverton.ibm.com>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org> <200301232159.28656.oliver@neukum.name> <20030123213423.GA26415@redhat.com> <200301232339.40892.oliver@neukum.name> <20030123152554.F12788@one-eyed-alien.net> <20030124214831.GA28812@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20030124214831.GA28812@redhat.com>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Oliver Neukum <oliver@neukum.name>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Doug,
	I started writing the interface you put forth in your email. I
	am currently debugging it in UML so I can generate the error
	conditions in a control manner. I still have some stuff to look
	at in the error handler with it running in this mode as it
	previously expected no one else to be possibly doing operations
	on the host. This could be the case if other LLDD's use this
	interface and have another device that happens to timeout an IO
	post a device being set offline.
	
A clarification question below.


Doug Ledford [dledford@redhat.com] wrote:

> So, what you should be doing in 
> order to be both a nice scsi host that plays well with the generic 
> mechanism we have in place is when you get this removal event, you should 
> be free'ing all the state you needed about the usb bus and such and taking 
> this usb device off line or whatever you do.  Then let the scsi mid layer 
> clean up at it's leisure.  You don't need to worry about it because the 
> only thing you will have left is to wait for the scsi subsys to call you 
> when it's time to delete things.  You don't even have to keep device 
> references around because we pass those in to your deletion routines 
> anyway.
> 
> > I want to be able to inform the SCSI mid-layer, which will then inform
> > higher layers, that the device is gone.
> 
> scsi_set_device_offline() as we've been discussing.
> 

I assumed that the hotplug event would only come from this function if
no commands where outstanding. If there where commands outstanding the
event would not be generated until the error handler gained ownership of
all the commands.

-andmike
--
Michael Anderson
andmike@us.ibm.com



-------------------------------------------------------
This SF.NET email is sponsored by:
SourceForge Enterprise Edition + IBM + LinuxWorld = Something 2 See!
http://www.vasoftware.com
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
