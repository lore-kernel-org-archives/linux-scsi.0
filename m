From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC 4/8] scsi-ml: scsi_sgtable implementation
Date: Thu, 12 Jul 2007 14:09:44 -0500
Message-ID: <46967C78.3070100@cs.wisc.edu>
References: <468CDB3C.4060500@panasas.com> <468CF58E.1020901@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:38091 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755318AbXGLTMt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jul 2007 15:12:49 -0400
In-Reply-To: <468CF58E.1020901@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>

Boaz Harrosh wrote:
> +/*
> + * Should fit within a single page.
> + */
> +enum { SCSI_MAX_SG_SEGMENTS =
> +	((PAGE_SIZE - sizeof(struct scsi_sgtable)) /
> +	sizeof(struct scatterlist)) };
> +
> +enum { SG_MEMPOOL_NR =
> +	(SCSI_MAX_SG_SEGMENTS >= 7) +
> +	(SCSI_MAX_SG_SEGMENTS >= 15) +
> +	(SCSI_MAX_SG_SEGMENTS >= 31) +
> +	(SCSI_MAX_SG_SEGMENTS >= 63) +
> +	(SCSI_MAX_SG_SEGMENTS >= 127) +
> +	(SCSI_MAX_SG_SEGMENTS >= 255) +
> +	(SCSI_MAX_SG_SEGMENTS >= 511)
> +};
>  

What does SCSI_MAX_SG_SEGMENTS end up being on x86 now? On x86_64 or 
some other arch, we were going over a page when doing 
SCSI_MAX_PHYS_SEGMENTS of 256 right?

What happened to Jens's scatter list chaining and how does this relate 
to it then?
