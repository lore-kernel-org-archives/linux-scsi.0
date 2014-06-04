From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: bfa: bfad_attr.c:  Cleaning up missing
 null-terminate after strncpy call
Date: Wed, 04 Jun 2014 14:59:41 -0700
Message-ID: <1401919181.17510.36.camel@dabdike>
References: <1401917575-2954-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1401917575-2954-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-06-04 at 23:32 +0200, Rickard Strandqvist wrote:
> Added a guaranteed null-terminate after call to strncpy.
> 
> This was partly found using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/scsi/bfa/bfad_attr.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
> index 40be670..06aa3dd 100644
> --- a/drivers/scsi/bfa/bfad_attr.c
> +++ b/drivers/scsi/bfa/bfad_attr.c
> @@ -843,7 +843,8 @@ bfad_im_symbolic_name_show(struct device *dev, struct device_attribute *attr,
>  
>  	bfa_fcs_lport_get_attr(&bfad->bfa_fcs.fabric.bport, &port_attr);
>  	strncpy(symname, port_attr.port_cfg.sym_name.symname,
> -			BFA_SYMNAME_MAXLEN);
> +			sizeof(symname));
> +	symname[sizeof(symname) - 1] = '\0';

So actually, this isn't the correct pattern for this type of potential
problem, where the problem exists, the pattern is to replace strncpy()
with strlcpy() which does a correct null termination on truncation.

In this case I presume your static checker isn't sufficiently clever to
see that there isn't a bug because port_attr.port_cfg.sym_name.symname
is carefully copied to be NULL terminated and always less than
BFA_SYMNAME_MAXLEN, so when copying out of it we can rely on the NULL
termination fitting into BFA_SYMNAME_MAXLEN.

James
