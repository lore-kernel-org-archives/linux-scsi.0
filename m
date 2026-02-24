Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8158378806
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2026 14:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771943978; cv=none; b=dTsfOaGmGKolHnZniQCQHBD5GGEIxss+Y4BZWe5KL7J8/166LDxTdRNVlcc318bG8pzfOXeloVArlIqLOmQEojFY1JLaDiwyWcgyaKRP285JyqGSiZ75G8LA0XUSvuvImgGH4NmEtJfU8nqlgWor/jPtkFvlt8jjxPO9GwKY2as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771943978; c=relaxed/simple;
	bh=1orXDs7XaAUTK7dIA6tofH7Rrv1ucjLAJOFaGuE797s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YVOuJnCSRdU37HbNeWdt865XKxrhMC2+9gCcbmgjE9l+NZVuHaQUOBWUOhxb8Qb4yVbKv1NGGzrgaKnIk9uolyVZnUD+vLGA+cjhMU9FerJhtRWBbqOe8P8TWJqpEUCK4twSkgEsY91amcDhf/f86SsH2w0IvuSLZwOPdIChwwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 79F6E68D07; Tue, 24 Feb 2026 15:39:33 +0100 (CET)
Date: Tue, 24 Feb 2026 15:39:33 +0100
From: Christoph Hellwig <hch@lst.de>
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: kbusch@kernel.org, hch@lst.de, hare@suse.de, chaitanyak@nvidia.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	James.Bottomley@HansenPartnership.com, mlombard@arkamax.eu,
	jmeneghi@redhat.com, emilne@redhat.com, bgurney@redhat.com
Subject: Re: [PATCH V2 3/3] scsi: Convert async scanning to use the
 completion chain helper
Message-ID: <20260224143933.GC12308@lst.de>
References: <20260224122505.52401-1-mlombard@redhat.com> <20260224122505.52401-4-mlombard@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224122505.52401-4-mlombard@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 24, 2026 at 01:25:05PM +0100, Maurizio Lombardi wrote:
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index 7a193cc04e5b..d8a157bc9078 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -132,7 +132,7 @@ extern void scsi_exit_procfs(void);
>  
>  /* scsi_scan.c */
>  void scsi_enable_async_suspend(struct device *dev);
> -extern int scsi_complete_async_scans(void);
> +extern void scsi_complete_async_scans(void);

No need for the extern here.

> +DEFINE_COMPL_CHAIN(scanning_hosts);

This looks like it should be marked static.

