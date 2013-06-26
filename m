From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] bfa: Fixes for 0-terminated strncpy and possible
 null pointer dereference
Date: Wed, 26 Jun 2013 08:37:25 -0700
Message-ID: <1372261045.2168.33.camel@dabdike>
References: <1368646911-22620-1-git-send-email-jakobnormark@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1368646911-22620-1-git-send-email-jakobnormark@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jakob Normark <jakobnormark@gmail.com>
Cc: Anil Gurumurthy <agurumur@brocade.com>, Vijaya Mohan Guvva <vmohan@brocade.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-05-15 at 21:41 +0200, Jakob Normark wrote:
> This patch fixes two cppcheck errors in drivers/scsi/bfa/bfad_im.c
> 
> Signed-off-by: Jakob Normark <jakobnormark@gmail.com>
> ---
>  drivers/scsi/bfa/bfad_im.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
> index 5864f98..9489c56 100644
> --- a/drivers/scsi/bfa/bfad_im.c
> +++ b/drivers/scsi/bfa/bfad_im.c
> @@ -944,13 +944,15 @@ static int
>  bfad_im_slave_alloc(struct scsi_device *sdev)
>  {
>  	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
> -	struct bfad_itnim_data_s *itnim_data =
> -				(struct bfad_itnim_data_s *) rport->dd_data;
> -	struct bfa_s *bfa = itnim_data->itnim->bfa_itnim->bfa;
> +	struct bfad_itnim_data_s *itnim_data;
> +	struct bfa_s *bfa;
>  
>  	if (!rport || fc_remote_port_chkready(rport))
>  		return -ENXIO;
>  
> +	itnim_data = (struct bfad_itnim_data_s *) rport->dd_data;
> +	bfa = itnim_data->itnim->bfa_itnim->bfa;
> +
>  	if (bfa_get_lun_mask_status(bfa) == BFA_LUNMASK_ENABLED) {
>  		/*
>  		 * We should not mask LUN 0 - since this will translate
> @@ -1037,6 +1039,7 @@ bfad_fc_host_init(struct bfad_im_port_s *im_port)
>  
>  	strncpy(symname, bfad->bfa_fcs.fabric.bport.port_cfg.sym_name.symname,
>  		BFA_SYMNAME_MAXLEN);
> +	symname[BFA_SYMNAME_MAXLEN - 1] = '\0';

This isn't correct, it's effectively a handrolled version of strlcpy.
The correct fix is to replace strncpy with strlcpy.  I fixed it up in
the patch version.

James
