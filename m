From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] BUG: nr_phys_segments cannot be less than
	nr_hw_segments
Date: Thu, 02 Oct 2008 10:03:33 -0500
Message-ID: <1222959814.3222.5.camel@localhost.localdomain>
References: <200810021959.33616.knikanth@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755088AbYJBPEi@vger.kernel.org>
In-Reply-To: <200810021959.33616.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2008-10-02 at 19:59 +0530, Nikanth Karthikesan wrote:
> This is a follow-up to my earlier mail http://lkml.org/lkml/2008/9/23/294 
> ([PATCH] BUG: ll_merge_requests_fn() updates req->nr_phys_segments wrongly)
> 
> It is possible for the merging code to create lesser no of phys segments than 
> hw segments, but every hw segment needs atleast one new phys segment. This 
> triggers the BUG() on scsi_init_sgtable() as blk_rq_map_sg() returns more no 
> of segments than rq->nr_phys_segments
> 
> The following blktrace shows a sequence of bio's to trigger such condition on 
> my machine with max_sectors_kb=512 & max_hw_sectors_kb=32767.

Um, don't you mean this the other way around?  I can see this problem
occurring if the block layer gets tricked into doing a physical merge
where sector limits forbid a virtual merge.

The bug would appear to be that we sometimes only look at q->max_sectors
when deciding on mergability.  Either we have to insist on max_sectors
<= hw_max_sectors, or we have to start using min(q->max_sectors,
q->max_hw_sectors) for this.

James
