Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB4F211C;
	Thu, 27 Jun 2024 01:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719452774; cv=none; b=By7F1wIaZrx+38FlwW0ua4p52ydVqfNey9FVNjvXDO8yQ592fGCdyGGrqVU+NrFiAMYgy0pIwli7oEcwXC3JQs70pOUJDsBL9p6sZFiCUA8t4SfeFv1RoZSHcLZ//UfM+PAzM8SXaxFZ+ev97ab2/hKw6YBlZUyGwvxvJF57gg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719452774; c=relaxed/simple;
	bh=7mzg6UFFBwxUGEP8ZKHoxmdqFf2KwpRbJ82GWm0eFF0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sSDcCgdd+vFB1zNmzBlR+glYOg16EmBQKrGSjtmpuiZKyoK+RlCzuoQ6VaOdzhuyZ31ahQvVgzbmXoBqliErviFtHmSJbbKuxkPRCWc9ELfussy+RaLV65NqYhIB6/uO8W1J2Z+fIUIXSNjbgBM3k2Ijvkj1tozhWNO1agCUcso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VqNOjIKU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VqNOjIKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE712C116B1;
	Thu, 27 Jun 2024 01:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719452773;
	bh=7mzg6UFFBwxUGEP8ZKHoxmdqFf2KwpRbJ82GWm0eFF0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VqNOjIKUy2bU9V07Hp1lGWRe8GhWNcvC3eA7gi4rH6E4HT4lt5gpS/RumHzIyLxMu
	 jCAXB6iljG+MgnSZWeVHE9ybJEe76rGSf6yTqRjCkfp8nXr8ySW2spvE/eRbUn1+R/
	 51SJE1EQI7q6wX41iSM+Jh+ynY7fkH4DVpALPxyF7T/LF2iZbVjrFCVtwBF+uXKKiF
	 vM1UHwaWRUT6zHDZnXqJYe760vn3d5tF9p8paLGz6PJmBdomno+GtvpF+Ib5t32sVf
	 9HLaPvA9ZNmHHIDOw/oRl5T6VgatIzR4wJTz38Lh3QrZfvGIl4bIxkEex2Dh1gUXTM
	 HRU/LE0DVwW4Q==
Message-ID: <83125236-7d07-4b62-b86a-5a70f3ca578e@kernel.org>
Date: Thu, 27 Jun 2024 10:46:11 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/13] ata,scsi: Remove useless ata_sas_port_alloc()
 wrapper
To: Niklas Cassel <cassel@kernel.org>, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-27-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240626180031.4050226-27-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/27/24 03:00, Niklas Cassel wrote:
> Now when the ap->print_id assignment has moved to ata_port_alloc(),
> we can remove the useless ata_sas_port_alloc() wrapper.

Same comment as for patch 4: not a fan.

But I do like the fact that the port additional initialization is moved to
libsas, as that code is completely dependent on libsas.

What about this cleanup, which would make more sense:

1) Keep the ata_sas_xxx() exported symbols, even if they are trivial.
2) Move all these wrappers to a new file (libata-sas.c) and make this file
compilation dependend on CONFIG_SATA_HOST and CONFIG_SCSI_SAS_LIBSAS.

That has the benefit of keeping all the libsas wrappers together and to reduce
the binary size for configs that do not enable libsas.

Thoughts ?

-- 
Damien Le Moal
Western Digital Research

