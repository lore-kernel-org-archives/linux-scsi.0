From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] Eliminate extra 'out_free' label from fcoe_init function
Date: Thu, 1 Jun 2017 18:02:33 +0300
Message-ID: <20170601150233.2j6lxormywlvu7fa@mwanda>
References: <a1ea0104-83ed-2249-3450-dc5c31517558@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17452 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751096AbdFAPCo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2017 11:02:44 -0400
Content-Disposition: inline
In-Reply-To: <a1ea0104-83ed-2249-3450-dc5c31517558@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Milan P. Gandhi" <mgandhi@redhat.com>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Laurence Oberman <loberman@redhat.com>

On Thu, Jun 01, 2017 at 05:41:06PM +0530, Milan P. Gandhi wrote:
> Simplify the check for return code of fcoe_if_init routine
> in fcoe_init function such that we could eliminate need for
> extra 'out_free' label.
> 
> Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
> ---
>  drivers/scsi/fcoe/fcoe.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index ea21e7b..fb2a4c9 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -2523,13 +2523,11 @@ static int __init fcoe_init(void)
>  	fcoe_dev_setup();
>  
>  	rc = fcoe_if_init();
> -	if (rc)
> -		goto out_free;
> -
> -	mutex_unlock(&fcoe_config_mutex);
> -	return 0;
> +	if (rc == 0) {
> +		mutex_unlock(&fcoe_config_mutex);
> +		return 0;
> +	}
>  
> -out_free:
>  	mutex_unlock(&fcoe_config_mutex);

Gar...  Stop!  No1  Don't do this.

Do failure handling, not success handling.

People always think they should get creative with the last if statement
in a function.  This leads to spaghetti code and it's confusing.  Please
never do this again.

The original is correct and the new code is bad rubbish code.

regards,
dan carpenter
