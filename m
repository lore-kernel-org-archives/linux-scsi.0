From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: How to get more sequential IO merged at elevator
Date: Tue, 6 May 2014 10:06:34 +0000
Message-ID: <471cb78e78284a109ca9cc2571ebb9c6@BN1PR07MB247.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:13339
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934646AbaEFKGt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 May 2014 06:06:49 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

I got some clue on what was going on while doing 4K sequential read usi=
ng fio.

If I use ioengine in fio script as "libaio", I see " do_io_submit" call=
 plug/unplug the queue before submitting the IO.
It means after every IO, we expect to send IO immediately to the next l=
ayer. If at all there are any pending IO do merge.. but not due to plug=
ging.

This is what happens on my test. Every time IO comes from application w=
ith libaio engine, it send down to the elevator/io-scheduler because qu=
eue was unplugged in=20
do_io_submit(). Moment I reduce the queue depth of the block device, me=
rge start because of congestion at scsi mid layer.

If I use, mmap engine, I see merged IO coming to the device driver beca=
use of plugging. I really don't know how it works, but gave a try and f=
ound merge happen because of plugging. ( I confirm using blktrace)

Is there any ioengine in <fio> (or any other parameter setting), which =
can use plugging mechanism of block layer to merge more IO other than m=
map ?

~ Kashyap

> -----Original Message-----
> From: Desai, Kashyap
> Sent: Wednesday, April 30, 2014 12:33 PM
> To: 'axboe@kernel.dk'
> Cc: linux-scsi@vger.kernel.org
> Subject: How to get more sequential IO merged at elevator
>=20
> Jens,
>=20
> While working on one issue of less IOPs for sequential READ/WRITE, I =
found
> interesting stuffs which was causing performance drop for sequential =
IO.=A0 I
> did some reverse engineering on Block layer code to understand how to=
 get
> benefit from any sysfs parameters settings, but could not find anythi=
ng
> useful to solve this issue.
>=20
> I have described problem statement and root cause of this issue in th=
is mail
> thread.
>=20
> Problem statement - "Cannot achieve Sequential read/write performance=
,
> because of back merge is not happening frequently"
>=20
> Here is my understanding of back merge done in elevator.
>=20
> Linux block layer is responsible for merging/sorting of the IO with t=
he help of
> Elevator hook in OS + IO scheduler.
> IO scheduler does not have any role in merging sequential IO. It is d=
one in
> Elevator hook, so choosing any IO scheduler in Linux will not help (O=
R you can
> consider that behavior will be unchanged irrespective of IO scheduler=
). Any
> sequential IO will be merge at Elevator code path.
>=20
> 1. When IO comes from upper layer, it will be queued at Elevator/IO
> scheduler level. =A0It will also add IO into hash look up which will =
be used for
> merge and other purpose.
> 2. Elevator code will search any outstanding IO (in the queue of the =
same
> layer). If there is any chance to merge it, it will perform  (BACK ME=
RGE)
> merge 3. If there is no merge possible, IO will be queued to the next=
 level
> (which is IO scheduler).
> 4. In IO completion Path, IO scheduler will post IO to the Driver que=
ue, if at all
> there is any outstanding IO. (There are many other condition, but thi=
s is very
> common code path)
>=20
> To merge more command, #2 should find more outstanding in hash table
> look up. This is possible if flow control start either at block layer=
/Driver level.
> It means, driver/block layer forcefully delay IO submission to next l=
evel and
> give more chance at elevator code to merge more IO via accumulating m=
ore
> IO from user space.
>=20
> If I manually change queue depth of the device to lower value (betwee=
n 1-
> 8), which is doing only Sequential IO.. I am able to see maximum IO c=
oming to
> the driver after merge and it eventually increase the IOPs.
>=20
> Is there any way to increase possibility of merged IO coming from blo=
ck layer
> to the Low level driver ?
>=20
> Thanks, Kashyap
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
