From: Arie Folger <afolger@ymail.yu.edu>
Subject: Bug in aha152x driver in 2.4.19-rc1
Date: Wed, 26 Jun 2002 21:59:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200206262159.25865.afolger@ymail.yu.edu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Juergen Fischer <fischer@norbit.de>, linux-scsi@vger.kernel.org

Hi,

I found a bug in the aha152x driver in 2.4.19-rc1 as well as in RedHat's stock 
2.4.18-5 kernels. I have a Iomega SCSI pcmcia card for a zip drive, a card 
tht is functioning well up until RedHat's stock rpm distributed 2.4.18-4 
kernel. The card works since 2.2.x kernels. 

However, in both 2.4.18-5 by RedHat updates and in 2.4.19-rc1 which I compiled 
on my system, the card does not work. An excerpt from the syslog is appended 
at the end of this message.

The fact that the problem appears in both the stock kernel and the one I 
compiled myself leads me to believe this may be a bug that has been 
overlooked and not the result of me misconfiguring my kernel.

Feel free to contact me for additional information. This bug is persistent, no 
matter how many times I reboot. Another, less serious issue, is that in the 
past it was possible to remove the card and the kernel would know to free the 
modules and resources, while lately removing the card has caused the machine 
to freeze.

My machine is a Sony Vaio with an AMD K6-550MHz running RH7.3 with all updates 
applied.

When I insert the card the following mesage appears in /var/log/messages:
Jun 26 21:48:08 localhost cardmgr[787]: initializing socket 0
Jun 26 21:48:08 localhost cardmgr[787]: socket 0: Adaptec APA-1460 SlimSCSI
Jun 26 21:48:08 localhost kernel: cs: memory probe 0xa0000000-0xa0ffffff: 
clean.
Jun 26 21:48:08 localhost cardmgr[787]: executing: 'modprobe aha152x_cs'
Jun 26 21:48:08 localhost cardmgr[787]: get dev info on socket 0 failed: No 
such device
Jun 26 21:48:08 localhost kernel: aha152x: processing commandline: ok
Jun 26 21:48:08 localhost kernel: aha152x: BIOS test: passed, detected 1 
controller(s)
Jun 26 21:48:08 localhost kernel: aha152x: resetting bus...
Jun 26 21:48:08 localhost kernel: aha152x0: vital data: rev=1, io=0x340 
(0x340/0x340), irq=3, scsiid=7, reconnect=enabled, parity=enabled, 
synchronous=disabled, delay=100, extended translation=disabled
Jun 26 21:48:08 localhost kernel: aha152x0: trying software interrupt, lost.
Jun 26 21:48:08 localhost kernel: aha152x0: IRQ 3 possibly wrong.  Please 
verify.
Jun 26 21:48:08 localhost kernel: aha152x_cs: no SCSI devices found
Jun 26 21:48:08 localhost kernel: Trying to free nonexistent resource 
<00000340-0000035f>
Jun 26 21:48:12 localhost cardmgr[787]: shutting down socket 0
Jun 26 21:48:12 localhost cardmgr[787]: executing: 'modprobe -r aha152x_cs'

-- 
It is absurd to seek to give an account of the matter to a man 
who cannot himself give an account of anything; for insofar as
he is already like this, such a man is no better than a vegetable.
           -- Book IV of Aristotle's Metaphysics
