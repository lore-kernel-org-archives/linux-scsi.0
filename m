From: Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>
Subject: RE: [PATCH v3 1/9] ufs: sysfs: device descriptor
Date: Tue, 2 Jan 2018 13:54:30 +0000
Message-ID: <DM2PR0401MB0975DB9535FFBCFB9B61BF949A190@DM2PR0401MB0975.namprd04.prod.outlook.com>
References: <1514467754-24499-1-git-send-email-stanislav.nijnikov@wdc.com>
 <1514467754-24499-2-git-send-email-stanislav.nijnikov@wdc.com>
 <20171228193717.GA47637@jaegeuk-macbookpro.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171228193717.GA47637@jaegeuk-macbookpro.roam.corp.google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, Alex Lemberg <Alex.Lemberg@wdc.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Thursday, December 28, 2017 9:37 PM
> To: Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
> gregkh@linuxfoundation.org; Alex Lemberg <Alex.Lemberg@wdc.com>
> Subject: Re: [PATCH v3 1/9] ufs: sysfs: device descriptor
>=20
> On 12/28, Stanislav Nijnikov wrote:
> > This patch introduces a sysfs group entry for the UFS device
> > descriptor parameters. The group adds "device_descriptor" folder under
> > the UFS driver sysfs entry (/sys/bus/platform/drivers/ufshcd/*). The
> > parameters are shown as hexadecimal numbers. The full information
> > about the parameters could be found at UFS specifications 2.1.
> >
> > Signed-off-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
> > ---
> >  Documentation/ABI/testing/sysfs-driver-ufs | 223
> +++++++++++++++++++++++++++++
> >  drivers/scsi/ufs/Makefile                  |   3 +-
> >  drivers/scsi/ufs/ufs-sysfs.c               | 170 +++++++++++++++++++++=
+
> >  drivers/scsi/ufs/ufs-sysfs.h               |  25 ++++
> >  drivers/scsi/ufs/ufs.h                     |   8 ++
> >  drivers/scsi/ufs/ufshcd.c                  |  12 +-
> >  drivers/scsi/ufs/ufshcd.h                  |   4 +
> >  7 files changed, 439 insertions(+), 6 deletions(-)  create mode
> > 100644 Documentation/ABI/testing/sysfs-driver-ufs
> >  create mode 100644 drivers/scsi/ufs/ufs-sysfs.c  create mode 100644
> > drivers/scsi/ufs/ufs-sysfs.h
> >
> > diff --git a/Documentation/ABI/testing/sysfs-driver-ufs
> > b/Documentation/ABI/testing/sysfs-driver-ufs
> > new file mode 100644
> > index 0000000..17cc4aa
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-driver-ufs
>=20
> [snip]
>=20
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
>=20
> Why not just adding ufs-sysfs.o in the existing configuration?

The kernel build robot compiles the UFS driver as a separate module.=20
The existing configuration doesn't allow to add a new file to be compiled=20
as a part of this module. The line like " obj-$(CONFIG_SCSI_UFSHCD) +=3D=20
ufshcd.o ufs-sysfs.o" in the makefile will actually create 2 modules.
This was the reason why I used EXPORT_SYMBOL in the first version.

>=20
> >  obj-$(CONFIG_SCSI_UFSHCD_PCI) +=3D ufshcd-pci.o
> >  obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) +=3D ufshcd-pltfrm.o diff --git
> > a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c new file
> > mode 100644 index 0000000..1c685f3
> > --- /dev/null
> > +++ b/drivers/scsi/ufs/ufs-sysfs.c
> > @@ -0,0 +1,170 @@
> > +/*
> > +* UFS Device Management sysfs
> > +*
> > +* Copyright (C) 2017 Western Digital Corporation
> > +*
> > +* This program is free software; you can redistribute it and/or
> > +* modify it under the terms of the GNU General Public License version
> > +* 2 as published by the Free Software Foundation.
> > +*
> > +* This program is distributed in the hope that it will be useful, but
> > +* WITHOUT ANY WARRANTY; without even the implied warranty of
> > +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> GNU
> > +* General Public License for more details.
> > +*
> > +*/
> > +
> > +#include <linux/err.h>
> > +#include <linux/string.h>
> > +
> > +#include "ufs.h"
> > +#include "ufs-sysfs.h"
> > +/* collision between the device descriptor parameter and the
> > +definition */ #undef DEVICE_CLASS
>=20
> Does this make sense? How about attaching "_" for all the macro like
> _DEVICE_CLASS below?
>=20

It's not just changing the one line that uses "DEVICE_CLASS" to use=20
"_DEVICE_CLASS". It's will be necessary to add "_" to all descriptor
parameters macros in all patches.

> > +
> > +enum ufs_desc_param_size {
> > +	UFS_PARAM_BYTE_SIZE	=3D 1,
> > +	UFS_PARAM_WORD_SIZE	=3D 2,
> > +	UFS_PARAM_DWORD_SIZE	=3D 4,
> > +	UFS_PARAM_QWORD_SIZE	=3D 8,
> > +};
> > +
> > +static inline ssize_t ufs_sysfs_read_desc_param(
> > +	struct ufs_hba *hba, u8 desc_idn, u8 index, char *buf, u8 off,
> > +	enum ufs_desc_param_size param_size) {
> > +	int desc_len;
> > +	int ret;
> > +	u8 *desc_buf;
> > +
> > +	if (ufshcd_map_desc_id_to_length(hba, desc_idn, &desc_len) ||
> > +		off >=3D desc_len)
> > +		return -EINVAL;
> > +	desc_buf =3D kzalloc(desc_len, GFP_ATOMIC);
> > +	if (!desc_buf)
> > +		return -ENOMEM;
> > +	ret =3D ufshcd_query_descriptor_retry(hba,
> UPIU_QUERY_OPCODE_READ_DESC,
> > +		desc_idn, index, 0, desc_buf, &desc_len);
> > +	if (ret)
>=20
> Should free desc_buf here.
>=20
> > +		return -EINVAL;
> > +	switch (param_size) {
> > +	case UFS_PARAM_BYTE_SIZE:
> > +		ret =3D sprintf(buf, "0x%02X\n", desc_buf[off]);
> > +		break;
> > +	case UFS_PARAM_WORD_SIZE:
> > +		ret =3D sprintf(buf, "0x%04X\n",
> > +			be16_to_cpu(*((u16 *)(desc_buf + off))));
> > +		break;
> > +	case UFS_PARAM_DWORD_SIZE:
> > +		ret =3D sprintf(buf, "0x%08X\n",
> > +			be32_to_cpu(*((u32 *)(desc_buf + off))));
> > +		break;
> > +	case UFS_PARAM_QWORD_SIZE:
> > +		ret =3D sprintf(buf, "0x%016llX\n",
> > +			be64_to_cpu(*((u64 *)(desc_buf + off))));
> > +		break;
> > +	}
> > +	kfree(desc_buf);
> > +
> > +	return ret;
> > +}
> > +
> > +#define ufs_sysfs_desc_param_show(_name, _puname, _duname,
> _size)             \
> > +static ssize_t _name##_show(struct device *dev,                       =
        \
