Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990F93595C;
	Mon,  6 Oct 2025 19:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759779691; cv=none; b=jzQgkriNUWaAQmDr2HK+dqZWe3RZN93P/I6seJ+a10X7sV1jBcew2aYwAKZDECgRN7XLwh8x/PDu/HIiCJpARVUeScLeApGeHEhxrZ4MXty11YZD1312kHovLsn6E1WG5af0DGMuGEfjO0fmUL18jVaJD/d1cbAPC7Fd3pM3jow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759779691; c=relaxed/simple;
	bh=jxP0zMtLefG3gelLpEwi/Nfyuz8ryR09EqQ3t1WBA+w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rYhBYZKUjnT5WiZwNf22UZhIeAcQn/lrTGdXafANgbaSlGuLeibxPy7NQzuhQbYtxT4F8DtHzRVla6CQhUdTfbYLaNaP8MAqvlmJxyt8En1rYovijUChFbYXavlci9IlMoVNIIrSU4mIydyXAOrpiAgplmlGubA5RZ4mNPkTJSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EBbMtXrc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EBbMtXrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9C2C4CEF5;
	Mon,  6 Oct 2025 19:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759779691;
	bh=jxP0zMtLefG3gelLpEwi/Nfyuz8ryR09EqQ3t1WBA+w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EBbMtXrcRPtkn+cXtsxzXPsiAnxRORCr2LiSol6hGiagi4OlD2EnkiyranHO9bSpv
	 AZEv624lzFrw28XtMPu3gUaR+UIuuPiuYqudLRmE+tKPI2Nk7z1wZ/Nfo6nY4ADXH/
	 INFg9ih6Jfs0dPPt2n7NFude6dR1lhYnG7KoURLi/8Gp/NNMy6A4jizA6tYOIa0moG
	 /gnKML89dXOJZ1FLEhorRVVxlx1kUgH5jlFjMPrEOY9YM3m3fLZPfPZnEDsBlU6nVa
	 QeFks1SeRxZ9uN1ajzMQmMCnV3iyFv/vCAVXivzsZZ+UBpjQdAFJ7YydsVMCCr+edn
	 4Wh2yLZ4DPzwQ==
Message-ID: <a6709051-bd95-4f7f-8a85-d4d670f7a316@kernel.org>
Date: Mon, 6 Oct 2025 13:41:30 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: fix shift out-of-bounds in sg_build_indirect The
 num variable is set to 0. The variable num gets its value from
 scatter_elem_sz. However the minimum value of scatter_elem_sz is PAGE_SHIFT.
 So setting num to PAGE_SIZE when num < PAGE_SIZE.
To: Kshitij Paranjape <kshitijvparanjape@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Doug Gilbert <dgilbert@interlog.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kernel-mentees@lists.linux.dev, stable@vger.kernel.org,
 syzbot+270f1c719ee7baab9941@syzkaller.appspotmail.com
References: <20251006174658.217497-1-kshitijvparanjape@gmail.com>
Content-Language: en-US
From: Khalid Aziz <khalid@kernel.org>
In-Reply-To: <20251006174658.217497-1-kshitijvparanjape@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/6/25 11:46 AM, Kshitij Paranjape wrote:
> Cc: <stable@vger.kernel.org>
> Reported-by: syzbot+270f1c719ee7baab9941@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=270f1c719ee7baab9941
> Signed-off-by: Kshitij Paranjape <kshitijvparanjape@gmail.com>
> ---
>   drivers/scsi/sg.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index effb7e768165..9ae41bb256d7 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1888,6 +1888,7 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
>   		if (num < PAGE_SIZE) {
>   			scatter_elem_sz = PAGE_SIZE;
>   			scatter_elem_sz_prev = PAGE_SIZE;
> +			num = scatter_elem_sz;
>   		} else
>   			scatter_elem_sz_prev = num;
>   	}

Have you seen any issues caused by not setting num to PAGE_SIZE when num 
< PAGE_SIZE?

 From what I can see, num is used to calculate the page order for 
allocation which will be 0 whether num=PAGE_SIZE or < PAGE_SIZE. After 
that num gets assigned a new value any way before its next use.

--
Khalid
