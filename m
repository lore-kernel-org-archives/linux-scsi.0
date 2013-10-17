From: vaughan <vaughan.cao@oracle.com>
Subject: Re: [Bug] 12.864681  BUG: lock held when returning to user space!
Date: Thu, 17 Oct 2013 10:52:03 +0800
Message-ID: <525F50D3.6090708@oracle.com>
References: <8761tilrl0.fsf@redhat.com> <874n8s2tjz.fsf@redhat.com>	 <5253A9E7.5030707@oracle.com> <52540C7F.8050207@interlog.com> <1381929897.1864.0.camel@dabdike> <525F1601.8080906@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <525F1601.8080906@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dgilbert@interlog.com, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Madper Xie <cxie@redhat.com>, linux-kernel@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 10/17/2013 06:41 AM, Douglas Gilbert wrote:
> That seems to be the case. Vaughan acknowledged the
> problem and forwarded it to me 8 days ago. Yes, it
> seems to be a "no-no" to hold a any kernel semaphore
> when returning to the user space; in this case from
> sg_open(). I was hoping a revised patch might
> appear from Vaughan but to date that has not been
> the case. So with only a few weeks to go before
> lk 3.12 is released, reverting the whole 4 patches
> in that series seems to be the safest course.
>
> Also without a new patch from Vaughan in the next few
> weeks he may also miss the opportunity of getting
> his improved O_EXCL logic into the lk 3.13 series.
>
>
> Thinking about how to solve this problem: a field could
> be added to 'struct sg_device' with one of three states:
> no_opens, non_excl_opens and excl_open. It could be
> manipulated by sg_open() and sg_release() like a
> read-write semaphore. And the faulty 'struct
> rw_semaphore o_sem' in sg_device could be replaced by a
> normal semaphore to protect the manipulation of the new
> three-state field.
> And the new three-state field would replace (or expand)
the 'char exclude' field in struct sg_device .
>
> Doug Gilbert
Hi Doug,

Thanks for providing advice on how to fix this.
However, it seems be still awkward somehow. We have to
1. hold a lock (maybe sg_index_lock or a new one)
2. check
   a) the new three-state field;
   b) if sfp list is empty;
   c) sdp->detached field;
if either condition fails, we may link the open process into o_excl_wait
queue and need wakeup.
if satisfied, we go on.
3. then we release at least sg_index_lock to malloc a new sfp and
initialize.
4. try to acquire sg_index_lock again and add this sfp into sfd_siblings
list if possible.  <== We still have to check at least sdp->detached field
5. update three-state field to reflect the result of Step 4, and wake up
processes waiting in o_excl_wait.

This uncomfortable is introduced by releasing the sg_index_lock in the
middle of check->malloc->add the new sfp struct.

I wanna ask if it is possible to split the sg_add_sfp() into two
functions, sg_init_sfp() and sg_add_sfp2(). We can do all initialize
work in sg_init_sfp()
without any lock and let sg_add_sfp2() only serve lock-check-add in one
way. It seems more convenient for me to understand.
But there is still some questions on this approach:
1. memory consume can be very large if lots of sg_init_sfp in the same time;
2. some field are initialized according to the fields of scsi device sdp
points to, such as low_dma, sg_tablesize, max_sector, phys_segs.
    I know scsi_device_get() would keep the underlying scsi_device
alive, however would these fields change in the gap of our initialize
and add?
    The relationship of sg_device and scsi_device like above said
confuse me somehow...

Thanks,
Vaughan
