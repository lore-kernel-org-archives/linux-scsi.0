From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [RESEND][PATCH v3 1/2] scsi: ufs: Use DEVICE_ATTR_RW macros and
 sdev_attrs structure
Date: Wed, 26 Jul 2017 15:17:14 +0000
Message-ID: <1501082233.2671.2.camel@wdc.com>
References: <20170726145503.15339-1-michalx.potomski@intel.com>
         <20170726145503.15339-2-michalx.potomski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:22585 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750918AbdGZPSD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2017 11:18:03 -0400
In-Reply-To: <20170726145503.15339-2-michalx.potomski@intel.com>
Content-Language: en-US
Content-ID: <6C1E70141179834EBC1A02235C36EE7E@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "michalx.potomski@intel.com" <michalx.potomski@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "szymonx.mielczarek@intel.com" <szymonx.mielczarek@intel.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>

On Wed, 2017-07-26 at 16:55 +0200, Michal Potomski wrote:
> Previous implementation was obsolete and needed to be updated.
> Additionally device_create_file() call occurs after a UFS device
> has been made visible in sysfs and hence will cause trouble
> (race condition) if a udev rule tries to set this attribute
> from inside a rule that is triggered by device creation.

Hello Michal,

Thank you for having done this work!

> +static ssize_t rpm_lvl_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> +	int curr_len;
> +	u8 lvl;
> +
> +	curr_len =3D snprintf(buf, PAGE_SIZE,
> +			    "\nCurrent Runtime PM level [%d] =3D> dev_state [%s] link_state [=
%s]\n",
> +			    hba->rpm_lvl,
> +			    ufschd_ufs_dev_pwr_mode_to_string(
> +				ufs_pm_lvl_states[hba->rpm_lvl].dev_state),
> +			    ufschd_uic_link_state_to_string(
> +				ufs_pm_lvl_states[hba->rpm_lvl].link_state));
> +
> +	curr_len +=3D snprintf((buf + curr_len), (PAGE_SIZE - curr_len),
> +			     "\nAll available Runtime PM levels info:\n");
> +	for (lvl =3D UFS_PM_LVL_0; lvl < UFS_PM_LVL_MAX; lvl++)
> +		curr_len +=3D snprintf((buf + curr_len), (PAGE_SIZE - curr_len),
> +				     "\tRuntime PM level [%d] =3D> dev_state [%s] link_state [%s]\n"=
,
> +				    lvl,
> +				    ufschd_ufs_dev_pwr_mode_to_string(
> +					ufs_pm_lvl_states[lvl].dev_state),
> +				    ufschd_uic_link_state_to_string(
> +					ufs_pm_lvl_states[lvl].link_state));
> +
> +	return curr_len;
> +}

I am aware that this code is existing code that has been moved up. But are
the UFS contributors aware that this kind of output violates the sysfs rule=
s?
Please consider either to move this attribute to debugfs (the one value per
file rule only applies to sysfs and configfs) or to split it into multiple
sysfs attributes if that is possible without breaking existing user space
applications. A quote from
https://www.kernel.org/doc/Documentation/filesystems/sysfs.txt: "Attributes
should be ASCII text files, preferably with only one value per file. It is
noted that it may not be efficient to contain only one value per file, so i=
t
is socially acceptable to express an array of values of the same type."

Anyway, since this patch is an improvement compared to the current code bas=
e:

Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
