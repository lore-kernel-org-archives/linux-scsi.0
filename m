From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] scsi: zero per-cmd driver data for each MQ I/O
Date: Wed, 17 May 2017 23:05:18 +0000
Message-ID: <1495062317.2679.1.camel@sandisk.com>
References: <MWHPR03MB31361482F0BAE79275957D63CEE10@MWHPR03MB3136.namprd03.prod.outlook.com>
         <1494892845.2567.14.camel@sandisk.com>
         <MWHPR03MB3136DEB8FD09EDDF7CDB8BF5CEE60@MWHPR03MB3136.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:55525 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751957AbdEQXFV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2017 19:05:21 -0400
In-Reply-To: <MWHPR03MB3136DEB8FD09EDDF7CDB8BF5CEE60@MWHPR03MB3136.namprd03.prod.outlook.com>
Content-Language: en-US
Content-ID: <BA52143A5E3CC94EB36366D807572497@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "longli@microsoft.com" <longli@microsoft.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "sthemmin@microsoft.com" <sthemmin@microsoft.com>, "kys@microsoft.com" <kys@microsoft.com>

On Tue, 2017-05-16 at 17:31 +0000, Long Li wrote:
> > -----Original Message-----
> > From: Bart Van Assche [mailto:Bart.VanAssche@sandisk.com]
> > Sent: Monday, May 15, 2017 5:01 PM
> > To: jejb@linux.vnet.ibm.com; linux-scsi@vger.kernel.org; linux-
> > kernel@vger.kernel.org; Long Li <longli@microsoft.com>;
> > martin.petersen@oracle.com
> > Cc: Stephen Hemminger <sthemmin@microsoft.com>; KY Srinivasan
> > <kys@microsoft.com>
> > Subject: Re: [PATCH] scsi: zero per-cmd driver data for each MQ I/O
> >=20
> > On Mon, 2017-05-15 at 23:32 +0000, Long Li wrote:
> > > Thanks for looking! Yes this is for chasing a bug.
> > >=20
> > > With the patch, we also zero the private data used by lower layer
> > > driver, in addition to the private data in scsi_cmnd.
> >=20
> > Hello Long,
> >=20
> > What bug did you encounter, with which combination of ULP (sd?) and LLD=
 SCSI
> > driver(s) and for which request type (REQ_OP_*)? You will have to menti=
on
> > that information in the patch description anyway if you want your patch=
 to get
> > accepted.
> >=20
> > If the bug that you encountered only occurs with a single LLD, would it=
 be
> > possible to implement a fix by modifying the LLD instead of the SCSI co=
re?
>=20
> The bug I encounter is that in hv_storvsc (a LLD), sometime we are gettin=
g stale data in the private driver data memory allocated by SCSI. As a LLD,=
 we expect the memory allocated by SCSI to be zeroed. If not we may send un=
expected commands to the device.
>=20
> A little background on private data: In LLD's scsi_host_template, the dri=
ver may optionally ask SCSI to allocate its private driver memory for each =
command, by specifying cmd_size. This memory is allocated at the end of scs=
i_cmnd by SCSI. Later when SCSI queues a command, the LLD can use scsi_cmd_=
priv to get its private data.
>=20
> hv_storvsc doesn't clear its private data before use. I'm not sure about =
other LLD drivers. Although it's possible to fix it in LLD not SCSI core, I=
 think that is not the ideal place to do it. Whoever is allocating the SCSI=
 command should also zero it.
>=20
> There is a similar patch that fixed a similar issue for non-MQ case:
> commit ee5242360424b9b967454e9183767323d10cf985
>=20
> I'm sorry I should have put more details in the patch.=20

Hello Long,

Thank you for the feedback. I'm working on a patch series that merges the s=
csi-sq
and scsi-mq code paths for command initialization and that should fix the b=
ug you
encountered.

Bart.=
