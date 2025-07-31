Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42AD8F40;
	Thu, 31 Jul 2025 03:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753934266; cv=none; b=YqIRPyDSkwcG+YcDS8jz0IIUzvFPThN8ronsPBllXv5VPel0Ey7ftw8aVbaXpgGNUFvyuRX4q9SoayjjqDvWNX83gaxIGzb6r8MrDXLIjiUIAUdZ7U5AUJX3MvS90xaForaLEzIY3HmAybYy4FBUhGvXVUSHjGD+ZWFOVndC4Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753934266; c=relaxed/simple;
	bh=maPP0KTLL+KVL5uDKTl+/6t8K9GjbDJcQyXmtsi53P4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tvWW6lWtwO0NdU7uVGm5nJzPi1qLFBZbNKBfEoZ/JeDDbTjWrVwxPwy3zo78qHFiH3Zdd2QPKFqhQQ2ylQJUX7GhtDKynEElzCPDbXKpwRd16BvK4bFnHmBHBIUJ+g8wrBHuQp+EjOYqwyBFKTWSAsHb9/lDbUZiJ24T0i0xUPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jmh9qFkL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jmh9qFkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83823C4CEEF;
	Thu, 31 Jul 2025 03:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753934266;
	bh=maPP0KTLL+KVL5uDKTl+/6t8K9GjbDJcQyXmtsi53P4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Jmh9qFkLalMAhUxy+LWo2akSe02Aca8opVmzcGK/sJzqYYKeiqJ6/j9p5QAPWx//l
	 wRg5jBAZ7OQRfwk8Iir4x1Nj6hcdnquplh5ZhVrLXqoVAWEpmVzQWpRn5oCa7SzAje
	 XC/9s4kN+YmMY27FRG2JEII7h2VzoJwO0vhoNbBJmr50lZo7lncg7hhQX3v44Zhbdd
	 BxFw/wuc0Yo5vYy0WDr67S5TGimEkabGd7Oj0nh92KmIgmQNWzS+i94+YPxp77D1Nc
	 m4CPBaI9K3gDM/kw6LvQQoN4Vhlil1WhWmpAx9dPkrdhMkUCNe7FPWrcFNt4xAxpCv
	 ifM5XY5shmImg==
Message-ID: <ebc412c1-1fff-4dea-8efa-c062b66982cc@kernel.org>
Date: Thu, 31 Jul 2025 12:55:14 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: buslogic: mark blogic_pci_tbl as __maybe_unused
To: Arnd Bergmann <arnd@kernel.org>, Khalid Aziz <khalid@gonehiking.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Masahiro Yamada <masahiroy@kernel.org>, Alexey Gladkov <legion@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Geoff Levand <geoff@infradead.org>,
 Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250730214451.441025-1-arnd@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250730214451.441025-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/31/25 6:44 AM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> A previous patch removed an #ifdef check around the array definition, but
> this is not actually used when the driver is built-in, and now causes
> a warning when -Wunused-const-variable is set:
> 
> drivers/scsi/BusLogic.c:3727:35: error: 'blogic_pci_tbl' defined but not used [-Werror=unused-const-variable=]
> 
> Mark it as __maybe_unused for this configuration.
> 
> Ideally this should be fixed instead by using the array as part of
> a pci_driver definition, instead of the linux-2.4 style manual bus
> scan.
> 
> Fixes: 204689f0ea20 ("scsi: Always define blogic_pci_tbl structure")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
