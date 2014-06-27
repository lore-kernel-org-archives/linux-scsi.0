From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH 1/4] Add XEN pvSCSI protocol description
Date: Fri, 27 Jun 2014 13:11:54 -0400
Message-ID: <20140627171154.GA30451@laptop.dumpdata.com>
References: <1403879676-25431-1-git-send-email-jgross@suse.com>
 <1403879676-25431-2-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29341 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaF0RMR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jun 2014 13:12:17 -0400
Content-Disposition: inline
In-Reply-To: <1403879676-25431-2-git-send-email-jgross@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgross@suse.com
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, xen-devel@lists.xen.org

On Fri, Jun 27, 2014 at 04:34:33PM +0200, jgross@suse.com wrote:
> From: Juergen Gross <jgross@suse.com>
> 
> Add the definition of pvSCSI protocol used between the pvSCSI frontend in a
> XEN domU and the pvSCSI backend in a XEN driver domain (usually Dom0).
> 
> This header was originally provided by Fujitsu for XEN based on Linux 2.6.18.
> Changes are:
> - added comment
> - adapt to Linux style guide
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>  include/xen/interface/io/vscsiif.h | 110 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 110 insertions(+)
>  create mode 100644 include/xen/interface/io/vscsiif.h
> 
> diff --git a/include/xen/interface/io/vscsiif.h b/include/xen/interface/io/vscsiif.h
> new file mode 100644
> index 0000000..f8420f3
> --- /dev/null
> +++ b/include/xen/interface/io/vscsiif.h
> @@ -0,0 +1,110 @@
> +/******************************************************************************
> + * vscsiif.h
> + *
> + * Based on the blkif.h code.
> + *
> + * This interface is to be regarded as a stable API between XEN domains
> + * running potentially different Linux kernel versions.
> + *
> + * Permission is hereby granted, free of charge, to any person obtaining a copy
> + * of this software and associated documentation files (the "Software"), to
> + * deal in the Software without restriction, including without limitation the
> + * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
> + * sell copies of the Software, and to permit persons to whom the Software is
> + * furnished to do so, subject to the following conditions:
> + *
> + * The above copyright notice and this permission notice shall be included in
> + * all copies or substantial portions of the Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> + * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> + * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
> + * DEALINGS IN THE SOFTWARE.
> + *
> + * Copyright(c) FUJITSU Limited 2008.
> + */
> +
> +#ifndef __XEN__PUBLIC_IO_SCSI_H__
> +#define __XEN__PUBLIC_IO_SCSI_H__
> +
> +#include "ring.h"
> +#include "../grant_table.h"
> +
> +/* commands between backend and frontend */
> +#define VSCSIIF_ACT_SCSI_CDB		1	/* SCSI CDB command */
> +#define VSCSIIF_ACT_SCSI_ABORT		2	/* SCSI Device(Lun) Abort*/
> +#define VSCSIIF_ACT_SCSI_RESET		3	/* SCSI Device(Lun) Reset*/
> +#define VSCSIIF_ACT_SCSI_SG_PRESET	4	/* Preset SG elements */
> +
> +/*
> + * Maximum scatter/gather segments per request.
> + *
> + * Considering balance between allocating at least 16 "vscsiif_request"
> + * structures on one page (4096 bytes) and the number of scatter/gather
> + * elements needed, we decided to use 26 as a magic number.
> + */
> +#define VSCSIIF_SG_TABLESIZE		26
> +
> +/*
> + * based on Linux kernel 2.6.18

This being a bit more .. new, - do these sizes make sense anymore?
Should they be extended a bit? Or have support for using the
old ones (as default) and then negotiate new sizes with the kernel?
(If of course there is a difference?)
> + */
> +#define VSCSIIF_MAX_COMMAND_SIZE	16
> +#define VSCSIIF_SENSE_BUFFERSIZE	96
> +
> +struct scsiif_request_segment {
> +	grant_ref_t gref;
> +	uint16_t offset;
> +	uint16_t length;
> +};
> +typedef struct scsiif_request_segment vscsiif_segment_t;

No typedefs please.
> +
> +struct vscsiif_request {
> +	uint16_t rqid;		/* private guest value, echoed in resp  */
> +	uint8_t act;		/* command between backend and frontend */
> +	uint8_t cmd_len;
> +
> +	uint8_t cmnd[VSCSIIF_MAX_COMMAND_SIZE];
> +	uint16_t timeout_per_command;	/* The command is issued by twice
> +					   the value in Backend. */
> +	uint16_t channel, id, lun;
> +	uint16_t padding;
> +	uint8_t sc_data_direction;	/* for DMA_TO_DEVICE(1)
> +					   DMA_FROM_DEVICE(2)
> +					   DMA_NONE(3) requests */
> +	uint8_t nr_segments;		/* Number of pieces of scatter-gather */
> +
> +	vscsiif_segment_t seg[VSCSIIF_SG_TABLESIZE];
> +	uint32_t reserved[3];
> +};

Could you add a comment saying what the size should be. Just in case
somebody extends this in the future - they will know the limits.

> +typedef struct vscsiif_request vscsiif_request_t;

Ditto.
> +
> +#define VSCSIIF_SG_LIST_SIZE ((sizeof(vscsiif_request_t) - 4) /		\
> +				sizeof(vscsiif_segment_t))

That -4 ought to have a comment. In case the scsiif_request_segment
gets a new member or such.
> +
> +struct vscsiif_sg_list {
> +	/* First two fields must match struct vscsiif_request! */
> +	uint16_t rqid;		/* private guest value, must match main req */
> +	uint8_t act;		/* VSCSIIF_ACT_SCSI_SG_PRESET */
> +	uint8_t nr_segments;	/* Number of pieces of scatter-gather */
> +	vscsiif_segment_t seg[VSCSIIF_SG_LIST_SIZE];
> +};
> +typedef struct vscsiif_sg_list vscsiif_sg_list_t;

Ditto.
> +
> +struct vscsiif_response {
> +	uint16_t rqid;
> +	uint8_t act;		/* valid only when backend supports SG_PRESET */

Same comment? First two fields must match 'struct vscsiif_request' ?

> +	uint8_t sense_len;
> +	uint8_t sense_buffer[VSCSIIF_SENSE_BUFFERSIZE];
> +	int32_t rslt;
> +	uint32_t residual_len;	/* request bufflen -
> +				   return the value from physical device */
> +	uint32_t reserved[36];
> +};
> +typedef struct vscsiif_response vscsiif_response_t;

I think you know what I am going to say :-)
> +
> +DEFINE_RING_TYPES(vscsiif, struct vscsiif_request, struct vscsiif_response);
> +
> +#endif /*__XEN__PUBLIC_IO_SCSI_H__*/
> -- 
> 1.8.4.5
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
