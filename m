From: Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
Date: Tue, 31 Jul 2007 23:45:25 +0900
Message-ID: <46AF4B05.4010700@gmail.com>
References: <20070705194909.337398431@intel.com>	 <20070705130518.135e4e3c.kristen.c.accardi@intel.com>	 <46AE12B6.6090408@garzik.org>  <46AED656.8070407@gmail.com> <1185891382.2750.8.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1185891382.2750.8.camel@laptopd505.fenrus.org>
Sender: linux-ide-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>, Kristen Carlson Accardi <kristen.c.accardi@intel.com>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, edwintorok@gmail.com, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

Arjan van de Ven wrote:
> On Tue, 2007-07-31 at 15:27 +0900, Tejun Heo wrote:
>> Jeff Garzik wrote:
>>> Any chance the SCSI peeps could ACK this, and then let me include i=
t in
>>> the ALPM patchset in the libata tree?
>> ATA link PS is pretty complex with HIPM, DIPM and AHCI ALPM.  I'm no=
t
>> sure whether this three level knob would be sufficient.=20
>=20
> adding more levels later is easy.

Dunno whether they would be linear levels and putting HIPM, DIPM, ALPM
selection into SCSI sysfs knob doesn't look so appealing.

>>  It might be
>> good enough if we're gonna develop extensive in-kernel black/white l=
ist
>> specifying which method works on which combination but my gut tells =
me
>> that it's best left to userland (probably in the form of per-noteboo=
k PS
>> profile).
>=20
> either sucks. AHCI ALPM ought to work if it's supported; it's what ot=
her
> operating systems also use...=20
>> Adding to the fun, there are quite a few broken devices out there wh=
ich
>> act weirdly when link PS actions are taken.
>=20
> do you have any specific examples that act funny with the patch in
> question here? (the patch tries to be careful, previous patches weren=
't
> always so please test this patch before claiming the concept as a who=
le
> is broken)

They were hardware problems.  I don't think any amount of proper
implementation can fix them.  I have one DVD RAM somewhere in my pile o=
f
hardware which locks up solidly if any link PS mode is used and had a
report of a HDD which had problem with link PS.  Can't remember the
details tho.  Also, IIRC one of my wendies spins down on SLUMBER.

>> Also, I generally don't think AHCI ALPM is a good idea.  It doesn't =
have
>> 'cool down' period before entering PS state
>=20
> that's a chipset implementation decision.... not part of the
> spec/technology per se.

That's actually something AHCI spec specifically states.  From section
8.3.1.3.

When PxCMD.ALPE is set to =E2=80=981=E2=80=99, if the HBA recognizes th=
at there are no
commands to process, the HBA shall initiate a transition to Partial or
Slumber interface power management state based upon the setting of
PxCMD.ASP. The HBA recognizes no commands to transmit as either:

    =E2=80=A2 PxSACT is set to 0h, and the HBA updates PxCI from a non-=
zero
value to 0h.
    =E2=80=A2 PxCI is set to 0h, and a Set Device Bits FIS is received =
that
updates PxSACT from a non-zero value to 0h.

Have no idea why it's specified this way.  Adding 100ms or 1s cool down
time wouldn't burn noticeably more power.  Maybe AHCI expects the host
driver to queue commands even for non-NCQ drives but libata currently
doesn't do that.

Anyways, I don't really think this attribute belongs to SCSI sysfs
hierarchy.  There currently isn't any alternative but sysfs is part of
userland visible interface and putting something into SCSI sysfs
hierarchy just because libata doesn't have one doesn't look like a good
idea.

sysfs isn't far from being detached from kobject and driver model.  I
think it would be best to wait a bit and build proper libata sysfs
hierarchy which won't have to be changed later when libata departs from
SCSI.  Well, it isn't really a good way but IMHO it's better than
sticking ATA power saving node into SCSI sysfs hierarchy.

Thanks.

--=20
tejun
