Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14F126A1C1;
	Tue, 25 Feb 2025 15:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740496080; cv=none; b=E1UhHMIK4Lq8NY1BQORRy6N8n6r3kNhcfkblNzvvDwk5Y2HM4IZY27HzzWttRBXrkydnvGrk62VnnMEPEeUGl4s7RsdDmztZmSdU+UvjdsECjaS+l+rToSEx365lJqaBFPb8zzL5wYT+qtEp/L0Q+ZsLFQG6pQc6X0gwXF8gR7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740496080; c=relaxed/simple;
	bh=XOZtUF0f3op4qCgTNJ7ufH2wcZyTZQaZySaKmdTYvuI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MCHKZXWuUB124IvdoSszSrsCsvYpsVuLIwTF00FyzoLRwE06dAz1JIla74VWnaBFQ/MBXkuK9k7u7NumjOOPB7Ww2QXgvNss/1QqWcwKRQ8BjewY01nbeUu69y8kuo4invc8XbM1ZKd+VjrhJHBE25ehs2YLuTT3XSz1wLWh5Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5899C68D05; Tue, 25 Feb 2025 16:07:54 +0100 (CET)
Date: Tue, 25 Feb 2025 16:07:53 +0100
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, anuj1072538@gmail.com,
	nikh1092@linux.ibm.com, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH v1 2/3] nvme: Fix incorrect block integrity sysfs
 values for non-PI namespaces
Message-ID: <20250225150753.GB6099@lst.de>
References: <20250225044653.6867-1-anuj20.g@samsung.com> <CGME20250225045516epcas5p3fa5712152300bf976d1bc0ab26211633@epcas5p3.samsung.com> <20250225044653.6867-3-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250225044653.6867-3-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 25, 2025 at 10:16:52AM +0530, Anuj Gupta wrote:
>  	memset(bi, 0, sizeof(*bi));
>  
> +	bi->flags = BLK_INTEGRITY_NOGENERATE | BLK_INTEGRITY_NOVERIFY;
>  	if (!head->ms)
>  		return true;
>  
> @@ -1850,6 +1851,9 @@ static bool nvme_init_integrity(struct nvme_ns_head *head,
>  		break;
>  	}
>  
> +	if (bi->flags & BLK_INTEGRITY_DEVICE_CAPABLE)
> +		bi->flags &= ~(BLK_INTEGRITY_NOGENERATE |
> +			       BLK_INTEGRITY_NOVERIFY);

I don't think the driver is the proper place to do this, this should
be done in blk_validate_integrity_limits.  That should also take care
or the stacked devices and remove the need for the last hunk in the
previous patch.

