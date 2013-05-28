From: Vijaya Mohan Guvva Guvva <vmohan@Brocade.com>
Subject: RE: [PATCH 1/1] bfa: Fix for possible null pointer dereference
Date: Tue, 28 May 2013 03:29:04 -0600
Message-ID: <51BD2AE8016AE441B63F5661159C99020F1DF18A37@BRM-EXCH-3.corp.brocade.com>
References: <1369597877-3160-1-git-send-email-jakobnormark@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1369597877-3160-1-git-send-email-jakobnormark@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jakob Normark <jakobnormark@gmail.com>, Anil Gurumurthy <agurumur@Brocade.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Jakob Normark
> Sent: Monday, May 27, 2013 1:21 AM
> To: Anil Gurumurthy; Vijaya Mohan Guvva Guvva; James E.J. Bottomley
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Jakob Normark
> Subject: [PATCH 1/1] bfa: Fix for possible null pointer dereference
> 
> Fix for cppcheck error in bfa_fcs_lport.c
> 
> Kernel version: v3.10-rc2
> 
> Signed-off-by: Jakob Normark <jakobnormark@gmail.com>
> ---
>  drivers/scsi/bfa/bfa_fcs_lport.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
> index 1224d04..a37c45a 100644
> --- a/drivers/scsi/bfa/bfa_fcs_lport.c
> +++ b/drivers/scsi/bfa/bfa_fcs_lport.c
> @@ -5615,13 +5615,14 @@
> bfa_fcs_lport_get_rport_max_speed(bfa_fcs_lport_t *port)
>  	bfa_port_speed_t max_speed = 0;
>  	struct bfa_port_attr_s port_attr;
>  	bfa_port_speed_t port_speed, rport_speed;
> -	bfa_boolean_t trl_enabled = bfa_fcport_is_ratelim(port->fcs->bfa);
> +	bfa_boolean_t trl_enabled;
> 
> 
>  	if (port == NULL)
>  		return 0;
> 
>  	fcs = port->fcs;
> +	trl_enabled = bfa_fcport_is_ratelim(port->fcs->bfa);
> 
>  	/* Get Physical port's current speed */
>  	bfa_fcport_get_attr(port->fcs->bfa, &port_attr);
> --
> 1.7.9.5
> 
> --

Changes looks good. Thanks for the patch.
Acked-by: Vijay Mohan Guvva <vmohan@brocade.com>
