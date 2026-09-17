Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A444CB8A8;
	Thu, 17 Sep 2026 11:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789644525; cv=none; b=kukuZrypwY8iPS/A0RW4d86hqQWV64Gg0TjPOCjpIEWnX9NREXVPLozDuBMGpg/rgsgVYTFBnQxRk9iyuBjrLKKDa+kopj2h8ixu032u3GhcqaxuXwRHxf5dbSfEdO12s+gFX+op81L1JPyvsdGsRxr/dZVNR3ENZwqB/aIg8Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789644525; c=relaxed/simple;
	bh=5Ncpa8+NPx3xlMt918fJVdvAb8iYngnRZqFQiVXUJYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F/LL6O+Qm2LQbhGZrEMP1AQ0B92ubxac8PL+BZf8TtETCVKpR2r6tGGhINLoacieUL6arWk/aDrzZou/T9CvJ+yTlGdh06T+vEYuoX55mlOAFTqOCI434vFgidTJOKWauwyq7rfPxKg78oUI8BOPtKNO35ih5ymoUIcs808ZxvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eAb7tk41; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eAb7tk41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9AD1F000FF;
	Thu, 17 Sep 2026 11:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789644523;
	bh=4C7PqXuoe7AK1vOOoG90qYxrgB0Vpzu901u3h29blQ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eAb7tk41jou1f5EjO/mghkgxzKuudOv9p4aKy1P0r85T2d/1Nob7lbhrughCpdv2X
	 pv2EFz0AiZv5lw9B3UT3hgoibBXVbfJZL/hQgwTAcXQ+BB+7k2XHKic20fmcEvjF8l
	 KCwaFMPDEM+UvvrGHsPr3gaYsN7qGPnYHLbJ4ZHuea4dOyEjV9C0iSjprrY4XNM66V
	 xRhvAU9rTOb86/zmvUCArfrLnqMiCFgOaEf/DHObrZBKrH8ih33vuFwItFj772xHjN
	 XRvMwsKP4Dv2l+dQfnMZ7yolurTCp/8KaoU+sT4TUBeMjGsVeVwkO6h71hAAjrXnKf
	 qe4GOd9dAo/5w==
Date: Thu, 17 Sep 2026 12:28:40 +0100
From: Lee Jones <lee@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Liang Haowen <nbg2974@gmail.com>, linux-scsi@vger.kernel.org,
	linux-leds@vger.kernel.org
Subject: Re: [PATCH RFC v6 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED
 driver for ROG NVMe enclosures
Message-ID: <20260917112840.GJ1605367@google.com>
References: <202609162200.RFCv6-0.lhw@gmail.com>
 <202609162200.RFCv6-1.lhw@gmail.com>
 <20260916143832.520721F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260916143832.520721F000FF@smtp.kernel.org>

On Wed, 16 Sep 2026, sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] leds: build failure due to undefined kzalloc_obj()

Please review, explain or fix the Sashiko review(s).

If this is a set, this request includes the other patches too.

> --
> 
> commit 8323106d834da191a6608c0c1f5330cc2b52094f
> Author: Liang Haowen <nbg2974@gmail.com>
> 
> leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG NVMe enclosures
> 
> This commit adds a new driver for ASUS Aura RGB LEDs on ROG external NVMe
> enclosures. It exposes the 4 independently addressable LEDs as multicolor LED
> class devices driven via vendor SCSI commands.
> 
> > diff --git a/drivers/leds/leds-asus-aura-scsi.c b/drivers/leds/leds-asus-aura-scsi.c
> > new file mode 100644
> > index 0000000000000..4e039bdbe76ac
> > --- /dev/null
> > +++ b/drivers/leds/leds-asus-aura-scsi.c
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
> Does this code fail to compile because kzalloc_obj() is undefined? In
> asus_aura_attach() in drivers/leds/leds-asus-aura-scsi.c, this line triggers a
> compilation error since kzalloc_obj() is not a valid Linux kernel memory
> allocation API. Should this be a call to kzalloc(sizeof(*zone), GFP_KERNEL)
> instead?
> 
> > +	if (!zone)
> > +		return SCSI_DH_NOMEM;
> > +	zone->sdev = sdev;
> > +	spin_lock_init(&zone->lock);
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/202609162200.RFCv6-1.lhw@gmail.com?part=1

-- 
Lee Jones
