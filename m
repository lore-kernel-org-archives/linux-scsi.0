From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 09/12] Make scsi_mq_prep_fn() call scsi_init_command()
Date: Fri, 2 Jun 2017 17:49:06 +0000
Message-ID: <1496425745.1214.14.camel@sandisk.com>
References: <20170601232711.29062-1-bart.vanassche@sandisk.com>
         <20170601232711.29062-10-bart.vanassche@sandisk.com>
         <20170602072227.GH560@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:11799 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751164AbdFBRvL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2017 13:51:11 -0400
In-Reply-To: <20170602072227.GH560@lst.de>
Content-Language: en-US
Content-ID: <DD34E5588FEEFE4F991BC826E7E5D5DB@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "hare@suse.com" <hare@suse.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Fri, 2017-06-02 at 09:22 +0200, Christoph Hellwig wrote:
> I like this idea, but..
>=20
> > -void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
> > +void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd,
> > +		       struct scsi_data_buffer *prot_sdb)
> >  {
> >  	void *buf =3D cmd->sense_buffer;
> > -	void *prot =3D cmd->prot_sdb;
> >  	unsigned int unchecked_isa_dma =3D cmd->flags & SCMD_UNCHECKED_ISA_DM=
A;
> > =20
> >  	/* zero out the cmd, except for the embedded scsi_request */
> > @@ -1164,7 +1164,7 @@ void scsi_init_command(struct scsi_device *dev, s=
truct scsi_cmnd *cmd)
> > =20
> >  	cmd->device =3D dev;
> >  	cmd->sense_buffer =3D buf;
> > -	cmd->prot_sdb =3D prot;
> > +	cmd->prot_sdb =3D prot_sdb;
>=20
> What would be the problem of always preserving the original prot_sdb
> value instead of passing it by argument?  You;d just need to initialize
> it in scsi_init_request when the command is allocated.

Hello Christoph,

That sounds like a good idea to me. I will make that change.

Bart.=
