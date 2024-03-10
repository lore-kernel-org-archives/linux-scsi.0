Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC6339FFE
	for <linux-scsi@vger.kernel.org>; Sun, 10 Mar 2024 20:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710102314; cv=none; b=DYkZGxJ/dMSqY7PGbaySz1Ll9Z0tVggsOrIJzCuXfg7Qn8koACSpb2tYhsFBiB6lD1gG2jN0O56o5sWoL2FGWotG+ZyeQUuovh4BG5UHKtrKM487HMzcgyr92RpK0rmLLctw0hT2ldOFWoUwWsh2m5gra4oeT2N7baX5rmyG7is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710102314; c=relaxed/simple;
	bh=dX2AMrq/7kp8z60Mca7/OzLoKxT4Q4mWoJ2VKPVk7I4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gaHeYNDRw69SrMUnHe5YuPEQJem7lt5X+9goo8/5Y3ZaPKxEURO4Vsj7QGrL52JBdyT+LzLI/7mUTVylkbiOXfvDikETmwBWnZO5jiSQIXBz65i7AcGBQM+m4ZrblxW7FxZlCoV+jMAQYamqWG91QfchHKa2isRkEKMxwKPBA9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XdznT4Kw; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XdznT4Kw"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-5dcc4076c13so2420658a12.0
        for <linux-scsi@vger.kernel.org>; Sun, 10 Mar 2024 13:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710102312; x=1710707112; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wgxsON1wX0X5ll1QPvTDk6MMOdNDfvszUycVnKDJ7XA=;
        b=XdznT4KwHCpUohU7NRJm5Nb5UzYQSlwRacPHS4vWUzIjr5lIQG4Wa1TQ7vtKoBLysy
         rz7nV4K2bWzCAOaxH3efBuPWVE+JUqh5RTkEc+mT71lla+JrjLalehFB0m/w9Zm9v1wV
         80nXQcjQPholUQQfvt+2jG7wuv2xQkklWHI9HxmidGO8cacwhGhlMR1kkcwEhsrEz7+7
         M/JUuJ6L/XcdNhOX7zBoKDiSl2Hc/b841dLlFqrDs62k+9f+VvNVia6yGZDT8CHeuqyj
         E3vSAfgc/q5G2LwXWCGMLLXu28MwuKjj00Sag1GhAHvMMWnr62Cq7SGb+a4aOR18HzRU
         tIaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710102312; x=1710707112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wgxsON1wX0X5ll1QPvTDk6MMOdNDfvszUycVnKDJ7XA=;
        b=npXi2LJW68QF+8TIuX2gtj6tlDofhpl+SY7B/xkU3F5gMVV8twQ2ToTeEwAWir5L6Q
         jrl3bHLGKvIDd+BF4gSx1VEEq35GyYKu/TJpn4tzwdvDxL7BfirhYulnBClcW7/IuXCs
         8Q9Utj3yTeH+w2858++PyjyjotLS3c4LQth2SDCfGkyBRjtb2yjNfLasd04Gk6pB5MgS
         kQ008uWiI6Q4j/VROjWCLYOobXr+NLCMb5ZJsAZaIAgP2oMDZEKn6G3nSLiCgLYZq1Qh
         Y2BEJ+wKt6jDeQHzymm47/AXaqZmHm/6wwsyqOPv986o6FS10Yq1LHVnNrbDdoW4pcfH
         X3mQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5/adJs39wAIcSu9iNfP95WIVsXywRjpf3qFB8u/ud/FGDlGQBgEgSHuaBWyrxTuyb0Npq3aZLQD4IZHaGRIeD9ZzBn4VppUgoqQ==
X-Gm-Message-State: AOJu0YzETpPe1Opam10gjU8Mm4E84gZXTTpdsPlISlujtz2vmgfj66D/
	GWfUZZsZ+gViScWlIFMu7oq2oL7LMnyP/CkF7qW9GD+fqw8aAwMOn+9rwD7KYBplSpjhPhoaRDJ
	esw==
X-Google-Smtp-Source: AGHT+IFuuQ9QL7EHIljZVXvrBxDr5fqMxAMmld1+YwO0Nq+B5cB1dC46S6HnVmwhaGwLIzAJTjMfsw==
X-Received: by 2002:a17:90a:f992:b0:29a:decc:711f with SMTP id cq18-20020a17090af99200b0029adecc711fmr7689327pjb.20.1710102311843;
        Sun, 10 Mar 2024 13:25:11 -0700 (PDT)
Received: from google.com ([2620:15c:2c5:13:d1de:e5bb:fcf:1314])
        by smtp.gmail.com with ESMTPSA id g19-20020a631113000000b005cd8044c6fesm2923687pgl.23.2024.03.10.13.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Mar 2024 13:25:11 -0700 (PDT)
Date: Sun, 10 Mar 2024 13:25:06 -0700
From: Igor Pylypiv <ipylypiv@google.com>
To: John Garry <john.g.garry@oracle.com>
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com,
	chenxiang66@hisilicon.com, jinpu.wang@cloud.ionos.com,
	artur.paszkiewicz@intel.com, yanaijie@huawei.com,
	dlemoal@kernel.org, cassel@kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/6] scsi: isci: Use LIBSAS_SHT_BASE
Message-ID: <Ze4XIlerHpox-INc@google.com>
References: <20240308114339.1340549-1-john.g.garry@oracle.com>
 <20240308114339.1340549-7-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240308114339.1340549-7-john.g.garry@oracle.com>

On Fri, Mar 08, 2024 at 11:43:39AM +0000, John Garry wrote:
> Use standard template for scsi_host_template structure to reduce
> duplication.
> 
> Reviewed-by: Jason Yan <yanaijie@huawei.com>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  drivers/scsi/isci/init.c | 23 ++---------------------
>  1 file changed, 2 insertions(+), 21 deletions(-)
> 

Reviewed-by: Igor Pylypiv <ipylypiv@google.com>

Thanks,
Igor
