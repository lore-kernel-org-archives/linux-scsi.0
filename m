Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5911EF08A
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jan 2025 12:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736253014; cv=none; b=lOXAVChAujcAkJ6+JetJyzPXjQv5x1GFbr8LC++RuUtyrZxeKYJD49YNrd+5AC5N5eIqHFo8LP9mb+u6DxsZXRB5ICA2WtKmOiEJFOAx6Kk2ylrTkhxrth/rabHdeB02kgY+yZ43dVVp/lqEAeRemyYI17ocbbZR6PS7hnUQ0w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736253014; c=relaxed/simple;
	bh=NWekeuKUOLvDOs6s2gbwTr1+mKpu8Z8AuyHjmEI5UOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mjwADlo9n4yTEV5Nxj/FtKsltDQnGQPOntxlNxfjZXpzpuORAJysLn4NLD4O1c4JdglYNgAD3bFGFct4Llu9KiBQCquYnpDOyNdV1+FqPmsg6LChBGezLcZnDAUeB3QWmzqQouU2uYIJi3VVM2zir8+/npkKUYNf8vvYW4WAZRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TdYvUu8D; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TdYvUu8D"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43621d27adeso107200825e9.2
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jan 2025 04:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736253009; x=1736857809; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9oKx+g6OpK2tMiz1AXArp0pzfyJtWxMl3EtD57kJgmw=;
        b=TdYvUu8D1IuwKVOTG7VQEgvUbwo+BS/u9NKUNPIWoBg3j0vcgWdfIhIuQkZG9pRqdk
         LVfZNViM+VGwKGMiC7HNrkjzpV6lBpClMvm6zvGfzifYySY8Tnud65cs4S+qvTOUjc5k
         VDAWPpwDCjnx/04BS3tllNeud6qhQrY3YWoeuSq0tl0jTNOgMqyMhJItfGKGTZYnqlG9
         fR6x5T8FUwx8+HLdTMpKpJ1kjXA7grGXv3E1jyUYOfaHs6lg5Vp3IKHP/1jRlxuUkZMM
         wpfdeM1KQSqQPn1gY7pq98odiblfzfqelUvPXtwdy+fgfSrvsoGVHNAwg/oMGZ/3G9tW
         rQYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736253009; x=1736857809;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9oKx+g6OpK2tMiz1AXArp0pzfyJtWxMl3EtD57kJgmw=;
        b=Y7MsrRZpvi4XJ1eJtG0D61zK6T5lKT1wfkWWWDejm5YRW4PxLs9M2iJEujfLPVWgaN
         GK5SBJizV+qNn1Nqy/7fW/Z/9qwyIY1xLhLEIjvP5o3YizGpb6TKIsoEYGo6+ex+WRwr
         jFMcAA6eGDd3kb6AHpI054YQD0x7EiMP2rbJtesg+nSh4PYaAAu5SyZYyv7rIQhHJUDW
         RBIH60XywznDw4ivDgi1/4SJsfshDsY91LM9DBkqWt/Tq389kKh52Vp0mqT6CpC2fH6Q
         sUVHbSJP6YLJtq1XNUz9WjTBB1llC2g0x/cznsVDEyMAN4REKpViuRgrx7KfFVYooQ73
         1mOA==
X-Forwarded-Encrypted: i=1; AJvYcCUd/6kspKAp3zDwxEWCwE482mH3kBcJ1cao/shQC8U9817YESxG8k+sZZzlE3h32innMmz5Rtko9uQt@vger.kernel.org
X-Gm-Message-State: AOJu0YwSy0n46BwIqxNJgDuWLhM+pFetxVVjBOC0FzdWvjERHq+4Jqw3
	s+18y0s5R6fLW/fpGp1R7HJH6V3F4uNRKWEkKEXZasqEDC3pW6YS3hRFy7MZeT4=
