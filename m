From: Kurt Garloff <garloff@suse.de>
Subject: Re: Why REPORT LUN only for SCSI-2?
Date: Thu, 17 Jul 2003 20:49:09 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030717184909.GD2520@nbkurt.garloff.de>
References: <3F140D30.D2B5C4D8@fujitsu-siemens.com> <20030715073927.A8218@beaverton.ibm.com> <3F14F7FA.BA551505@fujitsu-siemens.com> <20030716123519.A19244@beaverton.ibm.com> <3F16649C.239EC87B@fujitsu-siemens.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0IvGJv3f9h+YhkrH"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([213.95.15.193]:50185 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S271626AbTGQWg6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2003 18:36:58 -0400
Content-Disposition: inline
In-Reply-To: <3F16649C.239EC87B@fujitsu-siemens.com>
List-Id: linux-scsi@vger.kernel.org
To: Josef =?iso-8859-1?Q?M=F6llers?= <josef.moellers@fujitsu-siemens.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org, "Wichert, Gerhard" <Gerhard.Wichert@fujitsu-siemens.com>


--0IvGJv3f9h+YhkrH
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 17, 2003 at 10:55:56AM +0200, Josef M=F6llers wrote:
> Isn't this what pretty much is in the device table? Information about
> devices needing special treatment?
> I agree that a SCSI-2 device which accepts REPORT LUNS is not really
> standard,

I would not say that a device that implements commands from newer
standards breaks the older one. Otherwise, the standards have not
well been defined w.r.t. backwards compatibility.

> but a SCSI-2 device which doesn't accept REPORT LUNS should
> reject it and that would be OK with the current code.

Sure.
But we would need a blacklist flag for broken devices.
On the other hand it would probably reduce the size of the blacklist
as BLIST_SPARSELUN | BLIST_LARGELUN devices could go away.

> What good are all these auto-configuration features if they can't be
> used?

Well, this question should probably not be asked to Linux SCSI hackers
but to vendors who sell things that would not survive the simplest
SCSI compliance tests ...=20

> > We could change BLIST_LARGELUN to be BLIST_SCSI_3, and take that to mean
> > use REPORT LUN, and go up to the LLDD's max_lun (though I dislike adding
> > anything to the device_info table, especially when these devices should
> > report back as SCSI-3). Any multi-lun device that wants LUN > 8 better =
not
> > hang on a REPORT LUN.

That could be a compromise, but I'd prefer to always try REPORT_LUNS if
the device is SCSI-2 or up. Or one could use additional indications like
the attachment to a host adapter that supports LUNS > 8. My guess would
be that there not that many broken FC devices out there. (GIven the
price tag that is attached to FC HW, this should be a reason to jump=20
into the vendor's face.)

> REPORT LUNS is a clean way to handle LUNs: on devices which support it,
> you don't even look at non-existing LUNs!

Sure.

> > > I guess (I haven't dug into this deep enough, I'm not a standards
> > > person) is that the parts aren't 100% SCSI-3, connected to a
> > > FibreChannel HA. They are capable of addressing more than 8 LUNs.
> > > Adding them to the device_table doen't really work, because then we g=
et
> > > 128 LUNs showing up and I have seen pretty large configurations with
> > > several RAID boxes connected so we run out of device numbers.

Hmm, I was hoping that we'd have 64 bit device numbers to address this
when 2.6 is ready. For 2.4, we have patches to support dynamic block
device numbers and are able to support > 2000 disks.
http://www.suse.de/~garloff/scsi-many/

The patch can be redone for 2.6 of course, but I was hoping to see=20
a nicer solution ...
What's the statuds on 64bit dev_t?

> > You mean making the device BLIST_SPARSELUN in the scsi_static_device_li=
st
> > or device_info gives you 128 LUNs?
>=20
> On some devices (a colleague reports this for an EMC 4700), yes it does.
> That's one of our main problems.

Looks like we need scsi-many for 2.6 ...=20
Or does just changing the "Report Code" in REPORT_LUNS fix this?

> As a side note (probably starting a new thread) why does BLIST_LARGELUN
> override max_scsi_luns?=20

It shouldn't. Did I really do this? (... checking 2.4 code ...)
No, I plead innocent.

> If I specify on the command line that I want
> only 8 LUNs, I want only 8 LUNs and BLIST_LARGELUN overrides this with
> the HA's max_lun.

Sure. If I don't misparse the code, this should work in 2.4.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers                 SuSE Labs (Head)
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--0IvGJv3f9h+YhkrH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2-rc1-SuSE (GNU/Linux)

iD8DBQE/Fu+lxmLh6hyYd04RAvysAJ93R+tVoPZehvOgFX2VH3DTqL6imQCbBhwV
cTzCvrlRtXpuOwZU5FV6/GM=
=TpNx
-----END PGP SIGNATURE-----

--0IvGJv3f9h+YhkrH--
