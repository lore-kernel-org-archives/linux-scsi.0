From: Robert Love <robert.w.love@intel.com>
Subject: Re: [PATCH] fcoe: convert to %pM
Date: Wed, 15 Jul 2009 15:06:15 -0700
Message-ID: <1247695575.23392.5.camel@fritz>
References: <1247671274.10754.5.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:5955 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188AbZGOWGd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jul 2009 18:06:33 -0400
In-Reply-To: <1247671274.10754.5.camel@johannes.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Leech, Christopher" <christopher.leech@intel.com>

On Wed, 2009-07-15 at 08:21 -0700, Johannes Berg wrote:
> print_mac is being deprecated, and %pM makes for smaller
> code anyway.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Thanks Johannes.

Acked-by: Robert Love <robert.w.love@intel.com>

> ---
>  drivers/scsi/fcoe/libfcoe.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> --- wireless-testing.orig/drivers/scsi/fcoe/libfcoe.c	2009-07-15 17:12:02.000000000 +0200
> +++ wireless-testing/drivers/scsi/fcoe/libfcoe.c	2009-07-15 17:12:17.000000000 +0200
> @@ -1104,7 +1104,6 @@ static void fcoe_ctlr_timeout(unsigned l
>  	struct fcoe_fcf *sel;
>  	struct fcoe_fcf *fcf;
>  	unsigned long next_timer = jiffies + msecs_to_jiffies(FIP_VN_KA_PERIOD);
> -	DECLARE_MAC_BUF(buf);
>  	u8 send_ctlr_ka;
>  	u8 send_port_ka;
>  
> @@ -1128,9 +1127,8 @@ static void fcoe_ctlr_timeout(unsigned l
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
> 
> 

