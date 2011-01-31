From: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCH] cdrom: support devices that have check_events but not
 media_changed
Date: Mon, 31 Jan 2011 14:22:58 +0300
Message-ID: <4D469B92.6050705@ru.mvista.com>
References: <1291838262-21274-1-git-send-email-tj@kernel.org> <1291838262-21274-8-git-send-email-tj@kernel.org> <4D44BE3E.5080107@simon.arlott.org.uk> <4D44BF64.4060205@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4D44BF64.4060205@simon.arlott.org.uk>
Sender: linux-ide-owner@vger.kernel.org
To: Simon Arlott <simon@fire.lp0.eu>
Cc: axboe@kernel.dk, Tejun Heo <tj@kernel.org>, jeff@garzik.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, jack@suse.cz, James.Bottomley@HansenPartnership.com
List-Id: linux-scsi@vger.kernel.org

Hello.

On 30-01-2011 4:31, Simon Arlott wrote:

> 93aae17af1172c40c6f74b7294e93a90c3cfaa5d replaced the media_changed op

    Please specify the commit summary in parens, as asked by Linus.

> with the check_events op in drivers/scsi/sr.c

> All users that check for the CDC_MEDIA_CHANGED capability try both
> the check_events op and the media_changed op, but register_cdrom()
> was requiring media_changed.

> This patch fixes the capability checking and removes a redundant
> check that media_changed != NULL.

> The cdrom_select_disc ioctl is also using the two operations, so
> they should be required for CDC_SELECT_DISC too.

> Signed-off-by: Simon Arlott<simon@fire.lp0.eu>
> Cc: Jens Axboe<axboe@kernel.dk>
> Cc: Tejun Heo<tj@kernel.org>
> Cc: Kay Sievers<kay.sievers@vrfy.org>
[...]

> diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
> index 14033a3..4716d76 100644
> --- a/drivers/cdrom/cdrom.c
> +++ b/drivers/cdrom/cdrom.c
> @@ -409,7 +409,9 @@ int register_cdrom(struct cdrom_device_info *cdi)
>   	}
>
>   	ENSURE(drive_status, CDC_DRIVE_STATUS );
> -	ENSURE(media_changed, CDC_MEDIA_CHANGED);
> +	if (cdo->check_events == NULL && cdo->media_changed == NULL) {
> +		*change_capability = ~(CDC_MEDIA_CHANGED | CDC_SELECT_DISC);
> +	}

    {} are not needed here. I think checkstatus.pl should detect this...

WBR, Sergei
