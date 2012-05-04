From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [v2 PATCH 3/4] bnx2fc: cleanup task management IO when it times
 out.
Date: Fri, 04 May 2012 03:49:58 -0500
Message-ID: <4FA39836.3070907@cs.wisc.edu>
References: <1335306364-31449-1-git-send-email-bprakash@broadcom.com> <1335306364-31449-4-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36359 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784Ab2EDIuI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 May 2012 04:50:08 -0400
In-Reply-To: <1335306364-31449-4-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Cc: JBottomley@Parallels.com, linux-scsi@vger.kernel.org

On 04/24/2012 05:26 PM, Bhanu Prakash Gollapudi wrote:
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
> index d3ee231..082a25c 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
> @@ -185,6 +185,16 @@ void bnx2fc_flush_active_ios(struct bnx2fc_rport *tgt)
>  		BUG_ON(rc);
>  	}
>  
> +	list_for_each_safe(list, tmp, &tgt->active_tm_queue) {
> +		i++;
> +		io_req = (struct bnx2fc_cmd *)list;

Why didn't you use list_for_each_entry_safe()? Or, when using
list_for_each_safe, instead of the cast are we supposed to be using
list_entry()?


> +		list_del_init(&io_req->link);
> +		io_req->on_tmf_queue = 0;
> +		BNX2FC_IO_DBG(io_req, "tm_queue cleanup\n");
> +		if (io_req->wait_for_comp)
> +			complete(&io_req->tm_done);
> +	}
> +
>  	list_for_each_safe(list, tmp, &tgt->els_queue) {
>  		i++;
>  		io_req = (struct bnx2fc_cmd *)list;

