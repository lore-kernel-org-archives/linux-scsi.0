From: Sayali Lokhande <sayalil@codeaurora.org>
Subject: Re: [PATCH V6] scsi: ufs: Add configfs support for UFS provisioning
Date: Mon, 30 Jul 2018 13:30:17 +0530
Message-ID: <ed53959d-8832-e2a0-4bf4-bf53ec8191ab@codeaurora.org>
References: <1531734237-27421-1-git-send-email-sayalil@codeaurora.org>
 <1531734237-27421-2-git-send-email-sayalil@codeaurora.org>
 <fc305cad-a0db-9c4b-9d5f-14e8e48a23b3@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fc305cad-a0db-9c4b-9d5f-14e8e48a23b3@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Hunter <adrian.hunter@intel.com>, subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, evgreen@chromium.org, riteshh@codeaurora.org
Cc: linux-scsi@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On 7/17/2018 6:36 PM, Adrian Hunter wrote:
> On 16/07/18 12:43, Sayali Lokhande wrote:
>> This patch adds configfs support to provision UFS device at
>> runtime. This feature can be primarily useful in factory or
>> assembly line as some devices may be required to be configured
>> multiple times during initial system development phase.
>> Configuration Descriptors can be written multiple times until
>> bConfigDescrLock attribute is zero.
>>
>> Configuration descriptor buffer consists of Device and Unit
>> descriptor configurable parameters which are parsed from vendor
>> specific provisioning file and then passed via configfs node at
>> runtime to provision ufs device.
>> CONFIG_CONFIGFS_FS needs to be enabled for using this feature.
>>
>> Usage:
>> 1) To read current configuration descriptor :
>>     cat /config/XXXX.ufshc/ufs_provision
>> 2) To provision ufs device:
>>     echo <config_desc_buf> > /config/XXXX.ufshc/ufs_provision
>>
>> Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
>> ---
>>   Documentation/ABI/testing/configfs-driver-ufs |  18 +++
>>   drivers/scsi/ufs/Kconfig                      |  10 ++
>>   drivers/scsi/ufs/Makefile                     |   1 +
>>   drivers/scsi/ufs/ufs-configfs.c               | 162 ++++++++++++++++++++++++++
>>   drivers/scsi/ufs/ufshcd.c                     |   2 +
>>   drivers/scsi/ufs/ufshcd.h                     |  19 +++
>>   6 files changed, 212 insertions(+)
>>   create mode 100644 Documentation/ABI/testing/configfs-driver-ufs
>>   create mode 100644 drivers/scsi/ufs/ufs-configfs.c
>>
>> diff --git a/Documentation/ABI/testing/configfs-driver-ufs b/Documentation/ABI/testing/configfs-driver-ufs
>> new file mode 100644
>> index 0000000..eeee499c
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/configfs-driver-ufs
>> @@ -0,0 +1,18 @@
>> +What:		/config/ufshcd/ufs_provision
>> +Date:		Jun 2018
>> +KernelVersion:	4.14
>> +Description:
>> +		This file shows the current ufs configuration descriptor set in device.
>> +		This can be used to provision ufs device if bConfigDescrLock is 0.
>> +		For more details, refer 14.1.6.3 Configuration Descriptor and
>> +		Table 14-12 - Unit Descriptor configurable parameters from specs for
>> +		description of each configuration descriptor parameter.
>> +		Configuration descriptor buffer needs to be passed in space separated
>> +		format specificied as below:
>> +		echo <bLength> <bDescriptorIDN> <bConfDescContinue> <bBootEnable>
>> +		<bDescrAccessEn> <bInitPowerMode> <bHighPriorityLUN>
>> +		<bSecureRemovalType> <bInitActiveICCLevel> <wPeriodicRTCUpdate>
>> +		<0Bh:0Fh_ReservedAs_0> <bLUEnable> <bBootLunID> <bLUWriteProtect>
>> +		<bMemoryType> <dNumAllocUnits> <bDataReliability> <bLogicalBlockSize>
>> +		<bProvisioningType> <wContextCapabilities> <0Dh:0Fh_ReservedAs_0>
>> +		> /config/XXXX.ufshc/ufs_provision
>> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
>> index e27b4d4..34d89c2 100644
>> --- a/drivers/scsi/ufs/Kconfig
>> +++ b/drivers/scsi/ufs/Kconfig
>> @@ -100,3 +100,13 @@ config SCSI_UFS_QCOM
>>   
>>   	  Select this if you have UFS controller on QCOM chipset.
>>   	  If unsure, say N.
>> +
>> +config UFS_PROVISION
>> +	tristate "Runtime UFS Provisioning support"
>> +	depends on SCSI_UFSHCD_PLATFORM && CONFIGFS_FS
> Why SCSI_UFSHCD_PLATFORM instead of SCSI_UFSHCD?
SCSI_UFSHCD_PLATFORM in turn depends on SCSI_UFSHCD hence used it, no 
specific reason as such.
I will update it to SCSI_UFSHCD (as provisioning is meant for UFS device 
and scsi_ufshcd config ensures support for ufs devices).
>
> Also please cc me in future revisions.
will do.
