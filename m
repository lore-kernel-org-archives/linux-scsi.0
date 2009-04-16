From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 14/17] scsi: replace custom rq mapping with	blk_rq_map_kern_sgl()
Date: Thu, 16 Apr 2009 15:30:29 +0900
Message-ID: <49E6D085.3050601@kernel.org>
References: <49E6A0B5.2090704@kernel.org> <20090416054457.GA13226@liondog.tnic> <49E6CB0D.3060307@kernel.org> <20090416062904.GA13487@liondog.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:40016 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbZDPGap (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Apr 2009 02:30:45 -0400
In-Reply-To: <20090416062904.GA13487@liondog.tnic>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: petkovbb@gmail.com, Tejun Heo <tj@kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, bharrosh@panasas.com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

Borislav Petkov wrote:
> Hi Tejun,
> 
> On Thu, Apr 16, 2009 at 03:07:09PM +0900, Tejun Heo wrote:
> 
> [..]
> 
>> There was another problem.  If we use blk_rq_map_kern() the failed rq
>> must be finished after the sense rq is finished because that's when
>> the bio is copied back if it was copied.  Before sense_rq completion,
>> the sense buffer doesn't contain any valid data.
> 
> Well, as an idea, we could just postpone the completion of the failed rq
> in:
> 
> if (sense && uptodate)
>         ide_cd_complete_failed_rq(drive, rq);
> 
> and put that just after
> 
> ide_complete_rq(drive, uptodate ? 0 : -EIO, nsectors << 9);
> 
> line in cdrom_newpc_intr(). This way, we can copy back the sense data
> safely and then kill the rq.

Yeah, already have that in my patch.

> The only problem I fear with changes like that is that later some subtle
> interactions come about with some device which shouldn't normally
> happen. This is old code, you know, which still needs lots of scrubbing.
> It's like walking on a minefield :).

:-)

-- 
tejun
