From: Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>
Subject: RE: [PATCH v4 01/10] ufs: sysfs: attribute group for existing sysfs
 entries.
Date: Sun, 4 Feb 2018 12:29:06 +0000
Message-ID: <DM2PR0401MB097509D74E03449B0FA616249AFF0@DM2PR0401MB0975.namprd04.prod.outlook.com>
References: <1517501746-19075-1-git-send-email-stanislav.nijnikov@wdc.com>
 <1517501746-19075-2-git-send-email-stanislav.nijnikov@wdc.com>
 <20180201165923.GA12838@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:62613 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751261AbeBDM3O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Feb 2018 07:29:14 -0500
In-Reply-To: <20180201165923.GA12838@kroah.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jaegeuk@kernel.org" <jaegeuk@kernel.org>, Alex Lemberg <Alex.Lemberg@wdc.com>



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, February 1, 2018 6:59 PM
> To: Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
> jaegeuk@kernel.org; Alex Lemberg <Alex.Lemberg@wdc.com>
> Subject: Re: [PATCH v4 01/10] ufs: sysfs: attribute group for existing sy=
sfs
> entries.
>=20
> On Thu, Feb 01, 2018 at 06:15:37PM +0200, Stanislav Nijnikov wrote:
> > This patch introduces attribute group to show existing sysfs entries.
> >
> > Signed-off-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
> > ---
> >  drivers/scsi/ufs/Makefile    |   3 +-
> >  drivers/scsi/ufs/ufs-sysfs.c | 164
> > +++++++++++++++++++++++++++++++++++++++++++
> >  drivers/scsi/ufs/ufs-sysfs.h |  22 ++++++
> >  drivers/scsi/ufs/ufshcd.c    | 156 ++---------------------------------=
-----
> >  drivers/scsi/ufs/ufshcd.h    |   2 +
> >  5 files changed, 194 insertions(+), 153 deletions(-)  create mode
> > 100644 drivers/scsi/ufs/ufs-sysfs.c  create mode 100644
> > drivers/scsi/ufs/ufs-sysfs.h
> >
> > diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> > index 9310c6c..918f579 100644
> > --- a/drivers/scsi/ufs/Makefile
> > +++ b/drivers/scsi/ufs/Makefile
> > @@ -3,6 +3,7 @@
> >  obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) +=3D tc-dwc-g210-pci.o ufshcd-
> dwc.o
> > tc-dwc-g210.o
> >  obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) +=3D tc-dwc-g210-pltfrm.o
> > ufshcd-dwc.o tc-dwc-g210.o
> >  obj-$(CONFIG_SCSI_UFS_QCOM) +=3D ufs-qcom.o
> > -obj-$(CONFIG_SCSI_UFSHCD) +=3D ufshcd.o
> > +obj-$(CONFIG_SCSI_UFSHCD) +=3D ufshcd-core.o ufshcd-core-objs :=3D
> > +ufshcd.o ufs-sysfs.o
> >  obj-$(CONFIG_SCSI_UFSHCD_PCI) +=3D ufshcd-pci.o
> >  obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) +=3D ufshcd-pltfrm.o diff --git
> > a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c new file
> > mode 100644 index 0000000..cc68a90
> > --- /dev/null
> > +++ b/drivers/scsi/ufs/ufs-sysfs.c
> > @@ -0,0 +1,164 @@
> > +//SPDX-License-Identifier: GPL-2.0-only //Copyright (C) 2018 Western
> > +Digital Corporation //This program is free software; you can
> > +redistribute it and/or modify it //under the terms of the GNU General
> > +Public License as published by the //Free Software Foundation;
> > +version 2.
> > +//
> > +//This program is distributed in the hope that it will be useful, but
> > +//WITHOUT ANY WARRANTY; without even the implied warranty of
> > +//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> GNU
> > +//General Public License for more details.
>=20
> No need to put the whole "This program" crud in the file here if you have=
 the
> SPDX line already.  We are going through the kernel tree and removing all=
 of
> the 700+ different ways we have this boilerplate code in the tree, please=
 do
