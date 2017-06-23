From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi/libata: Support variable-length cdb of ata
 pass-thru(32).
Date: Fri, 23 Jun 2017 17:02:50 +0000
Message-ID: <1498237368.2735.6.camel@wdc.com>
References: <1497697243-3724-1-git-send-email-dn3108@gmail.com>
         <1498071149.2746.26.camel@wdc.com>
         <CAKv8XUU-k0dFjHAu9G2rM+is4AZw9BKfsFDh1zG0zwq=GzSVkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAKv8XUU-k0dFjHAu9G2rM+is4AZw9BKfsFDh1zG0zwq=GzSVkg@mail.gmail.com>
Content-Language: en-US
Content-ID: <08A317FD51793B429AFAAE7DAE3E8C89@namprd04.prod.outlook.com>
Sender: linux-ide-owner@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "tj@kernel.org" <tj@kernel.org>, "dn3108@gmail.com" <dn3108@gmail.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2017-06-24 at 01:50 +0900, Minwoo Im wrote:
> On Thu, Jun 22, 2017 at 3:52 AM, Bart Van Assche <Bart.VanAssche@wdc.com>=
 wrote:
> > > @@ -4385,7 +4463,12 @@ int ata_scsi_add_hosts(struct ata_host *host, =
struct scsi_host_template *sht)
> > >               shost->max_id =3D 16;
> > >               shost->max_lun =3D 1;
> > >               shost->max_channel =3D 1;
> > > -             shost->max_cmd_len =3D 16;
> > > +             /*
> > > +              * SPC-3, SPC-4: Definition of CDB
> > > +              * A CDB may have a fixed length of up to 16 bytes or
> > > +              * variable length of between 12 and 260 bytes.
> > > +              */
> > > +             shost->max_cmd_len =3D 260;
> >=20
> > Does ATA pass-through really support 260-byte CDBs or is the maximum CD=
B length
> > that is supported by ATA_32 perhaps 32 bytes?
>=20
> Here's my opinion about your question.
> In perspective of SCSI host, I guess the max cmd len should be 260 bytes.
> Because SPC says that, in case of variable-length command, it could be
> from 12 to 260 bytes.
> That's why I have applied 260 value to max_cmd_len of scsi host.
> Please feel free to give any opinions about it.

Hello Minwoo,

Table 172 in document sat4r06.pdf shows that the CDB of the ATA PASS-THROUG=
H (32)
command is exactly 32 bytes long. My conclusion from analyzing __ata_scsi_q=
ueuecmd()
is that the current version of that function does not support CDBs of more =
than
16 bytes. Since your patch adds support for a single command with 32-byte C=
DB I
am convinced that max_cmd_len should be set to 32 in ata_scsi_add_hosts().

Bart.=
