From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 1/9] snic: snic module infrastructure
Date: Thu, 2 Apr 2015 02:21:58 -0700
Message-ID: <20150402092158.GA6794@infradead.org>
References: <1427965488-12073-1-git-send-email-nmusini@cisco.com>
 <1427965488-12073-2-git-send-email-nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48227 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbbDBJWA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2015 05:22:00 -0400
Content-Disposition: inline
In-Reply-To: <1427965488-12073-2-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Narsimhulu Musini <nmusini@cisco.com>
Cc: JBottomley@Parallels.com, linux-scsi@vger.kernel.org, hare@suse.de, Sesidhar Baddela <sebaddel@cisco.com>

> +/*
> + * Usage of the scsi_cmnd scratchpad.
> + * These fields are locked by the hashed req_lock.
> + */
> +#define CMD_SP(Cmnd)		((Cmnd)->SCp.ptr)
> +#define CMD_STATE(Cmnd)		((Cmnd)->SCp.phase)
> +#define CMD_ABTS_STATUS(Cmnd)	((Cmnd)->SCp.Message)
> +#define CMD_LR_STATUS(Cmnd)	((Cmnd)->SCp.have_data_in)
> +#define CMD_TAG(Cmnd)		((Cmnd)->SCp.sent_command)
> +#define CMD_FLAGS(Cmnd)		((Cmnd)->SCp.Status)

Please don't abuse ->SCp for new drivers.  Declare your own structure
and set .cmd_size in the host template to it's size, then access it
using scsi_cmd_priv().  That should also avoid the need for the mempool
that the driver currently creates.

> +static int
> +snic_slave_alloc(struct scsi_device *sdev)
> +{
> +	u32 qdepth = 0, max_ios = 0;
> +	struct snic_tgt *tgt = starget_to_tgt(scsi_target(sdev));
> +
> +	if (!tgt || snic_tgt_chkready(tgt))
> +		return -ENXIO;
> +
> +	max_ios = snic_max_qdepth;
> +	max_ios = snic_max_qdepth;
> +	qdepth = min_t(u32, max_ios, SNIC_MAX_QUEUE_DEPTH);
> +	scsi_change_queue_depth(sdev, qdepth);

Plase set the queue_depth in ->slave_configure like all other drivers.

> +	.cmd_per_lun = 3,

why so low?

> +
> +#ifndef PCI_VENDOR_ID_CISCO
> +#define PCI_VENDOR_ID_CISCO     0x1137
> +#endif

Just use the numeric value directly.

> +
> +#define SNIC_OS_TYPE	SNIC_OS_LINUX
> +#define snic_cmd_tag(sc)	(((struct scsi_cmnd *) sc)->request->tag)
> +
> +extern struct device_attribute *snic_attrs[];
> +
> +static inline struct kmem_cache *
> +snic_cache_create(const char *cache_name, const int sz)
> +{
> +	void *cp;
> +
> +	cp = kmem_cache_create(cache_name, sz, SNIC_SG_DESC_ALIGN,
> +			       SLAB_HWCACHE_ALIGN, NULL);
> +
> +	return (struct kmem_cache *) cp;
> +}

Please remove all the wrappers in the snic_os.h file and use the Linux
APIs directly.
