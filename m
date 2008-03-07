From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: data corruption: ext3/lvm2/md/mptsas/vitesse/seagate
Date: Thu, 06 Mar 2008 18:10:52 -0600
Message-ID: <1204848652.3062.100.camel@localhost.localdomain>
References: <200803062108.m26L8e4i020882@colby.verdasys.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58405 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752239AbYCGAK4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 19:10:56 -0500
In-Reply-To: <200803062108.m26L8e4i020882@colby.verdasys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Marc Bejarano <beej@alum.mit.edu>
Cc: linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org

On Thu, 2008-03-06 at 16:08 -0500, Marc Bejarano wrote:
> i've been doing burn-in on a new server i had hoped to deploy months 
> ago and can't seem to figure out the cause of data corruption i've 
> been seeing.  the SAS controller is an LSI SAS3801E connected to an 
> xTore XJ-SA12-316 SAS enclosures (vitesses expanders) full of seagate 
> 7200.10 750-GB SATA drives.
> 
> the corruption is occurring in ext3 filesystems that live on top of 
> an lvm2 RAID 0 stripe composed of 16 2-drive md RAID 1 sets.  the 
> corruption has been detected both by MySQL noticing bad checksums and 
> also by using md's "check" (sync_action) for RAID 1 consistency.

Actually, the RAID-1 might be the most useful.  Is there anything
significant about the differing data?  Do od dumps of the corrupt
sectors in both halves of the mirror and see what actually appears in
the data ... it might turn out to be useful.  Things like how long the
data corruption is (are the two sectors different, or is it just a run
of a few bytes within them) can be useful in tracking the source of the
corruption.

> most recently we got two cases of the storage stack apparently 
> writing a mysql 16K page starting at the wrong 512-byte (sector) 
> boundary.  in both cases it was at too low a sector.  one page was 13 
> sectors too early, the other 34 too early.  in both cases, one disk 
> in each mirror set had the correct data and the other incorrect 
> (apparently ruling out everything above md). unfortunately, the 
> problem is not easily repeatable.  the system can run for days with 
> terabytes of writes before we notice any corruption.

Do you happen to have the absolute block number (and relative block
number---relative to the partition start) of the corruption?  That might
help analyse the writing algorithms to see if there's a problem
somewhere.

> we're running RHEL 5.1's kernel and drivers and i understand that 
> these lists are for vanilla kernel support.  i've already engaged 
> redhat support, but i just wanted to see if anybody else has seen 
> something similar or anybody has any brilliant troubleshooting 
> ideas.  swapping drives, enclosures, HBA's, cables, and sacrifices of 
> animals to gods have so far not been able to make the world right.

Don't worry too much; the RHEL 5 stack is close enough to the vanilla
kernel, and we're interested in tracking it down.  Of course, confirming
that git head has this problem too, so we could rule out patches added
to the RHEL kernel would be useful ...

James


