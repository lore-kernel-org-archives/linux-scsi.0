From: Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: Re: [Y2038] [PATCH 3/7] scsi: bfa: improve
 bfa_ioc_send_enable/disable data
Date: Mon, 13 Nov 2017 14:08:34 +0000
Message-ID: <1510582114.18523.3.camel@codethink.co.uk>
References: <20171110153715.1929456-1-arnd@arndb.de>
         <20171110153715.1929456-4-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171110153715.1929456-4-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: hare@suse.com, linux-scsi@vger.kernel.org, y2038@lists.linaro.org, linux-kernel@vger.kernel.org, jthumshirn@suse.de, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On Fri, 2017-11-10 at 16:37 +0100, Arnd Bergmann wrote:
> In bfa_ioc_send_enable, we use the deprecated do_gettimeofday() function
> to read the current time. This is not a problem, since the firmware
> interface is already limited to 32-bit timestamps, but it's better
> to use ktime_get_seconds() and document what the limitation is.
> 
> I noticed that I did the same change in commit a5af83925363 ("bna:
> avoid writing uninitialized data into hw registers") for the ethernet
> driver. That commit also changed the "disable" funtion to initialize
> the data we pass to the firmware properly, so I'm doing the same
> thing here.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/scsi/bfa/bfa_ioc.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
> index 256f4afaccf9..117332537763 100644
> --- a/drivers/scsi/bfa/bfa_ioc.c
> +++ b/drivers/scsi/bfa/bfa_ioc.c
> @@ -1809,13 +1809,12 @@ static void
>  bfa_ioc_send_enable(struct bfa_ioc_s *ioc)
>  {
>  	struct bfi_ioc_ctrl_req_s enable_req;
> -	struct timeval tv;
>  
>  	bfi_h2i_set(enable_req.mh, BFI_MC_IOC, BFI_IOC_H2I_ENABLE_REQ,
>  		    bfa_ioc_portid(ioc));
>  	enable_req.clscode = cpu_to_be16(ioc->clscode);
> -	do_gettimeofday(&tv);
> -	enable_req.tv_sec = be32_to_cpu(tv.tv_sec);
> +	/* unsigned 32-bit time_t overflow in y2106 */
> +	enable_req.tv_sec = be32_to_cpu(ktime_get_real_seconds());

The byte order conversion should also logically be cpu_to_be32(), not
be32_to_cpu().

Ben.

>  	bfa_ioc_mbox_send(ioc, &enable_req, sizeof(struct bfi_ioc_ctrl_req_s));
>  }
>  
> @@ -1826,6 +1825,9 @@ bfa_ioc_send_disable(struct bfa_ioc_s *ioc)
>  
>  	bfi_h2i_set(disable_req.mh, BFI_MC_IOC, BFI_IOC_H2I_DISABLE_REQ,
>  		    bfa_ioc_portid(ioc));
> +	disable_req.clscode = cpu_to_be16(ioc->clscode);
> +	/* unsigned 32-bit time_t overflow in y2106 */
> +	disable_req.tv_sec = be32_to_cpu(ktime_get_real_seconds());
>  	bfa_ioc_mbox_send(ioc, &disable_req, sizeof(struct bfi_ioc_ctrl_req_s));
>  }
>  
-- 
Ben Hutchings
Software Developer, Codethink Ltd.
