From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 06/10] libata: use __scsi_format_command()
Date: Fri, 14 Nov 2014 16:02:19 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029593A7DEA@G9W0745.americas.hpqcorp.net>
References: <1415262639-121586-1-git-send-email-hare@suse.de>
 <1415262639-121586-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1415262639-121586-7-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Thursday, 06 November, 2014 2:31 AM
> To: James Bottomley
> Cc: Christoph Hellwig; Ewan Milne; Elliott, Robert (Server Storage);
> linux-scsi@vger.kernel.org; Hannes Reinecke; linux-
> ide@vger.kernel.org; LKML
> Subject: [PATCH 06/10] libata: use __scsi_format_command()
> 
> libata already uses an internal buffer, so we should be using
> __scsi_format_command() here.
> 
> Cc: linux-ide@vger.kernel.org
> Cc: LKML <linux-kernel@vger.kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/ata/libata-eh.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
> index dad83df..6550a9a 100644
> --- a/drivers/ata/libata-eh.c
> +++ b/drivers/ata/libata-eh.c
> @@ -2509,15 +2509,12 @@ static void ata_eh_link_report(struct
> ata_link *link)
> 
>  		if (ata_is_atapi(qc->tf.protocol)) {
>  			if (qc->scsicmd)
> -				scsi_print_command(qc->scsicmd);
> +				__scsi_format_command(cdb_buf,
> sizeof(cdb_buf),
> +						      qc->scsicmd->cmnd,
> +						      qc->scsicmd->cmd_len);
>  			else
> -				snprintf(cdb_buf, sizeof(cdb_buf),
> -				 "cdb %02x %02x %02x %02x %02x %02x %02x
> %02x  "
> -				 "%02x %02x %02x %02x %02x %02x %02x %02x\n
> ",
> -				 cdb[0], cdb[1], cdb[2], cdb[3],
> -				 cdb[4], cdb[5], cdb[6], cdb[7],
> -				 cdb[8], cdb[9], cdb[10], cdb[11],
> -				 cdb[12], cdb[13], cdb[14], cdb[15]);
> +				__scsi_format_command(cdb_buf,
> sizeof(cdb_buf),
> +						      cdb, qc->dev->cdb_len);

Since results in just one "cdb" variable usage, you could change
"cdb" to qc->cdb" to get rid of the variable declaration and 
slightly simplify the code.
                const u8 *cdb = qc->cdb;


>  		} else {
>  			const char *descr = ata_get_cmd_descript(cmd-
> >command);
>  			if (descr)
> --
> 1.8.5.2

Reviewed-by: Robert Elliott <elliott@hp.com>
