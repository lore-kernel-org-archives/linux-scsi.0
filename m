From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: /proc/scsi/aic7xxx/? considered harmful (2.4.19-pre9)
Date: Thu, 6 Jun 2002 09:58:24 +1000 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <15614.42400.697670.602385@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: From notabene ([129.94.211.194] == dulcimer.orchestra.cse.unsw.EDU.AU)
	(for <linux-scsi@vger.kernel.org>)
	(for <linux-kernel@vger.kernel.org>) (for <c-staff@cse.unsw.edu.au>)
	By tone With Smtp ; Thu, 6 Jun 2002 09:58:24 +1000
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Hi,
 I have 3 NFS servers with ext3 on raid5 on scsi with assorted
aic7xxx scsi controllers, all running 2.4.19-pre9 (plus some ext3 and
raid and nfs patches) using the "new" aic7xxx drivers.

While trying to diagnose some problems I ran a little script which
extracts the "Commands Queued" value for each drive and prints out
differences every second, so I can watch traffic.

One our newer machine, which reports
Jun  3 17:33:21 eno kernel: scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.6
Jun  3 17:33:21 eno kernel:         <Adaptec aic7899 Ultra160 SCSI adapter>
Jun  3 17:33:21 eno kernel:         aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs
Jun  3 17:33:21 eno kernel: 
Jun  3 17:33:21 eno kernel: scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.6
Jun  3 17:33:21 eno kernel:         <Adaptec aic7899 Ultra160 SCSI adapter>
Jun  3 17:33:21 eno kernel:         aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
Jun  3 17:33:21 eno kernel: 
Jun  3 17:33:21 eno kernel: scsi2 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.6
Jun  3 17:33:21 eno kernel:         <Adaptec 29160B Ultra160 SCSI adapter>
Jun  3 17:33:21 eno kernel:         aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

This works fine.

On an older machine, which reports

Jan  1 11:01:39 cage kernel: scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.6
Jan  1 11:01:39 cage kernel:         <Adaptec 3950B Ultra2 SCSI adapter>
Jan  1 11:01:39 cage kernel:         aic7896/97: Ultra2 Wide Channel A, SCSI Id=7, 32/253 SCBs
Jan  1 11:01:39 cage kernel: 
Jan  1 11:01:39 cage kernel: scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.6
Jan  1 11:01:39 cage kernel:         <Adaptec 3950B Ultra2 SCSI adapter>
Jan  1 11:01:39 cage kernel:         aic7896/97: Ultra2 Wide Channel B, SCSI Id=7, 32/253 SCBs
Jan  1 11:01:39 cage kernel: 


I get lots of errors:
Jun  6 09:38:01 cage kernel: scsi1: Signaled a Target Abort
Jun  6 09:38:02 cage kernel: scsi0: PCI error Interrupt at seqaddr = 0x8
Jun  6 09:38:02 cage kernel: scsi0: Signaled a Target Abort
Jun  6 09:38:02 cage kernel: scsi0: PCI error Interrupt at seqaddr = 0x9
Jun  6 09:38:02 cage kernel: scsi0: Signaled a Target Abort
Jun  6 09:38:02 cage kernel: scsi0: PCI error Interrupt at seqaddr = 0x9
Jun  6 09:38:02 cage kernel: scsi0: Signaled a Target Abort
Jun  6 09:38:02 cage kernel: scsi0: PCI error Interrupt at seqaddr = 0x8
Jun  6 09:38:02 cage kernel: scsi0: Signaled a Target Abort
Jun  6 09:38:02 cage kernel: scsi1: PCI error Interrupt at seqaddr = 0x8
Jun  6 09:38:02 cage kernel: scsi1: Signaled a Target Abort
Jun  6 09:38:02 cage kernel: scsi1: PCI error Interrupt at seqaddr = 0x9

but it seems to keep working..


On the last machine, which is similar to the second but only has one
even-older scsi card:

Jan  1 11:10:35 glass kernel: scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.6
Jan  1 11:10:35 glass kernel:         <Adaptec 2940 Ultra2 SCSI adapter>
Jan  1 11:10:35 glass kernel:         aic7890/91: Ultra2 Wide Channel A, SCSI Id=7, 32/253 SCBs
Jan  1 11:10:35 glass kernel: 

I get the above errors for about 10 seconds, and then the machine
freezes solid.


I guess I will re-write my script to use /proc/partitions to monitor
disc traffic.

NeilBrown
