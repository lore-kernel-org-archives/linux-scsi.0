From: Robert LeBlanc <robert@leblancnet.us>
Subject: Re: [PATCH 0/7] Enable iSCSI offload drivers to use information from iface.
Date: Mon, 24 Jul 2017 12:32:22 -0600
Message-ID: <CAANLjFra69rJAsOUqdD46-u07YRHjBDKHvdfzR4_FL_8h=HK6g@mail.gmail.com>
References: <20170606180717.5007-1-robert@leblancnet.us> <20170607162839.ludxvmddghx5ocn2@straylight.hirudinean.org>
 <CAANLjFomYCEmjfE7HLAsE7SgVqBKH8KSxYzFqxuV7t8as8+-ZQ@mail.gmail.com>
 <CAANLjFrJ2g8JfB-3bcVwVXxK41rB3aaSeP3ho7J5F0YLO=3sUw@mail.gmail.com>
 <D566FD10.3ABC0%manish.rangankar@cavium.com> <CAANLjFqSB=JuaLJ1Ax-L9B0m-6EW6Hk9ePXGY-pMCK0uKJ6h_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34847 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755198AbdGXScY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2017 14:32:24 -0400
Received: by mail-oi0-f65.google.com with SMTP id q70so4899143oic.2
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2017 11:32:23 -0700 (PDT)
In-Reply-To: <CAANLjFqSB=JuaLJ1Ax-L9B0m-6EW6Hk9ePXGY-pMCK0uKJ6h_Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rangankar, Manish" <Manish.Rangankar@cavium.com>
Cc: Chris Leech <cleech@redhat.com>, "lduncan@suse.com" <lduncan@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, "ogerlitz@mellanox.com" <ogerlitz@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>, "roid@mellanox.com" <roid@mellanox.com>, Doug Ledford <dledford@redhat.com>, "Hefty, Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma <linux-rdma@vger.kernel.org>, "subbu.seetharaman@broadcom.com" <subbu.seetharaman@broadcom.com>, "ketan.mukadam@broadcom.com" <ketan.mukadam@broadcom.com>

On Wed, Jun 14, 2017 at 10:47 AM, Robert LeBlanc <robert@leblancnet.us> wrote:
> On Wed, Jun 14, 2017 at 3:20 AM, Rangankar, Manish
> <Manish.Rangankar@cavium.com> wrote:
>>
>> On 13/06/17 10:19 PM, "Robert LeBlanc" <robert@leblancnet.us> wrote:
>>
>>>On Wed, Jun 7, 2017 at 12:30 PM, Robert LeBlanc <robert@leblancnet.us>
>>>wrote:
>>>> On Wed, Jun 7, 2017 at 10:28 AM, Chris Leech <cleech@redhat.com> wrote:
>>>>> On Tue, Jun 06, 2017 at 12:07:10PM -0600, Robert LeBlanc wrote:
>>>>>> This patchset enables iSCSI offload drivers to have access to the
>>>>>>iface
>>>>>> information provided by iscsid. This allows users to have more control
>>>>>> of how the driver connects to the iSCSI target. iSER is updated to use
>>>>>> iface.ipaddress to set the source IP address if configured. This
>>>>>>allows
>>>>>> iSER to use multiple ports on the same network or in more complicated
>>>>>> routed configurations.
>>>>>>
>>>>>> Since there is already a change to the function parameters, dst_addr
>>>>>> is upgraded to sockaddr_storage so that it is more future proof and
>>>>>>makes
>>>>>> the size of the struct static and not dependent on checking the
>>>>>>SA_FAMILY.
>>>>>>
>>>>>> This is dependent on updates to Open-iSCSI.
>>>>>
>>>>> Hi Robert,
>>>>>
>>>>> I don't think that passing the iface_rec structure directly from the
>>>>> iscsid internals into a netlink message is a good way to go about this.
>>>>> It's really big, there's an embedded list_head with user address
>>>>> pointers that needs to be left out, and there are 32/64-bit layout
>>>>> differences.
>>>>>
>>>>> Let me take a look at how you're proposing using this info for iSER, if
>>>>> it makes sense I think we should come up with a better designed
>>>>> structure for passing the information.
>>>>>
>>>>> Thanks,
>>>>> Chris
>>>>>
>>>>
>>>> Chris,
>>>>
>>>> Thank you for your feedback. I agree that the entire iface is probably
>>>> overkill, it was more of a proof of concept. We are only using the
>>>> ipaddress in the iface for iSER (in my patch), but I could see other
>>>> drivers benefiting from some of the other data in the iface (mac,
>>>> interface_name, vlan, etc) so I didn't want to be too restrictive so
>>>> that it wouldn't have to be extended later. I've not worked on
>>>> userspace/kernel interaction before so I need some guidance to make
>>>> the transition between userspace and kernel versions smoother.
>>>>
>>>> This patchset works for what we need and it is very important for us
>>>> (and I'm sure others once the feature is available) and I'm happy to
>>>> put in the time to get it accepted upstream, I'm just new to kernel
>>>> development and need some guidance.
>>>
>>>Are there other comments/ideas/suggestions specifically from the
>>>iSCSI/iSER guys? I'd like to keep this patch moving.
>>
>> Considering partial iSCSI offload solution (like bnx2i and qedi) point of
>> view, we liked the idea from Hannes to create TAP interface to associate
>> with each iSCSI offload interface, which will allow us to use userspace
>> tools for configuration. I haven't dig into its details yet, but at higher
>> level it looks like this will help us to move away from our dependency
>> over iscsiuio.
>
> I'm having a hard time wrapping my head around this idea. How can
> configuring a TAP (separate Ethernet device) affect the offload NIC. I
> don't see how you can bind to the right interface with the IP address
> or how that is passed to rdma_connect() using a TAP. Is TAP used
> instead of netlink for communicating between userspace and the kernel?
> Obviously by my questions, at the moment I'm not sure how to approach
> this at all and would be the wrong person to make this happen.
>
> If someone can explain how this would work and point to some code that
> does something like this (examples are good for me), I can try to
> create a patch with TAPs. As I mentioned before, this is important for
> us and I'm willing to put in the time to learn and code, but I'm
> really lost at this point.
>
> Thank you,
>
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1

Can we get some more discussion/enlightenment on this? It would be
really nice to have this in 4.14 and time is getting short.

Thanks.

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
