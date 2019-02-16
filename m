From: Walter Harms <wharms@bfs.de>
Subject: Re: [PATCH] scsi: mvumi: fix 32 bit shift of a 32 bit unsigned int
Date: Sat, 16 Feb 2019 17:27:16 +0100 (CET)
Message-ID: <1596625925.142066.1550334436646@ox-groupware.bfs.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Jianyun Li <jyli@marvell.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Am 16.02.2019 15:44, schrieb Colin King:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently m_sg->baseaddr_h (a 32 bit unsigned int) is being shifted by a
> total of 32 bits; this always produces a 0 result.  Fix this by casting
> it to a dma_addr_t (a 64 bit unsigned int) before performing the shift.
> 
> Detected by CoverityScan, CID#147270 ("Operands don't affect result")
> 
> Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/mvumi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 36f64205ecfa..d3582accfd09 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
> @@ -313,7 +313,7 @@ static void mvumi_delete_internal_cmd(struct mvumi_hba
> *mhba,
>  			sgd_getsz(mhba, m_sg, size);
>  
>  			phy_addr = (dma_addr_t) m_sg->baseaddr_l |
> -				(dma_addr_t) ((m_sg->baseaddr_h << 16) << 16);
> +				(((dma_addr_t) m_sg->baseaddr_h << 16) << 16);
>  
>  			dma_free_coherent(&mhba->pdev->dev, size, cmd->data_buf,
>  								phy_addr);

i would suggest to try a version with less casts to make it more readable
like this untested suggestion:

phy_addr =(m_sg->baseaddr_h << 16)| m_sg->baseaddr_l;
phy_addr <<= 16;


just my 2 cents,
re,
 wh
