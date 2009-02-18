From: "Love, Robert W" <robert.w.love@intel.com>
Subject: RE: [PATCH] libfc: fix printk format warnings
Date: Wed, 18 Feb 2009 14:59:34 -0700
Message-ID: <273D38FBE7C6FE46A1689FCD014A0B8B30714198@azsmsx505.amr.corp.intel.com>
References: <20090218131238.10050b14.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:20015 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122AbZBRWAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Feb 2009 17:00:08 -0500
In-Reply-To: <20090218131238.10050b14.randy.dunlap@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>, scsi <linux-scsi@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, jejb <James.Bottomley@HansenPartnership.com>

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix libfc printk format warnings:
> 
> drivers/scsi/libfc/fc_lport.c:788: warning: long long unsigned int
> format, u64 arg (arg 3) drivers/scsi/libfc/fc_lport.c:792: warning:
> long long unsigned int format, u64 arg (arg 3)
> drivers/scsi/libfc/fc_rport.c:968: warning: long long unsigned int
> format, u64 arg (arg 4)  
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Robert Love <robert.w.love@intel.com>

This patch will conflict with the updates I've sent and some
that I plan to send since we've done an overhaul of our debugging
statements. If there's anything I can do to help with this, let
me know.

> ---
>  drivers/scsi/libfc/fc_lport.c |    5 +++--
>  drivers/scsi/libfc/fc_rport.c |    2 +-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
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
> +	FC_DBG("FLOGI from port WWPN %llx\n", (unsigned long
> long)remote_wwpn); 
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

