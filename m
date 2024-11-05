Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0115C1D04A9
	for <linux-scsi@vger.kernel.org>; Tue,  5 Nov 2024 09:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730797822; cv=none; b=YdcNdLeubqfuryaLciMDQgUKYaJeH+LfaDicJJz0Zz8ZgYmU5s22rXb14rJhfqkMvhQvlX8wMoX+iVvy76WOhrGMnJwReZxPxxP6XhsqHKpNxW2c+FJPRd2qSZNYE/93vkbnsG90pMX4+8ZO6rSMtVrL814CESjtoHGtjV8fgBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730797822; c=relaxed/simple;
	bh=rRX7gRfmRH50GikGgGMdM8fD40I8pVDpalHORU68WlI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nZAfWQP/KPT5AhWbzHjiIZuXXSsR+fkQcTLfVfRJY1/IwkwPc+oqfrFLlNvm1Oo+3bjXEjPj+lvQKkw1wwCoMMAVWhEUh+Hen6L/Zd6nBudtTclmcJUDFGQTMmbz9JqNzPK7edV/OhClp59ZRdB/eEbxEA81rjewV6/3aVBWq6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DrAP4Kyc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DrAP4Kyc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DEAEC4CECF;
	Tue,  5 Nov 2024 09:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730797821;
	bh=rRX7gRfmRH50GikGgGMdM8fD40I8pVDpalHORU68WlI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DrAP4Kyc67XXn3kzrJerD4RPG/kswNvRGzRsoXUssGIDaC+PrhLiUAnd8//cyOpF1
	 JMgmng7UalwQyd3u8Kd+5zixD+OXzdLEBzVxXVe0Sh3+zxDDJrTPreZ3cIDl31fB71
	 dS+4vKK4DApEWKQY97NCUhSWzlrDniSEmrxgr3bwObXn6d/rmXzBF7KqwOuzzrHuJA
	 3ZTdTI3EMi8wqd7gwiebHeQp4rWc67+bmEX3nR1/QIsgjzP6m0HwN2z0f4aBs0hESl
	 IbZN6ZeCtGRwx4IySwNmqflEi7hWiBnGIOuyfQhW5i1q4xUoa71f3rLkyv9JMK7WWQ
	 FZ+nu7robnp7w==
Date: Tue, 5 Nov 2024 10:10:17 +0100
From: Niklas Cassel <cassel@kernel.org>
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	James Bottomley <james.bottomley@hansenpartnership.com>,
	linux-scsi@vger.kernel.org, Wenchao Hao <haowenchao2@huawei.com>,
	Xingui Yang <yangxingui@huawei.com>
Subject: Re: [PATCHv8 00/10] scsi: EH rework, main part
Message-ID: <Zyng-RIx0XkeFLr-@ryzen>
References: <20231023092837.33786-1-hare@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023092837.33786-1-hare@suse.de>

Hello Hannes,

On Mon, Oct 23, 2023 at 11:28:27AM +0200, Hannes Reinecke wrote:
> Hi all,
> 
> (taking up an old thread:)
> here's now the main part of my EH rework.
> It modifies the reset callbacks for SCSI EH such that
> each callback (eh_host_reset_handler, eh_bus_reset_handler,
> eh_target_reset_handler, eh_device_reset_handler) only
> references the actual entity it needs to work on
> (ie 'Scsi_Host', (scsi bus), 'scsi_target', 'scsi_device'),
> and the 'struct scsi_cmnd' is dropped from the argument list.
> This simplifies the handler themselves as they don't need to
> exclude some 'magic' command, and we don't need to allocate
> a mock 'struct scsi_cmnd' when issuing a reset via SCSI ioctl.
> 
> The entire patchset can be found at:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git
> branch eh-rework.v8
> 
> As usual, comments and reviews are welcome.

This seems to be the latest version of your EH rework.

Do you have any plans to send a v9?


Kind regards,
Niklas
