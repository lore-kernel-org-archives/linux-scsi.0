Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5E054774
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 16:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764693171; cv=none; b=FdDFDE7VBy15jGVyosZ5IK7CDwkuVzdjfqe+pUzhkC7Cmvp1bfMuJweS6CZpAXypklnAOB6mYBmq6t5gQW4YN53z9Wk2f1dSIuVWJzDuQe7Hkr4THZfzt8YUDmqhe1X6u5lBMZlfv6IskmCHgTC0mobR0rw+ilWPmfNfs9eeiCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764693171; c=relaxed/simple;
	bh=CgnCv99rlYoTBKkc5OEI0pqXEVZN/epw59T/1Slob5c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FIuX4XEEkX2ydSYpspRhagU6tgNb7OKtKkQlr/1DYAEG33wnoja7SqSD9rODo+Laq2nqHjuYaR5Uo2+vUjDjkKmpRDjZcE3ihxq0k1DDbiXeC4tCtxWNZYkX5wYxNLjyUngtS8RKDZkCmPTvXbpvxcvX6UG1NbVklOk20lyS+wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D2JI24jo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D2JI24jo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95328C4CEF1;
	Tue,  2 Dec 2025 16:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764693171;
	bh=CgnCv99rlYoTBKkc5OEI0pqXEVZN/epw59T/1Slob5c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D2JI24joDNVrSU4TxzLTfOEGttVGrylZbTk/C08BWnXY2vsCVO/fObC4KkIt/QZvI
	 2krmcvaEwbA4Oy1dfq2wL6Npkx9dk7jfHnK1RpMEA8cn5KrpK4aZnXaUSLFi8ttkIC
	 HIwEo+S3p96tFiD2o4WNstRltvxqYSwxpXAlx34O03JaTLwJiGcy4fpLsSdWN3ylDQ
	 mKlwiAkhgxRsOXNcDn4zsZepXjn4HlfjFxcOhBaJSebHpyj482DgstGUqKrMFkmMIO
	 T1iWWrTz5aT6xY09NrKXbebCvFX590gnx6PlF9nvOtoMwnYKASWT1EBMe3AOOx1fHU
	 xasgRZofFkwQw==
Date: Tue, 2 Dec 2025 22:02:43 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@sandisk.com>, 
	Bean Huo <beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, 
	Roger Shimizu <rosh@debian.org>, Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Subject: Re: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved
 request
Message-ID: <jay3lhd7onhvt7ws2nuqzkuzxygnzirdtbyok4xcvbw45yamqz@54pndmmutftu>
References: <20251031204029.2883185-1-bvanassche@acm.org>
 <20251031204029.2883185-22-bvanassche@acm.org>
 <ehorjaflathzab5oekx2nae2zss5vi2r36yqkqsfjb2fgsifz2@yk3us5g3igow>
 <5f75d98a-2c0a-4fdf-a2a9-89bfe09fe751@acm.org>
 <6fw4oikdxwkzbamtvu55fn2gqxr3ngfzymvxr6nxcrjpnpdb2s@v325mijraxmg>
 <75cf6698-9ce9-4e6d-8b3c-64a7f9ef8cfc@acm.org>
 <in3muo5gco75eenvfjif3bcauyj2ilx3d6qgriifwnyj657fyq@eftlas3z3jiu>
 <d7579c22-40d0-4228-b539-4dfe4e25b771@acm.org>
 <nso6f36ozpad36yd3dlrqoujsxcvz4znvr6snqwgxihb3uxyya@gs6vuu76n6sx>
 <5c142a9d-7b41-422a-bbff-638fda1939dc@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5c142a9d-7b41-422a-bbff-638fda1939dc@acm.org>

On Tue, Dec 02, 2025 at 06:03:40AM -1000, Bart Van Assche wrote:
> On 12/1/25 10:51 PM, Manivannan Sadhasivam wrote:
> > Please share a fix on top of scsi-next or next/master.
> Before a fix can be developed, the root cause needs to be identified.
> We just learned that commit 1d0af94ffb5d ("scsi: ufs: core: Make the
> reserved slot a reserved request") is not the root cause of the boot
> hang.
> 
> Can you please help with the following:
> * Verify whether or not Martin's for-next branch boots fine on the
>   Qcom RB3Gen2 board (I expect this not to be the case). Martin's
>   Linux kernel git repository is available at
>   git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git.

If linux-next is broken and if I can revert patches that came from scsi-next and
found it to fix the issue, then it implies that scsi-next would be broken too.

> * If Martin's for-next branch boots fine, bisect linux-next.
> * If the boot hang is reproducible with Martin's for-next branch,
>   bisect that branch. After every bisection step, apply the patch
>   below to work around bisectability issues in this patch series.

This is insane. How can you make a 28 patch series not bisectable? If anyone is
doing a bisect in the future for any issue, are you expecting them to apply the
below fix to fix the failures?

This rule is clearly mentioned in the process documentation:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst#n190

- Mani

>   If any part of that patch fails to apply, ignore the failures.
>   We already know that the boot hang does not occur with commit
>   1d0af94ffb5d ("scsi: ufs: core: Make the reserved slot a reserved
>   request"). There are only 35 UFS patches on Martin's for-next branch
>   past that commit:
>   $ git log 1d0af94ffb5d..mkp-scsi/for-next */ufs|grep -c ^commit
>   35
> 
> Thanks,
> 
> Bart.
> 
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 1b3fbd328277..ef7d6969ef06 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -231,12 +231,6 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost,
> struct device *dev,
>  		goto fail;
>  	}
> 
> -	if (shost->nr_reserved_cmds && !sht->queue_reserved_command) {
> -		shost_printk(KERN_ERR, shost,
> -			     "nr_reserved_cmds set but no method to queue\n");
> -		goto fail;
> -	}
> -
>  	/* Use min_t(int, ...) in case shost->can_queue exceeds SHRT_MAX */
>  	shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
>  				   shost->can_queue);
> diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
> index 7d6d19361af9..4259f499382f 100644
> --- a/drivers/ufs/core/ufshcd-priv.h
> +++ b/drivers/ufs/core/ufshcd-priv.h
> @@ -374,7 +374,12 @@ static inline bool ufs_is_valid_unit_desc_lun(struct
> ufs_dev_info *dev_info, u8
>   */
>  static inline struct scsi_cmnd *ufshcd_tag_to_cmd(struct ufs_hba *hba, u32
> tag)
>  {
> -	struct blk_mq_tags *tags = hba->host->tag_set.shared_tags;
> +	/*
> +	 * Host-wide tags are enabled in MCQ mode only. See also the
> +	 * host->host_tagset assignment in ufs-mcq.c.
> +	 */
> +	struct blk_mq_tags *tags = hba->host->tag_set.shared_tags ?:
> +					   hba->host->tag_set.tags[0];
>  	struct request *rq = blk_mq_tag_to_rq(tags, tag);
> 
>  	if (WARN_ON_ONCE(!rq))
> 

-- 
மணிவண்ணன் சதாசிவம்
