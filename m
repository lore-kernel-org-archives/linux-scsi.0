From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v5 5/8] char: rpmb: add RPMB simulation device
Date: Wed, 31 Aug 2016 12:57:08 +0200
Message-ID: <20160831105708.GD10180@kroah.com>
References: <1468873673-21776-1-git-send-email-tomas.winkler@intel.com>
 <1468873673-21776-6-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-mmc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1468873673-21776-6-git-send-email-tomas.winkler@intel.com>
Sender: linux-mmc-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 18, 2016 at 11:27:50PM +0300, Tomas Winkler wrote:
> This is a simple platform device used for testing
> the RPMB subsystem.
> 
> The module currently supports two configuration options:
> 1. max_wr_blks: for specifying max blocks that can be written
> in a single command
> 2. daunits:  used to set storage capacity in 128K units.
> 
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
> V2: remove .owner setting, it is set automatically
> V3: 1. Add shutdown handler (similar to ufshcd)
>     2. Commit message fix
> V4: Use select RPMB in Kconfg to ensure valid configuration.
> V5: Revamp the code using the sequence command.
> 
>  drivers/char/rpmb/Kconfig    |  10 +
>  drivers/char/rpmb/Makefile   |   1 +
>  drivers/char/rpmb/rpmb_sim.c | 668 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 679 insertions(+)
>  create mode 100644 drivers/char/rpmb/rpmb_sim.c
> 
> diff --git a/drivers/char/rpmb/Kconfig b/drivers/char/rpmb/Kconfig
> index 6794be9fcc5e..c21b3934249f 100644
> --- a/drivers/char/rpmb/Kconfig
> +++ b/drivers/char/rpmb/Kconfig
> @@ -13,3 +13,13 @@ config RPMB_INTF_DEV
>  	help
>  	  Say yes here if you want to access RPMB from user space
>  	  via character device interface /dev/rpmb%d
> +
> +
> +config RPMB_SIM
> +	tristate "RPMB partition device simulator"
> +	default n
> +	select RPMB
> +	select CRYPTO_SHA256
> +	select CRYPTO_HMAC
> +	help
> +	  RPMB partition simulator used for testing the RPMB subsystem

Hm, that's very vague, why would I want this?  Not want this?  Please
provide more information here.

thanks,

greg k-h
