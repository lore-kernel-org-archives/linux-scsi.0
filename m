Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F5C5C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 09:08:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2518523120
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 09:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbhAGJHn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 04:07:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:59648 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbhAGJHk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Jan 2021 04:07:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E153FACAF;
        Thu,  7 Jan 2021 09:06:58 +0000 (UTC)
Date:   Thu, 7 Jan 2021 10:06:58 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v6 20/31] elx: efct: RQ buffer, memory pool allocation
 and deallocation APIs
Message-ID: <20210107090658.xtbj5uqqmp3b2hf7@beryllium.lan>
References: <20210107005030.2929-1-jsmart2021@gmail.com>
 <20210107005030.2929-21-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107005030.2929-21-jsmart2021@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 06, 2021 at 04:50:19PM -0800, James Smart wrote:
> +static int
> +efct_hw_cmd_submit_pending(struct efct_hw *hw)
> +{
> +	struct efct_command_ctx *ctx = NULL;
> +	int rc = 0;
> +
> +	/* Assumes lock held */
> +
> +	/* Only submit MQE if there's room */
> +	while (hw->cmd_head_count < (EFCT_HW_MQ_DEPTH - 1) &&
> +	       !list_empty(&hw->cmd_pending)) {
> +		ctx = list_first_entry(&hw->cmd_pending,
> +				       struct efct_command_ctx, list_entry);
> +		if (!ctx)
> +			break;
> +
> +		list_del_init(&ctx->list_entry);
> +
> +		list_add_tail(&ctx->list_entry, &hw->cmd_head);
> +		hw->cmd_head_count++;
> +		if (sli_mq_write(&hw->sli, hw->mq, ctx->buf) < 0) {
> +			efc_log_debug(hw->os,
> +				      "sli_queue_write failed: %d\n", rc);
> +			rc = -1;

EFC_FAIL?

> +			break;
> +		}
> +	}
> +	return rc;
> +}

> +int
> +efct_issue_mbox_rqst(void *base, void *cmd, void *cb, void *arg)
> +{
> +	int rc = 0;
> +	struct efct_mbox_rqst_ctx *ctx;
> +	struct efct *efct = base;
> +	struct efct_hw *hw = &efct->hw;
> +
> +	/*
> +	 * Allocate a callback context (which includes the mbox cmd buffer),
> +	 * we need this to be persistent as the mbox cmd submission may be
> +	 * queued and executed later execution.
> +	 */
> +	ctx = mempool_alloc(hw->mbox_rqst_pool, GFP_ATOMIC);
> +	if (!ctx)
> +		return EFC_FAIL;
> +
> +	ctx->callback = cb;
> +	ctx->arg = arg;
> +
> +	if (efct_hw_command(hw, cmd, EFCT_CMD_NOWAIT, efct_mbox_rsp_cb, ctx)) {
> +		efc_log_err(efct, "issue mbox rqst failure\n");
> +		mempool_free(ctx, hw->mbox_rqst_pool);
> +		rc = -1;

EFC_FAIL?

> +	}
> +	return rc;
> +}
