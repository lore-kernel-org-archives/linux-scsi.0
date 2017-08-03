From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 00/13] mpt3sas driver NVMe support:
Date: Thu, 3 Aug 2017 08:48:55 +0200
Message-ID: <3bc9f695-e6a5-6e98-69ae-81e0f3b41181@suse.de>
References: <1500038560-11231-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <e679a449-90c3-d2e1-2b31-1387cf414e09@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e679a449-90c3-d2e1-2b31-1387cf414e09@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On 08/02/2017 10:14 AM, Hannes Reinecke wrote:
> On 07/14/2017 03:22 PM, Suganath Prabu S wrote:
>> Ventura Series controller are Tri-mode. The controller and
>> firmware are capable of supporting NVMe devices and
>> PCIe switches to be connected with the controller. This
>> patch set adds driver level support for NVMe devices and
>> PCIe switches.
>>
>> Suganath Prabu S (13):
>>   mpt3sas: Update MPI Header
>>   mpt3sas: Add nvme device support in slave alloc, target alloc and
>>     probe
>>   mpt3sas: SGL to PRP Translation for I/Os to NVMe  devices
>>   mpt3sas: Added support for nvme encapsulated request message.
>>   mpt3sas: API 's to support NVMe drive addition to SML
>>   mpt3sas: API's to remove nvme drive from sml
>>   mpt3sas: Handle NVMe PCIe device related events generated            
>>        from firmware.
>>   mpt3sas: Set NVMe device queue depth as 128
>>   mpt3sas: scan and add nvme device after controller reset
>>   mpt3as: Add-Task-management-debug-info-for-NVMe-drives.
>>   mpt3sas: NVMe drive support for BTDHMAPPING ioctl command and log
>>     info
>>   mpt3sas: Fix nvme drives checking for tlr.
>>   mpt3sas: Update mpt3sas driver version.
>>
>>  drivers/scsi/mpt3sas/mpi/mpi2.h          |   43 +-
>>  drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h     |  647 ++++++++++-
>>  drivers/scsi/mpt3sas/mpi/mpi2_init.h     |   11 +-
>>  drivers/scsi/mpt3sas/mpi/mpi2_ioc.h      |  331 ++++++-
>>  drivers/scsi/mpt3sas/mpi/mpi2_pci.h      |  142 +++
>>  drivers/scsi/mpt3sas/mpi/mpi2_tool.h     |   14 +-
>>  drivers/scsi/mpt3sas/mpt3sas_base.c      |  710 +++++++++++-
>>  drivers/scsi/mpt3sas/mpt3sas_base.h      |  171 +++-
>>  drivers/scsi/mpt3sas/mpt3sas_config.c    |  100 ++
>>  drivers/scsi/mpt3sas/mpt3sas_ctl.c       |  158 ++-
>>  drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 1874 ++++++++++++++++++++++++++++--
>>  drivers/scsi/mpt3sas/mpt3sas_warpdrive.c |    2 +-
>>  12 files changed, 4063 insertions(+), 140 deletions(-)
>>  create mode 100644 drivers/scsi/mpt3sas/mpi/mpi2_pci.h
>>
> I'm not happy with this approach.
> NVMe devices should _not_ appear as SCSI devices; this will just confuse
> matters _and_ will be incompatible with 'normal' NVMe devices.
> 
> Rather I would like to see the driver to hook into the existing NVMe
> framework (which essentially means to treat the mpt3sas as a weird
> NVMe-over-Fabrics HBA), and expose the NVMe devices like any other NVMe HBA.
> 
> I'm sorry that you'll have to redo your patchset (again), but this is
> the only way I see how this patchset can be brought forward.
> 
> I'd be happy to discuss implementation details with you.
> 
After discussion with Broadcom it turns out that the NVMe passthrough
functionality of the current firmware is rather limited and wouldn't be
suitable for full NVMe device support.
And one of the goals is to have intermixed NVMe and SCSI support,
possibly with RAID thrown in for good measure.
So my idea of exposing the NVMe devices directly won't work, and I'll
have to retract my above comment.

But I'll continue to bug Broadcom; maybe we'll be getting NVMe device
support eventually :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
