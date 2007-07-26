From: "Freels, James D." <freelsjd@ornl.gov>
Subject: Re: [Bug 8366] aic79xx and aic7xxx driver issues
Date: Thu, 26 Jul 2007 17:57:48 -0400
Message-ID: <1185487068.14419.77.camel@fea.ornl.gov>
References: <20070725010525.614621080E4@picon.linux-foundation.org>
 <1185329683.3488.46.camel@localhost.localdomain>
 <1185461780.14419.17.camel@fea.ornl.gov>
 <1185462341.3501.62.camel@localhost.localdomain>
 <1185480022.14419.58.camel@fea.ornl.gov>
 <1185482804.3501.87.camel@localhost.localdomain>
 <1185484390.3501.93.camel@localhost.localdomain>
 <1185484597.14419.65.camel@fea.ornl.gov>
 <1185485358.3501.94.camel@localhost.localdomain>
 <1185485848.14419.71.camel@fea.ornl.gov>
 <1185486264.3501.99.camel@localhost.localdomain>
Reply-To: freelsjd@ornl.gov
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emroute1.ornl.gov ([160.91.4.119]:45860 "EHLO emroute1.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbXGZV5u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 17:57:50 -0400
Received: from emroute1.ornl.gov ([127.0.0.1])
 by emroute1.ornl.gov (PMDF V6.3-x11 #31501)
 with ESMTP id <0JLT0072R3OD8T@emroute1.ornl.gov> for
 linux-scsi@vger.kernel.org; Thu, 26 Jul 2007 17:57:49 -0400 (EDT)
In-reply-to: <1185486264.3501.99.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

OK.  Booted up great.  Found the media changer.  Here is the output from
the check you asked for:

target0:0:3: Beginning Domain Validation
target0:0:3: asynchronous
target0:0:3: FAST-20 SCSI 20.0 MB/s ST (50 ns, offset 32)
target0:0:3: Domain Validation skipping write tests
target0:0:3: Ending Domain Validation

output from amanda checks out OK:

fea8::/home/amanda/: mt status
SCSI 2 tape drive:
File number=0, block number=0, partition=0.
Tape block size 65536 bytes. Density code 0x81 (DLT 15GB compressed).
Soft error count since last status=0
General status bits on (41010000):
 BOT ONLINE IM_REP_EN
fea8::/home/amanda/: amcheck rrd
Amanda Tape Server Host Check
-----------------------------
Holding disk /holding_disk: 61245156 kB disk space available, using
60817408 kB as requested
slot 4: read label `rrd31', date `X'
NOTE: skipping tape-writable test
Tape rrd31 label ok
Server check took 19.264 seconds

Amanda Backup Client Hosts Check
--------------------------------
Client check: 4 hosts checked in 0.237 seconds, 0 problems found

(brought to you by Amanda 2.5.1p3)


It could never do this before.  True test will be tonight when backing
up about 20-60 GB.  Will report back in.

Thanks again.

On Thu, 2007-07-26 at 17:44 -0400, James Bottomley wrote:
> On Thu, 2007-07-26 at 17:37 -0400, Freels, James D. wrote:
> > Here is what I get when I apply the patch against the vanilla 2.6.22.1
> > source:
> 
> The reject files all have spaces instead of tabs, so it looks like your
> mailer did some nefarious translation.
> 
> Try the attachment ... that usually defeats mailer text translations.
> 
> the md5sum just for integrity's sake is 9ba6ace80c06d34b5391407ea68c381a
> 
> I tested it against 2.6.22.1 and it applies (but with some offsets):
> 
> jejb@hobholes> quilt push
> Applying patch tmp.diff
> patching file drivers/scsi/aic7xxx/aic79xx_osm.c
> Hunk #1 succeeded at 2309 (offset 25 lines).
> Hunk #2 succeeded at 2393 (offset 25 lines).
> Hunk #3 succeeded at 2475 (offset 25 lines).
> Hunk #4 succeeded at 2515 (offset 25 lines).
> Hunk #5 succeeded at 2551 (offset 25 lines).
> Hunk #6 succeeded at 2595 (offset 25 lines).
> Hunk #7 succeeded at 2631 (offset 25 lines).
> Hunk #8 succeeded at 2675 (offset 25 lines).
> patching file drivers/scsi/aic7xxx/aic7xxx_osm.c
> Hunk #1 succeeded at 2356 (offset 39 lines).
> Hunk #2 succeeded at 2425 (offset 39 lines).
> 
> James
> 
James D. Freels, Ph.D.
Senior Research Staff, HFIR Cold Source, ORNL
http://sunsite.utk.edu/wuot/mt/podcast/051807HIFER.mp3
