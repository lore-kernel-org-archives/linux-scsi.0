Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E4430AAB7
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 16:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755275947; cv=none; b=plEpOVNIYt+P7c+9ijvf1Qu6yC+FvXMns8K4BdQE0yJ9rqyiaQgFZ+3SSqDeELIZTkiZaYsnhAj2Iiz9/0igZGoJ80zrXPzcUoEbuM2uzCYb35f4qTPMa1i8pFdXvJzPCErRE3si+x8OTj9AJ36uvQHtdP6IDBHmgzeqpu48728=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755275947; c=relaxed/simple;
	bh=0Mjcb7EACHwG2udX/Ta+L+DP5eo5+HNVKSMvziYqvNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nXq13XXnFPsegB+dvXl+8PBWHUL9E1s+CYoEWq45VTZHFpWvcqTqZjppEMbmxvlzJvjWqusv/fNRKa8xabYwDVCcHUwASOo5zPgf6knooqpcaSkh+z98vyaLAURlepijFVuRQ9qMkuPlq2QnVjvWDY5nPuI3J3s6724OlaVah+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gWI22BC4; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gWI22BC4"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-242d1e9c6b4so4465ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 09:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755275945; x=1755880745; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ACHslmzFGkcI90cDAKGZTQeAzbfztE6TjBqkqnOFFBA=;
        b=gWI22BC4fDe+f2k6f+WGwnWQ/W3lu/342GYgu1YVuUPwmbn+uVv0xSNIHZFZyvLwAg
         UyurXjE1TQZdpXKu4t3oh/4U111r+Z/BUm8R8KDXeveJrmUZOpjpG+CjkqalU6S5Nd4u
         rfe/QhTxYOghcret2qxL5WKlFTavuFFj19RkHFBNyn6dghEYpD4vFaJ37excFnH94AAv
         F6bRvF/RbErZ4PJrXsbXA1OTy7cHS1CWT6CSR7m0e9jv3jLXoFodQDmADOMVDUhlMvLq
         rZWA/AwTXZZvZqLdWWk1H3qjxbGiaSXpOAMsR6YMTm0IG5MK9K2X4wrrEBUWBpM3k51g
         lmaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755275945; x=1755880745;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ACHslmzFGkcI90cDAKGZTQeAzbfztE6TjBqkqnOFFBA=;
        b=bQO8h9qSM4vsiNEqIFkbDw0TzROyG039A/Wjli1WrSHSWTSK0r9hGS3Lly5CZC1v+L
         RWiaBH7dfhy1Df5I0MxvLtuVQTq6qUTHh1ya4VIkzqLILj33j+Lwukm1T943rTNDdB7a
         +SuFFKJCIHQP1MIX4LC7HrSsNQEUo4XZ63j4AfpJY80Omv5PJPApbZp+Ii2gzZscbSBi
         N/Ad14Es+Bg1Nyn308wJzuLgQDBECUiYA2cPc7wYp6lR9xYOm0v8EqUlauJ9ExNcW3RD
         01cvkBokfsc+cAz5AHJbXG4WddJvmwpz/odEp0gtavG7PIXxLDPxotGAeXcUdEGbqc4W
         jzvA==
X-Forwarded-Encrypted: i=1; AJvYcCW3ZFYsT7XzNXEX9HJkub+3Dv15Xy+YADWFCMS8s4IwPYdE1yIuOI5UVX3udeiRIJe4sK/ve166o2u7@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5OWlwxYowTxv8RZij19y99xdk8/DH5XmPgHm+cdJ8dzhaWee0
	dgLBALQkGUJde/leN2CtMbEp2AoM/MML5lb34kUAYU7Tzlpz488oa59Zb9WsCUydGA==
X-Gm-Gg: ASbGncuxmjuUfWkv9hkYOKkdegQwMB/YHf0NNRHwdo2U+jVDlxkOMVHsZXMHswUapuN
	OGm+xqNDNfwE3uJ/qoR2WinuKVzJ899BLv47O2uFOAaoeW92QYlGSLbEeQ9mCCNJNf236n3yTsc
	8ix3i7bwBzT14fwaSQrH7hr6Et0Aj+5HtaLmPcAIgL8qWaENnOtBPf3rLehzIm29p8oU+t8mZ2k
	v1In61L05t8/AZCUalXXOPEyZWF4UfWlfT9xeuC45k7HuRhiqvVNUPFDPyjWtcz48nDTT2f2Ens
	GebHG8K35f3fL4beT6aB+hxsQ6cOnXPnDCKvcoZ+yrbrbkGdcdRCMa1UmOOesAUx0nM9oe/1Te7
	Kxfuzh01mlMlS0Bvbgu94zXxxUrGR/HKZ3bqUG4RG9p8g23cacwdqx/HvyQZzbB1GwKcyPrD61w
	c=
X-Google-Smtp-Source: AGHT+IHxo8h6kWg/qs0rNEDX1VR6PFUuEQpHOfb7h/ywLOXytUPffF0XJZtjjcC5UUsjp/4jHh0elQ==
X-Received: by 2002:a17:903:1a67:b0:240:2bd5:7c98 with SMTP id d9443c01a7336-2446ae54f34mr3502695ad.11.1755275945085;
        Fri, 15 Aug 2025 09:39:05 -0700 (PDT)
Received: from google.com (57.23.105.34.bc.googleusercontent.com. [34.105.23.57])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32343ca3ce5sm1538509a91.33.2025.08.15.09.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 09:39:04 -0700 (PDT)
Date: Fri, 15 Aug 2025 09:39:00 -0700
From: Igor Pylypiv <ipylypiv@google.com>
To: Niklas Cassel <cassel@kernel.org>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 07/10] scsi: pm80xx: Use dev_parent_is_expander()
 helper
Message-ID: <aJ9ipCQXfZ2q3X1Y@google.com>
References: <20250814173215.1765055-12-cassel@kernel.org>
 <20250814173215.1765055-19-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814173215.1765055-19-cassel@kernel.org>

On Thu, Aug 14, 2025 at 07:32:22PM +0200, Niklas Cassel wrote:
> Make use of the dev_parent_is_expander() helper.
> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
