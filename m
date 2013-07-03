From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3 07/13] scsi_transport_srp: Add transport layer error
 handling
Date: Wed, 03 Jul 2013 18:00:06 +0200
Message-ID: <51D44A86.5050000@acm.org>
References: <51D41C03.4020607@acm.org> <51D41F13.6060203@acm.org> <1372864458.24238.32.camel@frustration.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:52428 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab3GCQAK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jul 2013 12:00:10 -0400
In-Reply-To: <1372864458.24238.32.camel@frustration.ornl.gov>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Dillow <dave@thedillows.org>
Cc: Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@kernel.org>, Vu Pham <vuhuong@mellanox.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, Jinpu Wang <jinpu.wang@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>

On 07/03/13 17:14, David Dillow wrote:
> On Wed, 2013-07-03 at 14:54 +0200, Bart Van Assche wrote:
>> +int srp_tmo_valid(int fast_io_fail_tmo, int dev_loss_tmo)
>> +{
>> +	return (fast_io_fail_tmo < 0 || dev_loss_tmo < 0 ||
>> +		fast_io_fail_tmo < dev_loss_tmo) &&
>> +		fast_io_fail_tmo <= SCSI_DEVICE_BLOCK_MAX_TIMEOUT &&
>> +		dev_loss_tmo < LONG_MAX / HZ ? 0 : -EINVAL;
>> +}
>> +EXPORT_SYMBOL_GPL(srp_tmo_valid);
>
> This would have been more readable:
>
> int srp_tmo_valid(int fast_io_fail_tmp, int dev_loss_tmo)
> {
> 	/* Fast IO fail must be off, or no greater than the max timeout */
> 	if (fast_io_fail_tmo > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
> 		return -EINVAL;
>
> 	/* Device timeout must be off, or fit into jiffies */
> 	if (dev_loss_tmo >= LONG_MAX / HZ)
> 		return -EINVAL;
>
> 	/* Fast IO must trigger before device loss, or one of the
> 	 * timeouts must be disabled.
> 	 */
> 	if (fast_io_fail_tmo < 0 || dev_loss_tmo < 0)
> 		return 0;
> 	if (fast_io_fail < dev_loss_tmo)
> 		return 0;
>
> 	return -EINVAL;	
> }

Isn't that a matter of personal taste which of the above two is more 
clear ? It might also depend on the number of mathematics courses in 
someones educational background :-)

> Though, now that I've unpacked it -- I don't think it is OK for
> dev_loss_tmo to be off, but fast IO to be on? That drops another
> conditional.

The combination of dev_loss_tmo off and reconnect_delay > 0 worked fine 
in my tests. An I/O failure was detected shortly after the cable to the 
target was pulled. I/O resumed shortly after the cable to the target was 
reinserted.

> Also, FC caps dev_loss_tmo at SCSI_DEVICE_BLOCK_MAX_TIMEOUT if
> fail_io_fast_tmo is off; I agree with your reasoning about leaving it
> unlimited if fast fail is on, but does that still hold if it is off?

I think setting dev_loss_tmo to a large value only makes sense if the 
value of reconnect_delay is not too large. Setting both to a large value 
would result in slow recovery after a transport layer failure has been 
corrected.

Bart.

