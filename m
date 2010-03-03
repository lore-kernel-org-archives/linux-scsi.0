From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 03/32] bfa: Defined a new LPS event to clear virtual
 link on a vport
Date: Wed, 03 Mar 2010 21:10:23 +0530
Message-ID: <1267630823.15025.130.camel@mulgrave.site>
References: <1267148837-21819-1-git-send-email-kgudipat@blc-10-2.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57579 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023Ab0CCPkh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Mar 2010 10:40:37 -0500
In-Reply-To: <1267148837-21819-1-git-send-email-kgudipat@blc-10-2.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Krishna Gudipati <kgudipat@brocade.com>
Cc: linux-scsi@vger.kernel.org, adapter_linux_open_src_team@brocade.com, huangj@brocade.com

On Thu, 2010-02-25 at 17:47 -0800, Krishna Gudipati wrote:
> Change details:
> 
>     - Clear virtual links was not propagated upwards to bfa from fw.
>       This resulted in HBA and switch being in an inconsistent state.
> 
>     - So defined a new LPS event for clear virtual link on a vport,
> 	  and also now clear virtual link on a baseport, is sent as a
> 	  link down event from the fw.
> ---
>  drivers/scsi/bfa/bfa_lps.c             |   71 +++++++++++++++++++++++++++++++-
>  drivers/scsi/bfa/include/bfa_svc.h     |    1 +
>  drivers/scsi/bfa/include/bfi/bfi_lps.h |    8 ++++
>  drivers/scsi/bfa/vport.c               |   11 +++++
>  4 files changed, 90 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/bfa/bfa_lps.c b/drivers/scsi/bfa/bfa_lps.c
> index 9844b45..c8c2564 100644
> --- a/drivers/scsi/bfa/bfa_lps.c
> +++ b/drivers/scsi/bfa/bfa_lps.c
> @@ -49,7 +49,7 @@ static void bfa_lps_send_login(struct bfa_lps_s *lps);
>  static void bfa_lps_send_logout(struct bfa_lps_s *lps);
>  static void bfa_lps_login_comp(struct bfa_lps_s *lps);
>  static void bfa_lps_logout_comp(struct bfa_lps_s *lps);
> -
> +static void bfa_lps_cvl_event(struct bfa_lps_s *lps);
>  
>  /**
>   *  lps_pvt BFA LPS private functions
> @@ -62,6 +62,7 @@ enum bfa_lps_event {
>  	BFA_LPS_SM_RESUME	= 4,	/* space present in reqq queue	*/
>  	BFA_LPS_SM_DELETE	= 5,	/* lps delete from user		*/
>  	BFA_LPS_SM_OFFLINE	= 6,	/* Link is offline		*/
> +	BFA_LPS_SM_RX_CVL       = 7,	/* Rx clear virtual link        */
>  };
>  
>  static void bfa_lps_sm_init(struct bfa_lps_s *lps, enum bfa_lps_event event);
> @@ -101,6 +102,7 @@ bfa_lps_sm_init(struct bfa_lps_s *lps, enum bfa_lps_event event)
>  		bfa_lps_free(lps);
>  		break;
>  
> +	case BFA_LPS_SM_RX_CVL:
>  	case BFA_LPS_SM_OFFLINE:
>  		break;
>  
> @@ -162,6 +164,14 @@ bfa_lps_sm_loginwait(struct bfa_lps_s *lps, enum bfa_lps_event event)
>  		bfa_reqq_wcancel(&lps->wqe);
>  		break;
>  
> +	case BFA_LPS_SM_RX_CVL:
> +		/*
> +		 * Login was not even sent out; so when getting out
> +		 * of this state, it will appear like a login retry
> +		 * after Clear virtual link
> +		 */
> +		break;
> +
>  	default:
>  		bfa_assert(0);
>  	}
> @@ -187,6 +197,15 @@ bfa_lps_sm_online(struct bfa_lps_s *lps, enum bfa_lps_event event)
>  		}
>  		break;
>  
> +	case BFA_LPS_SM_RX_CVL:
> +		bfa_sm_set_state(lps, bfa_lps_sm_init);
> +
> +		/* Let the vport module know about this event */
> +		bfa_lps_cvl_event(lps);
> +		bfa_plog_str(lps->bfa->plog, BFA_PL_MID_LPS,
> +			BFA_PL_EID_FIP_FCF_CVL, 0, "FCF Clear Virt. Link Rx");
> +		break;

OK, so you can't do this in the patch set, it causes a compile error:

drivers/scsi/bfa/bfa_lps.c: In function 'bfa_lps_sm_online':
drivers/scsi/bfa/bfa_lps.c:205: error: 'BFA_PL_MID_LPS' undeclared
(first use in this function)
drivers/scsi/bfa/bfa_lps.c:205: error: (Each undeclared identifier is
reported only once
drivers/scsi/bfa/bfa_lps.c:205: error: for each function it appears in.)
drivers/scsi/bfa/bfa_lps.c:206: error: 'BFA_PL_EID_FIP_FCF_CVL'
undeclared (first use in this function)

Because these constants aren't defined until PATCH 24.

To be bisectable, each patch can only depend on things in its
predecessor in the sequence.  Could you redo this so that everything is
bisectable?  (And add the signoffs this time so I don't have to do it by
hand).

Thanks,

James


