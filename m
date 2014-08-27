From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH 01/10] scsi/constants: Cleanup printk message in __scsi_print_sense()
Date: Wed, 27 Aug 2014 15:56:32 +0200
Message-ID: <53FDE390.4080503@suse.de>
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal> <20140808115006.6768.5118.stgit@yuno-kbuild.novalocal>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140808115006.6768.5118.stgit@yuno-kbuild.novalocal>
Sender: linux-kernel-owner@vger.kernel.org
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Doug Gilbert <dgilbert@interlog.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 08/08/2014 01:50 PM, Yoshihiro YUNOMAE wrote:
> A device name is output like "sda: Sense Key : Medium Error [current]=
"
> in __scsi_print_sense(), but it should be "[sda] Sense Key : Medium E=
rror
> [current]" because other printk messages output a device name like "[=
sda] foo."
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
>   drivers/scsi/constants.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
> index c6a7a4a..a0e8159 100644
> --- a/drivers/scsi/constants.c
> +++ b/drivers/scsi/constants.c
> @@ -1470,7 +1470,7 @@ void __scsi_print_sense(struct scsi_device *sde=
v, const char *name,
>   		return;
>   	}
>
> -	sdev_printk(KERN_INFO, sdev, "%s: Sense Key : %s %s%s\n", name,
> +	sdev_printk(KERN_INFO, sdev, "[%s] Sense Key : %s %s%s\n", name,
>   	       scsi_sense_key_string(sshdr.sense_key),
>   	       scsi_sense_type_string(&sshdr),
>   	       scsi_sense_format_string(&sshdr));
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
A similar fix is already present in my next version of the scsi=20
logging patchset.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
