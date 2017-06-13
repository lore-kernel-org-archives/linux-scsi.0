From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: [PATCH 0/7] Enable iSCSI offload drivers to use information from iface.
Date: Tue, 13 Jun 2017 10:49:22 -0600
Message-ID: <CAANLjFrJ2g8JfB-3bcVwVXxK41rB3aaSeP3ho7J5F0YLO=3sUw@mail.gmail.com>
References: <20170606180717.5007-1-robert@leblancnet.us> <20170607162839.ludxvmddghx5ocn2@straylight.hirudinean.org>
 <CAANLjFomYCEmjfE7HLAsE7SgVqBKH8KSxYzFqxuV7t8as8+-ZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFomYCEmjfE7HLAsE7SgVqBKH8KSxYzFqxuV7t8as8+-ZQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, lduncan-IBi9RG/b67k@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, subbu.seetharaman-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, ketan.mukadam-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, jitendra.bhivare-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, QLogic-Storage-Upstream-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, varun-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 7, 2017 at 12:30 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
> On Wed, Jun 7, 2017 at 10:28 AM, Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> On Tue, Jun 06, 2017 at 12:07:10PM -0600, Robert LeBlanc wrote:
>>> This patchset enables iSCSI offload drivers to have access to the iface
>>> information provided by iscsid. This allows users to have more control
>>> of how the driver connects to the iSCSI target. iSER is updated to use
>>> iface.ipaddress to set the source IP address if configured. This allows
>>> iSER to use multiple ports on the same network or in more complicated
>>> routed configurations.
>>>
>>> Since there is already a change to the function parameters, dst_addr
>>> is upgraded to sockaddr_storage so that it is more future proof and makes
>>> the size of the struct static and not dependent on checking the SA_FAMILY.
>>>
>>> This is dependent on updates to Open-iSCSI.
>>
>> Hi Robert,
>>
>> I don't think that passing the iface_rec structure directly from the
>> iscsid internals into a netlink message is a good way to go about this.
>> It's really big, there's an embedded list_head with user address
>> pointers that needs to be left out, and there are 32/64-bit layout
>> differences.
>>
>> Let me take a look at how you're proposing using this info for iSER, if
>> it makes sense I think we should come up with a better designed
>> structure for passing the information.
>>
>> Thanks,
>> Chris
>>
>
> Chris,
>
> Thank you for your feedback. I agree that the entire iface is probably
> overkill, it was more of a proof of concept. We are only using the
> ipaddress in the iface for iSER (in my patch), but I could see other
> drivers benefiting from some of the other data in the iface (mac,
> interface_name, vlan, etc) so I didn't want to be too restrictive so
> that it wouldn't have to be extended later. I've not worked on
> userspace/kernel interaction before so I need some guidance to make
> the transition between userspace and kernel versions smoother.
>
> This patchset works for what we need and it is very important for us
> (and I'm sure others once the feature is available) and I'm happy to
> put in the time to get it accepted upstream, I'm just new to kernel
> development and need some guidance.

Are there other comments/ideas/suggestions specifically from the
iSCSI/iSER guys? I'd like to keep this patch moving.

Thanks.

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
