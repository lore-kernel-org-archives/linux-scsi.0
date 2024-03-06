Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8501417551
	for <linux-scsi@vger.kernel.org>; Wed,  6 Mar 2024 20:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709758583; cv=none; b=JsZzhY0ncL4aleDJVPPfGBvVwc4TdZ4/RQwVbaEFLFFVnuY2kvvfTuM5SH8eNdY2ngRLspxUl0kygeI+JtzNLQg6lwICd9Nnep32gw+2WGO/R3KGKJTsYGcgjoqUbH/c0I/4SXjMvarcwIDxXfDo7/AI2Qet6npzxrN9TgleFVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709758583; c=relaxed/simple;
	bh=chMLxuuJhus8RSm2D1A6/5wioNv3E3Jgtwtcd+vx6Hs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tMwBYSixI8KDOxArFhQeAfF8tPBFXlT64qmY/O7gm/wcGRG5LhCGQsijnAOnIvH9z8YaiU9Xy1OD8Bwoaoge7kFSU92A6SE7F3LTZDqKIb5xPkaeGpsQ4AefZCYsqbf6ARyWD/eaE0gUcBGz/GvN4QXLkNT5bzJIYhiohHSpKz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TIEgxQWG; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TIEgxQWG"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6e6419cd4ddso132442b3a.2
        for <linux-scsi@vger.kernel.org>; Wed, 06 Mar 2024 12:56:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709758581; x=1710363381; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=24sGFAKUTMlFkQcWZBTL9mXGCoHWah/p2w8E9U7LrWw=;
        b=TIEgxQWGUdZcgyAEg02NRIfvaCCwulC7zCXCg1AHb+9YobU/p5rsm/rIo1tasgARhp
         X/TvboIjVw2DlRcyhTOmRgBNjc9OBvLjIY7Ut4LDiykEE8yoNWDWtQYKrifaADDsh4kz
         cU+h/mDqjUL5QC3pg30iyxu4dzx/E0WCKKCmMomydBC0jwPPKjqiTmujLTd6+6pgXJy7
         vPvTio0T4eapBN1yG8a5zV2jkP+ovmRmOYx6tqjmfSh4mSWmg+rIURyB4Ou2x8QGHl1S
         bG2b2MuR5r2c6/Yrm9nLU9c3xkQY4BcKPSUtljuPQkHiFJwAufLvABh1nyuLZZsf1uMR
         z5MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709758581; x=1710363381;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=24sGFAKUTMlFkQcWZBTL9mXGCoHWah/p2w8E9U7LrWw=;
        b=I8VStfKyqqjG8Bhr9EhUMlHqevHC8WVIoZJtssp+82tl72Pr8kgMAL4UVqDTgdGlUw
         ZxU0EJJ4VTxM5FxYrqy3FHpEGmkl4VsVTtY583gQi0ME8TQWSsiE+epNgPihWox+SnJx
         anMomt8uxaUz1BeePuEMcL83Fk4syFFQy+HM0QNU2iVmP7QOpaMfSRKHEFdYxcd15VG5
         7frHF0wbk9Q+VavtYoxXYBEQ5yOtiSAGTV6ELMT4juapsOKWLnxXq4rnBA/ppjkJFJb9
         UhXsta16LtcYv0wm41Fjjbgpmmv/02V3Xavym4rB2UOKHGSvcyJkSbV7iLyxVnoVFlZZ
         pb+A==
X-Forwarded-Encrypted: i=1; AJvYcCXXNf9emF4+wd2INU0xs+bQrx9CjtxcTpBGfDSv4/PQHDATOo/KircmXyWRk0yOBWl844UlC1Y/qtmVtAXkDsvj1P4uXopStWPYlQ==
X-Gm-Message-State: AOJu0YwYnIlcM+ku8Hq6EsJB9HFB1KpMG3nitwElfSbp5mK1JyzBkmT0
	UNIv8lcjPKQRDBowu39knvHJLKzraZTHqmH7q4SUUHreNumXjiLAR/BdqLDfxA==
