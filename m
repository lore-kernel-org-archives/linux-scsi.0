From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] qla1280 update for 2.6.1-mm4
Date: Mon, 19 Jan 2004 12:14:06 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040119121406.A32409@infradead.org>
References: <16395.51364.833229.536552@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:39689 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264575AbUASMOJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 07:14:09 -0500
Content-Disposition: inline
In-Reply-To: <16395.51364.833229.536552@gargle.gargle.HOWL>; from jes@trained-monkey.org on Mon, Jan 19, 2004 at 07:08:04AM -0500
List-Id: linux-scsi@vger.kernel.org
To: Jes Sorensen <jes@trained-monkey.org>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, James.Bottomley@steeleye.com, jeremy@sgi.com

On Mon, Jan 19, 2004 at 07:08:04AM -0500, Jes Sorensen wrote:
> +#ifdef QLA_64BIT_PTR
>  static int qla1280_64bit_start_scsi(struct scsi_qla_host *, struct srb *);
> +#else
>  static int qla1280_32bit_start_scsi(struct scsi_qla_host *, struct srb *);
> +#endif

Shouldn't you just call both of those qla1280_start_scsi if only one of
them is compiled at a time anyway?

> +#ifdef QLA_64BIT_PTR
> +	/*
> +	 * Using 64 bit commands if the PCI bridge doesn't support it is a
> +	 * bit wasteful, however this should really only happen if one's
> +	 * PCI controller is completely broken, like the BCM1250. For
> +	 * sane hardware this is not an issue.
> +	 */
> +	status = qla1280_64bit_start_scsi(ha, sp);
> +#else
> +	status = qla1280_32bit_start_scsi(ha, sp);
> +#endif

That would also clean up this nicely..

