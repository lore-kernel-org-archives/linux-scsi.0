Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128E14A0A
	for <linux-scsi@vger.kernel.org>; Tue,  5 Nov 2024 02:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730774848; cv=none; b=AgeW+5B50Xfp6ydLNiHICftEXj5qZbHgqOiAfCZ7qMMEYbypvYVOG7kCx8Kdte/Im0v/NHqHv8dhr0zxxhTHimAT8yqnkhh+KGmM6SLcA5PHptZFPmgo2z7y1yyON8KCTR3GoPzjb6qrOPAKh1N2ez++HKxGR/ZGMaz/zhfWAOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730774848; c=relaxed/simple;
	bh=1yNgrwYPboQhRzRqDTN2FFObV+gJjTHmkMJ/NntUSAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YGmbGYaAygRzbhnMoVZloxLyX/YBErVLGRvFHEnxVIvd/rcHk+rPEdmrdhB00q8unWMeZrCUPU8e9RY+ijgu3BAe7uJ2+PFxMJjzOIxlm9+um6Yh0WuOUm8N8Ug0QjNpl78rHASE/hzO9Nb9mKDzIZTR/VNP/ZM7K9C6Pder7FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rowland.harvard.edu; spf=fail smtp.mailfrom=g.harvard.edu; dkim=pass (2048-bit key) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.b=PJ9nR4jF; arc=none smtp.client-ip=209.85.222.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rowland.harvard.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=g.harvard.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.b="PJ9nR4jF"
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-84fc21ac668so1337247241.1
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2024 18:47:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1730774845; x=1731379645; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MTlg3WVtPOaNEtPAughUpTGXurHUbvsup5xya8HjuJ0=;
        b=PJ9nR4jFxeZCAjEqCNf9X14hv/IO2iPPbnXuwTaIfi5YF8l7FgLO5TFnMGvj5z7Ew+
         3vhQwrPX4I3u3nMtXLjzeaQ8jU8akdT/jXR5ZbnTIeL7SAK7VFHKIvNlHOk3I13P+0ky
         OTvcMUNrgavEYGc/izAUr9lLmEfcBYeJC2nq3eU81/wtsstSJtbHU5EDdtL5tJSJ66u/
         nesaCmGFJ6U/jJoLvcIV8EWfcFq/x+xlr7ClzQT89uysFb3PbvoHlA2FBDQHXb6OBkbR
         mrvrqGph4177AydOx/JBm8Z29gYZK5pCwRs6Pnxkxv/rpHr8GODko39x2xUFHadndM27
         d8BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730774845; x=1731379645;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MTlg3WVtPOaNEtPAughUpTGXurHUbvsup5xya8HjuJ0=;
        b=XLXUwYMT6duLYfDp+Nm9d6Ur0/NPmRtNzXVgnjbVectc+1kRh76vjGtYOF0efpuo6K
         QZ/m6d0tYi4PlcD60auaMIjHBOcUjhb8KEMbR5hO+ayqtb73zwTh4xvZG2n2W0e98ylg
         3fqPhubJIbUqWJx8Zzv8ioOsMhiMK/wN+cV3heY/7yBSfmzyK+FOxiBU2RvD4dY1R1DC
         7Gnw/u5FTyeFI+jO/GnOqxcFFhazmAjzmGJigLwin92df1Ha/P/r5A+4KzBcddTSKoh1
         maba5LRdnm1i5LFjRvQJj3IrF5KsJSE8kLixV+Zxu8C7xnKAcEVuHc+GT+PACehLfj0u
         Fscg==
X-Forwarded-Encrypted: i=1; AJvYcCVolYS3symER6EUgXX2/g41Gn2RxgVdD3OP9Erc81lYIP5UXrK++bgPanH9bGj/gjH6dIPwVRewb+/A@vger.kernel.org
X-Gm-Message-State: AOJu0YzEoVF506wFdnj321OhaC4p++OIpTekccptYm2dC5dXENwk6cKV
	g8Aw1nxS0812/hki470BhqdHvs92vOqd/BFg6xkem110qqjpQAQEDH7Pd0mndsVsgTisyUDrh14
	=
X-Google-Smtp-Source: AGHT+IEyb/wDyPUaQWdbUNiEg1rmeUbOrh4sZSC2BjpsaaGBYYt0e2XBd8iKJtXS1BeLQBr81PKvtQ==
X-Received: by 2002:a05:6102:6cc:b0:4a5:6f41:211e with SMTP id ada2fe7eead31-4a8cfd598demr29966954137.24.1730774844864;
        Mon, 04 Nov 2024 18:47:24 -0800 (PST)
