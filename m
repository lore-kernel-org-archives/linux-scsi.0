Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C11E6A33B
	for <linux-scsi@vger.kernel.org>; Mon,  4 Nov 2024 13:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730728352; cv=none; b=XA2uWGK7cjwa6cVklbw5cXkaV2WLYbS/ZgAemPhkJ2ZbN9oGv5WhYM8Sy1DcYIN548KCpKpKV5MS4eobG+eYoVQPHTaf1827NcikisVSzDu+BJdEmkG1pZt6L/t+5PuUo15/4wBnhsTYyueOy+slxD9NDXM5iYY97MKeA3uul7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730728352; c=relaxed/simple;
	bh=va+mJ8jqYuF1m2DMlIh3VClRv2mNCKxpQOuHse15mgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hUzDmfl93mNex8efFzQLdwCyOv8vd8bqutsIsj2MTo4L119Ll9SLdG2QZriRZU5ZaYSIxv7hwRVEnIPH4CxlSFFNjQkaeh8xZGW6J1zhJG+uwKb8HLz1i/wxA0TDW1UVNsWDwXJaFOGPfQiPOM6T/imBfzvMKvxSXCBdGGV3RN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=TNddlwN/; arc=none smtp.client-ip=209.85.222.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="TNddlwN/"
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-84fc0209e87so1163848241.1
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2024 05:52:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1730728349; x=1731333149; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EkBaJUaQmNlDT9UG7F3IUEDB61PJd1lepS1O8vS2Df4=;
        b=TNddlwN/cQFlt9b9NOt4ygwx4ZmhdBnD7UfEqeL0yjQxKSL4n2gd4M6UaUGP4tOFL4
         YuDG5FuzEu7aQQ4U2Ak4kTWSWSL7pEIowGcwnpuKcdxz16CGtbmzPEAdyt83jXZqbfGU
         IHojgiML0TF/a44/SfqOP53DqR1P2zxpRF3cqXyECVvQJEEUaz8xBPf+Yp6osgB1tMJU
         rPHo7yuMB7lCs2OKBGFOnWom33RdUE0FUwr9oQmPO/dbhu9U7RL+i8Nn+eAJmmU7tgLx
         l2ps9Leuc9AuGigcaoqZgKVPB8n0g4AMAloCHCsvocu84DwwJaEhLIdxm1s5/3di0NL2
         eonQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730728349; x=1731333149;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EkBaJUaQmNlDT9UG7F3IUEDB61PJd1lepS1O8vS2Df4=;
        b=rmhB1TiuG5F1tQN39gQGcHd/v4oxAXuZGw2IKEFo/om62NVK3wrrqZ+RhmzcupWSgc
         DSKpZm6X5vKiAOr7CQ7bM7xPUwOHC5YW+ZQkN/r5Sq29hItgpevYTgOG3CDXXipwjLFi
         XwlCqA4Hck9KtvhavYkVW48FbM+2BTFYZUGDLWvbwOKd6JBgOmflN7ILkrwM/hhb5dhp
         XhpNkQMC3HbyMW5JYx/k5fiXb/f9GsvpJ/bEugwZLoJjTFmDQDad5G+/Cn3+G3ML4FpL
         rzR9U+zCragIdKa5cmxfndJ1eYUegPGX5C7SjQQ9ChdIbXGYEjWqk/PIZlungWxGiRFy
         CY7w==
X-Forwarded-Encrypted: i=1; AJvYcCU8hKKEiiHIroPiV3TAlmAXX2FZGir0ftbghWdoKotkzScaVfr6UlDcVN/0cs3KUiFZV8vWE/yDW3gC@vger.kernel.org
X-Gm-Message-State: AOJu0YyeFJ0plA98jT8YGnYrTJ02URFnu+E54w1utFkw7mYEb4p+hABK
	2yXNsr/NEuHmNPM/TbHBUcgp7MbSUV0lTVSxI28xN4lXldLTi/Jxv/TSzFc4Uzo=
X-Google-Smtp-Source: AGHT+IFmlPTEulo8PrBSa4hLGepjHWucd1eo0mnO56qT1Ydh9XheeGVoeKHcAHFWhX+avIDDQrBpSQ==
X-Received: by 2002:a05:6102:3753:b0:4a4:8756:d899 with SMTP id ada2fe7eead31-4a9543ece24mr15248394137.29.1730728348895;
        Mon, 04 Nov 2024 05:52:28 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-462ad0adffesm47192441cf.32.2024.11.04.05.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2024 05:52:28 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1t7xVL-00000000hsn-2kgO;
	Mon, 04 Nov 2024 09:52:27 -0400
Date: Mon, 4 Nov 2024 09:52:27 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Xinhui Pan <Xinhui.Pan@amd.com>, David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Leon Romanovsky <leon@kernel.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Michael Walle <mwalle@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Naveen Krishna Chatradhi <naveenkrishna.chatradhi@amd.com>,
	Carlos Bilbao <carlos.bilbao.osdev@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
	"David E. Box" <david.e.box@linux.intel.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Frederic Barrat <fbarrat@linux.ibm.com>,
	Andrew Donnellan <ajd@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
	Logan Gunthorpe <logang@deltatee.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-cxl@vger.kernel.org, amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
	linux-mtd@lists.infradead.org, platform-driver-x86@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-alpha@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v2 05/10] sysfs: treewide: constify attribute callback of
 bin_is_visible()
Message-ID: <20241104135227.GE35848@ziepe.ca>
References: <20241103-sysfs-const-bin_attr-v2-0-71110628844c@weissschuh.net>
 <20241103-sysfs-const-bin_attr-v2-5-71110628844c@weissschuh.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241103-sysfs-const-bin_attr-v2-5-71110628844c@weissschuh.net>

On Sun, Nov 03, 2024 at 05:03:34PM +0000, Thomas Weißschuh wrote:
> The is_bin_visible() callbacks should not modify the struct
> bin_attribute passed as argument.
> Enforce this by marking the argument as const.
> 
> As there are not many callback implementers perform this change
> throughout the tree at once.
> 
> Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
> ---
>  drivers/cxl/port.c                      |  2 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c |  2 +-
>  drivers/infiniband/hw/qib/qib_sysfs.c   |  2 +-
>  drivers/mtd/spi-nor/sysfs.c             |  2 +-
>  drivers/nvmem/core.c                    |  3 ++-
>  drivers/pci/pci-sysfs.c                 |  2 +-
>  drivers/pci/vpd.c                       |  2 +-
>  drivers/platform/x86/amd/hsmp.c         |  2 +-
>  drivers/platform/x86/intel/sdsi.c       |  2 +-
>  drivers/scsi/scsi_sysfs.c               |  2 +-
>  drivers/usb/core/sysfs.c                |  2 +-
>  include/linux/sysfs.h                   | 30 +++++++++++++++---------------
>  12 files changed, 27 insertions(+), 26 deletions(-)

For infiniband:

Acked-by: Jason Gunthorpe <jgg@nvidia.com>
