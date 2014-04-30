From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: How to get more sequential IO merged at elevator
Date: Wed, 30 Apr 2014 07:02:36 +0000
Message-ID: <33fd994ed1f241d8991f1c1de4a06907@BN1PR07MB247.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:54913
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751426AbaD3HC5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Apr 2014 03:02:57 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Jens,

While working on one issue of less IOPs for sequential READ/WRITE, I fo=
und interesting stuffs which was causing performance drop for sequentia=
l IO.=A0 I did some reverse engineering on Block layer code to understa=
nd how to get benefit from any sysfs parameters settings, but could not=
 find anything useful to solve this issue.=20

I have described problem statement and root cause of this issue in this=
 mail thread.=20

Problem statement - "Cannot achieve Sequential read/write performance, =
because of back merge is not happening frequently"

Here is my understanding of back merge done in elevator.

Linux block layer is responsible for merging/sorting of the IO with the=
 help of Elevator hook in OS + IO scheduler.
IO scheduler does not have any role in merging sequential IO. It is don=
e in Elevator hook, so choosing any IO scheduler in Linux will not help=
 (OR you can consider that behavior will be unchanged irrespective of I=
O scheduler). Any sequential IO will be merge at Elevator code path.

1. When IO comes from upper layer, it will be queued at Elevator/IO sch=
eduler level. =A0It will also add IO into hash look up which will be us=
ed for merge and other purpose.
2. Elevator code will search any outstanding IO (in the queue of the sa=
me layer). If there is any chance to merge it, it will perform  (BACK M=
ERGE) merge=20
3. If there is no merge possible, IO will be queued to the next level (=
which is IO scheduler).
4. In IO completion Path, IO scheduler will post IO to the Driver queue=
, if at all there is any outstanding IO. (There are many other conditio=
n, but this is very common code path)

To merge more command, #2 should find more outstanding in hash table lo=
ok up. This is possible if flow control start either at block layer/Dri=
ver level.
It means, driver/block layer forcefully delay IO submission to next lev=
el and give more chance at elevator code to merge more IO via accumulat=
ing more IO from user space.

If I manually change queue depth of the device to lower value (between =
1-8), which is doing only Sequential IO.. I am able to see maximum IO c=
oming to the driver after merge and it eventually increase the IOPs.

Is there any way to increase possibility of merged IO coming from block=
 layer to the Low level driver ?

Thanks, Kashyap
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
