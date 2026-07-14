Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E357B4DBD72
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 16:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784048052; cv=none; b=mv+BgDlM62nCxYK3Ak1xTCfSIyeM1mNBAsJb/v0mDSfauR/aE702Vw6QL2sx6GHck9xS4i4ha5nbzGjJvxxK+U+ZKJFbmHVCSF2gMk3gD7EYngqcj6umMY8u6yHpG9EfFTG7Ek7P8bk2BdwjNtZLzTDaK5kCU4Gx73zS+ZDKkl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784048052; c=relaxed/simple;
	bh=4qra9CqEh0KKwnvzQ1NJlqZBHpc3jdOVaveANMBgCh8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=O7wqiAISK7qOv6N6CLFN/Igegs8aYEiyjINeq8e+YoFw0xOPxVAFY5VKL9kLR499eKr/CND1UXXgeH6RsMZcbJfVQ3zV8EgtXyupOsy4wSeCbR6FQHqMazdxjDgkj+yXVa6PVnfB4sdOMOSejE2iExPUMQX3wQG9kFJDKAM1x2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DgCwMkji; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DgCwMkji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904771F000E9;
	Tue, 14 Jul 2026 16:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784048050;
	bh=LzxISkKmredfoytZRCnTTFI1aOq0RgbcsXcCvqK9PEg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DgCwMkjiz1dtGf2WAQuBLt6VmurYxJsUOWpO8HzrzV6NwgtSD9in2YxXmdQIrAco9
	 M4ZZrPRc9iDP/heNXoJSWEFFQYcqVPCnlGpoDtnJTBOx1prC4IyewRXddQb8j+cz2U
	 k1aVbf5X9STBNHHwBqRnPTukWMGoSNbNqpmYJGEgSqO4wES9wUK8XMOD5I8+V3mERl
	 sniywqOLR8HWA0C4F8bX+P2c5zZL0mT7zXvRr4hJ8+swdMjvYt8lnfDl6r88hg47oj
	 bJdSQOQQ1VmHKa/z4Ax6RIDs5IkXwCpPXdpFy0IflXSSGwImrUba5q4tu1CulHDwNf
	 PzTJBCHcF6ycw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 44/56] scsi: qla2xxx: Add 64G/128G port speed setting
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-45-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-45-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 16:54:10 +0000
Message-Id: <20260714165410.904771F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Port speeds > 64G are silently lost after an adapter reset and can=
not be re-applied via sysfs.

Pre-existing issues:
- [Medium] The driver updates the software state `ha->set_data_rate` before=
 hardware validation, but fails to roll it back if the hardware rejects the=
 setting.
--

--- Patch [44]: [PATCH v4 44/56] scsi: qla2xxx: Add 64G/128G port speed set=
ting support ---
commit 99c7281ce562509718a0baadfd40321c7fb5f8c0
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Add 64G/128G port speed setting support

This patch adds support for setting 64G and 128G port speeds via sysfs. It
updates the port speed store function to map inputs to PORT_SPEED_64GB and
PORT_SPEED_128GB, and allows these values in qla2x00_set_data_rate(). It
also modifies the ICB configuration to handle rates up to 64G.

> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
> index 6cf74f8c9628d..3b24e8a5e29ba 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
[ ... ]
> @@ -1860,6 +1860,12 @@ qla2x00_port_speed_store(struct device *dev, struc=
t device_attribute *attr,
>  	case 32:
>  		ha->set_data_rate =3D PORT_SPEED_32GB;
>  		break;
> +	case 64:
> +		ha->set_data_rate =3D PORT_SPEED_64GB;
> +		break;
> +	case 128:
> +		ha->set_data_rate =3D PORT_SPEED_128GB;
> +		break;
>  	default:
>  		ql_log(ql_log_warn, vha, 0x1199,
>  		    "Unrecognized speed setting:%lx. Setting Autoneg\n",
>  		    speed);
>  		ha->set_data_rate =3D PORT_SPEED_AUTO;
>  	}
> =20
>  	if (qla2x00_chip_is_down(vha) || (oldspeed =3D=3D ha->set_data_rate))
>  		return -EINVAL;
> =20
>  	ql_log(ql_log_info, vha, 0x70da,
>  	    "Setting speed to %lx Gbps \n", type);
> =20
>  	rval =3D qla2x00_set_data_rate(vha, mode);
>  	if (rval !=3D QLA_SUCCESS)
>  		return -EIO;

[Severity: Medium]
This is a pre-existing issue, but if qla2x00_set_data_rate() fails here
(e.g., if the firmware rejects an unsupported speed or the mailbox times ou=
t),
we return -EIO without rolling back ha->set_data_rate to oldspeed.

Does this leave ha->set_data_rate corrupted with the rejected speed?

If so, subsequent adapter resets might attempt to use this invalid speed,
and the user would be prevented from retrying the exact same speed via sysfs
because of the oldspeed =3D=3D ha->set_data_rate check earlier in this func=
tion.

> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index e31997241c348..5f04190c14879 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -4793,7 +4793,14 @@ qla24xx_config_rings(struct scsi_qla_host *vha)
>  		ql_dbg(ql_dbg_init, vha, 0x00fd,
>  		    "Speed set by user : %s Gbps \n",
>  		    qla2x00_get_link_speed_str(ha, ha->set_data_rate));
> -		icb->firmware_options_3 =3D cpu_to_le32(ha->set_data_rate << 13);
> +		/*
> +		 * The ICB data-rate field is 3 bits (bits 13-15); rates above
> +		 * 64G do not fit and would overflow into bit 16 (75 ohm
> +		 * termination select). Such rates are forced via MBC_DATA_RATE.
> +		 */
> +		if (ha->set_data_rate <=3D PORT_SPEED_64GB)
> +			icb->firmware_options_3 =3D
> +			    cpu_to_le32(ha->set_data_rate << 13);

[Severity: High]
Since MBC_DATA_RATE is only issued from the sysfs store function and not
during reset recovery, what happens if the adapter resets asynchronously?

If the user configured a 128G speed, this ICB bypass logic skips setting it.
It seems the hardware might come up at a lower default speed (such as
auto-negotiation), effectively losing the configured 128G speed.

Furthermore, because ha->set_data_rate still holds the > 64G value, if the
user tries to re-apply the 128G setting via sysfs, will the
oldspeed =3D=3D ha->set_data_rate check in qla2x00_port_speed_store() block=
 the
write and prevent recovery?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D44
