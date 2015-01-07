From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [target:nvme_of 3/3] drivers/target/nvme_of/nvme_of_configfs.c:25:31: sparse: symbol 'nvme_of_fabric_configfs' was not declared. Should it be static?
Date: Wed, 7 Jan 2015 22:26:26 +0200
Message-ID: <8F6AF977-2BD7-46FF-A38D-108AF3C05809@dev.mellanox.co.il>
References: <201501070334.EgwC5iey%fengguang.wu@intel.com> <1420584282.6927.62.camel@haakon3.risingtidesystems.com> <54ACF516.4080602@dev.mellanox.co.il> <1420654943.12144.38.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1420654943.12144.38.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Patil, Kiran" <kiran.patil@intel.com>, "Minturn, Dave B" <dave.b.minturn@intel.com>
List-Id: linux-scsi@vger.kernel.org


>> On Wed, 2015-01-07 at 10:57 +0200, Sagi Grimberg wrote:
>>> On 1/7/2015 12:44 AM, Nicholas A. Bellinger wrote:
>>>> On Wed, 2015-01-07 at 03:35 +0800, kbuild test robot wrote:
>>>> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git nvme_of
>>>> head:   40d8c11927282d59855d645b35798edd97828da5
>>>> commit: 40d8c11927282d59855d645b35798edd97828da5 [3/3] nvme_of: Initial skeleton commit
>>>> reproduce:
>>>>   # apt-get install sparse
>>>>   git checkout 40d8c11927282d59855d645b35798edd97828da5
>>>>   make ARCH=x86_64 allmodconfig
>>>>   make C=1 CF=-D__CHECK_ENDIAN__
>>>> 
>>>> 
>>>> sparse warnings: (new ones prefixed by >>)
>>>> 
>>>>>> drivers/target/nvme_of/nvme_of_configfs.c:25:31: sparse: symbol 'nvme_of_fabric_configfs' was not declared. Should it be static?
>>>> 
>>>> Please review and possibly fold the followup patch.
>>> 
>>> Fixed.  Thanks Fengguang!
>> 
>> Hey Nic,
>> 
>> Hope all is well.
>> 
>> So this skeleton is interesting to me. As this is a fabric module I
>> assume this would be the NVMEoFabrics target mode driver for upstream 
>> which would be able to talk to NVMEoFabrics initiator (which by
>> the way makes LIO something more than a SCSI target - will this be 
>> accepted?).
> 
> That is currently the plan.
> 
> It's still unclear how this will work wrt to existing target code, but
> given the amount of logic that NVMe is borrowing from SCSI on the
> command set side (PR, ALUA, VAAI, DIF), I'm sure there is an opportunity
> for code sharing between NVMe and SCSI based fabrics.

Right, but I assume there will be a different method to provision this stuff given that the target exposes NVME SQs.

> 
>> I'm currently participating in nvmexpress working group defining the
>> standard of protocol, specifically in the context of RDMA (naturally).
> 
> Glad to hear that your involved.  ;)

Should say passively involved, at the moment I'm just following this stuff.

> 
>> I'm interested in taking an active role in this project, It is
>> important to build this layered from day one - separating the fabric 
>> logic (RDMA or FCoE) from the core layer.
>> 
>> Moreover, I know that Mellanox has some plans on accelerating this
>> area in future devices and we are currently looking into ways to
>> do that. I want to see that the SW will be able to support that.
>> 
>> So, Thoughts?
> 
> FYI, Kiran and Dave (CC'ed) from Intel will be driving upstream NVME-OF
> target development.
> 
> I'll be primarily focused on figuring out how NVMe and SCSI can play
> nicely in target-core, and helping out on the NVMe-OF side where
> necessary.

Is there something open that I can start playing around with? What is the status here? I imagine that the initiator is developed as well...

Cheers,
Sagi.
