From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] virtio: Reduce BUG if total_sg > virtqueue size to
 WARN.
Date: Fri, 11 Aug 2017 20:36:59 +0200
Message-ID: <a7220de9-0a51-0548-03c0-236e37aa2ef4@redhat.com>
References: <20170810164035.19963-1-rjones@redhat.com>
 <20170810164035.19963-2-rjones@redhat.com>
 <20170811001447-mutt-send-email-mst@kernel.org>
 <20170810213038.GC20914@redhat.com>
 <20170811003107-mutt-send-email-mst@kernel.org>
 <20170810213511.GB10017@redhat.com>
 <20170811003621-mutt-send-email-mst@kernel.org>
 <64d3c483-076b-1362-b284-30dda704f80c@redhat.com>
 <20170811201843-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170811201843-mutt-send-email-mst@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Richard W.M. Jones" <rjones@redhat.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, jasowang@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On 11/08/2017 19:23, Michael S. Tsirkin wrote:
> On Fri, Aug 11, 2017 at 04:09:26PM +0200, Paolo Bonzini wrote:
>> On 10/08/2017 23:41, Michael S. Tsirkin wrote:
>>>>> Then we probably should fail probe if vq size is too small.
>>>> What does this mean?
>>>
>>> We must prevent driver from submitting s/g lists > vq size to device.
>>
>> What is the rationale for the limit?
> 
> So the host knows what it needs to support.
> 
>> both virtio-blk and virtio-scsi transmit their own value for the
>> maximum sg list size (max_seg in virtio-scsi, seg_max in virtio-blk).
> 
> No other device has it, and it seemed like a good idea to
> limit it generally at the time.
> 
> we can fix the spec to relax the requirement for blk and scsi -
> want to submit a proposal? Alternatively, add a generic field
> for that.

Yes, I can submit a proposal.  blk and scsi are the ones that are most
likely to have very long sg lists.

When I was designing scsi I just copied that field from blk. :)

Paolo
