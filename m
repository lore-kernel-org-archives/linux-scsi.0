Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF1231985B
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 16:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770742293; cv=none; b=hp8Z8asHUmvSdK89XsnZLBgF7PptFeulnVv1A5YJ6fVOeuYb5mu+J61vfZ0INwb9HtPinLPw1llq2t4bljJyGlUbTIp8Y5AnYABfcZ3mzP3yXLawD9aSCnKaIjTLGXHrE1rRxFjwM3vu1Z6upAuUZwGdmzQ2qjcrXx/5FeAMZS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770742293; c=relaxed/simple;
	bh=aWS004gOUWanJVurW2ze/F4zrzZwHauMVj1dvy1BON8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TZ26GQYJkBMu0y/tSFAZldPeH+JWI580mI0Kbh83JTDXyb2k2zuGRk8T8BL/5C1UK11K9BN4PT2M07uXG5JEDekUJ6rUNG4/lRK1G5nKdU/hTnJLwTec9+1WJanVfZAF33IwmqBInghCEfhj/F3lGRlhM44UDhYIXIuABnKNKQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2/2laX4h; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2/2laX4h"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a76b39587aso97905ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 08:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770742290; x=1771347090; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=989tdQAlf781B/sL6qZb8qmAzQttQ316aWChUa1Nooo=;
        b=2/2laX4hJUEJT7XYzg+oGdzB4tey9zLM7VXI5Le08+C4aHHgD0ffrteA7p9g40yMJX
         akk1N8T4QeZaTXUTAlOmXZ/fh/izERGkfjtF+Kz6WKAqz51d/V6NYJJe+pLtzw0vXLq5
         17xPoo3MyndfBLpf5zLkgWhKO5VLHH1aLfbi1/Uj24bDBWidCHOxLXJcF4XYCLd6j1+u
         t1b/8wSeXwfZNbOp89CG9g625PcgCz8Tu/TT3rHRMcC62OPVpBjDTkHoLRXmnpHjY6sH
         OWPv9SpUs8KXlmDonTy5+qjRenkRWCq4YBFs54ALbA4o3k8RoBVt4AAKHpivNDPT+RWb
         GnOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770742290; x=1771347090;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=989tdQAlf781B/sL6qZb8qmAzQttQ316aWChUa1Nooo=;
        b=V1PLCdW9rLAHBQhfio8qSwWmmI1DhzU60/WWjS3VDb5lOW0W3AjBWVnmX1tP210alM
         wfYcEUNhG3soYFHMi0YHseClsHhF3FX1OqzyTSOUidXada59VltWlrM51T6peR+Ne8Eu
         M0JPKJzTDJJXNtKAtbhmh3o+eQEcAS9PdwsKYiAmVSV4JJ30cAVIa0USXuSnEUdwh35U
         SEey3vNuimojgJSvwhR5uZPaY4m3J9zWxNrT2wZKHsLnpaj7+r7A9xXOzJfek81SSZZ0
         VclyDZSgA8aVuJPHd204wMnPGFc+k70EdsLH4LPFNiNSZvqOkKhyAeF9ui3HkTtH1NwB
         Uu/A==
X-Forwarded-Encrypted: i=1; AJvYcCVlDz5iaBJu07VJ4B0Y5zMKZ5L9b11PxSbpbzT/dJd0BR38th/exAh7DnQakcY63XzInPkmJC+d0+GX@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3WgGw0rfUvAle2V3ToOGIIDusb7tc5/bdcXFpjoiYCEuvhfB+
	U5iBSHQcIHF3HUKneCCbNLZefPQ/8ShGqw1pZzZIebjYw15lTHP+Ff/y9RKAYR7f5q2E8L951Qj
	rjEQWqg==
X-Gm-Gg: AZuq6aJTZVKpH5Z820SxsdDW9ZCqRNBAtW9nq8zs0FT6ea6qLFs2QC36IFGs3Gcg3W3
	51wSA80W/y1IT+m5EzW97H9AY4GOGu4rX3wbpDjhvu3vtYWxnjLKQu2ObQL4fgrU+LrHBPQlmJv
	cKguYwLii9WdgPib8gDM+1cRwDKtOsCG3cNv2rwC6EITM4uJczzy7JYZL4/SEWfhH5WsehauGnM
	EzDj6+KbxpMnHaUXAkun7VoOrCSwxVEwiMY0s/p+SpeNeaQBGkwjUaAewRJKSxcuUnEiAqNsI31
	cXNgmHDqsAbo/2Cf/2UdQMjElRuSgHCJkRzAueMAkGh1Omf4VKGW5RjSvWmguHi39BDk1zLA8mM
	8JONNm9MpO7mOi4VUd3FhZtHR3jdrvMFcvr4BaGIQy/kG0ycgTiCI/uDtkPoscFjD+1nK/nzhrk
	kcB6myIrLI6MpodehWpNdNeyva9kdTkg0VsyQ/AWEN3dor+7L0DbPhWSQwzjXkAg==
