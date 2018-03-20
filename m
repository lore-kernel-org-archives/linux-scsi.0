From: Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH V2 1/1] scsi: ufs: Add support for Auto-Hibernate Idle
 Timer
Date: Tue, 20 Mar 2018 14:09:40 +0200
Message-ID: <30e5b7fa-778a-3db6-c423-d99df4081fc3@intel.com>
References: <1521446478-12656-1-git-send-email-adrian.hunter@intel.com>
 <1521446478-12656-2-git-send-email-adrian.hunter@intel.com>
 <MWHPR04MB113751510AF964BF944455C59AAB0@MWHPR04MB1137.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <MWHPR04MB113751510AF964BF944455C59AAB0@MWHPR04MB1137.namprd04.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Szymon Mielczarek <szymonx.mielczarek@intel.com>, Alim Akhtar <alim.akhtar@samsung.com>, Alex Lemberg <Alex.Lemberg@wdc.com>, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

On 20/03/18 13:56, Stanislav Nijnikov wrote:
> 
> 
>> -----Original Message-----
>> From: Adrian Hunter [mailto:adrian.hunter@intel.com]
>> Sent: Monday, March 19, 2018 10:01 AM
>> To: Vinayak Holikatti <vinholikatti@gmail.com>; Martin K. Petersen
>> <martin.petersen@oracle.com>; James E.J. Bottomley
>> <jejb@linux.vnet.ibm.com>
>> Cc: Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>; Jaegeuk Kim
>> <jaegeuk@kernel.org>; Bart Van Assche <Bart.VanAssche@wdc.com>; linux-
>> scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Szymon Mielczarek
>> <szymonx.mielczarek@intel.com>; Alim Akhtar
>> <alim.akhtar@samsung.com>; Alex Lemberg <Alex.Lemberg@wdc.com>;
>> Vivek Gautam <vivek.gautam@codeaurora.org>
>> Subject: [PATCH V2 1/1] scsi: ufs: Add support for Auto-Hibernate Idle Timer
>>
>> UFS host controllers may support an autonomous power management
>> feature called the Auto-Hibernate Idle Timer. The timer is set to the number
>> of microseconds of idle time before the UFS host controller will
>> autonomously put the link into Hibernate state. That will save power at the
>> expense of increased latency. Any access to the host controller interface
>> registers will automatically put the link out of Hibernate state. So once
>> configured, the feature is transparent to the driver.
>>
>> Expose the Auto-Hibernate Idle Timer value via SysFS to allow users to
>> choose between power efficiency or lower latency. Set a default value of
>> 150 ms.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  Documentation/ABI/testing/sysfs-driver-ufs | 15 ++++++
>>  drivers/scsi/ufs/ufs-sysfs.c               | 77
>> ++++++++++++++++++++++++++++++
>>  drivers/scsi/ufs/ufshcd.c                  | 26 ++++++++++
>>  drivers/scsi/ufs/ufshcd.h                  |  3 ++
>>  drivers/scsi/ufs/ufshci.h                  |  7 +++
>>  5 files changed, 128 insertions(+)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-driver-ufs
>> b/Documentation/ABI/testing/sysfs-driver-ufs
>> index 83735f79e572..a4142329cc34 100644
>> --- a/Documentation/ABI/testing/sysfs-driver-ufs
>> +++ b/Documentation/ABI/testing/sysfs-driver-ufs
>> @@ -1,3 +1,18 @@
>> +What:		/sys/bus/*/drivers/ufshcd/*/auto_hibern8
>> +Date:		February 2018
>> +Contact:	linux-scsi@vger.kernel.org
>> +Description:
>> +		This file contains the auto-hibernate idle timer setting of a
>> +		UFS host controller. A value of '-1' means auto-hibernate is
>> not
>> +		supported. A value of '0' means auto-hibernate is not
>> enabled.
>> +		Otherwise the value is the number of microseconds of idle
>> time
>> +		before the UFS host controller will autonomously put the link
>> +		into hibernate state. That will save power at the expense of
>> +		increased latency. Note that the hardware supports 10-bit
>> values
>> +		with a power-of-ten multiplier which allows a maximum
>> value of
>> +		102300000. Refer to the UFS Host Controller Interface
>> +		specification for more details.
>> +
>>  What:
>> 	/sys/bus/platform/drivers/ufshcd/*/device_descriptor/device_type
>>  Date:		February 2018
>>  Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
>> diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c index
>> 4ff9e0b7eba1..17ad661b1cb5 100644
>> --- a/drivers/scsi/ufs/ufs-sysfs.c
>> +++ b/drivers/scsi/ufs/ufs-sysfs.c
>> @@ -3,6 +3,7 @@
>>
>>  #include <linux/err.h>
>>  #include <linux/string.h>
>> +#include <linux/bitfield.h>
>>  #include <asm/unaligned.h>
>>
>>  #include "ufs.h"
>> @@ -117,12 +118,87 @@ static ssize_t spm_target_link_state_show(struct
>> device *dev,
>>  				ufs_pm_lvl_states[hba-
>>> spm_lvl].link_state));
>>  }
>>
>> +static void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit) {
>> +	unsigned long flags;
>> +
>> +	if (!(hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT))
>> +		return;
>> +
>> +	spin_lock_irqsave(hba->host->host_lock, flags);
>> +	if (hba->ahit == ahit)
>> +		goto out_unlock;
>> +	hba->ahit = ahit;
>> +	if (!pm_runtime_suspended(hba->dev))
>> +		ufshcd_writel(hba, hba->ahit,
>> REG_AUTO_HIBERNATE_IDLE_TIMER);
>> +out_unlock:
>> +	spin_unlock_irqrestore(hba->host->host_lock, flags); }
>> +
>> +/* Convert Auto-Hibernate Idle Timer register value to microseconds */
>> +static int ufshcd_ahit_to_us(u32 ahit) {
>> +	int timer = FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK, ahit);
>> +	int scale = FIELD_GET(UFSHCI_AHIBERN8_SCALE_MASK, ahit);
>> +
>> +	for (; scale > 0; --scale)
>> +		timer *= UFSHCI_AHIBERN8_SCALE_FACTOR;
>> +
>> +	return timer;
>> +}
>> +
>> +/* Convert microseconds to Auto-Hibernate Idle Timer register value */
>> +static u32 ufshcd_us_to_ahit(unsigned int timer) {
>> +	unsigned int scale;
>> +
>> +	for (scale = 0; timer > UFSHCI_AHIBERN8_TIMER_MASK; ++scale)
>> +		timer /= UFSHCI_AHIBERN8_SCALE_FACTOR;
>> +
>> +	return FIELD_PREP(UFSHCI_AHIBERN8_TIMER_MASK, timer) |
>> +	       FIELD_PREP(UFSHCI_AHIBERN8_SCALE_MASK, scale); }
>> +
>> +static ssize_t auto_hibern8_show(struct device *dev,
>> +				 struct device_attribute *attr, char *buf) {
>> +	struct ufs_hba *hba = dev_get_drvdata(dev);
>> +	int timer = -1;
>> +
>> +	if (hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT)
>> +		timer = ufshcd_ahit_to_us(hba->ahit);
> I think it's better to return EOPNOTSUPP when the feature is not supported than to show "-1".

OK

>> +
>> +	return snprintf(buf, PAGE_SIZE, "%d\n", timer); }
>> +
>> +static ssize_t auto_hibern8_store(struct device *dev,
>> +				  struct device_attribute *attr,
>> +				  const char *buf, size_t count)
>> +{
>> +	struct ufs_hba *hba = dev_get_drvdata(dev);
>> +	unsigned int timer;
>> +
>> +	if (!(hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT))
>> +		return -EOPNOTSUPP;
>> +
>> +	if (kstrtouint(buf, 0, &timer))
>> +		return -EINVAL;
>> +
>> +	if (timer > UFSHCI_AHIBERN8_MAX)
>> +		return -EINVAL;
>> +
>> +	ufshcd_auto_hibern8_update(hba, ufshcd_us_to_ahit(timer));
>> +
>> +	return count;
>> +}
>> +
>>  static DEVICE_ATTR_RW(rpm_lvl);
>>  static DEVICE_ATTR_RO(rpm_target_dev_state);
>>  static DEVICE_ATTR_RO(rpm_target_link_state);
>>  static DEVICE_ATTR_RW(spm_lvl);
>>  static DEVICE_ATTR_RO(spm_target_dev_state);
>>  static DEVICE_ATTR_RO(spm_target_link_state);
>> +static DEVICE_ATTR_RW(auto_hibern8);
>>
>>  static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
>>  	&dev_attr_rpm_lvl.attr,
>> @@ -131,6 +207,7 @@ static ssize_t spm_target_link_state_show(struct
>> device *dev,
>>  	&dev_attr_spm_lvl.attr,
>>  	&dev_attr_spm_target_dev_state.attr,
>>  	&dev_attr_spm_target_link_state.attr,
>> +	&dev_attr_auto_hibern8.attr,
>>  	NULL
>>  };
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
>> 3abcd31646eb..facee2b97926 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -41,6 +41,7 @@
>>  #include <linux/devfreq.h>
>>  #include <linux/nls.h>
>>  #include <linux/of.h>
>> +#include <linux/bitfield.h>
>>  #include "ufshcd.h"
>>  #include "ufs_quirks.h"
>>  #include "unipro.h"
>> @@ -3708,6 +3709,18 @@ static int ufshcd_uic_hibern8_exit(struct ufs_hba
>> *hba)
>>  	return ret;
>>  }
>>
>> +static void ufshcd_auto_hibern8_enable(struct ufs_hba *hba) {
>> +	unsigned long flags;
>> +
>> +	if (!(hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT) || !hba-
>>> ahit)
>> +		return;
>> +
>> +	spin_lock_irqsave(hba->host->host_lock, flags);
>> +	ufshcd_writel(hba, hba->ahit, REG_AUTO_HIBERNATE_IDLE_TIMER);
>> +	spin_unlock_irqrestore(hba->host->host_lock, flags); }
>> +
>>   /**
>>   * ufshcd_init_pwr_info - setting the POR (power on reset)
>>   * values in hba power info
>> @@ -6307,6 +6320,9 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>>  	/* UniPro link is active now */
>>  	ufshcd_set_link_active(hba);
>>
>> +	/* Enable Auto-Hibernate if configured */
>> +	ufshcd_auto_hibern8_enable(hba);
>> +
>>  	ret = ufshcd_verify_dev_init(hba);
>>  	if (ret)
>>  		goto out;
>> @@ -7391,6 +7407,10 @@ static int ufshcd_resume(struct ufs_hba *hba,
>> enum ufs_pm_op pm_op)
>>
>>  	/* Schedule clock gating in case of no access to UFS device yet */
>>  	ufshcd_release(hba);
>> +
>> +	/* Enable Auto-Hibernate if configured */
>> +	ufshcd_auto_hibern8_enable(hba);
>> +
>>  	goto out;
>>
>>  set_old_link_state:
>> @@ -7834,6 +7854,12 @@ int ufshcd_init(struct ufs_hba *hba, void
>> __iomem *mmio_base, unsigned int irq)
>>  						UFS_SLEEP_PWR_MODE,
>>  						UIC_LINK_HIBERN8_STATE);
>>
>> +	/* Set the default auto-hiberate idle timer value to 150 ms */
>> +	if (hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT) {
>> +		hba->ahit = FIELD_PREP(UFSHCI_AHIBERN8_TIMER_MASK,
>> 150) |
>> +			    FIELD_PREP(UFSHCI_AHIBERN8_SCALE_MASK, 3);
>> +	}
>> +
>>  	/* Hold auto suspend until async scan completes */
>>  	pm_runtime_get_sync(dev);
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index
>> deb3c5d382e9..8110dcd04d22 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -531,6 +531,9 @@ struct ufs_hba {
>>  	struct device_attribute spm_lvl_attr;
>>  	int pm_op_in_progress;
>>
>> +	/* Auto-Hibernate Idle Timer register value */
>> +	u32 ahit;
>> +
>>  	struct ufshcd_lrb *lrb;
>>  	unsigned long lrb_in_use;
>>
>> diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h index
>> 1a1b5d9fe514..bb5d9c7f3353 100644
>> --- a/drivers/scsi/ufs/ufshci.h
>> +++ b/drivers/scsi/ufs/ufshci.h
>> @@ -86,6 +86,7 @@ enum {
>>  enum {
>>  	MASK_TRANSFER_REQUESTS_SLOTS		= 0x0000001F,
>>  	MASK_TASK_MANAGEMENT_REQUEST_SLOTS	= 0x00070000,
>> +	MASK_AUTO_HIBERN8_SUPPORT		= 0x00800000,
>>  	MASK_64_ADDRESSING_SUPPORT		= 0x01000000,
>>  	MASK_OUT_OF_ORDER_DATA_DELIVERY_SUPPORT	= 0x02000000,
>>  	MASK_UIC_DME_TEST_MODE_SUPPORT		= 0x04000000,
>> @@ -119,6 +120,12 @@ enum {
>>  #define MANUFACTURE_ID_MASK	UFS_MASK(0xFFFF, 0)
>>  #define PRODUCT_ID_MASK		UFS_MASK(0xFFFF, 16)
>>
>> +/* AHIT - Auto-Hibernate Idle Timer */
>> +#define UFSHCI_AHIBERN8_TIMER_MASK		GENMASK(9, 0)
>> +#define UFSHCI_AHIBERN8_SCALE_MASK		GENMASK(12, 10)
>> +#define UFSHCI_AHIBERN8_SCALE_FACTOR		10
>> +#define UFSHCI_AHIBERN8_MAX			(1023 * 100000)
>> +
>>  /*
>>   * IS - Interrupt Status - 20h
>>   */
>> --
>> 1.9.1
> Please fix all checkpatch errors.

I don't get any checkpatch errors.  Can you list them?
