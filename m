From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH 04/10] scsi/constants: Cleanup printk message in scsi_dump_sense_buffer()
Date: Wed, 27 Aug 2014 15:59:15 +0200
Message-ID: <53FDE433.5070409@suse.de>
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal> <20140808115014.6768.44632.stgit@yuno-kbuild.novalocal>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140808115014.6768.44632.stgit@yuno-kbuild.novalocal>
Sender: linux-kernel-owner@vger.kernel.org
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Doug Gilbert <dgilbert@interlog.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 08/08/2014 01:50 PM, Yoshihiro YUNOMAE wrote:
> Unrecognized sense data should be output after linebuf is filled beca=
use
> "[%s] Unrecognized sense data (in hex): %s" message is output many ti=
mes in
> loop.
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
>   drivers/scsi/constants.c |   13 +++++--------
>   1 file changed, 5 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
> index 5956d4d..6fad6b4 100644
> --- a/drivers/scsi/constants.c
> +++ b/drivers/scsi/constants.c
> @@ -1385,16 +1385,13 @@ EXPORT_SYMBOL(scsi_print_sense_hdr);
>
>   static void
>   scsi_dump_sense_buffer(struct scsi_device *sdev, const char *prefix=
,
> -		       const unsigned char *sense_buffer, int sense_len,
> -		       struct scsi_sense_hdr *sshdr)
> +		       const unsigned char *sense_buffer, int sense_len)
>   {
>   	char linebuf[128];
>   	int i, linelen, remaining;
>
>   	if (sense_len < 32)
>   		sense_len =3D 32;
> -	sdev_printk(KERN_INFO, sdev,
> -		    "[%s] Unrecognized sense data (in hex):", prefix);
>
>   	remaining =3D sense_len;
>   	for (i =3D 0; i < sense_len; i +=3D 16) {
> @@ -1403,9 +1400,10 @@ scsi_dump_sense_buffer(struct scsi_device *sde=
v, const char *prefix,
>
>   		hex_dump_to_buffer(sense_buffer + i, linelen, 16, 1,
>   				   linebuf, sizeof(linebuf), false);
> -		sdev_printk(KERN_INFO, sdev, "[%s] Sense: %s\n",
> -			    prefix, linebuf);
>   	}
> +	sdev_printk(KERN_INFO, sdev,
> +		    "[%s] Unrecognized sense data (in hex): %s",
> +		    prefix, linebuf);
>   }
>
>   static void
> @@ -1467,8 +1465,7 @@ void __scsi_print_sense(struct scsi_device *sde=
v, const char *name,
>
>   	if (!scsi_normalize_sense(sense_buffer, sense_len, &sshdr)) {
>   		/* this may be SCSI-1 sense data */
> -		scsi_dump_sense_buffer(sdev, name, sense_buffer,
> -				       sense_len, &sshdr);
> +		scsi_dump_sense_buffer(sdev, name, sense_buffer, sense_len);
>   		return;
>   	}
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
As discussed this patch is invalid.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
