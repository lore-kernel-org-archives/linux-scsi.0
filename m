Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB0812E40;
	Wed, 26 Jun 2024 19:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719430261; cv=none; b=fwpIZSOGPww0cPPdJh0K/ogOWSYOxhWX+JqHEAsVLM11RUC3nOUh5ShaqIRDs4IYuhOV3fFovWxZrdcTNPQKEAeAqletCgA49ytQLIaC++g0Tw8FAICDj192xbaQMxEnJQZ4XPuNqsjw5tEdM72FJBSVYOna7GERRHXktM7d/Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719430261; c=relaxed/simple;
	bh=gfuDKbZMtEaInwEhR5RxgMY1M2sRvFao35EHuUk7Lpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gUFKDqswnEKWVZuCsCqNO56EQ9U8KU86fop91khwngq6P0wPlXrbzRQ5QoQw9kDNaNHtXqqNBIzmpd1zeSokNIDnqem4Kn9y4lXYlDyV7RqAIAQf1YAzpNHETZ/NVbXmE8jpNXExfUGEG39ozAagT+t23KwKBF4tNKUyIyUgdfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AaHBCa1m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AaHBCa1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16DDC116B1;
	Wed, 26 Jun 2024 19:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719430260;
	bh=gfuDKbZMtEaInwEhR5RxgMY1M2sRvFao35EHuUk7Lpk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AaHBCa1mTG8jbfTFjPjgL3Ahiezt4eW0bTpEV+Y1TBpLe30GwxRRfO9PgcL5vAHq5
	 9b2UnbBDEPXt8evhJjIJoq+9RONHUxfWd2Hoi4qJkXor8Al5RfoV92mANWpVlEa5re
	 hh+GbWXIGjEcuAPe1/SN4Bl7JbJZ+8oGKMOJqdUzN/MKbmOrMYW1OU8F5HrdTROtSQ
	 dzprGsJ9W0lSUNMibzEDhvMzlvuRjLzCfEHlZ3EMacJ8VwKrYRnsrpPK8auOjYHJ4P
	 6v9VY+R0ECDJr8psix8PEhYUXZCL5XQFFFmilY+86VCWdEp8YB71Wb8uxrffClkvgt
	 s7Y69Z2lnKhDw==
Date: Wed, 26 Jun 2024 21:30:52 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	linux-ide@vger.kernel.org
Subject: Re: [PATCH v2 07/13] ata: libata-core: Remove support for decreasing
 the number of ports
Message-ID: <ZnxsbCA6BgQti3tb@ryzen.lan>
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-22-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240626180031.4050226-22-cassel@kernel.org>

On Wed, Jun 26, 2024 at 08:00:37PM +0200, Niklas Cassel wrote:
> @@ -5908,12 +5903,13 @@ int ata_host_register(struct ata_host *host, const struct scsi_host_template *sh
>  		return -EINVAL;
>  	}
>  
> -	/* Blow away unused ports.  This happens when LLD can't
> -	 * determine the exact number of ports to allocate at
> -	 * allocation time.
> +	/*
> +	 * For a driver using ata_host_register(), the ports are allocated by
> +	 * ata_host_alloc(), which also allocates the host->ports array.
> +	 * The number of array elements must match host->n_ports.
>  	 */
>  	for (i = host->n_ports; host->ports[i]; i++)
> -		kfree(host->ports[i]);
> +		WARN_ON(host->ports[i]);

Nit:
Even though we replace the kfree() with a WARN_ON() here, the strictly
correct thing would have been for the earlier patch in this series:
"ata,scsi: libata-core: Add ata_port_free()" to have replaced the kfree()
with ata_port_free(), and then for this patch to replace the ata_port_free()
with a WARN_ON().


Kind regards,
Niklas
