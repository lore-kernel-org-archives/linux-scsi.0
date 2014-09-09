From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH] drivers: target: target_core_transport.c: build warning
Date: Tue, 9 Sep 2014 13:02:27 +0530
Message-ID: <20140909073227.GB11332@sudip-PC>
References: <1410247430-11293-1-git-send-email-sudipm.mukherjee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1410247430-11293-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 09, 2014 at 12:53:50PM +0530, Sudip Mukherjee wrote:
> build is giving : 
> warning: passing argument 1 of 'strlen' makes pointer from integer 
> without a cast [enabled by default]
> 
> the snprintf after the strlen is trying to put the "Unsupported" string
> at the end of exising string. so len should give the string length here
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
>  drivers/target/target_core_transport.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 1dd1181..3ce85ed 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -953,7 +953,7 @@ int transport_dump_vpd_ident_type(
>  		strlcat(buf, "SCSI name string\n", sizeof(buf));
>  		break;
>  	default:
> -		len = strlen(len);
> +		len = strlen(buf);
>  		snprintf(&buf[len], sizeof(buf) - len, "Unsupported: 0x%02x\n",
>  				vpd->device_identifier_type);
>  		ret = -EINVAL;
> -- 
> 1.8.1.2
> 

please discard this patch. This is based on next-20140908 , and the
issue has been corrected in next-20140909.

thanks
sudip
