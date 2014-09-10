From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 01/21] uas: replace WARN_ON_ONCE() with lockdep_assert_held()
Date: Wed, 10 Sep 2014 13:48:51 +0200
Message-ID: <54103AA3.7000801@redhat.com>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com> <1410349611-17573-2-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436AbaIJLs4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2014 07:48:56 -0400
In-Reply-To: <1410349611-17573-2-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Sanjeev Sharma <Sanjeev_Sharma@mentor.com>

Hi,

Note this series is NOT intended for stable, but I accidentally
had "cc = stable@vger.kernel.org" in my .git/config when sending
this series, please ignore for stable.

NACK for stable.

Sorry & Regards,

Hans


On 09/10/2014 01:46 PM, Hans de Goede wrote:
> From: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
> 
> On some architecture spin_is_locked() always return false in
> uniprocessor configuration and therefore it would be advise to replace
> with lockdep_assert_held().
> 
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/usb/storage/uas.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 3f42785..05b2d8e 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -154,7 +154,7 @@ static void uas_mark_cmd_dead(struct uas_dev_info *devinfo,
>  	struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd, SCp);
>  
>  	uas_log_cmd_state(cmnd, caller);
> -	WARN_ON_ONCE(!spin_is_locked(&devinfo->lock));
> +	lockdep_assert_held(&devinfo->lock);
>  	WARN_ON_ONCE(cmdinfo->state & COMMAND_ABORTED);
>  	cmdinfo->state |= COMMAND_ABORTED;
>  	cmdinfo->state &= ~IS_IN_WORK_LIST;
> @@ -181,7 +181,7 @@ static void uas_add_work(struct uas_cmd_info *cmdinfo)
>  	struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd, SCp);
>  	struct uas_dev_info *devinfo = cmnd->device->hostdata;
>  
> -	WARN_ON_ONCE(!spin_is_locked(&devinfo->lock));
> +	lockdep_assert_held(&devinfo->lock);
>  	cmdinfo->state |= IS_IN_WORK_LIST;
>  	schedule_work(&devinfo->work);
>  }
> @@ -283,7 +283,7 @@ static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
>  	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
>  	struct uas_dev_info *devinfo = (void *)cmnd->device->hostdata;
>  
> -	WARN_ON_ONCE(!spin_is_locked(&devinfo->lock));
> +	lockdep_assert_held(&devinfo->lock);
>  	if (cmdinfo->state & (COMMAND_INFLIGHT |
>  			      DATA_IN_URB_INFLIGHT |
>  			      DATA_OUT_URB_INFLIGHT |
> @@ -622,7 +622,7 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
>  	struct urb *urb;
>  	int err;
>  
> -	WARN_ON_ONCE(!spin_is_locked(&devinfo->lock));
> +	lockdep_assert_held(&devinfo->lock);
>  	if (cmdinfo->state & SUBMIT_STATUS_URB) {
>  		urb = uas_submit_sense_urb(cmnd, gfp, cmdinfo->stream);
>  		if (!urb)
> 
