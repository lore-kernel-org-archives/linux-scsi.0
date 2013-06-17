From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 07/14] scsi_transport_srp: Add transport layer error handling
Date: Mon, 17 Jun 2013 09:29:46 +0200
Message-ID: <51BEBAEA.4080202@acm.org>
References: <51B87501.4070005@acm.org> <51B8777B.5050201@acm.org> <51BA20ED.6040200@mellanox.com> <51BB1857.7040802@acm.org> <51BB5A04.3080901@mellanox.com> <51BC3945.9030900@acm.org> <51BEAA40.9070908@suse.de> <51BEB4FF.9000607@acm.org> <51BEB770.9030305@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:60844 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab3FQH3t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jun 2013 03:29:49 -0400
In-Reply-To: <51BEB770.9030305@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Vu Pham <vuhuong@mellanox.com>, Roland Dreier <roland@kernel.org>, David Dillow <dillowda@ornl.gov>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>

On 06/17/13 09:14, Hannes Reinecke wrote:
> On 06/17/2013 09:04 AM, Bart Van Assche wrote:
>> I agree that the value of fast_io_fail_tmo should be kept small.
>> Although as you explained changing the SCSI device state into
>> SDEV_BLOCK doesn't help for I/O that has already been queued on a
>> failed path, I think it's still useful for I/O that is queued after
>> the fast_io_fail timer has been started and before that timer has
>> expired.
>
> Why, but of course.
>
> The typical scenario would be:
> -> detect link-loss
> -> call scsi_block_request()
> -> start dev_loss_tmo and fast_io_fail_tmo
>
> -> When fast_io_fail_tmo triggers:
>     -> Abort all outstanding requests
>
> -> When dev_loss_tmo triggers:
>     -> Abort all outstanding requests
>     -> Remove/disable the I_T nexus
>     -> call scsi_unblock_request()
>
> However, if and whether multipath detects SDEV_BLOCK doesn't
> guarantee a fast failover; in fact is was only added rather recently
> as it's not a big win in most cases.

Even if setting the state SDEV_BLOCK doesn't help much with improving 
failover time, it still has the advantage over using 
scsi_block_requests() that it can be overridden by a user via sysfs.

Bart.

