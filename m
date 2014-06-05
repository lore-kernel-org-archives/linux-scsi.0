From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: bfa: bfad_attr.c:  Optimization of the Code
Date: Thu, 05 Jun 2014 08:55:59 +0200
Message-ID: <5390147F.8070803@acm.org>
References: <1401905288-32642-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1401905288-32642-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/04/14 20:08, Rickard Strandqvist wrote:
> Minimized the use of snprintf()
> And removed a variable that was only used for the temporary storage.
> 
> This was partly found using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/scsi/bfa/bfad_attr.c |   14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
> index 40be670..5f5917a 100644
> --- a/drivers/scsi/bfa/bfad_attr.c
> +++ b/drivers/scsi/bfa/bfad_attr.c
> @@ -839,12 +839,10 @@ bfad_im_symbolic_name_show(struct device *dev, struct device_attribute *attr,
>  			(struct bfad_im_port_s *) shost->hostdata[0];
>  	struct bfad_s *bfad = im_port->bfad;
>  	struct bfa_lport_attr_s port_attr;
> -	char symname[BFA_SYMNAME_MAXLEN];
>  
>  	bfa_fcs_lport_get_attr(&bfad->bfa_fcs.fabric.bport, &port_attr);
> -	strncpy(symname, port_attr.port_cfg.sym_name.symname,
> -			BFA_SYMNAME_MAXLEN);
> -	return snprintf(buf, PAGE_SIZE, "%s\n", symname);
> +	return snprintf(buf, PAGE_SIZE, "%s\n",
> +			port_attr.port_cfg.sym_name.symname);
>  }
>  
>  static ssize_t
> @@ -865,7 +863,9 @@ static ssize_t
>  bfad_im_drv_version_show(struct device *dev, struct device_attribute *attr,
>  				char *buf)
>  {
> -	return snprintf(buf, PAGE_SIZE, "%s\n", BFAD_DRIVER_VERSION);
> +	strncpy(buf, BFAD_DRIVER_VERSION  "\n" , PAGE_SIZE);
> +	buf[PAGE_SIZE - 1] = '\0';
> +	return strlen(buf);
>  }
>  
>  static ssize_t
> @@ -913,7 +913,9 @@ static ssize_t
>  bfad_im_drv_name_show(struct device *dev, struct device_attribute *attr,
>  				char *buf)
>  {
> -	return snprintf(buf, PAGE_SIZE, "%s\n", BFAD_DRIVER_NAME);
> +	strncpy(buf, BFAD_DRIVER_NAME  "\n" , PAGE_SIZE);
> +	buf[PAGE_SIZE - 1] = '\0';
> +	return strlen(buf);
>  }

This is ugly. Please use sprintf(buf, "%.*s\n", PAGE_SIZE - 1, str)
instead of strncpy() + strlen().

Bart.
