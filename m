Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A87C4320E
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Aug 2021 15:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4EDC60FA0
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Aug 2021 15:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233337AbhHKPr4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Aug 2021 11:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232973AbhHKPrw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Aug 2021 11:47:52 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B34EC0613D5
        for <linux-scsi@vger.kernel.org>; Wed, 11 Aug 2021 08:47:28 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id 3so1388052qvd.2
        for <linux-scsi@vger.kernel.org>; Wed, 11 Aug 2021 08:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=6tF0dzi2GoJvxRdrYyAAeHG1Gte82wPM17JrCS4BiWU=;
        b=UXyizVxPbrX/ffO5vk1uTZCI3O+SQFcvKh3pwlfARjYUXRDVMM0lnbsmAm+4/CmcDd
         RXQr+rHEJdAXljdSQXw5qvITjwjdaNBOONM4cJPt9phyAS+qZNNWtp35HH+FHj5ycvgb
         fWxDfUbyWlCU62RjANC9dBIMNP0cS8KUlJ/j2OtBROe6yfnYfn7UDKxBhAMQ6zRhEpHz
         zF3v5mxK71hcsTu5nV46w+IkZajUww0GZGBdnE2VRc5LpzRxpooYp5/2b/9RTB4PzO39
         0y6pDEs1ieHZqItmWkvBUr7uL2/NigEDmzeqsH44SM9lUfFHCygUFBEs27tSlDEZrj+4
         mgFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=6tF0dzi2GoJvxRdrYyAAeHG1Gte82wPM17JrCS4BiWU=;
        b=r3KOYmXVqRkes5zONrRT31GyceCqUoklcUQ7RZVSW2CNEY5m3JMKRTsT6qtVahAQjF
         2JJDMmeaD1QeMgF3cHt1udiv3BKvf8NihbyOdUg0xyErAO2RZRmnRYxI3akMNpmkz5qD
         FtygtJjil7xTzl9qFs0+NUa1zFdXkFHrj+0VQq1bpfmmlrgdgU61oYVEDtT9slZaqOqB
         Qi8Iyqf+tJn5LYWeRDIAmib/bvhW1AbfeC6dsM4y5sA3kG5B83s4T5eTMgq/eRlKpYxd
         iHU6glg/qqSuR13hvjM6BQQud2M0dsMJRNVx7IgfK2YiGZgztb2g773yC0Mv0HW3pa+R
         VbkA==
X-Gm-Message-State: AOAM533weiW/zdouqANosCETugQwNTLX0hPX7xoggEkEKX2YwjJ8zhS9
        LOssEgnwDKujFIO8UgLNupM=
