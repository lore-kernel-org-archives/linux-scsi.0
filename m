From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi/sd: Fix size output in MB
Date: Sat, 30 Aug 2008 15:57:14 -0600
Message-ID: <20080830215714.GE1239@parisc-linux.org>
References: <48B9546B.4010004@simon.arlott.org.uk> <1220117091.3615.3.camel@localhost.localdomain> <20080830174516.GD1239@parisc-linux.org> <48B9B552.8060406@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:40421 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbYH3V5a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Aug 2008 17:57:30 -0400
Content-Disposition: inline
In-Reply-To: <48B9B552.8060406@simon.arlott.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Simon Arlott <simon@fire.lp0.eu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Sat, Aug 30, 2008 at 10:02:10PM +0100, Simon Arlott wrote:
> On 30/08/08 18:45, Matthew Wilcox wrote:
> > On Sat, Aug 30, 2008 at 12:24:50PM -0500, James Bottomley wrote:
> >> No, this is wrong.  By mandated standards the manufacturers are allowed
> >> to calculate MB by dividing by 10^6.  This is a fiddle to allow them to
> >> make their drives look slightly bigger.  However, we want the printed
> >> information to match that written on the drive, so in this printk, we
> >> use the manufacturer standard for calculation (and then do everything
> >> else in bytes so we don't have to bother with it ever again).
> 
> It's unlikely to match what's on the drive, "1000204886016" isn't 1TB 
> by any standard.

Hm.  I bought a 500GB drive last year:

sd 1:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)

512 * 976773168
500107862016

512 * 976773168 / (1024 * 1024 * 1024)
465.76174163818359375000

If we report it as 465GB, we will get questions.  Even pretending it's
1024 * 1000 * 1000 doesn't work:

512 * 976773168 / (1000 * 1000 * 1024)
488.38658400000000000000

I think we have to stick with dividing by multiples of 1000.  It's what
the drive manufacturers do (and I do understand their reasons for doing
it).

> This looks useful for testing this... do you have an updated version?

Yes.
http://git.kernel.org/?p=linux/kernel/git/willy/ata.git;a=shortlog;h=ata-ram

> > 2. We should report in GB or TB when appropriate.  The exact definition
> > of 'appropriate' is going to vary from person to person.  Might I
> > suggest that we should report between two and four significant digits.
> > eg 9543 MB is ok, 10543 MB should be 10 GB.
> 
> I've gone with five digits, it switches to GB at ~98GB, and to TB 
> at ~98TB etc.

Reasonable minds can certainly disagree on this one.  I respectfully
submit that reporting a 97415MB capacity is less useful than reporting a
97GB capacity.  If you look at drive advertisements, they sell 1TB,
1.5TB, 80GB, 750GB, 360GB, ... we should be trying to match that.  I'm a
little dubious about trying to match the 1.5TB; I think 1500GB is close
enough, but a 50GB drive shouldn't be reported as 50000MB.  IMO, anyway.

> > 3. I hate myself for saying this ... but maybe we should be using the
> > horrific MiB/GiB/TiB instead of MB/GB/TB.
> 
> Somehow this stuff got into net-tools (ifconfig) too, so I have a
> patch to remove it from my systems.

I understand why networking tools are particularly cautious about this.
The line rate (eg 1Gbps) is 1000,000,000 bps, but the amount of traffic
reported might well use either binary SI or decimal SI.  Reporting the
wrong one makes a 7% difference at the GB/GiB level, and that's the kind
of amount that people can spend a week or more chasing.

> > 4. I've been far too busy to write said patch.  Simon, would you mind
> > doing the honours?
> 
> Sure, patch will follow this email... it can only go as far as 8192EB 
> and then there's not enough space to store more than 2^64 512-byte 
> sectors.

I think it'll be a while before we get drives of that capacity.  ATA is
limited to 48 bits for the number of sectors, and while you can increase
the sector size (4k is currently planned), that still doesn't bring you
close.  I suppose you could get ata_ram to have multiple drives and
raid-0 them together, but you'd still need to allocate 2^13 of them.

scsi_debug can probably go to the full 2^64 sectors.  I haven't looked
into it.

> (And if you only modify drivers/scsi/sd.c, the kernel make system 
> won't recompile sd.o!)

That sounds odd to me; what command are you using to rebuild?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
