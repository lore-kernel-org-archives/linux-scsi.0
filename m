From: Robert Love <robert.w.love@intel.com>
Subject: Re: [Open-FCoE] [PATCH] libfc: fix mem leak in fc_fcp_srr_resp()
Date: Thu, 28 Oct 2010 14:39:59 -0700
Message-ID: <1288301999.1431.187.camel@fritz>
References: <AANLkTik9+jAwcs0G9v2Nbwh-GfFc61V4=n7wYn0CaSc-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7173 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933157Ab0J1VkA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Oct 2010 17:40:00 -0400
In-Reply-To: <AANLkTik9+jAwcs0G9v2Nbwh-GfFc61V4=n7wYn0CaSc-@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

On Mon, 2010-10-25 at 20:47 +0800, Hillf Danton wrote:
> There seems frame should be freed against memory leakage.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/drivers/scsi/libfc/fc_fcp.c	2010-09-13 07:07:38.000000000 +0800
> +++ b/drivers/scsi/libfc/fc_fcp.c	2010-10-25 20:33:58.000000000 +0800
> @@ -1685,6 +1685,7 @@ static void fc_fcp_srr_resp(struct fc_se
>  	 */
>  	if (fh->fh_type == FC_TYPE_BLS) {
>  		fc_fcp_unlock_pkt(fsp);
> +		fc_frame_free(fp);
>  		return;
>  	}

My first thought was that we need to do a fc_fcp_pkt_release here since
we're doing a fc_fcp_pkt_hold in fc_fcp_srr, but on further
consideration I think this BLS check is unnecessary. fc_exch_recv checks
for BLS frames before calling any of the response handlers.

