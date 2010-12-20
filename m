From: Hannes Reinecke <hare@suse.de>
Subject: Re: RFC: short reads on block devices
Date: Mon, 20 Dec 2010 10:43:00 +0100
Message-ID: <4D0F2524.5030407@suse.de>
References: <4D0B945C.2060309@interlog.com> <1292618194.2820.90.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1292618194.2820.90.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: dgilbert@interlog.com, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Penokie, George" <George.Penokie@lsi.com>, mkp@mkp.net
List-Id: linux-scsi@vger.kernel.org

On 12/17/2010 09:36 PM, James Bottomley wrote:
> On Fri, 2010-12-17 at 11:48 -0500, Douglas Gilbert wrote:
>> Recently while testing with the scsi_debug driver
>> I was able to trick the block layer into reading
>> random data which the block layer thought was
>> valid ***.
>>
>> Best to start with an example, say LBA ** 4660 has
>> an unrecoverable error (aka medium error) and
>> the block layer fires off a SCSI READ for 8
>> blocks (512 byte variety) at LBA 4656. The response
>> will be a medium error with the sense buffer info
>> field indicating LBA 4660. Now are the 4 blocks
>> that precede it (i.e. LBA 4656 to 4659) possibly
>> sitting in the data-in buffer and valid??
>>
>> The block layer thinks they are. This is what my
>> term "short read" in the title alludes to. So I put
>> this question to the T10 reflector:
>>     http://www.t10.org/t10r.htm
>> titled "sbc: reading blocks prior to a medium error".
>> And the answers were pretty clear. And the one from
>> George Penokie of LSI is interesting because Linux's
>> block layer assumption breaks some of LSI's equipment.
>=20
> Well, unsurprisingly, I was aware of the issue via Novell customer
> interactions.  Since you've outed LSI, we can discuss it openly.
>=20
> The fact is that for medium errors, every other array returns valid d=
ata
> up to the erroring sector.
>=20
>> On the other hand, big array vendors and database vendors
>> want exactly what the block layer is doing at the moment.
>> So those guys don't want a change. [Please correct me
>> if that is too sweeping.] Also I'm informed some other
>> OSes do this as well.
>=20
> Plus all disk devices transfer up to the error sector.  Additionally,
> Martin Petersen uses the same code for DIF and he's secured external
> agreement from the DIF based arrays that nothwithstanding the ambigui=
ty
> in the SCSI standards, all DIF arrays return valid data up to the sec=
tor
> with the DIF error.
>=20
>> I would like to propose a solution, at least in the SCSI
>> subsystem context. The 'resid' field was added 11 years
>> ago and is used by a HBA driver to indicate how many bytes
>> less than requested were placed in the scatter gather
>> list (i.e. the data-in buffer). It defaults to zero
>> (meaning all requested bytes have been read). Usually
>> for a medium error one would not bother setting resid
>> (so resid would remain 0). Somewhat surprisingly the
>> block layer has always ignored resid. I propose in the
>> case of a short read caused by a MEDIUM ERROR the block
>> layer checks resid. And if resid equals the requested
>> number of bytes then that means no data in the scatter
>> gather list is valid. So the block layer should act on
>> this information.
>>
>> To this end I propose to change the scsi_debug driver
>> to set resid equal to bufflen when it simulates a
>> medium error.
>>
>> Changes in the block layer and drivers from vendors who
>> want the strict "T10" handling of medium errors would
>> also be required. Maybe the USB mass storage (and UAS)
>> folks might also check if this impacts them.
>=20
> OK, so I checked, and I think all of the major in-use HBA drivers tod=
ay
> do set the residue, so I'd be reasonably happy with a modification li=
ke
> the following.  It basically believes the lower of either the
> transferred data or the listed error (assuming the listed error is
> valid ... if it's invalid, we still assume we can't trust anything).
> This should mean that HBA drivers that set the residue work for all
> arrays and those that don't work as they do today.
>=20
Okay, having been part of the discussion (and the resulting
specification digging) I'm not quite convinced that this minimal
patch does entirely the right thing.

After all, T10 said we should consider the buffer as invalid in the
face of read or write errors, despite the fact that some bits in
there _may_ be valid.

So the correct approach here would be to retry the command
with a short read up to the size indicated in the sense code;
that should avoid the error and the buffer would be filled with
correct data.

And with that approach we would be keeping everyone happy.

Hmm. Someone should do a patch here :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
