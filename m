From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH 06/10] scsi/sd: Delete extra scsi_show_extd_sense()
 in sd_print_sense_hdr()
Date: Wed, 27 Aug 2014 16:07:12 +0200
Message-ID: <53FDE610.5070309@suse.de>
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal> <20140808115019.6768.99063.stgit@yuno-kbuild.novalocal>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140808115019.6768.99063.stgit@yuno-kbuild.novalocal>
Sender: linux-kernel-owner@vger.kernel.org
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Doug Gilbert <dgilbert@interlog.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 08/08/2014 01:50 PM, Yoshihiro YUNOMAE wrote:
> sd_print_sense_hdr() calls scsi_show_extd_sense(),
> but scsi_print_sense_hdr() also calls scsi_show_extd_sense().
> We can get same result, so we delete it.
>
> Note:
> Calling scsi_show_extd_sense() is introduced in fdd8b297.
>
> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Doug Gilbert <dgilbert@interlog.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
>   drivers/scsi/sd.c |    2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 8d7204a..22dd214 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3286,8 +3286,6 @@ static void sd_print_sense_hdr(struct scsi_disk=
 *sdkp,
>   			       struct scsi_sense_hdr *sshdr)
>   {
>   	scsi_print_sense_hdr(sdkp->device, sdkp->disk->disk_name, sshdr);
> -	scsi_show_extd_sense(sdkp->device, sdkp->disk->disk_name,
> -			     sshdr->asc, sshdr->ascq);
>   }
>
>   static void sd_print_result(struct scsi_disk *sdkp, int result)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
A similar patch has been applied to my scsi-logging tree.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
