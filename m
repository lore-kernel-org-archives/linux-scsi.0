From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [scsi 3/4] scsi: ufs: ufshcd_get_max_icc_level fix endianity
 handling
Date: Tue, 10 Jan 2017 16:59:10 -0800
Message-ID: <a34d3dfc572a6a6e008e921ca752592e@codeaurora.org>
References: <1483605912-15041-1-git-send-email-tomas.winkler@intel.com>
 <1483605912-15041-3-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55394 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755619AbdAKA7L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jan 2017 19:59:11 -0500
In-Reply-To: <1483605912-15041-3-git-send-email-tomas.winkler@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 2017-01-05 00:45, Tomas Winkler wrote:
> Reading big endian value from a buffer requires explicit cast.
> Fix sparse warning:
> drivers/scsi/ufs/ufshcd.c:4825:24: warning: cast to restricted __be16
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 63d7ae2c3be9..fdea08f79b7d 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4822,7 +4822,7 @@ static u32 ufshcd_get_max_icc_level(int
> sup_curr_uA, u32 start_scan, char *buff)
>  	u16 unit;
> 
>  	for (i = start_scan; i >= 0; i--) {
> -		data = be16_to_cpu(*((u16 *)(buff + 2*i)));
> +		data = be16_to_cpup((__be16 *)&buff[2 * i]);
>  		unit = (data & ATTR_ICC_LVL_UNIT_MASK) >>
>  						ATTR_ICC_LVL_UNIT_OFFSET;
>  		curr_uA = data & ATTR_ICC_LVL_VALUE_MASK;


Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
