From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 1 of 9] patches to add diskdump functionality to block
	layer
Date: Mon, 18 Apr 2005 17:47:07 +0200
Message-ID: <1113839227.6274.80.camel@laptopd505.fenrus.org>
References: <20050418153644.GA25409@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:19671 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262113AbVDRPrN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Apr 2005 11:47:13 -0400
In-Reply-To: <20050418153644.GA25409@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mike.miller@hp.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, marcelo.tosatti@cyclades.com

On Mon, 2005-04-18 at 10:36 -0500, mike.miller@hp.com wrote:
> +
> +/*
> + * Extended block operations for dump for preserving binary compatibility.
> + */
> +struct block_dump_ops {
> +	int (*sanity_check)(void *device);
> +	int (*rw_block)(void *device, int rw, unsigned long dump_block_nr, void *buf, int len, unsigned long start_sect, unsigned long nr_sects);
> +	int (*quiesce)(void *device);
> +	int (*shutdown)(void *device);
> +};

this looks wrong. In linux we don't care about module ABI, and just go
for the clean solution instead! (eg in this case, just put the methods
in the block dev ops)


