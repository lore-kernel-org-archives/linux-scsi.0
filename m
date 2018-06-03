From: Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH] message: fusion: Remove extra parentheses
Date: Sun, 3 Jun 2018 11:31:45 +0000
Message-ID: <20180603113145.GA6348@osadl.at>
References: <20180603110307.4080-1-rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180603110307.4080-1-rvarsha016@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, Jun 03, 2018 at 04:33:07PM +0530, Varsha Rao wrote:
> To fix clang warning of extraneous parentheses and check patch issue,
> remove extra parentheses and replace x == NULL with !x. Following
> coccinelle script is used to fix it.
> 
> @disable is_null,paren@
> expression e;
> statement s;
> @@
> if (
> - (e==NULL)
> +!e
>  )
> s
> 
> Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
Reviewed-by: Nicholas Mc Guire <der.herr@hofr.at>

> ---
>  drivers/message/fusion/mptbase.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index 51eb1b027963..3fe53b65c5fa 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -335,11 +335,11 @@ static int mpt_remove_dead_ioc_func(void *arg)
>  	MPT_ADAPTER *ioc = (MPT_ADAPTER *)arg;
>  	struct pci_dev *pdev;
>  
> -	if ((ioc == NULL))
> +	if (!ioc)
>  		return -1;
>  
>  	pdev = ioc->pcidev;
> -	if ((pdev == NULL))
> +	if (!pdev)

This is of course equivalent - but note that in mptbase.c the "style"
== NULL is used in other places as well - so maybe it would be good to
change those as well or leave the == NULL in place for readability reasons.

>  		return -1;
>  
>  	pci_stop_and_remove_bus_device_locked(pdev);
> -- 
> 2.17.0
> 
