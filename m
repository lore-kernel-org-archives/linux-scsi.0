Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85237C4167B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 15:22:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5672C23730
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 15:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgLGPWK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 10:22:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:33170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbgLGPWJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Dec 2020 10:22:09 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 486992371F;
        Mon,  7 Dec 2020 15:21:28 +0000 (UTC)
Date:   Mon, 7 Dec 2020 10:21:26 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/3] scsi: ufs: Distinguish between query REQ and
 query RSP in query trace
Message-ID: <20201207102126.66d8e4f7@gandalf.local.home>
In-Reply-To: <20201206164226.6595-2-huobean@gmail.com>
References: <20201206164226.6595-1-huobean@gmail.com>
        <20201206164226.6595-2-huobean@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun,  6 Dec 2020 17:42:24 +0100
Bean Huo <huobean@gmail.com> wrote:

> From: Bean Huo <beanhuo@micron.com>
> 
> Currently, in the query completion trace print,  since we use
> hba->lrb[tag].ucd_req_ptr and didn't differentiate UPIU between
> request and response, thus header and transaction-specific field
> in UPIU printed by query trace are identical. This is not very
> practical. As below:
> 
> query_send: HDR:16 00 00 0e 00 81 00 00 00 00 00 00, CDB:06 0e 03 00 00 00 00 00 00 00 00 00 00 00 00 00
> query_complete: HDR:16 00 00 0e 00 81 00 00 00 00 00 00, CDB:06 0e 03 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> For the failure analysis, we want to understand the real response
> reported by the UFS device, however, the current query trace tells
> us nothing. After this patch, the query trace on the query_send, and
> the above a pair of query_send and query_complete will be:
> 
> query_send: HDR:16 00 00 0e 00 81 00 00 00 00 00 00, CDB:06 0e 03 00 00 00 00 00 00 00 00 00 00 00 00 00
> ufshcd_upiu: HDR:36 00 00 0e 00 81 00 00 00 00 00 00, CDB:06 0e 03 00 00 00 00 00 00 00 00 01 00 00 00 00
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index ceb562accc39..e10de94adb3f 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -321,9 +321,15 @@ static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int tag,
>  static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba, unsigned int tag,
>  		const char *str)
>  {
> -	struct utp_upiu_req *rq = hba->lrb[tag].ucd_req_ptr;
> +	struct utp_upiu_req *rq_rsp;
> +

I would add:

	if (!trace_ufshcd_upiu_enabled())
		return;

Why do the work if the trace point is not enabled?

-- Steve


> +	if (!strcmp("query_send", str))
> +		rq_rsp = hba->lrb[tag].ucd_req_ptr;
> +	else
> +		rq_rsp = (struct utp_upiu_req *)hba->lrb[tag].ucd_rsp_ptr;
>  
> -	trace_ufshcd_upiu(dev_name(hba->dev), str, &rq->header, &rq->qr);
> +	trace_ufshcd_upiu(dev_name(hba->dev), str, &rq_rsp->header,
> +			  &rq_rsp->qr);
>  }
>  
>  static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,