X-Google-Smtp-Source: AGHT+IHGAd/L7VB6xNYd1gWzlLG1X1+due696CWjKmT3T0LUK5z6Uf8B1dNIBpiddnRm1LGtygv1Gg==
X-Received: by 2002:a05:6a00:1915:b0:6e5:584d:8d17 with SMTP id y21-20020a056a00191500b006e5584d8d17mr18776495pfi.15.1709758580424;
        Wed, 06 Mar 2024 12:56:20 -0800 (PST)
Received: from google.com ([2620:15c:2c5:13:9a91:c17:53d9:d156])
        by smtp.gmail.com with ESMTPSA id s16-20020a62e710000000b006e5a6e83f8esm10313892pfh.134.2024.03.06.12.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Mar 2024 12:56:20 -0800 (PST)
Date: Wed, 6 Mar 2024 12:56:15 -0800
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
Subject: Re: [PATCH v7 5/7] scsi: hisi_sas: Add libsas SATA sysfs attributes
 group
Message-ID: <ZejYb4ykeF7Qx5a5@google.com>
References: <20240306012226.3398927-1-ipylypiv@google.com>
 <20240306012226.3398927-6-ipylypiv@google.com>
 <ZehLpV06mpHxjecc@ryzen>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZehLpV06mpHxjecc@ryzen>

On Wed, Mar 06, 2024 at 11:55:33AM +0100, Niklas Cassel wrote:
> On Tue, Mar 05, 2024 at 05:22:24PM -0800, Igor Pylypiv wrote:
> > The added sysfs attributes group enables the configuration of NCQ Priority
> > feature for HBAs that rely on libsas to manage SATA devices.
> > 
> > Reviewed-by: John Garry <john.g.garry@oracle.com>
> > Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> > Reviewed-by: Jason Yan <yanaijie@huawei.com>
> > Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> > ---
> >  drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 6 ++++++
> >  drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 6 ++++++
> 
> Is there a reason why you didn't patch:
> drivers/scsi/hisi_sas/hisi_sas_v1_hw.c ?
> 

I originally patched hisi_sas_v1_hw.c as well. John Garry pointed out
that v1 HW doesn't support SATA so I dropped the change.

> 
> >  2 files changed, 12 insertions(+)
> > 
> > diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> > index 73b378837da7..b5d379ebe05d 100644
> > --- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> > +++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> > @@ -3544,6 +3544,11 @@ static struct attribute *host_v2_hw_attrs[] = {
> >  
> >  ATTRIBUTE_GROUPS(host_v2_hw);
> >  
> > +static const struct attribute_group *sdev_groups_v2_hw[] = {
> > +	&sas_ata_sdev_attr_group,
> > +	NULL
> > +};
> > +
> >  static void map_queues_v2_hw(struct Scsi_Host *shost)
> >  {
> >  	struct hisi_hba *hisi_hba = shost_priv(shost);
> > @@ -3585,6 +3590,7 @@ static const struct scsi_host_template sht_v2_hw = {
> >  	.compat_ioctl		= sas_ioctl,
> >  #endif
> >  	.shost_groups		= host_v2_hw_groups,
> > +	.sdev_groups		= sdev_groups_v2_hw,
> >  	.host_reset		= hisi_sas_host_reset,
> >  	.map_queues		= map_queues_v2_hw,
> >  	.host_tagset		= 1,
> > diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> > index b56fbc61a15a..9b69ea16a1e6 100644
> > --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> > +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> > @@ -2929,6 +2929,11 @@ static struct attribute *host_v3_hw_attrs[] = {
> >  
> >  ATTRIBUTE_GROUPS(host_v3_hw);
> >  
> > +static const struct attribute_group *sdev_groups_v3_hw[] = {
> > +	&sas_ata_sdev_attr_group,
> > +	NULL
> > +};
> > +
> >  #define HISI_SAS_DEBUGFS_REG(x) {#x, x}
> >  
> >  struct hisi_sas_debugfs_reg_lu {
> > @@ -3340,6 +3345,7 @@ static const struct scsi_host_template sht_v3_hw = {
> >  	.compat_ioctl		= sas_ioctl,
> >  #endif
> >  	.shost_groups		= host_v3_hw_groups,
> > +	.sdev_groups		= sdev_groups_v3_hw,
> >  	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
> >  	.host_reset             = hisi_sas_host_reset,
> >  	.host_tagset		= 1,
> > -- 
> > 2.44.0.278.ge034bb2e1d-goog
> > 