> > +	struct device_attribute *attr, char *buf)                            =
 \
> > +{                                                                     =
        \
> > +	struct ufs_hba *hba =3D dev_get_drvdata(dev);                        =
   \
> > +	return ufs_sysfs_read_desc_param(hba,
> QUERY_DESC_IDN_##_duname,       \
> > +		0, buf, _duname##_DESC_PARAM_##_puname,                       \
> > +		UFS_PARAM_##_size##_SIZE);                                    \
> > +}
> > +
> > +#define UFS_DESC_PARAM(_pname, _puname, _duname, _size)
> \
> > +	ufs_sysfs_desc_param_show(_pname, _puname, _duname, _size)
> \
> > +	static DEVICE_ATTR_RO(_pname)
> > +
> > +#define UFS_DEVICE_DESC_PARAM(_name, _uname, _size)
> \
> > +	UFS_DESC_PARAM(_name, _uname, DEVICE, _size)
> > +
> > +UFS_DEVICE_DESC_PARAM(device_type, DEVICE_TYPE, BYTE);
> > +UFS_DEVICE_DESC_PARAM(device_class, DEVICE_CLASS, BYTE);
> > +UFS_DEVICE_DESC_PARAM(device_sub_class, DEVICE_SUB_CLASS,
> BYTE);
> > +UFS_DEVICE_DESC_PARAM(protocol, PRTCL, BYTE);
> > +UFS_DEVICE_DESC_PARAM(number_of_luns, NUM_LU, BYTE);
> > +UFS_DEVICE_DESC_PARAM(number_of_wluns, NUM_WLU, BYTE);
> > +UFS_DEVICE_DESC_PARAM(boot_enable, BOOT_ENBL, BYTE);
> > +UFS_DEVICE_DESC_PARAM(descriptor_access_enable,
> DESC_ACCSS_ENBL,
> > +BYTE); UFS_DEVICE_DESC_PARAM(initial_power_mode,
> INIT_PWR_MODE,
> > +BYTE); UFS_DEVICE_DESC_PARAM(high_priority_lun, HIGH_PR_LUN,
> BYTE);
> > +UFS_DEVICE_DESC_PARAM(secure_removal_type, SEC_RMV_TYPE,
> BYTE);
> > +UFS_DEVICE_DESC_PARAM(support_security_lun, SEC_LU, BYTE);
> > +UFS_DEVICE_DESC_PARAM(bkops_termination_latency,
> BKOP_TERM_LT, BYTE);
> > +UFS_DEVICE_DESC_PARAM(initial_active_icc_level, ACTVE_ICC_LVL,
> BYTE);
> > +UFS_DEVICE_DESC_PARAM(specification_version, SPEC_VER, WORD);
> > +UFS_DEVICE_DESC_PARAM(manufacturing_date, MANF_DATE, WORD);
> > +UFS_DEVICE_DESC_PARAM(manufacturer_id, MANF_ID, WORD);
> > +UFS_DEVICE_DESC_PARAM(rtt_capability, RTT_CAP, BYTE);
> > +UFS_DEVICE_DESC_PARAM(rtc_update, FRQ_RTC, WORD);
> > +UFS_DEVICE_DESC_PARAM(ufs_features, UFS_FEAT, BYTE);
> > +UFS_DEVICE_DESC_PARAM(ffu_timeout, FFU_TMT, BYTE);
> > +UFS_DEVICE_DESC_PARAM(queue_depth, Q_DPTH, BYTE);
> > +UFS_DEVICE_DESC_PARAM(device_version, DEV_VER, WORD);
> > +UFS_DEVICE_DESC_PARAM(number_of_secure_wpa, NUM_SEC_WPA,
> BYTE);
> > +UFS_DEVICE_DESC_PARAM(psa_max_data_size, PSA_MAX_DATA,
> DWORD);
> > +UFS_DEVICE_DESC_PARAM(psa_state_timeout, PSA_TMT, BYTE);
> > +
> > +static struct attribute *ufs_sysfs_device_descriptor[] =3D {
> > +	&dev_attr_device_type.attr,
> > +	&dev_attr_device_class.attr,
> > +	&dev_attr_device_sub_class.attr,
> > +	&dev_attr_protocol.attr,
> > +	&dev_attr_number_of_luns.attr,
> > +	&dev_attr_number_of_wluns.attr,
> > +	&dev_attr_boot_enable.attr,
> > +	&dev_attr_descriptor_access_enable.attr,
> > +	&dev_attr_initial_power_mode.attr,
> > +	&dev_attr_high_priority_lun.attr,
> > +	&dev_attr_secure_removal_type.attr,
> > +	&dev_attr_support_security_lun.attr,
> > +	&dev_attr_bkops_termination_latency.attr,
> > +	&dev_attr_initial_active_icc_level.attr,
> > +	&dev_attr_specification_version.attr,
> > +	&dev_attr_manufacturing_date.attr,
> > +	&dev_attr_manufacturer_id.attr,
> > +	&dev_attr_rtt_capability.attr,
> > +	&dev_attr_rtc_update.attr,
> > +	&dev_attr_ufs_features.attr,
> > +	&dev_attr_ffu_timeout.attr,
> > +	&dev_attr_queue_depth.attr,
> > +	&dev_attr_device_version.attr,
> > +	&dev_attr_number_of_secure_wpa.attr,
> > +	&dev_attr_psa_max_data_size.attr,
> > +	&dev_attr_psa_state_timeout.attr,
> > +	NULL,
> > +};
> > +
> > +static const struct attribute_group ufs_sysfs_device_descriptor_group =
=3D {
> > +	.name =3D "device_descriptor",
> > +	.attrs =3D ufs_sysfs_device_descriptor, };
> > +
> > +static const struct attribute_group *ufs_sysfs_groups[] =3D {
> > +	&ufs_sysfs_device_descriptor_group,
> > +	NULL,
> > +};
> > +
> > +void ufs_sysfs_add_device_management(struct ufs_hba *hba) {
> > +	int ret;
> > +
> > +	ret =3D sysfs_create_groups(&hba->dev->kobj, ufs_sysfs_groups);
> > +	if (ret)
> > +		dev_err(hba->dev,
> > +			"%s: sysfs groups creation failed (err =3D %d)\n",
> > +			__func__, ret);
> > +}
> > +
> > +void ufs_sysfs_remove_device_management(struct ufs_hba *hba) {
> > +	sysfs_remove_groups(&hba->dev->kobj, ufs_sysfs_groups); }
> > diff --git a/drivers/scsi/ufs/ufs-sysfs.h
> > b/drivers/scsi/ufs/ufs-sysfs.h new file mode 100644 index
> > 0000000..a1fc9dc
> > --- /dev/null
> > +++ b/drivers/scsi/ufs/ufs-sysfs.h
> > @@ -0,0 +1,25 @@
> > +/*
> > +* UFS Device Management sysfs
> > +*
> > +* Copyright (C) 2017 Western Digital Corporation
> > +*
> > +* This program is free software; you can redistribute it and/or
> > +* modify it under the terms of the GNU General Public License version
> > +* 2 as published by the Free Software Foundation.
> > +*
> > +* This program is distributed in the hope that it will be useful, but
> > +* WITHOUT ANY WARRANTY; without even the implied warranty of
> > +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> GNU
> > +* General Public License for more details.
> > +*
> > +*/
> > +#ifndef __UFS_SYSFS_H__
> > +#define __UFS_SYSFS_H__
> > +
> > +#include <linux/sysfs.h>
> > +
> > +#include "ufshcd.h"
> > +
> > +void ufs_sysfs_add_device_management(struct ufs_hba *hba); void
> > +ufs_sysfs_remove_device_management(struct ufs_hba *hba); #endif
> > diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h index
> > 54deeb7..6ae1e08 100644
> > --- a/drivers/scsi/ufs/ufs.h
> > +++ b/drivers/scsi/ufs/ufs.h
> > @@ -220,6 +220,14 @@ enum device_desc_param {
> >  	DEVICE_DESC_PARAM_UD_LEN		=3D 0x1B,
> >  	DEVICE_DESC_PARAM_RTT_CAP		=3D 0x1C,
> >  	DEVICE_DESC_PARAM_FRQ_RTC		=3D 0x1D,
> > +	DEVICE_DESC_PARAM_UFS_FEAT		=3D 0x1F,
> > +	DEVICE_DESC_PARAM_FFU_TMT		=3D 0x20,
> > +	DEVICE_DESC_PARAM_Q_DPTH		=3D 0x21,
> > +	DEVICE_DESC_PARAM_DEV_VER		=3D 0x22,
> > +	DEVICE_DESC_PARAM_NUM_SEC_WPA		=3D 0x24,
> > +	DEVICE_DESC_PARAM_PSA_MAX_DATA		=3D 0x25,
> > +	DEVICE_DESC_PARAM_PSA_TMT		=3D 0x29,
> > +	DEVICE_DESC_PARAM_PRDCT_REV		=3D 0x2A,
> >  };
> >
> >  /*
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index a355d98..97dcb52 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -44,6 +44,7 @@
> >  #include "ufshcd.h"
> >  #include "ufs_quirks.h"
> >  #include "unipro.h"
> > +#include "ufs-sysfs.h"
> >
> >  #define CREATE_TRACE_POINTS
> >  #include <trace/events/ufs.h>
> > @@ -2894,11 +2895,10 @@ static int __ufshcd_query_descriptor(struct
> ufs_hba *hba,
> >   * The buf_len parameter will contain, on return, the length parameter
> >   * received on the response.
> >   */
> > -static int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
> > -					 enum query_opcode opcode,
> > -					 enum desc_idn idn, u8 index,
> > -					 u8 selector,
> > -					 u8 *desc_buf, int *buf_len)
> > +int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
> > +				  enum query_opcode opcode,
> > +				  enum desc_idn idn, u8 index, u8 selector,
> > +				  u8 *desc_buf, int *buf_len)
> >  {
> >  	int err;
> >  	int retries;
> > @@ -7704,10 +7704,12 @@ static inline void
> > ufshcd_add_sysfs_nodes(struct ufs_hba *hba)  {
> >  	ufshcd_add_rpm_lvl_sysfs_nodes(hba);
> >  	ufshcd_add_spm_lvl_sysfs_nodes(hba);
> > +	ufs_sysfs_add_device_management(hba);
>=20
> IMO, ufs-sysfs.c must have the existing entries above, rpm/spm, as a defa=
ult
> group first, and then would be better to add device_descriptor_group on t=
op
> of it.
>=20
> Thanks,
>=20
> >  }
> >
> >  static inline void ufshcd_remove_sysfs_nodes(struct ufs_hba *hba)  {
> > +	ufs_sysfs_remove_device_management(hba);
> >  	device_remove_file(hba->dev, &hba->rpm_lvl_attr);
> >  	device_remove_file(hba->dev, &hba->spm_lvl_attr);  } diff --git
> > a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index
> > 1332e54..6a0ec4b 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -841,6 +841,10 @@ static inline bool ufshcd_is_hs_mode(struct
> > ufs_pa_layer_attr *pwr_info)  }
> >
> >  /* Expose Query-Request API */
> > +int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
> > +				  enum query_opcode opcode,
> > +				  enum desc_idn idn, u8 index, u8 selector,
> > +				  u8 *desc_buf, int *buf_len);
> >  int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
> >  	enum flag_idn idn, bool *flag_res);
> >  int ufshcd_hold(struct ufs_hba *hba, bool async);
> > --
> > 2.7.4
=20
Regards
Happy new year!
