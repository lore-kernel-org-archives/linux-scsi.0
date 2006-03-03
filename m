From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: sg regression in 2.6.16-rc5
Date: Fri, 3 Mar 2006 09:17:40 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0603030903190.22647@g5.osdl.org>
References: <E94491DE-8378-41DC-9C01-E8C1C91B6B4E@mac.com> <4404AA2A.5010703@torque.net>
 <20060301083824.GA9871@merlin.emma.line.org> <Pine.LNX.4.64.0603011027400.22647@g5.osdl.org>
 <4405F6F1.9040106@torque.net> <Pine.LNX.4.63.0603012239440.5789@kai.makisara.local>
 <44074CA1.3000007@torque.net> <Pine.LNX.4.64.0603021317520.22647@g5.osdl.org>
 <20060302230814.GB16237@merlin.emma.line.org> <Pine.LNX.4.64.0603021518430.22647@g5.osdl.org>
 <44087241.3090702@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:30133 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750886AbWCCRRu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2006 12:17:50 -0500
In-Reply-To: <44087241.3090702@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Matthias Andree <matthias.andree@gmx.de>, Kai Makisara <Kai.Makisara@kolumbus.fi>, Mark Rustad <mrustad@mac.com>, linux-scsi@vger.kernel.org



On Fri, 3 Mar 2006, Douglas Gilbert wrote:
> 
> Well thanks for the characterization as a whiner. I may
> not follow the party line but I try not to resort to
> name calling.

I have a saying: "On the internet, nobody can hear you being subtle".

So I don't much do "polite". Sorry.

> Yes, I have been told the block subsystem is generic, if so why does it 
> enforce concepts like max_sectors ?

Exactly because it's generic.

If it wasn't generic, everybody would need to know what the low-level 
device limits are, before they submitted a request. 

So the block subsystem is all about _hiding_ the limitations of the 
devices behind it, and that means that it's designed so that you can 
submit lots of small requests, and it will try to generate the most 
efficient one that it can.

The same is true of scatter-gather. The native page-size is assumed to be 
the minimal acceptable scatter-gather size (and alignment - many devices 
cannot do DMA across certain boundaries, but we assume that the boundary 
is never _within_ a page), and the block subsystem knows how to merge them 
_if_ the device can handle bigger requests.

So the generic block subsystem knows about things like "this device cannot 
do DMA that crosses a 64kB boundary", or "this device can only do DMA 
withing the low 24 bits of the address space" etc etc, exactly because 
it's meant as a generic layer against a lot of different devices, where 
the low-level devices have strange limitations that the upper levels 
_really_ don't want to know about.

Yes, it's complex. And yes, sg.c used to ignore it. And yes, most devices 
in practice allow much more than the minimum we assume, so quite often, in 
_practice_ you can ignore the limitations and it works even if it 
shouldn't, and even though on some other devices it might not.

> ... and I believe that is the correct solution and what,
> I believe, Mike Christie who is the author of "st/sg
> scatter gather list merge" change wants to do. But
> since the requirement has just come up, it is unlikely
> that code code be produced it time for lk 2.6.16 .

Now, the reason I don't personally worry so much is because the error will 
be hard and abrupt: if the device driver limits say (for example) that a 
device only takes 255-sector requests (even if the hw can actually handle 
mroe), then the end result is a nice hard IO error.

In contrast, when we've gone the other way, the end result is quite often 
very subtle corruption that only happens under heavy load when writeback 
generates a bigger request than the hw can handle. I think the initio.c 
driver used to do things like that (and we've had issues with IDE drivers 
that thought that a sector count of 0 meant _zero_ instead of 256 like an 
IDE controller should, and thus just _dropped_ the write entirely).

So the good news is that I don't expect any subtle bugs. It doesn't get 
much less subtle than "my SCSI CD-writer doesn't burn any more". The other 
reason I think it's ok is that people who use the SG interfaces tend to be 
doing something pretty special in the first place - disk testing, for 
example.

Finally, the real reason is that I think the new approach is just 
fundamentally more correct, and we just need to bite the bullet.

		Linus
