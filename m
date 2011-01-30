From: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: [PATCH 7/8] sr: implement sr_check_events()
Date: Sun, 30 Jan 2011 01:26:22 +0000
Message-ID: <4D44BE3E.5080107@simon.arlott.org.uk>
References: <1291838262-21274-1-git-send-email-tj@kernel.org> <1291838262-21274-8-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1291838262-21274-8-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, jack@suse.cz, James.Bottomley@HansenPartnership.com
List-Id: linux-scsi@vger.kernel.org

On 08/12/10 19:57, Tejun Heo wrote:
> Replace sr_media_change() with sr_check_events().  It normally only
> uses GET_EVENT_STATUS_NOTIFICATION to check both media change and
> eject request.  If @clearing includes DISK_EVENT_MEDIA_CHANGE, it
> issues TUR and compares whether media presence has changed.  The SCSI
> specific media change uevent is kept for compatibility.
> 
> sr_media_change() was doing both media change check and revalidation.
> The revalidation part is split into sr_block_revalidate_disk().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> ---
>  drivers/scsi/sr.c   |  147 +++++++++++++++++++++++++++++++++------------------
>  drivers/scsi/sr.h   |    2 +-
>  include/scsi/scsi.h |    1 +
>  3 files changed, 98 insertions(+), 52 deletions(-)

This breaks growisofs:
:-( /dev/dvd: CD_ROM_MEDIA_CHANGED ioctl failed: Inappropriate ioctl for device

SR_CAPABILITIES in sr.c includes CDC_MEDIA_CHANGED but cdrom.c removes
this capability in register_cdrom because there is no media_changed op:
	ENSURE(media_changed, CDC_MEDIA_CHANGED);

The ioctl function cdrom_ioctl_media_changed() then returns -ENOSYS.

The media_changed() function again checks this capability but never uses
the media_changed op if the check_events op exists.

The cdrom_media_changed() function requires the media_changed op but
then calls media_changed().

It looks like cdrom_select_disc() is going to dereference the NULL
media_changed pointer if both check_events and media_changed don't
exist.

> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index f6d8ee4..1e4b9b1 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -104,14 +104,15 @@ static void sr_release(struct cdrom_device_info *);
>  static void get_sectorsize(struct scsi_cd *);
>  static void get_capabilities(struct scsi_cd *);
>  
> -static int sr_media_change(struct cdrom_device_info *, int);
> +static unsigned int sr_check_events(struct cdrom_device_info *cdi,
> +				    unsigned int clearing, int slot);
>  static int sr_packet(struct cdrom_device_info *, struct packet_command *);
>  
>  static struct cdrom_device_ops sr_dops = {
>  	.open			= sr_open,
>  	.release	 	= sr_release,
>  	.drive_status	 	= sr_drive_status,
> -	.media_changed		= sr_media_change,
> +	.check_events		= sr_check_events,
>  	.tray_move		= sr_tray_move,
>  	.lock_door		= sr_lock_door,
>  	.select_speed		= sr_select_speed,
> @@ -165,69 +166,96 @@ static void scsi_cd_put(struct scsi_cd *cd)
>  	mutex_unlock(&sr_ref_mutex);
>  }

-- 
Simon Arlott
