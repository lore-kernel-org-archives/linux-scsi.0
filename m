From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: SCSI mid layer and high IOPS capable devices
Date: Fri, 14 Dec 2012 12:59:49 +0800
Message-ID: <008f01cdd9b7$d84fbf80$88ef3e80$@com>
References: <20121211000013.GI23107@beardog.cce.hp.com>	<50C9F2B9.4050500@acm.org>	<20121213172513.GH20898@beardog.cce.hp.com>	<50CA0692.2010903@acm.org>	<005c01cdd991$18d59bf0$4a80d3d0$@com>	<CADzpL0TMT31yka98Zv0=53N4=pDZOc9+gacnvDWMbj+iZg4H5w@mail.gmail.com>	<006301cdd99c$35099b40$9f1cd1c0$@com> <CADzpL0S5cfCRQftrxHij8KOjKj55psSJedmXLBQz1uQm_SC30A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:41080 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab2LNE74 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Dec 2012 23:59:56 -0500
In-Reply-To: <CADzpL0S5cfCRQftrxHij8KOjKj55psSJedmXLBQz1uQm_SC30A@mail.gmail.com>
Content-Language: zh-cn
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Stephen Cameron' <stephenmcameron@gmail.com>
Cc: 'Bart Van Assche' <bvanassche@acm.org>, "'Stephen M. Cameron'" <scameron@beardog.cce.hp.com>, linux-scsi@vger.kernel.org, 'dbrace' <dab@hp.com>

Steve,

Thanks for share detail of your problem.

Yes you =91re right about test I talk. Now I know what you want to disc=
uss on
this thread.

Jack

Right, but if I understand you correctly, you're ganging up 24 device q=
ueues
and measuring aggregate iops across them all.=A0 That is, you have 24 S=
AS
disks all presented individually to the OS, right? (or did the controll=
er
aggregate them all into 1 logical drive presented to the OS?)

I'm talking about one very low latency single device capable of let's s=
ay
450k iops all by itself.=A0 The problem is that with the scsi mid layer=
 in
this case, there can only be a single request queue feeding that one de=
vice
(unlike your 24 request queues feeding 24 devices.)=A0 That single requ=
est
queue is essentially single threaded -- only one cpu can touch it at a =
time
to add or remove a request from it.=A0 With the block layer's make_requ=
est
interface, I can take advantage of parallelism in the low level block d=
river
and get essentially a queue per cpu feeding the single device.=A0 With =
the
scsi mid layer, the low level driver's queue per cpu is (if I am correc=
t)
throttled by the fact that what is feeding those lld queues is one
(essentially) single threaded request queue.=A0 It doesn't matter that =
the
scsi LLD has a twelve lane highway leading into it because the scsi mid=
layer
has a 1 lane highway feeding into that 12 lane highway.=A0 If I underst=
and you
correctly, you get 800k iops by measuring 24 highways going to 24 diffe=
rent
towns.=A0 I have one town and one highway.=A0 The part of my highway th=
at I
control can handle several hundred kiops, but the part I don't control
seemingly cannot.

That is why scsi_debug driver can't get very high iops on a single
pseudo-device, because there's only one request queue and that queue is
protected by a spin lock.=A0 perf shows contention on spin locks in
scsi_request_fn()=A0 -- large percentage of cpu time spent trying to ge=
t spin
locks in scsi_request_fn().=A0 I forget the exact number right now, but=
 iirc,
it was something like 30-40%.

That is sort of the whole problem I'm having, as best I understand it, =
and
why I started this thread.=A0=A0 And unfortunately I do not have any ve=
ry good
ideas about what to do about it, other than use the block layer's make
request interface, which is not ideal for a number of reasons (e.g. peo=
ple
and software (grub, etc.) are very much accustomed to dealing with the =
sd
driver, and all other things being equal, using the sd driver interface=
 is
very much preferable.)

With flash based storage devices, the age old assumptions that "disks" =
are
glacially slow compared to the cpu(s) and seek penalties exist and are =
to be
avoided which underlie the design of the linux storage subsystem
architecture are starting to become false.=A0 That's kind of the "big p=
icture"
view of the problem.

