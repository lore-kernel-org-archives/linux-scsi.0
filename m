From: Mike Snitzer <snitzer@redhat.com>
Subject: [LSF/MM TOPIC] a few storage topics
Date: Tue, 17 Jan 2012 15:06:12 -0500
Message-ID: <20120117200609.GA7933@redhat.com>
References: <CABE8wws67dn0fwhTCs_XqH0g_CxGuT+hPQH9cVFe1xx5t_O9Jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab2AQUGU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jan 2012 15:06:20 -0500
Content-Disposition: inline
In-Reply-To: <CABE8wws67dn0fwhTCs_XqH0g_CxGuT+hPQH9cVFe1xx5t_O9Jw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org

1) expose WRITE SAME via higher level interface (ala sb_issue_discard)
   for more efficient zeroing on SCSI devices that support it
   - dm-thinp and dm-kcopyd could benefit from offloading the zeroing to
     the array
   - I'll be reviewing this closer to assess the scope of the work

2) revise fs/block_dev.c:__blkdev_put's "sync on last close" semantic,
   please see Mikulas Patocka's recent proposal on dm-devel:
   http://www.redhat.com/archives/dm-devel/2012-January/msg00021.html
   - patch didn't create much discussion (other than hch's suggestion to
     use file->private_data).  Are the current semantics somehow 
     important to some filesystems (e.g. NFS)?
   - allowing read-only opens to _not_ trigger a sync is desirable
     (e.g. if dm-thinp's storage pool was exhausted we should still be
      able to read data from thinp devices)

3) Are any SSD+rotational storage caching layers that are being
   developed for upstream consideration (there were: bcache, fb's
   dm-cache, etc).
   - Red Hat would like to know if leveraging the dm-thinp
     infrastructure to implement a new DM target for caching would be
     well received by the greater community
   - and are there any proposals for classifying data/files as cache
     hot, etc (T10 has an active proposal for passing info in the CDB)
     -- is anyone working in this area?

4) is anyone working on an interface to GET LBA STATUS?
   - Martin Petersen added GET LBA STATUS support to scsi_debug, but is
     there a vision for how tools (e.g. pvmove) could access such info
     in a uniform way across different vendors' storage?

5) Any more progress on stable pages?
   - I know Darrick Wong had some proposals, what remains?
