From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: Re: [PATCH 8/8] scsi: ufs: connect to RPMB subsystem
Date: Mon, 4 Apr 2016 11:32:01 +0100
Message-ID: <570242A1.6020501@synopsys.com>
References: <1459676572-29921-1-git-send-email-tomas.winkler@intel.com>
 <1459676572-29921-9-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <1459676572-29921-9-git-send-email-tomas.winkler@intel.com>
Sender: linux-mmc-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>, gregkh@linuxfoundation.org, Ulf Hansson <ulf.hansson@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, Joao Pinto <Joao.Pinto@synopsys.com>, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander Usyskin <alexander.usyskin@intel.com>
List-Id: linux-scsi@vger.kernel.org


Hi!

On 4/3/2016 10:42 AM, Tomas Winkler wrote:
> Register UFS RPMB LUN with the RPMB subsystem and provide
> implementation for the RPMB access operations. RPMB partition is
> accessed via a sequence of security protocol in and security protocol
> out commands with UFS specific parameters. This multi step process is
> abstracted into 4 basic RPMB commands.
> 
> Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 219 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.h |   2 +
>  2 files changed, 221 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index f8fa72c31a9d..c087e9713db3 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -37,10 +37,13 @@
>   * license terms, and distributes only under these terms.
>   */
>  

[snip]

>  	scsi_remove_host(hba->host);
>  	/* disable interrupts */
>  	ufshcd_disable_intr(hba, hba->intr_mask);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 4bb65669f052..92bfddf80ae8 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -346,6 +346,7 @@ struct ufs_init_prefetch {
>   * @utmrdl_dma_addr: UTMRDL DMA address
>   * @host: Scsi_Host instance of the driver
>   * @dev: device handle
> + * @sdev_ufs_rpmb: reference to RPMB device W-LU
>   * @lrb: local reference block
>   * @lrb_in_use: lrb in use
>   * @outstanding_tasks: Bits representing outstanding task requests
> @@ -408,6 +409,7 @@ struct ufs_hba {
>  	 * "UFS device" W-LU.
>  	 */
>  	struct scsi_device *sdev_ufs_device;
> +	struct scsi_device *sdev_ufs_rpmb;
>  
>  	enum ufs_dev_pwr_mode curr_dev_pwr_mode;
>  	enum uic_link_state uic_link_state;
> 

I saw some kbuild robot issues regarding the patchset, so I would suggest you
make a v2 of the patch set and I can run some tests with the DW UFS Host design.

Thanks.
Joao
