Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C41C182DB
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jun 2024 07:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718783862; cv=none; b=PBgfYTWgIz6fFFVrTXE+h8EJAynHXvk7NsJJuZwryIiH+FMariRPp46H6Taut+WdO0Lnjl8zJ6koP7RIQIboXA9Qern7uHGK9i9Usc/cpo8pdnwJAdFgSdwDatu4OggHzg/b1B4d8Fo4nI6Dh6J4b+JqghpDmqXeXSG9xZK5vJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718783862; c=relaxed/simple;
	bh=v5jgjVY3lGe/H3tyCud9wYBNaYRWVD+SYI9WvIfobPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kLYeWkR7LydYDBAhjrWstHT4EqPMZLNXf+Au7b5MPC+68pPuVfTYp8DIIqas1UeCodp4OEtkEMqNEy0Gg1QlNJrYztKoKKgd0TfBSPEpUmAKzwQxHWQhF1Li/AmgSygmbxxetMbD1/IxWHbXTQVEirAd+siJWxUiua4lpQLDU98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=V3QAF+jf; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="V3QAF+jf"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3c9d70d93dbso4030003b6e.3
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jun 2024 00:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718783859; x=1719388659; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ucEEQi3unsOns52PvadoHhN287b7f7lLSd0r6kGw75M=;
        b=V3QAF+jf+IZy+upExKJrGUK4u5rWWRBnlT5T1JGjQms4jOgDaQkyI08N4jRVdMI/qo
         RJxIzc1YREDEk5SfCQXhb3DDB5IJ66z8w/DrjM73NSy3PHDMmuK+IcTsiPJ/247JE1BS
         7TEBuxYgmpQ1GbbS4H/8HM4wpLm67H9yS70FiG20JHY91u78BTPKDZWh5s4OFlYkOapV
         FYHHAQ1e+vT6pGnMSjLPN/bfih/PZSHVDhmXmoM2lvFZ29yvQg6yyjSV7hopBaMUskLN
         yta9NThYzNnrWDGGDdHfDbgzAbbCKhCNiFXvkoAOORXVRL5CJiJPHOCptQPV6GpQtAKc
         T97g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718783859; x=1719388659;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ucEEQi3unsOns52PvadoHhN287b7f7lLSd0r6kGw75M=;
        b=o7w3ETL6RY9MqCWbFVV0LU6zuKYzTzyeJKnp6tQzXGeWWgZEFbqL6s6kjJ1nwlKowC
         sTJ9jRXUXFtTV3xqfc0CApw/GPa/xQVSuZiXoqZkOUvHrM1wfK7hCaM3NHHXwqSf0BGw
         10Ek7hZ6RPRSA/pfV267S5+C40EmUPASf1lMupXy77oL1WBaT5iazmFDLE0Lwks7SaHb
         6x6R/KHBi2/vyZSjlR55o90L6SwoqTqArcwpLgtOoro93COWYTUt/Xm+jUvgtTNOHCO4
         b/cm8jl8t7NUkEFhMvyagao0xqMRnMA6yS1tneX5VyurHdpvIplIq76gkxaX51ia01Vf
         XZdQ==
X-Forwarded-Encrypted: i=1; AJvYcCV599S5OPcYIwXzyV/TpfnLCZATS7WJZ4u7pQIMO99CYLummBzBsZK1l/cQfgxBDYerIMp2RnCa+UhUeCykA6xIarKAwf3W9i6HSQ==
X-Gm-Message-State: AOJu0YyPL8b2DpthBuhq/8Z+yaNJe4QerqDiSNbx9R5t+GP4qhwyMqOy
	s3/CFLJOBATuxeyCUFLq9I/EQA0fledz4cf6U1um6KHjHIe7dejxduHumn3Lxg==
X-Google-Smtp-Source: AGHT+IHUf6R9AeU8DWfcY9tLoKaCa6CEO7v4k1RKO6WnkL8QcbJT90VrHgHKaMVtt4+8Zeq1/329sg==
X-Received: by 2002:a05:6808:14c2:b0:3d2:2585:bc5d with SMTP id 5614622812f47-3d51bac5b54mr2422127b6e.45.1718783859240;
        Wed, 19 Jun 2024 00:57:39 -0700 (PDT)
