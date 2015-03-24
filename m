From: Olaf Hering <olaf@aepfle.de>
Subject: Re: [PATCH 6/7] scsi: storvsc: Don't assume that the scatterlist is
 not chained
Date: Tue, 24 Mar 2015 09:56:07 +0100
Message-ID: <20150324085607.GA1849@aepfle.de>
References: <1427144760-11875-1-git-send-email-kys@microsoft.com>
 <1427144801-11920-1-git-send-email-kys@microsoft.com>
 <1427144801-11920-6-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:32212 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbbCXI4m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2015 04:56:42 -0400
Content-Disposition: inline
In-Reply-To: <1427144801-11920-6-git-send-email-kys@microsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com

On Mon, Mar 23, K. Y. Srinivasan wrote:

> @@ -653,32 +640,39 @@ static unsigned int copy_from_bounce_buffer(struct scatterlist *orig_sgl,
>  	unsigned long bounce_addr = 0;
>  	unsigned long dest_addr = 0;
>  	unsigned long flags;
> +	struct scatterlist *cur_dest_sgl;
> +	struct scatterlist *cur_src_sgl;
>  
>  	local_irq_save(flags);
> -
> +	cur_dest_sgl = orig_sgl;
> +	cur_src_sgl = bounce_sgl;
>  	for (i = 0; i < orig_sgl_count; i++) {
> -		dest_addr = sg_kmap_atomic(orig_sgl,i) + orig_sgl[i].offset;
> +		dest_addr = (unsigned long)
> +				kmap_atomic(sg_page(cur_dest_sgl)) +
> +				cur_dest_sgl->offset;
>  		dest = dest_addr;
>  		destlen = orig_sgl[i].length;
> +		destlen = cur_dest_sgl->length;

Double assignment.

Olaf
