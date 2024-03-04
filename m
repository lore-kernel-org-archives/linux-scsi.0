Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA6D7868F
	for <linux-scsi@vger.kernel.org>; Mon,  4 Mar 2024 22:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709590536; cv=none; b=Tou9sfBtCOpBWq6tLrxec1LYZOkqGPBx1KWUKVDt5uIfwU8EH4ulBM3q8zVhbRO5APWJH/DxbY1G7eL82UMj4ub9rO1FwFDOS1cr7TWBnKsLm0A6IY1Aka9bDhBnD4QmNzruBOsnjyo7JIYOAqSzKHVuyKRRVLGLw5oQkI0n5bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709590536; c=relaxed/simple;
	bh=Ywwfa5hw3g3wV4YuKstMZgWxolfExRYUJDz6ONhDQPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YncOujeBvkvXAF7ZKuoQxspjCYwSxBOcX1/b1/DBGGnVdQKfVr11xr8Fc6GUZ+N2C0KdVsp1Bx0TY3cB8cfg9zkAlVEe9rbAeTpr8oFqzPPW8U6uIYw0SCcCGUdg4t5chA7O5ILKxx28DUZda5GZehE6oRy1cPcTtE2tUUf/bSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GByNeGXu; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GByNeGXu"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6e5c0be115aso2167048b3a.3
        for <linux-scsi@vger.kernel.org>; Mon, 04 Mar 2024 14:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709590533; x=1710195333; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CSTIJJSftklFQL8UGUvWnO8gT1gJvRrz6tflwqRvH64=;
        b=GByNeGXu3mpKAP7KYOO2fiHJHa12KRG5RXYRwRreTb8kjQGlPb0RYVix/kQssGHzmg
         JyZkr1G+DCzUaVkvFbYRvhxx9+Kz6YtOI5GvgK/VnU6jiDY/q8suiKabRqggLFwKc7cF
         0FCcwp822HVaZE8nCNLytXMZK1IGGepTyQhh9k+9FAHHwiZm7tIKUapF/7ha6Ggi+vit
         LbRq6SJUvTvGRHwyDoex4Z49D1LSVb4CTHynN1rJn2vW53bZ6A19OF+teVNUWP0wGo7H
         XJz2WQ5ipdscUGNS2SFFGtqmiNBmrd5Jpr3Ltf+N90XXkx/ja3yqa/4QVuZngYMLhHs9
         B4aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709590533; x=1710195333;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CSTIJJSftklFQL8UGUvWnO8gT1gJvRrz6tflwqRvH64=;
        b=K4ogB3kTsiBjqf8CYacORvrNWR7RbLWdq+Kon+6NhjSHNnNfwvVSp4P9kLRneEtzCN
         5zwopSVj8w5Qbl4WvNqKg20hpWVrHEsxX5xwKg8XkhEdUJM+6SvIq8jCCkTac3Arvngc
         PtLfJJlhZ3RuPGCRY6NTcLq/zREEufkrb0Ec7L9tnjq9GRNEHyUwTZi7h/SlRytI2eZJ
         Cq0blvGJoqpSbUB6WZNQh8uyPhz0R3Spyp1znlWXvwFcO7EvLOZMsyCTaWiDIO5zImWm
         1mLJLyGmcz+aKfdykTyPiIs4D949PBHMaxsaRNdhneCH0Oa6c5miCCkZ8ENJmlsGmUcn
         ZNRA==
X-Forwarded-Encrypted: i=1; AJvYcCXtG2WxFIPXnoz1T3eGOL7TKPNss5O9SqV9AcrFe7K6v5c1gBMFgblpN0DTu/Pkb/Xo6vsZn02TRCmFmzAlZkL+43mC3qDiY79JvQ==
X-Gm-Message-State: AOJu0YwR2U4+LFK6bpjVHIwa/JPCccwP5gCCE+FHNT44QDmtg5mWurub
	eMCVYJzlgZfK3I+ONb7BqKIqVnPlhV0fXw5cClzO0w2TWsAagiQzMc1uYJG02A==
X-Google-Smtp-Source: AGHT+IHt/hQua7h8iZoyVsAhREKa+jlMeGGZA/YCtHYwR0B6JyCyglCHiHhKof9hlPuS6WTl1DYncQ==
X-Received: by 2002:a05:6a20:938f:b0:1a1:e75:477c with SMTP id x15-20020a056a20938f00b001a10e75477cmr39790pzh.9.1709590532931;
        Mon, 04 Mar 2024 14:15:32 -0800 (PST)
