From: "Fajun Chen" <fajunchen@gmail.com>
Subject: Any known issues to cause data miscompares on sg read/write on 2.6.15.4 and 2.6.18-rc2?
Date: Sun, 20 Aug 2006 03:30:56 -0600
Message-ID: <8202f4270608200230s34aa9505s2426f3f3b90fa7ec@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Cc: dougg@torque.net, jgarzik@pobox.com, htejun@gmail.com, alan@lxorguk.ukuu.org.uk, akpm@osdl.org, rmk@arm.linux.org.uk
List-Id: linux-scsi@vger.kernel.org

Hi Folks,

I use ATA pass through via sg ioctl interface for data read/write. Two
kernels were tested:
Linux 2.6.15.4 with Jeff Garzik's libata patch (pata support)
Linux 2.6.18-rc2 with Jeff Garzik's git libata patch (new EH, hotplug,
pata support)
Hardware: ARM IOP80321 with PCI-X
Host adapters: sata Sil3124 and pata Sil680
Test algorithm: random write-read-compare (same range)

I've tried sg mmap, direct and indirect IO on both 2.6.18-rc2 and
2.6.15.4 release, none of the combinations survived data compare
overnight test.  I also tried to change cache policy to write through
on 2.6.15.4,  no luck either.  Several different symptoms were
observed among the failures:
1. A few bytes in a data pattern were not written correctly to the
disc (low data miscompare rate)
2. Pretty much none of the data were written correctly to the disc
(high data miscompare rate)
3. Data were written to the disc correctly but miscompares when read
it back. What's weird is that when the read buffer was printed out
right after data miscompare , it contains the correct data!
Sg write failures (symptom #1 and #2) are more typical than read
failure (symptom #3).  This problem has been observed on many
different test machines with both pata and sata drives.

I don't know of a good way to trace and isolate the problem yet. Since
data miscompare issue can be caused by issues from different
subsystems, I cc'ed some subsystem maintainers here.  Any information
or suggestions are greatly appreciated.

Thanks,
Fajun
