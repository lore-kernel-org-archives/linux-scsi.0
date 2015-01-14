From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Wed, 14 Jan 2015 14:23:46 +0200
Message-ID: <54B65FD2.5020907@dev.mellanox.co.il>
References: <54B63F74.2040702@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <54B63F74.2040702@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 1/14/2015 12:05 PM, Bart Van Assche wrote:
> The LIO and SCST SCSI target subsystems consist of the following components:
> * A core that processes SCSI commands and that provides common
> functionality like persistent reservations, LUN masking and an interface
> that allows configuration from user space.
> * Device handlers that allow this core to access SCSI devices, block
> devices and files uniformly as SCSI devices.
> * Target drivers that implement a storage protocol (iSCSI, FC, SRP,
> iSER, FCoE, ...) and that realize the SCSI request and response
> communication between the target system and an initiator system.
>
> A significant amount of code is shared between several LIO target
> drivers and the SCST target drivers that implement the same storage
> protocol. Since there are two sets of these drivers this means that each
> set has to be maintained, extended and tested separately. This means a
> lot of redundant work. The main difference between these two sets of
> drivers is the interface between the target drivers and the SCSI target
> core.  Hence the proposal to discuss the unification of the API between
> SCSI target core and SCSI target drivers. Implementing a single unified
> API would have the following advantages:
> * A single set of target drivers works for both projects which means a
> reduction of the maintenance effort for those who maintain target
> drivers for target driver developers and target driver users.
> * This would increase the size of the user base for the unified target
> drivers.
> * This would reduce the workload for the storage target maintainers.
> * This would motivate the SCST target driver maintainers to contribute
> to the upstream target drivers and to bring the upstream SRP and FCoE
> target drivers to the same feature and stability level as their SCST
> counterparts. In other words, the LIO users would also benefit from this
> work.
> * This effort would also help SCST users by ensuring that all latest
> target driver features are also available to SCST users. Some time ago
> (but no longer today) the LIO QLogic target driver was ahead of the SCST
> QLogic target driver. This motivated an SCST user to port the LIO QLogic
> target driver to SCST. See also Greg Wettstein, New release of
> SCST/Qlogic target interface driver, linux-scsi, April 2014,
> http://marc.info/?l=linux-scsi&m=139649571807085).
>

I would definitely like to talk about this. The upstream SRP target
driver definitely needs more active maintenance.

I still feel that unifying the fabric drivers would not reduce testing
efforts (at least not dramatically) as these drivers will need to work
with two different target core stacks. This even might introduce
additional challenges.

> During the first phase of this initiative the focus will be on the
> QLogic FC, SRP and FCoE target drivers since a significant part of the
> code of these drivers is shared between the two target frameworks.
>

I would like to discuss about unifying the iSCSI and iSER drivers
as well. As you said, This might be more challenging since the two
stacks evolved from different code base and have different architecture,
so it would be nice to discuss if we would really benefit from a unified
implementation in the long run.

Sagi.
