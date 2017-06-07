From: Robert LeBlanc <robert@leblancnet.us>
Subject: Re: [PATCH 0/7] Enable iSCSI offload drivers to use information from iface.
Date: Wed, 7 Jun 2017 12:30:33 -0600
Message-ID: <CAANLjFomYCEmjfE7HLAsE7SgVqBKH8KSxYzFqxuV7t8as8+-ZQ@mail.gmail.com>
References: <20170606180717.5007-1-robert@leblancnet.us> <20170607162839.ludxvmddghx5ocn2@straylight.hirudinean.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:34429 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751814AbdFGSae (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2017 14:30:34 -0400
Received: by mail-ot0-f193.google.com with SMTP id a2so1720715oth.1
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jun 2017 11:30:34 -0700 (PDT)
In-Reply-To: <20170607162839.ludxvmddghx5ocn2@straylight.hirudinean.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Leech <cleech@redhat.com>, Robert LeBlanc <robert@leblancnet.us>, lduncan@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, ogerlitz@mellanox.com, Sagi Grimberg <sagi@grimberg.me>, roid@mellanox.com, Doug Ledford <dledford@redhat.com>, "Hefty, Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma <linux-rdma@vger.kernel.org>, subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com, QLogic-Storage-Upstream@qlogic.com, varun@chelsio.com

On Wed, Jun 7, 2017 at 10:28 AM, Chris Leech <cleech@redhat.com> wrote:
> On Tue, Jun 06, 2017 at 12:07:10PM -0600, Robert LeBlanc wrote:
>> This patchset enables iSCSI offload drivers to have access to the iface
>> information provided by iscsid. This allows users to have more control
>> of how the driver connects to the iSCSI target. iSER is updated to use
>> iface.ipaddress to set the source IP address if configured. This allows
>> iSER to use multiple ports on the same network or in more complicated
>> routed configurations.
>>
>> Since there is already a change to the function parameters, dst_addr
>> is upgraded to sockaddr_storage so that it is more future proof and makes
>> the size of the struct static and not dependent on checking the SA_FAMILY.
>>
>> This is dependent on updates to Open-iSCSI.
>
> Hi Robert,
>
> I don't think that passing the iface_rec structure directly from the
> iscsid internals into a netlink message is a good way to go about this.
> It's really big, there's an embedded list_head with user address
> pointers that needs to be left out, and there are 32/64-bit layout
> differences.
>
> Let me take a look at how you're proposing using this info for iSER, if
> it makes sense I think we should come up with a better designed
> structure for passing the information.
>
> Thanks,
> Chris
>

Chris,

Thank you for your feedback. I agree that the entire iface is probably
overkill, it was more of a proof of concept. We are only using the
ipaddress in the iface for iSER (in my patch), but I could see other
drivers benefiting from some of the other data in the iface (mac,
interface_name, vlan, etc) so I didn't want to be too restrictive so
that it wouldn't have to be extended later. I've not worked on
userspace/kernel interaction before so I need some guidance to make
the transition between userspace and kernel versions smoother.

This patchset works for what we need and it is very important for us
(and I'm sure others once the feature is available) and I'm happy to
put in the time to get it accepted upstream, I'm just new to kernel
development and need some guidance.

Thanks,
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
