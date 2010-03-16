From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/3] SCSI: be2iscsi, fix lock imbalance
Date: Tue, 16 Mar 2010 13:10:53 -0500
Message-ID: <4B9FC9AD.3000409@cs.wisc.edu>
References: <1268753039-17214-1-git-send-email-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1268753039-17214-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jirislaby@gmail.com, Jayamohan Kallickal <jayamohank@serverengines.com>
List-Id: linux-scsi@vger.kernel.org

On 03/16/2010 10:23 AM, Jiri Slaby wrote:
> Stanse found that one error path in mgmt_invalidate_icds omits to unlock
> ctrl->mbox_lock. Fix that.
>
> Added in 756d29c8c7ed8887ed7d752371ce2f (Enable async mode for mcc rings)
> where the spinlock was moved.
>
> Signed-off-by: Jiri Slaby<jslaby@suse.cz>
> Cc: Jayamohan Kallickal<jayamohank@serverengines.com>
> Cc: James Bottomley<James.Bottomley@suse.de>
> ---
>   drivers/scsi/be2iscsi/be_mgmt.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
> index 72617b6..e641922 100644
> --- a/drivers/scsi/be2iscsi/be_mgmt.c
> +++ b/drivers/scsi/be2iscsi/be_mgmt.c
> @@ -169,6 +169,7 @@ unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
>   		SE_DEBUG(DBG_LVL_1,
>   			 "Failed to allocate memory for"
>   			 "mgmt_invalidate_icds \n");
> +		spin_unlock(&ctrl->mbox_lock);
>   		return -1;
>   	}
>   	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);

Looks good.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
