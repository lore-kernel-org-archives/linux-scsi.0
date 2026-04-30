Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09065287257
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 22:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777587551; cv=none; b=ZADUlLov8+eQtZe716TIKW0b0LRNZYVX2+Y1VvQoq/A/doG6NuQiZccTl7tUisZqwj+WTnq3aU0d2XzhhTv6LyQKEiltNTZ51bS9Ucjm669BRekuUSlRhZJ+YYZRiAoMO61kVE8A6IHBvGjIyhQs8qibRQvNIZCcmcznTdN9eKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777587551; c=relaxed/simple;
	bh=z5lQ+YIALAYnP8iA5flpksWSd260K648LLjB5G50Wsc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=Ja+56XUSs1egKFEfCne0Ih8v0Dt89/QXhVxh/8MfWxln6tSw3XxE8UtHEyDn0Pei2S4lecVbMSHVSbx1NEMwu6jD4Qi6M/DJem1JI0xwe0LFfijRMrFFIi0JGEimWkLGepOz4UGoSkLJ6xTIp2+LYXbHrSEdtx4w/BlCf3WUZFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r4PfhVF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r4PfhVF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43A9C2BCB3;
	Thu, 30 Apr 2026 22:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777587550;
	bh=z5lQ+YIALAYnP8iA5flpksWSd260K648LLjB5G50Wsc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=r4PfhVF4BV6ndAcbhsXZQ8vgx0k9ONR+T5QRkKHAbVnGFo7oRM02RkiEu2oj3gQOB
	 oTCE7dNDQkLrjGKSyGUt42uRMNdX2lhG2EUE1r3NhDySnatGNp/9ZDFXcQgBswBpCg
	 dBvV9GYUVI4ARIxBsGrGJ99sjM/JJSuiKzCqr4/Rts2JPdTpqI0YBlm8Ker42R/7DU
	 Y/6c8nMVZKmMp/EUo5u73qPmqGzbK5Ffw3Hr4ukh5SmoN+vtBSNyJJCwxPb8yEA8xA
	 NadEUgl8aCEsoQUqtoV8HY01eiYCkdYjS2ad7JiySCftJO1iydUAoTAJmsC7Dmytdt
	 5CsLOj1jMKeRw==
Date: Thu, 30 Apr 2026 17:19:09 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH v2 01/56] PCI: Convert to_pci_dev() into an inline
 function
Message-ID: <20260430221909.GA448587@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430182130.1978347-2-bvanassche@acm.org>

On Thu, Apr 30, 2026 at 11:19:31AM -0700, Bart Van Assche wrote:
> Clang's context analysis checker performs alias analysis on expressions
> passed to annotations like __acquires(). Clang's alias analysis does not
> support container_of(). Convert to_pci_dev() from a macro into an inline
> function such that Clang recognizes multiple to_pci_dev() expressions as
> identical if the 'dev' argument is the same.
> 
> It is on purpose that to_pci_dev() accepts a const pointer and returns a
> pointer that is not const. Any other choice, e.g. accepting a non-const
> pointer or returning a const pointer, triggers compiler errors.
> 
> While _Generic() could be used to support const and non-const struct
> device pointers in a more elegant way, Clang's alias analysis does not
> support _Generic().
> 
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  include/linux/pci.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 2c4454583c11..f5989267a537 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -606,7 +606,10 @@ static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
>  
>  struct pci_dev *pci_alloc_dev(struct pci_bus *bus);
>  
> -#define	to_pci_dev(n) container_of(n, struct pci_dev, dev)
> +static inline struct pci_dev *to_pci_dev(const struct device *dev)
> +{
> +	return container_of(dev, struct pci_dev, dev);
> +}
>  #define for_each_pci_dev(d) while ((d = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, d)) != NULL)
>  #define for_each_pci_dev_reverse(d) \
>  	while ((d = pci_get_device_reverse(PCI_ANY_ID, PCI_ANY_ID, d)) != NULL)
