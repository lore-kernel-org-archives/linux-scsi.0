From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-io async WRITE_SAME results in iSCSI NULL pointer [was: Re:
 Write same support]
Date: Mon, 20 Feb 2012 18:44:10 -0500
Message-ID: <20120220234410.GC31853@redhat.com>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
 <20120216200202.GA27311@redhat.com>
 <20120216210301.GA27404@redhat.com>
 <yq139a55rhr.fsf@sermon.lab.mkp.net>
 <20120220184623.GA29931@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851Ab2BTXo1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Feb 2012 18:44:27 -0500
Content-Disposition: inline
In-Reply-To: <20120220184623.GA29931@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jaxboe@fusionio.com, dm-devel@redhat.com, michaelc@cs.wisc.edu, Vivek Goyal <vgoyal@redhat.com>

On Mon, Feb 20 2012 at  1:46pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> I'm adding more debug printks to blk_rq_map_sg() to try to understand
> what is going on... will share more once I have it.

The REQ_WRITE_SAME request, that SCSI is processing on behalf of the
dm_kcopyd_zero() generated bio, has multiple bios (as if merging
occurred).

Curiously, using the dm_kcopyd_zero() interface, I'll see repeat calls
to elv_rq_merge_ok() for a bio with a given bi_sector:

           <...>-10    [000]  6047.137941: elv_rq_merge_ok: WRITE_SAME bio bi_sector=5214336
           <...>-10    [000]  6047.137942: elv_rq_merge_ok: WRITE_SAME bio bi_sector=5214336
           <...>-10    [000]  6047.137942: elv_rq_merge_ok: WRITE_SAME bio bi_sector=5214336
           <...>-10    [000]  6047.137943: elv_rq_merge_ok: WRITE_SAME bio bi_sector=5214336
           <...>-10    [000]  6047.137943: elv_rq_merge_ok: WRITE_SAME bio bi_sector=5214336
           <...>-10    [000]  6047.137944: elv_rq_merge_ok: WRITE_SAME bio bi_sector=5214336
           <...>-10    [000]  6047.137944: elv_rq_merge_ok: WRITE_SAME bio bi_sector=5214336
           <...>-10    [000]  6047.137945: elv_rq_merge_ok: WRITE_SAME bio bi_sector=5214336

           <...>-10    [000]  6047.137958: elv_rq_merge_ok: WRITE_SAME bio bi_sector=5214464
           <...>-10    [000]  6047.137959: elv_rq_merge_ok: WRITE_SAME bio bi_sector=5214464
           <...>-10    [000]  6047.137959: elv_rq_merge_ok: WRITE_SAME bio bi_sector=5214464
           <...>-10    [000]  6047.137960: elv_rq_merge_ok: WRITE_SAME bio bi_sector=5214464
           <...>-10    [000]  6047.137960: elv_rq_merge_ok: WRITE_SAME bio bi_sector=5214464
           <...>-10    [000]  6047.137961: elv_rq_merge_ok: WRITE_SAME bio bi_sector=5214464
           <...>-10    [000]  6047.137961: elv_rq_merge_ok: WRITE_SAME bio bi_sector=5214464
           <...>-10    [000]  6047.137962: elv_rq_merge_ok: WRITE_SAME bio bi_sector=5214464
           <...>-10    [000]  6047.137963: elv_rq_merge_ok: WRITE_SAME bio bi_sector=5214464

So something in the dm-kcopyd and dm-io bio submission path is causing
multiple calls to elv_rq_merge_ok() for the _same_ bio, really quite
bizarre!

If I use the bdev_write_same() interface I only get one elv_rq_merge_ok
for a given bi_sector:

           <...>-2088  [001] 10430.160868: elv_rq_merge_ok: WRITE_SAME bio bi_sector=4652928
           <...>-1990  [001] 10432.565862: elv_rq_merge_ok: WRITE_SAME bio bi_sector=6659456
           <...>-1990  [001] 10434.050269: elv_rq_merge_ok: WRITE_SAME bio bi_sector=6667904
           <...>-1990  [001] 10434.238763: elv_rq_merge_ok: WRITE_SAME bio bi_sector=6668032
           <...>-1990  [001] 10435.852311: elv_rq_merge_ok: WRITE_SAME bio bi_sector=6668160
           <...>-1990  [001] 10437.730371: elv_rq_merge_ok: WRITE_SAME bio bi_sector=6668288
           <...>-1990  [001] 10438.275437: elv_rq_merge_ok: WRITE_SAME bio bi_sector=6668416
           <...>-1990  [001] 10439.737049: elv_rq_merge_ok: WRITE_SAME bio bi_sector=6668544
           <...>-1990  [001] 10440.100221: elv_rq_merge_ok: WRITE_SAME bio bi_sector=6668672
           <...>-1990  [001] 10441.987857: elv_rq_merge_ok: WRITE_SAME bio bi_sector=6668800
           <...>-1990  [001] 10443.875244: elv_rq_merge_ok: WRITE_SAME bio bi_sector=6668928

And as if the above wasn't weird enough, I can avoid the scatter-gather
NULL pointer (in libiscsi_tcp when using the dm_kcopyd_zero() interface)
if I switch elv_rq_merge_ok() to checking the rq->cmd_flags for
REQ_WRITE_SAME, rather than checking the request's first bio's bi_rw:

        /*
         * Don't merge write same requests
         */
-       if ((bio->bi_rw & REQ_WRITE_SAME) || (rq->bio->bi_rw & REQ_WRITE_SAME))
+       if ((bio->bi_rw & REQ_WRITE_SAME) || (rq->cmd_flags & REQ_WRITE_SAME))
                return 0;

That would seem to imply to me that some WRITE SAME bios are losing the
REQ_WRITE_SAME flag in bio->bi_rw!? (or there is some other un-guarded
merge point -- also associated with the issue above).

(It at least starts to explain why I was seeing 512b sg segments at the
end of a WRITE's sg list with 4096b segments... but I still have
unanswered questions I need to sort out).
