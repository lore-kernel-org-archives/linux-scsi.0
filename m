Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D864917FE;
	Thu, 27 Jun 2024 01:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719451860; cv=none; b=CiLcvWB3jKt+yFxKY5lw5HN0yDDudrxc0Cur+8pCICQUeXyRQ1jyAIjX5oYebF2A617yo+v1js5MnYbkPOMiVKp7a1lrkzj3Uvbg60RXHY9y4otZHL7B4jGTH7681kzqaQRe3gpTQYS0p7+2YM604FVNjVQLvo9j7yEytHeNQBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719451860; c=relaxed/simple;
	bh=WjcO8n9VAUKFEyYchd+eiGfr0/stKlMZHZN+o7ulerQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nRcZ3vHhOQQPcijXe5FJ1DHrwvMG6lS3IdEuX3Y41Q5qrtjRBoigxBXNONkoYFcNIWGSCasIb3P29G1eAAsEu5+OAbmd0XW1gAvnva3qK6EjcqbxNRG2NviKDGkWJvFijSUNNWskOBTKG96to0uwYSKstzRxpJLAZiAq7jlVycs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T7bZqjVp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T7bZqjVp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C81FC116B1;
	Thu, 27 Jun 2024 01:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719451859;
	bh=WjcO8n9VAUKFEyYchd+eiGfr0/stKlMZHZN+o7ulerQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=T7bZqjVpO7r9t8MIEbwfNg+3YUcC/QkClvPgPwMy6HHMfCBCZi6ZyM98kJA5nHob6
	 vpfdQFpiEm6QTp/3P0WmCD6ONdKlnya8jjFd0d8CYs/OI2icEo0Lpgz21dGD2eBnmc
	 ro1tMAHFF4T+prFWZhkAIdeMVnJj+/YDKcYgsTweNUSNEy4KI6H6HFf3F72kjXM3Nc
	 IYEAY4Ljvu5n8phvgfBtp1wxbFZrQh8ocmlEST9wlKQqYvWRRUTlq3AAdRLldvnY4w
	 cIzpR+hIPUfN2hYox7fcr0157iR3zCigOEWP79tkngEPh/5/IkOcE4kzAhrt3/7VvU
	 Ing+N+rRuXsEg==
Message-ID: <b548ef2a-519e-4693-80c0-06d9212dbc75@kernel.org>
Date: Thu, 27 Jun 2024 10:30:57 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/13] ata: libata-core: Remove support for decreasing
 the number of ports
To: Niklas Cassel <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-ide@vger.kernel.org
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-22-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240626180031.4050226-22-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/27/24 03:00, Niklas Cassel wrote:
> Commit f31871951b38 ("libata: separate out ata_host_alloc() and
> ata_host_register()") added ata_host_alloc(), where the API allowed
> a LLD to overallocate the number of ports supplied to ata_host_alloc(),
> as long as the LLD decreased host->n_ports before calling
> ata_host_register().
> 
> However, this functionally has never ever been used by a single LLD.
> 
> Because of the current API design, the assignment of ap->print_id is
> deferred until registration time, which is bad, because that means that
> the ata_port_*() print functions cannot be used by a LLD until after
> registration time, which means that a LLD is forced to use a print
> function that is non-port specific, even for a port specific error.
> 
> Remove the support for decreasing the number of ports, such that it will
> be possible to assign ap->print_id earlier.
> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

With your own nit applied,

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

