Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE94A2D;
	Thu, 27 Jun 2024 01:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719451995; cv=none; b=MWZs+x79y/xtTdR2mGB8jCvMZd9eZqEhZVPgAsP64bAUbslFmjASmhFnt7KndsPKql0BPuqhi35vgpTGJaQnklpxYsHEe/HbiZAD6JMd/XBYJWEnSD+WOyyZ9QzLFGH4CTeVAWwjx7IcFehEpi5h1mNZntFjeFDD0J5NXI9FUTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719451995; c=relaxed/simple;
	bh=Ci87NY8U4vUA2WE4DBYx0YcBlQ8b797elbkMXpsRJ7A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QO5EBh8MDAFNrdd5a8OwcHDy/VmKQJjEz1lIi6bI9yP6GsZF0F0nnDjL3BYhMk/txUDNK42SlYNM254VGK0EF71GxdwY0G+fteGgc7mf1fXB4CTn5iOkPmAfPQRatqNfBxGBLVj8mJO8vqTvbqhtdPrPFeE1JV//Dl4218cYNO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PPHgMFxn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PPHgMFxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE81C116B1;
	Thu, 27 Jun 2024 01:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719451995;
	bh=Ci87NY8U4vUA2WE4DBYx0YcBlQ8b797elbkMXpsRJ7A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PPHgMFxnFpgwLamOQEEiclVGDM69+fJ26jAl2rSDt6cMKIms9ZJrmlpOZVmN5Ybb2
	 +60aSgRIsWXiaypiLMEfbj2MGpPbZi1LxqJbSEi0eRMp0MhLT657Fg843q01ypOPUb
	 TxAEbIEUfZ92smHrK3tFrIDZIXZyV+mP+djRCUGfHl1JIZM4JLlS/jKUJCgGalfwCq
	 9IrBVdPUkIluGIjs6VxO80AYhgpzZGuTPp4VF6cpN6iFcvXCo3EfQ88vPKMLV7osxL
	 UcXxJWQ1JzIQrptWCK9ewcI/C50wNMSZyz3ABpSRUlBbrGKvR6eP3N9gsXp78iqJwB
	 cfhlytHlv70EQ==
Message-ID: <57a720b0-a48d-4b0a-a5cd-aa79d73ac121@kernel.org>
Date: Thu, 27 Jun 2024 10:33:13 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/13] ata: libata-core: Remove local_port_no struct
 member
To: Niklas Cassel <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-ide@vger.kernel.org
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-24-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240626180031.4050226-24-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/27/24 03:00, Niklas Cassel wrote:
> ap->local_port_no is simply ap->port_no + 1.
> Since ap->local_port_no can be derived from ap->port_no, there is no need
> for the ap->local_port_no struct member, so remove ap->local_port_no.
> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

