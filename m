From: Barto <mister.freeman@laposte.net>
Subject: Re: BUG in scsi_lib.c due to a bad commit
Date: Sun, 16 Nov 2014 19:30:59 +0100
Message-ID: <5468ED63.4010709@laposte.net>
References: <54629CAE.2000207@laposte.net> <CAErSpo6FFK6zMOWSK9=dOOMKjWd1soAyj9r73yP8Z_U4F9ygAA@mail.gmail.com> <5462CB90.1080303@roeck-us.net> <54642541.9080302@laposte.net> <94D0CD8314A33A4D9D801C0FE68B4029593A1880@G9W0745.americas.hpqcorp.net> <54647C10.4070506@laposte.net> <20141113142907.GB29354@infradead.org> <5464E6E6.3090606@laposte.net> <20141113175402.GA27327@infradead.org> <546536EA.4070705@laposte.net> <20141114073214.GA1879@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141114073214.GA1879@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Guenter Roeck <linux@roeck-us.net>, Bjorn Helgaas <bhelgaas@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Joe Perches <joe@perches.com>
List-Id: linux-scsi@vger.kernel.org

Hello everyone,

> Also, SCSI_QUEUE_DELAY seems like an arbitrary magic number;
> maybe that value isn't working correctly anymore?

this is an excellent remark from Robert Elliot,

this gives me an idea : try to set manually a value in the if()
statement ( line 1779 in file /drivers/scsi/scsi_lib.c )

by default the value of SCSI_QUEUE_DELAY is 3 ms, which might be
inapropriate with some slow harddisks and with the changes made by the
commit
74665016086615bbaa3fa6f83af410a0a4e029ee ( scsi: convert host_busy to
atomic_t ),

after further tests I discover that the value 40 ms solves my problem,
the bug is gone with this value,

here is the patch who sets 40 ms in the if() statement :

--- a/drivers/scsi/scsi_lib.c	2014-10-05 21:23:04.000000000 +0200
+++ b/drivers/scsi/scsi_lib.c	2014-11-16 17:39:16.819674725 +0100
@@ -1776,7 +1776,7 @@ static void scsi_request_fn(struct reque
 	atomic_dec(&sdev->device_busy);
 out_delay:
 	if (!atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev))
-		blk_delay_queue(q, SCSI_QUEUE_DELAY);
+		blk_delay_queue(q, 40);
 }

 static inline int prep_to_mq(int ret)

with this patch the value of SCSI_QUEUE_DELAY is still 3 ms, but here w=
e
use 40 ms only in a specific part of scsi_lib.c file ( line 1779, it's
this part where the bug seems to be triggered, so that's why I set 40 m=
s
here in the blk_delay_queue() function )

after applying this patch I don't see problems related to I/O
performance/speed, all is ok,

the question is now : why putting a higher value in line 1779 does solv=
e
the bug ?
and why before the commit 74665016086615bbaa3fa6f83af410a0a4e029ee I
don't have problems even with a value of 3 ms for SCSI_QUEUE_DELAY ?



Le 14/11/2014 08:32, Christoph Hellwig a =E9crit :
> On Thu, Nov 13, 2014 at 11:55:38PM +0100, Barto wrote:
>> it's interesting, with this commit
>> 74665016086615bbaa3fa6f83af410a0a4e029ee I have the bug :
>>
>> scsi: convert host_busy to atomic_t :
>=20
> At this point we'll need a bisction between v3.16 as the last good
> point, and 74665016086615bbaa3fa6f83af410a0a4e029ee as the known bad
> point.
>=20
