From: Andreas Dilger <adilger@sun.com>
Subject: Re: [dm-devel] REQUEST for new 'topology' metrics to be moved out	of
 the 'queue' sysfs directory.
Date: Tue, 30 Jun 2009 01:09:27 +0200
Message-ID: <20090629230927.GU3570@webber.adilger.int>
References: <125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
 <20090625194015.GB31415@kernel.dk> <19012.49673.454853.975682@notabene.brown>
 <20090626125037.GO23611@kernel.dk>
 <f0d53a7338e1be4e7bdcbe09223c6f73.squirrel@neil.brown.name>
 <20090626132940.GR23611@kernel.dk> <19014.4447.248248.63960@notabene.brown>
 <20090629101841.GF23611@kernel.dk>
 <b0aa07ac85efd6040501e4ea875176a3.squirrel@neil.brown.name>
 <20090629114121.GH23611@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:60685 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbZF2XJm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2009 19:09:42 -0400
Content-disposition: inline
In-reply-to: <20090629114121.GH23611@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: NeilBrown <neilb@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>

On Jun 29, 2009  13:41 +0200, Jens Axboe wrote:
> ... externally it just makes the API worse since tools then have to know
> which device type they are talking to.
> 
> So I still see absolutely zero point in making such a change, quite the
> opposite.

Exactly correct.  Changing these tunables just for the sake of giving
them a slightly different name is madness.  Making all block devices
appear more uniform to userspace (even if they don't strictly need all
of the semantics) is very sensible.  The whole point of the kernel is
to abstract away the underlying details so that userspace doesn't need
to understand it all again.

In order to get good throughput on RAID arrays we need to tune the
queue/max_* values to ensure the IO requests don't get split.

It would be great if the MD queue/max_* values would pass these tunings
down to the underlying disk devices as well.  As it stands now, we have
to follow the /sys/block/*/slaves tree to set all of these ourselves,
and before "slaves/" was introduced it was nigh impossible to automatically
tune these values.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

