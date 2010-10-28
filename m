From: Robert Love <robert.w.love@intel.com>
Subject: Re: [Open-FCoE] [PATCH 2/2] libfc: fix memory leakage in local port
Date: Thu, 28 Oct 2010 16:13:28 -0700
Message-ID: <1288307608.1431.203.camel@fritz>
References: <AANLkTi=dLRNj0r8aUehqtVPgzpJsbGqnX2t-7AOkQfkS@mail.gmail.com>
	 <AANLkTikU6J5_uJ0k-EdmzKP0ORYrHkd1jdQjwY0B_jf-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2127 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758427Ab0J1XN2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Oct 2010 19:13:28 -0400
In-Reply-To: <AANLkTikU6J5_uJ0k-EdmzKP0ORYrHkd1jdQjwY0B_jf-@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

On Wed, 2010-10-27 at 20:43 +0800, Hillf Danton wrote:
> There seems info should get freed when error encountered.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/drivers/scsi/libfc/fc_lport.c	2010-09-13 07:07:38.000000000 +0800
> +++ b/drivers/scsi/libfc/fc_lport.c	2010-10-27 20:35:10.000000000 +0800
> @@ -1707,8 +1707,10 @@ static int fc_lport_els_request(struct f
>  	info->sg = job->reply_payload.sg_list;
> 
>  	if (!lport->tt.exch_seq_send(lport, fp, fc_lport_bsg_resp,
> -				     NULL, info, tov))
> +				     NULL, info, tov)) {
> +		kfree(info);

The same comment I made about patch [1/2] applies here. We need the BSG
info in the fc_lport_bsg_resp response handler.

Thanks, //Rob


