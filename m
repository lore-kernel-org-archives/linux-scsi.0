From: Joe Eykholt <jeykholt@cisco.com>
Subject: Re: [PATCH] fix vulnerability in file operations of scsi target interface
Date: Thu, 11 Nov 2010 10:47:21 -0800
Message-ID: <4CDC3A39.6020801@cisco.com>
References: <AANLkTin+Epf5WuD9sV=kNNgVXo5No4euF=6VoSOkFK12@mail.gmail.com>	<4CD98FC6.9000108@cisco.com> <AANLkTimN+nhY+SDApbcpJ41z9jPTu6jj0RmYjNYNyo5+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-4.cisco.com ([171.68.10.86]:47331 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942Ab0KKSrW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2010 13:47:22 -0500
In-Reply-To: <AANLkTimN+nhY+SDApbcpJ41z9jPTu6jj0RmYjNYNyo5+@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-scsi@vger.kernel.org



On 11/11/10 5:45 AM, Hillf Danton wrote:
> On Wed, Nov 10, 2010 at 2:15 AM, Joe Eykholt <jeykholt@cisco.com> wrote:
>> On 11/9/10 6:01 AM, Hillf Danton wrote:
>>> Ring buffers are setup for exchanging data between K and U spaces, but
>>> they could not survive multiple open operations.
>>>
>>> The registered misc interface is monitored and prevented from multiple
>>> opens for fixing the vulnerability.
>>>
>>> A typo, -BUSY, is also cleaned up.
>>>
>>> btw, the ring buffers could be setup in a per file manner?
>>>
>>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>>> ---
>>>
>>> --- a/drivers/scsi/scsi_tgt_if.c      2010-09-13 07:07:38.000000000 +0800
>>> +++ b/drivers/scsi/scsi_tgt_if.c      2010-11-09 21:42:48.000000000 +0800
>>> @@ -85,7 +85,7 @@ static int tgt_uspace_send_event(u32 typ
>>>       if (!ev->hdr.status)
>>>               tgt_ring_idx_inc(ring);
>>>       else
>>> -             err = -BUSY;
>>> +             err = -EBUSY;
>>>
>>>       spin_unlock_irqrestore(&ring->tr_lock, flags);
>>>
>>> @@ -319,20 +319,33 @@ static int tgt_mmap(struct file *filp, s
>>>       return err;
>>>  }
>>>
>>> +static unsigned long tgt_open_cnt = 0;
>>> +
>>>  static int tgt_open(struct inode *inode, struct file *file)
>>>  {
>>> +     if (tgt_open_cnt)
>>> +             return -EBUSY;
>>> +     tgt_open_cnt++;
>>
>> Since there's no locking, there's still a tiny hole where
>> simultaneous opens could succeed.  Consider using an atomic.
>> Good find and good fix otherwise.
>>
> Would you please, Joe, show the atomic version?
> thanks//Hillf

I take it back.  There's no good atomic version.
The best I came up with was:
In open:
	if (atomic_inc_return(&tgt_open_cnt) != 1)
		return -EBUSY;

Then in release (since its the last close):
	atomic_set(&tgt_open_cnt, 0);

There's still a hole that this might overflow, and I don't see
the best way to fix that without test-and-set or compare-and-swap.
We can't just decrement it since the last close will clear it.

So the best thing would be to use your
version but protect it with the tx_ring.tr_lock.
I would rename tgt_open_cnt to just tgt_busy,
and make it a u8 since it will be 1 or 0.

	int error = 0;
	
	spin_lock_irq(&tx_ring.tr_lock);
	if (tgt_busy)
		error = -EBUSY;
	else {
		tgt_busy = 1;
		tx_ring.tr_idx = 0;
		rx_ring.tr_idx = 0;
	}
	spin_unlock_irq(&tx_ring.tr_lock);
	return error;

Then in release:
	spin_lock_irq(&tx_ring.tr_lock);
	tgt_busy = 0;
	spin_unlock_irq(&tx_ring.tr_lock);

>>> +
>>>       tx_ring.tr_idx = rx_ring.tr_idx = 0;
>>>
>>>       cycle_kernel_lock();
>>>       return 0;
>>>  }
>>>
>>> +static int tgt_release(struct inode *inode, struct file *file)
>>> +{
>>> +     tgt_open_cnt--;
>>> +     return 0;
>>> +}
>>> +
>>>  static const struct file_operations tgt_fops = {
>>>       .owner          = THIS_MODULE,
>>>       .open           = tgt_open,
>>>       .poll           = tgt_poll,
>>>       .write          = tgt_write,
>>>       .mmap           = tgt_mmap,
>>> +     .release        = tgt_release,
>>>  };
>>>
>>>  static struct miscdevice tgt_miscdev = {
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
