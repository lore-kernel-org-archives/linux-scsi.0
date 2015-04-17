From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 28/43] hpsa: don't return abort request until target
 is complete
Date: Fri, 17 Apr 2015 15:24:35 +0200
Message-ID: <55310993.3080109@suse.de>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134915.30238.86273.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33901 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932515AbbDQNYi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:24:38 -0400
In-Reply-To: <20150416134915.30238.86273.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:49 PM, Don Brace wrote:
> From: Webb Scales <webbnh@hp.com>
>=20
> Don't return from the abort request until the target command is compl=
ete.
> Mark outstanding commands which have a pending abort, and do not send=
 them
> to the host if we can avoid it.
>=20
> If the current command has been aborted, do not call the SCSI command
> completion routine from the I/O path: when the abort returns successf=
ully,
> the SCSI mid-layer will handle the completion implicitly.
>=20
> The following race was possible in theory.
>=20
> 1. LLD is requested to abort a scsi command
> 2. scsi command completes
> 3. The struct CommandList associated with 2 is made available.
> 4. new io request to LLD to another LUN re-uses struct CommandList
> 5. abort handler follows scsi_cmnd->host_scribble and
>    finds struct CommandList and tries to aborts it.
>=20
> Now we have aborted the wrong command.
>=20
> Fix by resetting the scsi_cmd field of struct CommandList
> upon completion and making the abort handler check that
> the scsi_cmd pointer in the CommadList struct matches the
> scsi_cmnd that it has been asked to abort.
>=20
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Webb Scales <webbnh@hp.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c     |  120 +++++++++++++++++++++++++++++++++++--=
----------
>  drivers/scsi/hpsa.h     |    1=20
>  drivers/scsi/hpsa_cmd.h |    2 +
>  3 files changed, 93 insertions(+), 30 deletions(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
