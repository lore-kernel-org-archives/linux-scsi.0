From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: calling scsi_adjust_queue_depth() during I/O...
Date: Fri, 05 Aug 2005 11:32:07 -0500
Message-ID: <1123259528.5003.36.camel@mulgrave>
References: <20050804234155.GJ13374@plap.qlogic.org>
	 <20050805075751.GN9369@suse.de> <20050805110911.GA22867@htj.dyndns.org>
	 <42F350E6.2090109@gmail.com>  <20050805123301.GA3311@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:19407 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263021AbVHEQce (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Aug 2005 12:32:34 -0400
In-Reply-To: <20050805123301.GA3311@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <axboe@suse.de>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-08-05 at 21:33 +0900, Tejun Heo wrote:
>  Here's the fix.  It basically revives bqt->real_max_depth sans
> allocation optimization in init_tag_map.  I've also added a comment
> explicitly noting that tag map cannot be shrunk to prevent other
> morons like me.  :-( Please try this one and let me know how it works.
> If this is the correct fix, I'll repost properly to Jens and lkml with
> detailed explanation on how it was broken in the original code and how
> I broke it with my previous patch.  Sorry.

Actually, if you really want to adjust the array size downwards, there's
a way we can do it:

- If the bits that would be lost on shrinkage are all zero at the time
blk_queue_resize_tags() is called, that means that there are no
outstanding tags up there and the array can be shrunk immediately.

- If there are outstanding tags between the new and the old depth, the
array can be shrunk when the last one of these returns, say in
blk_rq_end_tag()

James


