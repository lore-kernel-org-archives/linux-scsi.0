Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29653C433E3
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 16:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11E2120773
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 16:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730033AbgGMQFl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 12:05:41 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:17833 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729593AbgGMQFl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 12:05:41 -0400
Received: from localhost (varun.asicdesigners.com [10.193.191.116])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 06DG5SlI003709;
        Mon, 13 Jul 2020 09:05:29 -0700
Date:   Mon, 13 Jul 2020 21:35:28 +0530
From:   Varun Prakash <varun@chelsio.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: cxgb4i: fix dereference of pointer tdata
 before it is null checked
Message-ID: <20200713160526.GA1704@chelsio.com>
References: <20200709135217.1408105-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709135217.1408105-1-colin.king@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 09, 2020 at 02:52:17PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently pointer tdata is being dereferenced on the initialization of
> pointer skb before tdata is null checked. This could lead to a potential
> null pointer dereference.  Fix this by dereferencing tdata after tdata
> has been null pointer sanity checked.
> 
> Addresses-Coverity: ("Dereference before null check")
> Fixes: e33c2482289b ("scsi: cxgb4i: Add support for iSCSI segmentation offload")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/cxgbi/libcxgbi.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
> index 1fb101c616b7..a6119d9daedf 100644
> --- a/drivers/scsi/cxgbi/libcxgbi.c
> +++ b/drivers/scsi/cxgbi/libcxgbi.c
> @@ -2147,7 +2147,7 @@ int cxgbi_conn_init_pdu(struct iscsi_task *task, unsigned int offset,
>  	struct iscsi_conn *conn = task->conn;
>  	struct iscsi_tcp_task *tcp_task = task->dd_data;
>  	struct cxgbi_task_data *tdata = iscsi_task_cxgbi_data(task);
> -	struct sk_buff *skb = tdata->skb;
> +	struct sk_buff *skb;
>  	struct scsi_cmnd *sc = task->sc;
>  	u32 expected_count, expected_offset;
>  	u32 datalen = count, dlimit = 0;
> @@ -2161,6 +2161,7 @@ int cxgbi_conn_init_pdu(struct iscsi_task *task, unsigned int offset,
>  		       tcp_task ? tcp_task->dd_data : NULL, tdata);
>  		return -EINVAL;
>  	}
> +	skb = tdata->skb;
>  
>  	log_debug(1 << CXGBI_DBG_ISCSI | 1 << CXGBI_DBG_PDU_TX,
>  		  "task 0x%p,0x%p, skb 0x%p, 0x%x,0x%x,0x%x, %u+%u.\n",
> @@ -2365,7 +2366,7 @@ int cxgbi_conn_xmit_pdu(struct iscsi_task *task)
>  	struct iscsi_tcp_task *tcp_task = task->dd_data;
>  	struct cxgbi_task_data *tdata = iscsi_task_cxgbi_data(task);
>  	struct cxgbi_task_tag_info *ttinfo = &tdata->ttinfo;
> -	struct sk_buff *skb = tdata->skb;
> +	struct sk_buff *skb;
>  	struct cxgbi_sock *csk = NULL;
>  	u32 pdulen = 0;
>  	u32 datalen;
> @@ -2378,6 +2379,7 @@ int cxgbi_conn_xmit_pdu(struct iscsi_task *task)
>  		return -EINVAL;
>  	}
>  
> +	skb = tdata->skb;
>  	if (!skb) {
>  		log_debug(1 << CXGBI_DBG_ISCSI | 1 << CXGBI_DBG_PDU_TX,
>  			  "task 0x%p, skb NULL.\n", task);

Acked-by: Varun Prakash <varun@chelsio.com>
