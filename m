From: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCH 5/8] scsi: fix TUR error handling in sr_media_change()
Date: Thu, 09 Dec 2010 21:20:53 +0300
Message-ID: <4D011E05.5030205@ru.mvista.com>
References: <1291838262-21274-1-git-send-email-tj@kernel.org> <1291838262-21274-6-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1291838262-21274-6-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, jack@suse.cz, James.Bottomley@HansenPartnership.com
List-Id: linux-scsi@vger.kernel.org

Hello.

Tejun Heo wrote:

> sr_test_unit_ready() returns 0 iff TUR succeeded - IOW, when media is
> present and the device is actually ready, so the return value wouldn't
> be zero when TUR ends with sense data. sr_media_change() incorrectly
> tests (retval || (scsi_sense_valid(sshdr)...)) when it tries to test
> whether TUR failed without sense data or with sense data indicating
> media-not-present.

> Fix the test using scsi_status_is_good() and update comments.

> Signed-off-by: Tejun Heo <tj@kernel.org>
[...]

> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index d7b383c..deb24f0 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -214,13 +214,17 @@ static int sr_media_change(struct cdrom_device_info *cdi, int slot)
>  
>  	sshdr =  kzalloc(sizeof(*sshdr), GFP_KERNEL);
>  	retval = sr_test_unit_ready(cd->device, sshdr);
> -	if (retval || (scsi_sense_valid(sshdr) &&
> -		       /* 0x3a is medium not present */
> -		       sshdr->asc == 0x3a)) {
> -		/* Media not present or unable to test, unit probably not
> -		 * ready. This usually means there is no disc in the drive.
> -		 * Mark as changed, and we will figure it out later once
> -		 * the drive is available again.
> +	/*
> +	 * Media is considered to be present if TUR succeeds or fails with
> +	 * sense data indicating something other than media-not-present
> +	 * (ASC 0x3a).
> +	 */
> +	if (!scsi_status_is_good(retval) &&
> +	    (!scsi_sense_valid(sshdr) || sshdr->asc == 0x3a)) {
> +		/*
> +		 * Probably not media in the device.  Mark as changed, and

    s/not/no/

WBR, Sergei

