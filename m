From: Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [RFC-v2 0/4] tcm_vhost+cmwq fabric driver code for-3.6
Date: Wed, 18 Jul 2012 08:42:21 -0500
Message-ID: <5006BD3D.7090104@us.ibm.com>
References: <1342041304-29728-1-git-send-email-nab@linux-iscsi.org> <20120717150548.GA11587@redhat.com>  <5005B52E.20509@us.ibm.com> <1342561819.18004.470.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1342561819.18004.470.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 07/17/2012 04:50 PM, Nicholas A. Bellinger wrote:
> On Tue, 2012-07-17 at 13:55 -0500, Anthony Liguori wrote:
>> On 07/17/2012 10:05 AM, Michael S. Tsirkin wrote:
>>> On Wed, Jul 11, 2012 at 09:15:00PM +0000, Nicholas A. Bellinger wrote:
>
> <SNIP>
>
>>>
>>> It still seems not 100% clear whether this driver will have major
>>> userspace using it. And if not, it would be very hard to support a driver
>>> when recent userspace does not use it in the end.
>>
>> I don't think this is a good reason to exclude something from the kernel.
>> However, there are good reasons why this doesn't make sense for something like
>> QEMU--specifically because we have a large number of features in our block layer
>> that tcm_vhost would bypass.
>>
>
> I can definitely appreciate your concern here as the QEMU maintainer.
>
>> But perhaps it makes sense for something like native kvm tool.  And if it did go
>> into the kernel, we would certainly support it in QEMU.
>>
>
> ...
>
>> But I do think the kernel should carefully consider whether it wants to support
>> an interface like this.  This an extremely complicated ABI with a lot of subtle
>> details around state and compatibility.
>>
>> Are you absolutely confident that you can support a userspace application that
>> expects to get exactly the same response from all possible commands in 20 kernel
>> versions from now?  Virtualization requires absolutely precise compatibility in
>> terms of bugs and features.  This is probably not something the TCM stack has
>> had to consider yet.
>>
>
> We most certainly have thought about long term userspace compatibility
> with TCM.  Our userspace code (that's now available in all major
> distros) is completely forward-compatible with new fabric modules such
> as tcm_vhost.  No update required.

I'm not sure we're talking about the same thing when we say compatibility.

I'm not talking about the API.  I'm talking about the behavior of the commands 
that tcm_vhost supports.

If you add support for a new command, you need to provide userspace a way to 
disable this command.  If you change what gets reported for VPD, you need to 
provide userspace a way to make VPD look like what it did in a previous version.

Basically, you need to be able to make a TCM device behave 100% the same as it 
did in an older version of the kernel.

This is unique to virtualization due to live migration.  If you migrate from a 
3.6 kernel to a 3.8 kernel, you need to make sure that the 3.8 kernel's TCM 
device behaves exactly like the 3.6 kernel because the guest that is interacting 
with it does not realize that live migration happened.

Yes, you can add knobs via configfs to control this behavior, but I think the 
question is, what's the plan for this?

BTW, I think this is a good thing to cover in Documentation/vhost/tcm_vhost.txt. 
  I think that's probably the only change that's needed here.

Regards,

Anthony Liguori

>
> Also, by virtue of the fact that we are using configfs + rtslib (python
> object library) on top, it's very easy to keep any type of compatibility
> logic around in python code.  With rtslib, we are able to hide configfs
> ABI changes from higher level apps.
>
> So far we've had a track record of 100% userspace ABI compatibility in
> mainline since .38, and I don't intend to merge a patch that breaks this
> any time soon.  But if that ever happens, apps using rtslib are not
> going to be effected.
>
>>> I think a good idea for 3.6 would be to make it depend on CONFIG_STAGING.
>>> Then we don't commit to an ABI.
>>
>> I think this is a good idea.  Even if it goes in, a really clear policy would be
>> needed wrt the userspace ABI.
>>
>> While tcm_vhost is probably more useful than vhost_blk, it's a much more complex
>> ABI to maintain.
>>
>
> As far as I am concerned, the kernel API (eg: configfs directory layout)
> as it is now in sys/kernel/config/target/vhost/ is not going to change.
> It's based on the same drivers/target/target_core_fabric_configfs.c
> generic layout that we've had since .38.
>
> The basic functional fabric layout in configfs is identical (with fabric
> dependent WWPN naming of course) regardless of fabric driver, and by
> virtue of being generic it means we can add things like fabric dependent
> attributes + parameters in the future for existing fabrics without
> breaking userspace.
>
> So while I agree the ABI is more complex than vhost-blk, the logic in
> target_core_fabric_configfs.c is a basic ABI fabric definition that we
> are enforcing across all fabric modules in mainline for long term
> compatibility.
>
> --nab
>
