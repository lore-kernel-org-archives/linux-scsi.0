Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDC335965;
	Tue, 17 Feb 2026 03:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771299346; cv=none; b=DoyibwhkhaF8qOCxAm7WAESHfZkRbu1vNOxhhYxuWY2ljZJusvjn/VmkYBUwPJhdM+HIabNL5dQxrGkyRqU1igNH7PiLCES0uBn1/KEwSXMXZ3omzONSQutzpmJCJDEu/scjtIBg+nUI/WYLeoIsir/22O0LL2mD6CAWA2CkELQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771299346; c=relaxed/simple;
	bh=zFiRO50MtPY8LWtdq36HtVhyIwYM+z9iRhRKPp6t4rQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IaJyx4w+n1/Yo4P8W0Zy2+CB8KWQhh/toY/k/R6lV8Tj2JNCngaBJaDhuhZTlHBnwTJ81ZFQahbJsXN6Xvn+9CMMLGDEweFYU/epLS6BeA5+XbNOLRkmp0b8KbD+kA5XBbmWNEH+9cahMv4uKmpQ81oov86VFNOAbcM+25V/dsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uDRnXEIJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uDRnXEIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60322C4CEF7;
	Tue, 17 Feb 2026 03:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771299345;
	bh=zFiRO50MtPY8LWtdq36HtVhyIwYM+z9iRhRKPp6t4rQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uDRnXEIJCu8C+XnIYJZci9UWTVI6x7Ja0heXvYTXbDx3tfLhBlku/08zTVYVJ/PD4
	 xKiHaveK8Lo6UMag5NSz1/rhi+kBykqgQaBclLW0nQ33pWfqk4BjaVDM11hVnzUYqX
	 S2G9P0TksjryfmFEIbTm1LOm6AHkitrC2Z4uDv1dMySfq2oKQCkpQ7TzPqN8lyF26W
	 ykd7rY/CHa3ViyQ9p2Gch2wMGbOqFOHh+q7p/Z8I7KVNatU8CYgSKzp/daLk7ZJUBC
	 Tn5wZC7Ogly1XjyGzYCoka/XrHnQRLBn6/VIjYBFrvXtwuq+QAVDUFso3PseYoKuV7
	 ifvRY5NGTrv1Q==
Message-ID: <093cccbf-1477-478c-be6c-ce1a69cf4de7@kernel.org>
Date: Tue, 17 Feb 2026 12:35:42 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: pm8001: Fix use-after-free in
 pm8001_queue_command()
To: Salomon Dushimirimana <salomondush@google.com>
Cc: James.Bottomley@HansenPartnership.com, damien.lemoal@opensource.wdc.com,
 jinpu.wang@cloud.ionos.com, john.g.garry@oracle.com,
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
References: <20260213192214.437871-1-salomondush@google.com>
 <20260213192806.439432-1-salomondush@google.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260213192806.439432-1-salomondush@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/14/26 04:28, Salomon Dushimirimana wrote:
> Commit e29c47fe8946 ("scsi: pm8001: Simplify pm8001_task_exec()")
> refactors pm8001_queue_command(), however it introduces a potential
> cause of a double free scenario when it changes the function to return
> -ENODEV in case of phy down/device gone state.
> 
> In this path, pm8001_queue_command updates task status and calls
> task_done to indicate to upper layer that the task has been handled.
> However, this also frees the underlying sas task. A -ENODEV is then
> returned to the caller. When libsas sas_ata_qc_issue receives this error
> value, it assumes the task wasn't handled/queued by LLDD and proceeds to
> clean up and free the task again, resulting in a double free.
> 
> Since pm8001_queue_command handles the sas task in this case, it should
> return 0 to the caller indicating that the task has been handled.
> 
> Fixes: e29c47fe8946 ("scsi: pm8001: Simplify pm8001_task_exec()")
> Signed-off-by: Salomon Dushimirimana <salomondush@google.com>

Looks OK.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
