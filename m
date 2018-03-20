From: Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>
Subject: RE: [PATCH V3 1/1] scsi: ufs: Add support for Auto-Hibernate Idle
 Timer
Date: Tue, 20 Mar 2018 13:12:06 +0000
Message-ID: <MWHPR04MB1137BAC16378A1CE7BBD9B679AAB0@MWHPR04MB1137.namprd04.prod.outlook.com>
References: <1521551258-4027-1-git-send-email-adrian.hunter@intel.com>
 <1521551258-4027-2-git-send-email-adrian.hunter@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521551258-4027-2-git-send-email-adrian.hunter@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Hunter <adrian.hunter@intel.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Szymon Mielczarek <szymonx.mielczarek@intel.com>, Alim Akhtar <alim.akhtar@samsung.com>, Alex Lemberg <Alex.Lemberg@wdc.com>, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Adrian Hunter [mailto:adrian.hunter@intel.com]
> Sent: Tuesday, March 20, 2018 3:08 PM
> To: Vinayak Holikatti <vinholikatti@gmail.com>; Martin K. Petersen
> <martin.petersen@oracle.com>; James E.J. Bottomley
> <jejb@linux.vnet.ibm.com>
> Cc: Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>; Jaegeuk Kim
> <jaegeuk@kernel.org>; Bart Van Assche <Bart.VanAssche@wdc.com>; linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Szymon Mielczarek
> <szymonx.mielczarek@intel.com>; Alim Akhtar
> <alim.akhtar@samsung.com>; Alex Lemberg <Alex.Lemberg@wdc.com>;
> Vivek Gautam <vivek.gautam@codeaurora.org>
> Subject: [PATCH V3 1/1] scsi: ufs: Add support for Auto-Hibernate Idle Ti=
mer
>=20
> UFS host controllers may support an autonomous power management
> feature called the Auto-Hibernate Idle Timer. The timer is set to the num=
ber
> of microseconds of idle time before the UFS host controller will
> autonomously put the link into Hibernate state. That will save power at t=
he
> expense of increased latency. Any access to the host controller interface
> registers will automatically put the link out of Hibernate state. So once
> configured, the feature is transparent to the driver.
>=20
> Expose the Auto-Hibernate Idle Timer value via SysFS to allow users to
> choose between power efficiency or lower latency. Set a default value of
> 150 ms.
>=20
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
> ---
>  Documentation/ABI/testing/sysfs-driver-ufs | 14 ++++++
>  drivers/scsi/ufs/ufs-sysfs.c               | 76
> ++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.c                  | 26 ++++++++++
>  drivers/scsi/ufs/ufshcd.h                  |  3 ++
>  drivers/scsi/ufs/ufshci.h                  |  7 +++
>  5 files changed, 126 insertions(+)
>=20
> diff --git a/Documentation/ABI/testing/sysfs-driver-ufs
> b/Documentation/ABI/testing/sysfs-driver-ufs
> index 83735f79e572..016724ec26d5 100644
> --- a/Documentation/ABI/testing/sysfs-driver-ufs
> +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> @@ -1,3 +1,17 @@
> +What:		/sys/bus/*/drivers/ufshcd/*/auto_hibern8
> +Date:		March 2018
> +Contact:	linux-scsi@vger.kernel.org
> +Description:
> +		This file contains the auto-hibernate idle timer setting of a
> +		UFS host controller. A value of '0' means auto-hibernate is
> not
> +		enabled. Otherwise the value is the number of microseconds
> of
> +		idle time before the UFS host controller will autonomously
> put
> +		the link into hibernate state. That will save power at the
> +		expense of increased latency. Note that the hardware
> supports
> +		10-bit values with a power-of-ten multiplier which allows a
> +		maximum value of 102300000. Refer to the UFS Host
> Controller
> +		Interface specification for more details.
> +
>  What:
> 	/sys/bus/platform/drivers/ufshcd/*/device_descriptor/device_type
>  Date:		February 2018
>  Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c =
index
> 4ff9e0b7eba1..8d9332bb7d0c 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -3,6 +3,7 @@
>=20
>  #include <linux/err.h>
>  #include <linux/string.h>
> +#include <linux/bitfield.h>
>  #include <asm/unaligned.h>
>=20
>  #include "ufs.h"
> @@ -117,12 +118,86 @@ static ssize_t spm_target_link_state_show(struct
> device *dev,
>  				ufs_pm_lvl_states[hba-
> >spm_lvl].link_state));
>  }
>=20
> +static void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit) {
> +	unsigned long flags;
> +
> +	if (!(hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT))
> +		return;
> +
> +	spin_lock_irqsave(hba->host->host_lock, flags);
> +	if (hba->ahit =3D=3D ahit)
> +		goto out_unlock;
> +	hba->ahit =3D ahit;
> +	if (!pm_runtime_suspended(hba->dev))
> +		ufshcd_writel(hba, hba->ahit,
> REG_AUTO_HIBERNATE_IDLE_TIMER);
> +out_unlock:
> +	spin_unlock_irqrestore(hba->host->host_lock, flags); }
> +
> +/* Convert Auto-Hibernate Idle Timer register value to microseconds */
> +static int ufshcd_ahit_to_us(u32 ahit) {
> +	int timer =3D FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK, ahit);
> +	int scale =3D FIELD_GET(UFSHCI_AHIBERN8_SCALE_MASK, ahit);
> +
> +	for (; scale > 0; --scale)
> +		timer *=3D UFSHCI_AHIBERN8_SCALE_FACTOR;
> +
> +	return timer;
> +}
> +
> +/* Convert microseconds to Auto-Hibernate Idle Timer register value */
> +static u32 ufshcd_us_to_ahit(unsigned int timer) {
> +	unsigned int scale;
> +
> +	for (scale =3D 0; timer > UFSHCI_AHIBERN8_TIMER_MASK; ++scale)
> +		timer /=3D UFSHCI_AHIBERN8_SCALE_FACTOR;
> +
> +	return FIELD_PREP(UFSHCI_AHIBERN8_TIMER_MASK, timer) |
> +	       FIELD_PREP(UFSHCI_AHIBERN8_SCALE_MASK, scale); }
> +
> +static ssize_t auto_hibern8_show(struct device *dev,
> +				 struct device_attribute *attr, char *buf) {
> +	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> +
> +	if (!(hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT))
> +		return -EOPNOTSUPP;
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n", ufshcd_ahit_to_us(hba-
> >ahit));
> +}
> +
> +static ssize_t auto_hibern8_store(struct device *dev,
> +				  struct device_attribute *attr,
> +				  const char *buf, size_t count)
> +{
> +	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> +	unsigned int timer;
> +
> +	if (!(hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT))
> +		return -EOPNOTSUPP;
> +
> +	if (kstrtouint(buf, 0, &timer))
> +		return -EINVAL;
> +
> +	if (timer > UFSHCI_AHIBERN8_MAX)
> +		return -EINVAL;
> +
> +	ufshcd_auto_hibern8_update(hba, ufshcd_us_to_ahit(timer));
> +
> +	return count;
> +}
> +
>  static DEVICE_ATTR_RW(rpm_lvl);
>  static DEVICE_ATTR_RO(rpm_target_dev_state);
>  static DEVICE_ATTR_RO(rpm_target_link_state);
>  static DEVICE_ATTR_RW(spm_lvl);
>  static DEVICE_ATTR_RO(spm_target_dev_state);
>  static DEVICE_ATTR_RO(spm_target_link_state);
> +static DEVICE_ATTR_RW(auto_hibern8);
>=20
>  static struct attribute *ufs_sysfs_ufshcd_attrs[] =3D {
>  	&dev_attr_rpm_lvl.attr,
> @@ -131,6 +206,7 @@ static ssize_t spm_target_link_state_show(struct
> device *dev,
>  	&dev_attr_spm_lvl.attr,
>  	&dev_attr_spm_target_dev_state.attr,
>  	&dev_attr_spm_target_link_state.attr,
> +	&dev_attr_auto_hibern8.attr,
>  	NULL
>  };
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 3abcd31646eb..facee2b97926 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -41,6 +41,7 @@
>  #include <linux/devfreq.h>
>  #include <linux/nls.h>
>  #include <linux/of.h>
> +#include <linux/bitfield.h>
>  #include "ufshcd.h"
>  #include "ufs_quirks.h"
>  #include "unipro.h"
> @@ -3708,6 +3709,18 @@ static int ufshcd_uic_hibern8_exit(struct ufs_hba
> *hba)
>  	return ret;
>  }
>=20
> +static void ufshcd_auto_hibern8_enable(struct ufs_hba *hba) {
> +	unsigned long flags;
> +
> +	if (!(hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT) || !hba-
> >ahit)
> +		return;
> +
> +	spin_lock_irqsave(hba->host->host_lock, flags);
> +	ufshcd_writel(hba, hba->ahit, REG_AUTO_HIBERNATE_IDLE_TIMER);
> +	spin_unlock_irqrestore(hba->host->host_lock, flags); }
> +
>   /**
>   * ufshcd_init_pwr_info - setting the POR (power on reset)
>   * values in hba power info
> @@ -6307,6 +6320,9 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>  	/* UniPro link is active now */
>  	ufshcd_set_link_active(hba);
>=20
> +	/* Enable Auto-Hibernate if configured */
> +	ufshcd_auto_hibern8_enable(hba);
> +
>  	ret =3D ufshcd_verify_dev_init(hba);
>  	if (ret)
>  		goto out;
> @@ -7391,6 +7407,10 @@ static int ufshcd_resume(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>=20
>  	/* Schedule clock gating in case of no access to UFS device yet */
>  	ufshcd_release(hba);
> +
> +	/* Enable Auto-Hibernate if configured */
> +	ufshcd_auto_hibern8_enable(hba);
> +
>  	goto out;
>=20
>  set_old_link_state:
> @@ -7834,6 +7854,12 @@ int ufshcd_init(struct ufs_hba *hba, void
> __iomem *mmio_base, unsigned int irq)
>  						UFS_SLEEP_PWR_MODE,
>  						UIC_LINK_HIBERN8_STATE);
>=20
> +	/* Set the default auto-hiberate idle timer value to 150 ms */
> +	if (hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT) {
> +		hba->ahit =3D FIELD_PREP(UFSHCI_AHIBERN8_TIMER_MASK,
> 150) |
> +			    FIELD_PREP(UFSHCI_AHIBERN8_SCALE_MASK, 3);
> +	}
> +
>  	/* Hold auto suspend until async scan completes */
>  	pm_runtime_get_sync(dev);
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index
> deb3c5d382e9..8110dcd04d22 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -531,6 +531,9 @@ struct ufs_hba {
>  	struct device_attribute spm_lvl_attr;
>  	int pm_op_in_progress;
>=20
> +	/* Auto-Hibernate Idle Timer register value */
> +	u32 ahit;
> +
>  	struct ufshcd_lrb *lrb;
>  	unsigned long lrb_in_use;
>=20
> diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h index
> 1a1b5d9fe514..bb5d9c7f3353 100644
> --- a/drivers/scsi/ufs/ufshci.h
> +++ b/drivers/scsi/ufs/ufshci.h
> @@ -86,6 +86,7 @@ enum {
>  enum {
>  	MASK_TRANSFER_REQUESTS_SLOTS		=3D 0x0000001F,
>  	MASK_TASK_MANAGEMENT_REQUEST_SLOTS	=3D 0x00070000,
> +	MASK_AUTO_HIBERN8_SUPPORT		=3D 0x00800000,
>  	MASK_64_ADDRESSING_SUPPORT		=3D 0x01000000,
>  	MASK_OUT_OF_ORDER_DATA_DELIVERY_SUPPORT	=3D 0x02000000,
>  	MASK_UIC_DME_TEST_MODE_SUPPORT		=3D 0x04000000,
> @@ -119,6 +120,12 @@ enum {
>  #define MANUFACTURE_ID_MASK	UFS_MASK(0xFFFF, 0)
>  #define PRODUCT_ID_MASK		UFS_MASK(0xFFFF, 16)
>=20
> +/* AHIT - Auto-Hibernate Idle Timer */
> +#define UFSHCI_AHIBERN8_TIMER_MASK		GENMASK(9, 0)
> +#define UFSHCI_AHIBERN8_SCALE_MASK		GENMASK(12, 10)
> +#define UFSHCI_AHIBERN8_SCALE_FACTOR		10
> +#define UFSHCI_AHIBERN8_MAX			(1023 * 100000)
> +
>  /*
>   * IS - Interrupt Status - 20h
>   */
> --
> 1.9.1
