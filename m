From: Luben Tuikov <luben@splentec.com>
Subject: Re: Re: [PATCH] USB changes for 2.5.58
Date: Mon, 20 Jan 2003 13:56:56 -0500
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <3E2C4678.1090508@splentec.com>
References: <10426732153816@kroah.com> <20030117105414.E359@one-eyed-alien.net> <3E2C3380.3070700@splentec.com> <200301201923.50467.oliver@neukum.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Oliver Neukum <oliver@neukum.name>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Oliver Neukum wrote:
>>I take it you mean that the transport will tell the LLDD that the device
>>is gone and it (LLDD) call the one above, SCSI Core to remove the device.
>>
>>Hmm, more thinking needs to be done here, as shouldn't this be handled
>>by hotplugging? I.e. Targets do not *initiate* events.
>>
>>The transport can notify that the device is gone, but an ULP entity will
>>call scsi_remove_device() not the other way around.
> 
> 
> NO!

We're probably talking about two different things.

> This is an insanely complicated scheme.
> We have no notification beforehand. User yanks out cable.
> That's it. No preperation at all.

So now you have two possibilities:
	a) the transport supports this event notification,
	b) the transport doesn't support this event notification.

Let me just elaborate a bit more here: since the transport/LLDD would
know that the device has just disappeared (a)), it *will* return error
in the due time when someone is trying to use it (and this is the
same error as if there had never been such a device).

But a removal of a device would probably have to start in top-down
approach, to free/release/etc resources/etc, rather than a bottom-up
approach (I just cannot see how this would work...)

In fact, this is the whole point of hotplugging, as there may be
other closely related things which would have to be done.

> We as the writers of device drivers need a way to get rid of the device
> as we are notified of the physical disconnect.

Yes, and as I explained earlier: you *may* get notified by the transport.

 > It is not our job to maintain devices in an undead state.

Yes, Linus has said this here before and it's pointless for you to
repeat it here.  Furthermore, nothing I've said suggests that.

Everyone agrees with this.

> And a scheme that goes subsystem driver -> hotplugging -> script finding
> corresponding devices -> script doing proc magic -> scsi layer notifying
> low level driver is _not_ sensible. It triples the amount of complexity.
> 
> We need a simple scheme like
> 1. block further requests
> 2. kill old requests
> 3. remove device

But there's nothing non-trivial about this scheme -- i.e. it's no
brainer -- everyone knows that *those* are the minimum set of steps.

Q: who initiates step 1?

If it's the user, then we're wasting time discussing trivialities
here (or maybe we're showing that we're working :-)) ).
But if it's not the user, then...

In general, I wasn't really discussing hotplugging, I was basically
hinting that SCSI Core could use a few more functionalities, and that
some things need to go away.

-- 
Luben





-------------------------------------------------------
This SF.NET email is sponsored by: FREE  SSL Guide from Thawte
are you planning your Web Server Security? Click here to get a FREE
Thawte SSL guide and find the answers to all your  SSL security issues.
http://ads.sourceforge.net/cgi-bin/redirect.pl?thaw0026en
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
