From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2] scsi: ufs: Implement Auto-Hibern8 setup
Date: Tue, 25 Jul 2017 15:30:27 +0000
Message-ID: <1500996626.3031.1.camel@wdc.com>
References: <20170725094514.19192-1-michalx.potomski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:24662 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752638AbdGYPbN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2017 11:31:13 -0400
In-Reply-To: <20170725094514.19192-1-michalx.potomski@intel.com>
Content-Language: en-US
Content-ID: <CA6D0BD5B39D1A45B9507BF164CA804E@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "michalx.potomski@intel.com" <michalx.potomski@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "szymonx.mielczarek@intel.com" <szymonx.mielczarek@intel.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>

On Tue, 2017-07-25 at 11:45 +0200, Michal Potomski wrote:
> Since Auto-Hibern8 feature has to be enabled by the user
> proper API has been given via SysFS.
>=20
> We expose this API to user-space, since we don't know
> in driver, what kind of additional Power Management rules
> user wants to use. Due to that we want to expose API, to
> let user or high level S/W decide, whether it wants to
> use Auto-Hibern8 feature for Power Saving and give him
> "slider" to decide between performance and power efficiency.
> This is important because different platforms using
> the same UFS host and/or device might want different
> options on this one, e.g. High-End Desktop PC might
> want to have this feature disabled, while Mobile or
> Server platforms might want to have this feature enabled,
> but levels will vary depending on what's to be acheived.
>=20
> As this feature is meant to be transparent for driver,
> we'd like to let user decide whether he wants this enabled
> or not.

Less than ten minutes after v1 of this patch was posted version v2 was
posted. What is the difference between v1 and v2? Second and later versions
of a patch or patch series are expected to include a changelog.

Since I'm not familiar with the Auto-Hibern8 feature: what impact does it
have on command processing? Does it e.g. cause SCSI or TMF commands that ar=
e
sent to the UFS device to be ignored, to fail or to time out?

> +static ssize_t ufshcd_auto_hibern8_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> +	u32 val;
> +	unsigned long timer;
> +	u8 scale;
> +	char *unit;
> +
> +	val =3D ufshcd_read_auto_hibern8_state(hba);
> +	timer =3D val & UFSHCI_AHIBERN8_TIMER_MASK;
> +	scale =3D	(val & UFSHCI_AHIBERN8_SCALE_MASK)
> +			>> UFSHCI_AHIBERN8_SCALE_OFFSET;
> +
> +	unit =3D scale >=3D UFSHCI_AHIBERN8_SCALE_1MS ? "ms" : "us";
> +
> +	for (scale %=3D UFSHCI_AHIBERN8_SCALE_1MS; scale > 0; --scale)
> +		timer *=3D UFS_AHIBERN8_SCALE_STEP_MAGNITUDE;
> +
> +	return snprintf(buf, PAGE_SIZE, "%ld %s\n", timer, unit);
> +}

>From Documentation/filesystems/sysfs.txt: "All new sysfs attributes must be
documented in Documentation/ABI. See also Documentation/ABI/README for more
information." Please add proper documentation of the attributes added by th=
is
patch when you resubmit this patch.

Regarding this attribute: units should be documented in Documentation/ABI/*=
/*
instead of specifying these in the attribute itself. In other words, the
"ms" / "us" suffix should be left out.

> @@ -7693,16 +7766,34 @@ static void ufshcd_add_spm_lvl_sysfs_nodes(struct=
 ufs_hba *hba)
>  		dev_err(hba->dev, "Failed to create sysfs for spm_lvl\n");
>  }
> =20
> +static void ufshcd_add_ahibern8_sysfs_node(struct ufs_hba *hba)
> +{
> +	if (!(hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT))
> +		return;
> +
> +	hba->ahibern8_attr.show =3D ufshcd_auto_hibern8_show;
> +	hba->ahibern8_attr.store =3D ufshcd_auto_hibern8_store;
> +	sysfs_attr_init(&hba->ahibern8_attr.attr);
> +	hba->ahibern8_attr.attr.name =3D "ufs_auto_hibern8";
> +	hba->ahibern8_attr.attr.mode =3D 0600;
> +	if (device_create_file(hba->dev, &hba->ahibern8_attr))
> +		dev_err(hba->dev, "Failed to create sysfs for ufs_auto_hibern8\n");
> +}

Please use a static variable at file scope and DRIVER_ATTR_RW() to initiali=
ze
the sysfs attributes instead of initializing the sysfs attributes explicitl=
y.

Additionally, please set sdev_attrs in struct scsi_host_template instead of
calling device_create_file() explicitly. The above device_create_file() cal=
l
occurs after a UFS device has been made visible in sysfs and hence will cau=
se
trouble (race condition) if a udev rule tries to set this attribute from in=
side
a rule that is triggered by device creation.

I am aware the above code follows the style that is used for other UFS sysf=
s
attributes. If you would have the time to convert the code for creating the
existing UFS sysfs attributes that would be great.

Thanks,

Bart.=
