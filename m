From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH V5 1/5] virtio-scsi: redo allocation of target data
Date: Tue, 19 Mar 2013 12:45:06 +0100
Message-ID: <51484FC2.6030601@redhat.com>
References: <1363687057-13580-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<1363687057-13580-2-git-send-email-gaowanlong@cn.fujitsu.com>
	<1363692727.2377.53.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1363692727.2377.53.camel@dabdike.int.hansenpartnership.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Il 19/03/2013 12:32, James Bottomley ha scritto:
> On Tue, 2013-03-19 at 17:57 +0800, Wanlong Gao wrote:
>> From: Paolo Bonzini <pbonzini@redhat.com>
>>
>> virtio_scsi_target_state is now empty.  We will find new uses for it in
>> the next few patches, so this patch does not drop it completely.
>> However, having dropped the sglist flexible array member, we can turn
>> the tgt array-of-pointers into a simple array.  This simplifies the
>> allocation.
>>
>> Even simpler would be to place the virtio_scsi_target_state structs in a
>> flexible array member at the end of struct virtio_scsi.  But we do not
>> do that, because we will place the virtqueues there in the next patches.
> 
> I'm really sorry, but I must have been asleep at the wheel when I let
> code like this go in.  No modern driver should have fixed arrays for
> target information.  The way this is supposed to work is that you have
> entries in the host template for target_alloc and target_destroy.  You
> hook into these and attach your struct virtio_scsi_target_state to
> scsi_target->hostdata,

So that would be sc->device->sdev_target->hostdata.

> which you kmalloc in the target_alloc routine and
> kfree in the target_destroy routine.  Now you get at it from the sdev
> with scsi_target(sdev)->hostdata. No messing around with fixed size
> arrays and bulk memory allocation and no need to pass in the maximum
> target size as a parameter because everything should now happen
> dynamically.

The maximum target size is not a module parameter, it is given by the
host; so the module itself is not placing arbitrary limitation.  Still
it is a good idea to do it like this.

Thanks for the review.

Paolo

> Since you're redoing the code anyway, can you fix it to work this way?
> 
> Thanks,
> 
> James
> 
> 
