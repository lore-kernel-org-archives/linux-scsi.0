From: Kyle Moffett <kyle@moffetthome.net>
Subject: Re: MD/RAID time out writing superblock
Date: Sun, 20 Sep 2009 20:02:04 -0400
Message-ID: <f73f7ab80909201702q4661cfe4t5b7b8449ba12306a@mail.gmail.com>
References: <20090917115728.GA13854@arachsys.com> <4AB2596D.10809@kernel.org>
	<4AB67883.3010500@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755605AbZIUACY@vger.kernel.org>
In-Reply-To: <4AB67883.3010500@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Chris Webb <chris@arachsys.com>, Neil Brown <neilb@suse.de>, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, Sep 20, 2009 at 14:46, Robert Hancock <hancockrwd@gmail.com> wr=
ote:
> On 09/17/2009 09:44 AM, Tejun Heo wrote:
>>>
>>> Thanks Neil. This implies that when we see these fifteen second
>>> hangs reading /proc/mdstat without write errors, there are genuinel=
y
>>> successful superblock writes which are taking fifteen seconds to
>>> complete, presumably corresponding to flushes which complete but
>>> take a full 15s to do so.
>>>
>>> Would such very slow (but ultimately successful) flushes be
>>> consistent with the theory of power supply issues affecting the
>>> drives? It feels like the 30s timeouts on flush could be just a mor=
e
>>> severe version of the 15s very slow flushes.
>>
>> Probably not. =C2=A0Power problems usually don't resolve themselves =
with
>> longer timeout. =C2=A0If the drive genuinely takes longer than 30s t=
o
>> flush, it would be very interesting tho. =C2=A0That's something peop=
le have
>> been worrying about but hasn't materialized yet. =C2=A0The timeout i=
s
>> controlled by SD_TIMEOUT in drivers/scsi/sd.h. =C2=A0You might want =
to bump
>> it up to, say, 60s and see whether anything changes.
>
> It's possible if the power dip only slightly disrupted the drive it m=
ight
> just take longer to complete the write. I've also seen reports of vib=
ration
> issues causing problems in RAID arrays (there's a video on Youtube of=
 a guy
> yelling at a Sun disk array during heavy I/O and the resulting vibrat=
ions
> causing an immediate spike in I/O service times). Could be something =
like
> that causing issues with simultaneous media access to all drives in t=
he
> array, too..

There have been a rather large number of reported firmware problems
lately with various models of Seagate SATA drives; typically they
cause command timeouts and occasionally they completely brick the
drive (restart does not fix it).  I possessed 3 of these for a while
and they pretty consistently fell over (even with just 3 in a
low-power-CPU box with a good PSU rated for 8 drives).

You might check with the various Seagate tech support lines to see if
your drive firmwares are affected by the bugs (Some were related to
NCQ command processing, others were just single-command failures).

Cheers,
Kyle Moffett
