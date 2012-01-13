From: "Jack Wang" <jack_wang@usish.com>
Subject: Re: [GIT PATCH v4 0/2] libsas: eh reworks (ata-eh vs discovery, races, ...)
Date: Fri, 13 Jan 2012 09:37:00 +0800
Message-ID: <93016D61E9AE4462B084F3715705FDD6@usish.com.cn>
References: <20120110073647.4563.7504.stgit@localhost6.localdomain6><9095644D6BEB42D8ADE7EB255D282AE8@usish.com.cn> <CABE8wwvovD1n8U6DLxKYSGMAJ2RwLb=gxF=xCy98Bci_aEvNCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:53664 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825Ab2AMBia convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2012 20:38:30 -0500
In-Reply-To: <CABE8wwvovD1n8U6DLxKYSGMAJ2RwLb=gxF=xCy98Bci_aEvNCQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Dan Williams' <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

>=20
> On Thu, Jan 12, 2012 at 4:57 PM, Jack Wang <jack_wang@usish.com> wrot=
e:
> > Hi Dan,
> >
> > Thanks for your fix, I do test this with new patchset, this works g=
ood for
> > me.
> > Only one thing confuse me, kernel sometimes print cmd timed out whe=
n disk
> > attached.
> > Like :
> > "
> > [  312.732468] sd 4:0:11:0: [sdl] command ffff88032c6eaa00 timed ou=
t
> > [  312.753114] sd 4:0:13:0: [sdn] command ffff88032c6eb000 timed ou=
t
> > [  312.753257] sd 4:0:4:0: [sde] command ffff88032903e800 timed out
> > [  312.753266] sd 4:0:14:0: [sdo] command ffff880329284c00 timed ou=
t
> > [  312.755304] sd 4:0:1:0: [sdb] command ffff8801b4b80600 timed out
> > [  312.797458] sd 4:0:15:0: [sdp] command ffff880329285900 timed ou=
t
> > "
> > Although, this is no harm.
>=20
> These were probably timeouts that were happening before but did not
> get reported by the old sas_scsi_timed_out().
>=20
> So, I'm still trying to figure out what to do about the "failure to
> transmit signature-fis" case that you sent a patch to address.  I'm
> wondering if we need to schedule rediscovery after a longer timeout?
> I agree with skipping sas_set_ex_phy(), but for initial discovery it
> would be nice to know that we have a device out there that is trying
> to connect and hold off ->scan_finished() until libsas has given up o=
n
> waiting for that phy to settle.
>=20
> For example libata will reset 3 times with increasing wait times (10s=
,
> 10s, 35s).  On the last attempt it will slow down the phy to give the
> ata device a better chance of connecting.  libsas is just doing 3
> 500ms tries at full speed and then giving up.
[Jack Wang]=20
Yes=EF=BC=8C in our internal test I expand the time to 10s, but I'm not=
 sure this will be accepted by mainline kernel.
>=20
> Wouldn't mind someone from libata land commenting on how libsas can b=
e
> more helpful to struggling sata devices.
>=20
> "Let libata do it" would be my first choice, but at the point where w=
e
> are discovering this condition we don't yet have an ata_port, and
> libsas only creates an ata_port *after* receiving a signature-fis.
> Maybe we could create an unattached ata_port (i.e. with a stand-in
> domain_device), but libsas would need to learn how to attach and prob=
e
> the domain_device after the fact.
>=20
> --
> Dan

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
