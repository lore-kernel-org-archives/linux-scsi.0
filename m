From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [SCSI] libsas: remove expander from dev list on error
Date: Wed, 31 Aug 2011 09:52:26 -0700 (PDT)
Message-ID: <1314809546.41862.YahooMailNeo@web31808.mail.mud.yahoo.com>
References: <1311747048.72460.YahooMailNeo@web31810.mail.mud.yahoo.com> <CAA9_cmc3RWUFsWkyO4qnTLbVTmcGv51Ab8LyJqJUbNHbnx0kCg@mail.gmail.com>
Reply-To: Luben Tuikov <ltuikov@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm1.bullet.mail.sp2.yahoo.com ([98.139.91.71]:32613 "HELO
	nm1.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756808Ab1HaQw2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Aug 2011 12:52:28 -0400
In-Reply-To: <CAA9_cmc3RWUFsWkyO4qnTLbVTmcGv51Ab8LyJqJUbNHbnx0kCg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "JBottomley@Parallels.com" <JBottomley@parallels.com>, Jack Wang <jack_wang@usish.com>

----- Original Message -----

> From: Dan Williams <dan.j.williams@intel.com>
> To: Luben Tuikov <ltuikov@yahoo.com>
> Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>; "linux=
-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; "JBottomley@Pa=
rallels.com" <JBottomley@parallels.com>; Jack Wang <jack_wang@usish.com=
>
> Sent: Wednesday, July 27, 2011 1:32 PM
> Subject: Re: [PATCH] [SCSI] libsas: remove expander from dev list on =
error
>=20
> On Tue, Jul 26, 2011 at 11:10 PM, Luben Tuikov <ltuikov@yahoo.com> wr=
ote:
>>  If expander discovery fails (sas_discover_expander()),
>>  remove the expander from the port device list
>>  (sas_ex_discover_expander()), before freeing it. Else
>>  the list is corrupted and, e.g., when we attempt to send
>>  SMP commands to other devices, the kernel oopses.
>>=20
>>  Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
>>  Reviewed-by: Jack Wang <jack_wang@usish.com>
>>  ---
>>  =A0drivers/scsi/libsas/sas_expander.c |=A0=A0=A0 3 +++
>>  =A01 files changed, 3 insertions(+), 0 deletions(-)
>>=20
>>  diff --git a/drivers/scsi/libsas/sas_expander.c=20
> b/drivers/scsi/libsas/sas_expander.c
>>  index 874e29d..f84084b 100644
>>  --- a/drivers/scsi/libsas/sas_expander.c
>>  +++ b/drivers/scsi/libsas/sas_expander.c
>>  @@ -849,6 +849,9 @@ static struct domain_device *sas_ex_discover_ex=
pander(
>>=20
>>  =A0=A0=A0=A0=A0=A0=A0 res =3D sas_discover_expander(child);
>>  =A0=A0=A0=A0=A0=A0=A0 if (res) {
>>  +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 spin_lock_irq(&parent->=
port->dev_list_lock);
>>  +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 list_del(&child->dev_li=
st_node);
>>  +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 spin_unlock_irq(&parent=
->port->dev_list_lock);
>>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 kfree(child);
>>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return NULL;
>=20
> Acked-by: Dan Williams <dan.j.williams@intel.com>
>=20
> ...but it raises a couple questions for potential follow on patches:
>=20
> 1/ Do we need to add the device to port->dev_list prior to the
> discovery?=A0 Seems cleaner to defer the list_add until after the
> discovery has succeeded.

In my original SAS Transport layer, devices were added to the
port device list in one and only one place, after discovery,
at sas_kobj_set() (which doesn't exist now because my code was
edited off-line before being submitted into the kernel by Bottomley).
Thus due to the architecture of the code, this bug doesn't exist in my =
original
implementation, but was introduced in the version submitted by Bottomle=
y,
when devices are being added to the port list in more than one place.

My development git history was removed as the code was taken
off my git trees, edited off line, off git, and then submitted, thus er=
asing
its original state or its development history (in git). So it's now imp=
ossible
for a 3rd party to see what bugs were introduced due to those off-line
changes before submission.

And as you can see, there are bugs. The bugs are, as I can see, stemmin=
g
from the current _explicitness_ of libsas, a la, just-in-place fix, as =
if
someone has been studying the code by line-stepping it with a debugger,
and then going "A-ha! Here is where we can stick this in." SATA support
seems to have been added in a similar manner, "where can we stick this
to get it to work". I.e. there is no grand architecture, no vision.

The original code, was much more implicit: you had to pull back to see
what was happening.

It was designed as a transport layer. For example, for a new SAS
controller, you'd only need to write a PCI device driver which exposed
the ASIC's particular domain access implementation in a structure
of function pointers, that the PCI LLDD fills in, and the SAS Transport
Layer (SAS TL) fills in, and this is how both communicate. Then,
the SAS TL would register with the SCSI layer. It was a beautiful solut=
ion
of enterprise quality and design. SATA support was added in 2006 which
is _not_ libsata, but also a layer of abstraction with a structure of f=
unction
pointers, in effect allowing you to register a SATA device on _any_ tra=
nsport
protocol, not only SAS, as a matter of filling in the stubs of a few fu=
nction pointers.
(Thus also allowing you to easily emulate a SATA device if you so desir=
e.)

The original SAS TL, also represented the whole SAS domain in sysfs,
exactly as it would look like in the physical world and was thus really
easy to do "tree -d" and then look at your work bench or rack and see
what is connected to what or what is missing or has been added.
See this http://marc.info/?l=3Dlinux-scsi&m=3D112629509826900&w=3D2,
for example.

The event infrastructure, removed by Bottomley, allowed for an infinite=
 number
of events in a finite amount of memory. Removing it, introduced a few b=
ugs, which
were I believe fixed back then, but it is impossible to know how many m=
ore there are.

> 2/ We have unlocked list manipulations in sas_ex_discover_end_dev(),
> sas_unregister_common_dev(), and sas_ex_discover_end_dev()

Yes, I can see that and that is very unfortunate. And as I mentioned, t=
his
doesn't exist in the original design of the code. The point is that aft=
er
the changes offline people using Linux end up with substandard
and mediocre implementation of SAS.

Locking and coherency were achieved via the kobj infrastructure which w=
as
a beautiful thing at the time, but has seen its number of changes begin=
ning
in 06-07 (git can help there).

=A0=A0 Luben
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
