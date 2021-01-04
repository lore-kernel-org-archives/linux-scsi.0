Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 435A3C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 17:45:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 156EB2068D
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 17:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbhADRpI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:45:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:41904 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbhADRpH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Jan 2021 12:45:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CCA5EADF0;
        Mon,  4 Jan 2021 17:44:26 +0000 (UTC)
Date:   Mon, 4 Jan 2021 18:44:26 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v5 21/31] elx: efct: Hardware IO and SGL initialization
Message-ID: <20210104174426.sxdvuacdcbkjdz7s@beryllium.lan>
References: <20210103171134.39878-1-jsmart2021@gmail.com>
 <20210103171134.39878-22-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210103171134.39878-22-jsmart2021@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jan 03, 2021 at 09:11:24AM -0800, James Smart wrote:
> +static inline struct efct_hw_io *
> +_efct_hw_io_alloc(struct efct_hw *hw)
> +{
> +	struct efct_hw_io *io = NULL;
> +
> +	if (!list_empty(&hw->io_free)) {
> +		io = list_first_entry(&hw->io_free, struct efct_hw_io,
> +				      list_entry);
> +		list_del(&io->list_entry);
> +	}
> +	if (io) {
> +		INIT_LIST_HEAD(&io->list_entry);
> +		list_add_tail(&io->list_entry, &hw->io_inuse);
> +		io->state = EFCT_HW_IO_STATE_INUSE;
> +		io->abort_reqtag = U32_MAX;
> +		io->wq = hw->wq_cpu_array[raw_smp_processor_id()];

This one will also crash for system with more than 128 CPUs.


> +		if (!io->wq) {
> +			efc_log_err(hw->os, "WQ not assigned for cpu:%d\n",
> +					raw_smp_processor_id());
> +			io->wq = hw->hw_wq[0];
> +		}
> +		kref_init(&io->ref);
> +		io->release = efct_hw_io_free_internal;
> +	} else {
> +		atomic_add_return(1, &hw->io_alloc_failed_count);
> +	}
> +
> +	return io;
> +}
