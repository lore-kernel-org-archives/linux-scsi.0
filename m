From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH 1/1] scsi: ufs: Add support for Auto-Hibernate Idle Timer
Date: Sun, 18 Feb 2018 09:45:54 +0000
Message-ID: <DM5PR04MB10857B795CCBBD945062DCCDFCC90@DM5PR04MB1085.namprd04.prod.outlook.com>
References: <1518782464-28847-1-git-send-email-adrian.hunter@intel.com>
 <1518782464-28847-2-git-send-email-adrian.hunter@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:14403 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751285AbeBRJqD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Feb 2018 04:46:03 -0500
In-Reply-To: <1518782464-28847-2-git-send-email-adrian.hunter@intel.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Hunter <adrian.hunter@intel.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michal Potomski <michalx.potomski@intel.com>, Szymon Mielczarek <szymonx.mielczarek@intel.com>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Adrian Hunter
> Sent: Friday, February 16, 2018 2:01 PM
> To: Vinayak Holikatti <vinholikatti@gmail.com>; Martin K. Petersen
> <martin.petersen@oracle.com>; James E.J. Bottomley
> <jejb@linux.vnet.ibm.com>
> Cc: Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>; Jaegeuk Kim
> <jaegeuk@kernel.org>; Bart Van Assche <Bart.VanAssche@wdc.com>; linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Michal Potomski
> <michalx.potomski@intel.com>; Szymon Mielczarek
> <szymonx.mielczarek@intel.com>
> Subject: [PATCH 1/1] scsi: ufs: Add support for Auto-Hibernate Idle Timer
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
> ---
>  Documentation/ABI/testing/sysfs-driver-ufs | 15 ++++++
>  drivers/scsi/ufs/ufs-sysfs.c               | 77 ++++++++++++++++++++++++=
++++++
>  drivers/scsi/ufs/ufshcd.c                  | 26 ++++++++++
>  drivers/scsi/ufs/ufshcd.h                  |  3 ++
>  drivers/scsi/ufs/ufshci.h                  |  7 +++
>  5 files changed, 128 insertions(+)
>=20
> diff --git a/Documentation/ABI/testing/sysfs-driver-ufs
> b/Documentation/ABI/testing/sysfs-driver-ufs
> index 07f1c2f8dbfc..c7f9441079eb 100644
> --- a/Documentation/ABI/testing/sysfs-driver-ufs
> +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> @@ -1,3 +1,18 @@
> +What:		/sys/bus/*/drivers/ufshcd/*/auto_hibern8
> +Date:		February 2018
> +Contact:	linux-scsi@vger.kernel.org
> +Description:
> +		This file contains the auto-hibernate idle timer setting of a
> +		UFS host controller. A value of '-1' means auto-hibernate is
> not
> +		supported. A value of '0' means auto-hibernate is not
> enabled.
> +		Otherwise the value is the number of microseconds of idle
> time
> +		before the UFS host controller will autonomously put the link
> +		into hibernate state. That will save power at the expense of
> +		increased latency. Note that the hardware supports 10-bit
> values
> +		with a power-of-ten multiplier which allows a maximum
> value of
> +		102300000. Refer to the UFS Host Controller Interface
> +		specification for more details.
> +
>  What:
> 	/sys/bus/platform/drivers/ufshcd/*/device_descriptor/device_type
>  Date:		February 2018
>  Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c =
index
> cd7174d2d225..a0e38776dc92 100644
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
> @@ -123,12 +124,88 @@ static ssize_t spm_lvl_store(struct device *dev,
>  	return ufs_sysfs_pm_lvl_store(dev, attr, buf, count, false);  }
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
> +	int timer =3D -1;
> +
> +	if (hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT)
> +		timer =3D ufshcd_ahit_to_us(hba->ahit);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n", timer); }
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
>  static DEVICE_ATTR_RW(spm_lvl);
> +static DEVICE_ATTR_RW(auto_hibern8);
>=20
>  static struct attribute *ufs_sysfs_ufshcd_attrs[] =3D {
>  	&dev_attr_rpm_lvl.attr,
>  	&dev_attr_spm_lvl.attr,
> +	&dev_attr_auto_hibern8.attr,
>  	NULL
>  };
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 5d874e303d4e..d5fc2fa65495 100644
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
> @@ -3709,6 +3710,18 @@ static int ufshcd_uic_hibern8_exit(struct ufs_hba
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
> @@ -6315,6 +6328,9 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>  	/* UniPro link is active now */
>  	ufshcd_set_link_active(hba);
>=20
> +	/* Enable Auto-Hibernate if configured */
> +	ufshcd_auto_hibern8_enable(hba);
> +
>  	ret =3D ufshcd_verify_dev_init(hba);
>  	if (ret)
>  		goto out;
> @@ -7399,6 +7415,10 @@ static int ufshcd_resume(struct ufs_hba *hba,
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
> @@ -7843,6 +7863,12 @@ int ufshcd_init(struct ufs_hba *hba, void
> __iomem *mmio_base, unsigned int irq)
>  						UFS_SLEEP_PWR_MODE,
>  						UIC_LINK_HIBERN8_STATE);
>=20
> +	/* Set the default auto-hiberate idle timer value to 150 ms */
Your commit said you are setting an idle timer in microseconds,  Better use=
 usec to avoid confusion?=20

=20
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
> a57d9bdebfed..763a8e6c98ee 100644
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
>  	MASK_OUT_OF_ORDER_DATA_DELIVERY_SUPPORT	=3D
> 0x02000000,
>  	MASK_UIC_DME_TEST_MODE_SUPPORT		=3D
> 0x04000000,
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
