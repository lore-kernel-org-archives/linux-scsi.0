From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] libfc: introduce __fc_fill_fc_hdr that accepts fc_hdr
 as an argument
Date: Fri, 25 Feb 2011 11:53:04 -0500
Message-ID: <1298652784.2459.37.camel@mulgrave.site>
References: <1296787638.268.788.camel@LTLNR-SJCE10.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53129 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387Ab1BYQxK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 11:53:10 -0500
In-Reply-To: <1296787638.268.788.camel@LTLNR-SJCE10.corp.ad.broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Gollapudi <bprakash@broadcom.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "devel@open-fcoe.org" <devel@open-fcoe.org>, Mike Christie <michaelc@cs.wisc.edu>, robert.w.love@intel.com

On Thu, 2011-02-03 at 18:47 -0800, Bhanu Gollapudi wrote:
> fc_fill_fc_hdr() expects fc_frame as an argument. Introduce __fc_fill_fc_hdr to
> accept fc_frame_header as an argument.

Not sure you noticed this, Robert, but I need it to get the bnx2fc
driver compiling ... could you ack or send as part of the libfc updates?

Thanks,

James


> Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
> ---
>       include/scsi/fc_encode.h |   26 +++++++++++++++++---------
>  1 files changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/include/scsi/fc_encode.h b/include/scsi/fc_encode.h
> index 6d293c8..be418d8 100644
> --- a/include/scsi/fc_encode.h
> +++ b/include/scsi/fc_encode.h
> @@ -46,16 +46,11 @@ struct fc_ct_req {
>  	} payload;
>  };
>  
> -/**
> - * fill FC header fields in specified fc_frame
> - */
> -static inline void fc_fill_fc_hdr(struct fc_frame *fp, enum fc_rctl r_ctl,
> -				  u32 did, u32 sid, enum fc_fh_type type,
> -				  u32 f_ctl, u32 parm_offset)
> +static inline void __fc_fill_fc_hdr(struct fc_frame_header *fh,
> +				    enum fc_rctl r_ctl,
> +				    u32 did, u32 sid, enum fc_fh_type type,
> +				    u32 f_ctl, u32 parm_offset)
>  {
> -	struct fc_frame_header *fh;
> -
> -	fh = fc_frame_header_get(fp);
>  	WARN_ON(r_ctl == 0);
>  	fh->fh_r_ctl = r_ctl;
>  	hton24(fh->fh_d_id, did);
> @@ -68,6 +63,19 @@ static inline void fc_fill_fc_hdr(struct fc_frame *fp, enum fc_rctl r_ctl,
>  }
>  
>  /**
> + * fill FC header fields in specified fc_frame
> + */
> +static inline void fc_fill_fc_hdr(struct fc_frame *fp, enum fc_rctl r_ctl,
> +				  u32 did, u32 sid, enum fc_fh_type type,
> +				  u32 f_ctl, u32 parm_offset)
> +{
> +	struct fc_frame_header *fh;
> +
> +	fh = fc_frame_header_get(fp);
> +	__fc_fill_fc_hdr(fh, r_ctl, did, sid, type, f_ctl, parm_offset);
> +}
> +
> +/**
>   * fc_adisc_fill() - Fill in adisc request frame
>   * @lport: local port.
>   * @fp: fc frame where payload will be placed.


