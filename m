From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH] scsi: zero per-cmd driver data for each MQ I/O
Date: Tue, 16 May 2017 17:31:28 +0000
Message-ID: <MWHPR03MB3136DEB8FD09EDDF7CDB8BF5CEE60@MWHPR03MB3136.namprd03.prod.outlook.com>
References: <MWHPR03MB31361482F0BAE79275957D63CEE10@MWHPR03MB3136.namprd03.prod.outlook.com>
 <1494892845.2567.14.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1494892845.2567.14.camel@sandisk.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>, KY Srinivasan <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Bart Van Assche [mailto:Bart.VanAssche@sandisk.com]
> Sent: Monday, May 15, 2017 5:01 PM
> To: jejb@linux.vnet.ibm.com; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org; Long Li <longli@microsoft.com>;
> martin.petersen@oracle.com
> Cc: Stephen Hemminger <sthemmin@microsoft.com>; KY Srinivasan
> <kys@microsoft.com>
> Subject: Re: [PATCH] scsi: zero per-cmd driver data for each MQ I/O
>=20
> On Mon, 2017-05-15 at 23:32 +0000, Long Li wrote:
> > Thanks for looking! Yes this is for chasing a bug.
> >
> > With the patch, we also zero the private data used by lower layer
> > driver, in addition to the private data in scsi_cmnd.
>=20
> Hello Long,
>=20
> What bug did you encounter, with which combination of ULP (sd?) and LLD S=
CSI
> driver(s) and for which request type (REQ_OP_*)? You will have to mention
> that information in the patch description anyway if you want your patch t=
o get
> accepted.
>=20
> If the bug that you encountered only occurs with a single LLD, would it b=
e
> possible to implement a fix by modifying the LLD instead of the SCSI core=
?

The bug I encounter is that in hv_storvsc (a LLD), sometime we are getting =
stale data in the private driver data memory allocated by SCSI. As a LLD, w=
e expect the memory allocated by SCSI to be zeroed. If not we may send unex=
pected commands to the device.

A little background on private data: In LLD's scsi_host_template, the drive=
r may optionally ask SCSI to allocate its private driver memory for each co=
mmand, by specifying cmd_size. This memory is allocated at the end of scsi_=
cmnd by SCSI. Later when SCSI queues a command, the LLD can use scsi_cmd_pr=
iv to get its private data.

hv_storvsc doesn't clear its private data before use. I'm not sure about ot=
her LLD drivers. Although it's possible to fix it in LLD not SCSI core, I t=
hink that is not the ideal place to do it. Whoever is allocating the SCSI c=
ommand should also zero it.

There is a similar patch that fixed a similar issue for non-MQ case:
commit ee5242360424b9b967454e9183767323d10cf985

I'm sorry I should have put more details in the patch.=20

>=20
> Thanks,
>=20
> Bart.
