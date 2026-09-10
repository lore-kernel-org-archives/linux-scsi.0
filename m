Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D48635FF58;
	Thu, 10 Sep 2026 09:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789032758; cv=none; b=lMuwopVc5aAq5spVfP/o00kOMmunSz/udTE+RUeoJpKtilHSVEX//uVL0FlU9lD4TE2V9nL11wVTSYeRbA/XXmwtiHaJ9nBf9jyH/tLbb0gUx5OXCgAEUGG0dllYCC3ENPBC/MWHjCOEXWnTG2vCK1kjpGPmbElLlB7wrEQe8A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789032758; c=relaxed/simple;
	bh=54dZu+HJBXV/zlEMnr/s691DMCK68D57Aj83+ubgV2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o7Aw/1gO5Jd4SazrR+9k/ogMOsvs3VYtBNYzP3QRCt2zerii0daGidOzR/92T4guffH+FWtnuq72ex5SusIlcuni9ES8k+j04nRhZUNXMx2+x9rBpD50qSe+5TrZqixHxj8BCYolEQbG4lJFE1QhW1NstPi19XaynWfZjLDBc90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F3lQ3UDo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F3lQ3UDo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403CE1F000FF;
	Thu, 10 Sep 2026 09:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789032756;
	bh=CBDxZQ9H1UEbeWdcAY7SvOJdn2ByFXxB980XBHiPdDQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F3lQ3UDoaw19pt+XyW+TUWwKz8hLNxASXyWq/4JK7sHwsNJ8w0Xiuvs7taQSgOVPl
	 qaQ/ISm+tY5YD979GiHx30DZXyglQtwKBLFC4L5O+2cAXij2a7+SAbAUp6sLJb49FP
	 2fjWTg8wRZ3/TD8ZdTAHunIVRM0yedI39dSOaXEa3Lbh7GYpo7sJBzVzu1ZKSQ3mvq
	 pqZwLJnoliA0cnrZOakvDpIyJ3515eCQbGNt++jBbgLkVbh+xO3V8k3lPLPR7Qu+w8
	 TGKmZG1N1W4wo55ML1lY6pMvbksePaRTXz28BVTFvWwQ2BRR/iOg+0ZRZWzhF7NV3S
	 M5N2LLfBoc/PQ==
Date: Thu, 10 Sep 2026 10:32:32 +0100
From: Lee Jones <lee@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Liang Haowen <nbg2974@gmail.com>, linux-leds@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC v3 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED
 driver for ROG NVMe enclosures
Message-ID: <20260910093232.GO2133376@google.com>
References: <202609012200.RFC0.lhw@gmail.com>
 <202609012200.RFC1.lhw@gmail.com>
 <202609032000.RFCv2-0.lhw@gmail.com>
 <202609032000.RFCv2-1.lhw@gmail.com>
 <20260903161357.GX2133376@google.com>
 <202609042000.RFCv3-0.lhw@gmail.com>
 <202609042030.RFCv3-1.lhw@gmail.com>
 <20260904131503.355C41F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260904131503.355C41F00A3E@smtp.kernel.org>

Please do not attach subsequent versions to previous ones.

New versions should be sent on their own.

On Fri, 04 Sep 2026, sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [Medium] LED class device name violates UAPI naming standards and breaks userspace parsing.
> - [Low] Compilation failure due to undefined macro `kzalloc_obj`.
> - [Low] Compilation failure due to missing argument in `blk_rq_map_kern()` call.

Please review, explain or fix the Sashiko review(s).

If this is a set, this request includes the other patches too.

> --
> 
> commit c4b336ab5a8222a99fc342c60592e26cbc2f680e
> Author: Liang Haowen <nbg2974@gmail.com>
> 
> leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG NVMe enclosures
> 
> This commit introduces a driver for ASUS ROG external NVMe enclosures. It
> exposes the Aura LEDs connected to an ENE controller via vendor SCSI
> commands, implementing multicolor LED class devices for each LED.
> 
> > diff --git a/drivers/leds/leds-asus-aura-scsi.c b/drivers/leds/leds-asus-aura-scsi.c
> > new file mode 100644
> > index 0000000000000..3ff33615a7934
> > --- /dev/null
> > +++ b/drivers/leds/leds-asus-aura-scsi.c
> [ ... ]
> > +static int ene_write(struct scsi_device *sdev, u16 reg,
> > +		     const void *data, u8 arg_count)
> > +{
> > +	struct request *rq;
> > +	struct scsi_cmnd *scmd;
> > +	u8 cdb[ENE_CDB_LEN];
> > +	int ret;
> > +
> > +	ene_build_cdb(cdb, reg, arg_count);
> > +
> > +	rq = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_OUT, 0);
> > +	if (IS_ERR(rq))
> > +		return PTR_ERR(rq);
> > +
> > +	if (arg_count) {
> > +		ret = blk_rq_map_kern(rq, (void *)data, arg_count, GFP_NOIO);
> 
> [Severity: Low]
> Will this compile successfully? Looking at blk_rq_map_kern() in
> block/blk-map.c, the function expects 5 arguments with the request queue as
> the first parameter, but this call only provides 4. Should this pass
> sdev->request_queue as the first argument?
> 
> [ ... ]
> > +static int asus_aura_register_led(struct asus_aura_zone *zone, int index)
> > +{
> [ ... ]
> > +	/*
> > +	 * Include the sdev's H:C:T:L: every enclosure gets its own SCSI
> > +	 * host, so the names stay unique when more than one is connected.
> > +	 * With a static name the LED core would register the second
> > +	 * enclosure's LEDs under renamed nodes (asus-arion:led0_1), which
> > +	 * is the wrong device identity. The names are per-attachment, like
> > +	 * sd X letters, and userspace is expected to enumerate.
> > +	 */
> > +	cdev->name = kasprintf(GFP_KERNEL, "asus-arion-%s:led%d",
> > +			       dev_name(&zone->sdev->sdev_gendev), index);
> 
> [Severity: Medium]
> Does this format string comply with the standard LED class device naming
> conventions? Since the SCSI dev_name() format typically introduces multiple
> colons (like 0:0:0:0), and standard LED userspace tools expect the naming
> scheme devicename:color:function, will the extra colons break userspace
> parsing or udev rules?
> 
> [ ... ]
> > +static int asus_aura_attach(struct scsi_device *sdev)
> > +{
> > +	struct asus_aura_zone *zone;
> > +	int i, ret;
> > +
> > +	if (strncmp(sdev->vendor, ARION_INQ_VENDOR, strlen(ARION_INQ_VENDOR)) ||
> > +	    strncmp(sdev->model, ARION_INQ_MODEL, strlen(ARION_INQ_MODEL)))
> > +		return SCSI_DH_DEV_UNSUPP;
> > +
> > +	zone = kzalloc_obj(*zone, GFP_KERNEL);
> 
> [Severity: Low]
> Will this cause a build failure? It appears kzalloc_obj is not a defined
> kernel allocation macro. Should this be using kzalloc() with sizeof(*zone)
> instead?
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/202609042030.RFCv3-1.lhw@gmail.com?part=1

-- 
Lee Jones
