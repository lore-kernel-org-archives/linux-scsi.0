Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57C04A1E;
	Mon,  6 Oct 2025 19:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759778630; cv=none; b=Nu47EWogKqryLUfENxw/MFHuFq83wajp9nDkb5t19cVFcKiXfT9+VSTGbYYJsxBxDoJBiIWTQPJjZkzVUETs0Mp6CPF0R1OvjdlaJOOr+yOQYK9pIN+lis9pYGJ54c8nLoHOiFyM7L35OyR+LzWD0DlhPrcPPci2NoK7lv7ZWiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759778630; c=relaxed/simple;
	bh=3IRDYsJ/lyS6bBFNqgWZ/wSYHq2uNlr+cfD7SYriQkM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hZNo8K+HPZ+Ujp7EPK/L392jqAviNRlEK7DZy7AKUfmHNHFqIkWR3u4k6KchlB3plRGVWFB/cwhTTcW940ilM+eJ9YyDgvF2ruGeihN8nKeWIl7hTf2hEGIxlomPq/GJn79dbYr7CtNVGMvcCQTlGon/XFZDsfLMlNz7ZV/iaXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iphYsLly; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iphYsLly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8D7C4CEF5;
	Mon,  6 Oct 2025 19:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759778629;
	bh=3IRDYsJ/lyS6bBFNqgWZ/wSYHq2uNlr+cfD7SYriQkM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iphYsLly7QOqRuXXuGM8uHEbpe3bk7vNgjXo6lIwvHbnrM0fSWm3wDMKK1mDPvnJ3
	 +vW/fDE+MysEziEbbUz4Clg/7DrZ+cYebLr/o3IphZHOuZi4wdDh0I1Lyw6SnQZZdd
	 fhCZiPEs+rz9Mb8mgFYIviTNpDw7ET+Au4b6da1Kv6lObNQxnWoEV4UwQzJ3s3IbC/
	 9GkjB3ttQSA+dzscD6SsORAfH6R1wS32apbx9EiLc9QaAh8Ur8o0AMgcfoLykC7/c3
	 bA6F39zCqG4btRA7Hj6enc1W5QdIoTggoXMq0cvV3HYm/fi2pf/d4/GPP95NpJ1Te0
	 AWptrSRpg4SsA==
Message-ID: <03cb97b4-c58a-42fc-aaea-db63c1b2ce4b@kernel.org>
Date: Mon, 6 Oct 2025 13:23:48 -0600
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

Please add a one line summary above your commit log to avoid the issue 
Vivek pointed out. One line summary will become the subject line for 
your patch email.

--
Khalid
