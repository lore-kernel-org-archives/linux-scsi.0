From: Bernd Schubert <bernd-schubert@web.de>
Subject: i/o errors
Date: Wed, 23 Jun 2004 11:42:54 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200406231142.56957.bernd-schubert@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.uni-heidelberg.de ([129.206.100.212]:42408 "EHLO
	relay.uni-heidelberg.de") by vger.kernel.org with ESMTP
	id S265260AbUFWJm7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2004 05:42:59 -0400
Received: from euklid.pci.uni-heidelberg.de (euklid.pci.uni-heidelberg.de [129.206.21.104])
	by relay.uni-heidelberg.de (8.12.10/8.12.10) with ESMTP id i5N9gw1K011056
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jun 2004 11:42:58 +0200 (MET DST)
Received: from bernd by euklid.pci.uni-heidelberg.de with local (Exim 3.35 #1 (Debian))
	id 1Bd4HR-0005jf-00
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jun 2004 11:42:57 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello,

we have trouble with our transtec 5008 IDE/SCSI raid array, sometimes t=
he=20
scsi-driver reports i/o erros. Due to the reason described below, I'm n=
ot so=20
sure if those i/o errors are really caused by the raid-array. So I want=
 to=20
ask if the linux scsi-system might cause/report wrong errors?

Description:
The mainserver (with the transtec raid array) is connect via a gigabit=20
ethernet connection to a failover server. Some partitions on the main s=
erver=20
are mirrored via drbd with this failover server. During a full resync f=
rom=20
the failover server and write speeds of about 50-60MB/s it happens that=
 the=20
raid array doesn't respond any more and so the scsi driver resets the b=
us.=20
Well, though that is not nice, it still doesn't cause any harm. Its muc=
h=20
worse, that sometimes after such reset the scsi driver might report an =
I/O=20
error of the device, in that case drbd will stop the system immediately=
=2E

=46irst I thought its a bug of the scsi-driver, after Justin T. Gibbs t=
old me=20
that it can't be a bug of the driver, I contacted transtec and we got t=
he=20
raid array replaced with a new one. Unfortunality this didn't solve our=
=20
problems.  To be sure its not a controller, cable, etc. bug, we connect=
ed the=20
raid array with completely different cables to the failover server, whi=
ch=20
also has a MPT scsi controller instead of the Adaptec controller of the=
 main=20
server, but the same problems remained.
So that probably means the the transtec array has a general bug?

However, when some people recently reported problems with their usb sti=
cks, I=20
overthought the situation and now I'm also considering that their might=
 be a=20
general linux scsi-bug.

USB-stick-problem:
- Suddenly the problematic systems don't like the sticks any more and r=
eport=20
i/o errors when they are accessing the usb stick. Removing and re-inser=
ting=20
the stick doesn't help, however, rebooting the system fixes this issue.
- Well, that might be an USB problem, but those sticks use the sg-drive=
r and=20
so the scsi-system, could this somehow be related with our raid i/o err=
ors?

Also, trantec told me that the raid array should report an error to its=
 logs=20
when an i/o error happens, but there is no error message at all :(


All those problems happend with 2.4.26, but we now also tried to use 2.=
6.7 and=20
the problem doesn't occur with this kernel. Unfortunality we never reac=
h the=20
resync speed of >45 MB, its usually about 30MB/s. If we reduced the=20
resync-speed in 2.4.26 to those values, we also never had the problem, =
so the=20
test with 2.6.7 doesn't help so much in this case.


So, does someone  here has an idea if this a bug of the transtec array =
or of=20
the linux-scsi system?


Thanks in advance,
	Bernd


--=20
Bernd Schubert
Physikalisch Chemisches Institut / Theoretische Chemie
Universit=E4t Heidelberg
INF 229
69120 Heidelberg
e-mail: bernd.schubert@pci.uni-heidelberg.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
