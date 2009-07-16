From: Tobias Klauser <klto@zhaw.ch>
Subject: Re: [PATCH] fcoe: Use %pM conversion specifier
Date: Thu, 16 Jul 2009 14:16:55 +0200
Message-ID: <4A5F1A37.8090309@zhaw.ch>
References: <1247735698-22060-1-git-send-email-klto@zhaw.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.zhaw.ch ([160.85.104.51]:42990 "EHLO mx2.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755428AbZGPMQ6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jul 2009 08:16:58 -0400
In-Reply-To: <1247735698-22060-1-git-send-email-klto@zhaw.ch>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, robert.w.love@intel.com, vasu.dev@intel.com, yi.zou@intel.com, christopher.leech@intel.com, linux-scsi@vger.kernel.org

I see this patch was already submitted by Johannes Berg just yesterday
(message id: 1247671274.10754.5.camel () johannes ! local)

Sorry.

On 07/16/2009 11:14 AM, Tobias Klauser wrote:
> Use the %pM conversion specifier for printk instead of print_mac.
> 
> Signed-off-by: Tobias Klauser <klto@zhaw.ch>
> ---
>  drivers/scsi/fcoe/libfcoe.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
> index f544340..d6ed3f8 100644
> --- a/drivers/scsi/fcoe/libfcoe.c
> +++ b/drivers/scsi/fcoe/libfcoe.c
> @@ -1104,7 +1104,6 @@ static void fcoe_ctlr_timeout(unsigned long arg)
>  	struct fcoe_fcf *sel;
>  	struct fcoe_fcf *fcf;
>  	unsigned long next_timer = jiffies + msecs_to_jiffies(FIP_VN_KA_PERIOD);
> -	DECLARE_MAC_BUF(buf);
>  	u8 send_ctlr_ka;
>  	u8 send_port_ka;
>  
> @@ -1128,9 +1127,8 @@ static void fcoe_ctlr_timeout(unsigned long arg)
>  		fcf = sel;		/* the old FCF may have been freed */
>  		if (sel) {
>  			printk(KERN_INFO "libfcoe: host%d: FIP selected "
> -			       "Fibre-Channel Forwarder MAC %s\n",
> -			       fip->lp->host->host_no,
> -			       print_mac(buf, sel->fcf_mac));
> +			       "Fibre-Channel Forwarder MAC %pM\n",
> +			       fip->lp->host->host_no, sel->fcf_mac);
>  			memcpy(fip->dest_addr, sel->fcf_mac, ETH_ALEN);
>  			fip->port_ka_time = jiffies +
>  					    msecs_to_jiffies(FIP_VN_KA_PERIOD);

