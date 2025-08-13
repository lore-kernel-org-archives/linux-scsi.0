Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA63A20D50C
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 19:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755114182; cv=none; b=qPCnWmgplZbzqhqXcZEv1p32iBPMvwA2xxvQYlKdK+UyPU+dkzqD65aKpVm3osMyKF3r8k5uoL+4nk0Zcdupu7qLAJx4wNDeRHHC0H8SOOxNGYx3+t3z1hvWa+xlm0rJ7cuh1NIQbXHmHytxE94f7Iw1kuQZI8l6kiTRoBr5rJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755114182; c=relaxed/simple;
	bh=S3+lEZFxzNFrR1dDHVo0nGH6n5NzkJBRG7g9FCSGDBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=irbkAJH4LGfioGE7nZGYbAFwbih9vYomMYIpG6t1AVZM7UDh4N8DAnq4/p5tGcaFoIMabxU4FTtcdBU9GnN6HC7J8ishnvNSaZ5ZK7RID0qKFGwc1WvdpFU997kgGIyY/PU+j5kSCgbFMDpVWJlmddfFAaHARWzL5xKG4V0hVVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dUfpT8dB; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dUfpT8dB"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-242d3be5bdfso1325ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 12:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755114180; x=1755718980; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e5yjeBF0Fvuj+XdIYTIoaakOdeBP3QCm0K+Uemswf7w=;
        b=dUfpT8dB6EKOKBAWPGXJfJQhCJkQpIYTNX1NistmLf9xexotK563v18Gn6RXZzc/HB
         KMbZIlJGbyonjTvc2O8jD1R+pq8llZIVISJf2cgIaVmgkUYm8fU4gCTiMkzyTFqcyGPr
         15eO2EX+MyXGExVtHXKSx4mqqFX77+SJPIpu7UIzrqR4xdTxVIl5N19E6pKpOUQCUQMf
         e61sMoLI0z7l4uVU8eTfFdoHGsQAaAvhcSB5F4OMTL5jKZeAEOBtIInugSOgw9Iw8bJg
         YqUSbIlBTPyI429fbZdiNu0BDVEDZM/2bRer1KRmjOucL8bmW1bQyQ45vc/P18zOqocJ
         ZfRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755114180; x=1755718980;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e5yjeBF0Fvuj+XdIYTIoaakOdeBP3QCm0K+Uemswf7w=;
        b=NiF39zVkzbwmBcDNhdiA1Wo0KmERfPfwSctGbM9WBjK670MyoXnGBu8/8vOSlw9+D8
         6MaF76/Y/q4MskB08x+JCkw3wDIF3UlilgUA41ZwjlnXMeGZUYpjSwmyrSktFilaWJHJ
         6mfG7jW9k7N+nCB5QiVKvpQpHgb6VjilI5FlnNGxjsdKktK7/7rDw37/kmk9aM++Wlxt
         14TqUlMxzj2qyzUGCm40UV/BAQvv2rL1dpRbJjWA3LZGXrTrmpoBzSVVYgPr4ASVXtgN
         Pe1LgtC071cSjHZ7nwId0MWFUaSmYtC6Mh1g0uXTE6NSLsdG1r5PjmK9c4OjyhqJ6zXB
         JpRg==
X-Forwarded-Encrypted: i=1; AJvYcCXIQfHTS8WGHKtftNvCWDmF9U1YJUOcPhqWx27KqZlQyNDZ8iMk/cLNMsWwSbVr4s+cj7XEJsFZjh0b@vger.kernel.org
X-Gm-Message-State: AOJu0Yzzdopoe+v2atVz5HYgAVtYLZfMw/HdnM2Kn//brySgOFDoi/n1
	bJtrXKQqPy7tEPM/M2FTLrNOcJHy33vRqLUR+b18ZtwKwWJQClK+dJ0/ibcEeSSVMA==
X-Gm-Gg: ASbGncsQC9Xypxdo+2Bife0/SNf+QTog8EwRs7dqChztSRujijUK3xu0LiYMz2SIc9F
	1sUBEFqGaGpuUFYKwgA4kBc/inUnkdKDa43mBKhTbMXNE1RrWrhuZvjeQNfMUSAa+lACDggQVz4
	h0RbmgKosg24CE3jr3eLQWnybi5OaXOJhk/M/8LOVxYSpiC9ux2WDEHyYbtTEJqWAqJQs2KJR5o
	V9Mzp3l+pZzfShWDbnLSH4Ruit20tKPvP0D8Lv0Z1O5sO81CDRnqzJdCroxriDxJUP60qQUMZU4
	BZyi3IebTX+yiJFtjxkv9jODzfZqvxAFsxIpJbou1lhZFe8yjcu6DQCWS13MvqfBDVHwnKvDYE9
	dPaTlgdpDka0ZX1kEknheuRV9PZJIi23E5GOh+yMEoExaxnL+qUPFoTbTkw==
X-Google-Smtp-Source: AGHT+IFB4a9Tlba7GPaRUSvgnWq6N832jg/KaVdUpCZA0Nv9gL9PzqWfSTUd4LufwdODQPn8/jVjzw==
X-Received: by 2002:a17:903:11c7:b0:23f:df2c:9f0d with SMTP id d9443c01a7336-24458e56fb8mr197455ad.21.1755114179780;
        Wed, 13 Aug 2025 12:42:59 -0700 (PDT)
Received: from google.com (57.23.105.34.bc.googleusercontent.com. [34.105.23.57])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1f0f603sm333079445ad.48.2025.08.13.12.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 12:42:58 -0700 (PDT)
Date: Wed, 13 Aug 2025 12:42:54 -0700
From: Igor Pylypiv <ipylypiv@google.com>
To: Niklas Cassel <cassel@kernel.org>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Terrence Adams <tadamsjr@google.com>,
	Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/5] scsi: pm80xx: Restore support for expanders
Message-ID: <aJzqvp4QPn1qQa_Q@google.com>
References: <20250813114107.916919-7-cassel@kernel.org>
 <20250813114107.916919-8-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250813114107.916919-8-cassel@kernel.org>

On Wed, Aug 13, 2025 at 01:41:08PM +0200, Niklas Cassel wrote:
> Commit 0f630c58e31a ("scsi: pm80xx: Do not use libsas port ID") broke
> support for expanders. After the commit, devices behind an expander are no
> longer detected.
> 
> Simply reverting the commit restores support for devices behind an
> expander.
> 
> Instead of reverting the commit (and reintroducing a helper to get the
> port), get the port directly from the lldd_port pointer in struct
> asd_sas_port.
> 
> Suggested-by: Igor Pylypiv <ipylypiv@google.com>
> Fixes: 0f630c58e31a ("scsi: pm80xx: Do not use libsas port ID")
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Thank you for fixing this, Niklas!

Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
