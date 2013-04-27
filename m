From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: T10 WCE interpretation in Linux & device level access
Date: Sat, 27 Apr 2013 09:09:31 -0700
Message-ID: <1367078971.1840.21.camel@dabdike>
References: <5176E3E8.3000809@redhat.com> <1366747622.1939.6.camel@dabdike>
	 <51770DAA.4020409@tributary.com>
	 <94D0CD8314A33A4D9D801C0FE68B402950DFB8F2@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38191 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752704Ab3D0QJe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Apr 2013 12:09:34 -0400
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402950DFB8F2@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Jeremy Linton <jlinton@tributary.com>, Ric Wheeler <rwheeler@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <mkp@mkp.net>, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>, Mike Snitzer <snitzer@redhat.com>, "dgilbert@interlog.com" <dgilbert@interlog.com>

On Wed, 2013-04-24 at 05:44 +0000, Elliott, Robert (Server Storage)
wrote:
> If the writeback cache is enabled (per the WCE bit in the Caching mode page),
> prudent software uses the FUA bit in WRITE commands when writing metadata
> and/or sends the SYNCHRONIZE CACHE command at important checkpoints to 
> ensure the data is not going to be lost due to a power loss.  Some 
> database software is particularly prolific at sending these commands. 
> 
> Around 2003, many RAID controllers with non-volatile writeback caches honored
> the SYNCHRONIZE CACHE command, flushing the entire cache to the drives.  This
> started causing timeouts as non-volatile write cache sizes grew.  Recently,
> it's even causing trouble on individual disk drives with growing volatile 
> write caches.
> 
> The intent of software using these commands and bits was unclear - it could be:
> a) ensure data is in non-volatile cache (and will eventually be flushed) 
>    or on the medium; or
> b) ensure data is on the medium (so the drives are ready for removal). 

Just from looking at the Linux code (and the code in other operating
systems like BSD or Solaris), you can see that for non-removable media
our intent is always a).

For removable media, you can argue the OS needs b), but I don't actually
know of any removable hard disks that actually have a NV cache (that's
exclusively the province of the array vendors), so it's a bit moot.

> As a short-term fix, many RAID controllers assumed intent (a) and started
> interpreting the SYNCHRONIZE CACHE command as a NOP and ignoring the FUA bit.  
> 
> Surprise removal of a drive from a RAID controller is risky even if software 
> has run SYNCHRONIZE CACHE, since the RAID controller might be doing other
> activity in the background. So, there are other reasons to justify assuming
> that the user just won't do that.

Right.  In fact surprise removal of array disks is something most admins
quickly learn never to do.  The only use case for deliberately damaging
your array like this is drive replacement, and that's where you remove a
potentially failing device and ask for a rebuild but since the array
keeps running, there are no cache issues involved.

> Afraid of breaking software with intent (b) (which was more likely in the 
> days of floppy disks, Bournelli Boxes, and other removable block devices), 
> T10 chose to clarify that the original meaning was (b) and added new 
> FUA_NV and SYNC_NV bits to let software express intent (a).  The hope
> was that devices would implement the bits and software would start using
> them at appropriate times.

Just for future learning, does T10 see the mistake here?  Even if we
assume the b) case (which I think everyone can agree is the wrong one),
Operating Systems are slow to change, so arrays have to continue with
current behaviour.  Even in the b) case, the only way to update the
standard to codify existing behaviour and enable the b) case is to say
that current SYNCHRONIZE CACHE may now choose not to flush the NV cache
but here's a new bit to signal intent to flush NV cache as well (i.e.
the new flag should have forced flush of volatile + Non Volatile cache).

By doing the opposite, T10 effectively piled confusion onto the
situation because array vendors worried about flush latencies were
always going to ignore the flush and new entrants were going to get
confused about what the OS is doing, leading to what you say below:

> Unfortunately, the short-term fix worked well enough that it still prevails
> today, and most standalone removable media block devices have disappeared.
> There is not much software actually sending the FUA_NV and SYNC_NV bits 
> and few devices honoring the bits per the standard.

And the arrays that did actually honour the standard are now the ones
people are complaining about ...

> As an SBC-3 letter ballot comment, I recently submitted T10 proposal 
> 13-050 (see http://www.t10.org/doc13.htm) to obsolete the SYNC_NV and 
> FUA_NV bits and change the meaning of the commands without those bits
> to intent (a), reflecting what the industry has actually done.

I think that works.  If an admin is concerned about the b) case, they'll
ask the array management software to do the offline rather than the OS,
so I don't actually see any use case where we have to worry in the OS
about the NV cache.

James


