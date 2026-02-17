Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0D236D51B
	for <linux-scsi@vger.kernel.org>; Tue, 17 Feb 2026 16:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771347491; cv=none; b=FnCKsSXaLb1mkif2lFYJTh/YO0gr5fG65HBIJY4qT4hvAtTax7oQ2u93/rvxYzD3SCbd61XIPmW0/Pqo1kmQz+EsiTgu+MPVf1IxPO7k/Snxgo/4wCmlYfxzxLKz5Y9X4Scu9gUmOXcGVYljL7bD7/lTqgvg89DJX0RRWvnlpgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771347491; c=relaxed/simple;
	bh=ieXwuS9RqKG5AbDgk6zK3Sz/gDnf1qgIn0zAze1pTE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F0qaiJY4yequULCHKeAusjmmoWcax4in9qxlO0DH3e/bVsSmHV5ZZP6GlduI1aKQbzp9BQQ6Sa2isj0Qj8yMpVUcKqW/jVH14U9iBISiZkkA7d83HbNMVwRCS0QP+fYCQNT9gz+zd+RNYB3dyX4TCnsJWaO3rd8lKHbMZHkkyLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4HIGJeI1; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4HIGJeI1"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a885af8ee7so209005ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 17 Feb 2026 08:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771347490; x=1771952290; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XlBGe6Nd5IhwkGo2tJT1WGLgnhboDh9a8xjyQWZ5EZg=;
        b=4HIGJeI1p4U2u1W7AnWPETiuTNRVFOj4/Tcf7KClz9NCMrLteZfK86yP4g9uzjXzd4
         HQfrS5xh7Z7FQI1ivcPvcxUGoAuoEIGd8lPEqEy4vLyAAR4AjJQM4WSscA5qDElgHGZC
         SyyBMpypydYZOpwFgRL6Jwo2AxwFQezoIRvdeG0epXEvImLWCGh2LWk/abqtjeBTSa5G
         x4/XrOzlt3MMFZ5NPjFDhlHGR/ahcxMkIL36j4pRN0LCBOpMgJw0x4HX7J7dGjTWoVaj
         ytosGwDDJU2VuqNYBl0XjfFuRoeexOkxw41ICqnmQM33R5VmHvQcr70bFQfOoSEdfbup
         c1CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771347490; x=1771952290;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XlBGe6Nd5IhwkGo2tJT1WGLgnhboDh9a8xjyQWZ5EZg=;
        b=Zd/ZyotwpMWkdd99IZYQeVgKLAkWi3SSc7TJOihIYjRRGQr6y6tikjE0+45n1QkkAK
         QxQAkRWerbslCVvBh7Dol1ZYO6DL2iEV4ZGuTptuXr1HJL+Ms8Xpl1lF4+9jhAuBRzQJ
         pYv4FjjxE8U5nNtpXW33u7777BLsu52VKHxg+vRQa/x8GU62Y80OECNGDoxn3Oikw63W
         ESymiS8tVmqvXhN9OzsoykBK0jJ/44g6axZIpo2xSWl2pyaBsX/CAw3+iY2gzpwrevfF
         8TIMELPA0MumADZoGmxGCT/rVzeotAxbO4c2YS6ux7ow0YdwGQHgHH+WZTTJzfNIPy/E
         bSww==
X-Forwarded-Encrypted: i=1; AJvYcCVlFtgUZDl13B/G2O+/3EsWOx/N0sZ+Asw52yD5iEUwzNFcJzQwprbePYgOfuo2bqmIaqnS5DwqRO+3@vger.kernel.org
X-Gm-Message-State: AOJu0YzITINpVD3UVlIshySNwCw0aSPREfvZdY/Ai+xIDpnDNIjkE4G0
	89DfsWyWXWRRGBkAfiXfgtwAghBFOUM4B/GcM5c6JkLgT2T1A57tb7nM9JwYvL2FEg==
X-Gm-Gg: AZuq6aL6bU3NkTszQ3vM5GJ3FdFH+tPl7cN56WnkvfBPI0q8mUsa9h6y8BPvKMBOphm
	db0g6g166raBwwuS0pCCQR35BUTkiRgkpBqTy/xLD4AFpPm7EBjFbbTbjxNupA4bUUP5MaJ8CrU
	735pgqziGtwNKT6d94uFGzZLSMHgeFN0x9BPGWYqmuK2t80eHJeIahGttoRRUlEBxF5J6laxEXK
	ZwbtF9UQFCj7UTMkbE0xMbtof8AzX2gXPeVtviJ4Zszx/IuZ27qAQtRtjYQWoUGAhQZmAlNiE59
	4vkpFwyCgT5ZmgCnlfW++kzSL/Tqzv3Hm5tWidxV5BUTrUhPnP6+dIXWqaVta9OS9M1vMGG4kZ2
	6W26yglIiGVgln6H8raoS2s76cg9JsuJ740gpa2nd/xkuQMwqcgiy2iezQgxsPKu0lykwXzPzsV
	Cmkm3pir1jgeSTbVe5LFcGsQZhxU6ttJCwkwiFIvM4Iibc+To5rdct1/heRr8ESA==
