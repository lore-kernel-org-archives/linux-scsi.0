Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80FE5C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 16:35:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43E5F2245C
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 16:35:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbhADQfU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 11:35:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:53570 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727471AbhADQfU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Jan 2021 11:35:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7EFE9ADD6;
        Mon,  4 Jan 2021 16:34:39 +0000 (UTC)
Date:   Mon, 4 Jan 2021 17:34:39 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v5 15/31] elx: libefc: Extended link Service IO handling
Message-ID: <20210104163439.vgeklc4uzezwvp3t@beryllium.lan>
References: <20210103171134.39878-1-jsmart2021@gmail.com>
 <20210103171134.39878-16-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210103171134.39878-16-jsmart2021@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,

On Sun, Jan 03, 2021 at 09:11:18AM -0800, James Smart wrote:
> +void efc_disc_io_complete(struct efc_disc_io *io, u32 len, u32 status,
> +			  u32 ext_status)
> +{
> +	struct efc_els_io_req *els =
> +				container_of(io, struct efc_els_io_req, io);
> +
> +	WARN_ON(!els->cb);


Could this be a filling up the logs? Maybe the the once version of it
would be enough.

> +
> +	((efc_hw_srrs_cb_t) els->cb) (els, len, status, ext_status);
> +}

[...]

> +int
> +efc_send_plogi(struct efc_node *node)
> +{
> +	struct efc_els_io_req *els;
> +	struct efc *efc = node->efc;
> +	struct fc_els_flogi  *plogi;
> +
> +	node_els_trace();
> +
> +	els = efc_els_io_alloc(node, sizeof(*plogi));
> +	if (!els) {
> +		efc_log_err(efc, "IO alloc failed\n");
> +		return EFC_FAIL;
> +	}
> +	els->display_name = "plogi";
> +
> +	/* Build PLOGI request */
> +	plogi = els->io.req.virt;
> +
> +	memcpy(plogi, node->nport->service_params, sizeof(*plogi));
> +
> +	plogi->fl_cmd = ELS_PLOGI;
> +	memset(plogi->_fl_resvd, 0, sizeof(plogi->_fl_resvd));
> +
> +	efc_els_send_req(node, els, EFC_DISC_IO_ELS_REQ);
> +
> +	return EFC_SUCCESS;

Just wondering it would be a good idea to efc_els_send_req() return a
error status and use it here. At least efc_els_send_req() can fail.

The same comment is true for the rest of the file. There are a bunch
more of those send functions with the 'fire and forget' semantic.

Thanks,
Daniel
