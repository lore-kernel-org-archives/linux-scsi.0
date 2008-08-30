From: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: [PATCH] scsi/sd: Fix size output in MB
Date: Sat, 30 Aug 2008 23:22:16 +0100
Message-ID: <48B9C818.6020302@simon.arlott.org.uk>
References: <48B9546B.4010004@simon.arlott.org.uk> <1220117091.3615.3.camel@localhost.localdomain> <20080830174516.GD1239@parisc-linux.org> <48B9B552.8060406@simon.arlott.org.uk> <20080830215714.GE1239@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from proxima.lp0.eu ([85.158.45.36]:49510 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887AbYH3WWW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Aug 2008 18:22:22 -0400
In-Reply-To: <20080830215714.GE1239@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 30/08/08 22:57, Matthew Wilcox wrote:
> On Sat, Aug 30, 2008 at 10:02:10PM +0100, Simon Arlott wrote:
>> On 30/08/08 18:45, Matthew Wilcox wrote:
>> > On Sat, Aug 30, 2008 at 12:24:50PM -0500, James Bottomley wrote:
>> >> No, this is wrong.  By mandated standards the manufacturers are allowed
>> >> to calculate MB by dividing by 10^6.  This is a fiddle to allow them to
>> >> make their drives look slightly bigger.  However, we want the printed
>> >> information to match that written on the drive, so in this printk, we
>> >> use the manufacturer standard for calculation (and then do everything
>> >> else in bytes so we don't have to bother with it ever again).
>> 
>> It's unlikely to match what's on the drive, "1000204886016" isn't 1TB 
>> by any standard.
> 
> Hm.  I bought a 500GB drive last year:
> 
> sd 1:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
> 
> 512 * 976773168
> 500107862016
> 
> 512 * 976773168 / (1024 * 1024 * 1024)
> 465.76174163818359375000
> 
> If we report it as 465GB, we will get questions.  Even pretending it's
> 1024 * 1000 * 1000 doesn't work:
> 
> 512 * 976773168 / (1000 * 1000 * 1024)
> 488.38658400000000000000
> 
> I think we have to stick with dividing by multiples of 1000.  It's what
> the drive manufacturers do (and I do understand their reasons for doing
> it).
> 

I disagree. The difference between advertised and actual capacity is 
only going to get worse when drive capacity increases further.
e.g. "4TB" will only be 3.6TB.

Who is going to be asking these questions about the kernel output, but 
not about whatever else reports 465GB, from 'df' to a GUI showing disk 
capacity? This actually makes the kernel more consistent with everything 
else.

>> This looks useful for testing this... do you have an updated version?
> 
> Yes.
> http://git.kernel.org/?p=linux/kernel/git/willy/ata.git;a=shortlog;h=ata-ram
> 
>> > 2. We should report in GB or TB when appropriate.  The exact definition
>> > of 'appropriate' is going to vary from person to person.  Might I
>> > suggest that we should report between two and four significant digits.
>> > eg 9543 MB is ok, 10543 MB should be 10 GB.
>> 
>> I've gone with five digits, it switches to GB at ~98GB, and to TB 
>> at ~98TB etc.
> 
> Reasonable minds can certainly disagree on this one.  I respectfully
> submit that reporting a 97415MB capacity is less useful than reporting a
> 97GB capacity.  If you look at drive advertisements, they sell 1TB,
> 1.5TB, 80GB, 750GB, 360GB, ... we should be trying to match that.  I'm a
> little dubious about trying to match the 1.5TB; I think 1500GB is close
> enough, but a 50GB drive shouldn't be reported as 50000MB.  IMO, anyway.

This really depends on whether or not you're going for matching advertised 
capacity. I think the extra digit avoids losing precision too early.

If you're intending to divide by 1000 you may as well determined what the 
advertised capacity would be and handle .5 xB (or even .25, .75, .1 
through .9).

>> > 3. I hate myself for saying this ... but maybe we should be using the
>> > horrific MiB/GiB/TiB instead of MB/GB/TB.
>> 
>> Somehow this stuff got into net-tools (ifconfig) too, so I have a
>> patch to remove it from my systems.
> 
> I understand why networking tools are particularly cautious about this.
> The line rate (eg 1Gbps) is 1000,000,000 bps, but the amount of traffic
> reported might well use either binary SI or decimal SI.  Reporting the
> wrong one makes a 7% difference at the GB/GiB level, and that's the kind
> of amount that people can spend a week or more chasing.

It's not actually a useful value... you'd need to use the byte value, which 
is also displayed, to monitor actual usage over time.

>> > 4. I've been far too busy to write said patch.  Simon, would you mind
>> > doing the honours?
>> 
>> Sure, patch will follow this email... it can only go as far as 8192EB 
>> and then there's not enough space to store more than 2^64 512-byte 
>> sectors.
> 
> I think it'll be a while before we get drives of that capacity.  ATA is
> limited to 48 bits for the number of sectors, and while you can increase
> the sector size (4k is currently planned), that still doesn't bring you
> close.  I suppose you could get ata_ram to have multiple drives and
> raid-0 them together, but you'd still need to allocate 2^13 of them.

The sector size can't currently be increased beyond 512 to get around this 
because it's scaled to 512 to store capacity. (Which my patch then uses to 
avoid computing the unit splits at runtime.)

> scsi_debug can probably go to the full 2^64 sectors.  I haven't looked
> into it.
> 
>> (And if you only modify drivers/scsi/sd.c, the kernel make system 
>> won't recompile sd.o!)
> 
> That sounds odd to me; what command are you using to rebuild?
> 

Maybe I was imagining it then... it appeared to be doing that at times 
while I found all the possible ways to mess up calculating 100000xB 
and having "0 EB" devices each time.

-- 
Simon Arlott

