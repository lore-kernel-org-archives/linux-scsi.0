From: Robert Love <robert.w.love@intel.com>
Subject: Re: [Open-FCoE] [PATCH 1/2] libfc: fix memory leakage in local port
Date: Thu, 28 Oct 2010 16:12:05 -0700
Message-ID: <1288307525.1431.201.camel@fritz>
References: <AANLkTi=dLRNj0r8aUehqtVPgzpJsbGqnX2t-7AOkQfkS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9794 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758671Ab0J1XMG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Oct 2010 19:12:06 -0400
In-Reply-To: <AANLkTi=dLRNj0r8aUehqtVPgzpJsbGqnX2t-7AOkQfkS@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

On Wed, 2010-10-27 at 20:40 +0800, Hillf Danton wrote:
> There seems info should get freed when error encountered.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/drivers/scsi/libfc/fc_lport.c	2010-09-13 07:07:38.000000000 +0800
> +++ b/drivers/scsi/libfc/fc_lport.c	2010-10-27 20:33:36.000000000 +0800
> @@ -1766,8 +1766,10 @@ static int fc_lport_ct_request(struct fc
>  	info->sg = job->reply_payload.sg_list;
> 
>  	if (!lport->tt.exch_seq_send(lport, fp, fc_lport_bsg_resp,
> -				     NULL, info, tov))
> +				     NULL, info, tov)) {
> +		kfree(info);

We cannot free the BSG info here. If you look at fc_exch_seq_send you
can see that it's attached to the exchange and then when the response is
received it is passed to the response handler, in the case
fc_lport_bsg_resp, where it is free'd.

>  		return -ECOMM;
> +	}
>  	return 0;
>  }
> _______________________________________________
> devel mailing list
> devel@open-fcoe.org
> http://www.open-fcoe.org/mailman/listinfo/devel


