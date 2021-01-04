Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85523C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 17:59:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 555A422209
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 17:59:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbhADR6x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:58:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:45864 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbhADR6x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Jan 2021 12:58:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 472DCACAF;
        Mon,  4 Jan 2021 17:58:12 +0000 (UTC)
Date:   Mon, 4 Jan 2021 18:58:11 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 24/31] elx: efct: SCSI IO handling routines
Message-ID: <20210104175811.vvz2er27h74urrei@beryllium.lan>
References: <20210103171134.39878-1-jsmart2021@gmail.com>
 <20210103171134.39878-25-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210103171134.39878-25-jsmart2021@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jan 03, 2021 at 09:11:27AM -0800, James Smart wrote:
> This patch continues the efct driver population.
> 
> This patch adds driver definitions for:
> Routines for SCSI transport IO alloc, build and send IO.
> 
> Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Just one nitpick. The rest looks good.

Reviewed-by: Daniel Wagner <dwagner@suse.de>

> +struct efct_scsi_cmd_resp {
> +	u8 scsi_status;			/* SCSI status */
> +	u16 scsi_status_qualifier;	/* SCSI status qualifier */
> +	/* pointer to response data buffer */
> +	u8 *response_data;
> +	/* length of response data buffer (bytes) */
> +	u32 response_data_length;
> +	u8 *sense_data;		/* pointer to sense data buffer */
> +	/* length of sense data buffer (bytes) */
> +	u32 sense_data_length;
> +	/* command residual (not used for target), positive value
> +	 * indicates an underflow, negative value indicates overflow
> +	 */
> +	int residual;
> +	/* Command response length received in wcqe */
> +	u32 response_wire_length;
> +};

These comments should be in kernel doc format.

