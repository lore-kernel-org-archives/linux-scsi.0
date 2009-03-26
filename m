From: Ahmed A <ahmedcali@yahoo.com>
Subject: Re: Stale devices in sysfs
Date: Thu, 26 Mar 2009 11:51:45 -0700 (PDT)
Message-ID: <635936.80425.qm@web32508.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web32508.mail.mud.yahoo.com ([68.142.207.218]:30930 "HELO
	web32508.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754262AbZCZSvs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Mar 2009 14:51:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org




--- On Thu, 3/26/09, James Bottomley <James.Bottomley@HansenPartnership=
=2Ecom> wrote:

> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Subject: Re: Stale devices in sysfs
> To: "Ahmed A" <ahmedcali@yahoo.com>
> Cc: linux-scsi@vger.kernel.org
> Date: Thursday, March 26, 2009, 10:41 AM
> On Thu, 2009-03-26 at 10:16 -0700,
> Ahmed A wrote:
> > Hello,
> >=20
> > I have a two port FC hba in my system.=A0 The hba
> is properly connecting
> > to a Target, and I can tell it seems all the LUNs
> exported to it.
> > However, when I browse through the
> /sys/class/scsi_host/...
> > directory , and output of "lsscsi", I can see "sd"
> mappings that are
> > old and invalid (cannot write to them).=A0 In my
> ouput below,
> > sd[e/f/g/h] and sd[c/d] are invalid.
> >=20
> > 1. Is there an command I an issue to flush out the
> older mappings?
> >=20
> > 2. Is this a bug in the FC driver?
> >=20
> > [root@pe850 ~]# lsscsi
> > [2:0:0:10]=A0=A0=A0disk=A0 =A0 3PARdata
> VV=A0 =A0 =A0 =A0 =A0 =A0
> =A0=A0=A00000=A0 /dev/sde
> > [2:0:0:11]=A0=A0=A0disk=A0 =A0 3PARdata
> VV=A0 =A0 =A0 =A0 =A0 =A0
> =A0=A0=A00000=A0 /dev/sdf
> > [2:0:0:254]=A0 enclosu 3PARdata SES=A0 =A0
> =A0 =A0 =A0 =A0 =A0 0000=A0 -=A0 =A0
> =A0=A0=A0
> > [2:0:1:10]=A0=A0=A0disk=A0 =A0 3PARdata
> VV=A0 =A0 =A0 =A0 =A0 =A0
> =A0=A0=A00000=A0 /dev/sdg
> > [2:0:1:11]=A0=A0=A0disk=A0 =A0 3PARdata
> VV=A0 =A0 =A0 =A0 =A0 =A0
> =A0=A0=A00000=A0 /dev/sdh
> > [2:0:1:254]=A0 enclosu 3PARdata SES=A0 =A0
> =A0 =A0 =A0 =A0 =A0 0000=A0 -=A0 =A0
> =A0=A0=A0
> > [2:0:2:10]=A0=A0=A0disk=A0 =A0 3PARdata
> VV=A0 =A0 =A0 =A0 =A0 =A0
> =A0=A0=A00000=A0 /dev/sdi
> > [2:0:2:11]=A0=A0=A0disk=A0 =A0 3PARdata
> VV=A0 =A0 =A0 =A0 =A0 =A0
> =A0=A0=A00000=A0 /dev/sdj
> > [2:0:2:254]=A0 enclosu 3PARdata SES=A0 =A0
> =A0 =A0 =A0 =A0 =A0 0000=A0 -=A0 =A0
> =A0=A0=A0
> > [3:0:0:10]=A0=A0=A0disk=A0 =A0 3PARdata
> VV=A0 =A0 =A0 =A0 =A0 =A0
> =A0=A0=A00000=A0 /dev/sdc
> > [3:0:0:11]=A0=A0=A0disk=A0 =A0 3PARdata
> VV=A0 =A0 =A0 =A0 =A0 =A0
> =A0=A0=A00000=A0 /dev/sdd
> > [3:0:0:254]=A0 enclosu 3PARdata SES=A0 =A0
> =A0 =A0 =A0 =A0 =A0 0000=A0 -=A0 =A0
> =A0=A0=A0
> > [3:0:1:10]=A0=A0=A0disk=A0 =A0 3PARdata
> VV=A0 =A0 =A0 =A0 =A0 =A0
> =A0=A0=A00000=A0 /dev/sdk
> > [3:0:1:11]=A0=A0=A0disk=A0 =A0 3PARdata
> VV=A0 =A0 =A0 =A0 =A0 =A0
> =A0=A0=A00000=A0 /dev/sdl
> > [3:0:1:254]=A0 enclosu 3PARdata SES=A0 =A0
> =A0 =A0 =A0 =A0 =A0 0000=A0 -=A0 =A0
> =A0=A0=A0
> > [root@pe850 ~]#=20
>=20
> It's very hard to tell anything without knowing which fibre
> HBA or
> looking in the logs.=A0 However, I'd say you've had some
> disconnect event
> which exceeded the devloss timeout twice on HBA 2 and once
> on HBA 1 ...
> this causes LUNs to be re-presented in exactly this fashion
> (with the
> target number incrementing).
>=20
> It sounds like the problem is whatever event caused this,
> and there's
> insufficient information to make any guesses about that.
>=20
> James
>=20
>=20
>=20

Hi James,=20

Thank you for your reply.  It is an Emulex 2 port FC hba (LPE11002), us=
ing the inbox driver version 8.2.0.33.3p.  Yes, there have been some di=
sconnect, initiatied by me by disabling / enablling the port on the tar=
get.  Even in these situations, wouldn't the driver remove the old/stal=
e mappings?  I am guessing from you response, there is no way for me to=
 clean-up the old ones.

As to figure out which ones are real, just use the sd mapping with the =
latest target number, right?

Thank you,
Ahmed.



     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
