From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] libfc: fix printk format warnings
Date: Thu, 19 Feb 2009 22:19:19 +0900
Message-ID: <20090219221856U.fujita.tomonori@lab.ntt.co.jp>
References: <20090218131238.10050b14.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:53638 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299AbZBSNUI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Feb 2009 08:20:08 -0500
In-Reply-To: <20090218131238.10050b14.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: randy.dunlap@oracle.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com

On Wed, 18 Feb 2009 13:12:38 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix libfc printk format warnings:
> 
> drivers/scsi/libfc/fc_lport.c:788: warning: long long unsigned int format, u64 arg (arg 3)
> drivers/scsi/libfc/fc_lport.c:792: warning: long long unsigned int format, u64 arg (arg 3)
> drivers/scsi/libfc/fc_rport.c:968: warning: long long unsigned int format, u64 arg (arg 4)
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/scsi/libfc/fc_lport.c |    5 +++--
>  drivers/scsi/libfc/fc_rport.c |    2 +-
>  2 files changed, 4 insertions(+), 3 deletions(-)

The identical patch is in scsi-misc?

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commitdiff;h=e109928f140e3cbd5bfeacb5c0d2b2e820b11be5


> --- lnx2629-rc5-docsrc.orig/drivers/scsi/libfc/fc_lport.c
> +++ lnx2629-rc5-docsrc/drivers/scsi/libfc/fc_lport.c
> @@ -786,10 +786,11 @@ static void fc_lport_recv_flogi_req(stru
>  	remote_wwpn = get_unaligned_be64(&flp->fl_wwpn);
>  	if (remote_wwpn == lport->wwpn) {
>  		FC_DBG("FLOGI from port with same WWPN %llx "
> -		       "possible configuration error\n", remote_wwpn);
> +		       "possible configuration error\n",
> +		       (unsigned long long)remote_wwpn);
>  		goto out;
>  	}
> -	FC_DBG("FLOGI from port WWPN %llx\n", remote_wwpn);
> +	FC_DBG("FLOGI from port WWPN %llx\n", (unsigned long long)remote_wwpn);
>  
>  	/*
>  	 * XXX what is the right thing to do for FIDs?
> --- lnx2629-rc5-docsrc.orig/drivers/scsi/libfc/fc_rport.c
> +++ lnx2629-rc5-docsrc/drivers/scsi/libfc/fc_rport.c
> @@ -966,7 +966,7 @@ static void fc_rport_recv_plogi_req(stru
>  	switch (rdata->rp_state) {
>  	case RPORT_ST_INIT:
>  		FC_DEBUG_RPORT("incoming PLOGI from %6x wwpn %llx state INIT "
> -			       "- reject\n", sid, wwpn);
> +			       "- reject\n", sid, (unsigned long long)wwpn);
>  		reject = ELS_RJT_UNSUP;
>  		break;
>  	case RPORT_ST_PLOGI:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
