From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH v2 RESEND 05/23] csiostor: Remove superfluous call to
 pci_disable_msix()
Date: Sat, 26 Jul 2014 09:13:12 +0100
Message-ID: <20140726081311.GC21129@agordeev.usersys.redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
 <bd849e403573b161beb4dcfdb7d410f997c95562.1405533479.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bd849e403573b161beb4dcfdb7d410f997c95562.1405533479.git.agordeev@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Naresh Kumar Inna <naresh@chelsio.com>, Arvind Bhushan <arvindb@chelsio.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 16, 2014 at 08:05:09PM +0200, Alexander Gordeev wrote:
> There is no need to call pci_disable_msix() in case
> the previous call to pci_enable_msix() failed

Hi Naresh, Arvind,

Could you please review csiostor patches in this series?

Thanks!

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Naresh Kumar Inna <naresh@chelsio.com>
> Cc: Arvind Bhushan <arvindb@chelsio.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/scsi/csiostor/csio_isr.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/csiostor/csio_isr.c b/drivers/scsi/csiostor/csio_isr.c
> index 7ee9777..91ba91d 100644
> --- a/drivers/scsi/csiostor/csio_isr.c
> +++ b/drivers/scsi/csiostor/csio_isr.c
> @@ -529,10 +529,8 @@ csio_enable_msix(struct csio_hw *hw)
>  			csio_reduce_sqsets(hw, cnt - extra);
>  		}
>  	} else {
> -		if (rv > 0) {
> -			pci_disable_msix(hw->pdev);
> +		if (rv > 0)
>  			csio_info(hw, "Not using MSI-X, remainder:%d\n", rv);
> -		}
>  
>  		kfree(entries);
>  		return -ENOMEM;
> -- 
> 1.7.7.6
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