Received: from rowland.harvard.edu ([2601:19b:681:fd10::dc3c])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d35415a653sm54998556d6.96.2024.11.04.18.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2024 18:47:23 -0800 (PST)
Date: Mon, 4 Nov 2024 21:47:20 -0500
From: Alan Stern <stern@rowland.harvard.edu>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi: sg: Enable runtime power management
Message-ID: <43ee24de-8d54-4c41-85b3-b3961366b52e@rowland.harvard.edu>
References: <20241030220310.1373569-1-bvanassche@acm.org>
 <40e8ff4e-9ffc-4658-ae1f-69ceee5593cb@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40e8ff4e-9ffc-4658-ae1f-69ceee5593cb@acm.org>

On Mon, Nov 04, 2024 at 09:25:17AM -0800, Bart Van Assche wrote:
> On 10/30/24 3:03 PM, Bart Van Assche wrote:
> > In 2010, runtime power management support was implemented in the SCSI core.
> > The description of patch "[SCSI] implement runtime Power Management"
> > mentions that the sg driver is skipped but not why. This patch enables
> > runtime power management even if an instance of the sg driver is held open.
> > Enabling runtime PM for the sg driver is safe because all interactions of
> > the sg driver with the SCSI device pass through the block layer
> > (blk_execute_rq_nowait()) and the block layer already supports runtime PM.
> > 
> > Cc: Alan Stern <stern@rowland.harvard.edu>
> > Cc: Douglas Gilbert <dgilbert@interlog.com>
> > Fixes: bc4f24014de5 ("[SCSI] implement runtime Power Management")
> > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> > ---
> >   drivers/scsi/sg.c | 9 +--------
> >   1 file changed, 1 insertion(+), 8 deletions(-)
> > 
> > diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> > index f86be197fedd..84334ab39c81 100644
> > --- a/drivers/scsi/sg.c
> > +++ b/drivers/scsi/sg.c
> > @@ -307,10 +307,6 @@ sg_open(struct inode *inode, struct file *filp)
> >   	if (retval)
> >   		goto sg_put;
> > -	retval = scsi_autopm_get_device(device);
> > -	if (retval)
> > -		goto sdp_put;
> > -
> >   	/* scsi_block_when_processing_errors() may block so bypass
> >   	 * check if O_NONBLOCK. Permits SCSI commands to be issued
> >   	 * during error recovery. Tread carefully. */
> > @@ -318,7 +314,7 @@ sg_open(struct inode *inode, struct file *filp)
> >   	      scsi_block_when_processing_errors(device))) {
> >   		retval = -ENXIO;
> >   		/* we are in error recovery for this device */
> > -		goto error_out;
> > +		goto sdp_put;
> >   	}
> >   	mutex_lock(&sdp->open_rel_lock);
> > @@ -371,8 +367,6 @@ sg_open(struct inode *inode, struct file *filp)
> >   	}
> >   error_mutex_locked:
> >   	mutex_unlock(&sdp->open_rel_lock);
> > -error_out:
> > -	scsi_autopm_put_device(device);
> >   sdp_put:
> >   	kref_put(&sdp->d_ref, sg_device_destroy);
> >   	scsi_device_put(device);
> > @@ -392,7 +386,6 @@ sg_release(struct inode *inode, struct file *filp)
> >   	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp, "sg_release\n"));
> >   	mutex_lock(&sdp->open_rel_lock);
> > -	scsi_autopm_put_device(sdp->device);
> >   	kref_put(&sfp->f_ref, sg_remove_sfp);
> >   	sdp->open_cnt--;
> 
> (replying to my own email)
> 
> Can anyone please help with reviewing this patch? This patch is
> important for Android. The Android security software uses the sg driver
> to communicate with the UFS RPMB so this patch is required to enable
> run-time power management in Android devices with UFS storage. See also
> https://android.googlesource.com/platform/system/core/+/refs/heads/main/trusty/storage/proxy/rpmb.c

Acked-by: Alan Stern <stern@rowland.harvard.edu>

The patch itself is innocuous.  However, it does open up the possibility 
of devices unexpectedly going into low-power mode between SG commands, 
if those commands are spaced sufficiently far apart (more than a few 
seconds).  Presumably the system default is to disallow runtime PM for 
SCSI devices, so this shouldn't be a big issue.  But it might cause 
trouble in a few cases.

Alan Stern
