From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 03/18] libosd: OSDv1 Headers
Date: Tue, 4 Nov 2008 11:10:37 -0800
Message-ID: <20081104111037.bcae04e5.akpm@linux-foundation.org>
References: <491073BB.4000900@panasas.com>
	<1225817046-5946-1-git-send-email-bharrosh@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41517 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752326AbYKDTMT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2008 14:12:19 -0500
In-Reply-To: <1225817046-5946-1-git-send-email-bharrosh@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Sami.Iren@seagate.com, pw@padd.com

On Tue,  4 Nov 2008 18:44:06 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> Headers only patch.
> 
> osd_protocol.h
> 	Contains a C-fied definition of the T10 OSD standard
> osd_types.h
> 	Contains CPU order common used types
> osd_initiator.h
> 	API definition of the osd_initiator library
> osd_sec.h
> 	Contains High level API for the security manager.
> 
> [Note that checkpatch spews errors on things that are valid in this context
> and will not be fixed]
> 
> --- /dev/null
> +++ b/include/scsi/osd_initiator.h

This header uses quite a few things without including the header files
which define them.  That's a bit risky - it causes compile breakage
across architectures, across config changes and across time.

> @@ -0,0 +1,332 @@
> +/*
> + * osd_initiator.h - OSD initiator API definition
> + *
> + * Copyright (C) 2008 Panasas Inc.  All rights reserved.
> + *
> + * Authors:
> + *   Boaz Harrosh <bharrosh@panasas.com>
> + *   Benny Halevy <bhalevy@panasas.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2
> + *
> + */
> +#ifndef __OSD_INITIATOR_H__
> +#define __OSD_INITIATOR_H__
> +
> +#include <linux/blkdev.h>
> +
> +#include "osd_protocol.h"
> +#include "osd_types.h"
> +
> +/* Note: "NI" in comments below means "Not Implemented yet" */
> +
> +/*
> + * Object-based Storage Device.
> + * This object represents an OSD device.
> + * It is not a full linux device in any way. It is only
> + * a place to hang resources associated with a Linux
> + * request Q and some default properties.
> + */
> +struct osd_dev {
> +	struct scsi_device *scsi_dev;

scsi_device

> +	unsigned def_timeout;
> +};
> +
> +void osd_dev_init(struct osd_dev *, struct scsi_device *scsi_dev);
> +void osd_dev_fini(struct osd_dev *);
> +
> +struct osd_request;
> +typedef void (osd_req_done_fn)(struct osd_request *, void *);
> +
> +struct osd_request {
> +	struct osd_cdb cdb;
> +	struct osd_data_out_integrity_info out_data_integ;
> +	struct osd_data_in_integrity_info in_data_integ;
> +
> +	struct osd_dev *osd_dev;
> +	struct request *request;
> +
> +	struct _osd_req_data_segment {
> +		void *buff;
> +		unsigned alloc_size; /* 0 here means not allocated by us */
> +		unsigned total_bytes;
> +	} set_attr, enc_get_attr, get_attr;
> +
> +	struct _osd_io_info {
> +		struct bio *bio;
> +		u64 total_bytes;

u64(!)

> +		struct request *req;
> +		struct _osd_req_data_segment *last_seg;
> +		u8 *pad_buff;
> +	} out, in;
> +
> +	gfp_t alloc_flags;

gfp_t

> +	unsigned timeout;
> +	unsigned retries;
> +	u8 sense[OSD_MAX_SENSE_LEN];
> +	enum osd_attributes_mode attributes_mode;
> +
> +	osd_req_done_fn *async_done;
> +	void *async_private;
> +	int async_error;
> +};

etc, etc, etc.   Please review all that.

> +struct osd_request *osd_start_request(struct osd_dev *, gfp_t gfp);
> +int osd_finalize_request(struct osd_request *or,
> +	u8 options, const void *cap, const u8 *cap_key);
> +void osd_req_set_master_seed_xchg(struct osd_request *, ...);/* NI */
> +void osd_req_set_master_key(struct osd_request *, ...);/* NI */
> +void osd_req_format(struct osd_request *, u64 tot_capacity);
> +int osd_req_list_dev_partitions(struct osd_request *,
> +	osd_id initial_id, struct osd_obj_id_list *list, unsigned nelem);

hm.  It appears that someone made the decision to omit the name from
the `struct osd_request *' parameter in the prototypes and to include
the argument names for all other arguments.

Not a bad idea, really.

