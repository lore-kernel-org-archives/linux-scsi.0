From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] instrument ide-scsi in 2.5.68
Date: Wed, 07 May 2003 23:21:43 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EB90867.6050803@torque.net>
References: <3EB11AD3.2070503@torque.net>	<3EB22F09.7060906@torque.net>	<20030502095536.76dba4dd.rddunlap@osdl.org>	<3EB385F3.6010708@torque.net>	<20030505095715.6d96e703.rddunlap@osdl.org>	<3EB7748F.2030702@torque.net> <20030506073923.210a82ff.rddunlap@osdl.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080008050609050708030107"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:62478 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S263169AbTEGNGi
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2003 09:06:38 -0400
In-Reply-To: <20030506073923.210a82ff.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: linux-scsi@vger.kernel.org, alan@lxorguk.ukuu.org.uk

This is a multi-part message in MIME format.
--------------080008050609050708030107
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Randy.Dunlap wrote:
> On Tue, 06 May 2003 18:38:39 +1000 Douglas Gilbert <dougg@torque.net> wrote:
> 
> | > New kernel log file is now at
> | >   http://www.xenotime.net/linux/capture2.txt
> | > 
> | > Are there any docs on SCSI logging?
> | 
> | Randy,
> | The failure looks very similar. This time it timed
> | out and corrupted on a Mode Sense (10) for page 5
> | (alloc length=2) while last time its failed on a
> | Mode Sense (10) for page 0x2a (alloc length=2).
> | The Mode Sense is not translated (i.e. the app sent a
> | 10 byte Mode Sense). Perhaps there is a weakness
> | when the allocation length is that short.
> | 
> | This time 141 commands where sent (last time 91)
> | with lots of Test Unit Readys. Without timestamps
> | it is hard to say whether a "magicdev" type program
> | is at work or libscg (cdrecord transport layer) is
> | solely responsible for that sequence of SCSI commands.
> | [cdrecord may be accessing the cdwriter via the cdrom
> | driver and the sg driver.]
> 
> Well, I saw no scsi logging messages except when I ran
> cdrecord.  Does that help any?

Randy,
Now I have a generic atapi cdwriter. With it cdrecord (version
in RH9) burnt several small dummy iso images. Some with pio
(the default) and others with DMA (after 'hdparm -d 1 /dev/hdb').
Everything worked, here is a link to a tarball of the
cdrecord output and the log from "ide-scsi debug=2":
     http://www.torque.net/sg/p/ide_scsi_capture.tgz

The initial sequence from cdrecord looks close to
your previous two captures. So maybe cdrecord was
producing those sequences.

> | Here is the point of failure from Randy's log:
> | 
> | ide-scsi: hdd: que 141, cmd = [ 5a 0 5 0 0 0 0 0 2 0 ]
> | hdd: lost interrupt
> | ide-scsi: Reached idescsi_pc_intr interrupt handler
> | ide-scsi: hdd: DMA complete
> | ide-scsi: CoD != 0 in idescsi_pc_intr
> | hdd: DMA disabled
> | Error handler scsi_eh_2 waking up
> | scsi_eh_<pr4>t_hfdadi: lA_TstAaPIts r: e2se:t0: 0co:m0 plcmetdse
> | failiedde:- sc0s,i :c anRecaeclh: ed1
> | idTeosctsali_ pofc_ 1in ctro mminantdersr oupnt 1  hdanedvliceres
> |   rePaqcuikrete  ceho mmwoanrdk
> | ....
> | 
> | Ouch, after the error handler starts the dump looks like it
> | is in Klingon :-) Lots of data but no information. It could
> | be a result of the corruption or another problem.
> 
> I think (but I'm not sure) that this is because it's a dual-proc
> system and both procs are garbling the message log.  Later on during
> a panic(), all procs except the current one are disabled, but for
> early messages, all procs can lead to this.  I've seen this on 2
> other occasions (non-scsi).

Do your failures only occur in an SMP environment?


Attached is a patch for ide-scsi.c against lk 2.5.69
   - fixes multiple answering problem I reported
     yesterday (and should quieten ide-scsi when
     CONFIG_SCSI_MULTI_LUN is set)
   - sets the DMA direction for all data transfers in
     idescsi_set_direction() [not just read + write]
   - more debug message cleanups
   - changes reported earlier in this thread

So bugs are being fixed and the driver cleaned up but
still no insight into Randy's problem.


Now for the strange observation of the day:
# modprobe ide-scsi
# lsscsi
[0:0:1:0]    disk    FUJITSU  MAM3184MP        0106  /dev/sda
[2:0:0:0]    cd      ATAPI    CD-RW 48X16      A.RZ  /dev/sr0
[3:0:0:0]    cd      CREATIVE CD5233E          1.00  /dev/sr1
# rmmod ide-scsi
# modprobe ide-scsi
# lsscsi
[0:0:1:0]    disk    FUJITSU  MAM3184MP        0106  /dev/sda
[2:0:0:0]    cd      CREATIVE CD5233E          1.00  /dev/sr0
[3:0:0:0]    cd      ATAPI    CD-RW 48X16      A.RZ  /dev/sr1
# rmmod ide-scsi
# modprobe ide-scsi
# lsscsi
[0:0:1:0]    disk    FUJITSU  MAM3184MP        0106  /dev/sda
[2:0:0:0]    cd      ATAPI    CD-RW 48X16      A.RZ  /dev/sr0
[3:0:0:0]    cd      CREATIVE CD5233E          1.00  /dev/sr1

and the pattern continues with the two atapi devices changing
positions. So much for device naming stability.

Doug Gilbert




--------------080008050609050708030107
Content-Type: application/x-gzip;
 name="ide-scsi_2569dpg1.diff.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="ide-scsi_2569dpg1.diff.gz"

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
9z/SjTMcs4IAAA==
--------------080008050609050708030107--

