From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH 1/4] scsi: move initialization of scmd->eh_entry
Date: Fri, 24 May 2013 12:57:40 -0400
Message-ID: <20130524165739.GC30270@logfs.org>
References: <1369389050-118628-1-git-send-email-hare@suse.de>
 <1369389050-118628-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59265 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055Ab3EXS0I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 May 2013 14:26:08 -0400
Content-Disposition: inline
In-Reply-To: <1369389050-118628-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Bryn Reeves <bmr@redhat.com>, Roland Dreier <roland@purestorage.com>

On Fri, 24 May 2013 11:50:47 +0200, Hannes Reinecke wrote:
>=20
> The 'eh_entry' list might be used even before scsi_softirq_done()
> is called. Hence we should rather initialize it together with
> the other eh-related variables.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_lib.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index c31187d..a5515ec 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -318,6 +318,8 @@ static void scsi_init_cmd_errh(struct scsi_cmnd *=
cmd)
>  	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
>  	if (cmd->cmd_len =3D=3D 0)
>  		cmd->cmd_len =3D scsi_command_size(cmd->cmnd);
> +	INIT_LIST_HEAD(&cmd->eh_entry);
> +	cmd->eh_eflags =3D 0;

I always suspect something subtle going on when a variable is
initialized to 0 three lines below a memset.  Can line this go away?

J=C3=B6rn

--
Those who come seeking peace without a treaty are plotting.
-- Sun Tzu
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
