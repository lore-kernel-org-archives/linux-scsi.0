Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AE247CC8C
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 13:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791378750; cv=none; b=nblVZpeHdIODzmJpFFo0goAvEXMnCzlMKv88kfpjWBPvIVOyUzAP3St45U1JYaIdzqju9OXWQV/HFK+BQP28n4Z3Lsr37K/JvjZKGZvK4UJjXixOVGEUXgALSpEtCHHCs4F/y7Cg99Z5lWEYhxlrFs81YeUfqo/m2jQB1y/9mYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791378750; c=relaxed/simple;
	bh=Au9XRwYQ7tB2F7LVAYMFCgtCq2YdCGr4aDisL33Y2Tg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rje6aX8pNKrrBYsggbCpij5ObhEpv83udrZCDMBPkJO78C9prkyieTEpKrnlpdZKLu5pLFp7TcsgnT/cEXUtUxtBJ+uEjBXC9wvaQBeKvdPu91AP1wkBsP2ndk5POOY5VKGMetgXE8HMGR4FeE0L1XVYZ6LbhazxPrRX+pJYm0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F36BD68BFE; Wed,  7 Oct 2026 15:12:18 +0200 (CEST)
Date: Wed, 7 Oct 2026 15:12:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 5/8] scsi: scsi_debug: Split resp_write_dt0()
Message-ID: <20261007131218.GC30647@lst.de>
References: <cover.1791349129.git.bvanassche@acm.org> <cd2d03eef52045b8a94c7c11644c3676f91b105f.1791349129.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd2d03eef52045b8a94c7c11644c3676f91b105f.1791349129.git.bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 06, 2026 at 10:07:27PM -0700, Bart Van Assche wrote:
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index c66f8556896d..685949aedf9a 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -5094,6 +5094,85 @@ static int corrupt_lbas(struct sdebug_dev_info *devip, u64 lba, u32 num,
>  	return error;
>  }
>  
> +/*
> + * Returns 0 upon success or -1 with *scsi_status set to a SCSI status code upon

Overly long line.

The rest looks pretty sane.