Received: from thinkpad ([120.60.70.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705cc91e149sm10120315b3a.8.2024.06.19.00.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jun 2024 00:57:38 -0700 (PDT)
Date: Wed, 19 Jun 2024 13:27:31 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>, quic_cang@quicinc.com
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Peter Wang <peter.wang@mediatek.com>,
	ChanWoo Lee <cw9316.lee@samsung.com>,
	Yang Li <yang.lee@linux.alibaba.com>,
	Po-Wen Kao <powen.kao@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH 4/8] scsi: ufs: Make .get_hba_mac() optional
Message-ID: <20240619075731.GB8089@thinkpad>
References: <20240617210844.337476-1-bvanassche@acm.org>
 <20240617210844.337476-5-bvanassche@acm.org>
 <20240619071329.GD6056@thinkpad>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240619071329.GD6056@thinkpad>

+ Can

On Wed, Jun 19, 2024 at 12:43:29PM +0530, Manivannan Sadhasivam wrote:
> On Mon, Jun 17, 2024 at 02:07:43PM -0700, Bart Van Assche wrote:
> > UFSHCI controllers that are compliant with the UFSHCI 4.0 standard report
> > the maximum number of supported commands in the controller capabilities
> > register. Use that value if .get_hba_mac == NULL.
> > 
> > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> > ---
> >  drivers/ufs/core/ufs-mcq.c | 12 +++++++-----
> >  include/ufs/ufshcd.h       |  4 +++-
> >  include/ufs/ufshci.h       |  2 +-
> >  3 files changed, 11 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
> > index 0482c7a1e419..d6f966f4abef 100644
> > --- a/drivers/ufs/core/ufs-mcq.c
> > +++ b/drivers/ufs/core/ufs-mcq.c
> > @@ -138,7 +138,6 @@ EXPORT_SYMBOL_GPL(ufshcd_mcq_queue_cfg_addr);
> >   *
> >   * MAC - Max. Active Command of the Host Controller (HC)
> >   * HC wouldn't send more than this commands to the device.
> > - * It is mandatory to implement get_hba_mac() to enable MCQ mode.
> >   * Calculates and adjusts the queue depth based on the depth
> >   * supported by the HC and ufs device.
> >   */
> > @@ -146,10 +145,13 @@ int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba)
> >  {
> >  	int mac = -EOPNOTSUPP;
> >  
> > -	if (!hba->vops || !hba->vops->get_hba_mac)
> > -		goto err;
> > -
> > -	mac = hba->vops->get_hba_mac(hba);
> > +	if (!hba->vops || !hba->vops->get_hba_mac) {
> > +		hba->capabilities =
> > +			ufshcd_readl(hba, REG_CONTROLLER_CAPABILITIES);
> > +		mac = (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS) + 1;
> > +	} else {
> > +		mac = hba->vops->get_hba_mac(hba);
> > +	}
> >  	if (mac < 0)
> >  		goto err;
> >  
> > diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> > index d4d63507d090..d32637d267f3 100644
> > --- a/include/ufs/ufshcd.h
> > +++ b/include/ufs/ufshcd.h
> > @@ -325,7 +325,9 @@ struct ufs_pwr_mode_info {
> >   * @event_notify: called to notify important events
> >   * @reinit_notify: called to notify reinit of UFSHCD during max gear switch
> >   * @mcq_config_resource: called to configure MCQ platform resources
> > - * @get_hba_mac: called to get vendor specific mac value, mandatory for mcq mode
> > + * @get_hba_mac: reports maximum number of outstanding commands supported by
> > + *	the controller. Should be implemented for UFSHCI 4.0 or later
> > + *	controllers that are not compliant with the UFSHCI 4.0 specification.
> >   * @op_runtime_config: called to config Operation and runtime regs Pointers
> >   * @get_outstanding_cqs: called to get outstanding completion queues
> >   * @config_esi: called to config Event Specific Interrupt
> > diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
> > index c50f92bf2e1d..899077bba2d2 100644
> > --- a/include/ufs/ufshci.h
> > +++ b/include/ufs/ufshci.h
> > @@ -67,7 +67,7 @@ enum {
> >  
> >  /* Controller capability masks */
> >  enum {
> > -	MASK_TRANSFER_REQUESTS_SLOTS		= 0x0000001F,
> > +	MASK_TRANSFER_REQUESTS_SLOTS		= 0x000000FF,
> 
> This should be a separate fix that comes before this patch. But I believe this
> came up during MCQ review as well and I don't remember what was the reply from
> Can. 0x1F is the mask for SDB mode and 0xFF is the mask for MCQ mode.
> 
> Can, can you comment more?
> 

Oops. Can is not CCed. Added now.

- Mani


> - Mani
> 
> -- 
> மணிவண்ணன் சதாசிவம்

-- 
மணிவண்ணன் சதாசிவம்
