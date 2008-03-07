From: Marc Bejarano <beej@alum.mit.edu>
Subject: Re: data corruption: ext3/lvm2/md/mptsas/vitesse/seagate
Date: Fri, 07 Mar 2008 17:40:40 -0500
Message-ID: <200803101519.m2AFJCJS032509@colby.verdasys.com>
References: <200803062108.m26L8e4i020882@colby.verdasys.com>
 <1204848652.3062.100.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1204848652.3062.100.camel@localhost.localdomain>
References: <200803062108.m26L8e4i020882@colby.verdasys.com>
 <1204848652.3062.100.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

hi, james.  thanks so much for taking the time to dig into this! :)

At 19:10 3/6/2008, James Bottomley wrote:
 >On Thu, 2008-03-06 at 16:08 -0500, Marc Bejarano wrote:
 >> i've been doing burn-in on a new server i had hoped to deploy months
 >> ago and can't seem to figure out the cause of data corruption i've
 >> been seeing.  the SAS controller is an LSI SAS3801E connected to an
 >> xTore XJ-SA12-316 SAS enclosures (vitesses expanders) full of seagate
 >> 7200.10 750-GB SATA drives.
 >>
 >> the corruption is occurring in ext3 filesystems that live on top of
 >> an lvm2 RAID 0 stripe composed of 16 2-drive md RAID 1 sets.  the
 >> corruption has been detected both by MySQL noticing bad checksums and
 >> also by using md's "check" (sync_action) for RAID 1 consistency.
 >
 >Actually, the RAID-1 might be the most useful.  Is there anything
 >significant about the differing data?

it looks like contiguous sectors of misplaced data.

 >Do od dumps of the corrupt
 >sectors in both halves of the mirror and see what actually appears in
 >the data ... it might turn out to be useful.

my colleague (who has been batting his head against this for far 
longer than he'd like to have been) has been getting at the data via 
a pread64() of the actual mysql data file.  multiple pread64()'s end 
up giving him both halves of the mirror.

 >Things like how long the
 >data corruption is (are the two sectors different, or is it just a run
 >of a few bytes within them) can be useful in tracking the source of the
 >corruption.

here is a cut of an email he wrote me:
===
In one instance of mirroring out-of-sync-ness, the disk with the bad
data looked as follows:

"a" is a currently undetermined offset into the block device divisible by 16K.

a + 0x00000: "header of 16K mysql/innodb page # 178812066 followed by 
good data"

a + 0x02600: **BAD DATA**: "header of 16K mysql/innodb page # 178812067",
should be at a+0x04000, followed by old version of first 6656 bytes 
of page 178812067

a + 0x04000: "header of 16K mysql/innodb page # 178812067 followed by 
correct current copy of page"

It looks to me like mysql/innodb "page" 178812067 at some point was 
written to the wrong spot, and subsequently a newer version of page 
178812067 got written out again, but to the proper spot.

In another instance of out-of-sync-ness, the bad disk looked as 
follows.  The bad disk was in a completely different md raid1 
"device", and if it needs to be said explicitly, was a totally 
different physical drive.

b + 0x00000: "header of 16K mysql/innodb page 309713974 followed by good data"

b + 0x03600: **BAD DATA**: "header of 16K mysql/innodb page 
309713975", should be at b+0x04000, followed by first 10752 == 21*512 
bytes of current correct value of page per disk with good copy

b + 0x06000: correct current last part of page 309713975 in proper place.

This is hard to explain.  It looks like page 309713975 got written 
out to the proper spot, but then the first 10752 bytes got written 
out again to the wrong spot?!?
===

 >Do you happen to have the absolute block number (and relative block
 >number---relative to the partition start) of the corruption?

no.  can you suggest an easy way to get that?

 >Of course, confirming
 >that git head has this problem too, so we could rule out patches added
 >to the RHEL kernel would be useful ...

we're not currently git-enabled, but i suppose it wouldn't take too 
long to become so.  would testing with the latest kernel.org snapshot 
(currently 2.6.25-rc4-git2 from this mornging) be good enough?  or 
were you hoping for a test with stuff from scsi-misc?

cheers,
marc

