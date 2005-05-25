From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] allow the HBA to reserve target and device private areas
Date: Wed, 25 May 2005 08:13:53 +0100
Message-ID: <20050525071353.GA13141@infradead.org>
References: <1116971851.5897.52.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus1.kernel.org ([204.152.191.4]:2221 "EHLO zeus1.kernel.org")
	by vger.kernel.org with ESMTP id S262325AbVEYHRM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2005 03:17:12 -0400
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by zeus1.kernel.org (8.13.1/8.13.1) with ESMTP id j4P7HAhT003307
	for <linux-scsi@vger.kernel.org>; Wed, 25 May 2005 00:17:11 -0700
Content-Disposition: inline
In-Reply-To: <1116971851.5897.52.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, May 24, 2005 at 04:57:31PM -0500, James Bottomley wrote:
> +/* Private area maintenance. The driver requested allocations come
> + * directly after the transport class allocations (if any).  The idea
> + * is that you *must* call these only once.  The code assumes that the
> + * initial values are the ones the transport specific code requires */
> +static inline void
> +scsi_transport_reserve_target(struct scsi_transport_template * t, int space)
> +{
> +	t->target_private_offset = ALIGN(t->target_size, sizeof(void *));
> +	t->target_size = t->target_private_offset + space;
> +}
> +static inline void
> +scsi_transport_reserve_device(struct scsi_transport_template * t, int space)
> +{
> +	t->device_private_offset = ALIGN(t->device_size, sizeof(void *));
> +	t->device_size = t->device_private_offset + space;
> +}

Do we really need separate functions for this?  It would be so much nicer
to just have target_priv_size and device_priv_size members in the
foo_function_template.  Yes, it would mean having this in all different
transport templates, but in general having this as compile-time initializer
seems a lot nicer.

