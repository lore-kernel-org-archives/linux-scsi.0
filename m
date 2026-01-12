Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D386359FB6
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 14:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768227270; cv=none; b=uXjlNscJuQiddMoluY2URm899QUTfk6BbyjdT97MY5GZ1TQ1RijykgPBtISHtGsT0tNe0WQv9HC0gkgpt0MDTIJoMCAuNMkIDO3+5yQhfDpnoinIpCo4RFBou86GSHOMzrNZWrbfYGnAuIjPqnCD1OoU6bOuQzGD+mWYAD0JnOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768227270; c=relaxed/simple;
	bh=kp53GfsNv3qFKGeJyWhO5MWdquPq5tCGGZQu2ohaAEc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q521p7Z1bbr0sxm0GSSUunnwObKs/jrWCEYNLM4vxa9An2rZblyt9UYE+H6XZ6hKyUR1qLkmzZ8AhTsX3eUcZuGwWVOFHD6wCkq5ONOmOwqZqVwoJWciY39D6Aw0nYxXlbM0XFF7F8B0UZUDyVju1jKbvdi84HSgPq0O7j1QXBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jXMiAMBv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jXMiAMBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390B0C16AAE;
	Mon, 12 Jan 2026 14:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768227270;
	bh=kp53GfsNv3qFKGeJyWhO5MWdquPq5tCGGZQu2ohaAEc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jXMiAMBvr/T/9xqsW1SpWlEHhjiqcN0JnmH2luCEsi2Px03/LxbOz8UiP3AyApjIc
	 0kWnlp06Hl4o8x9ZRqDYChnq/Tg96AVQEsJgT4f5PVSCAmHDP8XK0ZinOTOyCIXPzk
	 9so/IZuJR3KompfGoWk2oJoWdW8j5SQuyjcB/uf1LkfBjINgR8X3EwrSNHzVy8zldt
	 IRF9hogTwx2e1I2wXaiSU6XMaZ1Yr7D576EE6RszwuL3+AQX1MU7eEZLZZnU/dWJgi
	 ao+UQmeumMt8AZZE349ammxHbooz/v0037+WeKXELTP/hYv8bXbBDT9AaFPhvT8pBv
	 vPQoY2ezxqhpg==
Message-ID: <0179528f-72c1-4d95-a49f-69a2adae9b26@kernel.org>
Date: Mon, 12 Jan 2026 15:14:26 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/7] mpi3mr: Add module parameter to control threaded
 IRQ polling
To: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
 chandrakanth.patil@broadcom.com, prayas.patel@broadcom.com,
 salomondush@google.com
References: <20260112081037.74376-1-ranjan.kumar@broadcom.com>
 <20260112081037.74376-2-ranjan.kumar@broadcom.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260112081037.74376-2-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/12/26 09:10, Ranjan Kumar wrote:
> Add a module parameter to enable or disable threaded IRQ polling
> in the driver. The default behavior remains unchanged
> with polling enabled.
> 
> When disabled, completion processing is kept entirely in the
> hard IRQ context, avoiding the threaded polling path.

What does that bring ? Better throughput ? Lower latency ? please tell us more
about the benefits of this change.

> 
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
> ---
>  drivers/scsi/mpi3mr/mpi3mr_fw.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> index 8fe6e0bf342e..869e525f3e73 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -21,6 +21,10 @@ static int mpi3mr_check_op_admin_proc(struct mpi3mr_ioc *mrioc);
>  static int poll_queues;
>  module_param(poll_queues, int, 0444);
>  MODULE_PARM_DESC(poll_queues, "Number of queues for io_uring poll mode. (Range 1 - 126)");
> +static bool threaded_isr_poll = true;
> +module_param(threaded_isr_poll, bool, 0444);
> +MODULE_PARM_DESC(threaded_isr_poll,
> +			"Enablement of IRQ polling thread (default=true)");
>  
>  #if defined(writeq) && defined(CONFIG_64BIT)
>  static inline void mpi3mr_writeq(__u64 b, void __iomem *addr,
> @@ -595,7 +599,8 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
>  		 * Exit completion loop to avoid CPU lockup
>  		 * Ensure remaining completion happens from threaded ISR.
>  		 */
> -		if (num_op_reply > mrioc->max_host_ios) {
> +		if ((num_op_reply > mrioc->max_host_ios) &&
> +			(threaded_isr_poll == true)) {
>  			op_reply_q->enable_irq_poll = true;
>  			break;
>  		}
> @@ -692,7 +697,7 @@ static irqreturn_t mpi3mr_isr(int irq, void *privdata)
>  	 * If more IOs are expected, schedule IRQ polling thread.
>  	 * Otherwise exit from ISR.
>  	 */
> -	if (!intr_info->op_reply_q)
> +	if ((threaded_isr_poll == false) || !intr_info->op_reply_q)
>  		return ret;
>  
>  	if (!intr_info->op_reply_q->enable_irq_poll ||


-- 
Damien Le Moal
Western Digital Research
