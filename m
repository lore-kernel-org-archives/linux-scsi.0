Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FA2284B54;
	Wed, 11 Feb 2026 01:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770773325; cv=none; b=uegxc8TMsU9ACctMUpL4QyHt5ZyD6ecEXP4azxVOWnQwsiOUv0GB4+u6q2u2uoyfZIv5NlY5j6o1TMhiyUCQepl4WzrIu41YRxRTvPzfD0DR9kchd4LR91cPm3XECx8LOCHmP8yp1jIOkAsYMNh9opG0OArz5ImyW7nY2EWp6Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770773325; c=relaxed/simple;
	bh=RztOmg704q0Ai+lh2FJeXzzIlZVkunXUQZGOleobHVc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UpsHO60hKRmmfTJ7S2oGP0/gNaRN6JSakKj0SZiJMoYBv/b3gD9bEhzH4Dl0MBfVG6JeCv6qZQEzRXOq0rsUUVNG3DWmKOTLcK5dG6sS6PvHUZhUZzLH/EZnOfUO8Do5CdRcsf1GYXdbyftHWb440oTx484HGnB2b7WA6XFtqCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EmKzKFUy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EmKzKFUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A4DC116C6;
	Wed, 11 Feb 2026 01:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770773324;
	bh=RztOmg704q0Ai+lh2FJeXzzIlZVkunXUQZGOleobHVc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EmKzKFUyI28iUPCpK9xAlOA/Gc8ifdRR3qFdghTbx4GQ+BMmV7Tm2N6n+fZEr/F7/
	 yt0dKA1PKnWZbg0PY/ZGKlBOuMLt3eUCK5epDu+XNJofouEIFPcnpDpj02lhOdHfkD
	 sWeRNlDJ3W89hTIqq1lbqRxKqDVXUyrIkPIuYekJhQ+KvXSxp9qWL09UuGsN4r1OQx
	 JVRYum4XXy7vdWjfgRjLG1VLl8bSxhSqgsSwqbTPrYaIDAxSZSkwlAPKXhaFwvUZFz
	 JkGmrBpj3HTyQGaqv/DZJFXEVJtGnsfNf/NVX5qfYCK1fB8+dDFJzS4GydQBPFrA/t
	 u0v63t0GdNx3A==
Message-ID: <05c3fac5-b604-496b-b0eb-5b2dbd68e66c@kernel.org>
Date: Wed, 11 Feb 2026 10:28:41 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: pm8001: Fix use-after-free in
 pm8001_queue_command()
To: Salomon Dushimirimana <salomondush@google.com>,
 Jack Wang <jinpu.wang@cloud.ionos.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 John Garry <john.g.garry@oracle.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260210010754.1824914-1-salomondush@google.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260210010754.1824914-1-salomondush@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/10/26 10:07, Salomon Dushimirimana wrote:
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
> ---
>  drivers/scsi/pm8001/pm8001_sas.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 6a8d35aea93a..0285ce6400dc 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -525,8 +525,8 @@ int pm8001_queue_command(struct sas_task *task, gfp_t gfp_flags)
>  		} else {
>  			task->task_done(task);
>  		}
> -		rc = -ENODEV;
> -		goto err_out;
> +		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> +		return 0;

Can you add a pm8001_dbg() message call to signal this issue ? Otherwise, with
this change, we lose the existing message.

>  	}
>  
>  	ccb = pm8001_ccb_alloc(pm8001_ha, pm8001_dev, task);


-- 
Damien Le Moal
Western Digital Research
