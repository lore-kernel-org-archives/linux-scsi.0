From: okaya@codeaurora.org
Subject: Re: [PATCH V3 2/2] scsi: hpsa: drop shutdown callback
Date: Wed, 30 May 2018 21:08:42 -0400
Message-ID: <3ebb873ea4658275e7fa89c01cd8bfe1@codeaurora.org>
References: <1527542471-10316-1-git-send-email-okaya@codeaurora.org>
 <1527542471-10316-2-git-send-email-okaya@codeaurora.org>
 <51bb7b82-c4a1-435c-7668-639db96d76e1@finnie.org>
 <af772e6434e645f4a42d22821442a3bd@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <af772e6434e645f4a42d22821442a3bd@microsemi.com>
Sender: stable-owner@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: Ryan Finnie <ryan@finnie.org>, linux-pci@vger.kernel.org, timur@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "esc.storagedev" <esc.storagedev@microsemi.com>, "open list:HEWLETT-PACKARD SMART ARRAY RAID DRIVER (hpsa)" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2018-05-30 15:25, Don Brace wrote:
>> -----Original Message-----
>> From: Ryan Finnie [mailto:ryan@finnie.org]
>> Sent: Tuesday, May 29, 2018 8:50 PM
>> To: Sinan Kaya <okaya@codeaurora.org>; linux-pci@vger.kernel.org;
>> timur@codeaurora.org
>> Cc: linux-arm-msm@vger.kernel.org; 
>> linux-arm-kernel@lists.infradead.org;
>> stable@vger.kernel.org; Don Brace <don.brace@microsemi.com>; James 
>> E.J.
>> Bottomley <jejb@linux.vnet.ibm.com>; Martin K. Petersen
>> <martin.petersen@oracle.com>; esc.storagedev
>> <esc.storagedev@microsemi.com>; open list:HEWLETT-PACKARD SMART ARRAY
>> RAID DRIVER (hpsa) <linux-scsi@vger.kernel.org>; open list <linux-
>> kernel@vger.kernel.org>
>> Subject: Re: [PATCH V3 2/2] scsi: hpsa: drop shutdown callback
>> 
>> EXTERNAL EMAIL
>> 
>> 
>> On 05/28/2018 02:21 PM, Sinan Kaya wrote:
>> > 'Commit cc27b735ad3a ("PCI/portdrv: Turn off PCIe services during
>> > shutdown")' has been added to kernel to shutdown pending PCIe port
>> > service interrupts during reboot so that a newly started kexec kernel
>> > wouldn't observe pending interrupts.
>> >
>> > pcie_port_device_remove() is disabling the root port and switches by
>> > calling pci_disable_device() after all PCIe service drivers are shutdown.
>> >
>> > This has been found to cause crashes on HP DL360 Gen9 machines during
>> > reboot due to hpsa driver not clearing the bus master bit during the
>> > shutdown procedure by calling pci_disable_device().
>> >
>> > Drop the shutdown API and do an orderly clean up by using the remove.
>> >
>> > Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
>> > Link: https://bugzilla.kernel.org/show_bug.cgi?id=199779
>> > Fixes: cc27b735ad3a ("PCI/portdrv: Turn off PCIe services during shutdown")
>> > Cc: stable@vger.kernel.org
>> > Reported-by: Ryan Finnie <ryan@finnie.org>
>> 
>> Tested successfully on DL360 Gen9 and DL380 Gen9.
>> 
>> Tested-by: Ryan Finnie <ryan@finnie.org>
> 
> The shutdown path issues a cache flush to the controller.
> Without this flush, you will see "Dirty Cache" messages at POST.
> It is best to keep the shutdown path.
> 

I have seen that shutdown() is also called from remove().

remove() is supposed to do a safe cleanup too. If it is leaving the hw 
in inconsistent state even though it is c lling shutdown , it is yet 
another bug.

> Thanks,
> Don Brace
> ESC - Smart Storage
> Microsemi Corporation
