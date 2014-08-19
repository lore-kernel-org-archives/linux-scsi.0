From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
Subject: RE: [PATCH v3] uas: replace WARN_ON_ONCE() with
 lockdep_assert_held()
Date: Tue, 19 Aug 2014 06:33:04 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE94DF2FDA2@EU-MBX-02.mgc.mentorg.com>
References: <yes>
 <1407825621-23322-1-git-send-email-sanjeev_sharma@mentor.com>
 <53E9B418.3050303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "kraxel@redhat.com" <kraxel@redhat.com>, "mdharm-usb@one-eyed-alien.net" <mdharm-usb@one-eyed-alien.net>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi Greg,

Any feedback on this patch ?

Regards
Sanjeev Sharma

-----Original Message-----
From: Sharma, Sanjeev 
Sent: Tuesday, August 12, 2014 12:07 PM
To: 'Hans de Goede'
Cc: gregkh@linuxfoundation.org; kraxel@redhat.com; mdharm-usb@one-eyed-alien.net; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org
Subject: RE: [PATCH v3] uas: replace WARN_ON_ONCE() with lockdep_assert_held()

Yes I have incorporated review comment from Greg.

Regards
Sanjeev Sharma

-----Original Message-----
From: Hans de Goede [mailto:hdegoede@redhat.com]
Sent: Tuesday, August 12, 2014 11:59 AM
To: Sharma, Sanjeev
Cc: gregkh@linuxfoundation.org; kraxel@redhat.com; mdharm-usb@one-eyed-alien.net; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3] uas: replace WARN_ON_ONCE() with lockdep_assert_held()

Hi,

On 08/12/2014 08:40 AM, Sanjeev Sharma wrote:
> on some architecture spin_is_locked() always return false in 
> uniprocessor configuration and therefore it would be advise to replace 
> with lockdep_assert_held().
> 
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
> ---
> Changes in v3:
>  incorporated review comment suggested by Greg

Thanks, this is still:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans

> 
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
