From: Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 1/1] scsi: ufs: Add support for Auto-Hibernate Idle Timer
Date: Mon, 5 Mar 2018 15:08:27 +0200
Message-ID: <4403f748-b7c6-7996-f44d-4a2775d2ffa6@intel.com>
References: <1518782464-28847-1-git-send-email-adrian.hunter@intel.com>
 <1518782464-28847-2-git-send-email-adrian.hunter@intel.com>
 <DM5PR04MB10857B795CCBBD945062DCCDFCC90@DM5PR04MB1085.namprd04.prod.outlook.com>
 <5b6cc5c9-0045-9270-fec7-29ac6d0b4fcb@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5b6cc5c9-0045-9270-fec7-29ac6d0b4fcb@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Avri Altman <Avri.Altman@wdc.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michal Potomski <michalx.potomski@intel.com>, Szymon Mielczarek <szymonx.mielczarek@intel.com>
List-Id: linux-scsi@vger.kernel.org

On 19/02/18 08:35, Adrian Hunter wrote:
> On 18/02/18 11:45, Avri Altman wrote:
>>
>>
>>> -----Original Message-----
>>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>>> owner@vger.kernel.org] On Behalf Of Adrian Hunter
>>> Sent: Friday, February 16, 2018 2:01 PM
>>> To: Vinayak Holikatti <vinholikatti@gmail.com>; Martin K. Petersen
>>> <martin.petersen@oracle.com>; James E.J. Bottomley
>>> <jejb@linux.vnet.ibm.com>
>>> Cc: Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>; Jaegeuk Kim
>>> <jaegeuk@kernel.org>; Bart Van Assche <Bart.VanAssche@wdc.com>; linux-
>>> scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Michal Potomski
>>> <michalx.potomski@intel.com>; Szymon Mielczarek
>>> <szymonx.mielczarek@intel.com>
>>> Subject: [PATCH 1/1] scsi: ufs: Add support for Auto-Hibernate Idle Timer
>>>
>>> UFS host controllers may support an autonomous power management
>>> feature called the Auto-Hibernate Idle Timer. The timer is set to the number
>>> of microseconds of idle time before the UFS host controller will
>>> autonomously put the link into Hibernate state. That will save power at the
>>> expense of increased latency. Any access to the host controller interface
>>> registers will automatically put the link out of Hibernate state. So once
>>> configured, the feature is transparent to the driver.
>>>
>>> Expose the Auto-Hibernate Idle Timer value via SysFS to allow users to
>>> choose between power efficiency or lower latency. Set a default value of
>>> 150 ms.
>>>
>>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>>> ---
>>>  Documentation/ABI/testing/sysfs-driver-ufs | 15 ++++++
>>>  drivers/scsi/ufs/ufs-sysfs.c               | 77 ++++++++++++++++++++++++++++++
>>>  drivers/scsi/ufs/ufshcd.c                  | 26 ++++++++++
>>>  drivers/scsi/ufs/ufshcd.h                  |  3 ++
>>>  drivers/scsi/ufs/ufshci.h                  |  7 +++
>>>  5 files changed, 128 insertions(+)
>>>
>>> diff --git a/Documentation/ABI/testing/sysfs-driver-ufs
>>> b/Documentation/ABI/testing/sysfs-driver-ufs
>>> index 07f1c2f8dbfc..c7f9441079eb 100644
>>> --- a/Documentation/ABI/testing/sysfs-driver-ufs
>>> +++ b/Documentation/ABI/testing/sysfs-driver-ufs
>>> @@ -1,3 +1,18 @@
>>> +What:		/sys/bus/*/drivers/ufshcd/*/auto_hibern8
>>> +Date:		February 2018
>>> +Contact:	linux-scsi@vger.kernel.org
>>> +Description:
>>> +		This file contains the auto-hibernate idle timer setting of a
>>> +		UFS host controller. A value of '-1' means auto-hibernate is
>>> not
>>> +		supported. A value of '0' means auto-hibernate is not
>>> enabled.
>>> +		Otherwise the value is the number of microseconds of idle
>>> time
>>> +		before the UFS host controller will autonomously put the link
>>> +		into hibernate state. That will save power at the expense of
>>> +		increased latency. Note that the hardware supports 10-bit
>>> values
>>> +		with a power-of-ten multiplier which allows a maximum
>>> value of
>>> +		102300000. Refer to the UFS Host Controller Interface
>>> +		specification for more details.
>>> +
>>>  What:
>>> 	/sys/bus/platform/drivers/ufshcd/*/device_descriptor/device_type
>>>  Date:		February 2018
>>>  Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
>>> diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c index
>>> cd7174d2d225..a0e38776dc92 100644

SNIP

>>> @@ -7843,6 +7863,12 @@ int ufshcd_init(struct ufs_hba *hba, void
>>> __iomem *mmio_base, unsigned int irq)
>>>  						UFS_SLEEP_PWR_MODE,
>>>  						UIC_LINK_HIBERN8_STATE);
>>>
>>> +	/* Set the default auto-hiberate idle timer value to 150 ms */
>> Your commit said you are setting an idle timer in microseconds,  Better use usec to avoid confusion? 
> 
> As the SysFS documentation says "Note that the hardware supports 10-bit
> values with a power-of-ten multiplier ... Refer to the UFS Host Controller
> Interface specification for more details.", so 150,000 us is still a value
> of 150 with a power-of-ten multiplier of 3.

Are there any other comments?