Part of me thinks what we really ought to do is make the non-volatile
storage look like RAM at the hardware level, more or less, then put a r=
amfs
on top of it, and call it done (there are probably myriad reasons it's =
not
that simple of which I'm ignorant.)

-- steve

On Thu, Dec 13, 2012 at 7:41 PM, Jack Wang <jack_wang@usish.com> wrote:
=A0
Maybe, and good to know for real-world scenarios, but scsi-debug with
fake_rw=3D1 isn't even actually doing the i/o.=A0 I would think sequent=
ial,
random, whatever wouldn't matter in that case, because presumably, it's=
 not
even looking at the LBAs, much less acting on them, nor would I expect =
the
no-op i/o scheduler to be affected by the LBAs.

-- steve
=46or read world hardware, I tested with next generation PMCS SAS contr=
oller
with 24 SAS disks, 512 sequential read with more than 800K , 512 sequen=
tial
write with more than 500K
similar results with windows 2008, but SATA performance did worse than
windows
kernel is 3.2.x as I remembered.
Jack
=A0
On Thu, Dec 13, 2012 at 6:22 PM, Jack Wang <jack_wang@usish.com> wrote:
On 12/13/12 18:25, scameron@beardog.cce.hp.com wrote:
> On Thu, Dec 13, 2012 at 04:22:33PM +0100, Bart Van Assche wrote:
>> On 12/11/12 01:00, scameron@beardog.cce.hp.com wrote:
>>> The driver, like nvme, has a submit and reply queue per cpu.
>>
>> This is interesting. If my interpretation of the POSIX spec is
>> correct then aio_write() allows to queue overlapping writes and all
>> writes submitted by the same thread have to be performed in the orde=
r
>> they were submitted by that thread. What if a thread submits a first
>> write via aio_write(), gets rescheduled on another CPU and submits a
>> second overlapping write also via aio_write() ? If a block driver
>> uses one queue per CPU, does that mean that such writes that were
>> issued in order can be executed in a different order by the driver
>> and/or hardware than the order in which the writes were submitted ?
>>
>> See also the aio_write() man page, The Open Group Base Specification=
s
>> Issue 7, IEEE Std 1003.1-2008
>>
(http://pubs.opengroup.org/onlinepubs/9699919799/functions/aio_write.ht=
ml).
>
> It is my understanding that the low level driver is free to re-order
> the i/o's any way it wants, as is the hardware. =A0It is up to the
> layers above to enforce any ordering requirements. =A0For a long time
> there was a bug in the cciss driver that all i/o's submitted to the
> driver got reversed in order -- adding to head of a list instead of t=
o
> the tail, or vice versa, I forget which -- and it caused no real
> problems (apart from some slight performance issues that were mostly
masked by the Smart Array's cache.
> It was caught by firmware guys noticing LBAs coming in in weird order=
s
> for supposedly sequential workloads.
>
> So in your scenario, I think the overlapping writes should not be
> submitted by the block layer to the low level driver concurrently, as
> the block layer is aware that the lld is free to re-order things. =A0=
(I
> am very certain that this is the case for scsi low level drivers and
> block drivers using a request_fn interface -- less certain about bloc=
k
> drivers using the make_request interface to submit i/o's, as this
> interface is pretty new to me.

As far as I know there are basically two choices:
1. Allow the LLD to reorder any pair of write requests. The only way
=A0 =A0 for higher layers to ensure the order of (overlapping) writes i=
s then
=A0 =A0 to separate these in time. Or in other words, limit write reque=
st
=A0 =A0 queue depth to one.
2. Do not allow the LLD to reorder overlapping write requests. This
=A0 =A0 allows higher software layers to queue write requests (queue de=
pth
=A0 =A0 > 1).

=A0From my experience with block and SCSI drivers option (1) doesn't lo=
ok
attractive from a performance point of view. From what I have seen
performance with QD=3D1 is several times lower than performance with QD=
 > 1.
But maybe I overlooked something ?



Bart.
I was seen low queue depth improve sequential performance, and high que=
ue
depth improve random performance.

Jack

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html
=A0


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
