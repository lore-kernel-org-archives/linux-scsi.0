From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 20/22] atari_scsi: Set a reasonable default for
 cmd_per_lun
Date: Tue, 15 Mar 2016 07:53:01 +0100
Message-ID: <56E7B14D.4070704@suse.de>
References: <20160314042700.596192247@telegraphics.com.au>
 <20160314042705.846189331@telegraphics.com.au> <56E66CF5.2070200@suse.de>
 <alpine.LNX.2.00.1603151403150.20294@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1603151403150.20294@nippy.intranet>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

On 03/15/2016 04:27 AM, Finn Thain wrote:
>=20
> On Mon, 14 Mar 2016, Hannes Reinecke wrote:
>=20
>> On 03/14/2016 05:27 AM, Finn Thain wrote:
>>> This setting does not need to be conditional on Atari ST or TT.
>>>
>>> Without TCQ support, cmd_per_lun =3D=3D 2 is probably reasonable...
>>>
>>> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>>>
>>> ---
>>>  drivers/scsi/atari_scsi.c |    3 +--
>>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>>
>>> Index: linux/drivers/scsi/atari_scsi.c
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> --- linux.orig/drivers/scsi/atari_scsi.c	2016-03-14 15:26:45.000000=
000 +1100
>>> +++ linux/drivers/scsi/atari_scsi.c	2016-03-14 15:26:55.000000000 +=
1100
>>> @@ -750,6 +750,7 @@ static struct scsi_host_template atari_s
>>>  	.eh_abort_handler	=3D atari_scsi_abort,
>>>  	.eh_bus_reset_handler	=3D atari_scsi_bus_reset,
>>>  	.this_id		=3D 7,
>>> +	.cmd_per_lun		=3D 2,
>>>  	.use_clustering		=3D DISABLE_CLUSTERING,
>>>  	.cmd_size		=3D NCR5380_CMD_SIZE,
>>>  };
>> _2_ ? Are you being overly cheeky here?
>> I sincerely doubt the driver is capable of submitting two
>> simultaneous commands ...
>=20
> Right. The LLD has LU busy flags to prevent a LU from being issued mo=
re=20
> than one command.
>=20
>> Care to explain?
>=20
> It seemed harmless and it is consistent with the all of the other 538=
0=20
> drivers.
>=20
> I don't know why it was done that way. Perhaps it was done to create =
a=20
> pipeline. That is, to keep a small number of commands in the LLD issu=
e=20
> queue so that the NCR5380_main() work item does not have to terminate=
 and=20
> then get requeued needlessly.
>=20
Like I suspected.
While I'm aware of the reasoning, I sincerely doubt whether it makes
any difference in real life.
After all, a 'BUSY' return value still relies on someone kicking the
queue so that the next command can be submitted. So it's not much
different from using a queuedepth of '1' and use the 'official' way.

Have you done any benchmarking here?
Would be very interesting to check if it makes a difference in real
life ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
