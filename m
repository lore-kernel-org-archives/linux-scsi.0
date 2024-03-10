Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C01383A9
	for <linux-scsi@vger.kernel.org>; Sun, 10 Mar 2024 20:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710101856; cv=none; b=g3nC6j+LgAVeYwxDOfqVZ2XLZgE2xAOPlo158n8s1u7OgJ2ls5fbkMN/e7WKhKU+I3CGeDjkNVujklozj9Pj7nhzwNiYzHjuiz5LXshnAvKQRCt+wuhJz6auwXEGHCXWMvRgCkm6V0IrYhj2opvD8+uGeOtV2DG/31iLPyyN0jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710101856; c=relaxed/simple;
	bh=yYpWxaTagmqVzXIXxrJg3aLLEPUItswmEUTywcZvkUo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mMQMYlkTcGcgD2T2XRCpxn0c6oRuxI3+RNR8RXNhWMn9bNKtOFoPD6Umu0LQNigklFa/7yYU/z+79Y1Va+HUcaOkZk4DF282idN+Sly/jrjK5CvUp0o7rFX+thsDyu0iup5FJirPb0WV/5dshWVzEaI7vFUnBfv769yfZCYHR4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nEUjC3om; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nEUjC3om"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1dd9b6098aeso2071915ad.0
        for <linux-scsi@vger.kernel.org>; Sun, 10 Mar 2024 13:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710101854; x=1710706654; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WbiSzw26+9373KYouYTfVHpboWaxNLA5RmqGKrJSo98=;
        b=nEUjC3om9ooDnd/4bTXaTwNJz6rGWVy5+4Ugqzje0Zfpljlc4x46/ZBEg+oSHFXO+F
         YWzwZzSMSLFJv1uDm+ZqgttR4CyH8RPyXJNaV06RPZP74sbAu+Muiu/yqmUzikyhkedt
         2NfXe3Ujj95W1L812F/XqBdHFGPJVncgLAi5R5kpCQs7QTKH1mQbkzAOfux0jj2JT+8p
         qTN9lSoyx8fcIS7qvMD+KybR1d7pQT1jQd+5T+g4qqQyR3p3GjI7d9U9B6aejoFyWxrc
         sa5IiUFntLhJOtupSTDe67BJhC5X2+H6nR6GleqCLyMe9ggqdfd7JkVnVrdbteHYcN6C
         HeUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710101854; x=1710706654;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WbiSzw26+9373KYouYTfVHpboWaxNLA5RmqGKrJSo98=;
        b=W1yDsuY1gYK8XbDQ4nsyJBcsdRy/r7nKPW3PiWgjRDHUX/ejOW+TNO5AvDa7BlGYBK
         imdSG7uRAZSPCBoiC4VcSrjJV3XuwNqZtUe0u+c3Z43G6hdYdiCphi2T5Rmnv0HkLugg
         VoJgYQy6tKsx840deqnhNGWkLMheJqUTQlSKDz2W70BG6cRgtZzKTGMWHdUCWqz6V87F
         uPn3VL4eYkHfNdbAlKGSFivDBRHl1d1jJPGTRpFZgdlT5tcBs+hUo/WGezIVFkSTHNZP
         VK/6iv8zyVkh5vDxgFULYu9Bqb/Orw8kVmHFyCzSTE4N09T8Kjxtxlch8FdCjd+j8QKU
         SjnA==
X-Forwarded-Encrypted: i=1; AJvYcCWSkQlhvB+8EsR/go2/VsXADZypBbkntfRanJ1x2aA/JAAZaScrHTLgGjK1egoZl8XlfCm2XZutMI7ifYjjX5MxK6NvP3QGoZhtTQ==
X-Gm-Message-State: AOJu0YxbiJQ2kHbC9O2+FSnQuIxsGBQSDvSa3sg1bl4uFrhJ64JdULMd
	Fg5vzYkeXxhCpsuKdIbcKVF24aRU1J0I1i7qKaPDOgNTlBz8Z9kffUjd6EtWOQ==
X-Google-Smtp-Source: AGHT+IHpNG92iH7XTGOkJLBcMhmM9mRBUygQpDgdmRz9qp4hXq7hh1jlRbGd45dyAql9JF0l5lIGaQ==
X-Received: by 2002:a17:902:7608:b0:1dc:90c0:1e9a with SMTP id k8-20020a170902760800b001dc90c01e9amr5153297pll.64.1710101853807;
        Sun, 10 Mar 2024 13:17:33 -0700 (PDT)
Received: from google.com ([2620:15c:2c5:13:d1de:e5bb:fcf:1314])
        by smtp.gmail.com with ESMTPSA id p8-20020a170902e74800b001dd6298a3efsm3039369plf.118.2024.03.10.13.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Mar 2024 13:17:33 -0700 (PDT)
Date: Sun, 10 Mar 2024 13:17:28 -0700
From: Igor Pylypiv <ipylypiv@google.com>
To: John Garry <john.g.garry@oracle.com>
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com,
	chenxiang66@hisilicon.com, jinpu.wang@cloud.ionos.com,
	artur.paszkiewicz@intel.com, yanaijie@huawei.com,
	dlemoal@kernel.org, cassel@kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/6] scsi: pm8001: Use LIBSAS_SHT_BASE
Message-ID: <Ze4VWDO6_X6BbH53@google.com>
References: <20240308114339.1340549-1-john.g.garry@oracle.com>
 <20240308114339.1340549-3-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240308114339.1340549-3-john.g.garry@oracle.com>

On Fri, Mar 08, 2024 at 11:43:35AM +0000, John Garry wrote:
> Use standard template for scsi_host_template structure to reduce
> duplication.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 20 +-------------------
>  1 file changed, 1 insertion(+), 19 deletions(-)

Reviewed-by: Igor Pylypiv <ipylypiv@google.com>

Thanks,
Igor
