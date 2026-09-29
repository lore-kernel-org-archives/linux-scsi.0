Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602F62459E1
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 13:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790689191; cv=none; b=esk78imx4kpNOEL72GLG+xYM33XyOGAO2AiVVhmHdRuQs4nM11mZrE9Lp51Xuh2Cb6Ffm/BdfGYPB+Ui742o6elaYfktW4hSVLKOlF3edT+rjnzdPxTRFSicBzy73d9g34RvIyvlSML9/CMq41uUJqnxwxWTBYBkN33Z2nPjjxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790689191; c=relaxed/simple;
	bh=uK0/YIIEOWDis7wT5A64LCPmUEDnriNM4b62oxEXDD8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AVg5kJkRD50d7xO6vhH+Qp4cNGU0zpdSTVk9u2HZCeVhoSAWMiU/zrbhg3e997LD4fd/zabW724+ZQF4uam/428H6XHl4IrnLOYS2/W3RqA1cJcK7nSHyn71CLoSZ8VBxELPaGaPctrJGVmrOXgxNmXosyug9sgGtiDJR8viHqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HjLajsUC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HjLajsUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C90341F000FF;
	Tue, 29 Sep 2026 13:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790689190;
	bh=4jYF9gj0YOvKZ32j1rYY7WrPGr1Bp/M+w5K4bLrjLVM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HjLajsUCWwZgvA8DjNdEhQZyEXoAgD4mAB6DinMansOjQis3Q8Inde4oZRzEEmJP4
	 6r4SisPymWfcoUEUyqWRXuRTsWpKkdkgExOzsGCkxj/F28KtIWpGGpwvp9Zep+rAFV
	 Hy7v9a31coYrcwKricI+lcnjGkAYKPVAeXX3/CqIJj+rr680ncSVEs5BYlACB9BwYk
	 luP1dpwyLdVNfWDcbXsO74OiPFthWjLgi1G05K8F0SgznfP4cDxsUHceRg8050tWsq
	 DJqX2TxktkJw4ODA+5wOgN+jaqqTXtl8nX4UZFzYFBcCZgwbfF6Msj2RN1c08ZdZTK
	 xh7+1XjWW1o+Q==
Message-ID: <a596f6cf-799e-4aea-9e20-c083fc91d7dc@kernel.org>
Date: Tue, 29 Sep 2026 15:39:46 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 06/13] scsi: scsi_debug: Avoid 32-bit overflow in
 WRITE SCATTERED offsets
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>
References: <20260929082456.857423-15-cassel@kernel.org>
 <20260929082456.857423-21-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260929082456.857423-21-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/29 10:25, Niklas Cassel wrote:
> resp_write_scat() computes the length of an LBA range in bytes as a
> 32-bit product, num_by = num * lb_size, and adds it to sg_off, the
> 32-bit offset of the next range in the data-out buffer. The product
> wraps for a range of 4 GiB or more, which check_device_access_params()
> allows once the store is that large, and sg_off wraps once the ranges
> add up to 4 GiB, which neither their number nor their overlap prevents.
> The ranges that follow are then written from the wrong offset in the
> buffer.
> 
> Make num_by and sg_off 64-bit, and pass do_device_access() sg_off
> capped at the length of the buffer. An offset at the end of the buffer
> copies nothing, and sg_copy_buffer(), which takes it as an off_t, is
> never given one larger than the buffer that it copies.
> 
> Assisted-by: LLM
> Fixes: 481b5e5c7949 ("scsi: scsi_debug: add resp_write_scat function")
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
