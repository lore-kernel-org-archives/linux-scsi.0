Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F952914;
	Fri, 28 Jun 2024 03:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719546390; cv=none; b=YsI7RHGB5VVpPdMPqLNWg5cJ1cUdholYuWEtNz3YRA/bbZVPwlRTS611PAD952ntd626Uo0aRd9/1mNah84KBwX0YG4hLN1cAnBZJCO9Y8NcV8mYKkeDhjwNsJk5SMo+83j2YgJUH+Z7rYYCpHMiQ0ys6MlrPpfMBLfuwJXJhkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719546390; c=relaxed/simple;
	bh=eV8HMRdVSoL2xrsydq+Vlau9g9kha6184GSXwRBvOuI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OyGd6uBXGxlpLRM41y2lzptcad0Q1t9EFWnjNYOkQp3OxiYNr4N3rtMParCSkhRzJqQongWPMIJq/vzLxuUqyia0zBEsMMLpr9Qu/gKOB0+nvK5I74oZe5XH30UMGYasLUdKFXL5qh24nMx0f2xqpBh1Jda9STMc9KOOh2a0QP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d+rJ5oNL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d+rJ5oNL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A74FC116B1;
	Fri, 28 Jun 2024 03:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719546389;
	bh=eV8HMRdVSoL2xrsydq+Vlau9g9kha6184GSXwRBvOuI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=d+rJ5oNLY+revW55fa8ZqsPEaiitjQ3qiUnnZPKIk9XMyxdyqwBNtNAzWJPejcM9u
	 x+Cq/tbWRjZ+QMaQMCdLjgxeX/TLyha2ts9b25gjYLwZZ/1JrgEezns8nKQQ87t7EC
	 CQfJ68yCRKG2DWJeD05iTHgpMf48JgZdWPH6L3irCjq2w4EJoyQXu5hyXanA00ygIZ
	 /m/o+C1o4tP9FWgDfAvyzVt862JSbZsKXMfT3I4c3/28m5LO9YqnzMbkkAI2G/LBDL
	 gDRo4lq47NmEhDulcCairKVNfSltfdO2nnXguFBFK/NAOjHTzvQraT9IUjfSxjnLqO
	 GJ/Ip7OxcMTxg==
Message-ID: <2dcbc221-ff0f-4bfe-94f3-9266c980abb2@kernel.org>
Date: Fri, 28 Jun 2024 12:46:25 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/13] ata,scsi: Remove useless ata_sas_port_alloc()
 wrapper
To: Niklas Cassel <cassel@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-27-cassel@kernel.org>
 <83125236-7d07-4b62-b86a-5a70f3ca578e@kernel.org>
 <Zn01XqPMga6aG1nL@ryzen.lan>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <Zn01XqPMga6aG1nL@ryzen.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/27/24 6:48 PM, Niklas Cassel wrote:
> You will see that far from all libata functions have ata_sas_*() wrapper,
> so all the ata_* functions that do not not have ata_sas_*() wrapper are
> already exported using EXPORT_SYMBOL_GPL(), i.e.:

OK. I thought things where a little more consistent than that.
Let's kill the wrappers then. Keep your patch as it is !


-- 
Damien Le Moal
Western Digital Research

