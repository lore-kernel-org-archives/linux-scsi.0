Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE091812
	for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 00:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709165052; cv=none; b=rY78Rk1TPRwOB2reyymdXrMLpNddIT65oKuwN6NkzLVbsw/H4zM9hhQ1UyvLYY8BaiBZiQLoPgeukhTRXAC2KNzI32ltjA50I2nZslDFvnOZdIERLrprq9ZppdSw1PxiA262cnsc6HR5SgDZyZrKnSNXhM6hRdwcWHStFnp9ye4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709165052; c=relaxed/simple;
	bh=BlRDOZg+zYl2/c2qiWKrfWwMo03Qg8kTaZE9gXkvdu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AqHYvj8/YiMo8j730+byEEya/vz62c709jPgvxn9gBh9zBM51cEFEbNKaEspqJRwBsLy+uVr+JL3u2bgZONzg4js8lMwc10W+WspfVSqEJXy/UCedryzTFCRwGzTkXaBpR4Q20qPGIzZbTWplCjgeqvy5VLFuWY4An4i19ndSec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=ej2Br3md; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ej2Br3md"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7bade847536so16986339f.0
        for <linux-scsi@vger.kernel.org>; Wed, 28 Feb 2024 16:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709165050; x=1709769850; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RUj5hY7aGRQbXDULaVrC9+/HHDaRLDH5uHjbAmT9VvE=;
        b=ej2Br3mdLKng8neAkFwC+buS+Nrzprbo7zYRo6DIoo1kCwIFKUscjKNY5E47CkeSNz
         JWoiR4JVpeIpqIeL7S/PiaAyvNQmAFAFFHHg1lNwtnYkKR5JTyIVExnEUxkU/t6pnt13
         dqUG7x1jK3hr33pDMSJFbgexd4EGt8In09WqI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709165050; x=1709769850;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RUj5hY7aGRQbXDULaVrC9+/HHDaRLDH5uHjbAmT9VvE=;
        b=bbDjs6YgvB3KFg77Nkh6rwaH/NxTTQNgL9LQX2Zgzw3kiUvMM0oXH5kGmR98w6gv6B
         i80o+z7Yjw2l1dA8p7fVlGce1CrBtMDf+kaSsXhl+qKMq8eYR2JyqbuJ6iKZXFBolnNr
         AImUc1dcJVNu4o0kXlaw9YWcQqNkUXDXF+E7QPIcJDE7BZONgXPpcHrDwFOOf7r31XPO
         RH1JjJvwrB9JK9fWQDeFweeiyfO8H/2MXHsqXCt5iNMEWlVxSwymutoFI8aWFvf8R25J
         EBwJQKaji5jWZM9oZIWO94Z99ij7tAvqUykGv5f2JpgHcuq7eBEQ1NmRZZPdU9cy5/jY
         w8uQ==
X-Forwarded-Encrypted: i=1; AJvYcCX01l/95VMRyRRgK75mfWVuQRaFnQCKbFW23adt8t9kzHQh5m98Gh1yVJWdZpNtaAQFHCjyZwhWuODBk2ulHXuVQkpLVoDBlBc0PA==
X-Gm-Message-State: AOJu0YxOf3rAuJmVtvn6gH5tO4qALf4bu8iqrvnUMMv3oT8h8nMOabhS
	Z1pSWbAKof/iSau93JMfWyNKIrmI7nDWr5iE0I07y8/BqjTCBsxGxUMySv4Gkg==
X-Google-Smtp-Source: AGHT+IHMceGOR/TqQRDwpXXUp9zn3ZRfO8HssBUzlpIFHIoDWaL+0rfSEW9cDWBqvWkjRiWTEC2RaQ==
X-Received: by 2002:a92:d312:0:b0:365:1a59:dd6f with SMTP id x18-20020a92d312000000b003651a59dd6fmr846556ila.21.1709165049874;
        Wed, 28 Feb 2024 16:04:09 -0800 (PST)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id d16-20020a056a00199000b006e56b4e10bcsm34291pfl.53.2024.02.28.16.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 16:04:09 -0800 (PST)
Date: Wed, 28 Feb 2024 16:04:08 -0800
From: Kees Cook <keescook@chromium.org>
To: Justin Stitt <justinstitt@google.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ariel Elior <aelior@marvell.com>,
	Manish Chopra <manishc@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	Don Brace <don.brace@microchip.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	MPT-FusionLinux.pdl@broadcom.com, netdev@vger.kernel.org,
	storagedev@microchip.com
Subject: Re: [PATCH v2 3/7] scsi: qedf: replace deprecated strncpy with
 strscpy
Message-ID: <202402281604.C50A4D9@keescook>
References: <20240228-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v2-0-dacebd3fcfa0@google.com>
 <20240228-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v2-3-dacebd3fcfa0@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240228-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v2-3-dacebd3fcfa0@google.com>

On Wed, Feb 28, 2024 at 10:59:03PM +0000, Justin Stitt wrote:
> We expect slowpath_params.name to be NUL-terminated based on its future
> usage with other string APIs:
> 
> |	static int qed_slowpath_start(struct qed_dev *cdev,
> |				      struct qed_slowpath_params *params)
> ...
> |	strscpy(drv_version.name, params->name,
> |		MCP_DRV_VER_STR_SIZE - 4);
> 
> Moreover, NUL-padding is not necessary as the only use for this slowpath
> name parameter is to copy into the drv_version.name field.
> 
> Also, let's prefer using strscpy(src, dest, sizeof(src)) in two
> instances (one of which is outside of the scsi system but it is trivial
> and related to this patch).
> 
> We can see the drv_version.name size here:
> |	struct qed_mcp_drv_version {
> |		u32	version;
> |		u8	name[MCP_DRV_VER_STR_SIZE - 4];
> |	};
> 
> Signed-off-by: Justin Stitt <justinstitt@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
