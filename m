From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 02/28] drivers/scsi/aic7xxx/: possible cleanups
Date: Wed, 8 Mar 2006 05:22:18 -0700
Message-ID: <20060308122218.GH7301@parisc-linux.org>
References: <200603080816.k288G72x002153@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:44506 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S932510AbWCHMWS
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Mar 2006 07:22:18 -0500
Content-Disposition: inline
In-Reply-To: <200603080816.k288G72x002153@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, bunk@stusta.de

On Wed, Mar 08, 2006 at 12:14:18AM -0800, akpm@osdl.org wrote:
> From: Adrian Bunk <bunk@stusta.de>
> 
> - make needlessly global code static
> 
> - #if 0 the following unused global functions:
>   - aic79xx_core.c: ahd_print_scb
>   - aic79xx_core.c: ahd_suspend
>   - aic79xx_core.c: ahd_resume
>   - aic79xx_core.c: ahd_dump_scbs
>   - aic79xx_osm.c: ahd_softc_comp
> 
>  
> @@ -155,7 +155,7 @@ typedef enum {
>  	AHDMSG_1B,
>  	AHDMSG_2B,
>  	AHDMSG_EXT
> -} ahd_msgtype;
> +	} ahd_msgtype;
>  static int		ahd_sent_msg(struct ahd_softc *ahd, ahd_msgtype type,
>  				     u_int msgval, int full);
>  static int		ahd_parse_msg(struct ahd_softc *ahd,

 - Introduces  some  wrong  whitespace  changes

> @@ -238,10 +238,33 @@ static int		ahd_handle_target_cmd(struct
>  					      struct target_cmd *cmd);
>  #endif
>  
> +static int		ahd_abort_scbs(struct ahd_softc *ahd, int target,
> +				       char channel, int lun, u_int tag,
> +				       role_t role, uint32_t status);

 - prototypes some functions, while ...

> @@ -295,11 +318,44 @@ ahd_set_active_fifo(struct ahd_softc *ah
>  	}
>  }
>  
> +static __inline void
> +ahd_unbusy_tcl(struct ahd_softc *ahd, u_int tcl)
> +{
> +	ahd_busy_tcl(ahd, tcl, SCB_LIST_NULL);
> +}
> +
> +/*
> + * Determine whether the sequencer reported a residual
> + * for this SCB/transaction.
> + */
> +static __inline void
> +ahd_update_residual(struct ahd_softc *ahd, struct scb *scb)
> +{
> +	uint32_t sgptr;
> +
> +	sgptr = ahd_le32toh(scb->hscb->sgptr);
> +	if ((sgptr & SG_STATUS_VALID) != 0)
> +		ahd_calc_residual(ahd, scb);
> +}
> +
> +static __inline void
> +ahd_complete_scb(struct ahd_softc *ahd, struct scb *scb)
> +{
> +	uint32_t sgptr;
> +
> +	sgptr = ahd_le32toh(scb->hscb->sgptr);
> +	if ((sgptr & SG_STATUS_VALID) != 0)
> +		ahd_handle_scb_status(ahd, scb);
> +	else
> +		ahd_done(ahd, scb);
> +}
> +
> +

 - ... moving others around.  Consistency?

