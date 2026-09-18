Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43FA2931CE
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 09:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789723700; cv=none; b=XG4K1kCwcNCh1u2GNZzil/dF+2fqfwfQxl0NNYt3sFVUJFrAeCC3T0snm00NWJ5ud7lc5dMy2mOLt+B/Q3mKUv6X6aVG4zCa9SpxYxmO5qb3F2HCqdsvEFYoFhsBQGZx0ZdapA8iOiB/oYBc7pZBRbfcQuHHaP5dF3uHkT9izvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789723700; c=relaxed/simple;
	bh=DUjHCLdPVmgT0CBJYHlUgYzvi007nGS1EuQLCE7ZbgQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HWirkHx048X6dMpzMQzRw0RgQwDRkjhO09uRa6ZXHt/IQOzK78qlHim3Em8rMq3AW4D71GD+e8CCkvE6Vs/z9Aa9IwHE/78+S5f/U4Picze6SyvAJze/8KZvxGdFJonMr3DW8BK5Ayevr1xiIx06Xh71vqPwgKog1+S4N/Y93d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UD2ALxlY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UD2ALxlY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44ADF1F000FF;
	Fri, 18 Sep 2026 09:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789723698;
	bh=ZoGI7gGJtosCKtKVN87HaAz+gmt+rRmZSxNq1c4BElY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UD2ALxlY1HCkd3TQpTBKHmAPr+h54bk2tM/0RuwzX/QiZk/WQc8os6iU4hPMbiDSA
	 fs2efD6v0pAmEAscu9Voo1XIhq7q74O5t1FrzUVU/rz+4NglmlsKwifwcPdqKCnCqH
	 IVwpYqC0Zn2XyKcNf6oc40Vwc4fHJEexlgD336jmoWnC8XNXmcSRp1VCkEHGcPVzz+
	 PTW15vmFl8fgBJtmCzmXCfEa+wxF6O2sKRqrBwxhqjAX8N3rMdwBLj0rOgdd1bSvgX
	 RA7Nv8bEXT3nX0Xo0dgrJs46Bp+X7Kd+RM4cTBEfnRJe92TuadmnTzPiypzo4gG9be
	 RHZQAA7EzdgsQ==
Message-ID: <fe803d1a-6ea8-433c-b213-82985ee448d3@kernel.org>
Date: Fri, 18 Sep 2026 16:28:14 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/10] scsi: scsi_debug: Take the zone metadata lock
 before the data lock
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>
References: <20260918062910.1709791-12-cassel@kernel.org>
 <20260918062910.1709791-15-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260918062910.1709791-15-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/18 13:29, Niklas Cassel wrote:
> resp_comp_write() takes the data lock and then the zone metadata lock.
> Every other command that takes both takes them the other way round:
> resp_write_dt0(), resp_write_scat(), resp_write_same() and
> resp_write_tape() take the metadata lock and then call
> do_device_access(), which takes the data lock.
> 
> Two commands that take the same two locks in opposite orders can
> deadlock against each other, so a COMPARE AND WRITE and any other write
> to the same store can hang one another.
> 
> Take the locks in the same order as everywhere else, and release them in
> the reverse of that order.
> 
> Correct the comment above map_region() while here. The provisioning map
> is covered by the metadata lock rather than by the data lock, which is
> why resp_unmap() takes only the metadata lock while unmap_region()
> clears map bits.
> 
> Assisted-by: LLM
> Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
