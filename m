Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D14BC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 17:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40E2420715
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 17:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbhADRwI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:52:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:43484 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727696AbhADRwI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Jan 2021 12:52:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AB95FADF0;
        Mon,  4 Jan 2021 17:51:26 +0000 (UTC)
Date:   Mon, 4 Jan 2021 18:51:26 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 22/31] elx: efct: Hardware queues processing
Message-ID: <20210104175126.sikmz7xlsvfqcqzu@beryllium.lan>
References: <20210103171134.39878-1-jsmart2021@gmail.com>
 <20210103171134.39878-23-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210103171134.39878-23-jsmart2021@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,

On Sun, Jan 03, 2021 at 09:11:25AM -0800, James Smart wrote:
> +struct efct_io {
> +	struct list_head	list_entry;
> +	struct list_head	io_pending_link;
> +	/* reference counter and callback function */
> +	struct kref		ref;
> +	void (*release)(struct kref *arg);
> +	/* pointer back to efct */
> +	struct efct		*efct;
> +	/* unique instance index value */
> +	u32			instance_index;
> +	/* display name */
> +	const char		*display_name;
> +	/* pointer to node */
> +	struct efct_node	*node;
> +	/* (io_pool->io_free_list) free list link */
> +	/* initiator task tag (OX_ID) for back-end and SCSI logging */
> +	u32			init_task_tag;
> +	/* target task tag (RX_ID) - for back-end and SCSI logging */
> +	u32			tgt_task_tag;
> +	/* HW layer unique IO id - for back-end and SCSI logging */
> +	u32			hw_tag;
> +	/* unique IO identifier */
> +	u32			tag;
> +	/* SGL */
> +	struct efct_scsi_sgl	*sgl;
> +	/* Number of allocated SGEs */
> +	u32			sgl_allocated;
> +	/* Number of SGEs in this SGL */
> +	u32			sgl_count;
> +	/* backend target private IO data */
> +	struct efct_scsi_tgt_io tgt_io;
> +	/* expected data transfer length, based on FC header */
> +	u32			exp_xfer_len;
> +
> +	/* Declarations private to HW/SLI */
> +	void			*hw_priv;
> +
> +	/* indicates what this struct efct_io structure is used for */
> +	enum efct_io_type	io_type;
> +	struct efct_hw_io	*hio;
> +	size_t			transferred;
> +
> +	/* set if auto_trsp was set */
> +	bool			auto_resp;
> +	/* set if low latency request */
> +	bool			low_latency;
> +	/* selected WQ steering request */
> +	u8			wq_steering;
> +	/* selected WQ class if steering is class */
> +	u8			wq_class;
> +	/* transfer size for current request */
> +	u64			xfer_req;
> +	/* target callback function */
> +	efct_scsi_io_cb_t	scsi_tgt_cb;
> +	/* target callback function argument */
> +	void			*scsi_tgt_cb_arg;
> +	/* abort callback function */
> +	efct_scsi_io_cb_t	abort_cb;
> +	/* abort callback function argument */
> +	void			*abort_cb_arg;
> +	/* BLS callback function */
> +	efct_scsi_io_cb_t	bls_cb;
> +	/* BLS callback function argument */
> +	void			*bls_cb_arg;
> +	/* TMF command being processed */
> +	enum efct_scsi_tmf_cmd	tmf_cmd;
> +	/* rx_id from the ABTS that initiated the command abort */
> +	u16			abort_rx_id;
> +
> +	/* True if this is a Target command */
> +	bool			cmd_tgt;
> +	/* when aborting, indicates ABTS is to be sent */
> +	bool			send_abts;
> +	/* True if this is an Initiator command */
> +	bool			cmd_ini;
> +	/* True if local node has sequence initiative */
> +	bool			seq_init;
> +	/* iparams for hw io send call */
> +	union efct_hw_io_param_u iparam;
> +	/* HW IO type */
> +	enum efct_hw_io_type	hio_type;
> +	/* wire length */
> +	u64			wire_len;
> +	/* saved HW callback */
> +	void			*hw_cb;
> +
> +	/* for abort handling */
> +	/* pointer to IO to abort */
> +	struct efct_io		*io_to_abort;
> +
> +	/* SCSI Response buffer */
> +	struct efc_dma		rspbuf;
> +	/* Timeout value in seconds for this IO */
> +	u32			timeout;
> +	/* CS_CTL priority for this IO */
> +	u8			cs_ctl;
> +	/* Is io object in freelist > */
> +	u8			io_free;
> +	u32			app_id;
> +};

These comments should be in kernel doc format.

> +
> +struct efct_io_cb_arg {
> +	int status;		/* completion status */
> +	int ext_status;		/* extended completion status */
> +	void *app;		/* application argument */
> +};
> +

These here too.

Thanks,
Daniel