X-Gm-Gg: ASbGncscbkeLAurrzSdn15hwCT5P0qOtgQVZdcweeMUK6vTAU0yyEaVqJb8G+sPKHPJ
	qKtZRD6jsG5jZt/4GUJm6hmSI2Qu9iU2UaIGSWmJrsg6o0v+0e0Rks++1IlgueyOK4iWwotdZCW
	YGpPK+/agaeiZt24eoUznZ6wiAwgdqjOiDKDGKz6nj++8i+GDpd3ASQ7BXUrMeM9WchXtCjCaNZ
	qotzrCKUZ37ykOtplQ0sgcg0UfLcgkv67J0KHVJK1N3XTeyO1K/D97aDyBWXw==
X-Google-Smtp-Source: AGHT+IEKKA4graFSHjqic7No2WQQs5z7AjXA66Y32ufFyWwCe5KXzQuwUPNJQ7n1GyPlo1MVe3Z4nQ==
X-Received: by 2002:a05:600c:150c:b0:431:5aea:95f with SMTP id 5b1f17b1804b1-4366a0cf7e7mr532081855e9.16.1736253009178;
        Tue, 07 Jan 2025 04:30:09 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656b441bbsm627320025e9.40.2025.01.07.04.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 04:30:08 -0800 (PST)
Date: Tue, 7 Jan 2025 15:30:05 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Karan Tilak Kumar <kartilak@cisco.com>
Cc: sebaddel@cisco.com, arulponn@cisco.com, djhawar@cisco.com,
	gcboffa@cisco.com, mkai2@cisco.com, satishkh@cisco.com,
	aeasi@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v7 07/15] scsi: fnic: Add and integrate support for FDMI
Message-ID: <4141c9ab-c640-4765-a23c-c2f64df687cb@stanley.mountain>
References: <20241212020312.4786-1-kartilak@cisco.com>
 <20241212020312.4786-8-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212020312.4786-8-kartilak@cisco.com>

On Wed, Dec 11, 2024 at 06:03:04PM -0800, Karan Tilak Kumar wrote:
> @@ -612,6 +615,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	unsigned long flags;
>  	int hwq;
>  	char *desc, *subsys_desc;
> +	int len;

Do not introduce unnecessary levels of indirection.  Get rid of this len
variable.

>  
>  	/*
>  	 * Allocate SCSI Host and set up association between host,
> @@ -646,9 +650,17 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	fnic_stats_debugfs_init(fnic);
>  
>  	/* Find model name from PCIe subsys ID */
> -	if (fnic_get_desc_by_devid(pdev, &desc, &subsys_desc) == 0)
> +	if (fnic_get_desc_by_devid(pdev, &desc, &subsys_desc) == 0) {
>  		dev_info(&fnic->pdev->dev, "Model: %s\n", subsys_desc);
> -	else {
> +
> +		/* Update FDMI model */

This comment adds no information.  Delete it.

> +		fnic->subsys_desc_len = strlen(subsys_desc);

Keep in mind that strlen() does not count the NUL-terminator.

> +		len = ARRAY_SIZE(fnic->subsys_desc);

Use sizeof() when you are talking about bytes or chars.  For snprintf() and
other string functions, it's always sizeof() and never ARRAY_SIZE().

> +		if (fnic->subsys_desc_len > len)
> +			fnic->subsys_desc_len = len;
> +		memcpy(fnic->subsys_desc, subsys_desc, fnic->subsys_desc_len);

So this is an 0-14 character buffer.  If fnic->subsys_desc_len is set to 14,
then the string is not NUL terminated.  This is how the buffer is used in
fdls_fdmi_register_hba()

	strscpy_pad(data, fnic->subsys_desc, FNIC_FDMI_MODEL_LEN);
	data[FNIC_FDMI_MODEL_LEN - 1] = 0;

This suggests that fnic->subsys_desc is expected to be NUL-terminated.
However FNIC_FDMI_MODEL_LEN is 12.  So in that case the last 3 characters
are removed.  LOL.  It's harmless but so very annoying.

Also strscpy_pad() will ensure that data[FNIC_FDMI_MODEL_LEN - 1] is set
to zero so that line could be deleted.

regards,
dan carpenter
