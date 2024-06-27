Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007D117FE;
	Thu, 27 Jun 2024 01:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719452263; cv=none; b=jg81b7YTe/b6HZWyo+w0y4yFh1t4hBUU0/liNrV9wSFQS5M+Iz21XBrJplNtOlAHKEtx/VWYPHj0ZW6IcnMPXGwLqzdWZdf/zOzqXZFVIJQ7mGVkeMNG9R0sd0eKicAB82SUixmxuJpHc4zkgGPRMggvmmgDdrld0BRvi9QFtdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719452263; c=relaxed/simple;
	bh=EsixI+5ue5GbWwMIQMd/iWcIJYp2cc0lUE0HeBhD92U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tAn9VKuz7Ckfudk/0WfmWq6xSPXUVYq/MdrSAjEh7KBS2gSqlXrM3gpof5I7SpWxaTCZp/PK+M9P+sXUIUWRuAyYpXZFJVifN58Z6tHZs4HqG0mKqNB/EitL42yBAuHFVqtPecX7W2R7MqVyO99fq9SjXmh7zF6WLhiHxk9R9P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HIn+NCBQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HIn+NCBQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A521C116B1;
	Thu, 27 Jun 2024 01:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719452262;
	bh=EsixI+5ue5GbWwMIQMd/iWcIJYp2cc0lUE0HeBhD92U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HIn+NCBQVz5L8eSdPWwMbk8oQ3zpLfgEWNGPrxM5hySHVnGbTy0N3HfyFFCeIkO0V
	 izXhcGbObPYzGJx+NOYzhDbl20MpApLVxpqb5j/uWYwXQ2R+N/mpltAjDvc9mt5Ohv
	 xUo3ynLZMO1ORnnVmF8qhHXlAIAjAq4LHNqvpmL40BckL35rXGietncj8Fk0y9feJp
	 c8V3ZKefYbEhXDxphimCTmXgnRcVnRDa87umlE+QxU3Vzs4ytXjEZRcHKpCMExiEdi
	 TzWvIdLyXwEGTnYorjane7y0Q4HYKyxcsQXQyNoLvRSNK7OzZ5z74uVE2VRplTbp3f
	 PaR4QCLfk4mWg==
Message-ID: <3672b5e6-4842-4ffc-b55b-352359aa39a9@kernel.org>
Date: Thu, 27 Jun 2024 10:37:40 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/13] ata: libata-core: Reuse available ata_port
 print_ids
To: Niklas Cassel <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-ide@vger.kernel.org
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-26-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240626180031.4050226-26-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/27/24 03:00, Niklas Cassel wrote:
> Currently, the ata_port print_ids are increased indefinitely, even when
> there are lower ids available.
> 
> E.g. on first boot you will have ata1-ata6 assigned.
> After a rmmod + modprobe, you will instead have ata7-ata12 assigned.
> 
> Move to use the ida_alloc() API, such that print_ids will get reused.
> This means that even after a rmmod + modprobe, the ports will be assigned
> print_ids ata1-ata6.
> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Looks good. But maybe it would make sense to squash this together with patch 10 ?

Either way,

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

