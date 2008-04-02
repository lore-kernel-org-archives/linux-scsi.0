From: "Sanjay Gandotra" <sanjay.gandotra@exar.com>
Subject: Help On Adaptec SAS Controller AD-483000
Date: Wed, 2 Apr 2008 16:32:35 -0700
Message-ID: <90500F9127D5CC40BE9D712D8ACCB4860864F5@fre1exch00.hq.exar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.exar.com ([204.154.183.12]:47996 "EHLO smtp2.exar.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756966AbYDBXbv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Apr 2008 19:31:51 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,
=A0
Ok, the issue I have is the following:
=A0
I have connected a SATA Port Multiplier to AD-483000. And I have two sa=
ta drives connected to the Sata port multiplier (one at port 0 and seco=
nd at port 1)
My Linux Kernel is 2.6.24.3. I am using the drivers in the kernel.. aic=
94xx and libsas
=A0
The drive at port 0 of the sata port multiplier is detected nicely. The=
 problem is that the second drive on the port multiplier is not detecte=
d.=20
After investigations.. I figured out that no one is trying to do sata p=
ort multiplier initialisation and detection. After reading the sata spe=
c etc., I tried to modify libsas so that before detecting any sata devi=
ce, it would send out FIS (soft reset ) to sata port 15 with SRST bit s=
et to 1 followed by another FIS to sata port 15 with SRST bit set to 0.
=A0
The first FIS goes out. I can see it on a SATA analyzer. The second=A0 =
=46IS never goes out...=20
Adaptec's driver.. is giving errors for the first FIS.
"
Apr 2 12:32:48 linux-storage kernel: sas: task aborted, flags:0x15
Apr 2 12:32:48 linux-storage kernel: aic94xx: tmf tasklet complete
Apr 2 12:32:48 linux-storage kernel: aic94xx: tmf came back
Apr 2 12:32:48 linux-storage kernel: aic94xx: task 0xf5d83a80 aborted, =
res: 0x4
Apr 2 12:32:48 linux-storage kernel: sas: came back from abort task
Apr 2 12:32:58 linux-storage kernel: sas: task aborted, flags:0x15
Apr 2 12:32:58 linux-storage kernel: aic94xx: task 0xf5d83a80 done with=
 opcode 0x1e resp 0x0 stat 0x8d but aborted by upper layer!
Apr 2 12:32:58 linux-storage kernel: aic94xx: tmf tasklet complete
Apr 2 12:32:58 linux-storage kernel: aic94xx: tmf came back
Apr 2 12:32:58 linux-storage kernel: aic94xx: asd_abort_task: task 0xf5=
d83a80 done
Apr 2 12:32:58 linux-storage kernel: aic94xx: task 0xf5d83a80 aborted, =
res: 0x0
Apr 2 12:32:58 linux-storage kernel: sas: came back from abort task
Apr 2 12:32:58 linux-storage kernel: sas: task finished with resp:0x0, =
stat:0x8d
Apr 2 12:33:08 linux-storage kernel: sas: task aborted, flags:0x15
Apr 2 12:33:08 linux-storage kernel: aic94xx: task 0xf5d83a80 done with=
 opcode 0x1e resp 0x0 stat 0x8d but aborted by upper layer!
Apr 2 12:33:08 linux-storage kernel: aic94xx: tmf tasklet complete
Apr 2 12:33:08 linux-storage kernel: aic94xx: tmf came back
Apr 2 12:33:08 linux-storage kernel: aic94xx: asd_abort_task: task 0xf5=
d83a80 done
Apr 2 12:33:08 linux-storage kernel: aic94xx: task 0xf5d83a80 aborted, =
res: 0x0
Apr 2 12:33:08 linux-storage kernel: sas: came back from abort task
Apr 2 12:33:08 linux-storage kernel: sas: task finished with resp:0x0, =
stat:0x8d
Apr 2 12:33:08 linux-storage kernel: sas: DONE DISCOVERY on port 0, pid=
:10707, result:-250"
=A0
=A0
I will appreciate if anyone could help me in any way by giving some sug=
gestion(s)/direction(s)
=A0
Best Regards,
Sanjay
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
