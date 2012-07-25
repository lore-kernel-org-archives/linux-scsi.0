From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: virtio(-scsi) vs. chained sg_lists (was Re: [PATCH] scsi: virtio-scsi:
 Fix address translation failure of HighMem pages used by sg list)
Date: Wed, 25 Jul 2012 22:16:36 +0300
Message-ID: <50104614.3080002@panasas.com>
References: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com> <500FB1DE.1000100@redhat.com> <500FBAE8.2050107@panasas.com> <500FBF37.50603@redhat.com> <500FE7D2.7070101@panasas.com> <500FEB63.3000709@redhat.com> <500FF412.3090600@panasas.com> <50100014.2010109@redhat.com> <50101091.5090909@panasas.com> <50103043.5050508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <50103043.5050508@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Wang Sen <senwang@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, stefanha@linux.vnet.ibm.com, mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
List-Id: linux-scsi@vger.kernel.org

On 07/25/2012 08:43 PM, Paolo Bonzini wrote:

> Il 25/07/2012 17:28, Boaz Harrosh ha scritto:
>>> 1) what I get is a scsi_cmnd which contains an N-element scatterlist.
>>>
>>> 2) virtio-scsi has to build the "packet" that is passed to the hardware
>>> (it does not matter that the hardware is virtual).  This packet (per
>>> virtio-scsi spec) has an N+1-element scatterlist, where the first
>>> element is a request descriptor (struct virtio_scsi_cmd_req), and the
>>> others describe the written data.
>>
>> Then "virtio-scsi spec" is crap. It overloads the meaning of
>> "struct scatterlist" of the first element in an array. to be a
>> "struct virtio_scsi_cmd_req".
> 
> What the holy fuck?  The first element simply _points_ to the "struct
> virtio_scsi_cmd_req", just like subsequent elements point to the data.
> 
> And the protocol of the device is _not_ a struct scatterlist[].  The
> virtio _API_ takes that array and converts to a series of physical
> address + offset pairs.
> 
>> Since you need to change the standard to support chaining then
>> it is a good time to fix this.
> 
> Perhaps it is a good time for you to read the virtio spec.  You are
> making a huge confusion between the LLD->virtio interface and the
> virtio->hardware interface.  I'm talking only of the former.
> 
>>> 3) virtio takes care of converting the "packet" from a scatterlist
>>> (which currently must be a flat one) to the hardware representation.
>>> Here a walk is inevitable, so we don't care about this walk.
>>
>> "hardware representation" you mean aio or biovec, what ever the
>> IO submission path uses at the host end?
> 
> No, I mean the way the virtio spec encodes the physical address + offset
> pairs.
> 
> I stopped reading here.
> 


The picture confused me. It looked like the first element is the virtio_scsi_cmd_req
not an sgilist-element that points to the struct's buffer.

In that case then yes your plan of making a two-elements fragment that points to the
original scsi-sglist is perfect. All you have to do is that, and all you have to do
at virtio is use the sg_for_each macro and you are done.

You don't need any sglist allocation or reshaping. And you can easily support
chaining. Looks like order of magnitude more simple then what you do now
So what is the problem?

And BTW you won't need that new __sg_set_page API anymore.

> Paolo


Cheers
Boaz
