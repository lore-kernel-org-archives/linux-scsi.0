From: Josef =?iso-8859-1?Q?M=F6llers?=
	<josef.moellers@fujitsu-siemens.com>
Subject: Re: Why REPORT LUN only for SCSI-2?
Date: Wed, 16 Jul 2003 09:00:10 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F14F7FA.BA551505@fujitsu-siemens.com>
References: <3F140D30.D2B5C4D8@fujitsu-siemens.com> <20030715073927.A8218@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plam.fujitsu-siemens.com ([217.115.66.9]:32568 "EHLO
	plam.fujitsu-siemens.com") by vger.kernel.org with ESMTP
	id S269804AbTGPGo4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jul 2003 02:44:56 -0400
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:

> > Ist there a hard reason not to allow the REPORT LUNS command for SC=
SI-2
> > devices?

> No.

So, can I cast my vote to drop it? Or at least change it to a check for
SCSI_1.

The code does work with SCSI-2 devices (some disks) which don't support
REPORT LUNs and IMHO devices which do support command code A0h for
anything other than REPORT LUNs _are_ broken.

> > There are several devices (e.g. RAID) which tread carefull and clai=
m
> > only SCSI-2 compliancy but support REPORT LUNS. It would make life
> > easier with these if REPORT LUNS would be generally available.
> > Eg I have a box which will happily accept INQUIRYs on LUNs 0-7 but
> > REPORT LUNS returns only the 4 configured LUNs.
>=20
> Are the unconfigured LUNs showing up as if they were configured?

Yes

These are the configured entries from /proc/scsi/scsi:

Host: scsi1 Channel: 00 Id: 01 Lun: 00
  Vendor: MYLEX    Model: DAC960FL 18000T0 Rev: 5426
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 01 Lun: 01
  Vendor: MYLEX    Model: DAC960FL 18000T0 Rev: 5426
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 01 Lun: 02
  Vendor: MYLEX    Model: DAC960FL 18000T0 Rev: 5426
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 01 Lun: 03
  Vendor: MYLEX    Model: DAC960FL 15464T0 Rev: 5426
  Type:   Direct-Access                    ANSI SCSI revision: 02

These are the unconfigured LUNs:

Host: scsi1 Channel: 00 Id: 01 Lun: 04
  Vendor: MYLEX    Model: DAC960FL         Rev: 5426
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 01 Lun: 05
  Vendor: MYLEX    Model: DAC960FL         Rev: 5426
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 01 Lun: 06
  Vendor: MYLEX    Model: DAC960FL         Rev: 5426
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 01 Lun: 07
  Vendor: MYLEX    Model: DAC960FL         Rev: 5426
  Type:   Direct-Access                    ANSI SCSI revision: 02

These last 4 Luns are not detected if I remove the SCSI_3 check at the
beginning of scsi_report_lun_scan().

> Most disk/RAID arrays made in the last few years can configure whethe=
r
> they report back as SCSI-2 or SCSI-3. It would be best if you could c=
hange
> the device to report as SCSI-3.
>=20
> Even some SCSI disk drives are capable of reporting back as SCSI-2 or
> SCSI-3.

No, unfortunately we cannot change this. I've tried, but the vendors
(these are OEM parts, it's not only the MYLEX thingies shown above)
refused.
I guess (I haven't dug into this deep enough, I'm not a standards
person) is that the parts aren't 100% SCSI-3, connected to a
=46ibreChannel HA. They are capable of addressing more than 8 LUNs.
Adding them to the device_table doen't really work, because then we get
128 LUNs showing up and I have seen pretty large configurations with
several RAID boxes connected so we run out of device numbers.

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
