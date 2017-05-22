From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 14/18] scsi: Make scsi_initialize_rq() zero the entire
 struct scsi_cmnd
Date: Mon, 22 May 2017 17:12:40 +0000
Message-ID: <1495473159.2610.5.camel@sandisk.com>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com>
         <20170519183016.12646-15-bart.vanassche@sandisk.com>
         <20170521064918.GD12891@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:23796 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932968AbdEVRMo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2017 13:12:44 -0400
In-Reply-To: <20170521064918.GD12891@lst.de>
Content-Language: en-US
Content-ID: <3F27F1EA6C19D24B907B59F83DB18B8A@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "hare@suse.com" <hare@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Sun, 2017-05-21 at 08:49 +0200, Christoph Hellwig wrote:
> On Fri, May 19, 2017 at 11:30:12AM -0700, Bart Van Assche wrote:
> > This simplifies the memset() call in scsi_initialize_rq() and avoids
> > that any stale data is left behind in struct scsi_request.
> >=20
> > Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Hannes Reinecke <hare@suse.com>
> > ---
> >  drivers/scsi/scsi_lib.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index eeb668935836..791bae192bfb 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -1160,11 +1160,9 @@ static void scsi_initialize_rq(struct request *r=
q)
> >  	void *buf =3D cmd->sense_buffer;
> >  	void *prot =3D cmd->prot_sdb;
> > =20
> > -	/* zero out the cmd, except for the embedded scsi_request */
> > -	memset((char *)cmd + sizeof(cmd->req), 0,
> > -		sizeof(*cmd) - sizeof(cmd->req) + dev->host->hostt->cmd_size);
> > +	memset(cmd, 0, blk_queue_cmd_size(rq->q));
> >  	scsi_req_init(&cmd->req);
> > -	cmd->req.sense =3D cmd->sense_buffer;
> > +	cmd->req.sense =3D buf;
> >  	cmd->device =3D dev;
> >  	cmd->sense_buffer =3D buf;
>=20
> maybe move the two sense buffer initializations together?

Hello Christoph,

That sounds like a good idea to me. I will make that change.

Bart.=