X-Google-Smtp-Source: ABdhPJwWSRzPrvsv+tYJs6C+nDL/OS5EuWU3sYtrRCXdLj2qKd0feb6HW9LDRQkhBbSIvrjgqU6RZQ==
X-Received: by 2002:a05:6214:10e6:: with SMTP id q6mr35176740qvt.11.1628696847569;
        Wed, 11 Aug 2021 08:47:27 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k5sm495317qtq.6.2021.08.11.08.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 08:47:27 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 11 Aug 2021 08:47:25 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Shai Malin <smalin@marvell.com>
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        malin1024@gmail.com, Manish Rangankar <mrangankar@marvell.com>
Subject: Re: [PATCH v2] scsi: qedi: Add support for fastpath doorvell recovery
Message-ID: <20210811154725.GA1122984@roeck-us.net>
References: <20210804221412.5048-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210804221412.5048-1-smalin@marvell.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 05, 2021 at 01:14:12AM +0300, Shai Malin wrote:
> Driver fastpath employs doorbells to indicate to the device that work
> is available. Each doorbell translates to a message sent to the device
> over the pci. These messages are queued by the doorbell queue HW block,
> and handled by the HW.
> If a sufficient amount of CPU cores are sending messages at a sufficient
> rate, the queue can overflow, and messages can be dropped. There are
> many entities in the driver which can send doorbell messages.
> When overflow happens, a fatal HW attention is indicated, and the
> Doorbell HW block stops accepting new doorbell messages until recovery
> procedure is done.
> 
> When overflow occurs, all doorbells are dropped. Since doorbells are
> aggregatives, if more doorbells are sent nothing has to be done.
> But if the "last" doorbell is dropped, the doorbelling entity doesn’t know
> this happened, and may wait forever for the device to perform the action.
> The doorbell recovery mechanism addresses just that - it sends the last
> doorbell of every entity.
> 
> Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>  drivers/scsi/qedi/qedi_fw.c    | 14 ++++----------
>  drivers/scsi/qedi/qedi_iscsi.c | 33 ++++++++++++++++++++++++++++++++-
>  drivers/scsi/qedi/qedi_iscsi.h |  1 +
>  3 files changed, 37 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
> index 71333d3c5c86..e7064f62c833 100644
> --- a/drivers/scsi/qedi/qedi_fw.c
> +++ b/drivers/scsi/qedi/qedi_fw.c
> @@ -936,17 +936,11 @@ void qedi_fp_process_cqes(struct qedi_work *work)
>  
>  static void qedi_ring_doorbell(struct qedi_conn *qedi_conn)
>  {
> -	struct iscsi_db_data dbell = { 0 };
> +	qedi_conn->ep->db_data.sq_prod = qedi_conn->ep->fw_sq_prod_idx;
>  
> -	dbell.agg_flags = 0;
> -
> -	dbell.params |= DB_DEST_XCM << ISCSI_DB_DATA_DEST_SHIFT;
> -	dbell.params |= DB_AGG_CMD_SET << ISCSI_DB_DATA_AGG_CMD_SHIFT;
> -	dbell.params |=
> -		   DQ_XCM_ISCSI_SQ_PROD_CMD << ISCSI_DB_DATA_AGG_VAL_SEL_SHIFT;
> -
> -	dbell.sq_prod = qedi_conn->ep->fw_sq_prod_idx;
> -	writel(*(u32 *)&dbell, qedi_conn->ep->p_doorbell);
> +	/* wmb - Make sure fw idx is coherent */
> +	wmb();
> +	writel(*(u32 *)&qedi_conn->ep->db_data, qedi_conn->ep->p_doorbell);
>  
>  	/* Make sure fw write idx is coherent, and include both memory barriers
>  	 * as a failsafe as for some architectures the call is the same but on
> diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
> index 97f83760da88..8ac8aabc1ef6 100644
> --- a/drivers/scsi/qedi/qedi_iscsi.c
> +++ b/drivers/scsi/qedi/qedi_iscsi.c
> @@ -499,8 +499,8 @@ static u16 qedi_calc_mss(u16 pmtu, u8 is_ipv6, u8 tcp_ts_en, u8 vlan_en)
>  
>  static int qedi_iscsi_offload_conn(struct qedi_endpoint *qedi_ep)
>  {
> -	struct qedi_ctx *qedi = qedi_ep->qedi;
>  	struct qed_iscsi_params_offload *conn_info;
> +	struct qedi_ctx *qedi = qedi_ep->qedi;
>  	int rval;
>  	int i;
>  
> @@ -577,8 +577,34 @@ static int qedi_iscsi_offload_conn(struct qedi_endpoint *qedi_ep)
>  		  "Default cq index [%d], mss [%d]\n",
>  		  conn_info->default_cq, conn_info->mss);
>  
> +	/* Prepare the doorbell parameters */
> +	qedi_ep->db_data.agg_flags = 0;
> +	qedi_ep->db_data.params = 0;
> +	SET_FIELD(qedi_ep->db_data.params, ISCSI_DB_DATA_DEST, DB_DEST_XCM);
> +	SET_FIELD(qedi_ep->db_data.params, ISCSI_DB_DATA_AGG_CMD,
> +		  DB_AGG_CMD_MAX);
> +	SET_FIELD(qedi_ep->db_data.params, ISCSI_DB_DATA_AGG_VAL_SEL,
> +		  DQ_XCM_ISCSI_SQ_PROD_CMD);
> +	SET_FIELD(qedi_ep->db_data.params, ISCSI_DB_DATA_BYPASS_EN, 1);
> +
> +	/* Register doorbell with doorbell recovery mechanism */
> +	rval = qedi_ops->common->db_recovery_add(qedi->cdev,
> +						 qedi_ep->p_doorbell,
> +						 &qedi_ep->db_data,
> +						 DB_REC_WIDTH_32B,
> +						 DB_REC_KERNEL);
> +	if (rval) {
> +		kfree(conn_info);
> +		return rval;
> +	}
> +
>  	rval = qedi_ops->offload_conn(qedi->cdev, qedi_ep->handle, conn_info);
>  	if (rval)
> +		/* delete doorbell from doorbell recovery mechanism */
> +		rval = qedi_ops->common->db_recovery_del(qedi->cdev,
> +							 qedi_ep->p_doorbell,
> +							 &qedi_ep->db_data);
> +
>  		QEDI_ERR(&qedi->dbg_ctx, "offload_conn returned %d, ep=%p\n",
>  			 rval, qedi_ep);

Due to missing { } this will now always result in QEDI_ERR() execution
(and possibly a C compiler warning).

Guenter

>  
> @@ -1109,6 +1135,11 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
>  	    test_bit(QEDI_IN_RECOVERY, &qedi->flags))
>  		goto ep_release_conn;
>  
> +	/* Delete doorbell from doorbell recovery mechanism */
> +	ret = qedi_ops->common->db_recovery_del(qedi->cdev,
> +					       qedi_ep->p_doorbell,
> +					       &qedi_ep->db_data);
> +
>  	ret = qedi_ops->destroy_conn(qedi->cdev, qedi_ep->handle, abrt_conn);
>  	if (ret) {
>  		QEDI_WARN(&qedi->dbg_ctx,
> diff --git a/drivers/scsi/qedi/qedi_iscsi.h b/drivers/scsi/qedi/qedi_iscsi.h
> index 758735209e15..a31c5de74754 100644
> --- a/drivers/scsi/qedi/qedi_iscsi.h
> +++ b/drivers/scsi/qedi/qedi_iscsi.h
> @@ -80,6 +80,7 @@ struct qedi_endpoint {
>  	u32 handle;
>  	u32 fw_cid;
>  	void __iomem *p_doorbell;
> +	struct iscsi_db_data db_data;
>  
>  	/* Send queue management */
>  	struct iscsi_wqe *sq;
> -- 
> 2.22.0
> 
