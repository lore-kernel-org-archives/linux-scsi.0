From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv2 RESENDv2 3/9] target: Allocate se_dev_entrys in
	device list only when used
Date: Tue, 24 Jun 2014 16:48:05 +0200
Message-ID: <20140624144805.GA18450@lst.de>
References: <1403567738-13310-1-git-send-email-agrover@redhat.com> <1403567738-13310-4-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44907 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbaFXOsJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2014 10:48:09 -0400
Content-Disposition: inline
In-Reply-To: <1403567738-13310-4-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org

> +	/*
> +	 * Wait for any in process SPEC_I_PT=1 or REGISTER_AND_MOVE
> +	 * PR operation to complete.
> +	 */
> +	while (atomic_read(&deve->pr_ref_count) != 0)
> +		cpu_relax();

A busy loop under an irq disabling spinlock is fairly nasty.  Can we just
remove the pointer to the entry from the device list array, then unlock
and then have the busy loop?

>  enum transport_lunflags_table {
>  	TRANSPORT_LUNFLAGS_NO_ACCESS		= 0x00,
> -	TRANSPORT_LUNFLAGS_INITIATOR_ACCESS	= 0x01,
> -	TRANSPORT_LUNFLAGS_READ_ONLY		= 0x02,
> -	TRANSPORT_LUNFLAGS_READ_WRITE		= 0x04,
> +	TRANSPORT_LUNFLAGS_READ_ONLY		= 0x01,
> +	TRANSPORT_LUNFLAGS_READ_WRITE		= 0x02,

Not something for this patch, but having the read only and read/write
flags is silly.  Having one of them should be enough, either a rdonly
or a writeable one would do it.
