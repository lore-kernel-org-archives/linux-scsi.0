From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RFC 2/2] scsi_proc: Change /proc/scsi/scsi to use bus
 device iterator
Date: Fri, 18 Dec 2015 10:23:26 +0100
Message-ID: <5673D08E.3040202@suse.de>
References: <1449583704-32400-1-git-send-email-emilne@redhat.com>
 <1449583704-32400-3-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42322 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934812AbbLRJX2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Dec 2015 04:23:28 -0500
In-Reply-To: <1449583704-32400-3-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org

On 12/08/2015 03:08 PM, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
>
> This prevents crashing due to accessing a removed element on the list=
,
> the iterator will now hold the correct reference.  It was not suffici=
ent
> to rely on the klist's reference on the containing device object.
>
>  From a patch originally developed by David Jeffery <djeffery@redhat.=
com>
>
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>   drivers/scsi/scsi_proc.c | 49 ++++++++++++++++++++++++++++---------=
-----------
>   1 file changed, 29 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
> index 251598e..6c1b79d 100644
> --- a/drivers/scsi/scsi_proc.c
> +++ b/drivers/scsi/scsi_proc.c
> @@ -40,6 +40,11 @@
>   /* 4K page size, but our output routines, use some slack for overru=
ns */
>   #define PROC_BLOCK_SIZE (3*1024)
>
> +struct scsi_proc_state {
> +	struct klist_iter iter;
> +	int pos;
> +};
> +
>   static struct proc_dir_entry *proc_scsi;
>
>   /* Protect sht->present and sht->proc_dir */
> @@ -370,47 +375,50 @@ static ssize_t proc_scsi_write(struct file *fil=
e, const char __user *buf,
>   	return err;
>   }
>
> -static int always_match(struct device *dev, void *data)
> -{
> -	return 1;
> -}
> -
> -static inline struct device *next_scsi_device(struct device *start)
> -{
> -	struct device *next =3D bus_find_device(&scsi_bus_type, start, NULL=
,
> -					      always_match);
> -	put_device(start);
> -	return next;
> -}
> -
>   static void *scsi_seq_start(struct seq_file *sfile, loff_t *pos)
>   {
> +	struct scsi_proc_state *state =3D sfile->private;
>   	struct device *dev =3D NULL;
>   	loff_t n =3D *pos;
> +	int err;
> +
> +	err =3D bus_device_iter_init(&state->iter, &scsi_bus_type);
> +	if (err < 0)
> +		return ERR_PTR(err);
>
> -	while ((dev =3D next_scsi_device(dev))) {
> +	while ((dev =3D bus_device_iter_next(&state->iter))) {
>   		if (!n--)
>   			break;
> -		sfile->private++;
> +		put_device(dev);
> +		state->pos++;
>   	}
>   	return dev;
>   }
>
>   static void *scsi_seq_next(struct seq_file *sfile, void *v, loff_t =
*pos)
>   {
> +	struct scsi_proc_state *state =3D sfile->private;
> +
>   	(*pos)++;
> -	sfile->private++;
> -	return next_scsi_device(v);
> +	put_device(v);
> +	state->pos++;
> +
> +	return bus_device_iter_next(&state->iter);
>   }
>
>   static void scsi_seq_stop(struct seq_file *sfile, void *v)
>   {
> +	struct scsi_proc_state *state =3D sfile->private;
> +
>   	put_device(v);
> +	bus_device_iter_exit(&state->iter);
>   }
>
>   static int scsi_seq_show(struct seq_file *sfile, void *dev)
>   {
> -	if (!sfile->private)
> +	struct scsi_proc_state *state =3D sfile->private;
> +
> +	if (!state->pos)
>   		seq_puts(sfile, "Attached devices:\n");
>
>   	return proc_print_scsidevice(dev, sfile);
> @@ -436,7 +444,8 @@ static int proc_scsi_open(struct inode *inode, st=
ruct file *file)
>   	 * We don't really need this for the write case but it doesn't
>   	 * harm either.
>   	 */
> -	return seq_open(file, &scsi_seq_ops);
> +	return seq_open_private(file, &scsi_seq_ops,
> +				sizeof(struct scsi_proc_state));
>   }
>
>   static const struct file_operations proc_scsi_operations =3D {
> @@ -445,7 +454,7 @@ static const struct file_operations proc_scsi_ope=
rations =3D {
>   	.read		=3D seq_read,
>   	.write		=3D proc_scsi_write,
>   	.llseek		=3D seq_lseek,
> -	.release	=3D seq_release,
> +	.release	=3D seq_release_private,
>   };
>
>   /**
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
