Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF9F2F4A14;
	Wed, 11 Mar 2026 19:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773258042; cv=none; b=KnXXNv4+I12bh8XDmQc6VSi5GNx4QodsWGmhMQDUsfw0WTlqZJpFNT75C6cVJlBQym4ueQOuQDVgxL+WfB8aIve8v/XIWmvFviSj6+WA+b6qetLgOUEAbzJlt+0S/Mri0tJRQQQz0zz2xxdW9eSY6RmH25/FXKPfInvzo6Pr3ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773258042; c=relaxed/simple;
	bh=cqcs0kdiwCEbSZ6YAhhVTcmjX99KADHLItChmhGh1fs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sD16HXcuhaWpGiWmsSYCgh/dr4Vi4mcWu2QSqqfS4k03HKiAvVZV6jjrh+eNQay3n6bpvoNcqR+BwboaUnAdvT0mnfj8dV5tngxH1+BJqpNCTgW2MbLAZzpH1pkZF2A3KBvkevknZh/qLUMt1AmVFLSbLn2Rw1ER3sZnbD+53Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pKcY2qJb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pKcY2qJb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=UauR/UJlDBZ2dBizfiwZm7RvW4m8pMIUl2WRKBObDYM=; b=pKcY2qJbMrXpROU41g8NTDShBe
	SJ7aODbeYHjAdkcD9fbpK4bb27SZdJrCihd4lZ/f7g462tkmKSVAovx0jxQTPP/97rwO2qNTTMixE
	MU2wqxPtf0omdAGrkGMSHdCqEjResGWrLjq0Esq3PTOsvSntU6eZeQMg+fYFelVjRjeB7p8JrwGY/
	cPkdJJDUDrObyaU2K1rp0w9jQ6OUJPyEOO6suxGf3XhciNSIwU1OHfhIHJupl8oJ3x/NGIc4hUdhu
	mXh8DN8ZFmPjK8dMNRxsiGnXeaEbb36jcV7Po1zlKCyiAhykCe4vj8rC2qrxsicH4C6syO+vkUxvM
	Wwlkr2YQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0PQ5-0000000CNMf-12Ug;
	Wed, 11 Mar 2026 19:40:37 +0000
Message-ID: <a15d4e2f-4a6f-4bf5-bc07-c4a1d38e8dda@infradead.org>
Date: Wed, 11 Mar 2026 12:40:36 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] driver core: async device shutdown infrastructure
To: David Jeffery <djeffery@redhat.com>, linux-kernel@vger.kernel.org,
 driver-core@lists.linux.dev, linux-pci@vger.kernel.org,
 linux-scsi@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>
Cc: Tarun Sahu <tarunsahu@google.com>, Pasha Tatashin <tatashin@google.com>,
 =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,
 Jordan Richards <jordanrichards@google.com>, Ewan Milne <emilne@redhat.com>,
 John Meneghini <jmeneghi@redhat.com>,
 "Lombardi, Maurizio" <mlombard@redhat.com>,
 Stuart Hayes <stuart.w.hayes@gmail.com>,
 Laurence Oberman <loberman@redhat.com>
References: <20260311171209.9205-1-djeffery@redhat.com>
 <20260311171209.9205-3-djeffery@redhat.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260311171209.9205-3-djeffery@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 3/11/26 10:12 AM, David Jeffery wrote:
> Patterned after async suspend, allow devices to mark themselves as wanting
> to perform async shutdown. Devices using async shutdown wait only for their
> dependencies to shutdown before executing their shutdown routine.
> 
> Sync shutdown devices are shut down one at a time and will only wait for an
> async shutdown device if the async device is a dependency.
> 
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
> Tested-by: Laurence Oberman <loberman@redhat.com>
> ---
>  drivers/base/base.h    |   2 +
>  drivers/base/core.c    | 104 ++++++++++++++++++++++++++++++++++++++++-
>  include/linux/device.h |  13 ++++++
>  3 files changed, 118 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/base/base.h b/drivers/base/base.h
> index 79d031d2d845..ea2a039e7907 100644
> --- a/drivers/base/base.h
> +++ b/drivers/base/base.h

I know this isn't directly about this patch, but would you mind adding
descriptions that are currently missing for a couple of struct member fields?

Warning: drivers/base/base.h:59 struct member 'drivers_autoprobe' not described in 'subsys_private'
Warning: drivers/base/base.h:135 struct member 'deferred_probe_reason' not described in 'device_private'

thanks.
-- 
~Randy