X-Received: by 2002:a17:902:ea0c:b0:297:f2a0:e564 with SMTP id d9443c01a7336-2ab100b9cfamr2505385ad.11.1770742289657;
        Tue, 10 Feb 2026 08:51:29 -0800 (PST)
Received: from google.com (185.29.127.34.bc.googleusercontent.com. [34.127.29.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a9521f8cb6sm149589995ad.79.2026.02.10.08.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 08:51:29 -0800 (PST)
Date: Tue, 10 Feb 2026 08:51:24 -0800
From: Igor Pylypiv <ipylypiv@google.com>
To: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] scsi: core: Add 'serial' sysfs attribute for SCSI/SATA
Message-ID: <aYtiDLvRotCE0hEt@google.com>
References: <20260209212151.342151-1-ipylypiv@google.com>
 <d61a1830-d9d0-4697-b547-80106ce57023@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d61a1830-d9d0-4697-b547-80106ce57023@suse.de>

On Tue, Feb 10, 2026 at 12:38:51PM +0100, Hannes Reinecke wrote:
> On 2/9/26 22:21, Igor Pylypiv wrote:
> > Add a 'serial' sysfs attribute for SCSI and SATA devices. This attribute
> > exposes the Unit Serial Number, which is derived from the Device
> > Identification Vital Product Data (VPD) page 0x80.
> > 
> > Whitespace is stripped from the retrieved serial number to handle
> > the different alignment (right-aligned for SCSI, potentially
> > left-aligned for SATA). As noted in SAT-5 10.5.3, "Although SPC-5 defines
> > the PRODUCT SERIAL NUMBER field as right-aligned, ACS-5 does not require
> > its SERIAL NUMBER field to be right-aligned. Therefore, right-alignment
> > of the PRODUCT SERIAL NUMBER field for the translation is not assured."
> > 
> > This attribute is used by tools such as lsblk to display the serial
> > number of block devices.
> > 
> > Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> > ---
> > 
> > v2->v3 changes:
> > - Replaced sysfs_emit(buf, "%s\n", buf) with a manual newline placement
> >    to avoid undefined behavior of passing the output buffer as an input.
> > 
> > v1->v2 changes:
> > - Reordered declarations in scsi_vpd_lun_serial() from longest to shortest.
> > - Replaced rcu_read_lock()/rcu_read_unlock() with guard(rcu)().
> > 
> > 
> >   drivers/scsi/scsi_lib.c    | 47 ++++++++++++++++++++++++++++++++++++++
> >   drivers/scsi/scsi_sysfs.c  | 16 +++++++++++++
> >   include/scsi/scsi_device.h |  1 +
> >   3 files changed, 64 insertions(+)
> > 
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 4a902c9dfd8b..c17fbe4dd845 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -13,6 +13,7 @@
> >   #include <linux/bitops.h>
> >   #include <linux/blkdev.h>
> >   #include <linux/completion.h>
> > +#include <linux/ctype.h>
> >   #include <linux/kernel.h>
> >   #include <linux/export.h>
> >   #include <linux/init.h>
> > @@ -3459,6 +3460,52 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
> >   }
> >   EXPORT_SYMBOL(scsi_vpd_lun_id);
> > +/**
> > + * scsi_vpd_lun_serial - return a unique device serial number
> > + * @sdev: SCSI device
> > + * @sn:   buffer for the serial number
> > + * @sn_size: size of the buffer
> > + *
> > + * Copies the device serial number into @sn based on the information in
> > + * the VPD page 0x80 of the device. The string will be null terminated
> > + * and have leading and trailing whitespace stripped.
> > + *
> > + * Returns the length of the serial number or error on failure.
> > + */
> > +int scsi_vpd_lun_serial(struct scsi_device *sdev, char *sn, size_t sn_size)
> > +{
> > +	const struct scsi_vpd *vpd_pg80;
> > +	const unsigned char *d;
> > +	int len;
> > +
> > +	guard(rcu)();
> > +	vpd_pg80 = rcu_dereference(sdev->vpd_pg80);
> > +	if (!vpd_pg80)
> > +		return -ENXIO;
> > +
> > +	len = vpd_pg80->len - 4;
> > +	d = vpd_pg80->data + 4;
> > +
> > +	/* Skip leading spaces */
> > +	while (len > 0 && isspace(*d)) {
> > +		len--;
> > +		d++;
> > +	}
> > +
> > +	/* Skip trailing spaces */
> > +	while (len > 0 && isspace(d[len - 1]))
> > +		len--;
> > +
> 
> Please use 'strim()' instead.

Hi Hannes,

Bart pointed this out in V1 as well. I'll copy-paste my reply from V1:

"Yes, I considered using strim(). strim() modifies the input buffer by
replacing first trailing whitespace with '\0' so we can't use it directly
on the vpd_pg80->data. The solution would be to copy the whole vpd page
data into the sn buffer and call strim() on the sn buffer. strim() returns
a pointer to the first non-whitespace character so we would also need to
memmove the serial number to the beginning of the sn buffer. All this extra
copying seems to be redundant so I went ahead with a simpler solution
that does a single memcpy()."

Please let me know your thoughts on this.

> 
> > +	if (sn_size < len + 1)
> > +		return -EINVAL;
> > +
> > +	memcpy(sn, d, len);
> 
> 'len' might well be '0' after 'strim()', please check
> before calling 'memcpy'.

It looks like calling a memcpy() with zero length is a no-op. Is checking
for len > 0 really necessary in this case?

Thank you,
Igor

> > +	sn[len] = '\0';
> > +
> > +	return len;
> > +}
> > +EXPORT_SYMBOL(scsi_vpd_lun_serial);
> > +
> >   /**
> >    * scsi_vpd_tpg_id - return a target port group identifier
> >    * @sdev: SCSI device
> > diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> > index 99eb0a30df61..9c4f47e7a298 100644
> > --- a/drivers/scsi/scsi_sysfs.c
> > +++ b/drivers/scsi/scsi_sysfs.c
> > @@ -1013,6 +1013,21 @@ sdev_show_wwid(struct device *dev, struct device_attribute *attr,
> >   }
> >   static DEVICE_ATTR(wwid, S_IRUGO, sdev_show_wwid, NULL);
> > +static ssize_t
> > +sdev_show_serial(struct device *dev, struct device_attribute *attr, char *buf)
> > +{
> > +	struct scsi_device *sdev = to_scsi_device(dev);
> > +	ssize_t ret;
> > +
> > +	ret = scsi_vpd_lun_serial(sdev, buf, PAGE_SIZE);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	buf[ret] = '\n';
> > +	return ret + 1;
> > +}
> > +static DEVICE_ATTR(serial, S_IRUGO, sdev_show_serial, NULL);
> > +
> >   #define BLIST_FLAG_NAME(name)					\
> >   	[const_ilog2((__force __u64)BLIST_##name)] = #name
> >   static const char *const sdev_bflags_name[] = {
> > @@ -1257,6 +1272,7 @@ static struct attribute *scsi_sdev_attrs[] = {
> >   	&dev_attr_device_busy.attr,
> >   	&dev_attr_vendor.attr,
> >   	&dev_attr_model.attr,
> > +	&dev_attr_serial.attr,
> >   	&dev_attr_rev.attr,
> >   	&dev_attr_rescan.attr,
> >   	&dev_attr_delete.attr,
> > diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> > index d32f5841f4f8..9c2a7bbe5891 100644
> > --- a/include/scsi/scsi_device.h
> > +++ b/include/scsi/scsi_device.h
> > @@ -571,6 +571,7 @@ void scsi_put_internal_cmd(struct scsi_cmnd *scmd);
> >   extern void sdev_disable_disk_events(struct scsi_device *sdev);
> >   extern void sdev_enable_disk_events(struct scsi_device *sdev);
> >   extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
> > +extern int scsi_vpd_lun_serial(struct scsi_device *, char *, size_t);
> >   extern int scsi_vpd_tpg_id(struct scsi_device *, int *);
> >   #ifdef CONFIG_PM
> 
> Otherwise looks okay.
> 
> Cheers,
> 
> Hannes
> -- 
> Dr. Hannes Reinecke                  Kernel Storage Architect
> hare@suse.de                                +49 911 74053 688
> SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
> HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
