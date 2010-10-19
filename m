From: "Zou, Yi" <yi.zou@intel.com>
Subject: RE: [Open-FCoE] [PATCH] libfc: fix handling of fc frame in
	fc_exch_recv_bls()
Date: Tue, 19 Oct 2010 08:00:18 -0700
Message-ID: <7C88852EF6F99F4EB538472FCFEBE2220146CC7FC7@orsmsx509.amr.corp.intel.com>
References: <AANLkTikQYBNsV2vbAfG+xe+ruJq+vfFTvJPOMUXAApXT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:33068 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab0JSPAW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Oct 2010 11:00:22 -0400
In-Reply-To: <AANLkTikQYBNsV2vbAfG+xe+ruJq+vfFTvJPOMUXAApXT@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>, "devel@open-fcoe.org" <devel@open-fcoe.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> 
> There seems that fp should get freed if exch is unavailable.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/drivers/scsi/libfc/fc_exch.c	2010-09-13 07:07:38.000000000 +0800
> +++ b/drivers/scsi/libfc/fc_exch.c	2010-10-19 21:35:08.000000000 +0800
> @@ -1564,8 +1564,11 @@ static void fc_exch_recv_bls(struct fc_e
>  				fc_frame_free(fp);
>  			break;
>  		case FC_RCTL_BA_ABTS:
> -			fc_exch_recv_abts(ep, fp);
> -			break;
> +			if (ep) {
> +				fc_exch_recv_abts(ep, fp);
> +				break;
> +			}
> +			/* fall thru */
>  		default:			/* ignore junk */
>  			fc_frame_free(fp);
>  			break;

No, fc_exch_recv_abts() already checks ep at its very beginning and gets
freed there.

yi
