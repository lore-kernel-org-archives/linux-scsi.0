Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB8A27A45C
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 12:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759752711; cv=none; b=l+XdLCzBPb/OBCcizAdHwYuA0IMlSovVIY9X9VSmO11JDsPQfm5/NcYueNU96FUM6lq9dtNZnB7jkxa7I+IlL53S7ErE/lVXgQgRTrSFqorVqbUaXALOjuCHEcitjCjBewRmEKa15XsNDuxW3IE7kqxAXLcRc2puz7RgaS9UcFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759752711; c=relaxed/simple;
	bh=bEpFkBhMAl+Kyv9UshSYj++BncULeY9oVKP4ESd6Yqw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=g1aM1UGfDo8b2cvk1OhcCJ+jgKNeJVrFNmeyjYDArnkMd1TSMm7n/zZLWw/2HHH2sTTKLKUhDVLfZ+SMeszwAgg1+PWy9OjKqgBYub6bRMAvLs7zWO+ugMhWCpKw6h52oso609+R8oh1KAg20X7017I9FPI3XBJONcZKNwlj10I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=oT1aSPuj; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="oT1aSPuj"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 3DF6F240027
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 14:11:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de; s=2017;
	t=1759752707; bh=2zbnC8Z/CyeVECVYwsvs1oT4U41KTfZNklK696kKRTQ=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:Autocrypt:OpenPGP:From;
	b=oT1aSPujWARqnkuEgI9skVSO1edRSQZdn5NVB8DdM4uIoq3hGsBtoMrJUUGfqLPra
	 Vx6HBneQevsOvJBmw06KScau/6eW+tvKCgjFs84iMWrC6C4HCPceg49Y/R+gp/zf/w
	 lZjSjo5MfTM6eNT5WH0blvlsJC5FzWtU+PBJAoaYxtqgJqv05XUs+va6KfgXlcoGHk
	 4GslXLdPx32uB722r2lLIcDYZGt+dy3ZIuXZd5xzGNdADHFMEYa6OOyjOpzCs4vgjX
	 zi2RD06L1WTePuZT/eHJANlUMdHmj/WnkfXf77+rjjPlr5NM1n8oyB/7UdvlX0Ok14
	 8nli6YoJp2Pbw==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4cgJ696Q94z6v1b;
	Mon,  6 Oct 2025 14:11:45 +0200 (CEST)
Message-ID: <568ee07cc0155f3d05a868ae6dce102916b83566.camel@posteo.de>
Subject: Re: [PATCH 1/2] Add manage_restart device attribute to scsi_disk
From: Markus Probst <markus.probst@posteo.de>
To: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K.
 Petersen" <martin.petersen@oracle.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Mon, 06 Oct 2025 12:11:46 +0000
In-Reply-To: <524f67bf-f4df-41bf-bf1b-5cd0a79649eb@kernel.org>
References: <8c3cb28c57462f9665b08fdaa022e6abc57fcd9e.camel@posteo.de>
	 <20251005190559.1472308-1-markus.probst@posteo.de>
	 <524f67bf-f4df-41bf-bf1b-5cd0a79649eb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Autocrypt: addr=markus.probst@posteo.de; prefer-encrypt=mutual;
  keydata=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
  aBeNN4ijKZchBXHPgVx+YtWRHfcm4l8=
OpenPGP: url=https://posteo.de/keys/markus.probst@posteo.de.asc; preference=encrypt

