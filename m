From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Why REPORT LUN only for SCSI-2?
Date: Wed, 16 Jul 2003 12:35:19 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030716123519.A19244@beaverton.ibm.com>
References: <3F140D30.D2B5C4D8@fujitsu-siemens.com> <20030715073927.A8218@beaverton.ibm.com> <3F14F7FA.BA551505@fujitsu-siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:42724 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S271060AbTGPTUQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2003 15:20:16 -0400
Content-Disposition: inline
In-Reply-To: <3F14F7FA.BA551505@fujitsu-siemens.com>; from josef.moellers@fujitsu-siemens.com on Wed, Jul 16, 2003 at 09:00:10AM +0200
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?Josef_M=F6llers?= <josef.moellers@fujitsu-siemens.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Jul 16, 2003 at 09:00:10AM +0200, Josef M=F6llers wrote:
> Patrick Mansfield wrote:

> So, can I cast my vote to drop it? Or at least change it to a check f=
or
> SCSI_1.
>=20
> The code does work with SCSI-2 devices (some disks) which don't suppo=
rt
> REPORT LUNs and IMHO devices which do support command code A0h for
> anything other than REPORT LUNs _are_ broken.

But some broken devices might hang when sent a REPORT LUN command, and
then we have to add a BFLAGS_NO_REPORT_LUN or some other hacks.=20

We could change BLIST_LARGELUN to be BLIST_SCSI_3, and take that to mea=
n
use REPORT LUN, and go up to the LLDD's max_lun (though I dislike addin=
g
anything to the device_info table, especially when these devices should
report back as SCSI-3). Any multi-lun device that wants LUN > 8 better =
not
hang on a REPORT LUN.

> > Are the unconfigured LUNs showing up as if they were configured?
>=20
> Yes

Are the PQ values of the extra drives coming back as 1?  If so the devi=
ces
will show up under sd but be offline. I can resend a patch for this, I =
got
no comments last time it went out.

You can easily tell if run with scsi scan logging, either boot with:

	scsi_mod.scsi_logging_level=3D0x00000180

Or before insmod of the adapter:

	echo scsi log scan 6  >/proc/scsi/scsi

> > Most disk/RAID arrays made in the last few years can configure whet=
her
> > they report back as SCSI-2 or SCSI-3. It would be best if you could=
 change
> > the device to report as SCSI-3.
> >=20
> > Even some SCSI disk drives are capable of reporting back as SCSI-2 =
or
> > SCSI-3.
>=20
> No, unfortunately we cannot change this. I've tried, but the vendors
> (these are OEM parts, it's not only the MYLEX thingies shown above)
> refused.
> I guess (I haven't dug into this deep enough, I'm not a standards
> person) is that the parts aren't 100% SCSI-3, connected to a
> FibreChannel HA. They are capable of addressing more than 8 LUNs.
> Adding them to the device_table doen't really work, because then we g=
et
> 128 LUNs showing up and I have seen pretty large configurations with
> several RAID boxes connected so we run out of device numbers.

=46or linux 2.6 SCSI-3 (generally) means we will send a REPORT LUN, and=
 we
will allow sequential scans past lun 8, and that would be fine in your
case.

You mean making the device BLIST_SPARSELUN in the scsi_static_device_li=
st
or device_info gives you 128 LUNs?

-- Patrick Mansfield
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