X-Received: by 2002:a17:902:8216:b0:2a0:89b0:71d7 with SMTP id d9443c01a7336-2ad36c912c4mr2366405ad.13.1771347489590;
        Tue, 17 Feb 2026 08:58:09 -0800 (PST)
Received: from google.com (185.29.127.34.bc.googleusercontent.com. [34.127.29.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3567e9da8a2sm19378161a91.5.2026.02.17.08.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 08:58:08 -0800 (PST)
Date: Tue, 17 Feb 2026 08:58:04 -0800
From: Igor Pylypiv <ipylypiv@google.com>
To: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] scsi: core: Add 'serial' sysfs attribute for SCSI/SATA
Message-ID: <aZSeHCH-IOjqw2n3@google.com>
References: <20260209212151.342151-1-ipylypiv@google.com>
 <d61a1830-d9d0-4697-b547-80106ce57023@suse.de>
 <aYtiDLvRotCE0hEt@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aYtiDLvRotCE0hEt@google.com>

On Tue, Feb 10, 2026 at 08:51:24AM -0800, Igor Pylypiv wrote:
> On Tue, Feb 10, 2026 at 12:38:51PM +0100, Hannes Reinecke wrote:
> > On 2/9/26 22:21, Igor Pylypiv wrote:
> > > Add a 'serial' sysfs attribute for SCSI and SATA devices. This attribute
> > > exposes the Unit Serial Number, which is derived from the Device
> > > Identification Vital Product Data (VPD) page 0x80.
> > > 
> > > Whitespace is stripped from the retrieved serial number to handle
> > > the different alignment (right-aligned for SCSI, potentially
> > > left-aligned for SATA). As noted in SAT-5 10.5.3, "Although SPC-5 defines
> > > the PRODUCT SERIAL NUMBER field as right-aligned, ACS-5 does not require
> > > its SERIAL NUMBER field to be right-aligned. Therefore, right-alignment
> > > of the PRODUCT SERIAL NUMBER field for the translation is not assured."
> > > 
> > > This attribute is used by tools such as lsblk to display the serial
> > > number of block devices.
> > > 
> > > Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> > > ---
> > > 
> > > v2->v3 changes:
> > > - Replaced sysfs_emit(buf, "%s\n", buf) with a manual newline placement
> > >    to avoid undefined behavior of passing the output buffer as an input.
> > > 
> > > v1->v2 changes:
> > > - Reordered declarations in scsi_vpd_lun_serial() from longest to shortest.
> > > - Replaced rcu_read_lock()/rcu_read_unlock() with guard(rcu)().
> > > 
> > > 
> > >   drivers/scsi/scsi_lib.c    | 47 ++++++++++++++++++++++++++++++++++++++
> > >   drivers/scsi/scsi_sysfs.c  | 16 +++++++++++++
> > >   include/scsi/scsi_device.h |  1 +
> > >   3 files changed, 64 insertions(+)
> > > 
> > > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > > index 4a902c9dfd8b..c17fbe4dd845 100644
> > > --- a/drivers/scsi/scsi_lib.c
> > > +++ b/drivers/scsi/scsi_lib.c
> > > @@ -13,6 +13,7 @@
> > >   #include <linux/bitops.h>
> > >   #include <linux/blkdev.h>
> > >   #include <linux/completion.h>
> > > +#include <linux/ctype.h>
> > >   #include <linux/kernel.h>
> > >   #include <linux/export.h>
> > >   #include <linux/init.h>
> > > @@ -3459,6 +3460,52 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
> > >   }
> > >   EXPORT_SYMBOL(scsi_vpd_lun_id);
> > > +/**
> > > + * scsi_vpd_lun_serial - return a unique device serial number
> > > + * @sdev: SCSI device
> > > + * @sn:   buffer for the serial number
> > > + * @sn_size: size of the buffer
> > > + *
> > > + * Copies the device serial number into @sn based on the information in
> > > + * the VPD page 0x80 of the device. The string will be null terminated
> > > + * and have leading and trailing whitespace stripped.
> > > + *
> > > + * Returns the length of the serial number or error on failure.
> > > + */
> > > +int scsi_vpd_lun_serial(struct scsi_device *sdev, char *sn, size_t sn_size)
> > > +{
> > > +	const struct scsi_vpd *vpd_pg80;
> > > +	const unsigned char *d;
> > > +	int len;
> > > +
> > > +	guard(rcu)();
> > > +	vpd_pg80 = rcu_dereference(sdev->vpd_pg80);
> > > +	if (!vpd_pg80)
> > > +		return -ENXIO;
> > > +
> > > +	len = vpd_pg80->len - 4;
> > > +	d = vpd_pg80->data + 4;
> > > +
> > > +	/* Skip leading spaces */
> > > +	while (len > 0 && isspace(*d)) {
> > > +		len--;
> > > +		d++;
> > > +	}
> > > +
> > > +	/* Skip trailing spaces */
> > > +	while (len > 0 && isspace(d[len - 1]))
> > > +		len--;
> > > +
> > 
> > Please use 'strim()' instead.
> 
> Hi Hannes,
> 
> Bart pointed this out in V1 as well. I'll copy-paste my reply from V1:
> 
> "Yes, I considered using strim(). strim() modifies the input buffer by
> replacing first trailing whitespace with '\0' so we can't use it directly
> on the vpd_pg80->data. The solution would be to copy the whole vpd page
> data into the sn buffer and call strim() on the sn buffer. strim() returns
> a pointer to the first non-whitespace character so we would also need to
> memmove the serial number to the beginning of the sn buffer. All this extra
> copying seems to be redundant so I went ahead with a simpler solution
> that does a single memcpy()."
> 
> Please let me know your thoughts on this.

Hi Hannes,

Ping for a feedback.
Sending this in case my previous reply fell through the cracks.

Thank you!
Igor

> 
> > 
> > > +	if (sn_size < len + 1)
> > > +		return -EINVAL;
> > > +
> > > +	memcpy(sn, d, len);
> > 
> > 'len' might well be '0' after 'strim()', please check
> > before calling 'memcpy'.
> 
> It looks like calling a memcpy() with zero length is a no-op. Is checking
> for len > 0 really necessary in this case?
> 
> Thank you,
> Igor
> 
> > > +	sn[len] = '\0';
> > > +
> > > +	return len;
> > > +}
> > > +EXPORT_SYMBOL(scsi_vpd_lun_serial);
> > > +
> > >   /**
> > >    * scsi_vpd_tpg_id - return a target port group identifier
> > >    * @sdev: SCSI device
> > > diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> > > index 99eb0a30df61..9c4f47e7a298 100644
> > > --- a/drivers/scsi/scsi_sysfs.c
> > > +++ b/drivers/scsi/scsi_sysfs.c
> > > @@ -1013,6 +1013,21 @@ sdev_show_wwid(struct device *dev, struct device_attribute *attr,
> > >   }
> > >   static DEVICE_ATTR(wwid, S_IRUGO, sdev_show_wwid, NULL);
> > > +static ssize_t
> > > +sdev_show_serial(struct device *dev, struct device_attribute *attr, char *buf)
> > > +{
> > > +	struct scsi_device *sdev = to_scsi_device(dev);
> > > +	ssize_t ret;
> > > +
> > > +	ret = scsi_vpd_lun_serial(sdev, buf, PAGE_SIZE);
> > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > > +	buf[ret] = '\n';
> > > +	return ret + 1;
> > > +}
> > > +static DEVICE_ATTR(serial, S_IRUGO, sdev_show_serial, NULL);
> > > +
> > >   #define BLIST_FLAG_NAME(name)					\
> > >   	[const_ilog2((__force __u64)BLIST_##name)] = #name
> > >   static const char *const sdev_bflags_name[] = {
> > > @@ -1257,6 +1272,7 @@ static struct attribute *scsi_sdev_attrs[] = {
> > >   	&dev_attr_device_busy.attr,
> > >   	&dev_attr_vendor.attr,
> > >   	&dev_attr_model.attr,
> > > +	&dev_attr_serial.attr,
> > >   	&dev_attr_rev.attr,
> > >   	&dev_attr_rescan.attr,
> > >   	&dev_attr_delete.attr,
> > > diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> > > index d32f5841f4f8..9c2a7bbe5891 100644
> > > --- a/include/scsi/scsi_device.h
> > > +++ b/include/scsi/scsi_device.h
> > > @@ -571,6 +571,7 @@ void scsi_put_internal_cmd(struct scsi_cmnd *scmd);
> > >   extern void sdev_disable_disk_events(struct scsi_device *sdev);
> > >   extern void sdev_enable_disk_events(struct scsi_device *sdev);
> > >   extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
> > > +extern int scsi_vpd_lun_serial(struct scsi_device *, char *, size_t);
> > >   extern int scsi_vpd_tpg_id(struct scsi_device *, int *);
> > >   #ifdef CONFIG_PM
> > 
> > Otherwise looks okay.
> > 
> > Cheers,
> > 
> > Hannes
> > -- 
> > Dr. Hannes Reinecke                  Kernel Storage Architect
> > hare@suse.de                                +49 911 74053 688
> > SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
> > HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
