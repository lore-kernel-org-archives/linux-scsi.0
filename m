Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE9D3FD943;
	Tue, 16 Jun 2026 17:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632401; cv=none; b=Bo3Fc6iHjwQ+7tvUVerA2CZnnemXP1VaUpT5ms7if5uXBdHSWvMn8MhwMfNkM2143gvIc3z+F7KIZy22gAfMK/siykpgoOXv14I9VK93tASHkdHQltBteHSdrRj2rhIxq7P+nifpUhc08vcHiDgB18ObCbpAODZah4SZtlpk1uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632401; c=relaxed/simple;
	bh=WdkA2dGh3qiPZ0i5m69ONCw3y6A+3IB2oG81WYCYse8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=POZCkSGS8G2a/phi1hXicdeEmt7JLgIEmgh6N8UxPuPCGQZhtINo+GVa7NHYy7rNBQxXGNTJuuD1+GB/nNm3eAkNCsZeYHa3IHx2cQGFF0K9QIFiaqPaQbtC28MOk/qUozAUX7Nytb5C5k5KriG67w1QqMufPaB/xYFuN347vCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RxsTWzVj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RxsTWzVj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=tWXK2MgnxD76uTnjz4VT2lfsHJfH4SLRFX57lXEkaNw=; b=RxsTWzVjDiJ23uFRByihzp7YOi
	Sj+kNPojtis8GUGiY02DCjNz+XBA4kNh+/M9yiNrhxyOODFByn01DQVdLmEnqitFZuZpJxqh9GMHk
	lDYOTjOTf4DfcMztT1vyVdY/e4wxIDBOwr/Nprs1UsghrzyYwkNm5d5zjYAqt5PhgqOdGboRyC89D
	aH487eIHwJbhlLiNza1Tf8JcIZMzxpxEMkeFQ1F62JoDIIdn7PrfvWCG/dAKtTBuGHnF2WFXTzSmN
	Oud6hDWV5TADylpfJ5pK825mXo8XwqEsKH2RwABFdNCSsGblI6ExRQkDzgshsTRZU8GqQSOKkhUKA
	kiM0PKIQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZXYn-0000000GAbV-0q6O;
	Tue, 16 Jun 2026 17:26:49 +0000
Message-ID: <6513c228-859d-4a04-853d-2d1d531b4610@infradead.org>
Date: Tue, 16 Jun 2026 10:26:46 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] driver core: async device shutdown infrastructure
To: David Jeffery <djeffery@redhat.com>, driver-core@lists.linux.dev,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-scsi@vger.kernel.org, Tarun Sahu <tarunsahu@google.com>,
 Pasha Tatashin <tatashin@google.com>,
 =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,
 Jordan Richards <jordanrichards@google.com>, Ewan Milne <emilne@redhat.com>,
 John Meneghini <jmeneghi@redhat.com>,
 "Lombardi, Maurizio" <mlombard@redhat.com>,
 Stuart Hayes <stuart.w.hayes@gmail.com>,
 Laurence Oberman <loberman@redhat.com>, Bart Van Assche
 <bvanassche@acm.org>, Bjorn Helgaas <helgaas@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 John Garry <john.g.garry@oracle.com>, kexec@lists.infradead.org
References: <20260616152219.6268-1-djeffery@redhat.com>
 <20260616152219.6268-4-djeffery@redhat.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260616152219.6268-4-djeffery@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/16/26 8:22 AM, David Jeffery wrote:
> +	core.async_shutdown=
> +			[KNL]
> +			Format: <bool>
> +			Enable or disable asynchronous shutdown support. When
> +			enabled, on system shutdown unrelated devices flagged
> +			as async shutdown compatible may be shut down in
> +			parallel and asynchronously. When disabled, device
> +			shutdown is performed in a serially and synchronously.

			            performed serially and synchronously.

> +			Enabled by default.

-- 
~Randy

