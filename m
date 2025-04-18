Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FF84C80
	for <linux-scsi@vger.kernel.org>; Fri, 18 Apr 2025 00:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744934870; cv=none; b=Xe5t+1OzbGGfBYbtqzexAEXkvVDDKJ0aAx5GGzPn+bhyeVHKWgFHmdSZh8/Cqy+5TgO2pD8/Pg+OITjGopSG+6G/SSTrvMoWPEP0RegAjnCaw5EfHlSIIBVtbhSelEAcuRBYCqDRn+6X5TxQYpdQScbkYW6Mw/wFh1RlqWbTZ08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744934870; c=relaxed/simple;
	bh=2Q96KZmAfjnzBaTHv10oj8TWul8tq+SQhcX6vZnVG9k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hcRrxInF/vkIwi5NmPtIhyV6Twc7FoWjyOoWSW26xgUUEcbNHht8NvQRNCgBHGd6Gia4ouxhWFZTrYj5tVHUEfRb8GiDMz6/IsvpR5Nnzr8lbmtLYylOs4vTboM43wKuxybqWcLwSZAMsKNWS87IwKm2wJS4JJo+lDW0PzB0l4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HTC9x61A; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HTC9x61A"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2264c9d0295so48225ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2025 17:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744934869; x=1745539669; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/KrmWAJyZXfnuTABRqnhfRHchKK0MW8AbXSUHMqH/vI=;
        b=HTC9x61AKBFOAuF02rBi42HGDH4gnJEzU5Z6arkBce1alaUdu68JIee8lxnAfKjcC2
         gksfLGof8ynGldr3Xr4oWAFwxLXLLG4IvcP37TNE3JKtxQXD0elrUmkJ8IylbDgQkZua
         Rs+SzcW4iDYplirKAuBd69NUD50UKB3oHMyGXq60QLfk8IbZZr/Fmh2g/+XxZickdAcX
         Oc6Sg59pxhGlC+ngwEkaHg/zxZClv1p2cfdEkWkiGjfop+2ixDYTE2qD8XrZfrcz0ubo
         ba28mb2moe3w/YPscfCm1YNKIowzRdK4I9Wf96uDaYJcoUADl21DA7+8pN9KzNlczDtD
         w14A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744934869; x=1745539669;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/KrmWAJyZXfnuTABRqnhfRHchKK0MW8AbXSUHMqH/vI=;
        b=uGwmt3l4GhUmJhQ3FwZICgIXM5Aw1hoOWKBRU/q7IWsVYXmC7EYlbSnjhBIhS6ePfk
         NxTOhIO7COFbiWdlnY2yC3HQLyU7qmwZucAYLotwgN7V7KlRwmlruVotiJxIc7mpPA7Q
         OzVrHTOQijNuEcc2TsVGujt2622PAbhtbqYNC4Z9c1xH+aq5nnJ2TfMT6yoMjABZ2lb6
         TlTCP53iDwyB961oydPQKW7M2A3EDv2pnn+AyR/CNmgI6KlU7Ql9wxH6XS4imcXobvBd
         yx081ejbjq3FbXltdVbmPzCzd1LMK98F5KqidkQCPD9phKJ/k6rmOS56V05N6wZ5AfKN
         VZ4g==
X-Forwarded-Encrypted: i=1; AJvYcCVrdU7MeF9R+OjsTu6bdA+W84GKvuqistzF+h7SUsbO1S/RpWS9/oQ7bL+R9u+LM7h1xrmihejbbEk3@vger.kernel.org
X-Gm-Message-State: AOJu0Ywwqdh4QrIiuqbew3uxvJPsHxOBIeDkvqEaNLYuetkXjpj93qoz
	WVritswk+FvEu2vX2nIAsH3RpRxZpPFy1Z62hZuG+4gGpQIlHMfe0kqy911RCocaraI613E3lkU
	BvA==
X-Gm-Gg: ASbGnctt0Tfq7W1w/rhGA9BsI5nEYozk7MQkmFbfvoVKohqacQkfzDJzdr/m037F/gi
	VgVCYe1f1xlWcUMPyLqsHGr+QfjWbfuWN68oma96axUDoJHuz6b+OKUuve1ffuU6ukNDaOqGajs
	hnolPAW+7xceEl8MZtlaBI3J9N+hV8Y/qyxzy6EwKzlhNwZ6gVh6ZjmD5wZeWI5QxfyVCUD0geJ
	YS2kfrhZ2B6uuBKVcEzZtLqClpEHOWAvcX3z0Rx+SePJSRIJmlse5//rPfyS7mfHA0LqOqAd60G
	C+qpekCEW7Yuit9q5q4G3B1fVfPrci4qVaOCoBACoYjMCKQSHCrYFPawwO08Sma2N92cszR8Zc3
	s
X-Google-Smtp-Source: AGHT+IFb3SrJqfiSFr7FAgdAYVWS2IhZLL0NjhjCGyfGFPOWK0db25W8bTlujUSvVI0gsV5qmJXIuw==
X-Received: by 2002:a17:903:4408:b0:223:7f8f:439b with SMTP id d9443c01a7336-22c54696799mr589535ad.29.1744934868332;
        Thu, 17 Apr 2025 17:07:48 -0700 (PDT)
Received: from google.com (24.21.230.35.bc.googleusercontent.com. [35.230.21.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c50fdbad2sm5963025ad.226.2025.04.17.17.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Apr 2025 17:07:47 -0700 (PDT)
Date: Thu, 17 Apr 2025 17:07:42 -0700
From: Igor Pylypiv <ipylypiv@google.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/3] ata: libata-scsi: Improve CDL control
Message-ID: <aAGXzmgOog1jjXSv@google.com>
References: <20250416084238.258169-1-dlemoal@kernel.org>
 <20250416084238.258169-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416084238.258169-3-dlemoal@kernel.org>

On Wed, Apr 16, 2025 at 05:42:37PM +0900, Damien Le Moal wrote:
> With ATA devices supporting the CDL feature, using CDL requires that the
> feature be enabled with a SET FEATURES command. This command is issued
> as the translated command for the MODE SELECT command issued by
> scsi_cdl_enable() when the user enables CDL through the device
> cdl_enable sysfs attribute.
> 
> Currently, ata_mselect_control_ata_feature() always translates a MODE
> SELECT command for the ATA features subpage of the control mode page to
> a SET FEATURES command to enable or disable CDL based on the cdl_ctrl
> field. However, there is no need to issue the SET FEATURES command if:
> 1) The MODE SELECT command requests disabling CDL and CDL is already
>    disabled.
> 2) The MODE SELECT command requests enabling CDL and CDL is already
>    enabled.
> 
> Fix ata_mselect_control_ata_feature() to issue the SET FEATURES command
> only when necessary. Since enabling CDL also implies a reset of the CDL
> statistics log page, avoiding useless CDL enable operations also avoids
> clearing the CDL statistics log.
> 
> Also add debug messages to clearly signal when CDL is being enabled or
> disabled using a SET FEATURES command.
> 
> Fixes: df60f9c64576 ("scsi: ata: libata: Add ATA feature control sub-page translation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
