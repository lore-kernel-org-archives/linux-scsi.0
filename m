From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 1/2] block: Avoid invoking blk_run_queue() recursively
Date: Sat, 23 Feb 2013 13:34:53 +0100
Message-ID: <5128B76D.4040004@acm.org>
References: <51274C2F.6070500@acm.org> <51274C76.8080007@acm.org> <20130222181416.GO3570@htj.dyndns.org> <5127BF8E.9080604@acm.org> <20130222190129.GD25064@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:57263 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758827Ab3BWMe7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Feb 2013 07:34:59 -0500
In-Reply-To: <20130222190129.GD25064@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, James Bottomley <JBottomley@parallels.com>

On 02/22/13 20:01, Jens Axboe wrote:
> That'd be fine. I agree with Tejun that just returning is error prone
> and could cause hard-to-debug hangs or stalls. So something ala
>
>          if (blk_queue(dead))
>                  return;
>          else if (q->request_fn_active) {
>                  blk_delay_queue(q, 0);
>                  return;
>          }
>
> would work. Alternatively, you could mark the queue as needing a re-run,
> so any existing runner of it would notice and clear this flag and re-run
> the queue. But that's somewhat more fragile, and since it isn't a
> hot/performance path, I suspect the simple "just re-run me soon" is good
> enough.

I'm worried that in the device mapper the approach using 
blk_delay_queue() could trigger a queue run after the final dm_put(). 
And I'm also afraid that that approach could trigger several needless 
context switches before q->request_fn_active finally drops to zero. So 
the approach with the "need re-run" flag seems preferable to me. But 
maybe I'm overlooking something ?

Bart.


