From: Varun Prakash <varun@chelsio.com>
Subject: Re: [PATCH] scsi: csiostor: avoid null pointer dereference on
 card_fw allocation failure
Date: Thu, 2 Aug 2018 20:23:41 +0530
Message-ID: <20180802145339.GA1671@chelsio.com>
References: <20180801161743.22301-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180801161743.22301-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 01, 2018 at 05:17:43PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently if card_fw fails to be allocated then a null pointer
> dereference occurs on card_fd when calling csio_hw_prep_fw. Fix this
> by checking for a failed allocation and returning -ENOMEM.
> 
> Detected by CoverityScan, CID#1271213 ("Dereference null return value")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/csiostor/csio_hw.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
> index a10cf25ee7f9..aa637e9ea9ba 100644
> --- a/drivers/scsi/csiostor/csio_hw.c
> +++ b/drivers/scsi/csiostor/csio_hw.c
> @@ -2275,8 +2275,8 @@ static int csio_hw_prep_fw(struct csio_hw *hw, struct fw_info *fw_info,
>  }
>  
>  /*
> - * Returns -EINVAL if attempts to flash the firmware failed
> - * else returns 0,
> + * Returns -EINVAL if attempts to flash the firmware failed,
> + * -ENOMEM if allocation failed, else returns 0,
>   * if flashing was not attempted because the card had the
>   * latest firmware ECANCELED is returned
>   */
> @@ -2321,6 +2321,8 @@ csio_hw_flash_fw(struct csio_hw *hw, int *reset)
>  	 * card
>  	 */
>  	card_fw = kmalloc(sizeof(*card_fw), GFP_KERNEL);
> +	if (!card_fw)
> +		return -ENOMEM;
>  
>  	/* upgrade FW logic */
>  	ret = csio_hw_prep_fw(hw, fw_info, fw_data, fw_size, card_fw,

There is a call to release_firmware() after csio_hw_prep_hw()

        /* upgrade FW logic */
        ret = csio_hw_prep_fw(hw, fw_info, fw_data, fw_size, card_fw,
                         hw->fw_state, reset);

        /* Cleaning up */
        if (fw != NULL)
                release_firmware(fw);

In case of memory allocation failure csio_hw_flash_fw() will return without
calling release_firmware() with this patch.

Following patch fixes this issue  

csio_hw_flash_fw(struct csio_hw *hw, int *reset)
                return -EINVAL;
        }

+       /* allocate memory to read the header of the firmware on the
+        * card
+        */
+       card_fw = kmalloc(sizeof(*card_fw), GFP_KERNEL);
+       if (!card_fw)
+               return -ENOMEM;
+
        if (csio_is_t5(pci_dev->device & CSIO_HW_CHIP_MASK))
                fw_bin_file = FW_FNAME_T5;
        else
csio_hw_flash_fw(struct csio_hw *hw, int *reset)
                fw_size = fw->size;
        }

-       /* allocate memory to read the header of the firmware on the
-        * card
-        */
-       card_fw = kmalloc(sizeof(*card_fw), GFP_KERNEL);
-
        /* upgrade FW logic */
        ret = csio_hw_prep_fw(hw, fw_info, fw_data, fw_size, card_fw,
                         hw->fw_state, reset);
