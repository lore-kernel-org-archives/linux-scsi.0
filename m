From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Fri, 22 Apr 2005 13:36:56 +0200
Message-ID: <20050422113654.GY9371@suse.de>
References: <20050321075531.GC23911@suse.de> <7044.1111398919@www16.gmx.net> <Pine.LNX.4.56.0503211111290.20956@pcgl.dsa-ac.de> <20050321104419.GH23911@suse.de> <Pine.LNX.4.56.0503211147420.20956@pcgl.dsa-ac.de> <Pine.LNX.4.60.0503302318250.9431@poirot.grange> <1112220802.9435.1.camel@mulgrave> <Pine.LNX.4.56.0503311051290.20956@pcgl.dsa-ac.de> <Pine.LNX.4.60.0504100035110.4283@poirot.grange> <Pine.LNX.4.60.0504212341390.6761@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:53457 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262025AbVDVLhR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Apr 2005 07:37:17 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0504212341390.6761@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Kurt Garloff <garloff@suse.de>

On Thu, Apr 21 2005, Guennadi Liakhovetski wrote:
> +static void *dc390_kmap_atomic_sg(struct scatterlist *sg, int sg_count, size_t offset, size_t *len)
> +{
> +	int i;
> +	size_t sg_len = 0;
> +
> +	for (i = 0; i < sg_count; i++) {
> +		sg_len += sg[i].length;
> +		if (sg_len > offset)
> +			break;
> +	}
> +
> +	BUG_ON(i == sg_count);
> +
> +	*len = sg_len - offset;
> +
> +	return kmap_atomic(sg[i].page, KM_BIO_SRC_IRQ) + sg[i].offset + sg[i].length - *len;
> +}
> +
> +static void dc390_kunmap_atomic_sg(void *virt)
> +{
> +	kunmap_atomic(virt_to_page(virt), KM_BIO_SRC_IRQ);
> +}

Please remember to test this with highmem debug. The above is buggy,
kunmap_atomic() takes the mapped pointer, not the page structure.

-- 
Jens Axboe

