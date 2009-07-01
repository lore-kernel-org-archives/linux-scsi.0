From: Neil Brown <neilb@suse.de>
Subject: Re: [dm-devel] REQUEST for new 'topology' metrics to be moved out	of
 the 'queue' sysfs directory.
Date: Wed, 1 Jul 2009 10:29:10 +1000
Message-ID: <19018.44502.425131.683796@notabene.brown>
References: <125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
	<20090625194015.GB31415@kernel.dk>
	<19012.49673.454853.975682@notabene.brown>
	<20090626125037.GO23611@kernel.dk>
	<f0d53a7338e1be4e7bdcbe09223c6f73.squirrel@neil.brown.name>
	<20090626132940.GR23611@kernel.dk>
	<19014.4447.248248.63960@notabene.brown>
	<20090629101841.GF23611@kernel.dk>
	<b0aa07ac85efd6040501e4ea875176a3.squirrel@neil.brown.name>
	<20090629114121.GH23611@kernel.dk>
	<20090629230927.GU3570@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57942 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278AbZGAA2a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jun 2009 20:28:30 -0400
In-Reply-To: message from Andreas Dilger on Tuesday June 30
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>

On Tuesday June 30, adilger@sun.com wrote:
> On Jun 29, 2009  13:41 +0200, Jens Axboe wrote:
> > ... externally it just makes the API worse since tools then have to know
> > which device type they are talking to.
> > 
> > So I still see absolutely zero point in making such a change, quite the
> > opposite.
> 
> Exactly correct.  Changing these tunables just for the sake of giving
> them a slightly different name is madness.  Making all block devices
> appear more uniform to userspace (even if they don't strictly need all
> of the semantics) is very sensible.  The whole point of the kernel is
> to abstract away the underlying details so that userspace doesn't need
> to understand it all again.

Uniformity is certainly desirable.  But we shouldn't take it so far
as to make apples look like oranges.

We wouldn't want a SATA disk drive to have 'chunk_size' and 'raid_disks'.
Nor would we want a software RAID array to have a 'scheduler' or
'iosched' attributes.

> 
> In order to get good throughput on RAID arrays we need to tune the
> queue/max_* values to ensure the IO requests don't get split.
> 
> It would be great if the MD queue/max_* values would pass these tunings
> down to the underlying disk devices as well.  As it stands now, we have
> to follow the /sys/block/*/slaves tree to set all of these ourselves,
> and before "slaves/" was introduced it was nigh impossible to automatically
> tune these values.

I don't think that passing these values down is - in general - a well
defined problem.  This is (in part) because md/dm devices can be based on
partitions, and partitions don't have independent max_* values.

In your particular case, I don't expect that you use partitions, so it
makes perfect sense to do the tuning on a per-array basis.  But I
don't think that it is a concept that fits in the kernel.  As you say,
we have 'slaves/', which makes it practical to do this in user-space
and I would rather it stayed there.

NeilBrown
