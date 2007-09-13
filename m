From: Mark Lord <lkml@rtr.ca>
Subject: Re: [linux-usb-devel] Problems with USB disk [solved]
Date: Thu, 13 Sep 2007 10:35:46 -0400
Message-ID: <46E94AC2.3030607@rtr.ca>
References: <Pine.LNX.4.44L0.0709131008360.3619-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759449AbXIMOgA@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0709131008360.3619-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Chuck Ebbert <cebbert@redhat.com>, Niels <zorglub_olsen@hotmail.com>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Wed, 12 Sep 2007, Mark Lord wrote:
> 
>> Chuck Ebbert wrote:
..
>>> Oh, nice. The usb-storage (SCSI) disk spins itself down and we can't handle that.
>>> Should we be disabling auto-spindown when we connect the device, or be able to
>>> handle this by sending the start command when needed?
>> There's more to this.
>>
>> My Sandisk Cruzer Micro 1GB USB sticks suffer from this regression.
> 
> I seriously doubt that.  Are you claiming that your USB stick spins 
> itself down during a suspend?  And then requires to be spun back up 
> before it will resume proper operation?

No, the machine is not being suspended at all.

What happens is, there's a nice little LED on the Cruzer stick,
that is "lit" when the stick itself is not in a "power suspend" state
(or whatever you USB folks call it).

On 2.6.22, that little LED stays "on" normally, and flickers off/on
when data is being transfered.

The new "USB autosuspend" logic in 2.6.23 now causes that little LED
to turn off after a few seconds of inactivity.

Once that happens, the USB stick is not accessible until after a longish
timeout (~30s I think), followed by a USB reset.  Then it is usable again
until the next inactivity timeout and autosuspend (a few seconds).

Etc.