Received: from google.com ([2620:15c:2c5:13:e901:e760:20cd:d870])
        by smtp.gmail.com with ESMTPSA id hq4-20020a056a00680400b006e4e93f4f17sm7817163pfb.117.2024.03.04.14.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 14:15:32 -0800 (PST)
Date: Mon, 4 Mar 2024 14:15:26 -0800
From: Igor Pylypiv <ipylypiv@google.com>
To: John Garry <john.g.garry@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
	Jason Yan <yanaijie@huawei.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Hannes Reinecke <hare@suse.de>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
	Bart Van Assche <bvanassche@acm.org>,
	TJ Adams <tadamsjr@google.com>, linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/7] ata: libata-sata: Factor out NCQ Priority
 configuration helpers
Message-ID: <ZeZH_jX4SO9YxgXk@google.com>
References: <20240302201636.1228331-1-ipylypiv@google.com>
 <20240302201636.1228331-2-ipylypiv@google.com>
 <5c20140a-79e8-4d0a-899a-d4ec5c9def42@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c20140a-79e8-4d0a-899a-d4ec5c9def42@oracle.com>

On Mon, Mar 04, 2024 at 08:34:52AM +0000, John Garry wrote:
> On 02/03/2024 20:16, Igor Pylypiv wrote:
> > Export libata NCQ Priority configuration helpers to be reused
> > for libsas managed SATA devices.
> > 
> > Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> 
> This looks ok. Some small code comments below, though.
> 
> > ---
> >   drivers/ata/libata-sata.c | 139 +++++++++++++++++++++++++++-----------
> >   include/linux/libata.h    |   4 ++
> >   2 files changed, 103 insertions(+), 40 deletions(-)
> > 
> > diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
> > index 0fb1934875f2..a8d5e36d5211 100644
> > --- a/drivers/ata/libata-sata.c
> > +++ b/drivers/ata/libata-sata.c
> > @@ -848,29 +848,73 @@ DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
> >   	    ata_scsi_lpm_show, ata_scsi_lpm_store);
> >   EXPORT_SYMBOL_GPL(dev_attr_link_power_management_policy);
> > +/**
> > + *	ata_ncq_prio_supported - Check if device supports NCQ Priority
> > + *	@ap: ATA port of the target device
> > + *	@sdev: SCSI device
> > + *
> > + *	Helper to check if device supports NCQ Priority feature,
> > + *	usable with both libsas and libata.
> > + */
> > +int ata_ncq_prio_supported(struct ata_port *ap, struct scsi_device *sdev)
> > +{
> > +	struct ata_device *dev;
> > +	unsigned long flags;
> > +	int rc;
> > +
> > +	spin_lock_irqsave(ap->lock, flags);
> > +	dev = ata_scsi_find_dev(ap, sdev);
> > +	if (!dev)
> > +		rc = -ENODEV;
> > +	else
> > +		rc = !!(dev->flags & ATA_DFLAG_NCQ_PRIO);
> > +	spin_unlock_irqrestore(ap->lock, flags);
> > +	return rc;
> > +}
> 
> I'm not the biggest fan of functions which effectively return both a boolean
> and an error code.
> 
> I like this patten more:
> 
> int ata_ncq_prio_supported(struct ata_port *ap, struct scsi_device *sdev,
> bool *supported)
> {
> 	...
> 	if (rc)
> 		return rc;
> 	*supported = true/false.
> 	return 0;
> }
> 
> No big deal, though.

Thanks for the review, John. Separating out an error code and a boolean
makes the code a bit more readable. Sent out v4 with the changes.

