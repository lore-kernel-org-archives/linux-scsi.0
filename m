From: Robert Love <robert.w.love@intel.com>
Subject: Re: [PATCH] thaw FC local port
Date: Thu, 16 Dec 2010 15:18:41 -0800
Message-ID: <1292541521.1346.20.camel@fritz>
References: <AANLkTi=4waDVnmLg9VRvrwRej+TLe4KGsL58XdWdG091@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54204 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab0LPXSm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Dec 2010 18:18:42 -0500
In-Reply-To: <AANLkTi=4waDVnmLg9VRvrwRej+TLe4KGsL58XdWdG091@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>
Cc: "devel@open-fcoe.org" <devel@open-fcoe.org>, Joe Eykholt <jeykholt@cisco.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2010-12-16 at 08:07 -0800, Hillf Danton wrote:
> The state machine of local port is freezed if it could not get ready,
> so thawing is necessary.
> 
Please start putting a prefix "fcoe: ", "libfc: " or "libfcoe: " on your
patch titles. Also, please provide more meaningful commit messages. I
believe that I've pointed out these two issues with your patches before.

> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/drivers/scsi/libfc/fc_lport.c	2010-11-01 19:54:12.000000000 +0800
> +++ b/drivers/scsi/libfc/fc_lport.c	2010-12-17 00:08:06.000000000 +0800
> @@ -1514,11 +1514,11 @@ void fc_lport_enter_flogi(struct fc_lpor
> 
>  	fc_lport_state_enter(lport, LPORT_ST_FLOGI);
> 
> -	if (lport->point_to_multipoint) {
> -		if (lport->port_id)
> +	if (lport->point_to_multipoint)
> +		if (lport->port_id) {
>  			fc_lport_enter_ready(lport);
> -		return;
> -	}
> +			return;
> +		}
> 
>  	fp = fc_frame_alloc(lport, sizeof(struct fc_els_flogi));
>  	if (!fp)

We do not want to proceed with sending a FLOGI here when we're in
point-to-multipoint (VN2VN) mode. VN2VN is a mode where there is no
fabric and we FLOGI directly into the remote port. So for VN2VN the
FLOGI happens in the rport layer.

//Rob

