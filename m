Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01991B80B
	for <linux-scsi@vger.kernel.org>; Wed,  6 Mar 2024 21:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759610; cv=none; b=ZzVEWwMyjr47OxGTwLnQ190gN+GojRChlG7OubhCaL3+D3TuM/RoSenVFOeBCgMHAreZvPoHne1CC3SHVQc7eSP/v9W9XL/DOfahxfJyq6ZW/j2JpX+zzqDXXr5t8VC8NfZHhKYLjXx3hLJcFkAFj2qOeYz4T+2tX0kew2jelN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759610; c=relaxed/simple;
	bh=d883N2vJtpZj5bifCRAlDtYmvlYuDPPoWBWkmtRiq6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BoUdUjj3E45OAGfeGjJ7xzZu/qulYn0fTg99zEXvBGhq7LPYkkfQXiCPRbmz1XJ6Ed4UIihLOqmmIFGlVcoTg9nnn4E5sIEPJ4rNybeOjyyrSyilNDtbpfZ81cEiRxLdijSxSWN5JID7D9F+ItO1rvLsuYJ+OdkHMIcLyBlaLF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3MlpxjPt; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3MlpxjPt"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1dc09556599so1739465ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Mar 2024 13:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709759608; x=1710364408; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l2JVk38XPxvsT3/YhoDsMGF+vCTpgTNDdkuD7ePo4Wc=;
        b=3MlpxjPtVLPVJ5BScvq0HiKkCmWisnlK5Ozt8VO/pN7XFO7YPc6ynB16pLx8vDmE2b
         fI/3LDxOpB4Iu8+HSM8F4MIfRAMJIyH6k1sFv7oldzb8U6hKtJYfGi1hfATts+f3ATzu
         J6U2LDjS6pCafGa+LYU1ts57MXbwEk2NMDiM2JRTBeJcbOaguhXUCFaknOO0QHPAyeG5
         +OeyzrxncKsk974cNimDVbUbxXTWO1BqpNWUnoQodthV83TFKUIzAQRGyLga6kgRK+jg
         XLTbXmZNIMHg7Cvbsp303SASiHAcvg5BquewW2wrr9kmbVLu8xyp3BWRDMAqcWzLjxxt
         LLAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709759608; x=1710364408;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l2JVk38XPxvsT3/YhoDsMGF+vCTpgTNDdkuD7ePo4Wc=;
        b=mvVBsaWR5qK9CGtKu0JIPTEYfw/AG2QHXYGMAZRNDA0NLAAW1Mmp72xy/P17GDN12o
         ilQxnaiPOGmDia0diqnqOVdUB4wI7Nb9f+7C1LnAKXo8nH26SyJsKtvYNajXcPincI3T
         MGnyHGEfLaEh4p7fGOMbOndrvZXyRzwQHfi5i7c0n8SAfTJNk0KSzehVLbZZZIl0DYWO
         g/7gL5rhxbWM5jgMi9U/9IfRGIAo50SozLilIWw74ngWsHsl/mU6ksDn45xVGdLCtwY3
         owytSTP4iivQHbIBvDa1F+iXXE0JzXM1OsLyvKagC7QG4+03UR+2FfQjPnjww6bZyXFX
         QK9w==
X-Forwarded-Encrypted: i=1; AJvYcCVQ/MiG05uL6wVNW/7C6rVyfpaiHY2DB1UAs5Kkk+/RtPihb3pixtbk7n+0JJJBodGzoC1JfgJZnZpAkoExmkcQI1uiVOuXZWgiPg==
X-Gm-Message-State: AOJu0YzOhWjyo45RQxrsFS5gtb26FQehpW+Byl6f5OjZXa6i36vdz7pY
	ZEPKfFCqVKuoBU6uHBLbt67mc2yllH0XzRPrf5TgNu60wIkmwRckI4RAdu0s+A==
X-Google-Smtp-Source: AGHT+IEjY5wfLmhvO6o+PFnHEKHo1lDD+P9YoVu1QuPXyRH71YIGQ7FOVYJlLAbtUP4oshOZLuF4Yg==
X-Received: by 2002:a17:903:18f:b0:1dd:152:225d with SMTP id z15-20020a170903018f00b001dd0152225dmr8094717plg.8.1709759607700;
        Wed, 06 Mar 2024 13:13:27 -0800 (PST)
Received: from google.com ([2620:15c:2c5:13:9a91:c17:53d9:d156])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902a3cc00b001dbad2172cbsm13343407plb.8.2024.03.06.13.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Mar 2024 13:13:27 -0800 (PST)
Date: Wed, 6 Mar 2024 13:13:22 -0800
From: Igor Pylypiv <ipylypiv@google.com>
To: Niklas Cassel <cassel@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
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
Subject: Re: [PATCH v7 4/7] scsi: mvsas: Add libsas SATA sysfs attributes
 group
Message-ID: <ZejccpVEsQTHjltB@google.com>
References: <20240306012226.3398927-1-ipylypiv@google.com>
 <20240306012226.3398927-5-ipylypiv@google.com>
 <ZehLl4AymauIvYl8@ryzen>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZehLl4AymauIvYl8@ryzen>

On Wed, Mar 06, 2024 at 11:55:19AM +0100, Niklas Cassel wrote:
> On Tue, Mar 05, 2024 at 05:22:23PM -0800, Igor Pylypiv wrote:
> > The added sysfs attributes group enables the configuration of NCQ Priority
> > feature for HBAs that rely on libsas to manage SATA devices.
> > 
> > Reviewed-by: John Garry <john.g.garry@oracle.com>
> > Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> > Reviewed-by: Jason Yan <yanaijie@huawei.com>
> > Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> > ---
> >  drivers/scsi/mvsas/mv_init.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
> > index 43ebb331e216..f1090bb5f2c9 100644
> > --- a/drivers/scsi/mvsas/mv_init.c
> > +++ b/drivers/scsi/mvsas/mv_init.c
> > @@ -26,6 +26,7 @@ static const struct mvs_chip_info mvs_chips[] = {
> >  };
> >  
> >  static const struct attribute_group *mvst_host_groups[];
> > +static const struct attribute_group *mvst_sdev_groups[];
> 
> I think you can remove this line.
>
I kept the forward declaration to match the mvst_host_groups style.

Perhaps mvs_sht can be moved to the bottom of the file so that all forward
declarations can be removed? This can be done in a separate cleanup patch
series.

I'll keep this and aic94xx patches as-is, unless there are objections.

> 
> >  
> >  #define SOC_SAS_NUM 2
> >  
> > @@ -53,6 +54,7 @@ static const struct scsi_host_template mvs_sht = {
> >  	.compat_ioctl		= sas_ioctl,
> >  #endif
> >  	.shost_groups		= mvst_host_groups,
> > +	.sdev_groups		= mvst_sdev_groups,
> >  	.track_queue_depth	= 1,
> >  };
> >  
> > @@ -779,6 +781,11 @@ static struct attribute *mvst_host_attrs[] = {
> >  
> >  ATTRIBUTE_GROUPS(mvst_host);
> >  
> > +static const struct attribute_group *mvst_sdev_groups[] = {
> > +	&sas_ata_sdev_attr_group,
> > +	NULL
> > +};
> 
> ..and move these lines up to be after:
> static const struct attribute_group *mvst_host_groups[];
> 
> 
> > +
> >  module_init(mvs_init);
> >  module_exit(mvs_exit);
> >  
> > -- 
> > 2.44.0.278.ge034bb2e1d-goog
> > 
