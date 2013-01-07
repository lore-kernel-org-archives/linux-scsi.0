From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 1/5] virtio: add functions for piecewise addition of
	buffers
Date: Mon, 07 Jan 2013 15:27:46 +0100
Message-ID: <50EADB62.1010704@redhat.com>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
	<1355833972-20319-2-git-send-email-pbonzini@redhat.com>
	<87r4m45g88.fsf@rustcorp.com.au> <50E54DC0.4040609@redhat.com>
	<87pq1h508k.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <87pq1h508k.fsf@rustcorp.com.au>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org, mst@redhat.com, hutao@cn.fujitsu.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, stefanha@redhat.com, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Il 07/01/2013 01:02, Rusty Russell ha scritto:
> Paolo Bonzini <pbonzini@redhat.com> writes:
>> Il 02/01/2013 06:03, Rusty Russell ha scritto:
>>> Paolo Bonzini <pbonzini@redhat.com> writes:
>>>> The virtqueue_add_buf function has two limitations:
>>>>
>>>> 1) it requires the caller to provide all the buffers in a single call;
>>>>
>>>> 2) it does not support chained scatterlists: the buffers must be
>>>> provided as an array of struct scatterlist;
>>>
>>> Chained scatterlists are a horrible interface, but that doesn't mean we
>>> shouldn't support them if there's a need.
>>>
>>> I think I once even had a patch which passed two chained sgs, rather
>>> than a combo sg and two length numbers.  It's very old, but I've pasted
>>> it below.
>>>
>>> Duplicating the implementation by having another interface is pretty
>>> nasty; I think I'd prefer the chained scatterlists, if that's optimal
>>> for you.
>>
>> Unfortunately, that cannot work because not all architectures support
>> chained scatterlists.
> 
> WHAT?  I can't figure out what an arch needs to do to support this?

It needs to use the iterator functions in its DMA driver.

> All archs we care about support them, though, so I think we can ignore
> this issue for now.

Kind of... In principle all QEMU-supported arches can use virtio, and
the speedup can be quite useful.  And there is no Kconfig symbol for SG
chains that I can use to disable virtio-scsi on unsupported arches. :/

Paolo

>> (Also, as you mention chained scatterlists are horrible.  They'd happen
>> to work for virtio-scsi, but not for virtio-blk where the response
>> status is part of the footer, not the header).
> 
> We lost that debate 5 years ago, so we hack around it as needed.  We can
> add helpers to append if we need.
