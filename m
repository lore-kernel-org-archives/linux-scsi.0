From: Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH] scsi: message: fusion: clean up clang warning on
 extraneous parentheses
Date: Sun, 30 Sep 2018 16:09:53 -0700
Message-ID: <20180930230953.GA12922@flashbox>
References: <20180930223123.17907-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180930223123.17907-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Sep 30, 2018 at 11:31:23PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There are extraneous parantheses that are causing clang to produce a
> warning so remove these. Also replace pointer comparison with NULL
> with the !ptr idiom.
> 
> Clean up clang warnings:
> equality comparison with extraneous parentheses [-Wparentheses-equality]
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/message/fusion/mptbase.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index dc1e43a02599..ba551d8dfba4 100644
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
>  		return -1;
>  
>  	pci_stop_and_remove_bus_device_locked(pdev);
> -- 
> 2.17.1
> 

Hi Colin,

I already sent a patch that was picked up by Martin a few days ago: https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?id=90ded4e2005b1195a5e781009be991e1cd049c10

I've been sending several warning fixes for Clang over the past few
weeks that have been documented on GitHub. You may consider checking
them out since I have started to see some overlap.

Link: https://github.com/ClangBuiltLinux/linux/issues

Cheers!
Nathan
