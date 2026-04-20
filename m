Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0093235BDDB
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 20:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776716741; cv=none; b=Mk9dG353Y5jeahBwnFD0U0wpzvY0fV4p4FJraXUgwsebcX5NES9IeyhzJlPzBg9S2JM5RBSaNPA+pHLizLlLE+NPPVvfnrdsInF2wTcb2AbLscECWaABs2XawWZydT8kN7xQGttDKN2OX0wE8VPtkUwfw4cNmIZVRh0F6dVIJ/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776716741; c=relaxed/simple;
	bh=Dx76hdPmzkcK4nbwEphDzpwF8eLBrP39wXmhzcE1i9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UCQZdVEEKzNcHw2RRVfqw0TZQCODAutW9gto3zF4+3EiaJmXqp3vq4Fxxw6bU68z80QQQn2TRWfQSaq2Q/YNWdsa3oTJ9zmruSp5i/Sqq0CKdv/000+5tddd5IuhJIHalmxvP79g2zuZP+fF38OoC7D6azcDoUqvI06ONGzB2TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=MwCSCJDj; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="MwCSCJDj"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-899a9f445cbso43158856d6.0
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 13:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776716738; x=1777321538; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=86B2EppM//v3TWmEymAoj6QAs94Bt1WYW2cmbvlwvO8=;
        b=MwCSCJDjXbCvC3v1RscWJNQ6YOVZFVHPpzP1nFOPs+Pt2NtU0oJJ7oPNGqLFnDPktw
         JQivfdVMFtG/TTh19cK0LfNJTMpX6DhFeINI9+bXbdsjmVv/Ds59umoP3m2sMmDSj2Ov
         CW44m8KumgVPrHC7bHyyEY/UCqNky5Nh1uFJRf+yP89OeyEgx2bA5CXrFUOtN7utWTPa
         ysOTh8bHlSvAMd+jPHDO4f4GH21Ll0Y8xFjaWsOrhpB8PNyQhlp9FTNA2txcwDr/OUVB
         bCJYbYtioyIcLpcaPBQlLIgtHGnLAcHF+aDWum6zTiiHn7hQppMnqofiAZq6jOgpcDBu
         wvOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776716738; x=1777321538;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=86B2EppM//v3TWmEymAoj6QAs94Bt1WYW2cmbvlwvO8=;
        b=ZYdc4lRduHIfTfGFFLNGtTGzL7OHPAGx3L7nq/4UYiPr9AZwfyw0C12GbN78y2DVx3
         nXHZpIb86IBRTAsaf5DUf5udO5ThE+feDwayhY6so+GNDwh3q1ZxsvbpzhSwU5QzRfZw
         Yuw6AmxKMMu1U3Xm/LHrlnyo1qZLYSCUckbDlDe+ATaSiDBrBEa86DhXK3XSFLr3+Lm4
         5867+SK7Y7SyInDn22BTjHKs24DQwL31vemDwL7BQpRN01R6oHR9Fl8M0Oo0uO1mI0iT
         bbbu3OKF7ciAHlU1le4vRdfBBgJExmzGxby8Xfr6CVtem1BOu/u8vDOFy9P7pvQjEJud
         ZDHw==
X-Forwarded-Encrypted: i=1; AFNElJ8F8CY/D5pr4zH5v9WBN3a4rdywWvhwm7tsPaLsg/AtJAG+24VxBBd34uhnGXG2KUIJeGvZgdo5VMq9@vger.kernel.org
X-Gm-Message-State: AOJu0YyLY+horec3wSAljG2sIk6R3szljZD6an0fzJ6LoSj6hlYXloMI
	M+uC2DniTFnSygSnwgrvhzdn3Vul/kDqkevvmLxSc/3aj8YuzfwOmLFVP0O93TSJmdU=
