From: Josef =?iso-8859-1?Q?M=F6llers?=
	<josef.moellers@fujitsu-siemens.com>
Subject: Re: Why REPORT LUN only for SCSI-2?
Date: Thu, 17 Jul 2003 10:55:56 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F16649C.239EC87B@fujitsu-siemens.com>
References: <3F140D30.D2B5C4D8@fujitsu-siemens.com> <20030715073927.A8218@beaverton.ibm.com> <3F14F7FA.BA551505@fujitsu-siemens.com> <20030716123519.A19244@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plim.fujitsu-siemens.com ([217.115.66.8]:51498 "EHLO
	plim.fujitsu-siemens.com") by vger.kernel.org with ESMTP
	id S271375AbTGQIkM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jul 2003 04:40:12 -0400
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, "Wichert, Gerhard" <Gerhard.Wichert@fujitsu-siemens.com>

Patrick Mansfield wrote:
>=20
> On Wed, Jul 16, 2003 at 09:00:10AM +0200, Josef M=F6llers wrote:
> > Patrick Mansfield wrote:
>=20
> > So, can I cast my vote to drop it? Or at least change it to a check=
 for
> > SCSI_1.
> >
> > The code does work with SCSI-2 devices (some disks) which don't sup=
port
> > REPORT LUNs and IMHO devices which do support command code A0h for
> > anything other than REPORT LUNs _are_ broken.
>=20
> But some broken devices might hang when sent a REPORT LUN command, an=
d
> then we have to add a BFLAGS_NO_REPORT_LUN or some other hacks.

Isn't this what pretty much is in the device table? Information about
devices needing special treatment?
I agree that a SCSI-2 device which accepts REPORT LUNS is not really
standard, but a SCSI-2 device which doesn't accept REPORT LUNS should
reject it and that would be OK with the current code.

What good are all these auto-configuration features if they can't be
used?

> We could change BLIST_LARGELUN to be BLIST_SCSI_3, and take that to m=
ean
> use REPORT LUN, and go up to the LLDD's max_lun (though I dislike add=
ing
> anything to the device_info table, especially when these devices shou=
ld
> report back as SCSI-3). Any multi-lun device that wants LUN > 8 bette=
r not
> hang on a REPORT LUN.

I know that these devices should report back as SCSI-3, but if the
vendors don't want to re-certify their devices for SCSI-3 compliancy, I
can't force them to do so, so we are stuck with FC devices reporting
more than 8 LUNs on SCSI-2.
REPORT LUNS is a clean way to handle LUNs: on devices which support it,
you don't even look at non-existing LUNs!

Section 7.1.1 of S2-R10L states that "A target that receives a reserved
bit, field, or byte that is not zero or receives a reserved code value
shall terminate the command with CHECK CONDITION status and the sense
key shall be set to ILLEGAL REQUEST." Thus, a SCSI-2 device which does
not properly reject REPORT LUNS yet chokes on it is not SCSI-2.

> > > Are the unconfigured LUNs showing up as if they were configured?
> >
> > Yes
>=20
> Are the PQ values of the extra drives coming back as 1?  If so the de=
vices
> will show up under sd but be offline. I can resend a patch for this, =
I got
> no comments last time it went out.

Apparently they do, because when I change the check for PQ =3D=3D 3 to =
PQ !=3D
0, then I only see 4 LUNs.

[ ... ]

> > > Most disk/RAID arrays made in the last few years can configure wh=
ether
> > > they report back as SCSI-2 or SCSI-3. It would be best if you cou=
ld change
> > > the device to report as SCSI-3.
> > >
> > > Even some SCSI disk drives are capable of reporting back as SCSI-=
2 or
> > > SCSI-3.
> >
> > No, unfortunately we cannot change this. I've tried, but the vendor=
s
> > (these are OEM parts, it's not only the MYLEX thingies shown above)
> > refused.
> > I guess (I haven't dug into this deep enough, I'm not a standards
> > person) is that the parts aren't 100% SCSI-3, connected to a
> > FibreChannel HA. They are capable of addressing more than 8 LUNs.
> > Adding them to the device_table doen't really work, because then we=
 get
> > 128 LUNs showing up and I have seen pretty large configurations wit=
h
> > several RAID boxes connected so we run out of device numbers.
>=20
> For linux 2.6 SCSI-3 (generally) means we will send a REPORT LUN, and=
 we
> will allow sequential scans past lun 8, and that would be fine in you=
r
> case.

Not quite, since the devices we're talking abour say they're SCSI-2!

> You mean making the device BLIST_SPARSELUN in the scsi_static_device_=
list
> or device_info gives you 128 LUNs?

On some devices (a colleague reports this for an EMC 4700), yes it does=
=2E
That's one of our main problems.

As a side note (probably starting a new thread) why does BLIST_LARGELUN
override max_scsi_luns? If I specify on the command line that I want
only 8 LUNs, I want only 8 LUNs and BLIST_LARGELUN overrides this with
the HA's max_lun.

Josef
--=20
Josef M=F6llers (Pinguinpfleger bei FSC)
	If failure had no penalty success would not be a prize
						-- T.  Pratchett
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
