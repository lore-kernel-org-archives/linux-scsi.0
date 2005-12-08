From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Ang: Re: [Stgt-devel] Re: stgt a new version
 of iscsi target?
Date: Thu, 08 Dec 2005 21:46:13 +0300
Message-ID: <43987F75.2000301@vlnb.net>
References: <OF6932015B.01CF53D9-ONC12570D0.00462028@capvert.ins> <43972C2D.9060500@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <iscsitarget-devel-admin@lists.sourceforge.net>
In-Reply-To: <43972C2D.9060500@cs.wisc.edu>
Sender: iscsitarget-devel-admin@lists.sourceforge.net
Errors-To: iscsitarget-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:iscsitarget-devel@lists.sourceforge.net>
List-Help: <mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=iscsitarget-devel>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt <stgt-devel@lists.berlios.de>, Robert Whitehead <WRWHITEHEAD@novell.com>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Mike Christie wrote:
> johan@capvert.se wrote:
>> I, and I suppose a lot of other people, would like know how you look=20
>> at the
>> HW support on the Fc side? I don=B4t know what you mean now, when you =
talk
>> about HW target support,=20
>=20
> For qlogic FC, it is the same as scst at this point, except we are base=
d=20
> off the mainline qla2xxx driver.

Actually, this is not completely true and could mislead people. Stgt is=20
*not* the same as scst at this point and, I think will not be for at=20
least considerable amount of time.

They are the same only on a basic subset of functionality, which I would=20
call "fast path", and only for block devices that are could be=20
considered stateless, i.e. on which the result of a SCSI command's=20
execution isn't dependent on the current state of the device. For, eg,=20
tapes this isn't true, because on such devices the current state, like=20
block size, changes the result of the command a lot, so it shall be=20
honored and special handling of Unit Attention conditions shall be done.=20
For example, all UAs from a device shall be delivered to all connected=20
initiators, not only to one of them who happens to execute the command=20
with UA result. Another example is when one initiator changes state of=20
the device. After that all other initiators shall receive appropriate=20
UA, i.e. the mid-layer shall generate it, because for the device all=20
initiators act as one initiator (nexus) and the device is not able to=20
distinguish between them to perform all necessary SCSI handling. Thus,=20
the mid-layer has to do it. Not doing so is dangerous and could lead to=20
data corruption and loss. The same is true for "advanced" commands like=20
RESERVE/RELEASE, which also have to be "emulated" by the mid-layer.=20
Also, currently stgt doesn't care much about task management.

Scst from the very beginning was targeted for SCSI tapes exported via=20
hardware targets and was designed with all that very complicated staff=20
in mind. Most of scst complexity is caused by handling of it as well as=20
by attempt to make that handling at most performance effective way. For=20
example, on the fast path, no task management and UA-related locks are=20
taken, although this is done on the way, which could be considered a bit=20
  unusual or extravagant, but effective.

Thus, to resume, the following important features are missed in stgt=20
comparing to scst:

  - Task management

  - SCSI handling/emulation required for statefull SCSI devices (tapes,=20
etc.)

  - Scst has some performance advantages over stgt, at least, on=20
hardware targets, because it allows internal handling in SIRQ context as=20
well as doesn't need user space program, so it eliminates additional=20
context switches (at least 3 per command for WRITEs and 2 per command=20
for reads plus switches to user space daemon, probably, 2 per command).=20
5 context switches per command looks too much for me, especially=20
considering how little work is done on each context. It means ~15000=20
CS/sec on regular 200Mb/sec link with 64K block size. Additionally,=20
kernel only commands execution allows direct access to page cache, which=20
is GREAT performance improvement, because in architecture with user=20
space daemon the data should be copied several times between kernel and=20
user space. Or, do I miss anything?

  - Access and devices (LUNs) visibility management. It allows for an=20
initiator or group of initiators to have different set of LUs, each with=20
appropriate access permissions. This feature provides HUGE usability,=20
people who tried it will confirm that.

  - Support for most SCSI devices, namely tapes, processors (SCSI type=20
3), CDROM's (SCSI type 5), MO disks (SCSI type 7), medium changers (SCSI=20
type 8) and RAID controllers (SCSI type 0xC)

  - Stability. Current SCST (0.9.3-pre2) is quite stable, as far as I=20
know only task management has some unfixed flaws.

Those are what I've noticed on a brief review. It's possible that I=20
missed something. For example, stgt seems doesn't have internal commands=20
serialization, so I suspect that if some initiator mixes READs and=20
WRITEs on some targets it will be possible that order of the commands=20
execution will be broken, because WRITE command have additional phase ,=20
when the command's data from the initiator is sent to the target. During=20
it subsequent READs could be executed out of order. The result could be=20
data corruption.

 From other side, stgt has not too much advantages over scst.=20
Technically, I, personally, see only few such advantages. One of them is=20
support for putting block commands directly to the device request queue.=20
I'm going to fix this in the next version (I hope nobody will blame me=20
if I borrow this code from stgt :) ). Another one is support for=20
different "protocols", although I have not understood which ones, except=20
SCSI, are going to be there.

Actually, we would greatly appreciate if Mike or Christoph will tell us=20
what is so wrong in scst on their opinion, so they started they own new=20
project. (I'm not considering motivation like "I want to make my own in=20
any case" seriously). Is scst too complicated? Do you think stgt will be=20
simpler with all those features implemented?

Vlad


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
