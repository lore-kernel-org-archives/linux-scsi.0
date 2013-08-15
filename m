From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [RFC PATCH 2/2] ata: acpi: rework the ata acpi bind support
Date: Thu, 15 Aug 2013 09:33:28 +0800
Message-ID: <520C2FE8.90009@intel.com>
References: <1374731223-28685-1-git-send-email-aaron.lu@intel.com> <1374731223-28685-3-git-send-email-aaron.lu@intel.com> <20130725145229.GB26107@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20130725145229.GB26107@mtj.dyndns.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Aaron Lu <aaron.lwe@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Wu <jeff.wu@amd.com>, Shane Huang <shane.huang@amd.com>, Matthew Garrett <mjg@redhat.com>, Holger Macht <holger@homac.de>, Zhang Rui <rui.zhang@intel.com>, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/25/2013 10:52 PM, Tejun Heo wrote:
> On Thu, Jul 25, 2013 at 01:47:03PM +0800, Aaron Lu wrote:
>> Binding ACPI handle to SCSI device has several drawbacks, namely:
>> 1 During ATA device initialization time, ACPI handle will be needed
>>   while SCSI devices are not created yet. So each time ACPI handle is
>>   needed, instead of retrieving the handle by ACPI_HANDLE macro,
>>   a namespace scan is performed to find the handle for the corresponding
>>   ATA device. This is inefficient, and also expose a restriction on
>>   calling path not holding any lock.
>> 2 The binding to SCSI device tree makes code complex, while at the same
>>   time doesn't bring us any benefit. All ACPI handlings are still done
>>   in ATA module, not in SCSI.
>>
>> Rework the ATA ACPI binding code to bind ACPI handle to ATA transport
>> devices(ATA port and ATA device). The binding needs to be done only once,
>> since the ATA transport devices do not go away with hotplug. And due to
>> this, the flush_work call in hotplug handler for ATA bay is no longer
>> needed.
> 
> I like it but am wondering why we weren't doing this before.  Was the
> acpi support added before we made ata objects proper devices?
 
Hi Tejun,

This has been quiet for some time, may I know your opinion on this?

Thanks,
Aaron
