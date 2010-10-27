From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: Add SHT->unlocked_qcmd for host_lock less
 SHT->queuecommand() dispatch
Date: Wed, 27 Oct 2010 16:26:09 +0200
Message-ID: <AANLkTi=juKAP9gZ4hhRCPwovWRn8px=FEWCCUfuJbUQM@mail.gmail.com>
References: <1288139559-12019-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1288139559-12019-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 27, 2010 at 2:32 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>
> [ ... ]
>
> Finally, this patch also converts the remaining struct Scsi_Host->cmd=
_serial_number
> to atomic_t following a recommedation by Joe Eykholt to start struct =
Scsi_Host->
> cmd_serial_number at 1, and increment each serial_number by 2 so that=
 the
> serial is odd, and wraps to 1 instead of 0. =A0struct Scsi_Host->cmd_=
serial_number
> is initialized to '1' in drivers/scsi/hosts.c:scsi_host_alloc().
>
> [ ... ]
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 4f7a582..0c87c4f 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -381,6 +381,11 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_ho=
st_template *sht, int privsize)
> =A0 =A0 =A0 =A0shost->unchecked_isa_dma =3D sht->unchecked_isa_dma;
> =A0 =A0 =A0 =A0shost->use_clustering =3D sht->use_clustering;
> =A0 =A0 =A0 =A0shost->ordered_tag =3D sht->ordered_tag;
> + =A0 =A0 =A0 shost->unlocked_qcmd =3D sht->unlocked_qcmd;
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Set the default shost->cmd_serial_number to 1.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 atomic_set(&shost->cmd_serial_number, 1);
>
> =A0 =A0 =A0 =A0if (sht->supported_mode =3D=3D MODE_UNKNOWN)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* means we didn't set it ... default =
to INITIATOR */
> [ ... ]
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 348fba0..7c93384 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -628,17 +628,69 @@ void scsi_log_completion(struct scsi_cmnd *cmd,=
 int disposition)
>
> =A0/**
> =A0* scsi_cmd_get_serial - Assign a serial number to a command
> - * @host: the scsi host
> =A0* @cmd: command to assign serial number to
> =A0*
> =A0* Description: a serial number identifies a request for error reco=
very
> - * and debugging purposes. =A0Protected by the Host_Lock of host.
> + * and debugging purposes. =A0Called directly by SCSI LLDs that have=
 a
> + * legacy requirement for struct scsi_cmnd->serial_number.
> =A0*/
> -static inline void scsi_cmd_get_serial(struct Scsi_Host *host, struc=
t scsi_cmnd *cmd)
> +void scsi_cmd_get_serial(struct scsi_cmnd *cmd)
> =A0{
> - =A0 =A0 =A0 cmd->serial_number =3D host->cmd_serial_number++;
> - =A0 =A0 =A0 if (cmd->serial_number =3D=3D 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cmd->serial_number =3D host->cmd_serial=
_number++;
> + =A0 =A0 =A0 struct Scsi_Host *host =3D cmd->device->host;
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Increment the host->cmd_serial_number by 2 so cmd-=
>serial_number
> + =A0 =A0 =A0 =A0* is always odd and wraps to 1 instead of 0.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 cmd->serial_number =3D atomic_add_return(2, &host->cmd_=
serial_number);
> +}
> +EXPORT_SYMBOL(scsi_cmd_get_serial);
> +
> [ ... ]

There is a mismatch between the patch description and the patch
itself. The patch description says that the serial number starts at
one while the patch itself makes the serial number start at three.

Bart.
