From: Kevin Fenzi <kevin-linux-kernel@scrye.com>
Subject: Re: 2.4.x end of tape handling error
Date: Mon, 3 Mar 2003 09:49:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030303164942.1505.qmail@scrye.com>
References: <mailman.1044901620.21591.linux-kernel2news@redhat.com>
	<200302101904.h1AJ4US05141@devserv.devel.redhat.com>
	<20030218021039.28335.qmail@scrye.com>
	<20030224235355.30878.qmail@scrye.com>
	<Pine.LNX.4.52.0303022118510.2029@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.52.0303022118510.2029@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

>>>>> "Kai" == Kai Makisara <Kai.Makisara@kolumbus.fi> writes:

Kai> On Mon, 24 Feb 2003, Kevin Fenzi wrote:

>> Some more information on this problem discovered by Tim Jones
>> <tjones@tolisgroup.com>:
>> 
Tim> Additional news.
>>
Tim> This is actually related to the check sense bit not being
Tim> propagated up to the ST driver.  A simpler test (beats writing
Tim> 40GB to a tape ...):
>>
Kai> ...
Tim> This is caused by the check sense not being set and the ST driver
Tim> sending up a EIO instead of the ENOMEDIUM.

>> So, it looks like this problem is _not_ in the st driver itself,
>> but somewhere in the SCSI layer.
>> 
>> Anyone have any ideas how to better track it down?
>> 
>> Happy to run debug code/test cases here.
>> 

Kai> If you enable debugging in the st driver, it prints on the
Kai> console(dmesg)/system log the sense data it gets. (To enable
Kai> debugging, edit the st source to '#define DEBUG 1' and recompile
Kai> the kernel/module).

Yeah, ok. 

Kai> The st driver does in some cases behave too conservatively when
Kai> the EOT early warning is found. This happens when operating in
Kai> fixed block mode and only with some drives. The drives I use for
Kai> testing behave in a different way and that is why I have not seen
Kai> this problem (tracked down with debugging output from one kind
Kai> user). I have a fix ready but testing will still take some
Kai> time. This problem is not seen when asynchronous writes and
Kai> driver buffering are disabled (as suggested in README.st when
Kai> trying to rely on EOT detection).

Humm... I tried to disable async writes and buffering and still got
the problem on my HP DDS2 drive. 

Whats the correct procedure to disable both those?

mt -f /dev/nst0 stoptions buffer-writes 0
mt -f /dev/nst0 stoptions async-writes 0

I can repeat those tests to confirm, but I'm pretty sure I was seeing
the problem even with those options set. 

Would you like debug output from that case?

Kai> 	Kai

kevin

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)
Comment: Processed by Mailcrypt 3.5.8 <http://mailcrypt.sourceforge.net/>

iD8DBQE+Y4em3imCezTjY0ERAsPOAJ4lSsrUfiDHPbdNQ+NcQxEy4w17sACdEkM8
EclBD42iXwpqsbiAJkeelEo=
=Uh2S
-----END PGP SIGNATURE-----
