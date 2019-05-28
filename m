From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH] scsi: ufs: Check that space was properly alloced in
 copy_query_response
Date: Tue, 28 May 2019 09:37:38 +0530
Message-ID: <cd9f0d7b-8ce6-e432-e1df-c4316b191156@samsung.com>
References: <CGME20190521082527epcas1p44fe0c4659549ae265c9d59ef7844e57e@epcas1p4.samsung.com>
        <1558427062-5084-1-git-send-email-avri.altman@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1558427062-5084-1-git-send-email-avri.altman@wdc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Avri Altman <avri.altman@wdc.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Evan Green <evgreen@chromium.org>, Bean Huo <beanhuo@micron.com>, Pedro Sousa <pedrom.sousa@synopsys.com>
Cc: Avi Shchislowski <avi.shchislowski@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Hi Avri

On 5/21/19 1:54 PM, Avri Altman wrote:
> struct ufs_dev_cmd is the main container that supports device management
> commands. In the case of a read descriptor request, we assume that the
> proper space was allocated in dev_cmd to hold the returning descriptor.
> 
> This is no longer true, as there are flows that doesn't use dev_cmd
> for device management requests, and was wrong in the first place.
> 
Can you please put some light on those flows? Are those platform 
specific? Just curious.
> fixes: d44a5f98bb49 (ufs: query descriptor API)
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>   drivers/scsi/ufs/ufshcd.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 8c1c551..3fe3029 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1917,7 +1917,8 @@ int ufshcd_copy_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>   	memcpy(&query_res->upiu_res, &lrbp->ucd_rsp_ptr->qr, QUERY_OSF_SIZE);
>   
>   	/* Get the descriptor */
> -	if (lrbp->ucd_rsp_ptr->qr.opcode == UPIU_QUERY_OPCODE_READ_DESC) {
> +	if (hba->dev_cmd.query.descriptor &&
> +	    lrbp->ucd_rsp_ptr->qr.opcode == UPIU_QUERY_OPCODE_READ_DESC) {
>   		u8 *descp = (u8 *)lrbp->ucd_rsp_ptr +
>   				GENERAL_UPIU_REQUEST_SIZE;
>   		u16 resp_len;
> 
This change looks ok to me. I hope you have tested this patch.
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
