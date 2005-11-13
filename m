From: Doug Ledford <dledford@redhat.com>
Subject: Re: Bug#338089: New aic7xxx driver fails spectacularly on 2940UW
Date: Sun, 13 Nov 2005 12:41:32 -0500
Message-ID: <43777ACC.8070503@redhat.com>
References: <20051113164732.73492.qmail@web88010.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:12174 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1751216AbVKMRd3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Nov 2005 12:33:29 -0500
In-Reply-To: <20051113164732.73492.qmail@web88010.mail.re2.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Graham Knap <graham.knap@rogers.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Horms <horms@debian.org>, 338089@bugs.debian.org, linux-scsi@vger.kernel.org

Graham Knap wrote:
> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
>>My best guess would be that the bus is slightly marginal.  The
>>aic7xxx drivers are notoriously sensitive to bus problems.  Could you
>>try lowering the bus speed to 10MHz in the aic7xxx bios and see if
>>that helps?
> 
> 
> Sure. I changed the device to 20MByte/s max. Now the driver shows
> 10MHz, 16-bit wide... and DV still fails, with what looks like the same
> messages.

I would expect this given what you state later...

> As for the bus being marginal, I don't see why it would be, but
> anything is possible.
> 
> Host adapter termination is set to "Automatic". If I understand things
> correctly, since there's no cable attached to the internal 50pin
> connector or the external connector, I could try forcing it to "Low ON
> / High ON"... right?
> 
> The cabling looks like this:
> 
> [HBA] -- [disk] -- [unused connector] -- [terminator]

Termination should be fine as automatic, but yes, you could force both on.

> I'm pretty sure the cable is U160 rated (it wasn't cheap). The
> terminator isn't integrated into the cable -- it's a plug-in Active SE
> terminator.
> 
> The drive is LVD capable, but I've never had trouble running it in SE
> mode. The "Force SE" jumper is not installed, but I suppose I could try
> that too.

Don't bother.

> http://www.hitachigst.com/tech/techlib.nsf/products/Ultrastar_36LZX
> 
> BTW -- Another oddity I should mention is that if I warm-reboot the
> system after DV fails, the drive isn't detected during POST. Power
> cycling fixes it. (In other cases, warm-rebooting works fine.)
> 
> Let me know what I should try next.

If the drive is unaccessible after the DV failure, even on a warm reboot 
(which includes a SCSI bus reset), then the drive is flat hung. 
Something done in the current code is breaking it.  Can you get a boot 
with DV turned off and capture the log messages and post them here 
please?  You already said it didn't help with the problem, but I'd like 
to see the failure scenario with it off, that might help determine the 
true root cause of the issue.


-- 
Doug Ledford <dledford@redhat.com>
http://people.redhat.com/dledford

