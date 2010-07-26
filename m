From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: rq-based mpath failed path on SCSI target failure (malformed
 discard)
Date: Mon, 26 Jul 2010 11:00:00 -0400
Message-ID: <20100726150000.GA31293@redhat.com>
References: <20100726133008.GA26771@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247Ab0GZPAO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jul 2010 11:00:14 -0400
Content-Disposition: inline
In-Reply-To: <20100726133008.GA26771@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, dm-devel@redhat.com

On Mon, Jul 26 2010 at  9:30am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Hi,
> 
> I have been implementing discard support for the various DM targets.  I
> have a LUN that requires a 4K alignment for all discard requests.  I
> forced the issue (by misconfiguring the alignment such that discards
> would be misaligned).  Multipath failed the path once the SCSI layer got
> the following error.
> 
> My question: shouldn't mpath _not_ fail the path for "Illegal
> Request".. "Parameter value invalid"?  The same request would fail on
> any path given that the failure is on the target side (rejecting the
> malformed discard request).  Following setup is ext4 FS ontop of linear
> DM mapping (dm-2) ontop of request-based mpath mapping (dm-1):
> 
> EXT4-fs (dm-2): mounted filesystem with ordered data mode
> sd 3:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> sd 3:0:0:0: [sda] Sense Key : Illegal Request [current] 
> Info fld=0x0
> sd 3:0:0:0: [sda] Add. Sense: Parameter value invalid
> sd 3:0:0:0: [sda] CDB: Write same(16): 93 08 00 00 00 00 00 00 45 82 00 00 03 00 00 00
> end_request: I/O error, dev sda, sector 17794
> device-mapper: multipath: Failing path 8:0.

The following patch sorts this out in multipath; special-cases discard
requests so that they don't enduce path failures:

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index ec2b43e..125c80f 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1272,6 +1272,9 @@ static int do_end_io(struct multipath *m, struct request *clone,
 	if (error == -EOPNOTSUPP)
 		return error;
 
+	if (clone->cmd_flags & REQ_DISCARD)
+		return error;   /* pass all discard request failures up */
+
 	if (mpio->pgpath)
 		fail_path(mpio->pgpath);
 
