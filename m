From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] block: fix blk_queue_end_tag()
Date: Wed, 21 Dec 2011 06:20:29 -0700
Message-ID: <20111221132029.GK20129@parisc-linux.org>
References: <20111220233117.17757.71139.stgit@localhost6.localdomain6> <4EF17DC4.5010008@tao.ma> <alpine.SOC.1.00.1112210835010.6858@math.ut.ee> <4EF18129.7030407@tao.ma> <CABE8wwtrq=SuuhAvNDjpSbfPGE+N4cWjjmVGWq8UzaH6sM9kRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:55149 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab1LUNUc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Dec 2011 08:20:32 -0500
Content-Disposition: inline
In-Reply-To: <CABE8wwtrq=SuuhAvNDjpSbfPGE+N4cWjjmVGWq8UzaH6sM9kRg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Tao Ma <tm@tao.ma>, Meelis Roos <mroos@linux.ee>, axboe@kernel.dk, Tao Ma <boyu.mt@taobao.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Ed Nadolski <edmund.nadolski@intel.com>

On Tue, Dec 20, 2011 at 11:30:14PM -0800, Williams, Dan J wrote:
> @@ -284,16 +284,7 @@ void blk_queue_end_tag(struct request_queue *q,
> struct request *rq)
>         struct blk_queue_tag *bqt = q->queue_tags;
>         int tag = rq->tag;
> 
> -       BUG_ON(tag == -1);
> -
> -       if (unlikely(tag >= bqt->max_depth)) {
> -               /*
> -                * This can happen after tag depth has been reduced.
> -                * But tag shouldn't be larger than real_max_depth.
> -                */
> -               WARN_ON(tag >= bqt->real_max_depth);
> -               return;
> -       }
> +       BUG_ON(tag == -1 || tag > bqt->real_max_depth);

or ...

-	int tag = rq->tag;
+	unsigned tag = rq->tag;
+	BUG_ON(tag >= bqt->real_max_depth);

since tags in the range INT_MIN to -2 are also a bug, right?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
