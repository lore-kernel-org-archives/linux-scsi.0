From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 2/5] scsi: bfa: bfa_fcs_lport.c:  Cleaning up missing
 null-terminate by switching from strncpy to strzcpy
Date: Mon, 20 Oct 2014 18:37:07 +0300
Message-ID: <20141020153707.GX26918@mwanda>
References: <1413670390-6259-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1413670390-6259-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Andi Kleen <ak@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Oct 19, 2014 at 12:13:10AM +0200, Rickard Strandqvist wrote:
> Ensures that the string is null-terminate in connection with the
> use of strncpy, by switching from strncpy to strzcpy.
> 

I wish the changelogs were more clear that we have no reason to think
this is a real issue.

> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/scsi/bfa/bfa_fcs_lport.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
> index ff75ef8..78af89e 100644
> --- a/drivers/scsi/bfa/bfa_fcs_lport.c
> +++ b/drivers/scsi/bfa/bfa_fcs_lport.c
> @@ -2633,7 +2633,7 @@ bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_lport_fdmi_s *fdmi,
>  	strncpy(hba_attr->driver_version, (char *)driver_info->version,
>  		sizeof(hba_attr->driver_version));

Why do we not change this one?

>  
> -	strncpy(hba_attr->os_name, driver_info->host_os_name,
> +	strzcpy(hba_attr->os_name, driver_info->host_os_name,
>  		sizeof(hba_attr->os_name));

strlcpy() would also be totally safe here.  It's also safe for patch
patch 3 and patch 4.  Patch 5 is trickier to audit so I don't know if
strlcpy() is safe.

regards,
dan carpenter
