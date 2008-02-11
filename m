From: Pete Wyckoff <pw-pxmRpbKlMIQ@public.gmane.org>
Subject: Re: [PATCH 2/3] iscsi: bidi support - libiscsi
Date: Mon, 11 Feb 2008 10:43:09 -0500
Message-ID: <20080211154309.GA27183@osc.edu>
References: <47A20E85.6040906@panasas.com> <47A22FC4.2020804@panasas.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <47A22FC4.2020804-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi-help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi-unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Benny Halevy <bhalevy-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Daniel.E.Messinger-ShLqkCeKS0lBDgjK7y7TUQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org wrote on Thu, 31 Jan 2008 22:29 +0200:
>   iscsi bidi support at the generic libiscsi level
>   - prepare the additional bidi_read rlength header.
>   - access the right scsi_in() and/or scsi_out() side of things.
>     also for resid.
>   - Handle BIDI underflow overflow from target
> 
> Signed-off-by: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>

I see you do this a bit differently than in your previous patch set.
In particular, the residual handling in libiscsi.c.  (I'm editing in
a bit more context to the patch below.)

> +	if (scsi_bidi_cmnd(sc) &&
> +		(rhdr->flags & (ISCSI_FLAG_CMD_BIDI_UNDERFLOW |
> +					ISCSI_FLAG_CMD_BIDI_OVERFLOW))) {
> +		int res_count = be32_to_cpu(rhdr->bi_residual_count);
> +
> +		if (res_count > 0 &&
> +			(rhdr->flags & ISCSI_FLAG_CMD_BIDI_OVERFLOW ||
> +			res_count <= scsi_in(sc)->length))
> +			scsi_in(sc)->resid = res_count;
> +		else
> +			sc->result =
> +				(DID_BAD_TARGET << 16) | rhdr->cmd_status;
> +	}
> +
>  	if (rhdr->flags & (ISCSI_FLAG_CMD_UNDERFLOW |
>  	                   ISCSI_FLAG_CMD_OVERFLOW)) {
>  		int res_count = be32_to_cpu(rhdr->residual_count);
>
>  		if (res_count > 0 &&
>  		    (rhdr->flags & ISCSI_FLAG_CMD_OVERFLOW ||
>  		     res_count <= scsi_bufflen(sc)))
> +			/* write side for bidi or uni-io set_resid */
>  			scsi_set_resid(sc, res_count);
>  		else
>  			sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
>       } else if (rhdr->flags & (ISCSI_FLAG_CMD_BIDI_UNDERFLOW |
>                                 ISCSI_FLAG_CMD_BIDI_OVERFLOW))
>               sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;

I haven't tested this, but, consider a bidi command that results in
an overflow on the read part, and no overflow on the write part.
E.g., the user supplied a data-in buffer that wasn't big enough to
hold the returned data from the target, but the data-out buffer was
just right.

Then this code will set scsi_in(sc)->resid properly, informing the
caller that there were extra bytes that were not transferred.  But
the "else" clause at the bottom will also set sc->result to be bad.
I don't think we want this.

Your earlier patch got rid of the second bidi_overflow handler and
just did all the logic for both bidi and non-bidi cases in a single
if clause.  Seemed better.

		-- Pete