On Mon, 2025-10-06 at 09:58 +0900, Damien Le Moal wrote:
> On 10/6/25 04:06, Markus Probst wrote:
> > there is already manage_shutdown, manage_system_start_stop and
> > manage_runtime_start_stop device attributes that allows the high-
> > level
> > device driver (sd) manage the device power state, expect for the
> > system_state SYSTEM_RESTART. With this device attribute, it is
> > possible to
> > let the high-level device driver (sd) manage the device power state
> > for
> > SYSTEM_RESTART too.
> >=20
> > Signed-off-by: Markus Probst <markus.probst@posteo.de>
> > ---
> > =C2=A0drivers/scsi/sd.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 | 35
> > ++++++++++++++++++++++++++++++++++-
> > =C2=A0include/scsi/scsi_device.h |=C2=A0 6 ++++++
> > =C2=A02 files changed, 40 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > index 5b8668accf8e..a3e9c2e9d9f4 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -318,6 +318,36 @@ static ssize_t manage_shutdown_store(struct
> > device *dev,
> > =C2=A0}
> > =C2=A0static DEVICE_ATTR_RW(manage_shutdown);
> > =C2=A0
> > +static ssize_t manage_restart_show(struct device *dev,
> > +				=C2=A0=C2=A0 struct device_attribute *attr,
> > char *buf)
> > +{
> > +	struct scsi_disk *sdkp =3D to_scsi_disk(dev);
> > +	struct scsi_device *sdp =3D sdkp->device;
>=20
> sdp is not really needed.

Then it would be inconsistent with manage_shutdown_*,
manage_runtime_start_stop_*, manage_system_start_stop_*, there it has
the sdp variable declared.

>=20
> > +
> > +	return sysfs_emit(buf, "%u\n", sdp->manage_restart);
> > +}
> > +
> > +
> > +static ssize_t manage_restart_store(struct device *dev,
> > +				=C2=A0=C2=A0=C2=A0 struct device_attribute *attr,
> > +				=C2=A0=C2=A0=C2=A0 const char *buf, size_t count)
> > +{
> > +	struct scsi_disk *sdkp =3D to_scsi_disk(dev);
> > +	struct scsi_device *sdp =3D sdkp->device;
>=20
> Same here.
>=20
> > +	bool v;
> > +
> > +	if (!capable(CAP_SYS_ADMIN))
> > +		return -EACCES;
> > +
> > +	if (kstrtobool(buf, &v))
> > +		return -EINVAL;
> > +
> > +	sdp->manage_restart =3D v;
> > +
> > +	return count;
> > +}
> > +static DEVICE_ATTR_RW(manage_restart);
> > +
> > =C2=A0static ssize_t
> > =C2=A0allow_restart_show(struct device *dev, struct device_attribute
> > *attr, char *buf)
> > =C2=A0{
> > @@ -654,6 +684,7 @@ static struct attribute *sd_disk_attrs[] =3D {
> > =C2=A0	&dev_attr_manage_system_start_stop.attr,
> > =C2=A0	&dev_attr_manage_runtime_start_stop.attr,
> > =C2=A0	&dev_attr_manage_shutdown.attr,
> > +	&dev_attr_manage_restart.attr,
> > =C2=A0	&dev_attr_protection_type.attr,
> > =C2=A0	&dev_attr_protection_mode.attr,
> > =C2=A0	&dev_attr_app_tag_own.attr,
> > @@ -4175,7 +4206,9 @@ static void sd_shutdown(struct device *dev)
> > =C2=A0	=C2=A0=C2=A0=C2=A0 (system_state =3D=3D SYSTEM_POWER_OFF &&
> > =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0 sdkp->device->manage_shutdown) ||
> > =C2=A0	=C2=A0=C2=A0=C2=A0 (system_state =3D=3D SYSTEM_RUNNING &&
> > -	=C2=A0=C2=A0=C2=A0=C2=A0 sdkp->device->manage_runtime_start_stop)) {
> > +	=C2=A0=C2=A0=C2=A0=C2=A0 sdkp->device->manage_runtime_start_stop) ||
> > +	=C2=A0=C2=A0=C2=A0 (system_state =3D=3D SYSTEM_RESTART &&
> > +	=C2=A0=C2=A0=C2=A0=C2=A0 sdkp->device->manage_restart)) {
> > =C2=A0		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
> > =C2=A0		sd_start_stop_device(sdkp, 0);
> > =C2=A0	}
> > diff --git a/include/scsi/scsi_device.h
> > b/include/scsi/scsi_device.h
> > index 6d6500148c4b..c7e657ac8b6d 100644
> > --- a/include/scsi/scsi_device.h
> > +++ b/include/scsi/scsi_device.h
> > @@ -178,6 +178,12 @@ struct scsi_device {
> > =C2=A0	 */
> > =C2=A0	unsigned manage_shutdown:1;
> > =C2=A0
> > +	/*
> > +	 * If true, let the high-level device driver (sd) manage
> > the device
> > +	 * power state for system restart (reboot) operations.
>=20
> What about cold boot ? Same is needed, no ?
Not sure what you mean with cold boot here.

> The name "manage_restart" is a bit
> confusing since we already have manage_system_start_stop,
> manage_runtime_start_stop and manage_shutdown. I do not have a better
> suggestion
> though.
In that case, we could remove the DEVICE_ATTR_RW(manage_restart), so it
would not be exposed to userspace yet and can later by changed without
breaking userspace?
>=20
> > +	 */
> > +	unsigned manage_restart:1;
> > +
> > =C2=A0	/*
> > =C2=A0	 * If set and if the device is runtime suspended, ask the
> > high-level
> > =C2=A0	 * device driver (sd) to force a runtime resume of the
> > device.
>=20

Thanks
- Markus Probst