X-Gm-Gg: AeBDievkoKevkNjoAq7kSwW62X3slqDnxgKEtoGO/xsezhnG9rs3+g/jJPKbe6ZGm1v
	CoypNwMfxksEnYK5AZ4pdwaThufte2erbDdhh5VbGtOLZC0HX+ru06WCo7LbRwCay4IvE/n4QED
	BTkTtYZTDmJw1dc1TlYFS3uYkUeXnjTIILxrY4FPf16Q20Nu6Mh5dJuod+u0+4qcoe1/g4gV7U2
	J9yG7SshlxLtX4RPcqJFXk7ddIlnzCjRjvyshEK2+sRInossCVD/H+KyT3GqJFaudhvEYaN6o24
	ehDpb3kBMwzlqJoPJmoGi6d37lg68/O//sNBaYCzLPmlIaVdtKlTuBzes3Yd0K/FVoA/SdC+vSF
	EoKffZK+G8t/KCg3fRXNM1zTSiC3+FPgBqvfdjnWmrk1GffDUIj1zlvX7KTIDkXX2ffwJSJG33S
	2+9kLRHNHWW3xZGbvpXRJXHO5FTzpBQmbzBvlyxP4rt+bQdJ723Oq+Rqs2dqcj
X-Received: by 2002:a05:6214:3209:b0:8ac:ab90:d764 with SMTP id 6a1803df08f44-8b0281653a5mr266452836d6.48.1776716737948;
        Mon, 20 Apr 2026 13:25:37 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02ac6c3e7sm85895836d6.13.2026.04.20.13.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 13:25:36 -0700 (PDT)
Date: Mon, 20 Apr 2026 20:25:34 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Jeffery <djeffery@redhat.com>
Cc: linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Tarun Sahu <tarunsahu@google.com>, 
	Pasha Tatashin <tatashin@google.com>, =?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>, 
	Jordan Richards <jordanrichards@google.com>, Ewan Milne <emilne@redhat.com>, 
	John Meneghini <jmeneghi@redhat.com>, "Lombardi, Maurizio" <mlombard@redhat.com>, 
	Stuart Hayes <stuart.w.hayes@gmail.com>, Laurence Oberman <loberman@redhat.com>, 
	Bart Van Assche <bvanassche@acm.org>, Bjorn Helgaas <helgaas@kernel.org>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, John Garry <john.g.garry@oracle.com>, kexec@lists.infradead.org
Subject: Re: [PATCH 1/5] driver core: separate function to shutdown one device
Message-ID: <h2r2jv4g2tednrybrmkn4d2dus3oalqsk3r2q4xrbuivucefon@n6vvx5bl5cm5>
References: <20260420152608.6244-1-djeffery@redhat.com>
 <20260420152608.6244-2-djeffery@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420152608.6244-2-djeffery@redhat.com>

On 04-20 11:26, David Jeffery wrote:
> Make a separate function for the part of device_shutdown() that does the
> shutown for a single device.  This is in preparation for making device
> shutdown asynchronous.
> 
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Tested-by: Laurence Oberman <loberman@redhat.com>
> ---
>  drivers/base/core.c | 71 +++++++++++++++++++++++++--------------------
>  1 file changed, 39 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 0613de0fbe44..5353c6c22d49 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -4783,12 +4783,48 @@ int device_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
>  	return error;
>  }
>  
> +static void shutdown_one_device(struct device *dev)
> +{
> +	struct device *parent = dev->parent;
> +
> +	/* hold lock to avoid race with probe/release */
> +	if (parent)
> +		device_lock(parent);
> +	device_lock(dev);
> +
> +	/* Don't allow any more runtime suspends */
> +	pm_runtime_get_noresume(dev);
> +	pm_runtime_barrier(dev);
> +
> +	if (dev->class && dev->class->shutdown_pre) {
> +		if (initcall_debug)
> +			dev_info(dev, "shutdown_pre\n");
> +		dev->class->shutdown_pre(dev);
> +	}
> +	if (dev->bus && dev->bus->shutdown) {
> +		if (initcall_debug)
> +			dev_info(dev, "shutdown\n");
> +		dev->bus->shutdown(dev);
> +	} else if (dev->driver && dev->driver->shutdown) {
> +		if (initcall_debug)
> +			dev_info(dev, "shutdown\n");
> +		dev->driver->shutdown(dev);
> +	}
> +
> +	device_unlock(dev);
> +	if (parent)
> +		device_unlock(parent);
> +
> +	put_device(parent);
> +	put_device(dev);
> +}

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 

Also, please CC: kexec@lists.infradead.org, this series helps the live 
update, and kexec performance.

Pasha
