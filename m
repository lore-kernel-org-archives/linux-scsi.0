From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] p00001_scsi_tcq_queue_lock
Date: Fri, 17 Sep 2004 12:55:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <414B2528.1020409@us.ibm.com>
References: <410FD03E.6040305@us.ibm.com> <1091815154.2421.15.camel@mulgrave> <4117846B.7030302@us.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:37062 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S268805AbUIQRzz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Sep 2004 13:55:55 -0400
In-Reply-To: <4117846B.7030302@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James,

Any chance of applying this patch? I think most of the issues you raised
I've answered. This patch certainly does not preclude other LLD's from
quiescing the device before changing the tcqing state if they need to.

Or would you prefer adding code to the scsi core to quiesce the device
before changing its tcqing state? The scsi core could feasibly quiesce the
device, enable or disable tagged queuing, then resume the queue. I haven't
looked at generating a patch for this yet, so I'm not sure how simple it
would be to do what I am suggesting...

Thanks

-Brian


Brian King wrote:
> James Bottomley wrote:
> 
>> On Tue, 2004-08-03 at 10:49, Brian King wrote:
>>
>>> Add locking to scsi_activate_tcq and scsi_deactivate_tcq to fix a race
>>> condition that can occur when disabling tcqing with commands in flight.
>>
>>
>>
>> It's possible to do it like this.  However, we should really quiesce the
>> SCSI device before disabling tcq.  It is not legal in the scsi spec to
>> have both tagged and untagged commands outstanding.  Most drives do the
>> right thing and return BUSY to an untagged request if they have tags in
>> flight.  
> 
> 
> Ok. I agree that we do not want both tagged and untagged requests going 
> to the device. In the case of the ipr driver, the adapter microcode 
> handles this for me. If there are tagged requests outstanding to a 
> device and an untagged request is sent, the tagged requests must first 
> finish, then the untagged request is sent to the device with no other 
> requests outstanding.
> 
>> Also, we have to wait until all tags return before freeing the
>> block layer tag structures...and there's always the devices that do
>> strange things in this situation...
> 

The block layer now handles this appropriately and does not free the tags
until blk_cleanup_queue is called.


> diff -puN include/scsi/scsi_tcq.h~blk_queue_free_tags_bug2 include/scsi/scsi_tcq.h
> --- linux-2.6.8-rc2/include/scsi/scsi_tcq.h~blk_queue_free_tags_bug2	2004-08-02 17:02:43.000000000 -0500
> +++ linux-2.6.8-rc2-bjking1/include/scsi/scsi_tcq.h	2004-08-02 17:02:43.000000000 -0500
> @@ -25,9 +25,13 @@
>   **/
>  static inline void scsi_activate_tcq(struct scsi_device *sdev, int depth)
>  {
> +        unsigned long flags;
> +
>          if (sdev->tagged_supported) {
> +		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
>  		if (!blk_queue_tagged(sdev->request_queue))
>  			blk_queue_init_tags(sdev->request_queue, depth, NULL);
> +		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
>  		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, depth);
>          }
>  }
> @@ -38,8 +42,12 @@ static inline void scsi_activate_tcq(str
>   **/
>  static inline void scsi_deactivate_tcq(struct scsi_device *sdev, int depth)
>  {
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
>  	if (blk_queue_tagged(sdev->request_queue))
>  		blk_queue_free_tags(sdev->request_queue);
> +	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
>  	scsi_adjust_queue_depth(sdev, 0, depth);
>  }
>  
> _

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