> 
> > +EXPORT_SYMBOL_GPL(ata_ncq_prio_supported);
> > +
> >   static ssize_t ata_ncq_prio_supported_show(struct device *device,
> >   					   struct device_attribute *attr,
> >   					   char *buf)
> >   {
> >   	struct scsi_device *sdev = to_scsi_device(device);
> >   	struct ata_port *ap = ata_shost_to_port(sdev->host);
> > +	int rc;
> > +
> > +	rc = ata_ncq_prio_supported(ap, sdev);
> > +	if (rc < 0)
> > +		return rc;
> > +
> > +	return sysfs_emit(buf, "%d\n", rc);
> > +}
> > +
> > +DEVICE_ATTR(ncq_prio_supported, S_IRUGO, ata_ncq_prio_supported_show, NULL);
> > +EXPORT_SYMBOL_GPL(dev_attr_ncq_prio_supported);
> > +
> > +/**
> > + *	ata_ncq_prio_enabled - Check if NCQ Priority is enabled
> > + *	@ap: ATA port of the target device
> > + *	@sdev: SCSI device
> > + *
> > + *	Helper to check if NCQ Priority feature is enabled,
> > + *	usable with both libsas and libata.
> 
> It's usable by anything which uses libata, really. For the moment that is
> libsas and libata.
> 
> > + */
> > +int ata_ncq_prio_enabled(struct ata_port *ap, struct scsi_device *sdev)
> > +{
> >   	struct ata_device *dev;
> > -	bool ncq_prio_supported;
> > -	int rc = 0;
> > +	unsigned long flags;
> > +	int rc;
> > -	spin_lock_irq(ap->lock);
> > +	spin_lock_irqsave(ap->lock, flags);
> >   	dev = ata_scsi_find_dev(ap, sdev);
> >   	if (!dev)
> >   		rc = -ENODEV;
> >   	else
> > -		ncq_prio_supported = dev->flags & ATA_DFLAG_NCQ_PRIO;
> > -	spin_unlock_irq(ap->lock);
> > -
> > -	return rc ? rc : sysfs_emit(buf, "%u\n", ncq_prio_supported);
> > +		rc = !!(dev->flags & ATA_DFLAG_NCQ_PRIO_ENABLED);
> > +	spin_unlock_irqrestore(ap->lock, flags);
> > +	return rc;
> >   }
> > -
> > -DEVICE_ATTR(ncq_prio_supported, S_IRUGO, ata_ncq_prio_supported_show, NULL);
> > -EXPORT_SYMBOL_GPL(dev_attr_ncq_prio_supported);
> > +EXPORT_SYMBOL_GPL(ata_ncq_prio_enabled);
> >   static ssize_t ata_ncq_prio_enable_show(struct device *device,
> >   					struct device_attribute *attr,
> > @@ -878,50 +922,45 @@ static ssize_t ata_ncq_prio_enable_show(struct device *device,
> >   {
> >   	struct scsi_device *sdev = to_scsi_device(device);
> >   	struct ata_port *ap = ata_shost_to_port(sdev->host);
> > -	struct ata_device *dev;
> > -	bool ncq_prio_enable;
> > -	int rc = 0;
> > +	int rc;
> > -	spin_lock_irq(ap->lock);
> > -	dev = ata_scsi_find_dev(ap, sdev);
> > -	if (!dev)
> > -		rc = -ENODEV;
> > -	else
> > -		ncq_prio_enable = dev->flags & ATA_DFLAG_NCQ_PRIO_ENABLED;
> > -	spin_unlock_irq(ap->lock);
> > +	rc = ata_ncq_prio_enabled(ap, sdev);
> > +	if (rc < 0)
> > +		return rc;
> > -	return rc ? rc : sysfs_emit(buf, "%u\n", ncq_prio_enable);
> > +	return sysfs_emit(buf, "%d\n", rc);
> >   }
> > -static ssize_t ata_ncq_prio_enable_store(struct device *device,
> > -					 struct device_attribute *attr,
> > -					 const char *buf, size_t len)
> > +/**
> > + *	ata_ncq_prio_enable - Enable/disable NCQ Priority
> > + *	@ap: ATA port of the target device
> > + *	@sdev: SCSI device
> > + *	@enable: true - enable NCQ Priority, false - disable NCQ Priority
> > + *
> > + *	Helper to enable/disable NCQ Priority feature, usable with both
> > + *	libsas and libata.
> > + */
> > +int ata_ncq_prio_enable(struct ata_port *ap, struct scsi_device *sdev,
> > +			bool enable)
> >   {
> > -	struct scsi_device *sdev = to_scsi_device(device);
> > -	struct ata_port *ap;
> >   	struct ata_device *dev;
> > -	long int input;
> > +	unsigned long flags;
> >   	int rc = 0;
> > -	rc = kstrtol(buf, 10, &input);
> > -	if (rc)
> > -		return rc;
> > -	if ((input < 0) || (input > 1))
> > -		return -EINVAL;
> > +	spin_lock_irqsave(ap->lock, flags);
> > -	ap = ata_shost_to_port(sdev->host);
> >   	dev = ata_scsi_find_dev(ap, sdev);
> > -	if (unlikely(!dev))
> > -		return  -ENODEV;
> > -
> > -	spin_lock_irq(ap->lock);
> > +	if (unlikely(!dev)) {
> 
> no need for unlikely() - this is not fathpath
> 
> > +		rc = -ENODEV;
> > +		goto unlock;
> > +	}
> >   	if (!(dev->flags & ATA_DFLAG_NCQ_PRIO)) {
> >   		rc = -EINVAL;
> >   		goto unlock;
> 