> not add new ones.
>=20
> Also, please put a ' ' after "//", it just looks ugly like this, don't yo=
u think so?
>=20
> Please fix this for all of the files you add in this patch series.
>=20
> > +#include <linux/err.h>
> > +#include <linux/string.h>
> > +
> > +#include "ufs-sysfs.h"
> > +
> > +static const char *ufschd_uic_link_state_to_string(
> > +			enum uic_link_state state)
> > +{
> > +	switch (state) {
> > +	case UIC_LINK_OFF_STATE:	return "OFF";
> > +	case UIC_LINK_ACTIVE_STATE:	return "ACTIVE";
> > +	case UIC_LINK_HIBERN8_STATE:	return "HIBERN8";
> > +	default:			return "UNKNOWN";
> > +	}
> > +}
> > +
> > +static const char *ufschd_ufs_dev_pwr_mode_to_string(
> > +			enum ufs_dev_pwr_mode state)
> > +{
> > +	switch (state) {
> > +	case UFS_ACTIVE_PWR_MODE:	return "ACTIVE";
> > +	case UFS_SLEEP_PWR_MODE:	return "SLEEP";
> > +	case UFS_POWERDOWN_PWR_MODE:	return "POWERDOWN";
> > +	default:			return "UNKNOWN";
> > +	}
> > +}
> > +
> > +static inline ssize_t ufs_sysfs_pm_lvl_store(struct device *dev,
> > +					     struct device_attribute *attr,
> > +					     const char *buf, size_t count,
> > +					     bool rpm)
> > +{
> > +	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> > +	unsigned long flags, value;
> > +
> > +	if (kstrtoul(buf, 0, &value))
> > +		return -EINVAL;
> > +
> > +	if (value >=3D UFS_PM_LVL_MAX)
> > +		return -EINVAL;
> > +
> > +	spin_lock_irqsave(hba->host->host_lock, flags);
> > +	if (rpm)
> > +		hba->rpm_lvl =3D value;
> > +	else
> > +		hba->spm_lvl =3D value;
> > +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> > +	return count;
> > +}
> > +
> > +static ssize_t rpm_lvl_show(struct device *dev,
> > +		struct device_attribute *attr, char *buf) {
> > +	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> > +	int curr_len;
> > +	u8 lvl;
> > +
> > +	curr_len =3D snprintf(buf, PAGE_SIZE,
> > +			    "\nCurrent Runtime PM level [%d] =3D> dev_state
> [%s] link_state [%s]\n",
> > +			    hba->rpm_lvl,
> > +			    ufschd_ufs_dev_pwr_mode_to_string(
> > +				ufs_pm_lvl_states[hba-
> >rpm_lvl].dev_state),
> > +			    ufschd_uic_link_state_to_string(
> > +				ufs_pm_lvl_states[hba-
> >rpm_lvl].link_state));
> > +
> > +	curr_len +=3D snprintf((buf + curr_len), (PAGE_SIZE - curr_len),
> > +			     "\nAll available Runtime PM levels info:\n");
> > +	for (lvl =3D UFS_PM_LVL_0; lvl < UFS_PM_LVL_MAX; lvl++)
> > +		curr_len +=3D snprintf((buf + curr_len), (PAGE_SIZE - curr_len),
> > +				     "\tRuntime PM level [%d] =3D> dev_state
> [%s] link_state [%s]\n",
> > +				    lvl,
> > +				    ufschd_ufs_dev_pwr_mode_to_string(
> > +					ufs_pm_lvl_states[lvl].dev_state),
> > +				    ufschd_uic_link_state_to_string(
> > +					ufs_pm_lvl_states[lvl].link_state));
> > +
>=20
> sysfs if "one value per file", not "random text that someone has to parse=
 per
> file" please.
>=20
> Huge hint, if you ever care about checking the size of the sysfs buffer y=
ou are
> writing into, you are doing something really really wrong.
>=20
Hi Greg
It's the existing code, added by:
commit 09690d5a6ae1b7e4cb5ac429c311b99d09352c12
Author: subhashj@codeaurora.org <subhashj@codeaurora.org>
Date:   Thu Dec 22 18:41:00 2016 -0800

    scsi: ufs: provide sysfs attribute to select the PM level
   =20
    This patch provides the sysfs attribute to choose the power management
    level for UFS runtime and system suspend.
   =20
    Reviewed-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
    Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

I just moved it to an another file and changed the sysfs entries creation b=
y
Jaegeuk Kim' request. At the moment the entry shows the PM level, the devic=
e
state, the link state and all possible PM levels. Do you want me to change =
it?

>=20
> > +	return curr_len;
> > +}
> > +
> > +static ssize_t rpm_lvl_store(struct device *dev,
> > +		struct device_attribute *attr, const char *buf, size_t count) {
> > +	return ufs_sysfs_pm_lvl_store(dev, attr, buf, count, true); }
> > +
> > +static ssize_t spm_lvl_show(struct device *dev,
> > +		struct device_attribute *attr, char *buf) {
> > +	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> > +	int curr_len;
> > +	u8 lvl;
> > +
> > +	curr_len =3D snprintf(buf, PAGE_SIZE,
> > +			    "\nCurrent System PM level [%d] =3D> dev_state
> [%s] link_state [%s]\n",
> > +			    hba->spm_lvl,
> > +			    ufschd_ufs_dev_pwr_mode_to_string(
> > +				ufs_pm_lvl_states[hba-
> >spm_lvl].dev_state),
> > +			    ufschd_uic_link_state_to_string(
> > +				ufs_pm_lvl_states[hba-
> >spm_lvl].link_state));
> > +
> > +	curr_len +=3D snprintf((buf + curr_len), (PAGE_SIZE - curr_len),
> > +			     "\nAll available System PM levels info:\n");
> > +	for (lvl =3D UFS_PM_LVL_0; lvl < UFS_PM_LVL_MAX; lvl++)
> > +		curr_len +=3D snprintf((buf + curr_len), (PAGE_SIZE - curr_len),
> > +				     "\tSystem PM level [%d] =3D> dev_state
> [%s] link_state [%s]\n",
> > +				    lvl,
> > +				    ufschd_ufs_dev_pwr_mode_to_string(
> > +					ufs_pm_lvl_states[lvl].dev_state),
> > +				    ufschd_uic_link_state_to_string(
> > +					ufs_pm_lvl_states[lvl].link_state));
> > +
>=20
> Same here, this output is not ok.
>=20
Same here.

> > +	return curr_len;
> > +}
> > +
> > +static ssize_t spm_lvl_store(struct device *dev,
> > +		struct device_attribute *attr, const char *buf, size_t count) {
> > +	return ufs_sysfs_pm_lvl_store(dev, attr, buf, count, false); }
> > +
> > +static DEVICE_ATTR_RW(rpm_lvl);
> > +static DEVICE_ATTR_RW(spm_lvl);
> > +
> > +static struct attribute *ufs_sysfs_ufshcd_attrs[] =3D {
> > +	&dev_attr_rpm_lvl.attr,
> > +	&dev_attr_spm_lvl.attr,
> > +	NULL
> > +};
> > +
> > +static const struct attribute_group ufs_sysfs_default_group =3D {
> > +	.attrs =3D ufs_sysfs_ufshcd_attrs,
> > +};
> > +
> > +static const struct attribute_group *ufs_sysfs_groups[] =3D {
> > +	&ufs_sysfs_default_group,
> > +	NULL,
> > +};
>=20
> ATTRIBUTE_GROUPS() macro?
>=20
> > +void ufs_sysfs_add_nodes(struct device *dev) {
> > +	int ret;
> > +
> > +	ret =3D sysfs_create_groups(&dev->kobj, ufs_sysfs_groups);
> > +	if (ret)
> > +		dev_err(dev,
> > +			"%s: sysfs groups creation failed (err =3D %d)\n",
> > +			__func__, ret);
>=20
> Why not return 'ret' so you can do something with it?

The existing in the driver functions that create the sysfs entries do nothi=
ng on
failure, just error message. So I just keep the same logic.

>=20
> thanks,
>=20
> greg k-h

Thank you.
Stanislav
