From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: MPTSAS: ("activate status led" | "find disc") in external
	enclosure
Date: Tue, 22 Apr 2008 11:12:14 -0500
Message-ID: <1208880734.3105.24.camel@localhost.localdomain>
References: <20080418124104.9ca87130.taeuber@bbaw.de>
	 <1208528945.3063.7.camel@localhost.localdomain>
	 <20080421110148.1918485e.taeuber@bbaw.de>
	 <1208791005.3640.10.camel@localhost.localdomain>
	 <20080422091837.12790125.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47139 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752790AbYDVQMT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2008 12:12:19 -0400
In-Reply-To: <20080422091837.12790125.taeuber@bbaw.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lars =?ISO-8859-1?Q?T=E4uber?= <taeuber@bbaw.de>
Cc: linux-scsi@vger.kernel.org

On Tue, 2008-04-22 at 09:18 +0200, Lars T=C3=A4uber wrote:
> James Bottomley <James.Bottomley@HansenPartnership.com> schrieb:
> > On Mon, 2008-04-21 at 11:01 +0200, Lars T=C3=A4uber wrote:
> > > # ls /sys/class/enclosure/*/
> > > /sys/class/enclosure/6:0:16:0/:
> > > 0  10  12  14  2  4  6  8  components  subsystem
> > > 1  11  13  15  3  5  7  9  device      uevent
> > >=20
> > > /sys/class/enclosure/6:0:33:0/:
> > > 0  10  12  14  2  4  6  8  components  subsystem
> > > 1  11  13  15  3  5  7  9  device      uevent
> > >=20
> > > This is two times the same enclosure.
> >=20
> > That's unusual .. to have two devices managing the same enclosure, =
but
> > if you only have 16 slots and not 32, I suppose it must be so.
>=20
> I use both external connections to both expanderboards of the enclosu=
re just for redundancy.
>=20
>=20
> > > monosan:/sys/class/enclosure/6:0:16:0/0 # ls -l
> > > insgesamt 0
> > > -rw-r--r-- 1 root root 4096 21. Apr 10:48 active
> > > -rw-r--r-- 1 root root 4096 21. Apr 10:48 fault
> > > -rw-r--r-- 1 root root 4096 21. Apr 10:48 locate
> > > -rw-r--r-- 1 root root 4096 21. Apr 10:48 status
> > > lrwxrwxrwx 1 root root    0 21. Apr 10:46 subsystem -> ../../../e=
nclosure_component
> > > -r--r--r-- 1 root root 4096 21. Apr 10:48 type
> > > --w------- 1 root root 4096 21. Apr 10:48 uevent
> > >=20
> > > There seems to be no device link if I understood you correctly.
> > > Is the subdirctory numbering somehow in relation to the SCSI ID?
> >=20
> > If the slot is populated a device link should appear (this
> > is the tricky bit because the ses driver uses VPD inquiries to matc=
h up
> > the reported disk, assuming the enclosure reports it, to the actual=
 one.
> > These work for SAS disks, but not for SATA ones).
>=20
> So this will never work for the SATA discs in our enclosure, right? O=
r is there a chance with asking LSI to do something in their firmware?

I don't think its an LSI issue.  The enclosure itself collects WWNs fro=
m
the inserted drives.  SAS drives have an agreed format which they
present in a VPD INQUIRY, so they're easy to match up.  SATA drives hav=
e
a defined way of manufacturing this information (defined in the SAT
standard).  I just need to plug one of these in and make sure my
enclosure does this correctly.  Once that's done, I have to persuade th=
e
ATA people to add the correct form of translation for the VPD inquiry t=
o
libata's SAT layer ... then it should all "just work".  So it's
basically just some development work.

> Seems I have no chance to get to know which slot contains the failed =
drive without a shutdown. Bad luck.

You could start by asking the sg_ses tools what you have.  You need to
find the sg device for your enclosure and then do

sg_ses --page=3D10 /dev/sg<n>

It will print out a list of what the enclosure thinks the addresses for
the devices are.  Then I just need to verify they're SAT format and awa=
y
we can go.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
